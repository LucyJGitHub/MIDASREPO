     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SF Validate action code for user/program')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  ZBACTU - Standard program to validate action code versus user*
      *           in a single branch environment                      *
      *                                                               *
      *  Function: This program checks, for a user, if the action code*
      *            entered is valid for a menu group/menu item. It's  *
      *            called in batch mode only.                         *
      *            A parameter is passed back to the calling program  *
      *            to indicate validity :                             *
      *            0 - all valid                                      *
      *            1 - the user is not authorised to this action code *
      *                for this menu item.                            *
      *                                                               *
      *  Where Used: Input Cycle, single branch environment           *
      *                                                               *
      *  Called By: Any program requiring this validation             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *  Any changes made to this program may also need to be         *
      *  incorporated in ZVACTU.                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      *  Prev Amend No. AR867641           Date 20Nov11               *
      *                 CBF005  *REWRITE   Date 04Jul11               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG2287            Date 28Apr04               *
      *                 CSF002             Date 11Aug03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CLE004 *CREATE     Date 27May97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *         - Remove checking and processing for CSC011 (24x7)    *
      *  AR867641 - BFMidas Drop2 build compilation issues            *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile (REWRITE)                                   *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  BUG2287 - Show consolidated global view  (Recompile)         *
      *  CSF002 - Global layer.                                       *
      *           - Replace previous ZMITEM layout with the new       *
      *             unique code.                                      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CLE004 - Syndications & Authorisations                       *
      *                                                               *
      ********************************************************************
      *
      * ID F  C  H  L     FUNCTION OF INDICATORS
      *
      *       99       NO RECORD FOUND FOR USER
      *
      *****************************************************************
      *       INPUTS TO THIS PROGRAM
      *
      *       ACTION CODE 1A  (FROM THE CALLING PROGRAM)
      *       USER ID    10A  (FROM THE CALLING PROGRAM)
      *
      *****************************************************************
      *       OUTPUT FROM THIS PROGRAM
      *
      *  Error Code :  0 = NO ERROR
      *                1 = THIS ACTION CODE NOT VALID FOR USER/MENU ITEM
      *
      *****************************************************************
     FSFMENUL0  IF   E           K DISK
     FGPMENUL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(SFMENUD0:GPMENUD0)
      *
     D LDA             DS           256
      *
      **     Local data area.
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
     D R_Count         S              4  0
 
     D*SDSTAT***     E DS           256    EXTNAME(SDSTAT)                                    CCB020
      ***Standing*Data*Data*Structure**********************************                       CCB020
      *****************************************************************                       CCB020
     D*SC24X7***     E DS           256    EXTNAME(SC24X7)                                    CCB020
      ***24*x*7*Status*Data*Structure**********************************                       CCB020
      *
      * DATA STRUCTURES FOR USE WITH ACCESS OBJECTS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data Structure for SAR Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     ISFMENUD0
     I              MIAAC10                     MIAA10
      *
     IGPMENUD0
     I              MIAAC10                     MIAA10
      *
     C     *ENTRY        PLIST
     C                   PARM                    ZACTN             1
     C                   PARM                    USRID            10
     C                   PARM                    UNQCDE           10
     C                   PARM                    ERR               1 0
      *
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   OPEN      GPMENUL0
     C                   ENDIF
      *
      *    ACCESS SDBANK FOR SINGLE BRANCH
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   MOVE      BJSBRC        ZBR               3
      *
     C                   EXSR      ChkAuth
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C*****ERR           IFEQ      0                                                          CCB020
      *****************************************************************                       CCB020
      ***Determine*if*CSC011*is*installed******************************                       CCB020
      *****************************************************************                       CCB020
     C**********         CALL      'AOSARDR0'                                                 CCB020
     C**********         PARM      *BLANKS       @RTCD             7                          CCB020
     C**********         PARM      '*VERIFY '    @OPTN             7                          CCB020
     C**********         PARM      'CSC011'      @SARD             6                          CCB020
     C*****SCSARD        PARM      SCSARD        DSFDY                                        CCB020
      *****************************************************************                       CCB020
     C*****@RTCD         IFNE      *BLANKS                                                    CCB020
     C*****@RTCD         ANDNE     '*NRF   '                                                  CCB020
     C******LOCK         IN        LDA                                                        CCB020
     C**********         MOVEL     'SCSARDPD'    DBFILE                                       CCB020
     C**********         Z-ADD     01            DBASE                                        CCB020
     C**********         MOVEL     'CSC011'      DBKEY                                        CCB020
     C**********         MOVEL     'ZBACTU'      DBPGM                                        CCB020
     C**********         OUT       LDA                                                        CCB020
     C**********         EXSR      *PSSR                                                      CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C*****@RTCD         IFEQ      *BLANKS                                                    CCB020
      *****************************************************************                       CCB020
      ***Access*SDSTAT*to*get*the*current*system*prefix****************                       CCB020
      *****************************************************************                       CCB020
     C******DTAARA       DEFINE                  SDSTAT                                       CCB020
     C**********         IN        SDSTAT                                                     CCB020
      *****************************************************************                       CCB020
      ***Access*SC24X7*to*get*the*support*system*prefix*and************                       CCB020
      ***maintenance*code**********************************************                       CCB020
      *****************************************************************                       CCB020
     C******DTAARA       DEFINE                  SC24X7                                       CCB020
     C**********         IN        SC24X7                                                     CCB020
      *****************************************************************                       CCB020
     C*****LIBR          IFEQ      S1SUPP                                                     CCB020
      *****************************************************************                       CCB020
     C*****CSD031        IFEQ      'Y'                                                        CCB020
     C******INU1         ANDEQ     *ON                                                        CCB020
     C*****UNQCDE        CHAIN     GPMENUL0                           20                      CCB020
     C**********         ELSE                                                                 CCB020
     C*****UNQCDE        CHAIN     SFMENUL0                           20                      CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C******IN20         IFEQ      *ON                                                        CCB020
     C*****MIACOB        OREQ      'N'                                                        CCB020
     C*****MIACOB        OREQ      *BLANK                                                     CCB020
     C*****ZACTN         ORNE      'E'                                                        CCB020
     C*****S1MANT        ANDEQ     'E'                                                        CCB020
     C*****ZACTN         ORNE      'E'                                                        CCB020
     C*****MIACOB        ANDEQ     'E'                                                        CCB020
     C**********         Z-ADD     1             ERR                                          CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C**********         ENDIF                                                                CCB020
      *****************************************************************                       CCB020
     C**********         ENDIF                                                                CCB020
      *
     C     CSD031        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   CLOSE     GPMENUL0
     C                   ENDIF
      *
     C                   RETURN
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
     C**********WHERE PMINDX = :UNQCDE AND PMACTC = :ZACTN                                  AR867641
     C**********   AND ENENTV = :ZBR   AND ENUSER = :USRID                                  AR867641
     C+         WHERE INDX = :UNQCDE AND ACA = :ZACTN                                       AR867641
     C+            AND BRCB = :ZBR   AND USRP = :USRID                                      AR867641
     C/END-EXEC
 
     C                   IF        R_COUNT > 0
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
