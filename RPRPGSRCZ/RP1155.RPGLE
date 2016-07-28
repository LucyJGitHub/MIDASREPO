     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Midas-Plato interface pre-proc PF/CLOANCL')   *
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP1155 - Midas-Plato Interface                               *
      *           Replication Pre-Processing Program for PF/CLOANCL.  *
      *                                                               *
      * This program is called as part of the Meridian Replication    *
      *  system for the Midas-Plato Interface.                        *
      * For each record on PF/CLOANCL, the following message format   *
      *   will be output to Meridian:                                 *
      *                                                               *
      *  LELNLLNK - Format of PF/CLOANCLK joined with Ins/Amd Ind.    *
      * ->                                                            *
      *¦ LEAMDLON - Format of PF/LOAMSDK joined with PF/CLOANCL/K.    *
      *¦ LEHSPLON - Format of PF/HISTSHP joined with PF/CLOANCL/K.    *
      *¦ LEHSQLON - Format of PF/HISTSHQ joined with PF/CLOANCL/K.    *
      * --                                                            *
      *  LELNLLNK - Format of PF/CLOANCLK joined with Ins/Amd Ind.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE154             Date 07Aug12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR858264           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP074             Date 11Sep03               *
      *                 CPK016             Date 04Sep03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPL005             Date 23Jan01               *
      *                 CLE011             Date 07Nov00               *
      *                 157669             Date 18Apr00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177415             Date 22Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPL003  *CREATE    Date 14Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR858264 - Compilation issues on RP Program                  *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CPK016 - Release 5 packaging.  Clash of field names.         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CPL005 - Midas-Plato Real-time Interface                     *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           (Recompiled)                                        *
      *  157669 - Cost of Funds are being reported incorrectly.       *
      *  177415 - Replication performance improvements.               *
      *           Do not close database files by not setting on *INLR.*
      *  CPL003 - Midas-Plato Interface                               *
      *                                                               *
      *****************************************************************
      *  Indicator Usage:                                             *
      *   *IN80 - End of records for key on LF/PLHISTL0.              *
      *   *INU7 - Error encountered in processing.                    *
      *   *INLR - Last Record - End program.                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F*
     FCLOAN     IF   E           K DISK    IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(L)
     FPLHISTL0  IF   E           K DISK    INFDS(PLHISTds)
     F                                     PREFIX(H)
     FPLLOAML0  IF   E           K DISK
     F                                     PREFIX(A)

      /EJECT
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      * Following /COPY is the procedure prototype for the Format routine
      /COPY RPCPYSRC,RPFMTPPF

      ** The following /COPY contains various standard declares
     C*/COPY RPCPYSRC,Std_Dcl                                                               AR858264
     C/COPY RPCPYSRC,STD_DCL                                                                AR858264

      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C*COPY RPCPYSRC,Mdn_Hd_DS                                                              AR858264
     C/COPY RPCPYSRC,MDN_HD_DS                                                              AR858264

      **   Composite Data
     D CompData        S                   LIKE(TransData) INZ(*BLANKS)

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

      **   Format for PF/CLOANCL
     D CLOANCLds     E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(L)
     D LRECI1        E                     EXTFLD(RECI      )
     D LLNRF1        E                     EXTFLD(LNRF      )
     D LRCDT1        E                     EXTFLD(RCDT      )
     D LMRIN1        E                     EXTFLD(MRIN      )
     D LORED1        E                     EXTFLD(ORED      )
     D LLCD1         E                     EXTFLD(LCD       )
     D LCHTP1        E                     EXTFLD(CHTP      )
     D LTNLU1        E                     EXTFLD(TNLU      )
      **   Format for PF/CLOANCK
     D CLOANCKds     E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(L)
     D LRECI2        E                     EXTFLD(RECI      )
     D LLNRF2        E                     EXTFLD(LNRF      )
     D LRCDT2        E                     EXTFLD(RCDT      )
     D LMRIN2        E                     EXTFLD(MRIN      )
     D LORED2        E                     EXTFLD(ORED      )
     D LLCD2         E                     EXTFLD(LCD       )
     D LCHTP2        E                     EXTFLD(CHTP      )
     D LTNLU2        E                     EXTFLD(TNLU      )
     D XFRNT         E                     EXTFLD(FRNT     )                                  CAP074
     D XAFRT         E                     EXTFLD(AFRT     )                                  CAP074
     D XREPA         E                     EXTFLD(REPA     )                                  CAP074
     D XTMST         E                     EXTFLD(TMST     )                                  CAP074
      **   Format for PF/LOAMSDK
     D LOAMSDKds     E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(A)
      **   Format for PF/HISTSHM
     D HISTSHMds     E DS                  EXTNAME(HISTSHM)
     D                                     PREFIX(H)
     D HRECI1        E                     EXTFLD(RECI      )
     D HRCDT1        E                     EXTFLD(RCDT      )
     D HBRCA1        E                     EXTFLD(BRCA      )
     D HCNUM1        E                     EXTFLD(CNUM      )
     D HLNRF1        E                     EXTFLD(LNRF      )
     D HVDAT1        E                     EXTFLD(VDAT      )
     D HPRSQ1        E                     EXTFLD(PRSQ      )
     D HLASN1        E                     EXTFLD(LASN      )
     D HFCUS1        E                     EXTFLD(FCUS      )
     D HFTYP1        E                     EXTFLD(FTYP      )
     D HFSEQ1        E                     EXTFLD(FSEQ      )
     D HPTYP1        E                     EXTFLD(PTYP      )
     D HCCY1         E                     EXTFLD(CCY       )
     D HAMTP1        E                     EXTFLD(AMTP      )
     D HPRAM1        E                     EXTFLD(PRAM      )
     D HBRTT1        E                     EXTFLD(BRTT      )
     D HBRTE1        E                     EXTFLD(BRTE      )
     D HRTSP1        E                     EXTFLD(RTSP      )
     D HSPIN1        E                     EXTFLD(SPIN      )
     D HCALC1        E                     EXTFLD(CALC      )
      **   Format for PF/HISTSHP
     D HISTSHPds     E DS                  EXTNAME(HISTSHP)
     D                                     PREFIX(H)
     D HRECI2        E                     EXTFLD(RECI      )
     D HRCDT2        E                     EXTFLD(RCDT      )
     D HBRCA2        E                     EXTFLD(BRCA      )
     D HCNUM2        E                     EXTFLD(CNUM      )
     D HLNRF2        E                     EXTFLD(LNRF      )
     D HVDAT2        E                     EXTFLD(VDAT      )
     D HPRSQ2        E                     EXTFLD(PRSQ      )
     D HLASN2        E                     EXTFLD(LASN      )
     D HFCUS2        E                     EXTFLD(FCUS      )
     D HFTYP2        E                     EXTFLD(FTYP      )
     D HFSEQ2        E                     EXTFLD(FSEQ      )
     D HPTYP2        E                     EXTFLD(PTYP      )
     D HCCY2         E                     EXTFLD(CCY       )
     D HAMTP2        E                     EXTFLD(AMTP      )
     D HPRAM2        E                     EXTFLD(PRAM      )
     D HLTYP2        E                     EXTFLD(LTYP      )
     D HSUTP2        E                     EXTFLD(SUTP      )
     D HLCD2         E                     EXTFLD(LCD       )
     D HZZ0012       E                     EXTFLD(ZZ001     )
     D HCPAM2        E                     EXTFLD(CPAM      )
     D HAITC2        E                     EXTFLD(AITC      )
     D HINTR2        E                     EXTFLD(INTR      )
     D HAIAP2        E                     EXTFLD(AIAP      )
     D HIPRD2        E                     EXTFLD(IPRD      )
     D HACDA2        E                     EXTFLD(ACDA      )                                 157669
     D HCOFR2        E                     EXTFLD(COFR      )                                 157669
     D HACAP2        E                     EXTFLD(ACAP      )                                 157669
     D HCOFD2        E                     EXTFLD(COFD      )                                 157669
     D HAITN2        E                     EXTFLD(AITN      )                                 CPK016
     D HAIAN2        E                     EXTFLD(AIAN      )                                 CPK016
     D HIPRN2        E                     EXTFLD(IPRN      )                                 CPK016
     D HFSPRAM2      E                     EXTFLD(FSPRAM    )                                 CPK016
     D HFSCPAM2      E                     EXTFLD(FSCPAM    )                                 CPK016
     D HCLAS2        E                     EXTFLD(CLAS      )                                 CLE042
     D HREPT2        E                     EXTFLD(REPT      )                                 CLE154
      **   Format for PF/HISTSHQ
     D HISTSHQds     E DS                  EXTNAME(HISTSHQ)
     D                                     PREFIX(H)
     D HRECI3        E                     EXTFLD(RECI      )
     D HRCDT3        E                     EXTFLD(RCDT      )
     D HBRCA3        E                     EXTFLD(BRCA      )
     D HCNUM3        E                     EXTFLD(CNUM      )
     D HLNRF3        E                     EXTFLD(LNRF      )
     D HVDAT3        E                     EXTFLD(VDAT      )
     D HPRSQ3        E                     EXTFLD(PRSQ      )
     D HLASN3        E                     EXTFLD(LASN      )
     D HFCUS3        E                     EXTFLD(FCUS      )
     D HFTYP3        E                     EXTFLD(FTYP      )
     D HFSEQ3        E                     EXTFLD(FSEQ      )
     D HPTYP3        E                     EXTFLD(PTYP      )
     D HCCY3         E                     EXTFLD(CCY       )
     D HAMTP3        E                     EXTFLD(AMTP      )
     D HBRTT3        E                     EXTFLD(BRTT      )
     D HBRTE3        E                     EXTFLD(BRTE      )
     D HRTSP3        E                     EXTFLD(RTSP      )
     D HSPIN3        E                     EXTFLD(SPIN      )
     D HCALC3        E                     EXTFLD(CALC      )
     D HLCD3         E                     EXTFLD(LCD       )
     D HZZ0013       E                     EXTFLD(ZZ001     )
     D HFSRP3        E                     EXTFLD(FSRP      )
     D HFSGN3        E                     EXTFLD(FSGN      )
     D HFPRC3        E                     EXTFLD(FPRC      )
     D HCPAM3        E                     EXTFLD(CPAM      )
     D HAITC3        E                     EXTFLD(AITC      )
     D HINTR3        E                     EXTFLD(INTR      )
     D HAIAP3        E                     EXTFLD(AIAP      )
     D HIPRD3        E                     EXTFLD(IPRD      )
     D HMNSG3        E                     EXTFLD(MNSG      )
     D HACDA3        E                     EXTFLD(ACDA      )                                 157669
     D HCOFR3        E                     EXTFLD(COFR      )                                 157669
     D HACAP3        E                     EXTFLD(ACAP      )                                 157669
     D HCOFD3        E                     EXTFLD(COFD      )                                 157669
     D HAITN3        E                     EXTFLD(AITN      )                                 CPK016
     D HAIAN3        E                     EXTFLD(AIAN      )                                 CPK016
     D HIPRN3        E                     EXTFLD(IPRN      )                                 CPK016
     D HFSCPAM3      E                     EXTFLD(FSCPAM    )                                 CPK016
     D HOCDT3        E                     EXTFLD(OCDT      )                                 CLE148
     D HEAIR3        E                     EXTFLD(EAIR      )                                 CLE148
     D HCNSP3        E                     EXTFLD(CNSP      )                                 CLE148
     D HCNSG3        E                     EXTFLD(CNSG      )                                 CLE148
     D HRDMT3        E                     EXTFLD(RDMT      )                                 CLE148
     D HRDFD3        E                     EXTFLD(RDFD      )                                 CLE148
      **   Format for Information DS for LF/PLHISTL0
     D PLHISTds        DS
     D   @KFormat            261    270

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters
      **   Parameters for ProcFormat
     D   InData        S                   LIKE(TransData) INZ(*Blanks)
     D   InDBFile      S             10A   INZ(*Blanks)
     D   InDecSep      S              1A   INZ('.')
     D   InShwPosSn    S              1A   INZ('N')
      **   Key to LF/CLOAN, LF/PLHISTL0 and LF/PLLOAML0.
     D@KCLOANds        DS
     D @KLNRFA                 1      6    INZ(*Blanks)
     D*@KLNRF***               1      6S 0 INZ(*Zeros)                                        CLE148
     D @KLNRF                  1      6    INZ(*BLANKS)                                       CLE148
     D @KRCDT          S                   LIKE(LRCDT1) INZ(*Zeros)
     D @KPRSQ          S                   LIKE(APRSQ) INZ(*Zeros)
     D @KVDAT          S                   LIKE(AVDAT) INZ(*Zeros)
     D @KAMTP          S                   LIKE(AAMTP) INZ(*Zeros)
      **   Work fileds for appending to PF/CLOANCL.
     D WrkPdueIn       S              1A   INZ('N')
     D WrkInsAmd       S              1A   INZ(*Blanks)
      **   Output queue name
     D OutQueue2       S                   LIKE(MQSQueue)

     DOutParms         DS
     D   OutData                           LIKE(TransData) INZ(*BLANKS)
     D   OutLen                       4S 0 INZ(*ZERO)
     DLonParms         DS
     D   LonData                           LIKE(TransData) INZ(*BLANKS)
     D   LonLen                       4S 0 INZ(*ZERO)
     DWrkParms         DS
     D   WrkData                           LIKE(TransData) INZ(*BLANKS)
     D   WrkLen                            LIKE(OutLen) INZ(*ZERO)

     D CPL005          S              1A                                                      CPL005
     D @Op_Code        S              1A                                                      CPL005
     D @SARD           S              6A                                                      CPL005
     D @OPTN           S              7A   INZ(*BLANKS)                                       CPL005
     D @RTCD           S              7A   INZ(*BLANKS)                                       CPL005
                                                                                              CPL005
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************

     ICLOANCLF
     I              RECI                        LRECI1
     I              LNRF                        LLNRF1
     I              RCDT                        LRCDT1
     I              MRIN                        LMRIN1
     I              ORED                        LORED1
     I              LCD                         LLCD1
     I              CHTP                        LCHTP1
     I              TNLU                        LTNLU1

     ICLOANCKF
     I              RECI                        LRECI2
     I              LNRF                        LLNRF2
     I              RCDT                        LRCDT2
     I              MRIN                        LMRIN2
     I              ORED                        LORED2
     I              LCD                         LLCD2
     I              CHTP                        LCHTP2
     I              TNLU                        LTNLU2

     IHISTSHMF
     I              RECI                        HRECI1
     I              RCDT                        HRCDT1
     I              BRCA                        HBRCA1
     I              CNUM                        HCNUM1
     I              LNRF                        HLNRF1
     I              VDAT                        HVDAT1
     I              PRSQ                        HPRSQ1
     I              LASN                        HLASN1
     I              FCUS                        HFCUS1
     I              FTYP                        HFTYP1
     I              FSEQ                        HFSEQ1
     I              PTYP                        HPTYP1
     I              CCY                         HCCY1
     I              AMTP                        HAMTP1
     I              PRAM                        HPRAM1
     I              BRTT                        HBRTT1
     I              BRTE                        HBRTE1
     I              RTSP                        HRTSP1
     I              SPIN                        HSPIN1
     I              CALC                        HCALC1

     IHISTSHPF
     I              RECI                        HRECI2
     I              RCDT                        HRCDT2
     I              BRCA                        HBRCA2
     I              CNUM                        HCNUM2
     I              LNRF                        HLNRF2
     I              VDAT                        HVDAT2
     I              PRSQ                        HPRSQ2
     I              LASN                        HLASN2
     I              FCUS                        HFCUS2
     I              FTYP                        HFTYP2
     I              FSEQ                        HFSEQ2
     I              PTYP                        HPTYP2
     I              CCY                         HCCY2
     I              AMTP                        HAMTP2
     I              PRAM                        HPRAM2
     I              LTYP                        HLTYP2
     I              SUTP                        HSUTP2
     I              LCD                         HLCD2
     I              ZZ001                       HZZ002
     I              CPAM                        HCPAM2
     I              AITC                        HAITC2
     I              INTR                        HINTR2
     I              AIAP                        HAIAP2
     I              IPRD                        HIPRD2

     IHISTSHQF
     I              RECI                        HRECI3
     I              RCDT                        HRCDT3
     I              BRCA                        HBRCA3
     I              CNUM                        HCNUM3
     I              LNRF                        HLNRF3
     I              VDAT                        HVDAT3
     I              PRSQ                        HPRSQ3
     I              LASN                        HLASN3
     I              FCUS                        HFCUS3
     I              FTYP                        HFTYP3
     I              FSEQ                        HFSEQ3
     I              PTYP                        HPTYP3
     I              CCY                         HCCY3
     I              AMTP                        HAMTP3
     I              BRTT                        HBRTT3
     I              BRTE                        HBRTE3
     I              RTSP                        HRTSP3
     I              SPIN                        HSPIN3
     I              CALC                        HCALC3
     I              LCD                         HLCD3
     I              ZZ001                       HZZ0013
     I              FSRP                        HFSRP3
     I              FSGN                        HFSGN3
     I              FPRC                        HFPRC3
     I              CPAM                        HCPAM3
     I              AITC                        HAITC3
     I              INTR                        HINTR3
     I              AIAP                        HAIAP3
     I              IPRD                        HIPRD3
     I              MNSG                        HMNSG3
      /EJECT

      ** +--------------------------------------+
      ** ¦ Start F-specs                        ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

     C* Reset Message parameters
     C                   Reset                   OutParms
     C                   Reset                   WrkParms
     C                   Reset                   LonParms

     C* Extract the Loan Number from the data input.

     C                   Eval      @KLNRFA = %subst(TransData:24:6)
     C                   Eval      @KRCDT  = 'A'

     C* Access original record on PF/CLOANCL.

     C     @KCLOAN       Chain     CLOANCLF                           90

      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf

     C* Format the data from PF/CLOANCL for Meridian.

     C                   Eval      InData   = CLOANCLds
     C                   Eval      InDBFile = 'CLOANCL   '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)

     C* Contruct the compound message format.

     C                   Eval      LonParms = OutParms

     C* Access original record on PF/CLOANCK.

     C                   Eval      @KRCDT  = 'B'

     C* Access original record on PF/CLOANCK.

     C     @KCLOAN       Chain     CLOANCKF                           90

      ** If error then perform any special processing and exit
     C                   If        *IN90 <> '0'
     C                   Exsr      *PSSR
     C                   EndIf

     C* Access history record for original principal amount on loan, or last
     C*   principal amount for currency if there has been a multi-currency
     C*   rollover.

     C* If there has not be a multi-currency rollover, access the start date
     C*   history record.
     C                   If        (LLMCD = 0) Or (LLMCD = LVDAT)

     C                   Eval      @KPRSQ = 06
     C                   Eval      @KVDAT = LVDAT

     C     @KPLHIST      Chain     HISTSHMF                           90

     C* If the history record is not found, use the current principal.
     C                   If        *IN90 <> '0'
     C                   If        LOPAM = 0
     C                   Eval      LOPAM = LCPAM
     C                   EndIf
     C                   Else

     C* Override the Original Principal Amount to the amount on the history.
     C                   Eval      LOPAM  = HPRAM1
     C                   EndIf

     C* Otherwise, access the last multi-currency rollover history record.
     C                   Else

     C                   Eval      @KPRSQ = 25
     C                   Eval      @KVDAT = *Hival

     C     @KPLHIST      SetGt     HISTSHQF
     C                   ReadP     HISTSHQF                               90

     C* If the history record is not found, use the current principal.
     C                   If        (*IN90 <> '0') Or (HLNRF3 > @KLNRF)
     C                   If        LOPAM = 0
     C                   Eval      LOPAM = LCPAM
     C                   EndIf
     C                   Else

     C* Override the Original Principal Amount to the amount on the history.
     C                   Select
     C     HPRINRO       WhenNe    *Zero
     C                   Eval      LOPAM  = HPRINRO
     C     HDISCRO       WhenNe    *Zero
     C                   Eval      LOPAM  = HDISCRO
     C                   Other
     C                   Eval      LOPAM  = HCPAM3
     C                   EndSl

     C                   EndIf

     C                   EndIf

     C* Format the data from PF/CLOANCK for Meridian.

     C                   Eval      InData   = CLOANCKds
     C                   Eval      InDBFile = 'CLOANCK   '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)

     C* Contruct the compound message format.

     C                   Eval      %subst(LonData:LonLen) = OutData
     C                   Eval      LonLen = LonLen + OutLen

     C* Check to see whether loan is "Past Due".
     C                   Eval      @KAMTP = 'PD'
     C     @KPLLOAM      SetLl     LOAMSDKF                               90

     C                   If        *IN90 = '1'
     C                   Eval      WrkPdueIn = 'Y'
     C                   Else
     C                   Eval      WrkPdueIn = 'N'
     C                   EndIf

     C* Contruct the compound message format.
     C                   Eval      LonLen = LonLen - 1
     C                   Eval      %subst(LonData:LonLen) = WrkPdueIn
     C                   Eval      LonLen = LonLen + 1

     C* Set Insert/Amend Indicator to "I" for "Insert".
     C                   Eval      WrkInsAmd = 'I'

     C* Contruct the compound message format.
     C                   Eval      %subst(LonData:LonLen) = WrkInsAmd

     C                   Eval      WrkData  = LonData

     C* Send the message for LELNLLNK.

     C                   Eval      RAMSGTYPE=('LELNLLNK_A')
     C                   Exsr      #SNDMSG
      *                                                                                       CPL005
      ** If Real-time infterface is present, then only output message                         CPL005
      ** format LEAMDLON, LEHSPLON and LEHSQLON for operation code                            CPL005
      ** equal to 'I' or 'A'                                                                  CPL005
      *                                                                                       CPL005
     C                   EVAL      @Op_Code = %SUBST(TransData:1:1)                           CPL005
                                                                                              CPL005
     C                   IF        CPL005 = 'N' OR                                            CPL005
     C                             (CPL005 = 'Y' and                                          CPL005
     C                             (@Op_Code = 'I' or @Op_Code = 'A'))                        CPL005

     C* Read all Loan Amendments from LF/PLLOAML0.

     C     @KLNRF        SetLl     LOAMSDKF
     C     @KLNRF        ReadE     LOAMSDKF                               80

     C     *IN80         DowEq     '0'

     C                   Eval      InData   = LOAMSDKds
     C                   Eval      InDBFile = 'LOAMSDK   '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)

     C* Output a message for the compound message format.

     C                   Reset                   WrkData
     C                   Eval      WrkData  = OutData
     C                   Eval      %subst(WrkData:OutLen) = LonData

     C* Send the message for LEAMDLON.

     C                   Eval      RAMSGTYPE=('LEAMDLON_A')
     C                   Exsr      #SNDMSG

     C     @KLNRF        ReadE     LOAMSDKF                               80
     C                   EndDo

     C* Read all Loan History from LF/PLHISTL0.

     C     @KLNRF        SetLl     PLHISTL0
     C     @KLNRF        ReadE     PLHISTL0                               80

     C     *IN80         DowEq     '0'

     C     @KFormat      IfEq      'HISTSHPF  '
     C                   Eval      InData   = HISTSHPds
     C                   Eval      InDBFile = 'HISTSHP   '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
     C                   Eval      RAMSGTYPE=('LEHSPLON_A')
     C                   EndIf

     C     @KFormat      IfEq      'HISTSHQF  '
     C                   Eval      InData   = HISTSHQds
     C                   Eval      InDBFile = 'HISTSHQ   '
     C                   Eval      OutParms = ProcFormat(InData:InDBFile:
     C                                                   InDecSep:InShwPosSn)
     C                   Eval      RAMSGTYPE=('LEHSQLON_A')
     C                   EndIf

     C     @KFormat      IfEq      'HISTSHPF  '
     C     @KFormat      OrEq      'HISTSHQF  '

     C* Output a message for the compound message format.

     C                   Reset                   WrkData
     C                   Eval      WrkData  = OutData
     C                   Eval      %subst(WrkData:OutLen) = LonData

     C* Send the message for LEHSPLON or LEHSQLON.

     C                   Exsr      #SNDMSG

     C                   EndIf

     C     @KLNRF        ReadE     PLHISTL0                               80
     C                   EndDo

     C* Set Insert/Amend Indicator to "A" for "Amend".
     C                   Eval      WrkInsAmd = 'A'

     C* Contruct the compound message format.
     C                   Eval      %subst(LonData:(LonLen)) = WrkInsAmd

     C                   Eval      WrkData  = LonData

     C* Send the message for LELNLLNK.

     C                   Eval      RAMSGTYPE=('LELNLLNK_A')
     C                   Exsr      #SNDMSG
                                                                                              CPL005
     C                   ENDIF                                                                CPL005

     C* Return control at the end of the processing for the message.

     C                   Commit
     C**********         Seton                                        LR        177415
     C                   Return

      *****************************************************************
      /EJECT
      **********************************************************************
      **                                                                  **
      ** SR/#SNDMSG - Send Meridian Message to MQ Queue                   **
      ** ==========                                                       **
      ** Parameters:                                                      **
      ** ===========                                                      **
      **  In : OutQueue     48A  Name of MQ message queue for output.     **
      **       MdnHeadDS   138A  Meridian header details (PF/RPMDHDPD)    **
      **       CompData   5000A  Meridian message data.                   **
      **       CommitCtl     1A  Indicator for Commitment Control (Y/N)   **
      **                                                                  **
      **  Out: ReturnCode   10A  Return code from sending MQ message      **
      **                                                                  **
      ** Description:                                                     **
      ** ============                                                     **
      **  Receive above parameters and write message to Meridian MQ       **
      **   message queue. If error, dump program.                         **
      **                                                                  **
      **********************************************************************

     C     #SNDMSG       Begsr

     C* Set up the Operation and Table fields on the message.

     C                   Eval      CompData =  %subst(TransData:1:20)
     C                   Eval      %subst(CompData:21) = WrkData

     C* Call a standard routine to actually send the message
     C                   CallB     'RPSNDMSG'
     C                   Parm      OutQueue1     OutQueue2
     C                   Parm                    MdnHeadDS
     C                   Parm                    CompData
     C                   Parm                    CommitCtl
     C                   Parm                    ReturnCode

      ** If error then perform any special processing and exit
     C                   If        ReturnCode <> *blank
     C                   Exsr      *PSSR
     C                   EndIf

     C     #SNDMSGEnd    Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         Begsr

      ** If error in RP1155, set Return Code accordingly.
     C                   If        ReturnCode = *blank
     C                   Eval      ReturnCode = ('ErrRP1155')
     C                   EndIf

     C     @RUN          IfEq      *BLANK
     C                   Move      'Y'           @RUN              1
     C                   Dump
     C                   EndIf

     C                   SetOn                                        U7U8LR
     C                   Return

     C                   Endsr
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * MQSeries queue to write to - this parameter IS used in this module
     C                   PARM                    OutQueue1        48
      * Merdian header
     C                   PARM                    MdnHeadDS
      * Transaction Data
     C                   PARM                    TransData
      * Commitment control flag
     C                   PARM                    CommitCtl
      * Return Code
     C                   PARM                    ReturnCode

     C* Key list for LF/INVTP.
     C     @KCLOAN       KLIST
     C                   KFLD                    @KLNRF
     C                   KFLD                    @KRCDT

     C* Key list for LF/PLHISTL0
     C     @KPLHIST      KLIST
     C                   KFLD                    @KLNRF
     C                   KFLD                    @KPRSQ
     C                   KFLD                    @KVDAT

     C* Key list for LF/PLLOAML0
     C     @KPLLOAM      KLIST
     C                   KFLD                    @KLNRF
     C                   KFLD                    @KAMTP
      *                                                                                       CPL005
      ** Check if Midas-Plato Real-time Interface is on.                                      CPL005
      *                                                                                       CPL005
     C                   CALLB     'AOSARDR0'                                                 CPL005
     C                   PARM      *BLANKS       @RTCD                                        CPL005
     C                   PARM      '*VERIFY'     @OPTN                                        CPL005
     C                   PARM      'CPL005'      @SARD                                        CPL005
      *                                                                                       CPL005
     C     @RTCD         IFEQ      *BLANK                                                     CPL005
     C                   MOVE      'Y'           CPL005                                       CPL005
     C                   ELSE                                                                 CPL005
     C                   MOVE      'N'           CPL005                                       CPL005
     C                   ENDIF                                                                CPL005

     C                   ENDSR
      *****************************************************************
