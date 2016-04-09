     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans cnv: file to screen DSP 2')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP2CT - Customer Loans cnv: file to screen DSPF 2        *
      *                                                               *
      *  Function:  This module converts the fields of a customer     *
      *             loan from their format as on file to a screen     *
      *             format (record format 2)                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD025521           Date 19Aug14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR846083           Date 14Oct11               *
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
      *                 CLE042             Date 06Sep05               *
      *                 BUG9720            Date 27Dec05               *
      *                 BUG9491            Date 05Dev05               *
      *                 CLE035             Date 22Sep03               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 TDA023             Date 22Mar04               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 04Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025521 - Added Interest Rate field.                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR846083 - Rate/Spread field displayed was incorrect         *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9720 - Loan Approval Error- Interest Defaulting Error     *
      *  BUG9491 - BASR field should be under switchable feature      *
      *            CLE036.                                            *
      *  CLE035 - Nordea LE Enh. Phase 1 Pty 2 - Income Splits. Added *
      *           Base Rate and Fixed Rate fields.                    *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
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
     D LoanScnFmt2   E DS                  EXTNAME(LECLI2PD)
      ***  Loan in Screen Format
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE035
     D SCA_LCD       E                     EXTFLD(LCD)                                        CLE035
      ***  External DS for SAR details                                                        CLE035
      *                                                                                       CLE035
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for access programs, long data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Access Object parameter                                                              CLE035
     D PRtcd           S              7                                                       CLE035
     D POptn           S              7                                                       CLE035
     D PSARD           S              6                                                       CLE035
     D*CLE035***       S              1                                               CLE035 BUG9491
     D CLE036          S              1                                                      BUG9491
     D CLE143          S              1                                                       CLE143
     D CRE073          S              1                                                       CRE073
                                                                                              CLE035
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
     C                   MOVEL     ZAMSTP        DDLST2
     C                   MOVE      *BLANKS       ZAMSID
      *
      ***  Loan number
      *
     C                   MOVE      LNRF          DDLNR2
      *
      ***  Base rate code
      *
     C     BRTT          IFNE      *ZERO
     C                   MOVE      BRTT          DDBRTT
     C                   ENDIF
      *
      ***  Change indicator
      *
     C                   MOVEL     CHIN          DDCHIN
      *                                                                                       CLE035
      ** Base Rate                                                                            CLE035
      *                                                                                       CLE035
     C                   IF        CLE036 = 'Y'                                              BUG9491
     C     BASR          IFNE      *ZEROS                                                     CLE035
     C                   MOVEL     *BLANKS       ZFIELD           16                          CLE035
     C                   MOVE      BASR          ZFIELD           16                          CLE035
     C                   Z-ADD     7             ZDEC              1 0                        CLE035
     C                   CALL      'ZEDIT'                                                    CLE035
     C                   PARM                    ZFIELD                                       CLE035
     C                   PARM                    ZDEC                                         CLE035
     C                   MOVE      ZFIELD        DDBASR                                       CLE035
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                               BUG9491
      *
      ***  Rate/spread
      *
     C     RTSP          IFNE      *ZEROS
     C                   IF        RTSP > *ZERO                                               CRE073
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      RTSP          ZFIELD           16
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   ELSE                                                                 CRE073
     C                   EVAL      ZFIELD = %CHAR(RTSP)                                       CRE073
     C                   ENDIF                                                                CRE073
     C**********         MOVE      ZFIELD        DDRTSP                              BUG9491 BUG9720
     C**********         IF        CLE036 = 'Y'                                      BUG9491 BUG9720
     C                   IF        BASR = *ZEROS And BRTT = *ZEROS                            CLE035
     C**********                   And CLE035 = 'Y'                                   CLE035 BUG9491
     C                             AND CLE036 = 'Y'                                          BUG9720
     C**********         MOVE      ZFIELD        DDFXRT                                CLE035 CRE073
     C**********         MOVEL     ZFIELD        DDFXRT                              CRE073 AR846083
     C                   MOVE      ZFIELD        DDFXRT                                     AR846083
     C                   ELSE                                                                 CLE035
     C*********          MOVE      ZFIELD        DDRTSP                                       CRE073
     C*********          MOVEL     ZFIELD        DDRTSP                              CRE073 AR846083
     C                   MOVE      ZFIELD        DDRTSP                                     AR846083
     C                   ENDIF                                                                CLE035
     C**********         ENDIF                                                       BUG9491 BUG9720
     C                   ENDIF
      *
      ***  Spread indicator
      *
     C                   MOVEL     SPIN          DDSPIN
      *                                                                                     MD025521
      ***  Interest rate                                                                    MD025521
      *                                                                                     MD025521
     C     INTR          IFNE      *ZEROS                                                   MD025521
     C                   MOVEL     *BLANKS       ZFIELD           16                        MD025521
     C                   MOVE      INTR          ZFIELD           16                        MD025521
     C                   Z-ADD     7             ZDEC              1 0                      MD025521
     C                   CALL      'ZEDIT'                                                  MD025521
     C                   PARM                    ZFIELD                                     MD025521
     C                   PARM                    ZDEC                                       MD025521
     C                   MOVE      ZFIELD        DDINTR                                     MD025521
     C                   ENDIF                                                              MD025521
      *
      ***  Next interest payment date
      *
     C     NIDT          IFNE      *ZERO
     C                   MOVE      NIDT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
     C                   MOVE      ZDateFmt6     DDNIDT
     C                   ENDIF
      *
      ***  Interest payment frequency
      *
     C                   MOVEL     IPFR          DDIPFR
      *
      ***  Int freq day in month
      *
     C     IFDY          IFNE      *ZERO
     C                   MOVE      IFDY          DDIFDY
     C                   ENDIF
      *
      ***  Interest calculation basis
      *
     C     ICBS          IFEQ      0                                                         BUG3721
     C                   MOVE      *BLANKS       DDCALC                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   MOVE      ICBS          DDCALC
     C                   ENDIF                                                               BUG3721
      *
      ***  Interest paid/recd to date
      *
     C                   MOVEL     CCY           @CURR             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFLD15
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     PTYP          ANDEQ     80                                                        BUG3721
     C                   MOVE      FLTI          ZFLD15                                      BUG3721
     C                   ELSE                                                                BUG3721
     C                   MOVE      TOTI          ZFLD15           15 0
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     A6NBDP        ZDECS             1 0
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   MOVE      ZOUT21        DDIPRD
      *
      ***  Margin and negative field
      *
     C     MARG          IFLT      *ZEROS
     C                   MOVEL     'Y'           DDNEGV
     C                   Z-SUB     MARG          MARG
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFIELD           16
     C                   MOVE      MARG          ZFIELD
     C                   Z-ADD     5             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   MOVE      ZFIELD        DDMARG
      *
      ***  Withholding tax rate
      *
     C                   MOVE      *BLANKS       ZFIELD           16
     C                   MOVE      WTRT          ZFIELD
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   MOVE      ZFIELD        DDWTRT
      *
      ***  Withholding tax indicator
      *
     C                   MOVEL     WTIN          DDWTIN
      *
      ***  Interest captilisation indicator
      *
     C                   MOVEL     INTC          DDINTC
      *
      ***  Round Down Interest Indicator
      *
     C                   MOVEL     RDFC          DDRDFC
      *
      ***  Additional Day Indicator
      *
     C                   MOVEL     ADDI          DDADDI
                                                                                             BUG3721
      ** If CLE028 is installed, setup Add on Interest, Add on Charges,                      BUG3721
      ** Charge Amount, and Include Charges in Interest                                      BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
                                                                                             BUG3721
     C                   MOVE      ADIF          DDADIF                                      BUG3721
     C                   MOVE      ADCF          DDADCF                                      BUG3721
     C                   MOVE      ICIF          DDICIF                                      BUG3721
                                                                                             BUG3721
     C     CHGA          IFNE      0                                                         BUG3721
     C                   MOVE      *BLANKS       ZFLD15                                      BUG3721
     C                   MOVE      CHGA          ZFLD15                                      BUG3721
     C                   Z-ADD     A6NBDP        ZDECS                                       BUG3721
                                                                                             BUG3721
     C                   CALL      'ZSEDIT'                                                  BUG3721
     C                   PARM                    ZFLD15                                      BUG3721
     C                   PARM                    ZDECS                                       BUG3721
     C                   PARM      *BLANKS       ZECODE                                      BUG3721
     C                   PARM                    ZOUT21                                      BUG3721
                                                                                             BUG3721
     C                   MOVE      ZOUT21        DDCHGA                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
      *
      ***  Repayment type
      *
     C     REPT          IFNE      0
     C                   MOVE      REPT          DDREPT
     C                   ENDIF
      *
      ***  Repayment amount
      *
     C     RAMT          IFNE      0
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      RAMT          ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
     C                   MOVE      ZOUT21        DDRAMT
     C                   ENDIF
      *
      ***  Facility Ccy Repayment Amt
      *
     C                   MOVEL     FCCY          @CURR
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
     C     FCRA          IFNE      0
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      FCRA          ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
     C                   MOVE      ZOUT21        DDFCRA
     C                   ENDIF
      *
      ***  Next repayment date
      *
     C     NRPD          IFNE      *ZERO
     C                   MOVE      NRPD          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum
     C                   PARM                    ZDateFmtInd
     C                   PARM                    ZDateFmt6
     C                   PARM                    ZDateFmt7
     C                   MOVE      ZDateFmt6     DDNRPD
     C                   ENDIF
      *
      ***  Repayment frequency
      *
     C                   MOVEL     RFRQ          DDRFRQ
      *
      ***  Repayment day no.
      *
     C     RDYN          IFNE      *ZERO
     C                   MOVE      RDYN          DDRDYN
     C                   ENDIF
      *
      ***  Billing/telex indicator
      *
     C                   MOVEL     BTIN          DDBTIN
      *
      ***  Billing days
      *
     C     BLDY          IFNE      *ZERO
     C                   MOVE      BLDY          DDBLDY
     C                   ENDIF
      *
      ***  Payment Due Day Indicator
      *
     C                   MOVEL     PDDI          DDPDDI
      *
      ***  Grace Days for Interest
      *
     C     GDIN          IFNE      *ZERO
     C                   MOVE      GDIN          DDGDIN
     C                   ENDIF
      *
      ***  Grace Days for Principal
      *
     C     GDPR          IFNE      *ZERO
     C                   MOVE      GDPR          DDGDPR
     C                   ENDIF
      *
      ***  Payment Taken Day Indicator
      *
     C                   MOVEL     PTDI          DDPTDI
      *
      ** Effective Annual Interest Rate                                                       CLE143
      *                                                                                       CLE143
     C                   IF        CLE143 = 'Y'                                               CLE143
     C                             AND EAIR <> *ZEROS                                         CLE143
     C                   MOVEL     *BLANKS       ZFIELD                                       CLE143
     C                   MOVE      EAIR          ZFIELD                                       CLE143
     C                   Z-ADD     8             ZDEC                                         CLE143
     C                   CALL      'ZEDIT'                                                    CLE143
     C                   PARM                    ZFIELD                                       CLE143
     C                   PARM                    ZDEC                                         CLE143
     C                   MOVE      ZFIELD        DDEAIR                                       CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   IF        CRE073 = 'Y'                                               CRE073
                                                                                              CRE073
      ** Contractual Spread                                                                   CRE073
                                                                                              CRE073
     C     CNSP          IFNE      *ZEROS                                                     CRE073
     C                   MOVEL     *BLANKS       ZFIELD                                       CRE073
     C                   MOVE      CNSP          ZFIELD                                       CRE073
     C                   Z-ADD     7             ZDEC                                         CRE073
     C                   CALL      'ZEDIT'                                                    CRE073
     C                   PARM                    ZFIELD                                       CRE073
     C                   PARM                    ZDEC                                         CRE073
     C                   MOVE      ZFIELD        DDCNSP                                       CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      ** Contractual Spread Sign                                                              CRE073
                                                                                              CRE073
     C                   MOVEL     CNSG          DDCNSG                                       CRE073
                                                                                              CRE073
      ** Rounding Method                                                                      CRE073
                                                                                              CRE073
     C                   MOVEL     RDMT          DDRDMT                                       CRE073
                                                                                              CRE073
      ** Rounding Fraction/Decimal                                                            CRE073
                                                                                              CRE073
     C                   MOVEL     RDFD          DDRDFD                                       CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
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
     C                   MOVEL     DDACT2        ##ACTN            1
     C                   MOVEL     *BLANK        LoanScnFmt2
     C                   MOVEL     ##ACTN        DDACT2
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
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
      *
      ***  OUTPUT parameters
      *
      ***  Loan in screen format
      *
     C                   PARM                    LoanScnFmt2
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP2CT'   DBPGM
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
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
     C                   CALLB     'AOSARDR0'                                                 CLE035
     C                   PARM      *Blanks       PRtcd                                        CLE035
     C                   PARM      '*VERIFY'     POptn                                        CLE035
     C**********         PARM      'CLE035'      PSARD                                CLE035 BUG9491
     C                   PARM      'CLE036'      PSARD                                       BUG9491
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE035
     C**********         EVAL      CLE035 = 'N'                                       CLE035 BUG9491
     C                   EVAL      CLE036 = 'N'                                              BUG9491
     C                   IF        PRtcd = *Blanks                                            CLE035
     C**********         EVAL      CLE035 = 'Y'                                       CLE035 BUG9491
     C                   EVAL      CLE036 = 'Y'                                              BUG9491
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Check if CLE143 is installed                                                         CLE143
                                                                                              CLE143
     C                   EVAL      CLE143 = 'N'                                               CLE143
     C                   CALLB     'AOSARDR0'                                                 CLE143
     C                   PARM      *Blanks       PRtcd                                        CLE143
     C                   PARM      '*VERIFY'     POptn                                        CLE143
     C                   PARM      'CLE143'      PSARD                                        CLE143
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE143
     C                   IF        PRtcd = *Blanks                                            CLE143
     C                   EVAL      CLE143 = 'Y'                                               CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
      ** Check if CRE073 Interest Rate Rounding feature is installed                          CRE073
                                                                                              CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRtcd                                        CRE073
     C                   PARM      '*VERIFY'     POptn                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRtcd = *Blanks                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
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
