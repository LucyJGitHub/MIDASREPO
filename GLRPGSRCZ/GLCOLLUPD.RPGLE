     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Details Update')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLUPD - Collateral Details Update                        *
      *                                                               *
      *  Function: This module will perform the database updates      *
      *            once all the collateral detail screens have been   *
      *            validated correctly.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11893           Date 15Aug06               *
      *                 CDL049             Date 07Jul06               *
      *                 218359             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS009             Date 16May05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6979            Date 04May05               *
      *                 CLE040             Date 05Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CAP084             Date 11Aug03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP074             Date 08Aug02               *
      *                 CAP073             Date 08Aug02               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             Date 25JUN02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG11893 - Error message displayed when authorizing record   *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  218359 - Amend SR/SRMMBLOCK and SR/SRSEBLOCK  so that if a   *
      *           new deal or security reference is being pointed to  *
      *           as a collateral, we add the lending amount to the   *
      *           collateral field in the new deal/security and       *
      *           subtract the same amount from the old deal/security *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  CGL014 - Collaterals Processing                              *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CAP084 - Access user Id from ZMUSER.                         *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP068 - Recompiled for changes to FCLTYFM and FCLTYFN.      *
      *  CGL011 - Collateral Processing for Midas (Phase 1)           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Account file - by RE A/c No.
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMF)
      *
      ** Security Details File
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Live Portfolio Definition Details
     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Specific Collateral Details by Module Secured & Collateral Customer
     FGLCOLLL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD2)
      *
      ** Specific Collateral Details by Module Secured, Secure Facility
      ** Customer, Secured Facility Type and Secured Facility Seq. Number
     FGLCOLLL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD3)
      *
      ** Specific Collateral Details by Module Secured & Secured Loan/Limit
     FGLCOLLL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD4)
      *
      ** Specific Collateral Details by Module Secured & Secured Retail A/c
     FGLCOLLL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD5)
      *
      ** Specific Collateral Details by Module Secured, Secured A/c Customer
      ** Number, Secured A/c Ccy, Secured A/c Code, Secured A/c Sequence No.
      ** and Secired A/c Branch.
     FGLCOLLL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD6)
      *
      ** Collateral Allocations by Module Secured & Allocation Customer
     FGLCOLALa  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLADa)
      *
      ** Collateral Allocations by Module Secured, Secure Facility
      ** Customer, Secured Facility Type and Secured Facility Seq. Number
     FGLCOLALb  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLADb)
      *
      ** Collateral Allocations by Module Secured & Secured Loan/Limit
     FGLCOLALc  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLADc)
      *
      ** Collateral Allocations by Module Secured & Secured Retail A/c No.
     FGLCOLALd  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLADd)
      *
      ** Collateral Allocations by Module Secured, Secured A/c Customer
      ** Number, Secured A/c Ccy, Secured A/c Code, Secured A/c Sequence No.
      ** and Secured A/c Branch.
     FGLCOLALe  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLAD0:GLCOLADe)
      *
      ** Collateral Details by Collateral Reference
     FGLCOLLL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Customer Limits File by Level, Entity and Customer
     FSDCLLML2  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Future and Options Client Details File
     FFOCLT     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** SD Future and Options Clients Details File
     FSDFOCSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Facility Details File
     FFCLTY     UF A E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(FCLTYHHF:FCLTYFNF:FCLTYZZF)
      *
      ** Loan Details File
     FCLOAN     UF A E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
      *
      ** Account Master File
     FACCNT     UF A E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(ACCNTAAF:ACCNTACF)
      *
      ** All Loans and Deposits Deals File
     FDEALSC    UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Money Market Deals Update File
     FMMDEAULL  UF A E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(MMDENSP0:MMDENBP0)
      *
      ** Blocked Positions File
     FSEBLKPL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
      ** Array of powers for Currency Conversion
     D POWER8          S              8  0 DIM(8) CTDATA PERRCD(1)
      *
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             88     88
     D  RcdNotFnd             89     89
     D  FileError             90     90
      *
      **  DATA STRUCTURE FOR SR. ZDATE10 - DATE INPUT TO SUBROUTINE
     D                 DS
     D  ZZDTIN                 1      8  0
     D  ZWYYYY                 1      4  0
     D  ZWMTH                  5      6  0
     D  ZWDAY                  7      8  0
      *
      ** Externally described DS for Valid Collateral
     D NwCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
     D                                     PREFIX(V_)
      *
      ** Collateral Definition Details retrieved from file
      ** - in file format
     D CrCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
     D                                     PREFIX(C_)
      *
      ** Externally described DS for 'BEFORE UPDATE' Collateral
     D B_GLCOLL      E DS                  EXTNAME(GLCOLLPD)
     D                                     PREFIX(B_)
      *
      ** Externally described DS for Previous Collateral
     D P_GLCOLL      E DS                  EXTNAME(GLCOLLPD)
     D                                     PREFIX(P_)
      *
      ** Externally described DS for Retrieve Collateral
     D GLCOLL        E DS                  EXTNAME(GLCOLLPD)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Portfolio Management Customer Details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for ZMUSER details                                                                CAP084
     D ZMUSER          DS            17                                                       CAP084
     D  PUSRID                 1     10                                                       CAP084
     D  PDBRN                 11     13                                                       CAP084
     D  PDPPT                 14     16                                                       CAP084
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
      *
      ** Index for arrays of error message IDs
     D Ix              S              3P 0
      *
      ** The timestamp field returned by this module
     D TimeStamp       S               Z
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      *
     D V_NBDP          S                   LIKE(A6NBDP)
     D V_SPRT          S                   LIKE(A6SPRT)
     D V_MDIN          S                   LIKE(A6MDIN)
     D @FNBDP          S                   LIKE(A6NBDP)
     D @FSPRT          S                   LIKE(A6SPRT)
     D @FMDIN          S                   LIKE(A6MDIN)
     D @CEDAT          S                   LIKE(CDEDAT)
     D @PCEDAT         S                   LIKE(CDEDAT)
     D KBRCD           S                   LIKE(VDBRCD)
     D KCNUM           S                   LIKE(VDCNUM)
     D KPTFR           S                   LIKE(VDPTFR)
     D KBLTY           S                   LIKE(VDBLTY)
     D KSESN           S                   LIKE(VDSESN)
     D KBEDT           S                   LIKE(VDBEDT)
     D KSEQN           S                   LIKE(VDSEQN)
      *
      ** Parameters for ZDATE2
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
      *
      ** Parameters for ZDATE10
     D DateIn          S                   LIKE(ZZDTIN)
     D DaynoOut        S              5P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   EXSR      SRINIT
      *
     C                   CLEAR                   P_GLCOLL
      *
     C     V_CDTYLC      IFNE      'I'
     C                   EXSR      SRRTVCOLL
     C                   ENDIF
      *
     C                   EXSR      SRCHKOTH
      *
     C     RETCODEIN     IFNE      *BLANKS
     C                   RETURN
     C                   ENDIF
      *
     C                   EXSR      SRCOLLUPD
      *
     C                   MOVE      False         FileError
      *
     C     V_CDTYLC      IFEQ      'I'
     C                   MOVEL     B_GLCOLL      GLCOLL
     C                   WRITE     GLCOLLD0                             90
     C                   ENDIF
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'D'
     C     V_CDTYLC      OREQ      'X'
     C                   MOVEL     B_GLCOLL      GLCOLL
     C                   UPDATE    GLCOLLD0                             90
     C                   ENDIF
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'GLCOLLD0  '  DBFILE
     C                   Z-ADD     003           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     V_CDTYLC      IFNE      'X'
     C     V_CDMODS      IFEQ      'FX'
     C     V_CDMODS      OREQ      'MM'
     C                   EXSR      SRCLLMUPD
     C                   ENDIF
     C     V_CDMODS      IFEQ      'FO'
     C                   EXSR      SRFOCLUPD
     C                   ENDIF
     C     V_CDMODS      IFEQ      'LE'
     C                   EXSR      SRLENDUPD
     C                   ENDIF
     C     V_CDMODS      IFEQ      'RE'
     C                   EXSR      SRACNTUPD
     C                   ENDIF
     C     V_CDCOPT      IFEQ      'D'
     C                   EXSR      SRMMBLOCK
     C                   ENDIF
     C     V_CDCOPT      IFEQ      'P'
     C                   EXSR      SRSEBLOCK
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation process                              *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
                                                                                             BUG6979
      ** Lock in data area, ZMUSER, to access the Job User.                                  BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
     C                   EVAL      PSUser = PUSRID                                           BUG6979
                                                                                             BUG6979
      ** Store value of the Job User.                                                        BUG6979
     C                   MOVE      PSUser        WWUser           10                         BUG6979
      *
      ** Clear working data structure
     C                   CLEAR                   B_GLCOLL
      *
      ** Set all working data structure file numeric fields to zero.
     C                   Z-ADD     0             B_CDLCD
     C                   Z-ADD     0             B_CDTNLU
     C**********         Z-ADD     0             B_CDCNUM                                     CSD027
     C                   EVAL      B_CDCNUM = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDSDAT
     C                   Z-ADD     0             B_CDVDAT
     C                   Z-ADD     0             B_CDEDAT
     C                   Z-ADD     0             B_CDRVDT
     C                   Z-ADD     0             B_CDRDNO
     C**********         Z-ADD     0             B_CDUNIT                                     CGL014
     C                   Z-ADD     0             B_CDPCNT
     C**********         Z-ADD     0             B_CDUAMT                                     CGL014
     C**********         Z-ADD     0             B_CDMAMT                                     CGL014
     C                   Z-ADD     0             B_CDVAMT
     C**********         Z-ADD     0             B_CDVCNM                                     CSD027
     C                   EVAL      B_CDVCNM = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDVLDT
     C                   Z-ADD     0             B_CDNVDT
     C                   Z-ADD     0             B_CDVDNO
     C                   Z-ADD     0             B_CDMARG
     C**********         Z-ADD     0             B_CDHCNM                                     CSD027
     C                   EVAL      B_CDHCNM = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDLAMT
     C**********         Z-ADD     0             B_CDPR01                                     CSD027
     C**********         Z-ADD     0             B_CDPR02                                     CSD027
     C**********         Z-ADD     0             B_CDPR03                                     CSD027
     C**********         Z-ADD     0             B_CDPR04                                     CSD027
     C**********         Z-ADD     0             B_CDPR05                                     CSD027
     C**********         Z-ADD     0             B_CDPR06                                     CSD027
     C**********         Z-ADD     0             B_CDPR07                                     CSD027
     C**********         Z-ADD     0             B_CDPR08                                     CSD027
     C**********         Z-ADD     0             B_CDPR09                                     CSD027
     C**********         Z-ADD     0             B_CDPR10                                     CSD027
     C**********         Z-ADD     0             B_CDPR11                                     CSD027
     C**********         Z-ADD     0             B_CDPR12                                     CSD027
     C                   EVAL      B_CDPR01 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR02 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR03 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR04 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR05 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR06 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR07 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR08 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR09 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR10 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR11 = *BLANKS                                         CSD027
     C                   EVAL      B_CDPR12 = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDACCR
     C                   Z-ADD     0             B_CDIAMT
     C**********         Z-ADD     0             B_CDFCUS                                     CSD027
     C                   EVAL      B_CDFCUS = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDFTYP
     C                   Z-ADD     0             B_CDFSEQ
     C**********         Z-ADD     0             B_CDLNLM                                     CLE148
     C                   EVAL      B_CDLNLM  = *BLANKS                                        CLE148
     C**********         Z-ADD     0             B_CDSCNM                                     CSD027
     C                   EVAL      B_CDSCNM = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDSACD
     C                   Z-ADD     0             B_CDSSEQ
     C                   Z-ADD     0             B_CDSACN
     C**********         Z-ADD     0             B_CDCCNM                                     CSD027
     C                   EVAL      B_CDCCNM = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDCACD
     C                   Z-ADD     0             B_CDCSEQ
     C                   Z-ADD     0             B_CDCACN
     C                   Z-ADD     0             B_CDDEAL
     C**********         Z-ADD     0             B_CDCSCN                                     CSD027
     C**********         Z-ADD     0             B_CDINSR                                     CSD027
     C                   EVAL      B_CDCSCN = *BLANKS                                         CSD027
     C                   EVAL      B_CDINSR = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDIVAL
     C                   Z-ADD     0             B_CDINDT
     C                   Z-ADD     0             B_CDINDN
     C                   Z-ADD     0             B_CDVPCH
     C**********         Z-ADD     0             B_CDSCHC                                     CSD027
     C                   EVAL      B_CDSCHC = *BLANKS                                         CSD027
     C                   Z-ADD     0             B_CDPCTA
     C                   Z-ADD     0             B_CDTOTA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVCOLL - Collateral Record Retrieval process              *
      *                                                               *
      *****************************************************************
     C     SRRTVCOLL     BEGSR
      *
     C     V_CDCREF      CHAIN     GLCOLLL1                           89
     C     RcdNotFnd     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     V_CDCREF      DBKEY
     C                   MOVEL     'GLCOLLL1    'DBFILE
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ELSE
     C                   MOVEL     GLCOLL        P_GLCOLL
     C                   EXSR      SRINIT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKOTH - Process to Check Whether Record has been Updated  *
      *             by Another Workstation                            *
      *                                                               *
      *****************************************************************
     C     SRCHKOTH      BEGSR
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM      *BLANKS       @Return           6
     C                   PARM      *BLANKS       @Mode             1
      *
     C     @Mode         IFEQ      '0'
     C                   MOVE      '*FRONT'      ModeOp
     C                   ELSE
     C                   MOVE      *BLANKS       ModeOp
     C                   ENDIF
      *
      ** Call the collateral details retieve module
      *
     C                   CALLB     'GLCOLLRTV'
      *
      ** INPUT PARAMETERS:
      *
      ** Initial screen fields
     C                   PARM      V_CDTYLC      DDACTN            1
     C                   PARM      V_CDCREF      DDCREF           10
     C                   PARM      *BLANKS       DDREVF           10
     C                   PARM      *BLANK        DDREQR            1
     C                   PARM      *BLANK        DDSENT            1
     C                   PARM      *BLANKS       DDSCMP            3
     C                   PARM      *BLANKS       DDSBRC            3
     C                   PARM      *BLANKS       DDSCOL            5
     C                   PARM      *BLANKS       DDSCNU           10
     C                   PARM      *BLANKS       DDSCCY            3
     C                   PARM      *BLANKS       DDSVAL           16
     C                   PARM      *BLANK        DDSGNS            1
      *
     C                   PARM                    CGL012
      *
      ** Mode of operation
     C                   PARM                    ModeOp            6
      *
      ** Response Mode
     C                   PARM      *BLANK        RespMode          1
      *
      ** Front Office Id
     C                   PARM      V_CDFRNT      FOTRID           20
      *
      ** OUTPUT PARAMETERS:
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      0             Ix
      *
      ** Collateral details (file format)
     C                   PARM      *BLANKS       CrCoFilFmt
      *
      ** OK Flags
     C                   PARM      *BLANK        DDACTNOK          1
     C                   PARM      *BLANK        DDCREFOK          1
     C                   PARM      *BLANK        DDREVFOK          1
     C                   PARM      *BLANK        DDREQROK          1
     C                   PARM      *BLANK        DDSENTOK          1
     C                   PARM      *BLANK        DDSCMPOK          1
     C                   PARM      *BLANK        DDSBRCOK          1
     C                   PARM      *BLANK        DDSCOLOK          1
     C                   PARM      *BLANK        DDSCNUOK          1
     C                   PARM      *BLANK        DDSCCYOK          1
     C                   PARM      *BLANK        DDSVALOK          1
     C                   PARM      *BLANK        DDSGNSOK          1
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
      *
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Trade was fetched by this
      ** program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
      *
      ** Interactive mode:
      *
     C     @Mode         IFEQ      '1'
      *
     C     C_CDTMST      IFNE      V_CDTMST
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   ENDIF
      *
      ** Batch mode:
     C                   ELSE
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCREFOK      OREQ      'N'
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   Z-ADD     1             C                 2 0
      *
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       @DBError
     C                   MOVEL     MsgIDArr(C)   @DBError
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM      *BLANKS       MsgSndRtn        10
     C                   PARM                    @DBError         28
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
     C                   ADD       1             C
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOLLUPD - Collateral Details File Update process           *
      *                                                               *
      *****************************************************************
     C     SRCOLLUPD     BEGSR
      *
      ** Determine next available transaction number.
     C                   EXSR      SRGENTRNNO
      *
     C                   MOVEL     NwCoFilFmt    B_GLCOLL
     C                   Z-ADD     BJRDNB        B_CDLCD
     C                   Z-ADD     NATN          B_CDTNLU
      *
     C                   SELECT
     C     V_CDTYLC      WHENEQ    'I'
     C                   EXSR      SRCOLLINS
     C     V_CDTYLC      WHENEQ    'A'
     C                   EXSR      SRCOLLAMD
     C     V_CDTYLC      WHENEQ    'D'
     C                   EXSR      SRCOLLDEL
     C     V_CDTYLC      WHENEQ    'X'
     C                   EXSR      SRCOLLAUT
     C                   ENDSL
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   MOVE      TimeStamp     B_CDTMST
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGENTRNNO - Generate Transaction Number process             *
      *                                                               *
      *****************************************************************
     C     SRGENTRNNO    BEGSR
      *
      ** Get the next available transaction number
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn            10
     C                   PARM      0             NATN              5 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOLLINS - Collateral Insertion process                     *
      *                                                               *
      *****************************************************************
     C     SRCOLLINS     BEGSR
      *
     C                   MOVE      'D'           B_CDRECI
     C                   MOVE      'I'           B_CDTYLC
     C                   MOVE      WWUser        B_CDIUSR
     C                   MOVE      *Blanks       B_CDAUSR
      *                                                                                     BUG11893
      ** Initialize Chargee Customer                                                        BUG11893
      *                                                                                     BUG11893
     C                   Eval      B_CDSCHC = *All'0'                                       BUG11893
      *
     C     CGL012        IFEQ      'Y'
     C                   MOVE      'C'           B_CDAUTH
     C                   MOVE      *Blanks       B_CDAUSR
     C                   ELSE
     C                   MOVE      'A'           B_CDAUTH
     C                   MOVE      WWUser        B_CDAUSR
     C                   ENDIF
      *
     C     B_CDGNSP      IFEQ      'S'
     C                   Z-ADD     B_CDLAMT      B_CDTOTA
     C                   Z-ADD     100           B_CDPCTA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOLLAMD - Collateral Amendment process                     *
      *                                                               *
      *****************************************************************
     C     SRCOLLAMD     BEGSR
      *
     C                   MOVE      'A'           B_CDTYLC
     C                   MOVE      WWUser        B_CDAUSR
      *
     C     CGL012        IFEQ      'Y'
     C     P_CDAUTH      IFEQ      'A'
     C                   MOVE      'R'           B_CDAUTH
     C                   ENDIF
     C                   MOVE      *Blanks       B_CDXUSR
     C                   ELSE
     C                   MOVE      'A'           B_CDAUTH
     C                   MOVE      WWUser        B_CDXUSR
     C                   ENDIF
      *
     C     B_CDGNSP      IFEQ      'S'
     C                   Z-ADD     B_CDLAMT      B_CDTOTA
     C                   Z-ADD     100           B_CDPCTA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOLLDEL - Collateral Deletion process                      *
      *                                                               *
      *****************************************************************
     C     SRCOLLDEL     BEGSR
      *
     C                   MOVE      'R'           B_CDRECI
     C                   MOVE      'D'           B_CDTYLC
     C                   MOVE      'A'           B_CDAUTH
     C                   MOVE      WWUser        B_CDXUSR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOLLAUT - Collateral Authorisation process                 *
      *                                                               *
      *****************************************************************
     C     SRCOLLAUT     BEGSR
      *
     C                   MOVE      P_CDTYLC      B_CDTYLC
     C                   MOVE      'A'           B_CDAUTH
     C                   MOVE      WWUser        B_CDXUSR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERR - Error processing                                     *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVE      '*ERROR '     RetCodeIn
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      ** Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLLMUPD - Customer Limits Update process                   *
      *                                                               *
      *****************************************************************
     C     SRCLLMUPD     BEGSR
      *
     C     V_CDENTY      IFEQ      'K'
     C                   MOVE      'S'           @Level            1
     C                   MOVE      'SYS'         @Entity           3
     C                   ELSE
     C                   MOVE      V_CDENTY      @Level
     C     @Level        IFEQ      'C'
     C                   MOVE      V_CDCMPY      @Entity
     C                   ELSE
     C                   MOVE      V_CDBRCA      @Entity
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     @Level        KLEVL
     C                   MOVEL     @Entity       KBCCD
     C                   MOVEL     V_CDCNUM      KCUST
     C     KCLLM         CHAIN     @CLLMIT                            89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C     V_CDMODS      IFEQ      'FX'
      *
     C     V_CDTYLC      IFEQ      'I'
     C     DZFLAM        ANDGT     0
     C     V_CDTYLC      OREQ      'A'
     C     DZFLAM        ANDGT     0
     C                   MOVE      'Y'           DZFLSC
      *
     C                   ELSE
      *
     C     DZFLAM        IFLE      0
     C                   MOVE      *Blank        DZFLSC
     C                   ELSE
      *
     C                   EXSR      SRCHKLIM
     C     @RecFound     IFEQ      'N'
     C                   MOVE      *Blank        DZFLSC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     V_CDMODS      IFEQ      'MM'
      *
     C     V_CDTYLC      IFEQ      'I'
     C     DZLLAM        ANDGT     0
     C     V_CDTYLC      OREQ      'A'
     C     DZLLAM        ANDGT     0
     C                   MOVE      'Y'           DZSECD
      *
     C                   ELSE
      *
     C     DZLLAM        IFLE      0
     C                   MOVE      *Blank        DZSECD
     C                   ELSE
      *
     C                   EXSR      SRCHKLIM
     C     @RecFound     IFEQ      'N'
     C                   MOVE      *Blank        DZSECD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    @CLLMIT                              90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'SDCLLML2  '  DBFILE
     C                   Z-ADD     005           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKLIM - Check if Other Collateral for Limit process       *
      *                                                               *
      *****************************************************************
     C     SRCHKLIM      BEGSR
      *
     C     KCOLL2        SETLL     GLCOLLL2                               88
     C                   MOVE      'N'           @RecFound         1
      *
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL2        READE     GLCOLLL2                               88
     C     EndOfFile     IFEQ      False
     C     CDRECI        ANDNE     'R'
     C     CDCREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
      *
     C     @RecFound     IFEQ      'N'
     C     KCOLL2        SETLL     GLCOLALa                               88
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL2        READE     GLCOLALa                               88
     C     EndOfFile     IFEQ      False
     C     CACREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFOCLUPD - Futures and Options Client Details Update process*
      *                                                               *
      *****************************************************************
     C     SRFOCLUPD     BEGSR
      *
     C     V_CDCNUM      CHAIN     FOCLTDF                            89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C                   MOVE      V_CDCNUM      WWCNUM            6
     C     WWCNUM        CHAIN     @BHRED0                            89
      *
     C     RcdNotFnd     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     WWCNUM        DBKEY
     C                   MOVEL     'SDFOCSPD  '  DBFILE
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     CLDS          IFEQ      *BLanks
     C                   MOVE      V_CDDESC      CLDS
     C                   MOVE      V_CDDESC      BHCODE
     C                   ENDIF
      *
     C     CLCC          IFEQ      *BLanks
     C                   MOVE      V_CDCCY       CLCC
     C                   MOVE      V_CDCCY       BHCYCD
     C                   ENDIF
      *
     C     CLCC          IFNE      V_CDCCY
      *
     C     V_CDCCY       IFNE      BSCCY
     C                   EXSR      SRTOBASE
     C                   ELSE
     C                   Z-ADD     P_CDLAMT      P_BSLAMT
     C                   Z-ADD     V_CDLAMT      BSLAMT
     C                   ENDIF
      *
     C     CLCC          IFNE      BSCCY
     C                   MOVE      CLCC          @FCCY             3
     C                   EXSR      SRFMBASE
     C                   Z-ADD     P_@FLAMT      P_FCurCLAM       15 0
     C                   Z-ADD     @FLAMT        FCurCLAM         15 0
     C                   ELSE
     C                   Z-ADD     P_BSLAMT      P_FCurCLAM
     C                   Z-ADD     BSLAMT        FCurCLAM
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     P_CDLAMT      P_FCurCLAM
     C                   Z-ADD     V_CDLAMT      FCurCLAM
     C                   ENDIF
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'D'
     C                   SUB       P_FCurCLAM    CLAM
     C                   SUB       P_FCurCLAM    BHCOAM
     C                   ENDIF
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'I'
     C                   ADD       FCurCLAM      CLAM
     C                   ADD       FCurCLAM      BHCOAM
     C                   ENDIF
      *
     C     CLAM          IFLT      0
     C                   Z-ADD     0             CLAM
     C                   Z-ADD     0             BHCOAM
     C                   ENDIF
      *
     C                   UPDATE    FOCLTDF                              90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'FOCLTD    '  DBFILE
     C                   Z-ADD     007           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   UPDATE    @BHRED0                              90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'SDFOCSPD  '  DBFILE
     C                   Z-ADD     008           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTOBASE - Convert Collateral Lending Values to Base Ccy     *
      *                                                               *
      *****************************************************************
     C     SRTOBASE      BEGSR
      *
      ** Access details for the Collateral Currency parameter
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      V_CDCCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     V_CDCCY       DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     009           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        V_NBDP
     C                   Z-ADD     A6SPRT        V_SPRT
     C                   MOVE      A6MDIN        V_MDIN
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'D'
     C                   CALLB     'ZCONVZ1'
     C                   PARM      P_CDLAMT      InputAmnt        15 0
     C                   PARM      V_SPRT        ExchRate         13 8
     C                   PARM      V_MDIN        MultDivInd        1
     C                   PARM      V_CDCCY       FrCurrency        3
     C                   PARM      BSCCY         ToCurrency        3
     C                   PARM      V_NBDP        FrDecPlace        1 0
     C                   PARM      BSNBDP        ToDecPlace        1 0
     C                   PARM      0             OutputAmnt       15 0
      *
     C                   Z-ADD     OutputAmnt    P_BSLAMT         15 0
     C                   ELSE
     C                   Z-ADD     0             P_BSLAMT
     C                   ENDIF
      *
     C                   CALLB     'ZCONVZ1'
     C                   PARM      V_CDLAMT      InputAmnt
     C                   PARM      V_SPRT        ExchRate
     C                   PARM      V_MDIN        MultDivInd
     C                   PARM      V_CDCCY       FrCurrency
     C                   PARM      BSCCY         ToCurrency
     C                   PARM      V_NBDP        FrDecPlace
     C                   PARM      BSNBDP        ToDecPlace
     C                   PARM      0             OutputAmnt
      *
     C                   Z-ADD     OutputAmnt    BSLAMT           15 0
     C                   MOVE      'Y'           @BCONV            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMBASE - Convert Base Currency Lending Values to File Ccy  *
      *                                                               *
      *****************************************************************
     C     SRFMBASE      BEGSR
      *
      ** Access details for the @FILE Collatera Currency parameter
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      @FCCY         PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     @FCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     010           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        @FNBDP
     C                   Z-ADD     A6SPRT        @FSPRT
     C     A6MDIN        IFEQ      'M'
     C                   MOVE      'D'           @FMDIN
     C                   ELSE
     C                   MOVE      'M'           @FMDIN
     C                   ENDIF
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'D'
     C                   CALLB     'ZCONVZ1'
     C                   PARM      P_CDLAMT      InputAmnt
     C                   PARM      @FSPRT        ExchRate
     C                   PARM      @FMDIN        MultDivInd
     C                   PARM      BSCCY         FrCurrency
     C                   PARM      @FCCY         ToCurrency
     C                   PARM      BSNBDP        FrDecPlace
     C                   PARM      @FNBDP        ToDecPlace
     C                   PARM      0             OutputAmnt
      *
     C                   Z-ADD     OutputAmnt    P_@FLAMT         15 0
     C                   ELSE
     C                   Z-ADD     0             P_@FLAMT
     C                   ENDIF
      *
     C                   CALLB     'ZCONVZ1'
     C                   PARM      BSLAMT        InputAmnt
     C                   PARM      @FSPRT        ExchRate
     C                   PARM      @FMDIN        MultDivInd
     C                   PARM      BSCCY         FrCurrency
     C                   PARM      @FCCY         ToCurrency
     C                   PARM      BSNBDP        FrDecPlace
     C                   PARM      @FNBDP        ToDecPlace
     C                   PARM      0             OutputAmnt
      *
     C                   Z-ADD     OutputAmnt    @FLAMT           15 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLENDUPD - Customer Lending Details Update process          *
      *                                                               *
      *****************************************************************
     C     SRLENDUPD     BEGSR
      *
     C                   MOVE      'A'           KRCDT
     C     KFCLT         CHAIN     FCLTY                              89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C     V_CDTYLC      IFEQ      'I'
     C     V_CDTYLC      OREQ      'A'
     C                   MOVE      'Y'           SECI
     C                   ELSE
     C                   EXSR      SRCHKFAC
     C     @RecFound     IFEQ      'N'
     C                   MOVE      'N'           SECI
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    FCLTYFMF                             90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'FCLTY     '  DBFILE
     C                   Z-ADD     011           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     KLOAN         CHAIN     CLOAN                              89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C     V_CDTYLC      IFEQ      'I'
     C     V_CDTYLC      OREQ      'A'
     C                   BITON     '0'           RELI
     C                   ELSE
     C                   EXSR      SRCHKLON
     C     @RecFound     IFEQ      'N'
     C                   BITOFF    '0'           RELI
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    CLOANCLF                             90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'CLOAN     '  DBFILE
     C                   Z-ADD     012           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKFAC - Check if Other Collateral for Facility process    *
      *                                                               *
      *****************************************************************
     C     SRCHKFAC      BEGSR
      *
     C     KCOLL3        SETLL     GLCOLLL3                               88
     C                   MOVE      'N'           @RecFound
      *
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL3        READE     GLCOLLL3                               88
     C     EndOfFile     IFEQ      False
     C     CDRECI        ANDNE     'R'
     C     CDCREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
      *
     C     @RecFound     IFEQ      'N'
     C     KCOLL2        SETLL     GLCOLALb                               88
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL2        READE     GLCOLALb                               88
     C     EndOfFile     IFEQ      False
     C     CACREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKLON - Check if Other Collateral for Loan process        *
      *                                                               *
      *****************************************************************
     C     SRCHKLON      BEGSR
      *
     C     KCOLL4        SETLL     GLCOLLL4                               88
     C                   MOVE      'N'           @RecFound
      *
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL4        READE     GLCOLLL4                               88
     C     EndOfFile     IFEQ      False
     C     CDRECI        ANDNE     'R'
     C     CDCREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
      *
     C     @RecFound     IFEQ      'N'
     C     KCOLL4        SETLL     GLCOLALc                               88
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL4        READE     GLCOLALc                               88
     C     EndOfFile     IFEQ      False
     C     CACREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRACNTUPD - Retail Account Update process                    *
      *                                                               *
      *****************************************************************
     C     SRACNTUPD     BEGSR
      *
     C     V_CDSACN      IFNE      0
     C     V_CDSACN      CHAIN     ACNUM                              89
     C**********         Z-ADD     CNUM          V_CDSCNM                                     CSD027
     C                   EVAL      V_CDSCNM = CNUM                                            CSD027
     C                   MOVE      CCY           V_CDSCCY
     C                   Z-ADD     ACOD          V_CDSACD
     C                   Z-ADD     ACSQ          V_CDSSEQ
     C                   MOVE      BRCA          V_CDSBRC
     C                   ENDIF
      *
     C     KACCNT        CHAIN     ACCNT                              89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'I'
     C                   MOVE      'Y'           ODSC
     C                   ELSE
      *
     C                   EXSR      SRCHKACC
      *
     C     @RecFound     IFEQ      'N'
     C                   MOVE      'N'           ODSC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   UPDATE    ACCNTABF                             90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'ACCNT     '  DBFILE
     C                   Z-ADD     013           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKACC - Check if Other Collateral for Retail A/c process  *
      *                                                               *
      *****************************************************************
     C     SRCHKACC      BEGSR
      *
     C                   MOVE      'N'           @RecFound
      *
     C     V_CDSACN      IFNE      0
      *
     C     KCOLL5        SETLL     GLCOLLL5                               88
      *
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL5        READE     GLCOLLL5                               88
     C     EndOfFile     IFEQ      False
     C     CDRECI        ANDNE     'R'
     C     CDCREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
      *
     C     @RecFound     IFEQ      'N'
     C     KCOLL5        SETLL     GLCOLALd                               88
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL5        READE     GLCOLALd                               88
     C     EndOfFile     IFEQ      False
     C     CACREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C     @RecFound     IFNE      'N'
      *
     C     KCOLL6        SETLL     GLCOLLL6                               88
      *
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL6        READE     GLCOLLL6                               88
     C     EndOfFile     IFEQ      False
     C     CDRECI        ANDNE     'R'
     C     CDCREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
      *
     C     @RecFound     IFEQ      'N'
     C     KCOLL6        SETLL     GLCOLALe                               88
     C     EndOfFile     DOWEQ     False
     C     @RecFound     ANDEQ     'N'
     C     KCOLL6        READE     GLCOLALe                               88
     C     EndOfFile     IFEQ      False
     C     CACREF        ANDNE     V_CDCREF
     C                   MOVE      'Y'           @RecFound
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMMBLOCK - Money Market Deposit Block process               *
      *                                                               *
      *****************************************************************
     C     SRMMBLOCK     BEGSR
      *
      ** DEALSC update
     C                   Z-ADD     V_CDDEAL      @DealNo           6 0
     C                   MOVE      *Blanks       @DCONV            1
      *
     C     @DealNo       CHAIN     DEALSC                             89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C     CCY           IFNE      V_CDCCY
      *
     C     V_CDCCY       IFNE      BSCCY
     C     @BCONV        IFNE      'Y'
     C                   EXSR      SRTOBASE
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     P_CDLAMT      P_BSLAMT
     C                   Z-ADD     V_CDLAMT      BSLAMT
     C                   ENDIF
      *
     C     CCY           IFNE      BSCCY
     C                   MOVE      CCY           @FCCY
     C                   EXSR      SRFMBASE
     C                   Z-ADD     P_@FLAMT      P_DCurCOLA       15 0
     C                   Z-ADD     @FLAMT        DCurCOLA         15 0
     C                   ELSE
     C                   Z-ADD     P_BSLAMT      P_DCurCOLA
     C                   Z-ADD     BSLAMT        DCurCOLA
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     P_CDLAMT      P_DCurCOLA
     C                   Z-ADD     V_CDLAMT      DCurCOLA
     C                   ENDIF
      *
     C                   MOVE      'Y'           @DCONV
      *                                                                                       218359
     C     V_CDDEAL      IFEQ      P_CDDEAL                                                   218359
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'D'
     C                   SUB       P_DCurCOLA    COLA
     C                   ENDIF
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'I'
     C                   ADD       DCurCOLA      COLA
     C                   ENDIF
      *                                                                                       218359
     C                   ELSE                                                                 218359
      *                                                                                       218359
     C     V_CDTYLC      IFEQ      'A'                                                        218359
     C     V_CDTYLC      OREQ      'I'                                                        218359
     C                   ADD       DCurCOLA      COLA                                         218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *
     C     V_CDTYLC      IFEQ      'I'
     C     AURO          ANDNE     'Y'
     C     MDAT          ANDNE     0
     C     V_CDTYLC      OREQ      'A'                                                        218359
     C     V_CDDEAL      ANDNE     P_CDDEAL                                                   218359
     C     AURO          ANDNE     'Y'                                                        218359
     C     MDAT          ANDNE     0                                                          218359
      *
     C                   MOVE      'Y'           AURO
     C     MDAT          SUB       VDAT          @DAYS             3 0
      *
     C     @DAYS         IFGT      182
     C                   MOVE      'Y'           ROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      91
     C     @DAYS         ANDLE     182
     C                   MOVE      'X'           ROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      61
     C     @DAYS         ANDLE     91
     C                   MOVE      'Q'           ROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      31
     C     @DAYS         ANDLE     61
     C                   MOVE      'T'           ROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      14
     C     @DAYS         ANDLE     31
     C                   MOVE      'M'           ROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      7
     C     @DAYS         ANDLE     14
     C                   MOVE      'F'           ROFQ
     C                   ENDIF
      *
     C     @DAYS         IFLE      7
     C                   MOVE      'W'           ROFQ
     C                   ENDIF
      *
     C     ROFQ          IFEQ      'W'
     C     ROFQ          OREQ      'F'
     C                   Z-ADD     0             RLDN
     C                   ELSE
     C                   Z-ADD     MDAT          ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDATE
     C                   PARM      *BLanks       ZADATE
     C                   MOVEL     ZADATE        RLDN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     COLA          IFLE      0
     C                   Z-ADD     0             COLA
     C                   MOVE      'N'           COLF
     C                   ELSE
     C                   MOVE      'Y'           COLF
     C                   ENDIF
      *
     C                   UPDATE    DEALSDCF                             90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'DEALSC    '  DBFILE
     C                   Z-ADD     014           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** MMDEAULL update
     C     @DealNo       CHAIN     MMDEAULL                           89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C     HKCCY         IFNE      V_CDCCY
      *
     C     V_CDCCY       IFNE      BSCCY
     C     @BCONV        IFNE      'Y'
     C                   EXSR      SRTOBASE
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     P_CDLAMT      P_BSLAMT
     C                   Z-ADD     V_CDLAMT      BSLAMT
     C                   ENDIF
      *
     C     HKCCY         IFNE      BSCCY
      *
     C     @DCONV        IFNE      'Y'
     C                   MOVE      HKCCY         @FCCY
     C                   EXSR      SRFMBASE
     C                   Z-ADD     P_@FLAMT      P_MCurCOLA       15 0
     C                   Z-ADD     @FLAMT        MCurCOLA         15 0
     C                   ELSE
     C                   Z-ADD     P_DCurCOLA    P_MCurCOLA
     C                   Z-ADD     DCurCOLA      MCurCOLA
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     P_BSLAMT      P_MCurCOLA
     C                   Z-ADD     BSLAMT        MCurCOLA
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     P_CDLAMT      P_MCurCOLA
     C                   Z-ADD     V_CDLAMT      MCurCOLA
     C                   ENDIF
      *                                                                                       218359
     C     V_CDDEAL      IFEQ      P_CDDEAL                                                   218359
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'D'
     C                   SUB       P_MCurCOLA    HKCOLA
     C                   ENDIF
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'I'
     C                   ADD       MCurCOLA      HKCOLA
     C                   ENDIF
      *                                                                                       218359
     C                   ELSE                                                                 218359
      *                                                                                       218359
     C     V_CDTYLC      IFEQ      'A'                                                        218359
     C     V_CDTYLC      OREQ      'I'                                                        218359
     C                   ADD       MCurCOLA      HKCOLA                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *
     C     V_CDTYLC      IFEQ      'I'
     C     HKAURO        ANDNE     'Y'
     C     HKMDMM        ANDNE     0
     C     V_CDTYLC      OREQ      'A'                                                        218359
     C     V_CDDEAL      ANDNE     P_CDDEAL                                                   218359
     C     HKAURO        ANDNE     'Y'                                                        218359
     C     HKMDMM        ANDNE     0                                                          218359
      *
     C                   MOVE      'Y'           HKAURO
      *
     C                   Z-ADD     HKMDYY        ZWYYYY
     C                   Z-ADD     HKMDMM        ZWMTH
     C                   Z-ADD     HKMDDD        ZWDAY
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         DaynoOut
      *
     C                   Z-ADD     DaynoOut      HKMATD
      *
     C                   Z-ADD     HKVDYY        ZWYYYY
     C                   Z-ADD     HKVDMM        ZWMTH
     C                   Z-ADD     HKVDDD        ZWDAY
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         DaynoOut
      *
     C                   Z-ADD     DaynoOut      HKDVSD
      *
     C     HKMATD        SUB       HKDVSD        @DAYS
      *
     C     @DAYS         IFGT      182
     C                   MOVE      'Y'           HKROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      91
     C     @DAYS         ANDLE     182
     C                   MOVE      'X'           HKROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      61
     C     @DAYS         ANDLE     91
     C                   MOVE      'Q'           HKROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      31
     C     @DAYS         ANDLE     61
     C                   MOVE      'T'           HKROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      14
     C     @DAYS         ANDLE     31
     C                   MOVE      'M'           HKROFQ
     C                   ENDIF
      *
     C     @DAYS         IFGT      7
     C     @DAYS         ANDLE     14
     C                   MOVE      'F'           HKROFQ
     C                   ENDIF
      *
     C     @DAYS         IFLE      7
     C                   MOVE      'W'           HKROFQ
     C                   ENDIF
      *
     C     HKROFQ        IFEQ      'W'
     C     HKROFQ        OREQ      'F'
     C                   Z-ADD     0             HKRLDN
     C                   ELSE
     C                   Z-ADD     MDAT          ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDATE
     C                   PARM      *BLanks       ZADATE
     C                   MOVEL     HKMATD        HKRLDN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     HKCOLA        IFLE      0
     C                   Z-ADD     0             HKCOLA
     C                   MOVE      'N'           HKCOLF
     C                   ELSE
     C                   MOVE      'Y'           HKCOLF
     C                   ENDIF
      *
     C                   UPDATE    MMDELDP0                             90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'MMDEAULL  '  DBFILE
     C                   Z-ADD     015           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       218359
     C     V_CDDEAL      IFNE      P_CDDEAL                                                   218359
     C     V_CDTYLC      ANDNE     'I'                                                        218359
      *                                                                                       218359
     C                   Z-ADD     P_CDDEAL      @DealNo           6 0                        218359
     C                   MOVE      *Blanks       @DCONV            1                          218359
      *                                                                                       218359
     C     @DealNo       CHAIN     DEALSC                             89                      218359
      *                                                                                       218359
     C     RcdNotFnd     IFEQ      False                                                      218359
      *                                                                                       218359
     C     CCY           IFNE      V_CDCCY                                                    218359
      *                                                                                       218359
     C     V_CDCCY       IFNE      BSCCY                                                      218359
     C     @BCONV        IFNE      'Y'                                                        218359
     C                   EXSR      SRTOBASE                                                   218359
     C                   ENDIF                                                                218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_CDLAMT      P_BSLAMT                                     218359
     C                   Z-ADD     V_CDLAMT      BSLAMT                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     CCY           IFNE      BSCCY                                                      218359
     C                   MOVE      CCY           @FCCY                                        218359
     C                   EXSR      SRFMBASE                                                   218359
     C                   Z-ADD     P_@FLAMT      P_DCurCOLA       15 0                        218359
     C                   Z-ADD     @FLAMT        DCurCOLA         15 0                        218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_BSLAMT      P_DCurCOLA                                   218359
     C                   Z-ADD     BSLAMT        DCurCOLA                                     218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_CDLAMT      P_DCurCOLA                                   218359
     C                   Z-ADD     V_CDLAMT      DCurCOLA                                     218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   MOVE      'Y'           @DCONV                                       218359
      *                                                                                       218359
     C     V_CDTYLC      IFEQ      'A'                                                        218359
     C     V_CDTYLC      OREQ      'D'                                                        218359
     C                   SUB       P_DCurCOLA    COLA                                         218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     COLA          IFLE      0                                                          218359
     C                   Z-ADD     0             COLA                                         218359
     C                   MOVE      'N'           COLF                                         218359
     C                   ELSE                                                                 218359
     C                   MOVE      'Y'           COLF                                         218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   UPDATE    DEALSDCF                             90                    218359
      *                                                                                       218359
     C     FileError     IFEQ      True                                                       218359
     C     *LOCK         IN        LDA                                                        218359
     C                   MOVEL     '*UPDATE   '  DBKEY                                        218359
     C                   MOVEL     'DEALSC    '  DBFILE                                       218359
     C                   Z-ADD     014           DBASE                                        218359
     C                   OUT       LDA                                                        218359
     C                   EXSR      SRERR                                                      218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     @DealNo       CHAIN     MMDEAULL                           89                      218359
      *                                                                                       218359
     C     RcdNotFnd     IFEQ      False                                                      218359
      *                                                                                       218359
     C     HKCCY         IFNE      V_CDCCY                                                    218359
      *                                                                                       218359
     C     V_CDCCY       IFNE      BSCCY                                                      218359
     C     @BCONV        IFNE      'Y'                                                        218359
     C                   EXSR      SRTOBASE                                                   218359
     C                   ENDIF                                                                218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_CDLAMT      P_BSLAMT                                     218359
     C                   Z-ADD     V_CDLAMT      BSLAMT                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     HKCCY         IFNE      BSCCY                                                      218359
      *                                                                                       218359
     C     @DCONV        IFNE      'Y'                                                        218359
     C                   MOVE      HKCCY         @FCCY                                        218359
     C                   EXSR      SRFMBASE                                                   218359
     C                   Z-ADD     P_@FLAMT      P_MCurCOLA       15 0                        218359
     C                   Z-ADD     @FLAMT        MCurCOLA         15 0                        218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_DCurCOLA    P_MCurCOLA                                   218359
     C                   Z-ADD     DCurCOLA      MCurCOLA                                     218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_BSLAMT      P_MCurCOLA                                   218359
     C                   Z-ADD     BSLAMT        MCurCOLA                                     218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_CDLAMT      P_MCurCOLA                                   218359
     C                   Z-ADD     V_CDLAMT      MCurCOLA                                     218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     V_CDTYLC      IFEQ      'A'                                                        218359
     C                   SUB       P_MCurCOLA    HKCOLA                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     HKCOLA        IFLE      0                                                          218359
     C                   Z-ADD     0             HKCOLA                                       218359
     C                   MOVE      'N'           HKCOLF                                       218359
     C                   ELSE                                                                 218359
     C                   MOVE      'Y'           HKCOLF                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   UPDATE    MMDELDP0                             90                    218359
      *                                                                                       218359
     C     FileError     IFEQ      True                                                       218359
     C     *LOCK         IN        LDA                                                        218359
     C                   MOVEL     '*UPDATE   '  DBKEY                                        218359
     C                   MOVEL     'MMDEAULL  '  DBFILE                                       218359
     C                   Z-ADD     015           DBASE                                        218359
     C                   OUT       LDA                                                        218359
     C                   EXSR      SRERR                                                      218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSEBLOCK - Security Holding Block process                   *
      *                                                               *
      *****************************************************************
     C     SRSEBLOCK     BEGSR
      *
     C     V_CDCSEC      CHAIN     SECTY                              89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C                   SELECT
     C     MATY          WHENNE    0
     C     MATY          ANDLT     P_CDEDAT
     C     P_CDEDAT      OREQ      0
     C                   Z-ADD     MATY          @PCEDAT
     C     P_CDEDAT      WHENNE    0
     C     P_CDEDAT      ANDLT     MATY
     C     MATY          OREQ      0
     C                   Z-ADD     P_CDEDAT      @PCEDAT
     C                   ENDSL
      *
     C                   SELECT
     C     MATY          WHENNE    0
     C     MATY          ANDLT     V_CDEDAT
     C     V_CDEDAT      OREQ      0
     C                   Z-ADD     MATY          @CEDAT
     C     V_CDEDAT      WHENNE    0
     C     V_CDEDAT      ANDLT     MATY
     C     MATY          OREQ      0
     C                   Z-ADD     V_CDEDAT      @CEDAT
     C                   ENDSL
      *
     C     @CEDAT        IFEQ      0
     C                   Z-ADD     99999         @CEDAT
     C                   ENDIF
      *
     C     NMCY          IFNE      V_CDCCY
      *
     C     V_CDCCY       IFNE      BSCCY
     C     @BCONV        IFNE      'Y'
     C                   EXSR      SRTOBASE
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     P_CDLAMT      P_BSLAMT
     C                   Z-ADD     V_CDLAMT      BSLAMT
     C                   ENDIF
      *
     C     NMCY          IFNE      BSCCY
     C                   MOVE      NMCY          @FCCY
     C                   EXSR      SRFMBASE
     C                   Z-ADD     P_@FLAMT      P_SCurCOLA       15 0
     C                   Z-ADD     @FLAMT        SCurCOLA         15 0
     C                   ELSE
     C                   Z-ADD     P_BSLAMT      P_SCurCOLA
     C                   Z-ADD     BSLAMT        SCurCOLA
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     P_CDLAMT      P_SCurCOLA
     C                   Z-ADD     V_CDLAMT      SCurCOLA
     C                   ENDIF
      *
     C     NMDP          IFNE      @FNBDP
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      NMCY          PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     NMCY          DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     016           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     NMDP          SUB       A6NBDP        IX
     C     IX            IFGT      0
     C                   ADD       1             IX
     C     P_SCurCOLA    MULT   (H)POWER8(IX)    P_SCurCOLA
     C     SCurCOLA      MULT   (H)POWER8(IX)    SCurCOLA
     C                   ELSE
     C                   Z-SUB     IX            IX
     C                   ADD       1             IX
     C     P_SCurCOLA    DIV    (H)POWER8(IX)    P_SCurCOLA
     C     SCurCOLA      DIV    (H)POWER8(IX)    SCurCOLA
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       218359
     C     V_CDCSEC      IFEQ      P_CDCSEC                                                   218359
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'D'
      *
     C                   MOVEL     P_CDCSCN      PCUST
     C                   EXSR      SRPTFR
      *
     C                   MOVE      P_CDCSBR      KBRCD
     C**********         Z-ADD     P_CDCSCN      KCNUM                                        CSD027
     C                   EVAL      KCNUM = P_CDCSCN                                           CSD027
     C                   MOVE      'P'           KBLTY
     C                   MOVE      P_CDCSEC      KSESN
     C                   Z-ADD     @PCEDAT       KBEDT
     C                   Z-ADD     00001         KSEQN
     C     KBLKP         CHAIN     SEBLKPL0                           89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C                   SUB       P_SCurCOLA    VDCOLA
     C                   SUB       P_SCurCOLA    VDNOMB
      *
     C     VDCOLA        IFLE      0
     C                   Z-ADD     0             VDCOLA
     C                   MOVE      'N'           VDCOLF
     C                   ELSE
     C                   MOVE      'Y'           VDCOLF
     C                   ENDIF
      *
     C                   UPDATE    SEBLKPD0                             90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'SEBLKPL0  '  DBFILE
     C                   Z-ADD     017           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *
     C     V_CDTYLC      IFEQ      'A'
     C     V_CDTYLC      OREQ      'I'
      *
     C                   MOVEL     V_CDCSCN      PCUST
     C                   EXSR      SRPTFR
      *
     C                   MOVE      V_CDCSBR      KBRCD
     C**********         Z-ADD     V_CDCSCN      KCNUM                                        CSD027
     C                   EVAL      KCNUM = V_CDCSCN                                           CSD027
     C                   MOVE      'P'           KBLTY
     C                   MOVE      V_CDCSEC      KSESN
     C                   Z-ADD     @CEDAT        KBEDT
     C                   Z-ADD     00001         KSEQN
     C     KBLKP         CHAIN     SEBLKPL0                           89
      *
     C     RcdNotFnd     IFEQ      False
      *
     C                   ADD       SCurCOLA      VDCOLA
     C                   ADD       SCurCOLA      VDNOMB
      *
     C     VDCOLA        IFLE      0
     C                   Z-ADD     0             VDCOLA
     C                   MOVE      'N'           VDCOLF
     C                   ELSE
     C                   MOVE      'Y'           VDCOLF
     C                   ENDIF
      *
     C                   UPDATE    SEBLKPD0                             90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*UPDATE   '  DBKEY
     C                   MOVEL     'SEBLKPL0  '  DBFILE
     C                   Z-ADD     018           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'D'           VDRECI
     C                   Z-ADD     BJRDNB        VDLCD
     C                   MOVE      'I'           VDCHTP
     C                   MOVE      WWUser        VDLUID
     C                   MOVE      V_CDCSBR      VDBRCD
     C**********         Z-ADD     V_CDCSCN      VDCNUM                                       CSD027
     C                   EVAL      VDCNUM = V_CDCSCN                                          CSD027
     C                   MOVE      KPTFR         VDPTFR
     C                   MOVE      'P'           VDBLTY
     C                   MOVE      V_CDCSEC      VDSESN
     C                   Z-ADD     @CEDAT        VDBEDT
     C                   Z-ADD     SCurCOLA      VDNOMB
      *
     C     V_CDDESC      IFNE      *BLANKS
     C                   MOVEL     V_CDDESC      VDBNAR
     C                   ELSE
     C                   MOVEL     'Collateral'  VDBNAR
     C                   ENDIF
      *
     C                   Z-ADD     00001         VDSEQN
     C                   Z-ADD     V_CDVDAT      VDBSTT
     C                   MOVE      'W'           VDEWIN
     C                   MOVE      'Y'           VDCOLF
     C                   Z-ADD     SCurCOLA      VDCOLA
      *
     C                   WRITE     SEBLKPD0                             90
      *
     C     FileError     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     '*WRITE    '  DBKEY
     C                   MOVEL     'SEBLKPL0  '  DBFILE
     C                   Z-ADD     019           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       218359
     C     V_CDCSEC      IFNE      P_CDCSEC                                                   218359
      *                                                                                       218359
     C     P_CDCSEC      CHAIN     SECTY                              89                      218359
      *                                                                                       218359
     C     RcdNotFnd     IFEQ      False                                                      218359
      *                                                                                       218359
     C                   SELECT                                                               218359
     C     MATY          WHENNE    0                                                          218359
     C     MATY          ANDLT     P_CDEDAT                                                   218359
     C     P_CDEDAT      OREQ      0                                                          218359
     C                   Z-ADD     MATY          @PCEDAT                                      218359
     C     P_CDEDAT      WHENNE    0                                                          218359
     C     P_CDEDAT      ANDLT     MATY                                                       218359
     C     MATY          OREQ      0                                                          218359
     C                   Z-ADD     P_CDEDAT      @PCEDAT                                      218359
     C                   ENDSL                                                                218359
      *                                                                                       218359
     C     NMCY          IFNE      P_CDCCY                                                    218359
      *                                                                                       218359
     C     P_CDCCY       IFNE      BSCCY                                                      218359
     C     @BCONV        IFNE      'Y'                                                        218359
     C                   EXSR      SRTOBASE                                                   218359
     C                   ENDIF                                                                218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_CDLAMT      P_BSLAMT                                     218359
     C                   Z-ADD     V_CDLAMT      BSLAMT                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     NMCY          IFNE      BSCCY                                                      218359
     C                   MOVE      NMCY          @FCCY                                        218359
     C                   EXSR      SRFMBASE                                                   218359
     C                   Z-ADD     P_@FLAMT      P_SCurCOLA       15 0                        218359
     C                   Z-ADD     @FLAMT        SCurCOLA         15 0                        218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_BSLAMT      P_SCurCOLA                                   218359
     C                   Z-ADD     BSLAMT        SCurCOLA                                     218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ELSE                                                                 218359
     C                   Z-ADD     P_CDLAMT      P_SCurCOLA                                   218359
     C                   Z-ADD     V_CDLAMT      SCurCOLA                                     218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     NMDP          IFNE      @FNBDP                                                     218359
      *                                                                                       218359
     C                   CALLB     'AOCURRR0'                                                 218359
     C                   PARM      *BLANKS       PRTCD                                        218359
     C                   PARM      '*KEY   '     POPTN                                        218359
     C                   PARM      NMCY          PCCY                                         218359
     C     SDCURR        PARM      SDCURR        DSSDY                                        218359
      *                                                                                       218359
     C     PRTCD         IFNE      *BLANKS                                                    218359
     C     *LOCK         IN        LDA                                                        218359
     C                   MOVEL     NMCY          DBKEY                                        218359
     C                   MOVEL     'SDCURRPD'    DBFILE                                       218359
     C                   Z-ADD     016           DBASE                                        218359
     C                   OUT       LDA                                                        218359
     C                   EXSR      *PSSR                                                      218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     NMDP          SUB       A6NBDP        IX                                           218359
     C     IX            IFGT      0                                                          218359
     C                   ADD       1             IX                                           218359
     C     P_SCurCOLA    MULT   (H)POWER8(IX)    P_SCurCOLA                                   218359
     C     SCurCOLA      MULT   (H)POWER8(IX)    SCurCOLA                                     218359
     C                   ELSE                                                                 218359
     C                   Z-SUB     IX            IX                                           218359
     C                   ADD       1             IX                                           218359
     C     P_SCurCOLA    DIV    (H)POWER8(IX)    P_SCurCOLA                                   218359
     C     SCurCOLA      DIV    (H)POWER8(IX)    SCurCOLA                                     218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C     V_CDTYLC      IFEQ      'A'                                                        218359
     C     V_CDTYLC      OREQ      'D'                                                        218359
      *                                                                                       218359
     C                   MOVEL     P_CDCSCN      PCUST                                        218359
     C                   EXSR      SRPTFR                                                     218359
      *                                                                                       218359
     C                   MOVE      P_CDCSBR      KBRCD                                        218359
     C**********         Z-ADD     P_CDCSCN      KCNUM                                 218359 CSD031
     C                   EVAL      KCNUM = P_CDCSCN                                           CSD031
     C                   MOVE      'P'           KBLTY                                        218359
     C                   MOVE      P_CDCSEC      KSESN                                        218359
     C                   Z-ADD     @PCEDAT       KBEDT                                        218359
     C                   Z-ADD     00001         KSEQN                                        218359
     C     KBLKP         CHAIN     SEBLKPL0                           89                      218359
      *                                                                                       218359
     C     RcdNotFnd     IFEQ      False                                                      218359
      *                                                                                       218359
     C                   SUB       P_SCurCOLA    VDCOLA                                       218359
     C                   SUB       P_SCurCOLA    VDNOMB                                       218359
      *                                                                                       218359
     C     VDCOLA        IFLE      0                                                          218359
     C                   Z-ADD     0             VDCOLA                                       218359
     C                   MOVE      'N'           VDCOLF                                       218359
     C                   ELSE                                                                 218359
     C                   MOVE      'Y'           VDCOLF                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   UPDATE    SEBLKPD0                             90                    218359
      *                                                                                       218359
     C     FileError     IFEQ      True                                                       218359
     C     *LOCK         IN        LDA                                                        218359
     C                   MOVEL     '*UPDATE   '  DBKEY                                        218359
     C                   MOVEL     'SEBLKPL0  '  DBFILE                                       218359
     C                   Z-ADD     017           DBASE                                        218359
     C                   OUT       LDA                                                        218359
     C                   EXSR      SRERR                                                      218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *                                                                                       218359
     C                   ENDIF                                                                218359
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPTFR - Check default customer portfolio reference          *
      *                                                               *
      *****************************************************************
     C     SRPTFR        BEGSR
      *
      ** Check default customer portfolio reference
     C                   CALLB     'AOPLCSR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST            10
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
     C     PRTCD         IFNE      *Blanks
     C                   MOVE      *Blanks       KPTFR
     C                   ELSE
     C                   MOVE      QBDFPO        KPTFR
     C                   MOVEL     QBCUST        KCNUM
      *
     C     KPTFR         IFEQ      *BLANKS
     C                   MOVEL     *LOVAL        KPTFR
     C     KPORT         SETLL     PMPORTLL
     C                   READ      PMPORTLL                               89
      *
     C     RcdNotFnd     IFEQ      False
     C     PNCNUM        ANDEQ     KCNUM
     C                   MOVE      PNPTFR        KPTFR
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVEL     KCNUM         DBKEY
     C                   MOVEL     'PMPORTPD  '  DBFILE
     C                   Z-ADD     020           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     KPORT         CHAIN     PMPORTLL                           89
     C     RcdNotFnd     IFEQ      True
     C     *LOCK         IN        LDA
     C                   MOVEL     KCNUM         DBKEY
     C                   MOVEL     'PMPORTPD  '  DBFILE
     C                   Z-ADD     021           DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** New Collateral Record
     C                   PARM                    NwCoFilFmt
      *
     C                   PARM                    CGL012            1
     C/COPY WNCPYSRC,GLCOLLDC01
      *
      ** Key list for SDCLLML2
     C     KCLLM         KLIST
     C                   KFLD                    KLEVL             1
     C                   KFLD                    KBCCD             3
     C                   KFLD                    KCUST             6
      *
      ** Key list for GLCOLLL2 AND GLCOLALa
     C     KCOLL2        KLIST
     C                   KFLD                    V_CDMODS
     C                   KFLD                    V_CDCNUM
      *
      ** Key list for GLCOLLL3 and GLCOLALb
     C     KCOLL3        KLIST
     C                   KFLD                    V_CDMODS
     C                   KFLD                    V_CDFCUS
     C                   KFLD                    V_CDFTYP
     C                   KFLD                    V_CDFSEQ
      *
      ** Key list for GLCOLLL4 and GLCOLALc
     C     KCOLL4        KLIST
     C                   KFLD                    V_CDMODS
     C                   KFLD                    V_CDLNLM
      *
      ** Key list for GLCOLLL5 and GLCOLALd
     C     KCOLL5        KLIST
     C                   KFLD                    V_CDMODS
     C                   KFLD                    V_CDSACN
      *
      ** Key list for GLCOLLL6 and GLCOLALe
     C     KCOLL6        KLIST
     C                   KFLD                    V_CDMODS
     C                   KFLD                    V_CDSCNM
     C                   KFLD                    V_CDSCCY
     C                   KFLD                    V_CDSACD
     C                   KFLD                    V_CDSSEQ
     C                   KFLD                    V_CDSBRC
      *
      ** Key list for FCLTY
     C     KFCLT         KLIST
     C                   KFLD                    V_CDFCUS
     C                   KFLD                    V_CDFTYP
     C                   KFLD                    V_CDFSEQ
     C                   KFLD                    KRCDT             1
      *
      ** Key list for CLOAN
     C     KLOAN         KLIST
     C                   KFLD                    V_CDLNLM
     C                   KFLD                    KRCDT
      *
      ** Key list for ACCNT
     C     KACCNT        KLIST
     C                   KFLD                    V_CDSCNM
     C                   KFLD                    V_CDSCCY
     C                   KFLD                    V_CDSACD
     C                   KFLD                    V_CDSSEQ
     C                   KFLD                    V_CDSBRC
      *
      ** Key list for SEBLKPL0
     C     KBLKP         KLIST
     C                   KFLD                    KBRCD
     C                   KFLD                    KCNUM
     C                   KFLD                    KPTFR
     C                   KFLD                    KBLTY
     C                   KFLD                    KSESN
     C                   KFLD                    KBEDT
     C                   KFLD                    KSEQN
      *
      ** Key list for PMPORTLL
     C     KPORT         KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KPTFR
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLLUPD  ' DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get Base Currency details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BJCYCD        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     BJCYCD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      A6CYCD        BSCCY             3
     C                   Z-ADD     A6NBDP        BSNBDP            1 0
     C                   ENDIF
      *
      **********                                                                      CAP084 BUG6979
     C******DTAARA       DEFINE                  ZMUSER                               CAP084 BUG6979
     C**********         IN        ZMUSER                                             CAP084 BUG6979
     C**********         EVAL      PSUser = PUSRID                                    CAP084 BUG6979
      **********                                                                      CAP084 BUG6979
      ***Store*value*of*the*Job*User.                                                        BUG6979
     C**********         MOVE      PSUser        WWUser           10                         BUG6979
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  POWER8
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
