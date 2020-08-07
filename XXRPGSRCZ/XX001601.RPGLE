     H DEBUG
     H COPYRIGHT('(c) Finastra  International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Manual Journal Interface')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  XX001601 - Midas GL Manual Journal Interface                 *
      *                                                               *
      *  Function: This program only process batches coming from      *
      *            Finance department via Journal Upload tool as      *
      *            batches are sent with 'held' status                *
      *                                                               *
      *  (c) Finastra  International Limited 2018                     *
      *                                                               *
      *  Last Amend No. FVT104  *CREATE    Date 11Dec18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT104 - 4-Eyes Principle for Journal Upload Tool.           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** GL journal entry header interface
     FGLJEIHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BRREAH:GLBRREAH)
      ** GL journal entry header interface
     FGLJEIPL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** GL journal entry header
     FGLJENHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(G_)
      ** GL journal entry header
     FGLJEHQL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Q_)
      *
     FGlJenSL1  IF   E           K DISK    Infsr(*Pssr)
     F                                     Rename(@BSREAJ:@JensL1)
     F                                     Prefix(G_)
      ** GL journal entry currency summary file
      *
      ** GL journal entry Report
     FGL001601P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
      *
      ** GL journal Postings Audit
     FGL001601AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     F                                     USROPN
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR    - Program Initialisation Routine                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *  SRMain  - Main processing                                    *
      *  SRProceBcno- Processing for batch                            *
      *  SRBrchDtl-Access Branch Details                              *
      *  SRDeptCode- Access department code                           *
      *  SRWrite - Write the values to the fields of file GLJENHL1    *
      *  SRErrChk- Check for error and print the record in P1         *
      *  SRPrint - Print the record in P1                             *
      *  SRAudit - Write the report in AU (Audit)                     *
      *  SRZSfile- Process Report Lines                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
      /COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D SDUSER        E DS                  EXTNAME(MUSERDD)
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)
      *
      ** File Information Data Structure for GL001601P1
      *
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** File Information Data Structure for GL001600AU
      *
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
     DPBatchParm       DS           200
     D WMode                          1A   INZ('E')
     D WBatchNum                      3A   INZ(*BLANKS)
     D WErrorFlag                     1A   INZ(*BLANKS)
     D WTotalInt                     15A   INZ(*BLANKS)
     D WTotalDecimal                  3A   INZ(*BLANKS)
     D WTotalItems                    3A   INZ(*BLANKS)
     D WHeadBranch                    3A   INZ(*BLANKS)
      *
      ** Array for the error
      *
     D ErrFlg          S              1A   DIM(3)
     D Err_Dtl         S             25A   DIM(4) CTDATA PERRCD(1)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Program Variables used
      *
     D PRtncd          S              7A   INZ(*BLANKS)
     D POptn           S              7A   INZ(*BLANKS)
     D PBrca           S              3A   INZ(*BLANKS)
     D PSeq            S              5A   INZ(*BLANKS)
     D PSenty          S              3A   INZ(*BLANKS)
     D PZSerr          S              1A   INZ(*BLANKS)
     D PSbcno          S                   LIKE(BRBTNB)
     D PDept           S                   LIKE(BRDPCD)
      ** Parameters for call to AOSARDRO
      *
     D PSard           S              6A
     D PRTCD           S              7A
      *
     D CGL016          S              1A
      *
     D PBTNB           S              3A
      *
      ** Parameter Variables to call 'AOSVALR0'
      *
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A
      *
     D ZSfile          S             10A   INZ(*BLANKS)
     D ZSnum           S              6B 0 INZ(0)
      *
     D KBcno           S                   LIKE(BRBTNB)
      *
      ** Work variables used in the program
      *
     D WPrtCnt         S              1A   INZ(*BLANKS)
     D WOBcno          S                   LIKE(BRBTNB)
     D WFirst          S              1A   INZ(*BLANKS)
     D WKBcno          S                   LIKE(BRBTNB)
     D WCnt            S              1P 0 INZ(1)
     D WRqdln          S              1B 0
     D WDifl           S              2B 0
     D WBcno           S              3P 0
     D WValidCnt       S              6P 0
     D WInValidCnt     S              6P 0
     D WTotProcesd     S              6P 0
     D WTotalItemP     S              3P 0
     D WTotalIntP      S             15P 0
     D WTotalDecimalP  S              3P 0

     D W_SavCcy        S                   Like(G_BsCyCd)
     D W_TotDrAmt      S                   Like(G_BsDbTt)
     D W_TotCrAmt      S                   Like(G_BsCrTt)

      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D L_CD          E                     EXTFLD(LCD)

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically:the *INZSR is¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      SRMain
      *
      ** End the program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMain - Processing subroutine                                *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SRProcsBcno, SRAudit                                   *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
     C     *LOVAL        SETLL     GLJEIHL1
     C                   READ      GLJEIHL1
      *
     C                   DOW       NOT %EOF(GLJEIHL1)
      *
      ** Process only those from SWITI, i.e. BRBTSF is 'held' status
      *
     C                   IF        BRBTSF <> *Blanks
      *
      ** Reset the values
      *
     C                   CLEAR                   ErrFlg
     C                   EVAL      KBcno  = BRBTNB
     C                   EVAL      PRtncd = *BLANKS
     C                   EVAL      WOBcno = BRBTNB
     C                   EVAL      PSbcno = *BLANKS
     C                   EVAL      WCnt = 1
      *
      ** Processing for the validation of batch numbers
      *
     C     KBcno         CHAIN     GLJEIPL1
     C                   IF        %FOUND(GLJEIPL1)
     C                   EXSR      SRProcsBcno
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      GLJEIHL1
     C                   ENDDO
      *
      ** Write the report in AU
      *
     C                   EXSR      SRAudit
      *
      ** Close the Spool Files
      *
     C                   IF        %OPEN(GL001601P1)
     C                   CLOSE     GL001601P1
     C                   ENDIF
      *
     C                   IF        %OPEN(GL001601AU)
     C                   CLOSE     GL001601AU
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcsBcno - Processing for the validation of the batch no.  *
      *                                                               *
      * Called by: SRMain                                             *
      *                                                               *
      * Calls: SRBrchDtl, SRDeptCode, SRErrChk, SRWrite               *
      *                                                               *
      *****************************************************************
     C     SRProcsBcno   BEGSR
      *
      ** Access branch details
      *
     C                   EXSR      SRBrchDtl
      *
     C                   IF        PRtncd <> *BLANKS
     C                   MOVEA     'Y'           ErrFlg(1)
     C                   ENDIF
      *
      ** Access department codes
      *
     C                   EXSR      SRDeptCode
      *
     C                   IF        PRtncd <> *BLANKS
     C                   MOVEA     'Y'           ErrFlg(2)
     C                   ENDIF
      *
     C     KBcno         CHAIN(N)  GLJENHL1
      *
     C                   IF        NOT %FOUND(GLJENHL1)
      *
      ** Check if batch number is reached upto old batch number, means
      ** no batch number is free from 001 to 999. Hence an error
      *
     C                   IF        KBcno = '999'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WTotalItemP = *ZEROS
     C                   EVAL      WTotalIntP = *ZEROS
     C                   EVAL      WTotalDecimalP = *ZEROS
     C                   EVAL      WBatchNum   = KBcno
     C                   EVAL      WHeadBranch = BRBCDA
     C                   EVAL      WErrorFlag = 'N'
      *
     C                   CALL(E)   'GL0150U'
     C                   PARM                    WOBcno
     C                   PARM                    PSbcno
     C                   PARM                    PBatchParm
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WTotalItems   WTotalItemP
     C                   MOVE      WTotalInt     WTotalIntP
     C                   MOVE      WTotalDecimal WTotalDecimalP
      *
     C                   IF        WErrorFlag = 'Y' OR
     C                             BRHINI <> WTotalItemP OR
     C                             BRHIIN <> WTotalIntP OR
     C                             BRHDIN <> WTotalDecimalP
     C                   MOVEA     'Y'           ErrFlg(3)
     C                   ENDIF
      *
      ** Check for error and print the record in P1
      *
     C                   EXSR      SRErrChk
      *
      ** If Branch is in Error, this cannot be repaired and therefore
      ** there is no need to write it on the file anymore

     C                   IF        ErrFlg(1) <> 'Y'
     C                   EXSR      SRWrite
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBrchDtl - Access Branch Details                             *
      *                                                               *
      * Called by: SRProcsBcno                                        *
      *                                                               *
      * Calls:   AOBRCHR0                                             *
      *                                                               *
      *****************************************************************
     C     SRBrchDtl     BEGSR
      *
      ** Access branch details
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     PRtncd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRBCDA        PBrca
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDeptCode - Access department code                           *
      *                                                               *
      * Called by: SRProcsBcno                                        *
      *                                                               *
      * Calls:   AODEPTR0                                             *
      *                                                               *
      *****************************************************************
     C     SRDeptCode    BEGSR
      *
      ** Access department code
      *
     C                   CALL      'AODEPTR0'
     C                   PARM      '*BLANKS '    PRtncd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRDPCD        PDept
     C     SDDEPT        PARM      SDDEPT        DSFDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurrencies - Check currencies are in balance               *
      *                                                               *
      *  Called by: SrWrite                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCurrencies  Begsr

     C     KGlJenSL1r    KList
     C                   KFld                    G_BsBtNb

     C                   Clear                   W_SavCcy
     C                   Clear                   W_TotDrAmt
     C                   Clear                   W_TotCrAmt

     C                   Eval      G_BsBtNb = KBcNo
     C     KGlJenSL1r    Setll     @JensL1
     C     KGlJenSL1r    Reade     @JensL1
     C                   If        Not %Eof(GlJensL1)

      * Initialise save currency
     C                   Eval      W_SavCcy = G_BsCyCd

     C                   DoU       %Eof(GlJensL1)

      * If debit credit not equal do not accept
     C                   If        G_BsCyCd   <> W_SavCcy
     C                   If        W_TotDrAmt <> W_TotCrAmt
     C                   Eval      ErrFlg(3) = 'Y'
     C                   Eval      BrBtSf = 'H'
     C                   Leave
     C                   Endif

      * Reset work fields
     C                   Eval      W_SavCcy = G_BsCyCd
     C                   Clear                   W_TotDrAmt
     C                   Clear                   W_TotCrAmt

     C                   Endif

     C                   Eval      W_TotDrAmt =  W_TotDrAmt +  G_BsDbTt
     C                   Eval      W_TotCrAmt =  W_TotCrAmt +  G_BsCrTT

     C     KGlJenSL1r    Reade     @JensL1
     C                   Enddo

      * End of file with data - test again
     C                   If        W_TotDrAmt <> W_TotCrAmt
     C                   Eval      ErrFlg(3) = 'Y'
     C                   Eval      BrBtSf = 'H'
     C                   Endif

     C                   Endif

     C     ExCurrencies  Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite -  Write the values to the fields of file GLJENHL1    *
      *                                                               *
      * Called by: SRProcsBcno                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
      *
      ** Write the values to the fields of file GLJENHL1
      ** for error in processing
      *
     C                   IF        ErrFlg(2) = *BLANKS AND
     C                             ErrFlg(3) = *BLANKS
     C                   EVAL      G_BRVALI = 'Y'
     C                   MOVE      WTotalInt     G_BRHIIN
     C                   MOVE      WTotalDecimal G_BRHDIN
     C                   MOVE      WTotalItems   G_BRHINI
     C                   EVAL      WValidCnt = WValidCnt + 1
      *
      ** Write the values to the fields of file GLJENHL1
      ** for valid Branch or no error in processing
      *
     C                   ELSE
     C                   EVAL      G_BRVALI = 'N'
     C                   EVAL      G_BRHIIN = BRHIIN
     C                   EVAL      G_BRHDIN = BRHDIN
     C                   EVAL      G_BRHINI = BRHINI
     C                   EVAL      BRBTSF = 'H'
     C                   EVAL      WInValidCnt = WInValidCnt + 1
     C                   ENDIF
      *
      ** Set Hash integer, decimal, item calculated
      *
     C                   MOVE      WTotalInt     BRHICC
     C                   MOVE      WTotalDecimal BRHDCC
     C                   MOVE      WTotalItems   BRHINC
      *
      ** Override status with the system value

     C                   IF        PSVal1 <> *BLANKS
     C                             AND BRBTSF = *BLANKS
      *
     C                   EVAL      BRBTSF = PSVal1
     C                   ENDIF

     C                   IF        %LOOKUP('Y':ErrFlg) <> 0
     C                   EVAL      BRBTSF = 'H'
     C                   ENDIF

      *
      ** If to be accepted check currencies in balance
      *
     C                   If        BrBtSf <> 'H'
     C                   Exsr      SrCurrencies
     C                   Endif

     C                   EVAL      G_BRBTNB = KBCNO
     C                   EVAL      G_BRBCDA = BRBCDA
     C                   EVAL      G_BRDPCD = BRDPCD
     C                   EVAL      G_BRWSID = BRWSID
     C                   EVAL      G_BRHICC = BRHICC
     C                   EVAL      G_BRHDCC = BRHDCC
     C                   EVAL      G_BRHINC = BRHINC
     C                   EVAL      G_BRBTSF = BRBTSF
     C                   EVAL      G_BRBIUF = BRBIUF
     C                   EVAL      G_BRSHPI = BRSHPI
     C                   EVAL      G_BRRAPI = BRRAPI
     C                   EVAL      G_BRMBRB = BRMBRB
     C                   EVAL      G_BRRVVD = BRRVVD
     C                   EVAL      G_BRBDES = BRBDES
     C                   EVAL      G_BRSPTT = BRSPTT
     C                   EVAL      G_BRNIST = BRNIST
     C                   EVAL      G_BRSPRF = BRSPRF
     C                   EVAL      G_BRDCIN = BRDCIN
     C                   EVAL      G_BRIBCF = BRIBCF
     C                   EVAL      G_BRCUSF = BRCUSF
     C                   EVAL      G_BRCYCF = BRCYCF
     C                   EVAL      G_BRACCF = BRACCF
     C                   EVAL      G_BRACSF = BRACSF
     C                   EVAL      G_BRNNBF = BRNNBF
     C                   EVAL      G_BRRACF = BRRACF
     C                   EVAL      G_BRPRCF = BRPRCF
     C                   EVAL      G_BRAMTF = BRAMTF
     C                   EVAL      G_BRIBCT = BRIBCT
     C                   EVAL      G_BRCYCT = BRCYCT
     C                   EVAL      G_BRCNAT = BRCNAT
     C                   EVAL      G_BRACCT = BRACCT
     C                   EVAL      G_BRASNT = BRASNT
     C                   EVAL      G_BRNNBT = BRNNBT
     C                   EVAL      G_BRRACT = BRRACT
     C                   EVAL      G_BRTOJE = BRTOJE
     C                   EVAL      G_BRUSRI = *BLANKS
     C                   EVAL      G_BRUSRI = USRP
     C                   EVAL      G_BRUSRA = *BLANKS
     C                   EVAL      G_BRFRNT = *BLANKS
     C                   EVAL      G_BRAFRT = *BLANKS
     C                   EVAL      G_BRTMST = *LOVAL
     C                   EVAL      G_BRBHAI = BRBTSF
     C                   EVAL      G_BRACCF = *BLANKS
     C                   EVAL      G_BRACCT = *BLANKS
     C                   EVAL      G_BRMEAB = *BLANKS
     C                   EVAL      G_BRAUTH = *BLANKS
      *
     C                   WRITE(E)  @BRREAH
      *
     C                   EVAL      Q_HQBTCH = BRBTNB
     C                   EVAL      Q_HQBRCD = BRBCDA
     C                   EVAL      Q_HQFRID = *BLANKS
     C                   EVAL      Q_HQJETP = 'R'
      *
     C                   WRITE(E)  GLJEHQD0
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If batch status is accepted, submit batch for shadow posting
      *
     C                   IF        (BRBTSF = 'A') AND
     C                             (BRSHPI <> 'Y') AND
     C                             (CGL016 <> 'Y')
     C                   CALL      'GLSBMBCH'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      BRBTNB        PBTNB
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRErrChk -  Check for error and print the record in P1        *
      *                                                               *
      * Called by: SRProcsBcno                                        *
      *                                                               *
      * Calls: SRZSfile, SRPrint                                      *
      *                                                               *
      *****************************************************************
     C     SRErrChk      BEGSR
      *
     C                   EVAL      WPrtCnt = *BLANKS
     C                   EVAL      *IN30 = *OFF
      *
      ** Ensure Detail Spool File recorded by RCF
      *
     C                   IF        NOT %OPEN(GL001601P1)
     C                   OPEN      GL001601P1
     C                   EVAL      WFirst = 'Y'
      *
     C                   EVAL      ZSfile = SFILE1
     C                   EVAL      ZSnum  = SFNUM1
      *
     C                   EXSR      SRZSfile
     C                   ENDIF
      *
      ** Generate the P1 report
      *
     C                   IF        %LOOKUP('Y':ErrFlg) = 0
      *
     C                   EVAL      RBSTAT = Err_Dtl(4)
     C                   EXSR      SRPrint
      *
     C                   ELSE
      *
     C                   DOW       WCnt <= 3
     C                   EVAL      WCnt = %LOOKUP('Y':ErrFlg:WCnt)
      *
     C                   IF        WCnt<>0
     C
     C                   IF        WPrtCnt = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
      *
     C                   EVAL      RBSTAT = Err_Dtl(WCnt)
     C                   EXSR      SRPrint
     C                   EVAL      WPrtCnt = 'Y'
     C                   EVAL      WCnt = WCnt + 1
      *
     C                   ELSE
     C                   LEAVE
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint -  Print the record in P1                             *
      *                                                               *
      * Called by: SRErrChk                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPrint       BEGSR
      *
     C                   IF        *IN30 = *OFF
     C                   EVAL      RBBTNB = WOBCNO
     C                   EVAL      RBNBTN = KBCNO
     C                   EVAL      RBDPCD = BRDPCD
     C                   EVAL      RBBDES = BRBDES
     C                   MOVE      BRHINI        RBHINI
     C                   MOVE      BRHINC        RBHINC
     C                   ENDIF
      *
      ** For initial print of details
      *
     C                   IF        WFirst = 'Y'
     C                   WRITE(E)  HEADER1
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WFirst = *BLANKS
     C                   ELSE
      *
      ** For overflow has occured print the Header of the report
      *
     C                   EVAL      WRqdln = 1
     C                   EVAL      WDifl = OFLLN1 - PRTLN1
      *
     C                   IF        WDifl <= WRqdln
     C                   WRITE(E)  HEADER1
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write details to printer fields
      *
     C                   WRITE(E)  DEATIL1
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit -  Write the report in AU (Audit)                     *
      *                                                               *
      * Called by: SRMain                                             *
      *                                                               *
      * Calls: SRZSfile                                               *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
      ** Ensure Detail Spool File recorded by RCF
      *
     C                   IF        NOT %OPEN(GL001601AU)
     C                   OPEN      GL001601AU
     C                   EVAL      ZSfile = SFILEU
     C                   EVAL      ZSnum  = SFNUMU
     C                   EXSR      SRZSfile
     C                   ENDIF
      *
     C                   EVAL      WTotProcesd = WValidCnt +
     C                                           WInValidCnt
      *
     C                   WRITE(E)  HEADERU
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WValidCnt     RBTVAL
     C                   MOVE      WInValidCnt   RBTIVL
     C                   MOVE      WTotProcesd   RBTIPRC
      *
     C                   WRITE(E)  DETAILU
      *
     C                   IF        %ERROR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZSfile - Process Report Lines                               *
      *                                                               *
      * Called by: SRPrint                                            *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *****************************************************************
     C     SRZSfile      BEGSR
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PSenty
     C                   PARM                    ZSfile
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       PZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PZSerr = 'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: AOUSERR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANKS       PRtncd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PSUser
     C     SDUSER        PARM      SDUSER        DSSDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtncd <> *BLANKS AND
     C                                    PRtncd <> '*NRF   '
     C                   EVAL      DBFile = 'ZMUSER'
     C                   EVAL      DBKey = PSUser
     C                   EVAL      DBase = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtncd
     C                   PARM      'SWITIDefSts' PSValK1
     C                   PARM                    PSVal1
     C                   PARM      *BLANKS       PSValK2
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10
      *
     C                   IF        PRtncd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GL001601'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = %TRIM(PSValK1)
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF

     ** Access SAR details for Projected Movements Update Prior to Auth.

     C                   MOVEL     'N'           CGL016
     C                   CALLb     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL016'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL016
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
** CTDATA CPY@
(c) Finastra Internatonal Limited 2018
** CTDATA Err_Dtl
Error in Branch
Error in Dept Code
Error in Batch
Successful Transfer
