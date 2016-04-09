     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities trade SWIFT screen 1')             *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SE001805 - Securities Trade SWIFT Screen 1                   *
      *                                                               *
      *  Function:  This module is a replacement for SE1805.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. AR630707           Date 23Aug10               *
      *                 AR598682           Date 14Aug10               *
      *                 AR597791           Date 13Aug10               *
      *                 AR580916           Date 22Jul10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 23Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 216338             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211705             Date 07Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 202863             Date 21May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204833             Date 03May02               *
      *                 CSE034             Date 23Apr02               *
      *                 201429             Date 15Jan02               *
      *                 201233             Date 20Dec01               *
      *                 201192             Date 17Dec01               *
      *                 CAP067             Date 24Sep01               *
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 02Oct01               *
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR630707 - BULK - Extended Settlement appear twice even if   *
      *             Deliver From and Deliver To values are the same   *
      *  AR598682 - Trades Input screen are shown twice even if values*
      *             Deliver From and Deliver To are the same          *
      *  AR597791 - Message information details inputted in BULK      *
      *             were not saved                                    *
      *  AR580916 - Customer/CParty Indicator always defaulted        *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  216338 - Add missing parameter                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  211705 - Decimal Data Error occured in SETRADEDSP due to     *
      *           wrong value of TDVD.                                *
      *  202863 - Transfer the correct value date.                    *
      *  204833 - Correct display of SSI.                             *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  201233 - If message is unroutable, settlement of message     *
      *           request cannot be a 'Y'.                            *
      *  201192 - Buy-sell back give db error when going to ext.      *
      *           settlement screen.                                  *
      *           Initialize numeric parameters.                      *
      *  CAP067 - Repurchase Agreements API.                          *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CPK014 - Release 4 Packaging                                 *
      *           Fix parameter mismatch
      *  CSE028 - Standing Settlement Instructions                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     - Initial Processing                              *
      *  SRConvert  - Convert file fields to screen field counterpart *
      *  SRInitFld  - Convert file fields to screen field counterpart *
      *  SRDisplayA - Process Extension (SWIFT) Screen A              *
      *  SRDisplayB - Process Extension (SWIFT) Screen B              *
      *  SRScreenA  - Convert file fields to Screen A field           *
      *  SRScreenB  - Convert file fields to Screen B field           *
      *  SRDfltA    - Do defaulting for extension Screen A            *
      *  SRDfltB    - Do defaulting for extension Screen B            *
      *  SRInputVal - Set up input parameters to SETRADEVAL           *
      *  SRValA     - Validate input to extention screen A            *
      *  SRValB     - Validate input to Extension Screen B            *
      *  SREuroClr  - Remove leading blanks from Euroclear/Cedel Code *
      *  SRSE1852   - Calls Security Certificate No. Maintenance      *
      *  SRZM1100   - Determine the Network Routing/Address           *
      *  SRReset    - F5 key is pressed                               *
      *  SRCanc     - F12 key is pressed                              *
      *  SREndP     - End of Program                                  *
      *  SRReturn   - Return to calling program                       *
      *  SRUpdate   - Update to files                                 *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTRADSDY1  UF A E           K DISK    COMMIT
                                                                                              199797
     F***TRADSDY2  IF A E           K DISK    COMMIT                               AR598682 AR630707
     FTRADSDY2  UF A E           K DISK    COMMIT                                           AR630707
                                                                                            AR598682
     FSECTY     IF   E           K DISK    INFSR(*pssr)                                       199797
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
      ** SE Trades File
     D SETradsd      E DS                  EXTNAME(TRADSD)
 
      ** SE Trades MT5xx DS Template
     D SETrades      E DS                  EXTNAME(SE50DT)
 
      ** SE Trades Extension File 1
     D SEExtFile     E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(W1:2)
 
      ** SE Trades Extension Settlement
     D SEExtSett     E DS                  EXTNAME(TRADSDX2)
     D SEExtSetB     E DS                  EXTNAME(TRADSDX2)                                AR630707
     D                                     PREFIX(B)                                        AR630707
 
      ** New Trade in File Format
     D NwTrFilFmt    E DS                  EXTNAME(SEVTRADPD)
     D                                     PREFIX(NW)
 
      ** New Trade in screen format - Primay Details
     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
 
      ** New Trade in screen Format - Secondary Details
     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
 
      ** New Trade in Screen Format - Settlement Details
     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
     D  DDCLTY_S     E                     EXTFLD(DDCLTY)
 
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
                                                                                              222373
     D NewTrExts     E DS                  EXTNAME(SETESDPD)                                  222373
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(@A_)                                        222373
 
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B_)
 
      ** New Trade in Screen Format - Exchange Rate Details
     D NewTrExch     E DS                  EXTNAME(SETREXPD)
 
      * New Trade in File Format
     D NT1AFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(A_)
 
      * New Trade in File Format (Extension File)
     D NT1BFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(B_)
 
      ** Current Trade in Screen Format - SWIFT Details
     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@A)
 
      ** (Current) Trade in Screen Format - SWIFT Details
     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@B)
 
      ** Current Trade in File Format (Extension File)
     D CT1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CA_)
                                                                                              216338
      ** TRADSDX2 record                                                                      216338
     D PTradeX2      E DS                  EXTNAME(TRADSDX2)                                  216338
     D                                     PREFIX(X2:2)                                       216338
 
      ** Error Indicators
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
     D OKTrExts      E DS                  EXTNAME(SEETESPD)                                  222373
 
      * Previous Trade in Screen Format - SWIFT Details
     D PrvTrSwft     E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@P)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS For Accentt programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** SE Trades Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SETDEXPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Securities Clients
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** SC Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
 
     D TIMEST          DS            26
     D  TMS05                  4      5
     D  TMS08                  7      8
     D  TMS11                 10     11
     D  TMS14                 14     14
     D  TMS17                 17     17
     D  TMS20                 20     20
 
     D EUCLA           S              1    DIM(6)
     D EUCLB           S              1    DIM(6)
     D ROU             S              1    DIM(12)
 
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
     D PMCWL           DS          9999                                                       CSD015
                                                                                              CSD015
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D PCommand        S              2A
     D PMode           S              1A
     D PError          S              1A
     D PSARD           S              6A
     D COUNT           S              5  0
 
     D A_##DELF        S             10
     D A_##DELT        S             10
     D A_##SMTH        S              2
 
     D DDSRPN          S             20
     D SEUCL           S             10
 
     D CSE006          S              1
     D CSW003          S              1
     D WFirst          S              1    INZ(*Blanks)
 
     D DFCLAS          S                   LIKE(BFCLAS) INZ(*Blanks)
     D DFDRF1          S                   LIKE(BFDRF1) INZ(*Blanks)
     D DFDRF2          S                   LIKE(BFDRF2) INZ(*Blanks)
 
     D DTCLAS          S                   LIKE(BFCLAS) INZ(*Blanks)
     D DTDRF1          S                   LIKE(BFDRF1) INZ(*Blanks)
     D DTDRF2          S                   LIKE(BFDRF2) INZ(*Blanks)
 
     D SWRtnCode       S              7
 
      ** Key Fields
     D KTDRF           S              6A
     D KWHEN           S              1A
 
      ** Temporary working defined fields
     D WWACTN          S              2
     D WWTDRF          S              6
     D WPTCNR          S              6A
     D W0EUCL          S              6A
     D WKEUCL          S              7A
     D WSNDR           S              6A
     D WDEST           S              6A
     D WSCSD           S             12A
     D WSETP           S              2A
     D WWSENT          S              5A
     D*WWDEST***       S              6  0                                                    CSD027
     D WWDEST          S              6A                                                      CSD027
     D TMPSEN          S              5A
     D WNWSN           S             20A
     D WNWDS           S             22A
     D WNWRK           S              6A
     D WERRC           S              1A
     D WSRNM           S             20A
     D WSRTN           S             10A
     D WSIOR           S              1A
     D WDRNM           S             20A
     D WDRTN           S             10A
     D WWGME           S              1A
     D WWROU           S              6A
     D WKROT           S             12A
 
     D I               S              5  0
     D J               S              2  0
     D K               S              2  0
 
     D PrvN_Warn       S              3  0
 
     D A_DDROUS        S              6A
     D A_DDROTS        S             12A
     D A_DDROUC        S              6A
     D A_DDROTC        S             12A
     D B_DDROUS        S              6A
     D B_DDROTS        S             12A
     D B_DDROUC        S              6A
     D B_DDROTC        S             12A
 
     D @INKC           S              1A
     D @INKE           S              1A
     D @INKL           S              1A
     D @INKN           S              1A
     D Screen          S              1A
 
     D A_##TDRF        S              6A
     D A_##TDTP        S              2A
     D A_##CLTY        S              1A
     D A_##PCOD        S              1A
     D A_##PRYC        S              1A
     D A_##CNUM        S             10A
     D B_##TDRF        S              6A
     D B_##TDTP        S              2A
     D B_##CLTY        S              1A
     D B_##PCOD        S              1A
     D B_##SMTH        S              2A
     D B_##PRYC        S              1A
     D B_##CNUM        S             10A
     D B_##DELF        S             10A
     D B_##DELT        S             10A
 
     D Idx             S              3  0
     D WIdx_EVALA      S              3  0
 
     D PROT            S              1
     D RespMode        S              1
     D OVRErrors       S              1
 
     D WWNML           S             11  0
     D WWRTCD          S              1
     D WWRANG          S              1
 
     D CB_T1CONG       S              1
     D WIdx_EVALB      S              3  0
 
     D PCALL           S              3A                                                      222373
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                              CSC022
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EVAL      TDVD   = PTDVD                                             211705
      *                                                                                       211705
     C                   IF        WFirst = *Blanks
     C                   EXSR      SRInit
     C                   EXSR      SRConvert
     C                   ENDIF
 
     C                   EVAL      PUYAT = 'N'                                                201429
     C                   DOW       PMode = 'A'
     C                   EXSR      SRDisplayA
     C                   ENDDO
 
     C                   EVAL      PUYAT = 'N'                                                201429
     C                   DOW       PMode = 'B'
     C                   EXSR      SRDisplayB
     C                   ENDDO
 
     C                   IF        PACTN = 'B' and PMode = 'R'                              AR597791
     C                   MOVEL     'U'           PMODE                                      AR597791
     C                   ENDIF                                                              AR597791
     C                                                                                      AR597791
     C                   IF        PMode = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   IF        PMode = 'R'
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   IF        PMode = 'T'
     C                   EVAL      *INLR = *On
     C                   ENDIF
 
      *****************************************************************                       201192
      /EJECT                                                                                  201192
      *****************************************************************                       201192
      *                                                               *                       201192
      *  SRCLER - Clear numeric variables                             *                       201192
      *                                                               *                       201192
      *****************************************************************                       201192
     C     SRCLER        BEGSR                                                                201192
      *                                                                                       201192
     C**********         Z-ADD     0             NWTCNR                                201192 CSD027
     C                   EVAL      NWTCNR = *BLANKS                                           CSD027
     C                   Z-ADD     0             NWNOML                                       201192
     C                   Z-ADD     0             NWTNMD                                       201192
     C                   Z-ADD     0             NWTPDY                                       201192
     C                   Z-ADD     0             NWTDVD                                       201192
     C                   Z-ADD     0             NWTDDT                                       201192
     C                   Z-ADD     0             NWTCAP                                       201192
     C                   Z-ADD     0             NWDADJ                                       201192
     C                   Z-ADD     0             NWITRA                                       201192
     C                   Z-ADD     0             NWTINA                                       201192
     C                   Z-ADD     0             NWTDCR                                       201192
     C                   Z-ADD     0             NWPRIC                                       201192
     C                   Z-ADD     0             NWRALL                                       201192
     C                   Z-ADD     0             NWTDER                                       201192
     C                   Z-ADD     0             NWTBCR                                       201192
     C                   Z-ADD     0             NWSMTH                                       201192
     C                   Z-ADD     0             NWASNM                                       201192
     C**********         Z-ADD     0             NWDELT                                201192 CSD027
     C**********         Z-ADD     0             NWDELF                                201192 CSD027
     C                   EVAL      NWDELT = *BLANKS                                           CSD027
     C                   EVAL      NWDELF = *BLANKS                                           CSD027
     C                   Z-ADD     0             NWTBCA                                       201192
     C                   Z-ADD     0             NWTCCA                                       201192
     C                   Z-ADD     0             NWTCA1                                       201192
     C                   Z-ADD     0             NWTCA2                                       201192
     C                   Z-ADD     0             NWTCA3                                       201192
     C                   Z-ADD     0             NWTCA4                                       201192
     C                   Z-ADD     0             NWTCA5                                       201192
     C                   Z-ADD     0             NWTCA6                                       201192
     C                   Z-ADD     0             NWTCA7                                       201192
     C                   Z-ADD     0             NWTAXA                                       201192
     C                   Z-ADD     0             NWBCMR                                       201192
     C                   Z-ADD     0             NWCCMR                                       201192
     C                   Z-ADD     0             NWTXRB                                       201192
     C                   Z-ADD     0             NWTIME                                       201192
     C                   Z-ADD     0             NWTOSN                                       201192
     C                   Z-ADD     0             NWTNSN                                       201192
     C                   Z-ADD     0             NWTNSP                                       201192
     C                   Z-ADD     0             NWTOSV                                       201192
     C                   Z-ADD     0             NWTVSN                                       201192
     C                   Z-ADD     0             NWTVSP                                       201192
     C                   Z-ADD     0             NWTDSN                                       201192
     C                   Z-ADD     0             NWTDSP                                       201192
     C                   Z-ADD     0             NWTDFS                                       201192
     C                   Z-ADD     0             NWTSSQ                                       201192
     C                   Z-ADD     0             NWTCSR                                       201192
     C                   Z-ADD     0             NWTCTR                                       201192
     C                   Z-ADD     0             NWTDMC                                       201192
     C                   Z-ADD     0             NWTOED                                       201192
     C                   Z-ADD     0             NWLCD                                        201192
     C                   Z-ADD     0             NWTNLU                                       201192
     C                   Z-ADD     0             NWLSWS                                       201192
     C                   Z-ADD     0             NWTCFC                                       201192
     C                   Z-ADD     0             NWSPXR                                       201192
     C                   Z-ADD     0             NWFXMP                                       201192
     C                   Z-ADD     0             NWFXMR                                       201192
     C                   Z-ADD     0             NWMAMT                                       201192
     C                   Z-ADD     0             NWORDE                                       201192
     C                   Z-ADD     0             NWWHTX                                       201192
     C                   Z-ADD     0             CA_T1LSWS                                    201192
     C                   Z-ADD     0             CA_T1LSSC                                    201192
     C                   Z-ADD     0             A_T1LSWS                                     201192
     C                   Z-ADD     0             A_T1LSSC                                     201192
     C                   Z-ADD     0             B_T1LSWS                                     201192
     C                   Z-ADD     0             B_T1LSSC                                     201192
      *                                                                                       201192
     C                   ENDSR                                                                201192
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRInit - Initial Processing                                  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        ReturnCode <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = @Optn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSW003 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW003'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
 
     C                   IF        ReturnCode = *Blanks
     C                   EVAL      CSW003 = 'Y'
     C                   ELSE
     C                   EVAL      CSW003 = 'N'
     C                   ENDIF
 
      ** Check if CSW098 is installed
 
     C                   CALL      'SWIFT98'
     C                   PARM                    SWRtnCode
 
     C     Key001        KLIST
     C                   KFLD                    KTDRF
     C                   KFLD                    KWHEN
 
     C                   EVAL      KWHEN = 'A'
     C                   EVAL      KTDRF = PTDRF
 
     C                   EVAL      DFCLas = *Blanks
     C                   EVAL      DFDRF1 = *Blanks
     C                   EVAL      DFDRF2 = *Blanks
     C                   EVAL      DTCLas = *Blanks
     C                   EVAL      DTDRF1 = *Blanks
     C                   EVAL      DTDRF2 = *Blanks
 
     C**********         IF        PDELF <> *Zeros                                            CSD027
     C                   IF        PDELF <> *Blanks                                           CSD027
 
     C                   MOVE      PDELF         WPTCNR
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    WPTCNR
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   IF        ReturnCode <> *Blanks
 
     C                   EVAL      DBFILE = 'SDSECSPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = WPTCNR
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      DFClas = BFClas
     C                   EVAL      DFDRF1 = BFDRF1
     C                   EVAL      DFDRF2 = BFDRF2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         IF        PDELT <> *Zeros                                            CSD027
     C                   IF        PDELT <> *Blanks                                           CSD027
 
     C                   MOVE      PDELT         WPTCNR
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    WPTCNR
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   IF        ReturnCode <> *Blanks
 
     C                   EVAL      DBFILE = 'SDSECSPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = WPTCNR
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      DTClas = BFClas
     C                   EVAL      DTDRF1 = BFDRF1
     C                   EVAL      DTDRF2 = BFDRF2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      PTCNR         WPTCNR
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    WPTCNR
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   IF        ReturnCode <> *Blanks
     C                   EVAL      DBFILE = 'SDSECSPD'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = WPTCNR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PMODE = 'A'
 
      ** Initialize Timestamp
 
     C                   EVAL      TIMEST = *ZEROS
     C                   EVAL      TMS05 = '1-'
     C                   EVAL      TMS08 = '1-'
     C                   EVAL      TMS11 = '1-'
     C                   EVAL      TMS14 = '.'
     C                   EVAL      TMS17 = '.'
     C                   EVAL      TMS20 = '.'
 
     C                   MOVEL     TIMEST        T1TMST
 
     C                   EVAL      T1CONG = 'N'
     C                   EVAL      T1RCDG = 'N'
                                                                                              CAP067
      ** Check if CSW201 - Swift 2001 Standards Update is installed                           CAP067
                                                                                              CAP067
     C                   CALL      'SWIF2001'                           9090                  CAP067
     C                   PARM      *BLANKS       @RTCD                                        CAP067
                                                                                              CAP067
     C                   IF        *IN90 = *ON                                                CAP067
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP067
     C                   EVAL      DBASE = 912                                                CAP067
     C                   EVAL      DBKEY = 'CSW201'                                           CAP067
     C                   EXSR      *PSSR                                                      CAP067
                                                                                              CAP067
     C                   ELSE                                                                 CAP067
     C                   IF        @RTCD = 'CSW2001'                                          CAP067
     C                   EVAL      CSW201 = 'Y'                                               CAP067
     C                   ELSE                                                                 CAP067
     C                   EVAL      CSW201 = 'N'                                               CAP067
     C                   ENDIF                                                                CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** Initialise parameters                                                                CAP067
     C                   EXSR      SRCLER                                                     CAP067
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert file fields to screen field couterparts  *
      *                                                               *
      *  Called by:  Main Processing                                  *
      *                                                               *
      *  Calls:      SRInit                                           *
      *              SRScreenA                                        *
      *              SRScreenB                                        *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
      ** Convert to screen fields (Screen A)
 
     C                   EVAL      KWHEN = 'A'
     C     Key001        CHAIN     TRADSDY1                           01
 
     C                   IF        *IN01 = *OFF
 
     C                   EXSR      SRScreenA
 
     C                   ELSE
 
     C                   IF        PACTN = 'I'
     C                   EXSR      SRInitFld
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      DDACTN = PACTN
     C                   EVAL      DDTDRF = PTDRF
     C                   EVAL      DDSESN = PSESN
     C                   EVAL      DDBLKR = PBLKR
     C                   EVAL      DDTDTP = PTDTP
     C                   EVAL      DDBRCD = PTDBR
 
     C                   MOVE      PNOML         DDNOML
     C                   EVAL      DDCLTY = PCLTY
     C                   MOVE      PSMTH         DDSMTH
     C                   EVAL      DDPCOD = PPCOD
     C                   MOVE      PTCNR         DDCNUM
     C                   EVAL      DDPRYC = PPRYC
     C                   MOVE      PDELF         DDDELF
     C                   MOVE      PDELT         DDDELT
 
      ** Convert to screen fields (Screen B)
 
     C                   EVAL      KWHEN = 'B'
     C     Key001        CHAIN     TRADSDD1                           01
 
     C                   IF        *IN01 = *OFF
     C                   EXSR      SRScreenB
     C                   ENDIF
 
     C                   EVAL      DDSRPN = PSRPN
     C                   EVAL      DDSRNME = PSRPN                                            CAP067
 
      ** Set the First Pass Parameter
 
     C                   EVAL      WFirst = 'N'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitFld - Default screen fields                            *
      *                                                               *
      *  Called by:  SRConvert                                        *
      *                                                               *
      *  Calls:      SREuroClr                                        *
      *                                                               *
      *****************************************************************
     C     SRInitFld     BEGSR
 
     C                   IF        CSW003 = 'Y'
 
     C                   IF        PTDTP = 'TP'
 
     C                   SELECT
 
     C                   WHEN      PCLTY = '1'
     C                   EVAL      DDINST = '01'
     C                   EVAL      DDINSS = 'MATCH'
 
     C                   WHEN      PCLTY = '2'
 
     C                   SELECT
     C                   WHEN      DFCLAS = 'C'
     C                   EVAL      DDINST = '03C'
     C                   EVAL      DDINSS = 'MATCH'
     C                   WHEN      DFCLAS = 'K'
     C                   EVAL      DDINST = '03K'
     C                   WHEN      DFCLAS = 'X' OR DFCLAS = 'M'
     C                   EVAL      DDINST = '03'
     C                   ENDSL
 
     C                   WHEN      PCLTY = '3'
 
     C                   IF        PPCOD = '1' or PPCOD = '5'
     C                   EVAL      DDINST = '41'
     C                   ENDIF
 
     C                   WHEN      PCLTY = '4' and DFCLAS = 'E'
 
     C                   IF        PPCOD = '1' or PPCOD = '5'
     C                   EVAL      DDINST = '41'
     C                   ENDIF
 
     C                   ENDSL
 
      ** Else Trade Sale
 
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      PCLTY = '1'
 
     C                   EVAL      DDINST = '02'
     C                   EVAL      DDINSS = 'MATCH'
 
     C                   WHEN      PCLTY = '2'
 
     C                   SELECT
     C                   WHEN      DTCLAS = 'C'
     C                   EVAL      DDINST = '07C'
     C                   EVAL      DDINSS = 'MATCH'
     C                   WHEN      DTCLAS = 'K'
     C                   EVAL      DDINST = '07K'
     C                   WHEN      DTCLAS = 'X' or DTCLAS = 'M'
     C                   EVAL      DDINST = '07'
     C                   ENDSL
 
     C                   WHEN      PCLTY = '3'
 
     C                   IF        PPCOD = '1' or PPCOD = '5'
     C                   EVAL      DDINST = '51'
     C                   ELSE
     C                   EVAL      DDINST = '31'
     C                   ENDIF
 
     C                   WHEN      PCLTY = '4' AND DTCLAS = 'E'
 
     C                   IF        PPCOD = '1' OR PPCOD = '5'
     C                   EVAL      DDINST = '51'
     C                   ELSE
     C                   EVAL      DDINST = '31'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Init Euroclear/Cedel code
 
     C                   MOVE      *BLANKS       WKEUCL
 
     C                   IF        BFCLAS = 'M'
 
      ** Internal EOC.
 
     C                   IF        PCLTY = '1'
     C                   MOVEA(P)  PC101         EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      SEUCL
     C                   ENDIF
 
      ** Bridge EOC.
 
     C                   IF        PCLTY = '2'
     C                   MOVEA(P)  PC101         EUCLA
     C                   EXSR      SREuroClr
     C     '//XE'        CAT(P)    WKEUCL:0      SEUCL
     C                   ENDIF
 
      ** Internal Cedel.
 
     C                   IF        PCLTY = '3'
     C                   MOVEA(P)  PC102         EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      SEUCL
     C                   ENDIF
 
      ** Bridge Cedel.
 
     C                   IF        PCLTY = '4'
     C                   MOVEA(P)  PC102         EUCLA
     C                   EXSR      SREuroClr
     C     '//XC'        CAT(P)    WKEUCL:0      SEUCL
     C                   ENDIF
 
      ** More Bridge EOC.
 
     C                   IF        PCLTY = '2'
 
     C                   IF        PTDTP = 'TP' AND DFCLAS = 'C' OR
     C                             PTDTP = 'TS'  AND DTCLAS = 'C'
     C                   MOVEA(P)  PC102         EUCLA
     C                   EXSR      SREuroClr
     C     '//XC'        CAT(P)    WKEUCL:0      SEUCL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PCLTY = '4'
 
     C                   IF        PTDTP = 'TP'  AND DFCLAS = 'E' OR
     C                             PTDTP = 'TS'  AND DTCLAS = 'E'
     C                   MOVEA(P)  PC101         EUCLA
     C                   EXSR      SREuroClr
     C     '//XE'        CAT(P)    WKEUCL:0      SEUCL
     C                   ENDIF
 
     C                   ENDIF
 
      ** Else  (S or D)
 
     C                   ELSE
 
     C                   IF        PDELT <> PDELF
 
     C                   IF        PTDTP = 'TP'
 
     C                   SELECT
 
     C                   WHEN      PCLTY = '1'
     C                   MOVEA(P)  DFDRF1        EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      SEUCL
 
     C                   WHEN      PCLTY = '3'
     C                   MOVEA(P)  DFDRF2        EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      SEUCL
 
     C                   WHEN      PCLTY = '2' AND DFCLAS = 'C'
     C                   MOVEA(P)  DFDRF2        EUCLA
     C                   EXSR      SREuroClr
     C     '//XC'        CAT(P)    WKEUCL:0      SEUCL
 
     C                   WHEN      PCLTY = '4' AND DFCLAS = 'E'
     C                   MOVEA(P)  DFDRF1        EUCLA
     C                   EXSR      SREuroClr
     C     '//XE'        CAT(P)    WKEUCL:0      SEUCL
 
     C                   ENDSL
 
      ** Else  (TS)
 
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      PCLTY = '1'
     C                   MOVEA(P)  DTDRF1        EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      SEUCL
     C                   WHEN      PCLTY = '3'
     C                   MOVEA(P)  DTDRF2        EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      SEUCL
     C                   WHEN      PCLTY = '2' AND DTCLAS = 'C'
     C                   MOVEA(P)  DTDRF2        EUCLA
     C                   EXSR      SREuroClr
     C     '//XC'        CAT(P)    WKEUCL:0      SEUCL
     C                   WHEN      PCLTY = '4' AND DTCLAS = 'E'
     C                   MOVEA(P)  DTDRF1        EUCLA
     C                   EXSR      SREuroClr
     C     '//XE'        CAT(P)    WKEUCL:0      SEUCL
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVEL     SEUCL         DDEUCL
 
      ** Init Safekeeping Account
 
     C                   IF        PTDTP = 'TP'
 
     C                   SELECT
     C                   WHEN      PCLTY = '1' OR PCLTY = '2'
     C                   MOVE      DTDRF1        DDSAFA
     C                   MOVEL     '/'           DDSAFA
     C                   WHEN      PCLTY = '3' OR PCLTY = '4'
     C                   MOVE      DTDRF2        DDSAFA
     C                   MOVEL     '/'           DDSAFA
     C                   ENDSL
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      PCLTY = '1' OR PCLTY = '2'
     C                   MOVE      DFDRF1        DDSAFA
     C                   MOVEL     '/'           DDSAFA
     C                   WHEN      PCLTY = '3' OR PCLTY = '4'
     C                   MOVE      DFDRF2        DDSAFA
     C                   MOVEL     '/'           DDSAFA
     C                   ENDSL
 
     C                   ENDIF
 
      ** Determine Network routing and addresses/settlements
 
     C                   IF        PTDTP = 'TP'
     C                   MOVE      PDELT         WSNDR
     C                   MOVE      PDELT         WDEST
     C                   ELSE
     C                   MOVE      PDELF         WSNDR
     C                   MOVE      PDELF         WDEST
     C                   ENDIF
 
     C                   MOVE      *BLANKS       WSCSD
     C                   MOVE      PSMTH         WSETP
      *
     C                   EXSR      SRZM1100
 
     C                   MOVE      WWGME         DDGMES
     C                   MOVE      WWROU         A_DDROUS
     C                   MOVE      WKROT         A_DDROTS
 
      ** Default Settlement request to N if backvaluation
 
     C                   IF        PACTN = 'I' AND PTDVD < BJRDNB
     C                   MOVE      'N'           DDGMES
     C                   ENDIF
 
      ** Retrieve Cedel/Euroclear destination
 
     C                   MOVE      *BLANKS       WWSENT
     C                   MOVE      WDEST         WWDEST
 
     C                   IF        WWDEST = PDELT
 
     C                   IF        DTCLAS = 'E'
 
     C                   MOVE      'EOC  '       WWSENT
 
     C                   ELSE
 
     C                   IF        DTCLAS = 'C'
     C                   MOVE      'CEDEL'       WWSENT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WWDEST = PDELF
 
     C                   SELECT
     C                   WHEN      DFCLAS = 'E'
     C                   MOVE      'EOC  '       WWSENT
     C                   WHEN      DFCLAS = 'C'
     C                   MOVE      'CEDEL'       WWSENT
     C                   ENDSL
 
     C                   ENDIF
 
      ** Store Euroclear/Cedel destination if F12 taken in 2nd screen
 
     C                   MOVEL     WWSENT        TMPSEN
 
      ** Init Network routing and addresses for confirmations
 
     C                   MOVE      PTCNR         WSNDR
     C                   MOVE      PTCNR         WDEST
     C                   MOVE      *BLANKS       WSCSD
     C                   MOVE      PSMTH         WSETP
 
     C                   EXSR      SRZM1100
     C                   MOVE      'N'           DDGMEC
     C                   MOVE      WWROU         A_DDROUC
     C                   MOVE      WKROT         A_DDROTC
 
      ** Init Customer/Counterparty Indicator for MT510 or MT512
 
     C                   IF        DDCCID = *BLANKS                                         AR580916
     C                   IF        BFCLAS = 'M'
     C                   EVAL      DDCCID = 'P'
     C                   ELSE
     C                   EVAL      DDCCID = 'C'
     C                   ENDIF
     C                   ENDIF                                                              AR580916
 
      ** Settlement Message.
 
     C                   IF        CSW003 = 'Y'
 
     C                   IF        BFCLAS = 'S' AND PDELT = PDELF OR
     C                             BFCLAS = 'D' AND PDELT = PDELF
     C                   EVAL      DDGMES = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      **  Requested priorty
 
     C                   SELECT
     C                   WHEN      PPRYC = 'W'
     C                   EVAL      DDRPTY = '1'
     C                   WHEN      PPRYC = 'P'
     C                   EVAL      DDRPTY = '2'
     C                   WHEN      PPRYC = 'R'
     C                   EVAL      DDRPTY = '3'
     C                   WHEN      PPRYC = 'L'
     C                   EVAL      DDRPTY = '4'
     C                   ENDSL
 
      **  Guaranteed Delivery
 
     C                   IF        PPCOD = '5'
     C                   MOVE      'G'           DDGDEL
     C                   ENDIF
 
      **  If Settlement Message Request is 'N' then set
      **  Counterparty/Cedel code & safekeeping Account to blanks
 
     C                   IF        DDGMES = 'N'
     C                   MOVE      *BLANKS       DDEUCL
     C                   MOVE      *BLANKS       DDSAFA
     C                   ENDIF
 
     C                   IF        SWRtnCode = 'CSW098 '
     C                   MOVE      'N'           DDIORA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDisplayA - Process Extension (SWIFT) Screen A               *
      *                                                               *
      *  Called by:  Main Processing                                  *
      *                                                               *
      *  Calls:      SRDfltA                                          *
      *              SREndP                                           *
      *              SRReset                                          *
      *              SRCanc                                           *
      *              SRExtSettA                                       *
      *              SRValA                                           *
      *                                                               *
      *****************************************************************
     C     SRDisplayA    BEGSR
 
      ** Check whether screen B is required
 
     C                   MOVE      'N'           Display_B         1
 
     C                   IF        CSW003 = 'Y'
 
     C**********         IF        BFCLAS = 'S' and PDELT <> PDELF  or                      AR597791
     C**********                   BFCLAS = 'D' and PDELT <> PDELF                          AR597791
     C                   IF        BFCLAS = 'S' or BFCLAS = 'D'                             AR597791
     C                   EVAL      Display_B = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewTrSwftA    PrvTrSwft
     C                   Z-ADD     WIdx_EVALA    PrvN_Warn
 
      ** If insertion and if first time for trade ref, type, method, clear
      ** type, depot ....
 
     C**********         IF        DDACTN = 'I'                                 204833
     C                   IF        DDACTN = 'I' OR DDACTN = 'B'                 204833
 
     C                   IF        DDTDRF <> A_##TDRF or DDTDTP <> A_##TDTP or
     C                             DDSMTH <> A_##SMTH or DDCLTY <> A_##CLTY or
     C                             DDPCOD <> A_##PCOD or DDPRYC <> A_##PRYC or
     C                             DDCNUM <> A_##CNUM or DDDELF <> A_##DELF or
     C                             DDDELT <> A_##DELT or NewTRSwftA = *Blanks
 
      ** Do defaulting for extension screen A
 
     C                   EXSR      SRDfltA
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up Input Parameters
 
     C                   EVAL      DftFlag = 'Y'                                204833
     C                   EVAL      TCNR = PTCNR
     C                   EVAL      TNMC = PTNMC
     C                   EVAL      NOML = PNOML
     C                   EVAL      DELF = PDELF
     C                   EVAL      DELT = PDELT
 
      ** Write/Read Display - Extension Screen
 
     C                   CALLB     'SETRADEDSP'
 
      ** INPUT PARAMETERS :
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Screen A/B
 
     C                   PARM      'A'           Screen
 
      ** Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
 
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrExts                                    222373
 
      ** Trade (file fields)
 
     C                   PARM                    TCNR
     C                   PARM                    TNMC
     C                   PARM                    NOML
     C**********         PARM                    TDVD                                         202863
     C                   PARM                    PTDVD                                        202863
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
      *                                                                                       201429
      ** ISO15022 indicator - file field                                                      201429
     C                   PARM                    T1NEW                                        201429
      *                                                                                       CSE034
      ** Default SSI Flag                                                                     CSE034
     C                   PARM                    DftFlag           1                          CSE034
 
      ** Fields in error
 
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     222373
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Destination of Settlement Text fields
 
     C                   PARM                    A_DDROUS
     C                   PARM                    A_DDROTS
 
      ** Destination of Confirmation Text fields
 
     C                   PARM                    A_DDROUC
     C                   PARM                    A_DDROTC
 
      ** Security report name
 
     C**********         PARM                    DDSRPN                                       CPK014
     C                   PARM                    DDSRNME          41                          CPK014
      * Swift 2001 flag                                                                       CPK014
     C                   PARM                    CSW201            1                          CPK014
     C                   PARM                    PCALL                                        222373
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL             1                          CAP067
 
      ** OUTPUT PARAMETERS :
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       222373
     C                   PARM                    NwSEFilFmt                                   222373
 
      ** Reset Errors
 
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           SREndP
 
      ** F5 - Go To Initial Screen
 
     C     @INKE         CASEQ     '1'           SRReset
 
      ** F12 - Cancel on Extension Screen
 
     C     @INKL         CASEQ     '1'           SRCanc
 
      * F14 - Return from F14 Ext. Settlements
 
     C     @INKN         CASEQ     '1'           SRExtSettA
 
      **  Validate Input to Extension Screen
 
     C                   CAS                     SRValA
 
     C                   ENDCS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDisplayB - Process Extension (SWIFT) Screen B               *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRDfltB                                           *
      *             SREndP                                            *
      *             SRReset                                           *
      *             SRCanc                                            *
      *             SRExtSettB                                        *
      *             SRValB                                            *
      *                                                               *
      *****************************************************************
     C     SRDisplayB    BEGSR
 
      ** Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewTrSwftB    PrvTrSwft
     C                   Z-ADD     WIdx_EVALB    PrvN_Warn
 
      ** If Insertion and
      ** If first time for Trade Red, Type, Method, Clear Type, Depots ..
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'B'                                          204833
 
     C     DDTDRF        IFNE      B_##TDRF
     C     DDTDTP        ORNE      B_##TDTP
     C     DDSMTH        ORNE      B_##SMTH
     C     DDCLTY        ORNE      B_##CLTY
     C     DDPCOD        ORNE      B_##PCOD
     C     DDPRYC        ORNE      B_##PRYC
     C     DDCNUM        ORNE      B_##CNUM
     C     DDDELF        ORNE      B_##DELF
     C     DDDELT        ORNE      B_##DELT
     C     NewTrSwftB    OREQ      *BLANK
 
      ** Do defaulting for Extension screen B
 
     C                   EXSR      SRDfltB
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up Second screen
 
      ** Write/Read Display - Extension Screen
 
     C                   If        PDELT <> PDELF                                           AR598682
     C                   CALLB     'SETRADEDSP'
 
      ** INPUT PARAMETERS :
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Screen A/B
 
     C                   PARM      'B'           Screen
 
      ** Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
 
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftB
     C                   PARM                    NewTrExts                                    222373
 
      ** Trade (file fields)
 
     C                   PARM                    TCNR
     C                   PARM                    TNMC
     C                   PARM                    NOML
     C**********         PARM                    TDVD                                         202863
     C                   PARM                    PTDVD                                        202863
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
      *                                                                                       201429
      ** ISO15022 indicator - file field                                                      201429
     C                   PARM                    T1NEW                                        201429
      *                                                                                       CSE034
      ** Default SSI Flag                                                                     CSE034
     C                   PARM                    DftFlag                                      CSE034
 
      ** Fields in error
 
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     222373
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Destination of Settlement Text fields
 
     C                   PARM                    B_DDROUS
     C                   PARM                    B_DDROTS
 
      ** Destination of Confirmation Text fields
 
     C                   PARM                    B_DDROUC
     C                   PARM                    B_DDROTC
 
      ** Security report name
 
     C**********         PARM                    DDSRPN                                       CPK014
     C                   PARM                    DDSRNME          41                          CPK014
      * Swift 2001 flag                                                                       CPK014
     C                   PARM                    CSW201            1                          CPK014
     C                   PARM                    PCALL                                        222373
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
 
      ** Output Parameters
      ** Function Keys
 
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKE
     C                   PARM      '0'           @INKL
     C                   PARM      '0'           @INKN
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       222373
     C                   PARM                    NwSEFilFmt                                   222373
 
      ** Reset Errors ....
 
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** F3 - End Program
 
     C     @INKC         CASEQ     '1'           SREndp
 
      ** F5 - Go To Initial Screen
 
     C     @INKE         CASEQ     '1'           SRReset
 
      ** F12 - Cancel on Extension Screen
 
     C     @INKL         CASEQ     '1'           SRCanc
 
      ** F14 - Return from F14 Ext. Settlements
 
     C     @INKN         CASEQ     '1'           SRExtSettB
 
      ** Validate Input to Extension Screen
 
     C                   CAS                     SRValB
 
     C                   ENDCS
     C                                                                                      AR598682
     C                   Else                                                               AR598682
     C                   Eval      KWHEN = 'A'                                              AR598682
     C     Key001        CHAIN     TRADSDY2                                                 AR598682
     C                   If        %Found(TRADSDY2)                                         AR598682
     C                             AND Display_B = 'Y'                                      AR630707
     C                   EVAL      KWHEN = 'B'                                              AR630707
     C                   MOVE      SEEXTSETT     SEEXTSETB                                  AR630707
     C     KEY001        CHAIN     TRADSDY2                                                 AR630707
     C                   MOVE      SEEXTSETB     SEEXTSETT                                  AR630707
     C                   Eval      T2WHEN = 'B'                                             AR598682
     C                   IF        %FOUND(TRADSDY2)                                         AR630707
     C                   UPDATE    TRADSDD2                                                 AR630707
     C                   ELSE                                                               AR630707
     C                   WRITE     TRADSDD2                                                 AR598682
     C                   ENDIF                                                              AR630707
     C**********         Eval      PMode = 'R'                                     AR598682 AR630707
     C                   EndIf                                                              AR598682
     C                   Eval      PMode = 'R'                                              AR630707
     C                   Eval      KWHEN = 'B'                                              AR598682
     C                   EndIf                                                              AR598682
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScreenA - Convert file fields to Screen A fields           *
      *                                                               *
      *  Called by:  SRConvert                                        *
      *                                                               *
      *  Calls:      SRZM1100                                         *
      *                                                               *
      *****************************************************************
     C     SRScreenA     BEGSR
 
     C                   MOVE      T1GMES        DDGMES
     C                   MOVE      T1INST        DDINST
     C                   MOVE      T1INSS        DDINSS
     C                   MOVE      T1EUCL        DDEUCL
     C                   MOVE      T1SAFA        DDSAFA
     C                   MOVE      T1RPTY        DDRPTY
     C                   MOVE      T1GMEC        DDGMEC
 
     C                   SELECT
     C                   WHEN      SWRtnCode = 'CSW098 '
     C                   EVAL      DDIORA = T1SIOR
     C                   WHEN      T1FID1 = ' FORWARD'
     C                   EVAL      DDFID1 = 'FORWARD '
     C                   WHEN      T1FID1 = '  OPTION'
     C                   EVAL      DDFID1 = 'OPTION  '
     C                   WHEN      T1FID1 = ' REGULAR'
     C                   EVAL      DDFID1 = 'REGULAR '
     C                   WHEN      T1FID1 = '    SPOT'
     C                   EVAL      DDFID1 = 'SPOT    '
     C                   OTHER
     C                   EVAL      DDFID1 = T1FID1
     C                   ENDSL
 
     C                   EVAL      DDCCID = T1CCID
     C                   EVAL      DDTRTT = T1TRTT
     C                   EVAL      DDGDEL = T1GDEL
     C                   EVAL      DDFCOD = T1FCOD
     C                   EVAL      DDFTID = T1FTID
     C                   EVAL      DDSROL = T1SROL
 
      ** Determine Network routing and addresses/settlements
 
     C                   IF        PTDTP = 'TP'
     C                   MOVE      PDELT         WSNDR
     C                   MOVE      PDELT         WDEST
     C                   ELSE
     C                   MOVE      PDELF         WSNDR
     C                   MOVE      PDELF         WDEST
     C                   ENDIF
 
     C                   MOVE      *BLANKS       WSCSD
     C                   MOVE      PSMTH         WSETP
 
     C                   EXSR      SRZM1100
     C                   MOVE      WWROU         A_DDROUS
     C                   MOVE      WKROT         A_DDROTS
 
      ** Retrieve Cedel/Euroclear destination
 
     C                   MOVE      *BLANKS       WWSENT
     C                   MOVE      WDEST         WWDEST
 
     C                   IF        WWDEST = PDELT
     C                   SELECT
     C                   WHEN      DTCLAS = 'E'
     C                   EVAL      WWSENT = 'EOC  '
     C                   WHEN      DTCLAS = 'C'
     C                   EVAL      WWSENT = 'CEDEL'
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        WWDEST = PDELF
 
     C                   SELECT
     C                   WHEN      DFCLAS = 'E'
     C                   MOVE      'EOC  '       WWSENT
     C                   WHEN      DFCLAS = 'C'
     C                   MOVE      'CEDEL'       WWSENT
     C                   ENDSL
 
     C                   ENDIF
 
      ** Store Euroclear/Cedel destination if F12 taken in 2nd screen.
 
     C                   MOVEL     WWSENT        TMPSEN
 
      ** Init Network routing and addresses for confirmations
 
     C                   MOVE      PTCNR         WSNDR
     C                   MOVE      PTCNR         WDEST
     C                   MOVE      *BLANKS       WSCSD
     C                   MOVE      PSMTH         WSETP
 
     C                   EXSR      SRZM1100
     C                   MOVE      WWROU         A_DDROUC
     C                   MOVE      WKROT         A_DDROTC
 
     C                   EVAL      DDSNEW = T1NEW
     C                   EVAL      DDSTMP = T1STMP
     C                   EVAL      DDCHID = T1CHID
     C                   EVAL      DDTRRM = T1TRRM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScreenB - Convert file fields to Screen B fields           *
      *                                                               *
      *  Called by:  SRConvert                                        *
      *                                                               *
      *  Calls:      SRZM1100                                         *
      *                                                               *
      *****************************************************************
     C     SRScreenB     BEGSR
 
      ** Instructions type and sub-type.
 
     C                   IF        PTDTP = 'TP'
 
     C                   SELECT
 
     C                   WHEN      PCLTY = '1'
     C                   MOVEL     '02'          B_DDINST
     C                   MOVE      'MATCH'       B_DDINSS
 
     C                   WHEN      PCLTY = '2'  and DFCLAS = 'C'
 
     C                   IF        PPCOD = '1' or PPCOD = '5'
     C                   MOVEL     '51'          B_DDINST
     C                   ELSE
     C                   MOVEL     '31'          B_DDINST
     C                   ENDIF
 
     C                   WHEN      PCLTY = '3'
 
     C                   IF        PPCOD = '1' or PPCOD = '5'
     C                   MOVEL     '51'          B_DDINST
     C                   ELSE
     C                   MOVEL     '31'          B_DDINST
     C                   ENDIF
 
     C                   WHEN      PCLTY = '4' and DFCLAS = 'E'
     C                   MOVEL     '07C'         B_DDINST
     C                   MOVEL     'MATCH'       B_DDINSS
 
     C                   WHEN      PCLTY = '5' and DFCLAS = 'E'
     C                   MOVEL     '07 '         B_DDINST
 
     C                   ENDSL
 
      ** Else TS
 
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      PCLTY = '1'
     C                   MOVEL     '01'          B_DDINST
     C                   MOVE      'MATCH'       B_DDINSS
 
     C                   WHEN      PCLTY = '2' and DTCLAS = 'C'
 
     C                   IF        PPCOD = '1' or PPCOD = '5'
     C                   MOVEL     '41'          B_DDINST
     C                   ENDIF
 
     C                   WHEN      PCLTY = '3'
 
     C                   IF        PPCOD = '1' or PPCOD = '5'
     C                   MOVEL     '41'          B_DDINST
     C                   ENDIF
 
     C                   WHEN      PCLTY = '4' and DTCLAS = 'E'
     C                   MOVEL     '03C'         B_DDINST
     C                   MOVE      'MATCH'       B_DDINSS
 
     C                   WHEN      PCLTY = '5' and DTCLAS = 'E'
     C                   MOVEL     '03 '         B_DDINST
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** Determine Network routing and addresses/settlements
 
     C                   IF        PTDTP = 'TP'
     C                   MOVE      PDELF         WSNDR
     C                   MOVE      PDELF         WDEST
     C                   ELSE
     C                   MOVE      PDELT         WSNDR
     C                   MOVE      PDELT         WDEST
     C                   ENDIF
 
     C                   MOVE      *BLANKS       WSCSD
     C                   MOVE      PSMTH         WSETP
 
     C                   EXSR      SRZM1100
     C                   MOVE      WWGME         B_DDGMES
     C                   MOVE      WWROU         B_DDROUS
     C                   MOVE      WKROT         B_DDROTS
 
      ** Default Settlement request to N if backvaluation
 
     C     PACTN         IFEQ      'I'
     C     PTDVD         ANDLT     BJRDNB
     C                   MOVE      'N'           B_DDGMES
     C                   ENDIF
 
      ** Retrieve Cedel/Euroclear destination
 
     C                   MOVE      *BLANKS       WWSENT
     C                   MOVE      WDEST         WWDEST
 
     C                   IF        WWDEST = PDELT
 
     C                   SELECT
     C                   WHEN      DTCLAS = 'E'
     C                   MOVE      'EOC  '       WWSENT
     C                   WHEN      DTCLAS = 'C'
     C                   MOVE      'CEDEL'       WWSENT
     C                   ENDSL
 
     C                   ENDIF
 
     C                   IF        WWDEST = PDELF
 
     C                   SELECT
     C                   WHEN      DFCLAS = 'E'
     C                   MOVE      'EOC  '       WWSENT
     C                   WHEN      DFCLAS = 'C'
     C                   MOVE      'CEDEL'       WWSENT
     C                   ENDSL
 
     C                   ENDIF
 
      ** Euroclear/Cedel Code
 
     C                   IF        PTDTP = 'TP'
 
     C                   SELECT
     C                   WHEN      PCLTY = '1'
     C                   MOVEA(P)  DTDRF1        EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      B_DDEUCL
     C                   WHEN      PCLTY = '3'
     C                   MOVEA(P)  DTDRF2        EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      B_DDEUCL
     C                   WHEN      PCLTY = '2' and DFCLAS = 'C'
     C                   MOVEA(P)  DTDRF1        EUCLA
     C                   EXSR      SREuroClr
     C     '//XE'        CAT(P)    WKEUCL:0      B_DDEUCL
     C                   WHEN      PCLTY = '4' and DFCLAS = 'E'
     C                   MOVEA(P)  DTDRF2        EUCLA
     C                   EXSR      SREuroClr
     C     '//XC'        CAT(P)    WKEUCL:0      B_DDEUCL
     C                   ENDSL
 
      **  ELSE  (NOT TP)
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      PCLTY = '1'
     C                   MOVEA(P)  DFDRF1        EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      B_DDEUCL
     C                   WHEN      PCLTY = '3'
     C                   MOVEA(P)  DFDRF2        EUCLA
     C                   EXSR      SREuroClr
     C     '/'           CAT(P)    WKEUCL:0      B_DDEUCL
     C                   WHEN      PCLTY = '2' and DTCLAS = 'C'
     C                   MOVEA(P)  DFDRF1        EUCLA
     C                   EXSR      SREuroClr
     C     '//XE'        CAT(P)    WKEUCL:0      B_DDEUCL
     C                   WHEN      PCLTY = '4' and DTCLAS = 'E'
     C                   MOVEA(P)  DFDRF2        EUCLA
     C                   EXSR      SREuroClr
     C     '//XC'        CAT(P)    WKEUCL:0      B_DDEUCL
     C                   ENDSL
 
     C                   ENDIF
 
      ** Init Safekeeping Account
 
     C                   CLEAR                   B_DDSAFA
 
     C                   IF        PTDTP = 'TP'
 
     C                   SELECT
     C                   WHEN      PCLTY = '1'
     C                   MOVE      DFDRF1        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '3'
     C                   MOVE      DFDRF2        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '4' AND DFCLAS = 'E'
     C                   MOVE      DFDRF1        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '2' AND DFCLAS = 'C'
     C                   MOVE      DFDRF2        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '5' AND DFCLAS = 'E'
     C                   MOVE      DFDRF1        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '5' AND DFCLAS = 'C'
     C                   MOVE      DFDRF2        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C                   ENDSL
 
      ** Else (Not TP)
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      PCLTY =  '1'
     C                   MOVE      DTDRF1        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '3'
     C                   MOVE      DTDRF2        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '4' AND DTCLAS = 'E'
     C                   MOVE      DTDRF1        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '2' AND DTCLAS = 'C'
     C                   MOVE      DTDRF2        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '5' AND DTCLAS = 'E'
     C                   MOVE      DTDRF1        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
 
     C                   WHEN      PCLTY = '5' AND DTCLAS = 'C'
     C                   MOVE      DTDRF2        B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C                   ENDSL
 
     C                   ENDIF
 
      ** Move relevent fields from 1st screen to 2nd.
 
     C                   MOVE      DDFTID        B_DDFTID
     C                   MOVE      DDFCOD        B_DDFCOD
     C                   MOVE      DDRPTY        B_DDRPTY
     C                   MOVE      DDGDEL        B_DDGDEL
     C                   MOVE      DDSROL        B_DDSROL
 
     C                   MOVE      DDTRTT        B_DDTRTT
 
      ** Settlement Message Request.
 
     C                   IF        CSW003 = 'Y'
 
     C                   IF        BFCLAS = 'S' AND PDELT = PDELF OR
     C                             BFCLAS = 'D' AND PDELT = PDELF
     C                   MOVE      'N'           B_DDGMES
     C                   ENDIF
 
     C                   ENDIF
 
      **  If Settlement Message Request is 'N' then set
      **  Counterparty/Cedel code & safekeeping Account to blanks
 
     C                   IF        B_DDGMES = 'N'
     C                   MOVE      *BLANKS       B_DDEUCL
     C                   MOVE      *BLANKS       B_DDSAFA
     C                   ENDIF
 
     C                   EVAL      B_DDGMEC = DDGMEC
     C                   EVAL      B_DDSNEW = T1NEW
     C                   EVAL      B_DDSTMP = T1STMP
     C                   EVAL      B_DDCHID = T1CHID
     C                   EVAL      B_DDTRRM = T1TRRM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltA - Do defaulting for Extension Screen A                *
      *                                                               *
      *  Called by: SRDisplayA                                        *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRDfltA       BEGSR
 
      ** Set up other Input parameters
 
     C     PSESN         CHAIN     SECTYDF                            99                      199797
     C                   EVAL      INVT = SITP                                                199797
                                                                                              199797
     C                   EVAL      TDVD = PTDVD
     C                   EVAL      TCNR = PTCNR
     C                   EVAL      DELF = PDELF
     C                   EVAL      DELT = PDELT
 
     C     DDACTN        ifeq      'B'                                                        204833
     C     DDSETC        andeq     *blanks                                                    204833
     C                   eval      ddsetc = spyc                                              204833
     C                   end                                                                  204833
                                                                                              204833
      ** Swift (Screen) Field Defaulting
 
     C                   CALLB     'SETSWFTDFT'
 
      ** INPUT PARAMETERS :
      ** Screen A/B
 
     C                   PARM      'A'           Screen
 
      ** Trade Details (screen)
 
     C                   PARM                    DDACTN
     C                   PARM                    DDTDTP
     C                   PARM                    DDSMTH
     C                   PARM                    DDCLTY
     C                   PARM                    DDPCOD
     C                   PARM                    DDPRYC
     C                   PARM                    DDBRCD                                       201192
     C                   PARM                    DDBPBK                                       201192
     C                   PARM                    DDSETC                                       201192
     C                   PARM                    DDMRKT                                       CSE034
 
      ** Trade Details (file)
 
     C                   PARM                    TDVD
     C                   PARM                    TCNR
     C                   PARM                    DELF
     C                   PARM                    DELT
     C                   PARM                    INVT              3                          199797
 
      ** (CSW003) MT5XX - Phase 2 Message Generation
 
     C                   PARM                    CSW003
 
      ** OUTPUT PARAMETERS :
      ** Screen A details
 
     C                   PARM                    NewTrSwftA
     C                   PARM                    A_DDROUS
     C                   PARM                    A_DDROTS
     C                   PARM                    A_DDROUC
     C                   PARM                    A_DDROTC
 
      ** Screen B details
 
     C                   PARM                    NewTrSwftB
     C                   PARM                    B_DDROUS
     C                   PARM                    B_DDROTS
     C                   PARM                    B_DDROUC
     C                   PARM                    B_DDROTC
 
     C                   MOVEL     DDTDRF        A_##TDRF
     C                   MOVEL     DDTDTP        A_##TDTP
     C                   MOVEL     DDSMTH        A_##SMTH
     C                   MOVEL     DDCLTY        A_##CLTY
     C                   MOVEL     DDPCOD        A_##PCOD
     C                   MOVEL     DDPRYC        A_##PRYC
     C                   MOVEL     DDCNUM        A_##CNUM
     C                   MOVEL     DDDELF        A_##DELF
     C                   MOVEL     DDDELT        A_##DELT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltB - Do defaulting for Extension Screen B                *
      *                                                               *
      *  Called by: SRDisplayB                                        *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRDfltB       BEGSR
 
      ** SWIFT (SCREEN) FIELD DEFAULTING
 
     C     PSESN         CHAIN     SECTYDF                            99                      199797
     C                   EVAL      INVT = SITP                                                199797
                                                                                              199797
     C                   CALLB     'SETSWFTDFT'
 
      ** INPUT PARAMETERS :
      ** Screen A/B
 
     C                   PARM      'B'           Screen
 
      ** Trade Details (screen)
 
     C                   PARM                    DDACTN
     C                   PARM                    DDTDTP
     C                   PARM                    DDSMTH
     C                   PARM                    DDCLTY
     C                   PARM                    DDPCOD
     C                   PARM                    DDPRYC
     C                   PARM                    DDBRCD                                       201192
     C                   PARM                    DDBPBK                                       201192
     C                   PARM                    DDSETC                                       201192
     C                   PARM                    DDMRKT                                       CSE034
 
      ** Trade Details (file)
 
     C                   PARM                    TDVD
     C                   PARM                    TCNR
     C                   PARM                    DELF
     C                   PARM                    DELT
     C                   PARM                    INVT                                         199797
 
      ** (CSW003) MT5XX - Phase 2 Message Generation
 
     C                   PARM                    CSW003
 
      ** OUTPUT PARAMETERS :
      ** Screen A details
 
     C                   PARM                    NewTrSwftA
     C                   PARM                    A_DDROUS
     C                   PARM                    A_DDROTS
     C                   PARM                    A_DDROUC
     C                   PARM                    A_DDROTC
 
      ** Screen B details
 
     C                   PARM                    NewTrSwftB
     C                   PARM                    B_DDROUS
     C                   PARM                    B_DDROTS
     C                   PARM                    B_DDROUC
     C                   PARM                    B_DDROTC
 
     C                   MOVEL     DDTDRF        B_##TDRF
     C                   MOVEL     DDTDTP        B_##TDTP
     C                   MOVEL     DDSMTH        B_##SMTH
     C                   MOVEL     DDCLTY        B_##CLTY
     C                   MOVEL     DDPCOD        B_##PCOD
     C                   MOVEL     DDPRYC        B_##PRYC
     C                   MOVEL     DDCNUM        B_##CNUM
     C                   MOVEL     DDDELF        B_##DELF
     C                   MOVEL     DDDELT        B_##DELT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInputVal - Set up input paramaters to SETRADEVAL           *
      *                                                               *
      *  Called by: SRValA                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRInputVal    BEGSR
 
     C                   EVAL      NWTDRF = DDTDRF
     C                   EVAL      NWTINC = DDINCS
     C                   EVAL      NWTDSS = DDSESN
 
     C                   MOVE      DDCNUM        NWTCNR
 
     C                   EVAL      NWTDTP = DDTDTP
 
     C                   MOVE      DDNOML        NWNOML
     C                   MOVE      DDTPDY        NWTPDY
 
     C                   EVAL      NWTDBK = DDBPBK
     C                   EVAL      NWTSUB = DDTSUB
     C                   EVAL      NWLKRF = DDLKRF
     C                   EVAL      NWTDNR = DDTDNR
     C                   EVAL      NWTDMI = DDTDMI
     C                   EVAL      NWAIIP = DDAIIP
 
     C                   MOVE      DDSMTH        NWSMTH
     C                   MOVE      DDDELT        NWDELT
     C                   MOVE      DDDELF        NWDELF
 
     C                   EVAL      NWPYFM = DDPYFM
     C                   EVAL      NWPYFA = DDPYFB
     C                   EVAL      NWPAYT = DDPAYT
     C                   EVAL      NWPYTA = DDPYTB
     C                   EVAL      NWCLTY = DDCLTY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValA - Validate input to Extension Screen A                 *
      *                                                               *
      *  Called by: SRDisplayA                                        *
      *                                                               *
      *  Calls:     SRInputVal                                        *
      *                                                               *
      *****************************************************************
     C     SRValA        BEGSR
 
      ** If Enquire
 
     C     DDACTN        IFEQ      'E'
 
     C                   IF        Display_B = 'Y'
     C                   If        PDELT <> PDELF                                           AR598682
     C                   MOVEL     'B'           PMODE
     C                   Else                                                               AR598682
     C                   Eval      PMode = 'R'                                              AR598682
     C                   EndIf                                                              AR598682
     C                   ELSE
     C                   EVAL      PMode = 'R'
     C                   ENDIF
 
     C                   GOTO      EndVAL@E_A
 
     C                   ENDIF
 
      ** If Authorize/Approve
 
     C                   IF        DDACTN = 'Y'
 
      ** If screen B can't be displayed
      **    Go to updates
      ** Else, Go to EXTENSION (SWIFT) screen B
 
     C                   IF        Display_B <> 'Y'
     C                   MOVEL     'U'           PMODE
     C                   ELSE
     C                   MOVEL     'B'           PMODE
     C                   ENDIF
 
     C                   IF        PACTN = 'B' and PMODE = 'U'
 
     C                   IF        Display_B <> 'Y'
     C                   EVAL      PMODE = 'R'
     C                   ELSE
     C                   EVAL      PMODE = 'B'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   GOTO      EndVAL@E_A
 
     C                   ENDIF
 
      ** If Insert or Amend / Change
 
     C                   IF        DDACTN = 'I' or DDACTN = 'A' or DDACTN = 'B'
 
      ** Prior to validation, initialize error indicators as 'OK'
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_EVALA
 
     C                   MOVE      *ALL'Y'       OKTrSwft
 
      ** Set up input parameters
 
     C                   EXSR      SRInputVal
 
      ** Validate Extension Screen
 
     C                   CALLB     'SETRADEVAL'
 
      ** INPUTS
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Screen (A or B)
 
     C                   PARM      'A'           Screen
 
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
 
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
 
      ** Trade Extension File details
 
     C                   PARM                    NewTrSwftA
 
      ** Custom Extra Data file data
 
     C                   PARM                    ExtData
 
      ** Previous inds
 
     C                   PARM                    @ADDGMES
     C                   PARM                    @ADDGMEC
     C                   PARM                    @ADDCCID
     C                   PARM                    CA_T1CONG
 
      ** Processing type
 
     C                   PARM                    PROT
 
      ** Override errors
 
     C                   PARM                    OVRErrors
 
      ** Valid Trade layout (DS) from/to caller
 
     C                   PARM                    NwTrFilFmt
      *                                                                                       CPK014
      ** Swift 2001 flag                                                                      CPK014
     C                   PARM                    CSW201            1                          CPK014
      *                                                                                       201233
      ** Destination of settlement                                                            201233
     C                   PARM                    A_DDROTS                                     201233
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT                                        201429
                                                                                              216338
      ** Tradsdx2 data                                                                        216338
                                                                                              216338
     C                   PARM      *BLANKS       PTradeX2                                     216338
 
      ** OUTPUTS
      ** OK Flags
 
     C                   PARM                    OKTrSwft
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx_EVALA
 
      ** Valid Trade layout (DS) (Extension file) from/to caller
 
     C                   PARM                    NT1AFilFmt
 
      ** If errors returned
 
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@E_A
     C                   ENDIF
 
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      ** re-output the screen
 
     C     NewTrSwftA    IFNE      PrvTrSwft
     C     WIdx_EVALA    ORNE      PrvN_Warn
     C     PUYAT         OREQ      'N'                                                        201429
     C     PUYAT         IFEQ      'N'                                                        201429
     C                   EVAL      PUYAT = 'Y'                                                201429
     C                   ENDIF                                                                201429
     C                   GOTO      EndVAL@E_A
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** If screen B can't be displayed
      **    Go to updates
      ** Else, Go to EXTENSION (SWIFT) screen B
 
     C                   IF        Display_B <> 'Y'
     C                   MOVEL     'U'           PMODE
     C                   ELSE
     C                   MOVEL     'B'           PMODE
     C                   ENDIF
 
     C                   IF        PACTN = 'B' and PMODE = 'U'
 
     C                   IF        Display_B <> 'Y'
     C                   EVAL      PMODE = 'R'
     C                   ELSE
     C                   EVAL      PMODE = 'B'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndVAL@E_A    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValB - Validate input to Extention  Screen B                *
      *                                                               *
      *  Called by: SRDisplayB                                        *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRValB        BEGSR
 
      ** If Enquire
 
     C                   IF        DDACTN = 'E'
     C                   EVAL      PMode = 'R'
     C                   GOTO      EndVAL@E_B
     C                   ENDIF
 
      ** If Authorize / Approve
 
     C                   IF        DDACTN = 'Y'
     C                   EVAL      PMode = 'U'
     C                   GOTO      EndVAL@E_B
     C                   ENDIF
 
      ** If Insert or Amend / Change
 
     C                   IF        DDACTN = 'I' or DDACTN = 'A' or
     C                             DDACTN = 'C' or DDACTN = 'B'
 
      ** Prior to validation, initialize error indicators as 'OK'
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx_EVALB
     C                   MOVE      *ALL'Y'       OKTrSwft
 
      ** Validate Extension Screen
 
     C                   CALLB     'SETRADEVAL'
 
      ** INPUTS
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Screen (A or B)
     C                   PARM      'B'           Screen
 
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
 
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
 
      ** Trade Extension File details
 
     C                   PARM                    NewTrSwftB
 
      ** Custom Extra Data file data
 
     C                   PARM                    ExtData
 
      ** Previous inds
 
     C                   PARM                    @BDDGMES
     C                   PARM                    @BDDGMEC
     C                   PARM                    @BDDCCID
     C                   PARM                    CB_T1CONG
 
      ** Processing type
 
     C                   PARM                    PROT
 
      ** Override errors
 
     C                   PARM                    OVRErrors
 
      ** Valid Trade layout (DS) from/to caller
 
     C                   PARM                    NwTrFilFmt
      *                                                                                       CPK014
      ** Swift 2001 flag                                                                      CPK014
     C                   PARM                    CSW201            1                          CPK014
      *                                                                                       201233
      ** Destination of settlement                                                            201233
     C                   PARM                    B_DDROTS                                     201233
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT                                        201429
                                                                                              216338
      ** Tradsdx2 data                                                                        216338
                                                                                              216338
     C                   PARM      *BLANKS       PTradeX2                                     216338
 
      ** OUTPUTS
      ** OK Flags
 
     C                   PARM                    OKTrSwft
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx_EVALB
 
      ** Valid Trade layout (DS) (Extension file) from/to caller
 
     C                   PARM                    NT1BFilFmt
 
      ** If errors returned
 
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@E_B
     C                   ENDIF
 
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      **   re-output the screen
 
     C                   IF        NewTrSwftB <> PrvTrSwft or
     C                             WIdx_EVALB <> PrvN_Warn
     C                             or PUYAT = 'N'                                             201429
     C     PUYAT         IFEQ      'N'                                                        201429
     C                   EVAL      PUYAT = 'Y'                                                201429
     C                   ENDIF                                                                201429
     C                   GOTO      EndVAL@E_B
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      ** Go to updates
 
     C                   IF        PACTN <> 'B'
     C                   MOVEL     'U'           PMODE
     C                   ELSE
     C                   EVAL      PMODE = 'R'
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndVAL@E_B    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREuroClr - Reomove Leading blanks from Euroclear/Cedel Code  *
      *                                                               *
      *  Called by: SRScreenB                                         *
      *             SRInitFld                                         *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SREuroClr     BEGSR
 
      ** If the array is empty, do not try to remove leading blanks
      ** Otherwise, following existing logic.
 
     C                   MOVEA     EUCLA         W0EUCL
 
     C                   IF        W0EUCL = *BLANK
 
     C                   EVAL      WKEUCL = *BLANK
 
     C                   ELSE
 
     C                   Z-ADD     1             I
 
     C                   DOW       I < 6  and EUCLA(I) = *Blanks
     C                   ADD       1             I
     C                   ENDDO
 
     C                   MOVEA(P)  EUCLA(I)      EUCLB
     C                   MOVEA(P)  EUCLB         WKEUCL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZM1100 - Determine the Network Routing/Address              *
      *                                                               *
      *  Called by: SRScreenA                                         *
      *             SRScreenB                                         *
      *             SRInitFld                                         *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRZM1100      BEGSR
 
     C                   EVAL      WNWSN = *BLANKS
     C                   EVAL      WNWDS = *BLANKS
     C                   EVAL      WNWRK = *BLANKS
     C                   EVAL      WERRC = *BLANKS
     C                   EVAL      WSRNM = *BLANKS
     C                   EVAL      WSRTN = *BLANKS
     C                   EVAL      WDRNM = *BLANKS
     C                   EVAL      WDRTN = *BLANKS
 
     C                   CALL      'ZM1100'                             50
     C                   PARM                    WSNDR
     C                   PARM                    WSCSD
     C                   PARM                    WDEST
     C                   PARM                    WSETP
     C                   PARM                    WNWSN
     C                   PARM                    WNWDS
     C                   PARM                    WNWRK
     C                   PARM                    WERRC
     C                   PARM                    WSRNM
     C                   PARM                    WSRTN
     C                   PARM                    WDRNM
     C                   PARM                    WDRTN
 
     C                   IF        WSNDR <> *Blanks  and WDEST <> *Blanks
 
     C                   IF        *IN50 = *On  or WERRC = 'S' or WERRC = 'D' or
     C                             WNWRK = 'UNROUT'
 
     C                   EVAL      WWGME = 'N'
     C                   EVAL      WWROU = *Blanks
     C                   EVAL      WKROT = 'UNROUTABLE'
 
     C                   ELSE
 
     C                   EVAL      WWGME = 'Y'
 
     C                   MOVEL     WNWRK         WWROU
     C                   MOVEA     WNWDS         ROU
 
     C                   Z-ADD     1             J
     C     ' '           LOOKUP    ROU(J)                                 85
 
     C                   IF        *IN85 = *Off
 
     C                   MOVEL     WNWDS         WKROT
 
     C                   ELSE
 
     C     14            SUB       J             K
     C                   MOVEA     *ALL' '       ROU
     C                   MOVEA     WNWDS         ROU(K)
     C                   MOVEA     ROU           WKROT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSE1852 - Calls Security Certifiacte no. Maintenance         *
      *                                                               *
      *  Called by: SRUpdate                                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRSE1852      BEGSR
 
     C                   MOVE      'R'           WWRANG
 
     C                   Z-ADD     PNOML         WWNML
 
     C                   CALL      'SE1852'
     C                   PARM                    PSESN
     C                   PARM                    WWNML
     C                   PARM                    PTDRF
     C                   PARM                    PACTN
     C                   PARM                    WWRTCD
     C                   PARM      'R'           WWRANG
      *
      ** Test Return Code (WWRTCD) :
      **   If 1 - Successful call to SE1852 : pgm will drop out of loop
      **      2 - F3 taken in SE1852 : imply F3 taken in SE1805
      **      3 - F5 taken in SE1852 : imply F5 taken in SE1805
      **      4 - F12 taken in SE1852 : do while loop will be repeated
      *
     C     WWRTCD        IFEQ      '2'
     C                   MOVE      'R'           PMode
     C**********         ROLBK                                                                CSC022
     C                   ENDIF
      *
     C     WWRTCD        IFEQ      '3'
     C                   MOVE      Screen        PMode
     C**********         ROLBK                                                                CSC022
     C                   ENDIF
 
     C     WWRTCD        IFEQ      '4'
     C                   MOVE      Screen        PMode
     C**********         ROLBK                                                                CSC022
     C                   ENDIF
 
     C     WWRTCD        IFEQ      '1'
     C                   MOVE      'R'           PMode
     C                   ENDIF
      *                                                                                       CSC022
     C     WWRTCD        IFEQ      '2'                                                        CSC022
     C     WWRTCD        OREQ      '3'                                                        CSC022
     C     WWRTCD        OREQ      '4'                                                        CSC022
     C                   If        CSC022 <> 'Y'                                              CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   If        WCommitSkip <> 'Y'                                         CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtSettA - F14 is pressed                                  *
      *                                                               *
      *  Called by:  SRDisplayA                                       *
      *                                                               *
      *  Calls:      None                                             *
      *                                                               *
      *****************************************************************
     C     SRExtSettA    BEGSR
 
     C                   EVAL      PMode = 'A'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtSettB - F14 is pressed                                  *
      *                                                               *
      *  Called by:  SRDisplayB                                       *
      *                                                               *
      *  Calls:      None                                             *
      *                                                               *
      *****************************************************************
     C     SRExtSettB    BEGSR
 
     C                   EVAL      PMode = 'B'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReset - F5 Key is pressed                                   *
      *                                                               *
      * Called by: SRDisplayA                                         *
      *            SRDisplayB                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRReset       BEGSR
 
     C                   EVAL      PCommand = '05'
     C                   EVAL      PMode = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCanc  - Cancel                                              *
      *                                                               *
      * Called by: SRDisplayA                                         *
      *            SRDisplayB                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCanc        BEGSR
 
     C                   IF        PMode = 'B'
     C                   EVAL      PMode = 'A'
     C                   ELSE
     C                   EVAL      PCommand = '12'
     C                   EVAL      PMode = 'T'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndP - End of Program                                       *
      *                                                               *
      * Called by: SRDisplayA                                         *
      *            SRDisplayB                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   EVAL      PCommand = '03'
     C                   EVAL      PMode = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReturn - Return to calling program                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRReturn      BEGSR
 
     C                   EVAL      PCommand = '00'
     C                   EVAL      PMode = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate   - Update to files                                 *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRSE1852                                          *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   EVAL      KWHEN = 'A'
 
     C     Key001        CHAIN     TRADSDD1                           01
 
     C                   MOVE      DDTDRF        T1TDRF
     C                   MOVE      DDGMES        T1GMES
     C                   MOVE      DDINST        T1INST
     C                   MOVE      DDINSS        T1INSS
     C                   MOVE      DDEUCL        T1EUCL
     C                   MOVE      DDSAFA        T1SAFA
     C                   MOVE      DDRPTY        T1RPTY
     C                   MOVE      DDGMEC        T1GMEC
 
     C                   EVAL      T1NEW = DDSNEW
     C                   EVAL      T1STMP = DDSTMP
     C                   EVAL      T1CHID = DDCHID
     C                   EVAL      T1TRRM = DDTRRM
 
     C     SWRtnCode     IFNE      'CSW098 '
     C                   MOVE      DDFID1        T1FID1
     C                   ELSE
     C                   MOVE      DDIORA        T1SIOR
     C                   ENDIF
 
     C                   MOVE      DDCCID        T1CCID
     C                   MOVE      DDTRTT        T1TRTT
     C                   MOVE      DDGDEL        T1GDEL
     C                   MOVE      DDFCOD        T1FCOD
     C                   MOVE      DDFTID        T1FTID
     C                   MOVE      DDSROL        T1SROL
 
     C                   IF        CSW003 = 'Y'
     C                   MOVE      'A'           T1WHEN
     C                   ENDIF
 
     C                   Z-ADD     *ZEROS        T1LSWS
     C                   Z-ADD     *ZEROS        T1LSSC
 
     C**********         IF        PACTN = 'I' or PACTN = 'B'                                 201192
     C                   IF        *IN01 = *ON                                                201192
     C                   WRITE     TRADSDD1
     C                   ELSE
     C                   UPDATE    TRADSDD1
     C                   ENDIF
 
      ** If second screen is displayed, write a second record
 
     C                   IF        Display_B = 'Y'
 
     C                   EVAL      KWHEN = 'B'
 
     C     Key001        CHAIN     TRADSDD1                           01
 
     C                   MOVE      DDTDRF        T1TDRF
     C                   MOVE      B_DDGMES      T1GMES
     C                   MOVE      B_DDINST      T1INST
     C                   MOVE      B_DDINSS      T1INSS
     C                   MOVE      B_DDEUCL      T1EUCL
     C                   MOVE      B_DDSAFA      T1SAFA
     C                   MOVE      B_DDRPTY      T1RPTY
     C                   MOVE      B_DDTRTT      T1TRTT
     C                   MOVE      B_DDGDEL      T1GDEL
     C                   MOVE      B_DDFCOD      T1FCOD
     C                   MOVE      B_DDSROL      T1SROL
 
     C                   EVAL      T1NEW = B_DDSNEW
     C                   EVAL      T1STMP = B_DDSTMP
     C                   EVAL      T1CHID = B_DDCHID
     C                   EVAL      T1TRRM = B_DDTRRM
      *
     C                   MOVE      'B'           T1WHEN
     C                   MOVE      'N'           T1GMEC
 
     C**********         IF        PACTN = 'I' or PACTN = 'B'                               AR630707
     C                   IF        *IN01 = *ON                                              AR630707
     C                   WRITE     TRADSDD1
     C                   ELSE
     C                   UPDATE    TRADSDD1
     C                   ENDIF
 
     C                   ENDIF
 
      ** Call SE1852
 
     C                   IF        PTDTP = 'TS' and DDFTID = 'N' and
     C                             PDELF = PDC02
 
     C                   IF        DDFCOD = '1' or DDFCOD = '2'
     C                   EXSR      SRSE1852
     C                   ELSE
     C                   EVAL      PMODE = 'R'
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      PMODE = 'R'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** Output Parameters
      ** Command Key
      ** Error Flag
 
     C                   PARM                    PCommand
     C                   PARM                    PError
 
      ** Input Parameters
      ** SE Trades MT5xx DS Template
      ** SE Trades Extension File 1
      ** SE Trades Extension Settlements
 
     C                   PARM                    SETrades
     C                   PARM                    SEExtFile
     C                   PARM                    SEExtSett
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD             7                          CSC022
     C                   Parm      '*VERIFY'     @OPTN             7                          CSC022
     C                   Parm      'CSC022'      @SARD             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
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
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 005                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
