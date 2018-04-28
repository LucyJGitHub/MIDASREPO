     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list bulk data checking module (FT)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000016 - Watch List Bulk Data Checking module for Funds    *
      *             Transfer                                          *
      *                                                               *
      *  Function:  This module will check all data per function code *
      *             for Funds Transfer                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG15105A          Date 25Oct07               *
      *                 CSW207             Date 03Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11May06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSD015   *CREATE   Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15105A - Missing Process for SWIFT 2007 (Reopen)          *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Read Operation for INPAYL1                      *
      *    02         Chain Operation for INPAYXL0                    *
      *    03         Read Operation for OTPAYL1                      *
      *    04         Chain Operation for OTPAYXL0                    *
      *    05         Read Operation for FT101HL0                     *
      *    06         Reade Operation for FT101DL0                    *
      *    07         Read Operation for FT102HL0                     *
      *    08         Reade Operation for FT102DL0                    *
      *    09         Read Operation for CQCODDD                      *
      *    10         Reade Operation for CQCOCDL1                    *
      *    11         Read Operation for CQPACDD                      *
      *    12         Chain Operation for SDCWHTL0                    *
      *    13         Reade Operation for CQPADDL1                    *
      *    14         Read Operation for NTRAN                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrChkWList - Check Function Code for Bulk Checking           *
      *  SrCheckFreq - Check Function Code for possible cases         *
      *  SrInPayment - Parameter formatting for Incoming Payment      *
      *  Sr1stINParm - Setup first parm for Incoming Payment          *
      *  SrINCtrPty - Setup Counterparty Details for INPAYDD          *
      *  SrINProcess - Setup 2nd parm/ Call engine for IN Payment     *
      *  SrOtPayment - Parameter formatting for Outgoing Payment      *
      *  Sr1stOTParm - Setup first parm for Outgoing Payment          *
      *  SrOTCtrPty - Setup Counterparty Details for OTPAY            *
      *  SrOTProcess - Setup 2nd parm/ Call engine for OT Payment     *
      *  SrReqTrans - Parameter formatting for Request for Transfer   *
      *  Sr1stRFTParm - Setup first parm for RFT                      *
      *  SrRFTCtrPty - Setup Counterparty Details for RFT             *
      *  SrRFTProcess - Setup 2nd parm/ Call engine for RFT           *
      *  SrCustCredit - Parameter formatting for Customer Credit      *
      *  Sr1stCCTParm - Setup first parm for CCT                      *
      *  SrCCTCtrPty - Setup Counterparty Details for CCT             *
      *  SrCCTProcess - Setup 2nd parm/ Call engine for RFT           *
      *  SrCheqColl - Parameter formatting for Cheques for Collection *
      *  Sr1stCQParm - Setup first parm for Cheques for Collection    *
      *  SrCQCtrPty - Setup Counterparty Details for Cheques for Coll *
      *  SrCQProcess - Setup 2nd parm/ Call engine for CheqColl       *
      *  SrCheqPaid - Parameter formatting for Cheques to be Paid     *
      *  Sr1stCPParm - Setup first parm for Cheques to be Paid        *
      *  SrCPCtrPty - Setup Counterparty Details for CheqPaid         *
      *  SrCPProcess - Setup 2nd parm/ Call engine for CheqPaid       *
      *  SrNosTrans - Parameter formatting for Nostro Transfer        *
      *  Sr1stNTParm - Setup first parm for Nostro Transfer           *
      *  SrNTCtrPty - Setup Counterparty Details for Nostro Transfer  *
      *  SrNTProcess - Setup 2nd parm/ Call engine for Nostro Trans   *
      *  SrCtrPtyDetls - Details of Counterparty                      *
      *  SrWLChk - Watch List Check Engine                            *
      *  SrConvrt - Convert Customer to Customer Name and Address     *
      *  SrCvtDate - Convert dates to be used for Watch Engine Pgm    *
      *  SrCvtAmt - Convert amounts for Watch Engine Program          *
      * *INZSR - Initialise                                           *
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
 
      ** FT Incoming Payments File
     FINPAYL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** FT Incoming Payments Extended File
     FINPAYXL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** FT Outgoing Payments File
     FOTPAYL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** FT Outgoing Payments Extended File
     FOTPAYXL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** RFT Header File
     FFT101HL0  IF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** RFT Details File
     FFT101DL0  IF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** CCT Header File
     FFT102HL0  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H2_)
     F                                     USROPN
 
      ** CCT Details File
     FFT102DL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Cheques for Collections File by Pref
     FCQCOCDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CQCOCDDF:CQCOCDD2)
     F                                     PREFIX(C1_)
     F                                     USROPN
 
      ** Cheques for Collections File
     FCQCODDD   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Cheques fto be Paid file by Pref
     FCQPADDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CQPADDDF:CQPADDD2)
     F                                     PREFIX(P1_)
     F                                     USROPN
 
      ** Cheques to be Paid File
     FCQPACDD   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Nostro Transfers File
     FNTRAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Compliance Watch Hit List(FType/Identifier/Branch)
     FSDCWHTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Watch List Checking Details by Function Code File
     FSDWLCCL0  UF   E           K DISK    INFSR(*PSSR)
 
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
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
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
      ** ¦ Manuall included D-specs             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** DS for Bank Details
     D SDBank        E DS                  EXTNAME(SDBANKPD)
 
      ** General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Midas Functions for Watch List Checking Details File
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
 
      ** Fisrt DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Midas Watch List Transaction Details File
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)
 
      ** Midas Compliance Watch Configuration Data File
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
 
      ** Midas SD Customer Details File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Standing Data Dataarea
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** 24x7 Status Dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D ArrWatch        S             35    DIM(44) CTDATA PERRCD(1)
     D CCF001          S              1A
     D CSC011          S              1A
     D KBranch         S              3A
     D KFuncType       S              8A
     D KIden           S             40A
     D PAMDate         S               D
     D PAMFlot         S             18  3
     D PCurr           S              3A
     D PCOutput        S              6A
     D PFuncCode       S              8A
     D PInAmt          S             15A
     D PInCcy          S              3A
     D PInDate         S              5  0
     D PInput1         S             35A
     D PInput2         S             35A
     D PInput3         S             35A
     D PInput4         S             35A
     D PInput5         S             35A
     D PInput6         S             35A
     D PKey            S             10A
     D POutAmt         S              8F
     D POutDate        S             18  3
     D POutput         S            216A
     D POption         S              7A
     D PRtnCode        S              7A
     D PSard           S              6A
     D PStatus         S             10A
     D PWatchString    S          30000A
     D PRetCode        S              7A
     D PMsgs           S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
     D PSrvContext     S               *
     D WDBASE          S              3  0
     D ZCCY            S              3A
     D ZDAYNO          S              5  0
     D ZFREQ           S              1A
     D ZLOC            S              3A
     D ZMDAY           S              2  0
     D WACBN           S              2A
     D WCRPY           S             12A
     D WDRPY           S             12A
     D WDEST           S              2A
     D WORBK           S             12A
     D WRCCO           S             10A
     D WRecCor         S             10A
     D WSNCO           S             10A
 
     D                 DS
      **  OrderingBank
     D  OrderingBank           1     12
     D  ORBKNostro             1      2
     D  ORBKRetail             1     10
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Main Processing
 
      ** Open OFAC server
 
     C                   CALL      'SDOFACOP'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
      ** Error calling SDOFACOP
 
     C                   IF        PRetCode <> *BLANK
 
     C                   SELECT
 
     C                   WHEN      PRetCode = '*INIT  '
     C                   EVAL      WDBASE = 13
     C                   EVAL      PMsgId = 'USR9686'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*OPEN  '
     C                   EVAL      WDBASE = 14
     C                   EVAL      PMsgID = 'USR9687'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*NREADY'
     C                   EVAL      WDBASE = 15
     C                   EVAL      PMsgID = 'USR9688'
     C                   EXSR      SRSndErr
 
     C                   ENDSL
 
      ** Perform database error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKEY = PRetCode
     C                   EVAL      DBFile = 'SDOFACOP'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if FTIPAY is to be processed for bulk checking today
 
     C                   EVAL      PFuncCode = 'FTIPAY'
     C                   EXSR      SrChkWList
     C                   IF        PRtnCode = *BLANKS AND
     C                             W1PFRQ <> *BLANKS and W1NPCD <= BJRDNB
     C                   EXSR      SrInPayment
     C                   EXSR      SrCheckFreq
     C                   ENDIF
 
      ** Check if FTOPAY is to be processed for bulk checking today
 
     C                   EVAL      PFuncCode = 'FTOPAY'
     C                   EXSR      SrChkWList
     C                   IF        PRtnCode = *BLANKS AND
     C                             W1PFRQ <> *BLANKS and W1NPCD <= BJRDNB
     C                   EXSR      SrOtPayment
     C                   EXSR      SrCheckFreq
     C                   ENDIF
 
      ** Check if TRANSREQ is to be processed for bulk checking today
 
     C                   EVAL      PFuncCode = 'TRANSREQ'
     C                   EXSR      SrChkWList
     C                   IF        PRtnCode = *BLANKS AND
     C                             W1PFRQ <> *BLANKS and W1NPCD <= BJRDNB
     C                   EXSR      SrReqTrans
     C                   EXSR      SrCheckFreq
     C                   ENDIF
 
      ** Check if CUSTCRTR is to be processed for bulk checking today
 
     C                   EVAL      PFuncCode = 'CUSTCRTR'
     C                   EXSR      SrChkWList
     C                   IF        PRtnCode = *BLANKS AND
     C                             W1PFRQ <> *BLANKS and W1NPCD <= BJRDNB
     C                   EXSR      SrCustCredit
     C                   EXSR      SrCheckFreq
     C                   ENDIF
 
      ** Check if CHEQCOLL is to be processed for bulk checking today
 
     C                   EVAL      PFuncCode = 'CHEQCOLL'
     C                   EXSR      SrChkWList
     C                   IF        PRtnCode = *BLANKS AND
     C                             W1PFRQ <> *BLANKS and W1NPCD <= BJRDNB
     C                   EXSR      SrCheqColl
     C                   EXSR      SrCheckFreq
     C                   ENDIF
 
      ** Check if CHEQPAID is to be processed for bulk checking today
 
     C                   EVAL      PFuncCode = 'CHEQPAID'
     C                   EXSR      SrChkWList
     C                   IF        PRtnCode = *BLANKS AND
     C                             W1PFRQ <> *BLANKS and W1NPCD <= BJRDNB
     C                   EXSR      SrCheqPaid
     C                   EXSR      SrCheckFreq
     C                   ENDIF
 
      ** Check if FTNOSTRF is to be processed for bulk checking today
 
     C                   EVAL      PFuncCode = 'FTNOSTRF'
     C                   EXSR      SrChkWList
     C                   IF        PRtnCode = *BLANKS AND
     C                             W1PFRQ <> *BLANKS and W1NPCD <= BJRDNB
     C                   EXSR      SrNosTrans
     C                   EXSR      SrCheckFreq
     C                   ENDIF
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkWList - Check Function Code for Bulk Checking           *
      *                                                               *
      *****************************************************************
 
     C     SrChkWList    BEGSR
 
     C                   CALLB     'AOWLCCR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY'        POption
     C                   PARM                    PFuncCode
     C     SDWLCC        PARM      SDWLCC        DSFDY
 
      ** If return code not blank, then issue database error
 
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'
     C                   IN        LDA
     C                   EVAL      DBKEY = PFuncCode
     C                   EVAL      DBFILE = 'SDWLCCPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCheckFreq - Determine next periodic check date for func    *
      *                                                               *
      *****************************************************************
 
     C     SrCheckFreq   BEGSR
      *
      ** Retrieve function code record from the WLC Details File.
      *
     C     PFuncCode     CHAIN     SDWLCCL0
 
      ** Set Last Periodic Check Date to Rundate
 
     C                   EVAL      W1LPCD = BJRDNB
 
      ** Determine next periodic check date for function
 
     C                   EVAL      ZFREQ = W1PFRQ
     C                   EVAL      ZDAYNO = W1NPCD
     C                   EVAL      ZMDAY = W1PDYN
     C                   EVAL      ZCCY = BJLCCY
 
     C                   CALLB     'ZFREQB'
     C                   PARM                    PRtnCode
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C     SDGELR        PARM      SDGELR        DSFDY
 
      ** Update the Next Periodic Check Date field on file SDWLCCL0
 
     C                   EVAL      W1NPCD = ZDAYNO
     C                   UPDATE    SDWLCCD0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInPayment - Parameter formatting for Incoming Payment      *
      *                                                               *
      *****************************************************************
 
     C     SrInPayment   BEGSR
 
      ** Process Incoming Payment Detail File
 
     C                   OPEN      INPAYL1
     C                   OPEN      INPAYXL0
     C                   READ      INPAYDDF                               01
 
     C                   DOW       *IN01 = *OFF
 
     C                   IF        RECI = 'D'
 
     C                   EVAL      KFuncType = 'INPAYDD'
     C                   EVAL      KIden = PRef
     C                   EVAL      KBranch = BRCA
 
     C     KFuncKey      CHAIN     SDCWHTL0                           12
 
     C                   IF        *IN12 = *ON
     C                   IF        W1LPCD < W1LUDT
     C                   EXSR      SrInProcess
     C                   ENDIF
     C                   ELSE
     C                   IF        W3LWCD < W1LUDT
     C                   EXSR      SrInProcess
     C                   ENDIF
     C                   ENDIF
 
     C                   Endif
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stINParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
 
     C                   READ      INPAYDDF                               01
     C                   ENDDO
 
     C                   CLOSE     INPAYL1
     C                   CLOSE     INPAYXL0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stINParm - Setup first IN parm for Compliance Engine Pgm  *
      *                                                               *
      *****************************************************************
 
     C     Sr1stINParm   BEGSR
 
     C                   EVAL      W4ITEM = 'FTIPAY'
     C                   EVAL      W4IDEN = PREF
     C                   EVAL      W4BRCH = BRCA
     C                   EVAL      W4SYSM = LIBR
     C                   EVAL      W4FUNT = 'INPAYDD'
     C                   EXSR      SrInCtrPty
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4DDAT
     C                   MOVE      SLDT          PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4VDAT
     C                   MOVE      PVDT          PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4MDAT
     C                   EVAL      W4DEN1 = SMCY
     C                   MOVE      SMAM          PInAmt
     C                   EVAL      PCurr = W4DEN1
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT1 = PAMFlot
     C                   EVAL      W4DEN2 = PCCY
     C                   MOVE      PYAM          PInAmt
     C                   EVAL      PCurr = W4DEN2
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT2 = PAMFlot
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInCtrPty - Setup Counterparty Details for INPAY            *
      *                                                               *
      *****************************************************************
 
     C     SrInCtrPty    BEGSR
 
      ** Initialise Counterparty fields
 
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
     C                   MOVEL     RCCO          WRecCor
 
     C                   EVAL      PInput1 = SND1
     C                   EVAL      PInput2 = SND2
     C                   EVAL      PInput3 = SND3
     C                   EVAL      PInput4 = SND4
     C                   EVAL      PInCcy =  SMCY
     C                   EXSR      SrConvrt
 
     C                   IF        PCOutput = '*FREE' or PCOutput = '*CPART' or
     C                             (SND1 = *Blanks and SND2 = *Blanks and
     C                             SND3 = *Blanks and SND4 = *Blanks)
     C                   MOVEL     WRecCor       PInput1
     C                   EVAL      PInput2 = *Blanks
     C                   EVAL      PInput3 = *Blanks
     C                   EVAL      PInput4 = *Blanks
     C                   EVAL      PInCcy = SMCY
     C                   EXSR      SrConvrt
     C                   ENDIF
 
     C                   IF        PCOutput = '*FREE' or PCOutput = '*CPART' or
     C                             (SND1 = *Blanks and SND2 = *Blanks  and
     C                             SND3 = *Blanks and SND4 = *Blanks  and
     C                             WRecCor = *Blanks)
     C                   EVAL      PInput1 = INTRIB
     C                   EVAL      PInput2 = *Blanks
     C                   EVAL      PInput3 = *Blanks
     C                   EVAL      PInput4 = *Blanks
     C                   EXSR      SrConvrt
     C                   ENDIF
 
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'
     C                   EVAL      W4CNUM = PCOutput
     C                   EVAL      PKey = W4CNUM
     C                   EXSR      SrCtrPtyDetls
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInProcess - Calling of Engine Program for INPAY            *
      *                                                               *
      *****************************************************************
 
     C     SrInProcess   Begsr
 
      ** Setup second parameter for Compliance Engine Program
 
 
     C                   IF        SND1 <> *BLANKS OR SND2 <> *BLANKS OR
     C                             SND3 <> *BLANKS OR SND4 <> *BLANKS
     C                   EVAL      Pinput1 = SND1
     C                   EVAL      Pinput2 = SND2
     C                   EVAL      Pinput3 = SND3
     C                   EVAL      Pinput4 = SND4
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(1))
     C                             + %Trim(POutput) + %Trim(ArrWatch(2))
     C                   ENDIF
 
     C                   MOVEL     RCCO          WRCCO
     C                   IF        WRCCO <> *BLANKS
     C                   EVAL      Pinput1 = WRCCO
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(3))
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))
     C                   ENDIF
 
     C                   IF        ACBK <> *BLANKS
     C                   EVAL      Pinput1 = ACBK
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(5))
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))
     C                   ENDIF
 
     C                   IF        BNC1 <> *BLANKS OR BNC2 <> *BLANKS OR
     C                             BNC3 <> *BLANKS OR BNC4 <> *BLANKS OR
     C                             BNC5 <> *BLANKS
     C                   EVAL      Pinput1 = BNC1
     C                   EVAL      Pinput2 = BNC2
     C                   EVAL      Pinput3 = BNC3
     C                   EVAL      Pinput4 = BNC4
     C                   EVAL      Pinput5 = BNC5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(7))
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))
     C                   ENDIF
 
     C                   IF        ORB1 <> *BLANKS OR ORB2 <> *BLANKS OR
     C                             ORB3 <> *BLANKS OR ORB4 <> *BLANKS OR
     C                             ORB5 <> *BLANKS
     C                   EVAL      Pinput1 = ORB1
     C                   EVAL      Pinput2 = ORB2
     C                   EVAL      Pinput3 = ORB3
     C                   EVAL      Pinput4 = ORB4
     C                   EVAL      Pinput5 = ORB5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(9))
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))
     C                   ENDIF
 
     C                   IF        SNC1 <> *BLANKS OR SNC2 <> *BLANKS OR
     C                             SNC3 <> *BLANKS OR SNC4 <> *BLANKS OR
     C                             SNC5 <> *BLANKS
     C                   EVAL      Pinput1 = SNC1
     C                   EVAL      Pinput2 = SNC2
     C                   EVAL      Pinput3 = SNC3
     C                   EVAL      Pinput4 = SNC4
     C                   EVAL      Pinput5 = SNC5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(11))
     C                             + %Trim(POutput) + %Trim(ArrWatch(12))
     C                   ENDIF
 
     C                   IF        ORC1 <> *BLANKS OR ORC2 <> *BLANKS OR
     C                             ORC3 <> *BLANKS OR ORC4 <> *BLANKS
     C                             Or ORC5 <> *BLANKS                                      BUG15105A
     C                   EVAL      Pinput1 = ORC1
     C                   EVAL      Pinput2 = ORC2
     C                   EVAL      Pinput3 = ORC3
     C                   EVAL      Pinput4 = ORC4
     C                   EVAL      Pinput5 = ORC5                                          BUG15105A
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(13))
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))
     C                   ENDIF
 
     C                   IF        DTP1 <> *BLANKS OR DTP2 <> *BLANKS OR
     C                             DTP3 <> *BLANKS OR DTP4 <> *BLANKS
     C                   EVAL      Pinput1 = DTP1
     C                   EVAL      Pinput2 = DTP2
     C                   EVAL      Pinput3 = DTP3
     C                   EVAL      Pinput4 = DTP4
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(15))
     C                             + %Trim(POutput) + %Trim(ArrWatch(16))
     C                   ENDIF
 
     C                   IF        INB1 <> *BLANKS OR INB2 <> *BLANKS OR
     C                             INB3 <> *BLANKS OR INB4 <> *BLANKS OR
     C                             INB5 <> *BLANKS
     C                   EVAL      Pinput1 = INB1
     C                   EVAL      Pinput2 = INB2
     C                   EVAL      Pinput3 = INB3
     C                   EVAL      Pinput4 = INB4
     C                   EVAL      Pinput5 = INB5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(17))
     C                             + %Trim(POutput) + %Trim(ArrWatch(18))
     C                   ENDIF
 
     C                   IF        INRCO1 <> *BLANKS OR INRCO2 <> *BLANKS OR
     C                             INRCO3 <> *BLANKS OR INRCO4 <> *BLANKS OR
     C                             INRCO5 <> *BLANKS
     C                   EVAL      Pinput1 = INRCO1
     C                   EVAL      Pinput2 = INRCO2
     C                   EVAL      Pinput3 = INRCO3
     C                   EVAL      Pinput4 = INRCO4
     C                   EVAL      Pinput5 = INRCO5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(3))
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))
     C                   ENDIF
 
     C                   IF        INACB1 <> *BLANKS OR INACB2 <> *BLANKS OR
     C                             INACB3 <> *BLANKS OR INACB4 <> *BLANKS OR
     C                             INACB5 <> *BLANKS
     C                   EVAL      Pinput1 = INACB1
     C                   EVAL      Pinput2 = INACB2
     C                   EVAL      Pinput3 = INACB3
     C                   EVAL      Pinput4 = INACB4
     C                   EVAL      Pinput5 = INACB5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(5))
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))
     C                   ENDIF
 
      ** Process INPAYXPD extension file
 
     C     PREF          CHAIN     INPAYXDF                             02
 
     C                   IF        *IN02 = *OFF
 
     C                   IF        INTRIB <> *BLANKS OR INTRI1 <> *BLANKS OR
     C                             INTRI2 <> *BLANKS OR INTRI3 <> *BLANKS OR
     C                             INTRI4 <> *BLANKS OR INTRI5 <> *BLANKS
     C                   EVAL      Pinput1 = INTRIB
     C                   EVAL      Pinput2 = INTRI1
     C                   EVAL      Pinput3 = INTRI2
     C                   EVAL      Pinput4 = INTRI3
     C                   EVAL      Pinput5 = INTRI4
     C                   EVAL      Pinput6 = INTRI5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(39))
     C                             + %Trim(POutput) + %Trim(ArrWatch(40))
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOtPayment - Parameter formatting for Outgoing Payment      *
      *                                                               *
      *****************************************************************
 
     C     SrOtPayment   BEGSR
 
      ** Setup second parameter for Compliance Engine Program
 
      ** Process Outgoing Payment Detail File
 
     C                   OPEN      OTPAYL1
     C                   OPEN      OTPAYXL0
     C                   READ      OTPAYDDF                               03
 
     C                   DOW       *IN03 = *Off
 
     C                   IF        RECI = 'D'
 
     C                   EVAL      KFuncType = 'OTPAYDD'
     C                   EVAL      KIden = PRef
     C                   EVAL      KBranch = BRCA
 
     C     KFuncKey      CHAIN     SDCWHTL0                           12
 
     C                   IF        *IN12 = *ON
     C                   IF        W1LPCD < W1LUDT
     C                   EXSR      SrOtProcess
     C                   ENDIF
     C                   ELSE
     C                   IF        W3LWCD < W1LUDT
     C                   EXSR      SrOtProcess
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stOtParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
 
     C                   READ      OTPAYDDF                               03
     C                   ENDDO
 
     C                   CLOSE     OTPAYL1
     C                   CLOSE     OTPAYXL0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stOTParm - Setup first parm for Compliance Engine Pgm     *
      *                                                               *
      *****************************************************************
 
     C     Sr1stOTParm   BEGSR
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EVAL      W4ITEM = 'FTOPAY'
     C                   EVAL      W4IDEN = PREF
     C                   EVAL      W4BRCH = BRCA
     C                   EVAL      W4SYSM = LIBR
     C                   EVAL      W4FUNT = 'OTPAYDD'
     C                   EXSR      SrOTCtrPty
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4DDAT
     C                   MOVE      SLDT          PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4VDAT
     C                   MOVE      PVDT          PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4MDAT
     C                   EVAL      W4DEN1 = SMCY
     C                   MOVE      SMAM          PInAmt
     C                   EVAL      PCurr = W4DEN1
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT1 = PAMFlot
     C                   EVAL      W4DEN2 = PCCY
     C                   MOVE      PYAM          PInAmt
     C                   EVAL      PCurr = W4DEN2
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT2 = PAMFlot
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOtCtrPty - Setup Counterparty Details for OTPAY            *
      *                                                               *
      *****************************************************************
 
     C     SrOtCtrPty    BEGSR
 
      ** Initialise Counterparty fields
 
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
 
     C                   IF        ODMT <> *BLANKS
     C                   EVAL      PInput1 = ODMT
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInput5 = *BLANKS
     C                   EVAL      PInCcy =  SMCY
     C                   EXSR      SrConvrt
     C                   ENDIF
 
     C                   IF        PCOutput = '*FREE' or PCOutput = '*CPART' or
     C                             ODMT = *BLANKS
     C                   EVAL      PInput1 = ORC1
     C                   EVAL      PInput2 = ORC2
     C                   EVAL      PInput3 = ORC3
     C                   EVAL      PInput4 = ORC4
     C**********         EVAL      PInput5 = *BLANKS                                       BUG15105A
     C                   EVAL      PInput5 = ORC5                                          BUG15105A
     C                   EVAL      PInCcy =  SMCY
     C                   EXSR      SrConvrt
     C                   ENDIF
 
     C                   IF        PCOutput = '*FREE' or PCOutput = '*CPART' or
     C                             (ORC1 = *BLANKS and ORC2 = *BLANKS
     C                             and ORC3 = *BLANKS and ORC4 = *BLANKS
     C                             and ORC5 = *BLANKS                                      BUG15105A
     C                             and ODMT = *BLANKS)
     C                   IF        OPMSGR > 0
     C                   EVAL      PInput1 = OPORB1
     C                   EVAL      PInput2 = OPORB2
     C                   EVAL      PInput3 = OPORB3
     C                   EVAL      PInput4 = OPORB4
     C                   EVAL      PInput5 = OPORB5
     C                   EVAL      PInCcy =  SMCY
     C                   EXSR      SrConvrt
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PCOutput = '*FREE' or PCOutput = '*CPART' or
     C                             (ORC1 = *BLANKS and ORC2 = *BLANKS and
     C                             ORC3 = *BLANKS and ORC4 = *BLANKS and
     C                             ORC5 = *BLANKS and                                      BUG15105A
     C                             ODMT = *BLANKS and OPMSGR = 0)
     C                   MOVE      *BLANKS       OrderingBank
     C                   SELECT
     C                   WHEN      ORBT = 'N'
     C                   MOVEL     ORBK          ORBKNostro
     C                   MOVEL     OrderingBank  PInput1
     C                   WHEN      ORBT = 'R'
     C                   MOVEL     ORBK          ORBKRetail
     C                   MOVEL     OrderingBank  PInput1
     C                   OTHER
     C                   MOVEL     ORBK          PInput1
     C                   ENDSL
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInput5 = *BLANKS
     C                   EVAL      PInCcy =  SMCY
     C                   EXSR      SrConvrt
     C                   ENDIF
 
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'
     C                   EVAL      W4CNUM = PCOutput
     C                   EVAL      PKey = W4CNUM
     C                   EXSR      SrCtrPtyDetls
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOtProcess - Calling of Engine Program for OTPAY            *
      *                                                               *
      *****************************************************************
 
     C     SrOtProcess   BEGSR
 
     C                   IF        DST1 <> *BLANKS or DST2 <> *BLANKS or
     C                             DST3 <> *BLANKS or DST4 <> *BLANKS
     C                   EVAL      Pinput1 = DST1
     C                   EVAL      Pinput2 = DST2
     C                   EVAL      Pinput3 = DST3
     C                   EVAL      Pinput4 = DST4
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(19))
     C                             + %Trim(POutput) + %Trim(ArrWatch(20))
     C                   ENDIF
 
     C                   MOVEL     SNCO          WSNCO
     C                   IF        WSNCO <> *BLANKS
     C                   EVAL      Pinput1 = WSNCO
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(11))
     C                             + %Trim(POutput) + %Trim(ArrWatch(12))
     C                   ENDIF
 
     C                   MOVEL     ORBK          WORBK
     C                   IF        WORBK <> *BLANKS
     C                   EVAL      Pinput1 = WORBK
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(9))
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))
     C                   ENDIF
 
     C                   IF        ORC1 <> *BLANKS or ORC2 <> *BLANKS or
     C                             ORC3 <> *BLANKS or ORC4 <> *BLANKS
     C                             Or ORC5 <> *BLANKS                                      BUG15105A
     C                   EVAL      Pinput1 = ORC1
     C                   EVAL      Pinput2 = ORC2
     C                   EVAL      Pinput3 = ORC3
     C                   EVAL      Pinput4 = ORC4
     C                   EVAL      Pinput5 = ORC5                                          BUG15105A
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(13))
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))
     C                   ENDIF
 
     C                   IF        RCO1 <> *BLANKS or RCO2 <> *BLANKS or
     C                             RCO3 <> *BLANKS or RCO4 <> *BLANKS or
     C                             RCO5 <> *BLANKS
     C                   EVAL      Pinput1 = RCO1
     C                   EVAL      Pinput2 = RCO2
     C                   EVAL      Pinput3 = RCO3
     C                   EVAL      Pinput4 = RCO4
     C                   EVAL      Pinput5 = RCO5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(3))
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))
     C                   ENDIF
 
     C                   IF        ACB1 <> *BLANKS or ACB2 <> *BLANKS or
     C                             ACB3 <> *BLANKS or ACB4 <> *BLANKS or
     C                             ACB5 <> *BLANKS
     C                   EVAL      Pinput1 = ACB1
     C                   EVAL      Pinput2 = ACB2
     C                   EVAL      Pinput3 = ACB3
     C                   EVAL      Pinput4 = ACB4
     C                   EVAL      Pinput5 = ACB5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(5))
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))
     C                   ENDIF
 
     C                   IF        BNC1 <> *BLANKS or BNC2 <> *BLANKS or
     C                             BNC3 <> *BLANKS or BNC4 <> *BLANKS or
     C                             BNC5 <> *BLANKS
     C                   EVAL      Pinput1 = BNC1
     C                   EVAL      Pinput2 = BNC2
     C                   EVAL      Pinput3 = BNC3
     C                   EVAL      Pinput4 = BNC4
     C                   EVAL      Pinput5 = BNC5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(7))
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))
     C                   ENDIF
 
     C                   IF        DTP1 <> *BLANKS or DTP2 <> *BLANKS or
     C                             DTP3 <> *BLANKS or DTP4 <> *BLANKS
     C                   EVAL      Pinput1 = DTP1
     C                   EVAL      Pinput2 = DTP2
     C                   EVAL      Pinput3 = DTP3
     C                   EVAL      Pinput4 = DTP4
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(15))
     C                             + %Trim(POutput) + %Trim(ArrWatch(16))
     C                   ENDIF
 
     C                   IF        INB1 <> *BLANKS or INB2 <> *BLANKS or
     C                             INB3 <> *BLANKS or INB4 <> *BLANKS or
     C                             INB5 <> *BLANKS
     C                   EVAL      Pinput1 = INB1
     C                   EVAL      Pinput2 = INB2
     C                   EVAL      Pinput3 = INB3
     C                   EVAL      Pinput4 = INB4
     C                   EVAL      Pinput5 = INB5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(17))
     C                             + %Trim(POutput) + %Trim(ArrWatch(18))
     C                   ENDIF
 
     C                   IF        ODMT <> *BLANKS
     C                   EVAL      Pinput1 = ODMT
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(21))
     C                             + %Trim(POutput) + %Trim(ArrWatch(22))
     C                   ENDIF
 
     C                   IF        OPORB1 <> *BLANKS or OPORB2 <> *BLANKS or
     C                             OPORB3 <> *BLANKS or OPORB4 <> *BLANKS or
     C                             OPORB5 <> *BLANKS
     C                   EVAL      Pinput1 = OPORB1
     C                   EVAL      Pinput2 = OPORB2
     C                   EVAL      Pinput3 = OPORB3
     C                   EVAL      Pinput4 = OPORB4
     C                   EVAL      Pinput5 = OPORB5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(9))
     C                             + %Trim(POutput) + %Trim(ArrWatch(10))
     C                   ENDIF
 
      ** Process FTOPAYXPD extension file
 
     C     PREF          CHAIN     OTPAYXDF                             04
 
     C                   IF        *IN04 = *OFF
 
     C                   IF        OPTRI1 <> *BLANKS or OPTRI2 <> *BLANKS or
     C                             OPTRI3 <> *BLANKS or OPTRI4 <> *BLANKS or
     C                             OPTRI5 <> *BLANKS
     C                   EVAL      Pinput1 = OPTRI1
     C                   EVAL      Pinput2 = OPTRI2
     C                   EVAL      Pinput3 = OPTRI3
     C                   EVAL      Pinput4 = OPTRI4
     C                   EVAL      Pinput5 = OPTRI5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(39))
     C                             + %Trim(POutput) + %Trim(ArrWatch(40))
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReqTrans - Parameter formatting for Request for Transfer   *
      *                                                               *
      *****************************************************************
 
     C     SrReqTrans    BEGSR
 
      ** Setup second parameter for Compliance Engine Program
 
      ** Process RFT Header File
 
     C                   OPEN      FT101HL0
     C                   OPEN      FT101DL0
     C                   READ      FT101HD0                               05
 
     C                   DOW       *IN05 = *OFF
 
     C                   EVAL      KFuncType = 'FT101HPD'
     C                   EVAL      KIden = RftId
     C                   EVAL      KBranch = BRCA
 
     C     KFuncKey      CHAIN     SDCWHTL0                           12
 
     C                   IF        *IN12 = *On
     C                   IF        W1LPCD < W1LUDT
     C                   EXSR      SrRftProcess
     C                   ENDIF
     C                   ELSE
     C                   IF        W3LWCD < W1LUDT
     C                   EXSR      SrRFtProcess
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      FT101HD0                               05
     C                   ENDDO
 
     C                   CLOSE     FT101HL0
     C                   CLOSE     FT101DL0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stRFTParm - Setup first parm for Compliance Engine Prgm   *
      *                                                               *
      *****************************************************************
 
     C     Sr1stRFTParm  BEGSR
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EVAL      W4ITEM = 'FTREQT'
     C                   EVAL      W4IDEN = RFTID
     C                   EVAL      W4BRCH = BRCA
     C                   EVAL      W4SYSM = LIBR
     C                   EVAL      W4FUNT = 'FT101HPD'
     C                   EXSR      SrRFTCtrPty
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4DDat
     C                   MOVE      DBTVDT        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4VDat
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4MDat
     C                   EVAL      W4Den1 = TRNCCY
     C                   MOVE      TRNAMT        PInAmt
     C                   EVAL      PCurr = W4DEN1
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4Amt1 = PAMFlot
     C                   EVAL      W4Den2 = PAYCCY
     C                   MOVE      PAYAMT        PInAmt
     C                   EVAL      PCurr = W4DEN2
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4Amt2 = PAMFlot
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRFTCtrPty - Setup Counterparty Details for RFT             *
      *                                                               *
      *****************************************************************
 
     C     SrRFTCtrPty   BEGSR
 
      ** Initialise Counterparty fields
 
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
 
     C                   IF        PYTP = 'RI'
     C                   EVAL      PInput1 = HOCUS1
     C                   EVAL      PInCcy = *BLANKS
     C                   EXSR      SrConvrt
     C                   ELSE
     C                   EVAL      PInput1 = RFTDST
     C                   EVAL      PInCcy = *BLANKS
     C                   EXSR      SrConvrt
     C                   ENDIF
 
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'
     C                   EVAL      W4CNUM = PCOutput
     C                   EVAL      PKey = W4CNUM
     C                   EXSR      SrCtrPtyDetls
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRFTProcess - Calling of Engine Program for RFT             *
      *                                                               *
      *****************************************************************
 
     C     SrRFTProcess  BEGSR
 
     C                   EVAL      *IN06 = *OFF
 
     C     RFTID         SETLL     FT101DD0
     C     RFTID         READE     FT101DD0                             0606
 
     C                   IF        *IN06 = *ON
     C                   EXSR      SRRFTHProcess
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stRFTParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
     C                   ENDIF
 
     C                   DOW       *IN06 = *OFF
 
      ** Header
 
     C                   EXSR      SRRFTHProcess
 
      ** Process RFT Details
 
     C                   IF        TINPTY <> *BLANKS
     C                   EVAL      Pinput1 = TINPTY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(23))
     C                             + %Trim(POutput) + %Trim(ArrWatch(24))
     C                   ENDIF
 
     C                   IF        TOCUS1 <> *BLANKS or TOCUS2 <> *BLANKS or
     C                             TOCUS3 <> *BLANKS or TOCUS4 <> *BLANKS or
     C                             TOCUS5 <> *BLANKS
     C                   EVAL      Pinput1 = TOCUS1
     C                   EVAL      Pinput2 = TOCUS2
     C                   EVAL      Pinput3 = TOCUS3
     C                   EVAL      Pinput4 = TOCUS4
     C                   EVAL      Pinput5 = TOCUS5
     C                   EVAL      PInCcy = TRNCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(13))
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))
     C                   ENDIF
 
     C                   IF        TASI35 <> *BLANKS or TACC11 <> *BLANKS
     C                   IF        TASI35 <> *BLANKS
     C                   EVAL      Pinput1 = TASI35
     C                   ELSE
     C                   EVAL      Pinput1 = TACC11
     C                   ENDIF
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(25))
     C                             + %Trim(POutput) + %Trim(ArrWatch(26))
     C                   ENDIF
 
 
     C                   IF        TINST1 <> *BLANKS or TINST2 <> *BLANKS or
     C                             TINST3 <> *BLANKS or TINST4 <> *BLANKS or
     C                             TINST5 <> *BLANKS or TINSTA <> *BLANKS
 
     C                   IF        TINST1 <> *BLANKS or TINST2 <> *BLANKS or
     C                             TINST3 <> *BLANKS or TINST4 <> *BLANKS or
     C                             TINST5 <> *BLANKS
     C                   EVAL      Pinput1 = TINST1
     C                   EVAL      Pinput2 = TINST2
     C                   EVAL      Pinput3 = TINST3
     C                   EVAL      Pinput4 = TINST4
     C                   EVAL      Pinput5 = TINST5
     C                   EVAL      PInCcy = PAYCCY
     C                   ELSE
     C                   EVAL      Pinput1 = TINSTA
     C                   EVAL      PInCcy = PAYCCY
     C                   ENDIF
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(17))
     C                             + %Trim(POutput) + %Trim(ArrWatch(18))
     C                   ENDIF
 
     C                   IF        TACA35 <> *BLANKS or TACB35 <> *BLANKS or
     C                             TACC35 <> *BLANKS or TACD35 <> *BLANKS or
     C                             TACE35 <> *BLANKS or TACA11 <> *BLANKS
 
     C                   IF        TACA35 <> *BLANKS or TACB35 <> *BLANKS or
     C                             TACC35 <> *BLANKS or TACD35 <> *BLANKS or
     C                             TACE35 <> *BLANKS
     C                   EVAL      Pinput1 = TACA35
     C                   EVAL      Pinput2 = TACB35
     C                   EVAL      Pinput3 = TACC35
     C                   EVAL      Pinput4 = TACD35
     C                   EVAL      Pinput5 = TACE35
     C                   EVAL      PInCcy = PAYCCY
     C                   ELSE
     C                   EVAL      Pinput1 = TACA11
     C                   EVAL      PInCcy = PAYCCY
     C                   ENDIF
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(5))
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))
     C                   ENDIF
 
     C                   IF        TBNA35 <> *BLANKS or TBNB35 <> *BLANKS or
     C                             TBNC35 <> *BLANKS or TBND35 <> *BLANKS or
     C                             TBNE35 <> *BLANKS
     C                   EVAL      Pinput1 = TBNA35
     C                   EVAL      Pinput2 = TBNB35
     C                   EVAL      Pinput3 = TBNC35
     C                   EVAL      Pinput4 = TBND35
     C                   EVAL      Pinput5 = TBNE35
     C                   EVAL      PInCcy = PAYCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(7))
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))
     C                   ENDIF
 
     C                   IF        TRMA35 <> *BLANKS or TRMB35 <> *BLANKS or
     C                             TRMC35 <> *BLANKS or TRMD35 <> *BLANKS
     C                   EVAL      Pinput1 = TRMA35
     C                   EVAL      Pinput2 = TRMB35
     C                   EVAL      Pinput3 = TRMC35
     C                   EVAL      Pinput4 = TRMD35
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(27))
     C                             + %Trim(POutput) + %Trim(ArrWatch(28))
     C                   ENDIF
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stRFTParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
     C     RFTID         READE     FT101DD0                             0606
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRFTHProcess - Calling of Engine Program for RFT            *
      *                                                               *
      *****************************************************************
 
     C     SrRFTHProcess BEGSR
 
      ** Header
 
     C                   IF        RFTDST <> *BLANKS
     C                   EVAL      Pinput1 = RFTDST
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(19))
     C                             + %Trim(POutput) + %Trim(ArrWatch(20))
     C                   ENDIF
 
     C                   IF        HINPTY <> *BLANKS
     C                   EVAL      Pinput1 = HINPTY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(23))
     C                             + %Trim(POutput) + %Trim(ArrWatch(24))
     C                   ENDIF
 
     C                   IF        HOCUS1 <> *BLANKS or HOCUS2 <> *BLANKS or
     C                             HOCUS3 <> *BLANKS or HOCUS4 <> *BLANKS or
     C                             HOCUS5 <> *BLANKS
     C                   EVAL      Pinput1 = HOCUS1
     C                   EVAL      Pinput2 = HOCUS2
     C                   EVAL      Pinput3 = HOCUS3
     C                   EVAL      Pinput4 = HOCUS4
     C                   EVAL      Pinput5 = HOCUS5
     C                   EVAL      PInCcy =  TRNCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(13))
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))
     C                   ENDIF
 
     C                   IF        HACSV1 <> *BLANKS or HACSV2 <> *BLANKS
     C                   IF        HACSV1 <> *BLANKS
     C                   EVAL      Pinput1 = HACSV1
     C                   ELSE
     C                   EVAL      Pinput1 = HACSV2
     C                   ENDIF
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(25))
     C                             + %Trim(POutput) + %Trim(ArrWatch(26))
     C                   ENDIF
 
     C                   IF        SINST <> *BLANKS
     C                   EVAL      Pinput1 = SINST
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(41))
     C                             + %Trim(POutput) + %Trim(ArrWatch(42))
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCustCredit - Parameter formatting for Customer Credit      *
      *                                                               *
      *****************************************************************
 
     C     SrCustCredit  BEGSR
 
      ** Setup second parameter for Compliance Engine Program
 
      ** Process CCT Header File
 
     C                   OPEN      FT102HL0
     C                   OPEN      FT102DL0
     C                   READ      FT102HD0                               07
 
     C                   DOW       *IN07 = *OFF
 
     C                   EVAL      KFuncType = 'FT102HPD'
     C                   EVAL      KIden = H2_CCTID
     C                   EVAL      KBranch = H2_BRCA
 
     C     KFuncKey      CHAIN     SDCWHTL0                           12
 
     C                   IF        *IN12 = *ON
     C                   IF        W1LPCD < W1LUDT
     C                   EXSR      SrCCTProcess
     C                   ENDIF
     C                   ELSE
     C                   IF        W3LWCD < W1LUDT
     C                   EXSR      SrCCTProcess
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      FT102HD0                               07
     C                   ENDDO
 
     C                   CLOSE     FT102HL0
     C                   CLOSE     FT102DL0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stCctParm - Setup first parm for Compliance Engine Prgm   *
      *                                                               *
      *****************************************************************
 
     C     Sr1stCctParm  BEGSR
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EVAL      W4ITEM = 'FTCRED'
     C                   EVAL      W4IDEN = H2_CCTID
     C                   EVAL      W4BRCH = H2_BRCA
     C                   EVAL      W4SYSM = LIBR
     C                   EVAL      W4FUNT = 'FT102HPD'
     C                   EXSR      SrCCTCtrPty
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4DDAT
     C                   MOVE      H2_TTVDTE     PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4VDAT
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4MDAT
     C                   EVAL      W4Den1 = CCTCCY
     C                   MOVE      CCTAMT        PInAmt
     C                   EVAL      PCurr = W4DEN1
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4Amt1 = PAMFlot
     C                   EVAL      W4Den2 = PAYCCY
     C                   EVAL      PCurr = W4DEN2
     C                   MOVE      PAYAMT        PInAmt
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4Amt2 = PAMFlot
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCctCtrPty - Setup Counterparty Details for CCT             *
      *                                                               *
      *****************************************************************
 
     C     SrCctCtrPty   BEGSR
 
      ** Initialise Counterparty fields
 
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
 
     C                   IF        H2_CCTTYP = 'BI'
     C                   IF        SINST <> *BLANKS
     C                   EVAL      PInput1 = SINST
     C                   EVAL      PInCcy = CCTCCY
     C                   EXSR      SrConvrt
     C                   ENDIF
     C                   IF        PCOutput = '*FREE' or PCOutput = '*CPART'
     C                             or SINST = *BLANKS
     C                   EVAL      PInput1 = H2_SNDCOR
     C                   EVAL      PInCcy = CCTCCY
     C                   EXSR      SrConvrt
     C                   ENDIF
     C                   ELSE
     C                   IF        TOCUS1 <> *BLANKS
     C                   EVAL      PInput1 = TOCUS1
     C                   EVAL      PInCcy = PAYCCY
     C                   EXSR      SrConvrt
     C                   ENDIF
     C                   IF        PCOutput = '*FREE' or PCOutput = '*CPART'
     C                             or TOCUS1 = *BLANKS
     C                   EVAL      PInput1 = H2_OINST3
     C                   EVAL      PInCcy = PAYCCY
     C                   EXSR      SrConvrt
     C                   ENDIF
     C                   IF        PCOutput = '*FREE' or PCOutput = '*CPART' or
     C                             (TOCUS1 = *BLANKS and H2_OINST3 = *BLANKS)
     C                   EVAL      PInput1 = H2_OINST1
     C                   EVAL      PInCcy = PAYCCY
     C                   EXSR      SrConvrt
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'
     C                   EVAL      W4CNUM = PCOutput
     C                   EVAL      PKey = W4CNUM
     C                   EXSR      SrCtrPtyDetls
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCCTProcess - Calling of Engine Program for CCT             *
      *                                                               *
      *****************************************************************
 
     C     SrCCTProcess  BEGSR
 
     C                   EVAL      *IN08 = *OFF
 
     C     CCTID         SETLL     FT102DD0
     C     CCTID         READE     FT102DD0                             0808
 
     C                   IF        *IN08 = *ON
     C                   EXSR      SRCCTHProcess
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stCCTParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
     C                   ENDIF
 
     C                   DOW       *IN08 = *OFF
 
      ** Header
 
     C                   EXSR      SRCCTHProcess
 
      ** Process CCT Detail File
 
     C                   IF        ORDCU1 <> *BLANKS or ORDCU2 <> *BLANKS or
     C                             ORDCU3 <> *BLANKS or ORDCU4 <> *BLANKS
     C                             or ORDCU5 <> *BLANKS                                       CSW207
     C                   EVAL      Pinput1 = ORDCU1
     C                   EVAL      Pinput2 = ORDCU2
     C                   EVAL      Pinput3 = ORDCU3
     C                   EVAL      Pinput4 = ORDCU4
     C                   EVAL      Pinput5 = ORDCU5                                           CSW207
     C                   EVAL      PInCcy = PAYCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(13))
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))
     C                   ENDIF
 
     C                   IF        ORDI35 <> *BLANKS or ORDI11 <> *BLANKS
     C                   IF        ORDI35 <> *BLANKS
     C                   EVAL      Pinput1 = ORDI35
     C                   EVAL      PInCcy = PAYCCY
     C                   ELSE
     C                   EVAL      Pinput1 = ORDI11
     C                   EVAL      PInCcy = PAYCCY
     C                   ENDIF
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(43))
     C                             + %Trim(POutput) + %Trim(ArrWatch(44))
     C                   ENDIF
 
     C                   IF        ACCI35 <> *BLANKS or ACCI11 <> *BLANKS
     C                   IF        ACCI35 <> *BLANKS
     C                   EVAL      Pinput1 = ACCI35
     C                   EVAL      PInCcy = PAYCCY
     C                   ELSE
     C                   EVAL      Pinput1 = ACCI11
     C                   EVAL      PInCcy = PAYCCY
     C                   ENDIF
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(5))
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))
     C                   ENDIF
 
     C                   IF        BENF1 <> *BLANKS or BENF2 <> *BLANKS or
     C                             BENF3 <> *BLANKS or BENF4 <> *BLANKS or
     C                             BENF5 <> *BLANKS
     C                   EVAL      Pinput1 = BENF1
     C                   EVAL      Pinput2 = BENF2
     C                   EVAL      Pinput3 = BENF3
     C                   EVAL      Pinput4 = BENF4
     C                   EVAL      Pinput5 = BENF5
     C                   EVAL      PInCcy = PAYCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(7))
     C                             + %Trim(POutput) + %Trim(ArrWatch(8))
     C                   ENDIF
 
     C                   IF        REMI1 <> *BLANKS or REMI2 <> *BLANKS or
     C                             REMI3 <> *BLANKS or REMI4 <> *BLANKS
     C                   EVAL      Pinput1 = REMI1
     C                   EVAL      Pinput2 = REMI2
     C                   EVAL      Pinput3 = REMI3
     C                   EVAL      Pinput4 = REMI4
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(27))
     C                             + %Trim(POutput) + %Trim(ArrWatch(28))
     C                   ENDIF
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stCctParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
     C     CCTID         READE     FT102DD0                             0808
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCCTHProcess - Calling of Engine Program for CCT            *
      *                                                               *
      *****************************************************************
 
     C     SrCCTHProcess BEGSR
 
      ** Header
 
     C                   IF        H2_SINST <> *BLANKS
     C                   EVAL      Pinput1 = H2_SINST
     C                   EVAL      PInCcy = H2_CCTCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(41))
     C                             + %Trim(POutput) + %Trim(ArrWatch(42))
     C                   ENDIF
 
     C                   IF        H2_CCTDST <> *BLANKS
     C                   EVAL      Pinput1 = H2_CCTDST
     C                   EVAL      PInCcy = H2_CCTCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(19))
     C                             + %Trim(POutput) + %Trim(ArrWatch(20))
     C                   ENDIF
 
     C                   IF        H2_TOCUS1 <> *BLANKS or H2_TOCUS2 <> *BLANKS
     C                             or H2_TOCUS3 <> *BLANKS or
     C                             H2_TOCUS4 <> *BLANKS
     C                             or H2_TOCUS5 <> *BLANKS                                    CSW207
     C                   EVAL      Pinput1 = H2_TOCUS1
     C                   EVAL      Pinput2 = H2_TOCUS2
     C                   EVAL      Pinput3 = H2_TOCUS3
     C                   EVAL      Pinput4 = H2_TOCUS4
     C                   EVAL      Pinput5 = H2_TOCUS5                                        CSW207
     C                   EVAL      PInCcy = PAYCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(13))
     C                             + %Trim(POutput) + %Trim(ArrWatch(14))
     C                   ENDIF
 
     C                   IF        H2_OINST3 <> *BLANKS or H2_OINST1 <> *BLANKS
     C                   IF        H2_OINST3 <> *BLANKS
     C                   EVAL      Pinput1 = H2_OINST3
     C                   EVAL      PInCcy = PAYCCY
     C                   ELSE
     C                   EVAL      Pinput1 = H2_OINST1
     C                   EVAL      PInCcy = PAYCCY
     C                   ENDIF
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(43))
     C                             + %Trim(POutput) + %Trim(ArrWatch(44))
     C                   ENDIF
 
     C                   IF        H2_SNDCOR <> *BLANKS
     C                   EVAL      Pinput1 = H2_SNDCOR
     C                   EVAL      PInCcy = H2_CCTCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(11))
     C                             + %Trim(POutput) + %Trim(ArrWatch(12))
     C                   ENDIF
 
     C                   IF        H2_RCVCOR <> *BLANKS
     C                   EVAL      Pinput1 = H2_RCVCOR
     C                   EVAL      PInCcy = H2_CCTCCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(3))
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCheqColl - Parameter formatting for Cheques for Collection *
      *                                                               *
      *****************************************************************
 
     C     SrCheqColl    BEGSR
 
     C                   OPEN      CQCODDD
     C                   OPEN      CQCOCDL1
 
     C                   READ      CQCODDDF                               09
 
     C                   DOW       *IN09 = *OFF
 
     C                   IF        RECI = 'D'
 
     C                   EVAL      KFuncType = 'CQCOCDD'
     C                   EVAL      KIden = C1_PREF
     C                   EVAL      KBranch = C1_BRCA
 
     C     KFuncKey      CHAIN     SDCWHTL0                           12
 
     C                   IF        *IN12 = *ON
     C                   IF        W1LPCD < W1LUDT
     C                   EXSR      SrCQProcess
     C                   ENDIF
     C                   ELSE
     C                   IF        W3LWCD < W1LUDT
     C                   EXSR      SrCQProcess
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      CQCODDDF                               09
     C                   ENDDO
 
     C                   CLOSE     CQCODDD
     C                   CLOSE     CQCOCDL1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stCQParm - Setup first parm for Compliance Engine Program *
      *                                                               *
      *****************************************************************
 
     C     Sr1stCQParm   BEGSR
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EVAL      W4ITEM = 'FTCHQC'
     C                   EVAL      W4IDEN = C1_PREF
     C                   EVAL      W4BRCH = C1_BRCA
     C                   EVAL      W4SYSM = LIBR
     C                   EVAL      W4FUNT = 'CQCOCDD'
     C                   EXSR      SrCQCtrPty
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4DDAT
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4VDAT
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4MDAT
     C                   EVAL      W4Den1 = C1_CRCY
     C                   MOVE      C1_CCYAM      PInAmt
     C                   EVAL      PCurr = W4DEN1
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4Amt1 = PAMFlot
     C                   EVAL      W4Den2 = PDCY
     C                   MOVE      PDAM          PInAmt
     C                   EVAL      PCurr = W4DEN2
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4Amt2 = PAMFlot
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCQCtrPty - Setup Counterparty Details for CheqColl         *
      *                                                               *
      *****************************************************************
 
     C     SrCQCtrPty    BEGSR
 
      ** Initialise Counterparty fields
 
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
 
     C                   IF        COB1 <> *BLANKS or COB2 <> *BLANKS
     C                             or COB3 <> *BLANKS or COB4 <> *BLANKS
     C                   EVAL      PInput1 = COB1
     C                   EVAL      PInput2 = COB2
     C                   EVAL      PInput3 = COB3
     C                   EVAL      PInput4 = COB4
     C                   EVAL      PInCcy = SMCY
     C                   EXSR      SrConvrt
     C                   ENDIF
     C                   IF        PCOutPut = '*CPART' OR PCOutput <> '*FREE' OR
     C                             (COB1 = *BLANKS and  COB2 = *BLANKS
     C                             and COB3 = *BLANKS and COB4 = *BLANKS)
     C                   MOVE      RCCO          PInput1
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInCcy = SMCY
     C                   EXSR      SrConvrt
     C                   ENDIF
 
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'
     C                   EVAL      W4CNUM = PCOutput
     C                   EVAL      PKey = W4CNUM
     C                   EXSR      SrCtrPtyDetls
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCQProcess - Calling of Engine Program for CheqColl         *
      *                                                               *
      *****************************************************************
 
     C     SrCQProcess   BEGSR
 
      ** Setup second parameter for Compliance Engine Program
 
     C                   EVAL      *IN10 = *OFF
 
     C     PREF          SETLL     CQCOCDD2
     C     PREF          READE     CQCOCDD2                             1010
 
     C                   IF        *IN10 = *ON
     C                   EXSR      SRCQHProcess
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stCQParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
     C                   ENDIF
 
     C                   DOW       *IN10 = *OFF
 
      ** Header
 
     C                   EXSR      SRCQHProcess
 
      ** Cheques Details
 
     C                   IF        COB1 <> *BLANKS or COB2 <> *BLANKS or
     C                             COB3 <> *BLANKS or COB4 <> *BLANKS
     C                   EVAL      Pinput1 = COB1
     C                   EVAL      Pinput2 = COB2
     C                   EVAL      Pinput3 = COB3
     C                   EVAL      Pinput4 = COB4
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(29))
     C                             + %Trim(POutput) + %Trim(ArrWatch(30))
     C                   ENDIF
 
     C                   MOVEL     RCCO          WRCCO
     C                   IF        WRCCO <> *BLANKS
     C                   EVAL      Pinput1 = WRCCO
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(3))
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))
     C                   ENDIF
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stCQParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
     C     PREF          READE     CQCOCDD2                             1010
     C                   ENDDO
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCQHProcess - Calling of Engine Program for CheqColl        *
      *                                                               *
      *****************************************************************
 
     C     SrCQHProcess  BEGSR
 
      ** Header
 
     C                   MOVEL     C1_CRPY       WCRPY
     C                   IF        WCRPY <> *Blanks
     C                   EVAL      Pinput1 = WCRPY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(31))
     C                             + %Trim(POutput) + %Trim(ArrWatch(32))
     C                   ENDIF
 
     C                   IF        C1_NAR1 <> *BLANKS or C1_NAR2 <> *BLANKS or
     C                             C1_NAR3 <> *BLANKS or C1_NAR4 <> *BLANKS or
     C                             C1_NAR5 <> *BLANKS or C1_NAR6 <> *BLANKS
     C                   EVAL      Pinput1 = C1_NAR1
     C                   EVAL      Pinput2 = C1_NAR2
     C                   EVAL      Pinput3 = C1_NAR3
     C                   EVAL      Pinput4 = C1_NAR4
     C                   EVAL      Pinput5 = C1_NAR5
     C                   EVAL      Pinput6 = C1_NAR6
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(33))
     C                             + %Trim(POutput) + %Trim(ArrWatch(34))
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCheqPaid - Parameter formatting for Cheques to be Paid     *
      *                                                               *
      *****************************************************************
 
     C     SrCheqPaid    BEGSR
 
     C                   OPEN      CQPACDD
     C                   OPEN      CQPADDL1
     C                   READ      CQPACDDF                               11
 
     C                   DOW       *IN11 = *Off
 
     C                   IF        RECI = 'D'
 
     C                   EVAL      KFuncType = 'CQPACDD'
     C                   EVAL      KIden = PRef
     C                   EVAL      KBranch = BRCA
 
     C     KFuncKey      ChAIN     SDCWHTL0                           12
 
     C                   IF        *IN12 = *ON
     C                   IF        W1LPCD < W1LUDT
     C                   EXSR      SrCPProcess
     C                   ENDIF
     C                   ELSE
     C                   IF        W3LWCD < W1LUDT
     C                   EXSR      SrCPProcess
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   READ      CQPACDDF                               11
     C                   ENDDO
 
     C                   CLOSE     CQPACDD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stCPParm - Setup first parm for Compliance Engine Program *
      *                                                               *
      *****************************************************************
 
     C     Sr1stCPParm   BEGSR
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EVAL      W4ITEM = 'FTCHQP'
     C                   EVAL      W4IDEN = PREF
     C                   EVAL      W4BRCH = BRCA
     C                   EVAL      W4SYSM = LIBR
     C                   EVAL      W4FUNT = 'CQPACDD'
     C                   EXSR      SrCPCtrPty
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4DDAT
     C                   MOVE      PVDT          PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4VDAT
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4MDAT
     C                   EVAL      W4DEN1 = PCCY
     C                   MOVE      TOTR          PInAmt
     C                   EVAL      PCurr = W4DEN1
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT1 = PAMFlot
     C                   EVAL      W4DEN2 = *BLANKS
     C                   Z-ADD     *ZEROS        W4AMT2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCPCtrPty - Setup Counterparty Details for CheqPaid         *
      *                                                               *
      *****************************************************************
 
     C     SrCPCtrPty    BEGSR
 
      ** Initialise Counterparty fields
 
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
 
     C                   IF        RBK1 <> *BLANKS or RBK2 <> *BLANKS
     C                             or RBK3 <> *BLANKS or RBK4 <> *BLANKS
     C                   EVAL      PInput1 = RBK1
     C                   EVAL      PInput2 = RBK2
     C                   EVAL      PInput3 = RBK3
     C                   EVAL      PInput4 = RBK4
     C                   EVAL      PInCcy = PCCY
     C                   EXSR      SrConvrt
     C                   ENDIF
     C                   IF        PCOutPut = '*CPART' or PCOutput = '*FREE' or
     C                             (RBK1 = *BLANKS and RBK2 = *BLANKS
     C                             and RBK3 = *BLANKS and RBK4 = *BLANKS)
     C                   MOVE      SNCO          PInput1
     C                   EVAL      PInCcy = PCCY
     C                   EXSR      SrConvrt
     C                   ENDIF
 
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'
     C                   EVAL      W4CNUM = PCOutput
     C                   EVAL      PKey = W4CNUM
     C                   EXSR      SrCtrPtyDetls
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCPProcess - Calling of Engine Program for CheqPaid         *
      *                                                               *
      *****************************************************************
 
     C     SrCPProcess   BEGSR
 
     C                   EVAL      *IN13 = *OFF
 
     C     PREF          SETLL     CQPADDD2
     C     PREF          READE     CQPADDD2                             1313
 
     C                   IF        *IN13 = *ON
     C                   EXSR      SRCPHProcess
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stCPParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
     C                   ENDIF
 
     C                   DOW       *IN13 = *OFF
 
      ** Setup second parameter for Compliance Engine Program
 
      ** Header Details
 
     C                   EXSR      SRCPHProcess
 
      ** Cheques Detail
 
     C                   MOVEL     P1_DRPY       WDRPY
     C                   IF        WDRPY <> *BLANKS
     C                   EVAL      Pinput1 = WDRPY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(37))
     C                             + %Trim(POutput) + %Trim(ArrWatch(38))
     C                   ENDIF
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stCPParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
     C     PREF          READE     CQPADDD2                             1313
     C                   ENDDO
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCPHProcess - Calling of Engine Program for CheqPaid        *
      *                                                               *
      *****************************************************************
 
     C     SrCPHProcess  BEGSR
 
      ** Header
 
     C                   IF        RBK1 <> *BLANKS OR RBK2 <> *BLANKS OR
     C                             RBK3 <> *BLANKS OR RBK4 <> *BLANKS
     C                   EVAL      Pinput1 = RBK1
     C                   EVAL      Pinput2 = RBK2
     C                   EVAL      Pinput3 = RBK3
     C                   EVAL      Pinput4 = RBK4
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(35))
     C                             + %Trim(POutput) + %Trim(ArrWatch(36))
     C                   ENDIF
 
     C                   MOVEL     SNCO          WSNCO
     C                   IF        WSNCO <> *BLANKS
     C                   EVAL      Pinput1 = WSNCO
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(11))
     C                             + %Trim(POutput) + %Trim(ArrWatch(12))
     C                   ENDIF
 
     C                   IF        RCO1 <> *BLANKS OR RCO2 <> *BLANKS OR
     C                             RCO3 <> *BLANKS OR RCO4 <> *BLANKS OR
     C                             RCO5 <> *BLANKS
     C                   EVAL      Pinput1 = RCO1
     C                   EVAL      Pinput2 = RCO2
     C                   EVAL      Pinput3 = RCO3
     C                   EVAL      Pinput4 = RCO4
     C                   EVAL      Pinput5 = RCO5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(3))
     C                             + %Trim(POutput) + %Trim(ArrWatch(4))
     C                   ENDIF
 
     C                   IF        ACB1 <> *BLANKS OR ACB2 <> *BLANKS OR
     C                             ACB3 <> *BLANKS OR ACB4 <> *BLANKS OR
     C                             ACB5 <> *BLANKS
     C                   EVAL      Pinput1 = ACB1
     C                   EVAL      Pinput2 = ACB2
     C                   EVAL      Pinput3 = ACB3
     C                   EVAL      Pinput4 = ACB4
     C                   EVAL      Pinput5 = ACB5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(5))
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNosTrans - Parameter formatting for Nostro Transfer        *
      *                                                               *
      *****************************************************************
 
     C     SrNostrans    BEGSR
 
     C                   OPEN      NTRAN
     C                   READ      NTRANDDF                               14
 
     C                   DOW       *IN14 = *OFF
 
     C                   IF        RECI = 'D'
 
     C                   EVAL      KFuncType = 'NTRANDD'
     C                   EVAL      KIden = TFRF
     C                   EVAL      KBranch = BRCA
 
     C     KFuncKey      CHAIN     SDCWHTL0                           12
 
     C                   IF        *IN12 = *ON
     C                   IF        W1LPCD < W1LUDT
     C                   EXSR      SrNTProcess
     C                   ENDIF
     C                   ELSE
     C                   IF        W3LWCD < W1LUDT
     C                   EXSR      SrNTProcess
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PWatchString <> *BLANKS
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EXSR      Sr1stNTParm
 
      ** Send transaction details to Compliance Watch
 
     C                   EXSR      SrWLChk
     C                   ENDIF
 
     C                   READ      NTRANDDF                               14
     C                   ENDDO
 
     C                   CLOSE     NTRAN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr1stNTParm - Setup first parm for Compliance Engine Program *
      *                                                               *
      *****************************************************************
 
     C     Sr1stNTParm   BEGSR
 
      ** Setup first parameter for Compliance Engine Program
 
     C                   EVAL      W4ITEM = 'FTNOST'
     C                   EVAL      W4IDEN = TFRF
     C                   EVAL      W4BRCH = BRCA
     C                   EVAL      W4SYSM = LIBR
     C                   EVAL      W4FUNT = 'NTRANDD'
     C                   EXSR      SrNTCtrPty
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4DDAT
     C                   MOVE      VDAT          PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4VDAT
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W4MDAT
     C                   EVAL      W4DEN1 = CCY
     C                   MOVE      AMNT          PInAmt
     C                   EVAL      PCurr = W4DEN1
     C                   EXSR      SrCvtAmt
     C                   EVAL      W4AMT1 = PAMFlot
     C                   EVAL      W4DEN2 = *BLANKS
     C                   Z-ADD     *ZEROS        W4AMT2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNTCtrPty - Setup Counterparty Details for Nostro Trans     *
      *                                                               *
      *****************************************************************
 
     C     SrNTCtrPty    BEGSR
 
      ** Initialise Counterparty fields
 
     C                   EVAL      W4CNUM = *BLANKS
     C                   EVAL      W4CTYP = *BLANKS
     C                   EVAL      W4CUST = *BLANKS
 
     C                   MOVE      DEST          PInput1
     C                   EVAL      PInCcy = CCY
     C                   EXSR      SrConvrt
 
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'
     C                   EVAL      W4CNUM = PCOutput
     C                   EVAL      PKey = W4CNUM
     C                   EXSR      SrCtrPtyDetls
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNTProcess - Calling of Engine Program for Nostro Transfer  *
      *                                                               *
      *****************************************************************
 
     C     SrNTProcess   BEGSR
 
      ** Setup second parameter for Compliance Engine Program
 
     C                   MOVEL     DEST          WDEST
     C                   IF        WDEST <> *BLANKS
     C                   EVAL      Pinput1 = WDEST
     C                   EVAL      PInCcy = CCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(19))
     C                             + %Trim(POutput) + %Trim(ArrWatch(20))
     C                   ENDIF
 
     C                   MOVEL     ACBN          WACBN
     C                   IF        WACBN <> *BLANKS
     C                   EVAL      Pinput1 = WACBN
     C                   EVAL      PInCcy = CCY
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(5))
     C                             + %Trim(POutput) + %Trim(ArrWatch(6))
     C                   ENDIF
 
     C                   IF        NTINB1 <> *BLANKS OR NTINB2 <> *BLANKS OR
     C                             NTINB3 <> *BLANKS OR NTINB4 <> *BLANKS OR
     C                             NTINB5 <> *BLANKS
     C                   EVAL      Pinput1 = NTINB1
     C                   EVAL      Pinput2 = NTINB2
     C                   EVAL      Pinput3 = NTINB3
     C                   EVAL      Pinput4 = NTINB4
     C                   EVAL      Pinput5 = NTINB5
     C                   EXSR      SrConvrt
     C                   EVAL      PWatchString = %Trim(PWatchString)
     C                             + %Trim(Arrwatch(17))
     C                             + %Trim(POutput) + %Trim(ArrWatch(18))
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCtrPtyDetls - Details of Counterparty                      *
      *                                                               *
      *****************************************************************
 
     C     SrCtrPtyDetls BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PKey
     C                   PARM      *BLANKS       PStatus
     C     SDCUST        PARM      SDCUST        DSFDY
 
      ** If return code not blank, then issue database error
 
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'
     C                   IN        LDA
     C                   EVAL      DBKEY = W4CNUM
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtnCode = *BLANKS
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ELSE
     C                   IF        BBLICD <> *BLANKS and W1IND1 <> BBLICD
     C                             and W1IND2 <> BBLICD and W1IND3 <> BBLICD
     C                             and W1IND4 <> BBLICD and W1IND5 <> BBLICD
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4CUST = BBCRNM + BBCRTN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrConvrt - Convert Customer to Customer Name and Address     *
      *                                                               *
      *****************************************************************
     C     SrConvrt      BEGSR
 
     C                   CALL      'SDCWLFMT'
     C                   PARM                    PRtnCode
     C                   PARM                    PInput1
     C                   PARM                    PInput2
     C                   PARM                    PInput3
     C                   PARM                    PInput4
     C                   PARM                    PInput5
     C                   PARM                    PInput6
     C                   PARM                    PInCcy
     C                   PARM                    POutput
     C                   PARM                    PCOutput
 
      ** Clear variable strings
 
     C                   EVAL      PInput1 = *BLANKS
     C                   EVAL      PInput2 = *BLANKS
     C                   EVAL      PInput3 = *BLANKS
     C                   EVAL      PInput4 = *BLANKS
     C                   EVAL      PInput5 = *BLANKS
     C                   EVAL      PInput6 = *BLANKS
     C                   EVAL      PInCcy = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWLChk - Watch List Check Engine                            *
      *                                                               *
      *****************************************************************
     C     SrWLChk       BEGSR
 
     C                   CALL      'SDWLENGN'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
     C                   PARM                    SDWLTD
     C                   PARM                    PWatchString
 
      ** Error calling SDWLENGN
 
     C                   IF        PRetCode <> *BLANK
     C                   SELECT
 
     C                   WHEN      PRetCode = '*ERROR '
     C                   EVAL      WDBASE = 7
 
     C                   WHEN      PRetCode = '*FOFEXE'
     C                   EVAL      WDBASE = 8
     C                   EVAL      PMsgId = 'USR9680'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*SRVNAM'
     C                   EVAL      WDBASE = 9
     C                   EVAL      PMsgId = 'USR9681'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*DBNAME'
     C                   EVAL      WDBASE = 10
     C                   EVAL      PMsgId = 'USR9682'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*USRNAM'
     C                   EVAL      WDBASE = 11
     C                   EVAL      PMsgId = 'USR9683'
     C                   EXSR      SRSndErr
 
     C                   WHEN      PRetCode = '*PASSWD'
     C                   EVAL      WDBASE = 12
     C                   EVAL      PMsgId = 'USR9684'
     C                   EXSR      SRSndErr
 
     C                   OTHER
     C                   EVAL      PMsgId = 'USR9685'
     C                   EXSR      SRSndErr
     C                   ENDSL
 
      ** Perform database error either of the following return code is true
 
     C                   IF        PRetCode = '*ERROR ' OR
     C                             PRetCode = '*FOFEXE' OR
     C                             PRetCode = '*SRVNAM' OR
     C                             PRetCode = '*DBNAME' OR
     C                             PRetCode = '*USRNAM' OR
     C                             PRetCode = '*PASSWD'
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = WDBASE
     C                   EVAL      DBKey = SDWLTD
     C                   EVAL      DBFile = 'SDWLENGN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Initialise Parameters
 
     C                   EVAL      SDWLTD = *BLANKS
     C                   EVAL      PWatchString = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      *  SrCvtDate - Convert dates to be used for Watch Engine Pgm    *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BEGSR
 
     C                   CALL      'ZACVTDATE'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PInDate
     C                   PARM                    PAMDate
     C                   PARM                    POutDate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      *  SrCvtAmt - Convert amountst for Watch Engine Program         *
      *                                                               *
      *****************************************************************
     C     SrCvtAmt      BEGSR
 
     C                   CALL      'ZACVTAMT'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM                    PCurr
     C                   PARM                    PInAmt
     C                   PARM                    PAMFlot
     C                   PARM                    POutAmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndErr - Send error message to *SYSOPR                      *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    RetCodeOut
     C                   PARM      'SD000016'    PMsgs
     C                   PARM                    PMsgId
     C                   PARM      'GBSDUSRMSG'  PMsgF
     C                   PARM      'MOPERQ    '  PMsgQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtnCode
     C                   PARM      '*FIRST '     POption
     C     SDBank        PARM      SDBank        DSFDY
 
      ** Database Error
 
     C                   IF        PRtnCode <> *BLANKS
     C                   IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = POption
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if 24x7 Enhancement (CSC011) is installed
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'
     C                   IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   ENDIF
     C
     C                   IN        SDSTAT
 
      ** Check for Watch List Configuration Data File
 
     C                   CALLB     'AOCWCDR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST'      POption
     C     SDCWCD        PARM      SDCWCD        DSFDY
 
      ** If return code not blank, then issue database error
 
     C                   IF        PRtnCode <> *BLANKS AND PRtnCode <> '*NRF'
     C                   IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key list for SDCWHTL0
 
     C     KFuncKey      KLIST
     C                   KFLD                    KFuncType
     C                   KFLD                    KIden
     C                   KFLD                    KBranch
 
      ** Initialise indicators
 
     C                   MOVEA     '0000000000'  *IN(01)
     C                   MOVEA     '0000'        *IN(11)
 
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
      ** Close connection with the server
 
     C                   CALL      'SDOFACCL'
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    PSrvContext
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
**  ArrWatch
<Sender>
</Sender>
<Receiver's Correspondent>
</Receiver's Correspondent>
<Account With Institution>
</Account With Institution>
<Beneficiary>
</Beneficiary>
<Ordering Bank>
</Ordering Bank>
<Sender's Correspondent>
</Sender's Correspondent>
<Ordering Customer>
</Ordering Customer>
<Details of Payment>
</Details of Payment>
<Intermediary>
</Intermediary>
<Destination>
</Destination>
<MT100 Customer>
</MT100 Customer>
<Instructing Party>
</Instructing Party>
<Accnt Servicing Institution>
</Accnt Servicing Institution>
<Remittance Information>
</Remittance Information>
<Collecting Bank>
</Collecting Bank>
<Credit Party>
</Credit Party>
<Narrative>
</Narrative>
<Remitting Bank>
</Remitting Bank>
<Debit Party>
</Debit Party>
<Third Reimbursement Inst>
</Third Reimbursement Inst>
<Sending Institution>
</Sending Institution>
<Ordering Institution>
</Ordering Institution>
