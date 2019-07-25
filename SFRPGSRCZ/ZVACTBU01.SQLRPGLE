     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SF Validate User/Act to atleast one branch')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  ZVACTBU01 - Program to Validate User/Action to atleast one   *
      *              Branch Code                                      *
      *                                                               *
      *  Function: This program checks, for a user, if the Action     *
      *            Code is authorised to a menu group/item for at     *
      *            least one branch.                                  *
      *                                                               *
      *            A parameter is passed back to the calling program  *
      *            to indicate validity :                             *
      *            0 - all valid                                      *
      *            1 - no actions are authorised for this user/menu   *
      *                item combination (for at least one branch)     *
      *            2 - user is not authorised to this action code for *
      *                this menu item/branch.                         *
      *                                                               *
      *  Called By: SDCUSTRTV                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD022997           Date 23Oct13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD022997 - Customer being filtered was not displayed on the  *
      *             main list view of CUSD maintenance                *
      *                                                               *
      *****************************************************************
      *       INPUTS TO THIS PROGRAMME
      *
      *       ACTION CODE 1A  (FROM THE CALLING PROGRAM)
      *       DTAARA/ZMITEM   MENU ITEM REQUESTED
      *       USRID from PSDS
      *
      *****************************************************************
      *       OUTPUT FROM THIS PROGRAMME
      *
      * ERROR CODE : 0 = NO ERROR
      *              1 = NO RECORD FOUND FOR USER/MENU ITEM/BRANCH
      *              2 = ACTION CODE NOT VALID FOR USER/MENU ITEM/BRANCH
      *
      *****************************************************************
      *
     FSFMENUL0  IF   E           K DISK
     FGPMENUL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(SFMENUD0:GPMENUD0)
      *
      ** EXTERNAL DATA AREA OF MENU ITEM REQUESTED
     D ZMITEM          DS
     D  UNQCDE                 1     10
      *
      ** External data area for user name
     D ZMUSER          DS            17
     D  ZMUSR                  1     10

     D PSDS           SDS
     D  USRID                254    263

     D/COPY WNCPYSRC,ZVACTBUI01

     D R_Count         S              4  0
     D SQL_Err         S              1A
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D I#FULLCHECK     S              1A
     D O#ZONE          S             10A
     D O#SHTC          S              4A
     D O#RDNB          S              5S 0
     D O#DNWD          S              5S 0
     D O#BCCY          S              3A
     D O#NJOB          S              1S 0

      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data Structure for SAR Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
     I*
     ISFMENUD0
     I              MIAAC10                     MIAA10
      *
     IGPMENUD0
     I              MIAAC10                     MIAA10

      *
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   OPEN      GPMENUL0
     C                   ENDIF
      *
     C     *DTAARA       DEFINE                  ZMITEM
     C                   IN        ZMITEM
     C                   UNLOCK    ZMITEM
      *
      ** If ZMUSER exists, use the name from that, otherwise use the PSDS
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER                               99
     C     *IN99         IFEQ      '0'
     C                   UNLOCK    ZMUSER
     C                   ENDIF
      *
     C     ZMUSR         IFNE      *BLANKS
     C                   MOVEL     ZMUSR         USRID
     C                   ENDIF

     C                   EXSR      GetZone
     C                   EXSR      ChkAuth

     C/COPY WNCPYSRC,ZVACTBUC01
     C/COPY WNCPYSRC,ZVACTBUC02
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   CLOSE     GPMENUL0
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetZone - Get zone details from UDF extension table update   *
      *                                                               *
      *****************************************************************
     C     GetZone       BEGSR
      *
     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       I#RTCD
     C                   PARM      *BLANKS       I#ERMS
      ** INPUTS
     C                   PARM      'N'           I#FULLCHECK
      ** OUTPUTS
     C                   PARM                    O#ZONE
     C                   PARM                    O#SHTC
     C                   PARM                    O#RDNB
     C                   PARM                    O#DNWD
     C                   PARM                    O#BCCY
     C                   PARM                    O#NJOB

      ** Check for error in access object

     C                   IF        I#RTCD <> *BLANKS
     C                   MOVEL     'ZVACTBU01'   DBPGM
     C                   MOVEL     'GPZONEPD'    DBFILE
     C                   MOVEL     '100'         DBASE
     C                   MOVEL     *BLANKS       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C     GetZnEnd      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkAuth - Check user authority                               *
      *                                                               *
      *****************************************************************
     C     ChkAuth       BEGSR
      *
     C                   EVAL      ERR = 1

     C/EXEC SQL WHENEVER SQLERROR GOTO CheckEnd
     C/END-EXEC

     C/EXEC SQL WHENEVER NOT FOUND GOTO CheckEnd
     C/END-EXEC

     C/EXEC SQL
     C+  SELECT Count(*) into :R_Count from MIVW_PerMM
     C+         WHERE INDX = :UNQCDE AND ACA = :ZACTN
     C+            AND USRP = :USRID AND ZONE = :O#ZONE
     C/END-EXEC

      ** IF NO RECORD FOR THE ACTION, CHECK IF USER IS AUTHORISE TO OTHER ACTION
     C                   IF        R_Count < 1

     C/EXEC SQL
     C+  SELECT Count(*) into :R_Count from MIVW_PerMM
     C+         WHERE INDX = :UNQCDE AND USRP = :USRID
     C+            AND ZONE = :O#ZONE
     C/END-EXEC

     C                   IF        R_COUNT > 0
     C                   EVAL      ERR = 2
     C                   ENDIF

     C                   ELSE
     C                   EVAL      ERR = 0
     C                   ENDIF

     C     CheckEnd      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      ** Check if CSD031 is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD031'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   MOVE      'N'           CSD031            1
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD031
     C                   ELSE
      *
     C     PRTCD         IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     'CSD031'      DBKEY
     C                   Z-ADD     101           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
