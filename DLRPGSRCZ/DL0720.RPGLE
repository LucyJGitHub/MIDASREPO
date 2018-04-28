     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL MM Deals due for Automatic Rollover Today')   *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL0720 - Money Market Deals due for Automatic Rollover Today *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 AR747438           Date 11Nov13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239233             Date 11Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CDL016  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  AR747438 - DL0720P1 is reporting the wrong deal              *
      *           - Applied for MD023267                              *
      *  239233 - Missing bank title on report.                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Multibranching ON                               *
      *    20         End of File in DEALS                            *
      *    U7/U8/LR   Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROCES      -  Process Records from File DEALS             *
      *  SRDETAIL      -  Process and Print Detail Record Line        *
      *  SRWP1END      -  Write End of Report                         *
      *  SRFMTAMT      -  Format Printer File Fields Amount           *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
      ** Midas MM Loan/deposit/CD issued
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDFF)
     F                                     IGNORE(DEALSDBF)                                 AR747438
     F                                     IGNORE(DEALSDDF)                                 AR747438
     F                                     IGNORE(DEALSDEF)                                 AR747438
     F                                     IGNORE(DEALSDGF)                                 AR747438
 
     FDL0720P1  O    E             PRINTER INFDS(SPOOL1)
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
 
      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1
 
      ** Array holding shortnames of each month
     D SSA             S              3    DIM(12) CTDATA PERRCD(12)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Deal details                                           AR747438
      *                                                                                     AR747438
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                AR747438
      *                                                                                     AR747438
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for Rundate details
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Entry Parameter
     D PARMS           DS
     D PDealType               1      2
     D PDealSubType            3      4
     D PDealClass              5      8                                                       CDL038
 
      ** File Information Data Structure for DL0720P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** Value Date Data Structure
     D S1ValueDate     DS
     D   S1VDDD                1      2
     D   S1VDMM                3      5
     D   S1VDYY                6      7
 
      ** Maturity Date Data Structure
     D S1MatDate       DS
     D   S1MDDD                1      2
     D   S1MDMM                3      5
     D   S1MDYY                6      7
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
      ** System values array                                                                AR747438
      *                                                                                     AR747438
     D SVAl            S             20    DIM(2) CTDATA PERRCD(1)                          AR747438
      *                                                                                     AR747438
     D/COPY ZSRSRC,ZHOLILE                                                                  AR747438
     D/COPY ZSRSRC,ZHOLELE                                                                  AR747438
      *                                                                                     AR747438
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
     C                   READ      DEALS                                  20
 
      ** Do Until End of File
     C                   DOW       *IN20 = *OFF
 
      ** Record requested for Report ?
     C                   EVAL      WRequested = 'Y'
 
      ** Deal Type Selected....
     C                   IF        PDealType <> '**' AND
     C                             PDealType <> DTYP
     C                   EVAL      WRequested = 'N'
     C                   ENDIF
 
      ** Deal Type not Selected, then only output TI,TD,IP and IT from file...
     C                   IF        PDealType = '**' AND
     C                             DTYP <> 'TI'     AND
     C                             DTYP <> 'TD'     AND
     C                             DTYP <> 'IP'     AND
     C                             DTYP <> 'IT'
     C                   EVAL      WRequested = 'N'
     C                   ENDIF
 
      ** Deal SubType Selected....
     C                   IF        PDealSubType <> '**' AND
     C                             PDealSubType <> DLST
     C                   EVAL      WRequested = 'N'
     C                   ENDIF
                                                                                              CDL038
      ** Deal Class Selected....                                                              CDL038
     C                   IF        PDealSubType <> '**' AND                                   CDL038
     C                             PDealClass <> CLAS                                         CDL038
     C                   EVAL      WRequested = 'N'                                           CDL038
     C                   ENDIF                                                                CDL038
 
      ** Deal not due for Automatic Rollover Today....
 
      *    MDAT          SUB       SVAL11        WROLL
      *                                                                                     AR747438
      ** Calculate rollover generation date                                                 AR747438
      ** = rollover days back from maturity date                                            AR747438
      *                                                                                     AR747438
     C                   Z-ADD     MDAT          ZDAYNO                                     AR747438
     C                   MOVE      BJLCCY        ZCCY                                       AR747438
     C                   MOVE      *BLANK        ZLOC                                       AR747438
     C                   Z-ADD     ROLDAY        ZNRDYS                                     AR747438
     C                   EXSR      ZBKDT                                                    AR747438
     C**********         IF        WROLL <> BJRDNB  AND AURO <> 'Y'                         AR747438
      *                                                                                     AR747438
      ** Not autorollover                                                                   AR747438
      *                                                                                     AR747438
     C                   IF        AURO <> 'A'                                              AR747438
     C                   EVAL      WRequested = 'N'
     C                   ENDIF
 
      ** Deal already rolled over                                                           AR747438
      *                                                                                     AR747438
     C                   IF        RBDN <> 0                                                AR747438
     C                   EVAL      WRequested = 'N'                                         AR747438
     C                   ENDIF                                                              AR747438
      *                                                                                     AR747438
      ** Rollover generation date is in the future                                          AR747438
      *                                                                                     AR747438
     C                   IF        ZDYNBR >= BJDNWD AND AURO = 'A'                          AR747438
     C                   EVAL      WRequested = 'N'                                         AR747438
     C                   ENDIF                                                              AR747438
      *                                                                                     AR747438
      ** Process only selected  records
     C                   IF        WRequested = 'Y'
 
      ** Header Needed ?
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C                   IF        DIFLN1 <= RQDLN1 OR WCOUNT = 0
     C                   WRITE     DL0720R0
     C                   WRITE     DL0720R1
     C                   ENDIF
 
      ** Process Detail Record
     C                   ADD       1             WCOUNT
     C                   EXSR      SRDETAIL
 
     C                   ENDIF
 
      ** Read next record
     C                   READ      DEALS                                  20
 
     C                   ENDDO
 
     ** No Details to report
     C                   IF        WCOUNT = 0
     C                   WRITE     DL0720R0
     C                   WRITE     DL0720R5
     C                   ENDIF
 
     C                   WRITE     DL0720R3
     C                   CLOSE     DL0720P1
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
     C                   EVAL      S1BRCA = BRCA                                Branch Code
     C                   EVAL      S1DTYP = DTYP                                Deal Type
     C                   EVAL      S1DLST = DLST                                Deal SubType
     C                   EVAL      S1CLAS = CLAS                                Deal Class    CDL038
     C                   MOVE      CNUM          S1CNUM                         Customer Number
     C                   EVAL      S1ORBR = ORBR                                Original Branch
     C                   MOVE      DLNO          S1DLNO                         Deal Number
     C**********         EVAL      S1CCY  = PUCY                                Currency    AR747438
     C                   EVAL      S1CCY  = CCY                                 Currency    AR747438
     C                   EVAL      S1PCEN = PRFC                                Profit Centre
 
     C**********         EVAL      PINAMT = PUAM                                Amount      AR747438
     C                   EVAL      PINAMT = PCPL                                Amount      AR747438
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       S1AMNT                         Formatted Amount
 
      ** Value Date
     C                   Z-ADD     VDAT          DateIn            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    DateIn
     C                   PARM      'M'           ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DateOut           7
     C                   MOVE      DateOut       S1VDAT                                       CDL038
     C*******************MOVE      DateOut       S1ValueDate                                  CDL038
 
      ** Maturity Date
     C                   IF        MDAT <> 0
     C                   Z-ADD     MDAT          DateIn2           5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    DateIn2
     C                   PARM      'M'           ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    DateOut2          7
     C                   MOVE      DateOut2      S1MDAT                                       CDL038
     C*******************MOVE      DateOut2      S1MatDate                                    CDL038
     C                   ELSE                                                                 CDL038
     C                   MOVE      *BLANK        S1MDAT                                       CDL038
     C                   ENDIF
 
      ** Write Detail Record Format
 
     C                   WRITE     DL0720R2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMTAMT - Format Printer File Fields Amount                 *
      *                                                               *
      *  Called by: SRMTHBRK                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRFMTAMT      BEGSR
 
      ** Check Currency Decimal Places
     C                   CALLB     'AOCURRR0'
     C                   PARM      '        '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C**********         PARM                    PUCY                                       AR747438
     C                   PARM                    CCY                                        AR747438
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   EVAL      PINDEC = A6NBDP
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    PINAMT
     C                   PARM                    PINDEC
     C                   PARM                    PINCODE
     C                   PARM      *BLANKS       PINCHAR
     C                   PARM      *BLANKS       POUTAMT
 
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
     C                   Parm                    PSEQ              5
     C                   Parm                    PENTY             3
     C                   Parm                    PARMS           100
 
      ** Initialise LDA field
     C                   EVAL      DBPGM = 'DL0720'
 
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
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access RUNDAT for multibranching indicator
     C                   IN        RUNDAT
     C                   MOVE      AGMRDT        RRRUNA
     C                   MOVE      BJURPT        RRTITL                                       239233
 
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
 
      ** Initialize Amount and Work Fields
     C                   Z-ADD     0             WCOUNT
     C                   MOVE      'Y'           WFIRST
     C                   MOVE      'N'           WOPEN
 
      ** Setup DealType/SubType Narrative
     C                   MOVE      PDealType     S0DTYP
     C                   MOVE      PDealSubType  S0DLST
     C                   MOVE      PDealClass    S0CLAS                                       CDL038
 
     C                   IF        PDealType <> '**'
     C                   MOVE      '1'           *IN40
     C                   ENDIF
 
     C                   IF        PDealType <> '**' AND
     C                             PDealSubType = '**'
     C                   MOVE      'xx'          S0DLST
     C                   ENDIF
 
      ** Access Dealing ICD Details                                                         AR747438
      *                                                                                     AR747438
     C                   CALL      'AODEALR0'                                               AR747438
     C                   PARM      *BLANKS       @RTCD             7                        AR747438
     C                   PARM      '*FIRST '     @OPTN             7                        AR747438
     C     SDDEAL        PARM      SDDEAL        DSFDY                                      AR747438
      *                                                                                     AR747438
     C     @RTCD         IFNE      *BLANKS                                                  AR747438
     C     *LOCK         IN        LDA                                                      AR747438
     C                   EVAL      DBFILE = 'SDDEALPD'                                      AR747438
     C                   EVAL      DBASE = 5                                                AR747438
     C                   EVAL      DBKEY = @OPTN                                            AR747438
     C                   EVAL      *INU7 = *ON                                              AR747438
     C                   EVAL      *INU8 = *ON                                              AR747438
     C                   EVAL      *INLR = *ON                                              AR747438
     C                   OUT       LDA                                                      AR747438
     C                   EXSR      *PSSR                                                    AR747438
     C                   ENDIF                                                              AR747438
      *                                                                                     AR747438
      ** System values
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C**********         PARM                    SVALK1           20                        AR747438
     C                   PARM      SVAL(1)       SVALK1           20                        AR747438
     C                   PARM                    SVAL1           200
     C**********         PARM                    SVALK2           20                        AR747438
     C                   PARM      SVAL(2)       SVALK2           20                        AR747438
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
 
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK0        DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE                                                               AR747438
     C                   Z-ADD     0             ROLDAY            2 0                      AR747438
     C                   MOVEL     SVAL1         AUTOAU            1                        AR747438
     C                   MOVEL     SVAL2         ROLDNU            2                        AR747438
     C                   MOVE      ROLDNU        ROLDAY                                     AR747438
     C                   ENDIF
      *
      ***If*Rollovr*Processing*is*On,*find*Number*of*Rollover*Days*****                     AR747438
     C*****SVAL11        IFEQ      'Y'                                                      AR747438
     C*                  MOVE      '1'           HKROLDAYS
     C**********         ENDIF                                                              AR747438
 
      ** Generating non-authorized deals requires one extra days notice                     AR747438
      *                                                                                     AR747438
     C     AUTOAU        IFEQ      'N'                                                      AR747438
     C     BNMMAU        OREQ      'Y'                                                      AR747438
     C                   ADD       1             ROLDAY                                     AR747438
     C                   ENDIF                                                              AR747438
      *                                                                                     AR747438
      ** Open Printer File and Write Header
     C                   OPEN      DL0720P1
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
     C                   Parm                    PSEQ
     C                   Parm                    PENTY
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
      *  Calls    :                                                   *
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
     C                   WRITE     DL0720R4
     C                   CLOSE     DL0720P1
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
     C/COPY ZSRSRC,ZACCHLE                                                                  AR747438
     C/COPY ZSRSRC,ZBKDT_ILE                                                                AR747438
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
**  MONTH SHORTNAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   SVAL  -  SYSTEM VALUES ARRAY                                                           AR747438
AutAuthRollDeal                                                                             AR747438
RolloverDays                                                                                AR747438
