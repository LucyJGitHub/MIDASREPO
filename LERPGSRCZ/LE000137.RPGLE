     H DEBUG
     H Copyright('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL process - calculated suspended fees')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000137 - Past Due Call Loans: Suspended Fees               *
      *                                                               *
      *  Function:  This program reads the new account keys file      *
      *             LEPK2DPD and for each repayment account key it    *
      *             checks whether the settlement account has         *
      *             enough balance to cover the payment. If the       *
      *             balance is enough then it generates the payment   *
      *             otherwise it suspended the payment or cancel the  *
      *             fee if the max of suspended payments allowed has  *
      *             been reached                                      *
      *                                                               *
      *  Called By: LEC000137 - Fee Accruals Update & Account Key     *
      *             Generation.                                       *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD046080           Date 17Sep17               *
      *                 CLE164             Date 18Aug14               *
      *                 AR1063739          Date 03Dec12               *
      *                 AR1056323          Date 14Nov12               *
      *                 AR1055213          Date 10Nov12               *
      *                 AR724089           Date 01Aug12               *
      *                 AR402058           Date 01Aug12               *
      *                 AR217562           Date 01Aug12               *
      *                 263074             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046080 - Gap between CLE031 (Settlement to different       *
      *             currency) and CLE134 (PDCL processing)            *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  AR1063739 - SettlementAccount09 Issues                       *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  AR1055213 - Computation errors during Link Testing of        *
      *              Suspended Fees                                   *
      *  AR724089 - Several performance issues in COB component       *
      *             LEC000459. Call LE000475 directly, instead of     *
      *             passing thru LEC000475. (Child: AR724090)         *
      *  AR402058 - Wrong Available Balance (Child: AR402059)         *
      *  AR217562 - Wrong Repayment Methodology (Child: AR217563)     *
      *  263074 - Wrong Postings when interest and principal are paid *
      *           on the same day (Recompile)                         *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
     FLEPK2L4   UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     FLEPK2ZZ   UF   E             DISK    COMMIT
     F                                     PREFIX(T_)
     F                                     INFSR(*PSSR)
     FLEFEED    UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     FLEPK2L5   IF   E           K DISK    RENAME(LKEYFEDF:LKEYFED2)
     F                                     INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INCLUDE(ACCNTABF)
     F                                     INFSR(*PSSR)
     FCLOAN     IF   E           K DISK    INCLUDE(CLOANCLF)
     F                                     INFSR(*PSSR)
     FLESTALLF  IF   E           K DISK    PREFIX(L_)                                       MD046080
     FLE000137P1O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
     F                                     INFSR(*PSSR)
      *****************************************************************

     D SPOOL1          DS
     D SFILE1                 83     92
     D SFNUM1                123    124B 0
     D OFLLN1                188    189B 0
     D PRTLN1                367    368B 0

     D SDGELR        E DS                  EXTNAME(SDGELRPD)

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACCD1       E                     EXTFLD(QQACCD)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Nostro details

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)

     D SDFEE         E DS                  EXTNAME(SDFEEPD)
     D DSFDY         E DS
     D DSSDY         E DS
     D WFEEKEY         DS
     D WFCNU2                  1      6
     D WFLNNO                  8     13
     D WFEFSEQ                15     16
     D WFEFCOD                18     19

     D PRETURNCODE     S              7
     D CLE134          S              1
     D WRETCD          S              7
     D PAPOS           S              1
     D PCNAME          S             10
     D WPOSTR          S              1
     D WPARM           S             20A   INZ('LoanCustOriginPurch')

     D                 DS
     D SMDT                    1      6
     D SMDD                    1      2
     D SM                      3      4  0
     D SY                      5      6  0

     D                 DS
     D SMDTUS                  1      6
     D SMUS                    1      2  0
     D SMDDUS                  3      4  0

     D                 DS

      ** Divide Date

     D  WWDAT                  1      6  0
     D  WWDT1                  1      2  0
     D  WWDT2                  3      4  0
     D  WWDT3                  5      6  0

     D WLOAN           S              6
     D WCNU2           S              6
     D WFACL           S              5
     D WFSEQ           S              2
     D WFCOD           S              2
     D WFBRCD          S              3

      ** Account

     D WCURR           S              3
     D WBRCA           S              3
     D WCNUM           S              6
     D WCCY            S              3
     D WACOD           S             10  0
     D WACSQ           S              2  0
     D WACODA          S             10
     D WACSQA          S              2

      ** Balance check
      **  Cleared Balance
      **  Available Funds
      **  Total Suspended
      **  Suspended Limit
      **  Suspended Amt
      **  Amount to Reverse
      **  Repay amount
      **  Trailer amount
      **  Trailer Sign
      **  Trailer nr of recds
      **  Suspended Limit
      **  Nr Suspended Payms
      **  Tot Nr of susp.
      **  Available Funds
      **  past due amount
      **  past due amount

     D P@BLBF          S             15P 0
     D P@BLAF          S             15P 0
     D W@TSUSP         S             15P 0
     D W@PARTL         S             15P 0
     D W@SUSP          S             15P 0
     D W@REVE          S             15P 0
     D W@REPAY         S             15P 0
     D W@ZZAMT         S             15P 0
     D W@SIGN          S              1
     D W@NORE          S             15P 0
     D W@SUSL          S             15P 0
     D W@NRSUS         S              3P 0
     D W@TNRSUS        S              3P 0
     D W@AVAIL         S             15P 0
     D W@PDAMT         S             15P 0
     D W@ORIGP         S             15P 0

     D WPastDue        S              1
     D WDrCr           S              1

     D WPartW          S             16  3

     D W@Action        S              1

     D Totpost         S             15  0

     D Wf10            S             10
     D Wf3             S              3
     D Wf4             S              4

     D Branch          S              3

     D*P@OP01***       S             20                                                    AR1063739
     D*P@VL01***       S            200                                                    AR1063739
     D*P@OP02***       S             20                                                    AR1063739
     D*P@VL02***       S            200                                                    AR1063739
     D*P@OP03***       S             20                                                    AR1063739
     D*P@VL03***       S            200                                                    AR1063739
     D*P@OP04***       S             20                                                    AR1063739
     D*P@VL04***       S            200                                                    AR1063739
     D*P@OP05***       S             20                                                    AR1063739
     D*P@VL05***       S            200                                                    AR1063739
     D*P@OP06***       S             20                                                    AR1063739
     D*P@VL06***       S            200                                                    AR1063739
     D*P@OP07***       S             20                                                    AR1063739
     D*P@VL07***       S            200                                                    AR1063739
     D*P@OP08***       S             20                                                    AR1063739
     D*P@VL08***       S            200                                                    AR1063739
     D*P@OP09***       S             20                                                    AR1063739
     D*P@VL09***       S            200                                                    AR1063739
     D*P@OP10***       S             20                                                    AR1063739
     D*P@VL10***       S            200                                                    AR1063739

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

     D*SET09****       S              1                                                    AR1063739

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
                                                                                            MD046080
     D WRK01           S              1

     D PPCUST          S              1

     D SOYDD           S              2  0

     D DNWDDD          S              2  0
     D WKDDSY          S              2  0

     D GDATE           S              6  0
     D GDAYNO          S              5  0
     D GRTCD           S              1

     D smdy            S              5  0

     D CODT            S              5  0
     D MN              S              2  0
     D M2              S              2  0

     D WDATE           S              6  0
     D WCODTA          S              7

     D MNTND           S              2  0
     D MSTD            S              5  0

     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0

     D WIN91           S              1
     D WIN92           S              1
     D WIN93           S              1
     D WIN94           S              1
     D WIN95           S              1
     D WIN96           S              1

     D ZZWK2           S              4  0
     D ZZWK3           S             15  0

     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0

     D ZZNEGD          S              5

     D ZS2             S              1    DIM(21)
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)

     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS

     D*SVAL*****       S             20    DIM(4) CTDATA PERRCD(1)                         AR1063739

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Read a/c keys of fees that are allowed to be suspended.

     C     *LOVAL        SETLL     LEPK2L4
     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK2L4                                88

     C                   IF        *IN88 = *OFF

      ** If Settlement account is blanks/zero, then flag record as
      ** processed and read next

     C                   IF        SEBRCA = *BLANKS OR SEACCY = *BLANKS
     C                             OR SECNUM = *BLANKS OR SEACOD = 0 OR
     C                             SEACSQ = 0
     C                   EVAL      LKIPFL = 'P'
     C                   UPDATE    LKEYFEDF

     C                   ELSE

      ** Check if account key has posting ref 2

     C                   EXSR      SRCheckAc
     C                   EXSR      SrProc

     C                   ENDIF

     C                   ENDIF
     C                   ENDDO

      ** Produce report

     C                   EXSR      SRRepo
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCheckAC  - Check Account Key                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCheckAc     BEGSR
      *
      ** Check whether the Settlement account exists in ACCNT
      *
     C     KACCT         CHAIN     ACCNT
      *
      ** Database error if record does not exist
      *
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   MOVEL     'ACCNT   '    DBFILE
     C                   EVAL      Dbase = 001
     C                   MOVE      SEACOD        WACODA
     C                   MOVE      SEACSQ        WACSQA
     C                   EVAL      DBKEY = SEBRCA + SECNUM+ SEACCY
     C                              + WacodA+ WacsqA
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
      *
      ** -I:CUSTOMER NO
      ** -I:CURRENCY
      ** -I:ACCOUNT CODE
      ** -I:ACCOUNT SEQUENCE
      ** -I:BRANCH CODE
      *
     C                   MOVE      CNUM          wCnum
     C                   MOVE      CCY           wCCY
     C                   MOVE      ACOD          wAcod
     C                   MOVE      ACSQ          wAcsq
     C                   MOVE      BRCA          WBrca
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Process                                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRChkBal, SRChkSusp, SRChkPaym, SRChkUpdT, SRUpdack    *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
      *
      ** Chain  fee
      *
     C                   EXSR      SRChkfee
      *
      ** Check if fee has already been early matured within this cob
      ** run
      *
     C                   IF        FERECI = 'M'
     C                             AND FELCHT = 'S'
     C                   EXSR      SREarlyM
     C                   ELSE
      *
      ** Check Account Balance
      *
     C                   EXSR      SRChkBal

      ** Check suspense payment

     C                   SELECT

      ** payment of amount already suspended

     C                   WHEN      LKTYPE = 'S'
     C                   EXSR      SRChkSusp

      ** Partial payment manually input

     C                   WHEN      LKTYPE = 'P'
     C                   EXSR      SRChkSusp

      ** Full payment manually input

     C                   WHEN      LKTYPE = 'F'
     C                   EXSR      SRChkSusp

      ** Regular payment

     C                   WHEN      LKTYPE <> 'S'

     C                   EXSR      SRChkPaym

      ** Check whether fee can be paid/suspended or whether it must
      ** be early matured

     C                   EXSR      SRChkUpdT

      ** Update/create account key

     C                   EXSR      SRUpdack

     C                   ENDSL
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkfee - Access Fee File                                    *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkfee      BEGSR
      *
      ** Access fee file
      *
     C     Kfee          CHAIN     lefeed
     C                   IF        NOT %FOUND
     C     *LOCK         IN        LDA
     C                   MOVE      LKCNU2        wFcnu2
      *
      ** Error if fee not found
      *
     C                   IF        LKLOAN <> *BLANKS
     C                   MOVE      LKLOAN        wFlnno
     C                   ELSE
     C                   MOVE      LKFACL        wFlnno
     C                   ENDIF
     C                   MOVE      LKFACL        wFlnno
      *
     C                   MOVE      LKFSE2        wFefseq
     C                   MOVE      LKFCOD        wFefcod
     C                   MOVEL     Wfeekey       DBKEY
     C                   MOVEL     'LEFEED  '    Dbfile
     C                   Z-ADD     002           Dbase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkBal - Check Balance                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkBal      BEGSR
      *
     C                   MOVE      'N'           WPastDue
     C                   MOVE      *BLANKS       WDrCr
     C                   EVAL      w@Pdamt = 0
     C                   EVAL      w@Origp = LKEAMT
      *
     C                   EVAL      P@BLAF = LKAAMT
      *
      ** Set available balance flag
      *
     C                   MOVE      *BLANKS       WDrCr
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
     C                   WHEN      LKEAMT = 0
     C                   MOVE      'N'           wPastDue
      *
      ** If account key amount is negative, no check is needed
      ** as event amount is going to increase  the account balance
      *
     C                   WHEN      LKEAMT < 0
     C                             AND LKREVI = 0
     C                   MOVE      'N'           wPastDue
      *
      ** If account key amount is positive and a/c key is reversed,
      ** do not check balance as event amount is going to increase
      ** the account balance.
      *
     C                   WHEN      LKEAMT > 0
     C                             AND LKREVI = 1
     C                   MOVE      'N'           wPastDue
      *
      ** If available balance is zero, set the WPastDue flag =Y
      *
     C                   WHEN      W@Avail = 0
     C                   MOVE      'Y'           wPastDue
     C                   EVAL      w@Pdamt = LKEAMT
      *
      ** If available balance is debit, set past due flag = Y
      *
     C                   WHEN      W@Avail > 0
     C                             AND WDrCr = 'D'
     C                   MOVE      'Y'           wPastDue
     C                   EVAL      w@Pdamt = LKEAMT
      *
      ** If available balance is credit and is less than event
      ** amount, set past due flag = 'P'
      *
     C                   WHEN      W@Avail > 0
     C                             AND WDrCr = 'C'
     C                             AND LKEAMT > 0
     C                             AND LKEAMT > W@Avail
     C                   MOVE      'P'           wPastDue
     C                   EVAL      w@Pdamt = LKEAMT - W@Avail
      *
      ** If available balance is credit and is equal to event amount,
      ** set past due flag = 'N'
      *
     C                   WHEN      W@Avail > 0
     C                             AND WDrCr = 'C'
     C                             AND LKEAMT > 0
     C                             AND LKEAMT = W@Avail
     C                   MOVE      'N'           wPastDue

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkSusp - Check suspended account                           *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkSusp     BEGSR
      *
      ** a/c key proces. flag
      ** Nr of del/add recds
      ** Amt to be suspended
      ** Amt that can be paid
      ** Partial Limit
      ** Amt to be rev. out
      ** 1 - incr. susp paym.
      *
     C                   EVAL      LKIPFL = 'P'
     C                   EVAL      W@NORE = 0
     C                   EVAL      W@Susp = 0
     C                   EVAL      W@Repay = 0
     C                   EVAL      W@PartL = 0
     C                   EVAL      W@REve = 0
     C                   EVAL      W@NrSus = 0
     C                   EVAL      w@Origp = LKEAMT
     C                   EVAL      Lkaamt = P@BLAF

      ** SELECT based on whether the available balance is:
      ** - Fully available (WpastDue flag is set = 'N')
      ** - Partially available (WpastDue flag is set = 'P')
      ** - Is not available (WpastDue flag is set = 'Y')

     C                   SELECT

      ** If Balance is available, then subctract by 1 the nr of
      ** suspended payments

     C                   WHEN      WPastDue = 'N'

     C                   IF        LKEAMT <> 0
     C                             AND W@Avail > 0
     C                             AND WDrCr = 'C'

      ** Event amount can be fully paid so set W@Repay = Event amount

     C                   EVAL      W@Repay = LKEAMT

      ** If Early Maturity = 'S' then subtract 1 from total suspended
      ** payments

     C                   IF        FEFEMC = 'S'
     C                   EVAL      FESFP = FESFP - 1
     C                   ENDIF

      ** subtract amount of suspended payments

     C                   IF        lkeamt < 0
     C                   EVAL      FESFA = FESFA + LKEAMT
     C                   ELSE
     C                   EVAL      FESFA = FESFA - LKEAMT
     C                   ENDIF

     C                   ENDIF

      ** Update settled amount

     c                   EVAL      FEAMTS = FEAMTS + LKEAMT
     C                   IF        FECALT <> *BLANKS
     C                   EVAL      FEPAMS = FEPAMS + LKEAMT
     C                   ENDIF

      ** Update account key file

     C                   UPDATE    Lkeyfedf

      ** If Partial payment flag is Y and balance is partially
      ** available, then subtract by 1 the nr of suspended payments

     C                   WHEN      WPastDue = 'P'
     C                   Z-ADD     LKEAMT        WEAMT

     C                   IF        WEAMT < 0
     C     WEAMT         MULT      -1            WEAMT
     C                   ENDIF

      ** No Partial payment allowed

     C                   IF        FEFPPA = 'N'
     C                   EVAL      W@Reve = WEAMT
     C                   ENDIF

      **  Partial payment allowed

     C                   IF        FEFPPA = 'Y'
     C                   IF        FEPSIN = 'A'
     C                   EVAL      W@PartL = FEPSLM
     C                   ELSE
     C                   EVAL      W@PartL = WEAMT
     C                   ENDIF
     C                   ENDIF

      ** If partial limit allowed, calculate partial amount

     C                   IF        FEFPPA = 'P'

      ** Partial indicator A - Amount, P-Percentage (if P, calculate
      ** Partial limit amount as Repaym. amount * limit %)

     C                   IF        FEPSIN = 'A'
     C                   EVAL      W@PartL= FEPSLM

     C                   ELSE

     C     WEAMT         MULT      FEPSLM        WPartW
     C                   IF        WPartW <> 0
     C     WPartW        DIV       100           W@PartL
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** If Amount Available is Greater/Equal Partial Limit Amount

     C                   IF        W@Avail >= W@PartL

      * - subtract 1 from nr of suspended payments
      * - subtract amount repaid from total suspended
      * - add amount repaid to total settled

     C                   EVAL      W@Repay= W@Avail
     C                   EVAL      W@Reve = WEAMT - W@Repay

      ** If Early Maturity = 'S' then subtract 1 from total
      ** suspended payments

     C                   IF        FEFEMC = 'S'
     C                   EVAL      FESFP = FESFP - 1
     C                   ENDIF

     C                   ELSE

     C                   EVAL      W@Reve = WEAMT
     C                   ENDIF

      ** Subtract repaid amount from tot amount suspended

     C                   EVAL      FESFA = FESFA - W@Repay

      ** Update settled amount

     C                   EVAL      FEAMTS = FEAMTS + W@Repay
     C                   IF        FECALT <> *BLANKS
     C                   EVAL      FEPAMS = FEPAMS + LKEAMT
     C                   ENDIF

      ** Set LKEAMT = Amount repaid

     C                   EVAL      LKEAMT = W@Repay

      ** Subtract total unpaid from account keys trailer file

     C                   EVAL      W@Sign = 'S'
     C                   EVAL      W@ZZAMT = W@Reve
     C                   EVAL      W@NORE = 0
     C                   EXSR      SRTrailV

      ** update account key file

     C                   UPDATE    Lkeyfedf

      ** If Partial payment flag is Y and balance is partially
      ** available, then subtract by 1 the nr of suspended payments

     C                   WHEN      WPastDue = 'Y'
     C                   Z-ADD     LKEAMT        WEAMT

     C                   IF        WEAMT < 0
     C     WEAMT         MULT      -1            WEAMT
     C                   ENDIF

     C                   EVAL      W@Reve = WEAMT

      ** Set LKEAMT = Amount repaid

     C                   EVAL      LKEAMT = 0

      ** Subtract total unpaid from account keys trailer file

     C                   EVAL      W@ZZAMT = W@Reve
     C                   EVAL      W@Sign = 'S'
     C                   EVAL      W@NORE = -1
     C                   EXSR      SRTrailV

      ** Update account key file

     C                   DELETE    Lkeyfedf

     C                   ENDSL

      ** Update lefeed

     C                   UPDATE    Lefeedf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkPaym - Check payment                                     *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkPaym     BEGSR

      ** Nr of del/add recs
      ** Amt to be suspended
      ** Amt that can be paid
      ** Partial Limit
      ** Amt to be rev. out
      ** 1 - inc. susp paym.

     C                   EVAL      W@NORE = 0
     C                   EVAL      W@Susp = 0
     C                   EVAL      W@Repay = 0
     C                   EVAL      W@PartL = 0
     C                   EVAL      W@REve = 0
     C                   EVAL      W@NrSus = 0

      ** SELECT based on whether the available balance is:
      ** - Fully available (WpastDue flag is set = 'N')
      ** - Partially available (WpastDue flag is set = 'P')
      ** - Is not available (WpastDue flag is set = 'Y')

     C                   SELECT

      ** If Balance is available, then subctract by 1 the nr
      ** of suspended payments

     C                   WHEN      WPastDue = 'N'

     C                   IF        LKEAMT <> 0
     C                             AND W@Avail > 0
     C                             AND WDrCr = 'C'
     C                   EVAL      W@Repay = LKEAMT
     C                   ENDIF

      ** If Partial payment flag is Y and balance is partially
      ** available, then subtract by 1 the nr of suspended payments

     C                   WHEN      WPastDue = 'P'
     C                   Z-ADD     LKEAMT        WEAMT

     C                   IF        WEAMT < 0
     C     WEAMT         MULT      -1            WEAMT
     C                   ENDIF

      ** No Partial payment allowed

     C                   IF        FEFPPA = 'N'
     C                   EVAL      W@Susp = WEAMT
     C                   EVAL      W@Reve = WEAMT
     C                   EVAL      W@NrSus = 1
     C                   EVAL      W@PartL = WEAMT                                         AR1055213
     C                   ENDIF

      ** Partial payment allowed

     C                   IF        FEFPPA = 'Y'
     C                   IF        FEPSIN = 'A'
     C                   EVAL      W@PartL= FEPSLM
     C                   ELSE
     C**********         EVAL      W@PartL= WEAMT                                          AR1055213
     C                   EVAL      W@PartL= W@PDAMT                                        AR1055213
     C                   ENDIF
     C                   ENDIF

      ** If partial limit allowed, calculate partial amount

     C                   IF        FEFPPA = 'P'

      ** partial indicator A - Amount, P-Percentage (if P, calculate
      ** partial limit amount as Repayment amount * limit %)

     C                   IF        FEPSIN = 'A'
     C                   EVAL      W@PartL= FEPSLM

     C                   ELSE

     C     WEAMT         MULT      FEPSLM        WPartW
     C                   IF        WPartW <> 0
     C     WPartW        DIV       100           W@PartL
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** If Amount Available is Greater/Equal Partial Limit Amount

     C                   IF        W@Avail >= W@PartL

      ** Calculate amount to be reversed out from LKEAMT

     C                   EVAL      W@Repay= W@Avail
     C                   EVAL      W@Reve = WEAMT - W@Repay
     C                   EVAL      W@Susp = WEAMT - W@Repay
     C                   EVAL      W@NrSus = 1                                             AR1055213

     C                   ELSE

      ** Calculate amount to be reversed out
      ** Calculate amount to be suspended
      ** Add 1 to nr of suspended payments

     C                   EVAL      W@Reve = WEAMT
     C                   EVAL      W@Susp = WEAMT
     C                   EVAL      W@NrSus = 1

     C                   ENDIF

      ** If Partial payment flag is Y and balance is partially
      ** available, then subtract by 1 the nr of suspended payments

     C                   WHEN      WPastDue = 'Y'
     C                   Z-ADD     LKEAMT        WEAMT

     C                   IF        WEAMT < 0
     C     WEAMT         MULT      -1            WEAMT
     C                   ENDIF

     C                   EVAL      W@Reve = WEAMT
     C                   EVAL      W@Susp = WEAMT
     C                   EVAL      W@NrSus = 1

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkUpdT - Check Update                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkUpdT     BEGSR

     C                   MOVE      'U'           W@Action

      ** Check whether fee can be repaid/suspended or whether it
      ** must be early matured

     C                   IF        WPastDue = 'P'
     C                             OR WPastDue = 'Y'

     C                   SELECT

      ** FEFEMC = S Early mature conditioned on Nr of subsequent
      ** suspended payments

     C                   WHEN      FEFEMC = 'S'
     C                             AND W@NrSus = 1

     C                   Z-ADD     0             W@TNrSus
     C                   EVAL      W@TNrSus = FESFP + W@NrSus
     C                   IF        W@TNrSus >= FESFPM
     C                   EVAL      W@Action = 'C'
     C                   ELSE
     C                   EVAL      W@Action = 'S'
     C                   ENDIF

      ** FEFEMC = T Early mature conditioned on Nr of total suspended
      ** payments

     C                   WHEN      FEFEMC = 'T'
     C                             AND W@NrSus = 1

     C                   Z-ADD     0             W@TNrSus
     C                   EVAL      W@TNrSus = FESFP + W@NrSus
     C                   IF        W@TNrSus >= FESFPM
     C                   EVAL      W@Action = 'C'
     C                   ELSE
     C                   EVAL      W@Action = 'S'
     C                   ENDIF

      ** FEFEMC = A Early mature conditioned on Total Suspended
      ** amount

     C                   WHEN      FEFEMC = 'A'
     C                             AND W@Susp <> 0

     C                   Z-ADD     0             W@TSusp
     C                   EVAL      W@TSusp = FESFA + W@Susp
     C                   IF        W@TSusp >= FESFAM
     C                   EVAL      W@Action = 'C'
     C                   ELSE
     C                   EVAL      W@Action = 'S'
     C                   ENDIF

     C                   ENDSL

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdack - Update Account                                     *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRUpdack      BEGSR

     C                   EVAL      w@Pdamt = 0
     C                   EVAL      w@Origp = LKEAMT
     C                   EVAL      Lkaamt = P@BLAF
     C                   EVAL      LKIPFL = 'P'

     C                   SELECT

      ** Repayment can be suspended

     C                   WHEN      W@Action = 'U'
     C                   UPDATE    LKEYFEDF

      ** Fee can be suspended

     C                   WHEN      W@Action = 'S'

      ** When the repayment is fully past due and fee payment can
      ** be suspended - delete account key

     C                   IF        WPastDue = 'Y'

     C                   DELETE    LKEYFEDF

      ** Update trailer to reduece nr of records and total amount

     C                   EVAL      W@ZZAMT = W@SusP
     C                   EVAL      W@Sign = 'S'
     C                   EVAL      W@NORE = -1
     C                   EXSR      SRTrailV

      ** Update LKEYFED fields
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
                                                                                            MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      WINAMT = W@Susp                                          MD046080
     C                   EVAL      ORWAMT = W@Susp                                          MD046080
     C                   EXSR      SRCvtAmt                                                 MD046080
     C                   EVAL      W@Susp = WOUTAMT                                         MD046080
     C                   ENDIF                                                              MD046080

     C                   EVAL      FEAMTS = FEAMTS - W@Susp

     C                   IF        FECALT <> *BLANKS
     C                             AND FEPAMS > 0
     C                   EVAL      FEPAMS = FEPAMS - W@Susp
     C                   IF        FEPAMS < 0
     C                   EVAL      FEPAMS = 0
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      FESFA = FESFA + W@Susp
     C                   EVAL      FESFP = FESFP + W@NrSus
     C                   UPDATE    LEFEEDF
     C                   ENDIF

      ** When the repayment is partly past due and fee payment
      ** can be suspended - update existing account key to set event
      ** amount = amount that can be repaid
      *
     C                   IF        WPastDue = 'P'

      ** Update existing a/c key to set repayment amount = available
      ** amount

     C                   EVAL      LKEAMT = W@Repay
     C                   UPDATE    LKEYFEDF

      ** update trailer to reduce amount

     C                   EVAL      W@ZZAMT = W@Susp
     C                   EVAL      W@Sign = 'S'
     C                   EVAL      W@NORE = 0
     C                   EXSR      SRTrailV

      ** Update LEFEED  fields
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
                                                                                            MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      WINAMT = W@Susp                                          MD046080
     C                   EVAL      ORWAMT = W@Susp                                          MD046080
     C                   EXSR      SRCvtAmt                                                 MD046080
     C                   EVAL      W@Susp = WOUTAMT                                         MD046080
     C                   ENDIF                                                              MD046080

     C                   EVAL      FEAMTS = FEAMTS - W@Susp

     C                   IF        FECALT <> *BLANKS
     C                             AND FEPAMS > 0
     C                   EVAL      FEPAMS = FEPAMS - W@Susp
     C                   IF        FEPAMS < 0
     C                   EVAL      FEPAMS = 0
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      FESFA = FESFA + W@Susp
     C                   EVAL      FESFP = FESFP + W@NrSus
     C                   UPDATE    LEFEEDF
                                                                                            MD046080
      ** Put back the original value before convert                                         MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      W@Susp = ORWAMT                                          MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   ENDIF

      ** Fee must be early matured

     C                   WHEN      W@Action = 'C'

      ** Change account key from repayment to accrual and reverse
      ** out amount Create a new accrual account key (with opposite
      ** sign) to reverse out the outstanding fee amt
      ** + the suspended amount

     C                   Z-ADD     0             Totpost
     C                   EVAL      Totpost = + LKEAMT + FESFA
     C                   EVAL      Totpost = Totpost * -1
     C                   EVAL      LKEAMT = Totpost
     C                   EVAL      LKEDAT = BJRDNB

     C                   MOVEL     LKAKEY        Wf10
     C                   MOVE      'F'           Wf10
     C                   MOVEL     Wf10          LKAKEY
     C                   IF        LKRECI = 'L'
     C                   MOVEL     LKAKEY        Wf3
     C                   MOVE      'A'           Wf3
     C                   MOVEL     WF3           LKAKEY
     C                   ELSE
     C                   MOVEL     LKAKEY        Wf4
     C                   MOVE      'A'           Wf4
     C                   MOVEL     WF4           LKAKEY
     C                   ENDIF

      ** Update account key

     C                   UPDATE    LKEYFEDF

      ** Update trailer

     C                   EVAL      W@ZZAMT = FESFA
     C                   EVAL      W@Sign = 'A'
     C                   EVAL      W@NORE = 0
     C                   EXSR      SRTrailV

      ** Set LEFEED fields
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
                                                                                            MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      WINAMT = w@Origp                                         MD046080
     C                   EVAL      ORWAMT = w@Origp                                         MD046080
     C                   EXSR      SRCvtAmt                                                 MD046080
     C                   EVAL      w@Origp = WOUTAMT                                        MD046080
     C                   ENDIF                                                              MD046080

     C                   EVAL      FEAMTS = FEAMTS - w@Origp

     C                   IF        FECALT <> *BLANKS
     C                             AND FEPAMS > 0
     C                   EVAL      FEPAMS = FEPAMS - W@Origp
     C                   IF        FEPAMS < 0
     C                   EVAL      FEPAMS= 0
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      FESFA = 0
     C                   EVAL      FEPEND = BJRDNB
     C                   EVAL      FERECI = 'M'
     C                   EVAL      FELCHT = 'S'

      ** Update fee file

     C                   UPDATE    LEFEEDF

      ** Put back the original value before convert                                         MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      w@Origp = ORWAMT                                         MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREarlyM - Early Maturity                                     *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SREarlyM      BEGSR

      ** Change account key from repayment to accrual and reverse
      ** out amount

     C                   Z-ADD     0             Totpost
     C                   EVAL      w@Origp = LKEAMT
     C                   EVAL      Totpost = LKEAMT
     C                   EVAL      Totpost = Totpost * -1
     C                   EVAL      LKEAMT = Totpost
     C                   EVAL      LKEDAT = BJRDNB
     C                   MOVE      'P'           LKIPFL

     C                   MOVEL     LKAKEY        Wf10
     C                   MOVE      'F'           Wf10
     C                   MOVEL     Wf10          LKAKEY
     C                   IF        LKRECI = 'L'
     C                   MOVEL     LKAKEY        Wf3
     C                   MOVE      'A'           Wf3
     C                   MOVEL     WF3           LKAKEY
     C                   ELSE
     C                   MOVEL     LKAKEY        Wf4
     C                   MOVE      'A'           Wf4
     C                   MOVEL     WF4           LKAKEY
     C                   ENDIF

      ** Update account key

     C                   UPDATE    LKEYFEDF

      ** Set LEFEED fields
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
                                                                                            MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      WINAMT = w@Origp                                         MD046080
     C                   EVAL      ORWAMT = w@Origp                                         MD046080
     C                   EXSR      SRCvtAmt                                                 MD046080
     C                   EVAL      w@Origp = WOUTAMT                                        MD046080
     C                   ENDIF                                                              MD046080

     C                   EVAL      FEAMTS = FEAMTS - w@Origp

     C                   IF        FECALT <> *BLANKS
     C                             AND FEPAMS > 0
     C                   EVAL      FEPAMS = FEPAMS - W@Origp
     C                   IF        FEPAMS < 0
     C                   EVAL      FEPAMS= 0
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      FESFA = 0
     C                   EVAL      FEPEND = BJRDNB
     C                   EVAL      FERECI = 'M'
     C                   EVAL      FELCHT = 'S'

      ** Update fee file

     C                   UPDATE    LEFEEDF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailV - Update trailer                                     *
      *                                                               *
      * Called by: SRChkSusp, SRUpdack                                *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SRTrailV      BEGSR

      ** Access LEPK2ZZ

     C     *START        SETLL     LEPK2ZZ
     C                   READ      LEPK2ZZ                                78

     C                   IF        *IN78 = *OFF

     C                   EVAL      ZZTOTI = T_LKVLRF
     C                   EVAL      ZZTOTD = T_LKVLRL

     C                   IF        W@ZZAMT <>  *ZEROS

      ** Subtract unavailable amount

     C                   EVAL      ZZAMT = W@ZZAMT/1000

     C                   IF        ZZAMT < *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF

      ** Subtract from trailer total

     C                   IF        W@SIGN = 'S'
     C                   EXSR      GLZSUB
     C                   ENDIF

      ** Add to trailer total

     C                   IF        W@SIGN = 'A'
     C                   EXSR      GLZADD
     C                   ENDIF

     C                   ENDIF

      ** Setting up the values

     C                   EVAL      T_LKVLRF = ZZTOTI
     C                   EVAL      T_LKVLRL = ZZTOTD
     C                   EVAL      T_LKNORE = T_LKNORE + W@NORE

     C                   UPDATE    LKEYFEZF

     C                   ELSE

     C     *LOCK         IN        LDA
     C                   MOVEL     'LEPK2ZZ '    DBFILE
     C                   Z-ADD     005           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepo - Process Report                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRgetBRca, SRGetCcy, SRSetfield                        *
      *                                                               *
      *****************************************************************
     C     SRRepo        BEGSR

      ** Read a/c keys file that contains a/c key subject to funds
      ** pre-check

     C                   CLEAR                   LKNORE
     C                   MOVE      *OFF          *IN88
     C                   MOVE      *BLANKS       WBrca
     C     *LOVAL        SETLL     LEPK2L5

      ** Loop to read a/c keys on LEPK2DP

     C     *IN88         DOWEQ     *OFF
     C                   READ      LEPK2L5                                88
     C                   IF        *IN88 = *OFF

     C                   ADD       1             LKNORE

      ** Access branch details

     C                   IF        LKBRCD <> Wbrca
     C                   MOVE      LKBRCD        Branch
     C                   EXSR      SRgetBRca
     C                   WRITE     LER137H1
     C                   WRITE     LER137H2
     C                   MOVE      LKBRCD        WBRca
     C                   ENDIF

      ** Access ccy details

     C                   IF        LKEccy <> WCurr
     C                   EXSR      SRGetCcy
     C                   ENDIF
     C                   MOVE      lkeccy        Wcurr

      ** Set fields

     C                   EXSR      SRSetfield

      ** Print report

     C                   IF        PRtlN1 >= 60
     C                   WRITE     LER137H1
     C                   WRITE     LER137H2
     C                   ENDIF
     C                   WRITE     LER137D1
     C                   ENDIF
     C                   ENDDO

      ** Print end of report page

     C                   IF        PRtlN1 >= 60
     C                   WRITE     LER137H1
     C                   ENDIF
     C                   WRITE     LER137T1

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRGetCcy - Retrieve currency details                         *
      *****************************************************************
     C     SRGetCcy      BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @rtcd
     C                   PARM      '*KEY'        @optn
     C                   PARM                    LKECCY
     C     SDCURR        PARM                    DSSDY

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRSetfield - Format fields                                   *
      *****************************************************************
     C     SRSetfield    BEGSR

     C                   MOVE      *ZEROS        ZFLD15
     C                   MOVE      LkEAMT        ZFLD15
     C                   Z-ADD     a6nbdp        Zdecs
     C                   MOVE      'J'           Zecode
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        OEAMT

     C                   MOVE      *ZEROS        ZFLD15
     C                   MOVE      LkAAMT        ZFLD15
     C                   Z-ADD     a6nbdp        Zdecs
     C                   MOVE      'J'           Zecode
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        OAAMT

      ** facility

     C                   MOVEL     LKFACL        WFAC03
     C                   MOVE      LKFACL        WFAC02
     C                   MOVE      LKFSE2        LKFSEQ
     C                   MOVE      *OFF          *IN34
     C                   IF        LKLOAN <> *BLANKS
     C                   MOVE      *ON           *IN34
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRgetBRca - Retrieve branch details                          *
      *****************************************************************
     C     SRgetBRca     BEGSR

     C                   CALL      'AOBRCHR1'
     C                   PARM      '*DBERR'      @rtcd
     C                   PARM      '*KEY'        @optn
     C                   PARM                    Branch
     C     SDCURR        PARM                    DSSDY

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      *  *INZSR - Initial subroutine                                  *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    pAPOS
     C                   PARM                    pCNAME
     C                   PARM                    pReturnCode

     C                   EVAL      dbPgm = PSProcPgm

     C     Kfee          KLIST
     C                   KFLD                    lkfbrc
     C                   KFLD                    lkcnu2
     C                   KFLD                    lkfacl
     C                   KFLD                    lkloan
     C                   KFLD                    lkfse2

     C     KAcct         KLIST
     C                   KFLD                    SECNUM
     C                   KFLD                    SEACCY
     C                   KFLD                    SEACOD
     C                   KFLD                    SEACSQ
     C                   KFLD                    SEBRCA

     C     KLEP5         KLIST
     C                   KFLD                    lkloan
     C                   KFLD                    lkcnu2
     C                   KFLD                    lkfacl
     C                   KFLD                    lkfse2
     C                   KFLD                    lkfCod
     C                   KFLD                    lkakey

     C     KAllF         KLIST                                                              MD046080
     C                   KFLD                    LKCNU2                                     MD046080
     C                   KFLD                    LKLOAN                                     MD046080
     C                   KFLD                    LKFACL                                     MD046080
     C                   KFLD                    LKFSE2                                     MD046080
     C                   KFLD                    LKOSAC                                     MD046080
                                                                                            MD046080
     C     *LIKE         DEFINE    LKEAMT        WEAMT

      ** Access General Ledger details

     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY

     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

      ** Retrieve trading data

     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @rtcd
     C                   PARM      '*FIRST '     @optn
     C     sdbank        PARM      sdbank        DSFDY

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
     C**********         CALL      'AOSVALR0'                                              AR1063739
     C**********         PARM      *BLANKS       wRETCD                                    AR1063739
     C**********         PARM      SVAL(1)       P@OP01                                    AR1063739
     C**********         PARM      *BLANKS       P@VL01                                    AR1063739
     C**********         PARM      SVAL(2)       P@OP02                                    AR1063739
     C**********         PARM      *BLANKS       P@VL02                                    AR1063739
     C**********         PARM      SVAL(3)       P@OP03                                    AR1063739
     C**********         PARM      *BLANKS       P@VL03                                    AR1063739
     C**********         PARM      SVAL(4)       P@OP04                                    AR1063739
     C**********         PARM      *BLANKS       P@VL04                                    AR1063739
     C**********         PARM      *BLANKS       P@OP05                                    AR1063739
     C**********         PARM      *BLANKS       P@VL05                                    AR1063739
     C**********         PARM      *BLANKS       P@OP06                                    AR1063739
     C**********         PARM      *BLANKS       P@VL06                                    AR1063739
     C**********         PARM      *BLANKS       P@OP07                                    AR1063739
     C**********         PARM      *BLANKS       P@VL07                                    AR1063739
     C**********         PARM      *BLANKS       P@OP08                                    AR1063739
     C**********         PARM      *BLANKS       P@VL08                                    AR1063739
     C**********         PARM      *BLANKS       P@OP09                                    AR1063739
     C**********         PARM      *BLANKS       P@VL09                                    AR1063739
     C**********         PARM      *BLANKS       P@OP10                                    AR1063739
     C**********         PARM      *BLANKS       P@VL10                                    AR1063739

     C**********         IF        WRetcd <> *BLANKS                                       AR1063739
     C******LOCK         IN        LDA                                                     AR1063739
     C**********         MOVEL     'LE000137'    DBPGM                                     AR1063739
     C**********         MOVEL     'SDSVALPD'    DBFILE                                    AR1063739
     C**********         MOVEL     '*KEY   '     DBKEY                                     AR1063739
     C**********         Z-ADD     008           DBase                                     AR1063739
     C**********         OUT       LDA                                                     AR1063739
     C**********         EXSR      *PSSR                                                   AR1063739
     C**********         ENDIF                                                             AR1063739

      ***Save*value*of*Settlement09Postings*in*a*one*character*field***                    AR1063739

     C**********         MOVEL     P@VL04        SET09                                     AR1063739

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

     C                   IF        WRetcd <> '        '
     C                   MOVE      'P'           PPCUST
     C                   ELSE

      ** Isolate the first character of SVAL1 which = 'P' or 'O'.

     C                   MOVEL     SVAL1         WRK01
     C                   IF        WRK01 = 'O'
     C                   MOVE      'O'           PPCUST
     C                   ELSE
     C                   MOVE      'P'           PPCUST
     C                   ENDIF
     C                   ENDIF

      ** Calculate previous end of year + 1 to the start of year
      ** date in DDMMYY format and store STOY day field

     C                   Z-ADD     0             ZDAYNO
     C     BJPEYD        ADD       1             ZDAYNO
     C                   EXSR      Zdate2
     C                   IF        Zdate = *ZEROS
     C                             AND ZADATE = *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'LE000137'
     C                   EVAL      DBFILE = 'ZDATE2 '
     C                   EVAL      DBASE = 009
     C                   OUT       LDA
     C                   ENDIF
     C                   MOVEL     ZADATE        SOYDD

      ** Calculate the start of month date by converting the
      ** date of next working day to date format and inserting the
      ** start of year day number

     C                   Z-ADD     BJDNWD        ZDAYNO
     C                   EXSR      Zdate2
     C                   IF        Zdate = *ZEROS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'LE000137'
     C                   EVAL      DBFILE = 'ZDATE2 '
     C                   EVAL      DBASE = 010
     C                   OUT       LDA
     C                   ENDIF

     C                   MOVE      ZDATE         SMDT
     C                   MOVE      ZDATE         SMDTUS
     C                   IF        BJDFIN = 'D'
     C                   MOVEL     SOYDD         SMDD
     C                   ELSE
     C                   MOVEL     SOYDD         SMDDUS
     C                   MOVEL     SMDDUS        SMDD
     C                   MOVE      SMUS          SM
     C                   ENDIF

      ** Divide GDATE (converted date of next working day) by 10000
      ** to get the day number (2 DIGITS) and move the start of year
      ** day into a two digit work field for later comparison.

     C     ZDATE         DIV       10000         DNWDDD
     C                   MOVEL     SOYDD         WKDDSY

      ** If the day number of the date of next working
      ** day is less than the start of month day subtract
      ** one from the month number of the date of next working day
      ** this ensures that the conversion and checking of the start
      ** of month date is performed on the current month & not
      ** the next

     C                   IF        WKDDSY > DNWDDD
     C                   SUB       1             SM
     C                   IF        SM = 0
     C                   Z-ADD     12            SM
     C                   SUB       1             SY
     C                   IF        SY < 0
     C                   Z-ADD     99            SY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      SMDT          GDATE
     C                   MOVE      '0'           GRTCD
     C                   CALL      'LERDATEF'
     C                   PARM                    GDATE
     C                   PARM                    GDAYNO
     C                   PARM                    GRTCD

     C                   IF        GRTCD <> '0'
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'LE000137'
     C                   EVAL      DBFILE = 'LERDATEF'
     C                   EVAL      DBASE = 011
     C                   OUT       LDA
     C                   ENDIF
     C                   Z-ADD     gdayno        smdy

      ** Check whether the start of the new month falls between RUND
      ** and the date of next working day and if so make the start of
      ** next working day less one the end date.

     C                   IF        SMDY > BJRDNB
     C                             AND SMDY <= BJDNWD
     C                             AND BKAPDT = BJRDNB
     C     SMDY          SUB       1             CODT
     C     SM            SUB       1             MN

     C                   ELSE

     C                   Z-ADD     SM            MN

      ** Calc. earlier of accruals/profit date & (next working day - 1)

     C     BJDNWD        SUB       1             CODT
     C                   IF        BKAPDT < CODT
     C                   Z-ADD     BKAPDT        CODT
     C                   ENDIF
     C                   ENDIF

      ** Find the month of the CODT field for historic file

     C                   Z-ADD     CODT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   IF        ZDATE = *ZEROS
     C                             AND ZADATE = *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'LE000137'    DBPGM
     C                   MOVEL     'ZDATE2  '    DBFILE
     C                   Z-ADD     012           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     ZDATE         WDATE
     C                   MOVE      ZADATE        WCODTA

      ** Compute the total number of days from start date of the month
      ** up to the accrual profit date.  Also, get the value of the
      ** start date of the month in Midas format.

     C     WDATE         DIV       10000         MNTND
     C     CODT          SUB       MNTND         MSTD
     C     MSTD          ADD       1             MSTD

      ** Check if the result is zero (month was January) and if it is
      ** move December's month number (12) into the month field.

     C                   IF        MN = 0
     C                   Z-ADD     12            MN
     C                   ENDIF

      ** Get the value of the previous month for the array setup

     C     MN            SUB       1             M2

     C                   IF        M2 = 0

     C                   Z-ADD     12            M2

     C                   ENDIF

      ** Retrieve month where the fee amount must be added.

     C                   IF        WKDDSY = 01

      ** If the date format is to be European (DDMMYY):

     C                   Z-ADD     WDATE         WWDAT

     C                   IF        BJDFIN = 'D'
     C                   Z-ADD     WWDT2         MN
     C                   ELSE

      ** Otherwise use the U.S.A.-Defined date data structure

     C                   Z-ADD     WWDT1         MN
     C                   ENDIF

     C                   ENDIF

     C                   WRITE     LER137H1
     C                   WRITE     LER137H2

     C                   ENDSR

      *****************************************************************
      *  ZDATE2                                                       *
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM                    ZADATE
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUB - Subtracts an amount (ZZAMT) from the total           *
      *****************************************************************
     C     GLZSUB        BEGSR

      ** Just reverse the 'sign' and add

     C                   Z-SUB     ZZAMT         ZZAMT
     C                   EXSR      GLZADD
     C                   Z-SUB     ZZAMT         ZZAMT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZADD - Adds an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD) *
      *                                                               *
      *  Called by: GLZSUB                                            *
      *                                                               *
      *  Calls: GLZSUM                                                *
      *                                                               *
      *****************************************************************
     C     GLZADD        BEGSR

     C                   IF        ZZAMT <> *ZERO

      ** Split ZZAMT into integer and decimal fields

     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD

      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now

     C                   EXSR      GLZSUM
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZSUM  -  Carries out the addition of the amounts           *
      *                                                               *
      *  Called by: GLZADD                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     GLZSUM        BEGSR

      ** Save values of indicators to be used in the program

     C                   MOVE      *IN91         WIN91
     C                   MOVE      *IN92         WIN92
     C                   MOVE      *IN93         WIN93
     C                   MOVE      *IN94         WIN94
     C                   MOVE      *IN95         WIN95
     C                   MOVE      *IN96         WIN96
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599

      ** Determine sign of ZZAMTI and ZZAMTD, 92 if neg

     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND

      ** Determine sign of ZZTOTI and ZZTOTD, 91 if neg

     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193

      ** If ZZTOTAL is zero, return ZZAMOUNT

     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND

      ** If signs differ, bypass overflow checks

     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS

     C     ZZAMTD        ADD       ZZTOTD        ZZWK2
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93

     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3

      ** If the modulus of ZZWK3 is lt mod.ZZTOTI then O/F has occured

     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI

      ** If O/F zeroise ZZAMT,Ind '99' set and ZZTOT fields left intact

     C   99              Z-ADD     0             ZZAMT
     C                   GOTO      ZZSEND

      ** The 'signs' are different

     C     ZZOFPS        TAG

      ** If ZZAMT was negative, make it pos. to como with ZZTOT

     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD

      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.

     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD

      ** Both ZZAMT and ZZTOT are now positive

     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95

      ** If ZZTOT eq. ZZAMT return ZERO.

     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND

      ** If ZZTOT gt. ZZAMT.

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

      ** If ZZAMT gt. ZZTOT.

     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3
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

      ** Reverse sign of ZZTOT if larger I/P fields were negative

     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD

      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed

     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG

      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.

     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD

      ** Restore previous indicator values

     C                   MOVE      WIN91         *IN91
     C                   MOVE      WIN92         *IN92
     C                   MOVE      WIN93         *IN93
     C                   MOVE      WIN94         *IN94
     C                   MOVE      WIN95         *IN95
     C                   MOVE      WIN96         *IN96

     C                   ENDSR
      *****************************************************************                     MD046080
     C/EJECT                                                                                MD046080
      *****************************************************************                     MD046080
      *    SRCvtAmt - Convert Amount                                  *                     MD046080
      *****************************************************************                     MD046080
     C     SRCvtAmt      BEGSR                                                              MD046080
                                                                                            MD046080
      ** If CLE034 switched ON, get settlement details fro LESTALPD                         MD046080
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
     C                   EVAL      WCCY2 = FEFCCY                                           MD046080
     C                   IF        FEREXI = 'M'                                             MD046080
     C                   EVAL      WMDIN = 'D'                                              MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WMDIN = 'M'                                              MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
      ** If one of currencies is blank, no conversion                                       MD046080
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
      *  *PSSR - Error Handling                                       *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        runBefore <> 'Y'
     C                   EVAL      runBefore = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      pReturnCode = '*ERROR*'
     C                   MOVE      *ON           *INLR
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   RETURN

     C                   ENDSR

     C/COPY ZSRSRC,ZSEDITZ3LE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
