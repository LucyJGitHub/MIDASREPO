     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exchange-traded browse')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFTRANBRW - Futures and Options trade browse                 *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of transactions for           *
      *             selection, the other picks off the selection made.*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249093             Date 11Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      *                 199332             Date 12Nov01               *
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 167405             Date 07Feb01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249093 - Futures and Option Input Enquiry screen list trades *
      *           ascending order.  It should list the trades in      *
      *           descending order so that new trades are at the top. *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP166 - API for Non-Currency OTC                            *
      *  199332 - Non-currency OTC transactions shown via F15 in the  *
      *           OTC Midas menu option.                              *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  167405 - Show 'DELETED' remark for RECI = 'R'.               *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFTRANBDF CF   E             WORKSTN
     F                                     SFILE(FFTRANS1:@@RRN)
     F                                     SFILE(FFTRANS3:@@RRN)
 
      ** Exchange-traded FOs by transaction reference
     FFFEXTRL0  IF   E           K DISK    INFSR(*pssr)
     F                                     RENAME(TRANSDF : EXTRBO)
     F                                     USROPN
 
      ** Exchange-traded FOs by front-office ID
     FFFEXTRL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRANSDF : EXTRFO)
     F                                     USROPN
 
      ** Over-the-couner currency options by transaction reference
     FFFOTCCL0  IF   E           K DISK    INFSR(*pssr)
     F                                     RENAME(TRANSDF : OTCCBO)
     F                                     USROPN
 
      ** Over-the-couner currency options by front-office ID
     FFFOTCCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRANSDF : OTCCFO)
     F                                     USROPN
 
     FINTYP2    IF   E           K DISK
     F                                     RENAME(INTYPDF:INTYP2DF)
 
     FINTYP     IF   E           K DISK
 
     F/COPY WNCPYSRC,FFTRANBF01
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the FF standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the named constants
      ** used specifically in FF.
     D/COPY FFCPYSRC,NAMEDCONST
      **--------------------------------------------------------------------------------------------
 
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  NoRecFOCLT            98     98
      ** ¦                                                                ¦
     D  NoRecFound            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D MarketDS      E DS                  EXTNAME(MARKT)
      ** Market centre data structure to return
 
     D ISTTK           DS             5
      *   Key to LF/INTYP
      *   Also, re-defines Instr. Type  into Mkt Centre + Instr. Code
     D  KISTT                  1      5
     D  KMRKT                  1      2
     D  KISTC                  3      5
 
 
     D DDINSD          DS            22
      ** Instrument details
     D  DDPCAL                 1      1
     D  DDSTRP                 2     17
     D  DDMNTH                18     20
     D  DDYEAR                21     22
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Price (File Format)
     D FFPRIC          S             15P 8
 
      * Ticks Denominator
     D FFTKDM          S              3P 0
 
      * Minimum Price Fluctuation
     D FFMNPF          S             15P 8
 
      * Price (Screen Format)
     D FFSPRC          S             16A
 
      * Transaction number for chaining
     D @@TNBR          S              6S 0
 
      * Front-office transaction ID for chaining
     D @@Front         S             20A
 
      * Saved version of RECI
     D SavedRECI       S                   LIKE(RECI)
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     IINTYPDF
     I*    Instrument Types
     I*
     I              BCPT                        BCPTI
     I              CCPT                        CCPTI
     I              CTAM                        FFCTAM                          AUS022
     I              CNTT                        FFCNTT                          AUS022
     IINTYP2DF
     I*    Selected Instrument Type details
     I*
     I              RECI                        RECI2
     I              ISTT                        ISTT2
     I              ISTI                        ISTI2
     I              ISPT                        ISPT2
     I              ISCY                        ISCY2
     I              QOTC                        QOTC2
     I              TKDM                        TKDM2
     I              MNPF                        MNPF2
     I              TKVL                        TKVL2
     I              OTHC                        OTHC2
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * INITIALIZATION
     C                   EXSR      INIT
 
      * BUILD SUB-FILE
     C     @BDSFL        IFEQ      'Y'
 
      **  If First time in or subfile by Midas deal number was previously
      **  being run, then build subfile keyed on Midas deal number.
      **  Stay in loop while F11 toggle key is used.
     C     WDEAL         IFNE      'F'
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL
 
      **  If F11, switch to Front Office Deal subfile
     C     *INKK         IFEQ      '1'
     C                   EXSR      BLDSFL2
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
 
      **  If the subfile by Front Office Identifier was previously
      **  being run, then build subfile keyed on Front Office ID.
      **  Stay in loop while F11 toggle key is used.
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL2
 
      **  If F11, switch to Midas Deal Number subfile
     C     *INKK         IFEQ      '1'
     C                   EXSR      BLDSFL
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
 
      * READ SUBFILE RECORD
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
 
      * Set indicator and flag for Midas back office transaction reference
      * key used.
     C                   MOVE      'B'           WDEAL
 
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
 
      ** Validate Transaction Number
     C                   EXSR      VALTRN
 
      **  Initialise subfile relative record number.
     C                   Z-ADD     0             @@RRN             5 0
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
     C                   MOVE      '1'           *IN97
     C                   WRITE     FFTRANS0
     C                   MOVE      '0'           *IN97
 
      **  Write the select screen footer to the screen.
     C                   WRITE     FFTRANF1
 
      **  Set file pointer on key displayed on screen.
     C                   IF        TransType = ExchTrade
     C**** @@TNBR        SETLL     FFEXTRL0                                                   249093
     C     @@TNBR        SETGT     FFEXTRL0                                                   249093
     C                   ELSE
     C     @@TNBR        SETLL     FFOTCCL0
     C                   ENDIF
 
      * READ A VALID TRANSACTION
     C                   EXSR      RDTRAD
 
      **  If no records exist - set up an error message.
      **  and terminate
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C**********         ADD       1             @@RRN                                        199332
     C**********         ADD       1             @@CNT                                        199332
      *
      * Format transaction fields for output
      *
     C                   EXSR      FMTTRD
      *
      **  Write the transaction to the subfile.
      *
     C     Transtype     IFEQ      ExchTrade                                                  199332
     C     Transtype     OREQ      OTCCurr                                                    199332
     C     ISPT          ANDEQ     5                                                          199332
     C     Transtype     OREQ      OTCOvar                                                    CAP166
     C     ISPT          ANDEQ     4                                                          CAP166
     C     Transtype     OREQ      OTCOvar                                                    CAP166
     C     ISPT          ANDEQ     6                                                          CAP166
     C                   ADD       1             @@RRN                                        199332
     C                   ADD       1             @@CNT                                        199332
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     FFTRANS1
     C                   ENDIF                                                                199332
      *
      * READ A VALID TRANSACTION
      *
     C                   EXSR      RDTRAD
     C                   ENDDO
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FFTRANS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FFTRANS0                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
 
     C     WDEAL         IFNE      'F'
     C                   READC     FFTRANS1                               99
     C                   ELSE
     C                   READC     FFTRANS3                               99
     C                   ENDIF
 
     C                   ENDDO
      *
      **  Return the selected transaction number
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C/COPY WNCPYSRC,FFTRANBC01
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   ENDIF
      *
     C                   MOVE      DDTNBR        @TRSEL
     C                   IF        TransType = ExchTrade
     C                   MOVEL     DDISTT        @MBSEL
     C                   ELSE
     C                   MOVEL     *BLANK        @MBSEL
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTTRD - FORMAT TRANSACTION FIELDS FOR OUTPUT
      ******************************************************************
     C     FMTTRD        BEGSR
      *
      * Transaction number
      *
     C                   MOVEL     TNBR          DDTNBR
      *
      * Front Office Deal number
      *
     C                   MOVEL     FRNT          DDFODN
      *
      * Buy/Sell indicator
      *
     C                   MOVEL     TRTY          DDTRTY
      *
      * Type
      *
     C                   EVAL      DDISTT = ISTT
 
      * Get ticks denominator and minimum price fluctuation so that
      * we can correctly format the contract and strike price for screen
      * output.
     C                   MOVE      ISTT          KISTT
     C     KISTT         CHAIN     INTYP                              99
 
     C                   IF        NoRecFound = True OR RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     8             DBASE                          * DBERR 901*
     C                   MOVEL     'INTYP'       DBFILE                         ************
     C                   MOVEL     KISTT         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      **   'Futures'
     C     ISPT          IFLE      3
     C     ISPT          OREQ      7                                                           AUS02
     C                   MOVE      *BLANK        DDSTRP
      **   'Options'
     C                   ELSE
 
      **  Strike Price
 
      **   If a Market Instrument Trade, access Future Type Ref. for
      **    Min Price Fluctn + Ticks Denom.
     C                   IF        TransType = ExchTrade
     C                   MOVEL     DDISTT        KFTRF             5
     C                   MOVE      FTRF          KFTRF
 
     C     KFTRF         CHAIN     INTYP2DF                           99
 
     C                   IF        NoRecFound = True OR RECI2 <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     9             DBASE                          ** DBERR  09 **S0111
     C                   MOVE      'INTYP'       DBFILE
     C                   MOVEL     KFTRF         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     TKDM2         FFTKDM            3 0
     C                   Z-ADD     MNPF2         FFMNPF           15 8
 
     C                   ELSE
     C                   Z-ADD     TKDM          FFTKDM
     C                   Z-ADD     MNPF          FFMNPF
     C                   END
 
     C                   Z-ADD     STRP          FFPRIC           15 8
      **   - format price
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Screen version of price (16A)
     C                   PARM                    FFSPRC
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
     C                   PARM                    FFPRIC
      ** Tick denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
     C                   MOVE      FFSPRC        DDSTRP
     C                   ENDIF
      *
      * Month/Year
      *
     C                   IF        TransType = ExchTrade
     C                   MOVEL     ZMNM(MTHN)    DDMNTH
     C                   MOVEL     YRNO          DDYEAR
     C                   ELSE
     C                   MOVEL     *BLANK        DDMNTH
     C                   MOVEL     *BLANK        DDYEAR
     C                   ENDIF
      *
      * Counterparty
      *
     C                   IF            (TransType = ExchTrade)
     C**********                   AND (BOCO <> 0 )                                           CSD027
     C                             AND (BOCO <> *BLANKS)                                      CSD027
     C                   MOVEL     BOCO          DDCPTY
     C                   ELSE
     C                   MOVEL     CUSC          DDCPTY
     C                   ENDIF
      *
      * Book
      *
     C                   MOVEL     BOKC          DDBOKC
      *
      * Contract Price
      *
     C                   Z-ADD     COPR          FFPRIC
     C                   Z-ADD     TKDM          FFTKDM
     C                   Z-ADD     MNPF          FFMNPF
      **   - format price
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Screen version of price (16A)
     C                   PARM                    FFSPRC
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
     C                   PARM                    FFPRIC
      ** Tick denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
     C                   MOVE      FFSPRC        DDCOPR
      *
      ** Put Call
     C                   MOVE      PCAL          DDPCAL
      *
      **  If the trade has been deleted then show this.
     C**********         IF        SavedRECI = '*'                                            167405
     C     SavedRECI     IFEQ      '*'                                                        167405
     C     SavedRECI     OREQ      'R'                                                        167405
     C                   MOVE      '1'           *IN95
     C                   MOVEL     'ZZGBMSGF'    MSGNM
     C                   MOVEL     'ZZM1614'     MSGDNB
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM                    MSGNM            10
     C                   PARM                    MSGTXT           80
     C                   MOVEL     MSGTXT        DDTEXT
     C                   ELSE
     C                   MOVE      '0'           *IN95
     C                   MOVE      *BLANKS       DDTEXT
     C                   ENDIF
     C                   ENDSR
 
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDTRAD - READ A TRANSACTION
      *****************************************************************
 
     C     RDTRAD        BEGSR
 
      **  Reset End of File indicator
     C                   MOVE      *BLANK        @@EOF             1
 
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
     C     @@EOF         DOUEQ     'Y'
     C     @@ERR         OREQ      *ZERO
     C     TRTY          ANDNE     'E'
 
      **  Read the file.
     C     WDEAL         IFEQ      'B'
 
     C                   IF        TransType = ExchTrade
     C*****              READ      FFEXTRL0                               96                  249093
     C                   READP     FFEXTRL0                               96                  249093
     C                   ELSE
     C                   READ      FFOTCCL0                               96
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        TransType = ExchTrade
     C*****              READ      FFEXTRL1                               96                  249093
     C                   READP     FFEXTRL1                               96                  249093
     C                   ELSE
     C                   READ      FFOTCCL1                               96
     C                   ENDIF
 
     C                   ENDIF
 
      * End of File
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
     C/COPY WNCPYSRC,FFTRANBC02
      *
      ** If transaction read, check whether user can see it
      *
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        IFEQ      *BLANK
 
     C/COPY WNCPYSRC,FFTRANBC03
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C/COPY WNCPYSRC,FFTRANBC04
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
      ** Save RECI for later checking
     C                   EVAL      SavedRECI = RECI
 
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C/COPY WNCPYSRC,FFTRANBC05
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
     C/COPY WNCPYSRC,FFTRANBC06
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTRN - VALIDATE TRANSACTION POINTER FIELDS
      *****************************************************************
     C     VALTRN        BEGSR
      *
      **  Validate that the transaction number is numeric or blank.
      *
     C                   TESTN                   FFTNBR               98
     C                   MOVE      FFTNBR        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     FFTNBR        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
 
     C     FFTNBR        IFEQ      *BLANKS
     C******             Z-ADD     *LOVAL        @@TNBR                                       249093
     C                   Z-ADD     *HIVAL        @@TNBR                                       249093
     C******             EVAL      @@Front = *loval                                           249093
     C                   EVAL      @@Front = *Hival                                           249093
     C                   ELSE
     C                   MOVE      FFTNBR        @@TNBR
     C                   EVAL      @@Front = DDFODN
     C                   ENDIF
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   MOVEL     'APM0112'     @ERRMS
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE (For Front Office ID)
      ********************************************************************
     C     BLDSFL2       BEGSR
 
      * Set indicator and flag for front office Id. key used
     C                   MOVE      'F'           WDEAL             1
 
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
 
      * Validate transaction reference
     C                   EXSR      VALTRN
 
      **  Initialise subfile relative record number.
     C                   Z-ADD     0             @@RRN             5 0
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
     C                   MOVE      '1'           *IN97
     C                   WRITE     FFTRANS2
     C                   MOVE      '0'           *IN97
 
      **  Write the select screen footer to the screen.
     C                   WRITE     FFTRANF1
 
      **  Set file pointer on key displayed on screen.
     C                   IF        TransType = ExchTrade
     C*****@@Front       SETLL     FFEXTRL1                                                   249093
     C     @@Front       SETGT     FFEXTRL1                                                   249093
     C                   ELSE
     C     @@Front       SETLL     FFOTCCL1
     C                   ENDIF
 
      * READ A VALID DEAL
     C                   EXSR      RDTRAD
 
      **  If no records exist - set up an error message.
      **  and terminate
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   RETURN
     C                   END
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C**********         ADD       1             @@RRN                                        199332
     C**********         ADD       1             @@CNT                                        199332
      *
      * Format Deal fields for output
      *
     C                   EXSR      FMTTRD
      *
      **  Write the deal to the subfile.
      *
     C     Transtype     IFEQ      ExchTrade                                                  199332
     C     Transtype     OREQ      OTCCurr                                                    199332
     C     ISPT          ANDEQ     5                                                          199332
     C     Transtype     OREQ      OTCOvar                                                    CAP166
     C     ISPT          ANDEQ     4                                                          CAP166
     C     Transtype     OREQ      OTCOvar                                                    CAP166
     C     ISPT          ANDEQ     6                                                          CAP166
     C                   ADD       1             @@RRN                                        199332
     C                   ADD       1             @@CNT                                        199332
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     FFTRANS3
     C                   ENDIF                                                                199332
      *
      * READ A VALID DEAL
      *
     C                   EXSR      RDTRAD
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FFTRANS2
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FFTRANS2                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      ** CLEAR OUTPUTS
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @TRSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
 
      ** Open the exchange-traded or over-the-counter files as approprate;
      ** close all first in case they were left open from a previous
      ** call.
     C                   CLOSE     FFEXTRL0                             99
     C                   CLOSE     FFEXTRL1                             99
     C                   CLOSE     FFOTCCL0                             99
     C                   CLOSE     FFOTCCL1                             99
 
     C                   IF        TransType = ExchTrade
     C                   OPEN      FFEXTRL0
     C                   OPEN      FFEXTRL1
     C                   ELSE
     C                   OPEN      FFOTCCL0
     C                   OPEN      FFOTCCL1
     C                   ENDIF
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      * INPUT PARAMETERS
      * RETURN CODE
     C                   PARM                    ReturnCode
      * TRANSACTION NUMBER POINTER
     C                   PARM                    FFTNBR            6
      * BUILD SUB-FILE
     C                   PARM                    @BDSFL            1
      * READ SUBFILE RECORD
     C                   PARM                    @RDSFL            1
     C                   PARM                    SDBANK
      * Transaction type (EXTR or OTCC)
     C                   PARM                    TransType
 
      * OUTPUT PARAMETERS
      * ERROR MESSAGE
     C                   PARM                    @ERRMS            7
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      * TRANSACTION NUMBER SELECTED
     C                   PARM                    @TRSEL            6
      * MEMBER SELECTED
     C                   PARM                    @MBSEL            2
 
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C/COPY WNCPYSRC,FFTRANBC07
 
 
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
