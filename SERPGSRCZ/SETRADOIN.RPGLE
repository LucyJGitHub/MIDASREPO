     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade order details maintenance module')      *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SETRADOIN - Trade Order Details Maintenance Module           *
      *                                                               *
      *  Function:  This module allows a Touch of Finance Order       *
      *             number to be selected and an action code entered. *
      *             The browse module is then called to display all   *
      *             the trades for the order and defaulting in the    *
      *             action code for them.                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR698195B          Date 20Jan11               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 222373             Date 23Oct03               *
      *                 CSE039             Date 21Jan03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 189751             Date 27Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186044             Date 08Nov00               *
      *                 175216             Date 12Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      *                 CSE019             Date 19Apr00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CSE010 *CREATE     Date 21Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  222373 - Parameter Mismatch                                  *
      *  CSE039 - Auto-settlement of trades.                          *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *           (Recompiled).                                       *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  189751 - MUI Trade Order maintenance details should display  *
      *           allowable action codes.                             *
      *  186044 - Export variables changed to imports.                *
      *  175216 - Addtional field required for SWIFT 98.              *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *  CSE019 - SE Trades Selections Enhancements                   *
      *  CSE010 - SE Transaction Enhancements.                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------------
 
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
 
      * Export field Order Number
     D*EXORDE**********S**************6    EXPORT                                             186044
     D EXORDE          S              6    IMPORT                                             186044
 
      * Export field F10
     D*@ENDEL**********S**************1    EXPORT                                             186044
     D @ENDEL          S              1    IMPORT                                             186044
                                                                                CSE019
      ** Data structure to define Front Office Id                               CSE019
     D                 DS                                                       CSE019
     D WWFRNT                  1     20A                                        CSE019
     D W1ORDE                  1     16A                                        CSE019
     D DSOrder                 1     16A                                        CSE019
     D WWSTID                  1      2A                                        CSE019
     D WWDATE                  3     10A                                        CSE019
     D WWORDE                 11     16A                                        CSE019
     D WWORNO                 17     20A                                        CSE019
                                                                                CSE019
     D                 DS                                                       CSE019
     D W2FRNT                  1     20A                                        CSE019
     D W2ORDE                  1     16A                                        CSE019
 
      * Current Trade in File Format
     D CrTrFilFmt    E DS                  EXTNAME(TRADSD)
     D                                     PREFIX(C_)
 
      * Current Trade in File Format (Extension File)
     D CT1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CA_)
 
      * Current Trade in File Format (Extension File)
     D CT1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CB_)
 
      ** Trade Primary Details in screen format
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
 
      * (Current) Trade in Screen Format - Primary Details
     D CurTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(@)
 
      * (Current) Trade in Screen Format - Secondary Details
     D CurTrSeco     E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(@)
 
      * (Current) Trade in Screen Format - Exchange Rates Details
     D CurTrExch     E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(@)
 
      * (Current) Trade in Screen Format - Settlement Instructions
     D CurTrSett     E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(@)
 
     D @DDCLTY2      E                     EXTFLD(DDCLTY)
 
      * (Current) Trade in Screen Format - Charges/Commissions
     D CurTrChCm     E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@)
 
      * (Current) Trade in Screen Format - SWIFT Details
     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@A)
 
      * (Current) Trade in Screen Format - SWIFT Details
     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@B)
 
      * New Trade in File Format
     D NwTrFilFmt    E DS                  EXTNAME(SEVTRADPD)
 
      * New Trade in File Format (Extension File)
     D NT1AFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(A_)
 
      * New Trade in File Format (Extension File)
     D NT1BFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(B_)
 
      * New Trade in Screen Format - Primary Details
     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(C_)
 
      * New Trade in Screen Format - Secondary Details
     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
 
      * New Trade in Screen Format - Third Details                                            222373
     D NewTrThir     E DS                  EXTNAME(SETRTHPD)                                  222373
 
      * New Trade in Screen Format - Exchange Rate Details
     D NewTrExch     E DS                  EXTNAME(SETREXPD)
 
      * New Trade in Screen Format - Settlement Details
     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
 
     D DDCLTY2       E                     EXTFLD(DDCLTY)
 
      * New Trade in Screen Format - Charge & Commission Details
     D NewTrChCm     E DS                  EXTNAME(SETRCCPD)
 
      * New Trade in Screen Format - SWIFT Details
     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A_)
     D NewTrExts     E DS                  EXTNAME(SETESDPD)                                  222373
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 222373
 
      * New Trade in Screen Format - SWIFT Details
     D NewTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B_)
 
      * Previous Trade in Screen Format - Primary Details
     D PrvTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(@P)
 
      * Previous Trade in Screen Format - Secondary Details
     D PrvTrSeco     E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(@P)
 
      * Previous Trade in Screen Format - Exchange Rate Details
     D PrvTrExch     E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(@P)
 
      * Previous Trade in Screen Format - Settlement Details
     D PrvTrSett     E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(@P)
 
     D @PDDCLTY2     E                     EXTFLD(DDCLTY)
 
      * Previous Trade in Screen Format - Charge & Commission Details
     D PrvTrChCm     E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@P)
 
      * Previous Trade in Screen Format - SWIFT Details
     D PrvTrSwft     E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@P)
 
      ** Trade Primary Details OK indicators
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
     D OKTrExts      E DS                  EXTNAME(SEETESPD)                                  222373
                                                                                              CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
     D PMCWL           DS          9999                                                       CSD015
     D CAP051          S              1                                                       CSD015
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)                         CSE019
     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for Securities Trading Details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** External DS for Portfolio ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * SE Trades Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SETDEXPD)
                                                                                              222373
      **  Externally Described Data Structure For Valid Trade Extension 1                     222373
     D SEVTRDX2A     E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(AA_)                                        222373
      **  Externally Described Data Structure For Valid Trade Extension 1                     222373
     D SEVTRDX2B     E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(AB_)                                        222373
 
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D Ix              S              3P 0
      ** Index for arrays of error message ids etc
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
                                                                                              CGL031
     D CGL031          S              1A                                                      CGL031
 
     D DDPRICN         S             17                                                       222373
     D PCALL           S              3A                                                      222373
     D PMODE           S              3A                                                      222373
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRDPV025
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/MAIN
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      *                                                               *
      * MAIN    - Main Processing                                     *
      *                                                               *
      * Called By: None                                               *
      *                                                               *
      * Calls    : BLDBRW     - Build Browse Subfile                  *
      *            RDNBRW     - Read Next Browse Subfile Record       *
      *            SCRN@E_A   - Process Extension Swift Screen A      *
      *            SCRN@E_B   - Process Extension Swift Screen B      *
      *            SCRN@O     - Process Other Details Screen          *
      *            SCRN@ORD   - Process Order Details Screen          *
      *            SCRN@S     - Process Second Screen                 *
      *            VAL@E_A    - Validate Input to Extension Screen A  *
      *            VAL@E_B    - Validate Input to Extension Screen B  *
      *            VAL@O      - Validate Input to Other Details Screen*
      *            VAL@S      - Validate Input to Secondary Screen    *
      *            UPDATS     - Updates                               *
      *                                                               *
      *****************************************************************
      *
      ** Do while the screen is Order Details
      *
     C     @SCRN         DOWEQ     'D'
     C                   EXSR      SCRN@ORD
     C                   ENDDO
      *
      ** Do while the screen is Browse
      *
     C     @SCRN         DOWEQ     'W'
     C                   EXSR      BLDBRW
     C                   ENDDO
      *
      ** Do while the screen is Read Browse
      *
     C     @SCRN         DOWEQ     'R'
     C                   EXSR      RDNBRW
     C                   ENDDO
      *
      ** If Review Trades is YES
      *
     C     @@REVW        IFEQ      'Y'
      *
      ** Do While the screen is Secondary
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      SCRN@S
     C                   ENDDO
      *
      ** Do While the screen is Other Details
      *
     C     @SCRN         DOWEQ     'O'
     C                   EXSR      SCRN@O
     C                   ENDDO
      *
      ** Do While the screen is Extension (Swift) Details Screen A
      *
     C     @SCRN         DOWEQ     'A'
     C                   EXSR      SCRN@E_A
     C                   ENDDO
      *
      ** Do While the screen is Extension (Swift) Details Screen B
      *
     C     @SCRN         DOWEQ     'B'
     C                   EXSR      SCRN@E_B
     C                   ENDDO
      *
     C                   ELSE
      *
      ** Do While the screen is Secondary
      *
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      VAL@S
     C                   EXSR      VAL@O
     C                   EXSR      VAL@E_A
     C                   EXSR      VAL@E_B
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If the screen is Update
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      ** If the screen is Terminate
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/*INZSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : INITIAL - Initialization Routine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SETRADOIN'   DBPGM
     C                   OUT       LDA
      *
      **  Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Check if MT5XX Message Generation switchable feature is ON.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'S01401'      PSARD             6
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01401'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01401            1
     C                   ELSE
     C                   MOVE      'N'           S01401
     C                   END
      *
      ** Check if MT5XX Phase 2 Message Generation switchable feature in ON.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW003'      PSARD
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSW003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW003
     C                   ELSE
     C                   MOVE      'N'           CSW003            1
     C                   END
      *                                                                         CSE019
      ** Check if CSE019 - Trades Selections and Order Number Enhancements is ONCSE019
      *                                                                         CSE019
     C                   CALL      'AOSARDR0'                                   CSE019
     C                   PARM      *BLANKS       PRTCD             7            CSE019
     C                   PARM      '*VERIFY'     POPTN             7            CSE019
     C                   PARM      'CSE019'      PSARD             6            CSE019
      *                                                                         CSE019
      ** Database Error                                                         CSE019
      *                                                                         CSE019
     C     PRTCD         IFNE      *BLANKS                                      CSE019
     C     PRTCD         ANDNE     '*NRF   '                                    CSE019
     C                   MOVEL     'CSE019'      DBKEY                          CSE019
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE019
     C                   MOVEL     '903'         DBASE                          CSE019
     C                   EXSR      SRERR                                        CSE019
     C                   END                                                    CSE019
      *                                                                         CSE019
     C     PRTCD         IFEQ      *BLANK                                       CSE019
     C                   MOVE      'Y'           CSE019            1            CSE019
     C                   ELSE                                                   CSE019
     C                   MOVE      'N'           CSE019                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                                       222373
      ** Check if CAS006 is ON                                                                222373
      *                                                                                       222373
     C                   CALL      'AOSARDR0'                                                 222373
     C                   PARM      *BLANKS       PRTCD             7                          222373
     C                   PARM      '*VERIFY'     POPTN             7                          222373
     C                   PARM      'CAS006'      PSARD             6                          222373
      *                                                                                       222373
      ** Database Error                                                                       222373
      *                                                                                       222373
     C     PRTCD         IFNE      *BLANKS                                                    222373
     C     PRTCD         ANDNE     '*NRF   '                                                  222373
     C                   MOVEL     'CAS006'      DBKEY                                        222373
     C                   MOVEL     'SCSARDPD'    DBFILE                                       222373
     C                   MOVEL     '904'         DBASE                                        222373
     C                   EXSR      SRERR                                                      222373
     C                   END                                                                  222373
      *                                                                                       222373
     C     PRTCD         IFEQ      *BLANK                                                     222373
     C                   MOVE      'Y'           CAS006            1                          222373
     C                   ELSE                                                                 222373
     C                   MOVE      'N'           CAS006                                       222373
     C                   ENDIF                                                                222373
                                                                                              CGL031
      ** Check if CGL031 in installed                                                         CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C     PRTCD         IFNE      *BLANKS                                                    CGL031
     C     PRTCD         ANDNE     '*NRF   '                                                  CGL031
     C                   MOVEL     'CGL031'      DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '905'         DBASE                                        CGL031
     C                   EXSR      SRERR                                                      CGL031
     C                   END                                                                  CGL031
      *                                                                                       CGL031
     C     PRTCD         IFEQ      *BLANKS                                                    CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   END                                                                  CGL031
      *
      ** Go to Initial Screen
      *
     C                   EXSR      INITIAL
      **------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRDPV027
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/INITIAL
      *****************************************************************
      *                                                               *
      * INITIAL - Initialization Routine                              *
      *                                                               *
      * Called By: *INZSR - Program Initialisation Routine.           *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     INITIAL       BEGSR
      *
     C                   MOVE      'N'           @RDNB             1
     C                   MOVE      *BLANKS       DDACTN
     C                   MOVE      *BLANKS       DDORDE
     C                   MOVE      *BLANKS       DDREVW
     C                   MOVE      'D'           @SCRN             1
      *
      ** Reset commitment required to NO
      *
     C                   MOVE      'N'           CommitReqd        1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/BDLBRW
      *****************************************************************
      *                                                               *
      * BLDBRW - Build Browse Subfile                                 *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : CANC@W     - Cancel on Browse Screen               *
      *            ENDP       - Program Termination                   *
      *            SNDM@P     - Send a message to Primary Details     *
      *                         Screen                                *
      *                                                               *
      *****************************************************************
     C     BLDBRW        BEGSR
      *
     C                   MOVE      'N'           @RDNB
     C                   MOVE      *BLANKS       @ENDEL
     C                   MOVE      *BLANKS       FldNameArr
     C                   MOVE      *BLANKS       MsgIdArr
     C                   MOVE      *BLANKS       MsgDtaArr
      *
      ** Export new field Order Number, DDORDE set in SCRN@ORD
      *
     C                   MOVEL     @@ORDER       EXORDE
      *
     C     DDACTN        IFEQ      'D'
     C     DDREVW        ANDEQ     'N'
     C                   MOVE      'Y'           @ENDEL
     C                   ENDIF
      *
      ** Build the Subfile
      ** If CSE019 is not active                                                CSE019
     C     CSE019        Ifne      'Y'                                          CSE019
      *
     C                   CALLB     'SETRADBRW'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Trade Ref. Pointer
      * Build subfile
      * Read subfile record
      *
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDRF            6
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANKS       @RDSFL            1
      *
      * OUTPUT PARAMETERS :
      * Error message
      * Option Selected
      * Trade Reference Selected
      * Command Keys
     C                   PARM      *BLANKS       @ERRMS            7
     C                   PARM      *BLANKS       @OPSEL            1
     C                   PARM      *BLANKS       @TRSEL            6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** If F3 taken in browse, end the program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
      ** If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
      ** If F12 not taken in browse, read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
      *
      ** Else, execute subroutine CANC@W
      *
     C                   ELSE
     C                   EXSR      CANC@W
     C                   ENDIF
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C     CSE019        Ifeq      'Y'                                          CSE019
     C                   Move      'Y'           @RDNB                          CSE019
     C                   Movel     'R'           @SCRN                          CSE019
     C                   Endif                                                  CSE019
      *
     C     EndBLDBRW     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/RDNBRW
      *****************************************************************
      *                                                               *
      * RDNBRW - Read Next Browse Subfile Record                      *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : CVTTRD  - Put A Trade on the Secondary Screen      *
      *            INITIAL - Initialization Routine                   *
      *            RTVTRD  - Retrieve Trade                           *
      *                                                               *
      *****************************************************************
     C     RDNBRW        BEGSR
      *                                                                         CSE019
     C     CSE019        Ifne      'Y'                                          CSE019
      *
      **  Read Next Subfile Record
      *
     C                   CALLB     'SETRADBRW'
      * INPUT PARAMETERS :
      * Return code
      * Action code
      * Trade Ref. pointer
      * Build Sub-file
      * Read Sub-file record
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDRF            6
     C                   PARM      *BLANK        @BDSFL            1
     C                   PARM      'Y'           @RDSFL            1
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Trade Ref. selected
      * Function keys
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @TRSEL            6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C     CSE019        Ifeq      'Y'                                          CSE019
      *                                                                         CSE019
     C                   Movel     @FTSEL        DDFRNT                         CSE019
      *                                                                         CSE019
     C                   Callb     'SETRADRED'                                  CSE019
      *                                                                         CSE019
      * INPUT PARAMETERS                                                        CSE019
      *                                                                         CSE019
      * Return Code                                                             CSE019
     C                   Parm      *Blank        RetCodeOut                     CSE019
      *                                                                         CSE019
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CSE019
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CSE019
      *                                                                         CSE019
     C                   Parm      '*FRONT'      @@MODE            6            CSE019
      *                                                                         CSE019
      * Action Code                                                             CSE019
     C                   Parm                    DDACTN            1            CSE019
      *                                                                         CSE019
      * Trade Ref. Pointer                                                      CSE019
     C                   Parm                    DDTDRF            6            CSE019
      *                                                                         CSE019
      * Trade Front Office Pointer                                              CSE019
     C                   Parm                    DDFRNT                         CSE019
      *                                                                         CSE019
      * Read Forwards                                                           CSE019
     C                   Parm      'Y'           @RDFWD            1            CSE019
      *                                                                         CSE019
      * Read Backwards                                                          CSE019
     C                   Parm      *Blanks       @RDBCK            1            CSE019
      *                                                                         CSE019
      * OUTPUT PARAMETERS                                                       CSE019
      *                                                                         CSE019
      * Error message                                                           CSE019
     C                   Parm      *Blanks       @ERRMS            7            CSE019
      *                                                                         CSE019
      * Trade Ref. Read                                                         CSE019
     C                   Parm      *BlankS       @TRSEL            6            CSE019
      *                                                                         CSE019
      * Front Office Deal Read                                                  CSE019
     C                   Parm      *Blanks       @FTSEL           20            CSE019
      *                                                                         CSE019
      *** If next Front Office Id is blank (Treat like *EOF)                    CSE019
      *                                                                         CSE019
     C     @FTSEL        Ifeq      *Blanks                                      CSE019
     C     @TRSEL        Andeq     *Blanks                                      CSE019
     C                   Movel     '*EOF'        @ERRMS                         CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C     @ERRMS        Ifne      *Blanks                                      CSE019
     C                   Movel     *Blanks       @TRSEL                         CSE019
     C                   Else                                                   CSE019
     C                   Movel     @FTSEL        W2FRNT                         CSE019
     C     W1ORDE        Ifne      W2ORDE                                       CSE019
     C                   Movel     *Blanks       @TRSEL                         CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C                   Movel     @@OPSEL       @OPSEL                         CSE019
     C                   Endif                                                  CSE019
      *
      ** If Trade read from subfile is not blank
      *
     C     @TRSEL        IFNE      *BLANK
      *
      ** Retrieve Trade details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @TRSEL        DDTDRF
     C                   EXSR      RTVTRD
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
     C                   MOVEL     CT1AFilFmt    NT1AFilFmt
     C                   MOVEL     CT1BFilFmt    NT1BFilFmt
      *
      ** Convert Trade
      *
     C                   EXSR      CVTTRD
      *
      ** Put the trade on the SECONDARY screen if valid
      ** else put it on the BROWSE screen
      *
     C     Ix            IFEQ      *ZERO
     C                   Move      'N'           WWMSG             1            CSE019
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'W'           @SCRN
     C                   END
      *
      * Else, go to initial screen
      *
     C                   ELSE
     C     CommitReqd    IFEQ      'Y'
     C                   COMMIT
     C                   EXSR      INITIAL
     C                   GOTO      EndRDNBRW
      *
     C                   ELSE
      *
     C                   MOVE      'N'           @RDNB
     C                   MOVE      'N'           CommitReqd
     C                   MOVE      'D'           @SCRN
      *
     C                   END
      *
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/RTVTRD
      *****************************************************************
      *                                                               *
      * RTVTRD - Retrieve Trade                                       *
      *                                                               *
      * Called By: RDNBRW - Read Next Browsed Subfile Record.         *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     RTVTRD        BEGSR
      *
      ** Retrieve Trade
      *
     C                   CALLB     'SETRADRTV'
      *
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      *BLANK        @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM      *BLANK        FOTRID           20
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF
      * MT5XX - Phase 2 Message Generation is on.
     C                   PARM                    CSW003
      *                                                                                       CAP067
      * Buy-sell back                                                                         CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      * Trade Reference                                                                       CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      * OUTPUTS :
      * (Current) TRADE in file format
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
      *
      ** OK - Action code
      *
     C                   PARM      *BLANK        DDACTNOK
      *
      ** OK - Trade Reference
      *
     C                   PARM      *BLANK        DDTDRFOK
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
      *
     C                   PARM      *ZERO         Ix
      *
     C     EndRTVTRD     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/CVTTRD
      *****************************************************************
      *                                                               *
      * CVTTRD - Put A Trade on the Secondary Screen                  *
      *                                                               *
      * Called By: RDNBRW - Read Next Browsed Subfile Record.         *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     CVTTRD        BEGSR
      *
      ** Call program to fill screen fields with data from TRADSD
      *
     C                   CALLB     'SETRADCVT'
      *
      * INPUT PARAMETERS :
      * Return Code
      * TRADE in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
      ** Switchable features                                                                  222373
     C                   PARM                    CAS006                                       222373
      * Taxation of Savings Income                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      * OUTPUT PARAMETERS :
      * Trade - screen formats
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrThir                                    222373
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrSwftB
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
 
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CAP067
     C                   PARM                    DDSRNME                                      CAP067
     C                   PARM                    DDCRNM           20
      * Coupon Rate
      * Current Factor
      * Margin Amount
      * Portfolio Exchange Rate
      * Portfolio M/D Ind
      * Trade Countervalue
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX                                       222373
     C                   PARM                    DDPRICN                                      222373
      * SCREEN A
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      * SCREEN B
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
     C                   PARM                    DDFRNT                                    AR698195B
      *
      * Update 'Current' TRADE with TRADE in Screen Format
      *
     C                   MOVEL     NewTrPrim     CurTrPrim
     C                   MOVEL     NewTrSeco     CurTrSeco
     C                   MOVEL     NewTrExch     CurTrExch
     C                   MOVEL     NewTrSett     CurTrSett
     C                   MOVEL     NewTrChcm     CurTrChcm
     C                   MOVEL     NewTrSwftA    CurTrSwftA
     C                   MOVEL     NewTrSwftB    CurTrSwftB
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SCRN@ORD
      *****************************************************************
      *                                                               *
      * SCRN@ORD - Process Order Details Screen                       *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : ENDP       - Program Termination                   *
      *            VAL@ORD    - Validate Input in Order Details       *
      *                         Screen                                *
      *                                                               *
      *****************************************************************
     C     SCRN@ORD      BEGSR
      *
      ** Update Previous Screen
      *
     C                   MOVEL     NewTrPrim     PrvTrPrim
      *
     C     TradeProc     Ifeq      0                                            CSE019
     C     CSE019        Andeq     'Y'                                          CSE019
     C     DDACTNOK      Ifeq      'Y'                                          CSE019
     C     DDSTIDOK      Andeq     'Y'                                          CSE019
     C     DDDATEOK      Andeq     'Y'                                          CSE019
     C     DDORDEOK      Andeq     'Y'                                          CSE019
     C     DDREVWOK      Andeq     'Y'                                          CSE019
     C     WWMSG         Andeq     'Y'                                          CSE019
     C                   Move      'N'           OKORDE                         CSE019
     C                   Move      'N'           WWMSG                          CSE019
      *                                                                         CSE019
      ** Add error message to array passed to detail screen                     CSE019
      *                                                                         CSE019
     C                   Z-add     1             E                 3 0          CSE019
     C     *BLANK        Lookup    FldNameArr(E)                          99    CSE019
     C                   Movel     'DDORDE'      FldNameArr(E)                  CSE019
     C                   Movel     'SEW1028'     MsgIdArr(E)                    CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      *** Send number trades processed                                          CSE019
      *                                                                         CSE019
     C     TradeProc     Ifne      0                                            CSE019
     C     CSE019        Andeq     'Y'                                          CSE019
      *                                                                         CSE019
      ** Add error message to array passed to detail screen                     CSE019
      *                                                                         CSE019
     C                   Z-add     1             E                 3 0          CSE019
     C     *BLANK        Lookup    FldNameArr(E)                          99    CSE019
     C                   Movel     'DDORDE'      FldNameArr(E)                  CSE019
     C                   Movel     'SEW1027'     MsgIdArr(E)                    CSE019
     c                   Movel     TradeProc     MsgDtaArr(E)                   CSE019
     C                   Z-add     0             TradeProc         5 0          CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      ** Write and Read Order Detail Screen
      *
     C                   CALLB     'SETRADDDSP'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Order Number
      * Review Trade
      * Action Code OK
      * Order Number OK
      * Review Trade OK
      * Error fields array
      * Message Ids array
      * Message data array
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    @@OPSEL           1
     C                   PARM                    @@STID            2            CSE019
     C                   PARM                    @@DATE            6            CSE019
     C                   PARM                    @@ORDER           6
     C                   PARM                    @@REVW            1
     C                   PARM                    OKACTN            1
     C                   PARM                    OKSTID            1            CSE019
     C                   PARM                    OKDATE            1            CSE019
     C                   PARM                    OKORDE            1
     C                   PARM                    OKREVW            1
     C                   PARM                    CSE019            1            CSE019
     C                   PARM                    BVAUTH                                       189751
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * OUTPUT PARAMETERS :
      * Function Keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKE             1
      *
      ** If F3 or F12 is taken, end the program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndSCRN@ORD
     C                   ELSE
      *
      ** If F5 is not taken
      *
     C     @INKE         IFEQ      '0'
     C                   EXSR      VAL@ORD
     C                   ELSE
     C                   MOVE      *BLANKS       OKACTN
     C                   MOVE      *BLANKS       OKSTID                         CSE019
     C                   MOVE      *BLANKS       OKDATE                         CSE019
     C                   MOVE      *BLANKS       OKORDE
     C                   MOVE      *BLANKS       OKREVW
     C                   MOVE      *BLANKS       FldNameArr
     C                   MOVE      *BLANKS       MsgIdArr
     C                   MOVE      *BLANKS       MsgDtaArr
     C                   END
      *
     C                   END
      *
     C     EndSCRN@ORD   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/VAL@ORD
      *****************************************************************
      *                                                               *
      * VAL@ORD - Validate Input in Order Details Screen              *
      *                                                               *
      * Called By: SCRN@ORD   - Process Order Details Screen.         *
      *                                                               *
      * Calls    : RTVORD     - Retrieve Order Details                *
      *                                                               *
      *****************************************************************
     C     VAL@ORD       BEGSR
      *
      ** Prior to validation, initialise error indicators to 'OK'
      *
     C                   Z-ADD     *ZERO         Ix                3 0
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C                   Z-ADD     *ZERO         WIdx_EVALA        3 0
     C                   Z-ADD     *ZERO         WIdx_EVALB        3 0
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
      *
      ** Blank the following screen
      *
     C                   MOVEL     *BLANK        NewTrPrim
     C                   MOVEL     *BLANK        NewTrSeco
     C                   MOVEL     *BLANK        NewTrExch
     C                   MOVEL     *BLANK        NewTrSett
     C                   MOVEL     *BLANK        NewTrChcm
     C                   MOVEL     *BLANK        NewTrSwftA
     C                   MOVEL     *BLANK        NewTrSwftB
      *
      ** Retrieve the Trade
      *
     C                   EXSR      RTVORD
      *
      ** If primary fields are OK, set screen to BROWSE
      *
     C     DDACTNOK      IFEQ      'Y'
     C     DDSTIDOK      ANDEQ     'Y'                                          CSE019
     C     DDDATEOK      ANDEQ     'Y'                                          CSE019
     C     DDORDEOK      ANDEQ     'Y'
     C     DDREVWOK      ANDEQ     'Y'
     C                   Move      'Y'           WWMSG                          CSE019
     C                   MOVEL     'W'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/RTV@ORD
      *****************************************************************
      *                                                               *
      * RTVORD - Retrieve Order Details                               *
      *                                                               *
      * Called By: SCRN@ORD   - Process Order Details Sreen.          *
      *                                                               *
      * Calls    : RTVORD     - Retrieve Order Details                *
      *                                                               *
      *****************************************************************
     C     RTVORD        BEGSR
      *                                                                         CSE019
     C                   MOVE      *BLANKS       OKACTN                         CSE019
     C                   MOVE      *BLANKS       OKSTID                         CSE019
     C                   MOVE      *BLANKS       OKDATE                         CSE019
     C                   MOVE      *BLANKS       OKORDE                         CSE019
     C                   MOVE      *BLANKS       OKREVW                         CSE019
     C                   MOVE      *BLANKS       FldNameArr                     CSE019
     C                   MOVE      *BLANKS       MsgIdArr                       CSE019
     C                   MOVE      *BLANKS       MsgDtaArr                      CSE019
      *
      ** Retrieve the Trade
      *
     C                   CALLB     'SETRADORTV'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * System Id                                                               CSE019
      * Date of process                                                         CSE019
      * Order Number
      * Review Trade
      * CSE019 Feature                                                          CSE019
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM      @@OPSEL       DDACTN            1
     C                   PARM      @@STID        DDSTID            2            CSE019
     C                   PARM      @@DATE        DDDATE            6            CSE019
     C                   PARM      @@ORDER       DDORDE            6
     C                   PARM      @@REVW        DDREVW            1
     C                   PARM                    CSE019                         CSE019
      *
      * OUTPUT PARAMETERS :
      * Action Code OK
      * System Id OK                                                            CSE019
      * Date OK                                                                 CSE019
      * Order Number OK
      * Review Trade OK
      * Front Office Id                                                         CSE019
      * Error fields array
      * Message Ids array
      * Message data arrray
      * Array index
     C                   PARM      *BLANK        DDACTNOK
     C                   PARM      *BLANK        DDSTIDOK          1            CSE019
     C                   PARM      *BLANK        DDDATEOK          1            CSE019
     C                   PARM      *BLANK        DDORDEOK
     C                   PARM      *BLANK        DDREVWOK          1
     C                   PARM      *BLANK        DDFRNT           20            CSE019
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM      *ZERO         Ix
      *
     C                   MOVE      DDACTNOK      OKACTN
     C                   MOVE      DDSTIDOK      OKSTID                         CSE019
     C                   MOVE      DDDATEOK      OKDATE                         CSE019
     C                   MOVE      DDORDEOK      OKORDE
     C                   MOVE      DDREVWOK      OKREVW
     C                   MOVEL     DDFRNT        WWFRNT                         CSE019
     C                   MOVEL     DDFRNT        @FTSEL                         CSE019
     C                   MOVEL     DDREVW        @@REVW                         CSE019
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SCRN@S
      *****************************************************************
      *                                                               *
      * SCRN@S - Process Second Screen                                *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : CANC@S     - Cancel on Secondary Screen            *
      *            ENDP       - Program Termination                   *
      *            INITIAL    - Initialization Routine                *
      *            VAL@S      - Validation Input in Secondary Screen  *
      *                                                               *
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      ** Update previous screens and previous number warnings
      *
     C                   MOVE      *BLANKS       FldNameArr
     C                   MOVE      *BLANKS       MsgIdArr
     C                   MOVE      *BLANKS       MsgDtaArr
     C                   MOVEL     NewTrPrim     PrvTrPrim
     C                   MOVEL     NewTrSeco     PrvTrSeco
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn         3 0
      *
      ** Set F10 function key to Y for Action Code 'D'
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVE      'Y'           @EINKJ
     C                   ELSE
     C                   MOVE      'N'           @EINKJ
     C                   ENDIF
      *
      ** Write and read SECONDARY Screen
      *
     C                   MOVE      DDACTN        C_DDACTN
     C                   MOVE      EXORDE        DDORDE
     C                   CALLB     'SETRADSDSP'
      *
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Trade (IN SCREEN FORMAT - Primary / Secondary)
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CAP067
     C                   PARM                    DDSRNME                                      CAP067
     C                   PARM                    DDCRNM           20
      * Current Factor
      * Coupon Rate
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDCPNR           13
      *
      * Trade incomplete ind
     C                   PARM                    C_TINC
      *
      * Fields in error
     C                   PARM                    OKTrPrim
     C                   PARM                    OKTrSeco
      *
      ** Customer classification
     C                   PARM                    CustClass
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED Function Keys
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
      *                                                                                       CAP067
      * Protect book on second leg                                                            CAP067
     C                   PARM                    IN50              1                          CAP067
     C                   PARM                    TRDBK1            2                          CAP067
                                                                                              CGL031
      ** Switchable Feature                                                                   CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL             1                          CAP067
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'N'           @INKWDisp         1                          CSE039
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      ** If F3 is taken, end the program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndSCRN@S
     C                   END
      *
      ** If F5 is taken
      *
     C     @INKE         IFEQ      '1'
     C                   EXSR      INITIAL
     C                   GOTO      EndSCRN@S
     C                   END
      *
      ** If F12 is taken
      *
     C     @INKL         IFEQ      '1'
     C                   EXSR      CANC@S
     C                   ELSE
     C                   EXSR      VAL@S
     C                   END
      *
     C     EndSCRN@S     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/VAL@S
      *****************************************************************
      *                                                               *
      * VAL@S - Validation Input in Secondary Screen                  *
      *                                                               *
      * Called By: SCRN@S - Process Second Screen                     *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     VAL@S         BEGSR
      *
      ** If Action Code is D
      *
     C     DDACTN        IFEQ      'D'
      *
      ** If F10 is taken
      *
     C*****@ENDEL        IFEQ      '1'                                          CSE019
     C     @ENDEL        IFEQ      'Y'                                          CSE019
     C     @INKJ         OREQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   GOTO      EndVAL@S
     C                   ELSE
     C                   MOVEL     'W'           @SCRN
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDACTN        IFEQ      'E'
     C     DDACTN        OREQ      'P'
     C     DDACTN        OREQ      'Y'
     C                   MOVEL     'O'           @SCRN
     C                   GOTO      EndVAL@S
     C                   END
      *
     C                   END
      *
     C     EndVAL@S      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SCRN@O
      *****************************************************************
      *                                                               *
      * SCRN@O - Process Other Details Screen                         *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : CANC@O     - Cancel on Secondary Screen            *
      *            ENDP       - Program Termination                   *
      *            INITIAL    - Initialization Routine                *
      *            VAL@O      - Validation Input in Secondary Screen  *
      *                                                               *
      *****************************************************************
     C     SCRN@O        BEGSR
      *
      ** Update 'previous' screens and previous number of warnings
      *
     C                   MOVEL     NewTrExch     PrvTrExch
     C                   MOVEL     NewTrSett     PrvTrSett
     C                   MOVEL     NewTrChCm     PrvTrChCm
     C                   Z-ADD     WIdx_OVAL     PrvN_Warn         3 0
      *
      ** Pass clearance type from primary to other details screen
      *
     C                   MOVEL     C_DDCLTY      DDCLTY2
      *
      ** Write and read Other Details Screen
      *
     C                   CALLB     'SETRADODSP'
      *
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Trade (IN SCREEN FORMAT) - Primary/Secondary/Other Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
      *
      ** Current trade incomplete ind and date made complete
      *
     C                   PARM                    C_TINC
     C                   PARM                    C_TDMC
      *
      ** Customer classification, Customer PM (Y/N) and nominal currency
      *
     C                   PARM                    CustClass         1
     C                   PARM                    CustPM            1
     C                   PARM                    NMCY              3
     C                   PARM                    CustPB            1                          CAP067
      *                                                                                       CAP067
      ** Withholding tax                                                                      CAP067
      *                                                                                       CAP067
     C                   PARM                    DDWTAX           15                          CAP067
      * Fields in error
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChcm
      *
      ** Security report name
      ** Countervalue
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
      *
     C**********         PARM                    DDSRPN                                       CAP067
     C                   PARM                    DDSRNME          41                          CAP067
     C                   PARM                    DDTCTR
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
                                                                                              CGL031
      ** Switchable Feature                                                                   CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      ** OUTPUT PARAMETERS :
      *
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
      *
      ** If F3 is taken, end the program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndSCRN@O
     C                   END
      *
      ** If F5 is taken
      *
     C     @INKE         IFEQ      '1'
     C                   EXSR      INITIAL
     C                   GOTO      EndSCRN@O
     C                   END
      *
      ** If F12 is taken
      *
     C     @INKL         IFEQ      '1'
     C                   EXSR      CANC@O
     C                   ELSE
     C                   EXSR      VAL@O
     C                   END
      *
     C     EndSCRN@O     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/VAL@O
      *****************************************************************
      *                                                               *
      * VAL@O  - Validate input to Other Details Screen               *
      *                                                               *
      * Called By: SCRN@O     - Process Order Details Screen          *
      *                                                               *
      * Calls    : INITIAL    - Initialization Routine                *
      *                                                               *
      *****************************************************************
     C     VAL@O         BEGSR
      *
      ** If Action Code is ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      ** If MT5XX Message Generation not installed,
      *
     C     S01401        IFEQ      'N'
      *
      ** If Browse outstanding, read next Browse Subfile record
      ** Else, Go to Initial Screen
      *
   ??C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
      ** Else, go to Extension Swift Screen A
      *
     C                   ELSE
     C                   MOVEL     'A'           @SCRN
     C                   END
      *
     C                   ELSE
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
      *
      * If MT5XX Message Generation not installed, Go to Updates
      * Else, Go to EXTENSION (SWIFT) screen A
      *
     C     S01401        IFEQ      'N'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE
     C                   MOVEL     'A'           @SCRN
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SCRN@E_A
      *****************************************************************
      *                                                               *
      * SCRN@E_A - Process Extension (SWIFT) Screen A                 *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : CANC@E_A   - Cancel on Swift Screen A              *
      *            ENDP       - Program Termination                   *
      *            ExtSettA   - Cancel on Extended Settlement Screen A*
      *            INITIAL    - Initialization Routine                *
      *            VAL@E_A    - Validation Input to Swift Screen      *
      *                                                               *
      *****************************************************************
     C     SCRN@E_A      BEGSR
      *
      ** Check whether Screen B is required
      *
     C                   MOVE      'N'           Display_B         1
      *
      ** If MT5XX Phase 2 Message Generation, CSW003, is ON
      *
     C     CSW003        IFEQ      'Y'
      *
      ** If Customer Class is 'S'
      ** and Deliver To is not the same as Deliver From
      ** Or if Customer Class is 'D'
      ** and Deliver To is not the same as Deliver From
      ** Screen B should be displayed
      *
     C     CustClass     IFEQ      'S'
     C     DELT          ANDNE     DELF
     C     CustClass     OREQ      'D'
     C     DELT          ANDNE     DELF
     C                   MOVE      'Y'           Display_B
     C                   END
     C                   END
      *
      ** Update 'previous' screens and previous number of warnings
      *
     C                   MOVEL     NewTrSwftA    PrvTrSwft
     C                   Z-ADD     WIdx_EVALA    PrvN_Warn         3 0
      *
      ** Write and Read Extension Screen A screen
      *
     C                   CALLB     'SETRADEDSP'
      *
      ** INPUT PARAMETERS :
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Screen A/B
     C                   PARM      'A'           Screen            1
      *
      * Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrExts                                    222373
      *
      * Trade (file fields)
     C                   PARM                    TCNR
     C                   PARM                    TNMC
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       222373
      ** Process SE1806 flag                                                                  222373
     C                   PARM                    PUYAT             1                          222373
      *                                                                                       222373
      ** ISO15022 indicator in file                                                           222373
     C                   PARM                    T1NEW             1                          222373
      *                                                                                       222373
      ** Default SSI flag                                                                     222373
     C                   PARM                    DftFlag           1                          222373
      * Fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     222373
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Destination of Settlement Text fields
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
      * Destination of Confirmation Text fields
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      * Security report name
     C**********         PARM                    DDSRPN                                       CAP067
     C                   PARM                    DDSRNME          41                          CAP067
      * Swift 2001 flag                                                                       CAP067
     C                   PARM                    CSW201            1                          CAP067
     C                   PARM                    PCALL                                        222373
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      ** OUTPUT PARAMETERS :
      *
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
                                                                                              CSD015
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       222373
     C                   PARM                    NwSEFilFmt                                   222373
      *
      ** Reset error fields
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** If F3 is taken, end the program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndSCRN@E_A
     C                   END
      *
      ** If F5 is taken, go to Initial Screen
      *
     C     @INKE         IFEQ      '1'
     C                   EXSR      INITIAL
     C                   GOTO      EndSCRN@E_A
     C                   END
      *
      ** If F12 is taken, Cancel on Extension Screen A
      *
     C     @INKL         IFEQ      '1'
     C                   EXSR      CANC@E_A
     C                   GOTO      EndSCRN@E_A
     C                   END
      *
      ** If F14 is taken, return from F14 Extended Settlements A
      ** Else, Validate Input to Extension Screen A
      *
     C     @INKN         IFEQ      '1'
     C                   EXSR      ExtSettA
     C                   ELSE
     C                   EXSR      VAL@E_A
     C                   ENDIF
      *
     C     EndSCRN@E_A   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/VAL@E_A
      *****************************************************************
      *                                                               *
      * VAL@E_A - Validate Input to Extension Screen A                *
      *                                                               *
      * Called By: SCRN@E_A - Process Extension (SWIFT) Screen A      *
      *                                                               *
      * Calls    : INITIAL    - Initialization Routine                *
      *                                                               *
      *****************************************************************
     C     VAL@E_A       BEGSR
      *
      ** If Action Code is ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      ** If Screen B is not required
      *
     C     Display_B     IFNE      'Y'
      *
      ** If Browse outstanding, read next Browse Subfile record
      ** Else, Go To Initial screen
      *
   ??C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
      ** Else, Go to EXTENSION (SWIFT) screen B
      *
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
      ** Else, if Action Code is AUTHORIZE or APPROVE
      *
     C                   ELSE
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
      *
      ** If Screen B is not required, go to Update screen
      ** Else, go to Swift Screen B screen
      *
     C     Display_B     IFNE      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SCRN@E_B
      *****************************************************************
      *                                                               *
      * SCRN@E_B - Process Extension (SWIFT) Screen B                 *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : CANC@E_B   - Cancel on Swift Screen B              *
      *            ENDP       - Program Termination                   *
      *            ExtSettB   - Cancel on Extended Settlement Screen  *
      *            INITIAL    - Initialization Routine                *
      *            VAL@E_B    - Validation Input to Extension Screen B*
      *                                                               *
      *****************************************************************
     C     SCRN@E_B      BEGSR
      *
      ** Update 'previous' screens and previous number of warnings
      *
     C                   MOVEL     NewTrSwftB    PrvTrSwft
     C                   Z-ADD     WIdx_EVALB    PrvN_Warn         3 0
      *
      ** Write and read Swift Extension Screen B screen
      *
     C                   CALLB     'SETRADEDSP'
      *
      * INPUT PARAMETERS :
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Screen A/B
     C                   PARM      'B'           Screen
      *
      * Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftB
     C                   PARM                    NewTrExts                                    222373
      *
      * Trade (file fields)
     C                   PARM                    TCNR
     C                   PARM                    TNMC
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       222373
      ** Process SE1806 flag                                                                  222373
     C                   PARM                    PUYAT             1                          222373
      *                                                                                       222373
      ** ISO15022 indicator in file                                                           222373
     C                   PARM                    T1NEW             1                          222373
      *                                                                                       222373
      ** Default SSI flag                                                                     222373
     C                   PARM                    DftFlag           1                          222373
      * Fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     222373
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Destination of Settlement Text fields
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
      * Destination of Confirmation Text fields
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
      * Security report name
     C**********         PARM                    DDSRPN                                       CAP067
     C                   PARM                    DDSRNME          41                          CAP067
      * Swift 2001 flag                                                                       CAP067
     C                   PARM                    CSW201                                       CAP067
     C                   PARM                    PCALL                                        222373
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
                                                                                              CSD015
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       222373
     C                   PARM                    NwSEFilFmt                                   222373
      *
      ** Reset error fields
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** If F3 is taken, end the program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndSCRN@E_B
     C                   END
      *
      ** If F5 is taken, go to Initial Screen
      *
     C     @INKE         IFEQ      '1'
     C                   EXSR      INITIAL
     C                   GOTO      EndSCRN@E_B
     C                   END
      *
      ** If F12 is taken, Cancel on Extension Screen B
      *
     C     @INKL         IFEQ      '1'
     C                   EXSR      CANC@E_B
     C                   GOTO      EndSCRN@E_B
     C                   END
      *
      ** If F14 is taken, return from F14 Extended Settlements B
      ** Else, Validate Input to Extension Screen B
      *
     C     @INKN         IFEQ      '1'
     C                   EXSR      ExtSettB
     C                   ELSE
     C                   EXSR      VAL@E_B
     C                   END
      *
     C     EndSCRN@E_B   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/VAL@E_B
      *****************************************************************
      *                                                               *
      * VAL@E_B - Validate Input to Extension Screen B                *
      *                                                               *
      * Called By: SCRN@E_B   - Process Extension (SWIFT) Screen B    *
      *                                                               *
      * Calls    : INITIAL    - Initialization Routine                *
      *                                                               *
      *****************************************************************
     C     VAL@E_B       BEGSR
      *
      ** If Action Code is ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      ** If Browse outstanding, read next Browse Subfile record
      ** Else, Go To Initial screen
      *
   ??C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
      ** Else, if Action Code is AUTHORIZE or APPROVE
      ** Go to Update screen
      *
     C                   ELSE
     C     DDACTN        IFEQ      'P'
     C     DDACTN        OREQ      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SNDM@P
      *****************************************************************
      *                                                               *
      * SNDM@P - Send a message to Primary Details Screen             *
      *                                                               *
      * Called By: BLDBRW - Build Browse Subfile.                     *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      ** If single branching, user cannot browse the file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ** Trade reference on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMA0087'
     C                   MOVE      'N'           DDTDRFOK
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/CANC@W
      *****************************************************************
      *                                                               *
      * CANC@W - Cancel on Browse Screen                              *
      *                                                               *
      * Called By: BLDBRW - Build Browse Subfile.                     *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     CANC@W        BEGSR
      *
      ** Set screen to ORDER DETAILS
      *
     C                   MOVEL     'D'           @SCRN
      *
      ** Reset Read Next Browse Subfile Record field
      *
     C                   MOVEL     'N'           @RDNB
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/CANC@S
      *****************************************************************
      *                                                               *
      * CANC@S - Cancel on Secondary Screen                           *
      *                                                               *
      * Called By: SCRN@S - Process Second Screen.                    *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     CANC@S        BEGSR
      *
      ** Set screen to BROWSE
      *
     C                   MOVEL     'W'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/CANC@O
      *****************************************************************
      *                                                               *
      * CANC@O - Cancel on Other Details                              *
      *                                                               *
      * Called By: SCRN@O - Process Order Details Screen.             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     CANC@O        BEGSR
      *
      ** Set screen to SECONDARY
      *
     C                   MOVEL     'S'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/CANC@E_A
      *****************************************************************
      *                                                               *
      * CANC@E_A - Cancel on Swift Screen A                           *
      *                                                               *
      * Called By: SCRN@E_A - Process Extension (SWIFT) Screen A      *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     CANC@E_A      BEGSR
      *
      ** Set screen to Other Details
      *
     C                   MOVEL     'O'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/CANC@E_B
      *****************************************************************
      *                                                               *
      * CANC@E_B - Cancel on Swift Screen B                           *
      *                                                               *
      * Called By: SCRN@E_B - Process Extension (SWIFT) Screen B      *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     CANC@E_B      BEGSR
      *
      ** Set screen to Swift Screen A
      *
     C                   MOVEL     'A'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/ExtSettA
      *****************************************************************
      *                                                               *
      * ExtSettA - Cancel on Extended Settlement Screen A             *
      *                                                               *
      * Called By: SCRN@E_A - Process Extension (SWIFT) Screen A      *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
     C     ExtSettA      BEGSR
      *
      ** Set screen to Swift Screen A
      *
     C                   MOVEL     'A'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/ExtSettB
      *****************************************************************
      *                                                               *
      * ExtSettB - Cancel on Extended Settlement Screen B             *
      *                                                               *
      * Called By: SCRN@E_B - Process Extension (SWIFT) Screen B      *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     ExtSettB      BEGSR
      *
      ** Set screen to Swift Screen B
      *
     C                   MOVEL     'B'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/UPDATS
      *****************************************************************
      *                                                               *
      * UPDATS - Updates                                              *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : INITIAL    - Initialization Routine                *
      *                                                               *
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ** Update Trade Reference Field
      *
     C                   MOVEL     DDTDRF        TDRF
      *
      ** Update Change Type field
      *
     C                   MOVEL     DDACTN        CHTP
      *
      ** Update files
      *
     C                   CALLB     'SETRADUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwTrFilFmt
     C                   PARM                    NT1AFilFmt
     C                   PARM                    NT1BFilFmt
     C                   PARM                    S01401
     C                   PARM                    CSW003
                                                                                              CSD015
     C                   PARM                    CAP051                                       CSD015
     C                   PARM                    CAS006                                       222373
     C                   PARM                    CGL031                                       CGL031
     C                   PARM                    PMODE                                        222373
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    SEVTRDX2A                                    222373
     C                   PARM                    SEVTRDX2B                                    222373
      *
      ** If no errors occured in the Update functions,
      ** rollback any updates and go to Initial screen
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   ROLBK
     C                   EXSR      INITIAL
      *
      ** Else, Commit
      *
     C                   ELSE
     C                   MOVEL     'Y'           CommitReqd
     C                   ADD       1             TradeProc                      CSE019
      *
      ** If Read Next Browse Subfile Record is active
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
      *
      ** Else, go to Initial screen
      *
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/ENDP
      *****************************************************************
      *                                                               *
      * ENDP - Program Termination                                    *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : BLDBRW     - Build Browse Subfile                  *
      *            SCRN@E_A   - Process Extension Swift Screen A      *
      *            SCRN@E_B   - Process Extension Swift Screen B      *
      *            SCRN@O     - Process Other Details Screen          *
      *            SCRN@ORD   - Process Order Details Screen          *
      *            SCRN@S     - Process Second Screen                 *
      *                                                               *
      *****************************************************************
     C     ENDP          BEGSR
      *
      ** Set screen to Read Browse
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/SRERR
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls    : *INZSR    - Program Initialisation routine         *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
