     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Hist Ext of Generic Transaction')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEHXTGETR - Historic Extract for Generic Transactions        *
      *                                                               *
      *  Function:  This module is called once for every generic      *
      *             transaction by the historic extract controller.   *
      *             It writes details to the historic extract files   *
      *             in the appropriate format.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
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
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Changed to use right size arrays for member         *
      *           When default the funding rate for LDNI also need to *
      *           default the cost of funds rate                      *
      *           Enable DEWRKEDTA to get info from data area         *
      *           Do not import deal date event for LDNI or NASP      *
      *           as this makes the position run from deal date       *
      *           rather from value date                              *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
 
     FDEGPOSNL1 IF   E           K DISK
     F                                     RENAME(DEPOSNP0: DEGPOSNP0)
     F                                     INFDS(INFDS)
     FDEGEVNTL1 IF   E           K DISK
     F                                     RENAME(DEEVNTP0: DEGEVNTP0)
 
     FDEHTRANPD O    E           K DISK
     FDEHPOSNPD O    E           K DISK
     FDEHEVNTPD O    E           K DISK
     FDEHCASHPD O    E           K DISK
 
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
 
      * E X T R A C T   F I L E S
     D/COPY DECPYSRC,DEXTFILS
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXTPERDD
 
 
     D GTRAN         E DS                  EXTNAME(DEGTRANPD) PREFIX(G_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for CUSTOMER details
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)
      ** External DS for BASE RATE HISTORY details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** Extract Control Data
 
     D INFDS         E DS                  EXTNAME(Y2I1DSP)
      ** File Information DS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#ACTN            1            * ACTION CODE
     C                   PARM                    I#EXTT            4            * EXTRACT TYPE
     C                   PARM                    I#PH              1            * PROJ/HIST
     C                   PARM                    I#EOB             1            * END OF BOOK
     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#HCOD            5 0          * HIST CUT-OFF DATE
     C                   PARM                    I#EXTD            5 0          * EXTRACT DATE
     C                   PARM                    I#EVCD            5 0          * EVENT CTL DATE
     C                   PARM                    I#PCOD            5 0          * PROJECTION DATE
     C                   PARM                    PeriodEDT                      * PERIOD END DATES
     C                   PARM                    GTRAN
     C                   PARM                    Dataarea                                     208221
      *
      ** INITIAL PROCESSING FOR GENERIC TRANSACTION
      *
     C                   EXSR      INIT
 
     C     I#ACTN        IFNE      'D'
      *
      ** MAIN PROCESSING - 'ASSET' POSITION
      *
     C                   MOVE      'A'           W#ASLI            1
 
     C     POSNKEY       SETLL     DEGPOSNP0
     C     POSNKEY       READE     DEGPOSNP0                              99    *
     C     *in99         IFEQ      '0'
     C                   EXSR      MAIN
     C                   ENDIF
      *
      ** MAIN PROCESSING - 'LIABILITY' POSITION
      *
     C                   MOVE      'L'           W#ASLI
 
     C     POSNKEY       SETLL     DEGPOSNP0
     C     POSNKEY       READE     DEGPOSNP0                              99    *
     C     *in99         IFEQ      '0'
     C                   EXSR      MAIN
     C                   ENDIF
 
     C                   ENDIF
      *
      * COMMITMENT PROCESSING FOR GENERIC TRANSACTION
      *
     C                   EXSR      COMIT
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * INITIAL PROCESSING FOR GENERIC TRANSACTION
      *****************************************************************
     C     INIT          BEGSR
      *
      * Import transaction details
      *
     C                   MOVEL     GTRAN         T#TRAN
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'G' + @1FMB                                       208221
     C                   IF        @1FMB = 'LDNI'                                             208221
     C     T#TRTP        IFEQ      'CD'                                                       208221
     C     T#TRTP        OREQ      'CL'                                                       208221
     C     T#TRTP        OREQ      'DL'                                                       208221
     C     T#TRTP        OREQ      'IL'                                                       208221
     C     T#TRTP        OREQ      'ID'                                                       208221
     C                   EVAL      W#TYPE = 'G' + 'LDCL'                                      208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
      *                                                                                       208221
     C     T#ACTN        IFNE      'D'
     C                   MOVEL     '*IMPTRAN'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      * RESET EXPORT INDICATORS
      *
     C                   MOVEL     *BLANK        POSN_Exp          1
     C                   MOVEL     *BLANK        EVNT_Exp          1
     C                   MOVEL     *BLANK        CASH_Exp          1
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
     C********************************************************************
     C     IMPORT        BEGSR
      *
      * If extract is Money Market or Negotiable Assets
     C                   IF        @1FMB = 'LDNI' or @1FMB = 'NASP'
 
      * If Position Funding Spread and Sign not set
 
     C                   IF        P#FSRP = 0 and P#FSGN = *BLANK
 
      * Call Base Rate History for default rate
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       @RETURN           7
     C                   PARM      '*KEY   '     @OPTION           7
     C                   PARM      P#CCY         @CURRCY           3
     C                   PARM      DERDFR        @DEFFNDRT         2 0
     C                   PARM      P#IACD        @HISTDATE         5 0
     C     SDBSHS        PARM      SDBSHS        DSFDY
     C                   IF        @RETURN = *BLANKS
     C                   EVAL      P#FSRP = G0CBSR
     C                   EVAL      P#CRAT = G0CBSR                                            208221
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
      *
      * Import events
      *
     C     POSNKEY       SETLL     DEGEVNTP0
     C     POSNKEY       READE     DEGEVNTP0                              99    *
     C     *in99         DOWEQ     '0'
      *                                                                                       208221
      * If extract is Money Market or Negotiable Assets                                       208221
     C                   IF        E#EVTP <> 'DD'                                             208221
     C                             or @1FMB <> 'LDNI' and @1FMB <> 'NASP'                     208221
      *
      * If extract is Money Market
     C                   IF        @1FMB = 'LDNI'
      *
      * When processing a Spread Change
     C                   IF        E#EVTP = 'SC'
      *
      * If Event Funding Spread and Sign not set, Cost of Funds Change
      *  Rate indicator not on
     C                   IF        E#FSRP = 0 and E#FSGN = *BLANK and
     C                             E#CRCH <> 'Y'
      *
      * Call Base Rate History for default rate
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       @RETURN           7
     C                   PARM      '*KEY   '     @OPTION           7
     C                   PARM      P#CCY         @CURRCY           3
     C                   PARM      DERDFR        @DEFFNDRT         2 0
     C                   PARM      E#PRDT        @HISTDATE         5 0
     C     SDBSHS        PARM      SDBSHS        DSFDY
     C                   IF        @RETURN = *BLANKS
     C                   EVAL      E#FSRP = G0CBSR
     C                   EVAL      E#CRCH = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF                                                                208221
     C     POSNKEY       READE     DEGEVNTP0                              99    *
     C                   ENDDO
      *
      * Import period end dates
      *
     C                   EXSR      IMP_PE
      *
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     *INZSR        BEGSR
 
     C     POSNKEY       KLIST
     C                   KFLD                    T#MOD
     C                   KFLD                    T#TREF
     C                   KFLD                    W#ASLI
 
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  DEEXTCTL
     C                   IN        DEEXTCTL
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *****************************************************************
      * M A I N   P R O C E S S I N G
      /COPY DECPYSRC,DEXTMAINO
      *********************************************************************
      * C O M M I T M E N T   P R O C E S S I N G
      /COPY DECPYSRC,DEXTCOMMO
      *********************************************************************
      * I M P O R T   P E R I O D   E N D   D A T E S
      /COPY DECPYSRC,DEXTPERDI
      ********************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      *****************************************************************
      /COPY DECPYSRC,DEXTWEDTA
      *********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2001
