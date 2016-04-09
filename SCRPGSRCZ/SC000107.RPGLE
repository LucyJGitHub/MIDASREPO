     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Disable Authorization Limits')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000107 - Disable Authorization Limits                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG8384 *CREATE    Date 05Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG8384 - Authorization limits at OME system should be off.  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *  LR - Program End                                             *
      *  U7 - Error                                                   *
      *  U8 - Error                                                   *
      *  90 - File Read                                               *
      *  91 - File Chain                                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR - Initialization                                      *
      *  *PSSR  - Program Exception Error                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Midas Authorization Limits Check Status
     FV_ALLIMAPIIF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(V_ALLIMAPI:ALLIMAPI)
 
      ** Authorization Limits System Maintenance
     FT_ALSYSPD UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_ALSYSPD:ALSYSPD)
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D SysName         C                   CONST('ZoneSystemName')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PRetCode        S              7A
     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A
 
     D ZoneName        S             10A
     D WRun            S              1A
 
      ** Define key to access to extended details
     D K@Zone          S                   LIKE(ASZONE)
     D K@Api           S                   LIKE(ASAPI)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Start of Processing
 
      ** Read Authorization Limits Check Status File
     C                   READ      ALLIMAPI                               90
     C                   DOW       *IN90 = *OFF
 
      ** Check if ZONE is the zone being system setup and
      ** CHECKED is 'Y'
     C                   IF        ZONE = ZoneName
     C                             And CHECKED = 'Y'
 
      ** Check the zone being system setup and api in
      ** Authorization Limits System Maintenance File
     C                   EVAL      K@Zone = ZoneName
     C                   EVAL      K@Api = APINAME
     C     K@KEY1        CHAIN     ALSYSPD                            91
     C                   IF        *IN91 = *OFF
      ** If record found, update ASCHECKED to 'N'
     C                   EVAL      ASCHECKED = 'N'
     C                   UPDATE    ALSYSPD
     C                   ELSE
      ** Otherwise, write record with ASCHECKED initialized to 'N'
     C                   EVAL      ASZONE = ZoneName
     C                   EVAL      ASAPI = APINAME
     C                   EVAL      ASCHECKED = 'N'
     C                   WRITE     ALSYSPD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      ALLIMAPI                               90
     C                   ENDDO
 
      ** End of Program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameter
     C     *ENTRY        PLIST
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Key Fields
     C     K@KEY1        KLIST
     C                   KFLD                    K@Zone
     C                   KFLD                    K@Api
 
      ** Access System values
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      SysName       P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      *BLANKS       P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM      *BLANKS       P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      *BLANKS       P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      *BLANKS       P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM      *BLANKS       P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM      *BLANKS       P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10
 
     C                   IF        PRetCode  <> *BLANKS
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBKey = '*KEY   '
     C                   EVAL      DBase = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve zone being system setup
     C                   EVAL      ZoneName = P@VL01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2005
