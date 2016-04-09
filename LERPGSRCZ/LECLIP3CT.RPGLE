     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans cnv: file to screen DSP 3')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP3CT - Customer Loans cnv: file to screen DSPF 3        *
      *                                                               *
      *  Function:  This module converts the fields of a customer     *
      *             loan from their format as on file to a screen     *
      *             format (record format 3)                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 TDA023             Date 22Mar04               *
      *                 225959             Date 23Mar04               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 05Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  225959 - Missing CAS00x changes                              *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D LoanFilFmtCL  E DS                  EXTNAME(CLOANCL)
      ***  Loan in file Format CL
      *
     D LoanFilFmtCK  E DS                  EXTNAME(CLOANCK)
      ***  Loan in file Format CK
     D                                     PREFIX(K_)
      *
     D LoanScnFmt3   E DS                  EXTNAME(LECLI3PD)
      ***  Loan in Screen Format
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas modules details
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio ICD
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D CLE036          S              1                                                    BUG10391R
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ***  Initialization
      *
     C                   EXSR      INIT
      *
      ***  Set output screen fields
      *
     C                   EXSR      SETFLD
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set output screen fields                            *
      *****************************************************************
     C     SETFLD        BEGSR
      *
      ***  Loan status
      *
     C                   SELECT
     C     RECI          WHENEQ    'M'
     C                   MOVEL     'LEL0496'     ZAMSID
     C     RECI          WHENEQ    'R'
     C                   MOVEL     'LEL0088'     ZAMSID
     C     LSTS          WHENEQ    'C'
     C                   MOVEL     'LEL0098'     ZAMSID
     C     LSTS          WHENEQ    'R'
     C                   MOVEL     'LEL0086'     ZAMSID
     C     LSTS          WHENEQ    'A'
     C                   MOVEL     'LEL0087'     ZAMSID
     C     LSTS          WHENEQ    'D'
     C                   MOVEL     'LEL0088'     ZAMSID
     C     LSTS          WHENEQ    'Q'                                                        CLE030
     C                   MOVEL     'LEL0124'     ZAMSID                                       CLE030
     C                   ENDSL
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDLST3
     C                   MOVE      *BLANKS       ZAMSID
      *
      ***  Loan number
      *
     C                   MOVE      LNRF          DDLNR3
      *
      ***  Account officer
      *
     C                   MOVEL     ACOF          DDACOF
      *
      ***  Local industry code
      *
     C*****LIND*         IFNE      *ZERO                                                      CER020
     C**********         MOVE      LIND          DDLIND                                       CER020
     C     LOIC          IFNE      *BLANKS                                                    CER020
     C                   MOVE      LOIC          DDLIND                                       CER020
     C                   ENDIF
      *
      ***  Indicators: secured/doc/fees
      *
     C                   TESTB     '2'           RELI                     97
     C     *IN97         IFEQ      '1'
     C                   MOVE      'Y'           DDFEEI
     C                   ELSE
     C                   MOVE      'N'           DDFEEI
     C                   ENDIF
      *
      ***  Originating branch
      *
     C                   MOVEL     ORBR          DDORBR
      *
      ***  Country of risk
      *
     C                   MOVEL     CRSK          DDCRSK
      *
      ***  Documents indicator
      *
     C                   TESTB     '1'           RELI                     97
     C     *IN97         IFEQ      '1'
     C                   MOVE      'Y'           DDDOCI
     C                   ELSE
     C                   MOVE      'N'           DDDOCI
     C                   ENDIF
      *
      ***  Book Code
      *
     C                   MOVEL     BOKC          DDBOKC
      *
      ***  Frb code
      *
     C     K_FRBC        IFNE      *ZERO
     C                   MOVE      K_FRBC        DDFRBC
     C                   ENDIF
      *
      ***  Secured indicator
      *
     C                   TESTB     '0'           RELI                     97
     C     *IN97         IFEQ      '1'
     C                   MOVE      'Y'           DDSECI
     C                   ELSE
     C                   MOVE      'N'           DDSECI
     C                   ENDIF
      *
      ***  Customer loan a/c seq no.
      *
     C     LASQ          IFNE      *ZERO
     C                   MOVE      LASQ          DDACSQ
     C                   ENDIF
      *
      ***  Portfolio reference
      *
     C     PTFR          IFNE      '9997'
     C                   MOVEL     PTFR          DDPTFR
     C                   ELSE
     C                   MOVE      FCR997        DDPTFR
     C                   ENDIF
      *
      ***  Name and address code
      *
     C                   MOVEL     NACD          DDNACD
      *
      ***  Profit centre
      *
     C                   MOVEL     PRFC          DDPRFC
      *
      ***  Narrative 1
      *
     C                   MOVEL     K_NAR1        DDNAR1
      *
      ***  Narrative 2
      *
     C                   MOVEL     K_NAR2        DDNAR2
      *
      ***  Narrative 3
      *
     C                   MOVEL     K_NAR3        DDNAR3
      *
      ***  Narrative 4
      *
     C                   MOVEL     K_NAR4        DDNAR4
      *
      ***  Base currency exchange rate
      *
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      BCXR          ZFIELD
     C                   Z-ADD     8             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   MOVE      ZFIELD        DDBCXR
      *
      ***  Facility ccy exch. rate
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      FCXR          ZFIELD
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   MOVE      ZFIELD        DDFCXR
      *
      ***  Base currency indicator
      *
     C                   MOVEL     BMDI          DDBMIN
      *
      ***  Facility currency indicator
      *
     C                   MOVEL     FMDI          DDFMIN
      *
      ***  Receiver of the Guarantee
      *
     C*****RECE*         IFNE      *ZERO                                                      CSD027
     C     RECE          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      RECE          DDRECE
     C                   ENDIF
      *
      ***  Customer Confirmation
      *
     C*****COCU*         IFNE      *ZERO                                                      CSD027
     C     COCU          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      COCU          DDCOCU
     C                   ENDIF
      *
      ***  Funding Spread/Rate
      *
     C     FSRP          IFNE      *ZEROS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      FSRP          ZFIELD
     C                   Z-ADD     7             ZDEC
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   IF        CLE036 = 'Y' AND                                        BUG10391R
     C                             FSGN = *BLANK                                           BUG10391R
     C                   MOVE      ZFIELD        DDFUND                                    BUG10391R
     C                   ELSE                                                              BUG10391R
     C                   MOVE      ZFIELD        DDFRSP
     C                   ENDIF                                                             BUG10391R
     C                   ENDIF
      *
      ***  Original Maturity Date
      *
     C     OMDT          IFNE      *ZERO
     C                   MOVE      OMDT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDOMDT
     C                   ENDIF
      *
      ***  Funding Sign
      *
     C                   MOVEL     FSGN          DDFSGN
      *
      ***  Funding Profit Centre
      *
     C                   MOVEL     FPRC          DDFPRC
      *                                                                                       225959
      ***  Yield Curve                                                                        225959
      *                                                                                       225959
     C                   MOVEL     FSYLDC        DDYLDC                                       225959
      *                                                                                       225959
      ***  Forward Yield Curve                                                                225959
      *                                                                                       225959
     C                   MOVEL     FSFYLD        DDFYLD                                       225959
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file.                     *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF '    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP          132            Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialization                                         *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Blank outputs (except for action code within loan format)
      *
     C                   MOVEL     DDACT3        ##ACTN            1
     C                   MOVEL     *BLANK        LoanScnFmt3
     C                   MOVEL     ##ACTN        DDACT3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Program parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUTS parameters
      *
      ***  Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ***  Loan in file format CL
      *
     C                   PARM                    LoanFilFmtCL
      *
      ***  Loan in file format CK
      *
     C                   PARM                    LoanFilFmtCK
      *
      ***  OUTPUT parameters
      *
      ***  Loan in screen format
      *
     C                   PARM                    LoanScnFmt3
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP3CT'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** Retrieve midas module details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Retrieve portfolio management ICD for portfolio module
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   ENDIF
                                                                                           BUG10391R
      ** Determine if CLE036 is installed                                                  BUG10391R
                                                                                           BUG10391R
     C                   EVAL      CLE036 = 'N'                                            BUG10391R
     C                   CALLB     'AOSARDR0'                                              BUG10391R
     C                   PARM      *Blanks       @RTCD                                     BUG10391R
     C                   PARM      '*VERIFY'     @OPTN                                     BUG10391R
     C                   PARM      'CLE036'      @SARD                                     BUG10391R
     C                   IF        @RTCD <> *BLANKS AND                                    BUG10391R
     C                             @RTCD <> '*NRF '                                        BUG10391R
     C                   EVAL      DBKEY = @OPTN                                           BUG10391R
     C                   EVAL      DBFILE = 'SCSARDPD'                                     BUG10391R
     C                   EVAL      DBASE = 4                                               BUG10391R
     C                   EXSR      *PSSR                                                   BUG10391R
     C                   ENDIF                                                             BUG10391R
                                                                                           BUG10391R
     C                   IF        @RTCD = *Blanks                                         BUG10391R
     C                   EVAL      CLE036 = 'Y'                                            BUG10391R
     C                   ENDIF                                                             BUG10391R
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
