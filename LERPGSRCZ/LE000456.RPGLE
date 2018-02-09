     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL process - Loans account keys')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000456 - Past Due Call Loans: Loans Account Keys           *
      *                                                               *
      *  Function:  This program reads the new account keys file      *
      *             LEPK1DPD and for each repayment account key it    *
      *             checks whether the settlement account has         *
      *             enough balance to cover the payment. If the       *
      *             balance is enough then it generates the payment   *
      *             otherwise it creates a PDCL                       *
      *                                                               *
      *  Called By: LEC000456 (COB) - PDCL Generation for Loans       *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD048557           Date 27Nov17               *
      *                 MD046080           Date 21Sep17               *      
      *                 CGL165             Date 17Feb15               *
      *                 CLE164             Date 18Aug14               *
      *                 MD023378           Date 25Apr14               *
      *                 MD021423E          Date 12Sep13               *
      *                 MD021423 *REWRITE  Date 21Aug13               *
      *                 MD021019           Date 27Jun13               *
      *                 MD020684           Date 30May13               *
      *                 MD020563           Date 21May13               *
      *                 AR782473           Date 14May13               *
      *                 AR1095440          Date 26Mar13               *
      *                 AR1097176          Date 22Mar13               *
      *                 CLE075BH           Date 06Aug12               *
      *                 AR1085742          Date 06Jan13               *
      *                 CFC006             Date 06Aug12               *
      *                 AR1080660          Date 26Jan13               *
      *                 AR1063739          Date 03Dec12               *
      *                 AR1056323          Date 14Nov12               *
      *                 AR1021979          Date 01Aug12               *
      *                 AR724089           Date 01Aug12               *
      *                 AR571209           Date 01Aug12               *
      *                 AR402058           Date 01Aug12               *
      *                 AR217562           Date 01Aug12               *
      *                 263629             Date 01Aug12               *
      *                 263413             Date 01Aug12               *
      *                 263074             Date 01Aug12               *
      *                 CLE134 *CREATE     Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD048557 - Failing COB Component - LEC000471A                *
      *  MD046080 - Gap between CLE031 and CLE134                     *      
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  MD023378 - LEC000471A encountered FOOB on Past Due Call Loan *
      *             Account Keys Detail file                          *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *  MD021019 - LE000456P1 report which shows a CR balance even   *
      *             if it is zero                                     *
      *  MD020684 - Component LEC000471A failed due FOOB on trailer   *
      *             file. Move the position of COMMIT such that the   *
      *             changes to trailer file will also be comitted not *
      *             only the detail file                              *
      *  MD020563 - CFC006 issues                                     *
      *  AR782473 - Wrong value date of PDCL creation. Ensure that    *
      *             the actual value date of repayment is used for    *
      *             new PDCL.                                         *
      *             Applied for MD020209.                             *
      *  AR1095440 - LEC000471A encountered FOOB in Day 0 COB in EN   *
      *  AR1097176 - Accessing AOCOMR0 multiple times slows down the  *
      *              system                                           *
      *  CLE075BH - COB Restructure - LE COB Optimisation Phase 1     *
      *  AR1085742 - Recovery handling when PDP components loop due   *
      *              to database connection issues                    *
      *  CFC006 - COB Restructure - Remove reports from COB           *
      *  AR1080660 - Erroneous generated result with PDCL details     *
      *  AR1063739 - SettlementAccount09 Issues                       *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  AR1021979 - Option C - Technical Enhancements Stated in POC  *
      *  AR724089 - Several performance issues in COB component       *
      *             LEC0459. Call LE0475 directly, instead of passing *
      *             thru LEC0475. (Child: AR724090)                   *
      *  AR571209 - When Separate indicator is N and Capitalized ind  *
      *             is 'N' then the past due interest must be ignored *
      *             and must be repaid normally. (Child: AR571217)    *
      *  AR402058 - Wrong Available Balance. (Child: AR402059)        *
      *  AR217562 - Wrong Repayment Methodology. (Child: AR217563)    *
      *  263629 - Prevent field RECI on LEPK1DPD to be overwritten by *
      *           CLOANCL RECI.                                       *
      *  263413 - Issue with facility amount update                   *
      *  263074 - Wrong Postings when interest and principal are paid *
      *           on the same day (Recompile)                         *
      *           CLE134 / SWIFT                                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      *
      ** Midas LE Fee Past Due Call Loans Account Keys
     FLEPK1L3   UF A E           K DISK    RENAME(LKEY1DPF:LEPK1DPF)
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      *
      ** Midas LE Past Due Call Loans Account Keys Trailer
     FLEPK1ZZ   UF   E             DISK    RENAME(LKEY1ZZF:LEPK1ZZF)
     F                                     COMMIT
     F                                     INFSR(*PSSR)
      *
      ** Midas LE Past Due & Original Loan Link
     FLEPDUEL5  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas LE Actions Today
     FACTNPL1   UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas LE Past Due Call Loans Account Keys
     FLEPK1L0   IF   E           K DISK    RENAME(LKEY1DPF:LEPK0DPF)
     F                                     INFSR(*PSSR)
      *
      ** Midas LE Loans File
     FLELOANLW  IF   E           K DISK    INCLUDE(CLOANCLF)
     F                                     RENAME(CLOANCLF:CLOANCL6)
     F                                     INFSR(*PSSR)
      *
      ** Midas SD Currency Codes
     FSDCURRL1  IF   E           K DISK
      ** Settlement Allocation by RONS                                                      MD046080
     FLESTALLG  IF   E           K DISK    INFSR(*PSSR)                                     MD046080
     F                                     PREFIX(G_)                                       MD046080
      ** Settlement Allocation by PONS                                                      MD046080
     FLESTALLH  IF   E           K DISK    INFSR(*PSSR)                                     MD046080
     F                                     RENAME(LESTALD0:LESTALD1)                        MD046080
     F                                     PREFIX(H_)                                       MD046080
      *
      ** Past Due Call Loans Account Keys Generated Report
     FLE000456P1O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
     F                                     INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *ON (for indcator processing)
      ** False      logical = *OFF (for indcator processing)
      ** DBErrCtl   10A = 'DBERRCTL' (the name of the database error
      ** handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D SPOOL1          DS
     D SFILE1                 83     92
     D SFNUM1                123    124B 0
     D OFLLN1                188    189B 0
     D PRTLN1                367    368B 0
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** Trading ICD
      *
     D QQACCD1       E                     EXTFLD(QQACCD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
                                                                                           MD021423E
      ** Data Structure for Account Details                                                MD021423E
     D ACCNTB        E DS                  EXTNAME(ACCNTAB)                                MD021423E
     D  QRECI        E                     EXTFLD(RECI)                                     MD023378
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
      *
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access programs - long data structure
      *
      ** Entry parameters
      *
     D pReturnCode     S              7
     D pAPOS           S              1
     D pCNAME          S             10
      *
      ** Work variables
      *
     D wPostR          S              1
     D WRetcd          S              7
     D WPARM           S             20A   INZ('LoanCustOriginPurch')
      *
      ** Account
      *
     D wLoan           S              6
     D wcnu2           S              6
     D wFbrcd          S              3
      *
     D wEccy           S              3
     D wBrca           S              3
      *
      ** Balance check
      **  Cleared Balance
      **  Available Funds
      **  Available Funds
      **  Loan Amd Seq
      **  Loan Amd Val Date
      **  Principal
      **  Available
      **  Principal
      **  Principal
      **  Total amount
      **  Output Principal
      **  Output Interest
      **  Original Payment Pri
      **  Original EAMT
      **  Original Payment Int
      **  Total past due prin
      **  Total past due int
      **  New record
      *
     D P@BLAF          S             15P 0
     D W@Avail         S             15P 0
     D W@LASN          S              3P 0
     D W@AVDAT         S              5P 0
     D w@Prin          S             15P 0
     D w@Av            S             15P 0
     D w@Int           S             15P 0
     D w@Pdamt         S             15P 0
     D w@Totak         S             15P 0
     D w@OPdam         S             15P 0
     D w@OPdInt        S             15P 0
     D w@Origp         S             15P 0
     D w@OEAMT         S             15P 0
     D w@OrigI         S             15P 0
     D w@TotPD         S             15P 0
     D w@TotPI         S             15P 0
     D w@newRc         S              1P 0
     D w@adjamt        S             15P 0
     D W@BCR           S              1A                                                   MD021423E
      *
     D SVALK1          S             20
     D SVAL1           S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK0          S             20
     D SVAL10          S            200
      *
     D WPastDue        S              1
     D WReverse        S              1
     D WDrCr           S              1
      *
     D LTYP            S              2
     D SUTP            S              2
     D CLAS            S              4
      *
     D WignoreI        S              1
      *
     D Wtypef          S              1
      *
     D SEQ             S              2  0
     D COD             S              2  0
     D FACL            S              5  0
 
     D W@Type          S              1
 
     D WMult           S              1  0
 
     D wf10            S             10
 
     D K_RECI          S              1
 
     D Branch          S              3
 
     D RCDTT           S              1
 
     D WRK01           S              1
 
     D PPCUST          S              1
     D W@PGNM          S             10
     D BlockCredit     S              1A   INZ(*BLANKS)                                    MD021423E
 
     D ZS2             S              1    DIM(21)
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
 
     D PRTCD           S              7A
     D SUPFLG          S              1A
     D PNAME           S             10A
     D PCSEQ           S              5A
     D PSCTN           S             50A
     D CFC006          S              1A
     D POPTN           S              7A
     D PSARD           S              6A
                                                                                            MD046080
     D WINAMT          S             15  0                                                  MD046080
     D WRATE           S             13  8                                                  MD046080
     D WSPRT1          S             13  8                                                  MD046080
     D WSPRT2          S             13  8                                                  MD046080
     D WMDIN           S              1A                                                    MD046080
     D WMDIN1          S              1A                                                    MD046080
     D WMDIN2          S              1A                                                    MD046080
     D WCCY1           S              3A                                                    MD046080
     D WCCY2           S              3A                                                    MD046080
     D WNBDP1          S              1  0                                                  MD046080
     D WNBDP2          S              1  0                                                  MD046080
     D WOUTAMT         S             15  0                                                  MD046080
     D WWWAMT          S             15P 0                                                  MD046080
     D WIND1           S              1A                                                    MD046080
     D WSET            S             18A                                                    MD046080
     D WWCCY           S              3A                                                    MD046080
     D CLE031          S              1A                                                    MD046080
     D CLE034          S              1A                                                    MD046080
     D WZCCY           S              3A                                                    MD046080
 
      ** Cache Work Variables and Storage
 
     D CurrKey         S                   LIKE (A6CYCD)
     D CurrIdx         S              3  0 INZ(1)
     D TrailIdx        S              3  0 INZ(1)
     D CurrCache       S                   INZ LIKE(A6CYCD)
     D                                     DIM(250) ASCEND
      ** Key for Currency Details (Full Cache)
 
     D DSCurr        E DS                  INZ EXTNAME(SDCURRPD)
     D                                     DIM(250) QUALIFIED
      *                                                                                    MD021423E
     D  PRetCode       S              7A                                                   MD021423E
     D  POption        S              7A                                                   MD021423E
     D  PRETL          S             10A                                                   MD021423E
     D  PCustNum       S              6A                                                   MD021423E
     D  PCurrency      S              3A                                                   MD021423E
     D  PAccCode       S             10S 0                                                 MD021423E
     D  PAccSeq        S              2S 0                                                 MD021423E
     D  PBranch        S              3A                                                   MD021423E
      *                                                                                    MD021423E
      ** Storage for Currency Details (Full Cache)
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      ** M A I N  P R O C E S S I N G                                 *
      *****************************************************************
 
      ** Read a/c keys file that contains a/c key subject
      ** to funds pre-check
 
     C     *LOVAL        SETLL     LEPK1L3
      *
      ** Loop to read a/c keys on LEPK1DPD
      *
     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK1L3                                88
     C                   IF        *IN88 = *OFF
      *
      ** Chec if account key has posting ref 2
      *
     C                   EXSR      SRCheckAC
      *
      ** If Post Ref 2 exists, process account key
      *
     C                   IF        wPostR = '2'
     C                   EXSR      SRPDCL
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
      ** Produce the Report
      *
     C                   EXSR      SRRepo
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPDCL - Process PDCL                                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRChkLoan, SRChkBal, SRGenPdcl, SRUpdack, SRUpdtra     *
      *                                                               *
      *****************************************************************
     C     SRPDCL        BEGSR
      *
      ** Check  Loan
      *
     C                   EXSR      SRChkLoan
      *
      ** Check Account Balance
      *
     C                   EXSR      SRChkBal
      *
      ** Call function to update/generate PDCL
      *
     C     WPastDue      CASEQ     'Y'           SRGenPdcl
     C     WPastDue      CASEQ     'P'           SRGenPdcl
     C                   ENDCS
      *
      ** Update/create account key
      *
     C                   EXSR      SRUpdack
      *
      ** Update a/ck trailer
      *
     C                   EXSR      SRUpdtra
     C                   COMMIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCheckAC - Check if the account key has settlement account   *
      *             defined                                           *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCheckAC     BEGSR
      *
      ** Check whether the account key has settlement account defined
      ** If debit account is blanks then flag the record as processed
      ** and skip to next record
      ** Skip too if Loan Type starts with X, Y or Z
      *
     C                   CLEAR                   WPostr
     C                   IF        SEBRCA <> *BLANKS AND SEACCY <> *BLANKS AND
     C                             SECNUM <> *BLANKS AND SEACOD > 0
     C                             AND SEACSQ > 0
     C                             AND %SUBST(AKEY:1:1) <> 'X'
     C                             AND %SUBST(AKEY:1:1) <> 'Y'
     C                             AND %SUBST(AKEY:1:1) <> 'Z'
     C                   EVAL      WPOSTR = '2'
      *                                                                                    MD021423E
     C                   MOVEL     SECNUM        PCustNum                                  MD021423E
     C                   MOVEL     SEACCY        PCurrency                                 MD021423E
     C                   MOVEL     SEACOD        PAccCode                                  MD021423E
     C                   MOVEL     SEACSQ        PAccSeq                                   MD021423E
     C                   MOVEL     SEBRCA        PBranch                                   MD021423E
     C                   CALL      'AOACCTR0'                                              MD021423E
     C                   PARM      *BLANKS       PRetCode                                  MD021423E
     C                   PARM      '*KEY   '     POption                                   MD021423E
     C                   PARM      *BLANKS       PRETL                                     MD021423E
     C                   PARM                    PCustNum                                  MD021423E
     C                   PARM                    PCurrency                                 MD021423E
     C                   PARM                    PAccCode                                  MD021423E
     C                   PARM                    PAccSeq                                   MD021423E
     C                   PARM                    PBranch                                   MD021423E
     C     ACCNTB        PARM      ACCNTB        DSSDY                                     MD021423E
                                                                                           MD021423E
     C                   MOVEL     PAccCode      PAccCodex        10                       MD021423E
     C                   MOVEL     PAccSeq       PAccSeqX          2                       MD021423E
     C                   IF        PRetCode <>  *BLANKS                                    MD021423E
     C                   EVAL      WRETCD = '*ERROR'                                       MD021423E
     C                   EVAL      DBKEY =  PCustNum + PCurrency                           MD021423E
     C                             + PAccCodeX + PAccSeqX + PBranch                        MD021423E
     C                   EVAL      DBFILE = 'ACCNTAB'                                      MD021423E
     C                   EVAL      DBASE = 001                                             MD021423E
     C                   EXSR      *PSSR                                                   MD021423E
     C                   ENDIF                                                             MD021423E
                                                                                           MD021423E
     C                   EVAL      BlockCredit = 'N'                                       MD021423E
     C                   TESTB     '3'           RETB                     85               MD021423E
     C                   IF        *IN85 = *ON                                             MD021423E
     C                   EVAL      BlockCredit = 'Y'                                       MD021423E
     C                   ENDIF                                                             MD021423E
                                                                                           MD021423E
     C                   ELSE
     C                   EVAL      IPFL = 'P'
     C                   UPDATE    LEPK1DPF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkBal - Check settlement account's balance                 *
      *                                                               *
      * Called by: SRPDCL                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkBal      BEGSR
      *
      ** Clear fields
      *
     C                   CLEAR                   W@Opdam
     C                   CLEAR                   W@OPdInt
      *
      ** -O:Available Funds
      *
     C                   CLEAR                   P@BLAF
     C                   CLEAR                   WRepaym
     C                   CLEAR                   W@NewRc
     C                   CLEAR                   w@adjamt
     C                   EVAL      WPastDue = 'N'
     C                   EVAL      WReverse = 'N'
     C                   EVAL      WDrCr = *BLANKS
 
 
     C                   IF        AUTO = 'C'
     C                             AND RECI = 'D'
 
     C                   Z-ADD     EAMT          WRepaym
     C                   IF        WRepaym < 0
     C                   EVAL      WRepaym = WRepaym * -1
     C                   ENDIF
 
     C                   EVAL      P@BLAF = AAMT
      *
      ** Set available balance flag
      *
     C                   EVAL      WDrCr = *BLANKS
     C                   EVAL      W@Avail = *ZERO
     C                   IF        P@BLAF < 0
     C                   EVAL      W@Avail = P@BLAF * -1
     C                   EVAL      WDrCr = 'C'
     C                   ELSE
     C                   EVAL      W@Avail = P@BLAF
     C                   EVAL      WDrCr = 'D'
     C                   ENDIF
      *
      ** If available balance sign is credit
      *
     C                   SELECT
      *
      ** If account key amount is zero, set past due flag = 'N'
      *
     C                   WHEN      EAMT = 0
     C                   EVAL      wPastDue = 'N'
      *
      ** If account key amount is negative, no check is needed as event
      ** amount is going to increase the account balance
      *
     C                   WHEN      EAMT < 0
     C                             AND REVI = 0
     C                   EVAL      wPastDue = 'N'
      *
      ** If account key amount is positive and a/c key is reversed,
      ** do not check balance as event amount is going to increase
      ** the account balance.
      *
     C                   WHEN      EAMT > 0
     C                             AND REVI = 1
     C                   EVAL      wPastDue = 'N'
     C                   EVAL      WReverse = 'Y'
      *
      ** If available balance is zero, set the WPastDue flag =Y
      *
     C                   WHEN      W@Avail = 0
     C                   EVAL      wPastDue = 'Y'
      *
      ** If available balance is debit, set past due flag = Y
      *
     C                   WHEN      W@Avail > 0
     C                             AND WDrCr = 'D'
     C                   EVAL      wPastDue = 'Y'
      *
      ** If available balance is credit and is less than event amount,
      ** set past due flag = 'P'
      *
     C                   WHEN      W@Avail > 0
     C                             AND WDrCr = 'C'
     C
     C                             AND WRepaym > W@Avail
     C                   EVAL      wPastDue = 'P'
      *
      ** If available balaNCE IS credit and is equal to event amount,
      ** set past due flag = 'N'
      *
     C                   WHEN      W@Avail > 0
     C                             AND WDrCr = 'C'
     C                             AND WRepaym > 0
     C                             AND WREpaym = W@Avail
     C                   EVAL      wPastDue = 'N'
      *
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenPdcl - Generate PDCL                                     *
      *                                                               *
      * Called by: SRPDCL                                             *
      *                                                               *
      * Calls: LEC000473                                              *
      *                                                               *
      *****************************************************************
     C     SRGenPdcl     BEGSR
      *
      ** If Available Balance is debit set it to zero
      *
     C                   Z-ADD     W@Avail       W@Av
     C                   IF        WDrcr = 'D'
     C                   Z-ADD     0             W@Av
     C                   ENDIF
      *
      ** If Principal Repayment is negative, set it to positive
      *
     C                   Z-ADD     PAMT          W@PRin
     C                   IF        W@Prin < 0
     C                   EVAL      W@Prin = W@Prin * -1
     C                   ENDIF
      *
      ** If Interest Repayment is negative, set it to positive
      *
     C                   Z-ADD     IAMT          W@Int
     C                   IF        W@Int < 0
     C                   EVAL      W@Int = W@Int * -1
     C                   ENDIF
      *
      ** Set Interest/Principal/total flag
      *
     C                   IF        IAMT <> 0
     C                             AND PAMT <> 0
     C                   EVAL      W@Type = 'T'
     C                   ELSE
     C                   IF        IAMT <> 0
     C                   EVAL      W@Type = 'I'
     C                   ENDIF
     C                   IF        PAMT <> 0
     C                   EVAL      W@Type = 'P'
     C                   ENDIF
     C                   ENDIF
      *
      ** Set value date (of repayment)
      *
     C                   Z-ADD     AVDAT         W@AVDAT
      *
      ** Flag to ignore past due interest
      *
     C                   EVAL      WignoreI = *BLANKS
      *
      ** Generate PDCL - CALL LEC000473
      *
     C                   CALL      'LEC000473'
      *
      ** Input Parm
      **  Facility Seq
      **  Facility Cod
      **  Facility
      **  Branch
      **  Customer
      **  Event Date
      **  Principal Amt
      **  Interest Amount
      **  Available Balance
      **  Orig Repay - Prin
      **  Orig Repay - Int
      **  Loan Amd sequence
      **  VDAT of repayment
      **  I/P/T
      *
     C                   PARM                    wRetcd
     C                   PARM      'L'           Wtypef
     C                   PARM                    LNNO
     C                   PARM      *ZEROS        SEQ
     C                   PARM      *ZEROS        COD
     C                   PARM      *ZEROS        FACL
     C                   PARM                    BRCA
     C                   PARM                    CNUM
     C                   PARM                    EDAT
     C                   PARM                    w@Prin
     C                   PARM                    w@Int
     C                   PARM                    W@Av
     C                   PARM      PAMT          W@OrigP
     C                   PARM      IAMT          W@OrigI
     C                   PARM      ALASN         W@LASN
     C                   PARM                    W@AVDAT
     C                   PARM                    W@Type
      *
      ** Output parm
      **  Past Due Principal
      **  Past Due interest
      *
     C                   PARM      *ZERO         w@OPdam
     C                   PARM      *ZERO         w@OPdInt
      *
     C                   PARM      *BLANKS       w@FELN
     C                   PARM      'LEC000456'   W@PGNM
     C                   PARM      BlockCredit   W@BCR                                     MD021423E
      *
      ** If Return code is NOINTPD, then ignore interest
      *
     C                   IF        wRetcd = 'NOINTPD'
     C                             AND w@TYPE = 'I'
     C                   EVAL      WignoreI = 'Y'
     C                   ENDIF
      *
      ** Error in LEC000473
      *
     C                   IF        wRetcd <>  *BLANKS
     C                             AND wRetcd <> 'NOINTPD'
     C                             OR *INU7 = *ON
     C                             AND *INU8 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      Wloan = LNNO
     C                   EVAL      Wcnu2 = CNUM
     C                   EVAL      Wfbrcd = BRCA
     C                   EVAL      DBKEY = Wcnu2 + WLoan + Wfbrcd
     C                   EVAL      DBFILE = 'LEC000473'
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EVAL      *IN88 = *ON
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdack - Update account key                                 *
      *                                                               *
      * Called by: SRPDCL                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRUpdack      BEGSR
      *
     C                   EVAL      w@Pdamt = W@Opdam + W@OPdInt
     C                   EVAL      w@OEAMT = EAMT
     C                   EVAL      AAMT = P@BLAF
     C                   EVAL      IPFL = 'P'
     C                   Z-ADD     1             WMult
      *
     C                   SELECT
      *
      ** When the repayment is fully past due:
      *
     C                   WHEN      WpastDue = 'Y'
      *
      ** If both Past Due Interest and Past Due principal are not zero
      ** - amend account key field from xxRyy----B to xxRyy---DP
      **   and set amount = Past due principal
      ** - create new account key  xxRyy---DI
      **   with amount = Past Due Interest
      *
     C                   IF        W@OpdInt <> 0
     C                             AND W@Opdam <> 0
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ENDIF
     C                   EVAL      EAMT = W@Opdam
     C                   EXSR      SrConvert                                                MD046080
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XP'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   UPDATE    LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
      *
      ** Write new account key: field xxRyy---DI
      *
      ** If type is I-Interest and return code is NOINTPD, then ignore
      ** the past due interest. The return code is NOINTPD when the
      ** separate indicator is 'N' and the Capitalized indicator is 'N'
      *
     C                   IF        W@Type <> 'I'
     C                             OR W@Type = 'I'
     C                             AND WIgnoreI <> 'Y'
     C                   EVAL      EAMT = W@OPdInt
     C                   EVAL      EAMT = EAMT * WMult
     C                   EXSR      SrConvert                                                MD046080
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XI'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   Z-ADD     0             AAMT
     C                   WRITE     LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   ADD       1             W@NewRc
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Past Due Principal
      *
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ENDIF
     C                   IF        W@Opdam <> 0
     C                   EVAL      EAMT = W@Opdam
     C                   EXSR      SrConvert                                                MD046080
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XP'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   UPDATE    LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   ENDIF
      *
      ** Past Due Interest
      *
      ** If type is I-Interest and return code is NOINTPD, then ignore
      ** the past due interest. The return code is NOINTPD when the
      ** separate indicator is 'N' and the Capitalized indicator is 'N'
      *
     C                   IF        W@OpdInt <> 0
      *
     C                   IF        W@Type <> 'I'
     C                             OR W@Type = 'I'
     C                             AND WIgnoreI <> 'Y'
      *
     C                   EVAL      EAMT = W@OpdInt
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XI'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   ENDIF
     C                   EXSR      SrConvert                                                MD046080
      *
     C                   UPDATE    LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   ENDIF
      *
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
      *
      ** If Total Past Due does not match original value of EAMT
      ** - create a new account key xxRyy----B for the difference
      *
     C                   IF        w@Pdamt <> wRepaym
     C                   EVAL      EAMT = WRepaym - W@Pdamt
      *
     C                   IF        w@OEAMT < 0
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
      *
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      ' B'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   WRITE     LEPK1DPF
     C                   ADD       1             W@NewRc
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
      *
      ** When the repayment is partly past due:
      ** - update existing account key xxRyy----B and set amount
      **   = Available Balance
      ** - create new account key  xxRyy---DI with amount
      **   = Past Due Interest
      ** - create new account key  xxRyy---DP with amount
      **   = Past Due Principal
      *
     C                   WHEN      WpastDue = 'P'
      *
      ** If type is I-Interest and return code is NOINTPD, then ignore
      ** the past due interest. The return code is NOINTPD when the
      ** separate indicator is 'N' and the Capitalized indicator is 'N'
      *
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ENDIF
     C                   IF        W@Type <> 'I'
     C                             OR W@Type = 'I'
     C                             AND WIgnoreI <> 'Y'
      *
      ** Update existing account key xxRyy----B and set amount
      ** = Available Balance
      *
     C                   EVAL      EAMT = W@Avail
     C                   IF        W@OEAMT < 0
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
     C                   ENDIF
     C                   UPDATE    LEPK1DPF
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
      *
      ** Write Past Due Principal account key
      *
     C                   IF        W@Opdam <> 0
     C                   EVAL      EAMT = W@Opdam
     C                   IF        W@OEAMT < 0
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
     C                   EXSR      SrConvert                                                MD046080
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XP'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   Z-ADD     0             AAMT
     C                   WRITE     LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   ADD       1             W@NewRc
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
      *
      ** Past Due Interest
      *
     C                   IF        W@Type <> 'I'
     C                             OR W@Type = 'I'
     C                             AND WIgnoreI <> 'Y'
     C                   IF        W@OpdInt <> 0
     C                   EVAL      EAMT = W@OpdInt
     C                   IF        W@OEAMT < 0
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
     C                   EXSR      SrConvert                                                MD046080
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XI'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   Z-ADD     0             AAMT
     C                   WRITE     LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   ADD       1             W@NewRc
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If Total Past Due does not match original value of EAMT
      ** - create a new account key xxRyy----B for the difference
      *
     C                   EVAL      W@Totak = W@Pdamt + W@Avail
     C                   IF        w@Totak <> wRepaym
     C                   EVAL      EAMT = WRepaym - W@Totak
      *
     C                   IF        w@OEAMT < 0
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
      *
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      ' B'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   WRITE     LEPK1DPF
     C                   ADD       1             W@NewRc
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
      *
      ** When reverse
      *
     C                   WHEN      WReverse = 'Y'
     C                   EXSR      SRReverse
      *
      ** If Repayment is not past due, set account key flag = processed
      *
     C                   OTHER
     C                   UPDATE    LEPK1DPF
      *
     C                   ENDSL
      *
      ** Update ACTNPL1
      *
     C                   IF        WPastDue = 'Y'
     C                             OR WPastDue = 'P'
     C     KACTN1        CHAIN     ACTNPL1
     C                   IF        %FOUND
      *
      ** Interest
      *
     C                   IF        INTA < 0
     C                   EVAL      INTA = INTA + W@OPdInt
     C                   EVAL      TAMT  = TAMT + W@OPdInt
     C                   ENDIF
     C                   IF        INTA  > 0
     C                   EVAL      INTA = INTA - W@OPdInt
     C                   EVAL      TAMT  = TAMT - W@OPdInt
     C                   ENDIF
      *
      ** Principal
      *
     C                   IF        PRAM  < 0
     C                   EVAL      PRAM = PRAM + W@OPdAm
     C                   EVAL      TAMT = TAMT + W@OPdam
     C                   ENDIF
     C                   IF        PRAM  > 0
     C                   EVAL      PRAM = PRAM - W@OPdam
     C                   EVAL      TAMT = TAMT - W@OPdam
     C                   ENDIF
      *
      ** Update ACTNPL1
      *
     C                   UPDATE    LOAMSDKF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReverse - Process reversals                                 *
      *                                                               *
      * Called by: SRUpdack                                           *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRReverse     BEGSR
 
     C                   CLEAR                   W@TotPD
     C                   CLEAR                   W@TotPI
     C                   CLEAR                   W@Totak
     C                   Z-ADD     EAMT          W@OEAMT
 
      ** Read a/c keys file that contains a/c key subject
      ** to funds pre-check
 
     C     KPDCL         SETLL     LEPDUEL5
     C                   EVAL      *IN87 = *OFF
 
      ** Loop to read a/c keys on LEPDUEPD to retrieve the total
      ** past due that was accounted to the DP account key
 
     C     *IN87         DOWEQ     *OFF
 
     C     KPDCLP        READE     LEPDUEL5                               87
 
      ** YTYLC = 'R' (ignore record if amount has already been
      ** reversed out)
 
     C                   IF        *IN87 = *OFF
     C                             AND YTYLC <> 'R'
 
      ** Past due principal
 
     C                   IF        W@TotPD < PAMT
 
     C                   IF        YPCPAM <= PAMT
     C                   ADD       YPCPAM        W@TotPD
     C                   ELSE
     C                   ADD       PAMT          W@TotPD
     C                   ENDIF
     C                   ENDIF
 
      ** Past due interest
 
     C                   IF        W@TotPI < IAMT
 
     C                   IF        YPDINT <= IAMT
     C                   ADD       YPCPAM        W@TotPD
     C                   ELSE
     C                   ADD       IAMT          W@TotPD
     C                   ENDIF
     C                   ENDIF
 
      ** If total past due is greater than the event amount,
      ** then subtract difference from LEPDUEPD
      ** otherwise flag record as processed
 
     C                   EVAL      W@Totak = W@TOTPD + W@TotPI
     C                   IF        W@Totak <= EAMT
     C                   EVAL      YTYLC = 'R'
     C                   ELSE
     C                   SUB       W@TotPI       YPDINT
     C                   SUB       W@TotPD       YPCPAM
     C                   ENDIF
     C                   UPDATE    LEPDUED0
     C                   ENDIF
     C                   ENDDO
 
      ** If Total Past Due Principal and Interest are greater than zero,
      ** then reverse them using a/c key  xxRyy---DP and xxRyy---DI
 
     C                   IF        W@TotPD <> *ZEROS
     C                             AND W@TotPI <> *ZEROS
 
      ** Principal
 
     C                   IF        W@TotPD <> *ZEROS
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XP'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ENDIF
     C                   EVAL      EAMT = W@TOTPD
     C                   IF        W@OEAMT < *ZEROS
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
     C                   EXSR      SrConvert                                                MD046080
 
     C                   MOVEL     Wf10          AKEY
     C                   UPDATE    LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
 
      ** Interest: write a new record on the account key file
 
     C                   IF        W@TotPI <> *ZEROS
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XI'          Wf10
     C                   EVAL      EAMT = W@TOTPI
     C                   IF        W@OEAMT < *ZEROS
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
     C                   EXSR      SrConvert                                                MD046080
 
     C                   Z-ADD     0             AAMT
     C                   WRITE     LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
 
     C                   ADD       1             W@NewRc
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
 
      ** If total reversed out is different from Account key original
      ** amount, then create an account key xxRyy----B  with amount
      ** = Difference between Original amount and amount already
      ** reversed out.
 
     C                   IF        w@Totak <> wRepaym
     C                   EVAL      EAMT = WRepaym - W@Totak
 
     C                   IF        w@OEAMT < 0
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
 
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      ' B'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   WRITE     LEPK1DPF
     C                   ADD       1             W@NewRc
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ENDIF
 
      ** If either the Past Due principal or the past due interest
      ** are not zero
 
     C                   ELSE
 
      ** Principal
 
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ENDIF
     C                   IF        W@TotPD <> *ZEROS
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XP'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   EVAL      EAMT = W@TOTPD
     C                   IF        W@OEAMT < *ZEROS
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
     C                   EXSR      SrConvert                                                MD046080
 
     C                   MOVEL     Wf10          AKEY
     C                   UPDATE    LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   ENDIF
 
      ** Interest
 
     C                   IF        W@TotPI <> *ZEROS
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      'XI'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   EVAL      EAMT = W@TOTPI
     C                   IF        W@OEAMT < *ZEROS
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
     C                   EXSR      SrConvert                                                MD046080
 
     C                   MOVEL     Wf10          AKEY
     C                   UPDATE    LEPK1DPF
     C**********         EVAL      EAMT = WWWAMT                                   MD046080 MD048557
     C                   EVAL      ECCY = WZCCY                                             MD046080
     C                   ENDIF
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
 
      ** If total reversed out is different from Account key original
      ** amount, then create an account key xxRyy----B  with amount =
      ** Difference between Original amount and amount already rev. out
 
     C                   IF        w@Totak <> wRepaym
     C                   EVAL      EAMT = WRepaym - W@Totak
 
     C                   IF        w@OEAMT < 0
     C                   EVAL      EAMT = EAMT * -1
     C                   ENDIF
 
     C                   MOVEL     AKEY          Wf10
     C                   MOVE      ' B'          Wf10
     C                   MOVEL     Wf10          AKEY
     C                   WRITE     LEPK1DPF
     C                   IF        EAMT > 0
     C                   EVAL      w@adjamt = w@adjamt + EAMT
     C                   ELSE
     C                   EVAL      w@adjamt = w@adjamt - EAMT
     C                   ENDIF
     C                   ADD       1             W@NewRc
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkLoan - Check Loans file                                  *
      *                                                               *
      * Called by: SRPDCL                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkLoan     BEGSR
      *
      ** Chain Loan file
      *
     C                   EVAL      K_RECI = RECI
     C     LNNO          CHAIN     CLOANCL6
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   MOVE      LNNO          Dbkey
     C                   MOVEL     'LELOANLW'    Dbfile
     C                   Z-ADD     004           Dbase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      RECI = K_RECI
      *
     C                   ENDSR
                                                                                            MD046080
      *****************************************************************                     MD046080
      /EJECT                                                                                MD046080
      *****************************************************************                     MD046080
      *                                                               *                     MD046080
      * SrConvert - Convert Currency                                  *                     MD046080
      *                                                               *                     MD046080
      *****************************************************************                     MD046080
                                                                                            MD046080
     C     SrConvert     BEGSR                                                              MD046080
                                                                                            MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   IF        CLE034 = 'Y'                                             MD046080
     C                             AND STAL = 'Y'                                           MD046080
     C                   MOVE      *BLANKS       WSET                                       MD046080
     C                   MOVE      OSAC          WSET                                       MD046080
     C                   IF        PTYP <> 66                                               MD046080
     C                             AND PTYP <> 67                                           MD046080
     C                             AND PTYP <> 69                                           MD046080
     C                             AND PTYP <> 72                                           MD046080
     C     KSTAL         CHAIN     LESTALLG                                                 MD046080
     C                   MOVE      G_RSCY        WCCY1                                      MD046080
     C                   MOVE      G_REXI        WIND1                                      MD046080
     C                   Z-ADD     G_REXR        WRATE                                      MD046080
     C                   ELSE                                                               MD046080
     C     KSTAL         CHAIN     LESTALLH                                                 MD046080
     C                   MOVE      H_PSCY        WCCY1                                      MD046080
     C                   MOVE      H_PEXI        WIND1                                      MD046080
     C                   Z-ADD     H_PEXR        WRATE                                      MD046080
     C                   ENDIF                                                              MD046080
     C                   ELSE                                                               MD046080
     C                   IF        PTYP <> 66                                               MD046080
     C                             AND PTYP <> 67                                           MD046080
     C                             AND PTYP <> 69                                           MD046080
     C                             AND PTYP <> 72                                           MD046080
     C                   EVAL      WCCY1 = PSCY                                             MD046080
     C                   EVAL      WRATE = PEXR                                             MD046080
     C                   EVAL      WIND1 = PEXI                                             MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WCCY1 = SCCY                                             MD046080
     C                   EVAL      WRATE = REXR                                             MD046080
     C                   EVAL      WIND1 = REXI                                             MD046080
     C                   ENDIF                                                              MD046080
     C                   ENDIF                                                              MD046080
     C                   EVAL      WCCY2 = CCY                                              MD046080
     C                   EVAL      WWWAMT = EAMT                                            MD046080
     C                   EVAL      WINAMT = EAMT                                            MD046080
     C                   IF        WIND1 = 'M'                                              MD046080
     C                   EVAL      WMDIN = 'D'                                              MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WMDIN = 'M'                                              MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
      ** If one of currencies is blank, skip conversion                                     MD046080
                                                                                            MD046080
     C                   IF        WCCY1 = *BLANKS or WCCY2 = *BLANKS                       MD046080
     C                   EVAL      WOUTAMT = WINAMT                                         MD046080
     C                   ELSE                                                               MD046080
                                                                                            MD046080
      ** From currency                                                                      MD046080
                                                                                            MD046080
     C                   CALL      'AOCURRR0'                                               MD046080
     C                   PARM      *Blanks       @RTCD                                      MD046080
     C                   PARM      '*KEY'        @OPTN                                      MD046080
     C                   PARM                    WCCY1                                      MD046080
     C     SDCURR        PARM                    DSSDY                                      MD046080
                                                                                            MD046080
      ** Save necessary details                                                             MD046080
                                                                                            MD046080
     C                   EVAL      WSPRT1 = A6SPRT                                          MD046080
     C                   EVAL      WMDIN1 = A6MDIN                                          MD046080
     C                   EVAL      WNBDP1 = A6NBDP                                          MD046080
                                                                                            MD046080
      ** To currency                                                                        MD046080
                                                                                            MD046080
     C                   CALL      'AOCURRR0'                                               MD046080
     C                   PARM      *Blanks       @RTCD                                      MD046080
     C                   PARM      '*KEY'        @OPTN                                      MD046080
     C                   PARM                    WCCY2                                      MD046080
     C     SDCURR        PARM                    DSSDY                                      MD046080
                                                                                            MD046080
      ** Save necessary details                                                             MD046080
                                                                                            MD046080
     C                   EVAL      WSPRT2 = A6SPRT                                          MD046080
     C                   EVAL      WMDIN2 = A6MDIN                                          MD046080
     C                   EVAL      WNBDP2 = A6NBDP                                          MD046080
                                                                                            MD046080
      ** Convert amount                                                                     MD046080
                                                                                            MD046080
     C                   CALL      'ZCONVZ1'                                                MD046080
     C                   PARM                    WINAMT                                     MD046080
     C                   PARM                    WRATE                                      MD046080
     C                   PARM                    WMDIN                                      MD046080
     C                   PARM                    WCCY1                                      MD046080
     C                   PARM                    WCCY2                                      MD046080
     C                   PARM                    WNBDP1                                     MD046080
     C                   PARM                    WNBDP2                                     MD046080
     C                   PARM                    WOUTAMT                                    MD046080
                                                                                            MD046080
     C                   ENDIF                                                              MD046080
     C                   EVAL      EAMT = WOUTAMT                                           MD046080
     C                   EVAL      WZCCY = ECCY                                             MD046080
     C                   EVAL      ECCY = CCY                                               MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WWWAMT = EAMT                                            MD046080
     C                   EVAL      WZCCY = ECCY                                             MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   ENDSR                                                              MD046080
                                                                                            MD046080
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdtra - Update trailer                                     *
      *                                                               *
      * Called by: SRPDCL                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRUpdtra      BEGSR
 
     C                   IF        W@NewRc <> 0
     C                             OR w@adjamt <> 0
     C     1             SETLL     LEPK1ZZ
     C                   READ      LEPK1ZZ                                88
     C                   IF        *IN88 = *OFF
 
     C                   ADD       W@NewRC       NORE
      *
      ***  Set up amount fields for insert
      *
     C                   IF        w@adjamt < 0
     C                   EVAL      W@adjamt = w@adjamt * - 1
     C                   ENDIF
     C     w@adjamt      DIV       1000          ZZAMT            15 3
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VLRF          ZZTOTI
     C                   Z-ADD     VLRL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VLRF
     C                   Z-ADD     ZZTOTD        VLRL
 
     C                   UPDATE    LEPK1ZZF
     C                   ENDIF
     C                   CLEAR                   W@NewRc
     C                   CLEAR                   w@adjamt
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepo - Print report                                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRgetBRca, SRGetCcy, SRSetfield                        *
      *                                                               *
      *****************************************************************
     C     SRRepo        BEGSR
      *
      ** Read a/c keys file that contains a/c key subject
      ** to funds pre-check
      *
     C                   CLEAR                   NORE
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      WBrca = *BLANKS
     C     *LOVAL        SETLL     LEPK1L0
      *
      ** Loop to read a/c keys on LEPK1DPD
      *
     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK1L0                                88
     C                   IF        *IN88 = *OFF
      *
     C                   ADD       1             NORE
      *
      ** Access branch details
      *
     C                   IF        BRCA <> Wbrca
     C                   EVAL      Branch = BRCA
     C                   EXSR      SRgetBRca
     C                   IF        SUPFLG <> 'Y'
     C                   WRITE     LE0456H1
     C                   WRITE     LE0456H2
     C                   ENDIF
     C                   EVAL      WBRca = BRCA
     C                   ENDIF
      *
      ** Access ccy details
      *
     C                   IF        Eccy <> WEccy
     C                   EXSR      SRGetCcy
     C                   EVAL      WEccy = ECCY
     C                   ENDIF
      *
      ** Set fields
      *
     C                   EXSR      SRSetfield
      *
      ** Print report
      *
     C                   IF        SUPFLG <> 'Y'
     C                   IF        PRtlN1 >= 60
     C                   WRITE     LE0456H1
     C                   WRITE     LE0456H2
     C                   ENDIF
     C                   WRITE     LE0456D1
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** Print end of report page
      *
     C                   IF        SUPFLG <> 'Y'
     C                   IF        PRtlN1 >= 60
     C                   WRITE     LE0456H1
     C                   ENDIF
     C                   WRITE     LE0456T1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCcy - Retrieve currency details                         *
      *                                                               *
      *  Called by: SRRepo                                            *
      *                                                               *
      *  Calls: *None                                                 *
      *                                                               *
      *****************************************************************
     C     SRGetCcy      BEGSR
 
      ** Use details from the array if currency in the cache,
      ** otherwise, retrieve details from Access Object program
 
     C                   EVAL      CurrKey = ECCY
     C                   EVAL      CurrIdx = %LOOKUP( CurrKey :
     C                                                CurrCache :
     C                                                1 : TrailIdx )
     C
     C                   IF        CurrIdx > 0
     C                   EVAL      SDCURR = DSCurr(CurrIdx)
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    ECCY
     C     SDCURR        PARM                    DSSDY
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSetfield - Format fields                                   *
      *                                                               *
      *  Called by: SRRepo                                            *
      *                                                               *
      *  Calls: ZSEDIT                                                *
      *                                                               *
      *****************************************************************
     C     SRSetfield    BEGSR
 
     C                   EVAL      ZFLD15 = EAMT
     C                   EVAL      Zdecs = A6NBDP
     C                   EVAL      Zecode = 'J'
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        OEAMT
 
     C                   EVAL      ZFLD15 = AAMT
     C                   EVAL      Zdecs = A6NBDP
     C                   EVAL      Zecode = 'J'
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        OAAMT
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRgetBRca - Retrieve branch details                          *
      *                                                               *
      *  Called by: SRRepo                                            *
      *                                                               *
      *  Calls: *None                                                 *
      *                                                               *
      *****************************************************************
     C     SRgetBRca     BEGSR
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    Branch
     C     SDBRCH        PARM                    DSSDY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUB  -  Subtracts an amount (ZZAMT) from the total         *
      *                                                               *
      * Called by: *None                                              *
      *                                                               *
      * Calls: GLZADD                                                 *
      *                                                               *
      *****************************************************************
     C     GLZSUB        BEGSR
      *
      ***  Just reverse the 'sign' and add
      *
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   EXSR      GLZADD
     C                   Z-SUB     ZZAMT         ZZAMT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZADD  -  Adds an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)*
      *                                                               *
      * Called by: GLZSUB                                             *
      *                                                               *
      * Calls: GLZSUM                                                 *
      *                                                               *
      *****************************************************************
     C     GLZADD        BEGSR
      *
     C     ZZAMT         IFNE      *ZERO
      *
      ***  Split ZZAMT into integer and decimal fields
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
      *
      ***  Both ZZAMTI and ZZAMTD contain a 'sign' zone now
      *
     C                   EXSR      GLZSUM
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUM  -  Carries out the addition of the amounts            *
      *                                                               *
      * Called by: GLZADD                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
      ***  Save values of indicators to be used in the program
      *
     C                   MOVE      *IN91         WIN91             1
     C                   MOVE      *IN92         WIN92             1
     C                   MOVE      *IN93         WIN93             1
     C                   MOVE      *IN94         WIN94             1
     C                   MOVE      *IN95         WIN95             1
     C                   MOVE      *IN96         WIN96             1
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ***  Determine sign of ZZAMTI and ZZAMTD, 92 if neg
      *
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
      *
      ***  Determine sign of ZZTOTI and ZZTOTD, 91 if neg
      *
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
      *
      ***  If ZZTOTAL is zero, return ZZAMOUNT
      *
     C   93              Z-ADD     ZZAMTI        ZZTOTI           15 0
     C   93              Z-ADD     ZZAMTD        ZZTOTD            3 0
     C   93              GOTO      ZZSEND
      *
      ***  If signs differ, bypass overflow checks
      *
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
     C*
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      ***  If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured
      *
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
      *
      ***  If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left intact
      *
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
      *
      ***  The 'signs' are different
      *
     C     ZZOFPS        TAG
      *
      ***  If ZZAMT was negative, make it pos. to como with ZZTOT
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
      *
      ***  If ZZTOT was negative, make it pos. to comp with ZZAMT.
      *
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
      *
      ***  Both ZZAMT and ZZTOT are now positive
      *
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      ***  If ZZTOT eq. ZZAMT return ZERO.
      *
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
      *
      ***  If ZZTOT gt. ZZAMT.
      *
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
      *
      ***  If ZZAMT gt. ZZTOT.
      *
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
      *
      ***  Reverse sign of ZZTOT if larger I/P fields were negative
      *
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
      *
      ***  Restore sign of ZZAMTI & ZZAMTD if it was reversed
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG
      *
      ***  If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
      *
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
      *
      ***  Restore previous indicator values
      *
     C                   MOVE      WIN91         *IN91
     C                   MOVE      WIN92         *IN92
     C                   MOVE      WIN93         *IN93
     C                   MOVE      WIN94         *IN94
     C                   MOVE      WIN95         *IN95
     C                   MOVE      WIN96         *IN96
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOTRADR0, AOBANKR0, AOSVALR0                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    pAPOS
     C                   PARM                    pCNAME
     C                   PARM                    pReturnCode
 
     C                   EVAL      dbPgm = PSProcPgm
 
     C     KACTN1        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    LNNO
     C                   KFLD                    AVDAT
     C                   KFLD                    APRSQ
     C                   KFLD                    ALASN
 
     C     Kpdcl         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    LNNO
     C                   KFLD                    EDAT
 
     C     Kpdclp        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    LNNO
 
     C     Kcloan        KLIST
     C                   KFLD                    LNNO
     C                   KFLD                    RCDTT
                                                                                            MD046080
     C     KSTAL         KLIST                                                              MD046080
     C                   KFLD                    LNRF                                       MD046080
     C                   KFLD                    WSET                                       MD046080
                                                                                            MD046080
     C                   EVAL      RCDTT = 'A'
 
      ** Access General Ledger details
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ** DBERR 005
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   Z-ADD     005           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
 
      ** Retrieve trading data
 
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
      ** DBERR 006
 
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
                                                                                            MD046080
     C                   CALL      'AOSARDR0'                                               MD046080
     C                   PARM      *BLANKS       @RTCD                                      MD046080
     C                   PARM      '*VERIFY'     @OPTN                                      MD046080
     C                   PARM      'CLE031'      @SARD                                      MD046080
                                                                                            MD046080
     C                   IF        @RTCD       = *BLANKS                                    MD046080
     C                   EVAL      CLE031      = 'Y'                                        MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   CALL      'AOSARDR0'                                               MD046080
     C                   PARM      *BLANKS       @RTCD                                      MD046080
     C                   PARM      '*VERIFY'     @OPTN                                      MD046080
     C                   PARM      'CLE034'      @SARD                                      MD046080
                                                                                            MD046080
     C                   IF        @RTCD       = *BLANKS                                    MD046080
     C                   EVAL      CLE034      = 'Y'                                        MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
      ** Check System Value: Use Original Borrower or Purchased From?
      ** Set up parameter so access object checks LoanCustOriginPurch
 
     C                   EVAL      SVALK1 = WPARM
 
      ** Call Access object:
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    WRetcd
     C                   PARM                    SVALK1
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10
 
      ** If the system value is not found then default value to 'P'
 
     C                   IF        WRetcd <> *BLANKS
     C                   EVAL      PPCUST = 'P'
     C                   ELSE
 
      ** Isolate the first character of SVAL1 which = 'P' or 'O'.
 
     C                   MOVEL     SVAL1         WRK01
     C                   IF        WRK01 = 'O'
     C                   EVAL      PPCUST = 'O'
     C                   ELSE
     C                   EVAL      PPCUST = 'P'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      SUPFLG = 'N'
     C                   CALL      'AOCOMR0'
     C                   PARM      'LEC000456'   PNAME
     C                   PARM      '*ALL'        PCSEQ
     C                   PARM      'LE00045601'  PSCTN
     C                   PARM      *BLANKS       PRTCD
 
     C                   IF        PRTCD = 'Y'
     C                   EVAL      SUPFLG = 'Y'
     C                   ENDIF
 
      ** Full Cache SDCURRPD
 
     C                   READ      SDCURRL1
     C                   DOW       not %EOF and CurrIdx <= %ELEM(CurrCache)
     C                   EVAL      CurrCache(CurrIdx) = A6CYCD
     C                   EVAL      DSCurr(CurrIdx) = SDCURR
     C                   EVAL      CurrIdx = CurrIdx + 1
     C                   READ      SDCURRL1
     C                   ENDDO
 
     C                   EVAL      TrailIdx = CurrIdx - 1
 
     C     *LIKE         DEFINE    EAMT          WRepaym
     C     *LIKE         DEFINE    EAMT          WEAMT
 
     C     *LIKE         DEFINE    LNRF          W@FELN
 
     C                   WRITE     LE0456H1
     C                   WRITE     LE0456H2
 
     C                   ENDSR
 
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Error handling                                        *
      *                                                               *
      * Called by: Automatically called by the program                *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   ROLBK
     C                   IF        runBefore <> 'Y'
     C                   EVAL      runBefore = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      pReturnCode = '*ERROR*'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     C/COPY ZSRSRC,ZSEDITZ3LE
