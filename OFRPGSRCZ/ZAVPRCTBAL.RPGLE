     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas OF Check A/c Balances at Profit Centre')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  ZAVPRCTBAL - Validate A/c Balance at Profit Centre level     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CGL123  *CREATE    Date 12Dec12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL123 - Issue a warning message during closure of account   *
      *           if there is a remaining balance at Profit Centre    *
      *           level.                                              *
      *         - Applied fix AR861455 :                              *
      *           - Override to the correct file member to access     *
      *             the historic balances during validation.          *
      *             (Child: AR861456)                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FGLHIBLL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                           AR861455
                                                                                            AR861455
     FGLHBCGL1  IF   E           K DISK    INFSR(*PSSR)                                     AR861455
      ** Group Codes, format @BNRED0                                                        AR861455
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
                                                                                            AR861455
      ** QCommands                                                                          AR861455
     D QCmd            S            100    DIM(2) CTDATA PERRCD(1)                          AR861455
                                                                                            AR861455
      ** Data Structure for QCmd                                                            AR861455
     D Command         DS           100                                                     AR861455
     D  DSCmd                  1    100                                                     AR861455
     D  DSCmd1                13     22                                                     AR861455
     D  DSCmd2                29     38                                                     AR861455
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Incoming parameters
     D InPDCT          S              2
     D InPDYR          S              2
     D InPDNY          S              2
     D InBRCD          S              3
     D InCYCD          S              3
     D InACCD          S             10
     D InCUST          S              6
     D InACSN          S              2
 
      ** Period Month field (numeric)
     D WkNDNY          S              2S 0
 
      ** Work Variables
     D CurMonth        S              1
     D PrvMonth        S              1
     D WarningFound    S              1
     D CommandLen      S             15P 5                                                  AR861455
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
     C                   Movel     *Blanks       RetCodeIn
     C                   Movel     *Blank        CurMonth
     C                   Movel     *Blank        PrvMonth
     C                   Movel     'N'           WarningFound
     C                   Eval      Idx = 0
     C                   Eval      WIdx = 0
 
      ** Read through all defined group codes in the system                                 AR861455
     C     *LOVAL        Setll     @BNRED0                            41                    AR861455
                                                                                            AR861455
     C                   Dow       *IN41 = *OFF                                             AR861455
     C                   Read      @BNRED0                                41                AR861455
                                                                                            AR861455
     C                   If        *IN41 = *OFF and WarningFound = 'N'                      AR861455
     C                   EVAL      Command = QCmd(1)                                        AR861455
     C                   EVAL      DSCmd1 = 'GLHIBLL3'                                      AR861455
     C                   EVAL      DSCmd2 = HCCGCD                                          AR861455
     C                   EVAL      CommandLen = 39                                          AR861455
                                                                                            AR861455
      ** Close Mgmt Accounts Historic Balances file                                         AR861455
     C                   Close     GLHIBLL3                                                 AR861455
                                                                                            AR861455
     C                   CALL      'QCMDEXC'                                                AR861455
     C                   PARM                    Command                                    AR861455
     C                   PARM                    CommandLen                                 AR861455
                                                                                            AR861455
      ** Open Mgmt Accounts Historic Balances file                                          AR861455
     C                   Open      GLHIBLL3                                                 AR861455
                                                                                            AR861455
      ** Check Balance at Profit Centre level
     C                   Exsr      SrChkPCBal
                                                                                            AR861455
     C                   Endif                                                              AR861455
                                                                                            AR861455
     C                   Enddo                                                              AR861455
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrChkPCBal - Check Balance at Profit Centre level            *
      *****************************************************************
     C     SrChkPCBal    BEGSR
      *
      ** Access PCA balances for this account for the current month
     C     KyHIBL        Setgt     @HIBLEE
     C     KyHIBL        Readpe    @HIBLEE                                40
 
      ** If record for current month found, set flag to Y
     C                   If        *IN40 = *OFF
     C                   Eval      CurMonth = 'Y'
     C                   Endif
 
     C                   Dow       *IN40 = *OFF
     C                   If        HBPDCB <> 0
     C                   Add       1             WIdx
     C                   EVAL      WFldNmXAr(WIdx) = '*ANY  '
     C                   EVAL      WMsgIdXar(WIdx) = 'RE76022'
     C                   Eval      WarningFound = 'Y'
     C                   Leave
     C                   Endif
     C     KyHIBL        Readpe    @HIBLEE                                40
     C                   Enddo
 
      *
      ** Access PCA balances for this account for the previous month.
      ** Only do this if no record for the current month was found.
     C                   If        CurMonth <> 'Y'
 
      ** Set Period month value to previous month
     C                   Move      InPDNY        WkNDNY
     C                   Eval      WkNDNY = WkNDNY - 1
     C                   Move      WkNDNY        InPDNY
 
     C     KyHIBL        Setgt     @HIBLEE
     C     KyHIBL        Readpe    @HIBLEE                                40
      ** If record for previous month found, set flag to Y
     C                   If        *IN40 = *OFF
     C                   Eval      PrvMonth = 'Y'
     C                   Endif
 
     C                   Dow       *IN40 = *OFF
     C                   If        HBPDCB <> 0
     C                   Add       1             WIdx
     C                   EVAL      WFldNmXAr(WIdx) = '*ANY  '
     C                   EVAL      WMsgIdXar(WIdx) = 'RE76022'
     C                   Eval      WarningFound = 'Y'
     C                   Leave
     C                   Endif
     C     KyHIBL        Readpe    @HIBLEE                                40
     C                   Enddo
 
     C                   Endif
      *
     C                   If        WarningFound = 'Y'
     C                   Eval      RetCodeIn = 'Warning'
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *  Input
     C                   Parm                    RetCodeIn
     C                   Parm                    InPDCT
     C                   Parm                    InPDYR
     C                   Parm                    InPDNY
     C                   Parm                    InBRCD
     C                   Parm                    InCYCD
     C                   Parm                    InACCD
     C                   Parm                    InCUST
     C                   Parm                    InACSN
      *  Output
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMSGDtXAr
 
      ** Set up key list for LF/GLHIBLL3
     C     KyHIBL        KLIST
     C                   KFLD                    InPDCT
     C                   KFLD                    InPDYR
     C                   KFLD                    InPDNY
     C                   KFLD                    InBRCD
     C                   KFLD                    InCYCD
     C                   KFLD                    InACCD
     C                   KFLD                    InCUST
     C                   KFLD                    InACSN
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
**  QCmd                                                                                    AR861455
OVRDBF FILE(          ) MBR(          )                                                     AR861455
