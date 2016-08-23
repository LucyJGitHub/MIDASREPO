     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Outstanding loans against agent facil rpt')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000311 - Midas LE Outstanding Loans Against Agent          *
      *                                                               *
      *  Function:  This module lists loans drawn against Syndicated  *
      *             Facilities where the bank is acting as the Agent. *
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
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 221608             Date 25Sep03               *
      *                 CLE031  *CREATE    Date 03Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  221608 - Duplicate call to AOBANKR0.                         *
      *  CLE031 - Lending Enhancements.                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Multibranch Active                              *
      *    U7 + U8    Error Occured                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrInit     - Initialisation                                   *
      * SrProc     - Detail Processing                                *
      * SrRcfAu    - Subroutine to register the AU Printer File via   *
      *              RCF                                              *
      * SrRcfP1    - Subroutine to register the P1 Printer File via   *
      *              RCF                                              *
      * SrLnsAttch - Process the Loans Attached to the Facility       *
      * SRCvtAmt   - Convert Amount before printing                   *
      * SrCurrency - Access currency details                          *
      * SrDate     - Convert Date to DDMMMYY format                   *
      * SrAudit    - Subroutine to Output Audit report and End        *
      *              Program                                          *
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
 
     FLEFCLTLA  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Non-participant facilities
 
     FLELOANLC  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L)
      ** Midas LE Customer Lending Loans by Facility Reference
 
     FLE000311P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     L** PRT: Printer file for Outstanding Loans Against Agent Facilities
      ** Detail Report
 
     FLE000311AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     L** PRT: Printer file for Outstanding Loans Against Agent Facilities
      ** Audit Report
 
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
 
      ** File Information Data Structure for AS001009P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for AS001009AU
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
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
 
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
 
     D WRun            S              1
 
      ** Parameters for ZDATE2
     D ZDATE           S              6  0
     D ZADATE          S              7
     D PDate           S              5  0
 
      ** Key Fields of file LELOANLC
     D*KFCus****       S              6  0                                                    CSD027
     D KFCus           S              6                                                       CSD027
     D KFTyp           S              3  0
     D KFSeq           S              2  0
 
      ** Counter
     D WAgFacRead      S              5  0
     D WAgFacLnAt      S              5  0
     D WLnAttAgFc      S              5  0
 
     D WSaveBranch     S              3
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SrInit
 
     C                   EXSR      SrProc
 
     C                   EXSR      SrAudit
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
      ** RCF Processing for Audit File.
 
     C                   EXSR      SrRcfAu
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1  = *ZERO
     C                   EVAL      DifLn1  = *ZERO
     C                   EVAL      PrtLn1  = *ZERO
 
     C                   EVAL      WAgFacRead = *ZERO
     C                   EVAL      WAgFacLnAt = *ZERO
     C                   EVAL      WLnAttAgFc = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProc - Detail Processing                                   *
      *                                                               *
      *****************************************************************
     C     SrProc        BEGSR
 
     C     *LOVAL        SETLL     LEFCLTLA
     C                   READ      LEFCLTLA
 
      ** Audit Report if end of file
 
     C                   IF        %EOF(LEFCLTLA)
     C                   EXSR      SrAudit
     C                   ELSE
 
      ** Do while not End of file
 
     C                   DOW       NOT %EOF(LEFCLTLA)
 
     C                   EVAL      WAgFacRead = WAgFacRead + 1
 
     C                   EVAL      KFCus = CNUM
     C                   EVAL      KFTyp = FACT
     C                   EVAL      KFSeq = FCNO
 
      ** Check if there is at least one loan attached to the
      ** Agent Facility
 
     C     KLeloanlc     CHAIN     LELOANLC
 
     C                   IF        %FOUND (LELOANLC)
 
     C                   EVAL      WAgFacLnAt = WAgFacLnAt + 1
 
     C                   IF        WSaveBranch <> BRCA
 
     C                   EVAL      WSaveBranch = BRCA
 
     C                   IF        WLnAttAgFc <> *ZERO
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     TRAILP1
 
     C                   CLOSE     LE000311P1
 
     C                   ENDIF
 
      ** Get Transaction Branch name, only when MBIN = 'Y'
 
     C                   IF        MBIN = 'Y'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BRCA          PBrca
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
 
     C                   EVAL      RBRCD = BRCA
     C                   EVAL      RBRNM = A8BRNM
 
     C                   ENDIF
 
     C                   EXSR      SrRcfP1
 
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 9
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write Agent Facility Details
 
     C                   MOVEL     CNUM          RCNUM
     C                   MOVEL     CNUM          PCNUM
 
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
 
     C                   EVAL      RCSSN = BBCSSN
     C                   MOVE      FACT          RFACT
     C                   MOVE      FCNO          RFCNO
 
     C                   WRITE     DETAIL1
 
      ** Write Loans' Details
 
     C                   EXSR      SrLnsAttch
 
     C                   ENDIF
 
     C                   READ      LEFCLTLA
 
     C                   ENDDO
 
     C                   IF        WLnAttAgFc <> *ZERO
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     TRAILP1
     C                   CLOSE     LE000311P1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRcfAu - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SrRcfAu       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
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
      *  SrRcfP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *****************************************************************
     C     SrRcfP1       BEGSR
 
     C                   OPEN      LE000311P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      BRCA          SEnty
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
      *  SrLnsAttch - Process the Loans Attached to the Facility      *
      *                                                               *
      *****************************************************************
     C     SrLnsAttch    BEGSR
 
     C     KLeloanlc     SETLL     LELOANLC
     C     KLeloanlc     READE     LELOANLC
 
     C                   DOW       NOT %EOF(LELOANLC)
 
      ** Increment number of loans attached to agent facilities.
 
     C                   EVAL      WLnAttAgFc = WLnAttAgFc + 1
 
     C                   EVAL      RqdLn1 = 7
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Initialize Report File Fields
 
      ** Move Values to Report File Fields
 
     C                   EVAL      RBRCA = LBRCA
     C                   MOVEL     LLNRF         RLNRF
     C                   MOVEL     LCNUM         RCNUM
     C                   EVAL      RLTYP = LLTYP
     C                   EVAL      RSUTP = LSUTP
     C                   EVAL      RCLAS = LCLAS                                              CLE042
 
     C                   EVAL      PCcy = LCCY
     C                   EXSR      SrCurrency
 
     C                   EVAL      PFLD15 = LCPAM
     C                   EVAL      PDECS = A6NBDP
     C                   EVAL      PECODE = 'J'
     C                   EXSR      SRCvtAmt
 
      ** Retain negative sign '-' in position 21.
 
     C                   MOVE      POUT21        RCPAM
 
     C                   EVAL      RCCY  = LCCY
 
     C                   IF        LVDAT <> 0
     C                   EVAL      PDate = LVDAT
     C                   EXSR      SRDATE
     C                   EVAL      RVDAT = ZADATE
     C                   ELSE
     C                   EVAL      RVDAT = *BLANKS
     C                   ENDIF
 
     C                   IF        LMDAT <> 0
     C                   EVAL      PDate = LMDAT
     C                   EXSR      SRDATE
     C                   EVAL      RMDAT = ZADATE
     C                   ELSE
     C                   EVAL      RMDAT = *BLANKS
     C                   ENDIF
 
     C                   WRITE     DETAIL2
 
     C     KLeloanlc     READE     LELOANLC
     C                   ENDDO
 
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
     C                   PARM                    POut21
 
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
      *  SrAudit - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR
 
      ** Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
 
     C                   IF        *INU7 = *ON AND
     C                             *INU8 = *ON
 
      ** Write Database Error Report
 
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Move work variable to Printer File Fields.
 
     C                   EVAL      RCOUNT = WAgFacRead
     C                   EVAL      ACOUNT = WAgFacLnAt
     C                   EVAL      LCOUNT = WLnAttAgFc
 
      ** Write Audit Control Report
 
     C                   WRITE     CONTROL
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
 
     C*******************CALLB     'AOBANKR0'                                              221608
     C                   CALLB     'AOBANKR0'
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
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     KLeloanlc     KLIST
     C                   KFLD                    KFCus
     C                   KFLD                    KFTyp
     C                   KFLD                    KFSeq
 
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
     C                   DUMP
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRAUDIT
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
