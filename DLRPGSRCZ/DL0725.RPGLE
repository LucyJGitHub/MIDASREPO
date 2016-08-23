     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Early Maturity of Loans/Deposits')            *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL0725 - Deal Amendments made today with Early Maturity      *
      *           Date Change                                         *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. 260239             Date 18May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249458             Date 31Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239233             Date 11Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL017  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  260239 - Overflow error cause DLC0725 to fail.               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249458 - Change creation parm for DL0725P1 (recompile)       *
      *  239233 - Missing bank title on report.                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL017 - Penalty Fees and Early Maturity of Fixed Term       *
      *           Loans/Deposits                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Multibranching ON                               *
      *    20         End of File in MMDELDPP                         *
      *    U7/U8/LR   Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROCES      -  Process Records from File MMDELDPP          *
      *  SRDETAIL      -  Process and Print Detail Record Line        *
      *  SRWP1END      -  Write End of Report                         *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEAMSDHF)
     F                                     IGNORE(DEAMSDJF)
      ** Midas MM Deal Amendments
 
     FDL0725P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      ** Midas MM Deals due for Automatic Rollover Today
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
      ** Array holding shortnames of each month
     D SSA             S              3    DIM(12) CTDATA PERRCD(12)
 
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for CustomeriDetails
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)
 
      ** Externally described DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** Externally described DS for Rundate Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for DL0725P1
     D SPOOL1          DS
     D   SFile1               83     92
     D   SFNum1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** Value Date Data Structure
     D S1ValueDate     DS
     D   S1VDDD                1      2
     D   S1VDMM                3      5
     D   S1VDYY                6      7
 
      ** Early Maturity Date Data Structure
     D S1EMDate        DS
     D   S1EMD1                1      2  0
     D   S1EMM1                3      4  0
     D   S1EMY1                5      6  0
     D S1EMatDate      DS
     D   S1EMD2                1      2
     D   S1EMM2                3      5
     D   S1EMY2                6      7
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
 
      ** Parameters for ZEDIT
     DZField           S             16A
     DZADec            S              1  0
 
      ** Parameters for ZSEDITF
     D PINAMT          S             15P 0
     D PINDEC          S              1P 0
     D PINCODE         S              1A
     D PINCHAR         S              1A
     D POUTAMT         S             21A
 
      ** Parameters for access object programs
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Other fields used
     D WFile           S             10A
     D ZSNum           S              6  0
     D ZSErr           S              1A
     D WMDATE          S              5P 0
     D WROLL           S              5P 0
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
     D WOPEN           S              1A
     D WCOUNT          S             10  0
     D WFIRST          S              1A
     D WRUN            S              1A
     D WREQUESTED      S              1A
     D RunDate         S              5P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Perform Detail Processing
 
      ** Read first record from File
     C                   READ      DEAMS                                  20
 
      ** Do Until End of File
     C                   DOW       *IN20 = *OFF
 
      ** Record requested for Report ?
     C                   EVAL      WRequested = 'Y'
 
      ** Deal Amendment Type 'EM' for today
     C                   IF        DTYP <> 'EM'   AND
     C                             LCD = RunDate
     C                   EVAL      WRequested = 'N'
     C                   ENDIF
 
      ** Process only selected  records
     C                   IF        WRequested = 'Y'
 
      ** Header Needed ?
     C**********         Z-ADD     1             RQDLN1                                       260239
     C                   Z-ADD     4             RQDLN1                                       260239
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= RQDLN1 OR WCOUNT = 0
     C                   WRITE     DL0725R0
     C                   WRITE     DL0725R1
     C                   ENDIF
 
      ** Process Detail Record
     C                   ADD       1             WCOUNT
     C                   EXSR      SRDETAIL
 
     C                   ENDIF
 
      ** Read next record
     C                   READ      DEAMS                                  20
 
     C                   ENDDO
 
     ** No Details to report
     C                   IF        WCOUNT = 0
     C                   WRITE     DL0725R0
     C                   WRITE     DL0725R5
     C                   ENDIF
 
     C                   WRITE     DL0725R3
     C                   CLOSE     DL0725P1
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETAIL - Process and Print Detail Record Line              *
      *                                                               *
      *  Called by: SRPROCES                                          *
      *                                                               *
      *  Calls    : SRFMTAMT  SRCHKLIN                                *
      *                                                               *
      *****************************************************************
 
     C     SRDETAIL      BEGSR
 
      ** Move Input Fields to Output Fields
 
      ** Deal Number
     C                   Z-ADD     DLNO          S1DLNO
 
      ** Sequence Number
     C                   Z-ADD     DASN          S1SEQN
 
      ** Customer
     C                   MOVEL     CNUM          PCUST
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    PCUST            10
     C                   PARM      *BLANKS       PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
      *   Error?
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVE      CNUM          DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   MOVEL     BBCSSN        S1CNUM
     C                   ENDIF
 
      ** Rate/Spread
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      RTSP          ZField
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      7             ZADec
 
     C                   EVAL      S1SPRD = ZField
 
      ** Currency
     C                   EVAL      S1CCY  = CCY
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      CCY           PKEY              3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVE      CCY           DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Amount/Penalty Fee
     C                   IF        DAAM = 0
     C                   MOVE      *BLANKS       S1AMNP
     C                   ELSE
     C                   Z-ADD     DAAM          PIAMT
     C                   Z-ADD     A6NBDP        PDECPL
 
     C                   CALLB     'ZA1020'
     C                   PARM                    PIAMT            15 0
     C                   PARM      15            PCRET             2 0
     C                   PARM                    PDECPL            1 0
     C                   PARM                    BNDCSP
     C                   PARM                    BNTHSP
     C                   PARM                    PADSP            21
 
     C                   MOVE      PADSP         S1AMNP
     C                   ENDIF
 
      ** Funding Spread/Rate
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      FSRP          ZField
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM      7             ZADec
 
     C                   EVAL      S1FSPR = ZField
 
      ** Penalty Pay/Receive
     C                   EVAL      S1PENP = PENLTY
 
      ** Base Rate
     C                   MOVE      BRTT          S1BSRT
 
      ** Input User
     C                   EVAL      S1INPU = INPUSR
 
      ** Authorising User
     C                   EVAL      S1AUTU = AUTUSR
 
      ** Early Maturity Date
     C                   Z-ADD     EMDAT         DateIn            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    DateIn
     C                   PARM      'M'           ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DateOut           7
     C                   EVAL      S1EMDT = DateOut
 
      ** Value Date
     C                   Z-ADD     VDAT          DateIn2           5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    DateIn2
     C                   PARM      'M'           ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    DateOut2          7
     C                   EVAL      S1VDAT = DateOut2
 
      ** Write Detail Record Format
 
     C                   WRITE     DL0725R2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Receive entry parameters
     C     *ENTRY        PLIST
     C                   Parm                    PRSEQ             5
     C                   Parm                    PRENT             3
 
      ** Initialise LDA field
     C                   EVAL      DBPGM = 'DL0725'
 
      ** Call Access Program for Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing Details
     C                   CALL      'AODEALR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDDEAL        PARM      SDDEAL        DSFDY
 
      ** Handle Database Error
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDEALPD'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access RUNDAT for multibranching indicator
     C                   IN        RUNDAT
     C                   MOVE      AGRDNB        RunDate
     C                   MOVE      AGMRDT        RRRUNA
     C                   MOVE      BJURPT        RRTITL                                       239233
 
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
 
      ** Initialize Amount and Work Fields
     C                   Z-ADD     0             WCOUNT
     C                   MOVE      'Y'           WFIRST
     C                   MOVE      'N'           WOPEN
 
      ** Open Printer File and Write Header
     C                   OPEN      DL0725P1
     C                   Z-Add     SFNum1        ZSNum
     C                   Move      SFile1        WFile
     C                   Exsr      RcdRCF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RcdRCF - Register a printer file via RCF                     *
      *                                                               *
      *****************************************************************
 
     C     RcdRCF        Begsr
 
     C                   Call      'ZSFILE'
     C                   Parm                    PRSEQ
     C                   Parm                    PRENT
     C                   Parm                    WFile
     C                   Parm                    ZSNum
     C                   Parm                    ZSErr
 
     C                   If        ZSErr = 'Y'
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   Move      *On           *INLR
     C                   Return
     C                   Endif
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls    : SRAUDIT                                           *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called
 
     C                   IF        WRUN = *BLANKS
     C                   MOVE      'Y'           WRUN
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   MOVE      DBASE         DBBASE
     C                   DUMP
     C                   WRITE     DL0725R4
     C                   CLOSE     DL0725P1
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
**  MONTH SHORTNAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
