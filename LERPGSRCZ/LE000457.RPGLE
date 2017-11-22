     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Repayments')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000457 - Past Due Call Loan Repayments                     *
      *                                                               *
      *           The function of this program is to create the       *
      *           repayment schedule for Past Due Call Loans.         *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD046080           Date 17Sep17               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 MD023287           Date 06May14               *
      *                 MD021423C          Date 06Sep13               *
      *                 MD021423 *REWRITE  Date 21Aug13               *
      *                 MD020954           Date 02Aug13               *
      *                 AR786878           Date 05Jun13               *
      *                 MD020823           Date 10Jun13               *
      *                 MD020207           Date 14May13               *
      *                 AR1077063          Date 10Feb13               *
      *                 AR1022006          Date 01Aug12               *
      *                 AR993994           Date 05Jul12               *
      *                 CLE148             Date 05Dec11               *
      *                 AR756718           Date 01Aug12               *
      *                 AR724089           Date 01Aug12               *
      *                 AR402058           Date 01Aug12               *
      *                 AR217562           Date 01Aug12               *
      *                 AR214141           Date 01Aug12               *
      *                 263840             Date 01Aug12               *
      *                 264081             Date 01Aug12               *
      *                 263605             Date 01Aug12               *
      *                 263074             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046080 - Gap between CLE031 (Settlement to different       *
      *             currency) and CLE134 (PDCL processing)            *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  MD023287 - Result variable too small to hold result.         *
      *  MD021423C- Abnormally long run of PDCL/MAPY processing       *
      *             components (Reopened)                             *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *  MD020954 - Missing projection for new PDCL. Rename details of*
      *             LELWNEPK to prevent error in compilation.         *
      *  AR786878 - New processing for manual repayment and           *
      *             repayment schedule for PDCL's. (Child: AR786879)  *
      *  MD020823 - COB: component LEC000457 00001 failed             *
      *  MD020207 - Add COMMIT to be able to ROLLBACK the changes made*
      *             and not affect tables during rerun of LEC000457.  *
      *  AR1077063 - Encountered FOOB in LEC06A seq 04001             *
      *  AR1022006 - COB Performance Optimisation                     *
      *  AR993994 - Negative interest due against a PDCL affected the *
      *             available amount, but no postings were generated. *
      *             Alwats create a manual repayment if the amount due*
      *             is less than zero. Formalise fix.(Child: AR993995)*
      *  CLE148 - Alpha Loan Reference                                *
      *  AR756718 - LEC0457 fellover with a message 'The target for   *
      *             a numeric operation is too small to hold the      *
      *             result'. Initialise properly the Loan Amendment   *
      *             Sequence Number. (Child: AR756719)                *
      *  AR724089 - Several performance issues in COB component       *
      *             LEC0459. Call LE0475 directly, instead of passing *
      *             thru LEC0475. (Child: AR724090)                   *
      *  AR402058 - Wrong Available Balance (Child:AR402059)          *
      *  AR217562 - Wrong repayment methodology (Child:AR217563)      *
      *  AR214141 - Allow for more than 150                           *
      *             Branches (Child:AR214147)                         *
      *  263840 - Correct update of facility utilisation for PDCLs.   *
      *  264081 - Incorrect key used to access LEPDCRPD file.         *
      *  263605 - Wrong Accrued Interest for PDCLs                    *
      *  263074 - Wrong Postings when interest and principal are paid *
      *           on the same day (Recompile)                         *
      *  CLE134 - Past Due Call Loan Processing.                      *
      *                                                               *
      *****************************************************************
     F/SPACE
      *****************************************************************
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR) PREFIX(ac)
      ** Midas GL Account details - retail key
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(l_)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANZ1F)
      ** Midas LE Loans File
      *
     FLEFCAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCAMPF:LEFCAMD3)
     F                                     PREFIX(i_)
      ** Midas LE Facility amendment retrieval index
      *
     FLELOAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LOAMSF)
     F                                     PREFIX(a_)
      ** Midas LE Loan Amendments file
      *
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Branch codes by customer number
      *
     FLEPDUEL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Past Due & Original Loan Link
      *
     FLEPDUFL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Past Due & Original Fees Link
      *
     FFCLTY     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
     F                                     PREFIX(f_)
     F                                     COMMIT
      ** Midas LE Customer lending facility file
      *
     FCLOANLD   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(p_)
      ** Midas LE Loans File
      *
     FLEACCTL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(K_)
     F                                     COMMIT
      ** Midas LE Repayment Priority
      *
     FLELOMKL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSDKF)
     F                                     RENAME(LOAMSZ1F:LELOMZF)
     F                                     COMMIT
      ** Midas LE Loan Amendments file
      *
     FLOAMS     UF A E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSDKF)
     F                                     RENAME(LOAMSZ1F:LOAMSZF)
     F                                     COMMIT
      ** Midas LE Loan Amendments
      *
     FLELOMKPD  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LELOMKF)
     F                                     COMMIT
      ** Midas LE Loan Amendments Detail
      *
     FLOAMSDK   O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas LE Loan amendments file
      *
     FCLOANE    UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:LELWNED0)
     F                                     RENAME(CLOANCKF:LELWNEK0)
     F                                     RENAME(CLOANZ1F:LELWNEZ0)
     F                                     IGNORE(CLOANHHF)
     F                                     COMMIT
      ** Midas LE Loan with New Events keyed on Loan Number
 
      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+
 
     D KBRCA           S                   INZ LIKE(BRCA)
     D KLNRF           S                   INZ LIKE(LNRF)
     D KVDAT           S                   INZ LIKE(VDAT)
     D KLASN           S                   INZ LIKE(LASN)
 
     D Ka_LNRF         S                   INZ LIKE(a_LNRF)
     D Ka_VDAT         S                   INZ LIKE(a_VDAT)
 
     D KacACNO         S                   INZ LIKE(acACNO)
 
     D Kf_CNUM         S                   INZ LIKE(f_CNUM)
     D Kf_FACT         S                   INZ LIKE(f_FACT)
     D Kf_FCNO         S                   INZ LIKE(f_FCNO)
     D Kf_RCTP         S                   INZ LIKE(f_RCTP)
 
     D Ki_CNUM         S                   INZ LIKE(i_CNUM)
     D Ki_FACT         S                   INZ LIKE(i_FACT)
     D Ki_FCNO         S                   INZ LIKE(i_FCNO)
 
     D Kl_LNRF         S                   INZ LIKE(l_LNRF)
     D Kl_RCDT         S                   INZ LIKE(l_RCDT)
 
      ** Passed Parameters.
 
     D P@ACcy          S              3
     D P@ACOD          S             10P 0
     D P@ACSQ          S              2P 0
     D P@BrcA          S              3
     D P@CLAS          S              4
     D P@CNUM          S              6
     D P@LnRf          S              6
     D P@LtSt          S              8
     D P@LTYP          S              2
     D P@Nost          S              5
     D P@Post          S              1
     D P@SCcy          S              3
     D P@SDat          S              5P 0
     D P@SUTP          S              2
 
     D P@RTCD          S             10
     D P@RTCE          S              1
     D P@BLBF          S             15P 0
     D P@BLAF          S             15P 0
     D P@OVLN          S             15P 0
 
     D P@TimeStamp     S               Z
 
      ** Arrays/Tables.
 
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)
     D @BIC            S              6    DIM(999)
 
      ** Overlays.
     D                 DS
      ** Data Structure of Rundates.
     D  f_RUN0                 1      3P 0
     D  f_RUN1                 4      6P 0
     D  f_RUN2                 7      9P 0
     D  f_RUN3                10     12P 0
     D  f_RUN4                13     15P 0
     D  f_RUN5                16     18P 0
     D  f_RUN6                19     21P 0
     D  f_RUN7                22     24P 0
     D  f_RUN8                25     27P 0
     D  f_RUN9                28     30P 0
     D RUNS                    1     30P 0 DIM(10) ASCEND
 
     D                 DS
      ** Data Structure of Drawn Amounts.
     D  f_OAM1                 1      7P 0
     D  f_OAM2                 8     14P 0
     D  f_OAM3                15     21P 0
     D  f_OAM4                22     28P 0
     D  f_OAM5                29     35P 0
     D  f_OAM6                36     42P 0
     D  f_OAM7                43     49P 0
     D  f_OAM8                50     56P 0
     D  f_OAM9                57     63P 0
     D  f_OA10                64     70P 0
     D OAM                     1     70P 0 DIM(10)
 
     D DSPRME1         DS
     D  p_LPFI                             LIKE(LPFI)
     D  p_PTFC                             LIKE(PTFC)
     D  p_PTFT                             LIKE(PTFT)
     D  p_PTFN                             LIKE(PTFN)
 
     D DSPRME2         S                   INZ LIKE(DSPRME1)
 
      ** External Definitions.
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,PROCPARMS
 
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects.
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects.
 
     D LEALLO        E DS                  EXTNAME(LEALLO)
      ** DS for calculating PC reference
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details.
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Branch Details.
 
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ** ICD Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details.
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
 
     D DSFCCY_f        S                   INZ LIKE(f_FCCY)
     D DSCMDI_f        S                   INZ LIKE(f_CMDI)
     D DSCAXR_f        S                   INZ LIKE(f_CAXR)
 
     D DSNBDP_f        S                   INZ LIKE(A6NBDP)
     D DSSPRT_f        S                   INZ LIKE(A6SPRT)
     D DSMDIN_f        S                   INZ LIKE(A6MDIN)
 
     D DSNBDP_f2       S                   INZ LIKE(A6NBDP)
     D DSSPRT_f2       S                   INZ LIKE(A6SPRT)
     D DSMDIN_f2       S                   INZ LIKE(A6MDIN)
 
     D DSNBDP_p        S                   INZ LIKE(A6NBDP)
     D DSSPRT_p        S                   INZ LIKE(A6SPRT)
     D DSMDIN_p        S                   INZ LIKE(A6MDIN)
 
     D DSRVCR          S                   INZ LIKE(i_RVCR)
     D DSVlDt          S                   INZ LIKE(i_VLDT)
 
     D DSBRCH          S                   INZ DIM(500) LIKE(SDBRCH)
     D DSBrCd          S                   INZ DIM(500) LIKE(A8BRCD)
 
     D DSCURR          S                   INZ DIM(500) LIKE(SDCURR)
     D DSCyCd          S                   INZ DIM(500) LIKE(A6CYCD)
 
     D DSLOAN          S                   INZ DIM(500) LIKE(SDLOAN)
     D DSLtSt          S              8    INZ DIM(500)
 
     D DSNOST          S                   INZ DIM(500) LIKE(SDNOST)
     D DSNoCd          S              5    INZ DIM(500)
 
      ** Work Variables.
 
     D DSIntDue        S             15  0 INZ
     D DSIntnlCus      S              1    INZ('N')
     D DSLoanType      S              4    INZ
     D DSOFCXRT        S             15  9 INZ
     D DSPart          S              1    INZ('N')
     D DSRpyAmt        S             15  0 INZ
     D W@FCUS          S              6
     D W@LOAN          S              6
     D W@FACL          S              5
     D W@FSEQ          S              2
     D W@FCOD          S              2
     D W@PDCL          S              1
     D W@FILE          S             10
     D WSkip           S              1
     D Pdclt           S              1
     D P@NATN          S              5  0
     D WrkPRAMS        S             13  0
     D WTRCA           S              1
     D WFCXR           S             13  8
     D WROFXR          S              1
     D CX              S              1  0
     D PRAM_Fac        S             13  0
     D ZRATE1          S             13  8
     D ZMDI1           S              1
     D ZRATE2          S             13  8
     D ZMDI2           S              1
     D ZRATEX          S             13  8
     D ZMDIX           S              1
     D ZAMTCI          S             15  0
     D ZEXCH           S             13  8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0
     D ENDAY           S              5  0
     D DAYNO           S              5  0
     D FCBAL           S             13  0
     D WKSWRI          S              1
     D W#1ST3          S              3
     D W1ST11          S             11
     D WPCRF           S             15
     D PRTCD           S              7
     D POPTN           S              7
     D P@CCY           S              3
     D KCNUM           S              6
     D KCCY            S              3
     D KEYC1           S             10
     D KEYD            S              2
     D KNONB           S              2
     D KEYF            S              3
     D KEYG            S             10
     D KEYH            S              1
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWK2           S              4  0
     D ZZWK3           S             15  0
     D ZZAMT           S             15  3
     D ZZNEGD          S              5
     D WrkOutInt       S             13  0
     D WkRound         S             13  0
     D ZIBEG           S              5  0
     D ZIEND           S              5  0
     D ZICALC          S              1  0
     D ZIAMT           S             15  0
     D ZIRATE          S             11  7
     D ZINTR           S             30  9
 
     D WINAMT          S             15  0                                                  MD046080
     D WRATE           S             13  8                                                  MD046080
     D WSPRT1          S             13  8                                                  MD046080
     D WMDIN           S              1A                                                    MD046080
     D WMDIN1          S              1A                                                    MD046080
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
                                                                                            MD046080
     D                 DS
      ** Working DS with Amounts
 
     D  PRAMR                  1     13  0
     D  INTAR                 14     26  0
     D  PNAMR                 27     39  0
     D  TAMTR                 40     52  0
     D  WTXAR                 53     65  0
     D SAMT                    1     65
 
      ** Loan Amendment Current Amount in numeric
      ** (on Valid format LOAMSDKF)
 
     D  OPRAM                 66     78  0
     D  OINTA                 79     91  0
     D  OPNAM                 92    104  0
     D  OTAMT                105    117  0
     D  OWTXA                118    130  0
     D OAMT                   66    130
 
     D DSACTN          S              1    INZ('I')
 
      ** Indexes.
 
     D #A              S              9  0 INZ
     D #C              S              9  0 INZ
     D #W              S              9  0 INZ
     D #X              S              9  0 INZ
 
      ** Feature Flags.
 
     D CLE005          S              1    INZ('N')
     D CLE009          S              1    INZ('N')
     D CLE014          S              1    INZ('N')
     D CLE023          S              1    INZ('N')
     D CLE025          S              1    INZ('N')
     D CLE028          S              1    INZ('N')
     D CLE134          S              1    INZ('N')
      *  =============
      ** Rename fields
      *  =============
     ILELWNEK0
     I              NLRA                        PKNLRA
 
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
 
      ** Retrieve & Process Past Due Call Loan Details.
 
     C                   READ(E)   LEACCTL2
     C                   DOW       NOT %EOF(LEACCTL2)
     C                   IF        k_SEBRCA  <> *BLANKS AND
     C                             k_SEACCY  <> *BLANKS AND
     C                             k_SECNUM  <> *BLANKS AND
     C                             k_SEACOD  <> *ZEROS  AND
     C                             k_SEACSQ  <> *ZEROS
 
     C     KLEACT        CHAIN(E)  CLOANLD
 
     C                   IF        %FOUND(CLOANLD)
     C                             and ORED <= BJRDNB
 
     C                   EXSR      srPDCL
 
     C                   IF        WSkip      <> 'Y'
     C                   EXSR      xpPDCR
     C                   ENDIF
     C                   ENDIF
 
      ** Update flag on LEACCTPD to 'processed'
 
     C                   EVAL      k_SEIPFL    = 'P'
     C                   UPDATE    LEACCTD0
     C                   ENDIF
 
     C                   READ(E)   LEACCTL2
     C                   ENDDO
 
      ** Terminate Program.
 
     C                   EVAL      *INLR       = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * xpPDCR - Process Past Due Call Loan Details.                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: xsLOAMSZ1, xuLOAMSZ1, xsLELOMZ, xuLELOMZ               *
      *                                                               *
      *****************************************************************
     C     xpPDCR        BEGSR
 
      ** Retrieve Customer Loan 'B' Record Details.
 
     C                   EVAL      Kl_LNRF      = p_LNRF
     C                   EVAL      Kl_RCDT      = 'B'
     C     KCLOAN        CHAIN(E)  CLOAN
 
      ** Determine the Settlement Account.
 
     C                   EVAL      P@CNUM      = *BLANKS
     C                   EVAL      P@ACOD      = 0
     C                   EVAL      P@ACSQ      = 0
     C                   EVAL      P@BRCA      = *BLANKS
     C                   EVAL      P@ACCY      = *BLANKS
 
     C                   EVAL      P@LNRF      = p_LNRF
 
      ** Set Loan Type.
 
     C                   SELECT
     C                   WHEN      p_PTYP      = 61            OR
     C                             p_PTYP      = 62            OR
     C                             p_PTYP      = 63            OR
     C                             p_PTYP      = 70            OR
     C                             p_PTYP      = 80            AND
     C                             CLE028      = 'Y'
     C                   EVAL      DSLoanType  = 'LOAN'
 
     C                   WHEN      p_PTYP      = 64            OR
     C                             p_PTYP      = 65            OR
     C                             p_PTYP      = 68            OR
     C                             p_PTYP      = 71
     C                   EVAL      DSLoanType  = 'PTPU'
 
     C                   WHEN      p_PTYP      = 66            OR
     C                             p_PTYP      = 67            OR
     C                             p_PTYP      = 69            OR
     C                             p_PTYP      = 72
     C                   EVAL      DSLoanType  = 'PTSO'
 
     C                   OTHER
     C                   EVAL      DSLoanType  = 'UNKN'
     C                   ENDSL
 
      ** Set Settlement Account from Payable.
 
     C                   IF        p_PTYP      = 66            OR
     C                             p_PTYP      = 72
     C                   SELECT
     C                   WHEN      p_PSTM      = 01            OR
     C                             p_PSTM      = 08
     C                   EVAL      KCCY        = p_CCY
     C                   EVAL      KNONB       = %SUBST(p_PONS:01:02)
     C                   EVAL      KCNUM       = *BLANKS
     C                   EXSR      xrNOST
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      P@CNUM      = A7CUST
     C                   EVAL      P@ACOD      = %DEC(A7ACCD:10:0)
     C                   EVAL      P@ACSQ      = A7ACSN
     C                   EVAL      P@BRCA      = A7BRCD
     C                   EVAL      P@ACCY      = p_CCY
     C                   ENDIF
 
     C                   WHEN      p_PSTM      = 05
     C                   EVAL      P@CNUM      = %SUBST(p_PONS:01:06)
     C                   EVAL      P@ACOD = %DEC(%SUBST
     C                                      (P_PONS:07:10):10:0)
     C                   EVAL      P@ACSQ = %DEC(%SUBST
     C                                      (P_PONS:17:02):02:0)
     C                   EVAL      P@BRCA      = p_OMDB
     C                   EVAL      P@ACCY      = p_CCY
 
     C                   WHEN      p_PSTM      = 14
     C                   EVAL      KacACNO     = %DEC(p_PONS:10:0)
     C     KACCNTL1      CHAIN(E)  ACCNTL1
 
     C                   IF        %FOUND(ACCNTL1)
     C                   EVAL      P@CNUM      = acCNUM
     C                   EVAL      P@ACOD      = acACOD
     C                   EVAL      P@ACSQ      = acACSQ
     C                   EVAL      P@BRCA      = acBRCA
     C                   EVAL      P@ACCY      = acCCY
     C                   ENDIF
     C                   ENDSL
 
      ** Set Settlement Account from Receivable.
 
     C                   ELSE
     C                   IF        p_PTYP      = 61            OR
     C                             p_PTYP      = 62            OR
     C                             p_PTYP      = 64            OR
     C                             p_PTYP      = 68            OR
     C                             p_PTYP      = 80
     C                   SELECT
     C                   WHEN      p_RSTM      = 01            OR
     C                             p_RSTM      = 08
     C                   EVAL      KCCY        = p_CCY
     C                   EVAL      KNONB = %SUBST(p_RONS:01:02)
     C                   EVAL      KCNUM       = *BLANKS
     C                   EXSR      xrNOST
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      P@CNUM      = A7CUST
     C                   EVAL      P@ACOD      = %DEC(A7ACCD:10:0)
     C                   EVAL      P@ACSQ      = A7ACSN
     C                   EVAL      P@BRCA      = A7BRCD
     C                   EVAL      P@ACCY      = A7CYCD
     C                   ENDIF
 
     C                   WHEN      p_RSTM      = 05
     C                   EVAL      P@CNUM      = %SUBST(p_RONS:01:06)
     C                   EVAL      P@ACOD      = %DEC(%SUBST
     C                                             (P_RONS:07:10):10:0)
     C                   EVAL      P@ACSQ      = %DEC(%SUBST
     C                                             (P_RONS:17:02):02:0)
     C                   EVAL      P@BRCA      = p_OSDB
     C                   EVAL      P@ACCY      = p_CCY
 
     C                   WHEN      p_RSTM      = 14
     C                   EVAL      KacACNO     = %DEC(p_RONS:10:0)
     C     KACCNTL1      CHAIN(E)  ACCNTL1
 
     C                   IF        %FOUND(ACCNTL1)
     C                   EVAL      P@CNUM      = acCNUM
     C                   EVAL      P@ACOD      = acACOD
     C                   EVAL      P@ACSQ      = acACSQ
     C                   EVAL      P@BRCA      = acBRCA
     C                   EVAL      P@ACCY      = acCCY
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
      ** if SEIPFL = 'Y', set Available balance = SEAAMT
      ** (from LEACCTPD). This has been calculated by LEC0459/LE0479
 
     C                   EVAL      P@BLAF      = k_SEAAMT
 
      ** Retrieve Currency Details.
 
     C                   EVAL      k_SEAAMT    = P@BLAF
     C                   EVAL      P@CCY       = P@ACCY
     C                   EXSR      xrCURR
 
     C                   EVAL      DSNBDP_p    = A6NBDP
     C                   EVAL      DSSPRT_p    = A6SPRT
     C                   EVAL      DSMDIN_p    = A6MDIN
 
      ** Calculate Interest Due.
 
     C                   EVAL      DSintdue    = 0
     C                   EVAL      DSRepayAmt = 0
     C                   EVAL      DSINTDUE  = K_SEINTA
     C                   IF        p_PTYP      = 63            OR
     C                             p_PTYP      = 65            OR
     C                             p_PTYP      = 67
 
     C                   ELSE
     C                   ENDIF
 
      ** Calculate amount due based on available balance
 
     C     *LIKE         DEFINE    P@BLAF        Wbalance
     C     *LIKE         DEFINE    p_Cpam        DSRepayAmt
     C     *LIKE         DEFINE    p_Cpam        Wprincipal
     C                   Z-ADD     P@BLAF        Wbalance
     C                   Z-ADD     K_SEPRAM      WPrincipal
 
     C                   IF        Wbalance < 0
     C                   EVAL      Wbalance = Wbalance * -1
     C                   ENDIF
 
     C                   IF        K_SEPRAM <> 0
     C                   EVAL      DSRepayAmt = K_SEPRAM
     C                   ELSE
     C                   EVAL      DSRepayAmt = K_SEINTA
     C                   ENDIF
 
      ** Equate payment amount on what is available.
 
     C                   IF        Wbalance >= DSRepayAmt
     C                   EVAL      Wbalance = Wbalance - DSRepayAmt
     C                   ELSE
     C                   EVAL      DSRepayAmt = Wbalance
     C                   EVAL      Wbalance = 0
     C                   ENDIF
 
      ** Calculate Repayment Amount.
 
     C                   EVAL      DSRpyAmt = DSRepayAmt
 
      ** If Repayment;
      ** - Create Manual Repayment.
 
     C                   IF        DSRpyAmt   <> 0
     C                             AND P@BLAF < 0
     C                             or DSRpyAmt < 0
     C                   EXSR      xsLOAMSDK
     C                   EXSR      xwLOAMSDK
     C                   EXSR      xwLOMK
 
      **********         IF        DSActn      = 'I'                                        MD021423
      **********         EXSR      xsLOAMSZ1                                                MD021423
      **********         EXSR      xuLOAMSZ1                                                MD021423
      **********         EXSR      xsLELOMZ                                                 MD021423
      **********         EXSR      xuLELOMZ                                                 MD021423
      **********         ENDIF                                                              MD021423
 
     C                   IF        DSActn      = 'I'                                       MD021423C
     C                   EXSR      xsLOAMSZ1                                               MD021423C
     C                   EXSR      xuLOAMSZ1                                               MD021423C
     C                   EXSR      xsLELOMZ                                                MD021423C
     C                   EXSR      xuLELOMZ                                                MD021423C
     C                   ENDIF                                                             MD021423C
                                                                                           MD021423C
      ** - Update Facility.
 
     C                   IF        p_FAMU      = 'Y'           OR
     C                             Pdclt       = 'X'
     C                   EXSR      xsFCLTY
     C                   ENDIF
     C                   ENDIF
 
      ** Commit Changes.
 
     C                   EVAL      p_RECI      = 'P'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * srPDCL - Check Whether Loan Should be Processed.              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     srPDCL        BEGSR
 
      ** Initialisation.
 
     C                   MOVE      'N'           WSkip
 
      ** If input today & created in the COB, set flag to skip record.
 
     C                   IF        p_ORED      = BJRDNB
     C                   MOVEL     p_ltyp        Pdclt
     C
     C                   IF        Pdclt <> 'Z'
     C     p_LNRF        CHAIN(E)  LEPDUEL1
 
     C                   IF        %FOUND(LEPDUEL1)            AND
     C                             YPCBIC      = 'C'
     C                   MOVE      'Y'           WSkip
     C                   ENDIF
     C                   ELSE
     C     p_LNRF        CHAIN(E)  LEPDUFL1
     C                   IF        %FOUND(LEPDUFL1)            AND
     C                             YPCBIC      = 'C'
     C                   MOVE      'Y'           WSkip
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * xsLOAMSDK - Set Loan Amendment Details (LOAMSDK & LELOMKPD)   *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     xsLOAMSDK     BEGSR
 
      ** Initialisation.
 
     C                   CLEAR                   LOAMSDKF
 
      ** Set Details.
 
     C                   EVAL      Ka_LNRF     = p_LNRF
     C                   EVAL      Ka_VDAT     = BJRDNB
     C     KLELOAML3     SETGT     LELOAML3
     C     KLELOAML3     READPE    LELOAML3
 
     C                   EVAL      LNRF        = Ka_LNRF
     C                   EVAL      VDAT        = Ka_VDAT
 
     C                   IF        NOT %EOF(LELOAML3)
     C                   EVAL      LASN        = a_LASN
     C                   ELSE
     C                   EVAL      LASN        = 0
     C                   ENDIF
 
     C                   EVAL      LASN       += 1
 
     C                   EVAL      RECI        = 'D'
     C                   EVAL      MRIN        = 2
     C                   EVAL      LTYP        = p_LTYP
     C                   EVAL      SUTP        = p_SUTP
     C                   EVAL      PTYP        = p_PTYP
     C                   EVAL      AMTP        = 'MR'
     C                   EVAL      PRSQ        = 0
     C                   EVAL      BRTT        = 0
     C                   EVAL      RTSP        = 0
     C                   EVAL      CCY         = p_CCY
 
      ** generate 2 different MR one for principal and 1 for interest
 
     C                   EVAL      PRAM        = 0
     C                   EVAL      INTA        = 0
     C                   EVAL      TAMT        = 0
                                                                                            MD046080
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      WINAMT = DSRpyAmt                                        MD046080
     C                   EXSR      SRCvtAmt                                                 MD046080
     C                   EVAL      DSRpyAmt = WOUTAMT                                       MD046080
     C                   ENDIF                                                              MD046080
 
      ** principal
 
     C                   IF        K_SEPRAM <> 0
     C                   EVAL      PRAM = DSRpyAmt
     C                   ENDIF
 
      ** interest
 
     C                   IF        K_SEINTA <> 0
     C                   EVAL      INTA = DSRpyAmt
     C                   ENDIF
 
     C                   EVAL      WTXA        = 0
     C                   EVAL      FEAM        = 0
     C                   EVAL      TAMT        = DSRpyAmt
     C                   EVAL      BRCA        = p_BRCA
     C                   EVAL      CNUM        = p_CNUM
     C                   EVAL      REPT        = 0
     C                   EVAL      AUTO        = 'C'
     C                   EVAL      STAI        = *BLANKS
 
     C                   EVAL      TSEN        = p_RIBN
     C                   EVAL      FACO        = *BLANKS
     C                   EVAL      SPI1        = *BLANKS
     C                   EVAL      SPI2        = *BLANKS
     C                   EVAL      SPI3        = *BLANKS
     C                   BITOFF    '01234567'    LAIN
     C                   EVAL      BRTE        = 0
     C                   EVAL      SPIN        = *BLANKS
     C                   EVAL      CALC        = 0
     C                   EVAL      WTIN        = '0'
     C                   EVAL      LLAG        = 'A'
     C                   EVAL      LWOI        = *BLANKS
     C                   EVAL      XAVD        = 0
     C                   EVAL      XASQ        = 0
     C                   EVAL      FCUS        = p_FCUS
     C                   EVAL      FTYP        = p_FTYP
     C                   EVAL      FSEQ        = p_FSEQ
     C                   EVAL      RLON        = *BLANKS
     C                   EVAL      FECD        = *zero
     C                   BITOFF    '01234567'    PONI
     C                   EVAL      ACTI        = *blanks
     C                   EVAL      CNFY        = *BLANKS
     C                   EVAL      TLXY        = *BLANKS
     C                   EVAL      CBLY        = *BLANKS
     C                   EVAL      INTC        = *BLANKS
     C                   EVAL      NACD        = *BLANKS
     C                   EVAL      ACBI        = *BLANKS
     C                   EVAL      LSWCC       = 0
     C                   EVAL      LSWSC       = 0
     C                   EVAL      FCLB        = p_FCLB
     C                   EVAL      LSMD        = 0
     C                   EVAL      REBT        = *zero
 
     C                   EVAL      ORED        = BJRDNB
     C                   EVAL      LCD         = BJRDNB
     C                   EVAL      CHTP        = 'I'
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      0             P@NATN
 
     C                   EVAL      TNLU        = P@NATN
 
     C                   EVAL      PIBN        = *BLANKS
     C                   EVAL      PIBA        = *BLANKS
     C                   EVAL      POBN        = *BLANKS
     C                   EVAL      POCN        = *BLANKS
     C                   EVAL      RVNO        = *BLANKS
 
     C                   EVAL      AWBN        = *BLANKS
     C                   EVAL      AWBA        = *BLANKS
     C                   EVAL      BENN        = *BLANKS
     C                   EVAL      BENA        = *BLANKS
     C                   EVAL      DTP1        = *BLANKS
     C                   EVAL      DTP2        = *BLANKS
     C                   EVAL      DTP3        = *BLANKS
     C                   EVAL      DTP4        = *BLANKS
     C                   EVAL      DCHG        = *BLANKS
     C                   EVAL      BTB1        = *BLANKS
     C                   EVAL      BTB2        = *BLANKS
     C                   EVAL      BTB3        = *BLANKS
     C                   EVAL      BTB4        = *BLANKS
     C                   EVAL      BTB5        = *BLANKS
     C                   EVAL      BTB6        = *BLANKS
     C                   EVAL      CVMR        = *BLANKS
     C                   EVAL      FSRP        = 0
     C                   EVAL      FSGN        = *BLANKS
     C                   EVAL      FPRC        = *BLANKS
     C                   EVAL      COFA        = 0
     C                   EVAL      IRCF        = *BLANKS
     C                   EVAL      FRCF        = *BLANKS
     C                   EVAL      DFTP        = *BLANKS
     C                   EVAL      DFST        = *BLANKS
     C                   EVAL      MNSG        = 'M'
     C                   EVAL      GASS        = 'N'
     C                   EVAL      GPRT        = 'N'
     C                   EVAL      NRLI        = 'N'
     C                   EVAL      ROLN        = *BLANKS
     C                   EVAL      ROSN        = 0
     C                   EVAL      ROBR        = *BLANKS
     C                   EVAL      RORC        = '000000'
     C                   EVAL      PDGN        = *BLANKS
     C                   EVAL      GRIN        = *BLANKS
     C                   EVAL      RLCY        = *BLANKS
     C                   EVAL      PNAM        = 0
     C                   EVAL      PAST        = *BLANKS
     C                   EVAL      ASTS        = 'A'
     C                   EVAL      IUSR        = 'LE000457'
     C                   EVAL      AUSR        = *BLANKS
     C                   EVAL      XUSR        = *BLANKS
 
     C                   EXSR      xePCRF
     C                   EVAL      PCRF        = WPCRF
 
     C                   EVAL      PCOB        = *BLANKS
     C                   EVAL      MTPD        = 'N'
     C                   EVAL      PDDI        = *BLANKS
     C                   EVAL      PTDI        = *BLANKS
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      SCCY        = p_SCCY                                     MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      SCCY        = *BLANKS
     C                   ENDIF                                                              MD046080
     C                   EVAL      ICCY        = *BLANKS
     C                   EVAL      ECIN        = *BLANKS
     C                   EVAL      REPI        = *BLANKS
     C                   EVAL      CHDU        = 0
     C                   EVAL      INTN        = 0
     C                   EVAL      FSPRAM      = 0
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      REXR        = p_REXR                                     MD046080
     C                   EVAL      REXI        = p_REXI                                     MD046080
     C                   EVAL      PSCY        = p_PSCY                                     MD046080
     C                   EVAL      PEXR        = p_PEXR                                     MD046080
     C                   EVAL      PEXI        = p_PEXI                                     MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      REXR        = 0
     C                   EVAL      REXI        = *BLANKS
     C                   EVAL      PSCY        = *BLANKS
     C                   EVAL      PEXR        = 0
     C                   EVAL      PEXI        = *BLANKS
     C                   ENDIF                                                              MD046080
     C                   EVAL      STAL        = *BLANKS
     C                   EVAL      FRNT        = *BLANKS
     C                   EVAL      AFRT        = *BLANKS
     C                   EVAL      REPA        = *BLANKS
 
     C                   EXSR      xeTimestamp
     C                   EVAL      TMST        = P@TimeStamp
 
     C                   IF        p_PTYP      = 66            OR
     C                             p_PTYP      = 67            OR
 
     C                             CLE005      = 'Y'           AND
     C                             (p_PTYP     = 69            OR
     C                              p_PTYP     = 72)
 
     C                   EVAL      OSAC        = p_PONS
     C                   EVAL      SETP        = p_PSTM
     C                   EVAL      OSBR        = p_OSDB
     C                   EVAL      RSTM        = 0
     C                   EVAL      PSTM        = p_PSTM
 
     C                   ELSE
     C                   EVAL      OSAC        = p_RONS
     C                   EVAL      SETP        = p_RSTM
     C                   EVAL      OSBR        = p_OMDB
     C                   EVAL      RSTM        = p_RSTM
     C                   EVAL      PSTM        = 0
     C                   ENDIF
 
     C                   IF        RSTM        > 0
     C                   EVAL      RIBN        = p_RIBN
     C                   EVAL      RIBA        = p_RIBA
     C                   EVAL      ROBN        = p_ROBN
     C                   EVAL      ROCN        = p_ROCN
     C                   EVAL      RCRN        = p_RCRN
     C                   EVAL      RCRA        = p_RCRA
     C                   EVAL      RONS        = p_RONS
 
     C                   ELSE
     C                   EVAL      RIBN        = *BLANKS
     C                   EVAL      RIBA        = *BLANKS
     C                   EVAL      ROBN        = *BLANKS
     C                   EVAL      ROCN        = *BLANKS
     C                   EVAL      RCRN        = *BLANKS
     C                   EVAL      RCRA        = *BLANKS
     C                   EVAL      RONS        = *BLANKS
     C                   EVAL      PONS        = *BLANKS
     C                   ENDIF
 
     C                   EVAL      PONS        = *BLANKS
     C                   EVAL      AUTH        = *BLANKS
     C                   EVAL      FRCY        = *BLANKS
     C                   EVAL      FRAM        = 0
     C                   EVAL      FINT        = 0
     C                   EVAL      FTXA        = 0
     C                   EVAL      FTOT        = 0
     C                   EVAL      FPEN        = 0
     C                   EVAL      BASR        = 0
     C                   EVAL      SLTP        = *BLANKS
     C                   EVAL      SLST        = *BLANKS
     C                   EVAL      CLAS        = p_CLAS
     C                   EVAL      DFCL        = *BLANKS
     C                   EVAL      SLCL        = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * xsFCLTY - Set Facility Details                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     xsFCLTY       BEGSR
 
      ** Initialisation.
 
     C                   IF        PRAM = 0
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      DSPart      = 'N'
 
      ** Retrieve Facility (A - Record).
 
     C                   EVAL      Kf_CNUM     = p_FCUS
     C                   EVAL      Kf_FACT     = p_FTYP
     C                   EVAL      Kf_FCNO     = p_FSEQ
     C                   EVAL      Kf_RCTP     = 'A'
     C     KFCLTY        CHAIN(NE) FCLTY
 
     C                   IF        NOT %FOUND(FCLTY)           OR
     C                             %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'FCLTY'
     C                   EVAL      DBASE       = 003
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                                      %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Facility (B - Record).
 
     C                   EVAL      Kf_RCTP     = 'B'
     C     KFCLTY        CHAIN(E)  FCLTY
 
     C                   IF        NOT %FOUND(FCLTY)           OR
     C                             %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'FCLTY'
     C                   EVAL      DBASE       = 004
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                                     %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access LEFCAMPD file for change in revolving credit.
 
     C                   EVAL      DSRVCR      = *BLANK
     C                   EVAL      DSVlDt      = 0
 
     C                   EVAL      Ki_CNUM     = FCUS
     C                   EVAL      Ki_FACT     = FTYP
     C                   EVAL      Ki_FCNO     = FSEQ
     C     KFCAM         SETLL     LEFCAML3
     C     KFCAM         READE     LEFCAML3
 
     C                   DOW       NOT %EOF(LEFCAML3)          AND
     C                             DSRVCR      = *BLANK
     C                   IF        i_RECI      = 'D'           AND
     C                             i_FATP      = 'RC'
     C                   EVAL      DSRVCR      = i_RVCR
     C                   EVAL      DSVlDt      = i_VLDT
     C                   ENDIF
 
     C     KFCAM         READE     LEFCAML3
     C                   ENDDO
 
     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'LEFCAML3'
     C                   EVAL      DBASE       = 005
     C                   EVAL      DBKEY = Ki_CNUM + %CHAR(Ki_FACT) +
     C                                     %CHAR(Ki_FCNO)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Currency Details.
 
     C                   EVAL      P@CCY       = f_FCCY
     C                   EXSR      xrCURR
 
     C                   EVAL      DSNBDP_f    = A6NBDP
     C                   EVAL      DSSPRT_f    = A6SPRT
     C                   EVAL      DSMDIN_f    = A6MDIN
 
      ** Evaluate Facility Exposure Amount.
 
     C                   EXSR      xeExpAmt
 
      ** Derive Last Amendment Details & Set TimeStamp.
 
     C                   EVAL      f_LCD       = BJRDNB
     C                   EVAL      f_CHTP      = 'A'
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      0             P@NATN
 
     C                   EVAL      f_TNLU      = P@NATN
 
     C                   EXSR      xeTimestamp
     C                   EVAL      f_STMP      = P@TimeStamp
 
      ** Update Facility.
 
     C                   EXSR      xuFCLTYFN
 
      ** Update superfacility of the tranche, if any, for CLE005
 
     C                   IF        CLE005      = 'Y'        AND
     C                             f_TRCA      = 'TR'
     C                   EVAL      DSPRME2     = DSPRME1
     C                   EXSR      xsFCLTY_CA
     C                   EVAL      DSPRME1     = DSPRME2
     C                   ENDIF
 
      ** Retrieve Facility (A - Record).
 
     C                   IF        p_LPFI     <> ' '
     C                   EVAL      DSPart      = 'Y'
 
     C                   EVAL      Kf_CNUM     = p_PTFC
     C                   EVAL      Kf_FACT     = p_PTFT
     C                   EVAL      Kf_FCNO     = p_PTFN
     C                   EVAL      Kf_RCTP     = 'A'
     C     KFCLTY        CHAIN(E)  FCLTY
 
     C                   IF        NOT %FOUND(FCLTY)           OR
     C                             %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'FCLTY'
     C                   EVAL      DBASE       = 006
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                                     %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Facility (B - Record).
 
     C                   EVAL      Kf_RCTP     = 'B'
     C     KFCLTY        CHAIN(E)  FCLTY
 
     C                   IF        NOT %FOUND(FCLTY)           OR
     C                             %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'FCLTY'
     C                   EVAL      DBASE       = 007
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                                     %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Currency Details.
 
     C                   EVAL      P@CCY       = f_FCCY
     C                   EXSR      xrCURR
 
     C                   EVAL      DSNBDP_f    = A6NBDP
 
      ** Evaluate Facility Exposure Amount.
 
     C                   EXSR      xeExpAmt
 
      ** Set Last Change Details.
 
     C                   EVAL      f_LCD       = BJRDNB
     C                   EVAL      f_CHTP      = 'A'
 
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      0             P@NATN
 
     C                   EVAL      f_TNLU      = P@NATN
 
      ** Derive Timestamp.
 
     C                   EXSR      xeTimestamp
     C                   EVAL      f_STMP      = P@TimeStamp
 
      ** Update Facility.
 
     C                   EXSR      xuFCLTYFN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * xsFCLTY_CA - Set Facility - Credit Agreement Details.         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     xsFCLTY_CA    BEGSR
 
      ** Save Credit Agreement Values.
 
     C                   EVAL      DSFCCY_f    = f_FCCY
     C                   EVAL      DSCMDI_f    = f_CMDI
     C                   EVAL      DSCAXR_f    = f_CAXR
 
      ** Save the revolving credit indicator specified for the tranche
 
     C                   IF        CLE014      = 'Y'
     C                   EVAL      DSRVCR      = f_RVCR
     C                   ENDIF
 
      ** Whenever the facility utilisation is updated for a tranche,
      ** update the credit agreement/superfacility as well
 
     C                   EVAL      Kf_CNUM     = f_CANM
     C                   EVAL      Kf_FACT     = f_CAFT
     C                   EVAL      Kf_FCNO     = f_CAFN
     C                   EVAL      Kf_RCTP     = 'A'
     C     KFCLTY        CHAIN(NE) FCLTY
 
     C                   IF        NOT %FOUND(FCLTY)           OR
     C                             %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'FCLTY'
     C                   EVAL      DBASE       = 008
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                                     %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If the revolving credit indicator for the credit agreement is
      ** 'T', use the saved tranche revolving credit indicator as the
      ** credit agreement revolving indicator.
 
     C                   IF        CLE014      = 'Y'
     C                   IF        f_RVCR      = 'T'
     C                   EVAL      f_RVCR      = DSRVCR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      Kf_RCTP     = 'B'
     C     KFCLTY        CHAIN(E)  FCLTY
 
     C                   IF        NOT %FOUND(FCLTY)           OR
     C                             %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'FCLTY'
     C                   EVAL      DBASE       = 009
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                                     %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If tranche and superfacility currencies are different, get
      ** superfacility currency details
 
     C                   IF        DSFCCY_f   <> f_FCCY
     C                   EVAL      P@CCY       = f_FCCY
     C                   EXSR      xrCURR
 
     C                   EVAL      DSNBDP_f2   = A6NBDP
     C                   EVAL      DSSPRT_f2   = A6SPRT
     C                   EVAL      DSMDIN_f2   = A6MDIN
 
      ** Convert facility amount to credit facility currency equivalent
 
     C                   EVAL      CX = DSNBDP_f2 - DSNBDP_f + 4
 
     C                   IF        DSCMDI_f    = 'D'
     C     DSCAXR_f      DIV(H)    POWR(Cx)      DSOFCXRT
     C     1             DIV       DSOFCXRT      DSOFCXRT
 
     C                   ELSE
     C     DSCAXR_f      MULT(H)   POWR(CX)      DSOFCXRT
     C                   ENDIF
 
     C                   MULT(H)   DSOFCXRT      PRAM_Fac
 
      ** Convert facility amount to Credit agreement facility using
      ** spot rate for later update of Current exposure
 
     C                   IF        CLE023      = 'Y'
     C                   EVAL      ZRATE1      = DSSPRT_f
     C                   EVAL      ZMDI1       = DSMDIN_f
     C                   EVAL      ZRATE2      = DSSPRT_f2
     C                   EVAL      ZMDI2       = DSMDIN_f2
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
 
     C                   EVAL      ZAMTCI      = WrkPRAMS
     C                   EVAL      ZEXCH       = ZRATEX
     C                   EVAL      ZMD         = ZMDIX
     C                   EVAL      ZCCYI       = DSFCCY_f
     C                   EVAL      ZCCYO       = f_FCCY
     C                   EVAL      ZCDPI       = DSNBDP_f
     C                   EVAL      ZCDPO       = DSNBDP_f2
 
     C                   Callb     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM      0             ZAMTCO
 
     C                   Z-ADD     ZAMTCO        WrkPRAMS
     C                   ENDIF
     C                   ENDIF
 
      ** Update facility exposure and availability
 
     C                   MOVE      'Y'           WTRCA
 
      ** Evaluate Facility Exposure Amount.
 
     C                   EXSR      xeExpAmt
 
      ** Set Last Change Details.
 
     C                   EVAL      f_LCD       = BJRDNB
     C                   EVAL      f_CHTP      = 'A'
     C                   EVAL      f_TNLU      = P@NATN
 
      ** Update Facility Details.
 
     C                   EXSR      xuFCLTYFN
 
     C                   EVAL      WTRCA       = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * xeExpAmt - Evaluate Exposure Amount (Internal Customer).      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     xeExpAmt      BEGSR
 
      ** Convert amounts into facility currency equivalent
 
     C                   IF        WTRCA       = *BLANK
 
     C                   IF        CLE023      = 'Y'           AND
     C                             p_RLDT      < BJRDNB        AND
     C                             p_RLDT     <> *ZERO         AND
     C                             l_NFCE     <> *ZERO         AND
     C                             l_NCCY      = *BLANKS
     C                   Z-ADD     l_NFCE        WFCXR
     C                   MOVE      'Y'           WROFXR
 
     C                   ELSE
     C                   Z-ADD     p_FCXR        WFCXR
     C                   MOVE      'N'           WROFXR
     C                   ENDIF
 
     C     DSNBDP_f      SUB       DSNBDP_p      CX
     C     CX            ADD       4             CX
 
     C     p_FMDI        IFEQ      'D'
     C     WROFXR        ANDEQ     'N'
     C     l_NFMD        OREQ      'D'
     C     WROFXR        ANDEQ     'Y'
     C     WFCXR         MULT(H)   Powr(Cx)      DSOFCXRT
     C     1             DIV       DSOFCXRT      DSOFCXRT
 
     C                   ELSE
     C     WFCXR         MULT(H)   Powr(Cx)      DSOFCXRT
     C                   ENDIF
 
     C     PRAM          MULT(H)   DSOFCXRT      PRAM_Fac
 
      ** Convert amount to facility currency using spot rates
 
     C                   IF        CLE023      = 'Y'
     C                   EVAL      ZMDI1       = DSMDIN_p
     C                   EVAL      ZRATE1      = DSSPRT_p
     C                   EVAL      ZMDI2       = DSMDIN_f
     C                   EVAL      ZRATE2      = DSSPRT_f
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM      0             ZRATEX
     C                   PARM      *BLANKS       ZMDIX
 
     C                   EVAL      ZEXCH       = ZRATEX
     C                   EVAL      ZMD         = ZMDIX
     C                   EVAL      ZAMTCI      = PRAM
     C                   EVAL      ZCCYI       = p_CCY
     C                   EVAL      ZCCYO       = f_FCCY
     C                   EVAL      ZCDPI       = DSNBDP_p
     C                   EVAL      ZCDPO       = DSNBDP_f
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM      0             ZAMTCO
 
     C                   Z-ADD     ZAMTCO        WrkPRAMS
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up fields for availability updating
 
     C                   Z-ADD     p_MDAT        ENDAY                    40
 
     C                   IF        *IN40       = '1'
     C                   Z-ADD     99999         ENDAY
     C                   ENDIF
 
     C                   Z-ADD     p_VDAT        DAYNO
 
     C                   MOVEA     '00'          *IN(41)
 
      ** Similar update for a non-syndicated loan and part purchased,
      ** internal parts purchased and funding participant
 
     C                   IF        f_RVCR      = 'Y'           AND
     C                             DSRVCR      = ' '           OR
 
     C                             f_RVCR      = 'N'           AND
     C                             DSRVCR      = 'Y'           AND
     C                             DSVlDt     <= BJRDNB        OR
 
     C                             DSPart      = 'Y'           AND
     C                             GASS        = 'A'
 
      ** Participation sold
 
     C                   IF        DSLoanType <> 'PTSO'        AND
     C                             p_LPFI      = ' '           OR
     C                             DSPart      = 'Y'
 
     C                   IF        DSActn      = 'I'
     C                   EVAL      *IN41       = *ON
 
     C                   ELSE
     C                   EVAL      *IN42       = *ON
     C                   ENDIF
 
      ** Similar update for a non-syndicated parts sold,
      ** and prime facilities
 
     C                   ELSE
     C                   IF        DSActn       = 'I'
     C                   EVAL      *IN42        = *ON
 
     C                   ELSE
     C                   EVAL      *IN41        =*ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     PRAM_Fac      FCBAL
 
      ** Do not update for parts sold with recourse and
      ** if CLE023 is not installed.  If CLE023 is installed, do not
      ** update for parts sold for non-participant facility with or
      ** without recourse.  Also do not update
      ** Prime facility of a syndicated loan
 
     C                   IF        DSLoanType  = 'PTSO'        AND
     C                             p_RCSI      = 'Y'           AND
     C                             p_LPFI      = ' '           AND
     C                             CLE023      = 'N'           OR
 
     C                             DSLoanType  = 'PTSO'        AND
     C                             p_LPFI      = ' '           AND
     C                             CLE023      = 'Y'           OR
 
     C                             DSPart      = 'N'           AND
     C                             p_LPFI     <> ' '
     C                   MOVEA     '00'          *IN(41)
     C                   ENDIF
 
      ** If customer is branch internal customer, then no update to
      ** facility availability
 
     C                   IF        %LOOKUP(p_CNUM:@BIC) = 0
     C                   EVAL      DSIntnlCus  = 'N'
 
     C                   ELSE
     C                   EVAL      DSIntnlCus  = 'Y'
     C                   ENDIF
 
      ** If Internal customer and Not Linked to Part Facility
      ** Or, if Linked to Part Facility, then loan is an IPP.
 
     C                   IF        DSIntnlCus  = 'Y'           AND
     C                             p_LPFI     <> 'I'           OR
 
     C                             p_LPFI      = 'I'           AND
     C                             DSPart      = 'N'
     C                   EVAL      DSIntnlCus  = 'N'
 
     C                   ELSE
     C                   IF        *IN41       = *ON           OR
     C                             *IN42       = *ON
     C                   IF        DAYNO      <> 0
     C                   EXSR      xeDrwnAmts
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** UPDATE EXPOSURE
 
      ** Internal parts purchased and funding participants are updated
      ** just like any normal loan.  Prime facilities are updated only
      ** when sold without recourse just like a parts sold
      ** Also, since future-dated manual repayments can now be entered,
      ** update exposure only when value date is not in the future
      ** Update CAMD of Prime or normal facility only if loan is not
      ** a parts sold.  If CLE023 is installed, update the exposure
      ** only if normal loan or a funded loan is sold without recourse
 
     C                   IF        p_VDAT     <= BJRDNB
     C                   IF        p_LPFI     <> *BLANK
     C                   IF        DSActn      = 'I'           AND
     C                             DSPart      = 'Y'           OR
 
     C                             DSActn      = 'R'           AND
     C                             DSPart      = 'N'           AND
     C                             p_RCSI     <> 'Y'           AND
     C                             p_LPFI     <> 'I'
 
     C                   IF        DSPart      = 'Y'           AND
     C                             CLE023      = 'Y'           AND
     C                             CLE025      = 'N'           OR
 
     C                             CLE023      = 'N'           AND
     C                             CLE025      = 'N'
 
     C                   EVAL      f_CAMD     -= PRAM_Fac
     C                   ENDIF
 
     C                   IF        CLE023      = 'Y'           AND
     C                             CLE025      = 'N'
     C                   EVAL      f_CEXP     -= WrkPRAMS
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration
      ** Indicator to 'Changed'
 
     C                   IF        CLE009     =  'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DSActn      = 'R'           AND
     C                             DSPart      = 'Y'           OR
 
     C                             DSActn      = 'I'           AND
     C                             DSPart      = 'N'           AND
     C                             p_RCSI      = 'Y'           AND
     C                             p_LPFI      = 'I'
 
     C                   IF        DSPart      = 'Y'           AND
     C                             CLE023      = 'Y'           AND
     C                             CLE025      = 'N'           OR
 
     C                             CLE023      = 'N'           AND
     C                             CLE025      = 'N'
     C                   EVAL      f_CAMD     += PRAM_Fac
     C                   ENDIF
 
     C                   IF        CLE023      = 'Y'           AND
     C                             CLE025      = 'N'
     C                   EVAL      f_CEXP     += WrkPRAMS
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration
      ** Indicator to 'C'hanged
 
     C                   IF        CLE009      = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
     C                   ENDIF
 
      ** Normal, non-syndicated loans
 
     C                   ELSE
     C                   IF        DSLoanType <> 'PTSO'        AND
     C                             DSActn      = 'I'           OR
 
     C                             DSLoanType  = 'PTSO'        AND
     C                             DSActn      = 'R'           AND
     C                             p_RCSI     <> 'Y'
 
     C                   IF        DSLoanType <> 'PTSO'        AND
     C                             CLE023      = 'Y'           AND
     C                             CLE025      = 'N'           OR
 
     C                             CLE023      = 'N'           AND
     C                             CLE025      = 'N'
     C                   EVAL      f_CAMD     -= PRAM_Fac
     C                   ENDIF
 
     C                   IF        CLE023      = 'Y'           AND
     C                             CLE025      = 'N'
     C                   EVAL      f_CEXP     -= WrkPRAMS
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration
      ** Indicator to 'Changed
 
     C                   IF        CLE009      = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DSLoanType <> 'PTSO'        AND
     C                             DSActn      = 'R'           OR
 
     C                             DSLoanType  = 'PTSO'        AND
     C                             DSActn      = 'I'           AND
     C                             p_RCSI     <> 'Y'
 
     C                   IF        DSLoanType <> 'PTSO'        AND
     C                             CLE023      = 'Y'           AND
     C                             CLE025      = 'N'           OR
 
     C                             CLE023      = 'N'           AND
     C                             CLE025      = 'N'
     C                   EVAL      f_CAMD     += PRAM_Fac
     C                   ENDIF
 
     C                   IF        CLE023      = 'Y'           AND
     C                             CLE025      = 'N'
     C                   EVAL      f_CEXP     += WrkPRAMS
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration Indicator
      ** to 'Changed'.
 
     C                   IF        CLE009      = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * xeDrwnAmt - Evaluate Facility Drawn Amount for the            *
      *             Next 10 Days.                                     *
      *                                                               *
      * Called by: xeExpAmt                                           *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      * With Manual Repayment on loans during I/C                     *
      * the availability (i.e. undrawn amount) should be updated      *
      * to reflect the repayment.                                     *
      *                                                               *
      * RUNS,1 = The previous working day                             *
      * ENDAY  = Maturity date of loan                                *
      *                                                               *
      * If Loan is not autosettled, then the O/S principal of that    *
      * loan is included in all elements of the drawn amount array,   *
      * even beyond the maturity date of the loan. So this MR amount  *
      * should update all elements of the array if the loan is        *
      * non-autosettled                                               *
      *****************************************************************
     C     xeDrwnAmts    BEGSR
 
      ** Locate the End Date in Forward Run Days Array.
 
     C                   EVAL      #X          = 1
     C     ENDAY         LOOKUP    RUNS(#X)                           40  40
 
     C                   IF        *IN40       = '0'
     C                   EVAL      #X          = 99
 
     C                   ELSE
     C                   IF        p_AUTO      = 'N'           OR
     C                             ENDAY      <= RUNS(1)
     C                   EVAL      #X          = 99
     C                   ENDIF
     C                   ENDIF
 
      ** Locate Value Date in Forward Run Date Array.
 
     C                   EVAL      #W          = 1
     C     DAYNO         LOOKUP    RUNS(#W)                           40  40
 
      ** If within the next 10 days, adjust each day's Facility Balance.
 
     C                   IF        *IN40       = '1'
     C                   DOW       #W         <= 10            AND
     C                             #W          < #X
 
     C                   IF        CLE025      = 'N'
     C                   IF        *IN41       = '1'
     C                   EVAL      OAM(#W)    -= FCBAL
     C                   ENDIF
 
     C                   IF        *IN42       = '1'
     C                   EVAL      OAM(#W)    += FCBAL
     C                   ENDIF
     C                   ENDIF
 
      ** If CLE009 is installed, set Work Regeneration
      ** Indicator to 'Change'.
 
     C                   IF        CLE009      = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
 
      ** If Increment Index (day).
 
     C                   EVAL      #W         += 1
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * xePCRF - Evaluate PC Transaction Reference                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     xePCRF        BEGSR
 
      ** Retrieve Branch Details.
 
     C                   EVAL      P@BRCA      = p_BRCA
     C                   EXSR      xrBRCH
 
     C                   MOVEL     A8MQSM        W#1ST3
 
 
     C                   CALL      'LEALLO'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      'Y'           PUPDT             1
     C                   PARM      *BLANKS       PCLAST
     C                   PARM      *BLANKS       PCNEXT            8
 
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        WPCRF
     C                   MOVE      '0001'        WPCRF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xeTimestamp - Evaluate Timestamp                              *
      *                                                               *
      * Called by: xsLOAMSDK, xsFCLTY                                 *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xeTimestamp   BEGSR
 
      ** Generate a timestamp.
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    P@TimeStamp
 
     C                   IF        %ERROR
     C                   EVAL      DBPGM       = 'ZAGENTMSTM'
     C                   EVAL      DBFILE      = *BLANKS
     C                   EVAL      DBASE       = 010
     C                   EVAL      DBKEY       = *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xrBRCH - Retrieve Branch Details.                             *
      *                                                               *
      * Called by: xePCRF                                             *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xrBRCH        BEGSR
 
      ** Check Array for Branch.
 
     C                   EVAL      #C          = %LOOKUP(P@BRCA:DSBrCd)
 
     C                   IF        #C          > 0
     C                   EVAL      SDBRCH      = DSBRCD(#C)
 
      ** Otherwise, Retrieve Record.
 
     C                   ELSE
     C                   CALL(E)   'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    P@BRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRTCD      <> *BLANKS       OR
     C                             %ERROR
     C                   EVAL      DBPGM       = 'AOBRCHR1'
     C                   EVAL      DBFILE      = 'SDBRCHPD'
     C                   EVAL      DBASE       = 011
     C                   EVAL      DBKEY       = P@BRCA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #C          = %LOOKUP(' ':DSBrCd)
 
     C                   IF        #C          = 0
     C                   EVAL      DBFILE      = 'SDBRCHPD'
     C                   EVAL      DBKEY       = P@BRCA
     C                   EVAL      DBASE       = 111
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      DSBrCd(#C)  = P@BRCA
     C                   EVAL      DSBRCH(#C)  = SDBRCH
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xrCURR - Retrieve Currency Details.                           *
      *                                                               *
      * Called by: xpPDCR, xsFCLTY, xsFCLTY_CA                        *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xrCURR        BEGSR
 
      ** Check Array for Currency.
 
     C                   EVAL      #C          = %LOOKUP(P@CCY:DSCyCd)
 
     C                   IF        #C          > 0
     C                   EVAL      SDCURR      = DSCURR(#C)
 
      ** Otherwise, Retrieve Record.
 
     C                   ELSE
     C                   CALL(E)   'AOCURRR0'
     C                   PARM      '*BLANK  '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    P@CCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD      <> *BLANKS       OR
     C                             %ERROR
     C                   EVAL      DBPGM       = 'AOCURRR0'
     C                   EVAL      DBFILE      = 'SDCURRPD'
     C                   EVAL      DBASE       = 012
     C                   EVAL      DBKEY       = P@CCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #C          = %LOOKUP(' ':DSCyCd)
 
     C                   IF        #C          = 0
     C                   EVAL      DBFILE      = 'SDCURRPD'
     C                   EVAL      DBKEY       = P@CCY
     C                   EVAL      DBASE       = 112
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      DSCyCd(#C)  = P@CCY
     C                   EVAL      DSCURR(#C)  = SDCURR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xrLOAN - Retrieve Loan Type Details.                          *
      *                                                               *
      * Called by: *None                                              *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xrLOAN        BEGSR
 
      ** Initialisation.
 
     C                   EVAL      P@LtSt = P@LTYP  + P@SUTP  + P@CLAS
 
      ** Check Array for Loan Type.
 
     C                   EVAL      #C = %LOOKUP(P@LtSt:DSLtSt)
 
     C                   IF        #C          > 0
     C                   EVAL      SDLOAN      = DSLOAN(#C)
 
      ** Otherwise, Retrieve Record.
 
     C                   ELSE
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    P@LTYP
     C                   PARM                    P@SUTP
     C                   PARM                    P@CLAS
     C     SDLOAN        PARM      SDLOAN        DSFDY
 
     C                   IF        @RTCD      <> *BLANKS
     C                   EVAL      DBFILE      = 'SDLOANPD'
     C                   EVAL      DBKEY = P@LTYP  + P@SUTP  + P@CLAS
     C                   EVAL      DBASE       = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #C          = %LOOKUP(' ':DSLtSt)
 
     C                   IF        #C          = 0
     C                   EVAL      DBFILE      = 'SDLOANPD'
     C                   EVAL      DBKEY       = P@LtSt
     C                   EVAL      DBASE       = 112
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      DSLtSt(#C)  = P@LtSt
     C                   EVAL      DSLOAN(#C)  = SDLOAN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xrNOST -  Retrieve Nostro Details.                            *
      *                                                               *
      * Called by: xpPDCR                                             *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xrNOST        BEGSR
 
      ** Initialisation.
 
     C                   EVAL      P@NOST      = KCCY + KNONB
 
      ** Check Array for Nostro.
 
     C                   EVAL      #C = %LOOKUP(P@NOST:DSNoCd)
 
     C                   IF        #C          > 0
     C                   EVAL      SDNOST      = DSNOST(#C)
 
      ** Otherwise, Retrieve Record.
 
     C                   ELSE
     C                   CALL      'AONOSTR0'
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
 
     C                   IF        PRTCD      <> *BLANKS       OR
     C                             %ERROR
     C                   EVAL      DBPGM       = 'AONOSTR0'
     C                   EVAL      DBFILE      = 'SDNOSTPD'
     C                   EVAL      DBASE       = 025
     C                   EVAL      DBKEY       = P@NOST
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #C = %LOOKUP(' ':DSNoCd)
 
     C                   IF        #C          = 0
     C                   EVAL      DBFILE      = 'SDNOSTPD'
     C                   EVAL      DBKEY       = P@NOST
     C                   EVAL      DBASE       = 125
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      DSNoCd(#C)  = P@NOST
     C                   EVAL      DSNOST(#C)  = SDNOST
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xsLOAMSZ1 - Set Loan Amendments Trailer File .                *
      *                                                               *
      * Called by: xpPDCR                                             *
      *                                                               *
      * Calls: *PSSR, GLZADD                                          *
      *                                                               *
      *****************************************************************
     C     xsLOAMSZ1     BEGSR
 
      ** Retrieve Trailer Records.
 
     C                   EVAL       KLNRF      = '999999'
     C                   EVAL       KVDAT      = 99999
     C                   EVAL       KLASN      = 999
     C     KLOAMS        CHAIN(E)  LOAMS
 
     C                   IF        NOT %FOUND(LOAMS)
     C                   EVAL      DBFILE      = 'LOAMS'
     C                   EVAL      DBASE       = 014
     C                   EVAL      DBKEY       = '999999'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Increment Counts & Set Hash Totals.
 
     C                   SELECT
     C                   WHEN      DSACTN      = 'I'
     C**********         EVAL      NORE       += 1                                          MD023287
     C**********         EVAL      NINS       += 1                                          MD023287
     C**********         EVAL      NLRA       += 1                                          MD023287
     C                   ADD       1             NORE                                       MD023287
     C                   ADD       1             NINS                                       MD023287
     C                   ADD       1             NLRA                                       MD023287
 
     C**********         EVAL      ZZTOTI      = VRIF                                       MD023287
     C**********         EVAL      ZZTOTD      = VRIL                                       MD023287
     C                   Z-ADD     VRIF          ZZTOTI                                     MD023287
     C                   Z-ADD     VRIL          ZZTOTD                                     MD023287
     C                   EXSR      GLZADD
     C**********         EVAL      VRIF        = ZZTOTI                                     MD023287
     C**********         EVAL      VRIL        = ZZTOTD                                     MD023287
     C                   Z-ADD     ZZTOTI        VRIF                                       MD023287
     C                   Z-ADD     ZZTOTD        VRIL                                       MD023287
 
     C**********         EVAL      ZZTOTI      = VRRF                                       MD023287
     C**********         EVAL      ZZTOTD      = VRRL                                       MD023287
     C                   Z-ADD     VRRF          ZZTOTI                                     MD023287
     C                   Z-ADD     VRRL          ZZTOTD                                     MD023287
 
     C                   WHEN      DSACTN      = 'R'
     C**********         EVAL      NDEL       += 1                                          MD023287
     C**********         EVAL      NLRA       -= 1                                          MD023287
     C                   ADD       1             NDEL                                       MD023287
     C                   SUB       1             NLRA                                       MD023287
 
     C**********         EVAL      ZZTOTI      = VRDF                                       MD023287
     C**********         EVAL      ZZTOTD      = VRDL                                       MD023287
     C                   Z-ADD     VRDF          ZZTOTI                                     MD023287
     C                   Z-ADD     VRDL          ZZTOTD                                     MD023287
     C                   ENDSL
 
     C**********         EVAL      ZZAMT       = TAMT / 1000                                MD023287
     C     TAMT          DIV       1000          ZZAMT                                      MD023287
 
     C                   IF        ZZAMT       < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
      ** Adjust Hash Total by Value of Records after Insert/Reversal.
 
     C                   EXSR      GLZADD
 
      ** Set Appropiate Hash Total Fields.
 
     C                   SELECT
     C                   WHEN      DSACTN      = 'I'
     C**********         EVAL      VRRF        = ZZTOTI                                     MD023287
     C**********         EVAL      VRRL        = ZZTOTD                                     MD023287
     C                   Z-ADD     ZZTOTI        VRRF                                       MD023287
     C                   Z-ADD     ZZTOTD        VRRL                                       MD023287
 
     C                   WHEN      DSACTN      = 'R'
     C**********         EVAL      VRDF        = ZZTOTI                                     MD023287
     C**********         EVAL      VRDL        = ZZTOTD                                     MD023287
     C                   Z-ADD     ZZTOTI        VRDF                                       MD023287
     C                   Z-ADD     ZZTOTD        VRDL                                       MD023287
     C                   ENDSL
 
      ** Set Last Change Details.
 
     C                   EVAL      LCD         = BJRDNB
     C                   EVAL      CHTP        = 'A'
 
      ** Set Transaction Number of Last Update.
 
     C                   EVAL      TNLU        = P@NATN
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xsLELOMZ - Set Loan Amendments Trailer File .                 *
      *                                                               *
      * Called by: xpPDCR                                             *
      *                                                               *
      * Calls: *PSSR, GLZADD                                          *
      *                                                               *
      *****************************************************************
     C     xsLELOMZ      BEGSR
 
      ** Retrieve Trailer Records.
 
     C                   EVAL       KLNRF      = '999999'
     C                   EVAL       KVDAT      = 99999
     C                   EVAL       KLASN      = 999
     C     KLOMKL3       CHAIN(E)  LELOMKL3
 
     C                   IF        NOT %FOUND(LELOMKL3)
     C                   EVAL      DBFILE      = 'LELOMKL3'
     C                   EVAL      DBASE       = 013
     C                   EVAL      DBKEY       = '999999'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Increment Counts & Set Hash Totals.
 
     C                   SELECT
     C                   WHEN      DSACTN      = 'I'
     C**********         EVAL      NORE       += 1                                          MD023287
     C**********         EVAL      NINS       += 1                                          MD023287
     C**********         EVAL      NLRA       += 1                                          MD023287
     C                   ADD       1             NORE                                       MD023287
     C                   ADD       1             NINS                                       MD023287
     C                   ADD       1             NLRA                                       MD023287
 
     C**********         EVAL      ZZTOTI      = VRRF                                       MD023287
     C**********         EVAL      ZZTOTD      = VRRL                                       MD023287
     C                   Z-ADD     VRRF          ZZTOTI                                     MD023287
     C                   Z-ADD     VRRL          ZZTOTD                                     MD023287
 
     C                   WHEN      DSACTN      = 'R'
     C**********         EVAL      NDEL       += 1                                          MD023287
     C**********         EVAL      NLRA       -= 1                                          MD023287
     C                   ADD       1             NDEL                                       MD023287
     C                   SUB       1             NLRA                                       MD023287
 
     C**********         EVAL      ZZTOTI      = VRDF                                       MD023287
     C**********         EVAL      ZZTOTD      = VRDL                                       MD023287
     C                   Z-ADD     VRDF          ZZTOTI                                     MD023287
     C                   Z-ADD     VRDL          ZZTOTD                                     MD023287
     C                   ENDSL
 
     C**********         EVAL      ZZAMT       = TAMT / 1000                                MD023287
     C     TAMT          DIV       1000          ZZAMT                                      MD023287
 
     C                   IF        ZZAMT       < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
 
      ** Adjust Hash Total by Value of Records after Insert/Reversal.
 
     C                   EXSR      GLZADD
 
      ** Set Appropiate Hash Total Fields.
 
     C                   SELECT
     C                   WHEN      DSACTN      = 'I'
     C**********         EVAL      VRRF        = ZZTOTI                                     MD023287
     C**********         EVAL      VRRL        = ZZTOTD                                     MD023287
     C                   Z-ADD     ZZTOTI        VRRF                                       MD023287
     C                   Z-ADD     ZZTOTD        VRRL                                       MD023287
 
     C                   WHEN      DSACTN      = 'R'
     C**********         EVAL      VRDF        = ZZTOTI                                     MD023287
     C**********         EVAL      VRDL        = ZZTOTD                                     MD023287
     C                   Z-ADD     ZZTOTI        VRDF                                       MD023287
     C                   Z-ADD     ZZTOTD        VRDL                                       MD023287
     C                   ENDSL
 
      ** Set Last Change Details.
 
     C                   EVAL      LCD         = BJRDNB
     C                   EVAL      CHTP        = 'A'
 
      ** Set Transaction Number of Last Update.
 
     C                   EVAL      TNLU        = P@NATN
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * GLZADD - Subroutine to Add an Amount to the Hash Total.       *
      *                                                               *
      * Called by: xsLOAMSZ1, xsLELOMZ                                *
      *                                                               *
      * Calls: GLZSUM                                                 *
      *                                                               *
      *****************************************************************
     C     GLZADD        BEGSR
 
      ** Split Input Amount (ZZAMT) into Integer and Decimal.
 
     C                   IF        ZZAMT      <> 0
     C                   Z-ADD     ZZAMT         ZZAMT
 
     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
 
     C                   EXSR      GLZSUM
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUM - Subroutine to carry out the additon for subroutine   *
      *                                                               *
      * Called by: GLZADD                                             *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     GLZSUM        BEGSR
 
      ** Initialisation.
 
     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
 
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
 
      ** Determine sign of ZZAMTI & D, 92 if negative
 
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
 
      ** Determine sign of ZZTOTI & D, 91 if negative
 
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
 
      ** If ZZTOTAL is zero, return ZZAMOUNT
 
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND
 
      ** If signs differ bypass overflow checks
 
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
 
      ** If the modulus of ZZWK3 is less than the one of ZZTOTI
      ** then an overflow has occurred
 
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
 
      ** If overflow zeroise ZZAMT, set 99 on and let ZZTOT
      ** fields intact
 
     C   99              Z-ADD     0             ZZAMT
     C                   GOTO      ZZSEND
 
      ** The 'signs' are different
 
     C     ZZOFPS        TAG
 
      ** If ZZAMT was negative, make it positive to compare with ZZTOT
 
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
 
      ** If ZZTOT was negative, make it positive to compare with ZZAMT
 
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Both ZZAMT and ZZTOT are now positive
 
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
 
      ** If ZZTOT equals ZZAMT return zero
 
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
 
      ** If ZZTOT greater than ZZAMT
 
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
 
      ** If ZZAMT greater than ZZTOT
 
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
 
      ** If ZZTOTD is zero, and ZZTOTI is negative set up ZZNEGD
 
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xuFCLTYFN - Update Facility Details - B Record.               *
      *                                                               *
      * Called by: xsFCLTY, xsFCLTY_CA                                *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xuFCLTYFN     BEGSR
 
      ** Update Record.
 
     C                   UPDATE(E) FCLTYFNF
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'FCLTYFN'
     C                   EVAL      DBASE       = 016
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                                     %CHAR(Kf_FCNO) + Kf_RCTP
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xuLOAMSZ1 - Update Loan Amendment Trailer Record.             *
      *                                                               *
      * Called by: xpPDCR                                             *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xuLOAMSZ1     BEGSR
 
      ** Update Record.
 
     C                   UPDATE(E) LOAMSZF
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LOAMSZ1'
     C                   EVAL      DBASE       = 017
     C                   EVAL      DBKEY = KLNRF +
     C                                     %CHAR(KVDAT) +
     C                                     %CHAR(KLASN)
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * xuLELOMZ - Update Loan Amendment Trailer Record.              *
      *                                                               *
      * Called by: xpPDCR                                             *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xuLELOMZ      BEGSR
 
      ** Update Record.
 
     C                   UPDATE(E) LELOMZF
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LELOMZPD'
     C                   EVAL      DBASE       = 018
     C                   EVAL      DBKEY = KLNRF +
     C                                     %CHAR(KVDAT) +
     C                                     %CHAR(KLASN)
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * XwLOAMSDK - Write Loan Amendment Detail Record.               *
      *                                                               *
      * Called by: xpPDCR                                             *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xwLOAMSDK     BEGSR
 
      ** Write Record.
 
     C                   WRITE(E)  LOAMSDKF
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LOAMSDKS'
     C                   EVAL      DBASE       = 019
     C                   EVAL      DBKEY = LNRF + %CHAR(VDAT) +
     C                                     %CHAR(LASN)
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * XwLOMK - Write Loan Amendment Detail Record.                  *
      *                                                               *
      * Called by: xpPDCR                                             *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     xwLOMK        BEGSR
 
      ** Write Record.
 
     C                   WRITE(E)  LELOMKF
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LELOMKPD'
     C                   EVAL      DBASE       = 020
     C                   EVAL      DBKEY = LNRF + %CHAR(VDAT) +
     C                                     %CHAR(LASN)
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KLEACT        CHAIN(E)  CLOANE                             90
     C                   IF        *IN90 = '1'
     C                   EVAL      CPAM = P_CPAM
     C                   EVAL      RCDT = 'A'
     C                   WRITE     LELWNED0
     C                   ENDIF
      ** Access trailer record
     C                   MOVE      'Z'           WEPAR
     C                   MOVE      '999999'      WALON
     C                   MOVE      '999999Z'     WLTRL             7
     C     WKLON         CHAIN     CLOANE                             89
      ** Insert trailer record for LELWNEZ1
     C     *IN89         IFEQ      '1'
     C                   CLEAR                   LELWNEZ0
     C                   MOVE      'T'           RECI
     C                   MOVE      '999999'      LNRF
     C                   MOVE      'Z'           RCDT
     C                   Z-ADD     1             NORE
     C                   Z-ADD     1             NINS
     C                   Z-ADD     1             NLRA
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   Z-ADD     1             TNLU
     C                   WRITE     LELWNEZ0
      ** Set pointer to the new record for update
     C     WKLON         CHAIN     CLOANE                             89
     C                   ENDIF
      ** Check the original loan again, for updating of trailer
     C                   IF        *IN90 = '1'
      ***  Set up amount fields for insert
     C     P_CPAM        DIV       1000          ZZAMT            15 3
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
     C     CPAM          DIV       1000          ZZAMT
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
      *
     C                   ADD       1             NORE
     C                   ADD       1             NINS
     C                   ADD       1             NLRA
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   Z-ADD     1             TNLU
     C                   UPDATE    LELWNEZ0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Initialisation Rountine.                             *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialisation.
 
     C                   EVAL      DBPGM       = 'LE000457'
 
      ** Determine if 'Lending Enhancements - Tranche 3' is Active.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      CLE005      = 'Y'
     C                   ENDIF
 
      ** Determine if 'Lending Input Cycle Fees' is Active.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      CLE009      = 'Y'
     C                   ENDIF
 
      ** Determine if 'Customer Driven Enhancements' is Active.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      CLE014      = 'Y'
     C                   ENDIF
 
      ** Determine if 'Facility History Improvements' is Active.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      CLE023      = 'Y'
     C                   ENDIF
 
      ** Determine if 'Credit Lines' is Active.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE025'      @SARD
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      CLE025      = 'Y'
     C                   ENDIF
 
      ** Determine if 'Flat Rate Personal Loans (Rule of 78ths)'
      ** is Active.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE028'      @SARD
 
     C                   IF        @RTCD       = *BLANKS
     C                   EVAL      CLE028      = 'Y'
     C                   ENDIF
 
      ** Determine if 'Freq Fee & Allocation, Sett Ccy, Roll Utilisation'                   MD046080
      ** is Active.                                                                         MD046080
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
      ** Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD      <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'SDBANKPD'
     C                   EVAL      DBKEY       = '*FIRST'
     C                   EVAL      DBASE       = 021
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Branch Details (Store Internal Customer).
 
     C     *LOVAL        SETLL     SDBRCHL5
     C                   READ(E)   SDBRCHL5
 
     C                   IF        %EOF(SDBRCHL5)              OR
     C                             %ERROR
     c     *LOCK         IN        LDA
     C                   EVAL      DBFILE      = 'SDBRCHL5'
     C                   EVAL      DBKEY       = '*FIRST'
     C                   EVAL      DBASE       = 022
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   DOU       %EOF(SDBRCHL5)
     C                   EVAL      #A         += 1
     C                   EVAL      @BIC(#A)    = A8BICN
     C                   READ(E)   SDBRCHL5
     C                   ENDDO
 
      ** if File is empty, add trailer record
      ** Retrieve Trailer Records.
 
     C                   CLEAR                   LELOMZF
     C                   EVAL       KLNRF      = '999999'
     C                   EVAL       KVDAT      = 99999
     C                   EVAL       KLASN      = 999
     C     KLOMKL3       CHAIN(E)  LELOMKL3
 
     C                   IF        NOT %FOUND(LELOMKL3)
     C                   EVAL       LNRF       = '999999'
     C                   EVAL       VDAT       = 99999
     C                   EVAL       LASN       = 999
     C                   EVAL       RECI       = 'T'
     C                   EVAL       NORE       = 1
     C                   WRITE(E)  LELOMZF
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE      = 'LELOMZPD'
     C                   EVAL      DBASE       = 023
     C                   EVAL      DBKEY       = KLNRF +
     C                                           %CHAR(KVDAT) +
     C                                           %CHAR(KLASN)
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/SPACE
      *****************************************************************
      * SrintOut - Outstanding Interest                               *
      *                                                               *
      * Called by: *None                                              *
      *                                                               *
      * Calls: GLINTC                                                 *
      *                                                               *
      *****************************************************************
     C     SrIntOut      BEGSR
     C                   Z-ADD     0             WrkOutInt
 
      ** set End date
 
     C                   IF        P_Vdat > BJRDNB  AND CLE005 = 'Y'
     C                   EVAL      ZIEND = P_Vdat
     C                   ELSE
     C                   EVAL      ZIEND = bjrdnb
     C                   ENDIF
 
     C                   IF        P_Mdat <> 0 AND P_Mdat < Bjrdnb
     C                   EVAL      ZIEND = P_Mdat
     C                   ENDIF
 
      ** Start Date
 
     C                   EVAL      ZIBEG = P_Iacd
 
      ** Add 1 to End date depending on ADDI indicator
 
     C                   IF        ((P_Addi = 'B') OR (P_Addi = 'L')) AND
     C                             ZIEND = P_Mdat AND P_Ored < P_Mdat
     C                   EVAL      ZIEND = ZIEND + 1
     C                   ENDIF
 
      ** Add 1 to End date if Original Entry date is
      ** after maturity date
 
     C                   IF        ((P_Addi = 'B') OR (P_Addi = 'L')) AND
     C                             P_Ored >= P_Mdat
     C                   EVAL      ZIEND = ZIEND + 1
     C                   ENDIF
 
      ** set parameters required for interest calculation
 
     C                   EVAL      ZICALC = P_ICBS
     C                   EVAL      ZIRATE = P_INTR
     C                   EVAL      ZIAMT  = P_CPAM
     C                   EXSR      GLINTC
 
      ** Round Interest depending on RDFC indicator
 
     C                   IF        P_RDFC = 'Y'
     C                   Z-ADD     ZINTR         WkRound
     C                   Z-ADD     WkRound       ZINTR
     C                   ENDIF
 
      ** Calculate Interest Outstanding
 
     C                   EVAL      WrkOutInt = ZINTR + P_AITC +
     C                             P_AIAP + P_AIMN -
     C                             P_IPRD - P_ICTD - P_IWOD
 
     C                   ENDSR

      *****************************************************************                     MD046080
     C/EJECT                                                                                MD046080
      *****************************************************************                     MD046080
      *    SRCvtAmt - Convert Amount                                  *                     MD046080
      *****************************************************************                     MD046080
     C     SRCvtAmt      BEGSR                                                              MD046080
                                                                                            MD046080
     C                   IF        PTYP <> 66                                               MD046080
     C                             AND PTYP <> 67                                           MD046080
     C                             AND PTYP <> 69                                           MD046080
     C                             AND PTYP <> 72                                           MD046080
     C                   EVAL      WCCY1 = p_PSCY                                           MD046080
     C                   EVAL      WRATE = p_PEXR                                           MD046080
     C                   EVAL      WIND1 = p_PEXI                                           MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WCCY1 = p_SCCY                                           MD046080
     C                   EVAL      WRATE = p_REXR                                           MD046080
     C                   EVAL      WIND1 = p_REXI                                           MD046080
     C                   ENDIF                                                              MD046080
     C                   EVAL      WCCY2 = CCY                                              MD046080
     C                   IF        WIND1 = 'M'                                              MD046080
     C                   EVAL      WMDIN = 'D'                                              MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WMDIN = 'M'                                              MD046080
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
      ** If one of currencies is blank, no conversrsion                                     MD046080
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
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   ENDSR                                                              MD046080
                                                                                            MD046080
      *****************************************************************
     C/SPACE
      *****************************************************************
      * GLINTC - Calculate Interest on period                         *
      *                                                               *
      * Called by: SrIntOut                                           *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     GLINTC        BEGSR
 
     C                   CALLB     'GLINTC'
     C                   PARM                    ZIBEG
     C                   PARM                    ZIEND
     C                   PARM                    ZICALC
     C                   PARM                    ZIAMT
     C                   PARM                    ZIRATE
     C                   PARM                    ZINTR
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/SPACE
      *****************************************************************
      * @DEFN - Definition Rountine.                                  *
      *****************************************************************
     C     @DEFN         BEGSR
 
      ** Entry List...
      ** Key List...
 
     C     KLEACT        KLIST
     C                   KFLD                    k_SELNRF
 
     C     KACCNTL1      KLIST
     C                   KFLD                    KacACNO
 
     C     KCLOAN        KLIST
     C                   KFLD                    Kl_LNRF
     C                   KFLD                    Kl_RCDT
 
     C     KFCAM         KLIST
     C                   KFLD                    Ki_CNUM
     C                   KFLD                    Ki_FACT
     C                   KFLD                    Ki_FCNO
 
     C     KFCLTY        KLIST
     C                   KFLD                    Kf_CNUM
     C                   KFLD                    Kf_FACT
     C                   KFLD                    Kf_FCNO
     C                   KFLD                    Kf_RCTP
 
     C     KLELOAML3     KLIST
     C                   KFLD                    Ka_LNRF
     C                   KFLD                    Ka_VDAT
 
     C     KLOMKL3       KLIST
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KLASN
 
     C     KLOAMS        KLIST
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KLASN
 
     C     WKLON         KLIST
     C                   KFLD                    WALON             6
     C                   KFLD                    WEPAR             1
 
      ** Parameter List...
 
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
 
      ** Dataareas...
 
     C     *DTAARA       DEFINE                  LEALLO
 
     C                   ENDSR
     C/COPY ZACPYSRC,PSSR_ILEB
     C/EJECT
**  POWR -- USED IN CURRENCY CONVERSION(FACILITY)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
