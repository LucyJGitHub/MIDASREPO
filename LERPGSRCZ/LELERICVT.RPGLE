     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Instr convert: file to screen')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERICVT - Rollover Instructions convert: file to screen    *
      *                                                               *
      *  Function:  This module converts the fields of a customer     *
      *             loan from their format as on file to a screen     *
      *             format (Rollover Screen format)                   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD034449           Date 24Jan19               *
      *  Prev Amend No. MD044083           Date 12Feb19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD028338           Date 25Nov14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9737            Date 29Dec05               *
      *                 BUG9507            Date 06Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 BUG8145            Date 12Aug05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG2579            Date 08Jun04               *
      *                 BUG827             Date 05May04               *
      *                 CAP084             Date 09Jan04               *
      *                 TDA023             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP076  *CREATE    Date 15Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034449 - Correct negative discount amount display          *
      *           - Applied for MD052515                              *
      *  MD044083 - Issue 2: Spread rate showing incorrect value on   *
      *             rollover enquiry. Issue fixed with by replacing   *
      *             EVAL with EVALR and MOVEL to MOVE.                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD028338 - Interest calculation has rounding difference for  *
      *             Rollover of Facility Exchange Rate only. Add new  *
      *             field to flag rollover as 'FX Rate Change Only'.  *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9737 - Spread rate defaulting error.                      *
      *  BUG9507- Field NBSR is switchable under CLE036.              *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  BUG8145- New Funding Profit Centre should be populated       *
      *           with the old one as this is a non amendable field   *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG2579 - Lending Facility History Improvements (CLE023)     *
      *  BUG827 - Missing CASxxx changes from LE2070.                 *
      *           CAS001 - Net Present Value (NPV) Accounting.        *
      *  CAP084 - API wrapper project                                 *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP076 - Lending API enhancements - Rollover details         *
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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for*indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
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
     D LnCLFilFmt    E DS                  EXTNAME(CLOANCL)
      ***  Loan in file Format CL
      *
     D LnCKFilFmt    E DS                  EXTNAME(CLOANCK)
      ***  Loan in file Format CK
     D                                     PREFIX(K_)
      *
     D RollScnFmt    E DS                  EXTNAME(LELERIPD)
      ***  Rollover Instructions in Screen Format

     D RollScnWrk2   E DS                  EXTNAME(LELERI2PD)
      *** Rollover Instructions Work fields
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Module Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR details
     D                                     PREFIX(S_)
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details

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
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C*****************************************************************
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
      ***  Loan number.
      *
     C                   MOVE      LNRF          DDLNRF
      *
      **  Rollover status.
      *
     C                   MOVE      K_RSTS        WRSTS             1
     C                   EXSR      SRSTAT
     C                   MOVEL     WSTAT         DDRSTS
      *                                                                                       CAP084
      **  Loan Currency                                                                       CAP084
      *                                                                                       CAP084
     C                   MOVE      CCY           DDCURR                                       CAP084
      *
      ***  Customer number if action is E or X and run is interactive
      *
     C     @TYPE         IFEQ      '1'                                          run Interactively
     C     DDACTN        ANDEQ     'E'
     C     @TYPE         OREQ      '1'                                          run Interactively
     C     DDACTN        ANDEQ     'X'
      *
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68
     C     PTYP          OREQ      71
     C                   MOVEL     OLNO          DDCUST
     C                   ELSE
     C                   MOVEL     CNUM          DDCUST
     C                   END
      *
     C                   ELSE
     C     DDACTN        IFNE      'A'                                                        CAP084
     C                   MOVE      *BLANKS       DDCUST
     C                   ENDIF                                                                CAP084
     C                   END
      *
      **  Rollover date.
      *
     C     RLDT          IFNE      *ZEROS
     C                   Z-ADD     RLDT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         DDRLDT
     C                   ELSE
     C                   MOVE      *BLANKS       DDNROD
     C                   END

      *
      ***  if Rollover rate fixing day enhancement - CLE011 is on
      *
     C     CLE011        IFEQ      'Y'
      *
     C                   MOVEL     RFDY          DDRFDY
      *
     C     RFRI          IFEQ      'Y'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      RFRT          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDRFRT
     C                   ENDIF
      *
      ** If next rollover date field (NROD) has no value then
      ** recalculate next rollover date.
      *
     C                   ELSE
     C     RLDT          IFNE      *ZEROS
     C     RLFQ          ANDNE     *BLANK
     C                   Z-ADD     RLDT          ZDAYNO
     C                   MOVE      RLFQ          ZFREQ
     C                   Z-ADD     RLDY          ZMDAY
     C                   MOVE      CCY           ZCCY
     C                   EXSR      ZFREQB
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDNROD
     C                   ELSE
     C                   MOVE      *BLANKS       DDNROD
     C                   END
     C                   END
      *
      **  Rollover frequency and day number.
      *
     C                   MOVEL     RLFQ          DDRLFQ
     C     RLDY          IFNE      *ZEROS
     C                   MOVE      RLDY          DDRLDY
     C                   ELSE
     C                   MOVE      *BLANKS       DDRLDY
     C                   ENDIF
      *
      **  New base rate, spread/rate, spread indicator,
      **  New fixed rate,                                                                     CLE106
      **  interest calculation basis, change indicator
      *
     C     NBRA          IFNE      *ZERO
     C                   MOVEL     NBRA          DDNBRA
     C                   ENDIF
                                                                                              CLE106
     C                   IF        CLE036 = 'Y'                                              BUG9507
     C                   IF        NBSR <> *Zeros                                             CLE106
     C                   MOVE      *Blanks       ZFIELD                                       CLE106
     C                   MOVE      NBSR          ZFIELD                                       CLE106
     C                   Z-ADD     7             ZADEC                                        CLE106
     C                   EXSR      ZEDIT                                                      CLE106
     C                   EVAL      DDNBRT = ZFIELD                                            CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                               BUG9507
      *
     C     NRTS          IFNE      *ZERO
     C                   IF        NRTS < *ZERO                                               CRE073
     C**********         EVAL      ZFIELD = %CHAR(NRTS)                              CRE073 MD044083
     C                   EVALR     ZFIELD = %CHAR(NRTS)                                     MD044083
     C                   ELSE                                                                 CRE073
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NRTS          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   ENDIF                                                                CRE073
                                                                                              CLE106
      ** If no base rates were entered this is a fixed rate                                   CLE106
                                                                                              CLE106
     C**********         MOVE      ZFIELD        DDNRTS                              BUG9507 BUG9737
     C**********         IF        CLE036 = 'Y'                                      BUG9507 BUG9737
     C                   IF        NBRA = *Zeros And NBSR = *Zeros                            CLE106
     C                             AND CLE036 = 'Y'                                          BUG9737
     C**********         MOVE      ZFIELD        DDNRTF                                CLE106 CRE073
     C**********         MOVEL     ZFIELD        DDNRTF                              CRE073 MD044083
     C                   MOVE      ZFIELD        DDNRTF                                     MD044083
     C                   ELSE                                                                BUG9737
     C**********         MOVE      ZFIELD        DDNRTS                               BUG9737 CRE073
     C**********         MOVEL     ZFIELD        DDNRTS                              CRE073 MD044083
     C                   MOVE      ZFIELD        DDNRTS                                     MD044083
     C**********         ELSE                                                         CLE106 BUG9507
     C**********         MOVE      ZFIELD        DDNRTS                                      BUG9507
     C                   ENDIF                                                                CLE106
     C**********         ENDIF                                                       BUG9507 BUG9737
     C                   ENDIF
      *
     C                   MOVEL     NSIN          DDNSIN
      *
     C     NCAS          IFNE      *ZERO
     C                   MOVEL     NCAS          DDNCAS
     C                   ENDIF
      *
     C                   MOVEL     NCHI          DDNCHI
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
                                                                                              CRE073
      ** New Contractual Spread                                                               CRE073
                                                                                              CRE073
     C     NNSP          IFNE      *ZERO                                                      CRE073
     C                   MOVE      *BLANKS       ZFIELD                                       CRE073
     C                   MOVE      NNSP          ZFIELD                                       CRE073
     C                   Z-ADD     7             ZADEC                                        CRE073
     C                   EXSR      ZEDIT                                                      CRE073
     C                   EVAL      DDCNS2 = ZFIELD                                            CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      ** New Contractual Spread Sign                                                          CRE073
                                                                                              CRE073
     C                   MOVEL     NNSG          DDCNG2                                       CRE073
                                                                                              CRE073
      ** New Rounding Method                                                                  CRE073
                                                                                              CRE073
     C                   MOVEL     NDMT          DDRDM2                                       CRE073
                                                                                              CRE073
      ** New Rounding Fraction/Decimal                                                        CRE073
                                                                                              CRE073
     C                   MOVEL     NDFD          DDRDF2                                       CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
      *
      **  Next Rollover date.
      *
     C     NROD          IFNE      0
     C                   Z-ADD     NROD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         DDNROD
      *
      **  Compute if Rollover date and frequency detail exists.
     C                   ELSE
     C     RLDT          IFNE      *ZEROS
     C     RLFQ          ANDNE     *BLANK
     C                   Z-ADD     RLDT          ZDAYNO
     C                   MOVE      RLFQ          ZFREQ
     C                   Z-ADD     RLDY          ZMDAY
     C                   MOVE      CCY           ZCCY
     C                   EXSR      ZFREQB
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDNROD
     C                   ENDIF
     C                   ENDIF
      *
      **  New Principal Amount
      *
     C     K_NPRAM       IFNE      *ZERO
     C                   MOVEL     CCY           @CURR
     C                   Z-ADD     50            DBASE
     C                   EXSR      SRCurrDet
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      K_NPRAM       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNPRAM
     C                   ENDIF
      *
      **  New Discount Amount
      *
     C     K_NDAM        IFNE      *ZERO
     C                   MOVEL     CCY           @CURR
     C                   Z-ADD     51            DBASE
     C                   EXSR      SRCurrDet
     C                   MOVE      *BLANKS       ZFIELD
     C**********         MOVE      K_NDAM        ZFIELD                                     MD034449
     C                   EVALR     ZFIELD = %trimr(%char(K_NDAM))                           MD034449
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNDAM
     C                   ENDIF
      *
      **  New interest payment date
      **  - BLI Lending Enhancement feature (S01465)
      *
     C     NIPD          IFNE      *ZERO
     C     S01465        ANDEQ     'Y'
     C                   Z-ADD     NIPD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDNIPD
     C                   ENDIF
      *
      **  New maturity date
      **  - BLI Lending Enhancement feature
      *
     C     NMDT          IFNE      *ZERO
     C     S01465        ANDEQ     'Y'
     C                   Z-ADD     NMDT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDNMDT
     C                   ENDIF
      *
      **  New currency and new currency amount
      **  - Customer Lending Enhancement Syndications feature
      *
     C     K_NCCY        IFNE      *BLANKS
     C     S01465        ANDEQ     'Y'
     C                   MOVEL     K_NCCY        DDNCCY
      *
     C                   MOVEL     K_NCCY        @CURR
     C                   Z-ADD     52            DBASE
     C                   EXSR      SRCurrDet
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      K_NCPA        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNCPA
     C                   ENDIF
      *
      **  Exchange rate, exchange rate indicator
      **  - Customer Lending Enhancement Syndications feature  (CLE011)
      *
     C     K_NFCE        IFNE      *ZERO
     C     S01465        ANDEQ     'Y'
     C     K_NFCE        ORNE      *ZERO                                                     BUG2579
     C     @FCXRATE      ANDEQ     'Y'                                                       BUG2579
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      K_NFCE        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNFCE
      *
     C                   MOVEL     K_NFMD        DDNFMD
     C                   ENDIF
      *
      **  Base ccy exchange rate and indicator
      **  - Customer Lending Enhancement Syndications feature
      *
     C     K_NBCE        IFNE      *ZERO
     C     S01465        ANDEQ     'Y'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      K_NBCE        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNBCE
      *
     C                   MOVEL     K_NBMD        DDNBMD
     C                   ENDIF
                                                                                            MD028338
      ** Reuse filler for the FX Rate Change Only Indicator                                 MD028338
                                                                                            MD028338
     C     K_ZZ004       IFEQ      'Y'                                                      MD028338
     C                   MOVEL     K_ZZ004       DDFRCO                                     MD028338
     C                   ENDIF                                                              MD028338
      *
      **  Next loan currency repayment amount
      **  - Customer Lending Enhancement Syndications feature
      *
     C     K_NLRA        IFNE      *ZERO
     C     S01465        ANDEQ     'Y'
     C                   MOVEL     K_NCCY        @CURR
     C                   Z-ADD     53            DBASE
     C                   EXSR      SRCurrDet
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      K_NLRA        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNLRA
     C                   ENDIF
      *
     C                   MOVEL     K_SPI1        DDSPI1
     C                   MOVEL     K_SPI2        DDSPI2
     C                   MOVEL     K_SPI3        DDSPI3
      *
     C/COPY WNCPYSRC,LEH01456
      * Enable display of Funding Details if Analytical Accounting
      * module is switched on and loan is directly funded.
      * or enable display of Funding Details if Revenue Analysis
      * is switched on.
      *
     C     BGN0ST        IFEQ      'Y'
     C     FPRC          ANDNE     *BLANKS
     C     CDE002        OREQ      'Y'
     C     PTYP          IFEQ      62
     C     PTYP          OREQ      64
     C     PTYP          OREQ      66
     C     PTYP          OREQ      61
     C     PTYP          OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     PTYP          OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     PTYP          OREQ      63
     C     CDE002        ANDEQ     'Y'
     C     PTYP          OREQ      65
     C     CDE002        ANDEQ     'Y'
     C     PTYP          OREQ      67
     C     CDE002        ANDEQ     'Y'
     C                   MOVE      *ON           *IN62
     C                   ENDIF
     C                   ENDIF
      *
      **  Funding details
      *
     C     *IN62         IFEQ      *ON
      *
      **  New funding spread/rate
     C     NFRS          IFNE      *ZERO
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NFRS          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C**********         MOVE      ZFIELD        DDNFRSB                                      CAP084
     C                   MOVE      ZFIELD        DDNFRS                                       CAP084
     C                   ENDIF
      *
      **  New funding spread indicator and profit centre
     C**********         MOVEL     NFSN          DDNFSNB                                      CAP084
     C**********         MOVEL     NFPC          DDNFPCB                                      CAP084
     C                   MOVEL     NFSN          DDNFSN                                       CAP084
     C**********         MOVEL     NFPC          DDNFPC                               CAP084 BUG8145
     C                   MOVEL     FPRC          DDNFPC                                      BUG8145
     C                   MOVEL     FPRC          DDNFPCB                                     BUG8145
     C                   ENDIF
                                                                                              BUG827
     C     CAS001        IFEQ      'Y'                                                        BUG827
     C                   MOVEL     K_FSFYLB      DDFYLD                                       BUG827
     C                   ENDIF                                                                BUG827
                                                                                              CLE034
     C**********         EVAL      DDRSTA = K_RSTA                                    CLE034 CSF011A
     C                   EVAL      DDNSTA = K_RSTA                                           CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSTAT  -  Determine Rollover Status Narrative                *
      * Called by: SRSFLD - Format subfile fields                     *
      *            SRMOVP - Move test harness fields to screen fields *
      *            SRMOVR - Move rollover loan details to screen      *
      * Calls    : None                                               *
      *****************************************************************
     C     SRSTAT        BEGSR
      *
     C                   MOVE      *BLANKS       ZAMSID            7
     C                   SELECT
     C     WRSTS         WHENEQ    'C'
     C                   MOVEL     'LEV0003'     ZAMSID
     C     WRSTS         WHENEQ    'R'
     C                   MOVEL     'LEV0004'     ZAMSID
     C     WRSTS         WHENEQ    'A'
     C                   MOVEL     'LEV0005'     ZAMSID
     C     WRSTS         WHENEQ    'D'
     C                   MOVEL     'LEV0006'     ZAMSID
     C     WRSTS         WHENEQ    'Q'                                                        CLE030
     C                   MOVEL     'LEL0124'     ZAMSID                                       CLE030
     C                   OTHER
     C                   MOVE      *BLANKS       WSTAT
     C                   ENDSL
     C     ZAMSID        IFNE      *BLANKS
     C                   EXSR      SRTEXT
     C                   MOVEL(P)  ZAMSTX        WSTAT            16
     C                   MOVE      *BLANKS       ZAMSID
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurrDet - Access Currency Details                           *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCurrDet     BEGSR

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7

     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFREQB - Calc day num of next pymnt frq from curr dayno       *
      *                                                               *
      *****************************************************************
     C     ZFREQB        BEGSR

     C                   CallB     'ZFREQB'
     C                   Parm      *blanks       RetCodeIn
     C                   Parm                    ZFREQ             1
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3                        AR702741
     C                   Parm                    ZMDAY             2 0
     C                   Parm                    BJDFIN
     C                   Parm      SDGELR        SDGELR

     C                   ENDSR
     C********************************************************************
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
     C                   PARM                    ZAMSTX          132            Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      * Called by: SrScreen1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0

     C                   ENDSR
      *****************************************************************
      *****************************************************************
      * INIT - Initialization                                         *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Blank outputs (except for action code within loan format)
      *
     C     DDACTN        IFNE      'A'                                                        CAP084
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        RollScnFmt
     C                   MOVEL     ##ACTN        DDACTN
     C                   ENDIF                                                                CAP084
      *
      * Clear Rollover Instructions Work fields (output only fields)
      *
     C                   Clear                   RollScnWrk2
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
     C                   PARM                    LnCLFilFmt
      *
      ***  Loan in file format CK
      *
     C                   PARM                    LnCKFilFmt
      *
      ***  Features
      *
     C                   PARM                    CLE011            1
     C                   PARM                    S01465            1
     C                   PARM                    CLE005            1
                                                                                             BUG2579
      ** Multi-currency allowed by Loan facility                                             BUG2579
      ** New Facility xrate required for CLE023                                              BUG2579
     C                   PARM                    @MULTI            1                         BUG2579
     C                   PARM                    @FCXRATE          1                         BUG2579
      *
      ***  OUTPUT parameters
      *
      ***  Rollover Instructions in screen format
      *
     C                   PARM                    RollScnFmt
      *
      ***  Rollover Instructions in screen format
      *
     C                   PARM                    RollScnWrk2
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LELERICVT'   DBPGM
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
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 904*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END

      ** Access SAR details file to determine if CDE002 is switched on

     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CDE002'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C                   Move      'N'           CDE002            1
     C                   If        PRTCD = *Blanks
     C                   Eval      CDE002 = 'Y'
     C                   Endif
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '905'         DBASE                          * DBERR 905 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
                                                                                              BUG827
      ** Determine if CAS001 is installed                                                     BUG827
                                                                                              BUG827
     C                   CALLB     'AOSARDR0'                                                 BUG827
     C                   PARM      *BLANKS       @RTCD                                        BUG827
     C                   PARM      '*VERIFY '    @OPTN                                        BUG827
     C                   PARM      'CAS001'      @SARD                                        BUG827
     C     SCSARD        PARM      SCSARD        DSFDY                                        BUG827
                                                                                              BUG827
     C     @RTCD         IFEQ      *BLANKS                                                    BUG827
     C                   MOVE      'Y'           CAS001            1                          BUG827
     C                   ELSE                                                                 BUG827
     C                   MOVE      'N'           CAS001                                       BUG827
     C                   ENDIF                                                                BUG827
                                                                                             BUG9507
      ** Determine CLE036 is enabled                                                         BUG9507
                                                                                             BUG9507
     C                   MOVE      'N'           CLE036            1                         BUG9507
     C                   CALLB     'AOSARDR0'                                                BUG9507
     C                   PARM      *BLANKS       @RTCD                                       BUG9507
     C                   PARM      '*VERIFY'     @OPTN                                       BUG9507
     C                   PARM      'CLE036'      @SARD                                       BUG9507
                                                                                             BUG9507
      ** Database Error                                                                      BUG9507
                                                                                             BUG9507
     C                   IF        @RTCD <> *BLANKS AND                                      BUG9507
     C                             @RTCD <> '*NRF '                                          BUG9507
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG9507
     C                   EVAL      DBASE = 54                                                BUG9507
     C                   MOVEL     @OPTN         DBKEY                                       BUG9507
     C                   EXSR      *PSSR                                                     BUG9507
     C                   ENDIF                                                               BUG9507
     C     @RTCD         IFEQ      *BLANKS                                                   BUG9507
     C                   MOVE      'Y'           CLE036                                      BUG9507
     C                   ENDIF                                                               BUG9507
                                                                                              CRE073
     C/COPY WNCPYSRC,LEH01457
      ** Determine CRE073 Interest Rate Rounding feature is on                                CRE073
                                                                                              CRE073
     C                   MOVE      'N'           CRE073            1                          CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       @RTCD                                        CRE073
     C                   PARM      '*VERIFY'     @OPTN                                        CRE073
     C                   PARM      'CRE073'      @SARD                                        CRE073
                                                                                              CRE073
      ** Database Error                                                                       CRE073
                                                                                              CRE073
     C                   IF        @RTCD <> *BLANKS AND                                       CRE073
     C                             @RTCD <> '*NRF '                                           CRE073
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRE073
     C                   EVAL      DBASE = 55                                                 CRE073
     C                   MOVEL     @OPTN         DBKEY                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
     C     @RTCD         IFEQ      *BLANKS                                                    CRE073
     C                   MOVE      'Y'           CRE073                                       CRE073
     C                   ENDIF                                                                CRE073

      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @type             1
     C*
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
(c) Finastra International Limited 2002
