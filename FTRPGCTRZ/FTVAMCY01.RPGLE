     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Transfer Amount and Currency')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVAMCY01  - Validate Transfer Amount                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034751           Date 22Jun15               *
      *                 MD000091           Date 07May13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 01Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3281            Date 17Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 212229             Date 02Apr04               *
      *                 221761             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 221929             Date 07Oct03               *
      *                 220004             Date 24Jul03               *
      *                 CRE008             Date 19Feb02               *
      *                 205011             Date 17Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 01Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034751 - Serious Midas Error on completion of details for  *
      *             RFTD-Incoming when OrdCust1 in Header is          *
      *             "/Customer Number"                                *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3281 - Discrepancies on sources                           *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  212229 - System accepts the transfer currency even if it is  *
      *           different from the currency of the account entered  *
      *           in the ordering customer field.                     *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  221929 - Decimal data error on authorisation                 *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CRE008 - Cash Management                                     *
      *  205011 - Check that transfer currency is the ordering        *
      *           customer's (header) account currency                *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
      *                                                               *
      *****************************************************************
 
      * RFT Detail file (keyed on RFTID)
     FFT101DL2  IF   E           K Disk    INFSR(*PSSR)
                                                                                              CGL014
      ** RE Shadow balances file                                                              CGL014
     FMEMOSL2   IF   E           K DISK    INFSR(*PSSR)                                       CGL014
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              CRE008
      ** Externally described DS for SAR details                                              CRE008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE008
     D   SLCD        E                     EXTFLD(LCD)                                        CRE008
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Incoming account details from access objects
     D AccRecord     E DS                  EXTNAME(ACCNTAB)
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
     D C@FMT         E DS                  EXTNAME(SDCUSTPD)
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * OK Flags for second screen
     D OKFlags       E DS                  EXTNAME(FTE101S2PD)
 
      * DS to split account identifier into components
     D AccntCode       DS
     D  CustNo                 1      6
     D  P@CYCD                 7      9
     D***P@ACCD*               10     13                                                      CGL029
     D***P@ACSN*               14     15                                                      CGL029
     D***P@BRCA*               16     18                                                      CGL029
     D  P@ACCD                10     19                                                       CGL029
     D  P@ACSN                20     21                                                       CGL029
     D  P@BRCA                22     24                                                       CGL029
 
      * DS to split account identifier into components
     D WorkAccId       DS
     D**W#CNUM**               1      6  0                                                    CSD027
     D  W#CNUM                 1      6                                                       CSD027
     D  W#CCY                  7      9
     D***W#ACOD*               10     13  0                                                   CGL029
     D***W#ACSQ*               14     15  0                                                   CGL029
     D***W#BRCA*               16     18                                                      CGL029
     D  W#ACOD                10     19  0                                                    CGL029
     D  W#ACSQ                20     21  0                                                    CGL029
     D  W#BRCA                22     24                                                       CGL029
 
      ** DS to combine nostro account components                                              212229
     D WorkNost        DS                                                                     212229
     D  N#BRCA                 1      3                                                       212229
     D  N#CNUM                 4      9                                                       212229
     D  N#CCY                 10     12                                                       212229
     D  N#ACOD                13     16                                                       212229
     D  N#ACSQ                17     18                                                       212229
      ** Define full account details                                                          CRE008
     D***WkORCDS         DS            18                                              CRE008 CGL029
     D WkORCDS         DS                                                                     CGL029
     D   WkBRCA                1      3                                                       CRE008
     D***WkCNUM*               4      9  0                                             CRE008 CSD027
     D   WkCNUM                4      9                                                       CSD027
     D   WkCCY                10     12                                                       CRE008
     D***WkACOD*              13     16  0                                             CRE008 CGL029
     D***WkACSQ*              17     18  0                                             CRE008 CGL029
     D   WkACOD               13     22  0                                                    CGL029
     D   WkACSQ               23     24  0                                                    CGL029
                                                                                              CRE008
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
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** Numeric version of Transfer Amount
     D NumTRNAMT       S             15P 0
 
      ** CFT004 switchable feature flag
     D CFT004          S              1A
 
      ** Entry in Ordering Customer field
     D*W#OrdCust*******S             34A                                                      205011
     D W#OrdCust       S             35A                                                      205011
 
      ** Field to save Ledger Balance of account entered in Ordering Cust.
     D SaveLDBL        S                   LIKE(LDBL)
 
      ** Field to save Account Id of account entered in Ordering Cust.
     D***SaveAccnt       S             18                                                     CGL029
     D SaveAccnt       S             24                                                       CGL029
 
      ** Total of Transfer Amounts for all transactions in on RFTID.
     D Total           S             15P 0
 
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
      *                                                                                       CSW207
      ** SWIFT 2007 switchable feature                                                        CSW207
      *                                                                                       CSW207
     D CSW207          S              1A                                                      CSW207
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PRTCD           S              7                                                       CGL014
     D POPTN           S              7                                                       CGL014
     D PSARD           S              6                                                       CGL014
     D WAmount         S             15  0                                                    CGL014
     D WrkCLBLN        S             15  0                                                    CGL014
     D WTranAmt        S             15  0                                                    CGL014
                                                                                              CSW201
      ** Parameters used for call to RE101901                                                 CRE008
     D PRetCode        S              7                                                       CRE008
     D PInBranch       S              3                                                       CRE008
     D*PInCust**       S              6  0                                             CRE008 CSD027
     D PInCust         S              6                                                       CSD027
     D PInCurr         S              3                                                       CRE008
     D***PInACode        S              4  0                                           CRE008 CGL029
     D PInACode        S             10  0                                                    CGL029
     D PInASeqN        S              2  0                                                    CRE008
     D PDebAmnt        S             15  0                                                    CRE008
     D POutBranch      S              3                                                       CRE008
     D*POutCust*       S              6  0                                             CRE008 CSD027
     D POutCust        S              6                                                       CSD027
     D POutCurr        S              3                                                       CRE008
     D***POutACode       S              4  0                                           CRE008 CGL029
     D POutACode       S             10  0                                                    CGL029
     D POutASeqN       S              2  0                                                    CRE008
     D POutRetNo       S             10  0                                                    CRE008
                                                                                              CRE008
     D***WkACodeC        S              4                                              CRE008 CGL029
     D WkACodeC        S             10                                                       CGL029
     D WkASeqNC        S              2                                                       CRE008
     D WkCustC         S              6                                                       CRE008
     D WkRetNoC        S             10                                                       CRE008
     D WAcctType       S              1                                                       CRE008
     D WDebAmnt        S             15  0                                                    CRE008
                                                                                              CRE008
     D CRE008          S              1                                                       CRE008
                                                                                              CRE008
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
     C                   EVAL      OKTRAM     = 'Y'
     C                   EVAL      OKTRCY     = 'Y'
      *
      ** Reset work fields
      *
     C                   EVAL      ZALIGNok = 'Y'
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZADEC = *Zero
     C                   EVAL      ZADIG = *Zero
     C                   EVAL      NumTRNAMT = *Zero
     C                   EVAL      AccntCode = *Blanks
      *
     C                   EXSR      Validate
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validate fields                                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Validate      BEGSR
      *
      ** Both the Transfer Amount and Transfer Currency are mandatory
      *
     C                   IF        PTRNAMT = *Blanks
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Outgoing Request for Transfers,                       CSW201
      ** Transfer Amount may be left blank and will be set to zero.                           CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND PPTYP = 'RO'                              CSW201
     C                   MOVE      '0'           PTRNAMT                                      CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVE      'N'           OKTRAM
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0144'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C**********         ELSE                                                                 CSW201
      *
     C                   IF        PTRNAMT <> *BLANKS                                         CSW201
      *                                                                                       CSW201
     C                   IF        PTRNCCY = *Blanks
     C                   MOVE      'N'           OKTRCY
     C                   ADD       1             Idx
     C                   MOVEL     'PTRNCCY'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0148'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** Currency must be valid on the system
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PTRNCCY       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @Rtcd <> *Blanks
     C                   MOVE      'N'           OKTrCy
     C                   ADD       1             Idx
     C                   MOVEL     'PTrnCcy'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0147'     MsgIdXAr(Idx)
     C                   ELSE
                                                                                              205011
      ** Transfer ccy must be equal to the Ordering Customer's ccy (header).                  205011
                                                                                              205011
     C                   IF        PHOCUS1 <> *BLANKS                                         205011
     C                   EVAL      W#OrdCust = PHOCUS1                                        205011
     C                   EXSR      ValAccnt                                                   205011
                                                                                              205011
     C                   IF        (P@TYPE = '*LEDGER'  OR                                    205011
     C                              P@TYPE = '*RETAIL'  OR                                    205011
     C                              P@TYPE = '*NOSTRO')  AND  PTRNCCY <> W#CCY                205011
     C                   EVAL      OKTRCY = 'N'                                               205011
     C                   EVAL      Idx = Idx + 1                                              205011
     C                   EVAL      FldNamXAr(Idx) = 'PTRNCCY'                                 205011
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0702'                                  205011
     C                   GOTO      EndValidate                                                205011
     C                   ENDIF                                                                205011
     C                   ENDIF                                                                205011
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Customer Reference is entered,                        CSW201
      ** retrieve the Transfer Currency of the first detail record of                         CSW201
      ** the transaction using LF/FT101DL2.                                                   CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND PCUSTRF <> *BLANKS                        CSW201
     C     PRFTHDR       SETLL     FT101DL2                                                   CSW201
     C     PRFTHDR       READE     FT101DL2                               80                  CSW201
      *                                                                                       CSW201
     C                   IF        NOT *IN80                                                  CSW201
      *                                                                                       CSW201
      ** Transaction Currency of first record must be equal to the                            CSW201
      ** Transaction Currency entered.                                                        CSW201
      *                                                                                       CSW201
     C                   IF        TRNCCY <> PTrnCcY                                          CSW201
     C                   EVAL      OKTrCy = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PTrnCcy'                                 CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0500'                                  CSW201
     C                   GOTO      EndValidate                                                CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *
     C                   EVAL      PTrnCcy = A6CYCD                             ************
      *
      ** (Format amount field and ZADIG)
      *
     C                   MOVE (P)  PTrnAmt       ZFIELD                         ************
     C                   EVAL      ZADIG = 15 - A6NBDP                          ************
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
      ** Transfer Amount must be in correct format for this currency
      *
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKTram
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0149'     MsgIdXAr(Idx)
     C                   ELSE
                                                                                              CRE008
     C                   MOVE(P)   ZFIELD        WDebAmnt                                     CRE008
      *
      ** If no error in Amount, ensure it is greater than zero
      *
     C                   MOVE      ZFIELD        NumTRNAMT
     C                   IF        NumTRNAMT <= 0
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and Outgoing Request for Transfers,                       CSW201
      ** bypass generation of error when Transfer Amount is zero.                             CSW201
      *                                                                                       CSW201
     C**********         IF        CSW201 = 'N' OR PPTYP <> 'RO'                       CSW201 CSW207
     C*********                    OR NumTRNAMT < 0                                    CSW201 CSW207
     C                   IF        (CSW207 = 'N' And (CSW201 = 'N'                            CSW207
     C                             OR PPTYP <> 'RO'                                           CSW207
     C                             OR NumTRNAMT < 0))                                         CSW207
     C                   MOVE      'N'           OKTRAM
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0150'     MsgIdXAr(Idx)
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C**********         ELSE                                                                 CSW201
     C                   ENDIF                                                                CSW201
      *
      ** If Amount is OK format entry to aprropriate decimal places.
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      ZFIELD        PTRNAMT
      *
     C**********         ENDIF                                                                CSW201
      *
      ** If Ordering Customer was entered in header record, need to check
      ** that sufficient funds exist in the account specified therein for
      ** this Transfer Amount.
      *
     C                   IF        PPTyp = 'RI'
     C                   IF        PHOCUS1 <> *Blanks
     C*******************EVAL      W#OrdCust = PHOCUS1
     C                   MOVE      PHOCUS1       W#OrdCust
     C                   EXSR      ValAccnt
     C                   MOVE      *BLANK        WTRNCCY           3                          212229
     C                   MOVE      W#CCY         WTRNCCY                                      212229
     C     WTRNCCY       IFNE      PTRNCCY                                                    212229
     C     CSW207        ANDEQ     'N'                                                        CSW207
     C                   MOVE      'N'           OKTRCY                                       212229
     C                   ADD       1             Idx                                          212229
     C                   MOVEL     'PTRNCCY'     FldNamXAr(Idx)                               212229
     C                   MOVEL     'RFV0600'     MsgIdXAr(Idx)                                212229
     C                   ENDIF                                                                212229
      *
     C                   IF        P@TYPE <> '*NRF'
     C                   IF        P@TYPE = '*LEDGER' OR                                    MD034751
     C                             P@TYPE = '*RETAIL'                                       MD034751
     C                   IF        LDBL - NumTRNAMT < 0
     C                   MOVE      'W'           OKTRAM
     C                   ADD       1             WIx
     C                   MOVEL     DDSName       WFldNmXAr(WIx)
     C                   MOVEL     'RFV0141'     WMsgIdXAr(WIx)
     C                   ENDIF
     C                   ENDIF                                                              MD034751
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'  AND  ATYP = 'R'  AND                         CGL014
     C                             COLF = 'Y'                                                 CGL014
     C                   EVAL      WTranAmt = NumTRNAMT                                       CGL014
     C                   EXSR      ValBlocking                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CRE008
      ** If CRE008 is on and account is retail, check the account's overdraft limit.          CRE008
                                                                                              CRE008
     C                   IF        CRE008 = 'Y'  AND  WAcctType = 'R'                         CRE008
     C                   EVAL      PDebAmnt = WDebAmnt                                        CRE008
                                                                                              CRE008
      ** Ordering Customer is in "header", so debit amount is                                 CRE008
      ** the sum of the details' trasfer amounts.                                             CRE008
                                                                                              CRE008
     C     PRFTHDR       SETLL     FT101DL2                                                   CRE008
     C     PRFTHDR       READE     FT101DL2                                                   CRE008
                                                                                              CRE008
     C                   DOW       NOT %EOF(FT101DL2)                                         CRE008
                                                                                              CRE008
     C                   IF        TRNSID <> PTRNSID                                          CRE008
     C                   EVAL      PDebAmnt = PDebAmnt + TRNAMT                               CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C     PRFTHDR       READE     FT101DL2                                                   CRE008
     C                   ENDDO                                                                CRE008
                                                                                              CRE008
     C                   EXSR      SRODLChk                                                   CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDIF
      *
      ** If Ordering Customer was entered in detail record, need to find all
      ** the detail records with the same Ordering Customer and make sure
      ** that the sum of all the Transfer Amounts does not exceed the Ledger
      ** Balance of the Ordering Customer's account.  Bypass this process
      ** if Ordering Customer is blank on screen 1.
      *
     C                   ELSE
      *
     C                   IF        POCUS1 <> *Blanks
      *
      ** First, get ledger balance of Ordering Customer from screen 1.
      ** Save the Ledger Balance of the account entered.  Zeroise total.
      *
     C                   MOVE      POCUS1        W#OrdCust
     C                   EXSR      ValAccnt
      *
     C                   IF        P@TYPE <> '*NRF'
     C                   EVAL      SaveLDBL = LDBL
     C                   EVAL      SaveAccnt = WorkAccId
     C                   EVAL      Total = *Zero
      *
      ** Read all records with current RFT Id.  Convert their Ordering
      ** Customer account to full 18 char account Id.  Save this and
      ** the corresponding Transfer Amount to an array.
      *
     C     PRFTID        SETLL     FT101DL2
     C                   READ      FT101DL2                               80
     C                   DOW       *IN80 = *Off
      *
      ** Obtain account Id in full GL format
      *
     C                   MOVE      TOCUS1        W#OrdCust
     C                   EXSR      ValAccnt
      *
      ** If account Id matches the one entered in Ordering Customer, add the
      ** Transaction Amount to the total.
      *
     C                   IF        SaveAccnt = WorkAccId
     C                   EVAL      Total = Total + TRNAMT
     C                   ENDIF
      *
     C     PRFTID        READE     FT101DL2                               80
     C                   ENDDO
      *
      ** Add on the Transfer Amount of the record on-screen.  If the grand
      ** total is greater than the Ledger Balance - warning error.
      *
     C                   EVAL      Total = Total + NumTRNAMT
      *
     C                   IF        Total > SaveLDBL
     C                   MOVE      'W'           OKTRAM
     C                   ADD       1             WIx
     C                   MOVEL     DDSName       WFldNmXAr(WIx)
     C                   MOVEL     'RFV0141'     WMsgIdXAr(WIx)
     C                   ENDIF
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'  AND  ATYP = 'R'  AND                         CGL014
     C                             COLF = 'Y'                                                 CGL014
     C                   EVAL      WTranAmt = Total                                           CGL014
     C                   EXSR      ValBlocking                                                CGL014
     C                   ENDIF                                                                CGL014
      *
                                                                                              CRE008
      ** If CRE008 is on and account is retail, check the account's overdraft limit.          CRE008
      ** Ordering Customer is in "detail", so debit amount is the transfer amount.            CRE008
                                                                                              CRE008
     C                   IF        CRE008 = 'Y'  AND  WAcctType = 'R'                         CRE008
     C                   EVAL      PDebAmnt = WDebAmnt                                        CRE008
     C                   EXSR      SRODLChk                                                   CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C**********         ENDSR                                                                CSW201
     C     EndValidate   ENDSR                                                                CSW201
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAccnt - Retreive details of account entered in Ordering    *
      *            Customer (header) field.                           *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
      *
     C     ValAccnt      BEGSR
      *
     C                   CLEAR                   AccRecord                      O:ACCNT Format
      *
     C**********         MOVEL     W#OrdCust     W#ChkCust        34                          205011
     C                   MOVEL     W#OrdCust     W#ChkCust        35                          205011
      *
      ** If CFT004 present, IBANs are allowed.  Else send dummy return code.
      *
     C                   IF        CFT004 = 'Y'
      *
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       IBANRetCde        7            B:Return code
     C**********         PARM      W#OrdCust     P@IBAN           34            I:Option      212229
     C                   PARM      W#ChkCust     P@IBAN           34            I:Option      212229
     C                   PARM      *Blanks       AccRecord                      O:Data Structure
      *
     C                   ELSE
     C                   MOVEL     'Dummy'       IBANRetCde        7            B:Return code
     C                   MOVEL     *Blanks       P@IBAN           34            I:Option
     C                   ENDIF                                                  I:Option
      *
     C                   CALLB     'AOACCTV1'
     C                   PARM                    ACCTRetCde        7
     C                   PARM                    P@TYPE            7
     C**********         PARM                    W#ChkCust                                    212229
     C                   PARM                    W#OrdCust                                    212229
     C                   PARM                    DSSDY
      *
     C                   SELECT
 
     C                   WHEN      P@TYPE = '*NOSTRO'
     C                   CLEAR                   ACCRECORD                      221929
     C                   EVAL      N@FMT = DSSDY
     C                   EVAL      W#CCY  = A7CYCD                              O:ACCNT Format
     C                   EVAL      CCY    = A7CYCD                              O:ACCNT Format
     C                   MOVEL     A7ACCD        W#ACOD
     C                   EVAL      W#ACSQ = 01                                  O:ACCNT Format
     C                   EVAL      W#BRCA = A7BRCD                              O:ACCNT Format
     C                   MOVEL     A7CUST        W#CNUM
     C                   MOVEL     A7CUST        N#CNUM                                       212229
     C                   MOVEL     A7BRCD        N#BRCA                                       212229
     C                   MOVEL     A7CYCD        N#CCY                                        212229
     C                   MOVEL     A7ACCD        N#ACOD                                       212229
     C                   MOVEL     A7ACSN        N#ACSQ                                       212229
     C                   MOVEL     *BLANKS       WorkNost1        35                          212229
     C                   MOVEL     WorkNost      WorkNost1                                    212229
     C                   CALLB     'AOACCTV1'                                                 212229
     C                   PARM                    ACCTRetCde                                   212229
     C                   PARM                    P@TYPE                                       212229
     C                   PARM                    WorkNost1                                    212229
     C                   PARM                    DSSDY                                        212229
     C     P@TYPE        IFEQ      '*LEDGER'                                                  212229
     C                   MOVEL     DSSDY         ACCRECORD                                    212229
     C                   MOVEL     '*NOSTRO'     P@TYPE                                       212229
     C                   ENDIF                                                                212229
 
     C                   WHEN      P@TYPE = '*RETAIL'
     C                   EVAL      ACCRECORD = DSSDY
     C                   EVAL      W#CCY  = CCY                                 O:ACCNT Format
     C                   EVAL      W#ACOD = ACOD                                O:ACCNT Format
     C                   EVAL      W#ACSQ = ACSQ                                O:ACCNT Format
     C                   EVAL      W#BRCA = BRCA                                O:ACCNT Format
     C                   EVAL      W#CNUM = CNUM
 
     C                   WHEN      P@TYPE = '*LEDGER'
     C                   Eval      ACCRECORD = DSSDY
     C                   EVAL      W#CCY  = CCY                                 O:ACCNT Format
     C                   EVAL      W#ACOD = ACOD                                O:ACCNT Format
     C                   EVAL      W#ACSQ = ACSQ                                O:ACCNT Format
     C                   EVAL      W#BRCA = BRCA                                O:ACCNT Format
     C                   EVAL      W#CNUM = CNUM
     C                   ENDSL
      *
                                                                                              CRE008
      ** If CRE008 is on and account is retail, set up full account details.                  CRE008
                                                                                              CRE008
     C                   EVAL      WkORCDS = *BLANKS                                          CRE008
     C                   EVAL      WAcctType = *BLANK                                         CRE008
                                                                                              CRE008
     C                   IF        CRE008 = 'Y'  AND                                          CRE008
     C                             (P@TYPE = '*RETAIL'  OR  P@TYPE = '*LEDGER')               CRE008
     C     1             SUBST     DSSDY:26      WAcctType                                    CRE008
                                                                                              CRE008
      ** Set up full account details: BRCA, CNUM, CCY, ACOD, ACSQ.                            CRE008
                                                                                              CRE008
     C                   EVAL      WkORCDS = %SUBST(DSSDY:23:3) +                             CRE008
     C                                       %SUBST(DSSDY:2:6)  +                             CRE008
     C                                       %SUBST(DSSDY:8:3)  +                             CRE008
     C                                       %SUBST(DSSDY:554:10) +                           CGL029
     C**********                             %SUBST(DSSDY:11:4) +                      CRE008 CGL029
     C                                       %SUBST(DSSDY:15:2)                               CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CRE008
      *                                                               *                       CRE008
      *  SRODLChk - Overdraft Limit Check                             *                       CRE008
      *                                                               *                       CRE008
      *****************************************************************                       CRE008
                                                                                              CRE008
     C     SRODLChk      BEGSR                                                                CRE008
                                                                                              CRE008
     C                   EVAL      PInBranch = WkBRCA                                         CRE008
     C                   EVAL      PInCust   = WkCNUM                                         CRE008
     C                   EVAL      PInCurr   = WkCCY                                          CRE008
     C                   EVAL      PInACode  = WkACOD                                         CRE008
     C                   EVAL      PInASeqN  = WkACSQ                                         CRE008
                                                                                              CRE008
     C                   CALLB     'RE101901'                                                 CRE008
                                                                                              CRE008
      ** Return Code                                                                          CRE008
                                                                                              CRE008
     C                   PARM      *BLANKS       PRetCode                                     CRE008
                                                                                              CRE008
      ** Input parameters                                                                     CRE008
      ** ----------------                                                                     CRE008
                                                                                              CRE008
      ** Branch Code                                                                          CRE008
      ** Customer                                                                             CRE008
      ** Currency                                                                             CRE008
      ** Account Code                                                                         CRE008
      ** Account Sequence                                                                     CRE008
      ** Debit Amount (Payment Amount)                                                        CRE008
                                                                                              CRE008
     C                   PARM                    PInBranch                                    CRE008
     C                   PARM                    PInCust                                      CRE008
     C                   PARM                    PInCurr                                      CRE008
     C                   PARM                    PInACode                                     CRE008
     C                   PARM                    PInASeqN                                     CRE008
     C                   PARM                    PDebAmnt                                     CRE008
                                                                                              CRE008
      ** Ouput parameters                                                                     CRE008
      ** ----------------                                                                     CRE008
                                                                                              CRE008
      ** Branch                                                                               CRE008
      ** Customer                                                                             CRE008
      ** Currency                                                                             CRE008
      ** Account Code                                                                         CRE008
      ** Account Sequence                                                                     CRE008
      ** Retail Account No. of account in error                                               CRE008
                                                                                              CRE008
     C                   PARM                    POutBranch                                   CRE008
     C                   PARM                    POutCust                                     CRE008
     C                   PARM                    POutCurr                                     CRE008
     C                   PARM                    POutACode                                    CRE008
     C                   PARM                    POutASeqN                                    CRE008
     C                   PARM                    POutRetNo                                    CRE008
                                                                                              CRE008
      ** If overdraft limit exceeded, send warning message.                                   CRE008
                                                                                              CRE008
     C                   IF        PRetCode = '*ODLMTX'                                       CRE008
     C                   EVAL      OKTRAM = 'W'                                               CRE008
     C                   EVAL      WIx = WIx + 1                                              CRE008
     C                   EVAL      WMsgIDXAr(WIx) = 'FTA0131'                                 CRE008
     C                   EVAL      WFldNmXAr(WIx) = DDSName                                   CRE008
     C                   MOVE      POutCust      WkCustC                                      CRE008
     C                   MOVE      POutACode     WkACodeC                                     CRE008
     C                   MOVE      POutASeqN     WkASeqNC                                     CRE008
     C                   MOVE      POutRetNo     WkRetNoC                                     CRE008
                                                                                              CRE008
     C                   IF        POutRetNo = 0                                              CRE008
     C**********         EVAL      WMsgDtXAr(WIx) = POutBranch + '-' +  WkCustC      CRE008 MD000091
     C**********                    + '-' + POutCurr + '-' + WkACodeC                CRE008 MD000091
     C**********                    + '-' + WkASeqNC                                 CRE008 MD000091
     C                   EVAL      MsgDtaTmp = POutBranch + '-' +  WkCustC                  MD000091
     C                              + '-' + POutCurr + '-' + WkACodeC                       MD000091
     C                              + '-' + WkASeqNC                                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSE                                                                 CRE008
     C**********         EVAL      WMsgDtXAr(WIx) = POutBranch + '-' +  WkCustC      CRE008 MD000091
     C**********                    + '-' + POutCurr + '-' + WkACodeC                CRE008 MD000091
     C**********                    + '-' + WkASeqNC + '/' + WkRetNoC                CRE008 MD000091
     C                   EVAL      MsgDtaTmp = POutBranch + '-' +  WkCustC                  MD000091
     C                              + '-' + POutCurr + '-' + WkACodeC                       MD000091
     C                              + '-' + WkASeqNC + '/' + WkRetNoC                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF                                                                CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDSR                                                                CRE008
                                                                                              CRE008
      *****************************************************************                       CRE008
     C/EJECT                                                                                  CRE008
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  ValBlocking - Further validation for sufficient funds        *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
                                                                                              CGL014
     C     ValBlocking   BEGSR                                                                CGL014
                                                                                              CGL014
      ** Access MEMOS for the shadow cleared balance                                          CGL014
                                                                                              CGL014
     C     ACNO          CHAIN     MEMOSL2                                                    CGL014
                                                                                              CGL014
     C                   IF        %FOUND(MEMOSL2)                                            CGL014
     C                   Z-SUB     CLBLN         WrkCLBLN                                     CGL014
     C                   EVAL      WAmount = WrkCLBLN - WTranAmt                              CGL014
                                                                                              CGL014
      ** Error:  Available balance is not sufficient                                          CGL014
      ** to cover blocked amount                                                              CGL014
                                                                                              CGL014
     C                   IF        WAmount < BCOA                                             CGL014
     C                   EVAL      OKTRAM = 'N'                                               CGL014
     C                   ADD       1             Idx                                          CGL014
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CGL014
     C                   EVAL      MsgIdXAr(Idx) = 'FTA0140'                                  CGL014
     C                   ELSE                                                                 CGL014
                                                                                              CGL014
      ** Warning:  Balance is greater than blocked amount but less                            CGL014
      ** than minimum balance; minimum balance will be exceeded                               CGL014
                                                                                              CGL014
     C**********         IF        WAmount < MINB                                     CGL014 BUG3281
     C                   IF        WAmount < COLA                                            BUG3281
     C                   EVAL      OKTRAM = 'W'                                               CGL014
     C                   ADD       1             WIx                                          CGL014
     C                   EVAL      WFldNmXAr(WIx) = DDSName                                   CGL014
     C                   EVAL      WMsgIdXAr(WIx) = 'FTA0141'                                 CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
                                                                                              CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      ** Screen fields
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlags
      ** Access SAR file to see if CFT004 is present
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT004'      @SARD             6
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *Blank
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
      *
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      CFT004 = 'N'
     C                   ELSE
      *
      ** Database Error
      *
     C                   Eval      DBKey  =  CFT004
     C                   Eval      DBFile = 'AOSARDR0'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 1
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
                                                                                              CRE008
      ** Check if switchable feature CRE008 is on.                                            CRE008
                                                                                              CRE008
     C                   CALLB     'AOSARDR0'                                                 CRE008
     C                   PARM      *BLANKS       @RTCD                                        CRE008
     C                   PARM      '*VERIFY'     @OPTN                                        CRE008
     C                   PARM      'CRE008'      @SARD                                        CRE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
                                                                                              CRE008
      ** Database error.                                                                      CRE008
                                                                                              CRE008
     C                   IF        @RTCD <> *BLANKS AND                                       CRE008
     C                             @RTCD <> '*NRF   '                                         CRE008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE008
     C                   EVAL      DBASE = 6                                                  CRE008
     C                   EVAL      DBKEY = 'CRE008'                                           CRE008
     C                   EXSR      *PSSR                                                      CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   IF        @RTCD = *BLANKS                                            CRE008
     C                   EVAL      CRE008 = 'Y'                                               CRE008
     C                   ELSE                                                                 CRE008
     C                   EVAL      CRE008 = 'N'                                               CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 2                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *Blanks       PRTCD                                        CSW207
                                                                                              CSW207
     C                   IF        PRTCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
                                                                                              CRE008
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
