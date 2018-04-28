     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cheque Proc Validation and Update Program')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004246 - RE Cheque Processing Validation and Update        *
      *             Program                                           *
      *                                                               *
      *  Function:  This program will provide Cheque processing       *
      *             validation and update when feature Cheque Book    *
      *             Processing (CRE019) is switched on. Upon return,  *
      *             it will pass corresponding return code, warning   *
      *             messages and update Cheque Book file (CHQBKPD).   *
      *                                                               *
      *  Called By: REC004246 - RE Cheque Processing Validation       *
      *                         and Update Program                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR895153           Date 31Jan12               *
      *  Prev Amend No. AR763424           Date 01Jun11               *
      *                 CRE067             Date 05Oct10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204B *CREATE    Date 10Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR895153 - STOPPED CHEQUE warning message is displaying      *
      *             only letter W                                     *
      *  AR763424 - Set PRTCD to 0 on *PSSR and do not set PRTCD to 0 *
      *             if overridable error is found.                    *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CAP204B - Teller Related APIs - Account Transfer             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    65         Cheque book file indicator for delete mode      *
      *    66         Cheque book file indicator for insert mode      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrResetErrs   - Reset the errors                              *
      * SrSetKey      - Setup key fields                              *
      * SrChequeProc  - Cheque processing validation and update       *
      * SrStopCheque  - Verify if Stopped Cheque is already issued    *
      * SrValCheque   - Validate if Cheque is out of range or         *
      *                 already presented                             *
      * SrInsCheque   - Update presented Cheque table                 *
      * SrUpdateTrl   - Update trailer file                           *
      * SrDltCheque   - Delete cheque from list of presented cheques  *
      * SrEditMessage - Edit the message for output                   *
      * SrAlignCheque - Right-align the Cheque Number                 *
      * ZTNLU1        - Retrieve and update transaction number data   *
      *                 area                                          *
      * *PSSR         - Error processing                              *
      * *INZSR        - Program initialisation                        *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Cheque Book Details
     FCHQBKL1   UF A E           K DISK
 
      ** Midas RE Cheques Presented with Warning Messages
     FTTRANL6   IF   E           K DISK
 
      ** Teller Trans. logical file of all presented cheques
     FTTRANL7   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Teller Identification file
     FSDTELDL1  IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
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
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Account details
     D ACCNTB        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(#)
 
      ** Array of Fields in error
     D FldNameArr      S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data
     D MsgDtaArr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings
     D WFldNamArr      S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDArr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data
     D WMsgDtaArr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** File information DS for parameter PACNT
     D PACNT           DS            34
     D  WBRCA                  1      3
     D  WCUST                  4      9
     D  WCURR                 10     12
     D  WACNO                 13     22
     D  WSEQN                 23     24
     D  WZZZZ                 25     34
 
      ** Last transaction number DS
     D DNATN           DS             5
     D  FNATN                  1      5  0
 
      ** Data structure to hold string constants for QCMDEXC
     D                 DS
     D  @CMD                   1     80
     D  @BRI                  30     30
     D  @BID                  31     33
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PMODE           S              1A
     D PUPDF           S              1A
     D PRACN           S             10A
     D PCHQN           S              8A
     D PDRAM           S             13S 0                                                    CRE067
     D PRTCD           S              1A
     D PERMSG          S          32000A   VARYING
 
      ** Access objects
     D PRetCode        S              7A
     D POption         S              7A
     D PACID           S             10
     D PCYCD           S              3A
     D PACCD           S             10
     D PACSN           S              2
     D PBRCA           S              3A
     D PTYPE           S              7
     D PNOSN           S              2
     D PCHQAM          S             13S 0
     D PCHQNO          S              8S 0
     D PRETAC          S             10S 0
     D PCNUM           S              6
 
      ** ZALIGN Parameters
     D PZAlignOk       S              1A   INZ(*BLANKS)
     D PZField         S             16A   INZ(*BLANKS)
     D PZADec          S              1P 0 INZ(*ZEROS)
     D PZAdig          S              2P 0 INZ(*ZEROS)
 
      ** Key List fields
     D KRACN           S             10S 0
     D KGCIN           S              1S 0
     D KCHQN           S              8S 0
     D KRACNTR         S             10S 0
     D KGCINTR         S              1S 0
     D KCHQNTR         S              8S 0
 
      ** Work variables
     D @RUN            S              1    INZ(*BLANKS)
     D @LEN            S             15  5
     D @TXT            S             80A   DIM(2) CTDATA PERRCD(1)
     D WCHQOK          S              1A
     D WRANGE          S              1A
     D WDUP            S              1A
     D WNLIVE          S              1A
     D WINS            S              1A
     D WDEL            S              1A
     D WOKDEL          S              1A
     D WRACN           S             10S 0
     D WSCQN           S              8S 0
     D WOFSET          S              8S 0
     D WI              S              2S 0
     D WBITN           S              1S 0
     D WAR             S              1A   DIM(20)
     D W2              S              2S 0
     D WNATN           S              5S 0
     D WK0005          S              5S 0
     D WErrExist       S              1N   INZ(*OFF)
     D MsgArrOUT       S           9999
     D WErrIdx         S              3S 0 INZ(*ZEROS)
     D APIName         S             20    INZ(*BLANKS)                                     AR895153
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     ** +--- Start of Main processing --------------------------------+
     ** ¦                                                             ¦
     ** ¦ Initial processing is performed automatically: the *INZSR   ¦
     ** ¦ is executed at program activation.                          ¦
     ** ¦                                                             ¦
     ** +-------------------------------------------------------------+
 
      *
      ** Reset Error Fields
      *
     C                   EXSR      SrResetErrs
      *
      ** Setup key fields
      *
     C                   EXSR      SrSetKey
      *
      ** Check processing validation and update
      *
     C                   EXSR      SrChequeProc
      *
      ** Edit message for output
      *
     C                   EXSR      SrEditMessage
      *
      ** End of program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrResetErrs - Subroutine to Reset the errors                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrResetErrs   BEGSR
 
     C                   EVAL      WErrExist = *OFF
     C                   EVAL      PRTCD = '1'
     C                   EVAL      WErrIdx = 0
 
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIDArr   = *BLANKS
     C                   EVAL      MsgDtaArr  = *BLANKS
     C                   EVAL      WFldNamArr = *BLANKS
     C                   EVAL      WMsgIDArr  = *BLANKS
     C                   EVAL      WMsgDtaArr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSetKey - Subroutine to Setup key fields                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOACCTV0                                               *
      *                                                               *
      *****************************************************************
     C     SrSetKey      BEGSR
 
      *
      ** Set Cheque Number
      *
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      PCHQN         PZField
     C                   EXSR      SrAlignCheque
     C                   MOVE      PZField       KCHQN
      *
      ** Set GIRO cheque indicator
      *
     C                   EVAL      KGCIN = *ZEROS
      *
      ** Set Retail Account Number
      *
     C                   IF        PRACN <> *BLANKS
 
     C                   MOVE      PRACN         KRACN
      *
      ** Get account details using Retail Account Number
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY'        POption
     C                   PARM                    PRACN
     C                   PARM      *BLANKS       PCNUM
     C                   PARM      *BLANKS       PCYCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSN
     C                   PARM      *BLANKS       PBRCA
     C     ACCNTB        PARM      ACCNTB        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C******LOCK         IN        LDA                                                        CRE067
     C**********         EVAL      DBFILE =  'ACCNTAB'                                        CRE067
     C**********         EVAL      DBKEY  =  PRACN                                            CRE067
     C**********         EVAL      DBASE  =  2                                                CRE067
     C**********         OUT       LDA                                                        CRE067
     C**********         EXSR      *PSSR                                                      CRE067
     C                                                                                        CRE067
     C                   EVAL      WErrIdx = wErrIdx + 1                                      CRE067
     C                   EVAL      FldNameArr(wErrIdx) = 'CHEQUEACNO'                         CRE067
     C                   EVAL      MsgIDArr(wErrIdx)   = 'USR0123'                            CRE067
     C                   EVAL      MsgFArray(wErrIdx)  = 'GBRTSMSGF'                          CRE067
     C                   EVAL      WErrExist = *ON                                            CRE067
     C                   ELSE                                                                 CRE067
     C                                                                                        CRE067
     C                   IF        #RECI <> 'D'                                               CRE067
     C                   EVAL      WErrIdx = wErrIdx + 1                                      CRE067
     C                   EVAL      FldNameArr(wErrIdx) = 'CHEQUEACNO'                         CRE067
     C                   EVAL      MsgIDArr(wErrIdx)   = 'USR0124'                            CRE067
     C                   EVAL      MsgFArray(wErrIdx)  = 'GBRTSMSGF'                          CRE067
     C                   EVAL      WErrExist = *ON                                            CRE067
     C                   ENDIF                                                                CRE067
     C                   ENDIF
 
     C                   ELSE
      *
      ** Get account details if Retail Account Number not entered
      *
     C                   CALL      'AOACCTV0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      WCUST         PACID
     C                   PARM      WCURR         PCYCD
     C                   PARM      WACNO         PACCD
     C                   PARM      WSEQN         PACSN
     C                   PARM      WBRCA         PBRCA
     C                   PARM                    PTYPE
     C                   PARM                    PNOSN
     C     ACCNTB        PARM      ACCNTB        DSSDY
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      KRACN = #ACNO
     C                                                                                        CRE067
     C                   IF        #RECI <> 'D'                                               CRE067
     C                   EVAL      WErrIdx = wErrIdx + 1                                      CRE067
     C                   EVAL      WFldNamArr(wErrIdx) = 'CHEQUEACNO'                         CRE067
     C                   EVAL      WMsgIDArr(wErrIdx)   = 'USR0051'                           CRE067
     C                   EVAL      MsgFArray(wErrIdx)  = 'GBRTSMSGF'                          CRE067
     C                   EVAL      WErrExist = *ON                                            CRE067
     C                   ENDIF                                                                CRE067
     C                   ELSE
     C******LOCK         IN        LDA                                                        CRE067
     C**********         EVAL      DBFILE =  'ACCNTAB'                                        CRE067
     C**********         EVAL      DBKEY  =  PACID + PCYCD + PACCD +                          CRE067
     C**********                             PACSN + PBRCA                                    CRE067
     C**********         EVAL      DBASE  =  3                                                CRE067
     C**********         OUT       LDA                                                        CRE067
     C**********         EXSR      *PSSR                                                      CRE067
     C                   EVAL      WErrIdx = wErrIdx + 1                                      CRE067
     C                   EVAL      WFldNamArr(wErrIdx) = 'CHEQUEACNO'                         CRE067
     C                   EVAL      WMsgIDArr(wErrIdx)   = 'USR0050'                           CRE067
     C                   EVAL      MsgFArray(wErrIdx)  = 'GBRTSMSGF'                          CRE067
     C                   EVAL      WErrExist = *ON                                            CRE067
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChequeProc - Subroutine for Cheque processing validation    *
      *                 and update                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrStopCheque, SrValCheque, SrInsCheque                 *
      *                                                               *
      *****************************************************************
     C     SrChequeProc  BEGSR
 
      *
      ** INSERT mode validation
      *
     C                   IF        PMODE = 'I'
 
     C                   EVAL      WCHQOK = 'Y'
     C                   EXSR      SrStopCheque
 
     C                   IF        WCHQOK = 'Y'
     C                   EXSR      SrValCheque
     C                   ENDIF
      *
      ** INSERT mode update
      *
     C                   IF        WCHQOK = 'Y' AND
     C                             PUPDF  = 'Y'
     C                   EXSR      SrInsCheque
     C                   ENDIF
 
     C                   ENDIF
      *
      ** DELETE mode validation and update
      *
     C                   IF        PMODE = 'D' AND
     C                             PUPDF = 'Y'
     C                   EXSR      SrDltCheque
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrStopCheque - Subroutine to verify if Stopped Cheque is      *
      *                 already in place                              *
      *                                                               *
      * Called by: SrChequeProc                                       *
      *                                                               *
      * Calls: AOSTOPV0                                               *
      *                                                               *
      *****************************************************************
     C     SrStopCheque  BEGSR
 
     C                   CALL      'AOSTOPV0'
     C                   PARM      *BLANKS       PRetCode
     C**********         PARM      *ZEROS        PCHQAM                                       CRE067
     C                   PARM      PDRAM         PCHQAM                                       CRE067
     C                   PARM      KCHQN         PCHQNO
     C                   PARM      KRACN         PRETAC
     C                   PARM                    PCNUM
     C                   PARM                    PCYCD
     C                   PARM                    PACCD
     C                   PARM                    PACSN
     C                   PARM                    PBRCA
      **********                                                                              CRE067
      ***Error*if stopped cheque                                                              CRE067
      **********                                                                              CRE067
      ** Stopped Cheque error is changed to overridable error                                 CRE067
                                                                                              CRE067
     C                   IF        PRetCode = '*STOP  '
     C                   EVAL      WErrIdx = wErrIdx + 1
     C**********         EVAL      FldNameArr(wErrIdx) = 'FRCHEQUENO'                         CRE067
     C**********         EVAL      MsgIDArr(wErrIdx)   = 'USR1229'                            CRE067
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'                         CRE067
     C                   EVAL      WMsgIDArr(wErrIdx)  = 'USR1260'                            CRE067
     C                   EVAL      MsgFArray(wErrIdx)  = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValCheque - Subroutine to validate if Cheque is out of      *
      *                range or already presented                     *
      *                                                               *
      * Called by: SrChequeProc                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrValCheque   BEGSR
 
      *
      ** Initialise work flags for out of range and duplicate cheque
      *
     C                   EVAL      WRANGE = 'N'
     C                   EVAL      WDUP   = 'N'
      *
      ** Access Cheque book file
      *
     C     KCHQBK1       SETGT     CHQBKPDF
     C     KCHQBK2       READPE    CHQBKPDF                               66
      *
      ** If record is found and RECI = 'D'
      *
     C                   IF        *IN66 = *OFF AND
     C                             RECID = 'D'
     C                   EVAL      WNLIVE = 'N'
      *
      ** If cheque is not in range expected for any of the cheque books
      *
     C                   IF        KCHQN < SCQN OR
     C                             KCHQN > ECQN
 
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1232'                             CRE067
     C                   EVAL      WMsgIDArr(wErrIdx) = 'USR1262'                             CRE067
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   EVAL      WRANGE = 'Y'
 
     C                   ELSE
      *
      ** Verify if Cheque Number is already presented
      *
     C                   Z-ADD     KCHQN         WSCQN
     C                   EVAL      WOFSET = WSCQN - SCQN
     C                   EVAL      WI = %DIV(WOFSET:8)
     C                   EVAL      WBITN = %REM(WOFSET:8)
     C                   EVAL      WI = WI + 1
      *
      ** Test corresponding bit-position of element for cheque presented
      *
     C                   MOVEA     CQPS          WAR
     C                   IF        WBITN = 0
     C                   TESTB     '0'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 1
     C                   TESTB     '1'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 2
     C                   TESTB     '2'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 3
     C                   TESTB     '3'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 4
     C                   TESTB     '4'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 5
     C                   TESTB     '5'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 6
     C                   TESTB     '6'           WAR(WI)                  66
     C                   ENDIF
     C                   IF        WBITN = 7
     C                   TESTB     '7'           WAR(WI)                  66
     C                   ENDIF
     C                   MOVEA     WAR           CQPS
      *
      ** If *IN66 is on, set work flag for duplicate cheques to 'Y'
      *
     C                   IF        *IN66 = *ON
 
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1231'                             CRE067
     C                   EVAL      WMsgIDArr(wErrIdx) = 'USR1261'                             CRE067
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   EVAL      WDUP = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
      *
      ** If no live record was found
      *
     C                   IF        *IN66 =  *OFF AND
     C                             RECID <> 'D'
     C                   EVAL      WNLIVE = 'Y'
     C                   ENDIF
 
     C                   EVAL      WErrIdx = wErrIdx + 1
     C                   EVAL      WFldNamArr(wErrIdx) = 'FRCHEQUENO'
     C**********         EVAL      WMsgIDArr(wErrIdx) = 'USR1233'                             CRE067
     C                   EVAL      WMsgIDArr(wErrIdx) = 'USR1263'                             CRE067
     C                   EVAL      MsgFArray(wErrIdx) = 'GBRTSMSGF'
     C                   EVAL      WErrExist = *ON
     C                   EVAL      WRANGE = 'Y'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInsCheque - Subroutine to update presented Cheque table     *
      *                                                               *
      * Called by: SrChequeProc                                       *
      *                                                               *
      * Calls: ZTNLU1, SrUpdateTrl                                    *
      *                                                               *
      *****************************************************************
     C     SrInsCheque   BEGSR
 
      *
      ** Generate Next Transaction number
      *
     C                   EXSR      ZTNLU1
 
     C                   EVAL      WINS = 'N'
 
     C                   IF        WRANGE =  'Y' AND
     C                             WNLIVE <> 'Y'
 
     C                   EVAL      RECID = 'D'
     C                   EVAL      ACNO  = KRACN
     C                   EVAL      GCQI  = 0
     C                   EVAL      SCQN  = KCHQN
     C                   EVAL      NOCQ  = 1
     C                   EVAL      ECQN  = KCHQN
     C                   EVAL      DISS  = BJRDNB
     C                   EVAL      DCOL  = BJRDNB
     C                   EVAL      BRCA  = #BRCA
     C                   EVAL      CHTP  = 'I'
     C                   EVAL      CHAM  = 0
     C                   EVAL      CHAC  = 0
     C                   EVAL      CHTT  = 0
     C                   EVAL      OUTR  = 'Y'
     C                   EVAL      WINS  = 'Y'
      *
      ** Set bit of for all the 160 cheque presented array
      *
     C                   EVAL      W2 = 1
 
     C                   DOW       W2 <= 20
     C                   BITON     '01234567'    WAR(W2)
     C                   BITOFF    '01234567'    WAR(W2)
     C                   EVAL      W2 = W2 + 1
     C                   ENDDO
 
     C                   ENDIF
      *
      ** Update fields TNLU, LCD and CQPS for both update and write
      *
     C                   EVAL      TNLU = WNATN
     C                   EVAL      LCD  = BJRDNB
      *
      ** Set on bits  of CQPS to specify cheque presented
      *
     C                   Z-ADD     KCHQN         WSCQN
     C                   EVAL      WOFSET = WSCQN - SCQN
     C                   EVAL      WI = %DIV(WOFSET:8)
     C                   EVAL      WBITN = %REM(WOFSET:8)
     C                   EVAL      WI = WI + 1
      *
      ** Test corresponding bit-position of element for cheque presented
      *
     C                   MOVEA     CQPS          WAR
     C                   IF        WBITN = 0
     C                   BITON     '0'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 1
     C                   BITON     '1'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 2
     C                   BITON     '2'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 3
     C                   BITON     '3'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 4
     C                   BITON     '4'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 5
     C                   BITON     '5'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 6
     C                   BITON     '6'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 7
     C                   BITON     '7'           WAR(WI)
     C                   ENDIF
     C                   MOVEA     WAR           CQPS
      *
      ** If record does not exist, write a new one and update trailer
      ** file, else, update current record on CHQBKPD
      *
     C                   IF        WINS = 'Y'
     C                   EVAL      OEDT = BJRDNB
     C                   WRITE     CHQBKPDF
     C                   EXSR      SrUpdateTrl
 
     C                   ELSE
     C                   IF        WDUP  = 'N'
 
     C                   IF        RECID = '*'
     C                   EVAL      WINS  = 'Y'
     C                   ENDIF
 
     C                   EVAL      RECID = 'D'
     C                   EVAL      CHTP  = 'A'
     C                   UPDATE    CHQBKPDF
     C                   EXSR      SrUpdateTrl
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZTNLU1 - Subroutine to lock the transaction number data area  *
      *           and then update and release the data area           *
      *                                                               *
      * Called by: SrInsCheque                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ZTNLU1        BEGSR
 
     C     *DTAARA       DEFINE    MNATN         DNATN
     C     *LOCK         IN        DNATN
 
     C                   MOVE      FNATN         WNATN
     C                   MOVE      FNATN         WK0005
     C                   EVAL      WK0005 = WK0005 + 1
     C                   MOVE      WK0005        FNATN
 
     C                   OUT       DNATN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdateTrl - Subroutine to update trailer file               *
      *                                                               *
      * Called by: SrInsCheque, SrDltCheque                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrUpdateTrl   BEGSR
 
     C                   MOVE      *ALL'9'       KRACNTR
     C                   MOVE      '9'           KGCINTR
     C                   MOVE      *ALL'9'       KCHQNTR
 
     C     KCHQTR1       CHAIN     CHQBKPTF
 
     C                   IF        %FOUND
      *
      **  Increase No. of records if action is insert
      *
     C                   IF        WINS = 'Y'
     C                   EVAL      NORE = NORE + 1
     C                   ENDIF
      *
      **  Decrease No. of records if action is delete
      *
     C                   IF        WDEL = 'Y'
     C                   EVAL      NORE = NORE - 1
     C                   ENDIF
 
     C                   EVAL      WINS = 'N'
     C                   EVAL      WDEL = 'N'
 
     C                   EVAL      LCD  = BJRDNB
     C                   EVAL      CHTP = 'A'
     C                   EVAL      TNLU = WNATN
     C                   UPDATE    CHQBKPTF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDltCheque - Subroutine to validate and delete cheque        *
      *                number from the list of presented cheques      *
      *                                                               *
      * Called by: SrChequeProc                                       *
      *                                                               *
      * Calls: ZTNLU1, SrUpdateTrl                                    *
      *                                                               *
      *****************************************************************
     C     SrDltCheque   BEGSR
 
     C                   EVAL      WOKDEL = 'Y'
      *
      ** Validate if other transaction is using cheque number
      *
     C     PCHQN         SETLL     TTRANL6
     C     PCHQN         READE     TTRANL6                                65
 
     C                   DOW       *IN65 = *OFF
 
     C                   IF        KRACN = DRAN OR
     C                             KRACN = BTRACN
     C                   EVAL      WOKDEL = 'N'
     C                   LEAVE
     C                   ENDIF
 
     C     PCHQN         READE     TTRANL6                                65
     C                   ENDDO
 
     C                   IF        WOKDEL = 'Y'
     C     *LOVAL        SETLL     SDTELDL1
     C                   READ      SDTELDL1                               65
 
     C                   DOW       *IN65 = *OFF
      *
      ** If not the first time, delete previous overrides
      *
     C                   IF        @CMD <> *BLANKS
 
     C                   CLOSE     TTRANL7
 
     C                   EVAL      @CMD =  *BLANKS
     C                   EVAL      @CMD =  @TXT(1)
     C                   EVAL      @LEN =  %LEN(@CMD)
     C                   CALL      'QCMDEXC'
     C                   PARM                    @CMD
     C                   PARM                    @LEN
     C                   ENDIF
      *
      ** Perform override to LF/TTRANL7
      *
     C                   EVAL      @CMD = *BLANKS
     C                   EVAL      @CMD = @TXT(2)
     C                   EVAL      @BRI = 'T'
     C                   EVAL      @BID = FRTLID
     C                   EVAL      @LEN = %LEN(@CMD)
     C                   CALL      'QCMDEXC'
     C                   PARM                    @CMD
     C                   PARM                    @LEN
 
     C                   OPEN      TTRANL7
     C     *LOVAL        SETLL     TTRANL7
     C     PCHQN         CHAIN     TTRANL7
     C                   IF        %FOUND(TTRANL7)
     C                   EVAL      WOKDEL = 'N'
     C                   LEAVE
     C                   ENDIF
 
     C                   READ      SDTELDL1                               65
     C                   ENDDO
 
     C                   ENDIF
      *
      ** Allow delete if current transaction is the only transaction
      ** using the cheque
      *
     C                   IF        WOKDEL = 'Y'
      *
      ** Generate Next Transaction number
      *
     C                   EXSR      ZTNLU1
     C                   EVAL      TNLU = WNATN
     C                   EVAL      LCD  = BJRDNB
     C                   EVAL      WDEL = 'N'
      *
      ** Access Cheque book file
      *
     C     KCHQBK1       SETGT     CHQBKPDF
     C     KCHQBK2       READPE    CHQBKPDF
      *
      ** If out of range flag is 'Y', record can be deleted
      *
     C                   IF        OUTR = 'Y'
     C                   EVAL      WDEL = 'Y'
     C                   DELETE    CHQBKPDF
     C                   EXSR      SrUpdateTrl
 
     C                   ELSE
      *
      ** Else, ammend such that the cheque is not yet presented
      *
     C                   Z-ADD     KCHQN         WSCQN
     C                   EVAL      WOFSET = WSCQN - SCQN
     C                   EVAL      WI = %DIV(WOFSET:8)
     C                   EVAL      WBITN = %REM(WOFSET:8)
     C                   EVAL      WI = WI + 1
 
     C                   MOVEA     CQPS          WAR
     C                   IF        WBITN = 0
     C                   BITOFF    '0'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 1
     C                   BITOFF    '1'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 2
     C                   BITOFF    '2'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 3
     C                   BITOFF    '3'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 4
     C                   BITOFF    '4'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 5
     C                   BITOFF    '5'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 6
     C                   BITOFF    '6'           WAR(WI)
     C                   ENDIF
     C                   IF        WBITN = 7
     C                   BITOFF    '7'           WAR(WI)
     C                   ENDIF
     C                   MOVEA     WAR           CQPS
 
     C                   EVAL      CHTP = 'A'
     C                   UPDATE    CHQBKPDF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEditMessage - Subroutine to edit the message for output     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: APEDTMSGS                                              *
      *                                                               *
      *****************************************************************
     C     SrEditMessage BEGSR
 
     C                   IF        WErrExist = *ON
     C                   EVAL      APIName = 'STCQ'                                         AR895153
     C                   CALLB     'APEDTMSGS'
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    MsgArrOUT
     C                   PARM                    APIName                                    AR895153
 
     C                   EVAL      PERMSG = MsgArrOUT
     C**********         EVAL      PRTCD = '0'                                              AR763424
 
     C                   ELSE
     C                   EVAL      MsgArrOUT = *BLANKS
     C                   EVAL      PERMSG = MsgArrOUT
     C                   EVAL      PRTCD = '1'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAlignCheque - Subroutine to right-align the Cheque Number   *
      *                 passed to this program                        *
      *                                                               *
      * Called by: SrStopCheque, SrChqIssPre                          *
      *                                                               *
      * Calls: ZALIGN                                                 *
      *                                                               *
      *****************************************************************
     C     SrAlignCheque BEGSR
 
     C                   EVAL      PZADec = 0
     C                   EVAL      PZAdig = 8
 
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADec
     C                   PARM                    PZAdig
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation subroutine                            *
      *                                                               *
      * Called by: Automatically called                               *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C     *ENTRY        PLIST
     C                   PARM                    PMODE
     C                   PARM                    PUPDF
     C                   PARM                    PACNT
     C                   PARM                    PRACN
     C                   PARM                    PCHQN
     C                   PARM                    PDRAM                                        CRE067
     C                   PARM                    PRTCD
     C                   PARM                    PERMSG
 
     C     KCHQBK1       KLIST
     C                   KFLD                    KRACN
     C                   KFLD                    KGCIN
     C                   KFLD                    KCHQN
 
     C     KCHQBK2       KLIST
     C                   KFLD                    KRACN
     C                   KFLD                    KGCIN
 
     C     KCHQTR1       KLIST
     C                   KFLD                    KRACNTR
     C                   KFLD                    KGCINTR
     C                   KFLD                    KCHQNTR
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM  =  PSProcPgm
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST'      POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  POption
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
      ** Set PRTCD to '0' on program exception                                              AR763424
     C                   EVAL      PRTCD = '0'                                              AR763424
                                                                                            AR763424
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
**  @TXT - TEXT STRINGS FOR OVERRIDE
DLTOVR     FILE(TTRANL7)
OVRDBF     FILE(TTRANL7) MBR(XXXX) SECURE(*YES) SHARE(*NO)  SEQONLY(*NO)
