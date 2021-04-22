     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA AML settlement extract for FF module')        *
      *****************************************************************
      *                                                               *
      *  Midas - Common Programs                                      *
      *                                                               *
      *  ZAAMLSETFF - Settlement Extract for Futures and Options      *
      *               Module                                          *
      *                                                               *
      *  Function:  This program will be used to extract the Futures  *
      *             and Options settlement fields to be used in       *
      *             Account History export in AML.                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
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
      *                 CGL020  *CREATE    Date 12Dec02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialise variables                                 *
      * SRORIGIN - Format origin fields                               *
      * SRDEST - format payment destination fields                    *
      * SRDetAcctTyp - Determine Account Type                         *
      * SRCust - Call AOCUSTR0                                        *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Access Object Data Structure
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External DS for Nostro Details
 
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      ** External DS for Account Details
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** Counterparty Nostros Details
 
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)
      ** Location Code Details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
     D*PCustBkrCde     S              6S 0                                                    CSD027
     D PCustBkrCde     S              6                                                       CSD027
     D****PSetAccount     S             12                                                    CGL029
     D PSetAccount     S             18                                                       CGL029
     D PSetBranch      S              3
     D PForAcctOf      S             10
     D PSetCntrPrty    S              8
     D PInstrmntCcy    S              3
     D PRAccount       S             20
     D PRCountry       S              2
     D PRBank          S             20
     D PRCode          S             11
     D PPAccount       S             20
     D PPCountry       S              2
     D PPBank          S             20
     D PPCode          S             11
     D PDestAcnt       S             35
     D PDestCntry      S              2
     D PDestBank       S             20
 
      ** Parameters for Access Objects
     D PRtcd           S              7
     D POptn           S              7
     D PCust           S             10
     D PKey            S              7
     D PCNCD           S              8
     D PLCCD           S              3
 
      ** Access Object Nostro
     D PKey1           S              6
     D PCYCD           S              3
     D PNONB           S              2
     D PCSSN           S             10
     D PPNOI           S              1
 
      ** Access Object Retail
     D PRETL           S             10
     D PCNUM           S              6
     D***PACCD**         S              4                                                     CGL029
     D PACCD           S             10                                                       CGL029
     D PACSQ           S              2
     D PBRCA           S              3
 
      ** Work Variables
     D*WOrderCust      S              6S 0                                                    CSD027
     D WOrderCust      S              6                                                       CSD027
     D WBenfciary      S             10
     D WActWBnk        S             10
 
     D Ws1             S              2  0
     D WAccount        S             15
     D WCustNo         S              6
     D WRUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRORIGIN
 
     C                   EXSR      SRDEST
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialise variables                                 *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Initialise all output parameters
 
     C                   EVAL      PRAccount  = *BLANKS
     C                   EVAL      PRCountry  = *BLANKS
     C                   EVAL      PRBank     = *BLANKS
     C                   EVAL      PRCode     = *BLANKS
     C                   EVAL      PPAccount  = *BLANKS
     C                   EVAL      PPCountry  = *BLANKS
     C                   EVAL      PPBank     = *BLANKS
     C                   EVAL      PPCode     = *BLANKS
     C                   EVAL      PDestAcnt  = *BLANKS
     C                   EVAL      PDestCntry = *BLANKS
     C                   EVAL      PDestBank  = *BLANKS
 
      ** Initialize work variables
 
     C**********         EVAL      WOrderCust = *ZEROS                                        CSD027
     C                   EVAL      WOrderCust = *BLANKS                                       CSD027
     C                   EVAL      WBenfciary = *BLANKS
     C                   EVAL      WActWBnk   = *BLANKS
 
     C                   EVAL      WAccount  = PSetAccount
 
      ** Format Ordering Customer
 
     C                   EVAL      WOrderCust = PCustBkrCde
 
      ** Format Account with Bank
 
     C                   EXSR      SRDetAcctTyp
     C                   EVAL      WActWBnk = WCustNo
 
      ** Format Beneficiary
 
     C                   SELECT
     C                   WHEN      PForAcctOf <> *BLANKS
     C                   EVAL      WBenfciary = PForAcctOf
     C                   WHEN      PSetCntrPrty <> *BLANKS
     C                   EVAL      WBenfciary = PSetCntrPrty
     C                   OTHER
     C                   MOVEL     PCustBkrCde   WBenfciary
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetAcctTyp - Determine Account Type                         *
      *                                                               *
      *****************************************************************
 
     C     SRDetAcctTyp  BEGSR
 
     C                   EVAL      PCust = WAccount
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKey
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** If no record found, check for account type
 
     C                   IF        PRtcd <> *BLANKS
 
     C     ' '           SCAN      WAccount      Ws1
 
     C                   SELECT
 
      ** Nostro Account
 
     C                   WHEN      Ws1 = 3
 
     C                   EVAL      PNONB = WAccount
     C                   EVAL      PCYCD = PInstrmntCcy
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PKey1
     C                   PARM                    PCYCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSQ
     C                   PARM                    PNONB
     C                   PARM      *BLANKS       PBRCA
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      SDNOST        DSSDY
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PCust = A7CUST
     C                   EXSR      SRCust
     C                   ENDIF
 
      ** Retail Account
 
     C                   WHEN      Ws1 = 11
 
     C                   EVAL      PRETL = WAccount
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PRETL
     C                   PARM      *BLANKS       PCNUM
     C                   PARM      *BLANKS       PCYCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSQ
     C                   PARM      *BLANKS       PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PCust = *BLANKS
     C                   MOVEL     CNUM          PCust
     C                   EXSR      SRCust
     C                   ENDIF
 
      ** General Ledger Account
 
     C                   OTHER
     C                   EVAL      PCust = %SUBST(WAccount:1:6)
     C                   EXSR      SRCust
 
     C                   ENDSL
     C                   ENDIF
 
     C                   EVAL      WCustNo = BBCUST
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRORIGIN - Format origin fields                               *
      *                                                               *
      *****************************************************************
 
     C     SRORIGIN      BEGSR
 
     C**********         IF        WOrderCust <> *ZEROS                                       CSD027
     C                   IF        WOrderCust <> *BLANKS                                      CSD027
 
      **  Format Origin Country
 
     C                   MOVEL     WOrderCust    PCust
     C                   EXSR      SRCust
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PPCountry  = BBCOLC
     C                   EVAL      PRCountry  = BBCOLC
     C                   ENDIF
 
      ** Format Origin Bank
 
     C                   IF        BBSWFI = 'Y'
     C                   MOVEL     WOrderCust    PPBank
     C                   MOVEL     WOrderCust    PRBank
     C                   ENDIF
 
      ** Format Origin Code
 
     C                   IF        BBCSID <> *BLANKS
     C                   EVAL      PPCode = BBCSID
     C                   EVAL      PRCode = BBCSID
     C                   ELSE
     C                   EVAL      PPCode = BBCUST
     C                   EVAL      PRCode = BBCUST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDEST - format payment destination fields                    *
      *                                                               *
      *****************************************************************
 
     C     SRDEST        BEGSR
 
      ** Format Destination Country and Destination Bank
 
     C                   IF        WBenfciary <> *BLANKS
     C                   EVAL      PDestBank  = WBenfciary
 
     C                   EVAL      PCust = WBenfciary
     C                   EXSR      SRCust
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PDestCntry = BBCOLC
     C                   GOTO      EndSRDEST
     C                   ENDIF
 
      ** Check if Beneficiary is a Counter Party Nostro
 
     C                   MOVEL     WBenfciary    PCNCD
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCNCD
     C     SDCNST        PARM      SDCNST        DSSDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  =  PCNCD
     C                   EVAL      DBFILE = 'SDCNSTPD'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
 
      ** If Swidt Id is not blanks
 
     C                   IF        AWSWID <> *BLANKS
     C                   EVAL      PDestCntry = (%SUBST(AWSWID:5:2))
     C                   GOTO      EndSRDEST
     C                   ENDIF
 
      ** If Customer Shortname part 2 is not blanks
 
     C                   IF        AWCSN2 <> *BLANKS
 
     C                   CALL      'AOLOCNR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      AWCSN2        PLCCD
     C     SDLOCN        PARM      SDLOCN        DSSDY
 
      ** Database error
 
     C                   If        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  =  PLCCD
     C                   EVAL      DBFILE = 'SDLOCNPD'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PDestCntry = DVCNCD
     C                   GOTO      EndSRDEST
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WActWBnk <> *BLANKS
 
     C                   EVAL      PCust = WActWBnk
     C                   EXSR      SRCust
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      PDestCntry = BBCOLC
     C                   ENDIF
 
     C                   IF        PDestCntry <> *BLANKS OR
     C                             PDestBank = *BLANKS
     C                   EVAL      PDestBank = WActWBnk
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndSRDEST     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCust - Call AOCUSTR0                                        *
      *                                                               *
      *****************************************************************
 
     C     SRCust        BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKey
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  =  PCust
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C                   PARM                    PCustBkrCde
     C                   PARM                    PSetAccount
     C                   PARM                    PSetBranch
     C                   PARM                    PForAcctOf
     C                   PARM                    PSetCntrPrty
     C                   PARM                    PInstrmntCcy
 
      ** OUTPUT
      ** Receipt Origin Account/Country/Bank/Code
 
     C                   PARM                    PRAccount
     C                   PARM                    PRCountry
     C                   PARM                    PRBank
     C                   PARM                    PRCode
 
      ** Pay Origin Account/Country/Bank/Code
 
     C                   PARM                    PPAccount
     C                   PARM                    PPCountry
     C                   PARM                    PPBank
     C                   PARM                    PPCode
 
      ** Destination Account/Country/Bank
 
     C                   PARM                    PDestAcnt
     C                   PARM                    PDestCntry
     C                   PARM                    PDestBank
 
     C                   ENDSR
 
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
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
 
