     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE MT101/MT103 Generation by Sweep Report')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE102007 - RE MT101/MT103 Generation by Sweep Report         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 212367             Date 10Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212367 - Various reporting errors                            *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         EOF of REICSDL5                                 *
      *    02         Chain Fail in MGOREFL0                          *
      *    03         LOOKUP indicator                                *
      *    04         Branch indicator                                *
      *    05         From and To Dates indicator                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialisation                                       *
      * SRPROC - Detail Processing                                    *
      * SRAUDT - Audit Printing                                       *
      * SRPRNT - Detail Printing                                      *
      * SRRCFAU - Audit Spool File recorded by RCF                    *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** Master Messages Reference by TRNO
     FMGOREFL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Input Cycle Zero Balancing/Sweeping Dtls by Reference File
     FREICSDL5  IF   E           K DISK    INFSR(*PSSR)
 
      ** MT101/MT103 Generation by Sweep Audit Report
     FRE102007AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      ** MT101/MT103 Generation by Sweep Detail Report
     FRE102007P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for customer details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - long  data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** RUNDAT dataarea
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
     D TABCD           S              4    DIM(49) CTDATA PERRCD(1)
     D TABNAR          S             35    DIM(49) ALT(TABCD)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
      **  Parameters - 100 long string passed to RCF
     D PParm           DS            12
     D  WFMDAT                 1      6
     D  WFMYY                  1      2
     D  WFMMM                  3      4
     D  WFMDD                  5      6
     D  WTODAT                 7     12
     D  WTOYY                  7      8
     D  WTOMM                  9     10
     D  WTODD                 11     12
 
      **  Data structure for Date of Generation (yymmdd)
     D WADATE          DS
     D  GENYY                  1      2
     D  GENMM                  3      4  0
     D  GENDD                  5      6
 
      **  Data structure for Date of Generation (yymmdd)
     D W@DATE          DS
     D  GEN@Y                  1      2  0
     D  GEN@M                  3      4  0
     D  GEN@D                  5      6  0
 
      **  Data structure for Time of Generation (hh:mm:ss)
     D WATIME          DS
     D  GENHH                  1      2
     D  GENMN                  3      4
     D  GENSS                  5      6
 
      **  Data structure for FROM date (ddmmyy or mmddyy)
     D FMDAT           DS
     D  FMDM                   1      4
     D  FMYY                   5      6
 
      **  Data structure for TO date (ddmmyy or mmddyy)
     D TODAT           DS
     D  TODM                   1      4
     D  TOYY                   5      6
 
      **  Data structure for Gen date (ddmmyy or mmddyy)
     D GENDAT          DS
     D  GENDM                  1      4  0
     D  GENYR                  5      6  0
 
      ** Parameters for ZSEDIT
     D PZFld15         S             15  0
     D PZDecs          S              1  0
     D PZECode         S              1
     D PZOut21         S             21
 
      ** File Information Data Structure for RE102007P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for RE102007AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PCURR           S              3
 
      ** Parameter for calling ZDATE2
     D PDayN           S              5P 0
     D PFMT            S              1
     D PDATE           S              6  0
     D PADATE          S              7
     D GenDayN         S              5P 0
     D FMDayN          S              5P 0
     D TODayN          S              5P 0
 
      ** Parameter for program entry
     D PLevel          S              1
     D PEnty           S              3
 
     D CRE008          S              6
     D DifLn1          S              4P 0
     D PBRCA           S              3
     D RBRCA           S              3
     D RGEN            S              7
     D ReturnCode      S             10A
     D RqdLn1          S              3P 0
     D***WCACD**         S              4                                                     CGL029
     D WCACD           S             10                                                       CGL029
     D WCASN           S              2
     D WCUST           S              6
     D W_DATE          S              3
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   EXSR      SRAUDT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRRCFAU, ZAVDATE                                       *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** RCF Processing for Audit File.
 
     C                   EXSR      SRRCFAU
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      RCount  = 0
     C                   EVAL      PrtLn1  = 0
 
     C                   EVAL      FMYY = WFMYY
     C                   EVAL      FMDM = WFMDD
     C                   MOVE      WFMMM         FMDM
     C                   CALLB     'ZAVDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    FMDAT
     C                   PARM                    BJDFIN
     C                   PARM                    FMDayN
 
     C                   EVAL      TOYY = WTOYY
     C                   EVAL      TODM = WTODD
     C                   MOVE      WTOMM         TODM
     C                   CALLB     'ZAVDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    TODAT
     C                   PARM                    BJDFIN
     C                   PARM                    TODayN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRSYSLEV, SRALLBRC, SRSNGBRC                           *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   SELECT
 
      ** Level selected at Sytem Level
 
     C     PLevel        WHENEQ    'S'
     C                   EXSR      SRSYSLEV
 
      ** Level selected at Branch Level and selected branch is ALL
 
     C     PLevel        WHENEQ    'B'
     C     PEnty         ANDEQ     'ALL'
     C                   EXSR      SRALLBRC
 
      ** Level selected at Branch Level and selected branch is not ALL
 
     C     PLevel        WHENEQ    'B'
     C     PEnty         ANDNE     'ALL'
     C                   EXSR      SRSNGBRC
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSYSLEV - System Level Processing                            *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSYSLEV      BEGSR
 
     C                   EVAL      *IN04 = *OFF
 
      ** RCF Processing for printer file
 
     C                   CLOSE     RE102007P1
     C                   OPEN      RE102007P1
     C                   EXSR      SRRCFP1
 
     C     *LOVAL        SETLL     REICSDD0
     C                   READ      REICSDD0                               01
     C                   DOW       *IN01 = *OFF
     C                   EXSR      SRPRNT
     C                   READ      REICSDD0                               01
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   IF        RCount > 0
     C                   WRITE     TRAILP2
     C                   ENDIF
 
     C                   CLOSE     RE102007P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRALLBRC - All Branch Processing                              *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRALLBRC      BEGSR
 
     C                   EVAL      *IN04 = *ON
 
      ** RCF Processing for printer file
 
     C                   CLOSE     RE102007P1
     C                   OPEN      RE102007P1
     C                   EXSR      SRRCFP1
 
     C     *LOVAL        SETLL     REICSDD0
     C                   READ      REICSDD0                               01
 
     C                   DOW       *IN01 = *OFF
     C                   EVAL      RBRCA = IDCBRC
     C                   EXSR      SRPRNT
     C                   READ      REICSDD0                               01
 
     C                   IF        IDCBRC <> RBRCA AND *IN01 = *OFF
     C                   WRITE     TRAILP1
     C                   CLOSE     RE102007P1
     C                   OPEN      RE102007P1
     C                   EVAL      RBRCA = IDCBRC
     C                   WRITE     HEADP1
     C                   EXSR      SRRCFP1
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   IF        RCount > 0
     C                   WRITE     TRAILP1
     C                   WRITE     TRAILP2
     C                   ENDIF
 
     C                   CLOSE     RE102007P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNGBRC - Single Branch Processing                           *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSNGBRC      BEGSR
 
     C                   EVAL      *IN04 = *ON
     C                   EVAL      PBRCA = PEnty
 
      ** RCF Processing for printer file
 
     C                   CLOSE     RE102007P1
     C                   OPEN      RE102007P1
     C                   EXSR      SRRCFP1
 
     C     PBRCA         SETLL     REICSDD0
 
      ** Read Input Cycle Zero Balancing/Sweeping - Detail
 
     C     PBRCA         READE     REICSDD0                               01
 
     C                   DOW       *IN01 = *OFF
     C                   EVAL      RBRCA = IDCBRC
     C                   EXSR      SRPRNT
     C     PBRCA         READE     REICSDD0                               01
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   IF        RCount > 0
     C                   WRITE     TRAILP2
     C                   ENDIF
 
     C                   CLOSE     RE102007P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNT - Detail Printing                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: ZAVDATE                                                *
      *                                                               *
      *****************************************************************
     C     SRPRNT        BEGSR
 
      ** Check if T.R.N. in PF/MGOREFPD
 
     C     IDOMSR        CHAIN     MGOREFL0                           02
 
     C                   IF        *IN02 = *ON
     C                   EVAL      X_ERMS = 'Chain to MGOREFPD in error'
     C                   EVAL      RDESC = X_ERMS
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      MGDE          W@DATE
     C                   Z-ADD     GEN@Y         GENYR
     C                   Z-ADD     GEN@M         GENDM
     C                   MOVEL     GEN@D         GENDM
     C                   CALLB     'ZAVDATE'
     C                   PARM                    ReturnCode
     C                   PARM                    GENDAT
     C                   PARM                    BJDFIN
     C                   PARM                    GenDayn
 
     C                   IF        (*IN05 = *ON and GenDayN >= FMDayN and
     C                              GenDayN <= TODayN) OR
     C                             (*IN05 = *ON and GenDayN >= FMDayN and
     C                              WTODAT = *BLANK) OR
     C                             (WFMDAT = *BLANKS and WTODAT = *BLANKS)
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        RCOUNT = 0 OR
     C                             DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Obtain Transaction Reference and Destination
 
     C                   EVAL      RTRNO = IDOMSR
     C                   EVAL      RDEST = NWDS
 
      **  Obtain Message Type
 
     C*******************IF        IDSTYP = 'T'                                 212367
     C                   IF        IDTPSW = 'T'                                 212367
     C                   EVAL      RMTYP = 'MT101'
     C                   ELSE
     C                   EVAL      RMTYP = 'MT103'
     C                   ENDIF
 
      **  Obtain Amount
 
     C                   Z-ADD     IDSWFA        PZFld15
     C                   EXSR      SRAMNT
     C                   MOVE      PZOut21       RAMTA
 
      ** Convert Midas Day number to ddmmyy/mmddyy
 
     C                   EVAL      PDAYN  = IDVALD
     C                   EXSR      SRDATE
     C                   EVAL      RVDAT = PADATE
 
      ** Obtain Generation Date/Time
 
     C                   MOVE      MGDE          WADATE
     C                   MOVE      ZMNM(GENMM)   W_DATE
     C     GENDD         CAT       W_DATE        RGEN
     C                   MOVE      GENYY         RGEN
     C                   MOVE      MGTM          WATIME
     C                   EVAL      RGEND = RGEN  + '/' + GENHH + ':' +
     C                             GENMN + ':' + GENSS
 
      **  Obtain status description
 
     C     MGST          LOOKUP    TABCD         TABNAR                   03
     C                   IF        *IN03 = *ON
     C                   EVAL      RMGST = TABNAR
     C                   ELSE
     C                   EVAL      RMGST = MGST
     C                   ENDIF
 
      **  Obtain Account details
 
     C                   MOVEL     IDCCUS        WCUST
     C                   MOVEL     IDCACD        WCACD
     C                   MOVEL     IDCASN        WCASN
     C                   EVAL      RACNT = IDCBRC + '-' + WCUST + '-' +
     C                                     IDCCCY + '-' + WCACD + '-' + WCASN
 
     C                   If        IDDSTT = 'R' or
     C                             IDDSTT = 'N'
     C                   Movel     IDDEST        RSETA
     C                   Else
     C                   Movel     IDSNDC        RSETA
     C                   Endif
     C                   EVAL      REXAC = IDEXA1
 
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Printing                                       *
      *                                                               *
      * Called by: Main Processing, SRPROC, *PSSR                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
      ** Write Audit Header
 
     C                   WRITE     HEADAU
 
     C                   IF        *INU7 = '1' AND
     C                             *INU8 = '1'
 
      ** Write Database Error Report
 
     C                   WRITE     DBERROR
     C                   ELSE
 
     C                   IF        RCOUNT = 0
 
      ** Write No Details to Report
 
     C                   WRITE     NODTLS
     C                   ELSE
 
      ** Write Audit Control Report
 
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = '1'
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
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
      * SRRCFAU - Audit Spool File recorded by RCF                    *
      *                                                               *
      * Called by: SRINIT                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
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
      * SRAMNT - Convert Amount                                       *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: AOCURR0, ZSEDIT                                        *
      *                                                               *
      *****************************************************************
 
     C     SRAMNT        BEGSR
 
      ** Access currency file to get decimal places
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      IDCCCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOCURRR0 in error'
     C                   EVAL      RDESC = X_ERMS
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     A6NBDP        PZDecs
     C                   ENDIF
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecs
     C                   PARM      'J'           PZECode
     C                   PARM                    PZOut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE - Convert Value Date                                   *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDAYN
     C                   PARM      BJDFIN        PFMT
     C                   PARM      *ZERO         PDATE
     C                   PARM      *BLANKS       PADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, AOSARDR0                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
     C                   PARM                    PParm
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EVAL      RDESC = X_ERMS
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Access SAR details file to see if CRE008 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CRE008'      PSARD
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOSARDR0 in error'
     C                   EVAL      RDESC = X_ERMS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CRE008 = 'Y'
     C                   ELSE
     C                   EVAL      CRE008 = 'N'
     C                   ENDIF
 
      **  Blank out from and to dates if defaulted to *ALL from prompt program
     C                   IF        WFMDAT = '*ALL  ' And WTODAT = '*ALL  '
     C                   Eval      PPARM = *Blanks
     C                   ENDIF
 
      **  Check to see if the dates are blank
 
     C                   IF        WFMDAT <> *BLANKS Or  WTODAT <> *BLANKS
     C                   EVAL      *IN05 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R --- A B N O R M A L  E R R O R  C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** TABCD/TABNAR - Table of Status/Narrative.
