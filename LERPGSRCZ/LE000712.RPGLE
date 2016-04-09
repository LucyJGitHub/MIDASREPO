     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Commitment Fees Detail Report')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000712 - Commitment Fees Detail Report                     *
      *                                                               *
      *  Function:  This module shows the fee amounts to be charged at*
      *             the next fee payment and how these are calculated.*
      *             Actual calculations would have been done in       *
      *             extract program, LE0711. This report program will *
      *             simply report details as retrieved from the       *
      *             extract file.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE037  *CREATE    Date 09Dec03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE037 - Nordea Commitment Fee Update                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Multibranch Active                              *
      *    02         End of file for LECFEEL0                        *
      *    03         Record not found in LEFEEDL0                    *
      *    11         Hide period start and end, no. of days          *
      *    12         Hide no. of days                                *
      *    20         Outstanding Amount used                         *
      *    21         Facility Amount used                            *
      *    22         Available Amount used                           *
      *    31         Percentage if on, Amount if off                 *
      *    U7 + U8    Error Occured                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrInit     - Initialisation                                   *
      * SrProc     - Detail Processing                                *
      * SrRcfP1    - Subroutine to register the P1 Printer File via   *
      *              RCF                                              *
      * SrRcfAU    - Subroutine to register the AU Printer File via   *
      *              RCF                                              *
      * SrFeeAmtDet- Process fee amount details                       *
      * SRCvtAmt   - Convert Amount before printing                   *
      * SRSupZero - Suppress Zeros                                    *
      * SrCurrency - Access currency details                          *
      * SrDate     - Convert Date to DDMMMYY format                   *
      * SrNorec    - Subroutine to Output no records to report        *
      * SrAudit    - Subroutine to process audit report               *
      *                                                               *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Initialise                                       *
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
 
     FLECFEEL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Commitment Fees Details
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Lending fees master detail input
 
     FLE000712P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      ** PRT: Printer file for Commitment Fees Detail Report
 
     FLE000712AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** AUD: Printer file for Commitment Fees Detail Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Today's Date
     D RUNDAT          DS
     D  MBIN                  13     13
 
      ** File Information Data Structure for LE000712P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for LE000712AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** Currency Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Customer Details Data Stracture
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** DS for Access Programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External Data Structures for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  CL_QQDFAC    E                     EXTFLD(QQDFAC)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for Access Objects
     D PRtcd           S              7
     D POptn           S              7
     D PBrca           S              3
     D PCcy            S              3
     D PCnum           S             10
     D PCnSt           S              7
 
      ** Parameters for SDRTVTXT
     D PMsgId          S              7A
     D PMsgFNm         S             10A
     D PMsgDesc        S             80A
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
 
      ** Parameters for ZSEDIT
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PEcode          S              1
     D POut21          S             21
 
      ** ZEDIT/ZALIGN Parameters
     D PzField         S             16A
     D PzADec          S              1P 0
 
     D WRun            S              1    INZ('N')
 
      ** Parameters for ZDATE2
     D ZDATE           S              6  0
     D ZADATE          S              7
     D PDate           S              5  0
 
      ** Key for LEFEEDL1 chain
     D WLEFee          DS
     D*K#CNUM***               1      6  0                                                    CSD027
     D K#CNUM                  1      6                                                       CSD027
     D K#FCLT                  7     11  0
     D*K#LNRF***              12     17  0                                                    CLE148
     D K#LNRF                 12     17                                                       CLE148
     D K#FSEQ                 18     19  0
 
      ** Counter
     D WFacFeeRed      S              5  0
 
     D WSaveBranch     S              3
     D WResetFlg       S              1
     D WTieredFlg      S              1
     D X               S              1  0
     D Y               S              1  0
     D WFECALTN        S              2  0
     D WBrchChg        S              1    INZ('N')
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Perform Initialisation.
 
     C                   EXSR      SrInit
 
      ** Perform Detail Processing.
 
     C                   EXSR      SrProc
 
      ** Output audit report and end program.
 
     C                   EXSR      SRAudit
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
      ** RCF Processing for Audit File.
 
     C                   EXSR      SRRcfAu
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1  = *ZERO
     C                   EVAL      DifLn1  = *ZERO
     C                   EVAL      PrtLn1  = *ZERO
 
     C                   EVAL      WFacFeeRed = *ZERO
 
     C     *LIKE         DEFINE    CFCNUM        WPCNUM
     C     *LIKE         DEFINE    CFFACT        WPFACT
     C     *LIKE         DEFINE    CFFCNO        WPFCNO
     C     *LIKE         DEFINE    CFFSEQ        WPFSEQ
     C     *LIKE         DEFINE    CFPDST        WPPDST
     C     *LIKE         DEFINE    CFPDEN        WPPDEN
     C     *LIKE         DEFINE    CFNUMD        WTNUMD
     C     *LIKE         DEFINE    CFFAMT        WTFAMT
     C     *LIKE         DEFINE    CFAAMT        WPAAMT
     C     *LIKE         DEFINE    CFAAMT        WKAAMT
 
     C**********         EVAL      WPCNUM = 0                                                 CSD027
     C                   EVAL      WPCNUM = *BLANKS                                           CSD027
     C                   EVAL      WPFACT = 0
     C                   EVAL      WPFCNO = 0
     C                   EVAL      WPFSEQ = 0
     C                   EVAL      WPPDST = 0
     C                   EVAL      WPPDEN = 0
     C                   EVAL      WTNUMD = 0
     C                   EVAL      WTFAMT = 0
     C                   EVAL      WPAAMT = 0
     C                   EVAL      WKAAMT = 0
     C                   EVAL      WResetFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProc - Detail Processing                                   *
      *                                                               *
      *****************************************************************
     C     SrProc        BEGSR
 
     C     *LOVAL        SETLL     LECFEEL0
     C                   READ      LECFEEL0                               02
 
      ** No Records to Report
 
     C                   IF        %EOF(LECFEEL0)
     C                   EXSR      SrNoRec
     C                   ELSE
 
      ** Do while not End of file
 
     C                   DOW       NOT %EOF(LECFEEL0)
 
     C                   EVAL      WFacFeeRed = WFacFeeRed + 1
 
     C                   IF        MBIN = 'Y'
     C                   IF        WSaveBranch <> CFBRCA
 
     C                   EVAL      WSaveBranch = CFBRCA
     C                   EVAL      WBrchChg    = 'Y'
 
     C                   IF        WFacFeeRed > 1
     C                   EXSR      SRTotal
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
 
     C                   CLOSE     LE000712P1
 
     C                   ENDIF
 
      ** Get Transaction Branch name, only when MBIN = 'Y'
 
     C                   IF        MBIN = 'Y'
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CFBRCA        PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 2
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBKey  = PBrca
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RBRCD = CFBRCA
     C                   EVAL      RBRNM = A8BRNM
 
     C                   ENDIF
 
     C                   EXSR      SrRcfP1
 
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Multibranching is off
 
     C                   ELSE
 
      ** This should be run only once at the start
 
     C                   IF        WFacFeeRed = 1
     C                   EXSR      SrRcfP1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write Facility Fee Details
 
     C                   IF        CFCNUM <> WPCNUM or CFFACT <> WPFACT or
     C                             CFFCNO <> WPFCNO or CFFSEQ <> WPFSEQ or
     C                             WBrchChg = 'Y'
 
     C                   IF        WFacFeeRed > 1 and WBrchChg = 'N'
 
      ** Write total for previous fee
 
     C                   EXSR      SRTotal
     C                   ENDIF
     C                   EVAL      WBrchChg    = 'N'
 
     C                   EVAL      RqdLn1 = 9
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   EVAL      WPCNUM = CFCNUM
     C                   EVAL      WPFACT = CFFACT
     C                   EVAL      WPFCNO = CFFCNO
     C                   EVAL      WPFSEQ = CFFSEQ
 
     C                   MOVEL     CFCNUM        RCNUM
     C                   MOVEL     CFCNUM        PCnum
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCnum
     C                   PARM                    PCnst
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 3
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   MOVEL     PCnum         DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RCNAM = BBCRNM
     C                   MOVE      CFFACT        RFACT
     C                   MOVE      CFFCNO        RFCNO
     C                   MOVE      CFFSEQ        RFSEQ
 
      ** Setup key for chain to fees file
 
     C                   MOVE      CFCNUM        K#CNUM
     C                   MOVEL     CFFACT        K#FCLT
     C                   MOVE      CFFCNO        K#FCLT
     C**********         Z-ADD     0             K#LNRF                                       CLE148
     C                   MOVEL     *BLANKS       K#LNRF                                       CLE148
     C                   MOVE      CFFSEQ        K#FSEQ
 
     C     KLEFee        CHAIN     LEFEEDL1                           03
 
     C                   IF        NOT %FOUND(LEFEEDL1)
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 4
     C                   EVAL      DBFile = 'LEFEED'
     C                   EVAL      DBKey = WLEFee
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Format fee currency and calculation type
 
     C                   MOVE      FEFCCY        RFCCY
     C                   MOVE      FECALT        RFTYP
 
      ** Format fee calculation type narrative
 
     C                   EVAL      RFTYN = *BLANKS
     C                   SELECT
     C                   WHEN      FECALT = '01'
     C                   EVAL      PMsgID = 'LER1185'
     C                   WHEN      FECALT = '02'
     C                   EVAL      PMsgID = 'LER1186'
     C                   WHEN      FECALT = '03'
     C                   EVAL      PMsgID = 'LER1187'
     C                   WHEN      FECALT = '04'
     C                   EVAL      PMsgID = 'LER1188'
     C                   WHEN      FECALT = '05'
     C                   EVAL      PMsgID = 'LER1189'
     C                   WHEN      FECALT = '06'
     C                   EVAL      PMsgID = 'LER1190'
     C                   WHEN      FECALT = '11'
     C                   EVAL      PMsgID = 'LER1191'
     C                   WHEN      FECALT = '12'
     C                   EVAL      PMsgID = 'LER1192'
     C                   WHEN      FECALT = '13'
     C                   EVAL      PMsgID = 'LER1193'
     C                   WHEN      FECALT = '14'
     C                   EVAL      PMsgID = 'LER1194'
     C                   WHEN      FECALT = '15'
     C                   EVAL      PMsgID = 'LER1195'
     C                   WHEN      FECALT = '16'
     C                   EVAL      PMsgID = 'LER1196'
     C                   WHEN      FECALT = '21'
     C                   EVAL      PMsgID = 'LER1197'
     C                   WHEN      FECALT = '22'
     C                   EVAL      PMsgID = 'LER1198'
     C                   ENDSL
 
     C                   EXSR      SRRtvTxt
     C                   EVAL      RFTYN  = PMsgDesc
 
     C                   MOVE      FECALT        WFECALTN
 
     C                   SELECT
 
      ** Process available amount
 
     C                   WHEN      WFECALTN <= 6
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *ON
 
      ** Process outstanding amount
 
     C                   WHEN      WFECALTN <= 16
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
 
      ** Process facility amount
 
     C                   WHEN      WFECALTN <= 22
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *OFF
     C                   ENDSL
 
      ** Setup flag to determine if tiered amounts
 
     C                   EVAL      WTieredFlg = 'N'
     C                   IF        FECALT = '01' or FECALT = '04' or
     C                             FECALT = '11' or FECALT = '14'
     C                   EVAL      WTieredFlg = 'Y'
     C                   ENDIF
 
      ** Format Dates
 
      ** Period start date
 
     C                   MOVE      FEPSTD        PDate
     C                   EXSR      SRDate
     C                   MOVE      ZADATE        RPSTD
 
      ** Period end date
 
     C                   MOVE      FEPEND        PDate
     C                   EXSR      SRDate
     C                   MOVE      ZADATE        RPEND
 
      ** Last payment date
 
     C                   MOVE      FELPDT        PDate
     C                   EXSR      SRDate
     C                   MOVE      ZADATE        RLPDT
 
      ** Next payment date
 
     C                   IF        FENPYD > 0
     C                   MOVE      FENPYD        PDate
     C                   EXSR      SRDate
     C                   ENDIF
     C                   MOVE      ZADATE        RNPYD
 
      ** Print facility fee details
 
     C                   WRITE     DETAIL1
 
      ** Print column headings
 
     C                   IF        WTieredFlg = 'Y'
     C                   WRITE     DETAIL4
     C                   ELSE
     C                   WRITE     DETAIL2
     C                   ENDIF
 
     C                   ENDIF
 
      ** Print fee amount details
 
     C                   EXSR      SrFeeAmtDet
 
     C                   READ      LECFEEL0                               02
 
     C                   ENDDO
 
     C                   IF        WFacFeeRed > *ZERO
 
      ** Write total for previous fee
 
     C                   EXSR      SRTotal
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
     C                   CLOSE     LE000712P1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRcfP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SrRcfP1       BEGSR
 
     C                   OPEN      LE000712P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      CFBRCA        SEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSErr
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRcfAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SrRcfAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnum  = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      CFBRCA        SEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *BLANKS       ZSErr
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFeeAmtDet - Process fee amount details                     *
      *                                                               *
      *****************************************************************
     C     SrFeeAmtDet   BEGSR
 
      ** Reset total variables
 
     C                   IF        WResetFlg = 'Y'
     C                   EVAL      WTNUMD = 0
     C                   EVAL      WTFAMT = 0
     C                   ENDIF
 
     C                   IF        CFPDST <> WPPDST or
     C                             CFPDEN <> WPPDEN or
     C                             WResetFlg = 'Y'
 
     C                   EVAL      WPPDST = CFPDST
     C                   EVAL      WPPDEN = CFPDEN
 
      ** Period start date
 
     C                   MOVE      CFPDST        PDate
     C                   EXSR      SRDate
     C                   MOVE      ZADATE        RPRDS
 
      ** Period end date
 
     C                   MOVE      CFPDEN        PDate
     C                   EXSR      SRDate
     C                   MOVE      ZADATE        RPRDE
     C                   EVAL      *IN11 = *ON
 
     C                   ELSE
 
     C                   EVAL      RPRDS = *BLANKS
     C                   EVAL      RPRDE = *BLANKS
     C                   EVAL      *IN11 = *OFF
 
     C                   ENDIF
 
      ** Format balance amount
 
     C                   EVAL      PCcy = FEFCCY
     C                   EXSR      SRCurrency
 
     C                   IF        CFNUMD > 0
     C                   EVAL      WPAAMT = 0
     C                   ENDIF
 
     C                   EVAL      RAMNT = *BLANKS
     C                   IF        CFBALA > 0
     C                   MOVE      CFBALA        PFld15
     C                   Z-ADD     A6NBDP        PDecs
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
     C                   MOVE      POut21        RAMNT
     C                   ENDIF
 
      ** Format tiered amount
 
     C                   EVAL      RTAMT = *BLANKS
     C                   IF        CFTAMT > 0
     C                   MOVE      CFTAMT        PFld15
     C                   Z-ADD     A6NBDP        PDecs
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
     C                   MOVE      POut21        RTAMT
     C                   ENDIF
 
      ** Format percentage
 
     C                   EVAL      RPCT  = *BLANKS
     C                   IF        CFPCT  > 0
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFPCT         PzField
     C                   EVAL      PzADec = 3
     C                   EXSR      SRZEdit
     C                   MOVE      PzField       RPCT
     C                   ENDIF
 
      ** Format rate
 
     C                   EVAL      RRATE = *BLANKS
     C                   IF        CFRATE > 0
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFRATE        PzField
     C                   EVAL      PzADec = 5
     C                   EXSR      SRZEdit
     C                   MOVE      PzField       RRATE
     C                   ENDIF
     C
 
      ** Format number of days
 
     C                   EVAL      RNIDY = *BLANKS
     C                   EVAL      RNDYS = *BLANKS
     C                   EVAL      *IN12 = *OFF
     C                   IF        CFNUMD > 0 and *IN11 = *ON or
     C                             CFNUMD > 0 and *IN11 = *OFF and
     C                             WTieredFlg = 'Y'
     C                   EVAL      *IN12 = *ON
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      CFNUMD        PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SRZEdit
     C                   MOVE      PzField       RNIDY
 
      ** Retrieve calculation day basis equivalent
 
     C                   SELECT
     C                   WHEN      FECALC = 1 or FECALC = 4
     C                   EVAL      RNDYS = '365'
     C                   WHEN      FECALC = 2 or FECALC = 3 or FECALC = 5
     C                   EVAL      RNDYS = '360'
     C                   WHEN      FECALC = 6
     C                   EVAL      RNDYS = '366'
     C                   ENDSL
 
     C                   ENDIF
 
      ** Format fee amount
 
     C                   EVAL      RFAMT = *BLANKS
     C                   IF        CFFAMT > 0
     C                   MOVE      CFFAMT        PFld15
     C                   Z-ADD     A6NBDP        PDecs
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
     C                   MOVE      POut21        RFAMT
     C                   ENDIF
 
     c                   IF        CFNUMD > 0
     C                   EVAL      WTNUMD = WTNUMD + CFNUMD
     C                   EVAL      WTFAMT = WTFAMT + CFFAMT
     C                   ENDIF
 
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     DETAIL1
     C                   IF        WTieredFlg = 'Y'
     C                   WRITE     DETAIL4
     C                   ELSE
     C                   WRITE     DETAIL2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WTieredFlg = 'Y'
     C                   WRITE     DETAIL5
     C                   ELSE
     C                   WRITE     DETAIL3
     C                   ENDIF
 
     C                   IF        WResetFlg = 'Y'
     C                   EVAL      WResetFlg = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTotal - Total for fee being processed                      *
      *                                                               *
      *****************************************************************
     C     SRTotal       BEGSR
 
     C                   EVAL      WResetFlg = 'Y'
 
      ** Format total number of days
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WTNUMD        PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SRZEdit
     C                   MOVE      PzField       RTNIDY
 
      ** Format total fee amount
 
     C                   MOVE      WTFAMT        PFld15
     C                   Z-ADD     A6NBDP        PDecs
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
     C                   MOVE      POut21        RTFAMT
 
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   WRITE     DETAIL1
     C                   IF        WTieredFlg = 'Y'
     C                   WRITE     DETAIL4
     C                   ELSE
     C                   WRITE     DETAIL2
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WTieredFlg = 'Y'
     C                   WRITE     TOTAL2
     C                   ELSE
     C                   WRITE     TOTAL
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtAmt - Convert Amount before printing                    *
      *                                                               *
      *****************************************************************
     C     SRCvtAmt      BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PEcode
     C                   PARM      *BLANKS       POut21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZEdit    - Format Numeric Fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZEdit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PzField
     C                   PARM                    PzADec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurrency - Access currency details                         *
      *                                                               *
      *****************************************************************
     C     SrCurrency    BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 4
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCcy
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDate - Convert Date to DDMMMYY format                       *
      *                                                               *
      *****************************************************************
     C     SrDate        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDate
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve text                                      *
      *                                                               *
      *****************************************************************
 
     C     SRRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgID
     C                   PARM      'GBLERMSGF '  PMsgFNm
     C                   PARM      *BLANK        PMsgDesc
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNoRec - Subroutine to Output no records to report          *
      *                                                               *
      *****************************************************************
     C     SrNoRec       BEGSR
 
      ** Output NOREC
 
     C                   EXSR      SrRcfP1
     C                   WRITE     HEADP1
     C                   WRITE     NOREC
     C                   CLOSE     LE000712P1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output audit details                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = True
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   IF        WFacFeeRed = 0
     C                   WRITE     NODTLS
     C                   ELSE
 
     C                   MOVE      *BLANKS       PzField
     C                   MOVE      WFacFeeRed    PzField
     C                   EVAL      PzADec = 0
     C                   EXSR      SRZEdit
     C                   MOVE      PzField       RCNT1
 
     C                   WRITE     CONTROL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** End Program and Return.
 
     C                   EVAL      *INLR = True
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 1
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'LE000712'
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     KLEFee        KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FCLT
     C                   KFLD                    K#LNRF
     C                   KFLD                    K#FSEQ
 
      ** Check multibranch function
 
     C     MBIN          IFEQ      'Y'
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
 
     C                   ENDSR
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
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
 
     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
