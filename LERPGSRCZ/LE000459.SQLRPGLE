     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                    AR1022006
/*STD *  RPGSQLMOD                                                    *                    AR1022006
/*EXI *  TEXT('Midas LE PDCL Repayments - extract LEACCTPD')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000459 - Past Due Call Loan Repayments - Extract records to*
      *                LEACCTPD                                       *
      *           The function of this program is to create the       *
      *           repayment schedule for Past Due Call Loans.         *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD054326           Date 18Sep19               *
      *  Prev Amend No. MD036674           Date 26Nov15               *
      *                 MD051931           Date 23Sep18               *
      *                 MD051946           Date 23Sep18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD046080           Date 17Sep17               *
      *                 CLE164             Date 18Aug14               *
      *                 AR989420           Date 17Jun13               *
      *                 AR815697           Date 06Jun13               *
      *                 AR786878           Date 05Jun13               *
      *                 MD020619           Date 24May13               *
      *                 MD020206           Date 29Apr13               *
      *                 AR806881           Date 24Apr13               *
      *                 AR1022006          Date 01Aug12               *
      *                 AR750468           Date 14Oct12               *
      *                 AR374952           Date 01Aug12               *
      *                 AR217562           Date 01Aug12               *
      *                 263605             Date 01Aug12               *
      *                 263074             Date 01Aug12               *
      *                 262862             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054326 - Repayment amount debited from settlement account  *
      *             showed discrepancy against balance check          *
      *             on LEC000496 report (Recompile)                   *
      *  MD036674 - CLE164 Downgrade Performance Issues               *
      *           - Applied for MD-48954                              *
      *  MD051931 - Oustanding PDCL Z amount not paid but has         *
      *             sufficient balance                                *
      *  MD051946 - LEACCTPD amount was converted first then reduced  *
      *             by reconverting back the amount of LEREMRPD       *
      *             to PDCL currency                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046080 - Gap between CLE031 (Settlement to different       *
      *             currency) and CLE134 (PDCL processing)            *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  AR989420  - Repayment of PDCLs should use Original Loan      *
      *              Value Date instead of PDCL Value Date. Amend     *
      *              setting of SEVDAT in LEACCTPD and in LEREMRPD.   *
      *              (Child: AR989424)                                *
      *  AR815697 - New processing for maturity events of PDCL's.     *
      *             (Child:AR815698)                                  *
      *  AR786878 - New processing for manual repayment and           *
      *             repayment schedule for PDCL's. (Child: AR786879)  *
      *  MD020619 - Reverse fix for MD-20206                          *
      *  MD020206 - Change validation in writing to LEACCTPD when     *
      *             priority type is 200.                             *
      *  AR806881 - Reverse AR811076 as this has caused extra 1-day   *
      *             on the calculated interest. Suppress the genera-  *
      *             tion of LEACCTPD if amount < 0. (Child: AR806882) *
      *  AR1022006 - COB Performance Optimisation                     *
      *  AR750468 - Make interest of all Past Due Call Loans to have  *
      *             the same hierarchy. (Child: AR750469)             *
      *  AR374952 - Outstanding interest after full repayment of PDCL *
      *             When loan is fully repaid, the outstanding        *
      *             interest remains 1 instead of zero                *
      *             (Child: AR374953)                                 *
      *  AR217562 - Incorrect Repayment Methodology                   *
      *           - Assign a lower priority to Interest repayments    *
      *           2 records are output to LEACCTPD:                   *
      *           - record with lower priority and SEINTA = Int Due   *
      *             and SEPRAM = 0                                    *
      *           - record with higher priority and SEPRAM = CPAM and *
      *             and SEINTA = 0                                    *
      *             (Child: AR217563)                                 *
      *  263605 - Wrong Accrued Interest for PDCLs                    *
      *  263074 - Wrong Postings when interest and principal are paid *
      *           on the same day                                     *
      *           CLE134 / SWIFT                                      *
      *  262862 - Wrong Branch when RSTM = 05ng                       *
      *  CLE134 - Past Due Call Loan Processing                       *
      *         - PDCL loans incorrectly set to mature on rundate     *
      *           though there are outstanding interest.(M01991)      *
      *****************************************************************
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR) PREFIX(ac)
      ** Midas GL Account details - retail key

     F***LEACCNL5  IF   E           K DISK    INFSR(*PSSR)                                    CLE164
     F**********                           PREFIX(r_)                                         CLE164
      ***Midas*LE*Repayment*Priority***********************************                       CLE164

     F***LEPDCRPD  IF   E           K DISK    INFSR(*PSSR)                                 AR1022006
     F**********                           PREFIX(k_)                                      AR1022006
      ** Midas LE Customer Loans

     FLEACCTL1  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(p_)
     F                                     COMMIT
      ** Midas LE Repayment Priority

     FLEPDUEL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Past Due & Original Loan Link

     FLEPDUFL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Past Due & Original Loan Link

     FLEREMRPD  IF   E           K DISK    INFSR(*PSSR)                                     AR786878
     F                                     PREFIX(M_)                                       AR786878
      ** Midas LE Repayment Priority - Temporary File                                       AR786878
                                                                                            AR786878
     FMCLONCL1  IF   E           K DISK    INFSR(*PSSR)                                     AR989420
     F                                     PREFIX(C_)                                       AR989420
     F                                     RENAME(CLOANCLF:MCLONCLF)                        AR989420
     FLEPDUELZ  IF   E           K DISK    INFSR(*PSSR)                                     AR989420
     F                                     PREFIX(Y_)                                       AR989420
     F                                     RENAME(LEPDUED0:LEPDUEDC)                        AR989420
     FLEPDUFLZ  IF   E           K DISK    INFSR(*PSSR)                                     AR989420
     F                                     PREFIX(Y_)                                       AR989420
     F                                     RENAME(LEPDUFD0:LEPDUFDC)                        AR989420
     FLEFEEDLZ  IF   E           K DISK    INFSR(*PSSR)                                     AR989420
     F                                     PREFIX(F_)                                       AR989420
                                                                                            AR989420
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)                                       CLE164
     F                                     RENAME(LEFEEDF:LEFEEDFQ)                           CLE164
     F                                     PREFIX(L_)                                         CLE164
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       CLE164
     F                                     PREFIX(N_)                                         CLE164
     F                                     IGNORE(CLOANHHF)                                   CLE164
     F                                     IGNORE(CLOANCKF)                                   CLE164
     F                                     IGNORE(CLOANZ1F)                                   CLE164
     D/EJECT

      ** Key Fields
     D DSINTDUE        S             15  0 INZ
     D DSRPYAMT        S             15  0 INZ
     D WKTPRAM         S             15  0 INZ                                              AR786878
     D WKTINTA         S             15  0 INZ                                              AR786878

     D KACACNO         S                   INZ LIKE(ACACNO)

      ** Local Variables                                                                    MD036674
     D Sysvalue        S             20A                                                    MD036674
     D PVl01           S            200A                                                    MD036674
     D LTypPref        S              1A                                                    MD036674
     D LoanType        S              2A                                                    MD036674
     D SubType         S              2A                                                    MD036674
     D Nbrcds          S              4  0                                                  MD036674
     D NbrcdsF         S              4  0                                                  MD036674
     D index           S              4  0                                                  MD036674
     D ARRINDX         S              4  0                                                  MD036674
     D V_LNTY          S              2A                                                    MD036674
     D V_LNST          S              2A                                                    MD036674
     D V_LTST          S              4A                                                    MD036674
     D V_CLTY          S              2A                                                    MD036674
     D V_CLST          S              2A                                                    MD036674
     D V_LTSTF         S              4A                                                    MD036674
                                                                                            MD036674
     D V_XINTR         S            200A                                                    MD036674
     D V_XINTM         S            200A                                                    MD036674
     D V_XPRIN         S            200A                                                    MD036674
     D V_XPRIM         S            200A                                                    MD036674
     D V_YINTR         S            200A                                                    MD036674
     D V_YINTM         S            200A                                                    MD036674
     D V_YPRIN         S            200A                                                    MD036674
     D V_YPRIM         S            200A                                                    MD036674
     D V_ZINTR         S            200A                                                    MD036674
     D V_ZINTM         S            200A                                                    MD036674
     D V_ZPRIN         S            200A                                                    MD036674
     D V_ZPRIM         S            200A                                                    MD036674
                                                                                            MD036674
      ** Passed Parameters

      ** Overlays
     D                 DS

      ** External Definitions
     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,PROCPARMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
      ** Nostro details
     D LoanFileFmt   E DS                  EXTNAME(CLOANCL)                                AR1022006
     D                                     PREFIX(k_)                                      AR1022006
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                MD046080

      ** Loans Repayment Priority                                                           MD036674
     D LoanRPR       E DS                  EXTNAME(CLOANZTD)                                MD036674
     D                                     PREFIX(RP_)                                      MD036674
      ** Loan Type Sub Types                                                                MD036674
     D DSSDLOAN      E DS                  EXTNAME(SDLOANPD)                                MD036674
     D                                     PREFIX(SD_)                                      MD036674
     D SDKEY                          4A   INZ DIM(1000)                                    MD036674
     D SDKEYFE                        4A   INZ DIM(200)                                     MD036674
                                                                                            MD036674
      ** Additional Field Definitions
     D WSKIP           S              1
     D PDCLT           S              1
     D WRKOUTINT       S             13  0
     D WKROUND         S             13  0
     D ZIBEG           S              5  0
     D ZIEND           S              5  0
     D ZICALC          S              1  0
     D ZIAMT           S             15  0
     D ZIRATE          S             11  7
     D ZINTR           S             30  9
     D CLE005          S              1
     D KCNUM           S              6
     D KCCY            S              3
     D KEYC1           S             10
     D KEYD            S              2
     D KNONB           S              2
     D KEYF            S              3
     D KEYG            S             10
     D KEYH            S              1
     D pRTCD           S              7A                                                      CLE164
     D pCATC           S              5A                                                      CLE164
     D pFILE           S             10A                                                      CLE164
     D pLOAN           S              6A                                                      CLE164
     D pBRCH           S              3A                                                      CLE164
     D pCUST           S              6A                                                      CLE164
     D pFCLT           S              5S 0                                                    CLE164
     D pFESQ           S              2S 0                                                    CLE164
     D pREPR           S              8S 0                                                    CLE164
     D pCAPR           S              8S 0                                                    CLE164
     D pOVFL           S              1                                                       CLE164
     D OFACA           S              5  0                                                    CLE164
     D OFSQA           S              2  0                                                    CLE164
     D pLFFILE         S             10                                                       CLE164
     D wFACT           S              5                                                       CLE164
     D wFACTD          S              5  0                                                    CLE164
     D R_RPRECI        S              1                                                       CLE164
     D R_RPCNUM        S              6                                                       CLE164
     D R_RPACOD        S             10  0                                                    CLE164
     D R_RPACSQ        S              2  0                                                    CLE164
     D R_RPBRCA        S              3                                                       CLE164
     D R_RPACCY        S              3                                                       CLE164
     D R_RPLNRF        S              6                                                       CLE164
     D WINAMT          S             15  0                                                  MD046080
     D WRATE           S             13  8                                                  MD046080
     D WMDIN           S              1A                                                    MD046080
     D WCCY1           S              3A                                                    MD046080
     D WCCY2           S              3A                                                    MD046080
     D WNBDP1          S              1  0                                                  MD046080
     D WNBDP2          S              1  0                                                  MD046080
     D WOUTAMT         S             15  0                                                  MD046080
     D WWWAMT          S             15P 0                                                  MD046080
     D ORWAMT          S             15P 0                                                  MD046080
     D CLE031          S              1                                                     MD046080

     C/EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+

      ** Retrieve & Process Past Due Call Loan Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 021
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         READ(E)   LEPDCRPD                                                AR1022006
     C**********         DOW       NOT %EOF(LEPDCRPD)                                      AR1022006
                                                                                           AR1022006
     C/EXEC SQL                                                                            AR1022006
     C+ Declare LOANCursor cursor for                                                      AR1022006
     C+ select a.* from cloancl a, sdbankpd b                                              AR1022006
     C+ where substr(a.LTYP,1,1) in('X','Y','Z')                                           AR1022006
     C+   and a.AUTO = 'C'                                                                 AR1022006
     C+   and a.RECI = 'D'                                                                 AR1022006
     C+   and a.ORED <= b.BJRDNB                                                           AR1022006
     C+   and (a.CPAM <> 0 or a.AIPD <> 0 or                                               AR1022006
     C+       a.TOTI <> 0)                                                                 AR1022006
     C+   order by a.LNRF, a.BRCA                                                          AR1022006
     C/END-EXEC                                                                            AR1022006
                                                                                           AR1022006
     C/EXEC SQL                                                                            AR1022006
     C+ Open LOANCursor                                                                    AR1022006
     C/END-EXEC                                                                            AR1022006
                                                                                           AR1022006
     C/EXEC SQL                                                                            AR1022006
     C+ Fetch Next from LOANCursor into :LoanFileFmt                                       AR1022006
     C/END-EXEC                                                                            AR1022006
                                                                                           AR1022006
     C                   DOW       SQLCODE = 0                                             AR1022006
                                                                                           AR1022006
     C                   EXSR      PDCL
     C                   IF        WSKIP <> 'Y'
     C
     C                   EVAL      R_RPRECI = 'D'
     C**********         EVAL      R_RPPCKO = 99999                                           CLE164
     C                   EVAL      R_RPCNUM = *BLANKS
     C                   EVAL      R_RPACOD = *ZERO
     C                   EVAL      R_RPACSQ = *ZERO
     C                   EVAL      R_RPBRCA = *BLANKS
     C                   EVAL      R_RPACCY = *BLANKS
     C                   EVAL      R_RPLNRF = K_LNRF
     C*****K_LNRF        CHAIN(E)  LEACCNL5                                                   CLE164
     ******************************************************************                       CLE164
     C**********         IF        NOT %FOUND(LEACCNL5)                                       CLE164
     C                   EXSR      ACCN
     C**********         ENDIF                                                                CLE164

     C     K_LNRF        CHAIN(E)  LEACCTL1
     C                   IF        NOT %FOUND(LEACCTL1)
     C                   EXSR      WRITE
     C                   ENDIF

     C                   ENDIF
     C**********         READ(E)   LEPDCRPD                                                AR1022006
                                                                                           AR1022006
     C/EXEC SQL                                                                            AR1022006
     C+ Fetch Next from LOANCursor into :LoanFileFmt                                       AR1022006
     C/END-EXEC                                                                            AR1022006
                                                                                           AR1022006
     C                   ENDDO
     C/EXEC SQL                                                                            AR1022006
     C+ CLOSE LOANCursor                                                                   AR1022006
     C/END-EXEC                                                                            AR1022006

      ** Terminate Program

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  PDCL -  Check Whether Loan Should be Processed               *
      *****************************************************************
     C     PDCL          BEGSR

      ** Initialisation

     C                   MOVE      'N'           WSKIP

      ** If input today & created in the COB, set flag to skip record

     C**********         IF        K_ORED = BJRDNB                                            CLE164
     C                   MOVEL     K_LTYP        PDCLT
     C
     C                   IF        PDCLT <> 'Z'
     C     K_LNRF        CHAIN(E)  LEPDUEL1

     C                   IF        %FOUND(LEPDUEL1) AND
     C                             YPCBIC = 'C'
     C                             AND K_ORED = BJRDNB                                        CLE164
     C                   MOVE      'Y'           WSKIP
     C                   ENDIF
     C                   ELSE
     C     K_LNRF        CHAIN(E)  LEPDUFL1
     C                   IF        %FOUND(LEPDUFL1) AND
     C                             YPCBIC = 'C'
     C                             AND K_ORED = BJRDNB                                        CLE164
     C                   MOVE      'Y'           WSKIP
     C                   ENDIF
     C                   ENDIF

     C**********         ENDIF                                                                CLE164

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ACCN - Settlement account                                    *
      *****************************************************************
     C     ACCN          BEGSR

      ** Set Settlement Account from Payable

     C                   IF        K_PTYP = 66 OR
     C                             K_PTYP = 72
     C                   SELECT
     C                   WHEN      K_PSTM = 01 OR
     C                             K_PSTM = 08
     C                   EVAL      KCCY = K_CCY
     C                   EVAL      KNONB = %SUBST(K_PONS:01:02)
     C                   EVAL      KCNUM = *BLANKS
     C                   CALL      'AONOSTR0'    P@NOSTR0

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      R_RPCNUM = A7CUST
     C                   EVAL      R_RPACOD = %DEC(A7ACCD:10:0)
     C                   EVAL      R_RPACSQ = A7ACSN
     C                   EVAL      R_RPBRCA = A7BRCD
     C                   EVAL      R_RPACCY = K_CCY
     C                   ENDIF

     C                   WHEN      K_PSTM = 05
     C                   EVAL      R_RPCNUM = %SUBST(K_PONS:01:06)
     C                   EVAL      R_RPACOD = %DEC(%SUBST(K_PONS:07:10):10:0)
     C                   EVAL      R_RPACSQ = %DEC(%SUBST(K_PONS:17:02):02:0)
     C**********         EVAL      R_RPBRCA = k_OMDB                                          262862
     C                   EVAL      R_RPBRCA = K_OSDB                                          262862
     C                   EVAL      R_RPACCY = K_CCY

     C                   WHEN      K_PSTM = 14
     C                   EVAL      KACACNO = %DEC(K_PONS:10:0)
     C     KACCNTL1      CHAIN(E)  ACCNTL1

     C                   IF        %FOUND(ACCNTL1)
     C                   EVAL      R_RPCNUM = ACCNUM
     C                   EVAL      R_RPACOD = ACACOD
     C                   EVAL      R_RPACSQ = ACACSQ
     C                   EVAL      R_RPBRCA = ACBRCA
     C                   EVAL      R_RPACCY = ACCCY
     C                   ENDIF
     C                   ENDSL

      ** Set Settlement Account from Receivable

     C                   ELSE
     C                   IF        K_PTYP = 61 OR
     C                             K_PTYP = 62 OR
     C                             K_PTYP = 64 OR
     C                             K_PTYP = 68 OR
     C                             K_PTYP = 80
     C                   SELECT
     C                   WHEN      K_RSTM = 01 OR
     C                             K_RSTM = 08
     C                   EVAL      KCCY = K_CCY
     C                   EVAL      KNONB = %SUBST(K_RONS:01:02)
     C                   EVAL      KCNUM = *BLANKS
     C                   CALL      'AONOSTR0'    P@NOSTR0

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      R_RPCNUM = A7CUST
     C                   EVAL      R_RPACOD = %DEC(A7ACCD:10:0)
     C                   EVAL      R_RPACSQ = A7ACSN
     C                   EVAL      R_RPBRCA = A7BRCD
     C**********         EVAL      R_RPACCY = A7BRCD                                          CLE164
     C                   EVAL      R_RPACCY = K_CCY                                           CLE164
     C                   ENDIF

     C                   WHEN      K_RSTM = 05
     C                   EVAL      R_RPCNUM = %SUBST(K_RONS:01:06)
     C                   EVAL      R_RPACOD = %DEC(%SUBST
     C                                          (K_RONS:07:10):10:0)
     C                   EVAL      R_RPACSQ = %DEC(%SUBST
     C                                          (K_RONS:17:02):02:0)
     C**********         EVAL      R_RPBRCA = k_OSDB                                          262862
     C                   EVAL      R_RPBRCA = K_OMDB                                          262862
     C                   EVAL      R_RPACCY = K_CCY

     C                   WHEN      K_RSTM = 14
     C                   EVAL      KACACNO = %DEC(K_RONS:10:0)
     C     KACCNTL1      CHAIN(E)  ACCNTL1

     C                   IF        %FOUND(ACCNTL1)
     C                   EVAL      R_RPCNUM = ACCNUM
     C                   EVAL      R_RPACOD = ACACOD
     C                   EVAL      R_RPACSQ = ACACSQ
     C                   EVAL      R_RPBRCA = ACBRCA
     C                   EVAL      R_RPACCY = ACCCY
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  WRITE - Output to LEACCTPD                                   *
      *****************************************************************
     C     WRITE         BEGSR

      ** Calculate interest

     C**********         EVAL      DSINTDUE = 0                                             AR815697
     C**********         EXSR      INTOUT                                            263605 AR815697
     C**********         EVAL      DSRPYAMT = 0                                             AR815697
     C**********         IF        K_PTYP = 63 OR                                           AR815697
     C**********                   K_PTYP = 65 OR                                           AR815697
     C**********                   K_PTYP = 67                                              AR815697
     C**********         EVAL      DSIntDue = k_TOTI -                                        263605
     C**********                            k_AIPD - k_IPRD - k_ICTD                          263605
     C**********         EVAL      DSINTDUE = WRKOUTINT                              263605 AR815697
      *****************************************************************                     AR815697
     C**********         ELSE                                                               AR815697
     C**********         EVAL      DSIntDue = k_AIPD - k_IPRD - k_ICTD                        263605
     C**********         EVAL      DSINTDUE = WRKOUTINT                              263605 AR815697
     C**********         ENDIF                                                              AR815697
                                                                                            AR786878
      ** Search for pending MR/RE in LEREMRPD. If found, deduct event                       AR786878
      ** amount to current Principal or outstanding Interest.                               AR786878
                                                                                            AR786878
     C                   Z-ADD     0             WKTPRAM                                    AR786878
     C                   Z-ADD     0             WKTINTA                                    AR786878
     C                   MOVE      ' '           WKREMR            1                        AR815697
                                                                                            AR786878
     C     k_LNRF        SETLL(E)  LEREMRPD                                                 AR786878
     C                   IF        %EQUAL(LEREMRPD)                                         AR786878
                                                                                            AR786878
     C     k_LNRF        READE(E)  LEREMRPD                                                 AR786878
                                                                                            AR786878
     C                   DOW       NOT %EOF(LEREMRPD)                                       AR786878
     C**********         EVAL      wKTPRAM = wKTPRAM + m_SEPRAM                    AR786878 MD051946
     C**********         EVAL      wKTINTA = wKTINTA + m_SEINTA                    AR786878 MD051946
     C                   EVAL      wKTPRAM = wKTPRAM + M_PRAM                               MD051946
     C                   EVAL      wKTINTA = wKTINTA + M_INTA                               MD051946
     C                   EVAL      WKREMR = 'Y'                                             AR815697
     C     k_LNRF        READE(E)  LEREMRPD                                                 AR786878
     C                   ENDDO                                                              AR786878
     C                   ENDIF                                                              AR786878
                                                                                            AR815697
     C                   EVAL      DSintdue = 0                                             AR815697
     C                   EXSR      INTOUT                                                   AR815697
     C                   EVAL      DSRpyAmt = 0                                             AR815697
     C                   EVAL      DSIntDue = WrkOutInt                                     AR815697

      ** Output to LEACCTPD

     C                   EVAL      P_SERECI = R_RPRECI
     C**********         EVAL      P_SEPCKO = R_RPPCKO                                        CLE164
     C                   EVAL      P_SEBRCA = R_RPBRCA
     C                   EVAL      P_SEACCY = R_RPACCY
     C                   EVAL      P_SECNUM = R_RPCNUM
     C                   EVAL      P_SEACOD = R_RPACOD
     C                   EVAL      P_SEACSQ = R_RPACSQ
     C                   EVAL      P_SELNRF = R_RPLNRF
     C                   EVAL      P_SEVDAT = K_VDAT
     C                   EVAL      P_SEFILE = 'LEACCTPD'                                      CLE164
     C                   EVAL      P_SEOVRD = 0                                               CLE164
     C                   EVAL      P_SEVDPY = BJRDNB                                          CLE164
     C                   EVAL      P_SEVDPD = K_VDAT                                          CLE164
     C                   EVAL      P_SETREF = K_LNRF + %EDITC(K_FTYP:'X')                     CLE164
     C                                        + %EDITC(K_FSEQ:'X')                            CLE164
     C                   EVAL      P_SETMST = K_TMST                                          CLE164
                                                                                            AR989420
      ** Retrieve Value Date of Original Loan                                               AR989420
                                                                                            AR989420
     C                   EXSR      SROLVD                                                   AR989420
     C                   If        WSEVDT   <> 0                                            AR989420
     C                   EVAL      P_SEVDAT = WSEVDT                                        AR989420
     C                   END                                                                AR989420
                                                                                            AR989420
     C                   EVAL      P_SELTYP = K_LTYP
     C                   EVAL      P_SESUTP = K_SUTP
     C                   MOVEL     K_LTYP        P_SELTY1
     C                   EVAL      P_SETAMT = K_CPAM + DSINTDUE
     C**********         EVAL      WINAMT = P_SETAMT                               MD046080 MD051946
     C**********         EXSR      SrConvert                                       MD046080 MD051946
     C**********         EVAL      P_SETAMT = WOUTAMT                              MD046080 MD051946
     C                   EVAL      P_SEPRAM = K_CPAM
     C**********         EVAL      WINAMT = P_SEPRAM                               MD046080 MD051946
     C**********         EXSR      SrConvert                                       MD046080 MD051946
     C**********         EVAL      P_SEPRAM = WOUTAMT                              MD046080 MD051946
     C                   EVAL      P_SEINTA = DSINTDUE
     C**********         EVAL      WINAMT = P_SEINTA                               MD046080 MD051946
     C**********         EXSR      SrConvert                                       MD046080 MD051946
     C**********         EVAL      P_SEINTA = WOUTAMT                              MD046080 MD051946
     C                   EVAL      P_SEIPFL = *BLANKS
     C**********         EVAL      P_SEFILE = 'LT'                                            CLE164
                                                                                            AR786878
     C                   IF        WKTPRAM <> 0 or WKTINTA <> 0                             AR786878
     C                   EVAL      DSIntDue    = DSIntDue - WKTINTA                         AR786878
     C                   EVAL      P_SEINTA    = DSIntDue                                   AR786878
     C**********         EVAL      WINAMT = P_SEINTA                               MD046080 MD051946
     C**********         EXSR      SrConvert                                       MD046080 MD051946
     C**********         EVAL      P_SEINTA = WOUTAMT                              MD046080 MD051946
     C                   EVAL      K_CPAM      = K_CPAM - WKTPRAM                           AR786878
     C                   EVAL      P_SEPRAM    = K_CPAM                                     AR786878
     C**********         EVAL      WINAMT = P_SEPRAM                               MD046080 MD051946
     C**********         EXSR      SrConvert                                       MD046080 MD051946
     C**********         EVAL      P_SEPRAM = WOUTAMT                              MD046080 MD051946
     C                   ENDIF                                                              AR786878
                                                                                            MD051946
     C                   EVAL      WINAMT = P_SEPRAM                                        MD051946
     C                   EVAL      P_SEPRLN = P_SEPRAM                                      MD051931
     C                   EXSR      SrConvert                                                MD051946
     C                   EVAL      P_SEPRAM = WOUTAMT                                       MD051946
                                                                                            MD051946
     C                   EVAL      WINAMT = P_SEINTA                                        MD051946
     C                   EVAL      P_SEINLN = P_SEINTA                                      MD051931
     C                   EXSR      SrConvert                                                MD051946
     C                   EVAL      P_SEINTA = WOUTAMT                                       MD051946
                                                                                            MD051946
                                                                                              CLE164
      ** Retrieve Date values for LEACCTPD                                                    CLE164
                                                                                              CLE164
     C                   EXSR      SRRETDAT                                                   CLE164

      ** Assign a lower priority to Interest Repayment                                      AR217562

     C                   IF        DSINTDUE <> 0                                            AR217562
     C**********         EVAL      P_SETAMT = DSINTDUE                             AR217562 MD046080
     C                   EVAL      WINAMT = DSINTDUE                                        MD046080
     C                   EVAL      P_SETALN = WINAMT                                        MD051931
     C                   EXSR      SrConvert                                                MD046080
     C                   EVAL      P_SETAMT = WOUTAMT                                       MD046080
     C                   EVAL      P_SEPRAM = 0                                             AR217562
      *****************************************************************              AR217562 CLE164
      ***PDCL*with*type*'Z'*have*priority*200**************************              AR217562 CLE164
      *****************************************************************              AR217562 CLE164
     C                   IF        P_SELTY1 = 'Z'                                           AR217562
     C**********         EVAL      P_SEPCKM = 200                                    AR217562 CLE164
     C**********         EVAL      P_SEPCKT = 200                                    AR217562 CLE164
     C                   EVAL      P_SECATC = 'ZINTR'                                         CLE164
     C                   ENDIF                                                              AR217562
      *****************************************************************                       CLE164
      ***PDCL*with*type*'Y'*have*priority*250**************************              AR217562 CLE164
      *****************************************************************                       CLE164
     C                   IF        P_SELTY1 = 'Y'                                           AR217562
     C**********         EVAL      P_SEPCKM = 250                                  AR217563 AR750468
     C**********         EVAL      P_SEPCKT = 250                                  AR217563 AR750468
     C**********         EVAL      P_SEPCKM = 200                                    AR750468 CLE164
     C**********         EVAL      P_SEPCKT = 200                                    AR750468 CLE164
     C                   EVAL      P_SECATC = 'YINTR'                                         CLE164
     C                   ENDIF                                                              AR217562
      *****************************************************************                       CLE164
      ***PDCL*with*type*'X'*have*priority*290**************************              AR217562 CLE164
      *****************************************************************                       CLE164
     C                   IF        P_SELTY1 = 'X'                                           AR217562
     C**********         EVAL      P_SEPCKM = 290                                  AR217563 AR750468
     C**********         EVAL      P_SEPCKT = 290                                  AR217563 AR750468
     C**********         EVAL      P_SEPCKM = 200                                    AR750468 CLE164
     C**********         EVAL      P_SEPCKT = 200                                    AR750468 CLE164
     C                   EVAL      P_SECATC = 'XINTR'                                         CLE164
     C                   ENDIF                                                              AR217562
                                                                                            AR217562
      ** Retrieve Repayment Priority and                                                      CLE164
      ** Category Code Default Repayment Priority                                             CLE164
                                                                                              CLE164
     C                   EXSR      SRRETRPKY                                                  CLE164
                                                                                              CLE164
      ** Output LEACCTPD with CPAM                                                          AR217562
                                                                                            AR217562
     C                   EVAL      P_SEPAMT = P_SETAMT                                        CLE164
     C**********         IF        P_SETAMT > 0                                    AR806881 MD020206
     C**********         IF        P_SETAMT <> 0                                   MD020206 MD020619
     C                   IF        P_SETAMT > 0                                             MD020619
     C                   EVAL      P_SETRID = P_SETRID + 1                                    CLE164
     C                   WRITE     LEACCTD0                                                 AR217562
     C                   ENDIF                                                              AR806881
                                                                                            AR217562
     C                   ENDIF                                                              AR217562
                                                                                            AR217562

      ** Output LEACCTPD with CPAM if different than zero                                   AR217562

     C                   IF        K_CPAM <> 0                                              AR217562
     C**********         EVAL      P_SETAMT = K_CPAM                               AR217562 MD046080
     C**********         EVAL      P_SEPRAM = K_CPAM                               AR217562 MD046080
     C                   EVAL      WINAMT = K_CPAM                                          MD046080
     C                   EVAL      P_SETALN = WINAMT                                        MD051931
     C                   EXSR      SrConvert                                                MD046080
     C                   EVAL      P_SETAMT = WOUTAMT                                       MD046080
     C                   EVAL      P_SEPRAM = WOUTAMT                                       MD046080
     C                   EVAL      P_SEINTA = 0                                             AR217562

      ** PDCL*with*type 'Z' have priority 200                                               AR217562
      ***PDCL*with*type*'Z'*have*priority*300**************************              AR217562 CLE164

     C                   IF        P_SELTY1 = 'Z'
     C**********         EVAL      p_SEPCKM = 200                                           AR217562
     C**********         EVAL      p_SEPCKT = 200                                    263074 AR217562
     C**********         EVAL      P_SEPCKM = 300                                    AR217562 CLE164
     C**********         EVAL      P_SEPCKT = 300                                    AR217562 CLE164
     C                   EVAL      P_SECATC = 'ZPRIN'                                         CLE164
     C                   ENDIF

      ***PDCL*with*type*'Y'*have*priority*300**************************                     AR217562
      ***PDCL*with*type*'Y'*have*priority*350**************************              AR217562 CLE164

     C                   IF        P_SELTY1 = 'Y'
     C**********         EVAL      p_SEPCKM = 300                                           AR217562
     C**********         EVAL      p_SEPCKT = 300                                    263074 AR217562
     C**********         EVAL      P_SEPCKM = 350                                    AR217562 CLE164
     C**********         EVAL      P_SEPCKT = 350                                    AR217562 CLE164
     C                   EVAL      P_SECATC = 'YPRIN'                                         CLE164
     C                   ENDIF

      ** PDCL*with*type*'X' have priority 300                                               AR217562
      ***PDCL*with*type*'X'*have*priority*390**************************              AR217562 CLE164

     C                   IF        P_SELTY1 = 'X'
     C**********         EVAL      p_SEPCKM = 400                                           AR217562
     C**********         EVAL      p_SEPCKT = 400                                    263074 AR217562
     C**********         EVAL      P_SEPCKM = 390                                    AR217562 CLE164
     C**********         EVAL      P_SEPCKT = 390                                    AR217562 CLE164
     C                   EVAL      P_SECATC = 'XPRIN'                                         CLE164
     C                   ENDIF
                                                                                              CLE164
      ** Retrieve Repayment Priority and                                                      CLE164
      ** Category Code Default Repayment Priority                                             CLE164
                                                                                              CLE164
     C                   EXSR      SRRETRPKY                                                  CLE164

     C                   EVAL      P_SEPAMT = P_SETAMT                                        CLE164
     C**********         IF        P_SETAMT <> 0                                            AR806881
     C                   IF        P_SETAMT > 0                                             AR806881
     C                   EVAL      P_SETRID = P_SETRID + 1                                    CLE164
     C                   WRITE     LEACCTD0
     C                   ENDIF
     C                   ENDIF                                                              AR217562

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     AR989420
      *                                                               *                     AR989420
      *  SROLVD - Retrieve Original Loan Value Date                   *                     AR989420
      *                                                               *                     AR989420
      *  Calls: None                                                  *                     AR989420
      *  Called by: WRITE                                             *                     AR989420
      *                                                               *                     AR989420
      *****************************************************************                     AR989420
     C     SROLVD        BEGSR                                                              AR989420
                                                                                            AR989420
     C                   MOVEL     K_LTYP        PDCLT                                      AR989420
     C                   CLEAR                   Y_YPORG                                    AR989420
     C                   CLEAR                   Y_YECNUM                                   AR989420
     C                   CLEAR                   Y_YEFACL                                   AR989420
     C                   CLEAR                   Y_YPORG                                    AR989420
     C                   CLEAR                   Y_YESEQ                                    AR989420
     C                   CLEAR                   F_FEPSTD                                   AR989420
     C                   CLEAR                   C_VDAT                                     AR989420
     C                   Z-ADD     0             WSEVDT            5 0                      AR989420
                                                                                            AR989420
     C     KPDCL         KLIST                                                              AR989420
     C                   KFLD                    KYRECI            1                        AR989420
     C                   KFLD                    K_LNRF                                     AR989420
                                                                                            AR989420
     C                   MOVE      'P'           KYRECI                                     AR989420
                                                                                            AR989420
     C     KFEES         KLIST                                                              AR989420
     C                   KFLD                    Y_YECNUM                                   AR989420
     C                   KFLD                    Y_YEFACL                                   AR989420
     C                   KFLD                    Y_YPORG                                    AR989420
     C                   KFLD                    Y_YESEQ                                    AR989420
                                                                                            AR989420
     C                   IF        PDCLT <> 'Z'                                             AR989420
     C     KPDCL         CHAIN(E)  LEPDUELZ                                                 AR989420
     C     Y_YPORG       IFNE      *BLANKS                                                  AR989420
     C     Y_YPORG       CHAIN(E)  MCLONCL1                                                 AR989420
     C                   IF        %FOUND(MCLONCL1)                                         AR989420
     C                   EVAL      WSEVDT = C_VDAT                                          AR989420
     C                   ENDIF                                                              AR989420
     C                   ENDIF                                                              AR989420
     C                   ENDIF                                                              AR989420
                                                                                            AR989420
     C                   IF        PDCLT = 'Z'                                              AR989420
     C     KPDCL         CHAIN(E)  LEPDUFLZ                                                 AR989420
     C     KFEES         CHAIN(E)  LEFEEDLZ                                                 AR989420
     C                   IF        %FOUND(LEFEEDLZ)                                         AR989420
     C                   EVAL      WSEVDT = F_FEPSTD                                        AR989420
     C                   ENDIF                                                              AR989420
     C                   ENDIF                                                              AR989420
                                                                                            AR989420
     C                   ENDSR                                                              AR989420
      *****************************************************************                     AR989420
     C/EJECT                                                                                AR989420
      *****************************************************************                       263605
      *  INTOUT - Outstanding Interest                                *                       263605
      *****************************************************************                       263605
     C     INTOUT        BEGSR                                                                263605
                                                                                              263605
     C                   Z-ADD     0             WRKOUTINT                                    263605
                                                                                              263605
      ** Set End date                                                                         263605
                                                                                              263605
     C                   IF        K_VDAT > BJRDNB                                            263605
     C                             AND CLE005 = 'Y'                                           263605
     C                   EVAL      ZIEND = K_VDAT                                             263605
     C                   ELSE                                                                 263605
     C                   EVAL      ZIEND = BJRDNB                                             263605
     C                   ENDIF                                                                263605
                                                                                              263605
     C                   IF        K_MDAT <> 0 AND K_MDAT < BJRDNB                            263605
     C                   EVAL      ZIEND = K_MDAT                                             263605
     C                   ENDIF                                                                263605
                                                                                              263605
      ** Start Date                                                                           263605
                                                                                              263605
     C                   EVAL      ZIBEG = K_IACD                                             263605
                                                                                              263605
      ** Add 1 to End date depending on ADDI indicator                                        263605
                                                                                              263605
     C**********         IF        K_ADDI = 'B'                                        263605 CLE134
     C**********                   AND ZIEND = K_MDAT AND                              263605 CLE134
     C**********                   K_ORED < K_MDAT                                     263605 CLE134
     C**********         IF        ((K_ADDI = 'B') OR (K_ADDI = 'L')) AND            CLE134 AR806881
     C**********                   ZIEND = K_MDAT AND K_ORED < K_MDAT                CLE134 AR806881
     C                   IF        K_ADDI = 'B' AND ZIEND = K_MDAT AND                      AR806881
     C                             K_ORED < K_MDAT                                          AR806881
     C                   EVAL      ZIEND = ZIEND + 1                                          263605
     C                   ENDIF                                                                263605
                                                                                              263605
      ** Add 1 to End date if Original Entry date                                             263605
      ** is after maturity date                                                               263605
                                                                                              263605
     C**********         IF        K_ADDI = 'B' AND K_ORED >= K_MDAT                   263605 CLE134
     C**********         IF        ((K_ADDI = 'B') OR (K_ADDI = 'L')) AND            CLE134 AR806881
     C**********                   K_ORED >= K_MDAT                                  CLE134 AR806881
     C                   IF        K_ADDI = 'B' AND K_ORED >= K_MDAT                        AR806881
     C                   EVAL      ZIEND = ZIEND + 1                                          263605
     C                   ENDIF                                                                263605
                                                                                            AR815697
     C                   IF        WKREMR = 'Y' AND M_AMTP = 'MA'                           AR815697
     C                             AND ZIEND > K_MDAT AND K_ADDI = 'L'                      AR815697
     C                   EVAL      ZIEND = K_MDAT                                           AR815697
     C                   ENDIF                                                              AR815697
                                                                                              263605
      ** Set parameters required for interest calculation                                     263605
                                                                                              263605
     C                   EVAL      ZICALC = K_ICBS                                            263605
     C                   EVAL      ZIRATE = K_INTR                                            263605
     C                   EVAL      ZIAMT = K_CPAM                                             263605
     C                   EXSR      GLINTC                                                     263605
                                                                                              263605
      ** Round Interest depending on RDFC indicator                                           263605
                                                                                              263605
     C                   IF        K_RDFC = 'Y'                                               263605
     C                   Z-ADD     ZINTR         WKROUND                                      263605
     C                   Z-ADD     WKROUND       ZINTR                                        263605
     C                   ELSE                                                               AR374952
     C                   Z-ADD(H)  ZINTR         WKROUND                                    AR374952
     C                   Z-ADD     WKROUND       ZINTR                                      AR374952
     C                   ENDIF                                                                263605
                                                                                              263605
      ** Calculate Interest Outstanding                                                       263605
                                                                                              263605
     C                   EVAL      WRKOUTINT = ZINTR + K_AITC + K_AIAP +                      263605
     C                             K_AIMN - K_IPRD - K_ICTD - K_IWOD                          263605
                                                                                              263605
     C                   ENDSR                                                                263605
      *****************************************************************                       263605
     C/EJECT                                                                                  263605
      *****************************************************************                       263605
      *  GLINTC - Calculate Interest on period                        *                       263605
      *****************************************************************                       263605
     C     GLINTC        BEGSR                                                                263605
                                                                                              263605
     C                   CLEAR                   ZINTR                                      AR374952
     C                   CALL      'GLINTC'                                                   263605
      ** Starting Date                                                                        263605
     C                   PARM                    ZIBEG                                        263605
      ** Finishing date                                                                       263605
     C                   PARM                    ZIEND                                        263605
      ** Calc. Basis                                                                          263605
     C                   PARM                    ZICALC                                       263605
      ** Principal                                                                            263605
     C                   PARM                    ZIAMT                                        263605
      ** Rate of interest                                                                     263605
     C                   PARM                    ZIRATE                                       263605
      ** Interest                                                                             263605
     C                   PARM                    ZINTR                                        263605
                                                                                              263605
     C                   ENDSR                                                                263605
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
     C                   IF        K_PTYP <> 66                                             MD046080
     C                             AND K_PTYP <> 67                                         MD046080
     C                             AND K_PTYP <> 69                                         MD046080
     C                             AND K_PTYP <> 72                                         MD046080
     C**********         EVAL      WCCY1 = K_PSCY                                  MD046080 MD051946
     C**********         EVAL      WRATE = K_PEXR                                  MD046080 MD051946
     C**********         EVAL      WMDIN = K_PEXI                                  MD046080 MD051946
     C                   EVAL      WCCY2 = K_SCCY                                           MD051946
     C                   EVAL      WRATE = K_REXR                                           MD051946
     C                   EVAL      WMDIN = K_REXI                                           MD051946
     C                   ELSE                                                               MD046080
     C**********         EVAL      WCCY1 = K_SCCY                                  MD046080 MD051946
     C**********         EVAL      WRATE = K_REXR                                  MD046080 MD051946
     C**********         EVAL      WMDIN = K_REXI                                  MD046080 MD051946
     C                   EVAL      WCCY2 = K_PSCY                                           MD051946
     C                   EVAL      WRATE = K_PEXR                                           MD051946
     C                   EVAL      WMDIN = K_PEXI                                           MD051946
     C                   ENDIF                                                              MD046080
     C**********         EVAL      WCCY2 = K_CCY                                   MD046080 MD051946
     C                   EVAL      WCCY1 = K_CCY                                            MD051946
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
     C**********         EVAL      P_SEACCY = WCCY1                                MD046080 MD051946
     C                   EVAL      P_SEACCY = WCCY2                                         MD051946
     C                   ENDIF                                                              MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WOUTAMT = WINAMT                                         MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   ENDSR                                                              MD046080
                                                                                            MD046080
      *****************************************************************                       263605
      /EJECT
      *****************************************************************                       263605
      ** *INZSR - Initial processing                                  *                       263605
      *****************************************************************                       263605
     C     *INZSR        BEGSR                                                                263605
                                                                                              263605
     C                   CALL      'AOSARDR0'                                                 263605
     C                   PARM      *BLANK        @RTCD                                        263605
     C                   PARM      '*VERIFY'     @OPTN                                        263605
     C                   PARM      'CLE005'      @SARD                                        263605
                                                                                              263605
     C     @RTCD         IFEQ      *BLANKS                                                    263605
     C                   MOVE      'Y'           CLE005                                       263605
     C                   ELSE                                                                 263605
     C                   MOVE      'N'           CLE005                                       263605
     C                   ENDIF                                                                263605
                                                                                              263605
     C                   CALL      'AOSARDR0'                                               MD046080
     C                   PARM      *BLANK        @RTCD                                      MD046080
     C                   PARM      '*VERIFY'     @OPTN                                      MD046080
     C                   PARM      'CLE031'      @SARD                                      MD046080
                                                                                            MD046080
     C     @RTCD         IFEQ      *BLANKS                                                  MD046080
     C                   MOVE      'Y'           CLE031                                     MD046080
     C                   ELSE                                                               MD046080
     C                   MOVE      'N'           CLE031                                     MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
      ** Load System values for PDPCAT to local variables                                   MD036674
                                                                                            MD036674
     C                   CALL      'AOSVALR0'                                               MD036674
     C                   PARM                    RTNCDE            7                        MD036674
     C                   PARM      'PDPCAT_XINTR'SVALK1           20                        MD036674
     C                   PARM                    SVAL1           200                        MD036674
     C                   PARM      'PDPCAT_XINTM'SVALK2           20                        MD036674
     C                   PARM                    SVAL2           200                        MD036674
     C                   PARM      'PDPCAT_XPRIN'SVALK3           20                        MD036674
     C                   PARM                    SVAL3           200                        MD036674
     C                   PARM      'PDPCAT_XPRIM'SVALK4           20                        MD036674
     C                   PARM                    SVAL4           200                        MD036674
     C                   PARM      'PDPCAT_YINTR'SVALK5           20                        MD036674
     C                   PARM                    SVAL5           200                        MD036674
     C                   PARM      'PDPCAT_YINTM'SVALK6           20                        MD036674
     C                   PARM                    SVAL6           200                        MD036674
     C                   PARM      'PDPCAT_YPRIN'SVALK7           20                        MD036674
     C                   PARM                    SVAL7           200                        MD036674
     C                   PARM      'PDPCAT_YPRIM'SVALK8           20                        MD036674
     C                   PARM                    SVAL8           200                        MD036674
     C                   PARM      'PDPCAT_ZINTR'SVALK9           20                        MD036674
     C                   PARM                    SVAL9           200                        MD036674
     C                   PARM      'PDPCAT_ZINTM'SVALK0           20                        MD036674
     C                   PARM                    SVAL10          200                        MD036674
                                                                                            MD036674
     C                   IF        RTNCDE = *blanks                                         MD036674
                                                                                            MD036674
     C                   EVAL      V_XINTR = SVAL1                                          MD036674
     C                   EVAL      V_XINTM = SVAL2                                          MD036674
     C                   EVAL      V_XPRIN = SVAL3                                          MD036674
     C                   EVAL      V_XPRIM = SVAL4                                          MD036674
     C                   EVAL      V_YINTR = SVAL5                                          MD036674
     C                   EVAL      V_YINTM = SVAL6                                          MD036674
     C                   EVAL      V_YPRIN = SVAL7                                          MD036674
     C                   EVAL      V_YPRIM = SVAL8                                          MD036674
     C                   EVAL      V_ZINTR = SVAL9                                          MD036674
     C                   EVAL      V_ZINTM = SVAL10                                         MD036674
                                                                                            MD036674
     C                   ENDIF                                                              MD036674
                                                                                            MD036674
     C                   CALL      'AOSVALR0'                                               MD036674
     C                   PARM                    RTNCDE            7                        MD036674
     C                   PARM      'PDPCAT_ZPRIN'SVALK1           20                        MD036674
     C                   PARM                    SVAL1           200                        MD036674
     C                   PARM      'PDPCAT_ZPRIM'SVALK2           20                        MD036674
     C                   PARM                    SVAL2           200                        MD036674
     C                   PARM                    SVALK3           20                        MD036674
     C                   PARM                    SVAL3           200                        MD036674
     C                   PARM                    SVALK4           20                        MD036674
     C                   PARM                    SVAL4           200                        MD036674
     C                   PARM                    SVALK5           20                        MD036674
     C                   PARM                    SVAL5           200                        MD036674
     C                   PARM                    SVALK6           20                        MD036674
     C                   PARM                    SVAL6           200                        MD036674
     C                   PARM                    SVALK7           20                        MD036674
     C                   PARM                    SVAL7           200                        MD036674
     C                   PARM                    SVALK8           20                        MD036674
     C                   PARM                    SVAL8           200                        MD036674
     C                   PARM                    SVALK9           20                        MD036674
     C                   PARM                    SVAL9           200                        MD036674
     C                   PARM                    SVALK0           20                        MD036674
     C                   PARM                    SVAL10          200                        MD036674
                                                                                            MD036674
     C                   IF        RTNCDE = *blanks                                         MD036674
                                                                                            MD036674
     C                   EVAL      V_ZPRIN = SVAL1                                          MD036674
     C                   EVAL      V_ZPRIM = SVAL2                                          MD036674
                                                                                            MD036674
     C                   ENDIF                                                              MD036674
                                                                                            MD036674
      ** Cache the Loan Type Sub Type with Overdraft flag set to Y from                     MD036674
      ** SDLOANPD                                                                           MD036674
                                                                                            MD036674
     C                   EXSR      LOADSDLOAN                                               MD036674
                                                                                            MD036674
      ** Cache the Loan Type Sub Type for Overdraft Flag set to Y from                      MD036674
      ** SDFEEPD                                                                            MD036674
     C                   EXSR      LOADSDFEE                                                MD036674
                                                                                            MD036674
     C                   ENDSR                                                                263605
      *****************************************************************                       263605
      /EJECT
      *****************************************************************
      *  @DEFN - Definition Rountine                                  *
      *****************************************************************
     C     @DEFN         BEGSR

      ** Key Lists

     C     KLEACT        KLIST
     C                   KFLD                    K_BRCA
     C                   KFLD                    K_LNRF

     C     KACCNTL1      KLIST
     C                   KFLD                    KACACNO

      ** Parameter List

     C     P@NOSTR0      PLIST
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    KCNUM
     C                   PARM                    KCCY
     C                   PARM                    KEYC1
     C                   PARM                    KEYD
     C                   PARM                    KNONB
     C                   PARM                    KEYF
     C                   PARM                    KEYG
     C                   PARM                    KEYH
     C     SDNOST        PARM      SDNOST        DSFDY

     C                   ENDSR
      /EJECT
      *****************************************************************
      *    SRRETRPKY - Retrieve LEACCTPD Repayment Priorities         *                       CLE164
      *****************************************************************                       CLE164
     C     SRRETRPKY     BEGSR                                                                CLE164
                                                                                              CLE164
     C                   EVAL      PLFFILE = 'CLOANZTD'                                       CLE164
     C                   EVAL      wFACT = %EDITC(K_FTYP:'X') +                               CLE164
     C                                     %EDITC(K_FSEQ:'X')                                 CLE164
     C                   EVAl      wFACTD = %DEC(wFACT:5:0)                                   CLE164
     C                   EVAL      OFACA = wFACTD                                             CLE164
     C                   EVAL      OFSQA = *ZEROS                                             CLE164
                                                                                              CLE164
      * Check first if the record is already existing in CLOANZTD                           MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ select * into :LoanRPR                                                              MD036674
     C+ from CLOANZTD where                                                                 MD036674
     C+ lxlnrf = :K_LNRF and                                                                MD036674
     C+ lxcate = :P_SECATC and                                                              MD036674
     C+ lxcust = :K_CNUM                                                                    MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C                   IF        SQLCOD <> 0                                              MD036674
                                                                                            MD036674
     C                   CALL      'LE000801'                                                 CLE164
     C                   PARM      *BLANK        PRTCD                                        CLE164
     C                   PARM      P_SECATC      PCATC                                        CLE164
     C                   PARM      PLFFILE       PFILE                                        CLE164
     C                   PARM      K_LNRF        PLOAN                                        CLE164
     C                   PARM      K_BRCA        PBRCH                                        CLE164
     C                   PARM      K_CNUM        PCUST                                        CLE164
     C                   PARM      OFACA         PFCLT                                        CLE164
     C                   PARM      OFSQA         PFESQ                                        CLE164
     C                   PARM      *ZEROS        PREPR                                        CLE164
     C                   PARM      *ZEROS        PCAPR                                        CLE164
     C                   PARM      *BLANK        POVFL                                        CLE164
                                                                                            MD036674
     C                   ELSE                                                               MD036674
                                                                                              CLE164
      ** Get required fields from files instead                                             MD036674
                                                                                            MD036674
     C     'PDPCAT_'     CAT       P_SECATC      Sysvalue                                   MD036674
     C                   EVAL      Sysvalue = %TRIM(Sysvalue)                               MD036674
                                                                                            MD036674
     C                   EXSR      GETPCAPR                                                 MD036674
                                                                                            MD036674
     C                   EVAL      PREPR = RP_LXREPR                                        MD036674
     C                   EVAL      PCAPR = %INT(PVl01)                                      MD036674
                                                                                            MD036674
      ** Get Overdraft Flag from SDLOANPD                                                   MD036674
                                                                                            MD036674
     C                   EVAL      LoanType = K_LTYP                                        MD036674
     C                   EVAL      SubType = K_SUTP                                         MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ select LTYP, SUTP into                                                              MD036674
     C+ :LoanType, :SubType                                                                 MD036674
     C+ from CLOANCL where                                                                  MD036674
     C+ LNRF = :K_ORLN                                                                      MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C                   EVAL      LTypPref = %SUBST(K_LTYP:1:1)                            MD036674
     C                   IF        LTypPref = 'X' or                                        MD036674
     C                             LtypPref = 'Y'                                           MD036674
                                                                                            MD036674
     C                   EVAL      ArrIndx = 0                                              MD036674
     C     LoanType      CAT       SubType       V_LTST                                     MD036674
     C                   EVAL      ArrIndx = %LOOKUP(V_LTST : SDKEY)                        MD036674
                                                                                            MD036674
      ** ArrIndx is 0 if the current Loan type Sub Type is not existing in the cache        MD036674
      ** which means the Overdraft flag is N                                                MD036674
     C                   ELSEIF    LtypPref = 'Z'                                           MD036674
                                                                                            MD036674
     C                   EVAL      ArrIndx = 0                                              MD036674
     C     LoanType      CAT       SubType       V_LTSTF                                    MD036674
     C                   EVAL      ArrIndx = %LOOKUP(V_LTSTF : SDKEYFE)                     MD036674
                                                                                            MD036674
     C                   ENDIF                                                              MD036674
                                                                                            MD036674
     C                   IF        ArrIndx = 0                                              MD036674
     C                   EVAL      POVFL = 'N'                                              MD036674
     C                   ELSE                                                               MD036674
     C                   EVAL      POVFL = 'Y'                                              MD036674
     C                   ENDIF                                                              MD036674
                                                                                            MD036674
     C                   ENDIF                                                              MD036674
                                                                                            MD036674
     C                   EVAL      P_SECAPR = PCAPR                                           CLE164
     C                   EVAL      P_SEREPR = PREPR                                           CLE164
     C                   EVAL      P_SEOVFL = POVFL                                           CLE164
     C                   IF        P_SEPRAM <> 0 AND P_SEINTA = 0                             CLE164
     C                   EVAL      P_SEAKEY = 'PRINCIPAL'                                     CLE164
     C                   ELSEIF    P_SEPRAM = 0 AND P_SEINTA <> 0                             CLE164
     C                   EVAL      P_SEAKEY = 'INTEREST'                                      CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *    SRRETDAT - Retrieve LEACCTPD Dates                         *                       CLE164
      *****************************************************************                       CLE164
     C     SRRETDAT      BEGSR                                                                CLE164
                                                                                              CLE164
     C                   EVAL      P_SESDAT = *ZEROS                                          CLE164
     C                   EVAL      P_SEMDAT = *ZEROS                                          CLE164
     C                   IF        P_SELTY1 = 'Z'                                             CLE164
                                                                                              CLE164
     C                   IF        YEFACL = *ZEROS                                            CLE164
     C                   EVAL      OFACA = *ZEROS                                             CLE164
     C                   ELSE                                                                 CLE164
     C                   EVAL      OFACA = %DEC(YEFACL:5:0)                                   CLE164
     C                   ENDIF                                                                CLE164
     C                   IF        YESEQ = *ZEROS                                             CLE164
     C                   EVAL      OFSQA = *ZEROS                                             CLE164
     C                   ELSE                                                                 CLE164
     C                   EVAL      OFSQA = %DEC(YESEQ:2:0)                                    CLE164
     C                   ENDIF                                                                CLE164
     C     FEEKEY        KLIST                                                                CLE164
     C                   KFLD                    K_CNUM                                       CLE164
     C                   KFLD                    OFACA                                        CLE164
     C                   KFLD                    K_OFLN                                       CLE164
     C                   KFLD                    OFSQA                                        CLE164
                                                                                              CLE164
     C     FEEKEY        CHAIN     LEFEEDL1                                                   CLE164
     C                   IF        %FOUND(LEFEEDL1)                                           CLE164
     C                   EVAL      P_SESDAT = L_FEPSTD                                        CLE164
     C                   IF        L_FEPEND = 0                                               CLE164
     C                   EVAL      P_SEMDAT = L_FEPSTD                                        CLE164
     C                   ELSE                                                                 CLE164
     C                   EVAL      P_SEMDAT = L_FEPEND                                        CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDIF                                                                CLE164
     C                   ELSE                                                                 CLE164
     C     YPORG         CHAIN     CLOAN                                                      CLE164
     C                   IF        %FOUND(CLOAN)                                              CLE164
     C                   EVAL      P_SESDAT = N_VDAT                                          CLE164
     C                   IF        N_MDAT = 0                                                 CLE164
     C                   EVAL      P_SEMDAT = N_VDAT                                          CLE164
     C                   ELSE                                                                 CLE164
     C                   EVAL      P_SEMDAT = N_MDAT                                          CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
     C*    GETPCAPR - Get Priority using system values                *                     MD036674
      *****************************************************************                     MD036674
     C     GETPCAPR      BEGSR                                                              MD036674
     C                   SELECT                                                             MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_XINTR'                                MD036674
     C                   EVAL      PVl01 = V_XINTR                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_XINTM'                                MD036674
     C                   EVAL      PVl01 = V_XINTM                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_XPRIN'                                MD036674
     C                   EVAL      PVl01 = V_XPRIN                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_XPRIM'                                MD036674
     C                   EVAL      PVl01 = V_XPRIM                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_YINTR'                                MD036674
     C                   EVAL      PVl01 = V_YINTR                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_YINTM'                                MD036674
     C                   EVAL      PVl01 = V_YINTM                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_YPRIN'                                MD036674
     C                   EVAL      PVl01 = V_YPRIN                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_YPRIM'                                MD036674
     C                   EVAL      PVl01 = V_YPRIM                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_ZINTR'                                MD036674
     C                   EVAL      PVl01 = V_ZINTR                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_ZINTM'                                MD036674
     C                   EVAL      PVl01 = V_ZINTM                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_ZPRIN'                                MD036674
     C                   EVAL      PVl01 = V_ZPRIN                                          MD036674
     C                   WHEN      Sysvalue = 'PDPCAT_ZPRIM'                                MD036674
     C                   EVAL      PVl01 = V_ZPRIM                                          MD036674
     C                   ENDSL                                                              MD036674
                                                                                            MD036674
     C                   ENDSR                                                              MD036674
      *****************************************************************                     MD036674
      *    LOADSDLOAN - Get Loan Type Sub Type with overdraft flag set*                     MD036674
      *                 to Y from SDLOANPD                            *                     MD036674
      *****************************************************************                     MD036674
     C     LOADSDLOAN    BEGSR                                                              MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ select count(*) into:Nbrcds                                                         MD036674
     C+ from SDLOANPD where                                                                 MD036674
     C+ AYOVRD = 'Y'                                                                        MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ declare C1 cursor for                                                               MD036674
     C+ select AYLNTY, AYLNST                                                               MD036674
     C+ from SDLOANPD where                                                                 MD036674
     C+ AYOVRD = 'Y'                                                                        MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ open C1                                                                             MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C                   Eval      Index = 1                                                MD036674
     C                   IF        Nbrcds <> 0                                              MD036674
                                                                                            MD036674
     C     Index         DOUEQ     Nbrcds                                                   MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ fetch next                                                                          MD036674
     C+ from C1                                                                             MD036674
     C+ into: V_LNTY, : V_LNST                                                              MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C     V_LNTY        CAT       V_LNST        SDKEY(Index)                               MD036674
     C                   EVAL      Index = Index + 1                                        MD036674
     C                   ENDDO                                                              MD036674
                                                                                            MD036674
     C                   ENDIF                                                              MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ close C1                                                                            MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C                   ENDSR                                                              MD036674
      *****************************************************************                     MD036674
      *    LOADSDFEE - Get The loan type sub type with overdraft flag *                     MD036674
      *                set to Y from SDFEEPD                          *                     MD036674
      *****************************************************************                     MD036674
     C     LOADSDFEE     BEGSR                                                              MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ select count(*) into:NbrcdsF                                                        MD036674
     C+ from SDFEEPD where                                                                  MD036674
     C+ AUOVRA = 'Y'                                                                        MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ declare C2 cursor for                                                               MD036674
     C+ select AUCLTY, AUCLST                                                               MD036674
     C+ from SDFEEPD where                                                                  MD036674
     C+ AUOVRA = 'Y' and                                                                    MD036674
     C+ AUCLTY <> '' and                                                                    MD036674
     C+ AUCLST <> ''                                                                        MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C/exec SQL                                                                             MD036674
     C+ open C2                                                                             MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C                   Eval      Index = 1                                                MD036674
     C                   IF        NbrcdsF <> 0                                             MD036674
                                                                                            MD036674
     C     Index         DOUEQ     NbrcdsF                                                  MD036674
     C/exec SQL                                                                             MD036674
     C+ fetch next                                                                          MD036674
     C+ from C2                                                                             MD036674
     C+ into: V_CLTY, : V_CLST                                                              MD036674
     C/end-exec                                                                             MD036674
                                                                                            MD036674
     C     V_CLTY        CAT       V_CLST        SDKEYFE(Index)                             MD036674
     C                   EVAL      Index = Index + 1                                        MD036674
                                                                                            MD036674
     C                   ENDDO                                                              MD036674
     C                   ENDIF                                                              MD036674
                                                                                            MD036674
     C                   ENDSR                                                              MD036674
      ******************************************************************************************
     C/COPY ZACPYSRC,PSSR_ILEB
     C/EJECT
**  CPY@
(c) Finastra International Limited 2012
