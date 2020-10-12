     H DEBUG
     H Copyright('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL process - non calculated fees')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000131 - Past Due Call Loans: Non calculated fees process  *
      *                                                               *
      *  Function:  This program reads the new account keys file      *
      *             LEPK3DPD and for each repayment account key it    *
      *             checks whether the settlement account has         *
      *             enough balance to cover the payment. If the       *
      *             balance is enough then it generates the payment   *
      *             otherwise it creates a PDCL                       *
      *                                                               *
      *  (Note) - Changes to LE000131 should be applied to LE000138   *
      *                                                               *
      *  Called By: LEC000131 (COB) - PDCL generation for non         *
      *             calculated fees.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD052008           Date 05Oct18               *
      *                 MD051940           Date 21Sep18               *
      *                 MD051242           Date 29Jun18               *
      *                 MD049745A          Date 16Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD046080           Date 17Sep17               *
      *                 CGL165             Date 17Feb15               *
      *                 CLE164             Date 18Aug14               *
      *                 MD022807H          Date 22Apr14               *
      *                 MD021423E          Date 12Sep13               *
      *                 MD021423 *REWRITE  Date 21Aug13               *
      *                 AR1085742          Date 06Jan13               *
      *                 AR1063739          Date 03Dec12               *
      *                 AR1056323          Date 14Nov12               *
      *                 AR1021983          Date 01Aug12               *
      *                 AR757272           Date 01Aug12               *
      *                 AR724089           Date 01Aug12               *
      *                 AR402058           Date 01Aug12               *
      *                 AR217562           Date 01Aug12               *
      *                 263359             Date 01Aug12               *
      *                 263074             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD052008 - Rounding off issue on PDCL amount using           *
      *             settlement account with partial balance           *
      *  MD051940 - PDCL X, Y, Z amount is incorrect as a result of   *
      *             conversion rounding error.                        *
      *  MD051242 - CLE031: COB: GLC0340 failed with Currency out of  *
      *             balance for fee with no settlement currency       *
      *  MD049745A - Corruption of Original currency of Loans and     *
      *              PDCLs incorrect postings                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046080 - Gap between CLE031 (Settlement to different       *
      *             currency) and CLE134 (PDCL processing)            *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  MD022807H - Value date of PDCL and PI should be defaulted    *
      *              from the value date of the transaction           *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *  AR1085742 - Recovery handling when PDP components loop due   *
      *              to database connection issues                    *
      *  AR1063739 - SettlementAccount09 Issues                       *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  AR1021983 - Option C - Technical Enhancements Stated in POC  *
      *  AR757272 - PDCL for fee difference was not created in case   *
      *             of partial fee repayment. Zeroise var W@Av before *
      *             passing as parameter. (Child: AR757273)           *
      *  AR724089 - Several performance issues in COB component       *
      *             LEC000459. Call LE000475 directly, instead of     *
      *             passing thru LEC000475. (Child: AR724090)         *
      *  AR402058 - Overdraft PDCL repayments                         *
      *             (Child: AR402059)                                 *
      *  AR217562 - Incorrect Repayment methodology                   *
      *             (Child: AR217563)                                 *
      *  263359 - Data base error 003.                                *
      *  263074 - Wrong Postings when interest and principal are paid *
      *           on the same day (Recompile)                         *
      *           CLE134 / SWIFT                                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      *
      ** Fee Past Due Call Loans Account Keys
     FLEPK3L2   UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Fee Past Due Call Loans Account Key Trailer
     FLEPK3ZZ   UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Past Due & Original Fees Link
     FLEPDUFL5  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Fee Settl Det by BRCA, CNUM, FACL, LOAN, FSEQ
     FLEFEEDLU  IF   E           K DISK    Rename(LEFEEDF:LEFEEDFO)
      *
      ** Lending Fees Master Detail File
     FLEFEED    UF   E           K DISK    COMMIT
      *
      ** Fee Past Due Call Loans Account Keys
     FLEPK3L3   IF   E           K DISK    Rename(LKEYFEDF: LKEYFED3)
      *
      ** Midas LE Settlement Allocation File                                                MD046080
     FLESTALLF  IF   E           K DISK                                                     MD046080
     F                                     PREFIX(L_)                                       MD046080
      *                                                                                     MD046080
      ** Print File for Non-calculated and loan fee accruals account keys
     FLE000131P1O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
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

      ** Data structure for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Data structure for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** Data structure for Trade Details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACCD1       E                     EXTFLD(QQACCD)

      ** Data structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                           MD021423E
      ** Data Structure for Account Details                                                MD021423E
     D ACCNTB        E DS                  EXTNAME(ACCNTAB)                                MD021423E

      ** Data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)

      ** Data structure for fees ICD details
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
     D DSFDY         e ds
     D DSSDY         e ds
     D wFeekey         DS
     D wFcnu2                  1      6
     D wFlnno                  8     13
     D wFefseq                15     16
     D wFefcod                18     19

     D pReturnCode     s              7
     D CLE134          S              1
     D WRetcd          S              7
     D pAPOS           S              1
     D pCNAME          S             10
     D wPostR          S              1
     D WPARM           S             20A   INZ('LoanCustOriginPurch')

      ** Account
     D wLoan           S              6
     D wcnu2           S              6
     D wFacl           S              5
     D wFseq           S              2
     D wFcod           S              2
     D wFcodN          S              2  0
     D wFbrcd          S              3

     D wCurr           S              3
     D wBrca           S              3

      ** Balance check
     D P@BLAF          S             15P 0
     D W@Avail         S             15P 0
     D w@Av            S             15P 0
     D W@LASN          S              3P 0
     D w@Pdamt         S             15P 0
     D W@AVDAT         S              5P 0
     D w@Origp         S             15P 0
     D w@OrigI         S             15P 0
     D w@Int           S             15P 0
     D w@TotPD         S             15P 0
     D w@newRc         S              1P 0
     D w@OPdam         S             15P 0
     D w@OPdInt        S             15P 0
     D W@BCR           S              1A                                                   MK021423E
     D WSCCY           S              3A                                                   MD049745A
     D WSIND           S              1A                                                   MD049745A
     D WSRATE          S             13P 8                                                 MD049745A
     D WREV            S              1A                                                   MD049745A

     D ZS2             S              1    DIM(21)
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)

      ** Additional Field Definitions
     D WPastDue        S              1
     D WReverse        S              1
     D WDrCr           S              1
     D WMult           S              1  0
     D Wf10            S             10
     D Wtypef          S              1
     D W@Type          S              1
     D Branch          S              3
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
     D WRK01           S              1
     D PPCUST          S              1
     D W@PGNM          S             10
     D BlockCredit     S              1A   INZ(*BLANKS)                                    MD021423E
     D  PRetCode       S              7A                                                   MD021423E
     D  POption        S              7A                                                   MD021423E
     D  PRETL          S             10A                                                   MD021423E
     D  PCustNum       S              6A                                                   MD021423E
     D  PCurrency      S              3A                                                   MD021423E
     D  PAccCode       S             10S 0                                                 MD021423E
     D  PAccSeq        S              2S 0                                                 MD021423E
     D  PBranch        S              3A                                                   MD021423E

     D WINAMT          S             15  0                                                  MD046080
     D WRATE           S             13  8                                                  MD046080
     D WREXI           S              1A                                                    MD046080
     D WMDIN           S              1A                                                    MD046080
     D WCCY1           S              3A                                                    MD046080
     D WCCY2           S              3A                                                    MD046080
     D WNBDP1          S              1  0                                                  MD046080
     D WNBDP2          S              1  0                                                  MD046080
     D WOUTAMT         S             15  0                                                  MD046080
     D WWWAMT          S             15P 0                                                  MD046080
     D ORWAMT          S             15P 0                                                  MD046080
     D CLE031          S              1A                                                    MD046080
     D CLE034          S              1A                                                    MD046080
     D w@adjamt        S             15P 0                                                  MD051242
     D WMINUS          S              1A                                                    MD051242
                                                                                            MD046080
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************
      *
      ** Read a/c keys file that contains a/c key subject to funds
      ** pre-check
      *
     C     *LOVAL        SETLL     LEPK3L2
      *
      ** loop to read a/c keys on LEPK3DPD
      *
     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK3L2                                88
     C     *IN88         IFEQ      *OFF
      *
      ** Check if account key has posting ref 2
      *
     C                   EXSR      CheckAC
      *
      ** if Post Ref 2 exists, process account key
      *
     C     wPostR        IFEQ      '2'
     C                   EXSR      SrPDCL
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
      ** Produce Report
      *
     C                   EXSR      SrRepo
     C                   EVAL      *INLR       = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPDCL - Process Account Key                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ChkBal, Updack, Chkfee, Updfez, GenPdcl                *
      *                                                               *
      *****************************************************************
     C     SrPDCL        BEGSR

      ** Check Account Balance

     C                   EXSR      ChkBal

      ** Update fee                                                                         MD046080
                                                                                            MD046080
     C                   EXSR      Chkfee                                                   MD046080
                                                                                            MD046080
      ** Update/create account key

     C                   EXSR      Updack

      ***Update*fee****************************************************                     MD046080
      **********                                                                            MD046080
     C**********         EXSR      Chkfee                                                   MD046080

      ** Update a/ck trailer

     C                   EXSR      Updfez

      ** call function to update/generate PDCL

     C                   EXSR      GenPdcl
     C                   COMMIT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CheckAC - Check Account Key                                   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     CheckAC       BEGSR
      *
      ** check whether the account key has settlement account defined
      ** If debit account is blanks then flag the record as processed
      ** and skip to next record
      *
     C                   CLEAR                   WPostr
     C                   IF        SEBRCA <> *BLANKS and
     C                             seaccy <> *BLANKS and
     C                             SECNUM <> *BLANKS and SEACOD > 0
     C                             and seacsq > 0
     C                   EVAL      wPostR = '2'
      *                                                                                    MD021423E
     C                   CALL      'AOACCTR0'                                              MD021423E
     C                   PARM      *BLANKS       PRetCode                                  MD021423E
     C                   PARM      '*KEY   '     POption                                   MD021423E
     C                   PARM      *BLANKS       PRETL                                     MD021423E
     C                   PARM      SECNUM        PCustNum                                  MD021423E
     C                   PARM      SEACCY        PCurrency                                 MD021423E
     C                   PARM      SEACOD        PAccCode                                  MD021423E
     C                   PARM      SEACSQ        PAccSeq                                   MD021423E
     C                   PARM      SEBRCA        PBranch                                   MD021423E
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
     C                   EVAL      LKIPFL = 'P'
     C                   UPDATE    LKEYFEDF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkBal - Check Account Balance                                *
      *                                                               *
      * Called by: SrPDCL                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     ChkBal        BEGSR
     C                   CLEAR                   w@adjamt                                   MD051242
     C                   MOVE      LKFCOD        WFCODN

     C                   CLEAR                   W@NewRc
     C                   MOVE      'N'           WPastDue
     C                   MOVE      'N'           WReverse
     C                   MOVE      *BLANKS       WDrCr
     C                   EVAL      WSCCY = *Blanks                                         MD049745A
     C                   EVAL      WSIND = *Blanks                                         MD049745A
     C                   EVAL      WSRATE = *ZERO                                          MD049745A
     C                   Z-ADD     LKEAMT        WRepaym
     C     WRepaym       IFLT      0
     C                   MULT      -1            WRepaym
     C                   ENDIF

     C                   EVAL      P@BLAF      = LKAAMT

      ** set available balance flag

     C                   MOVE      *BLANKS       WDrCr
     C                   EVAL      W@Avail = *ZERO
     C     P@BLAF        IFLT      0
     C                   EVAL      W@Avail = P@BLAF * -1
     C                   EVAL      WDrCr = 'C'
     C                   ELSE
     C                   EVAL      W@Avail = P@BLAF
     C                   EVAL      WDrCr = 'D'
     C                   ENDIF

      ** if available balance sign is credit

     C                   SELECT

      ** if account key amount is zero, set past due flag = 'N'

     C     LKEAMT        WHENEQ    0
     C                   MOVE      'N'           wPastDue

      ** if account key amount is negative, no check is needed as event
      ** amount is going to increase the account balance

     C     LKEAMT        WHENLT    0
     C     LKREVI        ANDEQ     0
     C                   MOVE      'N'           wPastDue

      ** if account key amount is positive and a/c key is reversed,
      ** do not check balance as event amount is going to increase the
      ** account balance.

     C     LKEAMT        WHENGT    0
     C     LKREVI        ANDEQ     1
     C                   MOVE      'N'           wPastDue
     C                   MOVE      'Y'           WReverse

      ** if available balance is zero, set the WPastDue flag =Y

     C     W@Avail       WHENEQ    0
     C                   MOVE      'Y'           wPastDue

      ** if available balance is debit, set past due flag = Y

     C     W@Avail       WHENGT    0
     C     WDrCr         ANDEQ     'D'
     C                   MOVE      'Y'           wPastDue

      ** if available balance is credit and is less than event amount,
      ** set past due flag = 'P'

     C     W@Avail       WHENGT    0
     C     WDrCr         ANDEQ     'C'
     C     WRepaym       ANDGT     0
     C     WRepaym       ANDGT     W@Avail
     C                   MOVE      'P'           wPastDue

      ** if available balance is credit and is equal to event amount,
      ** set past due flag = 'N'

     C     W@Avail       WHENGT    0
     C     WDrCr         ANDEQ     'C'
     C     WRepaym       ANDGT     0
     C     WREpaym       ANDEQ     W@Avail
     C                   MOVE      'N'           wPastDue

     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Updack - Update/create account key                            *
      *                                                               *
      * Called by: SrPDCL                                             *
      *                                                               *
      * Calls: SrReverse                                              *
      *                                                               *
      *****************************************************************
     C     Updack        BEGSR

     C                   EVAL      w@Pdamt = 0
     C                   IF        LKOTHA =  0                                              MD051940
     C                   EVAL      w@Origp = LKEAMT
     C                   ELSE                                                               MD051940
     C                   EVAL      w@Origp = LKOTHA                                         MD051940
     C                   ENDIF                                                              MD051940
     C                   EVAL      Lkaamt = P@BLAF
     C                   EVAL      LKIPFL = 'P'
     C                   Z-ADD     1             WMult

     C                   SELECT

      ** when the repayment is fully past due, update account key
      ** field xxRyy--nnD or fffR---nnD

     C     WPastDue      WHENEQ    'Y'
     C                   EVAL      w@Pdamt = LKEAMT
     C                   IF        CLE031 = 'Y'                                             MD051242
     C                   IF        LKEAMT > 0                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt - LKEAMT                             MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt + LKEAMT                             MD051242
     C                   ENDIF                                                              MD051242
     C                   EVAL      WINAMT = LKEAMT                                          MD051242
     C                   EVAL      ORWAMT = LKEAMT                                          MD051242
     C                   EXSR      SRCvtAmt                                                 MD051242
     C                   EVAL      LKEAMT = WOUTAMT                                         MD051242
     C                   EVAL      LKECCY = FEFCCY                                          MD051242
     C                   IF        LKEAMT > 0                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt + LKEAMT                             MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt - LKEAMT                             MD051242
     C                   ENDIF                                                              MD051242
     C                   IF        CLE031 = 'Y'                                             MD051242
     C                             AND w@adjamt < 1                                         MD051242
     C                   EVAL      WMINUS = 'Y'                                             MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      WMINUS = ' '                                             MD051242
     C                   ENDIF                                                              MD051242
     C                   ENDIF                                                              MD051242
     C     W@Pdamt       IFLT      0
     C                   MULT      -1            w@Pdamt
     C                   ENDIF
     C                   MOVEL     LKAKEY        Wf10
     C                   MOVE      'D'           Wf10
     C                   MOVEL     Wf10          LKAKEY
     C                   UPDATE    LKEYFEDF
      *                                                                                     MD051940
     C                   IF        LKOTHA <> 0                                              MD051940
     C                   EVAL      w@Pdamt = LKOTHA                                         MD051940
     C                   EVAL      WSCCY = *BLANKS                                          MD051940
     C                   ENDIF                                                              MD051940

      ** when the repayment is partly past due, update account key
      ** field xxRyy--nnD or fffR---nnD and create new account key

     C
     C     WPastDue      WHENEQ    'P'

     C     LKEAMT        IFLT      0
     C                   Z-ADD     -1            WMult
     C                   ENDIF

     C                   EVAL      w@Pdamt = WRepaym - W@Avail

      ** update repayment amount = available amount
                                                                                            MD051242
     C                   IF        LKEAMT > 0                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt - LKEAMT                             MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt + LKEAMT                             MD051242
     C                   ENDIF                                                              MD051242

     C                   EVAL      LKEAMT = W@AVAIL
     C                   MULT      WMult         LKEAMT
     C                   UPDATE    LKEYFEDF
                                                                                            MD051242
     C                   IF        LKEAMT > 0                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt + LKEAMT                             MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt - LKEAMT                             MD051242
     C                   ENDIF                                                              MD051242
     C                   IF        CLE031 = 'Y'                                             MD051242
     C                             AND w@adjamt < 1                                         MD051242
     C                   EVAL      WMINUS = 'Y'                                             MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      WMINUS = ' '                                             MD051242
     C                   ENDIF                                                              MD051242

      ** write new account key: field xxRyy--nnD or fffR---nnD

     C**********         EVAL      LKEAMT = W@Pdamt                                         MD052008
     C                   EVAL      LKEAMT = W@AVAIL                                         MD052008
     C                   MULT      WMult         LKEAMT
                                                                                            MD046080
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
                                                                                            MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      WINAMT = LKEAMT                                          MD046080
     C                   EVAL      ORWAMT = LKEAMT                                          MD046080
     C                   EXSR      SRCvtAmt                                                 MD046080
     C                   EVAL      LKEAMT = WOUTAMT                                         MD046080
     C                   EVAL      LKECCY = FEFCCY                                          MD046080
     C                   ENDIF                                                              MD051940
      ** Available balance is now in loan currency. Now deduct this from repayment          MD052008
      ** amount to get past due amount                                                      MD052008
     C                   EVAL      LKEAMT = W@ORIGP - LKEAMT                                MD052008
     C                   EVAL      W@PDAMT = LKEAMT                                         MD052008
     C                   EVAL      WSCCY   = *BLANKS                                        MD052008
      *                                                                                     MD052008
     C                   IF        LKEAMT > 0                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt + LKEAMT                             MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      w@adjamt = w@adjamt - LKEAMT                             MD051242
     C                   ENDIF                                                              MD051242
     C                   IF        CLE031 = 'Y'                                             MD051242
     C                             AND w@adjamt < 1                                         MD051242
     C                   EVAL      WMINUS = 'Y'                                             MD051242
     C                   ELSE                                                               MD051242
     C                   EVAL      WMINUS = ' '                                             MD051242
     C                   ENDIF                                                              MD051242
     C**********         ENDIF                                                     MD051242 MD051940
                                                                                            MD046080
     C                   EVAL      LKAAMT = 0
     C                   MOVEL     LKAKEY        Wf10
     C                   MOVE      'D'           Wf10
     C                   MOVEL     Wf10          LKAKEY
     C                   WRITE     LKEYFEDF
     C                   ADD       1             W@NewRc

      ** Put back the original value before convert                                MD046080 MD051940
     C**********         IF        CLE031 = 'Y'                                    MD046080 MD051940
     C**********         EVAL      LKEAMT = ORWAMT                                 MD046080 MD051940
     C**********         ENDIF                                                     MD046080 MD051940
                                                                                            MD046080
      ** when reverse

     C
     C     WReverse      WHENEQ    'Y'
     C                   EXSR      SrReverse

      ** if Repayment is not past due, set account key flag = processed

     C                   OTHER
     C                   UPDATE    LKEYFEDF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReverse - Repayment Reverse                                 *
      *                                                               *
      * Called by: Updack                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SrReverse     BEGSR

     C                   CLEAR                   W@TotPD
     C                   Z-ADD     LKEAMT        W@EAMT

      ** Read a/c keys file that contains a/c key subject to funds
      ** pre-check

     C     KPDCL         SETLL     LEPDUFL5
     C                   MOVE      *OFF          *IN87

      ** loop to read a/c keys on LEPDUFPD to retrieve the total past
      ** due that was accounted to the D  Account key

     C     *IN87         DOWEQ     *OFF

     C     KPDCLP        READE     LEPDUFL5                               87

     C     *IN87         IFEQ      *OFF
     C     YTYLC         ANDNE     'R'
     C     W@TotPD       ANDLT     LKEAMT

                                                                                           MD049745A
      ** Convert amount to loan currency when CLE031 is *ON                                MD049745A
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WREV = 'Y'                                              MD049745A
     C                   EVAL      WINAMT = YPCPAM                                         MD049745A
     C                   EVAL      ORWAMT = YPCPAM                                         MD049745A
     C                   EXSR      SRCvtAmt                                                MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
     C                   EVAL      WREV = ' '                                              MD049745A
     C                   ENDIF                                                             MD049745A
     C     YPCPAM        IFLE      LKEAMT
     C                   ADD       YPCPAM        W@TotPD
     C                   ELSE
     C                   ADD       LKEAMT        W@TotPD
     C                   ENDIF

      ** if total past due is greater than the event amount, then
      ** subtract difference from LEPDUFPD

     C     W@TotPD       IFLE      LKEAMT
     C                   MOVE      'R'           YTYLC
     C                   ELSE
     C     W@TotPD       SUB       LKEAMT        W@EAMT
     C                   Z-ADD     W@EAMT        YPCPAM
     C                   ENDIF
                                                                                           MD049745A
      ** Convert amount to loan currency when CLE031 is *ON                                MD049745A
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = YPCPAM                                         MD049745A
     C                   EVAL      ORWAMT = YPCPAM                                         MD049745A
     C                   EXSR      SRCvtAmt                                                MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
     C                   ENDIF                                                             MD049745A
     C                   UPDATE    LEPDUFD0
     C                   ENDIF
     C                   ENDDO

      ** if Total Past Due is greater than zero then reverse out the
      ** amount using a/c key fffR---nnD instead of fffR---nnF

     C     W@TotPD       IFNE      *ZEROS

     C                   SELECT

      ** if total past due is equal to the event amount, replace the
      ** account key fffR---nnF by fffR---nnD

     C     W@TotPD       WHENEQ    LKEAMT
     C                   MOVEL     LKAKEY        Wf10
     C                   MOVE      'D'           Wf10
     C                   MOVEL     Wf10          LKAKEY
     C                   UPDATE    LKEYFEDF

      ** if total past due is less than event amount, then subtract
      ** total past due from event amount and post the amount to
      ** account key fffR---nnF.

     C     W@TotPD       WHENLT    LKEAMT
     C                   EVAL      LKEAMT  = LKEAMT  - W@TotPD
     C                   UPDATE    LKEYFEDF

      ** create a/c key fffR---nnD to post the total past due

     C                   EVAL      LKEAMT  = W@TotPD
                                                                                            MD046080
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
                                                                                            MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      WINAMT = LKEAMT                                          MD046080
     C                   EVAL      ORWAMT = LKEAMT                                          MD046080
     C                   EXSR      SRCvtAmt                                                 MD046080
     C                   EVAL      LKEAMT = WOUTAMT                                         MD046080
     C                   EVAL      LKECCY = FEFCCY                                          MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   MOVEL     LKAKEY        Wf10
     C                   MOVE      'D'           Wf10
     C                   MOVEL     Wf10          LKAKEY
     C                   WRITE     LKEYFEDF
     C                   ADD       1             W@NewRc

      ** Put back the original value before convert                                         MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      LKEAMT = ORWAMT                                          MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   ENDSL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Chkfee - Check/Update Fee                                     *
      *                                                               *
      * Called by: SrPDCL                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     Chkfee        BEGSR

      ** CHAIN Fee file

     C     WPastDue      IFEQ      'P'
     C     WPastDue      OREQ      'Y'
     C     Kfee          CHAIN     lefeedlu
     C                   IF        not%found
     C     *LOCK         IN        LDA
     C                   MOVE      LKCNU2        wFcnu2

     C                   IF        LKLOAN <> *BLANKS
     C                   MOVE      LKLOAN        wFlnno
     C                   ELSE
     C                   MOVE      LKFACL        wFlnno
     C                   ENDIF
     C                   MOVE      LKFACL        wFlnno

     C                   MOVE      LKFSEQ        wFefseq
     C                   MOVE      LKFSE2        wFefseq
     C                   MOVE      LKFCOD        wFefcod
     C                   MOVEL     Wfeekey       DBKEY
     C                   MOVEL     'LEFEED  '    Dbfile
     C                   Z-ADD     003           Dbase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Updfez - Update Account Key Trailer                           *
      *                                                               *
      * Called by: SrPDCL                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     Updfez        BEGSR

      ** update trailer

     C     W@NewRc       IFNE      0
     C     w@adjamt      ORNE      0                                                        MD051242
     C     1             SETLL     LEPK3ZZ
     C                   READ      LEPK3ZZ                                88
     C     *IN88         IFEQ      *OFF
     C                   ADD       W@NewRC       lknore
     C                   IF        w@adjamt < 0                                             MD051242
     C                   EVAL      W@adjamt = w@adjamt * - 1                                MD051242
     C                   ENDIF                                                              MD051242
     C     w@adjamt      DIV       1000          ZZAMT            15 3                      MD051242
     C     ZZAMT         IFLT      *ZEROS                                                   MD051242
     C                   Z-SUB     ZZAMT         ZZAMT                                      MD051242
     C                   ENDIF                                                              MD051242
      *                                                                                     MD051242
     C                   Z-ADD     LKVLRF        ZZTOTI                                     MD051242
     C                   Z-ADD     LKVLRL        ZZTOTD                                     MD051242
      *                                                                                     MD051242
     C                   IF        CLE031 = 'Y'                                             MD051242
     C                             AND WMINUS = 'Y'                                         MD051242
     C                   EXSR      GLZSUB                                                   MD051242
     C                   ELSE                                                               MD051242
     C                   EXSR      GLZADD                                                   MD051242
     C                   ENDIF                                                              MD051242
      *                                                                                     MD051242
     C                   Z-ADD     ZZTOTI        LKVLRF                                     MD051242
     C                   Z-ADD     ZZTOTD        LKVLRL                                     MD051242
     C                   UPDATE    lkeyfezf
     C                   ENDIF
     C                   CLEAR                   W@NewRc
     C                   CLEAR                   w@adjamt                                   MD051242

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GenPdcl - Generate/Update PDCL                                *
      *                                                               *
      * Called by: SrPDCL                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     GenPdcl       BEGSR

      ** move fields

     C                   Z-ADD     W@Avail       W@Av
     C     WDrcr         IFEQ      'D'
     C                   Z-ADD     0             W@Av
     C                   ENDIF

      ** set value date

     C*****LKEDAT        IFGE      BJDNWD                                                  MD022807H
     C                   Z-ADD     LKEDAT        W@AVDAT
     C**********         ELSE                                                              MD022807H
     C**********         Z-ADD     BJRDNB        W@AVDAT                                   MD022807H
     C**********         ENDIF                                                             MD022807H
      *
     C     WPastDue      IFEQ      'P'
     C                   MOVE      *ZERO         W@AV
     C                   ENDIF
                                                                                            MD046080
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
     C**********         IF        CLE031 = 'Y'                                    MD046080 MD051940
     C**********         EVAL      WINAMT = LKEAMT                                 MD046080 MD051940
     C**********         EVAL      ORWAMT = LKEAMT                                 MD046080 MD051940
     C**********         EXSR      SRCvtAmt                                        MD046080 MD051940
     C**********         EVAL      W@OrigP = WOUTAMT                               MD046080 MD051940
     C**********         ELSE                                                      MD046080 MD051940
     C**********         EVAL      W@OrigP = LKEAMT                                MD046080 MD051940
     C**********         ENDIF                                                     MD046080 MD051940
                                                                                   MD046080 MD051940
      ** generate PDCL - call LEC000473

     C     WPastDue      IFNE      'N'
     C                   CALL      'LEC000473'
     C                   PARM                    wRetcd
     C                   PARM      'F'           Wtypef
     C                   PARM                    lkloan
     C                   PARM                    lkfse2
     C                   PARM                    lkfcod
     C                   PARM                    lkfacl
     C                   PARM                    lkfbrc
     C                   PARM                    lkcnu2
     C                   PARM                    lkedat
     C                   PARM                    W@pdamt
     C                   PARM      0             W@Int
     C                   PARM                    W@Av
     C**********         PARM      LKEAMT        W@OrigP                                    MD046080
     C                   PARM                    W@OrigP                                    MD046080
     C                   PARM      0             W@OrigI
     C                   PARM      0             W@LASN
     C                   PARM                    W@AVDAT
     C                   PARM      'P'           W@Type
     C                   PARM                    WSCCY                                     MD049745A
     C                   PARM                    WSIND                                     MD049745A
     C                   PARM                    WSRATE                                    MD049745A

      ** Output parm

     C                   PARM      *ZERO         w@OPdam
     C                   PARM      *ZERO         w@OPdInt

      ** Original fee - update PDCL reference

     C                   PARM      *BLANKS       w@FPDCR
     C                   PARM      'LEC000131'   W@PGNM
     C                   PARM      BlockCredit   W@BCR                                     MK021423E

      ** Error in LEC000473

     C     wRetcd        IFNE      *BLANKS
     C     *INU7         OREQ      *ON
     C     *INU8         ANDEQ     *ON
     C     *LOCK         IN        LDA
     C                   MOVE      LKloan        Wloan
     C                   MOVE      LkCnu2        Wcnu2
     C                   MOVE      Lkfacl        Wfacl
     C                   MOVE      Lkfseq        Wfseq
     C                   MOVE      Lkfcod        Wfcod
     C                   MOVE      LKfbrc        Wfbrcd
     C                   EVAL      DBKEY =  Wcnu2 + WLoan + WFacl
     C                                      + WFseq + WFcod + Wfbrcd
     C                   EVAL      DBFILE      = 'LEC000473 '
     C                   EVAL      DBASE       = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** update reporting/basel II fields on original transaction

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *    SrRepo - Produce Report                                    *
      *****************************************************************
     C     SrRepo        BEGSR

      ** Read a/c keys file that contains a/c key subject to funds
      ** pre-check

     C                   CLEAR                   LKNORE
     C                   MOVE      *OFF          *IN88
     C                   MOVE      *BLANKS       WBrca
     C     *LOVAL        SETLL     LEPK3L3

      ** loop to read a/c keys on LEPK3DPD

     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK3L3                                88
     C     *IN88         IFEQ      *OFF

     C                   ADD       1             LKNORE

      ** access branch details

     C     LKBRCD        IFNE      Wbrca
     C                   MOVE      LKBRCD        Branch
     C                   EXSR      GetBrca
     C                   WRITE     LER131H1
     C                   WRITE     LER131H2
     C                   MOVE      LKBRCD        WBRca
     C                   ENDIF

      ** access ccy details

     C     LKECCY        IFNE      Wcurr
     C                   EXSR      GetCcy
     C                   MOVE      lkeccy        Wcurr
     C                   ENDIF

      ** Set fields

     C                   EXSR      Setfield

      ** print report

     C     PRtlN1        IFGE      60
     C                   WRITE     LER131H1
     C                   WRITE     LER131H2
     C                   ENDIF
     C                   WRITE     LER131D1
     C                   ENDIF
     C                   ENDDO

      ** print end of report page

     C     pRtlN1        IFGE      60
     C                   WRITE     LER131H1
     C                   ENDIF
     C                   WRITE     LER131T1

     C                   ENDSR

      *****************************************************************                     MD046080
     C/EJECT                                                                                MD046080
      *****************************************************************                     MD046080
      *    SRCvtAmt - Convert Amount                                  *                     MD046080
      *****************************************************************                     MD046080
     C     SRCvtAmt      BEGSR                                                              MD046080
                                                                                            MD046080
     C                   IF        wPastDue = 'Y'                                           MD051940
     C                   IF        LKOTHA <> 0                                              MD051940
     C                   EVAL      WOUTAMT = LKOTHA                                         MD051940
     C                   EVAL      WSCCY = *BLANKS                                          MD051940
     C                   LEAVESR                                                            MD051940
     C                   ENDIF                                                              MD051940
     C                   ENDIF                                                              MD051940
                                                                                            MD051940
      ** If CLE034 switched ON, get settlement details from LESTALPD                        MD046080
     C                   IF        CLE034 = 'Y'                                             MD046080
     C                             AND FESTAL = 'Y'                                         MD046080
     C     KAllF         CHAIN     LESTALLF                                                 MD046080
     C                   IF        %FOUND(LESTALLF)                                         MD046080
     C                   EVAL      WCCY1 = L_RSCY                                           MD046080
     C                   EVAL      WRATE = L_REXR                                           MD046080
     C                   EVAL      WREXI = L_REXI                                           MD046080
     C                   ELSE                                                               MD046080
     C     *LOCK         IN        LDA                                                      MD046080
     C                   MOVEL     'LESTALLF'    DBFILE                                     MD046080
     C                   EVAL      DBASE = 007                                              MD046080
     C                   MOVEL     @OPTN         DBKEY                                      MD046080
     C                   EXSR      *PSSR                                                    MD046080
     C                   OUT       LDA                                                      MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WCCY1 = FESCCY                                           MD046080
     C                   EVAL      WRATE = FEREXR                                           MD046080
     C                   EVAL      WREXI = FEREXI                                           MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   EVAL      WSCCY = WCCY1                                           MD049745A
     C                   EVAL      WSIND = WREXI                                           MD049745A
     C                   EVAL      WSRATE = WRATE                                          MD049745A
     C                   EVAL      WCCY2 = FEFCCY                                           MD046080
     C                   IF        WREXI = 'M'                                              MD046080
     C                   EVAL      WMDIN = 'D'                                              MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WMDIN = 'M'                                              MD046080
     C                   ENDIF                                                              MD046080
     C                   IF        WREV = 'Y'                                              MD049745A
     C                   IF        WMDIN = 'M'                                             MD049745A
     C                   EVAL      WMDIN = 'D'                                             MD049745A
     C                   ELSE                                                              MD049745A
     C                   EVAL      WMDIN = 'M'                                             MD049745A
     C                   ENDIF                                                             MD049745A
     C                   ENDIF                                                             MD049745A
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
                                                                                            MD046080
     C                   ENDSR                                                              MD046080
                                                                                            MD046080
      *****************************************************************
     C/EJECT
      *****************************************************************
      *    GetCcy - Get Currency                                      *
      *****************************************************************
     C     GetCcy        BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @rtcd
     C                   PARM      '*KEY'        @optn
     C                   PARM                    LKECCY
     C     sdcurr        PARM                    dssdy

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      *    Setfield - Set up Fields                                   *
      *****************************************************************
     C     Setfield      BEGSR

     C                   MOVE      *ZEROS        ZFLD15
     C                   MOVE      LkEAMT        ZFLD15
     C                   Z-ADD     a6nbdp        Zdecs
     C                   MOVE      'J'           Zecode
     C                   EXSR      Zsedit
     C                   MOVE      ZOUT21        OEAMT

     C                   MOVE      *ZEROS        ZFLD15
     C                   MOVE      LkAAMT        ZFLD15
     C                   Z-ADD     a6nbdp        Zdecs
     C                   MOVE      'J'           Zecode
     C                   EXSR      Zsedit
     C                   MOVE      ZOUT21        OAAMT

      ** facility

     C                   MOVEL     LKFACL        WFAC03
     C                   MOVE      LKFACL        WFAC02
     C                   MOVE      LKFSE2        LKFSEQ
     C                   MOVE      *OFF          *IN34
     C     LKLNNO        IFNE      *BLANKS
     C                   MOVE      *ON           *IN34
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *    getBRca - Get Branch                                       *
      *****************************************************************
     C     getBRca       BEGSR

     C                   CALL      'AOBRCHR1'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    BRANCH
     C     SDBRCH        PARM                    DSSDY

     C                   ENDSR
      *****************************************************************                     MD051242
      /EJECT                                                                                MD051242
      *****************************************************************                     MD051242
      * GLZSUB  -  Subtracts an amount (ZZAMT) from the total         *                     MD051242
      *                                                               *                     MD051242
      * Called by: *None                                              *                     MD051242
      *                                                               *                     MD051242
      * Calls: GLZADD                                                 *                     MD051242
      *                                                               *                     MD051242
      *****************************************************************                     MD051242
     C     GLZSUB        BEGSR                                                              MD051242
      *                                                                                     MD051242
      ***  Just reverse the 'sign' and add                                                  MD051242
      *                                                                                     MD051242
     C                   Z-SUB     ZZAMT         ZZAMT                                      MD051242
     C                   EXSR      GLZADD                                                   MD051242
     C                   Z-SUB     ZZAMT         ZZAMT                                      MD051242
      *                                                                                     MD051242
     C                   ENDSR                                                              MD051242
      *****************************************************************                     MD051242
      /EJECT                                                                                MD051242
      *****************************************************************                     MD051242
      * GLZADD  -  Adds an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)*                     MD051242
      *                                                               *                     MD051242
      * Called by: GLZSUB                                             *                     MD051242
      *                                                               *                     MD051242
      * Calls: GLZSUM                                                 *                     MD051242
      *                                                               *                     MD051242
      *****************************************************************                     MD051242
     C     GLZADD        BEGSR                                                              MD051242
      *                                                                                     MD051242
     C     ZZAMT         IFNE      *ZERO                                                    MD051242
      *                                                                                     MD051242
      ***  Split ZZAMT into integer and decimal fields                                      MD051242
      *                                                                                     MD051242
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0                      MD051242
     C                   MOVE      ZZAMT         ZZAMTD            3 0                      MD051242
      *                                                                                     MD051242
      ***  Both ZZAMTI and ZZAMTD contain a 'sign' zone now                                 MD051242
      *                                                                                     MD051242
     C                   EXSR      GLZSUM                                                   MD051242
     C                   ENDIF                                                              MD051242
      *                                                                                     MD051242
     C                   ENDSR                                                              MD051242
      ****************************************************************                      MD051242
      /EJECT                                                                                MD051242
      *****************************************************************                     MD051242
      * GLZSUM  -  Carries out the addition of the amounts            *                     MD051242
      *                                                               *                     MD051242
      * Called by: GLZADD                                             *                     MD051242
      *                                                               *                     MD051242
      * Calls: *None                                                  *                     MD051242
      *                                                               *                     MD051242
      *****************************************************************                     MD051242
     C     GLZSUM        BEGSR                                                              MD051242
      *                                                                                     MD051242
      ***  Save values of indicators to be used in the program                              MD051242
      *                                                                                     MD051242
     C                   MOVE      *IN91         WIN91             1                        MD051242
     C                   MOVE      *IN92         WIN92             1                        MD051242
     C                   MOVE      *IN93         WIN93             1                        MD051242
     C                   MOVE      *IN94         WIN94             1                        MD051242
     C                   MOVE      *IN95         WIN95             1                        MD051242
     C                   MOVE      *IN96         WIN96             1                        MD051242
     C                   SETOFF                                       919293                MD051242
     C                   SETOFF                                       949599                MD051242
      *                                                                                     MD051242
      ***  Determine sign of ZZAMTI and ZZAMTD, 92 if neg                                   MD051242
      *                                                                                     MD051242
     C     ZZAMTI        COMP      0                                    9293                MD051242
     C   93ZZAMTD        COMP      0                                    9293                MD051242
     C   93              GOTO      ZZSEND                                                   MD051242
      *                                                                                     MD051242
      ***  Determine sign of ZZTOTI and ZZTOTD, 91 if neg                                   MD051242
      *                                                                                     MD051242
     C     ZZTOTI        COMP      0                                    9193                MD051242
     C   93ZZTOTD        COMP      0                                    9193                MD051242
      *                                                                                     MD051242
      ***  If ZZTOTAL is zero, return ZZAMOUNT                                              MD051242
      *                                                                                     MD051242
     C   93              Z-ADD     ZZAMTI        ZZTOTI           15 0                      MD051242
     C   93              Z-ADD     ZZAMTD        ZZTOTD            3 0                      MD051242
     C   93              GOTO      ZZSEND                                                   MD051242
      *                                                                                     MD051242
      ***  If signs differ, bypass overflow checks                                          MD051242
      *                                                                                     MD051242
     C   91                                                                                 MD051242
     CANN92                                                                                 MD051242
     CORN91                                                                                 MD051242
     CAN 92              GOTO      ZZOFPS                                                   MD051242
     C*                                                                                     MD051242
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0                      MD051242
     C     ZZWK2         COMP      999                                93                    MD051242
     C  N93ZZWK2         COMP      -999                                 93                  MD051242
     C*                                                                                     MD051242
     C   93                                                                                 MD051242
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0                      MD051242
     C   93                                                                                 MD051242
     CAN 92ZZAMTI        SUB       1             ZZWK3                                      MD051242
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3                                      MD051242
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3                                      MD051242
      *                                                                                     MD051242
      ***  If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured                   MD051242
      *                                                                                     MD051242
     C  N92ZZWK3         COMP      ZZTOTI                               99                  MD051242
     C   92ZZWK3         COMP      ZZTOTI                             99                    MD051242
     C  N99              Z-ADD     ZZWK2         ZZTOTD                                     MD051242
     C  N99              Z-ADD     ZZWK3         ZZTOTI                                     MD051242
      *                                                                                     MD051242
      ***  If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left intact                  MD051242
      *                                                                                     MD051242
     C   99              Z-ADD     0             ZZAMT            15 3                      MD051242
     C                   GOTO      ZZSEND                                                   MD051242
      *                                                                                     MD051242
      ***  The 'signs' are different                                                        MD051242
      *                                                                                     MD051242
     C     ZZOFPS        TAG                                                                MD051242
      *                                                                                     MD051242
      ***  If ZZAMT was negative, make it pos. to como with ZZTOT                           MD051242
      *                                                                                     MD051242
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0                      MD051242
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0                      MD051242
      *                                                                                     MD051242
      ***  If ZZTOT was negative, make it pos. to comp with ZZAMT.                          MD051242
      *                                                                                     MD051242
     C   91              Z-SUB     ZZTOTI        ZZTOTI                                     MD051242
     C   91              Z-SUB     ZZTOTD        ZZTOTD                                     MD051242
      *                                                                                     MD051242
      ***  Both ZZAMT and ZZTOT are now positive                                            MD051242
      *                                                                                     MD051242
     C     ZZTOTI        COMP      ZZAMTI                             93  95                MD051242
     C   95ZZTOTD        COMP      ZZAMTD                             93  95                MD051242
      *                                                                                     MD051242
      ***  If ZZTOT eq. ZZAMT return ZERO.                                                  MD051242
      *                                                                                     MD051242
     C   95              Z-ADD     0             ZZTOTI                                     MD051242
     C   95              Z-ADD     0             ZZTOTD                                     MD051242
     C   95              GOTO      ZZSEND                                                   MD051242
      *                                                                                     MD051242
      ***  If ZZTOT gt. ZZAMT.                                                              MD051242
      *                                                                                     MD051242
     C   93ZZAMTD        COMP      ZZTOTD                             94                    MD051242
     C   93                                                                                 MD051242
     CAN 94ZZTOTI        SUB       1             ZZTOTI                                     MD051242
     C   93                                                                                 MD051242
     CAN 94ZZTOTD        ADD       1000          ZZWK2                                      MD051242
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI                                     MD051242
     C   93                                                                                 MD051242
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD                                     MD051242
     C   93                                                                                 MD051242
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD                                     MD051242
      *                                                                                     MD051242
      ***  If ZZAMT gt. ZZTOT.                                                              MD051242
      *                                                                                     MD051242
     C  N93ZZTOTD        COMP      ZZAMTD                             94                    MD051242
     C  N93                                                                                 MD051242
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0                      MD051242
     C  N93                                                                                 MD051242
     CAN 94ZZAMTD        ADD       1000          ZZWK2                                      MD051242
     C  N93                                                                                 MD051242
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI                                     MD051242
     C  N93                                                                                 MD051242
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI                                     MD051242
     C  N93                                                                                 MD051242
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD                                     MD051242
     C  N93                                                                                 MD051242
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD                                     MD051242
      *                                                                                     MD051242
      ***  Reverse sign of ZZTOT if larger I/P fields were negative                         MD051242
      *                                                                                     MD051242
     C                   SETOFF                                       94                    MD051242
     C   93                                                                                 MD051242
     CAN 91                                                                                 MD051242
     CORN93                                                                                 MD051242
     CAN 92              SETON                                        94                    MD051242
     C   94              Z-SUB     ZZTOTI        ZZTOTI                                     MD051242
     C   94              Z-SUB     ZZTOTD        ZZTOTD                                     MD051242
      *                                                                                     MD051242
      ***  Restore sign of ZZAMTI & ZZAMTD if it was reversed                               MD051242
      *                                                                                     MD051242
     C   92              Z-SUB     ZZAMTI        ZZAMTI                                     MD051242
     C   92              Z-SUB     ZZAMTD        ZZAMTD                                     MD051242
     C     ZZSEND        TAG                                                                MD051242
      *                                                                                     MD051242
      ***  If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.                             MD051242
      *                                                                                     MD051242
     C                   SETOFF                                       96                    MD051242
     C     ZZTOTD        COMP      0                                      91                MD051242
     C   91ZZTOTI        COMP      0                                    96                  MD051242
     C   96              MOVE      '.000-'       ZZNEGD            5                        MD051242
      *                                                                                     MD051242
      ***  Restore previous indicator values                                                MD051242
      *                                                                                     MD051242
     C                   MOVE      WIN91         *IN91                                      MD051242
     C                   MOVE      WIN92         *IN92                                      MD051242
     C                   MOVE      WIN93         *IN93                                      MD051242
     C                   MOVE      WIN94         *IN94                                      MD051242
     C                   MOVE      WIN95         *IN95                                      MD051242
     C                   MOVE      WIN96         *IN96                                      MD051242
      *                                                                                     MD051242
     C                   ENDSR                                                              MD051242
      *****************************************************************
     C/EJECT
      *****************************************************************
      *    *INZSR - Initialization Subroutine                         *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    pAPOS
     C                   PARM                    pCNAME
     C                   PARM                    pReturnCode

     C                   EVAL      dbPgm       = PSProcPgm

     C     Kfee          KLIST
     C                   KFLD                    lkfbrc
     C                   KFLD                    lkcnu2
     C                   KFLD                    lkfacl
     C                   KFLD                    lkloan
     C                   KFLD                    lkfse2

     C     Kpdcl         KLIST
     C                   KFLD                    lkloan
     C                   KFLD                    lkcnu2
     C                   KFLD                    lkfacl
     C                   KFLD                    lkfseq
     C                   KFLD                    lkfbrc
     C                   KFLD                    lkedat

     C     Kpdclp        KLIST
     C                   KFLD                    lkloan
     C                   KFLD                    lkcnu2
     C                   KFLD                    lkfacl
     C                   KFLD                    lkfseq
     C                   KFLD                    lkfbrc

     C     KAllF         KLIST                                                              MD046080
     C                   KFLD                    LKCNU2                                     MD046080
     C                   KFLD                    LKLOAN                                     MD046080
     C                   KFLD                    LKFACL                                     MD046080
     C                   KFLD                    LKFSE2                                     MD046080
     C                   KFLD                    LKOSAC                                     MD046080
                                                                                            MD046080
      ** Access General Ledger details

     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   EVAL      DBASE = 005
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

      ** Retrieve trading data

     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @rtcd
     C                   PARM      '*FIRST '     @optn
     C     sdbank        PARM      sdbank        dsfdy

      ** Check System Value: Use Original Borrower or Purchased From?
      ** Set up parameter so access object checks LoanCustOriginPurch

     C                   MOVEL     WPARM         SVALK1

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

     C     WRetcd        IFNE      '        '
     C                   MOVE      'P'           PPCUST
     C                   ELSE

      ** Isolate the first character of SVAL1 which = 'P' or 'O'.

     C                   MOVEL     SVAL1         WRK01
     C     WRK01         IFEQ      'O'
     C                   MOVE      'O'           PPCUST
     C                   ELSE
     C                   MOVE      'P'           PPCUST
     C                   ENDIF
     C                   ENDIF

      ** Determine if Freq Fee & Allocation, Sett Ccy, Roll Utilisation                     MD046080
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
      ** Determine if Freq Fee & Allocation, Sett Ccy, Roll Utilisation                     MD046080
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
     C     *LIKE         DEFINE    LKEAMT        WRepaym
     C     *LIKE         DEFINE    LKEAMT        W@EAMT
     C     *LIKE         DEFINE    FELOAN        w@FPDCR

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  *PSSR - Subroutine to handle abnormal error conditions       *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   ROLBK
     C                   IF        runBefore <> 'Y'
     C                   EVAL      runBefore   = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      pReturnCode = '*ERROR*'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

     C/COPY ZSRSRC,ZSEDITZ3LE
