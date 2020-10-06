     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Retrieve + Actn/Scty Val')         *
      *****************************************************************
      *                                                               *
      *  Midas - Secuties Module                                      *
      *                                                               *
      *  SESECSRTV - Securities Retrieve and Action Code / Security   *
      *              Validation                                       *
      *                                                               *
      *  Function: This module retrieves security details from the    *
      *            database.  As it does, it validates the action     *
      *            code and security shortname.                       *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                SESECSUPC                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 16May13               *
      *                 CRE073             Date 10Dec06               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22120           Date 14Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 29Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG9500            Date 09Dec05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2408            Date 05Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 222727             Date 05Nov03               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 201550             Date 11Sep02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 27Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22120 - Industry code becomes blank after authorisation   *
      *           (Recompile)                                         *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *  BUG9500 - Ensure that the field investment type and nominal  *
      *            currency have correct value when the investment    *
      *            type record was retrieved.                         *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2408- Need to access Investment information even for      *
      *           insert, as Midasplus need it for defaulting.        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE037 - Countervalue rounding                               *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  201550 - Do not allow deletion of Security if active trades  *
      *           are still attached to it.                           *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *         - Recompiled.                                         *
      *  CSD006 - MDF (Recompile)                                     *
      *  CSE023 - Treaty Withholding Tax (Recompile)                  *
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
      ** Securities by Security Shortname
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Securities by Front Office Id
     FSECTYL4   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECTYDF:SECTYD4)
      *
      ** Trades by Security
     F*TRADSE****IF***E***********K*DISK*** INFSR(*PSSR)                                      201550
     FTRADSR    IF   E           K DISK    INFSR(*PSSR)                                       201550
     F                                     PREFIX(F1)
      *
      ** Historic Trades by Security and Reverse Trade Date
     FHSTTRR    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F2)
      *
      ** User Depot Positions (None Zero Nominal) by Security
     FUDEPZ     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F3)
      *
      ** Clients Depot Positions (None Zero Nominal) by Security
     FCDEPZ     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F4)
      *
      ** Book Position Headers by Secuirty
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F5)
      *
      ** Book Positions
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F6)
      *
      ** Security Diary Events by Security - LIVE
     FSEDEL     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F7)
      *
      ** Depot Movements by Security
     FDPTMV     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F8)
      *
      ** Security Limits by Security
     FSLIMIS    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F9)
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
      **    True       logical = *on (for indicator processing)
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
      ** Securities retrieved from file - file format
     D SECSFmt       E DS                  EXTNAME(SECTYD)
      *
      ** Securities retrieved from file - file format
      ** This DS will be passed to the calling module.
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(CR)
      *
      ** Investment types details
     D PINVTPD       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(FI)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             70     70
     D  FrntNotFnd            71     71
     D  EndOfFile             72     72
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc.
     D IDx             S              3P 0
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Entry parameter list definition
     D PMode           S              6A
     D PResponse       S              1A
     D DDACTN          S              1A
     D FOTRID          S             20A
     D DDSESN          S             10A
     D BJSBRC          S              3A
     D PDBRN           S              3A
     D OKACTN          S              1A
     D OKSESN          S              1A
      *
      ** Key fields for KHSTTR
     D KTDSS           S                   LIKE(F2TDSS)
     D KTDDT           S                   LIKE(F2TDDT)
     D KTDRF           S                   LIKE(F2TDRF)
      *
      ** Parameter list for validation of action code
     D PActn           S              1A
     D PError          S              1P 0
     D PBrc            S              3A
      *
     D PRtCd           S              7A
     D POptn           S              7A
      *
      ** Parameter list for AOCUSTR1
     D PKeyC           S             10A
     D PKySt           S              7A
      *
     D POSESN          S             10A
     D PPOldSecDtl     S              1A
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
      ** Initialise.
      *
     C                   EXSR      SRInit
      *
      ** If the mode is 'Front Office Transaction Interface',
      ** do (extra) validation for Front Office Transaction Interface.
      *
     C                   IF        PMode = '*FRONT'
     C                   EXSR      SRValFrnt
      *
      ** No further validation if errors occurred.
      *
     C                   IF        OKACTN = 'N' OR OKSESN = 'N'
     C                   RETURN
     C                   ENDIF

     C                   ENDIF
      *
      ** Validate action code and security shortname.
      *
     C                   EXSR      SRValAct
      *
      ** No further validation if errors occurred.
      *
     C                   IF        OKACTN = 'N' OR OKSESN = 'N'
     C                   RETURN
     C                   ENDIF

     C                   SELECT
      *
      ** Additional validation for Insert.
      *
     C                   WHEN      DDACTN = 'I'
     C                   EXSR      SRValIns
      *
      ** Additional validation for Amend.
      *
     C                   WHEN      DDACTN = 'A'
     C                   EXSR      SRValAmd
      *
      ** Additional validation for Delete.
      *
     C                   WHEN      DDACTN = 'D'
     C                   EXSR      SRValDel
      *
      ** Additional validation for Enquire.
      *
     C                   WHEN      DDACTN = 'E'
     C                   EXSR      SRValEnq

     C                   ENDSL
      *
      ** No further validation if errors occurred.
      *
     C                   IF        OKACTN = 'N' OR OKSESN = 'N'
     C                   RETURN
     C                   ENDIF
      *
      ** If process old security details indicator is set to 'Y' and action
      ** is insert then retrieve old security details.
      *
     C                   IF        PPOldSecDtl = 'Y' AND DDACTN = 'I'
     C                   EXSR      SRRtvOldSec
     C                   ENDIF
      *
      ** If Action is not Insert, or Action is Insert and
      ** entry point is link processing, move file values to
      ** output parameter if Action Code and Security Shortname
      ** are valid.
      *
     C     DDACTN        IFNE      'I'
     C     PPOldSecDtl   OREQ      'Y'
     C                   EVAL      CrSEFilFmt = SECSFmt
     C                   ENDIF
      *
      ** Retrieve investment type details
      *
     C***************    IF        DDACTN <> 'I'                                             BUG2408
     C                   EXSR      SRAcsInv
     C***************    ENDIF                                                               BUG2408
      *
      ** Access security checking.
      *
     C                   IF        PResponse = 'S'
     C                   EXSR      SRAcsSec
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Routine to initialise fields                        *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
      ** Initialise output fields.
      *
     C     CRSITP        IFNE      *BLANKS                                                   BUG9500
     C     CRNMCY        ANDNE     *BLANKS                                                   BUG9500
     C                   EVAL      SITP = CRSITP                                             BUG9500
     C                   EVAL      NMCY = CRNMCY                                             BUG9500
     C                   ENDIF                                                               BUG9500
     C                   CLEAR                   CrSEFilFmt

     C                   Z-ADD     0             CrNMDP
     C                   Z-ADD     0             CrSIDY
     C**********         Z-ADD     0             CrISSR                                       CSD027
     C                   EVAL      CrISSR = *BLANKS                                           CSD027
     C                   Z-ADD     0             CrSDNM
     C                   Z-ADD     0             CrIDIV
     C                   Z-ADD     0             CrCD01
     C                   Z-ADD     0             CrCD02
     C                   Z-ADD     0             CrCD03
     C                   Z-ADD     0             CrCD04
     C                   Z-ADD     0             CrCD05
     C                   Z-ADD     0             CrCD06
     C                   Z-ADD     0             CrCD07
     C                   Z-ADD     0             CrCD08
     C                   Z-ADD     0             CrCD09
     C                   Z-ADD     0             CrCD10
     C                   Z-ADD     0             CrCD11
     C                   Z-ADD     0             CrCD12
     C                   Z-ADD     0             CrNEXD
     C                   Z-ADD     0             CrLCPN
     C                   Z-ADD     0             CrCPNR
     C**********         Z-ADD     0             CrBASC                                       CSD103
     C                   EVAL      CrBASC = *BLANKS                                           CSD103
     C                   Z-ADD     0             CrBASS
     C                   Z-ADD     0             CrMCPN
     C                   Z-ADD     0             CrMATY
     C**********         Z-ADD     0             CrRSKC                                       CSD027
     C                   EVAL      CrRSKC = *BLANKS                                           CSD027
     C                   Z-ADD     0             CrIADJ
     C                   Z-ADD     0             CrITLD
     C                   Z-ADD     0             CrFCPN
     C                   Z-ADD     0             CrNCHD
     C                   Z-ADD     0             CrSINP
     C                   Z-ADD     0             CrSFPP
     C                   Z-ADD     0             CrISSD
     C                   Z-ADD     0             CrISSP
     C**********         Z-ADD     0             CrLMGR                                       CSD027
     C                   EVAL      CrLMGR = *BLANKS                                           CSD027
     C                   Z-ADD     0             CrISSA
     C                   Z-ADD     0             CrTOTU
     C                   Z-ADD     0             CrALRQ
     C                   Z-ADD     0             CrALRC
     C                   Z-ADD     0             CrMGFD
     C                   Z-ADD     0             CrMGRC
     C                   Z-ADD     0             CrUNFD
     C                   Z-ADD     0             CrUNFR
     C                   Z-ADD     0             CrDCOM
     C                   Z-ADD     0             CrMKPR
     C                   Z-ADD     0             CrORED
     C                   Z-ADD     0             CrNDVD
     C                   Z-ADD     0             CrSEXR
     C                   Z-ADD     0             CrLPRU
     C                   Z-ADD     0             CrCPDP
     C                   Z-ADD     0             CrTPHD
     C                   Z-ADD     0             CrSCPP
     C                   Z-ADD     0             CrSCPD
     C                   Z-ADD     0             CrLCD
     C                   Z-ADD     0             CrTNLU
     C                   Z-ADD     0             CrCMFQ
     C                   Z-ADD     0             CrCFCT
     C                   Z-ADD     0             CrSRBK
     C**********         Z-ADD     0             CrPPAG                                       CSD027
     C**********         Z-ADD     0             CrGUAR                                       CSD027
     C                   EVAL      CrPPAG = *BLANKS                                           CSD027
     C                   EVAL      CrGUAR = *BLANKS                                           CSD027
     C                   Z-ADD     0             CrWEIC
     C                   Z-ADD     0             CrNDEC                                       CSE037
     C                   Z-ADD     0             CrALDT                                       CSE065
     C                   Z-ADD     0             CrCPDY                                       CSE075
     C                   Z-ADD     0             CrRPRT                                       CSE075
     C                   Z-ADD     0             CrWACP                                       CSE075
     C                   Z-ADD     0             CrWAMY                                       CSE075

     C                   CLEAR                   PINVTPD
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKSESN
     C**********         Z-ADD     0             FISDC1                                       CSD027
     C**********         Z-ADD     0             FISDC2                                       CSD027
     C**********         Z-ADD     0             FISDC3                                       CSD027
     C                   EVAL      FISDC1 = *BLANKS                                           CSD027
     C                   EVAL      FISDC2 = *BLANKS                                           CSD027
     C                   EVAL      FISDC3 = *BLANKS                                           CSD027
     C                   Z-ADD     0             FICMGN
     C                   Z-ADD     0             FIEXPC
     C                   Z-ADD     0             FIDTRD
     C                   Z-ADD     0             FILCD
     C                   Z-ADD     0             FITNLU
     C                   Z-ADD     0             FIDCMF
     C                   Z-ADD     0             FIPRTO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValFrnt - Routine to validate Front Office Transaction     *
      *              Interface                                        *
      *                                                               *
      *****************************************************************

     C     SRValFrnt     BEGSR
      *
      ** Error if action code is not I(Insert), A(Amend), D(Delete) or
      ** E(Enquire).
      *
     C                   IF        DDACTN <> 'I' AND DDACTN <> 'A' AND
     C                             DDACTN <> 'D' AND DDACTN <> 'E'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'SEA0303'
     C                   ENDIF
      *
      ** Error if Front Office Transaction Id is blank.
      *
     C                   IF        FOTRID = *BLANKS
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'APM0201'
     C                   ENDIF
      *
      ** No further validation if errors occurred.
      *
     C                   IF        OKACTN = 'N'
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
      ** Access security details file using Front Office
      ** Transaction Id.
      *
     C     FOTRID        CHAIN     SECTYL4                            71
      *
     C                   IF        DDACTN = 'I'
      *
      ** Front Office Transaction Id can't be present already.
      *
     C                   IF        FrntNotFnd = False
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'APM0102'
     C**********         EVAL      MsgDtaArr(IDx) = FOTRID                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If not insert, Front Office Transaction Id must be present.
      *
     C                   IF        FrntNotFnd = True
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDACTN'
     C                   EVAL      MsgIdArr(IDx) = 'APM0103'
     C**********         EVAL      MsgDtaArr(IDx) = FOTRID                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(IDx) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
      ** If not insert, update security shortname.
      *
     C                   MOVEL     SESN          DDSESN

     C                   ENDIF

     C     EValFrnt      ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAct - Routine to validate Action Code and Security      *
      *             Shortname                                         *
      *                                                               *
      *****************************************************************

     C     SRValAct      BEGSR
      *
      ** Error if action code is not I(Insert), A(Amend), D(Delete)
      ** or E(Enquire).
      *
     C                   IF        DDACTN <> 'I' AND DDACTN <> 'A' AND
     C                             DDACTN <> 'D' AND DDACTN <> 'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0228'
     C                   GOTO      EValAct
     C                   ENDIF
      *
      ** If the security shortname is blank, it is an error.
      *
     C                   IF        DDSESN = *BLANKS
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0229'
     C                   ENDIF

     C     EValAct       ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValIns - Routine to validate Action Code 'I'               *
      *                                                               *
      *****************************************************************

     C     SRValIns      BEGSR
      *
      ** Check that the security does not exist on master file as
      ** active or matured security.
      *
     C     DDSESN        CHAIN     SECTY                              70
     C                   IF        RecNotFnd = False
     C                   IF        RECI = 'D' OR RECI = 'M'
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0230'
     C                   GOTO      EValIns
     C                   ENDIF
     C                   ENDIF
      *
      ** Security shortname must not be a reserved word.
      *
     C                   IF        DDSESN = 'ALL'
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0231'
     C                   ENDIF

     C     EValIns       ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmd - Routine to validate Action Code 'A'               *
      *                                                               *
      *****************************************************************

     C     SRValAmd      BEGSR
      *
      ** If there is no valid, undeleted or matured record on SECTYD,
      ** it is an error.
      *
     C     DDSESN        CHAIN     SECTY                              70
      *
      ** Check for a valid security.
      *
     C                   IF        RecNotFnd = True
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0233'
     C                   GOTO      EValAmd
     C                   ENDIF
      *
      ** If security is not active, then it may not be amended.
      *
     C                   IF        RECI <> 'D'
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0232'
     C                   ENDIF

     C     EValAmd       ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDel - Routine to validate Action Code 'D'               *
      *                                                               *
      *****************************************************************

     C     SRValDel      BEGSR
      *
      ** If there is no valid, undeleted or matured record on SECTYD,
      ** it is an error.
      *
     C     DDSESN        CHAIN     SECTY                              70
      *
      ** Check for a valid record.
      *
     C                   IF        RecNotFnd = True
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0233'
     C                   GOTO      EValDel
     C                   ENDIF
      *
      ** If security exist but not active, then it is an error.
      *
     C                   IF        RECI <> 'D'
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0232'
     C                   GOTO      EValDel
     C                   ENDIF
      *
      ** If there are existing trades for the security, it is an error.
      *
     C     DDSESN        SETLL     TRADSDF
     C                   EVAL      EndOfFile = False
     C                   DOW       EndOfFile = False
     C     DDSESN        READE     TRADSDF                                72
     C                   IF        EndOfFile = False
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0128'
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      ** If there are existing historic trades for the security,
      ** it is an error.
      *
     C                   EVAL      KTDSS = DDSESN
     C                   EVAL      KTDDT = 99999
     C                   EVAL      KTDRF = *BLANK
     C     KHSTTR        SETLL     HSTTRDF
     C                   READ      HSTTRDF                                72
     C                   IF        EndOfFile = False AND
     C                             KTDSS = F2TDSS
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0128'
     C                   ENDIF
      *
      ** If there are existing user depot positions (non-zero nominal),
      ** it is an error.
      *
     C     DDSESN        SETLL     UDEPPDF
     C                   EVAL      EndOfFile = False
     C                   DOW       EndOfFile = False
     C     DDSESN        READE     UDEPPDF                                72
     C                   IF        EndOfFile = False AND F3RECI = 'D'
     C                   IF        F3UECN <> 0 OR F3UDNT <> 0 OR
     C                             F3UDNV <> 0 OR F3UDNS <> 0
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0129'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** If there are existing client depot positions (non-zero nominal),
      ** it is an error.
      *
     C     DDSESN        SETLL     CDEPPDF
     C                   EVAL      EndOfFile = False
     C                   DOW       EndOfFile = False
     C     DDSESN        READE     CDEPPDF                                72
     C                   IF        EndOfFile = False AND F4RECI = 'D'
     C                   IF        F4CECN <> 0 OR F4CDNT <> 0 OR
     C                             F4CDNV <> 0 OR F4CDNS <> 0
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0130'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** Check LF/BKPHD - Book Positions Header
      *
     C     DDSESN        SETLL     BKPHDDF
     C                   EVAL      EndOfFile = False
     C                   DOW       EndOfFile = False
     C     DDSESN        READE     BKPHDDF                                72
     C                   IF        EndOfFile = False AND F5RECI = 'D'
      *
      ** Check BKPOSD if record found on details
     C     KBKPOS        CHAIN     BKPOS                              72
     C                   IF        EndOfFile = False AND F6RECI = 'D' AND
     C                             (F6ECNP <> 0 OR F6NPSN <> 0)
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0131'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** Check LF/SEDEV - Security Diary Events
     C     DDSESN        SETLL     SEDEVDF
     C                   EVAL      EndOfFile = False
     C                   DOW       EndOfFile = False
     C     DDSESN        READE     SEDEVDF                                72
     C                   IF        EndOfFile = False
     C                   IF        F7RECI = 'D' OR F7RECI = 'C'
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0234'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** Check LF/DPTMV - Depot Movements
     C     DDSESN        SETLL     DPTMVDF
     C                   EVAL      EndOfFile = False
     C                   DOW       EndOfFile = False
     C     DDSESN        READE     DPTMVDF                                72
     C                   IF        EndOfFile = False AND F8RECI = 'D'
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0235'
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      ** Check LF/SLIMIS - Security Limits
     C     DDSESN        SETLL     SLIMIF                             72
     C                   DOW       EndOfFile = False
     C     DDSESN        READE     SLIMIF                                 72
     C                   IF        EndOfFile = False AND F9RECI = 'D'
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0236'
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

     C     EValDel       ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEnq - Routine to validate Action Code 'E'               *
      *                                                               *
      *****************************************************************

     C     SRValEnq      BEGSR
      *
      ** If there is no valid record on SECTY, it is an error.
      *
     C     DDSESN        CHAIN     SECTY                              70
      *
      ** Check for a valid record.
      *
     C                   IF        RecNotFnd = True
     C                   MOVE      'N'           OKSESN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSESN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0233'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcsSec - Access Security Checking                          *
      *                                                               *
      *****************************************************************

     C     SRAcsSec      BEGSR
      *
      ** If not multi-branching, check authority to only action code.
      *
     C                   IF        BJSBRC <> *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        PActn
     C                   PARM                    PError
     C                   IF        PError <> *ZERO
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   MOVEL     'SEA0304'     MsgIdArr(Idx)
     C                   ENDIF

     C                   ELSE
      *
      ** If multi-branching, check authority to user's default branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        PActn
     C                   PARM      PDBRN         PBrc
     C                   PARM                    PError

     C                   IF        PError = 1
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   MOVEL     'SEA0305'     MsgIdArr(Idx)
     C                   ENDIF

     C                   IF        PError = 2
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   MOVEL     'SEA0306'     MsgIdArr(Idx)
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvOldSec - Retrieve old security details                  *
      *                                                               *
      *****************************************************************

     C     SRRtvOldSec   BEGSR

     C     POSESN        CHAIN     SECTYDF                            01

     C                   IF        *IN01
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POSESN
     C                   EVAL      DBFILE = 'SECTYD'
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SESN = DDSESN
     C                   EVAL      FRNT = *BLANK
     C                   EVAL      REPA = *BLANK
     C                   EVAL      CHTP = *BLANK
     C                   EVAL      TNLU = 0
     C                   EVAL      LCD = 0
     C                   EVAL      ORED = 0
     C                   EVAL      DCOM = 0
     C                   CLEAR                   TMST

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcsInv - Access investment type details                    *
      *                                                               *
      *****************************************************************

     C     SRAcsInv      BEGSR

     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    SITP
     C                   PARM                    NMCY
     C     PINVTPD       PARM      PINVTPD       DSFDY

      ** Do not issues DB error for Action I, it should be cover by                          BUG2408
      ** investment validation.                                                              BUG2408
                                                                                             BUG2408
     C                   IF        DDACTN <> 'I'                                             BUG2408
                                                                                             BUG2408
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = SITP + NMCY
     C                   EVAL      DBFILE = 'INVTPD'
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                             BUG2408
     C                   ENDIF                                                               BUG2408

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAOCust - Access customer details                           *
      *                                                               *
      *****************************************************************

     C     SRAOCust      BEGSR

     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKeyC
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSLDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PKeyC
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

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

     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Retun Code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction Id
     C                   PARM                    FOTRID
      *
      ** Security Shortname
     C                   PARM                    DDSESN
      *
      ** Old Security from link proccessing
     C                   PARM                    POSESN
      *
      ** Process old security details indicator
     C                   PARM                    PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - Default Branch
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
     C                   PARM                    IDx
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Security Shortname
     C                   PARM                    OKSESN
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    PINVTPD
      *
      ** Key fields for LF/HSTTRR
     C     KHSTTR        KLIST
     C                   KFLD                    KTDSS
     C                   KFLD                    KTDDT
     C                   KFLD                    KTDRF
      *
      ** Key fields for LF/BKPOS
     C     KBKPOS        KLIST
     C                   KFLD                    F5BHSC
     C                   KFLD                    F5BHBA
     C                   KFLD                    F5BHBK
     C                   KFLD                    F5BHMK
     C                   KFLD                    F5BHTV
     C                   KFLD                    F5LPSD
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS

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
      *
**  CPY@
(c) Finastra International Limited 2001
