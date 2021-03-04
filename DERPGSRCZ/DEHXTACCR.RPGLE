     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Hist Ext of Retail Accounts')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract module                                  *
      *                                                               *
      *  DEHXTACCR - Historic Extract of Accounts                     *
      *                                                               *
      *  Function:  This module performs the extraction of Retail     *
      *             Accounts for the analysis of revenue within       *
      *             CCRM. It is called by DEHXCACCT and writes        *
      *             details to the historic extract files. It runs    *
      *             automatically in COB to process all Retail        *
      *             Accounts or On-request in the I/C for a single    *
      *             Account.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 216234             Date 04Apr03               *
      *                 CDE005             Date 22Aug02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  216234 - Problem if the history balance on REHISPS is debit  *
      *           and the history balance on REHISPD is credit for    *
      *           the same history date.                              *
      *  CDE005 - Data Export - Reservation ID (Recompiled)           *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Set up Funding sign on the Opening Position         *
      *           Enable DEWRKEDTA to get info from data area         *
      *           At the present writing out an asset and a liability *
      *           position for each history record regardless of how  *
      *           movement affects balance.                           *
      *           If the account balance is positive and the action   *
      *           of the movement means that the balance is still     *
      *           positive, only an asset record is required.         *
      *           Similarly if balance is negative and will stay      *
      *           negative, only a liability record is required.      *
      *           When the balance will switch from positive to       *
      *           negative or vice versa, both records are required.  *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************

      ** RE Debit Margin history by Account and Date
     FREHMRGL1  IF   E           K DISK
     F                                     RENAME(REHMRGD0:REHMRGD1)

      ** RE Credit Margin History by Account and Date
     FREHMRGL2  IF   E           K DISK
     F                                     RENAME(REHMRGD0:REHMRGD2)

      ** RE Retail History Debit Rate Change Records
     FREHRDJ    IF   E           K DISK

      ** RE Retail History Credit Rate Change Records
     FREHRCJ    IF   E           K DISK

      ** RE Retail Postings History File
     FREHPOPL   IF   E           K DISK
     F                                     PREFIX(PT_)

      ** RE Full Retail History File
     FREHISL0   IF   E           K DISK

      ** Accounts by Reference
     FACCBR     IF   E           K DISK
     F                                     PREFIX(PN_)
     F                                     RENAME(ACCNTABF:ACCNTAB0)

      ** Accounts by Retail Account No.
     FACCNTL1   IF   E           K DISK
     F                                     PREFIX(PR_)
     F                                     RENAME(ACCNTABF:ACCNTAB1)
     FDEHTRANPD O    E           K DISK
     FDEHPOSNPD O    E           K DISK
     FDEHEVNTPD O    E           K DISK
     FDEHCASHPD O    E           K DISK

      *********************************************************************
      * E X T R A C T   P E R I O D   D E F I N I T I O N
      /COPY DECPYSRC,DEXTPERDD
      *****************************************************************
      *
      ** Array for processing Posting Narrative
     D  PostNarr       S              1    DIM(30)
     D
      ** Array for processing VAT Narrative
     D  ScanArr        S              1    DIM(30)
      *
      ** Array for Fee Code
     D FeeCodeAr       S              2A   DIM(999)
      *
      ** Array for Commission and Charges amount
     D ChgCcyComAr     S             13P 0 DIM(999)
     D CommAr          S             13P 0 DIM(999)
     D ChgCcyChgAr     S             13P 0 DIM(999)
     D ChrgAr          S             13P 0 DIM(999)
     D
      *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

     D RELIVEX       E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC_)

     D REHISBLX      E DS                  EXTNAME(REHISPD)
     D                                     PREFIX(BL_)

      * E X T R A C T   F I L E S
      /COPY DECPYSRC,DEXTFILS

     D**  Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D**  Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for GENERAL LEDGER details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(RT_)

      ** External DS for Narrative Details
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
      *
      ** External DS for Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029

      ** External DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Midas Cusomer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for Switchable Features details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External DS for Posting narraive Details
     D CGPNAR        E DS                  EXTNAME(CGPNARPD)

     D I#PRM1          DS
      **  Data Structure for Customer and Branch
      *
     D ##CUST                  1      6
     D ##BRCA                  7      9

     D*W#ACID***       DS            20                                                       CGL029
     D W#ACID          DS            26                                                       CGL029
     D*W#CNUM***               1      6  0                                                    CSD027
     D W#CNUM                  1      6A                                                      CSD027
     D W#CCY                   7      9
     D W#ACOD                 10     19  0                                                    CGL029
     D W#ACSQ                 20     21  0                                                    CGL029
     D W#BRCA                 22     24                                                       CGL029
     D*W#ACOD***              10     13  0                                                    CGL029
     D*W#ACSQ***              14     15  0                                                    CGL029
     D*W#BRCA***              16     18                                                       CGL029

     D*W#ACPO***       DS                                                                     CGL029
     D W#ACPO          DS            24                                                       CGL029
     D*W#ACCN***               1      6  0                                                    CSD027
     D W#ACCN                  1      6A                                                      CSD027
     D W#ACCY                  7      9
     D W#ACCD                 10     19  0                                                    CGL029
     D W#ACAS                 20     21  0                                                    CGL029
     D*W#ACCD***              10     13  0                                                    CGL029
     D*W#ACAS***              14     15  0                                                    CGL029

     D*
     D** Debit Rates
     D WDRAT           DS
     D  ZIRD                   1     66P 7
     D                                     DIM(11)                              ZIC. INT.RATES
     D  ZRD01                  1      6P 7
     D  ZRD02                  7     12P 7
     D  ZRD03                 13     18P 7
     D  ZRD04                 19     24P 7
     D  ZRD05                 25     30P 7
     D  ZRD06                 31     36P 7
     D  ZRD07                 37     42P 7
     D  ZRD08                 43     48P 7
     D  ZRD09                 49     54P 7
     D  ZRD010                55     60P 7
     D  ZRD011                61     66P 7
     D  ZRD012                67     72P 7
     D*
     D** Debit Rates
     D WCRAT           DS
     D  ZIRC                   1     66P 7
     D                                     DIM(11)                              ZIC. INT.RATES
     D  ZRC01                  1      6P 7
     D  ZRC02                  7     12P 7
     D  ZRC03                 13     18P 7
     D  ZRC04                 19     24P 7
     D  ZRC05                 25     30P 7
     D  ZRC06                 31     36P 7
     D  ZRC07                 37     42P 7
     D  ZRC08                 43     48P 7
     D  ZRC09                 49     54P 7
     D  ZRC010                55     60P 7
     D  ZRC011                61     66P 7
     D  ZRC012                67     72P 7
     D*
     D*
     D** Date Structire To split from alpha to numeric debit and
     D** credit balances
     D*
     D WDBAL           DS
     D  ZIBD                   1     88P 0
     D                                     DIM(11)                              ZIC. INT.BALANCES
     D  ZBD01                  1      8P 0
     D  ZBD02                  9     16P 0
     D  ZBD03                 17     24P 0
     D  ZBD04                 25     32P 0
     D  ZBD05                 33     40P 0
     D  ZBD06                 41     48P 0
     D  ZBD07                 49     56P 0
     D  ZBD08                 57     64P 0
     D  ZBD09                 65     72P 0
     D  ZBD010                73     80P 0
     D  ZBD011                81     88P 0
     D  ZBD012                89     96P 0
     D*
     D WCBAL           DS
     D  ZIBC                   1     88P 0
     D                                     DIM(11)                              ZIC. INT.BALANCES
     D  ZBC01                  1      8P 0
     D  ZBC02                  9     16P 0
     D  ZBC03                 17     24P 0
     D  ZBC04                 25     32P 0
     D  ZBC05                 33     40P 0
     D  ZBC06                 41     48P 0
     D  ZBC07                 49     56P 0
     D  ZBC08                 57     64P 0
     D  ZBC09                 65     72P 0
     D  ZBC010                73     80P 0
     D  ZBC011                81     88P 0
     D  ZBC012                89     96P 0
     D*
     D** Posting Narrative Data structure
     D*FullNarr*       DS            30                                                       CGL029
     D FullNarr        DS            36                                                       CGL029
     D NarrBrc                 9     11
     D*NarrCust*              13     18  0                                                    CSD027
     D NarrCust               13     18A                                                      CSD027
     D NarrCcy                20     22
     D NarrAcod               24     33  0                                                    CGL029
     D NarrAcsq               35     36  0                                                    CGL029
     D*NarrAcod*              24     27  0                                                    CGL029
     D*NarrAcsq*              29     30  0                                                    CGL029
      *
      ** Work variables
     D WFeeCode        S              2A
     D W#HONR          S             30A
     D W#INNR          S             30A
     D W#MBNR          S             30A
     D W#EXNR          S             30A
     D W#FCNR          S             30A
     D W#DTNR          S             30A
     D W#DINR          S             30A
     D W#HMNR          S             30A
     D W#NANR          S             30A

     D Ix              S              3P 0
     D MovIx           S              3P 0
     D W#BCOM          S             13P 0
     D W#BCHGS         S             13P 0
                                                                                              CGL029
      ** Fields redefined by CGL029                                                           CGL029
     D K#ACOD          S             10P 0                                                    CGL029
     D K#ACOD1         S             10P 0                                                    CGL029
     D K#ACOD2         S             10P 0                                                    CGL029
     D W#CHACD         S             10P 0                                                    CGL029
     D CH_ACOD         S             10P 0                                                    CGL029
     D P@ACCD          S             10A                                                      CGL029
     D W#TEMP          S             14A                                                      CGL029
     D W#FILL          S             11A                                                      CGL029
      *
      ********************************************************************
      * MAIN PROCESSING
      ********************************************************************

     C                   EXSR      XTINIT

     C                   EXSR      XTMAIN

     C                   MOVE      *ON           *INLR
     C                   RETURN
     C/SPACE 5
      ********************************************************************
      * INITIAL PROCESSING
      ********************************************************************
     C     XTINIT        BEGSR


     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#ACTN            1
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#PH              1
     C                   PARM                    I#EOB             1
     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#HCOD            5 0
     C                   PARM                    I#EXTD            5 0
     C                   PARM                    I#EVCD            5 0
     C                   PARM                    I#PCOD            5 0
     C                   PARM                    PeriodEDT
     C                   PARM                    I#ACCD           25
     C                   PARM                    RELIVEX
     C                   PARM                    REHISBLX
     C                   PARM                    Dataarea                                     208221
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '        '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOBANKR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'HACCR'                                           208221
      *
      **  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '        '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOGELRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOMMODR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      **  Access Retail Details
      *
     C                   CALLB     'AORETLR0'
     C                   PARM      '        '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AORETLR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      ** Set up UDC Report Narrative
     C                   IF        BGN1ST = 'Y'
     C
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'REPNAR'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           W#UDCN            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF   '
     C                   MOVEL     'N'           W#UDCN            1
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOSARDR0'
     C                   END
     C                   END

     C                   ELSE
     C                   MOVEL     'N'           W#UDCN            1
     C                   END

      *
      **  Access Currency Details
      *
     C                   MOVE      BJCYCD        @CYCD
      *
     C                   EXSR      ACSCCY
     C
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOCURRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
     C
     C                   Z-ADD     A6NBDP        W#BCDP            1 0
      *
      **  Access Narrative Details for VAT
      *
     C                   MOVE      'R0'          @NRCD
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @NRCD             2
     C     SDNARR        PARM      SDNARR        DSSDY
     C
     C                   IF        @RTCD = *Blanks
     C                   MOVEL     ALDON         W#VATN           30
     C                   ELSE
     C                   IF        @RTCD = '*NRF   '
     C                   MOVEL     '** VAT **'   W#VATN           30
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Access Narrative Details for Charges
      *
     C                   MOVE      'R3'          @NRCD
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @NRCD             2
     C     SDNARR        PARM      SDNARR        DSSDY
      *
     C
     C                   IF        @RTCD = *Blanks
     C                   MOVEL     ALDON         W#CHGN           30
     C                   ELSE
     C                   IF        @RTCD = '*NRF   '
     C                   MOVEL     'CHARGES'     W#CHGN           30
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
     C                   ENDIF
     C*
     C** Set up Cahrges Narrative 2
     C                   EVAL      W#CHGN2 =W#CHGN
      *
      ** Access narrative details for Dr H/O Commission
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'R7'          @NRCD
     C     SDNARR        PARM      SDNARR        DSSDY
     C
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      W#HONR = ALDON
     C                   ELSE

     C                   IF        @RTCD = '*NRF   '
     C                   EVAL      W#HONR = 'Dr H/O COM'
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

     C                   ENDIF
      *
      ** Access narrative details for Inactive commission
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'R8'          @NRCD
     C     SDNARR        PARM      SDNARR        DSSDY
     C
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      W#INNR = ALDON
     C                   ELSE

     C                   IF        @RTCD = '*NRF   '
     C                   EVAL      W#INNR = 'INACT.COM'
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

     C                   ENDIF
      *
      ** Access narrative details for Minimum balance commission
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'R9'          @NRCD
     C     SDNARR        PARM      SDNARR        DSSDY
     C
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      W#MBNR = ALDON
     C                   ELSE

     C                   IF        @RTCD = '*NRF   '
     C                   EVAL      W#MBNR = 'MIN BAL COM'
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

     C                   ENDIF
      *
      ** Access narrative details for Statement commission
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'RA'          @NRCD
     C     SDNARR        PARM      SDNARR        DSSDY
     C
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      W#EXNR = ALDON
     C                   ELSE

     C                   IF        @RTCD = '*NRF   '
     C                   EVAL      W#EXNR = 'EXTRA STMT COM.'
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

     C                   ENDIF
      *
      ** Access narrative details for Fixed commission
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'RC'          @NRCD
     C     SDNARR        PARM      SDNARR        DSSDY
     C
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      W#FCNR = ALDON
     C                   ELSE

     C                   IF        @RTCD = '*NRF   '
     C                   EVAL      W#FCNR = 'FIXED COM.'
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

     C                   ENDIF
      *
      ** Access narrative details for Account commission
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'RD'          @NRCD
     C     SDNARR        PARM      SDNARR        DSSDY
     C
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      W#DTNR = ALDON
     C                   ELSE

     C                   IF        @RTCD = '*NRF   '
     C                   EVAL      W#DTNR = 'A/C COM'
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

     C                   ENDIF
      *
      ** Access narrative details for Dr Interest commission
      *
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      'RE'          @NRCD
     C     SDNARR        PARM      SDNARR        DSSDY
     C
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      W#DINR = ALDON
     C                   ELSE

     C                   IF        @RTCD = '*NRF   '
     C                   EVAL      W#DINR = 'DR INT. COM'
     C                   ELSE
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AONARRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      W#HMNR = 'Charge for Hold Mail'
     C                   EVAL      W#NANR = 'Charge for Numbered Acc'

     C                   ENDSR

      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * MAIN PROCESSING
      ********************************************************************
     C     XTMAIN        BEGSR
      *
     C                   EXSR      TRANIT
      *
      ** Main Processing - 'Asset' Position
      *
     C                   MOVE      'A'           W#ASLI            1
      *
      ** Perform Main Subroutine in /COPY DEXTMAINO
      *
     C                   EXSR      MAIN
      *
      ** Main Processing - 'Liability' Position
      *
     C                   MOVE      'L'           W#ASLI            1
      *
      ** Perform Main Subroutine in /COPY DEXTMAINO
      *
     C                   EXSR      MAIN
      *
      ** Perform Commitment as per /COPY DEXTCOMMO
      *
     C                   EXSR      COMIT

     C                   ENDSR

      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * TRANSACTION INITIALISATION
      ********************************************************************
     C     TRANIT        BEGSR
      *
      ** Clear Historic Transaction detail
     C                   CLEAR                   T#TRAN
      *
      ** Clear Historic Transaction detail
     C                   EVAL      T#MOD = 'GL'
      *
      ** Set up Transaction Reference
     C                   EVAL      W#CNUM = AC_CNUM
     C                   EVAL      W#CCY = AC_CCY
     C                   EVAL      W#ACOD = AC_ACOD
     C                   EVAL      W#ACSQ = AC_ACSQ
     C                   EVAL      W#BRCA = AC_BRCA
     C*
     C                   EVAL      T#TREF = W#ACID
      *
      ** Set up Transaction Type
     C                   MOVEL     AC_ACOD       T#TRTP
      *
      ** Set up Transaction Sub-Type
     C                   EVAL      T#TRST = AC_STYP
      *
      ** Set up Account Description
     C                   EVAL      T#TDES = I#ACCD
      *
      ** Set up Branch
     C                   EVAL      T#BRCA = AC_BRCA
      *
      ** Set up Counter Party
     C                   EVAL      T#CPTY = AC_CNUM
      *
      ** Set up Risk Customer
     C                   EVAL      T#RCST = AC_CNUM
      *
      ** Set up Transaction Market Value
     C                   IF        BMCBAI = 'Y'
     C                   EVAL      T#MKVL = AC_CLBL
     C                   ELSE
     C                   EVAL      T#MKVL = AC_LDBL
     C                   ENDIF
      *
      ** Set up Transaction Valuation Currency
     C                   EVAL      T#VCCY = AC_CCY
      *
      ** Access Details about Account Currency
     C                   MOVE      AC_CCY        @CYCD
      *
     C                   EXSR      ACSCCY
      *
     C                   MOVE      A6NBDP        W#ACDP            1 0
     C                   MOVE      A6SPRT        W#ACSR           13 8
     C                   MOVE      A6MDIN        W#ACMD            1
      *
      ** Set up Transaction Valuation Currency Decimal Places
     C                   EVAL      T#VCDP = A6NBDP
      *
      ** Set up Transaction Action
     C                   EVAL      T#ACTN = I#ACTN
      *
      ** Import the Transaction
     C                   EVAL      W#MODE = '*IMPTRAN'
      *
     C                   EXSR      WRKEDTA
      *
      ** Reset Export Indicators
     C                   EVAL      Posn_Exp = *Blank
     C                   EVAL      Evnt_Exp = *Blank
     C                   EVAL      Cash_Exp = *Blank
      *
      ** Process UDC transactions
     C                   IF        W#UDCN = 'Y'
      *
      ** Access Customer Details
     C                   MOVEL     AC_CNUM       @KEY1
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOCUSTR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      ** Set CGPNAR Module
     C                   EVAL       MNMODI = 'RE'
      *
      ** Set CGPNAR Branch
     C                   EVAL       MNBRCA = AC_BRCA
      *
      ** Set CGPNAR Customer
     C                   MOVEL     AC_CNUM       MNCUST
      *
      ** Set CGPNAR Currency
     C                   EVAL       MNCYCD = AC_CCY
      *
      ** Set CGPNAR Account Code
     C                   MOVEL     AC_ACOD       MNACCD
      *
      ** Set CGPNAR Account Sequence
     C                   MOVEL     AC_ACSQ       MNACSQ
      *
      ** Set CGPNAR Customer Report Name
     C                   EVAL       MNCRNM = BBCRNM
      *
      ** Set CGPNAR Retail Account Number
     C                   MOVEL     AC_ACNO       MNRACN
      *
      ** Set CGPNAR Associated Customer
     C                   EVAL       MNASOC = *Blanks
      *
      ** Clear Customer and Branch Parameter
     C                   CLEAR                   I#PRM1
      *
      ** Set up VAT Narrative
     C                   EVAL      MNNARR = W#VATN
      *
      ** Set up AOPNARR0 Message ID
     C                   EVAL      ##MGID = 'GB00370'
      *
      ** Set up Return Code
     C                   EVAL      W0RTN = *Blanks
      *
      ** Set up Return Narrative
     C                   EVAL      ##PNAR = *Blanks
      *
     C                   CALL      'AOPNARR0'
     C                   PARM                    W0RTN             7
     C                   PARM                    ##MGID            7
     C                   PARM                    I#PRM1            9
     C                   PARM                    CGPNAR
     C                   PARM                    ##PNAR           50
      *
      ** If Record Found
     C                   IF        W0RTN = *Blanks
     C                   MOVEL     ##PNAR        W#VATN
     C                   ENDIF
      *
      ** Determine Charges Narrative
     C                   EVAL      MNNARR = W#CHGN
      *
      ** Set up AOPNARR0 Message ID
     C                   EVAL      ##MGID = 'GB00200'
      *
      ** Set up Return Code
     C                   EVAL      W0RTN = *Blanks
      *
      ** Set up Return Narrative
     C                   EVAL      ##PNAR = *Blanks
      *
     C                   CALL      'AOPNARR0'
     C                   PARM                    W0RTN             7
     C                   PARM                    ##MGID            7
     C                   PARM                    I#PRM1            9
     C                   PARM                    CGPNAR
     C                   PARM                    ##PNAR           50
      *
      ** If Record Found
     C                   IF        W0RTN = *Blanks
     C                   MOVEL     ##PNAR        W#CHGN
     C                   ENDIF
      *
      ** Determine Charges Narrative 2
     C                   IF        BMRANR = 'Y'
     C                   EVAL      ##MGID = 'GB00201'
     C                   ELSE
     C                   EVAL      ##MGID = 'GB00202'
     C                   ENDIF
      *
      ** Set up Return Code
     C                   EVAL      W0RTN = *Blanks
      *
      ** Set up Return Narrative
     C                   EVAL      ##PNAR = *Blanks
      *
     C                   CALL      'AOPNARR0'
     C                   PARM                    W0RTN             7
     C                   PARM                    ##MGID            7
     C                   PARM                    I#PRM1            9
     C                   PARM                    CGPNAR
     C                   PARM                    ##PNAR           50
      *
      ** If Record Found
     C                   IF        W0RTN = *Blanks
     C                   MOVEL     ##PNAR        W#CHGN2          30
     C                   ENDIF
      *
      ** Determine fixed commission narrative
      *
     C                   EVAL      MNNARR = W#FCNR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00300'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#FCNR = ##PNAR
     C                   ENDIF
      *
      ** Determine Account commission narrative
      *
     C                   EVAL      MNNARR = W#DTNR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00310'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#DTNR = ##PNAR
     C                   ENDIF
      *
      ** Determine Dr Interest commission narrative
      *
     C                   EVAL      MNNARR = W#DINR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00320'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#DINR = ##PNAR
     C                   ENDIF
      *
      ** Determine H/O commission narrative
      *
     C                   EVAL      MNNARR = W#HONR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00330'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#HONR = ##PNAR
     C                   ENDIF
      *
      ** Determine Inactive commission narrative
      *
     C                   EVAL      MNNARR = W#INNR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00340'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#INNR = ##PNAR
     C                   ENDIF
      *
      ** Determine Minimum balance commission narrative
      *
     C                   EVAL      MNNARR = W#MBNR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00350'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#MBNR = ##PNAR
     C                   ENDIF
      *
      ** Determine Statement commission narrative
      *
     C                   EVAL      MNNARR = W#EXNR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00360'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#EXNR = ##PNAR
     C                   ENDIF
      *
      ** Determine Charge for Numbered acc narrative
      *
     C                   EVAL      MNNARR = W#NANR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00130'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#NANR = ##PNAR
     C                   ENDIF
      *
      ** Determine Charge for Hold mail narrative
      *
     C                   EVAL      MNNARR = W#HMNR
     C                   CALL      'AOPNARR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      'GB00150'     ##MGID
     C                   PARM                    I#PRM1
     C                   PARM                    CGPNAR
     C                   PARM      *BLANKS       ##PNAR
      *
      ** If Record Found
     C                   IF        W0RTN = *BLANKS
     C                   EVAL      W#HMNR = ##PNAR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      * IMPORT OPENING POSITION AND EVENTS
      *****************************************************************
     C     IMPORT        BEGSR
      *
      * Import Opening Position
     C                   EXSR      IMPOPOS
      *
      * Asset Processing
     C                   IF        W#ASLI = 'A'
      *
      * Rate Change Processing
     C                   IF        BL_DRCI = 'Y'
      *
      ** Set Work Interest Calculation Type
     C                   Z-ADD     BL_DICT       W#ICT             2 0
      *
      ** Set Work Interest Calculation Basis
     C                   Z-ADD     BL_DRCB       W#ICB             1 0
      *
      ** Set Work Rate Change Date
     C                   Z-ADD     BL_HISD       W#RCDT            5 0
      *
      ** Set Work Rate/Spread
     C                   Z-ADD     BL_DRIR       W#RTSP           11 7
      *
      ** Set work overdraft rate
     C                   Z-ADD     BL_AODR       W#ODRT           11 7
      *
      ** Set work overdraft line
     C                   Z-ADD     BL_ODRL       W#ODLN           10 0
      *
      ** Import Rate Event
     C                   EXSR      IMPORAT
      *
     C                   ENDIF
      *
      ** Import Manual Adjustments
     C                   IF        BL_MADI <> 0
      *
      ** Set Work Manual Adjustment
     C***************    Z-ADD     BL_HISD       W#NADT            5 0                        208221
     C                   Z-ADD     BL_HISD       W#MADT            5 0                        208221
      *
      ** Set Work Adjustment Amount
     C                   Z-ADD     BL_MADI       W#ADJA           15 0
      *
      ** Import Manual Adjustment Event
     C                   EXSR      IMPOMADJ
      *
     C                   ENDIF
      *
      ** Import all other historic events
     C                   EXSR      IMPOALLH
      *
     C                   ENDIF
      *
      * Liability Processing
     C                   IF        W#ASLI = 'L'
      *
      * Rate Change Processing
     C                   IF        BL_CRCI = 'Y'
      *
      ** Set Work Interest Calculation Type
     C                   Z-ADD     BL_CICT       W#ICT             2 0
      *
      ** Set Work Interest Calculation Basis
     C                   Z-ADD     BL_CRCB       W#ICB             1 0
      *
      ** Set Work Rate Change Date
     C                   Z-ADD     BL_HISD       W#RCDT            5 0
      *
      ** Set Work Rate/Spread
     C                   Z-ADD     BL_CRIR       W#RTSP           11 7
      *
      ** Set work overdraft rate
     C                   Z-ADD     0             W#ODRT           11 7
      *
      ** Set work overdraft line
     C                   Z-ADD     0             W#ODLN           10 0
      *
      ** Import Rate Event
     C                   EXSR      IMPORAT
      *
     C                   ENDIF
      *
      ** Perform Manual Adjustments Processing
     C                   IF        BL_MACI <> 0
      *
      ** Set Work Manual Adjustment
     C**************     Z-ADD     BL_HISD       W#NADT            5 0                        208221
     C                   Z-ADD     BL_HISD       W#MADT            5 0                        208221
      *
      ** Set Work Adjustment Amount
     C                   Z-ADD     BL_MACI       W#ADJA           15 0
      *
      ** Import Manual Adjustment Event
     C                   EXSR      IMPOMADJ
      *
     C                   ENDIF
      *
      ** Perform Retail History Debit Movements Processing
     C                   IF        BL_DMVT <> 0 or BL_CMVT <> 0
      *
      ** Set Work Manual Adjustment
     C                   Z-ADD     BL_HISD       W#HISD            5 0
      *
      ** Set Work Adjustment Amount
     C**********         MOVEL     *BLANKS       W#ACPO           18                          CGL029
     C                   MOVEL     *BLANKS       W#ACPO                                       CGL029
      *
      ** Import Commissions and Charges Events
     C                   EXSR      IMPOCOCH
      *
     C                   ENDIF
      *
      ** Import all other historic events
     C                   EXSR      IMPOALLH
      *
     C                   ENDIF
      *
      ** Perform Maturity Event Processing
     C                   IF        AC_RECI = 'C' and AC_DACC <> 0
      *
      ** Import Maturity Event
     C                   EXSR      IMPOMAT
      *
     C                   ENDIF
      *
      ** Import Period End Dates
     C                   EXSR      IMP_PE
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT OPENING POSITION
      *****************************************************************
     C     IMPOPOS       BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   P#POSN
      *
      * Reset work minimum balance
     C                   Z-ADD     0             W#MINBAL         15 0
      *
      * Module, Transaction Reference
     C                   MOVEL     T#TKEY        P#TKEY
      *
      * Asset/Liability
     C                   MOVEL     W#ASLI        P#ASLI
      *
      * Interest Accrl Ctl Date
     C                   Z-ADD     BL_HISD       P#IACD
      *
      * Accrued Int To Date
     C                   Z-ADD     *ZERO         P#AITC
      *
      * Nominal/Principal
     C                   Z-ADD     BL_HISB       W#ACCBAL         15 0
      *
      * Minimum Monthly Balance
     C                   Z-ADD     BL_MNBL       W#MINBAL         15 0
      *
      * Nominal/Principal
      *
      ** Asset Processing
     C                   IF        P#ASLI = 'A'
     C                   IF        BL_DICT >= 3
     C                   EVAL      P#NOML = BL_MNBL
     C                   IF        P#NOML < 0
     C                   EVAL      P#NOML = 0
     C                   ENDIF
     C                   ELSE
     C                   IF        W#ACCBAL < 0
     C                   EVAL      P#NOML = 0
     C                   ELSE
     C                   EVAL      P#NOML = W#ACCBAL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Liablity Processing
     C                   IF        P#ASLI = 'L'
     C                   IF        BL_CICT >= 3
     C                   EVAL      P#NOML = BL_MNBL
     C                   IF        P#NOML > 0
     C                   EVAL      P#NOML = 0
     C                   ENDIF
     C                   ELSE
     C                   IF        W#ACCBAL > 0
     C                   EVAL      P#NOML = 0
     C                   ELSE
     C                   EVAL      P#NOML = W#ACCBAL
     C                   ENDIF
     C                   ENDIF
      *
      ** Take Modulus of Nominal
     C                   IF        P#NOML < 0
     C     0             SUB       P#NOML        P#NOML
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Currency
     C                   MOVEL     BL_CCY        P#CCY
     C                   MOVEL     BL_CCY        @CYCD
     C                   EXSR      ACSCCY
      *
      * Position Ccy Dec Places
     C                   MOVEL     A6NBDP        P#NCDP
      *
      * Position Nominal Dec Places
     C                   MOVEL     A6NBDP        P#NMDP
      *
      * Position Currency Spot Days
     C                   MOVEL     A6SPDY        P#SPDY
      *
      * Position Accuracy
     C                   MOVEL     '9'           P#ACUR
      *
      * Accrue Indicator
     C                   MOVEL     'Y'           P#ACIN
      *
      * Accrue Cost of Funds
      *
      * Set up Calculation Basis from retail history file.
     C                   MOVEL     'Y'           P#ACCF
     C                   IF        W#ASLI = 'A' and BL_DRCB <> 0
     C                   EVAl      W#ICB = BL_DRCB
     C                   ENDIF
      *
     C                   IF        W#ASLI = 'L' and BL_CRCB <> 0
     C                   EVAl      W#ICB = BL_CRCB
     C                   ENDIF
      *
      * Set up Calculation Basis from Account Master file if it is not held on Retail history file
     C                   IF        W#ASLI = 'A' and AC_DRIC <> 0
     C                             and W#ICB = 0
     C                   EVAl      W#ICB = AC_DRIC
     C                   ENDIF
      *
     C                   IF        W#ASLI = 'L' and AC_CRIC <> 0
     C                             and W#ICB = 0
     C                   EVAl      W#ICB = AC_CRIC
     C                   ENDIF
      *
      ** If there thee are no calculation bases for retail history or for account
      ** default value to 1.
     C                   IF        W#ICB = 0
     C                   EVAl      W#ICB = 1
     C                   ENDIF
      *
      ** Obtain Calulation Method
     C                   EXSR      CALMETH
      *
     C                   EVAL      P#ICMT = W#ICMT
      *                                                                                       208221
      ** Set up Funding Rate Sign                                                             208221
     C                   IF        W#ASLI = 'A'                                               208221
     C                   EVAL      P#FSGN = '-'                                               208221
     C                   ELSE                                                                 208221
     C                   EVAL      P#FSGN = '+'                                               208221
     C                   ENDIF                                                                208221
      *
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT RATE EVENT
      *****************************************************************
     C     IMPORAT       BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = W#ASLI
      *
      * Set Event Processing date
     C                   EVAL      E#PRDT = W#RCDT
      *
      * Set Event Type
     C                   EVAL      E#EVTP = 'SC'
      *
      * Set Event Interest Rate Change
     C                   EVAL      E#IRCH = 'Y'
      *
      * Asset Processing
     C                   IF        W#ASLI = 'A'
      *
      * Calculate Work Balance based on Interest calculation type
     C                   IF        W#ICT  < 3
      *
     C                   IF        W#ACCBAL > 0
     C                   Z-ADD     W#ACCBAL      W#BALN           15 0
     C                   ELSE
     C                   EVAL      W#BALN = 0
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        W#MINBAL > 0
     C                   EVAL      W#BALN = W#MINBAL
     C                   ELSE
     C                   EVAL      W#BALN = 0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Liability Processing
     C                   IF        W#ASLI = 'L'
      *
      * Calculate Workbalance based on Interest calculation type
     C                   IF        W#ICT  < 3
      *
     C                   IF        W#ACCBAL < 0
     C                   Z-ADD     W#ACCBAL      W#BALN           15 0
     C                   ELSE
     C                   EVAL      W#BALN = 0
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        W#MINBAL < 0
     C                   EVAL      W#BALN = W#MINBAL
     C                   ELSE
     C                   EVAL      W#BALN = 0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Make Work Balances +ve
     C     0             SUB       W#BALN        W#BALN
     C     0             SUB       W#MINBAL      W#MINBAL
     C                   ENDIF
      *
      ** Calculate Spread Rate
     C                   IF        W#ICT = 0
      *
      ** Use Spread rate or calculate effective rate if this is blank
     C                   IF        W#ODRT = 0
     C                   EVAL      E#RTSP = W#RTSP
     C                   ELSE
     C                   EXSR      CALEFRT
     C                   EVAL      E#RTSP = W#EFRT
     C                   ENDIF
      *
     C                   ELSE
     C                   EXSR      CALEFRT
     C                   EVAL      E#RTSP = W#EFRT
     C                   ENDIF
      *
      ** Determine Calculation Method
     C                   EXSR      CALMETH
      *
     C                   EVAL      E#ICMT = W#ICMT
      *
      **Set up Key list to access MArgin History files
     C     K#MRG         KLIST
     C                   KFLD                    K#BRCA            3
     C**********         KFLD                    K#CNUM            6 0                        CSD027
     C                   KFLD                    K#CNUM            6                          CSD027
     C                   KFLD                    K#CCY             3
     C**********         KFLD                    K#ACOD            4 0                        CGL029
     C                   KFLD                    K#ACOD                                       CGL029
     C                   KFLD                    K#ACSQ            2 0
     C                   KFLD                    K#HISD            5 0
      *
     C**************     EVAL      K#BRCA = BL_BRCA                                           208221
     C**************     EVAL      K#CNUM = BL_CNUM                                           208221
     C**************     EVAL      K#CCY = BL_CCY                                             208221
     C**************     EVAL      K#ACOD = BL_ACOD                                           208221
     C**************     EVAL      K#ACSQ = BL_ACSQ                                           208221
     C                   EVAL      K#CNUM = AC_CNUM                                           208221
     C                   EVAL      K#CCY = AC_CCY                                             208221
     C                   EVAL      K#ACOD = AC_ACOD                                           208221
     C                   EVAL      K#ACSQ = AC_ACSQ                                           208221
     C                   EVAL      K#BRCA = AC_BRCA                                           208221
     C                   EVAL      K#HISD = W#RCDT
      *
      ** Asset Processing
     C                   IF        W#ASLI = 'A'
      *
      ** Access record from file
     C     K#MRG         CHAIN     REHMRGL1                           89
      *
      ** Set Details if Record found
     C                   IF        *IN89 = *Off
     C                   EVAL      E#CRCH = 'Y'
     C                   EVAL      E#FSGN = '-'
     C                   EVAL      E#FSRP = MGRATE
     C                   ENDIF
     C                   ENDIF
      *
      ** Liability Processing
     C                   IF        W#ASLI = 'L'
      *
      ** Access record from file
     C     K#MRG         CHAIN     REHMRGL2                           89
      *
      ** Set Details if Record found
     C                   IF        *IN89 = *Off
     C                   EVAL      E#CRCH = 'Y'
     C**************     EVAL      E#FSGN = '-'                                               208221
     C                   EVAL      E#FSGN = '+'                                               208221
     C                   EVAL      E#FSRP = MGRATE
     C                   ENDIF
     C                   ENDIF
      *
      * Import Rate Event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Set Work Extracted indicator
     C                   MOVEL     'Y'           W#REXT            1
     C                   Z-ADD     W#RCDT        W##RCD            5 0                        208221
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MANUAL ADJUSTMENT EVENT
      *****************************************************************
     C     IMPOMADJ      BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = W#ASLI
      *
      * Set Event Processing Date
     C                   EVAL      E#PRDT = W#MADT
      *
      * Set Event Type
     C                   EVAL      E#EVTP = 'MI'
      *
      * Set Event Interest Amount
     C                   EVAL      E#INTA = W#ADJA
      *
      ** Set Number of movements
     C                   EVAL      E#MVNO = 1
      *
      * Import Fee Payment Event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT COMMISSIONS AND CHARGES EVENT
      *****************************************************************
     C     IMPOCOCH      BEGSR
      *
      ** Reset Work Commissions and Work Charges
     C                   Z-ADD     0             W#COMM           13 0
     C                   Z-ADD     0             W#CHGS           13 0
      *
      ** Define Key List
     C     K#CHG         KLIST
     C                   KFLD                    K#BRCA2           3
     C**********         KFLD                    K#CNUM2           6 0                        CSD027
     C                   KFLD                    K#CNUM2           6                          CSD027
     C                   KFLD                    K#CCY2            3
     C**********         KFLD                    K#ACOD2           4 0                        CGL029
     C                   KFLD                    K#ACOD2                                      CGL029
     C                   KFLD                    K#ACSQ2           2 0
     C                   KFLD                    K#HIDT2           5 0
      *
      ** Set Limits against REHPOPL
     C                   IF        W#ACPO = *BLANKS
      *
     C                   EVAL      K#BRCA2 = BL_BRCA
     C                   EVAL      K#CNUM2 = BL_CNUM
     C                   EVAL      K#CCY2 = BL_CCY
     C                   EVAL      K#ACOD2 = BL_ACOD
     C                   EVAL      K#ACSQ2 = BL_ACSQ
     C                   EVAL      K#HIDT2 = W#HISD
      *
     C     K#CHG         SETLL     REHPOPL                                89
     C                   ELSE
      *
     C                   Z-ADD     0             W#CCOM           13 0
     C                   Z-ADD     0             W#CCHGS          13 0
      *
     C                   EVAL      K#BRCA2 = W#CHBRC
     C                   EVAL      K#CNUM2 = W#CHCNM
     C                   EVAL      K#CCY2 = W#CHCCY
     C                   EVAL      K#ACOD2 = W#CHACD
     C                   EVAL      K#ACSQ2 = W#CHASQ
     C                   EVAL      K#HIDT2 = W#HISD
      *
     C     K#CHG         SETLL     REHPOPL                                89
     C                   ENDIF
      *
      ** Read REHPOPL
     C     K#CHG         READE     REHPOPL                                89
     C                   DOW       *IN89 = *Off
      *
      ** Scan for VAT details
     C                   IF        PT_TRAT = 91050
     C     '** VAT **'   SCAN      PT_PNAR:1                              89
      *
      ** If Narrative is not found
     C                   IF        *IN89 = *Off
     C                   MOVEA     W#VATN        ScanArr
     C                   Z-ADD     30            Sc                2 0
     C                   DOW       ScanArr(Sc) = *Blanks
     C                   Sub       1             Sc
     C                   ENDDO
     C     W#VATN:Sc     SCAN      PT_PNAR:1                              89
      *
      ** If Narrative is not found
     C                   IF        *IN89 = *Off
     C                   EXSR      ACCSCAN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Scan for VAT details
     C                   IF        PT_TRAT = 94052 or PT_TRAT = 94053
     C                             or PT_TRAT = 94055
     C                   EXSR      ACCSCAN
     C                   ENDIF
      *
     C     K#CHG         READE     REHPOPL                                89
     C                   ENDDO
      *
      ** Convert Charges to Base Currency
     C                   IF        W#ACPO <> *BLANKS

     C                   EVAL      Ix = 1
     C                   DOW       FeeCodeAr(Ix) <> *BLANKS

     C                   IF        W#CHCCY <> AC_CCY
      *
      ** Check if charges Currency = Base Currency
     C                   IF        W#CHCCY <> BJCYCD
     C                   EXSR      CVTTOBASE
     C                   ELSE
      *
      ** Set Base Currency Charges and Commmissions
     C                   EVAL      W#BCOM  = ChgCcyComAr(Ix)
     C                   EVAL      W#BCHGs = ChgCcyChgAr(Ix)

     C                   ENDIF
      *
      ** Check if Account Currency = Base Currency
     C                   IF        AC_CCY <> BJCYCD
     C                   EXSR      CVTFMBASE
     C                   ELSE
      *
      ** Set Work Charges and Commmissions
     C                   EVAL      CommAr(Ix) = W#BCOM
     C                   EVAL      ChrgAr(Ix) = W#BCHGS

     C                   ENDIF

     C                   ELSE

     C                   EVAL      CommAr(Ix) = ChgCcyComAr(Ix)
     C                   EVAL      ChrgAr(Ix) = ChgCcyChgAr(Ix)

     C                   ENDIF
     C                   EVAL      Ix = Ix + 1

     C                   ENDDO
      *
     C                   ELSE
      *
      ** Set Base Currency Charges and Commmissions
     C                   Z-ADD     W#CCOM        W#COMM           13 0
     C                   Z-ADD     W#CCHGS       W#CHGS           13 0
     C                   ENDIF
      *
     C                   IF        W#COMM <> 0 or W#CHGS <> 0

     C                   EVAL      Ix = 1
     C                   DOW       FeeCodeAr(Ix) <> *BLANKS
      *
      * CLEAR POSITION
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = W#ASLI
      *
      * Set Event Processing date
     C                   EVAL      E#PRDT = W#HISD
      *
      * Set Event Type
     C                   EVAL      E#EVTP = 'FE'
      *
      * Set Event Charges
     C                   EVAL      E#CHRG = ChrgAr(Ix)
      *
      * Set Event Commissions
     C                   EVAL      E#COMM = CommAr(Ix)
      *
      * Set Event Total Amount
     C                   EVAL      E#TAMT = ChrgAr(Ix) + CommAr(Ix)
      *
      ** Set Fee code
     C                   EVAL      E#FEEC = FeeCodeAr(Ix)
      *
      ** Set Number of movements
     C                   EVAL      E#MVNO = MovIx
     C                   EVAL      MovIx = 0
      *
      * Set Event Currency Deciaml Places
     C                   EVAL      E#NCDP = T#VCDP
      *
      * Set Event Processed Indicator
     C                   EVAL      E#PRCD = 'Y'
      *
      * Set Event Total Amount
     C                   IF        E#TAMT < 0
     C                   EVAL      E#IO = 'O'
     C     0             SUB       E#TAMT        E#TAMT
     C                   ELSE
     C                   EVAL      E#IO = 'I'
     C                   ENDIF
      *
      * Import Commissions and Charges Event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA

     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * SCAN POSTING NARRATIVE FOR ACCOUNT DETAILS
      *****************************************************************
     C     ACCSCAN       BEGSR
     C*
     C** Check Narrative for Standard Midas Account details
     C                   MOVEL     PT_PNAR       FullNarr
     C                   EVAL      K#BRCA1 = NarrBrc
     C                   EVAL      K#CNUM1 = NarrCust
     C                   EVAL      K#CCY1 = NarrCcy
     C                   EVAL      K#ACOD1 = NarrAcod
     C                   EVAL      K#ACSQ1 = NarrAcsq
     C*
      ** Define Key list
     C     K#KEY1        KLIST
     C                   KFLD                    K#BRCA1           3
     C**********         KFLD                    K#CNUM1           6 0                        CSD027
     C                   KFLD                    K#CNUM1           6                          CSD027
     C                   KFLD                    K#CCY1            3
     C**********         KFLD                    K#ACOD1           4 0                        CGL029
     C                   KFLD                    K#ACOD1                                      CGL029
     C                   KFLD                    K#ACSQ1           2 0
      *
      ** Check if Record exists
     C     K#KEY1        CHAIN     ACCBR                              89
      *
     C     *IN89         IFEQ      *Off
     C                   MOVE      'Y'           AccFound          1
     C                   MOVE      PN_BRCA       CH_BRCA           3
     C**********         MOVE      PN_CNUM       CH_CNUM           6 0                        CSD027
     C                   MOVE      PN_CNUM       CH_CNUM           6                          CSD027
     C                   MOVE      PN_CCY        CH_CCY            3
     C**********         MOVE      PN_ACOD       CH_ACOD           4 0                        CGL029
     C                   MOVE      PN_ACOD       CH_ACOD                                      CGL029
     C                   MOVE      PN_ACSQ       CH_ACSQ           2 0
     C                   MOVE      PN_ACNO       CH_ACNO          10 0
     C                   ENDIF
      *
      ** Check if Record exists
     C                   IF        AccFound <> 'Y'
     C                   MOVEA     PT_PNAR       PostNarr
     C                   Z-ADD     1             x                 2 0
      *
      ** Look for Retail Account Numbers
     C                   DOW       x < 31
     C                   MOVEA     PostNarr(x)   W#Narr           10
     C                   MOVEL     W#Narr        W#NarrNo         10 0
     C                   MOVEL     W#NarrNo      W#NarrCn         10
      *
      ** If portion of field is numeric check to see if it corresponds
      ** to a valid retail account
     C                   IF        W#NarrCn = W#Narr
     C     W#NarrNo      CHAIN     ACCNTL1                            89
     C                   IF        *IN89 = *Off
     C                   MOVE      PR_BRCA       CH_BRCA           3
     C**********         MOVE      PR_CNUM       CH_CNUM           6 0                        CSD027
     C                   MOVE      PR_CNUM       CH_CNUM           6                          CSD027
     C                   MOVE      PR_CCY        CH_CCY            3
     C**********         MOVE      PR_ACOD       CH_ACOD           4 0                        CGL029
     C                   MOVE      PR_ACOD       CH_ACOD                                      CGL029
     C                   MOVE      PR_ACSQ       CH_ACSQ           2 0
     C                   MOVE      PR_ACNO       CH_ACNO          10 0
     C                   MOVE      'Y'           RetFound          1
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             x
     C                   CLEAR                   W#Narr
     C                   ENDDO
     C                   ENDIF
     C
     C*
     C** Set up Details
     C                   IF        W#ACPO = *Blanks
     C*
     C** If Narrative Account Details are found and match main Account Details
     C                   IF        AccFound <> 'Y' and RetFound <> 'Y'
     C                             or CH_ACNO = AC_ACNO
     C                             or CH_BRCA = AC_BRCA
     C                             and CH_CNUM = AC_CNUM
     C                             and CH_CCY = AC_CCY
     C                             and CH_ACOD = AC_ACOD
     C                             and CH_ACSQ = AC_ACSQ
     C*
     C                   IF        PT_TRAT = 91050

     C                   EXSR      SrFeeCode
     C                   EVAL      Ix = 1
     C     WFeeCode      LOOKUP    FeeCodeAr(Ix)                          89

     C                   IF        *IN89 = *Off
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FeeCodeAr(Ix) = WFeeCode
     C                   ENDIF

     C                   EVAL      MovIx = MovIx + 1
     C                   IF        WFeeCode = 'HO' OR WFeeCode = 'DT' OR
     C                             WFeeCode = 'FC' OR WFeeCode = 'EX' OR
     C                             WFeeCode = 'DI' OR WFeeCode = 'MB'

     C                   IF        PT_DRCR = 0
     C                   EVAL      CommAr(Ix) = CommAr(Ix) + PT_PSTA
     C                   EVAL      W#COMM = PT_PSTA + W#COMM
     C                   ELSE
     C                   EVAL      CommAr(Ix) = CommAr(Ix) - PT_PSTA
     C                   EVAL      W#COMM = W#COMM - PT_PSTA
     C                   ENDIF

     C                   ELSE

     C                   IF        PT_DRCR = 0
     C                   EVAL      ChrgAr(Ix) = ChrgAr(Ix) + PT_PSTA
     C                   EVAL      W#CHGS = PT_PSTA + W#CHGS
     C                   ELSE
     C                   EVAL      ChrgAr(Ix) = ChrgAr(Ix) - PT_PSTA
     C                   EVAL      W#CHGS = W#CHGS - PT_PSTA
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C                   EXSR      SrFeeCode
     C                   EVAL      Ix = 1
     C     WFeeCode      LOOKUP    FeeCodeAr(Ix)                          89

     C                   IF        *IN89 = *Off
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FeeCodeAr(Ix) = WFeeCode
     C                   ENDIF

     C                   EVAL      MovIx = MovIx + 1
     C                   IF        PT_DRCR = 0
     C                   EVAL      ChrgAr(Ix) = ChrgAr(Ix) + PT_PSTA
     C                   EVAL      W#CHGS = PT_PSTA + W#CHGS
     C                   ELSE
     C                   EVAL      ChrgAr(Ix) = ChrgAr(Ix) - PT_PSTA
     C                   EVAL      W#CHGS = W#CHGS - PT_PSTA
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C
     C                   ELSE
     C*
     C** If Narrative Account Details are found and match main Account Details
     C                   IF        RetFound = 'Y' and CH_ACNO = AC_ACNO
     C                             or AccFound = 'Y'
     C                             and CH_BRCA = AC_BRCA
     C                             and CH_CNUM = AC_CNUM
     C                             and CH_CCY = AC_CCY
     C                             and CH_ACOD = AC_ACOD
     C                             and CH_ACSQ = AC_ACSQ
     C*
     C                   IF        PT_TRAT = 91050

     C                   EXSR      SrFeeCode
     C                   EVAL      Ix = 1
     C     WFeeCode      LOOKUP    FeeCodeAr(Ix)                          89

     C                   IF        *IN89 = *Off
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FeeCodeAr(Ix) = WFeeCode
     C                   ENDIF

     C                   EVAL      MovIx = MovIx + 1
     C                   IF        WFeeCode = 'HO' OR WFeeCode = 'DT' OR
     C                             WFeeCode = 'FC' OR WFeeCode = 'EX' OR
     C                             WFeeCode = 'DI' OR WFeeCode = 'MB'

     C                   IF        PT_DRCR = 0
     C                   EVAL      ChgCcyComAr(Ix) = ChgCcyComAr(Ix) + PT_PSTA
     C                   EVAL      W#CCOM = PT_PSTA + W#CCOM
     C                   ELSE
     C                   EVAL      ChgCcyComAr(Ix) = ChgCcyComAr(Ix) - PT_PSTA
     C                   EVAL      W#CCOM = W#CCOM - PT_PSTA
     C                   ENDIF

     C                   ELSE

     C                   IF        PT_DRCR = 0
     C                   EVAL      ChgCcyChgAr(Ix) = ChgCcyChgAr(Ix) + PT_PSTA
     C                   EVAL      W#CCHGS = PT_PSTA + W#CCHGS
     C                   ELSE
     C                   EVAL      ChgCcyChgAr(Ix) = ChgCcyChgAr(Ix) - PT_PSTA
     C                   EVAL      W#CCHGS = W#CCHGS - PT_PSTA
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C                   EXSR      SrFeeCode
     C                   EVAL      Ix = 1
     C     WFeeCode      LOOKUP    FeeCodeAr(Ix)                          89

     C                   IF        *IN89 = *Off
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FeeCodeAr(Ix) = WFeeCode
     C                   ENDIF

     C                   EVAL      MovIx = MovIx + 1
     C                   IF        PT_DRCR = 0
     c                   EVAL      ChgCcyChgAr(Ix) = ChgCcyChgAr(Ix) + PT_PSTA
     C                   EVAL      W#CCHGS = PT_PSTA + W#CCHGS
     C                   ELSE
     c                   EVAL      ChgCcyChgAr(Ix) = ChgCcyChgAr(Ix) - PT_PSTA
     C                   EVAL      W#CCHGS = W#CCHGS - PT_PSTA
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT ALL HISTORIC EVENTS
      *****************************************************************
     C     IMPOALLH      BEGSR
      *
      ** Set Greater limits on REHISL0
     C                   EVAL      K#BRCA2 = BL_BRCA
     C                   EVAL      K#CNUM2 = BL_CNUM
     C                   EVAL      K#CCY2 = BL_CCY
     C                   EVAL      K#ACOD2 = BL_ACOD
     C                   EVAL      K#ACSQ2 = BL_ACSQ
     C                   EVAL      K#HIDT2 = BL_HISD
      *
      ** Set Greater limits on REHISL0
     C                   EVAL      K#BRCA = BL_BRCA
     C                   EVAL      K#CNUM = BL_CNUM
     C                   EVAL      K#CCY = BL_CCY
     C                   EVAL      K#ACOD = BL_ACOD
     C                   EVAL      K#ACSQ = BL_ACSQ
      *                                                                                       208221
     C                   IF        AC_DRCD = 0 and AC_CRCD = 0                                208221
     C                   SUB       1             K#HIDT2                                      208221
     C                   ENDIF                                                                208221
      *
     C     K#CHG         SETGT     REHISL0
      *
      ** Reset Work Stored History Date
     C                   Z-ADD     0             W#SHISD           5 0
      * Work Previous History Balance
     C                   Z-ADD     BL_HISB       W#PRVBAL         15 0
      *
      ** Define Key list
     C     K#KEY         KLIST
     C                   KFLD                    K#BRCA            3
     C**********         KFLD                    K#CNUM            6 0                        CSD027
     C                   KFLD                    K#CNUM            6                          CSD027
     C                   KFLD                    K#CCY             3
     C**********         KFLD                    K#ACOD            4 0                        CGL029
     C                   KFLD                    K#ACOD                                       CGL029
     C                   KFLD                    K#ACSQ            2 0
      *
      ** Read Through REHISL0 until change of Account occurs
     C     K#KEY         READE     REHISL0                                89
     C                   DOW       *IN89 = *Off
      *
      ** Set up Work Stored History Date
     C                   IF        W#SHISD <> HISD
     C                   MOVE      *Blank        W#REXT            1
     C                   Z-ADD     0             W##RCD            5 0                        208221
     C                   EVAL      W#SHISD = HISD
     C                   ENDIF
      *
      ** Import Historic Events
     C                   IF        RECI = 'D'
      *
      ** Import Historic Events
     C                   IF        W#ASLI = 'A' and DICT < 3
     C                             or W#ASLI = 'L' and CICT < 3
      *
      ** Import Daily Movement Events
     C                   EXSR      IMPODMVT
      *
     C                   ENDIF
      *
      ** Process Assets
     C                   IF        W#ASLI = 'A'
      *
      ** Process Assets
     C                   IF        DRCI = 'Y'
     C                   EVAL      W#ICT = DICT
     C                   EVAL      W#ICB = DRCB
     C                   EVAL      W#RCDT = HISD
     C     *LIKE         DEFINE    DRIR          W#RTSP
     C                   EVAL      W#RTSP = DRIR
     C                   EVAL      W#ODRT = AODR
     C                   EVAL      W#ODLN = ODRL
      *
      * Nominal/Principal
     C                   EVAL      W#ACCBAL = MNBL
     C                   EVAL      W#ACCBAL = HISB
      *
     C                   EXSR      IMPORAT
     C                   ENDIF
      *
      ** Process Assets
     C                   IF        MADI <> 0
     C                   Z-ADD     HISD          W#MADT            5 0
     C                   EVAL      W#ADJA = MADI
     C                   EXSR      IMPOMADJ
     C                   ENDIF
     C
     C                   ENDIF
      *
      ** Process Liabilities
     C                   IF        W#ASLI = 'L'
      *
      ** Process Liabilities
     C                   IF        CRCI = 'Y'
     C                   EVAL      W#ICT = CICT
     C                   EVAL      W#ICB = CRCB
     C                   EVAL      W#RCDT = HISD
     C                   EVAL      W#RTSP = CRIR
     C                   EVAL      W#ODRT = 0
     C                   EVAL      W#ODLN = 0
      *
      * Nominal/Principal
     C                   EVAL      W#MINBAL = MNBL
     C                   EVAL      W#ACCBAL = HISB
      *
     C                   EXSR      IMPORAT
     C                   ENDIF
      *
      ** Process Liabilities
     C                   IF        MACI <> 0
     C                   EVAL      W#MADT = HISD
     C                   EVAL      W#ADJA = MACI
     C                   EXSR      IMPOMADJ
     C                   ENDIF
     C
     C                   ENDIF
     C
     C                   ENDIF
      *
      ** Process Monthly Movement Events
     C                   IF        RECI = 'M'
      *
      ** Import Monthly Movement Events
     C                   IF        W#ASLI = 'A' and DICT >= 3
     C                             or W#ASLI = 'L' and CICT >=3
     C                   EXSR      IMPOMMVT
     C                   ENDIF
     C                   ENDIF
      *
      ** Process Cost of Funds Events
     C                   IF        RECI = 'G' and W#REXT = *Blanks
     C                             OR RECI = 'G' and W#REXT = 'Y'                             208221
     C                             and W##RCD <> HISD                                         208221
      *
      ** Import Cost of Funds Events
     C                   IF        W#ASLI = 'A' and MGDRCR = '0'
     C                             or W#ASLI = 'L' and MGDRCR = '1'
     C                   EXSR      IMPOCFRT
     C                   ENDIF
     C                   ENDIF
      *
      ** Process Interest Payment Event
     C                   IF        RECI = 'S'
      *
      ** Import Interest Payment Event
     C                   IF        W#ASLI = 'A' and DRIP <> 0
     C                             or W#ASLI = 'L' and CRIP <> 0
     C                   EXSR      IMPOIPAY
     C                   ENDIF
      *
      ** Process Charges
     C                   IF        W#ASLI = 'L'
     C                   EVAL      W#HISD = HISD + 1
     C                   EVAL      W#ACPO = SCHAC
      *
      ** Set up Charge Retail Number and Filler
     C                   IF        W#ACPO <> *Blanks
     C                   MOVEL     W#ACPO        W#CRNO           10
     C**********         MOVE      W#ACPO        W#TEMP            8                          CGL029
     C**********         MOVEL     W#TEMP        W#FILL            5                          CGL029
     C                   MOVE      W#ACPO        W#TEMP                                       CGL029
     C                   MOVEL     W#TEMP        W#FILL                                       CGL029
      *
     C                   IF        W#FILL = *Blanks
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      W#CRNO        P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C**********         PARM                    P@ACCD            4            I:Key field 3 CGL029
     C                   PARM                    P@ACCD                                       CGL029
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     SDACCT        PARM      SDACCT        DSSDY                          O:OUTPUT
     C
     C                   IF        P@RTCD = '*NRF   '
     C                   EVAL      W#ACPO = *Blanks
     C                   ELSE
     C                   IF        P@RTCD = *Blanks
     C                   MOVEL     RT_BRCA       W#CHBRC           3
     C**********         MOVEL     RT_CNUM       W#CHCNM           6 0                        CSD027
     C                   MOVEL     RT_CNUM       W#CHCNM           6                          CSD027
     C                   MOVEL     RT_CCY        W#CHCCY           3
     C**********         MOVEL     RT_ACOD       W#CHACD           4 0                        CGL029
     C                   MOVEL     RT_ACOD       W#CHACD                                      CGL029
     C                   MOVEL     RT_ACSQ       W#CHASQ           2 0
     C                   ENDIF
     C                   ENDIF
     C
     C                   ELSE
     C                   MOVEL     CHBR          W#CHBRC
     C**********         MOVEL     W#ACCN        W#CHCNM           6 0                        CSD027
     C                   MOVEL     W#ACCN        W#CHCNM           6                          CSD027
     C                   MOVEL     W#ACCY        W#CHCCY           3
     C**********         MOVEL     W#ACCD        W#CHACD           4 0                        CGL029
     C                   MOVEL     W#ACCD        W#CHACD                                      CGL029
     C                   MOVEL     W#ACAS        W#CHASQ           2 0
     C                   ENDIF
      *
      ** Import Commissions and Charges Event
     C                   EXSR      IMPOCOCH
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     HISD          IFNE      WW#HISD                                                    216234
     C                   Z-ADD     HISB          W#PRVBAL         15 0
     C     *LIKE         DEFINE    HISD          WW#HISD                                      216234
     C                   Z-ADD     HISD          WW#HISD                                      216234
     C                   ENDIF                                                                216234
      *
     C     K#KEY         READE     REHISL0                                89
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT DAILY MOVEMENT EVENT
      *****************************************************************
     C     IMPODMVT      BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = W#ASLI
      *
      * Set Event Processing Date
     C                   EVAL      E#PRDT = HISD
      *
      ** Set Number of movements
     C                   EVAL      E#MVNO = 1
      *
      * Set Work Amount
     C                   Z-ADD     0             W#AMT            15 0
     C                   EVAL      W#AMT = DMVT - CMVT
      *
      * Import Daily Movement Amount
     C                   IF        W#AMT <> 0
      *
      * Set Work Resulting Balance
     C                   Z-ADD     0             W#ENDBAL         15 0
     C                   EVAL      W#ENDBAL = W#PRVBAL + W#AMT
      *
     C                   IF        W#ASLI = 'A'
     C*
     C                   IF        W#PRVBAL < 0
     C                   IF        W#ENDBAL > 0
     C                   EVAL      E#EVTP = 'PI'
     C                   EVAL      E#PRAM = W#ENDBAL
     C                   ENDIF
     C*
     C                   ELSE
     C                   IF        W#ENDBAL < 0
     C                   EVAL      E#EVTP = 'PD'
     C                   EVAL      E#PRAM = W#PRVBAL
     C                   ELSE
     C*
     C                   IF        W#AMT < 0
     C                   EVAL      E#EVTP = 'PD'
     C                   EVAL      E#PRAM = 0 - W#AMT
     C                   ELSE
     C                   EVAL      E#EVTP = 'PI'
     C                   EVAL      E#PRAM = W#AMT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ELSE
     C*
     C                   IF        W#PRVBAL > 0
     C                   IF        W#ENDBAL < 0
     C                   EVAL      E#EVTP = 'PI'
     C                   EVAL      E#PRAM = 0 - W#ENDBAL
     C                   ENDIF
     C*
     C                   ELSE
     C                   IF        W#ENDBAL > 0
     C                   EVAL      E#EVTP = 'PD'
     C                   EVAL      E#PRAM = 0 - W#PRVBAL
     C                   ELSE
     C*
     C                   IF        W#AMT < 0
     C                   EVAL      E#EVTP = 'PI'
     C                   EVAL      E#PRAM = 0 - W#AMT
     C                   ELSE
     C                   EVAL      E#EVTP = 'PD'
     C                   EVAL      E#PRAM = W#AMT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
      *
      ** Import Daily Movement Event
     C                   IF        E#EVTP <> *BLANKS
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      ** Import Rate change event
     C                   EVAL      W#ACCBAL = HISB
     C                   EVAL      W#MINBAL = MNBL
      *
      ** Process Assets
     C                   IF        W#ASLI = 'A'
     C                   EVAL      W#ICT = DICT
     C                   EVAL      W#ICB = DRCB
     C                   EVAL      W#RCDT = HISD
     C                   EVAL      W#RTSP = DRIR
     C                   EVAL      W#ODRT = AODR
     C                   EVAL      W#ODLN = ODRL
     C                   ELSE
      *
      ** Process Liabilities
     C                   EVAL      W#ICT = CICT
     C                   EVAL      W#ICB = CRCB
     C                   EVAL      W#RCDT = HISD
     C                   EVAL      W#RTSP = CRIR
     C                   EVAL      W#ODRT = 0
     C                   EVAL      W#ODLN = 0
     C                   ENDIF
      *
     C                   EXSR      IMPORAT
      *
     C                   ENDIF
      *
     C                   ENDSR
     C
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MONTHLY MOVEMENT EVENT
      *****************************************************************
     C     IMPOMMVT      BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = W#ASLI
      *
      * Set Event Processing Date
     C                   EVAL      E#PRDT = HISD
      *
      ** Set Number of movements
     C                   EVAL      E#MVNO = 1
      *
      * Set Work Amount
     C                   Z-ADD     0             W#AMT            15 0
     C                   EVAL      W#AMT = MNBL - W#MINBAL
      *
      * Set Work Minimum Balance
     C                   EVAL      W#MINBAL = MNBL
      *
      * Import Daily Movement Amount
     C                   IF        W#AMT <> 0
      *                                                                                       208221
      * Set Work Resulting Balance                                                            208221
     C                   Z-ADD     0             W#ENDBAL         15 0                        208221
     C                   EVAL      W#ENDBAL = W#PRVBAL + W#AMT                                208221
      *                                                                                       208221
     C                   IF        W#ASLI = 'A'
     C*                                                                                       208221
     C                   IF        W#PRVBAL < 0                                               208221
     C                   IF        W#ENDBAL > 0                                               208221
     C                   EVAL      E#EVTP = 'PI'                                              208221
     C                   EVAL      E#PRAM = W#ENDBAL                                          208221
     C                   ENDIF                                                                208221
     C*                                                                                       208221
     C                   ELSE                                                                 208221
     C                   IF        W#ENDBAL < 0                                               208221
     C                   EVAL      E#EVTP = 'PD'                                              208221
     C                   EVAL      E#PRAM = W#PRVBAL                                          208221
     C                   ELSE                                                                 208221
     C*                                                                                       208221
     C                   IF        W#AMT < 0
     C                   EVAL      E#EVTP = 'PD'
     C                   EVAL      E#PRAM = 0 - W#AMT
     C                   ELSE
     C                   EVAL      E#EVTP = 'PI'
     C                   EVAL      E#PRAM = W#AMT
     C                   ENDIF
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C*                                                                                       208221
     C                   ELSE
     C*                                                                                       208221
     C                   IF        W#PRVBAL > 0                                               208221
     C                   IF        W#ENDBAL < 0                                               208221
     C                   EVAL      E#EVTP = 'PI'                                              208221
     C                   EVAL      E#PRAM = 0 - W#ENDBAL                                      208221
     C                   ENDIF                                                                208221
     C*                                                                                       208221
     C                   ELSE                                                                 208221
     C                   IF        W#ENDBAL > 0                                               208221
     C                   EVAL      E#EVTP = 'PD'                                              208221
     C                   EVAL      E#PRAM = 0 - W#PRVBAL                                      208221
     C                   ELSE                                                                 208221
     C*                                                                                       208221
     C                   IF        W#AMT < 0
     C                   EVAL      E#EVTP = 'PI'
     C                   EVAL      E#PRAM = 0 - W#AMT
     C                   ELSE
     C                   EVAL      E#EVTP = 'PD'
     C                   EVAL      E#PRAM = W#AMT
     C                   ENDIF
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C*                                                                                       208221
     C                   ENDIF
      *
      ** Import Daily Movement Event
     C                   IF        E#EVTP <> *BLANKS                                          208221
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF                                                                208221
      *
      ** Import Rate change event
     C                   EVAL      W#ACCBAL = HISB
     C                   EVAL      W#MINBAL = MNBL
      *
      ** Process Assets
     C                   IF        W#ASLI = 'A'
     C                   EVAL      W#ICT = DICT
     C                   EVAL      W#ICB = DRCB
     C                   EVAL      W#RCDT = HISD
     C                   EVAL      W#RTSP = DRIR
     C                   EVAL      W#ODRT = AODR
     C                   EVAL      W#ODLN = ODRL
     C                   ELSE
      *
      ** Process Liabilities
     C                   EVAL      W#ICT = CICT
     C                   EVAL      W#ICB = CRCB
     C                   EVAL      W#RCDT = HISD
     C                   EVAL      W#RTSP = CRIR
     C                   EVAL      W#ODRT = 0
     C                   EVAL      W#ODLN = 0
     C                   ENDIF
      *
     C                   EXSR      IMPORAT
      *
     C                   ENDIF
      *
     C                   ENDSR
     C
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT COST OF FUNDS RATE EVENT
      *****************************************************************
     C     IMPOCFRT      BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = W#ASLI
      *
      * Set Event Processing Date
     C                   EVAL      E#PRDT = HISD
      *
      * Set Event Type
     C                   EVAL      E#EVTP = 'SC'
      *
      ** Set Event Rate Change
     C                   EVAL      E#IRCH = *Blanks
      *
      ** Determine the Calculation Method
     C                   EXSR      CALMETH
      *
      ** Set Calculation Method
     C                   EVAL      E#ICMT = W#ICMT
      *
      ** Set Cost of Funds Rate Change
     C                   EVAL      E#CRCH = 'Y'
      *
      ** Set Event Funding Sign
     C                   IF        W#ASLI = 'A'                                               208221
     C                   EVAL      E#FSGN = '-'
     C                   ELSE                                                                 208221
     C                   EVAL      E#FSGN = '+'                                               208221
     C                   ENDIF                                                                208221
      *
      ** Set Event Funding Spread Rate
     C                   EVAL      E#FSRP = MGRATE
      *
      ** Import Daily Movement Event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
     C
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT INTEREST PAYMENT EVENT
      *****************************************************************
     C     IMPOIPAY      BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = W#ASLI
      *
      * Set Event Processing Date
     C                   EVAL      E#PRDT = HISD
      *
      * Set Event Type
     C                   EVAL      E#EVTP = 'IP'
      *
      ** Set Event Interest Amount
     C                   IF        W#ASLI = 'A'
      *
      ** Assets
     C                   EVAL      E#INTA = DRIP
     C                   ELSE
      *
      ** Liabilities
     C                   EVAL      E#INTA = CRIP
      *
     C                   ENDIF
      *
      ** Set Number of movements
     C                   EVAL      E#MVNO = 1
      *
      ** Import Daily Movement Event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
     C
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MATURITY EVENT
      *****************************************************************
     C     IMPOMAT       BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = W#ASLI
      *
      * Set Event Processing Date
     C                   EVAL      E#PRDT = AC_DACC
      *
      * Set Event Type
     C                   EVAL      E#EVTP = 'MT'
      *
      ** Set Event Suppress Settlement
     C                   EVAL      E#SSET = 'Y'
      *
      ** Import Daily Movement Event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
     C
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * CALCULATE EFfECTIVE RATE
      *****************************************************************
     C     CALEFRT       BEGSR
      *
      ** Reset Work Effective Rate and set Required Flag to 'Y'
     C                   Z-ADD     0             W#EFRT           11 7
     C                   MOVE      'Y'           W#EFRQ            1
      *
      ** Set up Tier/Threshold Processing
     C                   IF        W#ICT = 0
     C                   Z-ADD     1             W#TTIN            1 0
     C                   Z-ADD     W#RTSP        W#TR1            11 7
     C                   Z-ADD     W#RTSP        W#TR2            11 7
     C                   ADD       W#ODRT        W#TR2
     C                   Z-ADD     0             W#TB1            15 0
     C                   Z-ADD     W#ODLN        W#TB2            15 0
      *
      ** Set up Tier/Threshold Processing
     C                   IF        W#TB2 = 0
     C                   EVAL      W#TR1 = W#TR2
     C                   EVAL      W#TR2 = 0
     C                   ENDIF
      *
      ** Tier Balance 2 > 0
     C                   ELSE
      *
     C                   IF        W#ICT = 1 or W#ICT = 3
     C                   EVAL      W#TTIN = 1
     C                   ENDIF
      *
     C                   IF        W#ICT = 2 or W#ICT = 4
     C                   EVAL      W#TTIN = 0
     C                   ENDIF
      *
      ** Assets
     C                   IF        W#ASLI = 'A'
      *
     C                   EVAL      K#BRCA = BL_BRCA
     C                   EVAL      K#CNUM = BL_CNUM
     C                   EVAL      K#CCY = BL_CCY
     C                   EVAL      K#ACOD = BL_ACOD
     C                   EVAL      K#ACSQ = BL_ACSQ
     C                   EVAL      K#HISD = W#RCDT
      *
      ** Access Record
     C     K#MRG         CHAIN     REHRDJ                             89
     C                   IF        *IN89 = *Off
     C                   MOVEL     RAT2          WDRAT
      ** If tiers 7-11 do not exist, set to zero
     C                   IF        RAT3 <> *Blanks
     C                   MOVE      RAT3          WDRAT
     C                   ELSE
     C                   EVAL      ZRD07  = *Zero
     C                   EVAL      ZRD08  = *Zero
     C                   EVAL      ZRD09  = *Zero
     C                   EVAL      ZRD010 = *Zero
     C                   EVAL      ZRD011 = *Zero
     C                   ENDIF
     C                   MOVEL     BAL2          WDBAL
      ** If balances 7-11 do not exist, set to zero
     C                   IF        BAL3 <> *Blanks
     C                   MOVE      BAL3          WDBAL
     C                   ELSE
     C                   EVAL      ZBD07  = *Zero
     C                   EVAL      ZBD08  = *Zero
     C                   EVAL      ZBD09  = *Zero
     C                   EVAL      ZBD010 = *Zero
     C                   EVAL      ZBD011 = *Zero
     C                   ENDIF
     C                   EVAL      W#FRT1 = ZRD01
     C                   EVAL      W#FRT2 = ZRD02
     C                   EVAL      W#FRT3 = ZRD03
     C                   EVAL      W#FRT4 = ZRD04
     C                   EVAL      W#FRT5 = ZRD05
     C                   EVAL      W#FRT6 = ZRD06
     C                   EVAL      W#FRT7 = ZRD07
     C                   EVAL      W#FRT8 = ZRD08
     C                   EVAL      W#FRT9 = ZRD09
     C                   EVAL      W#FRT10 = ZRD010
     C                   EVAL      W#FRT11 = ZRD011
     C                   EVAL      W#FAM1 = ZBD01
     C                   EVAL      W#FAM2 = ZBD02
     C                   EVAL      W#FAM3 = ZBD03
     C                   EVAL      W#FAM4 = ZBD04
     C                   EVAL      W#FAM5 = ZBD05
     C                   EVAL      W#FAM6 = ZBD06
     C                   EVAL      W#FAM7 = ZBD07
     C                   EVAL      W#FAM8 = ZBD08
     C                   EVAL      W#FAM9 = ZBD09
     C                   EVAL      W#FAM10 = ZBD010
     C                   EVAL      W#FAM11 = ZBD011
     C                   ELSE
     C                   EVAL      W#EFRQ = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Liabilities
     C                   IF        W#ASLI = 'L'
      *
     C                   EVAL      K#BRCA = BL_BRCA
     C                   EVAL      K#CNUM = BL_CNUM
     C                   EVAL      K#CCY = BL_CCY
     C                   EVAL      K#ACOD = BL_ACOD
     C                   EVAL      K#ACSQ = BL_ACSQ
     C                   EVAL      K#HISD = W#RCDT
      *
      ** Access Record
     C     K#MRG         CHAIN     REHRCJ                             89
     C                   IF        *IN89 = *Off
     C                   MOVEL     RAT2          WCRAT
      ** If tiers 7-11 do not exist, set to zero
     C                   IF        RAT3 <> *Blanks
     C                   MOVE      RAT3          WCRAT
     C                   ELSE
     C                   EVAL      ZRC07  = *Zero
     C                   EVAL      ZRC08  = *Zero
     C                   EVAL      ZRC09  = *Zero
     C                   EVAL      ZRC010 = *Zero
     C                   EVAL      ZRC011 = *Zero
     C                   ENDIF
     C                   MOVEL     BAL2          WCBAL
      ** If balances 7-11 do not exist, set to zero
     C                   IF        BAL3 <> *Blanks
     C                   MOVE      BAL3          WCBAL
     C                   ELSE
     C                   EVAL      ZBC07  = *Zero
     C                   EVAL      ZBC08  = *Zero
     C                   EVAL      ZBC09  = *Zero
     C                   EVAL      ZBC010 = *Zero
     C                   EVAL      ZBC011 = *Zero
     C                   ENDIF
     C                   EVAL      W#FRT1 = ZRC01
     C                   EVAL      W#FRT2 = ZRC02
     C                   EVAL      W#FRT3 = ZRC03
     C                   EVAL      W#FRT4 = ZRC04
     C                   EVAL      W#FRT5 = ZRC05
     C                   EVAL      W#FRT6 = ZRC06
     C                   EVAL      W#FRT7 = ZRC07
     C                   EVAL      W#FRT8 = ZRC08
     C                   EVAL      W#FRT9 = ZRC09
     C                   EVAL      W#FRT10 = ZRC010
     C                   EVAL      W#FRT11 = ZRC011
     C                   EVAL      W#FAM1 = ZBC01
     C                   EVAL      W#FAM2 = ZBC02
     C                   EVAL      W#FAM3 = ZBC03
     C                   EVAL      W#FAM4 = ZBC04
     C                   EVAL      W#FAM5 = ZBC05
     C                   EVAL      W#FAM6 = ZBC06
     C                   EVAL      W#FAM7 = ZBC07
     C                   EVAL      W#FAM8 = ZBC08
     C                   EVAL      W#FAM9 = ZBC09
     C                   EVAL      W#FAM10 = ZBC010
     C                   EVAL      W#FAM11 = ZBC011
     C                   ELSE
     C                   EVAL      W#EFRQ = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Calculate Effective Rate if Required
      *
     C                   IF        W#EFRQ = 'Y'
     C                   CALLB     'DECALEFRT'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      'RE'          W#MODI            2            * ERROR MESSAGE
     C                   PARM                    W#FRT1           11 7
     C                   PARM                    W#FRT2           11 7
     C                   PARM                    W#FRT3           11 7
     C                   PARM                    W#FRT4           11 7
     C                   PARM                    W#FRT5           11 7
     C                   PARM                    W#FRT6           11 7
     C                   PARM                    W#FRT7           11 7
     C                   PARM                    W#FRT8           11 7
     C                   PARM                    W#FRT9           11 7
     C                   PARM                    W#FRT10          11 7
     C                   PARM                    W#FRT11          11 7
     C                   PARM                    W#FAM1           15 0
     C                   PARM                    W#FAM2           15 0
     C                   PARM                    W#FAM3           15 0
     C                   PARM                    W#FAM4           15 0
     C                   PARM                    W#FAM5           15 0
     C                   PARM                    W#FAM6           15 0
     C                   PARM                    W#FAM7           15 0
     C                   PARM                    W#FAM8           15 0
     C                   PARM                    W#FAM9           15 0
     C                   PARM                    W#FAM10          15 0
     C                   PARM                    W#FAM11          15 0
     C                   PARM      W#BALN        W#IBAL           15 0
     C                   PARM      W#TTIN        W#TIER            1 0
     C                   PARM      *Zero         W#FERT           11 7
     C                   PARM      *Zero         W#FEBL           15 0
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECALFERT'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      W#EFRT = W#FERT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * DETERMINE CALCULATION METHOD
      *****************************************************************
     C     CALMETH       BEGSR
      *
      ** Int Calc Method
     C                   CALLB     'DECVTICDL'
     C                   PARM      *BLANK        W@RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W@ERMS           30            * ERROR MESSAGE
     C                   PARM      W#ICB         W@ICBS            1 0          * INT CAL BASIS
     C                   PARM      *BLANK        W@ICMT            7            * INT CAL MTHD
      *
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DECVTICDL'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   MOVEL     W@ICMT        W#ICMT            7
      *
     C                   ENDSR
      *
      ********************************************************************
      * WRITE PROCESSING
      ********************************************************************
     C     XTWRITE       BEGSR
      *
      **  Export transaction details from the limits and revenue module
     C                   MOVEL     '*EXPTRAN'    W#MODE
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   END
      *
     C     W#RTCD        DOWNE     '*EOD'
     C                   WRITE     DETRANP0
      *
      **  Export transaction details from the limits and revenue module
     C                   MOVEL     '*EXPTRAN'    W#MODE
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   END
      *
     C                   END
      *
      **  Export position details from the limits and revenue module
     C                   MOVEL     '*EXPPOSN'    W#MODE
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   END
      *
     C     W#RTCD        DOWNE     '*EOD'
     C                   WRITE     DEPOSNP0
      *
      **  Export position details from the limits and revenue module
     C                   MOVEL     '*EXPPOSN'    W#MODE
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   END
      *
     C                   END
      *
      **  Export event details from the limits and revenue module
     C                   MOVEL     '*EXPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   END
      *
     C     W#RTCD        DOWNE     '*EOD'
     C                   WRITE     DEEVNTP0
      *
      **  Export event details from the limits and revenue module
     C                   MOVEL     '*EXPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   END
      *
     C                   END
      *
      **  Export cashflow details from the limits and revenue module
     C                   MOVEL     '*EXPCASH'    W#MODE
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   END
      *
     C     W#RTCD        DOWNE     '*EOD'
     C                   WRITE     DECASHP0
      *
      **  Export cashflow details from the limits and revenue module
     C                   MOVEL     '*EXPCASH'    W#MODE
     C                   EXSR      WRKEDTA
      *
      **  If data error encountered, log error
     C     W#RTCD        IFEQ      '*ERROR '
     C                   EVAL      BUFFER = W#RTCD + W#ERMS + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CONVERT CHARGE CCY COMMISSIONS/CHARGES TO BASE
      ********************************************************************
     C     CVTTOBASE     BEGSR
      *
      ** Access Work Charge Currency Details
     C                   EVAL      @CYCD = W#CHCCY
     C                   EXSR      ACSCCY
      *
      ** Store Charge Currency DP, Spot Raye and MDIN
     C                   MOVE      A6NBDP        W#CHDP            1 0
     C                   MOVE      A6SPRT        W#CHSR           13 8
     C                   MOVE      A6MDIN        W#CHMD            1
      *
      ** Call ZCONVZ1 to convert amount
     C                   EVAL(R)   InputAmnt = ChgCcyComAr(Ix)
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    InputAmnt        15 0
     C                   PARM      W#CHSR        ExchRate         13 8
     C                   PARM      W#CHMD        MultDivInd        1
     C                   PARM      W#CHCCY       FrCurrency        3
     C                   PARM      BJCYCD        ToCurrency        3
     C                   PARM      W#CHDP        FrDecPlace        1 0
     C                   PARM      W#BCDP        ToDecPlace        1 0   
     C                   PARM      *Zero         OutputAmnt       15 0
      *
      ** Set Base Currency Commissions to Output Amount
     C                   EVAL      W#BCOM = OutputAmnt
      *
      ** Calcaulate Base CVharges Amount
     C                   EVAL(R)   InputAmnt = ChgCcyChgAr(Ix)
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    InputAmnt        15 0
     C                   PARM      W#CHSR        ExchRate         13 8
     C                   PARM      W#CHMD        MultDivInd        1
     C                   PARM      W#CHCCY       FrCurrency        3
     C                   PARM      BJCYCD        ToCurrency        3
     C                   PARM      W#CHDP        FrDecPlace        1 0
     C                   PARM      W#BCDP        ToDecPlace        1 0
     C                   PARM      *Zero         OutputAmnt       15 0
      *
      ** Set Base Currency Charges to Output Amount
     C                   EVAL      W#BCHGS = OutputAmnt
      *
     C                   ENDSR
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * CONVERT CHARGE CCY COMMISSIONS/CHARGES TO ACCOUNT
      ********************************************************************
     C     CVTFMBASE     BEGSR
      *
      ** Invert Multiply/Divide Indicator
     C                   IF        W#ACMD = 'M'
     C                   EVAL      MultDivInd = 'D'
     C                   ENDIF
      *
     C                   IF        W#ACMD = 'D'
     C                   EVAL      MultDivInd = 'M'
     C                   ENDIF
      *
      ** Call ZCONVZ1 to convert amount
     C                   CALLB     'ZCONVZ1'
     C                   PARM      W#BCOM        InputAmnt        15 0
     C                   PARM      W#ACSR        ExchRate         13 8
     C                   PARM                    MultDivInd        1
     C                   PARM      BJCYCD        FrCurrency        3
     C                   PARM      AC_CCY        ToCurrency        3
     C                   PARM      W#BCDP        FrDecPlace        1 0     
     C                   PARM      W#ACDP        ToDecPlace        1 0
     C                   PARM      *Zero         OutputAmnt       15 0
      *
      ** Set Base Currency Commissions to Output Amount
     C                   EVAL      CommAr(Ix) = CommAr(Ix) + OutputAmnt
      *
      ** Calcaulate Base Charges Amount
     C                   CALLB     'ZCONVZ1'
     C                   PARM      W#BCHGS       InputAmnt        15 0
     C                   PARM      W#ACSR        ExchRate         13 8
     C                   PARM                    MultDivInd        1
     C                   PARM      BJCYCD        FrCurrency        3
     C                   PARM      AC_CCY        ToCurrency        3
     C                   PARM      W#BCDP        FrDecPlace        1 0    
     C                   PARM      W#ACDP        ToDecPlace        1 0
     C                   PARM      *Zero         OutputAmnt       15 0
      *
      ** Set Base Currency Charges to Output Amount
     C                   EVAL      ChrgAr(Ix) = ChrgAr(Ix) + OutputAmnt
      *
     C                   ENDSR
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '        '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFeeCode - Setup Fee Code based on posting narrative.       *
      *                                                               *
      *****************************************************************
     C     SrFeeCode     BEGSR

     C                   IF        PT_TRAT = 91050
      *
      ** Fee commission
     C                   EVAL      WFeeCode = 'CH'
     C     W#FCNR        SCAN      PT_PNAR:1                              89
     C                   IF        *IN89 = *ON
     C                   EVAL      WFeeCode = 'FC'
     C                   ENDIF
      *
      ** Account commission
     C     W#DTNR        SCAN      PT_PNAR:1                              89
     C                   IF        *IN89 = *ON
     C                   EVAL      WFeeCode = 'DT'
     C                   ENDIF
      *
      ** Dr interest commission
     C     W#DINR        SCAN      PT_PNAR:1                              89
     C                   IF        *IN89 = *ON
     C                   EVAL      WFeeCode = 'DI'
     C                   ENDIF
      *
      ** H/O commission
     C     W#HONR        SCAN      PT_PNAR:1                              89
     C                   IF        *IN89 = *ON
     C                   EVAL      WFeeCode = 'HO'
     C                   ENDIF
      *
      ** Inactive commission
     C     W#INNR        SCAN      PT_PNAR:1                              89
     C                   IF        *IN89 = *ON
     C                   EVAL      WFeeCode = 'IN'
     C                   ENDIF
      *
      ** Minimum balance commission
     C     W#MBNR        SCAN      PT_PNAR:1                              89
     C                   IF        *IN89 = *ON
     C                   EVAL      WFeeCode = 'MB'
     C                   ENDIF
      *
      ** Statement commission
     C     W#EXNR        SCAN      PT_PNAR:1                              89
     C                   IF        *IN89 = *ON
     C                   EVAL      WFeeCode = 'EX'
     C                   ENDIF
      *
     C                   ENDIF

     C                   IF        PT_TRAT = 94052
     C                   EVAL      WFeeCode = 'SF'
     C                   ENDIF

     C                   IF        PT_TRAT = 94053
      *
      ** Charge for hold mail
     C                   EVAL      WFeeCode = 'HM'
      *
      ** Charge for Numbered Acc.
     C     W#NANR        SCAN      PT_PNAR:1                              89
     C                   IF        *IN89 = *ON
     C                   EVAL      WFeeCode = 'NA'
     C                   ENDIF
      *
     C                   ENDIF

     C                   IF        PT_TRAT = 94055
     C                   EVAL      WFeeCode = 'FA'
     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      /SPACE 5
      * M A I N   P R O C E S S I N G
      /COPY DECPYSRC,DEXTMAINO
      ********************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      /COPY DECPYSRC,DEXTWEDTA
      ********************************************************************
      * E X T R A C T   C O M M I T M E N T
      /COPY DECPYSRC,DEXTCOMMO
      ********************************************************************
      * E X T R A C T   P E R I O D   I M P O R T
      /COPY DECPYSRC,DEXTPERDI
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
