     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA AML settlement extract for SE module')        *
      *****************************************************************
      *                                                               *
      *  Midas - Common Programs                                      *
      *                                                               *
      *  ZAAMLSETSE - AML Settlement Extract for Securities Module    *
      *                                                               *
      *  Function:  This program will be used to ectract the          *
      *             Securities settlement fields to be used in        *
      *             Account History export in AML.                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL020  *CREATE    Date 08Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL020 - Compliance Watch - Addtl A/C Postings Information   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initial procesing                                    *
      * SRINIT - Initialize variables                                 *
      * SRORIGIN - Format Pay/Receipt Origin fields                   *
      * SRDEST - Format Destination Accnt,Country & Destination Bank  *
      * SRDetAcctTyp - Determine Account Type                         *
      * SRCustomer - Get Customer Details                             *
      * SRNostro - Get Nostro Details                                 *
      * SRRetail - Get Retail Account Details                         *
      * SRCntrNostro - Get Counterparty Nostro details                *
      * SRLocation - Get Location Code Details                        *
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External DS for Nostro Details
 
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      ** External DS for Account Details
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** External DS for Counterparty Nostro
 
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      ** External DS for Location Codes
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Objects
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access objects Parameters
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Access Object Customer
     D PKEY1           S             10
     D PKYST           S              7
 
      ** Access Object Nostro
     D PCUST           S              6
     D PCYCD           S              3
     D*PACCN****       S              4                                                       CGL029
     D PACCN           S             10                                                       CGL029
     D PACSN           S              2
     D PNONB           S              2
     D PBRCD           S              3
     D PCSSN           S             10
     D PPNOI           S              1
 
      ** Access Object Retail
     D PRETL           S             10
     D PCNUM           S              6
     D PCUCD           S              3
     D*PACCD****       S              4                                                       CGL029
     D PACCD           S             10                                                       CGL029
     D PACSQ           S              2
     D PBRCA           S              3
 
      ** Access Object Location Codes
     D PLCCD           S              3
 
      ** Access Object Counterparty Nostro
     D PCDCN           S              8
 
      ** Entry Parameters
     D PInstrngParty   S             10
     D PInstPrtyAcct   S             35
     D PAcctWInstn     S             10
     D PAcctWInstnAc   S             35
     D PBenMoney       S             10
     D PBenMoneyAcct   S             35
     D PDebtor         S             10                                                       CSW210
     D PDebtorAcct     S             35                                                       CSW210
     D*PCounterParty   S              6S 0                                                    CSD027
     D PCounterParty   S              6A                                                      CSD027
     D PForAcctPayTo   S              8
     D*PPayTo***       S             12                                                       CGL029
     D PPayTo          S             18                                                       CGL029
     D PPayToBrch      S              3
     D PSettlCcy       S              3
 
      ** Output Parameters
     D PRecOrgnAccnt   S             20
     D PRecOrgnCntry   S              2
     D PRecOrgnBank    S             20
     D PRecOrgnCode    S             11
     D PPayOrgnAccnt   S             20
     D PPayOrgnCntry   S              2
     D PPayOrgnBank    S             20
     D PPayOrgnCode    S             11
     D PDestAccnt      S             35
     D PDestCntry      S              2
     D PDestBank       S             20
 
      ** Work Variables
     D WOrderingCust   S             10
     D WBenfciary      S             10
     D WActWBnk        S             10
     D Ws1             S              2  0
     D*WAccount*       S             15                                                       CGL029
     D WAccount        S             21                                                       CGL029
     D WCurrency       S              3
     D WBranch         S              3
     D WCustNo         S              6
     D WStart          S              1  0
     D*WACOD****       S              4                                                       CGL029
     D WACOD           S             10                                                       CGL029
     D WRUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
     C                   EXSR      SRINIT
     C                   EXSR      SRORIGIN
     C                   EXSR      SRDEST
 
      ** Terminate program
 
     C                   EVAL      *INLR = *On
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
 
     C                   PARM                    PInstrngParty
     C                   PARM                    PInstPrtyAcct
     C                   PARM                    PAcctWInstn
     C                   PARM                    PAcctWInstnAc
     C                   PARM                    PBenMoney
     C                   PARM                    PBenMoneyAcct
     C                   PARM                    PDebtor                                      CSW210
     C                   PARM                    PDebtorAcct                                  CSW210
     C                   PARM                    PCounterParty
     C                   PARM                    PForAcctPayTo
     C                   PARM                    PPayTo
     C                   PARM                    PPayToBrch
     C                   PARM                    PSettlCcy
 
      ** OUTPUT
      ** Receipt Origin Account/Country/Bank/Code
 
     C                   PARM                    PRecOrgnAccnt
     C                   PARM                    PRecOrgnCntry
     C                   PARM                    PRecOrgnBank
     C                   PARM                    PRecOrgnCode
 
      ** Pay Origin Account/Country/Bank/Code
 
     C                   PARM                    PPayOrgnAccnt
     C                   PARM                    PPayOrgnCntry
     C                   PARM                    PPayOrgnBank
     C                   PARM                    PPayOrgnCode
 
      ** Destination Account/Country/Bank
 
     C                   PARM                    PDestAccnt
     C                   PARM                    PDestCntry
     C                   PARM                    PDestBank
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialize variables                                 *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Initialize output parameters
 
     C                   EVAL      PRecOrgnAccnt = *Blanks
     C                   EVAL      PRecOrgnCntry = *Blanks
     C                   EVAL      PRecOrgnBank = *Blanks
     C                   EVAL      PRecOrgnCode = *Blanks
     C                   EVAL      PPayOrgnAccnt = *Blanks
     C                   EVAL      PPayOrgnCntry = *Blanks
     C                   EVAL      PPayOrgnBank = *Blanks
     C                   EVAL      PPayOrgnCode = *Blanks
     C                   EVAL      PDestAccnt = *Blanks
     C                   EVAL      PDestCntry = *Blanks
     C                   EVAL      PDestBank = *Blanks
 
      ** Initialize work variables
 
     C                   EVAL      WOrderingCust = *Blanks
     C                   EVAL      WBenfciary = *Blanks
      *                                                                                       CSW210
      ** Setup Debtor                                                                         CSW210
      *                                                                                       CSW210
     C                   IF        PDebtor <> *Blanks                                         CSW210
     C                   EVAL      WOrderingCust = PDebtor                                    CSW210
     C                   ELSE                                                                 CSW210
 
      ** Setup ordering customer
 
     C                   IF        PInstrngParty <> *Blanks
     C                   EVAL      WOrderingCust = PInstrngParty
     C                   ELSE
     C**********         IF        PCounterParty <> 0                                         CSD027
     C                   IF        PCounterParty <> *BLANKS                                   CSD027
     C                   EVAL      WOrderingCust = *Blanks
     C                   MOVEL     PCounterParty WOrderingCust
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CSW210
 
      ** Setup Account with Bank
     C                   IF        PAcctWInstn <> *Blanks
     C                   EVAL      WActWBnk = PAcctWInstn
     C                   ELSE
 
      ** Determine if Pay to is nostro, retail accnt or customer
 
     C                   EVAL      WAccount = PPayTo
     C                   EVAL      WCurrency = PSettlCcy
     C                   EVAL      WBranch = PPayToBrch
     C                   EXSR      SRDetAcctTyp
     C                   EVAL      WActWBnk = WCustNo
     C                   ENDIF
 
      ** Setup Beneficiary
 
     C                   IF        PBenMoney <> *Blanks
     C                   EVAL      WBenfciary = PBenMoney
     C                   ELSE
 
     C                   IF        PForAcctPayTo <> *Blanks
     C                   EVAL      WBenfciary = PForAcctPayTo
     C                   ELSE
     C**********         IF        PCounterParty <> 0                                         CSD027
     C                   IF        PCounterParty <> *BLANKS                                   CSD027
     C                   EVAL      WBenfciary = *Blanks
     C                   MOVEL     PCounterParty WBenfciary
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRORIGIN - Format Pay/Receipt Origin fields                   *
      *                                                               *
      *****************************************************************
 
     C     SRORIGIN      BEGSR
                                                                                              CSW210
      ** Format Debtor                                                                        CSW210
                                                                                              CSW210
     C                   IF        PDebtor <> *Blanks                                         CSW210
     C                   IF        %SUBST(PDebtorAcct:1:1) = '/'                              CSW210
     C                   EVAL      WStart = 2                                                 CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      WStart = 1                                                 CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   EVAL      PRecOrgnAccnt = %SUBST(PDebtorAcct: +                      CSW210
     C                             WStart)                                                    CSW210
     C                   EVAL      PPayOrgnAccnt = %SUBST(PDebtorAcct: +                      CSW210
     C                             WStart)                                                    CSW210
     C                   ELSE                                                                 CSW210
 
      ** Format Origin Account
 
     C                   IF        %SUBST(PInstPrtyAcct:1:1) = '/'
     C                   EVAL      WStart = 2
     C                   ELSE
     C                   EVAL      WStart = 1
     C                   ENDIF
 
     C                   EVAL      PRecOrgnAccnt = %SUBST(PInstPrtyAcct: +
     C                             WStart)
     C                   EVAL      PPayOrgnAccnt = %SUBST(PInstPrtyAcct: +
     C                             WStart)
     C                   ENDIF                                                                CSW210
 
      ** Format Origin Country, Bank and Code
 
     C                   IF        WOrderingCust <> *Blanks
 
     C                   EVAL      PKEY1 = WOrderingCust
     C                   EXSR      SRCustomer
 
      ** Record Found on Customer Details
 
     C                   IF        PRTCD = *BLANKS
 
      ** Format Origin Country
 
     C                   EVAL      PRecOrgnCntry = BBCOLC
     C                   EVAL      PPayOrgnCntry = BBCOLC
 
      ** Format Origin Bank
 
     C                   IF        BBSWFI = 'Y'
     C                   EVAL      PRecOrgnBank = WOrderingCust
     C                   EVAL      PPayOrgnBank = WOrderingCust
     C                   ENDIF
 
      ** Format Origin Code
 
     C                   IF        BBCSID <> *Blanks
     C                   EVAL      PRecOrgnCode = BBCSID
     C                   EVAL      PPayOrgnCode = BBCSID
     C                   ELSE
     C                   EVAL      PRecOrgnCode = BBCUST
     C                   EVAL      PPayOrgnCode = BBCUST
     C                   ENDIF
 
     C                   GOTO      SRORIGINEND
     C                   ENDIF
 
      ** Check if Ordering Customer is Counterparty Nostro
 
 
     C                   EVAL      PCDCN = WOrderingCust
     C                   EXSR      SRCntrNostro
 
     C                   IF        PRTCD = *Blanks
 
      ** If Ordering customer has attached SWIFT ID
 
     C                   IF        AWSWID <> *Blanks
     C                   EVAL      PRecOrgnCntry = %SUBST(AWSWID:5:6)
     C                   EVAL      PPayOrgnCntry = %SUBST(AWSWID:5:6)
     C                   EVAL      PRecOrgnCode = AWSWID
     C                   EVAL      PPayOrgnCode = AWSWID
     C                   GOTO      SRORIGINEND
     C                   ENDIF
 
      ** If Customer Shortname part 2 is not blank
 
     C                   IF        AWCSN2 <> *Blanks
     C                   EVAL      PLCCD = AWCSN2
     C                   EXSR      SRLocation
 
      ** If Customer Shortname exist in Location Details file (SDLOCNPD)
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PRecOrgnCntry = DVCNCD
     C                   EVAL      PPayOrgnCntry = DVCNCD
     C                   ENDIF
     C                   ENDIF
 
      ** Format Origin Code
 
     C                   EVAL      PRecOrgnCode = WOrderingCust
     C                   EVAL      PPayOrgnCode = WOrderingCust
 
     C                   ENDIF
     C                   ENDIF
 
     C     SRORIGINEND   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEST - Format Destination Accnt,Country & Destination Bank  *
      *                                                               *
      *****************************************************************
 
     C     SRDEST        BEGSR
 
      ** If Beneficiary is not blank
 
 
     C                   IF        WBenfciary <> *Blanks
     C                   SELECT
     C                   WHEN      %SUBST(PBenMoneyAcct:1:2) = '//'
     C                   EVAL      WStart = 3
     C                   WHEN      %SUBST(PBenMoneyAcct:1:2) = '/'
     C                   EVAL      WStart = 2
     C                   OTHER
     C                   EVAL      WStart = 1
     C                   ENDSL
 
     C                   EVAL      PDestAccnt = %SUBST(PBenMoneyAcct:WStart)
     C                   EVAL      PDestBank = WBenfciary
 
      ** Check is beneficiary is a customer
 
     C                   EVAL      PKEY1 = WBenfciary
     C                   EXSR      SRCustomer
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PDestCntry = BBCOLC
     C                   GOTO      SRDESTEND
     C                   ENDIF
 
      ** if not customer, check if counterparty nostro
 
 
     C                   EVAL      PCDCN = WBenfciary
     C                   EXSR      SRCntrNostro
 
     C                   IF        PRTCD = *BLANKS
 
      ** If swift ID is not blank
 
     C                   IF        AWSWID <> *Blanks
     C                   EVAL      PDestCntry = %SUBST(AWSWID:5:6)
     C                   GOTO      SRDESTEND
     C                   ENDIF
 
      ** If Customer Shortname part 2 is not blank, check if location
      ** exist on file
 
     C                   IF        AWCSN2 <> *Blanks
     C                   EVAL      PLCCD = AWCSN2
     C                   EXSR      SRLocation
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PDestCntry = DVCNCD
     C                   GOTO      SRDESTEND
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** If Beneficiary is blank, and Account with Bank is not
 
     C                   IF        WActWBnk <> *Blanks
 
      ** Check is Account with Bank is a customer
 
     C                   EVAL      PKEY1 = WActWBnk
     C                   EXSR      SRCustomer
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PDestCntry = BBCOLC
     C                   ELSE
 
     C                   EVAL      PCDCN = WActWBnk
     C                   EXSR      SRCntrNostro
 
     C                   IF        PRTCD = *Blanks
 
     C                   IF        AWSWID <> *Blanks
     C                   EVAL      PDestCntry = %SUBST(AWSWID:5:6)
     C                   ELSE
 
      ** If Customer Shortname part 2 is not blank
 
     C                   IF        AWCSN2 <> *Blanks
     C                   EVAL      PLCCD = AWCSN2
     C                   EXSR      SRLocation
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PDestCntry = DVCNCD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Format Destination Account
 
     C                   IF        PDestCntry <> *Blanks  OR
     C                             PDestBank = *Blanks
 
     C                   SELECT
     C                   WHEN      %SUBST(PAcctWInstnAc:1:2) = '//'
     C                   EVAL      WStart = 3
     C                   WHEN      %SUBST(PAcctWInstnAc:1:2) = '/'
     C                   EVAL      WStart = 2
     C                   OTHER
     C                   EVAL      WStart = 1
     C                   ENDSL
 
     C                   EVAL      PDestAccnt = %SUBST(PAcctWInstnAc:WStart)
     C                   EVAL      PDestBank = WActWBnk
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     SRDESTEND     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetAcctTyp - Determine Account Type                         *
      *                                                               *
      *****************************************************************
 
     C     SRDetAcctTyp  BEGSR
 
     C     ' '           SCAN      WAccount      Ws1
 
     C                   SELECT
 
      ** Nostro Account
 
     C                   WHEN      Ws1 = 3
     C                   EVAL      PNONB = WAccount
     C                   EVAL      PCYCD = WCurrency
     C                   EXSR      SRNostro
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PKEY1 = A7CUST
     C                   EXSR      SRCustomer
     C                   ENDIF
 
      ** Retail Account
 
     C                   WHEN      Ws1 = 11
     C                   EVAL      PRETL = WAccount
     C                   EXSR      SRRetail
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVEL     CNUM          PKEY1
     C                   MOVEL     ACOD          WACOD
     C                   EXSR      SRCustomer
     C                   ENDIF
 
      ** Customer Number
 
     C                   WHEN      Ws1 = 7
     C                   EVAL      PKEY1 = WAccount
     C                   EXSR      SRCustomer
 
      ** General Ledger Account
 
     C                   OTHER
     C                   EVAL      PKEY1 = %SUBST(WAccount:1:6)
     C                   EXSR      SRCustomer
 
     C                   ENDSL
 
     C                   EVAL      WCustNo = BBCUST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCustomer - Get Customer Details                             *
      *                                                               *
      *****************************************************************
 
     C     SRCustomer    BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY  '      POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error if *ERROR
 
 
     C                   IF        PRTCD <> *Blanks  AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = PKEY1
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNostro - Get Nostro Details                                 *
      *                                                               *
      *****************************************************************
 
     C     SRNostro      BEGSR
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      *BLANKS       PCUST
     C                   PARM                    PCYCD
     C                   PARM      *BLANKS       PACCN
     C                   PARM      *BLANKS       PACSN
     C                   PARM                    PNONB
     C                   PARM      *BLANKS       PBRCD
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      *BLANKS       DSFDY
 
      ** Database error if *ERROR
 
     C                   IF        PRTCD <> *Blanks  AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = PNONB + PCYCD
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetail - Get Retail Account Details                         *
      *                                                               *
      *****************************************************************
 
     C     SRRetail      BEGSR
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PRETL
     C                   PARM      *BLANKS       PCNUM
     C                   PARM      *BLANKS       PCUCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSQ
     C                   PARM      *BLANKS       PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
 
      ** Database error if *ERROR
 
     C                   IF        PRTCD <> *Blanks  AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = PRETL
     C                   EVAL      DBFILE = 'SDACCTPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCntrNostro - Get Counterparty Nostro details                *
      *                                                               *
      *****************************************************************
 
     C     SRCntrNostro  BEGSR
 
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCDCN
     C     SDCNST        PARM      *BLANKS       DSFDY
 
      ** Database error if *ERROR
 
     C                   IF        PRTCD <> *Blanks  AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = PNONB + PCYCD
     C                   EVAL      DBFILE = 'SDCNSTPD'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLocation - Get Location Code Details                        *
      *                                                               *
      *****************************************************************
 
     C     SRLocation    BEGSR
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PLCCD
     C     SDLOCN        PARM      SDLOCN        DSSDY
 
      ** Database error if *ERROR
 
     C                   IF        PRTCD <> *Blanks  AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = PLCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      DBPGM = 'ZAAMLSETSE'
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
