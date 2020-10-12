     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Repayments - process LEREMRPD')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE007056 - Process LEREMRPD records                          *
      *                                                               *
      *  Function: This program will process MR/RE records inserted   *
      *            on I/C against Past Due Call Loans. If available   *
      *            amount is enough to cover the whole payment an     *
      *            equivalent MR/RE will be output to LOAMSDK or if   *
      *            partial, only the maximum available amount will be *
      *            payed. Records with debit or 0 SEAAMT will be      *
      *            ignored. (This is based on LE0457)                 *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD055146           Date 04Feb20               *
      *                 CER050             Date 16Jun19               *
      *                 MD051900           Date 19Sep18               *
      *                 MD049363           Date 19Sep18               *
      *                 CLE071             Date 18Jul18               *
      *                 MD049745A          Date 16Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD046080           Date 17Sep17               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE164             Date 18Aug14               *
      *                 MD020966           Date 20Jun13               *
      *                 AR815697           Date 05Jun13               *
      *                 AR786878 *CREATE   Date 05Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD055146 - Failed MXC004802 seq. 00001 and others            *
      *             Increase Branches to 900.                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD051900 - Adjustment on MAPY from rounded up settlement     *
      *             amount                                            *
      *  MD049363 - Percentage allocation error                       *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD049745A - Corruption of Original currency of Loans and     *
      *              PDCLs incorrect postings                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046080 - Gap between CLE031 (Settlement to different       *
      *             currency) and CLE134 (PDCL processing)            *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  MD020966 - Payments for Past due loans are posted twice      *
      *  AR815697 - New processing for maturity events of PDCL's.     *
      *             (Child: AR815698)                                 *
      *  AR786878 - New processing for manual repayment and           *
      *             repayment schedule for PDCL's. (Child: AR786879)  *
      *                                                               *
      *****************************************************************

      ** Midas GL Account details - retail key
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(ac)

      ** Midas LE Loans File
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(l_)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
                                                                                            AR815697
     FCLOANLB   UF   E           K DISK    INFSR(*PSSR)                                     AR815697
     F                                     RENAME(CLOANCLF:CLOANBF)                         AR815697
     F                                     PREFIX(z_)                                       AR815697

      ** Midas LE Facility amendment retrieval index
     FLEFCAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCAMPF:LEFCAMD3)
     F                                     PREFIX(i_)

      ** Midas LE Loan Amendments file
    ?FLELOAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LOAMSF)
     F                                     PREFIX(a_)

      ** Midas SD Branch codes by customer number
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)

      ** Midas LE Past Due & Original Loan Link
     FLEPDUEL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas LE Past Due & Original Fees Link
     FLEPDUFL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas LE Customer lending facility file
     FFCLTY     UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     IGNORE(FCLTYHHF) IGNORE(FCLTYZZF)
     F                                     PREFIX(f_)

      ** Midas LE Loans File
     F***LEPDCRL2  UF   E           K DISK    INFSR(*PSSR)                                  MD020966
     F**********                           COMMIT                                           MD020966
     F**********                           RENAME(CLOANCLF:LEPDCRF)                         MD020966
     F**********                           PREFIX(p_)                                       MD020966
     FCLOANLD   IF   E           K DISK    INFSR(*PSSR)                                     MD020966
     F                                     PREFIX(p_)                                       MD020966

      ** Midas LE MR and RE extract file for PDCLs.
     FLEREMRPD  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(K_)

      ** Midas LE Loan Amendments file
     FLELOMKL3  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSDKF)
     F                                     RENAME(LOAMSZ1F:LELOMZF)

      ** Midas LE Loan Amendments
     FLOAMS     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSDKF)
     F                                     RENAME(LOAMSZ1F:LOAMSZF)
                                                                                            MD046080
      ** Settlement Allocation by RONS                                                      MD046080
     FLESTALLG  IF   E           K DISK    INFSR(*PSSR)                                     MD046080
     F                                     PREFIX(G_)                                       MD046080
      ** Settlement Allocation by PONS                                                      MD046080
     FLESTALLH  IF   E           K DISK    INFSR(*PSSR)                                     MD046080
     F                                     RENAME(LESTALD0:LESTALD1)                        MD046080
     F                                     PREFIX(H_)                                       MD046080

      ** Midas LE Loan Amendments Detail
     FLELOMKPD  O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(LOAMSDKF:LELOMKF)

      ** Midas LE Loan Amendments File
     FLOAMSDK   O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      ** Key Fields.

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
     D P@CCY           S              3
     D P@CLAS          S              4
     D P@CNUM          S              6
     D P@LnRf          S              6A
     D P@LtSt          S              8
     D P@LTYP          S              2
     D P@Nost          S              5
     D P@Post          S              1
     D P@SCcy          S              3
     D P@SUTP          S              2

     D P@RTCD          S             10
     D P@BLAF          S             15P 0

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
     D  p_LPFI
     D  p_PTFC
     D  p_PTFT
     D  p_PTFN

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

      ** DS for calculating PC reference.

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Bank Details.

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** Branch Details.

     D SDCLND        E DS                  EXTNAME(SDCLNDPD)

      ** ICD Details.

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Currency Details.

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)

      ** Nostro details

      ** Variables for Saving Values.

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

     D***DSBRCH*         S                   INZ DIM(500) LIKE(SDBRCH)                      MD055146
     D***DSBrCd*         S                   INZ DIM(500) LIKE(A8BRCD)                      MD055146
     D DSBRCH          S                   INZ DIM(999) LIKE(SDBRCH)                        MD055146
     D DSBrCd          S                   INZ DIM(999) LIKE(A8BRCD)                        MD055146

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

     D KCNUM           S              6
     D KCCY            S              3
     D KEYC1           S             10
     D KEYD            S              2
     D KNONB           S              2
     D KEYF            S              3
     D KEYG            S             10
     D KEYH            S              1

     D ZAMTCI          S             15  0
     D ZEXCH           S             13  8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

     D ZZNEGD          S              5
     D ZZWK3           S             15  0
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZAMT           S             15  3
     D ZZWK2           S              4  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D PRTCD           S              7
     D POPTN           S              7

     D FCBAL           S             13  0
     D ENDAY           S              5  0
     D DAYNO           S              5  0

     D ZRATE1          S             13  8
     D ZMDI1           S              1
     D ZRATE2          S             13  8
     D ZMDI2           S              1
     D ZRATEX          S             13  8
     D ZMDIX           S              1

     D WPCRF           S             15
     D W1ST11          S             11
     D PCNEXT          S              8
     D W#1ST3          S              3
     D PUPDT           S              1
     D WKSWRI          S              1
     D WrkPRAMS        S             13  0
     D PRAM_Fac        S             13  0
     D CX              S              1  0

     D WROFXR          S              1
     D WFCXR           S             13  8
     D WTRCA           S              1
     D P@NATN          S              5  0
     D WSkip           S              1
     D Pdclt           S              1
     D ConvertFlag     S              1N   INZ(*OFF)                                        MD051900

     D                 DS

      ** Working DS with Amounts

     D  PRAMR                  1     13  0
     D  INTAR                 14     26  0
     D  PNAMR                 27     39  0
     D  TAMTR                 40     52  0
     D  WTXAR                 53     65  0
     D SAMT                    1     65

      ** Loan Amendment Current Amount in numeric (on Valid format LOAMSDKF)

     D  OPRAM                 66     78  0
     D  OINTA                 79     91  0
     D  OPNAM                 92    104  0
     D  OTAMT                105    117  0
     D  OWTXA                118    130  0
     D OAMT                   66    130

     D DSACTN          S              1    INZ('I')
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
     D CLE031          S              1A                                                    MD046080
     D WIND1           S              1A                                                    MD046080
     D WSET            S             18A                                                    MD046080
     D WWCCY           S              3A                                                    MD046080
     D CLE034          S              1A                                                    MD046080
     D K1VDAT          S              5P 0                                                  MD049363
     D K1LASN          S              3S 0                                                  MD049363

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

      ** Main Processing Control.

      ** Retrieve & Process Past Due Call Loan Details.

     C                   READ(E)   LEREMRPD
     C                   DOW       NOT %EOF(LEREMRPD)

     C*****KLEACT        CHAIN(E)  LEPDCRL2                                                MD020966
     C     KLEACT        CHAIN(E)  CLOANLD                                                 MD020966

     C**********         IF        %FOUND(LEPDCRL2)                                        MD020966
     C                   IF        %FOUND(CLOANLD)                                         MD020966
     C                   EXSR      SRPDCL

     C                   IF        WSkip <> 'Y'
     C                   EXSR      XPPDCR
     C                   ENDIF
     C                   ENDIF
                                                                                            AR815697
      ** Set PDCL maturity date here back to zero.                                          AR815697
      ** LEC007051 will decide if PDCL should mature.                                       AR815697
                                                                                            AR815697
     C                   IF        k_AMTP = 'MA'                                            AR815697
                                                                                            AR815697
     C     KCLONB        CHAIN     CLOANLB                                                  AR815697
     C                   IF        %FOUND(CLOANLB)                                          AR815697
     C                   IF        z_MDAT > 0                                               AR815697
     C                   Z-ADD     0             z_MDAT                                     AR815697
     C                   UPDATE    CLOANBF                                                  AR815697
     C                   ENDIF                                                              AR815697
     C                   ENDIF                                                              AR815697
     C                   ENDIF                                                              AR815697

      ** Update flag on LEREMRPD to 'processed'.

     C                   EVAL      k_SEIPFL = 'P'
     C                   UPDATE    LEREMRD0

      ** Commit changes.

     C                   COMMIT(E)
     C                   READ(E)   LEREMRPD
     C                   ENDDO

      ** Terminate Program.

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XPPDCR - Process Past Due Call Loan Details.                 *
      *                                                               *
      *****************************************************************
     C     XPPDCR        BEGSR

      ** Retrieve Customer Loan 'B' Record Details.

     C                   EVAL      Kl_LNRF = p_LNRF
     C                   EVAL      Kl_RCDT = 'B'
     C     KCLOAN        CHAIN(E)  CLOAN

      ** Determine the Settlement Account.

     C                   EVAL      P@CNUM = *BLANKS
     C                   EVAL      P@ACOD = 0
     C                   EVAL      P@ACSQ = 0
     C                   EVAL      P@BRCA = *BLANKS
     C                   EVAL      P@ACCY = *BLANKS

     C                   EVAL      P@LNRF = p_LNRF

      ** Set Loan Type.

     C                   SELECT
     C                   WHEN      p_PTYP = 61 OR
     C                             p_PTYP = 62 OR
     C                             p_PTYP = 63 OR
     C                             p_PTYP = 70 OR
     C                             p_PTYP = 80 AND
     C                             CLE028 = 'Y'

     C                   EVAL      DSLoanType = 'LOAN'

     C                   WHEN      p_PTYP = 64 OR
     C                             p_PTYP = 65 OR
     C                             p_PTYP = 68 OR
     C                             p_PTYP = 71

     C                   EVAL      DSLoanType = 'PTPU'

     C                   WHEN      p_PTYP = 66 OR
     C                             p_PTYP = 67 OR
     C                             p_PTYP = 69 OR
     C                             p_PTYP = 72

     C                   EVAL      DSLoanType = 'PTSO'

     C                   OTHER

     C                   EVAL      DSLoanType = 'UNKN'
     C                   ENDSL

      ** Set Settlement Account from Payable.

     C                   IF        p_PTYP = 66 OR p_PTYP = 72

     C                   SELECT
     C                   WHEN      p_PSTM = 01 OR p_PSTM = 08

     C                   EVAL      KCCY = p_CCY
     C                   EVAL      KNONB = %SUBST(p_PONS:01:02)
     C                   EVAL      KCNUM = *BLANKS
     C                   EXSR      XRNOST

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      P@CNUM = A7CUST
     C                   EVAL      P@ACOD = %DEC(A7ACCD:10:0)
     C                   EVAL      P@ACSQ = A7ACSN
     C                   EVAL      P@BRCA = A7BRCD
     C                   EVAL      P@ACCY = p_CCY
     C                   ENDIF

     C                   WHEN      p_PSTM = 05
     C                   EVAL      P@CNUM = %SUBST(p_PONS:01:06)
     C                   EVAL      P@ACOD = %DEC(%SUBST(p_PONS:07:10):10:0)
     C                   EVAL      P@ACSQ = %DEC(%SUBST(p_PONS:17:02):02:0)
     C                   EVAL      P@BRCA = p_OMDB
     C                   EVAL      P@ACCY = p_CCY

     C                   WHEN      p_PSTM = 14
     C                   EVAL      KacACNO = %DEC(p_PONS:10:0)
     C     KACCNTL1      CHAIN(E)  ACCNTL1

     C                   IF        %FOUND(ACCNTL1)
     C                   EVAL      P@CNUM = acCNUM
     C                   EVAL      P@ACOD = acACOD
     C                   EVAL      P@ACSQ = acACSQ
     C                   EVAL      P@BRCA = acBRCA
     C                   EVAL      P@ACCY = acCCY
     C                   ENDIF
     C                   ENDSL

      ** Set Settlement Account from Receivable.

     C                   ELSE
     C                   IF        p_PTYP = 61 OR
     C                             p_PTYP = 62 OR
     C                             p_PTYP = 64 OR
     C                             p_PTYP = 68 OR
     C                             p_PTYP = 80

     C                   SELECT
     C                   WHEN      p_RSTM = 01 OR p_RSTM = 08

     C                   EVAL      KCCY = p_CCY
     C                   EVAL      KNONB = %SUBST(p_RONS:01:02)
     C                   EVAL      KCNUM = *BLANKS
     C                   EXSR      XRNOST

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      P@CNUM = A7CUST
     C                   EVAL      P@ACOD = %DEC(A7ACCD:10:0)
     C                   EVAL      P@ACSQ = A7ACSN
     C                   EVAL      P@BRCA = A7BRCD
     C                   EVAL      P@ACCY = A7CYCD
     C                   ENDIF

     C                   WHEN      p_RSTM = 05
     C                   EVAL      P@CNUM = %SUBST(p_RONS:01:06)
     C                   EVAL      P@ACOD = %DEC(%SUBST(p_RONS:07:10):10:0)
     C                   EVAL      P@ACSQ = %DEC(%SUBST(p_RONS:17:02):02:0)
     C                   EVAL      P@BRCA = p_OSDB
     C                   EVAL      P@ACCY = p_CCY

     C                   WHEN      p_RSTM = 14
     C                   EVAL      KacACNO = %DEC(p_RONS:10:0)
     C     KACCNTL1      CHAIN(E)  ACCNTL1

     C                   IF        %FOUND(ACCNTL1)
     C                   EVAL      P@CNUM = acCNUM
     C                   EVAL      P@ACOD = acACOD
     C                   EVAL      P@ACSQ = acACSQ
     C                   EVAL      P@BRCA = acBRCA
     C                   EVAL      P@ACCY = acCCY
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF

      ** Retrieve loan type/subtype

     C                   EVAL      P@LTYP = p_LTYP
     C                   EVAL      P@SUTP = p_SUTP
     C                   EVAL      P@CLAS = p_CLAS
     C                   EXSR      XRLOAN

     C                   EVAL      P@BLAF = k_SEAAMT

      ** Retrieve Currency Details.

     C                   EVAL      k_SEAAMT = P@BLAF
     C                   EVAL      P@CCY = P@ACCY
     C                   EXSR      XRCURR

     C                   EVAL      DSNBDP_p = A6NBDP
     C                   EVAL      DSSPRT_p = A6SPRT
     C                   EVAL      DSMDIN_p = A6MDIN

      ** Calculate Interest Due.

     C                   EVAL      DSintdue = 0
     C                   EVAL      DSRepayAmt = 0
     C                   EVAL      DSintdue = K_SEINTA

      ** Calculate amount due based on available balance.

     C     *LIKE         DEFINE    P@BLAF        Wbalance
     C     *LIKE         DEFINE    p_Cpam        Wprincipal
     C     *LIKE         DEFINE    p_Cpam        DSRepayAmt
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
     C                   EVAL      ConvertFlag = *OFF                                       MD051900
     C                   ELSE
     C                   EVAL      DSRepayAmt = Wbalance
     C                   EVAL      Wbalance = 0
     C                   EVAL      ConvertFlag = *ON                                        MD051900
     C                   ENDIF
     C                   EVAL      DSRpyAmt = DSRepayAmt

      ** If Repayment
      ** - Create Manual Repayment.

     C                   IF        DSRpyAmt <> 0 AND P@BLAF < 0

     C                   EXSR      XSLOAMSDK
     C                   EXSR      XWLOAMSDK
     C                   EXSR      XWLOMK

     C                   IF        DSActn = 'I'
     C                   EXSR      XSLOAMSZ1
     C                   EXSR      XULOAMSZ1
     C                   EXSR      XSLELOMZ
     C                   EXSR      XULELOMZ
     C                   ENDIF

      ** Update Facility.

     C                   IF        p_FAMU = 'Y' OR Pdclt = 'X'
     C                   EXSR      XSFCLTY
     C                   ENDIF
     C                   ENDIF

      ***Update*Record*Status*as*'Processed'.                                               MD020966
      **********                                                                            MD020966
     C**********         EVAL      p_RECI = 'P'                                             MD020966
     C**********         EXSR      XUPDCR                                                   MD020966

      ***Commit*Changes.                                                                    MD020966

     C**********         EVAL      p_RECI = 'P'                                             MD020966
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPDCL - Check Whether Loan Should be Processed.             *
      *                                                               *
      *****************************************************************
     C     SRPDCL        BEGSR

      ** Initialisation.

     C                   MOVE      'N'           WSkip
     C                   MOVEL     p_ltyp        Pdclt

      ** If input today & created in the COB, set flag to skip record.

     C                   IF        p_ORED = BJRDNB

     C                   IF        Pdclt <> 'Z'
     C     p_LNRF        CHAIN(E)  LEPDUEL1

     C                   IF        %FOUND(LEPDUEL1) AND YPCBIC = 'C'

     C                   MOVE      'Y'           WSkip
     C                   ENDIF
     C                   ELSE
     C     p_LNRF        CHAIN(E)  LEPDUFL1
     C                   IF        %FOUND(LEPDUFL1) AND YPCBIC = 'C'

     C                   MOVE      'Y'           WSkip
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSLOAMSDK - Set Loan Amendment Details (LOAMSDK & LELOMKPD)  *
      *                                                               *
      *****************************************************************
     C     XSLOAMSDK     BEGSR

      ** Initialisation.

     C                   CLEAR                   LOAMSDKF

      ** Set Details.

     C                   EVAL      Ka_LNRF = p_LNRF
     C                   EVAL      Ka_VDAT = k_VDAT
     C     KLELOAML3     SETGT     LELOAML3
     C     KLELOAML3     READPE    LELOAML3

     C                   EVAL      LNRF = Ka_LNRF
     C                   EVAL      VDAT = Ka_VDAT

     C                   IF        NOT %EOF(LELOAML3)
     C                   EVAL      LASN = a_LASN
     C                   ELSE
     C                   EVAL      LASN = 0
     C                   ENDIF

     C                   EVAL      LASN += 1

     C                   EVAL      RECI = 'D'
     C                   EVAL      MRIN = k_MRIN
     C                   EVAL      LTYP = k_LTYP
     C                   EVAL      SUTP = k_SUTP
     C                   EVAL      PTYP = k_PTYP
     C                   EVAL      AMTP = k_AMTP
     C                   EVAL      PRSQ = k_PRSQ
     C                   IF        k_AMTP = 'MA'                                            AR815697
     C                   EVAL      AMTP = 'MR'                                              AR815697
     C                   EVAL      PRSQ = 18                                                AR815697
     C                   ENDIF                                                              AR815697
     C                   EVAL      BRTT = k_BRTT
     C                   EVAL      RTSP = k_RTSP
     C                   EVAL      CCY = k_CCY

      ** Generate 2 different MR one for principal and one for interest.

     C                   EVAL      PRAM = 0
     C                   EVAL      INTA = 0
     C                   EVAL      TAMT = 0
                                                                                            MD046080
      ** Convert amount to loan currency when CLE031 is *ON                                 MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   IF        ConvertFlag = *ON                                        MD051900
     C                   EVAL      WINAMT = DSRpyAmt                                        MD046080
     C                   EXSR      SrConvert                                                MD046080
     C                   EVAL      DSRpyAmt = WOUTAMT                                       MD046080
     C                   ELSE                                                               MD051900
     C                   IF        K_SEPRAM <> 0                                            MD051900
     C                   EVAL      DSRpyAmt = K_PRAM                                        MD051900
     C                   ELSE                                                               MD051900
     C                   EVAL      DSRpyAmt = K_INTA                                        MD051900
     C                   ENDIF                                                              MD051900
     C                   ENDIF                                                              MD051900
     C                   ENDIF                                                              MD046080

      ** Principal.

     C                   IF        K_SEPRAM <> 0
     C                   EVAL      PRAM = DSRpyAmt
     C                   ENDIF

      ** Interest.

     C                   IF        K_SEINTA <> 0
     C                   EVAL      INTA = DSRpyAmt
     C                   ENDIF

     C                   EVAL      WTXA = k_WTXA
     C                   EVAL      FEAM = k_FEAM
     C                   EVAL      TAMT = DSRpyAmt
     C                   EVAL      BRCA = k_BRCA
     C                   EVAL      CNUM = k_CNUM
     C                   EVAL      REPT = k_REPT
     C                   EVAL      AUTO = 'C'
     C                   EVAL      STAI = k_STAI

     C                   EVAL      TSEN = k_TSEN
     C                   EVAL      FACO = k_FACO
     C                   EVAL      SPI1 = k_SPI1
     C                   EVAL      SPI2 = k_SPI2
     C                   EVAL      SPI3 = k_SPI3
     C                   BITOFF    '01234567'    LAIN
     C                   EVAL      BRTE = k_BRTE
     C                   EVAL      SPIN = k_SPIN
     C                   EVAL      CALC = k_CALC
     C                   EVAL      WTIN = k_WTIN
     C                   EVAL      LLAG = k_LLAG
     C                   EVAL      LWOI = k_LWOI
     C                   EVAL      XAVD = k_XAVD
     C                   EVAL      XASQ = k_XASQ
     C                   EVAL      FCUS = k_FCUS
     C                   EVAL      FTYP = k_FTYP
     C                   EVAL      FSEQ = k_FSEQ
     C                   EVAL      RLON = k_RLON
     C                   EVAL      FECD = k_FECD
     C                   BITOFF    '01234567'    PONI
     C                   EVAL      ACTI = *BLANKS
     C                   EVAL      CNFY = k_CNFY
     C                   EVAL      TLXY = k_TLXY
     C                   EVAL      CBLY = k_CBLY
     C                   EVAL      INTC = k_INTC
     C                   EVAL      NACD = k_NACD
     C                   EVAL      ACBI = k_ACBI
     C                   EVAL      LSWCC = 0
     C                   EVAL      LSWSC = 0
     C                   EVAL      FCLB = k_FCLB
     C                   EVAL      LSMD = k_LSMD
     C                   EVAL      REBT = k_REBT

     C                   EVAL      ORED = k_ORED
     C                   EVAL      LCD = k_LCD
     C                   EVAL      CHTP = 'I'

     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      0             P@NATN

     C                   EVAL      TNLU = P@NATN

     C                   EVAL      PIBN = k_PIBN
     C                   EVAL      PIBA = k_PIBA
     C                   EVAL      POBN = k_POBN
     C                   EVAL      POCN = k_POCN
     C                   EVAL      RVNO = k_RVNO

     C                   EVAL      AWBN = k_AWBN
     C                   EVAL      AWBA = k_AWBA
     C                   EVAL      BENN = k_BENN
     C                   EVAL      BENA = k_BENA
     C                   EVAL      DTP1 = k_DTP1
     C                   EVAL      DTP2 = k_DTP2
     C                   EVAL      DTP3 = k_DTP3
     C                   EVAL      DTP4 = k_DTP4
     C                   EVAL      DCHG = k_DCHG
     C                   EVAL      BTB1 = k_BTB1
     C                   EVAL      BTB2 = k_BTB2
     C                   EVAL      BTB3 = k_BTB3
     C                   EVAL      BTB4 = k_BTB4
     C                   EVAL      BTB5 = k_BTB5
     C                   EVAL      BTB6 = k_BTB6
     C                   EVAL      CVMR = k_CVMR
     C                   EVAL      FSRP = k_FSRP
     C                   EVAL      FSGN = k_FSGN
     C                   EVAL      FPRC = k_FPRC
     C                   EVAL      COFA = k_COFA
     C                   EVAL      IRCF = k_IRCF
     C                   EVAL      FRCF = k_FRCF
     C                   EVAL      DFTP = k_DFTP
     C                   EVAL      DFST = k_DFST
     C                   EVAL      MNSG = k_MNSG
     C                   EVAL      GASS = k_GASS
     C                   EVAL      GPRT = k_GPRT
     C                   EVAL      NRLI = k_NRLI
     C                   EVAL      ROLN = k_ROLN
     C                   EVAL      ROSN = k_ROSN
     C                   EVAL      ROBR = k_ROBR
     C                   EVAL      RORC = k_RORC
     C                   EVAL      PDGN = *BLANKS
     C                   EVAL      GRIN = k_GRIN
     C                   EVAL      RLCY = k_RLCY
     C                   EVAL      PNAM = k_PNAM
     C                   EVAL      PAST = *BLANKS
     C                   EVAL      ASTS = 'A'
     C                   EVAL      IUSR = 'LE007056'
     C                   EVAL      AUSR = *BLANKS
     C                   EVAL      XUSR  = *BLANKS

     C                   EXSR      XEPCRF
     C                   EVAL      PCRF = WPCRF

     C                   EVAL      PCOB = k_PCOB
     C                   EVAL      MTPD = k_MTPD
     C                   EVAL      PDDI = k_PDDI
     C                   EVAL      PTDI = k_PTDI
     C                   EVAL      SCCY = k_SCCY
     C                   EVAL      ICCY = k_ICCY
     C                   EVAL      ECIN = k_ECIN
     C                   EVAL      REPI = k_REPI
     C                   EVAL      CHDU = k_CHDU
     C                   EVAL      INTN = k_INTN
     C                   EVAL      FSPRAM = k_FSPRAM
     C                   EVAL      REXR = k_REXR
     C                   EVAL      REXI = k_REXI
     C                   EVAL      PSCY = k_PSCY
     C                   EVAL      PEXR = k_PEXR
     C                   EVAL      PEXI = k_PEXI
     C                   EVAL      STAL = k_STAL
     C                   EVAL      FRNT = k_FRNT
     C                   EVAL      AFRT = k_AFRT
     C                   EVAL      REPA = k_REPA

     C                   EXSR      XETIMESTAMP
     C                   EVAL      TMST = P@TimeStamp

     C                   EVAL      OSAC = k_OSAC
     C                   EVAL      SETP = k_SETP
     C                   EVAL      OSBR = k_OSBR
     C                   EVAL      RSTM = k_RSTM
     C                   EVAL      PSTM = k_PSTM

     C                   EVAL      RIBN = k_RIBN
     C                   EVAL      RIBA = k_RIBA
     C                   EVAL      ROBN = k_ROBN
     C                   EVAL      ROCN = k_ROCN
     C                   EVAL      RCRN = k_RCRN
     C                   EVAL      RCRA = k_RCRA
     C                   EVAL      RONS = k_RONS
     C                   EVAL      PONS = k_PONS

     C                   EVAL      AUTH = k_AUTH
     C                   EVAL      FRCY = k_FRCY
     C                   EVAL      FRAM = k_FRAM
     C                   EVAL      FINT = k_FINT
     C                   EVAL      FTXA = k_FTXA
     C                   EVAL      FTOT = k_FTOT
     C                   EVAL      FPEN = k_FPEN
     C                   EVAL      BASR = k_BASR
     C                   EVAL      SLTP = k_SLTP
     C                   EVAL      SLST = k_SLST
     C                   EVAL      CLAS = k_CLAS
     C                   EVAL      DFCL = k_DFCL
     C                   EVAL      SLCL = k_SLCL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSFCLTY - Set Facility Details.                              *
      *                                                               *
      *****************************************************************
     C     XSFCLTY       BEGSR

      ** Initialisation.

     C                   IF        PRAM = 0
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      DSPart = 'N'

      ** Retrieve Facility (A - Record).

     C                   EVAL      Kf_CNUM = p_FCUS
     C                   EVAL      Kf_FACT = p_FTYP
     C                   EVAL      Kf_FCNO = p_FSEQ
     C                   EVAL      Kf_RCTP = 'A'
     C     KFCLTY        CHAIN(NE) FCLTY

     C                   IF        NOT %FOUND(FCLTY) OR %ERROR

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                             %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve Facility (B - Record).

     C                   EVAL      Kf_RCTP = 'B'
     C     KFCLTY        CHAIN(E)  FCLTY

     C                   IF        NOT %FOUND(FCLTY) OR %ERROR

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                             %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access LEFCAMPD file for change in revolving credit.

     C                   EVAL      DSRVCR = *BLANK
     C                   EVAL      DSVlDt = 0

     C                   EVAL      Ki_CNUM = FCUS
     C                   EVAL      Ki_FACT = FTYP
     C                   EVAL      Ki_FCNO = FSEQ
     C     KFCAM         SETLL     LEFCAML3
     C     KFCAM         READE     LEFCAML3

     C                   DOW       NOT %EOF(LEFCAML3) AND DSRVCR = *BLANK

     C                   IF        i_RECI = 'D' AND i_FATP = 'RC'

     C                   EVAL      DSRVCR = i_RVCR
     C                   EVAL      DSVlDt = i_VLDT
     C                   ENDIF

     C     KFCAM         READE     LEFCAML3
     C                   ENDDO

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'LEFCAML3'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = Ki_CNUM + %CHAR(Ki_FACT) +
     C                             %CHAR(Ki_FCNO)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve Currency Details.

     C                   EVAL      P@CCY = f_FCCY
     C                   EXSR      XRCURR

     C                   EVAL      DSNBDP_f = A6NBDP
     C                   EVAL      DSSPRT_f = A6SPRT
     C                   EVAL      DSMDIN_f = A6MDIN

      ** Evaluate Facility Exposure Amount.

     C                   EXSR      XEEXPAMT

      ** Derive Last Amendment Details & Set TimeStamp.

     C                   EVAL      f_LCD = BJRDNB
     C                   EVAL      f_CHTP = 'A'

     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      0             P@NATN

     C                   EVAL      f_TNLU = P@NATN

     C                   EXSR      XETIMESTAMP
     C                   EVAL      f_STMP = P@TimeStamp

      ** Update Facility.

     C                   EXSR      XUFCLTYFN

      ** Update superfacility of the tranche, if any, for CLE005.

     C                   IF        CLE005 = 'Y' AND f_TRCA = 'TR'

     C                   EVAL      DSPRME2 = DSPRME1
     C                   EXSR      XSFCLTY_CA
     C                   EVAL      DSPRME1 = DSPRME2
     C                   ENDIF

      ** Retrieve Facility (A - Record).

     C                   IF        p_LPFI <> ' '
     C                   EVAL      DSPart = 'Y'

     C                   EVAL      Kf_CNUM = p_PTFC
     C                   EVAL      Kf_FACT = p_PTFT
     C                   EVAL      Kf_FCNO = p_PTFN
     C                   EVAL      Kf_RCTP = 'A'
     C     KFCLTY        CHAIN(E)  FCLTY

     C                   IF        NOT %FOUND(FCLTY) OR %ERROR

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                             %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve Facility (B - Record).

     C                   EVAL      Kf_RCTP = 'B'
     C     KFCLTY        CHAIN(E)  FCLTY

     C                   IF        NOT %FOUND(FCLTY) OR %ERROR

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 007
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                             %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve Currency Details.

     C                   EVAL      P@CCY = f_FCCY
     C                   EXSR      XRCURR

     C                   EVAL      DSNBDP_f = A6NBDP

      ** Evaluate Facility Exposure Amount.

     C                   EXSR      XEEXPAMT

      ** Set Last Change Details.

     C                   EVAL      f_LCD = BJRDNB
     C                   EVAL      f_CHTP = 'A'

     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD
     C                   PARM      0             P@NATN

     C                   EVAL      f_TNLU = P@NATN

      ** Derive Timestamp.

     C                   EXSR      XETIMESTAMP
     C                   EVAL      f_STMP = P@TimeStamp

      ** Update Facility.

     C                   EXSR      XUFCLTYFN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSFCLTY_CA - Set Facility - Credit Agreement Details.        *
      *                                                               *
      *****************************************************************
     C     XSFCLTY_CA    BEGSR

      ** Save Credit Agreement Values.

     C                   EVAL      DSFCCY_f = f_FCCY
     C                   EVAL      DSCMDI_f = f_CMDI
     C                   EVAL      DSCAXR_f = f_CAXR

      ** Save the revolving credit indicator specified for the tranche.

     C                   IF        CLE014 = 'Y'
     C                   EVAL      DSRVCR = f_RVCR
     C                   ENDIF

      ** Whenever the facility utilisation is updated for a tranche,
      ** update the credit agreement/superfacility as well.

     C                   EVAL      Kf_CNUM = f_CANM
     C                   EVAL      Kf_FACT = f_CAFT
     C                   EVAL      Kf_FCNO = f_CAFN
     C                   EVAL      Kf_RCTP = 'A'
     C     KFCLTY        CHAIN(NE) FCLTY

     C                   IF        NOT %FOUND(FCLTY) OR %ERROR

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 008
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                             %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If the revolving credit indicator for the credit agreement is
      ** 'T', use the saved tranche revolving credit indicator as the
      **  credit agreement revolving indicator.

     C                   IF        CLE014 = 'Y'
     C                   IF        f_RVCR = 'T'
     C                   EVAL      f_RVCR = DSRVCR
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      Kf_RCTP = 'B'
     C     KFCLTY        CHAIN(E)  FCLTY

     C                   IF        NOT %FOUND(FCLTY) OR %ERROR

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 009
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                             %CHAR(Kf_FCNO) + Kf_RCTP
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If tranche and superfacility currencies are different,
      ** get superfacility currency details.

     C                   IF        DSFCCY_f <> f_FCCY
     C                   EVAL      P@CCY = f_FCCY
     C                   EXSR      XRCURR

     C                   EVAL      DSNBDP_f2 = A6NBDP
     C                   EVAL      DSSPRT_f2 = A6SPRT
     C                   EVAL      DSMDIN_f2 = A6MDIN

      ** Convert facility amount to credit facility currency equivalent.

     C                   EVAL      CX = DSNBDP_f2 - DSNBDP_f + 4

     C                   IF        DSCMDI_f = 'D'
     C     DSCAXR_f      DIV(H)    POWR(Cx)      DSOFCXRT
     C     1             DIV       DSOFCXRT      DSOFCXRT

     C                   ELSE
     C     DSCAXR_f      MULT(H)   POWR(CX)      DSOFCXRT
     C                   ENDIF

     C                   MULT(H)   DSOFCXRT      PRAM_Fac

      ** Convert facility amount to Credit agreement facility using
      ** spot rate for later update of Current exposure.

     C                   IF        CLE023 = 'Y'
     C                   EVAL      ZRATE1 = DSSPRT_f
     C                   EVAL      ZMDI1 = DSMDIN_f
     C                   EVAL      ZRATE2 = DSSPRT_f2
     C                   EVAL      ZMDI2 = DSMDIN_f2

     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX

     C                   EVAL      ZAMTCI = WrkPRAMS
     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX
     C                   EVAL      ZCCYI = DSFCCY_f
     C                   EVAL      ZCCYO = f_FCCY
     C                   EVAL      ZCDPI = DSNBDP_f
     C                   EVAL      ZCDPO = DSNBDP_f2

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

      ** Update facility exposure and availability.

     C                   MOVE      'Y'           WTRCA

      ** Evaluate Facility Exposure Amount.

     C                   EXSR      XEEXPAMT

      ** Set Last Change Details.

     C                   EVAL      f_LCD = BJRDNB
     C                   EVAL      f_CHTP = 'A'
     C                   EVAL      f_TNLU = P@NATN

      ** Update Facility Details.

     C                   EXSR      XUFCLTYFN

     C                   EVAL      WTRCA = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XEEXPAMT - Evaluate Exposure Amount (Internal Customer).     *
      *                                                               *
      *****************************************************************
     C     XEEXPAMT      BEGSR

      ** Convert amounts into facility currency equivalent.

     C                   IF        WTRCA = *BLANK

     C                   IF        CLE023 = 'Y' AND
     C                             p_RLDT < BJRDNB AND
     C                             p_RLDT <> *ZERO AND
     C                             l_NFCE <> *ZERO AND
     C                             l_NCCY = *BLANKS

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

      ** Convert amount to facility currency using spot rates.

     C                   IF        CLE023 = 'Y'
     C                   EVAL      ZMDI1 = DSMDIN_p
     C                   EVAL      ZRATE1 = DSSPRT_p
     C                   EVAL      ZMDI2 = DSMDIN_f
     C                   EVAL      ZRATE2 = DSSPRT_f

     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM      0             ZRATEX
     C                   PARM      *BLANKS       ZMDIX

     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX
     C                   EVAL      ZAMTCI = PRAM
     C                   EVAL      ZCCYI = p_CCY
     C                   EVAL      ZCCYO = f_FCCY
     C                   EVAL      ZCDPI = DSNBDP_p
     C                   EVAL      ZCDPO = DSNBDP_f

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

      ** Set up fields for availability updating.

     C                   Z-ADD     p_MDAT        ENDAY                    40

     C                   IF        *IN40 = '1'
     C                   Z-ADD     99999         ENDAY
     C                   ENDIF

     C                   Z-ADD     k_VDAT        DAYNO

     C                   MOVEA     '00'          *IN(41)

      ** Similar update for a non-syndicated loan and part purchased,
      ** internal parts purchased and funding participant.

     C                   IF        f_RVCR = 'Y' AND
     C                             DSRVCR = ' ' OR
     C                             f_RVCR = 'N' AND
     C                             DSRVCR = 'Y' AND
     C                             DSVlDt <= BJRDNB OR
     C                             DSPart = 'Y' AND
     C                             GASS = 'A'

      ** Participation sold.

     C                   IF        DSLoanType <> 'PTSO' AND
     C                             p_LPFI = ' ' OR
     C                             DSPart = 'Y'

     C                   IF        DSActn = 'I'
     C                   EVAL      *IN41 = *ON
     C                   ELSE
     C                   EVAL      *IN42 = *ON
     C                   ENDIF

      ** Similar update for a non-syndicated parts sold, and prime facilities

     C                   ELSE
     C                   IF        DSActn = 'I'
     C                   EVAL      *IN42 = *ON

     C                   ELSE
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   Z-ADD     PRAM_Fac      FCBAL

      ** Do not update for parts sold with recourse and
      ** if CLE023 is not installed.  If CLE023 is installed, do not
      ** update for parts sold for non-participant facility with or
      ** without recourse.  Also do not update
      ** Prime facility of a syndicated loan.

     C                   IF        DSLoanType = 'PTSO' AND
     C                             p_RCSI = 'Y' AND
     C                             p_LPFI = ' ' AND
     C                             CLE023 = 'N' OR
     C                             DSLoanType = 'PTSO' AND
     C                             p_LPFI = ' ' AND
     C                             CLE023 = 'Y' OR
     C                             DSPart = 'N' AND
     C                             p_LPFI <> ' '
     C                   MOVEA     '00'          *IN(41)
     C                   ENDIF

      ** If customer is branch internal customer, then no update to
      ** facility availability.

     C                   IF        %LOOKUP(p_CNUM:@BIC) = 0
     C                   EVAL      DSIntnlCus = 'N'

     C                   ELSE
     C                   EVAL      DSIntnlCus = 'Y'
     C                   ENDIF

      ** If Internal customer and Not Linked to Part Facility
      ** Or, if Linked to Part Facility, then loan is an IPP.

     C                   IF        DSIntnlCus = 'Y' AND
     C                             p_LPFI <> 'I' OR
     C                             p_LPFI = 'I' AND
     C                             DSPart = 'N'

     C                   EVAL      DSIntnlCus = 'N'

     C                   ELSE
     C                   IF        *IN41 = *ON OR *IN42 = *ON

     C                   IF        DAYNO <> 0
     C                   EXSR      XEDRWNAMTS
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

     C                   IF        k_VDAT <= BJRDNB
     C                   IF        p_LPFI <> *BLANK
     C                   IF        DSActn = 'I' AND
     C                             DSPart = 'Y' OR
     C                             DSActn = 'R' AND
     C                             DSPart = 'N' AND
     C                             p_RCSI <> 'Y' AND
     C                             p_LPFI <> 'I'

     C                   IF        DSPart = 'Y' AND
     C                             CLE023 = 'Y' AND
     C                             CLE025 = 'N' OR
     C                             CLE023 = 'N' AND
     C                             CLE025 = 'N'

     C                   EVAL      f_CAMD -= PRAM_Fac
     C                   ENDIF

     C                   IF        CLE023 = 'Y' AND CLE025 = 'N'
     C                   EVAL      f_CEXP -= WrkPRAMS
     C                   ENDIF

      ** If CLE009 is installed, set Work Regeneration Indicator to 'Changed'

     C                   IF        CLE009 = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
     C                   ENDIF

     C                   IF        DSActn = 'R' AND
     C                             DSPart = 'Y' OR
     C                             DSActn = 'I' AND
     C                             DSPart = 'N' AND
     C                             p_RCSI = 'Y' AND
     C                             p_LPFI = 'I'

     C                   IF        DSPart = 'Y' AND
     C                             CLE023 = 'Y' AND
     C                             CLE025 = 'N' OR
     C                             CLE023 = 'N' AND
     C                             CLE025 = 'N'
     C                   EVAL      f_CAMD += PRAM_Fac
     C                   ENDIF

     C                   IF        CLE023 = 'Y' AND CLE025 = 'N'
     C                   EVAL      f_CEXP += WrkPRAMS
     C                   ENDIF

      ** If CLE009 is installed, set Work Regeneration Indicator to 'C'hanged

     C                   IF        CLE009 = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
     C                   ENDIF

      ** Normal, non-syndicated loans.

     C                   ELSE
     C                   IF        DSLoanType <> 'PTSO' AND
     C                             DSActn = 'I' OR
     C                             DSLoanType = 'PTSO' AND
     C                             DSActn = 'R' AND
     C                             p_RCSI <> 'Y'

     C                   IF        DSLoanType <> 'PTSO' AND
     C                             CLE023 = 'Y' AND
     C                             CLE025 = 'N' OR
     C                             CLE023 = 'N' AND
     C                             CLE025 = 'N'
     C                   EVAL      f_CAMD -= PRAM_Fac
     C                   ENDIF

     C                   IF        CLE023 = 'Y' AND CLE025 = 'N'
     C                   EVAL      f_CEXP -= WrkPRAMS
     C                   ENDIF

      **  If CLE009 is installed, set Work Regeneration Indicator to 'Changed

     C                   IF        CLE009 = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF
     C                   ENDIF

     C                   IF        DSLoanType <> 'PTSO' AND
     C                             DSActn = 'R' OR
     C                             DSLoanType = 'PTSO' AND
     C                             DSActn = 'I' AND
     C                             p_RCSI <> 'Y'

     C                   IF        DSLoanType <> 'PTSO' AND
     C                             CLE023 = 'Y' AND
     C                             CLE025 = 'N' OR
     C                             CLE023 = 'N' AND
     C                             CLE025 = 'N'
     C                   EVAL      f_CAMD += PRAM_Fac
     C                   ENDIF

     C                   IF        CLE023 = 'Y' AND CLE025 = 'N'
     C                   EVAL      f_CEXP += WrkPRAMS
     C                   ENDIF

      ** If CLE009 is installed, set Work Regeneration Indicator to 'Changed'

     C                   IF        CLE009 = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XEDRWNAMTS - Evaluate Facility Drawn Amount for the Next     *
      *              10 Days.                                         *
      *                                                               *
      *****************************************************************
     C     XEDRWNAMTS    BEGSR

      ** With Manual Repayment on loans during I/C
      ** the availability (i.e. undrawn amount) should be updated
      ** to reflect the repayment.

      ** RUNS,1 = The previous working day
      ** ENDAY  = Maturity date of loan

      ** If Loan is not autosettled, then the O/S principal of that loan
      ** is included in all elements of the drawn amount array, even
      ** beyond the maturity date of the loan. So this MR amount should
      ** update all elements of the array if the loan is non-autosettled

      ** Locate the End Date in Forward Run Days Array.

     C                   EVAL      #X = 1
     C     ENDAY         LOOKUP    RUNS(#X)                           40  40

     C                   IF        *IN40 = '0'
     C                   EVAL      #X = 99

     C                   ELSE
     C                   IF        p_AUTO = 'N' OR ENDAY <= RUNS(1)
     C                   EVAL      #X = 99
     C                   ENDIF
     C                   ENDIF

      ** Locate Value Date in Forward Run Date Array.

     C                   EVAL      #W = 1
     C     DAYNO         LOOKUP    RUNS(#W)                           40  40

      ** If within the next 10 days, adjust each day's Facility Balance.

     C                   IF        *IN40 = '1'
     C                   DOW       #W <= 10 AND #W < #X

     C                   IF        CLE025 = 'N'
     C                   IF        *IN41 = '1'
     C                   EVAL      OAM(#W) -= FCBAL
     C                   ENDIF

     C                   IF        *IN42 = '1'
     C                   EVAL      OAM(#W) += FCBAL
     C                   ENDIF
     C                   ENDIF

      ** If CLE009 is installed, set Work Regeneration Indicator to 'Change'

     C                   IF        CLE009 = 'Y'
     C                   MOVE      'C'           WKSWRI
     C                   ENDIF

      ** If Increment Index (day).

     C                   EVAL      #W += 1
     C                   ENDDO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
     1*  XEPCRF - Evaluate PC Transaction Reference                   *
      *                                                               *
      *****************************************************************
     C     XEPCRF        BEGSR

      ** Retrieve Branch Details.

     C                   EVAL      P@BRCA = p_BRCA
     C                   EXSR      XRBRCH

     C                   MOVEL     A8MQSM        W#1ST3

     C                   CALL      'LEALLO'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      'Y'           PUPDT
     C                   PARM      *BLANKS       PCLAST
     C                   PARM      *BLANKS       PCNEXT

     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        WPCRF
     C                   MOVE      '0001'        WPCRF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XETIMESTAMP - Evaluate Timestamp                             *
      *                                                               *
      *****************************************************************
     C     XETIMESTAMP   BEGSR

      ** Generate a timestamp.

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    P@TimeStamp

     C                   IF        %ERROR
     C                   EVAL      DBPGM = 'ZAGENTMSTM'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBASE = 010
     C                   EVAL      DBKEY = *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   XRBRCH - Retrieve Branch Details.                           *
      *                                                               *
      *****************************************************************
     C     XRBRCH        BEGSR

      ** Check Array for Branch.

     C                   EVAL      #C = %LOOKUP(P@BRCA:DSBrCd)

     C                   IF        #C > 0
     C                   EVAL      SDBRCH = DSBRCD(#C)

      ** Otherwise, Retrieve Record.

     C                   ELSE
     C                   CALL(E)   'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    P@BRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        PRTCD <> *BLANKS OR %ERROR
     C                   EVAL      DBPGM = 'AOBRCHR1'
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 011
     C                   EVAL      DBKEY = P@BRCA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      #C = %LOOKUP(' ':DSBrCd)

     C                   IF        #C = 0
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = P@BRCA
     C                   EVAL      DBASE = 111
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DSBrCd(#C) = P@BRCA
     C                   EVAL      DSBRCH(#C) = SDBRCH
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRCURR - Retrieve Currency Details.                          *
      *                                                               *
      *****************************************************************
     C     XRCURR        BEGSR

      ** Check Array for Currency.

     C                   EVAL      #C = %LOOKUP(P@CCY:DSCyCd)

     C                   IF        #C > 0
     C                   EVAL      SDCURR = DSCURR(#C)

      ** Otherwise, Retrieve Record.

     C                   ELSE
     C                   CALL(E)   'AOCURRR0'
     C                   PARM      '*BLANK  '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    P@CCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRTCD <> *BLANKS OR %ERROR

     C                   EVAL      DBPGM = 'AOCURRR0'
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 012
     C                   EVAL      DBKEY = P@CCY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      #C = %LOOKUP(' ':DSCyCd)

     C                   IF        #C = 0
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = P@CCY
     C                   EVAL      DBASE = 112
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DSCyCd(#C) = P@CCY
     C                   EVAL      DSCURR(#C) = SDCURR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRLOAN - Retrieve Loan Type Details.                         *
      *                                                               *
      *****************************************************************
     C     XRLOAN        BEGSR

      ** Initialisation.

     C                   EVAL      P@LtSt = P@LTYP + P@SUTP + P@CLAS

      ** Check Array for Loan Type.

     C                   EVAL      #C = %LOOKUP(P@LtSt:DSLtSt)

     C                   IF        #C > 0
     C                   EVAL      SDLOAN = DSLOAN(#C)

      ** Otherwise, Retrieve Record.

     C                   ELSE
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    P@LTYP
     C                   PARM                    P@SUTP
     C                   PARM                    P@CLAS
     C     SDLOAN        PARM      SDLOAN        DSFDY

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBKEY = P@LTYP + P@SUTP + P@CLAS
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      #C = %LOOKUP(' ':DSLtSt)

     C                   IF        #C = 0
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBKEY = P@LtSt
     C                   EVAL      DBASE = 112
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DSLtSt(#C) = P@LtSt
     C                   EVAL      DSLOAN(#C) = SDLOAN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XRNOST - Retrieve Nostro Details.                            *
      *                                                               *
      *****************************************************************
     C     XRNOST        BEGSR

      ** Initialisation.

     C                   EVAL      P@NOST = KCCY + KNONB

      ** Check Array for Nostro.

     C                   EVAL      #C = %LOOKUP(P@NOST:DSNoCd)

     C                   IF        #C > 0
     C                   EVAL      SDNOST = DSNOST(#C)

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

     C                   IF        PRTCD <> *BLANKS OR %ERROR

     C                   EVAL      DBPGM = 'AONOSTR0'
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBASE = 025
     C                   EVAL      DBKEY = P@NOST
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      #C = %LOOKUP(' ':DSNoCd)

     C                   IF        #C = 0
     C                   EVAL      DBFILE = 'SDNOSTPD'
     C                   EVAL      DBKEY = P@NOST
     C                   EVAL      DBASE = 125
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DSNoCd(#C) = P@NOST
     C                   EVAL      DSNOST(#C) = SDNOST
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSLOAMSZ1 - Set Loan Amendments Trailer File                 *
      *                                                               *
      *****************************************************************
     C     XSLOAMSZ1     BEGSR

      ** Retrieve Trailer Records.

     C                   EVAL       KLNRF = '999999'
     C                   EVAL       KVDAT = 99999
     C                   EVAL       KLASN = 999
     C     KLOAMS        CHAIN(E)  LOAMS

     C                   IF        NOT %FOUND(LOAMS)
     C                   EVAL      DBFILE = 'LOAMS'
     C                   EVAL      DBASE = 014
     C                   EVAL      DBKEY = '999999'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Increment Counts & Set Hash Totals.

     C                   SELECT
     C                   WHEN      DSACTN = 'I'
     C                   EVAL      NORE += 1
     C                   EVAL      NINS += 1
     C                   EVAL      NLRA += 1

     C                   EVAL      ZZTOTI = VRIF
     C                   EVAL      ZZTOTD = VRIL
     C                   EXSR      GLZADD
     C                   EVAL      VRIF = ZZTOTI
     C                   EVAL      VRIL = ZZTOTD

     C                   EVAL      ZZTOTI = VRRF
     C                   EVAL      ZZTOTD = VRRL

     C                   WHEN      DSACTN = 'R'
     C                   EVAL      NDEL += 1
     C                   EVAL      NLRA -= 1

     C                   EVAL      ZZTOTI = VRDF
     C                   EVAL      ZZTOTD = VRDL
     C                   ENDSL

     C                   EVAL      ZZAMT = TAMT / 1000

     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF

      ** Adjust Hash Total by Value of Records after Insert/Reversal.

     C                   EXSR      GLZADD

      ** Set Appropiate Hash Total Fields.

     C                   SELECT
     C                   WHEN      DSACTN = 'I'
     C                   EVAL      VRRF = ZZTOTI
     C                   EVAL      VRRL = ZZTOTD

     C                   WHEN      DSACTN = 'R'
     C                   EVAL      VRDF = ZZTOTI
     C                   EVAL      VRDL = ZZTOTD
     C                   ENDSL

      ** Set Last Change Details.

     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'A'

     C                   EVAL      TNLU = P@NATN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XSLELOMZ - Set Loan Amendments Trailer File                  *
      *                                                               *
      *****************************************************************
     C     XSLELOMZ      BEGSR

      ** Retrieve Trailer Records.

     C                   EVAL       KLNRF = '999999'
     C                   EVAL       KVDAT = 99999
     C                   EVAL       KLASN = 999
     C     KLOMKL3       CHAIN(E)  LELOMKL3

     C                   IF        NOT %FOUND(LELOMKL3)
     C                   EVAL      DBFILE = 'LELOMKL3'
     C                   EVAL      DBASE = 013
     C                   EVAL      DBKEY = '999999'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Increment Counts & Set Hash Totals.

     C                   SELECT
     C                   WHEN      DSACTN = 'I'
     C                   EVAL      NORE += 1
     C                   EVAL      NINS += 1
     C                   EVAL      NLRA += 1

     C                   EVAL      ZZTOTI = VRRF
     C                   EVAL      ZZTOTD = VRRL

     C                   WHEN      DSACTN = 'R'
     C                   EVAL      NDEL += 1
     C                   EVAL      NLRA -= 1

     C                   EVAL      ZZTOTI = VRDF
     C                   EVAL      ZZTOTD = VRDL
     C                   ENDSL

     C                   EVAL      ZZAMT = TAMT / 1000

     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF

      ** Adjust Hash Total by Value of Records after Insert/Reversal.

     C                   EXSR      GLZADD

      ** Set Appropiate Hash Total Fields.

     C                   SELECT
     C                   WHEN      DSACTN = 'I'
     C                   EVAL      VRRF = ZZTOTI
     C                   EVAL      VRRL = ZZTOTD

     C                   WHEN      DSACTN = 'R'
     C                   EVAL      VRDF = ZZTOTI
     C                   EVAL      VRDL = ZZTOTD
     C                   ENDSL

      ** Set Last Change Details.

     C                   EVAL      LCD = BJRDNB
     C                   EVAL      CHTP = 'A'

     C                   EVAL      TNLU = P@NATN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZADD - Subroutine to Add an Amount to the Hash Total.      *
      *                                                               *
      *****************************************************************
     C     GLZADD        BEGSR

      ** Split Input Amount (ZZAMT) into Integer and Decimal.

     C                   IF        ZZAMT <> 0
     C                   Z-ADD     ZZAMT         ZZAMT

     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD

      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now.

     C                   EXSR      GLZSUM
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLZSUM - Subroutine to carry out the additon for subroutine  *
      *                                                               *
      *****************************************************************
     C     GLZSUM        BEGSR

      ** Initialisation.

     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD

     C                   SETOFF                                       919293
     C                   SETOFF                                       949599

      ** Determine sign of ZZAMTI & D, 92 if negative.

     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND

      ** Determine sign of ZZTOTI & D, 91 if negative.

     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193

      ** If ZZTOTAL is zero, return ZZAMOUNT.

     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND

      ** If signs differ bypass overflow checks.

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
      ** then an overflow has occurred.

     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI

      ** If overflow zeroise ZZAMT, set 99 on and let ZZTOT fields intact.

     C   99              Z-ADD     0             ZZAMT
     C                   GOTO      ZZSEND

      ** The 'signs' are different.

     C     ZZOFPS        TAG

      ** If ZZAMT was negative, make it positive to compare with ZZTOT.

     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD

      ** If ZZTOT was negative, make it positive to compare with ZZAMT.

     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD

      ** Both ZZAMT and ZZTOT are now positive.

     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95

      ** If ZZTOT equals ZZAMT return zero.

     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND

      ** If ZZTOT greater than ZZAMT.

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

      ** If ZZAMT greater than ZZTOT.

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

      ** Reverse sign of ZZTOT if larger I/P fields were negative.

     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD

      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed.

     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD

     C     ZZSEND        TAG

      ** If ZZTOTD is zero, and ZZTOTI is negative set up ZZNEGD.

     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ***XUPDCR*-*Update*Customer*Loan*Details.                       *                     MD020966
      *                                                               *
      *****************************************************************
     C*****XUPDCR        BEGSR                                                              MD020966

      ***Update*Record.                                                                     MD020966

     C**********         UPDATE(E) LEPDCRF                                                  MD020966

     C**********         IF        %ERROR                                                   MD020966
     C**********         EVAL      DBFILE = 'LEPDCRPD'                                      MD020966
     C**********         EVAL      DBASE = 015                                              MD020966
     C**********         EVAL      DBKEY = p_LNRF + p_RCDT                                  MD020966
     C**********         EXSR      *PSSR                                                    MD020966
     C**********         ENDIF                                                              MD020966

     C**********         ENDSR                                                              MD020966
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XUFCLTYFN - Update Facility Details - B Record.              *
      *                                                               *
      *****************************************************************
     C     XUFCLTYFN     BEGSR

      ** Update Record.

     C                   UPDATE(E) FCLTYFNF

     C                   IF        %ERROR
     C                   EVAL      DBFILE = 'FCLTYFN'
     C                   EVAL      DBASE = 016
     C                   EVAL      DBKEY = Kf_CNUM + %CHAR(Kf_FACT) +
     C                             %CHAR(Kf_FCNO) + Kf_RCTP
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XULOAMSZ1 - Update Loan Amendment Trailer Record.            *
      *                                                               *
      *****************************************************************
     C     XULOAMSZ1     BEGSR

      ** Update Record.

     C                   UPDATE(E) LOAMSZF

     C                   IF        %ERROR
     C                   EVAL      DBFILE = 'LOAMSZ1'
     C                   EVAL      DBASE = 017
     C                   EVAL      DBKEY = KLNRF + %CHAR(KVDAT) +
     C                             %CHAR(KLASN)
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XULELOMZ - Update Loan Amendment Trailer Record.             *
      *                                                               *
      *****************************************************************
     C     XULELOMZ      BEGSR

      ** Update Record.

     C                   UPDATE(E) LELOMZF

     C                   IF        %ERROR
     C                   EVAL      DBFILE = 'LELOMZPD'
     C                   EVAL      DBASE = 018
     C                   EVAL      DBKEY = KLNRF + %CHAR(KVDAT) +
     C                             %CHAR(KLASN)
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XWLOAMSDK - Write Loan Amendment Detail Record.              *
      *                                                               *
      *****************************************************************
     C     XWLOAMSDK     BEGSR

      ** Write Record.

     C                   WRITE(E)  LOAMSDKF

     C                   IF        %ERROR
     C                   EVAL      DBFILE = 'LOAMSDKS'
     C                   EVAL      DBASE = 019
     C                   EVAL      DBKEY = LNRF + %CHAR(VDAT) +
     C                             %CHAR(LASN)
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  XWLOMK - Write Loan Amendment Detail Record.                 *
      *                                                               *
      *****************************************************************
     C     XWLOMK        BEGSR

      ** Write Record.

     C                   WRITE(E)  LELOMKF

     C                   IF        %ERROR
     C                   EVAL      DBFILE = 'LELOMKPD'
     C                   EVAL      DBASE = 020
     C                   EVAL      DBKEY = LNRF + %CHAR(VDAT) +
     C                             %CHAR(LASN)
     C                   EXSR      *PSSR
     C                   ENDIF

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
     C                   IF        CLE034 = 'Y'                                             MD046080
     C                             AND k_STAL = 'Y'                                         MD046080
     C                   MOVE      *BLANKS       WSET                                       MD046080
     C                   MOVE      k_OSAC        WSET                                       MD046080
     C                   IF        LASN = 0                                                 MD049363
     C                   EVAL      K1VDAT = 0                                               MD049363
     C                   EVAL      K1LASN = 0                                               MD049363
     C                   ELSE                                                               MD049363
     C                   EVAL      K1VDAT = VDAT                                            MD049363
     C                   EVAL      K1LASN = LASN                                            MD049363
     C                   ENDIF                                                              MD049363
     C                   IF        k_PTYP <> 66                                             MD046080
     C                             AND k_PTYP <> 67                                         MD046080
     C                             AND k_PTYP <> 69                                         MD046080
     C                             AND k_PTYP <> 72                                         MD046080
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
     C                   EVAL      CCY = WCCY1                                              MD046080
     C                   ELSE                                                               MD046080
     C                   IF        k_PTYP <> 66                                             MD046080
     C                             AND k_PTYP <> 67                                         MD046080
     C                             AND k_PTYP <> 69                                         MD046080
     C                             AND k_PTYP <> 72                                         MD046080
     C                   EVAL      WCCY1 = k_SCCY                                           MD046080
     C                   EVAL      WRATE = k_REXR                                           MD046080
     C                   EVAL      WIND1 = k_REXI                                           MD046080
     C                   ELSE                                                               MD046080
     C                   EVAL      WCCY1 = k_PSCY                                           MD046080
     C                   EVAL      WRATE = k_PEXR                                           MD046080
     C                   EVAL      WIND1 = k_PEXI                                           MD046080
     C                   ENDIF                                                              MD046080
     C                   ENDIF                                                              MD046080
     C                   EVAL      WCCY2 = k_CCY                                            MD046080
     C                   EVAL      WWWAMT = DSRpyAmt                                        MD046080
     C                   EVAL      WINAMT = DSRpyAmt                                        MD046080
     C                   EVAL      WMDIN = WIND1                                            MD046080
     C                   IF        WMDIN = 'M'                                             MD049745A
     C                   EVAL      WMDIN = 'D'                                             MD049745A
     C                   ELSE                                                              MD049745A
     C                   EVAL      WMDIN = 'M'                                             MD049745A
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
     C**********         EVAL      CCY = WCCY1                                     MD046080 MD051900
     C                   EVAL      CCY = WCCY2                                              MD051900
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
     C                   ENDSR                                                              MD046080
                                                                                            MD046080
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation Rountine.                            *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Key List.

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

     C     KCLONB        KLIST                                                              AR815697
     C                   KFLD                    k_BRCA                                     AR815697
     C                   KFLD                    k_LNRF                                     AR815697
                                                                                            AR815697
     C     KSTAL         KLIST                                                              MD046080
     C                   KFLD                    k_LNRF                                     MD046080
     C                   KFLD                    K1VDAT                                     MD049363
     C                   KFLD                    K1LASN                                     MD049363
     C                   KFLD                    WSET                                       MD046080
                                                                                            MD046080
      ** Parameter List.

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

      ** Initialisation.

     C                   EVAL      DBPGM = 'LE007056'

      ** Determine if 'Lending Enhancements - Tranche 3' is Active.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE005 = 'Y'
     C                   ENDIF

      ** Determine if 'Lending Input Cycle Fees' is Active.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE009 = 'Y'
     C                   ENDIF

      ** Determine if 'Customer Driven Enhancements' is Active.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE014 = 'Y'
     C                   ENDIF

      ** Determine if 'Facility History Improvements' is Active.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE023 = 'Y'
     C                   ENDIF

      ** Determine if 'Credit Lines' is Active.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE025'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE025 = 'Y'
     C                   ENDIF

      ** Determine if 'Flat Rate Personal Loans (Rule of 78ths)' is Active.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE028'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE028 = 'Y'
     C                   ENDIF

      ** Determine if 'Past Due Loan Processing' is Active.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE134'      @SARD

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE134 = 'Y'

     C                   ELSE
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
                                                                                            MD046080
      ** Determine if 'Settlement Diff Ccy' is active                                       MD046080
                                                                                            MD046080
     C                   CALL      'AOSARDR0'                                               MD046080
     C                   PARM      *BLANKS       @RTCD                                      MD046080
     C                   PARM      '*VERIFY'     @OPTN                                      MD046080
     C                   PARM      'CLE031'      @SARD                                      MD046080
                                                                                            MD046080
     C                   IF        @RTCD = *BLANKS                                          MD046080
     C                   EVAL      CLE031 = 'Y'                                             MD046080
                                                                                            MD046080
     C**********         ELSE                                                     MD046080 MD049745A
     C**********         EVAL      *INLR = *ON                                    MD046080 MD049745A
     C**********         RETURN                                                   MD046080 MD049745A
     C                   ENDIF                                                              MD046080
                                                                                            MD046080
      ** Determine if 'Settlement Allocation' is active                                     MD046080
                                                                                            MD046080
     C                   CALL      'AOSARDR0'                                               MD046080
     C                   PARM      *BLANKS       @RTCD                                      MD046080
     C                   PARM      '*VERIFY'     @OPTN                                      MD046080
     C                   PARM      'CLE034'      @SARD                                      MD046080
                                                                                            MD046080
     C                   IF        @RTCD = *BLANKS                                          MD046080
     C                   EVAL      CLE034 = 'Y'                                             MD046080
                                                                                            MD046080
     C**********         ELSE                                                     MD046080 MD049745A
     C**********         EVAL      *INLR = *ON                                    MD046080 MD049745A
     C**********         RETURN                                                   MD046080 MD049745A
     C                   ENDIF                                                              MD046080

      ** Access Bank Details.

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

      ** Retrieve Branch Details (Store Internal Customer).

     C     *LOVAL        SETLL     SDBRCHL5
     C                   READ(E)   SDBRCHL5

     C                   IF        %EOF(SDBRCHL5) OR %ERROR

     c     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHL5'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 022
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   DOU       %EOF(SDBRCHL5)
     C                   EVAL      #A += 1
     C                   EVAL      @BIC(#A) = A8BICN
     C                   READ(E)   SDBRCHL5
     C                   ENDDO

      ** If File is empty, add trailer record.

      ** Retrieve Trailer Records.

     C                   CLEAR                   LELOMZF
     C                   EVAL      KLNRF = '999999'
     C                   EVAL      KVDAT = 99999
     C                   EVAL      KLASN = 999
     C     KLOMKL3       CHAIN(E)  LELOMKL3

     C                   IF        NOT %FOUND(LELOMKL3)
     C                   EVAL      LNRF = '999999'
     C                   EVAL      VDAT = 99999
     C                   EVAL      LASN = 999
     C                   EVAL      RECI = 'T'
     C                   EVAL      NORE = 1
     C                   WRITE(E)  LELOMZF

     C                   IF        %ERROR
     C                   EVAL      DBFILE = 'LELOMZPD'
     C                   EVAL      DBASE = 023
     C                   EVAL      DBKEY = KLNRF + %CHAR(KVDAT) +
     C                             %CHAR(KLASN)
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILEB
**  POWR -- USED IN CURRENCY CONVERSION(FACILITY)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
