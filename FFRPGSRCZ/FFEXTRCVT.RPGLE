     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exchange-traded convert')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFEXTRCVT - Exchange-traded conversion: file to screen       *
      *              format                                           *
      *                                                               *
      *  Function:  This module converts the fields of an exchange-   *
      *             traded from their format on file to               *
      *             a screen format.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP191             Date 26Nov09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188671             Date 12Jan01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 06Sep99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 06Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  188671 - Spot price not formatted correctly.                 *
      *  CPB001 - 'Private Banking' Module                            *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface                               *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of FF inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FINTYP2    IF   E           K DISK
     F                                     RENAME(INTYPDF:INTYP2DF)
     FINTYP     IF   E           K DISK
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
     D  NoRecFound            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     D TranFilFmt    E DS                  EXTNAME(TRANSD)
      * Transaction in File Format
 
     D TranScnFmt    E DS                  EXTNAME(FFEXTRPD)
      * Transaction in Screen Format
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
      **   Months Short Names
 
     D ISTTK           DS             5
      *   Key to LF/INTYP
      *   Also, re-defines Instr. Type  into Mkt Centre + Instr. Code
     D  KISTT                  1      5
     D  KMRKT                  1      2
     D  KISTC                  3      5
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Market
     D Market          S              2A
 
      * Price (File Format)
     D FFPRIC          S             15P 8
 
      * Ticks Denominator
     D FFTKDM          S              3P 0
 
      * Minimum Price Fluctuation
     D FFMNPF          S             15P 8
 
      * Price (Screen Format)
     D FFSPRC          S             16A
 
      ** Message ID for 'DELETED' text
     D DeletedMsg      S              7A   INZ('ZZM1614')
 
      ** Message file for above message ID
     D MessageFil      S             10A   INZ('ZZGBMSGF')
 
      ** Message text from above message ID
     D MessageTxt      S             80A
 
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
 
     D ZDAYNO          S              5  0                                                    CFF007
     D ZDATE           S              6  0                                                    CFF007
     D ZADATE          S              7                                                       CFF007
     D PFRNT           S             20A                                                      CAP191
     D PAFRT           S             20A                                                      CAP191
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      **************************************************************
 
     IINTYPDF
     I*    Instrument Types
     I*
     I              RECI                        ITRECI
     I              BCPT                        BCPTI
     I              CCPT                        CCPTI
     I              CTAM                        FFCTAM                          AUS022
     I              CNTT                        FFCNTT                          AUS022
     I              CHTP                        ITCHTP                          AUS022
 
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
      **************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * INITIALISATION
     C                   EXSR      INIT
      *
      ** SET OUTPUT SCREEN FIELDS
      *
     C                   EXSR      SETFLD
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - SET OUTPUT SCREEN FIELDS
      *****************************************************************
     C     SETFLD        BEGSR
 
     C                   MOVE      ISTT          KISTT
     C     KISTT         CHAIN     INTYP                              99
     C                   IF        NoRecFound = True OR ITRECI <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     10            DBASE                          * DBERR 901*
     C                   MOVEL     'INTYP'       DBFILE                         ************
     C                   MOVEL     KISTT         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Transaction number.
     C                   MOVE      TNBR          STNBR
 
      **  Purchase or Sale.
     C                   MOVE      TRTY          STRTY
 
      **  Number of Contracts
     C                   Z-ADD     0             ZADEC             1 0
     C                   MOVEL     *BLANK        ZFIELD           16
     C                   MOVE      NUCO          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SNUCO
 
      **  Market
     C                   EVAL      SMRKT = %subst(ISTT : 1 : 2)
 
     C     MTHN          IFNE      00
      **  Instrument
     C                   MOVE      ISTT          SISTC
 
      **  Month
     C                   MOVE      ZMNM(MTHN)    SMTHN
 
      **  Year
     C                   MOVE      YRNO          SYRNO
     C                   ENDIF
 
      **  Put/Call indicator
     C                   MOVE      PCAL          SPCAL
 
      **   'Futures'
     C     ISPT          IFLE      3
     C     ISPT          OREQ      7                                                           AUS02
 
      **  Strike Price not allowed for futures
     C                   MOVE      *BLANK        SSTRP
      **   'Options'
     C                   ELSE
 
      **  Strike Price
 
      **   If a Market Instrument Trade, access Future Type Ref. for
      **    Min Price Fluctn + Ticks Denom.
 
     C                   MOVEL     SMRKT         KFTRF             5
     C                   MOVE      FTRF          KFTRF
 
     C     KFTRF         CHAIN     INTYP2DF                           99
 
     C                   IF        NoRecFound = True OR RECI2 <> 'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     11            DBASE                          ** DBERR  09 **S0111
     C                   MOVE      'INTYP'       DBFILE
     C                   MOVEL     KFTRF         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     TKDM2         FFTKDM            3 0
     C                   Z-ADD     MNPF2         FFMNPF           15 8
 
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
 
     C                   MOVE      FFSPRC        SSTRP
 
     C                   ENDIF
 
      **  Portfolio Reference
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'                                                         CPM00
     C     PTFR          ANDNE     *BLANKS                                                     S0123
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     PTFR          ANDNE     *BLANKS                                      CPB001
     C     PTFR          IFNE      '9997'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C                   MOVEL     PTFR          SPTFR                                         S0123
     C                   ELSE                                                                  S0123
     C                   MOVE      FCR997        SPTFR                                         CPM00
     C                   ENDIF                                                                 S0123
     C                   ELSE                                                                  S0123
     C                   MOVE      *BLANKS       SPTFR                                         S0123
     C                   ENDIF                                                                 S0123
 
      **  Contract Price
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
 
     C                   MOVE      FFSPRC        SCOPR
 
      **  Trade Date
 
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    TRSD              5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
 
     C                   MOVE      ZDATE         STRSD
 
      **  Broker
     C*****BOCO*         IFEQ      0                                                          CSD027
     C     BOCO          IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      *BLANK        SBOCO
     C                   ELSE
     C                   MOVEL     BOCO          SBOCO
     C                   ENDIF
 
      **  Customer
     C*****CUSC*         IFEQ      0                                                          CSD027
     C     CUSC          IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      *BLANK        SCUSC
     C                   ELSE
     C                   MOVEL     CUSC          SCUSC
     C                   ENDIF
 
      **  Book Code
     C                   MOVE      BOKC          SBOKC
 
      **  Booking Branch
     C                   MOVE      BRCA          SBRCD
 
      **  Narrative
     C                   MOVE      TNAR          STNAR
 
      **  To Be Left Open
     C                   MOVE      TBLO          STBLO
 
      **  Linked Reference Number
 
     C     LNKR          IFEQ      0
     C                   MOVE      *BLANK        SLNKR
     C                   ELSE
     C                   MOVE      LNKR          SLNKR
     C                   ENDIF
 
      **  Originating Branch
     C                   MOVE      ORBR          SORBR
 
      **  Profit Centre
     C                   MOVE      PRFC          SPRFC
 
      ** Book position profit centre
     C                   MOVE      BPRC          SBPRC
 
      ** Transaction position profit centre
     C                   MOVE      TPRC          STPRC
 
      ** If trade is deleted, set up the screen text
     C                   IF        CHTP = 'D'
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    DeletedMsg
     C                   PARM                    MessageFil
     C                   PARM                    MessageTxt
 
     C                   EVAL      FFSTS = %subst(MessageTxt : 1 : 24)
 
     C                   ENDIF
                                                                                CPL002
      ** If Plato interface present, then format Spot Price.                    CPL002
 
     C     BGN2ST        IFEQ      'Y'                                          CPL002
                                                                                CPL002
     C                   Z-ADD     PLSPTP        FFPRIC           15 8          CPL002
     C                   Z-ADD     TKDM2         FFTKDM                                       188671
     C                   Z-ADD     MNPF2         FFMNPF                                       188671
      **   - format price                                                       CPL002
     C                   RESET                   ReturnCode                     CPL002
     C                   CALLB     'FFPRCS'                                     CPL002
      ** Parameters returned from called procedure                              CPL002
      ** -----------------------------------------                              CPL002
      ** Return code                                                            CPL002
     C                   PARM                    ReturnCode                     CPL002
      ** Screen version of price (16A)                                          CPL002
     C                   PARM                    FFSPRC                         CPL002
                                                                                CPL002
      ** Parameters passed to called procedure                                  CPL002
      ** -------------------------------------                                  CPL002
      ** File version of price (15,8P)                                          CPL002
     C                   PARM                    FFPRIC                         CPL002
      ** Tick denominator (3,0P)                                                CPL002
     C                   PARM                    FFTKDM                         CPL002
      ** Minimum price fluctuation (15,8P)                                      CPL002
     C                   PARM                    FFMNPF                         CPL002
                                                                                CPL002
     C                   MOVE      FFSPRC        SSPTP                          CPL002
                                                                                CPL002
     C                   ENDIF                                                  CPL002
                                                                                CPL002
      ** If PB module and CFF007 are installed                                                CFF007
                                                                                              CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     BGN4ST        IFEQ      'Y'                                                        CFF007
     C                   MOVE      COVE          SCOVE                                        CFF007
     C                   MOVE      HETR          SHETR                                        CFF007
     C                   MOVE      BLUP          SBLUP                                        CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      *Blanks       SCOVE                                        CFF007
     C                   MOVE      *Blanks       SHETR                                        CFF007
     C                   MOVE      *Blanks       SBLUP                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   MOVE      VALD          ZDAYNO                                       CFF007
     C                   CALLB     'ZDATE2'                                                   CFF007
     C                   PARM                    ZDAYNO                                       CFF007
     C                   PARM                    BJDFIN                                       CFF007
     C                   PARM      *ZEROS        ZDATE                                        CFF007
     C                   PARM      *BLANKS       ZADATE                                       CFF007
                                                                                              CFF007
     C                   MOVEL     ZDATE         SVALD                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Front Office Transaction ID                                                          CAP191
                                                                                              CAP191
     C                   EVAL      PFRNT = FRNT                                               CAP191
                                                                                              CAP191
      ** Associated Front Office Transaction ID                                               CAP191
                                                                                              CAP191
     C                   EVAL      PAFRT = AFRT                                               CAP191
                                                                                              CAP191
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
 
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN TRANSACTION FORMAT)
      *
     C                   MOVEL     SACTN         ##ACTN            1
     C                   MOVEL     *BLANK        TranScnFmt
     C                   MOVEL     ##ACTN        SACTN
     C                   MOVEL     *BLANK        FFSTS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      * ~~~~~~
      * Return Code
     C                   PARM                    ReturnCode
      * Transaction in file format
     C                   PARM                    TranFilFmt
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      * OUTPUTS
      * ~~~~~~~
 
      * Transaction in screen format
     C                   PARM                    TranScnFmt
      * Transaction Status
     C                   PARM                    FFSTS            24
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
      ** Front Office Transaction ID                                                          CAP191
      ** Associated Front Office Transaction ID                                               CAP191
     C                   PARM                    PFRNT                                        CAP191
     C                   PARM                    PAFRT                                        CAP191
                                                                                              CAP191
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
