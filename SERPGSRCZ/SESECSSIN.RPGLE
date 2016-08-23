     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities input')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSSIN - Securities Input                                 *
      *                                                               *
      *  Function: This is the main screen input function for         *
      *            Securities.                                        *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. LLN022A            Date 03Jun15               *
      *  Prev Amend No. LLN022             Date 03Jun15               *
      *                 AR996842           Date 11Feb13               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 237063             Date 20Nov05               *
      *                 232543             Date 29Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 220008             Date 28Jul03               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      *                 CGL018             Date 07Oct02               *
      *                 216368             Date 12Jun03               *
      *                 214351             Date 25Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CSE031             Date 19Nov01               *
      *                 CSE032             Date 03Jan02               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE029             Date 20Jul01               *
      *                 192054             Date 28Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060             Date 21May01               *
      *                 CSD006             Date 12Jan01               *
      *                 183604             Date 16Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Recompiled over changes in /COPY                    *
      *  AR996842 - Creation of new security details: Private Banking *
      *             Instrument type defaulting improvement            *
      *             (Child:AR996843)                                  *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  220008 - Securities input accepts country of tax which does  *
      *           not exist in SDWHTTPD. Fix is to add validation.    *
      *  CGL014 - Collaterals Processing                              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSE037 - Countervalue rounding                               *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CGL018 - Risk Weighted Assets                                *
      *  216368 - DBErr occurs when enquiring a matured security with *
      *           already deleted issuer.  Fix is to bypass dberr and *
      *           display warning message indicating that issuer or   *
      *           lead manager details could no longer be found in    *
      *           the customer details file.                          *
      *  214351 - Name Change (NC) details not defaulted with API     *
      *           SECS.  Pass values from data structure PParOther to *
      *           SESECSCVT if PParOther is not equal to blanks.      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CSE032 - Recompile over recompiled SESECS2VL.                *
      *  193883 - Recompile over changed SESECSUPD.                   *
      *  CSE029 - ISO15022 Message Generation (recompile)             *
      *  192054 - ISIN code must be available if Private banking is on*
      *  CAP060 - Midas APIs Sec Prices                               *
      *  CSD006 - Market Data Feed                                    *
      *  183604 - Industry Code and Market Center must be mandatory   *
      *           when new PB Module is switched ON. Rating Code      *
      *           must be validated against new table PBRATIPD when   *
      *           new PB Module is switched ON.                       *
      *  CSE023 - Treaty Withholding Tax                              *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESECS001
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
      **    True       logical = *ON (for indicator processing)
      **    False      logical = *OFF (for indicator processing)
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
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
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
      *
      ** Securities for file update- file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
     D NwSEFilFmt1             1    899                                                       CSE065
      *
      ** Security details for file update- file format
     D NwSEFilFmtOld E DS                  EXTNAME(SEVSECSPD)
     D                                     PREFIX(O)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
     D CrSEFilFmt1             1    899                                                       CSE065
      *
      ** Security screen 1 details from incoming transaction - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Security screen 2 details from incoming transaction - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Security screen 3 details from incoming transaction - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *                                                                                       CSE031
      ** Security screen 4 details from incoming transaction - screen format                  CSE031
     D NwSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)                                  CSE031
                                                                                              CAS006
      ** Security Screen 5 Details From Incoming Transaction - Screen Format                  CAS006
     D NwSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)                                  CAS006
      *                                                                                       237063
      ** Security screen 6 details from incoming transaction - screen format                  237063
     D NwSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  237063
      *
      ** Security screen 1 details retrieved from file - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O:1)
      *
      ** Security screen 2 details retrieved from file - screen format
     D CrSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(O:1)
      *
      ** Security screen 3 details retrieved from file - screen format
     D CrSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
     D                                     PREFIX(O:1)
      *                                                                                       CSE031
      ** Security screen 4 details retrieved from file - screen format                        CSE031
     D CrSE4ScnFmt   E DS                  EXTNAME(SESEC4PD)                                  CSE031
     D                                     PREFIX(O:1)                                        CSE031
                                                                                              CAS006
      ** Security Screen 5 Details Retrieved From File - Screen Format                        CAS006
     D CrSE5ScnFmt   E DS                  EXTNAME(SESEC5PD)                                  CAS006
     D                                     PREFIX(O:1)                                        CAS006
      *                                                                                       237063
      ** Security Screen 6 Details Retrieved From File - Screen Format                        237063
     D CrSE6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  237063
     D                                     PREFIX(O:1)                                        237063
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** Securities screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
      *                                                                                       CSE031
      ** Securities screen 4 error indicators                                                 CSE031
     D SEESEC4       E DS                  EXTNAME(SEESEC4PD)                                 CSE031
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     D SEESEC5       E DS                  EXTNAME(SEESEC5PD)                                 CAS006
      *
      ** Securities extra data
     D PExtData      E DS                  EXTNAME(SESEEXPD)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Externally described DS for investment types
     D PINVTP        E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Passed other information
     D POthInf         DS           156
      *
      ** DS of fields for output only
     D POutFlds        DS
     D  WCSNM1                       10A
     D  WCSNM2                       10A
     D  WCSNM3                       10A
     D  WMKTN                        20A
     D  WSTBS                         1A
      *
      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10A
     D  PDBRN                 11     13A
     D  PDPPT                 14     16A
      *
      ** Data structure for key fields and key selections
     D KeyLists        DS
     D  WDSESN                 1     10A
     D  WDSRPN                11     30A
 
     D KeySelect       DS
     D  WDISSR                 1      6A
     D  WDNMCY                 7      9A
     D  WDSITP                10     12A
     D  WDPRTP                13     13A
     D  WDINCS                14     14A
     D  WDISIN                15     26A
     D  WDT2RF                27     38A
     D  WDSTAT                39     48A
                                                                                              CSC011
      ** 24x7 Status Data Area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data Area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter and work variable declarations
     D PParmLink       S              1A
     D PParmActn       S              1A
     D PParmRtcd       S              7A
     D PParmSESN       S             10A
     D PParOSESN       S             10A
     D PParOther       S            156A
 
     D POpSel          S              1A
     D PErrMS          S              7A
     D PSESNSel        S             10A
 
     D PEDtFld         S              1A
     D PEKyFld         S              1A
     D PResetFld       S              1A
 
     D PRdNb           S              1A
     D PSARd           S              6A
     D PRtcd           S              7A
     D POptn           S              7A
     D PMktN           S             20A
     D PSesn           S             10A                                                     CGL018
 
     D PKey            S              2A   INZ(*BLANKS)                         CSE023
     D PPgm            S             10A   INZ('SESECSSIN')                     CSE023
     D PAction         S              1A                                        CSE023
     D PSpareW         S            256A   INZ(*BLANKS)                         CSE023
                                                                                CSE023
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
 
     D PNCD            S              6A
     D PLCPN           S              6A
     D PNMDP           S              1P 0
     D PVLDP           S              1P 0
 
     D PPrCpn          S              1A
     D PAmendOk        S              1A
 
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKF           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKI           S              1A                                                      CSE031
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
     D PEINKE          S              1A
     D PEINKF          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKI          S              1A                                                      CSE031
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
 
     D CSE005          S              1A
     D CSE007          S              1A
     D CSE011          S              1A
     D CEU017          S              1A
     D CEU018          S              1A
     D S01401          S              1A
     D S01511          S              1A
     D CSE023          S              1A                                        CSE023
     D CSE031          S              1A                                                      CSE031
     D CGL032          S              1A                                                      CGL032
     D CGL031          S              1A                                                      CGL031
     D CSE071          S              1A                                                      237063
 
     D WScrn           S              1A
     D WOScrn          S              1A                                        CSE023
 
     D WRats           S              1A   INZ(*BLANK)
      *
      ** Redisplay screen flag and indicator
     D PReDsp          S              1A
     D WReDisplay      S              1A   INZ(*BLANK)
      *
      ** Process old security details indicator
     D PPOldSecDtl     S              1A   INZ(*BLANK)
      *
      ** Index for arrays of error message IDs
     D IdX             S              3P 0
      *
      ** Index for arrays of warning messages
     D Ex              S              3P 0
     D WiX             S              3P 0
     D WIdX            S              3P 0
     D WPrvIdX         S              3P 0
     D WCurIdX         S              3P 0
      *
     D WISSA1          S             11P 0
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     D PMode           S              6A   INZ('*SIN  ')
      *
      ** Response mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for synchronous.
     D PRespMode       S              1A   INZ('S')
 
     D* Midas APIs Sec Prices                                                                 CAP060
     D CAP060          S              1A                                                      CAP060
                                                                                              CAP060
     D* Market Data Feed                                                                      CSD006
     D CSD006          S              1A                                                      CSD006
                                                                                              CSD006
     D* Risk Weighted Assets                                                                  CGL018
     D CGL018          S              1A   INZ('N')                                           CGL018
                                                                                              CSD006
     D CSC011          S              1A                                                      CSC011
     D CAS006          S              1A   INZ('N')                                           CAS006
     D WkDate          S              5  0                                                    CSC011
     D WkNext          S              5  0                                                    CSC011
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                              CSE037
      ** Countervalue rounding                                                                CSE037
     D CSE037          S              1A                                                      CSE037
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
      *
     D CSE065          S              1A   INZ('N')                                           CSE065
     D W#MATY          S              6  0                                                    CSE065
     D WDateUsa        S               d   datfmt(*usa)                                       CSE065
     D WDateEur        S               d   datfmt(*eur)                                       CSE065
     D WDateVar        S              8  0                                                    CSE065
      *                                                                                       CSE065
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      /COPY QWINDSRC,SESECSDTA
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESECS002
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
      /COPY WNCPYSRC,SESECS003
      *
      ** Read next browse subfile record.
      *
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdnBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,SESECS004
      *
      ** DO WHILE screen: level 1 screen initial details only.
      *
     C                   DOW       WScrn = 'I'
     C                   EXSR      SRScrn_I
     C                   ENDDO
 
      /COPY WNCPYSRC,SESECS005
      *
      ** DO WHILE screen: level 1 screen details.
      *
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRScrn_P
     C                   ENDDO
 
      /COPY WNCPYSRC,SESECS006
      *
      ** DO WHILE screen: level 2 screen details.
      *
     C                   DOW       WScrn = 'S'
     C                   EXSR      SRScrn_S
     C                   ENDDO
                                                                                              CAS006
      ** DO WHILE screen: Level 5 Screen Details.                                             CAS006
                                                                                              CAS006
     C                   DOW       WScrn = 'H'                                                CAS006
     C                   EXSR      SRScrn_H                                                   CAS006
     C                   ENDDO                                                                CAS006
 
      /COPY WNCPYSRC,SESECS007
      *                                                                                       CSE031
      ** DO WHILE screen: level 4 screen details.                                             CSE031
      *                                                                                       CSE031
     C                   DOW       WScrn = 'G'                                                CSE031
     C                   EXSR      SRScrn_G                                                   CSE031
     C                   ENDDO                                                                CSE031
      *
      ** DO WHILE screen: level 3 screen details.
      *
     C                   DOW       WScrn = 'T'
                                                                                              CSE065
      ** Process defaulting of 3rd screen details before going to 3rd screen.                 CSE065
                                                                                              CSE065
     C                   EXSR      SRDefScn3                                                  CSE065
                                                                                              CSE065
     C                   EXSR      SRScrn_T
     C                   ENDDO
 
      /COPY WNCPYSRC,SESECS013                                                  CSE023
      *                                                                         CSE023
      ** If BOE installed  move required fields into fields to be passed to window.          LLN022A
      *                                                                                      LLN022A
     C                   If        LLN022 = 'Y'                                              LLN022A
     C                   Movel     DDSESN        BYSESN                                      LLN022A
     C                   Endif                                                               LLN022A
                                                                                             LLN022A
      ** Screen: Window processing.                                             CSE023
      *                                                                         CSE023
     C                   IF        WScrn = 'W'                                  CSE023
     C                   EXSR      SRWindow                                     CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
      /COPY WNCPYSRC,SESECS008
      *
      ** Screen: confirmation details.
      *
     C                   IF        WScrn = 'F'
     C                   EXSR      SRScrn_F
     C                   ENDIF
 
      /COPY WNCPYSRC,SESECS009
      *
      ** Do file update.
      *
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      /COPY WNCPYSRC,SESECS010
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      *                                                                                       CGL018
      ** Screen: RWA Processing                                                               CGL018
      *                                                                                       CGL018
     C                   IF        WScrn = 'Z'                                                CGL018
     C                   EXSR      SRScrn_Z                                                   CGL018
     C                   ENDIF                                                                CGL018
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SESECS011
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_I - Process screen 1 initial details only             *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_I      BEGSR
      *
      ** Securities maintenance has been called by linked
      ** maintenance/enquiry.
      *
     C                   IF        PParmLink = 'Y'
      *
      ** Protect screen fields if necessary and disable function keys
      ** accordingly.
      *
     C                   IF        PParmActn = 'I' or PParmActn = 'A'
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEINKE  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
 
     C                   IF        PParmActn = 'I' OR DDACTN = *BLANK
     C                   EVAL      PEKyFld = 'Y'
     C                   ELSE
     C                   EVAL      PEKyFld = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEKyFld = 'N'
     C                   EVAL      PEINKE  = 'N'
     C                   EVAL      PEINKL  = 'N'
     C                   ENDIF
 
     C                   EVAL      PEINKG  = 'N'
     C                   EVAL      PEINKH  = 'N'
     C                   EVAL      PEINKP  = 'N'
 
     C                   ELSE
      *
      ** Enable all fields on the initial screen as well as all function
      ** keys.
      *
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEKyFld = 'Y'
     C                   EVAL      PEINKE  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKJ  = 'N'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
 
     C                   ENDIF
 
      *
      ** Process 1st screen.
      *
     C                   CALLB     'SESECS1DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Security 1st screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Enable detail fields indicator
      ** Enable key fields indicator
     C                   PARM                    PEDtFld
     C                   PARM                    PEKyFld
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KJ = command key 10 = Delete
      ** KL = Command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** Security 1st screen error indicators
     C                   PARM                    SEESEC1
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - system run date
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - plato interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU securities decimals on nominals
     C                   PARM                    CEU018
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *
      ** Market Data Feed on?
     C                   PARM                    CSD006                                       CSD006
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KJ = command key 10 = Delete
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh screen 1 initial details.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwSE1ScnFmt = CrSE1ScnFmt
      *
      ** F7 - roll backwards.
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
      *
      ** F8 - roll forwards.
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
      *
      ** F12 - cancel on initial screen.
     C                   WHEN      PINKL = *ON
      *
      ** Display initial screen with blank fields.
      ** Reset read next browse subfile record indicator.
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
     C                   EVAL      WRats = *BLANK
     C                   EVAL      PRdNb = *BLANK
      *
      ** F15 - build browse.
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRSetupKey
     C                   EXSR      SRClearScn
     C                   EXSR      SRBldBrw
      *
      ** Enter key was pressed.  Validate input to initial screen.
     C                   OTHER
      *
      ** Validate input to level 1 screen.
     C                   EXSR      SRVal_I
 
     C                   ENDSL
 
     C     ESRScrn_I     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_I - Validate input to initial details screen           *
      *                                                               *
      *****************************************************************
 
     C     SRVal_I       BEGSR
      *
      ** Validate key fields and retrieve security details.
      *
     C                   EXSR      SRRtvSESN
      *
      ** Errors occurred during retrieval of security details,
      ** and/or in the validation of initial key fields.
      *
     C                   IF        IdX <> 0
     C                   GOTO      ESRVal_I
     C                   ENDIF
      *
      ** Move security details retrieved from the master
      ** database file into the update file record.  If no
      ** record has been retrieved (like in insert), fields
      ** contain initial values.
      *
     C**********         EVAL      NwSEFilFmt = CrSEFilFmt                                    CSE065
     C                   EVAL      NwSEFilFmt1 = CrSEFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     ALDT          S1ALDT                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S1ALDT                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** If action code is not insert, or from link processing and
      ** PPOldSecDtl indicator is true , put the securities details
      ** on the primary screen.
      *
     C                   IF        DDACTN <> 'I' OR PParmLink = 'Y'
     C                             AND PPOldSecDtl = 'Y' AND WRats = *BLANK
 
      ** Name Change - Change other values of the old security aside                          214351
      ** from security shortname if other fields in Corporate Action                          214351
      ** Maintenance are not left blank.                                                      214351
      *                                                                                       214351
     C                   IF        PParOther <> *BLANKS                                       214351
     C                   EVAL      POthInf = PParOther                                        214351
     C                   ENDIF                                                                214351
                                                                                              214351
     C                   EXSR      SRPutSec
 
     C                   ENDIF
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended (do not reset fields, this should be done
      ** on the primary screen validation).
      *
     C                   IF        DDACTN = 'A'
 
     C                   CALLB     'SESECS1MD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities Screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Processing type - from file INVTPD
     C                   PARM                    PPROT
      *
      ** Reset of fields in error required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Midas-Plato Interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities Decimals on Nominals
     C                   PARM                    CEU018
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Securities Screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
 
     C                   ENDIF
 
     C                   IF        DDACTN = 'I'
 
     C                   CALLB     'SESECS1VL'
      *                             =========
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** Decimals on nominals
     C                   PARM                    CEU018
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *
      ** Market migration
     C                   PARM                    S01511
      *                                                                                       CSD006
      ** Market Data Feed                                                                     CSD006
     C                   PARM                    CSD006                                       CSD006
      *                                                                                       CAP060
      ** Midas APIs Sec Prices                                                                CAP060
     C                   PARM                    CAP060                                       CAP060
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdX
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Externally described DS for investment types - output parameter
     C                   PARM                    PINVTP
      *
      ** Nominal currency's no. of decimal places
     C                   PARM                    PNMDP
      *
      ** Value currency's no. of decimal places
     C                   PARM                    PVLDP
      *
      ** Redisplay screen indicator
     C                   PARM      'N'           PReDsp
 
     C                   ENDIF
      *
      ** Process level 1 screen.
      *
     C                   EVAL      WScrn = 'P'
 
     C     ESRVal_I      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_P - Process screen 1                                  *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_P      BEGSR
      *
      ** Protect screen fields if necessary and disable function keys
      ** accordingly.
      *
     C                   IF        PParmLink = 'Y'
     C                   EVAL      PEINKG  = 'N'
     C                   EVAL      PEINKH  = 'N'
     C                   EVAL      PEINKP  = 'N'
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEINKE  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEINKE  = 'N'
     C                   EVAL      PEINKL  = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEINKE  = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEINKE  = 'N'
     C                   ENDIF
 
     C                   IF        DDACTN = 'D' AND IdX = 0
     C                   EVAL      PEINKJ  = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ  = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      PEKyFld = 'N'
      *
      ** Process defaulting of 1st screen details before going to 1st screen.
      *
     C                   EXSR      SRDefScn1
      *
      ** Process 1st screen.
      *
     C                   CALLB     'SESECS1DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Security 1st screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Enable detail fields indicator
      ** Enable key fields indicator
     C                   PARM                    PEDtFld
     C                   PARM                    PEKyFld
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KJ = command key 10 = Delete
      ** KL = Command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** Security 1st screen error indicators
     C                   PARM                    SEESEC1
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - system run date
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - plato interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU securities decimals on nominals
     C                   PARM                    CEU018
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *
      ** Market Data Feed on?
     C                   PARM                    CSD006                                       CSD006
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KJ = command key 10 = Delete
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *
      ** Save warning message ids array of 1st screen.
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh screen 1 (primary screen).
     C                   WHEN      PINKE = *ON
     C                   IF        DDACTN = 'I'
     C                   EVAL      WScrn = 'I'
     C                   ELSE
     C                   EVAL      WScrn = 'P'
     C                   ENDIF
     C                   EVAL      WRats = 'N'
     C                   EVAL      NwSE1ScnFmt = CrSE1ScnFmt
      *
      ** F7 - roll backwards.
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
      *
      ** F8 - roll forwards.
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
      *
      ** F10 - delete.
     C                   WHEN      PINKJ = *ON
     C                   EVAL      WScrn = 'U'
      *
      ** F12 - cancel on primary screen.
     C                   WHEN      PINKL = *ON
      *                                                                         CGL018
      ** Rollback any changes made by lower level programs                      CGL018
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK                                                  CGL018
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *
      ** Display initial screen with blank fields.
      ** Reset read next browse subfile record indicator.
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
     C                   EVAL      WRats = *BLANK
     C                   EVAL      PRdNb = *BLANK
      *
      ** F15 - build browse.
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRClearScn
     C                   EXSR      SRBldBrw
      *
      ** Enter key was pressed.  Validate input to initial screen.
     C                   OTHER
      *
      ** If Action is Insert or Amend, validate input to
      ** Level 1 screen.
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EXSR      SRVal_P
     C                   GOTO      ESRScrn_P
     C                   ENDIF
      *
      ** Action is Enquire.
     C                   IF        DDACTN = 'E'
 
     C                   EVAL      WScrn = 'S'
      *
      ** Process defaulting of 2nd screen details before going to 2nd screen.
     C                   EXSR      SRDefScn2
 
     C                   ENDIF
 
     C                   ENDSL
 
     C     ESRScrn_P     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScn1 - Default fields in 1st screen                     *
      *                                                               *
      *****************************************************************
 
     C     SRDefScn1     BEGSR
 
     C                   CALLB     'SESECS1DT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    PINVTP
      *
      ** Redisplay screen indicator
     C                   PARM                    PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt
 
     C     ESRDefScn1    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_P - Validate input to primary details screen           *
      *                                                               *
      *****************************************************************
 
     C     SRVal_P       BEGSR
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended.
      *
     C                   IF        DDACTN = 'A'
 
     C                   CALLB     'SESECS1MD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities Screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Processing type - from file INVTPD
     C                   PARM                    PPROT
      *
      ** Reset of fields in error required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Midas-Plato Interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU Securities Decimals on Nominals
     C                   PARM                    CEU018
      *
      ** MT5xx Message Generation
     C                   PARM                    S01401
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** EMU Securities Redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Securities Screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
 
     C                   ENDIF
 
     C                   CALLB     'SESECS1VL'
      *                             =========
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** Decimals on nominals
     C                   PARM                    CEU018
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *
      ** Market migration
     C                   PARM                    S01511
      *                                                                                       CSD006
      ** Market Data Feed                                                                     CSD006
     C                   PARM                    CSD006                                       CSD006
      *                                                                                       CAP060
      ** Midas APIs Sec Prices                                                                CAP060
     C                   PARM                    CAP060                                       CAP060
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdX
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Externally described DS for investment types - output parameter
     C                   PARM                    PINVTP
      *
      ** Nominal currency's no. of decimal places
     C                   PARM                    PNMDP
      *
      ** Value currency's no. of decimal places
     C                   PARM                    PVLDP
      *
      ** Redisplay screen indicator
     C                   PARM      'N'           PReDsp
 
     C                   EVAL      WRedisplay = *BLANK
      *
      ** If no errors occurred during validation of fields on Level 1
      ** screen, check if there are warnings which have not been
      ** displayed yet.
      *
     C                   IF        IdX = 0
 
     C                   Z-ADD     1             WiX
 
     C                   DOW       WiX <= WIdX AND WRedisplay = *BLANK
 
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WiX = WiX + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redisplay Level 1 screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IdX <> 0 OR WRedisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      ESRVal_P
     C                   ENDIF
 
     C                   EVAL      WScrn = 'S'
      *
      ** Process defaulting of 2nd screen details before going to 2nd screen.
      *
     C                   EXSR      SRDefScn2
 
     C     ESRVal_P      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_S - Process screen 2                                  *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_S      BEGSR
      *
      ** Protect screen fields if necessary and disable function keys
      ** accordingly.
      *
     C                   IF        PParmLink = 'Y'
     C                   EVAL      PEINKF  = 'N'
     C                   EVAL      PEINKG  = 'N'
     C                   EVAL      PEINKH  = 'N'
     C                   EVAL      PEINKI  = 'N'                                              CSE031
     C                   EVAL      PEINKP  = 'N'
     C                   ELSE
     C                   EVAL      PEINKF  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
      *                                                                                       CSE031
      ** Only enable F9 (Additional Information) if CSE031 is ON and                          CSE031
      ** the processing type is 3 or 8.                                                       CSE031
      *                                                                                       CSE031
     C                   IF        CSE031  = 'Y'                                              CSE031
     C                   IF        PPROT = '3' OR PPROT = '8'                                 CSE031
     C                   EVAL      PEINKI  = 'Y'                                              CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      PEINKI  = 'N'                                              CSE031
     C                   ENDIF                                                                CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDIF
 
     C                   EVAL      PEINKL  = 'Y'
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEINKE  = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEINKE  = 'N'
     C                   ENDIF
      *
      ** Process 2nd screen.
      *
     C                   CALLB     'SESECS2DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Security 2nd screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Externally described DS for investment types
     C                   PARM                    PINVTP
      *
      ** Fields for display only
     C                   PARM                    POutFlds
      *
      ** Last coupon date
     C                   PARM                    PLCPN
      *
      ** Next coupon date
     C                   PARM                    PNCD
      *
      ** Enable detail fields indicator
     C                   PARM                    PEDtFld
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KF = Command Key 06 = Initial screen
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KL = Command key 12 = Cancel
      ** KP = command key 15 = Browse
      ** KI = Command Key 09 = Additional Information                                         CSE031
     C                   PARM                    PEINKE
     C                   PARM                    PEINKF
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
     C                   PARM                    PEINKI                                       CSE031
      *
      ** Security 2nd screen error indicators
     C                   PARM                    SEESEC2
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - system run date
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - risk manangement
     C                   PARM                    BGRKMG
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on frn coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** EMU securities redenomination
     C                   PARM                    CEU017
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KF = Command Key 06 = Initial screen
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
      ** KI = Command Key 09 = Additional Information                                         CSE031
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKF
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKI                                        CSE031
      *
      ** Save warning message ids array of 2nd screen.
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh screen 2.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwSE2ScnFmt = CrSE2ScnFmt
     C                   EXSR      SRDefScn2
      *
      ** F6 - initial screen.
     C                   WHEN      PINKF = *ON
      *
      ** Redisplay Initial screen with blank screen fields.
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
      *
      ** F7 - roll backwards.
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
      *
      ** F8 - roll forwards.
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
      *                                                                                       CSE031
      ** F9 - Additional Information - Display 4th Screen.                                    CSE031
     C                   WHEN      PINKI = *ON                                                CSE031
      *                                                                                       CSE031
     C                   EVAL      NwSeFilFmtOld = NwSEFilFmt                                 CSE031
     C                   EVAL      WScrn = 'G'                                                CSE031
      *
      ** F12 - cancel on 2nd screen.
     C                   WHEN      PINKL = *ON
      *
      ** Refresh and redisplay screen 1.
     C                   EVAL      WScrn = 'P'
      *
      ** F15 - build browse.
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRClearScn
     C                   EXSR      SRBldBrw
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** If Action is Insert or Amend, validate input to
      ** Level 2 screen.
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EXSR      SRVal_S
     C                   GOTO      ESRScrn_S
     C                   ENDIF
                                                                                              CAS006
      ** Display the 5th Screen.                                                              CAS006
                                                                                              CAS006
     C                   EVAL      WScrn = 'H'                                                CAS006
      *
      ***Action*is*enquire*and*security*is*a*new*issue*or*private*banking                     CAS006
      ***is*installed,*display*3rd*screen.*Otherwise,*display*initial*screen                  CAS006
      ***with*blank*details.*******************************************                       CAS006
     C**********         IF        DDACTN = 'E' AND DDNISS = 'Y' OR                           CAS006
     C**********                   DDACTN = 'E' AND BGN4ST = 'Y'                              CAS006
 
     C**********         EVAL      WScrn  = 'T'                                               CAS006
 
     C**********         ELSE                                                                 CAS006
      *                                                                                       CAS006
      *---------------------------------------------------------------*                       CAS006
      *  NOTE: CGL018 was integrated into the Midas R5 Base Source    *                       CAS006
      *  prior to CAS006 precollection. The following block was       *                       CAS006
      *  moved to reflect correct processing.                         *                       CAS006
      *---------------------------------------------------------------*                       CAS006
      *                                                                         CSE023
      ***If*Risk*Weighted*Assets*is*on*and*Action*is*Enquire***********                CGL018 CAS006
      *                                                                                      CGL018
     C**********         IF        (CGL018 = 'Y')  AND                                 CGL018 CAS006
     C**********                   (DDACTN = 'E')                                      CGL018 CAS006
     C**********         EVAL      WOScrn = WScrn                                      CGL018 CAS006
     C**********         EVAL      WScrn  = 'Z'                                        CGL018 CAS006
     C**********         GOTO      ESRScrn_S                                           CGL018 CAS006
     C**********         ENDIF                                                         CGL018 CAS006
      ***Windows*2000*processing.**************************************                CSE023 CAS006
     C**********         IF        BGWDPR = 'Y'                                        CSE023 CAS006
     C**********         EVAL      WOScrn = WScrn                                      CSE023 CAS006
     C**********         EVAL      WScrn = 'W'                                         CSE023 CAS006
     C**********         GOTO      ESRScrn_S                                           CSE023 CAS006
     C**********         ENDIF                                                         CSE023 CAS006
      *
      ***If*securities*maintenance*has*been*called*by*linked***********                       CAS006
      ***maintenance/enquiry,*terminate*program.***********************                       CAS006
     C**********         IF        PParmLink = 'Y'                                            CAS006
     C**********         EVAL      PParmRtcd = *BLANK                                         CAS006
     C**********         EVAL      WScrn = 'E'                                                CAS006
     C**********         GOTO      ESRScrn_S                                                  CAS006
     C**********         ENDIF                                                                CAS006
      *
      ***Read*Next*Browse*Subfile*record.******************************                       CAS006
     C**********         IF        PRdNb = 'Y'                                                CAS006
     C**********         EVAL      WScrn = 'R'                                                CAS006
     C**********         GOTO      ESRScrn_S                                                  CAS006
     C**********         ENDIF                                                                CAS006
      *
      ***Redisplay*Initial*screen*with*blank*screen*fields.************                       CAS006
     C**********         EXSR      SRClearScn                                                 CAS006
     C**********         EVAL      WScrn = 'I'                                                CAS006
     C**********         ENDIF                                                                CAS006
 
     C                   ENDSL
 
     C     ESRScrn_S     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_S - Validate input to level 2 screen                   *
      *                                                               *
      *****************************************************************
 
     C     SRVal_S       BEGSR
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended.
      *
     C                   IF        DDACTN = 'A'
 
     C                   CALLB     'SESECS2MD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities Screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** Securities retrieved from file -  file format
     C                   PARM                    CrSEFilFmt
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Processing type - from file INVTPD
     C                   PARM                    PPROT
      *
      ** Reset of fields in error required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - risk management
     C                   PARM                    BGRKMG
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** EMU securities redenomination
     C                   PARM                    CEU017
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       237063
      ** Multiple Holidays                                                                    237063
     C                   PARM                    CSE071                                       237063
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Securities Screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** OK amendments field
     C                   PARM                    PAmendOK
      *
      ** Protect Coupon Rate/Inds Indicator
     C                   PARM                    PPrCpn
 
     C                   ENDIF
 
     C                   CALLB     'SESECS2VL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Security screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *                                                                                       237063
      ** Securities screen 6 details from incoming transaction                                237063
      ** - screen format                                                                      237063
     C                   PARM                    NwSE6ScnFmt                                  237063
      *                                                                                       237063
      ** Securities screen 6 details retrieved from file                                      237063
      ** - screen format                                                                      237063
     C                   PARM                    CrSE6ScnFmt                                  237063
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Processing type - from file INVTPD
     C                   PARM                    PPROT
      *
      ** Settlement depot customer 1
     C                   PARM                    PSDC1
      *
      ** Settlement depot customer 2
     C                   PARM                    PSDC2
      *
      ** Settlement depot customer 3
     C                   PARM                    PSDC3
      *
      ** Protect coupon rate/days
     C                   PARM                    PPrCpn
      *
      ** Nominal currency's decimal places
     C                   PARM                    PNmDp
      *
      ** Value currency's decimal places
     C                   PARM                    PVlDp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run day number
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WkDate                                       CSC011
      *
      ** SDBANK - date of next working day
     C**********         PARM                    BJDNWD                                       CSC011
     C                   PARM                    WkNext                                       CSC011
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDSTRD - convertible indicator A/K
     C                   PARM                    BVCIAK
      *                                                                        183604
      ** SDMMOD - Private banking                                              183604
     C                   PARM                    BGN4ST                        183604
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** EMU securities redenomination
     C                   PARM                    CEU017
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                       237063
      ** Multiple Holidays                                                                    237063
     C                   PARM                    CSE071                                       237063
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdX
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen indicator
     C                   PARM      'N'           PReDsp
      *
      ** Market Name
     C                   PARM                    WMKTN
 
     C                   EVAL      WRedisplay = *BLANK
      *
      ** If no errors occurred during validation of fields on Level 1
      ** screen, check if there are warnings which have not been
      ** displayed yet.
      *
     C                   IF        IdX = 0
 
     C                   Z-ADD     1             WiX
 
     C                   DOW       WiX <= WIdX AND WRedisplay = *BLANK
 
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WiX = WiX + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redisplay Level 2 screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IdX <> 0 OR WRedisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      ESRVal_S
     C                   ENDIF
      *
      ** Save old values of data structure for file update, to be used
      ** later if a cancellation occurs.
      *
     C                   EVAL      NwSeFilFmtOld = NwSefilFmt
                                                                                              CAS006
      ** Display the 5th Screen.                                                              CAS006
                                                                                              CAS006
     C                   EVAL      WScrn = 'H'                                                CAS006
      *
      ***If*New*Issue*is*'Y'*or*private*banking*is*installed,*display**                       CAS006
      ***third*screen.*************************************************                       CAS006
      *
     C**********         IF        DDNISS = 'Y' OR BGN4ST = 'Y'                               CAS006
     C**********         EVAL      WScrn = 'T'                                                CAS006
      *
      ***Setup*issue*amount*for*3rd*screen*if*risk*management*module*is                       CAS006
      ***installed*and*early*repayment*indicator*is*'Y'.**Value*of*this                       CAS006
      ***field*depends*on*previous*screen.*****************************                       CAS006
     C**********         IF        BGRKMG = 'Y' AND DDERPY ='Y'                               CAS006
     C**********         EVAL      DDISA2 = DDISA1                                            CAS006
     C**********         ENDIF                                                                CAS006
 
     C**********         ELSE                                                                 CAS006
      *                                                                                      CGLL018
      ****If*Risk*Weighted*Assets*is*on********************************               CGLL018 CAS006
      *                                                                                      CGLL018
     C**********         IF        CGL018 = 'Y'                                       CGLL018 CAS006
     C**********         EVAL      WOScrn = WScrn                                     CGLL018 CAS006
     C**********         EVAL      WScrn = 'Z'                                        CGLL018 CAS006
     C**********         GOTO      ESRval_S                                           CGLL018 CAS006
     C**********         ENDIF                                                        CGLL018 CAS006
      *                                                                         CSE023
      ***Windows*2000*processing.**************************************                CSE023 CAS006
     C**********         IF        BGWDPR = 'Y'                                        CSE023 CAS006
     C**********         EVAL      WOScrn = WScrn                                      CSE023 CAS006
     C**********         EVAL      WScrn = 'W'                                         CSE023 CAS006
     C**********         ELSE                                                          CSE023 CAS006
     C**********         EVAL      WScrn = 'F'                                                CAS006
     C**********         ENDIF                                                         CSE023 CAS006
      *                                                                         CSE023
     C**********         ENDIF                                                                CAS006
 
     C     ESRVal_S      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScn2 - Default fields in 2nd screen                     *
      *                                                               *
      *****************************************************************
 
     C     SRDefScn2     BEGSR
 
     C                   CALLB     'SESECS2DT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Security screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Passed other information coming from link programs
     C                   PARM                    POthInf
      *
      ** Externally described DS for investment types
     C                   PARM                    PINVTP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Risk Management
     C                   PARM                    BGRKMG
      *                                                                                       CSE031
      ** SWITCHABLE FEATURES                                                                  CSE031
      ** ===================                                                                  CSE031
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *
      ** OUTPUT
      ** ======
      *
      ** Security screen 2 details retrieved from file - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Fields for display only
     C                   PARM                    POutFlds
 
     C     ESRDefScn2    ENDSR
 
      *****************************************************************                       CSE065
      /EJECT                                                                                  CSE065
      *****************************************************************                       CSE065
      *                                                               *                       CSE065
      *  SRDefScn3 - Default fields in 3nd screen                     *                       CSE065
      *                                                               *                       CSE065
      *****************************************************************                       CSE065
                                                                                              CSE065
     C     SRDefScn3     BEGSR                                                                CSE065
                                                                                              CSE065
      ** Default Average Life Date if blanks                                                  CSE065
                                                                                              CSE065
     C                   IF        DDALDT = *BLANKS AND                                       CSE065
     C                             CSE065 = 'Y'                                               CSE065
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
                                                                                              CSE065
     C                   Z-ADD     *ZEROS        W#MATY                                       CSE065
     C                   IF        S1STBS = 'D' OR S1STBS = 'Y' AND                           CSE065
     C                             PPROT = '9'                                                CSE065
     C                   MOVE      DDMATY1       W#MATY                                       CSE065
     C                   ENDIF                                                                CSE065
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND                         CSE065
     C                             PPROT <> '4' AND PPROT <> '7') OR                          CSE065
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND                         CSE065
     C                             PPROT <> '4' AND PPROT <> '7' AND                          CSE065
     C                             PPROT <> '9')                                              CSE065
     C                   MOVE      DDMATY2       W#MATY                                       CSE065
     C                   ENDIF                                                                CSE065
     C                   IF        W#MATY  <> 0                                               CSE065
                                                                                              CSE065
      ** Convert Maturity Date from DDMMYY or MMDDYY to DDMMYYYY or MMDDYYYY                  CSE065
                                                                                              CSE065
     C                   IF        BJDFIN = 'D'                                               CSE065
     C     *dmy          MOVE      W#MATY        WDateEur                                     CSE065
                                                                                              CSE065
      ** Add 100 years                                                                        CSE065
                                                                                              CSE065
     C                   IF        DDLTMI = 'Y'                                               CSE065
     C                   ADDDUR    100:*Y        WDateEur                                     CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C     *eur          MOVE      WDateEur      WDateVar                                     CSE065
                                                                                              CSE065
     C                   ELSE                                                                 CSE065
                                                                                              CSE065
     C     *mdy          MOVE      W#MATY        WDateUsa                                     CSE065
                                                                                              CSE065
      ** Add 100 years                                                                        CSE065
                                                                                              CSE065
     C                   IF        DDLTMI = 'Y'                                               CSE065
     C                   ADDDUR    100:*Y        WDateUsa                                     CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C     *usa          MOVE      WDateUsa      WDateVar                                     CSE065
                                                                                              CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   MOVE      WDateVar      DDALDT                                       CSE065
                                                                                              CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   ENDSR                                                                CSE065
                                                                                              CSE065
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRVal_H - Validate input to Screen 5.                        *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRVal_H       BEGSR                                                                CAS006
                                                                                              CAS006
      ** If Action is Amend, validate whether non-amendable fields                            CAS006
      ** have been amended.                                                                   CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'A'                                               CAS006
                                                                                              CAS006
     C                   CALLB     'SESECS5MD'                                                CAS006
      *                  --------------------                                                 CAS006
                                                                                              CAS006
      ** Input Parameters                                                                     CAS006
      ** ================                                                                     CAS006
                                                                                              CAS006
      ** Return Code                                                                          CAS006
     C                   PARM                    RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Details From Incoming Transaction - File Format                           CAS006
     C                   PARM                    NwSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Securities Details Retrieved from File - File Format                                 CAS006
     C                   PARM                    CrSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Investment Processing Type                                                           CAS006
     C                   PARM                    PPROT                                        CAS006
                                                                                              CAS006
      ** Reset of Fields Flag                                                                 CAS006
     C                   PARM      'Y'           PResetFld                                    CAS006
                                                                                              CAS006
      ** Switchable Features:                                                                 CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CAS006
      ** Output Parameters                                                                    CAS006
      ** =================                                                                    CAS006
                                                                                              CAS006
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Error Array Index (3P0) From/To Caller                                               CAS006
     C                   PARM                    IdX                                          CAS006
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     C                   PARM                    SEESEC5                                      CAS006
                                                                                              CAS006
      ** Amend OK Flag                                                                        CAS006
     C                   PARM                    PAmendOK                                     CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate input to the 5th Screen.                                                    CAS006
                                                                                              CAS006
     C                   CALLB     'SESECS5VL'                                                CAS006
      *                  --------------------                                                 CAS006
                                                                                              CAS006
      ** Input Parameters                                                                     CAS006
      ** ================                                                                     CAS006
                                                                                              CAS006
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CAS006
      **      = '      ' (Not Front Office Transaction Interface)                             CAS006
      **      = '*RPR  ' (Repair Function)                                                    CAS006
      **      = '*SIN  ' (Screen Input Function)                                              CAS006
     C                   PARM                    PMode                                        CAS006
                                                                                              CAS006
      ** Response Mode                                                                        CAS006
     C                   PARM                    PRespMode                                    CAS006
                                                                                              CAS006
      ** Securities Screen 1 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE1ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 1 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE1ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details Retrieved From File                                      CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Detail Retrieved From File - File Format                                  CAS006
     C                   PARM                    CrSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Processing Type                                                                      CAS006
     C                   PARM                    PPROT                                        CAS006
                                                                                              CAS006
      ** Switchable Features:                                                                 CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CAS006
      ** Output Parameters                                                                    CAS006
      ** =================                                                                    CAS006
                                                                                              CAS006
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Error Array Index (3P0) From/To Caller                                               CAS006
     C                   PARM                    IdX                                          CAS006
                                                                                              CAS006
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                            CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIdArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Warning Array Index (3P0) From/To Caller                                             CAS006
     C                   PARM                    WIdX                                         CAS006
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     C                   PARM                    SEESEC5                                      CAS006
                                                                                              CAS006
      ** Securities Details For File Update - File Format                                     CAS006
     C                   PARM                    NwSEFilFmt                                   CAS006
                                                                                              CAS006
      ** If no errors occurred during the validation phase, check if                          CAS006
      ** there are warnings which have not been displayed yet.                                CAS006
                                                                                              CAS006
     C                   EVAL      WRedisplay = *BLANK                                        CAS006
                                                                                              CAS006
     C                   IF        IdX = 0                                                    CAS006
                                                                                              CAS006
     C                   Z-ADD     1             WiX                                          CAS006
                                                                                              CAS006
     C                   DOW       WiX <= WIdX AND                                            CAS006
     C                             WRedisplay = *BLANK                                        CAS006
                                                                                              CAS006
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)                          CAS006
     C                   EVAL      WRedisplay = 'Y'                                           CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WiX = WiX + 1                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   IF        WRedisplay <> 'Y'                                          CAS006
     C                   EXSR      SRResetErr                                                 CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Redisplay the 5th Screen if there are errors or warnings                             CAS006
      ** which have not been displayed yet.                                                   CAS006
                                                                                              CAS006
     C                   IF        IdX <> 0 OR                                                CAS006
     C                             WRedisplay = 'Y'                                           CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Save the old values for file updates.                                                CAS006
                                                                                              CAS006
     C                   EVAL      NwSeFilFmtOld = NwSefilFmt                                 CAS006
                                                                                              CAS006
      ** If New Issue = 'Y' or Private Banking is enabled, display the                        CAS006
      ** 3rd Screen.                                                                          CAS006
                                                                                              CAS006
     C                   IF        DDNISS = 'Y' OR BGN4ST = 'Y'                               CAS006
     C                             OR  CGL014 = 'Y'                                           CGL014
     C                   EVAL      WScrn = 'T'                                                CAS006
                                                                                              CAS006
      ** Set the Issue Amount for the 3rd Screen if Risk Management is                        CAS006
      ** enabled and Early Repayment Indicator = 'Y'. The value of                            CAS006
      ** this field depends on the previous screen.                                           CAS006
                                                                                              CAS006
     C                   IF        BGRKMG = 'Y' AND DDERPY ='Y'                               CAS006
     C                   EVAL      DDISA2 = DDISA1                                            CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Display the SE Risk Weighted Asset Codes MNT if CGL018 = 'Y'                         CAS006
      ** and Action Code = 'E'.                                                               CAS006
                                                                                              CAS006
     C                   IF        CGL018 = 'Y' AND                                           CAS006
     C                             DDACTN = 'E'                                               CAS006
     C                   EVAL      WOScrn = WScrn                                             CAS006
     C                   EVAL      WScrn  = 'Z'                                               CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Windows 2000 Processing.                                                             CAS006
                                                                                              CAS006
     C                   IF        BGWDPR = 'Y'                                               CAS006
     C                   EVAL      WOScrn = WScrn                                             CAS006
     C                   EVAL      WScrn = 'W'                                                CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WScrn = 'F'                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRScrn_H - Process Screen 5.                                 *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     C     SRScrn_H      BEGSR                                                                CAS006
                                                                                              CAS006
      ** Disable the Function Keys if necessary.                                              CAS006
                                                                                              CAS006
     C                   IF        PParmLink = 'Y'                                            CAS006
     C                   EVAL      PEINKF  = 'N'                                              CAS006
     C                   EVAL      PEINKG  = 'N'                                              CAS006
     C                   EVAL      PEINKH  = 'N'                                              CAS006
     C                   EVAL      PEINKP  = 'N'                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      PEINKF  = 'Y'                                              CAS006
     C                   EVAL      PEINKG  = 'Y'                                              CAS006
     C                   EVAL      PEINKH  = 'Y'                                              CAS006
     C                   EVAL      PEINKP  = 'Y'                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      PEINKL  = 'Y'                                              CAS006
                                                                                              CAS006
      ** Protect the screen fields if necessary.                                              CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'I' OR                                            CAS006
     C                             DDACTN = 'A'                                               CAS006
     C                   EVAL      PEdtFld = 'Y'                                              CAS006
     C                   EVAL      PEINKE  = 'Y'                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      PEdtFld = 'N'                                              CAS006
     C                   EVAL      PEINKE  = 'N'                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Process the 5th Screen.                                                              CAS006
                                                                                              CAS006
     C                   CALLB     'SESECS5DP'                                                CAS006
      *                  ---------------------                                                CAS006
                                                                                              CAS006
      ** Input Parameters                                                                     CAS006
      ** ================                                                                     CAS006
                                                                                              CAS006
      ** Return Code                                                                          CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Securities Screen 1 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE1ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Screen 5 Details From Incoming Transaction                                CAS006
      ** - Screen Format                                                                      CAS006
     C                   PARM                    NwSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** Securities Details Retrieved From File - File Format                                 CAS006
     C                   PARM                    CrSEFilFmt                                   CAS006
                                                                                              CAS006
      ** Investment Type Details                                                              CAS006
     C                   PARM                    PINVTP                                       CAS006
                                                                                              CAS006
      ** Display-Only Details                                                                 CAS006
     C                   PARM                    POutFlds                                     CAS006
                                                                                              CAS006
      ** Edit Indicator                                                                       CAS006
     C                   PARM                    PEDtFld                                      CAS006
                                                                                              CAS006
      ** Function Key Indicators:                                                             CAS006
                                                                                              CAS006
      ** KE (F05) = Refresh                                                                   CAS006
      ** KF (F06) = Initial Screen                                                            CAS006
      ** KG (F07) = Read Previous                                                             CAS006
      ** KH (F08) = Read Next                                                                 CAS006
      ** KL (F12) = Cancel                                                                    CAS006
      ** KP (F15) = Select                                                                    CAS006
     C                   PARM                    PEINKE                                       CAS006
     C                   PARM                    PEINKF                                       CAS006
     C                   PARM                    PEINKG                                       CAS006
     C                   PARM                    PEINKH                                       CAS006
     C                   PARM                    PEINKL                                       CAS006
     C                   PARM                    PEINKP                                       CAS006
                                                                                              CAS006
      ** Securities Screen 5 Error Indicators                                                 CAS006
     C                   PARM                    SEESEC5                                      CAS006
                                                                                              CAS006
      ** Error Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Warning Fields/Msg. IDs/Msg. Data (Arrays) From/To Caller                            CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIdArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Write Only Indicator                                                                 CAS006
     C                   PARM      'N'           WriteOnly                                    CAS006
                                                                                              CAS006
      ** Standing Data:                                                                       CAS006
                                                                                              CAS006
      ** System Run Date                                                                      CAS006
     C                   PARM                    BJMRDT                                       CAS006
                                                                                              CAS006
      ** Switchable Features:                                                                 CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CAS006
      ** Output Parameters                                                                    CAS006
      ** =================                                                                    CAS006
                                                                                              CAS006
      ** KC (F03) = Exit                                                                      CAS006
      ** KE (F05) = Refresh                                                                   CAS006
      ** KF (F06) = Initial Screen                                                            CAS006
      ** KG (F07) = Read Previous                                                             CAS006
      ** KH (F08) = Read Next                                                                 CAS006
      ** KL (F12) = Cancel                                                                    CAS006
      ** KP (F15) = Select                                                                    CAS006
     C                   PARM                    PINKC                                        CAS006
     C                   PARM                    PINKE                                        CAS006
     C                   PARM                    PINKF                                        CAS006
     C                   PARM                    PINKG                                        CAS006
     C                   PARM                    PINKH                                        CAS006
     C                   PARM                    PINKL                                        CAS006
     C                   PARM                    PINKP                                        CAS006
                                                                                              CAS006
      ** Save the Warning Message ID Array.                                                   CAS006
                                                                                              CAS006
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                                   CAS006
                                                                                              CAS006
      ** Reset the Error Fields.                                                              CAS006
                                                                                              CAS006
     C                   EXSR      SRResetErr                                                 CAS006
                                                                                              CAS006
      ** Begin Function Key Selection                                                         CAS006
      ** ============================                                                         CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
      ** F03 - End Program                                                                    CAS006
      ** -----------------                                                                    CAS006
                                                                                              CAS006
     C                   WHEN      PINKC = *ON                                                CAS006
     C                   EXSR      SREndP                                                     CAS006
                                                                                              CAS006
      ** F05 - Refresh                                                                        CAS006
      ** -------------                                                                        CAS006
                                                                                              CAS006
     C                   WHEN      PINKE = *ON                                                CAS006
     C                   EVAL      NwSE5ScnFmt = CrSE5ScnFmt                                  CAS006
                                                                                              CAS006
      ** F06 - Initial Screen                                                                 CAS006
      ** --------------------                                                                 CAS006
                                                                                              CAS006
     C                   WHEN      PINKF = *ON                                                CAS006
     C                   EXSR      SRClearScn                                                 CAS006
     C                   EVAL      WScrn = 'I'                                                CAS006
                                                                                              CAS006
      ** F07 - Roll Backwards                                                                 CAS006
      ** --------------------                                                                 CAS006
                                                                                              CAS006
     C                   WHEN      PINKG = *ON                                                CAS006
     C                   EXSR      SRRoll                                                     CAS006
                                                                                              CAS006
      ** F08 - Roll Forwards                                                                  CAS006
      ** -------------------                                                                  CAS006
                                                                                              CAS006
     C                   WHEN      PINKH = *ON                                                CAS006
     C                   EXSR      SRRoll                                                     CAS006
                                                                                              CAS006
      ** F12 - Cancel                                                                         CAS006
      ** ------------                                                                         CAS006
                                                                                              CAS006
     C                   WHEN      PINKL = *ON                                                CAS006
                                                                                              CAS006
      ** Refresh and redisplay Screen 2.                                                      CAS006
                                                                                              CAS006
     C                   EVAL      WScrn = 'S'                                                CAS006
                                                                                              CAS006
      ** F15 - Build Subfile Browse                                                           CAS006
      ** --------------------------                                                           CAS006
                                                                                              CAS006
     C                   WHEN      PINKP = *ON                                                CAS006
     C                   EXSR      SRClearScn                                                 CAS006
     C                   EXSR      SRBldBrw                                                   CAS006
                                                                                              CAS006
      ** The Enter Key was pressed.                                                           CAS006
                                                                                              CAS006
     C                   OTHER                                                                CAS006
                                                                                              CAS006
      ** If Action is Insert or Amend, validate input to the 5th                              CAS006
      ** Screen.                                                                              CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'I' OR                                            CAS006
     C                             DDACTN = 'A'                                               CAS006
     C                   EXSR      SRVal_H                                                    CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** If Action is Enquire and the Security is a new issue or if                           CAS006
      ** Private Banking is enabled, display the 3rd Screen.                                  CAS006
                                                                                              CAS006
     C                   IF        (DDACTN = 'E' AND DDNISS = 'Y') OR                         CAS006
     C                             (DDACTN = 'E' AND BGN4ST = 'Y')                            CAS006
     C                             OR  (DDACTN = 'E' AND CGL014 = 'Y')                        CGL014
     C                   EVAL      WScrn  = 'T'                                               CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Display the SE Risk Weighted Asset Codes MNT if CGL018 = 'Y'                         CAS006
      ** and Action Code = 'E'.                                                               CAS006
                                                                                              CAS006
     C                   IF        CGL018 = 'Y' AND                                           CAS006
     C                             DDACTN = 'E'                                               CAS006
     C                   EVAL      WOScrn = WScrn                                             CAS006
     C                   EVAL      WScrn  = 'Z'                                               CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Windows 2000 Processing.                                                             CAS006
                                                                                              CAS006
     C                   IF        BGWDPR = 'Y'                                               CAS006
     C                   EVAL      WOScrn = WScrn                                             CAS006
     C                   EVAL      WScrn = 'W'                                                CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** If the Securities Maintenance has been called by a linked                            CAS006
      ** maintenance/enquiry, terminate the program.                                          CAS006
                                                                                              CAS006
     C                   IF        PParmLink = 'Y'                                            CAS006
     C                   EVAL      PParmRtcd = *BLANK                                         CAS006
     C                   EVAL      WScrn = 'E'                                                CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Read Next Browse Subfile record.                                                     CAS006
                                                                                              CAS006
     C                   IF        PRdNb = 'Y'                                                CAS006
     C                   EVAL      WScrn = 'R'                                                CAS006
     C                   LEAVESR                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Redisplay the initial screen with blank fields.                                      CAS006
                                                                                              CAS006
     C                   EXSR      SRClearScn                                                 CAS006
     C                   EVAL      WScrn = 'I'                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
      ** End Function Key Selection                                                           CAS006
      ** ==========================                                                           CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_T - Process screen 3                                  *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_T      BEGSR
      *
      ** Protect screen fields if necessary and disable function keys
      ** accordingly.
      *
     C                   IF        PParmLink = 'Y'
 
     C                   EVAL      PEINKF  = 'N'
     C                   EVAL      PEINKG  = 'N'
     C                   EVAL      PEINKH  = 'N'
     C                   EVAL      PEINKP  = 'N'
 
     C                   ELSE
 
     C                   EVAL      PEINKF  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
 
     C                   ENDIF
 
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEINKE  = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEINKE  = 'N'
     C                   ENDIF
 
     C                   EVAL      PEINKL  = 'Y'
      *
      ** Process 3rd screen.
      *
     C                   CALLB     'SESECS3DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Security 1st screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Security 3rd screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Enable detail fields indicator
     C                   PARM                    PEDtFld
      *                                                                                       CSE065
      ** Processing Type Indicator                                                            CSE065
     C                   PARM                    PPRoT                                        CSE065
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KF = Command Key 06 = Initial screen
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KL = Command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKF
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** Security 3rd screen error indicators
     C                   PARM                    SEESEC3
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - system run date
     C                   PARM                    BJMRDT
      *                                                                                       CSE065
      ** SDBANK - system run day number                                                       CSE065
     C                   PARM                    BJRDNB                                       CSE065
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
                                                                                              CGL032
      ** SWITCHABLE FEATURES                                                                  CGL032
      ** ===================                                                                  CGL032
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KF = Command Key 06 = Initial screen
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KL = command key 12 = Cancel
      ** KP = command Key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKF
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      ** Save warning message ids array of 3rd screen.
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh screen 3.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwSE3ScnFmt = CrSE3ScnFmt
      *
      ** F6 - initial screen.
     C                   WHEN      PINKF = *ON
      *
      ** Redisplay Initial screen with blank screen fields.
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
      *
      ** F7 - roll backwards.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SRRoll
      *
      ** F8 - roll forwards.
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
      *
      ** F12 - cancel on 3rd screen.
     C                   WHEN      PINKL = *ON
      *
      ** Refresh, return old values for file update and redisplay screen 2.
      ** Set up Issue amount 1 to be equal to Issue amount on third screen
      ** only if Risk Management is on and early repayment and new issue.
      *
     C                   EVAL      NwSEFilFmt = NwSeFilFmtOld
     C                   MOVE      DDISA1        WISSA1
     C                   IF        BGRKMG = 'Y' AND DDERPY ='Y' AND
     C                             DDNISS = 'Y' AND WISSA1 = *ZEROS
     C                   EVAL      DDISA1 = DDISA2
     C                   ENDIF
     C**********         EVAL      WScrn = 'S'                                                CAS006
     C                   EVAL      WScrn = 'H'                                                CAS006
      *
      ** F15 - build browse.
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRClearScn
     C                   EXSR      SRBldBrw
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** If Action is Insert or Amend, validate input to
      ** Level 3 screen.
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EXSR      SRVal_T
     C                   GOTO      ESRScrn_T
     C                   ENDIF
      *
      ** Action is Enquire.
     C                   IF        DDACTN = 'E'
      *                                                                                      CGLL018
      ****If*Risk*Weighted*Assets*is*on********************************               CGLL018 CAS006
      *                                                                                      CGLL018
     C**********         IF        CGL018 = 'Y'                                       CGLL018 CAS006
     C**********         EVAL      WOScrn = WScrn                                     CGLL018 CAS006
     C**********         EVAL      WScrn  = 'Z'                                       CGLL018 CAS006
     C**********         GOTO      ESRScrn_T                                          CGLL018 CAS006
     C**********         ENDIF                                                        CGLL018 CAS006
      *                                                                         CSE023
      ** Windows 2000 processing.                                               CSE023
     C                   IF        BGWDPR = 'Y'                                 CSE023
     C                   EVAL      WOScrn = WScrn                               CSE023
     C                   EVAL      WScrn = 'W'                                  CSE023
     C                   GOTO      ESRScrn_T                                    CSE023
     C                   ENDIF                                                  CSE023
      *
      ** If securities maintenance has been called by linked
      ** maintenance/enquiry, terminate program.
     C                   IF        PParmLink = 'Y'
     C                   EVAL      PParmRtcd = *BLANK
     C                   EVAL      WScrn = 'E'
     C                   GOTO      ESRScrn_T
     C                   ENDIF
      *
      ** Read Next Browse Subfile record.
     C                   IF        PRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   GOTO      ESRScrn_T
     C                   ENDIF
      *
      ** Redisplay Initial screen with blank screen fields.
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
 
     C                   ENDIF
 
     C                   ENDSL
 
     C     ESRScrn_T     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_T - Validate input to level 3 screen                   *
      *                                                               *
      *****************************************************************
 
     C     SRVal_T       BEGSR
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended.
      *
     C                   IF        DDACTN = 'A'
 
     C                   CALLB     'SESECS3MD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Early repayments? - from 1st screen
      ** New issue - from 1st screen
      ** Issue amount 1 - from 2nd screen
     C                   PARM                    DDERPY
     C                   PARM                    DDNISS
     C                   PARM                    DDISA1
      *
      ** Securities screen 3 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE3ScnFmt
      *
      ** Reset of fields in error required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Securities screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** OK amendments field
     C                   PARM                    PAmendOK
 
     C                   ENDIF
 
     C                   CALLB     'SESECS3VL'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Securities input screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSe2ScnFmt
      *
      ** Securities input screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSe3ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *                                                                         CSE023
      ** Processing type, from PF/INVTPD                                        CSE023
     C                   PARM                    PPROT                          CSE023
      *
      ** New Issue
     C                   PARM                    DDNISS
      *
      ** Action code
     C                   PARM                    DDACTN
      *                                                                                       232543
      ** Subject to European Tax                                                              232543
     C                   PARM                    DDSETX                                       232543
      *                                                                                     AR996842
      ** Instrument type                                                                    AR996842
      *                                                                                     AR996842
     C                   PARM                    PINNR                                      AR996842
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SDMMOD - Interest risk management
     C                   PARM                    BGRKMG
      *                                                                         CSE023
      ** CSE023 - US Withholding Tax Treaty.                                    CSE023
     C                   PARM                    CSE023                         CSE023
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CGL031
      ** Taxation on Savings Income on                                                        CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdX
      *
      ** Securities screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen indicator
     C                   PARM      'N'           PReDsp
 
     C                   EVAL      WRedisplay = *BLANK
      *
      ** If no errors occurred during validation of fields on Level 3
      ** screen, check if there are warnings which have not been
      ** displayed yet.
      *
     C                   IF        IdX = 0
 
     C                   Z-ADD     1             WiX
 
     C                   DOW       WiX <= WIdX AND WRedisplay = *BLANK
 
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WiX = WiX + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redisplay Level 3 screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IdX <> 0 OR WRedisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      ESRVal_T
     C                   ENDIF
      *                                                                                      CGLL018
      ****If*Risk*Weighted*Assets*is*on********************************               CGLL018 CAS006
      *                                                                                      CGLL018
     C**********         IF        CGL018 = 'Y'                                       CGLL018 CAS006
     C**********         EVAL      WOScrn = WScrn                                     CGLL018 CAS006
     C**********         EVAL      WScrn  = 'Z'                                       CGLL018 CAS006
     C**********         GOTO      ESRVal_T                                           CGLL018 CAS006
     C**********         ENDIF                                                        CGLL018 CAS006
     C                   IF        BGWDPR = 'Y'                                 CSE023
     C                   EVAL      WOScrn = WScrn                               CSE023
     C                   EVAL      WScrn = 'W'                                  CSE023
     C                   ELSE                                                   CSE023
     C                   EVAL      WScrn = 'F'
     C                   ENDIF                                                  CSE023
 
     C     ESRVal_T      ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRScrn_G - Process screen 4                                  *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
                                                                                              CSE031
     C     SRScrn_G      BEGSR                                                                CSE031
      *                                                                                       CSE031
      ** Protect screen fields if necessary and disable function keys                         CSE031
      ** accordingly.                                                                         CSE031
      *                                                                                       CSE031
     C                   IF        PParmLink = 'Y'                                            CSE031
                                                                                              CSE031
     C                   EVAL      PEINKF  = 'N'                                              CSE031
     C                   EVAL      PEINKG  = 'N'                                              CSE031
     C                   EVAL      PEINKH  = 'N'                                              CSE031
     C                   EVAL      PEINKP  = 'N'                                              CSE031
                                                                                              CSE031
     C                   ELSE                                                                 CSE031
                                                                                              CSE031
     C                   EVAL      PEINKF  = 'Y'                                              CSE031
     C                   EVAL      PEINKG  = 'Y'                                              CSE031
     C                   EVAL      PEINKH  = 'Y'                                              CSE031
     C                   EVAL      PEINKP  = 'Y'                                              CSE031
                                                                                              CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                               CSE031
     C                   EVAL      PEdtFld = 'Y'                                              CSE031
     C                   EVAL      PEINKE  = 'Y'                                              CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      PEdtFld = 'N'                                              CSE031
     C                   EVAL      PEINKE  = 'N'                                              CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   EVAL      PEINKL  = 'Y'                                              CSE031
      *                                                                                       CSE031
      ** Process 4th screen.                                                                  CSE031
      *                                                                                       CSE031
     C                   CALLB     'SESECS4DP'                                                CSE031
      *                             =========                                                 CSE031
      *                                                                                       CSE031
      ** INPUT                                                                                CSE031
      ** =====                                                                                CSE031
      *                                                                                       CSE031
      ** Return code                                                                          CSE031
     C                   PARM                    RetCodeOut                                   CSE031
      *                                                                                       CSE031
      ** Security 1st screen details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE1ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Security 2nd screen details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE2ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Security 4th screen details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities retrieved from file - file format                                         CSE031
     C                   PARM                    CrSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Enable detail fields indicator                                                       CSE031
     C                   PARM                    PEDtFld                                      CSE031
      *                                                                                       CSE031
      ** Enable function keys                                                                 CSE031
      ** KE = command key 05 = Refresh                                                        CSE031
      ** KF = Command Key 06 = Initial screen                                                 CSE031
      ** KG = command key 07 = Read previous                                                  CSE031
      ** KH = command key 08 = Read next                                                      CSE031
      ** KL = Command key 12 = Cancel                                                         CSE031
      ** KP = command key 15 = Select                                                         CSE031
     C                   PARM                    PEINKE                                       CSE031
     C                   PARM                    PEINKF                                       CSE031
     C                   PARM                    PEINKG                                       CSE031
     C                   PARM                    PEINKH                                       CSE031
     C                   PARM                    PEINKL                                       CSE031
     C                   PARM                    PEINKP                                       CSE031
      *                                                                                       CSE031
      ** Security 4th screen error indicators                                                 CSE031
     C                   PARM                    SEESEC4                                      CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNameArr                                   CSE031
     C                   PARM                    MsgIdArr                                     CSE031
     C                   PARM                    MsgDtaArr                                    CSE031
      *                                                                                       CSE031
      ** Warning fields/message Ids/message data (arrays) from/to                             CSE031
      ** caller                                                                               CSE031
     C                   PARM                    WFldNamArr                                   CSE031
     C                   PARM                    WMsgIdArr                                    CSE031
     C                   PARM                    WMsgDtaArr                                   CSE031
      *                                                                                       CSE031
      ** Write screen with no read indicator                                                  CSE031
     C                   PARM      'N'           WriteOnly                                    CSE031
      *                                                                                       CSE031
      ** STANDING DATA                                                                        CSE031
      ** =============                                                                        CSE031
      *                                                                                       CSE031
      ** SDBANK - system run date                                                             CSE031
     C                   PARM                    BJMRDT                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Function keys enabled                                                                CSE031
      ** KC = command key 03 = Exit                                                           CSE031
      ** KE = command key 05 = Refresh                                                        CSE031
      ** KF = Command Key 06 = Initial screen                                                 CSE031
      ** KG = command key 07 = Read previous                                                  CSE031
      ** KH = command key 08 = Read next                                                      CSE031
      ** KL = command key 12 = Cancel                                                         CSE031
      ** KP = command Key 15 = Select                                                         CSE031
     C                   PARM                    PINKC                                        CSE031
     C                   PARM                    PINKE                                        CSE031
     C                   PARM                    PINKF                                        CSE031
     C                   PARM                    PINKG                                        CSE031
     C                   PARM                    PINKH                                        CSE031
     C                   PARM                    PINKL                                        CSE031
     C                   PARM                    PINKP                                        CSE031
      *                                                                                       CSE031
      ** Save warning message ids array of 4th screen.                                        CSE031
      *                                                                                       CSE031
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                                   CSE031
      *                                                                                       CSE031
      ** Reset error fields.                                                                  CSE031
      *                                                                                       CSE031
     C                   EXSR      SRResetErr                                                 CSE031
                                                                                              CSE031
     C                   SELECT                                                               CSE031
      *                                                                                       CSE031
      ** F3 - end program.                                                                    CSE031
     C                   WHEN      PINKC = *ON                                                CSE031
     C                   EXSR      SREndP                                                     CSE031
      *                                                                                       CSE031
      ** F5 - refresh screen 4.                                                               CSE031
     C                   WHEN      PINKE = *ON                                                CSE031
     C                   EVAL      NwSE4ScnFmt = CrSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** F6 - initial screen.                                                                 CSE031
     C                   WHEN      PINKF = *ON                                                CSE031
      *                                                                                       CSE031
      ** Redisplay Initial screen with blank screen fields.                                   CSE031
     C                   EXSR      SRClearScn                                                 CSE031
     C                   EVAL      WScrn = 'I'                                                CSE031
      *                                                                                       CSE031
      ** F7 - roll backwards.                                                                 CSE031
     C                   WHEN      PINKG = *ON                                                CSE031
     C                   EXSR      SRRoll                                                     CSE031
      *                                                                                       CSE031
      ** F8 - roll forwards.                                                                  CSE031
     C                   WHEN      PINKH = *ON                                                CSE031
     C                   EXSR      SRRoll                                                     CSE031
      *                                                                                       CSE031
      ** F12 - cancel on 4th screen.  Display 2nd Screen.                                     CSE031
     C                   WHEN      PINKL = *ON                                                CSE031
      *                                                                                       CSE031
      ** Refresh, return old values for file update and redisplay screen 2.                   CSE031
      *                                                                                       CSE031
     C                   EVAL      NwSEFilFmt = NwSeFilFmtOld                                 CSE031
     C                   EVAL      WScrn = 'S'                                                CSE031
      *                                                                                       CSE031
      ** F15 - build Select.                                                                  CSE031
     C                   WHEN      PINKP = *ON                                                CSE031
     C                   EXSR      SRClearScn                                                 CSE031
     C                   EXSR      SRBldBrw                                                   CSE031
      *                                                                                       CSE031
      ** Enter key was pressed.                                                               CSE031
     C                   OTHER                                                                CSE031
      *                                                                                       CSE031
      ** If Action is Insert or Amend, validate input to                                      CSE031
      ** Level 4 screen.                                                                      CSE031
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                               CSE031
     C                   EXSR      SRVal_G                                                    CSE031
     C                   GOTO      ESRScrn_G                                                  CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Redisplay 2nd screen.                                                                CSE031
     C                   EVAL      WSCRN = 'S'                                                CSE031
      *                                                                                       CSE031
      ** If securities maintenance has been called by linked                                  CSE031
      ** maintenance/enquiry, terminate program.                                              CSE031
     C                   IF        PParmLink = 'Y'                                            CSE031
     C                   EVAL      PParmRtcd = *BLANK                                         CSE031
     C                   EVAL      WScrn = 'E'                                                CSE031
     C                   GOTO      ESRScrn_G                                                  CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
     C                   ENDSL                                                                CSE031
                                                                                              CSE031
     C     ESRScrn_G     ENDSR                                                                CSE031
                                                                                              CSE031
      *****************************************************************                       CSE031
      /EJECT                                                                                  CSE031
      *****************************************************************                       CSE031
      *                                                               *                       CSE031
      *  SRVal_G - Validate input to level 4 screen                   *                       CSE031
      *                                                               *                       CSE031
      *****************************************************************                       CSE031
                                                                                              CSE031
     C     SRVal_G       BEGSR                                                                CSE031
      *                                                                                       CSE031
      ** If Action is Amend, validate whether non-amendable fields                            CSE031
      ** have been amended.                                                                   CSE031
      *                                                                                       CSE031
     C                   IF        DDACTN = 'A'                                               CSE031
                                                                                              CSE031
     C                   CALLB     'SESECS4MD'                                                CSE031
      *                             =========                                                 CSE031
      *                                                                                       CSE031
      ** INPUT                                                                                CSE031
      ** =====                                                                                CSE031
      *                                                                                       CSE031
      ** Return code                                                                          CSE031
     C                   PARM                    RetCodeOut                                   CSE031
      *                                                                                       CSE031
      ** Securities screen 4 details from incoming transaction                                CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities screen 4 details retrieved from file                                      CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities retrieved from file file format                                           CSE031
     C                   PARM                    CrSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Investment processing type from PF/INVTPD                                            CSE031
     C                   PARM                    PPROT                                        CSE031
      *                                                                                       CSE031
      ** Reset of fields in error required (Y/N)                                              CSE031
     C                   PARM      'Y'           PResetFld                                    CSE031
      *                                                                                       CSE031
      *                                                                                       CSE031
      ** SWITCHABLE FEATURES                                                                  CSE031
      ** ===================                                                                  CSE031
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message Ids/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNameArr                                   CSE031
     C                   PARM                    MsgIdArr                                     CSE031
     C                   PARM                    MsgDtaArr                                    CSE031
      *                                                                                       CSE031
      ** Array index (3P0) from/to caller                                                     CSE031
     C                   PARM                    IdX                                          CSE031
      *                                                                                       CSE031
      ** Securities screen 4 error indicators                                                 CSE031
     C                   PARM                    SEESEC4                                      CSE031
      *                                                                                       CSE031
      ** OK amendments field                                                                  CSE031
     C                   PARM                    PAmendOK                                     CSE031
                                                                                              CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   CALLB     'SESECS4VL'                                                CSE031
      *                             =========                                                 CSE031
      *                                                                                       CSE031
      ** INPUT                                                                                CSE031
      ** =====                                                                                CSE031
      *                                                                                       CSE031
      ** Mode = '*FRONT' (front office transaction interface)                                 CSE031
      ** Mode = '      ' (not front office transaction interface)                             CSE031
      ** Mode = '*RPR  ' (repair function)                                                    CSE031
      ** Mode = '*SIN  ' (screen input function)                                              CSE031
     C                   PARM                    PMode                                        CSE031
      *                                                                                       CSE031
      ** Response mode                                                                        CSE031
     C                   PARM                    PRespMode                                    CSE031
      *                                                                                       CSE031
      ** Securities input screen 4 details from incoming transaction                          CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    NwSe4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Security screen 4 details retrieved from file                                        CSE031
      ** - screen format                                                                      CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
      *                                                                                       CSE031
      ** Securities retrieved from file - file format                                         CSE031
     C                   PARM                    CrSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** STANDING DATA                                                                        CSE031
      ** =============                                                                        CSE031
      *                                                                                       CSE031
      ** SDMMOD - date format indicator                                                       CSE031
     C                   PARM                    BJDFIN                                       CSE031
      *                                                                                       CSE031
      ** SDBANK - Midas run date number                                                       CSE031
     C                   PARM                    BJRDNB                                       CSE031
      *                                                                                       CSE031
      ** OUTPUT                                                                               CSE031
      ** ======                                                                               CSE031
      *                                                                                       CSE031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    FldNameArr                                   CSE031
     C                   PARM                    MsgIdArr                                     CSE031
     C                   PARM                    MsgDtaArr                                    CSE031
      *                                                                                       CSE031
      ** Array index (3P0) from/to caller                                                     CSE031
     C                   PARM                    IdX                                          CSE031
      *                                                                                       CSE031
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSE031
     C                   PARM                    WFldNamArr                                   CSE031
     C                   PARM                    WMsgIdArr                                    CSE031
     C                   PARM                    WMsgDtaArr                                   CSE031
      *                                                                                       CSE031
      ** Array index (3P0) from/to caller                                                     CSE031
     C                   PARM                    WIdX                                         CSE031
      *                                                                                       CSE031
      ** Securities screen 4 error indicators                                                 CSE031
     C                   PARM                    SEESEC4                                      CSE031
      *                                                                                       CSE031
      ** Securities for file update - file format                                             CSE031
     C                   PARM                    NwSEFilFmt                                   CSE031
      *                                                                                       CSE031
      ** Redisplay screen indicator                                                           CSE031
     C                   PARM      'N'           PReDsp                                       CSE031
                                                                                              CSE031
     C                   EVAL      WRedisplay = *BLANK                                        CSE031
      *                                                                                       CSE031
      ** If no errors occurred during validation of fields on Level 4                         CSE031
      ** screen, check if there are warnings which have not been                              CSE031
      ** displayed yet.                                                                       CSE031
      *                                                                                       CSE031
     C                   IF        IdX = 0                                                    CSE031
                                                                                              CSE031
     C                   Z-ADD     1             WiX                                          CSE031
                                                                                              CSE031
     C                   DOW       WiX <= WIdX AND WRedisplay = *BLANK                        CSE031
                                                                                              CSE031
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)                          CSE031
     C                   EVAL      WRedisplay = 'Y'                                           CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      WiX = WiX + 1                                              CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   ENDDO                                                                CSE031
                                                                                              CSE031
     C                   IF        WRedisplay <> 'Y'                                          CSE031
     C                   EXSR      SRResetErr                                                 CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   ENDIF                                                                CSE031
      *                                                                                       CSE031
      ** Redisplay Level 4 screen if there are errors or if there                             CSE031
      ** are warnings which have not been displayed yet.                                      CSE031
      *                                                                                       CSE031
     C                   IF        IdX <> 0 OR WRedisplay = 'Y' OR                            CSE031
     C                             PReDsp = 'Y'                                               CSE031
     C                   GOTO      ESRVal_G                                                   CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
      ** Redisplay screen 2.                                                                  CSE031
     C                   EVAL      WScrn = 'S'                                                CSE031
                                                                                              CSE031
     C     ESRVal_G      ENDSR                                                                CSE031
                                                                                              CSE031
      *****************************************************************                       CSE031
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_F - Process confirmation screen                       *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_F      BEGSR
      *
      ** Reset error fields, specifically arrays for warning messages.
      *
     C                   EXSR      SRResetErr
      *
      ** Entries are valid or only warnings exist.  Output message
      ** "Press ENTER to apply transaction to database or F12 to change.".
      *
     C                   EVAL      WFldNamArr(1) = '*ANY'
     C                   EVAL      WMsgIdArr(1) = 'MMM1031'
      *
      ** Process 1st screen (protected - for confirmation only)
      *
     C                   CALLB     'SESECS1DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Security 1st screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Enable detail fields indicator
      ** Enable key fields indicator
     C                   PARM      'N'           PEDtFld
     C                   PARM      'N'           PEKyFld
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KJ = command key 10 = Delete
      ** KL = Command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM      'N'           PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** Security 1st screen error indicators
     C                   PARM                    SEESEC1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - system run date
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - plato interface
     C                   PARM                    BGN2ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU securities decimals on nominals
     C                   PARM                    CEU018
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      ** Market Data Feed on?
     C                   PARM                    CSD006                                       CSD006
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read previous
      ** KH = command key 08 = Read next
      ** KJ = command key 10 = Delete
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *                                                                                       192054
      ** Private Banking                                                                      192054
      *                                                                                       192054
     C                   PARM                    BGN4ST                                       192054
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display screen 1
     C                   WHEN      PINKL = *ON
      *
      ** Return old values for file update from 2nd screen.  This is done
      ** to make sure that fields from the 3rd screen does not get updated
      ** to file unnecessarily.
     C                   EVAL      NwSEFilFmt = NwSeFilFmtOld
      *
      ** Display primary screen.
     C                   EVAL      WScrn = 'P'
      *
      ** Enter key was pressed.  Update files.
     C                   OTHER
 
     C                   EVAL      WScrn = 'U'
 
     C                   ENDSL
 
     C     ESRScrn_F     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update files                                      *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
      *
      ** Action is delete.
      **           ======
      *
     C                   IF        DDACTN = 'D'
      *
      ** Move securities details retrieved from file directly to the
      ** securities update data structure.
     C**********         EVAL      NwSEFilFmt = CrSEFilFmt                                    CSE065
     C                   EVAL      NwSEFilFmt1 = CrSEFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     ALDT          S1ALDT                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S1ALDT                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Record id - update to 'C'.
     C                   EVAL      S1RECI = 'C'
 
     C                   ELSE
      *
      ** Action is insert.
      **           ======
      *
     C                   IF        DDACTN = 'I'
      *
      ** Record id.
     C                   EVAL      S1RECI = 'D'
      *
      ** Security shortname.
     C                   EVAL      S1SESN = DDSESN
      *
      ** Original entry dates.
     C                   Z-ADD     BJRDNB        S1ORED
      *
      ** First redemption - call/put,price and market price
     C                   EVAL      S1SCPI = *BLANK
     C                   EVAL      S1SCPP = *ZEROS
     C                   EVAL      S1MKPR = *ZEROS
                                                                                              CAS006
      ** Set the S1MKPN, S1MCRK, and S1MLQP fields to zero if CAS006 is                       CAS006
      ** enabled.                                                                             CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      S1MKPN = *ZERO                                             CAS006
     C                   EVAL      S1MCRK = *ZERO                                             CAS006
     C                   EVAL      S1MLQP = *ZERO                                             CAS006
     C                   ENDIF                                                                CAS006
      *
      ** If  new issue flag is not 'Y', output blank fields.
     C                   IF        DDNISS <> 'Y'
     C                   Z-ADD     *ZEROS        S1ISSD
     C                   IF        CGL031 <> 'Y'                                              232543
     C                   Z-ADD     *ZEROS        S1ISSP
     C                   ENDIF                                                                232543
     C                   Z-ADD     *ZEROS        S1ISSA
     C                   Z-ADD     *ZEROS        S1TOTU
     C                   Z-ADD     *ZEROS        S1ALRQ
     C                   Z-ADD     *ZEROS        S1ALRC
     C                   Z-ADD     *ZEROS        S1UNFD
     C                   Z-ADD     *ZEROS        S1UNFR
     C                   Z-ADD     *ZEROS        S1MGFD
     C                   Z-ADD     *ZEROS        S1MGRC
     C**********         Z-ADD     *ZEROS        S1LMGR                                       CSD027
     C                   EVAL      S1LMGR = *BLANKS                                           CSD027
     C                   EVAL      S1FECY = S1NMCY
     C                   ENDIF
      *
      ** Current factor
     C                   IF        PPROT = '8'
     C                   Z-ADD     1             S1CFCT
     C                   ELSE
     C                   Z-ADD     *ZEROS        S1CFCT
     C                   ENDIF
      *
      ** Default value of issue date to initial date if issue date
      ** was not entered.
     C                   IF        S1ISSD = *ZEROS
     C                   Z-ADD     S1ITLD        S1ISSD
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Action is amend/insert.
      **           ============
      *
      ** Date made complete.
      *
     C                   IF        ODINCS = 'I'
 
     C                   IF        DDINCS = *BLANK OR DDINCS = 'C'
     C                   Z-ADD     BJRDNB        S1DCOM
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Security Full name -1 defaults to Report name if blanks.
      *
     C                   IF        DDSFN1 <> *BLANKS
     C                   EVAL      S1SFN1 = DDSFN1
     C                   ELSE
     C                   EVAL      S1SFN1 = *BLANKS
     C                   EVAL      S1SFN1 = DDSRPN
     C                   ENDIF
      *
      ** Security full name - 2.
      *
     C                   EVAL      S1SFN2 = DDSFN2
      *
      ** Front Office ID                                                                      CAP060
     C                   EVAL      S1SPID = DDSPID                                            CAP060
      *
      ** Sector code
      *
     C                   EVAL      S1SSEC = DDSSEC
      *
      ** Rating.
      *
     C                   EVAL      S1QLTY = DDQLTY
      *
      ** Statutory Returns Code.
      *
     C                   EVAL      S1SRET = DDSRET
      *
      ** Pay currency
      *
     C                   EVAL      S1SPYC = S1VLCY
      *
      ** If midas-plato interface is installed.
      *
     C                   IF        BGN2ST = 'Y'
     C                   EVAL      S1PLICCD = DDICCD
     C                   EVAL      S1PLDINM = DDDINM
     C                   EVAL      S1PLRGCD = DDRGCD
     C                   EVAL      S1PLPGCD = DDPGCD
     C                   ENDIF
      *                                                                         CSE023
      ** Windows 2000 processing.                                               CSE023
     C                   IF        BGWDPR = 'Y' AND CSE023 = 'Y'                CSE023
     C                   EVAL      S1CRTT = #1CRTT                              CSE023
     C                   EVAL      S1INCT = #1INCT                              CSE023
     C                   EVAL      S1EXCD = #1EXCD                              CSE023
     C                   EVAL      S1OIDI = #1OIDI                              CSE023
     C                   EVAL      S1APIE = #1APIE                              CSE023
     C                   ENDIF                                                  CSE023
 
     C                   ENDIF
      *
      ** Action is insert/amend/delete.
      **           ===================
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A' OR
     C                             DDACTN = 'D'
      *
      ** Last change type
     C                   EVAL      S1CHTP = DDACTN
 
     C                   ENDIF
 
     C                   CALLB     'SESECSUPD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDSTRD - extel option
     C                   PARM                    BVEXOP
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - midas run day number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** ZMUSER - default branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** Market migration
     C                   PARM                    S01511
      ** MDF
     C                   PARM                    CSD006            1                          CSD006
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *
      ** If errors occurred on update, rollback uncommitted file
      ** changes.
      *
     C                   IF        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   IF        RetCodeOut = '*RECUPD'
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ELSE
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If securities maintenance has been called by
      ** linked maintenance/enquiry, terminate program.
     C                   IF        PParmLink = 'Y'
 
     C                   EVAL      WScrn = 'E'
 
     C                   ELSE
      *
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
      *
     C                   IF        RetCodeOut = '*RECUPD'
     C                   Z-ADD     1             IdX
     C                   Eval      FldNameArr(IdX) = '*ANY'
     C                   Eval      MsgIdArr(IdX) = 'APM1000'
     C                   ENDIF
      *
      ** Read next browse subfile record.
      *
     C                   IF        PRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   GOTO      ESRUpdate
     C                   ENDIF
      *
      ** Display initial screen with blank screen fields.
      *
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
 
     C                   ENDIF
 
     C     ESRUpdate     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *****************************************************************
 
     C     SRRdNBrw      BEGSR
 
     C                   CALLB     'SESECSBRW'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Key fields (file pointer)
     C                   PARM      *BLANKS       KeyLists
      *
      ** Selection fields (file select)
     C                   PARM      *BLANKS       KeySelect
      *
      ** Build subfile
     C                   PARM      *BLANK        PBdSfl
      *
      ** Read subfile record
     C                   PARM      'Y'           PRdSfl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - system run date
     C                   PARM                    BJMRDT
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default user branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Option selected
     C                   PARM                    PopSel
      *
      ** Security selected
     C                   PARM                    PSESNSel
      *
      ** Function key enabled - F3
     C                   PARM                    PINKC
      *
      ** Function key enabled - F12
     C                   PARM                    PINKL
      *
      ** If no security detail selected from subfile, reset
      ** read next browse subfile record indicator and then
      ** display initial screen with blank key fields.
      *
     C                   IF        POpSel = *BLANK
     C                   CLEAR                   CrSE1ScnFmt
     C                   CLEAR                   NwSE1ScnFmt
     C                   EVAL      PRdNb = *BLANK
     C                   EVAL      WScrn = 'I'
     C                   GOTO      ESRRdNBrw
     C                   ENDIF
      *
      ** Update action code with option selected.
      *
     C                   EVAL      DDACTN = POPSEL
      *
      ** Default action to enquiry if not valid.
      ** Valid entries are A(Amend), D(Delete) and E(Enquire).
      *
     C                   IF        DDACTN <> 'A' AND DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
      *
      ** Retrieve security details.
      *
     C                   EVAL      DDSESN = PSESNSel
 
     C                   EXSR      SRRtvSESN
      *
      ** If errors occurred in the retrieve module, display
      ** error messages on the initial screen.
      *
     C                   IF        IdX = 1 or IdX > 1 AND
     C                             MsgIdArr(1) <> 'APM1000'
     C                   EVAL      WScrn = 'I'
     C                   GOTO      ESRRdNBrw
     C                   ENDIF
      *
      ** Move the security details from the master database file
      ** into the update file record.
      *
     C**********         EVAL      NwSEFilFmt = CrSEFilFmt                                    CSE065
     C                   EVAL      NwSEFilFmt1 = CrSEFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     ALDT          S1ALDT                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S1ALDT                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Put security details on the screen.
      *
     C                   EXSR      SRPutSec
      *
      ** Display primary screen maintenance.
      *
     C                   EVAL      WScrn = 'P'
 
     C     ESRRdNBrw     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw - Build browse subfile record                       *
      *                                                               *
      *****************************************************************
 
     C     SRBldBrw      BEGSR
      *
      ** Reset Read Next Browse Subfile Record indicator.
      *
     C                   EVAL      PRdNb = *BLANK
      *
      ** Display browse screen.
      *
     C                   CALLB     'SESECSBRW'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Key fields (file pointer)
     C                   PARM                    KeyLists
      *
      ** Selection fields (file select)
     C                   PARM                    KeySelect
      *
      ** Build subfile
     C                   PARM      'Y'           PBdSfl
      *
      ** Read subfile record
     C                   PARM      *BLANK        PRdSfl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - system run date
     C                   PARM                    BJMRDT
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default user branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Option selected
     C                   PARM                    PopSel
      *
      ** Security selected
     C                   PARM                    PSESNSel
      *
      ** Function key enabled - F3
     C                   PARM                    PINKC
      *
      ** Function key enabled - F12
     C                   PARM                    PINKL
 
     C                   SELECT
      *
      ** F3 - End program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** Error message returned from browse.
     C                   WHEN      PErrMs <> *BLANKS
     C                   EXSR      SRSndM
      *
      ** F12 - Cancel. Go back to initial screen.
     C                   WHEN      PINKL = *ON
      *
      ** Redisplay Initial screen with blank screen fields.
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
      *
      ** Enter - read selected subfile records.
     C                   OTHER
 
     C                   EVAL      PRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
 
     C                   ENDSL
 
     C     ESRBldBrw     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRoll - Roll backward or forward through the security       *
      *           details file                                        *
      *                                                               *
      *****************************************************************
 
     C     SRRoll        BEGSR
      *
      ** Reset/clear previous errorwarning messages for every new record.
      *
     C                   EXSR      SRResetErr
      *
      ** Read next or previous record in the securities file
      ** according to function key taken (F7=INKG or F8=INKH).
      *
     C                   IF        PINKG = *ON
     C                   EVAL      PRdBck = 'Y'
     C                   EVAL      PRdFwd = *BLANK
     C                   ELSE
     C                   EVAL      PRdBck = *BLANK
     C                   EVAL      PRdFwd = 'Y'
     C                   ENDIF
 
     C                   CALLB     'SESECSRED'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    RetCodeOut
      *
      ** Security shortname (file pointer)
     C                   PARM                    DDSESN
      *
      ** Read backwards
     C                   PARM                    PRdBck
      *
      ** Read forwards
     C                   PARM                    PRdFwd
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Security shortname read
     C                   PARM                    PSeSnSel
      *
      ** If error message returned from read, send it to screen.
      *
     C                   IF        PErrMs <> *BLANKS
     C                   EXSR      SRSndM
     C                   GOTO      ESRRoll
     C                   ENDIF
      *
      ** Default Action to Enquiry if entry is invalid.  Valid
      ** entries are A(Amend), D(Delete) and E(Enquire).
      *
     C                   IF        DDACTN <> 'A' AND DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
      *
      ** Retrieve security details.
      *
     C                   MOVE      PSeSnSel      DDSESN
 
     C                   EXSR      SRRtvSESN
 
      *
      ** If errors occurred in the retrieval of security
      ** details, display error messages on the primary screen.
      *
     C                   IF        IdX <> *ZERO
     C                   EVAL      WScrn = 'I'
     C                   GOTO      ESRRoll
     C                   ENDIF
      *
      ** Move security details retrieved from the master database file
      ** into the update file record.
      *
     C**********         MOVEL     CrSEFilFmt    NwSEFilFmt                                   CSE065
     C                   MOVEL     CrSEFilFmt1   NwSEFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     ALDT          S1ALDT                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S1ALDT                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Put security details on the screen.
      *
     C                   EXSR      SRPutSec
 
     C                   EVAL      WScrn = 'P'
 
     C     ESRRoll       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvSESN - Retrieve security details                        *
      *                                                               *
      *****************************************************************
 
     C     SRRtvSESN     BEGSR
 
     C                   CALLB     'SESECSRTV'
      *                             =========
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front office transaction Id
     C                   PARM                    FRNT
      *
      ** Security shortname
     C                   PARM                    DDSESN
      *
      ** Old security shortname
     C                   PARM                    PParOSESN
      *
      ** Process old security details indicator
     C                   PARM                    PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** OK action code
     C                   PARM                    OKACTN
      *
      ** OK security shortname
     C                   PARM                    OKSESN
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Externally described DS for investment types
     C                   PARM                    PINVTP
 
     C     ESRRtvSESN    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutSec - Convert securities details from file to screen    *
      *             format                                            *
      *                                                               *
      *****************************************************************
 
     C     SRPutSec      BEGSR
 
     C                   MOVE      *BLANKS       RetCodeOut                                   216368
                                                                                              216368
     C                   CALLB     'SESECSCVT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Processing type - from file INVTPD
     C                   PARM                    PPROT
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Passed other information coming from link programs
     C                   PARM                    POthInf
      *
      ** Process old security details indicator
     C                   PARM                    PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run day number
     C                   PARM                    BJRDNB
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDMMOD - plato interface
     C                   PARM                    BGN2ST
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU securities decimals on nominals
     C                   PARM                    CEU018
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *                                                                         CSE023
      ** US Withholding tax treaty                                              CSE023
     C                   PARM                    CSE023                         CSE023
      *                                                                         CSD006
      ** Market Data Feed                                                       CSD006
     C                   PARM                    CSD006                         CSD006
      *                                                                         CAP060
      ** Midas APIs Sec Prices                                                  CAP060
     C                   PARM                    CAP060                         CAP060
      *                                                                         CSE031
      ** Coupon Fixing for Floating Rate Notes                                  CSE031
     C                   PARM                    CSE031                         CSE031
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              237063
      ** Multiple Holidays                                                                    237063
     C                   PARM                    CSE071                                       237063
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Security screen 1 details retrieved from file - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Security screen 2 details retrieved from file - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** Security screen 3 details retrieved from file - screen format
     C                   PARM                    CrSE3ScnFmt
      *                                                                                       CSE031
      ** Security screen 4 details retrieved from file - screen format                        CSE031
     C                   PARM                    CrSE4ScnFmt                                  CSE031
                                                                                              CAS006
      ** Security Screen 5 Details Retrieved From File - Screen Format                        CAS006
     C                   PARM                    CrSE5ScnFmt                                  CAS006
                                                                                              237063
      ** Security Screen 6 Details Retrieved From File - Screen Format                        237063
     C                   PARM                    CrSE6ScnFmt                                  237063
      *
      ** Last coupon date
     C                   PARM                    PLCPN
      *
      ** Next coupon date
     C                   PARM                    PNCD
                                                                                              CSC011
      ** Linked maintenance flag                                                              CSC011
                                                                                              CSC011
     C                   PARM                    PParmLink                                    CSC011
 
     C                   EVAL      NwSe1ScnFmt = CrSe1ScnFmt
     C                   EVAL      NwSe2ScnFmt = CrSe2ScnFmt
     C                   EVAL      NwSe3ScnFmt = CrSe3ScnFmt
     C                   EVAL      NwSe4ScnFmt = CrSe4ScnFmt                    CSE031
     C                   EVAL      NwSe5ScnFmt = CrSe5ScnFmt                                  CAS006
 
     C                   If        RetCodeOut <> *Blanks                                      216368
     C                   EVAL      WiX = 0                                                    216368
     C                   If        RetCodeOut = '*NOISSR   '                                  216368
     C                   EVAL      WiX = WiX + 1                                              216368
     C                   EVAL      WFldNamArr(WiX) = '*ANY'                                   216368
     C                   EVAL      WMsgIdArr(WiX) = 'SEA0520'                                 216368
     C                   Endif                                                                216368
     C                   If        RetCodeOut = '*NOLMGR   '                                  216368
     C                   EVAL      WiX = WiX + 1                                              216368
     C                   EVAL      WFldNamArr(WiX) = '*ANY'                                   216368
     C                   EVAL      WMsgIdArr(WiX) = 'SEA0521'                                 216368
     C                   Endif                                                                216368
     C                   Endif                                                                216368
                                                                                              216368
     C                   IF        CSE023 = 'Y'                                 CSE023
     C                   CLEAR                   DATA                           CSE023
                                                                                CSE023
     C                   IF        DDACTN <> 'I'                                CSE023
     C                   EVAL      #1CRTT = DDCRTT                              CSE023
     C                   EVAL      #1INCT = DDINCT                              CSE023
     C                   EVAL      #1EXCD = DDEXCD                              CSE023
     C                   EVAL      #1OIDI = DDOIDI                              CSE023
     C                   EVAL      #1APIE = DDAPIE                              CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C     ESRPutSec     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
 
     C     SRSndM        BEGSR
      *
      ** If single branching, user cannot browse file.
      *
     C                   IF        PErrMs = 'FXM0292'
     C                   EVAL      OKACTN = 'N'
     C                   ENDIF
      *
      ** Add error message to array passed to screen.
      *
     C                   Z-ADD     1             Ex
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   EVAL      FldNameArr(Ex) = '*ANY'
     C                   EVAL      MsgIdArr(Ex) = PErrMs
 
     C     ESRSndM       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - Set program to end                                  *
      *                                                               *
      *****************************************************************
 
     C     SREndP        BEGSR
      *
      ** Issue rollback to clear any possible updates in lower
      ** level programs.
      *
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *
      ** Set value of return code for linked processing.
      *
     C                   IF        PParmLink = 'Y'
     C                   EVAL      PParmRtcd = 'Y2U9999'
     C                   ENDIF
      *
      ** Set processing to end program.
      *
     C                   EVAL      WScrn = 'E'
 
     C     ESREndP       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetupKey - Setup keys for pointer or selection.            *
      *                                                               *
      *****************************************************************
 
     C     SRSetupKey    BEGSR
      *
      ** Setup key/selection fields.
      *
     C                   EVAL      WDSESN = DDSESN
     C                   EVAL      WDSRPN = DDSRPN
 
     C                   MOVEL     DDISSR        WDISSR
 
     C                   EVAL      WDNMCY = DDNMCY
     C                   EVAL      WDSITP = DDSITP
     C                   EVAL      WDPRTP = *BLANKS
     C                   EVAL      WDINCS = DDINCS
     C                   EVAL      WDISIN = DDISIN
     C                   EVAL      WDT2RF = DDT2RF
     C                   EVAL      WDSTAT = *BLANKS
 
     C     ESSetupKey    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClearScn - Clear screen data structures                    *
      *                                                               *
      *****************************************************************
 
     C     SRClearScn    BEGSR
      *
      ** Clear screen data structures for new processing.
      *
     C                   CLEAR                   CrSE1ScnFmt
     C                   CLEAR                   CrSE2ScnFmt
     C                   CLEAR                   CrSE3ScnFmt
     C                   CLEAR                   CrSE4ScnFmt                                  CSE031
     C                   CLEAR                   CrSE5ScnFmt                                  CAS006
 
     C                   CLEAR                   NwSE1ScnFmt
     C                   CLEAR                   NwSE2ScnFmt
     C                   CLEAR                   NwSE3ScnFmt
     C                   CLEAR                   NwSE4ScnFmt                                  CSE031
     C                   CLEAR                   NwSE5ScnFmt                                  CAS006
 
     C     ESClearScn    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
 
     C     SRResetErr    BEGSR
      *
      ** Reset error fields.
      *
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IdX
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIdX
      *
      ** Initialise screen fields error indicators.
      *
     C                   EVAL      SEESEC1 = *ALL'Y'
     C                   EVAL      SEESEC2 = *ALL'Y'
     C                   EVAL      SEESEC3 = *ALL'Y'
     C                   EVAL      SEESEC4 = *ALL'Y'                                          CSE031
     C                   EVAL      SEESEC5 = *ALL'Y'                                          CAS006
 
     C     ESRResetErr   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************         CSE023
      *                                                               *         CSE023
      * SRWindow - Call window manager program.                       *         CSE023
      *                                                               *         CSE023
      *****************************************************************         CSE023
                                                                                CSE023
     C     SRWindow      BEGSR                                                  CSE023
                                                                                CSE023
     C                   EVAL      #1PROT = PPROT                               CSE023
     C     DDACTN        IFNE      'E'                                                        220008
     C                   EVAL      #1SITP = DDSITP                                            220008
     C                   ENDIF                                                                220008
     C/COPY WNCPYSRC,SESECSSC01
      *                                                                         CSE023
      ** Call window manager.                                                   CSE023
      *                                                                         CSE023
     C                   CALL      'WN0010'                                     CSE023
     C                   PARM      'SESECSSIN'   PPgm                           CSE023
     C                   PARM                    PKey                           CSE023
     C                   PARM      DDACTN        PAction                        CSE023
     C                   PARM                    Data                           CSE023
     C                   PARM      *BLANKS       PRtcd                          CSE023
     C                   PARM      *BLANKS       PSpareW                        CSE023
      *                                                                         CSE023
      ** Process returned command keys.                                         CSE023
      ** F3, exit and return to calling program.                                CSE023
      *                                                                         CSE023
     C                   IF        PRtcd = 'Y2U9999'                            CSE023
     C                   EXSR      SREndP                                       CSE023
     C                   GOTO      ESRWindow                                    CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
      ** If Cmd12 pressed, return to previous screen;                           CSE023
      ** otherwise, go to confirmation screen.                                  CSE023
      *                                                                         CSE023
     C                   IF        PRtcd = 'USR0790'                            CSE023
      *                                                                         CSE023
      ** Redisplay previous screen.                                             CSE023
     C                   EVAL      WScrn = WOScrn                               CSE023
                                                                                CSE023
     C                   ELSE                                                   CSE023
      *                                                                         CSE023
     C                   SELECT                                                 CSE023
     C                   WHEN      DDACTN = 'E'                                 CSE023
      ** If securities maintenance has been called by linked                    CSE023
      ** maintenance/enquiry, terminate program.                                CSE023
     C                   IF        PParmLink = 'Y'                              CSE023
     C                   EVAL      PParmRtcd = *BLANK                           CSE023
     C                   EVAL      WScrn = 'E'                                  CSE023
     C                   GOTO      ESRWindow                                    CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
      ** Read Next Browse Subfile record.                                       CSE023
     C                   IF        PRdNb = 'Y'                                  CSE023
     C                   EVAL      WScrn = 'R'                                  CSE023
     C                   ELSE                                                   CSE023
     C                   EXSR      SRClearScn                                   CSE023
     C                   EVAL      WScrn = 'I'                                  CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   OTHER                                                  CSE023
      *                                                                         CSE023
      ** Otherwise, proceed to confirmation screen.                             CSE023
     C                   EVAL      WScrn = 'F'                                  CSE023
                                                                                CSE023
     C                   ENDSL                                                  CSE023
                                                                                CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C     ESRWindow     ENDSR                                                  CSE023
                                                                                CSE023
      *****************************************************************                      CGLL018
      *                                                               *                      CGLL018
      * SRScrn_Z - Call Securities Risk Weighted Asset Codes          *                      CGLL018
      *                                                               *                      CGLL018
      *****************************************************************                      CGLL018
                                                                                             CGLL018
     C     SRScrn_Z      BEGSR                                                               CGLL018
      *                                                                                      CGLL018
      ** Call Securities Risk weighted Asset Codes Maintenance                               CGLL018
      *                                                                                      CGLL018
     C                   CALL      'SEC001300'                                               CGLL018
     C                   PARM      *BLANK        PRtcd                                       CGLL018
     C                   PARM      DDSESN        PSesn                                       CGLL018
     C                   PARM      DDACTN        PAction                                     CGLL018
      *                                                                                      CGLL018
      ** Windows 2000 processing.                                                            CGLL018
     C                   IF        BGWDPR = 'Y'                                              CGLL018
     C                   EVAL      WOScrn = WScrn                                            CGLL018
     C                   EVAL      WScrn = 'W'                                               CGLL018
     C                   ELSE                                                                CGLL018
     C                   EVAL      WScrn = 'F'                                               CGLL018
     C                   ENDIF                                                               CGLL018
                                                                                             CGLL018
     C     ESRScrn_Z     ENDSR                                                               CGLL018
                                                                                             CGLL018
      *****************************************************************                      CGLL018
      /EJECT                                                                                 CGLL018
      *****************************************************************         CSE023
      /EJECT                                                                    CSE023
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Receive entry parameters.
      *
     C     *ENTRY        PLIST
      *
      ** Return code
     C                   PARM                    PParmRtcd
      *
      ** Action code
     C                   PARM                    PParmActn
      *
      ** Security shortname
     C                   PARM                    PParmSESN
      *
      ** Old security shortname
     C                   PARM                    PParOSESN
      *
      ** Other information
     C                   PARM                    PParOther
      *
      ** Linked maintenance flag
     C                   PARM                    PParmLink
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     1             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access ICD details for securities trading.
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDSTRDPD'
     C                   Z-ADD     2             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access midas modules.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   Z-ADD     3             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE005 (Effect of holidays on FRN
      ** coupon dates) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE005'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE005'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     4             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSE005 = 'Y'
     C                   ELSE
     C                   EVAL      CSE005 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE007 (Corporate actions)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE007'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE007'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     5             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSE007 = 'Y'
     C                   ELSE
     C                   EVAL      CSE007 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE011 (Duplicate security codes
      ** check) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE011'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE011'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     6             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSE011 = 'Y'
     C                   ELSE
     C                   EVAL      CSE011 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU017 (EMU securities
      ** denomination) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU017'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CEU017'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     7             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CEU017 = 'Y'
     C                   ELSE
     C                   EVAL      CEU017 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU018 (EMU securities decimals on
      ** nominals) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU018'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CEU018'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     8             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CEU018 = 'Y'
     C                   ELSE
     C                   EVAL      CEU018 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01401 (MT5XX message generation)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01401'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'S01401'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     9             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   EVAL      S01401 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01511 (Market migration)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01511'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'S01511'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     10            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      S01511 = 'Y'
     C                   ELSE
     C                   EVAL      S01511 = 'N'
     C                   ENDIF
      *                                                                         CSE023
      ** Access SAR file to determine if CSE023                                 CSE023
      ** (US Withholding tax treaty) is installed.                              CSE023
      *                                                                         CSE023
     C                   CALLB     'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       PRtcd                          CSE023
     C                   PARM      '*VERIFY'     POptn                          CSE023
     C                   PARM      'CSE023'      PSARD                          CSE023
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE023
      *                                                                         CSE023
      ** An NRF (No Record Found) return code is valid.                         CSE023
      ** Issue database error only for error return codes.                      CSE023
      *                                                                         CSE023
     C                   IF        PRtcd <> *BLANKS AND                         CSE023
     C                             PRtcd <> '*NRF   '                           CSE023
     C                   EVAL      DBKey = 'CSE023'                             CSE023
     C                   EVAL      DBFile = 'SCSARDPD'                          CSE023
     C                   Z-ADD     11            DBase                          CSE023
     C                   EXSR      *PSSR                                        CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   IF        PRtcd = *BLANKS                              CSE023
     C                   EVAL      CSE023 = 'Y'                                 CSE023
     C                   ELSE                                                   CSE023
     C                   EVAL      CSE023 = 'N'                                 CSE023
     C                   ENDIF                                                  CSE023
      *                                                                                       CAP060
      ** Access SAR details file to determine if CAP060                                       CAP060
      ** is switched on                                                                       CAP060
      *                                                                                       CAP060
     C                   CALLB     'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAP060'      @SARD             6                          CAP060
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP060
     C     @RTCD         IFEQ      *BLANK                                                     CAP060
     C                   MOVEL     'Y'           CAP060            1                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVEL     'N'           CAP060                                       CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
      *                                                                                       CSD006
      ** Access SAR details file to determine if Market Data Feed                             CSD006
      ** is switched on                                                                       CSD006
      *                                                                                       CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
     C     @RTCD         IFEQ      *BLANK                                                     CSD006
     C                   MOVEL     'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006                                       CSD006
     C                   END                                                                  CSD006
                                                                                              CSD006
      *                                                                                       CGL018
      ** Access SAR file to determine if CGL018 (Risk Weighted Assets)                        CGL018
      ** is installed.                                                                        CGL018
      *                                                                                       CGL018
     C                   CALLB     'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       PRtcd                                        CGL018
     C                   PARM      '*VERIFY'     POptn                                        CGL018
     C                   PARM      'CGL018'      PSARd                                        CGL018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL018
      *                                                                                       CGL018
      ** An NRF (No Record Found) return code is valid.                                       CGL018
      ** Issue database error only for error return codes.                                    CGL018
      *                                                                                       CGL018
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                    CGL018
     C                   EVAL      DBKey = 'CGL018'                                           CGL018
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL018
     C                   Z-ADD     12            DBase                                        CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   ENDIF                                                                CGL018
                                                                                              CGL018
     C                   IF        PRtcd = *BLANK                                             CGL018
     C                   EVAL      CGL018 = 'Y'                                               CGL018
     C                   ELSE                                                                 CGL018
     C                   EVAL      CGL018 = 'N'                                               CGL018
     C                   ENDIF                                                                CGL018
                                                                                              CGL018
      *                                                                         CSE031
      ** Access SAR file to determine if CSE031                                 CSE031
      ** (Coupon Fixing for Floating Rate Notes) is installed.                  CSE031
      *                                                                         CSE031
     C                   CALLB     'AOSARDR0'                                   CSE031
     C                   PARM      *BLANKS       PRtcd                          CSE031
     C                   PARM      '*VERIFY'     POptn                          CSE031
     C                   PARM      'CSE031'      PSARD                          CSE031
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE031
      *                                                                         CSE031
      ** An NRF (No Record Found) return code is valid.                         CSE031
      ** Issue database error only for error return codes.                      CSE031
      *                                                                         CSE031
     C                   IF        PRtcd <> *BLANKS AND                         CSE031
     C                             PRtcd <> '*NRF   '                           CSE031
     C                   EVAL      DBKey = 'CSE031'                             CSE031
     C                   EVAL      DBFile = 'SCSARDPD'                          CSE031
     C                   Z-ADD     12            DBase                          CSE031
     C                   EXSR      *PSSR                                        CSE031
     C                   ENDIF                                                  CSE031
                                                                                CSE031
     C                   IF        PRtcd = *BLANKS                              CSE031
     C                   EVAL      CSE031 = 'Y'                                 CSE031
     C                   ELSE                                                   CSE031
     C                   EVAL      CSE031 = 'N'                                 CSE031
     C                   ENDIF                                                  CSE031
                                                                                CSE031
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WkDate = BJRDNB                                            CSC011
     C                   EVAL      WkNext = BJDNWD                                            CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WkDate = S1DATE                                            CSC011
     C                   EVAL      WkNext = S1NEXT                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 12                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Access SAR details to see if CAS006 is enabled.                                      CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRTCD <> '*NRF'                                            CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY  = 'CAS006'                                          CAS006
     C                   EVAL      DBASE  = 13                                                CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Access SAR details to see if CSE065 is enabled.                                      CSE065
                                                                                              CSE065
     C                   CALLB     'AOSARDR0'                                                 CSE065
     C                   PARM      *BLANKS       PRTCD                                        CSE065
     C                   PARM      '*VERIFY'     POPTN                                        CSE065
     C                   PARM      'CSE065'      PSARD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
                                                                                              CSE065
     C                   IF        PRTCD = *BLANKS                                            CSE065
     C                   EVAL      CSE065 = 'Y'                                               CSE065
     C                   ELSE                                                                 CSE065
                                                                                              CSE065
     C                   IF        PRTCD <> '*NRF'                                            CSE065
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE065
     C                   EVAL      DBKEY  = 'CSE065'                                          CSE065
     C                   EVAL      DBASE  = 14                                                CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
      ** Access SAR details file to determine if Countervalue rounding                        CSE037
      ** is switched on                                                                       CSE037
      *                                                                                       CSE037
     C                   CALLB     'AOSARDR0'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD                                        CSE037
     C                   PARM      '*VERIFY'     @OPTN                                        CSE037
     C                   PARM      'CSE037'      @SARD                                        CSE037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE037
     C     @RTCD         IFEQ      *BLANK                                                     CSE037
     C                   MOVEL     'Y'           CSE037            1                          CSE037
     C                   ELSE                                                                 CSE037
     C                   MOVEL     'N'           CSE037                                       CSE037
     C                   ENDIF                                                                CSE037
                                                                                              CSE037
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 13                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
                                                                                              CGL032
      ** Access SAR details file to determine if Automatic Exchange                           CGL032
      ** of Information is on.                                                                CGL032
                                                                                              CGL032
     C                   CALL      'AOSARDR0'                                                 CGL032
     C                   PARM      *BLANKS       PRtcd                                        CGL032
     C                   PARM      '*VERIFY'     POptn                                        CGL032
     C                   PARM      'CGL032'      PSARd                                        CGL032
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL032
      *                                                                                       CGL032
      ** An NRF (No Record Found) return code is valid.                                       CGL032
      ** Issue database error only for error return codes.                                    CGL032
      *                                                                                       CGL032
     C                   IF        PRtcd <> *BLANKS AND                                       CGL032
     C                             PRtcd <> '*NRF   '                                         CGL032
     C                   EVAL      DBKey = 'CGL032'                                           CGL032
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL032
     C                   Z-ADD     14            DBase                                        CGL032
     C                   EXSR      *PSSR                                                      CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   IF        PRtcd = *BLANKS                                            CGL032
     C                   MOVEL     'Y'           CGL032                                       CGL032
     C                   ELSE                                                                 CGL032
     C                   MOVEL     'N'           CGL032                                       CGL032
     C                   END                                                                  CGL032
                                                                                              CGL032
      ** Access SAR details file to determine if Taxation on Sav-                             CGL031
      ** ings Income is on.                                                                   CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARd                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
      *                                                                                       CGL031
      ** An NRF (No Record Found) return code is valid.                                       CGL031
      ** Issue database error only for error return codes.                                    CGL031
      *                                                                                       CGL031
     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
     C                             PRtcd <> '*NRF   '                                         CGL031
     C                   EVAL      DBKey = 'CGL031'                                           CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   Z-ADD     15            DBase                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   END                                                                  CGL031
                                                                                              237063
      ** Check if CSE071 is enabled.                                                          237063
                                                                                              237063
     C                   CALL      'AOSARDR0'                                                 237063
     C                   PARM      *BLANKS       PRtcd                                        237063
     C                   PARM      '*VERIFY'     POptn                                        237063
     C                   PARM      'CSE071'      PSARd                                        237063
     C     SCSARD        PARM      SCSARD        DSFDY                                        237063
                                                                                              237063
     C                   EVAL      CSE071 = 'N'                                               237063
                                                                                              237063
     C                   IF        PRtcd = *BLANKS                                            237063
     C                   EVAL      CSE071 = 'Y'                                               237063
     C                   ELSE                                                                 237063
                                                                                              237063
     C                   IF        PRtcd <> '*NRF   '                                         237063
     C     *LOCK         IN        LDA                                                        237063
     C                   EVAL      DBKey = 'CSE071'                                           237063
     C                   EVAL      DBFile = 'SCSARDPD'                                        237063
     C                   EVAL      DBase = 16                                                 237063
     C                   OUT       LDA                                                        237063
     C                   EXSR      *PSSR                                                      237063
     C                   ENDIF                                                                237063
                                                                                              237063
     C                   ENDIF                                                                237063
                                                                                              237063
      *                                                                                      LLN022A
      ** Access Switchable Features file to determine whether                                LLN022A
      ** LLN022 (Bank of England) processing is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        PRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
     C                   PARM      'LLN022'      PSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        PRTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   IF        PParmLink = 'Y'
 
     C                   EVAL      DDACTN = PParmActn
     C                   EVAL      PParmRtcd = *BLANKS
 
     C                   IF        PParmActn = 'I'
 
     C                   IF        CSE007 = 'Y' AND PParOSESN <> *BLANKS
     C                   EVAL      DDSESN = PParmSESN
     C                   EVAL      PPOldSecDtl = 'Y'
     C                   ELSE
     C                   EVAL      DDSESN = *BLANKS
     C                   EVAL      PPOldSecDtl = 'N'
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      DDSESN = PParmSESN
 
     C                   ENDIF
      *
      ** Validate initial screen details.
     C                   EXSR      SRVal_I
      *
      ** If errors encountered during initial validation, set screen to
      ** initial screen.  Otherwise, proceed to primary screen.
     C                   IF        Idx <> 0
     C                   EVAL      WScrn = 'I'
     C                   ELSE
     C                   EVAL      WScrn = 'P'
     C                   ENDIF
 
     C                   ELSE
      *
      ** If not from linked processing, then start at initial screen.
     C                   EVAL      WScrn = 'I'
 
     C                   ENDIF
 
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SESECS012
 
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RtCd = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 14                                                 CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
