     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected extract of GL accounts')            *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXTACCT - Projected Extract for Accounts                   *
      *                                                               *
      *  Function:  This module is called by DEPXCACCT. It outputs    *
      *             records to DEPTRANPD, DEPPOSNPD, DEPEVNTPD        *
      *             and DEPCASHPD files. These are used for the       *
      *             reporting of exposure within CCRM.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CDE005             Date 20Aug02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
      /EJECT
     FTIPOSTL9  IF   E           K DISK    INFSR(*PSSR)
     FDEPTRANPD O    E           K DISK    INFSR(*PSSR)
     FDEPPOSNPD O    E           K DISK    INFSR(*PSSR)
     FDEPEVNTPD O    E           K DISK    INFSR(*PSSR)
     FDEPCASHPD O    E           K DISK    INFSR(*PSSR)
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      * E X T R A C T   F I L E S
     D/COPY DECPYSRC,DEXTFILS
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXTPERDD
 
 
 
     D ACCT          E DS                  EXTNAME(ACCNTAB)
 
 
     D                 DS
     D***W#ACID*                 1     18                                                     CGL029
     D W#ACID                  1     24                                                       CGL029
     D**W#CNUM**               1      6S 0                                                    CSD027
     D  W#CNUM                 1      6A                                                      CSD027
     D  W#CCY                  7      9A
     D***W#ACOD*               10     13S 0                                                   CGL029
     D***W#ACSQ*               14     15S 0                                                   CGL029
     D***W#BRCA*               16     18A                                                     CGL029
     D  W#ACOD                10     19S 0                                                    CGL029
     D  W#ACSQ                20     21S 0                                                    CGL029
     D  W#BRCA                22     24A                                                      CGL029
 
     D K_cnum                              LIKE(CNUM)
     D K_ccy                               LIKE(CCY)
     D K_acod                              LIKE(ACOD)
     D K_acsq                              LIKE(ACSQ)
     D K_brca                              LIKE(BRCA)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      *
      * INPUT PARAMETERS
      *
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
     C                   PARM                    ACCT
     C                   PARM                    I#TDES           16
     C                   PARM                    I#TFCT            1
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
      *
      * INITIAL PROCESSING FOR ACCOUNT
      *
     C                   EXSR      INIT
      *
      ** MAIN PROCESSING
      *
     C     I#ACTN        IFNE      'D'
     C                   EXSR      MAIN
     C                   ENDIF
      *
      * COMMITMENT PROCESSING FOR ACCOUNT
      *
     C                   EXSR      COMIT
      *
      * RETURN
      *
     C                   RETURN
      *
      *****************************************************************
      * INITIAL PROCESSING FOR ACCOUNT
      *****************************************************************
     C     INIT          BEGSR
      *
      * Clear Transaction Details
      *
     C                   CLEAR                   T#TRAN
      *
      * Module
     C                   MOVEL     'GL'          T#MOD
      *
      * Transaction Reference
     C                   MOVEL     CNUM          W#CNUM
     C                   MOVEL     CCY           W#CCY
     C                   MOVEL     ACOD          W#ACOD
     C                   MOVEL     ACSQ          W#ACSQ
     C                   MOVEL     BRCA          W#BRCA
     C                   MOVEL     W#ACID        T#TREF
      *
      * Transaction Type
     C                   MOVEL     ACOD          T#TRTP
      *
      * Transaction Description
      *
     C                   MOVEL     I#TDES        T#TDES
      *
      * Booking Branch
     C                   MOVEL     BRCA          T#BRCA
      *
      * Counterparty
     C                   MOVEL     CNUM          T#CPTY
      *
      * Risk Customer
     C                   MOVEL     CNUM          T#RCST
 
      /COPY WNCPYSRC,DEPXTAC001
      *
      * Currency Dec Places (for use later)
     C                   MOVEL     CCY           @CYCD
     C                   EXSR      ACSCCY
      *
      * Action code
     C                   MOVEL     I#ACTN        T#ACTN
      *                                                                                       CDE005
      * Reservation ID                                                                        CDE005
      *                                                                                       CDE005
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   MOVEL     I#RSRV        T#RSRV           10                          CDE005
     C                   ENDIF                                                                CDE005
      *
      * Import transaction details
      *
     C     I#ACTN        IFNE      'D'
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
      *****************************************************************
      * IMPORT OPENING POSITION AND EVENTS
      *****************************************************************
     C     IMPORT        BEGSR
      *
      * Import opening balance
      *
     C                   EXSR      IMP_OPBL
      *
      * If Account is a Trade Innovation Exposure account, then
      * Import Transaction Events
      *
     C                   IF        I#TFCT = 'Y'
     C                   EXSR      IMP_EVNT
     C                   ENDIF
      *
      * Import Period end dates
      *
     C                   EXSR      IMP_PE
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * IMPORT OPENING BALANCE
      *****************************************************************
     C     IMP_OPBL      BEGSR
      *
      * Clear Position
      *
     C                   CLEAR                   P#POSN
      *
      * Module, Transaction Reference
      *
     C                   MOVEL     T#TKEY        P#TKEY
      *
      * Asset/Liability
     C     CLBL          IFGE      0
     C                   MOVEL     'A'           P#ASLI
     C                   ELSE
     C                   MOVEL     'L'           P#ASLI
     C                   ENDIF
 
      * Copy Book to re-define Position Asset/Liability Indicator
      /COPY WNCPYSRC,DEPXTAC002
 
      *
      * Interest Accrl Ctl Date
     C*******************Z-ADD*****I#EXTD********P#IACD*********************    CDE002
     C                   Z-ADD     BJRDNB        P#IACD                         CDE002
      *
      * Nominal/Principal
     C                   Z-ADD     CLBL          P#NOML                 99      *
     C   99              Z-SUB     P#NOML        P#NOML                         *
 
      * Copy Book to re-define Position Nominal/Principal
      /COPY WNCPYSRC,DEPXTAC003
 
      *
      * Currency
     C                   MOVEL     CCY           P#CCY
     C                   MOVEL     CCY           @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Ccy Dec Places
     C                   MOVEL     A6NBDP        P#NCDP
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P#NMDP
      *
      * Nominal Ccy Spot Days
     C                   Z-ADD     A6SPDY        P#SPDY
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      *****************************************************************
      * Import Transaction Events
      *****************************************************************
     C     IMP_EVNT      BEGSR
 
     C                   MOVE      CNUM          K_cnum
     C                   MOVE      CCY           K_ccy
     C                   MOVE      ACOD          K_acod
     C                   MOVE      ACSQ          K_acsq
     C                   MOVE      BRCA          K_brca
 
     C     TIPKey        SETLL     TIPOSTL9
     C     TIPKey        READE     TIPOSTL9                               99
      *
     C     *IN99         DOWEQ     '0'
      *
      * Clear Position
      *
     C                   CLEAR                   E#EVNT
      *
      * Asset/Liability
     C     CLBL          IFGE      0
     C                   MOVEL     'A'           E#ASLI
     C                   ELSE
     C                   MOVEL     'L'           E#ASLI
     C                   ENDIF
 
      * Copy Book to re-define Event Asset/Liability
      /COPY WNCPYSRC,DEPXTAC004
 
      *
     C                   IF        TIAMNT <> 0
     C                   MOVE      T#MOD         E#MOD
     C                   MOVE      T#TREF        E#TREF
     C                   Z-ADD     MTIVD         E#PRDT
      *
     C                   IF        TIDCIN = 'C'
 
     C                   IF        E#ASLI = 'A'
     C                   MOVE      'PD'          E#EVTP
     C                   ELSE
     C                   MOVE      'PI'          E#EVTP
     C                   ENDIF
     C                   SUB       TIAMNT        CLBL
 
     C                   ELSE
     C                   IF        E#ASLI = 'A'
     C                   MOVE      'PI'          E#EVTP
     C                   ELSE
     C                   MOVE      'PD'          E#EVTP
     C                   ENDIF
     C                   ADD       TIAMNT        CLBL
     C                   ENDIF
 
      * Copy Book to re-define balance
      /COPY WNCPYSRC,DEPXTAC005
 
      *
     C                   Z-ADD     TIAMNT        E#PRAM
      *
      * Import transaction Events
      *
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDIF
      *
     C     TIPKey        READE     TIPOSTL9                               99
      *
     C                   ENDDO
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
      *
      **  Key list for TIPOSTL9
      *
     C     TIPkey        KLIST
     C                   KFLD                    K_cnum
     C                   KFLD                    K_ccy
     C                   KFLD                    K_acod
     C                   KFLD                    K_acsq
     C                   KFLD                    K_brca
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
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'PACCT'                                           208221
      *
      ** Determine if Data Export - Reservation ID is active                                  CDE005
     C                   CALL      'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD             7                          CDE005
     C                   PARM      '*VERIFY'     @OPTN             7                          CDE005
     C                   PARM      'CDE005'      @SARD             6                          CDE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE005
      *                                                                                       CDE005
     C     @RTCD         IFEQ      *BLANK                                                     CDE005
     C                   MOVEL     'Y'           CDE005            1                          CDE005
     C                   ELSE                                                                 CDE005
     C                   MOVEL     'N'           CDE005                                       CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CDE005
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * M A I N   P R O C E S S I N G
      /COPY DECPYSRC,DEXTMAINO
      *****************************************************************
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
