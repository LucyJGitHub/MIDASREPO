     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC convert file to screen fmt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCCCVT - Over-the-counter conversion: file to screen      *
      *              format                                           *
      *                                                               *
      *  Function:  This module converts the fields of an O.T.C       *
      *             from their format on file to a screen format.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 247471             Date 01May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 215528             Date 21Mar03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
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
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247471 - Calculate Premium Amount based on Premium currency. *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  215528 - System is associating a wrong premium amount.       *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CPB001 - 'Private Banking' Module                            *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface.                              *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of FF inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
     D TranFilFmt    E DS                  EXTNAME(TRANSD)
      * Transaction in File Format
 
     D TranScnFmt    E DS                  EXTNAME(FFOTCCPD)
      * Transaction in Screen Format
 
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
      ** Instrument types
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
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
 
      ** Contract type
     D FFCNTT          S              1S 0
 
      ** Number of contracts
     D FFNOC           S              5P 0
 
      ** Tick value
     D FFTKVL          S             14P 5
 
      ** Premium
     D FFPREM          S             13P 0
                                                                                              215528
      ** Strike Price                                                                         215528
     D FFSTRP          S                   LIKE(STRP)                                         215528
 
      ** Work field used to change sign of Quotation convention from
      ** positive to negative or vice versa
     D ChgSign         S              1P 0
 
      ** ZSEDIT fields
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
      ** Number of decimal places for currency
     D CDP             S              1P 0
     D DCDP            S                   LIKE(CDP)
     D PCDP            S                   LIKE(CDP)
     D CCDP            S                   LIKE(CDP)
 
      ** Message ID for 'DELETED' text
     D DeletedMsg      S              7A   INZ('ZZM1614')
 
      ** Message file for above message ID
     D MessageFil      S             10A   INZ('ZZGBMSGF')
 
      ** Message text from above message ID
     D MessageTxt      S             80A
 
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
      ** CFF001 enhancement                                                                   CFF007
     D CFF001          S              1A                                                      CFF007
                                                                                              CFF007
     D ZDATE           S              6  0                                                    CFF007
     D ZADATE          S              7                                                       CFF007
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
      **  Transaction number.
     C                   MOVE      TNBR          STNBR
 
      ** Instrument processing type
     C                   MOVE      ITISPT        SISPT
 
      **  OTC Type.
     C                   MOVE      ISTT          SISTT
 
      **  PM Instrument Type
     C                   MOVE      ITINNR        SINNR
 
      **  Purchase or Sale.
     C                   MOVE      TRTY          STRTY
 
      **  Number of Contracts
     C                   Z-ADD     0             ZADEC             1 0
     C                   Z-ADD     5             ZADIG             2 0
     C                   MOVEL     *BLANK        ZFIELD           16
     C                   MOVE      NUCO          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SNUCO
 
      **  Put/Call indicator
     C                   MOVE      PCAL          SPCAL
 
      **  Strike Price
 
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
 
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
 
      **  Portfolio Reference
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
     C     PTFR          ANDNE     *BLANKS
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     PTFR          ANDNE     *BLANKS                                      CPB001
     C     PTFR          IFNE      '9997'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C                   MOVEL     PTFR          SPTFR
     C                   ELSE
     C                   MOVE      FCR997        SPTFR
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SPTFR
     C                   END
 
      **  Contract Price
     C                   Z-ADD     COPR          FFPRIC
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
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
 
      **  Customer
     C*****CUSC*         IFEQ      0                                                          CSD027
     C     CUSC          IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      *BLANK        SCUSC
     C                   ELSE
     C                   MOVEL     CUSC          SCUSC
     C                   END
 
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
     C                   END
 
      **  Originating Branch
     C                   MOVE      ORBR          SORBR
 
      **  Profit Centre
     C                   MOVE      PRFC          SPRFC
 
      **   Style (American/ European Option indicator)
     C                   MOVE      ITAEIN        SAEIN
 
      **   Delivery & Counter Currency
     C                   MOVE      ITOTHC        SDCCY
     C                   MOVE      ITCTCY        SCTCY
 
      **   Delivery Currency Decimal Places
     C                   MOVE      SDCCY         FFCCY             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FFCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   Z-ADD     A6NBDP        DCDP
 
      **   Counter Currency Decimal Places
     C                   MOVE      SCTCY         FFCCY
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FFCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   Z-ADD     A6NBDP        CCDP
 
      **   Delivery (Contingent) Amount
     C                   Z-ADD     DCDP          ZADEC             1 0
     C     13            SUB       DCDP          ZADIG             2 0
     C                   MOVEL     *BLANK        ZFIELD           16
     C                   MOVE      ITCTAM        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SCTAM
 
      **   Counter Currency Amount
     C                   Z-ADD     CCDP          ZADEC
     C     13            SUB       CCDP          ZADIG
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      ITCCAM        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SCCAM
 
      **   Premium Currency
     C                   MOVE      ISCY          SISCY
 
      **   Premium Currency Decimal Places
     C                   MOVE      SISCY         FFCCY
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FFCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   Z-ADD     A6NBDP        PCDP
 
      **   Premium up Front
     C                   MOVE      ITPUPF        SPUPF
 
      **   Quotation Convention
     C     ITQOTC        IFLT      0
     C                   Z-SUB     ITQOTC        ChgSign
     C                   MOVE      ChgSign       SQOTC
     C                   MOVEL     '-'           SQOTC
     C                   ELSE
     C                   Z-ADD     ITQOTC        ChgSign
     C                   MOVE      ChgSign       SQOTC
     C                   MOVEL     ' '           SQOTC
     C                   END
 
      **   Value Date
 
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   MOVE      VALD          ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
 
     C                   MOVE      ZDATE         SVALD
 
      **   Expiry (Final Transaction) Date
     C                   MOVE      ITFTDT        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         SFTDT
 
      **   Expiry (Final Transaction) Time
     C                   MOVE      ITFTTM        SFTTM
 
      **   Settlement Date
     C                   MOVE      ITSETD        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         SSETD
 
      **   Commodity Ref
     C                   MOVE      ITCMRF        SCMRF
 
      **   Calculate Premium For Display
 
     C                   Z-ADD     NUCO          FFNOC
     C                   Z-ADD     COPR          FFPRIC
     C                   Z-ADD     ITTKDM        FFTKDM
     C                   Z-ADD     ITMNPF        FFMNPF
     C                   Z-ADD     ITTKVL        FFTKVL
     C                   Z-ADD     ITCNTT        FFCNTT
     C                   CALLB     'FFPMCL'
      *                               Premium (13,0P)
     C                   PARM                    FFPREM
      **                              Number of contracts (5,0P)
     C                   PARM                    FFNOC
      **                              Price (15,8P)
     C                   PARM                    FFPRIC
      **                              Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      **                              Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
      **                              Tick Value (14,5P)
     C                   PARM                    FFTKVL
      **                              Instrument type (1,0S)
     C                   PARM                    ITISPT
      **                              Contract type (1,0S, from INTYPD)
     C                   PARM                    FFCNTT
      **                              Contingent amount (13,0P), from INTYPD)
     C                   PARM                    ITCTAM
      **                              Strike Price (15,8P)                                    215528
     C                   PARM      STRP          FFSTRP                                       215528
 
 
      *                                                                                       247471
     C     ITISPT        IFEQ      5                                                          247471
     C     ITISCY        IFEQ      ITCTCY                                                     247471
     C     FFPREM        MULT      STRP          FFPREM                                       247471
     C                   END                                                                  247471
     C     ITISCY        IFNE      ITCTCY                                                     247471
     C     ITISCY        ANDNE     ITOTHC                                                     247471
     C                   Z-ADD     0             FFPREM                                       247471
     C                   END                                                                  247471
     C                   END                                                                  247471
      *                                                                                       247471
     C                   Z-ADD     FFPREM        ZFLD15
     C                   Z-ADD     PCDP          ZDECS
     C                   MOVE      'J'           ZECODE
     C                   CALLB     'ZSEDIT'
      ** Field to edit
     C                   PARM                    ZFLD15
      ** Decimal places
     C                   PARM                    ZDECS
      ** Edit code ('J', 'L' or ' ')
     C                   PARM                    ZECODE
      ** OUTPUT ***
     C                   PARM                    ZOUT21
     C                   MOVE      ZOUT21        SPREM
 
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
                                                                                CPL002
     C     BGN2ST        IFEQ      'Y'                                          CPL002
                                                                                CPL002
     C                   Z-ADD     PLSPTP        FFPRIC           15 8          CPL002
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
     C     BGN4ST        ANDEQ     'Y'                                                        CFF007
     C                   MOVE      COVE          SCOVE                                        CFF007
     C                   MOVE      HETR          SHETR                                        CFF007
     C                   MOVE      BLUP          SBLUP                                        CFF007
     C                   MOVE      ITUNSE        SUNSE                                        CFF007
     C                   MOVE      ITTECO        STECO                                        CFF007
     C                   MOVE      ITTNAT        STNAT                                        CFF007
     C                   MOVE      ITCRIK        SCRIK                                        CFF007
     C                   MOVE      ITCCYR        SCCYR                                        CFF007
     C     ITTWEI        IFNE      *ZEROS                                                     CFF007
     C                   MOVE      ITTWEI        STWEI                                        CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      *Blanks       STWEI                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      *Blanks       SCOVE                                        CFF007
     C                   MOVE      *Blanks       SHETR                                        CFF007
     C                   MOVE      *Blanks       SBLUP                                        CFF007
     C                   MOVE      *Blanks       SUNSE                                        CFF007
     C                   MOVE      *Blanks       STECO                                        CFF007
     C                   MOVE      *Blanks       STNAT                                        CFF007
     C                   MOVE      *Blanks       SCRIK                                        CFF007
     C                   MOVE      *Blanks       SCCYR                                        CFF007
     C                   MOVE      *Blanks       STWEI                                        CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      ** Convert value date from file to display format                                       CFF007
     C     CFF007        IFEQ      'Y'                                                        CFF007
     C     CFF001        OREQ      'Y'                                                        CFF007
     C                   MOVE      VALD          ZDAYNO                                       CFF007
     C                   CALLB     'ZDATE2'                                                   CFF007
     C                   PARM                    ZDAYNO                                       CFF007
     C                   PARM                    BJDFIN                                       CFF007
     C                   PARM      *ZEROS        ZDATE                                        CFF007
     C                   PARM      *BLANKS       ZADATE                                       CFF007
                                                                                              CFF007
     C                   MOVEL     ZDATE         SVALD                                        CFF007
     C                   ENDIF                                                                CFF007
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
 
     C     INIT          BEGSR
 
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN TRANSACTION FORMAT)
     C                   MOVEL     SACTN         ##ACTN            1
     C                   MOVEL     *BLANK        TranScnFmt
     C                   MOVEL     ##ACTN        SACTN
     C                   MOVEL     *BLANK        SPREM
     C                   MOVEL     *BLANK        FFSTS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Return Code
     C                   PARM                    ReturnCode
      * Inputs
      * ------
      * Transaction in file format
     C                   PARM                    TranFilFmt
      * Instrument types
     C                   PARM                    InstTypes
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      * Outputs
      * -------
      * Transaction in screen format
     C                   PARM                    TranScnFmt
      * Premium
     C                   PARM                    SPREM            15
      * Transaction Status
     C                   PARM                    FFSTS            24
      ** CFF001 Enhancement                                                                   CFF007
     C                   PARM                    CFF001                                       CFF007
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
 
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
(c) Misys International Banking Systems Ltd. 2001
