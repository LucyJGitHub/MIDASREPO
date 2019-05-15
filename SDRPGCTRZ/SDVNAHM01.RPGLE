     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Non-a/c Holder')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVNAHM01 - Midas SD Validate Non-account Holder             *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24029           Date 20May09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233207             Date 25Apr05               *
      *                 232543             Date 01Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  233207 - Non-account Holders Selection Processing            *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Joint A/c Member Details by Joint A/c No./Non-a/c Holder
     FSDJACCL3  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation X Error Array Declarations
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Non-account Holder Details Data Structure
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** Long Access Object Data Structure                                                  BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PDJANO          S              6A
     D PDNAHO          S             10A
     D OKNAHO          S              1A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PNAHo           S             10A
 
      ** Key Fields
     D KJANo           S                   LIKE(JCJANO)
     D KNAHo           S                   LIKE(JCNAHO)
 
      ** Working Variables
     D Ix              S              3P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise relevant variables
 
     C                   EVAL      PRetCode  = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Ix = *ZERO
 
      ** Validate Non-account Holder
 
     C                   IF        PDNAHO <> *BLANKS
 
     C                   EXSR      SRVNAHo
 
     C                   IF        OKNAHO <> 'Y'
     C                   EVAL      PRetCode  = '*ERROR'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNAHo - Validates the Non-account Holder                   *
      *                                                               *
      *****************************************************************
     C     SRVNAHo       BEGSR
 
      ** Check first if the given Non-a/c Holder exists
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      PDNAHO        PNAHo
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
     C                   IF        PRtCd = *BLANKS AND                                        233207
     C                             %SCAN('?':PDNAHO) <> *ZERO                                 233207
     C                   EVAL      PDNAHO = NHNAHO                                            233207
     C                   ENDIF                                                                233207
                                                                                              233207
     C                   IF        PRtCd <> *BLANKS
 
     C                   IF        PRtCd = '*NRF   '
 
      ** Invalid Non-account Holder
 
     C                   EVAL      OKNAHO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDNAHO'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0116'
 
     C                   ELSE
 
     C                   IF        PRtCd = '*NOSEL '                                          233207
     C                   EVAL      PDNAHO = *BLANKS                                           233207
     C                   ELSE                                                                 233207
                                                                                              233207
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDNAHOPD'
     C                   EVAL      DBKey = PNAHo
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
                                                                                              233207
     C                   ENDIF                                                                233207
 
     C                   ENDIF
 
     C                   LEAVESR
 
     C                   ENDIF
 
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
 
      ** Input Parameters **
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Joint Account Number
     C                   PARM                    PDJANO
 
      ** Non-account Holder
     C                   PARM                    PDNAHO
 
      ** Output Parameters **
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** OK - Non-account Holder
     C                   PARM                    OKNAHO
 
      **---------------------------------------------------------------
      ** Program, module, and procedure names for DB error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
      ** Key Lists
 
     C     KJACC         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KNAHo
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   CALLB     'DBERRCTL'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
