     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Retrieve')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMBRW - Midas SD Joint Account Member Details Retrieve   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL035             Date 01Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD1)
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.
 
     FSDJACCL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD3)
      ** Midas SD Joint A/c Member Details by Joint A/c No./Non-a/c Holder
 
     FSDJACCLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCDA)
      ** Midas SD Joint A/c Member Details by Front Office Transaction ID
 
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
      ** API Validation Error Array Declarations
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Joint A/c Member Details - File Format
     D JAcMFilFmt    E DS                  EXTNAME(SDJACCPD)
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** ZMUSER Data Area Layout
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D POprMode        S              6A
     D PResMode        S              1A
     D PDACTN          S              1A
     D PDFRNT          S             20A
     D PDJANO          S              6A
     D PDCUST          S              6A
     D PDNAHO          S             10A
     D PDACTD          S              1A
     D OKACTN          S              1A
     D OKCUST          S              1A
     D OKNAHO          S              1A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** Standard Utility Parameters
     D PZActn          S              1A
     D PZBrch          S              3A
     D PZErr           S              1P 0
 
      ** Key Fields
     D KFrnt           S                   LIKE(JCFRNT)
     D KJANo           S                   LIKE(JCJANO)
     D KCust           S                   LIKE(JCCUST)
     D KNAHo           S                   LIKE(JCNAHO)
 
      ** Working Variables
     D Ix              S              3P 0
     D WOKActn         S              1A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Validate Front Office Transaction Interface.
 
     C                   IF        POprMode = '*FRONT'
 
     C                   EXSR      SRVFrnt
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Action Code.
 
     C                   EXSR      SRVActn
 
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
 
      ** Access security checking.
 
     C                   IF        PResMode = 'S'
 
      ** Single branching.
 
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRAcSeS
     C                   ELSE
 
      ** Multi-branching.
 
     C                   IF        PDACTN <> 'I'
     C                   EXSR      SRAcSeM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Action Code 'I'.
 
     C                   IF        PDACTN = 'I'
     C                   EXSR      SRVActI
     C                   ENDIF
 
      ** Validate Action Code 'A'.
 
     C                   IF        PDACTN = 'A'
     C                   EXSR      SRRtvJAcM
     C                   ENDIF
 
      ** Validate Action Code 'D'.
 
     C                   IF        PDACTN = 'D'
     C                   EXSR      SRRtvJAcM
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFrnt - Validates the Front Office Transaction Interface.  *
      *                                                               *
      *****************************************************************
     C     SRVFrnt       BEGSR
 
     C                   IF        PDACTN <> 'I' AND
     C                             PDACTN <> 'A' AND
     C                             PDACTN <> 'E' AND
     C                             PDACTN <> 'D'
 
      ** Action Code must be 'I', 'A', 'E', or 'D'.
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0104'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        PDFRNT = *BLANKS
 
      ** Front Office Transaction ID can't be blank.
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0107'
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      KFrnt = PDFRNT
     C     KFrnt         CHAIN     SDJACCLA
 
     C                   IF        %FOUND
 
     C                   IF        PDACTN = 'I'
 
      ** Front Office Transaction ID already exists.
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0108'
     C                   EVAL      MsgDtaArr(Ix) = PDFRNT
     C                   LEAVESR
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PDACTN <> 'I'
 
      ** Front Office Transaction ID not found.
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0109'
     C                   EVAL      MsgDtaArr(Ix) = PDFRNT
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVActn - Validates the Action Code.                         *
      *                                                               *
      *****************************************************************
     C     SRVActn       BEGSR
 
     C                   IF        PDCUST = *BLANKS AND
     C                             PDNAHO = *BLANKS
 
      ** 1st screen validation.
 
     C                   EVAL      WOKActn = 'Y'
 
     C                   IF        PDACTD <> 'Y'
 
     C                   IF        PDACTN <> 'E' AND
     C                             PDACTN <> 'A'
     C                   EVAL      WOKActn = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PDACTN <> 'I'
     C                   EVAL      WOKActn = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WOKActn = 'N'
 
      ** Action Code must be 'A' or 'E'. Take note that 'I' is an internal
      ** action code that occurs when PDACTN = 'A' and no members are
      ** defined for the current Joint A/c Number.
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0105'
     C                   ENDIF
 
     C                   ELSE
 
      ** 2nd screen validation.
 
     C                   EVAL      WOKActn = 'Y'
 
     C                   IF        PDACTD <> 'Y'
 
     C                   IF        PDACTN <> 'D'
     C                   EVAL      WOKActn = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PDACTN <> 'I' AND
     C                             PDACTN <> 'A'
     C                   EVAL      WOKActn = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WOKActn = 'N'
 
      ** Action Code must be 'D'. Take note that 'A' is an internal action
      ** code that occurs when PDACTN = ' ', while 'I' occurs if the 2nd
      ** screen is in insert mode.
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0106'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcSeS - Access security checking - single branching.       *
      *                                                               *
      *****************************************************************
     C     SRAcSeS       BEGSR
 
      ** Check user's authority to the Action Code.
 
     C                   CALL      'ZVACTU'
     C                   PARM      PDACTN        PZActn
     C                   PARM      *ZERO         PZErr
 
     C                   IF        PZErr = 1
 
      ** Action Code invalid for user.
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0103'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcSeM - Access security checking - multi-branching.        *
      *                                                               *
      *****************************************************************
     C     SRAcSeM       BEGSR
 
      ** Check user's authority to the Action Code & Booking Branch.
 
     C                   CALL      'ZVACTBU'
     C                   PARM      PDACTN        PZActn
     C                   PARM      DBRN          PZBrch
     C                   PARM      *ZERO         PZErr
 
     C                   SELECT
 
     C                   WHEN      PZErr = 1
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C**********         EVAL      MsgIDArr(Ix) = 'SDM0101'                                   CGL035
     C                   EVAL      MsgIDArr(Ix) = 'SDM0136'                                   CGL035
 
     C                   WHEN      PZErr = 2
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0102'
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVActI - Validates Action Code 'I'.                         *
      *                                                               *
      *****************************************************************
     C     SRVActI       BEGSR
 
     C                   IF        PDCUST <> *BLANKS
 
     C                   EVAL      KJANo = PDJANO
     C                   EVAL      KCust = PDCUST
     C     KJAC1         CHAIN     SDJACCL1
 
     C                   IF        %FOUND
 
      ** Joint A/c Number/Customer Number combination already exists.
 
     C                   EVAL      OKCUST = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDCUST'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0110'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PDNAHO <> *BLANKS
 
     C                   EVAL      KJANo = PDJANO
     C                   EVAL      KNAHo = PDNAHO
     C     KJAC3         CHAIN     SDJACCL3
 
     C                   IF        %FOUND
 
      ** Joint A/c Number/Non-a/c Holder combination already exists.
 
     C                   EVAL      OKNAHO = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDNAHO'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0111'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvJAcM - Retrieves Joint A/c Members.                     *
      *                                                               *
      *****************************************************************
     C     SRRtvJAcM     BEGSR
 
     C                   IF        POprMode <> '*FRONT'
 
     C                   EVAL      KJANo = PDJANO
 
     C                   IF        PDCUST = *BLANKS AND
     C                             PDNAHO = *BLANKS
     C     KJANo         CHAIN     SDJACCL1
     C                   ELSE
 
     C                   IF        PDCUST <> *BLANKS
     C                   EVAL      KCust = PDCUST
     C     KJAC1         CHAIN     SDJACCL1
     C                   ELSE
     C                   EVAL      KNAHo = PDNAHO
     C     KJAC3         CHAIN     SDJACCL3
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        NOT %FOUND
 
      ** Record not found.
 
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDACTN'
     C                   EVAL      MsgIDArr(Ix) = 'SDM0112'
     C                   LEAVESR
     C                   ENDIF
 
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
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Operation Mode
     C                   PARM                    POprMode
 
      ** Response Mode
     C                   PARM                    PResMode
 
      ** Action Code
     C                   PARM                    PDACTN
 
      ** Front Office Transaction ID
     C                   PARM                    PDFRNT
 
      ** Joint A/c Number
     C                   PARM                    PDJANO
 
      ** Customer Number
     C                   PARM                    PDCUST
 
      ** Non-a/c Holder
     C                   PARM                    PDNAHO
 
      ** Action Code Default
     C                   PARM                    PDACTD
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Joint A/c Member Details - File Format
     C                   PARM                    JAcMFilFmt
 
      ** OK - Action Code
     C                   PARM                    OKACTN
 
      ** OK - Customer Number
     C                   PARM                    OKCUST
 
      ** OK - Non-a/c Holder
     C                   PARM                    OKNAHO
 
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array Index (3P0) From/To Caller
     C                   PARM                    Ix
 
      ** Key Lists
 
     C     KJAC1         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KCust
 
     C     KJAC3         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KNAHo
 
      ** Get bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IN        ZMUSER
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ILE RPG Program Status Subroutine
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