CRTDCreated
AMNDAmended
DLTDDeleted
RSNDRdy to send
PENDPending Trans
TRANTransmitted
EFMT#Format err¢
ELAU#Lgl Aut err¢
ESEQ#Inp seq err¢
ETID#Term ID err¢
ELEN#Length err¢
EAUT#SW auth err¢
QRDQ#RDYQ error¢
QVRQ#VRYQ error¢
LACKLogical ack
NACK#Neg ack¢
EBL1#Err bas hd¢
EBL2#Err app hd¢
EBL4#Err text¢
EBL5#Err trlr¢
PRTDPrinted
RRTDRe-routed
TSNTSent
TOUTPending Tx
TCANCancelled
TRTYIn retry
TACTActive
TSENSent
THLEHeld - error
THLOHeld/Oper.
TBOXAt Telex box
TCNRCancel req.
TRELHeld on TlxQ
TWTGWaiting
TRTSRdy to send
TDESIn despatch
TONQOn Tlx queue
TCMPComplete
TUNKUnknown
TRRTRe-route Q
TDLTDeleted
TSPVSupervisor
THORHeld Origntr
THTCHeld Time C.
THLOHeld by Oper
TCARAt Carrier
THOPHeld by Oper
TIRSItem Reset
TCNANot accountd
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
