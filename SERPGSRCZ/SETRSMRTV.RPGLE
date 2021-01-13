     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements details retrieve')          *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMRTV - Midas SE Trade Settlements Details retrieve and  *
      *              Key Validation                                   *
      *                                                               *
      *  Function: This module retrieves Security Trade Settlements   *
      *            details from the database. As it does, it          *
      *            validates key fields.                              *
      *                                                               *
      *  Component of: SETRSMSIN                                      *
      *                SETRSMCTL                                      *
      *                SETRSMRPR                                      *
      *                SETRSMUPC                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 29Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP182  *CREATE    Date 11Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80-81      Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInit      - Routine to initialise fields                   *
      *  SrValFrnt   - Routine to validate Front Office Transaction   *
      *                Interface                                      *
      *  SrValKeyFld - Validate Key fields                            *
      *  SrAcsSec    - Access Security Checking                       *
      *  SrNostro    - Subroutine to retrive Nosto Details            *
      *  SrAccount   - Subroutine to retrieve Account details.        *
      *  SrBranch    - Subroutine to retrieve branch details.         *
      *  SrZDate1    - Validate and convert date to day number        *
      *  SrZDate2    - Convert Midas Date into DDMMYY or MMDDYY       *
      *  SrZChkH     - Check if date is a holiday in specified Ccy    *
      *  *PSSR       - Error processing                               *
      *  *INZSR      - Initialise                                     *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Trades by Trade Reference Number
     FTRADHS    IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(TRADSDF)
     F                                     INCLUDE(HSTTRDF)
      *
      ** Trades by Trade Reference Number
     FTRADS     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRADSDF:TRADSVAL)
     F                                     PREFIX(TV_)
      *
      ** Securities by security shortname
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S_)
      *
      ** Trades Settlement file - by Front Office Id.
     FSETSFL1   IF   E           K DISK    INFSR(*PSSR)
      *
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
      ** SE Trade Settlements Details retrieved from file - file format
     D TRADFmt       E DS                  EXTNAME(TRADHS)
      *
      ** SE Trade Settlements Details retrieved from file - file format
     D TRADValFmt    E DS                  EXTNAME(TRADHS)
     D                                     PREFIX(TV_)
      *
      ** SE Trade Details retrieved from file - file format
      ** This DS will be passed to the calling module.
     D CrTDFilFmt    E DS                  EXTNAME(TRADHS)
     D                                     PREFIX(T_)
      *
      ** Security Details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(S_)
      *
      ** Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for Securities Customers
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Retail Account Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Account Details
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      *
      ** Entry parameter list definition
     D PMode           S              6A
     D PRespMode       S              1A
     D PFRNT           S             20A
     D DDTRDR          S              6A
     D DDMVDT          S              6A
     D DDFSET          S              1A
     D DDREVE          S              1A
     D PEdtFld         S              1A
     D BJSBRC          S              3A
     D BJRDNB          S              5P 0
     D BJDFIN          S              1A
     D PDBRN           S              3A
      *
     D OKTRDR          S              1A
     D OKMVDT          S              1A
     D OKFSET          S              1A
     D OKREVE          S              1A
      *
      ** Parameter list for validation of action code
     D PActn           S              1A
     D PError          S              1P 0
     D PBrc            S              3A
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D PNonb           S              2A
     D PBrcd           S              3A
     D PCssn           S             10A
     D PPnoi           S              1A
      *
     D DSAccount       DS
     D PCnum                   1      6
     D PCcyCode                7      9
     D PAcctCode              10     19                                                       CGL029
     D PAcctSeq               20     21                                                       CGL029
     D PBrch                  22     24                                                       CGL029
     D*PAcctCode              10     13                                                       CGL029
     D*PAcctSeq*              14     15                                                       CGL029
     D*PBrch****              16     18                                                       CGL029
      *
      ** Parameters for ZDATE1
     D PADateIn        S              6A
     D PDayNoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Parameter list for ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameters for ZCHKH
     D PZDayNoIn       S              5P 0
     D PZCcy           S              3A
     D PZLoc           S              3A
     D PZHolInd        S              1A
                                                                                              CGL029
      ** Fields redefined by CGL029                                                           CGL029
     D WCDSQ           S             12P 0                                                    CGL029
     D WAcodAcsq       S             12A                                                      CGL029
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialise.
      *
     C                   EXSR      SrInit
      *
      ** If the mode is 'Front Office Transaction Interface',
      ** do (extra) validation for Front Office Transaction Interface.
      *
     C                   If        PMode = '*FRONT'
     C                   Exsr      SrValFrnt
      *
      ** No further validation if errors occurred.
      *
     C                   If        OKTRDR = 'N' Or OKMVDT = 'N' Or
     C                             OKFSET = 'N' Or OKREVE = 'N'
     C                   RETURN
     C                   EndIf
 
     C                   EndIf
      *
      ** Validate key fields if in Edit mode.
     C                   If        PEdtFld = 'Y'
     C                   Exsr      SrValKeyFld
     C                   Else
     C                   Exsr      SrRetrieve
     C                   EndIf
      *
      ** Move file values to output parameter if Key fields are valid
     C                   Eval      CrTDFilFmt = TRADFmt
      *
      ** No further validation if errors occurred.
     C                   If        OKTRDR = 'N' Or OKMVDT = 'N' Or
     C                             OKFSET = 'N' Or OKREVE = 'N'
     C                   RETURN
     C                   EndIf
      *
      ** Access security checking.
     C                   If        PRespMode = 'S'
     C                   Exsr      SRAcsSec
     C                   EndIf
      *
      ** Return.
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  SrInit - Routine to initialise fields                        *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
      *
      ** Initialise output fields.
      *
     C                   Clear                   CrTDFilFmt
     C                   Clear                   TRADFmt
     C                   Clear                   TRADValFmt
     C                   Clear                   PSectyd
      *
     C                   Movel     'Y'           OKTRDR
     C                   Movel     'Y'           OKMVDT
     C                   Movel     'Y'           OKFSET
     C                   Movel     'Y'           OKREVE
      *
      *
      ** Access Securities Trading ICD Details
     C                   Call      'AOSTRDR0'
     C                   Parm      '*DBERR '     PRtcd
     C                   Parm      '*FIRST '     POptn
     C     SDSTRD        Parm      SDSTRD        DSSDY
     C                   If        PRtcd <> *Blanks
     C                   Eval      DBFILE = 'SDSTRDPD'
     C                   Eval      DBASE  = 002
     C                   Eval      DBKEY = '*FIRST '
     C                   Exsr      *PSSR
     C                   EndIf
      *
      *
      ** Get Module Details
     C                   Call      'AOMMODR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*FIRST'      POptn
     C     SDMMOD        Parm      SDMMOD        DSFDY
     C                   If        PRtcd <> *Blanks
     C                   Eval      DBFILE = 'SDMMODPD'
     C                   Eval      DBASE  = 003
     C                   Eval      DBKEY = '*FIRST '
     C                   Exsr      *PSSR
     C                   EndIf
      *
      ** Get retail details
     C                   If        BGRTBN = 'Y' Or BGIOAC = 'Y'
     C                   Call      'AORETLR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*FIRST'      POptn
     C     SDRETL        Parm      SDRETL        DSFDY
     C                   If        PRtcd <> *Blanks
     C                   Eval      DBFILE = 'SDRETLPD'
     C                   Eval      DBASE  = 004
     C                   Eval      DBKEY = '*FIRST '
     C                   Exsr      *PSSR
     C                   EndIf
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrValFrnt - Routine to validate Front Office Transaction     *
      *              Interface                                        *
      *                                                               *
      *****************************************************************
 
     C     SrValFrnt     BEGSR
      *
      ** Error if Front Office Transaction Id is blank.
     C                   If        PFRNT = *BLANKS
     C                   Move      'N'           OKTRDR
     C                   Add       1             IDx
     C                   Eval      FldNameArr(IDx) = 'DDTRDR'
     C                   Eval      MsgIdArr(IDx) = 'APM0201'
     C                   EndIf
      *
      ** No further validation if errors occurred.
     C                   If        OKTRDR = 'N'
     C                   Goto      EValFrnt
     C                   EndIf
      *
      ** Access security trade details file using Front Office
      ** Transaction Id.
     C     PFRNT         Chain     SETSFL1                            99
      *
      ** Front Office Transaction Id must not be present.
     C                   If        *IN99 = '0'
     C                   Move      'N'           OKTRDR
     C                   Add       1             IDx
     C                   Eval      FldNameArr(IDx) = 'DDTRDR'
     C                   Eval      MsgIdArr(IDx) = 'APM0103'
     C                   Eval      MsgDtaArr(IDx) = PFRNT
     C                   Goto      EValFrnt
     C                   EndIf
      *
     C     EValFrnt      ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrValKeyFld - Validate Key fields                            *
      *                                                               *
      *****************************************************************
 
     C     SrValKeyFld   BEGSR
      *
      ** Reset working fields
     C                   Move      *Blanks       PCnum
     C                   Move      *Blanks       PCcyCode
     C                   Move      *Blanks       PAcctCode
     C                   Move      *Blanks       PAcctSeq
     C                   Move      *Blanks       PBrch
     C                   Move      *Blanks       WEndValid         1
     C                   Move      *Blanks       WAcodAcsq
     C                   Move      *Blanks       WCust
      *
      *
      ** Validate Trade Number: Mandatory
      *  ======================
      *
     C                   If        DDTRDR = *BLANKS
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2020'
     C                   Endif
      *
      ** Must reference an active, complete trade or a reversal of a
      *  fully-settled trade
     C                   If        DDTRDR <> *BLANKS                            A1
      *
     C     DDTRDR        Chain     TRADSVAL                           80
     C                   If        *IN80 = '1'
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2020'
     C                   Endif
      *
     C                   If        *IN80 = '0'                                  A2
      *
     C                   Eval      TRADFmt = TRADValFmt
      *
      ** Store last transaction number
     C                   Z-Add     TNLU          WWTNLU            5 0
      *
      ** Check record is active
     C                   If        RECI = '*' OR RECI = 'C'                     A3
     C                             OR RECI = 'S' AND DDREVE <> 'Y'
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2021'
     C                   Else
      *
      ** Must not reference a trade created by a book transfer.
     C                   Movel     TCNR          WCust             6
     C                   Call      'AOSECSR0'
     C                   Parm      '*DBERR'      PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      WCust         CUST              6
     C     SDSECS        Parm      SDSECS        DSSDY
      *
      * and not flagged for automatic settlement
     C                   If        AUTS = 'Y' Or BFCLAS = 'I'                   A4
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2024'
     C                   Else
      *
      * Check record is complete
     C                   If        TINC <> 'C'                                  A5
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2025'
     C                   Else
      *
      * Check record is authorised
     C                   If        RECI = 'L' Or RECI = 'R'                     A6
     C                             Or RECI = 'P'
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2026'
     C                   Else
      *
      * and not already fully settled - unless reversal being entered
     C                   If        TDFS <> *Zeros And DDREVE <> 'Y'             A7
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2027'
     C                   Else
      *
      * Fetch Security detail
     C     TDSS          Chain     SECTYDF                            81
     C                   If        *In81 = '0'                                  B1
     C                   If        S_RECI <> 'D'                                B2
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2028'
     C                   Else
      *
      * If record ok, check Deliver To field there for purchase
     C**********         If        TDTP = 'TP' And DELT = *Zeros                              CSD027
     C                   If        TDTP = 'TP' And DELT = *Blanks                             CSD027
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2029'
     C                   Endif
      *
      * OR Deliver From field there for Sale
     C**********         If        TDTP = 'TS' And DELF = *Zeros                              CSD027
     C                   If        TDTP = 'TS' And DELF = *Blanks                             CSD027
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2030'
     C                   Endif
      *
     C                   Endif                                                  B2
     C                   Endif                                                  B1
      *
     C                   Endif                                                  A7
     C                   Endif                                                  A6
     C                   Endif                                                  A5
     C                   Endif                                                  A4
     C                   Endif                                                  A3
     C                   Endif                                                  A2
     C                   Endif                                                  A1
      *
      *
      ** If trade reference is invalid, other validation is superfluous
     C                   If        DDTRDR <> *Blanks And OKTRDR <> 'N'          C1
      *
      ** Validate Movement Date:
      *  =======================
      *
     C                   If        DDMVDT = *BLANKS
     C                   Z-add     BJRDNB        PDateIn
     C                   Exsr      SrZDate2
     C                   Move      PDateOut      DDMVDT
     C                   Endif
      *
      ** Check valid date entered
     C                   Eval      PADateIn = DDMVDT
     C                   Exsr      SrZDATE1
     C                   If        PErrorFlag = 'Y'                             C2
     C                   Move      'N'           OKMVDT
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDMVDT'
     C                   Eval      MsgIdArr(Idx) = 'USR2031'
     C                   Else
      *
      ** If ok, check before Run date
     C                   If        PDaynoOut > BJRDNB
     C                   Move      'N'           OKMVDT
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDMVDT'
     C                   Eval      MsgIdArr(Idx) = 'USR2032'
     C                   Endif
      *
      ** Check after Value date of trade
     C                   If        PDaynoOut < TDVD
     C                   Move      'N'           OKMVDT
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDMVDT'
     C                   Eval      MsgIdArr(Idx) = 'USR2033'
     C                   Endif
      *
      ** Check if not equal to Value date but equal to particular Settlement
      *  methods that it is not a holiday in Settlement Currency.
     C                   If        TDVD <> BJRDNB                               C3
     C                   If        SMTH = 01 Or SMTH = 02 Or SMTH = 07          C4
     C                             Or SMTH = 08 Or SMTH = 12
      *
     C                   Eval      PZLoc = *Blanks
      *
      ** Get Nostro Number
     C                   If        TDTP = 'TP'
     C                   Movel     PYFM          PNonb
      *                  Else
     C                   If        TDTP = 'TS'
     C                   Movel     PAYT          PNonb
     C                   Endif
     C                   Endif
      *
     C                   Eval      PCcyCode = SETC
      *
      ** Call Access Object to find the Branch Code of the Nostro
     C                   Exsr      SRNostro
      *
     C                   If        PRtcd = *Blanks
     C                   Eval      PDsnb = A7BRCD
     C                   Exsr      SRBranch
     C                   Eval      PZloc = A8LCCD
     C                   Endif
      *
     C                   Z-ADD     PDaynoOut     PZDayNoIn
     C                   Eval      PZCcy = SETC
     C                   Exsr      SrZChkH
 
     C                   If        PZHolInd = 'H'
     C                   Move      'W'           OKMVDT
     C                   Add       1             WIdx
     C                   Eval      WFldNamArr(WIdx) = 'DDMVDT'
     C                   Eval      WMsgIdArr(WIdx) = 'USR2034'
     C                   EndIf
      *
     C                   EndIf                                                  C4
     C                   EndIf                                                  C3
      *
     C                   EndIf                                                  C2
      *
      *
      ** Validate Full Settlement: Valid values 'Y', 'N' or blank
      *  ========================
     C                   If        DDFSET <> 'Y' And DDFSET <> 'N'
     C                             And DDFSET <> *Blanks
     C                   Move      'N'           OKFSET
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDFSET'
     C                   Eval      MsgIdArr(Idx) = 'USR2035'
     C                   EndIf
      *
      ** If 'Y', the trade cannot already be fully settled
     C                   If        DDFSET = 'Y'  And TDFS <> *Zeros
     C                   Move      'N'           OKFSET
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDFSET'
     C                   Eval      MsgIdArr(Idx) = 'USR2036'
     C                   EndIf
      *
      *
      ** Validate Reversal Indicator: Valid values 'Y', 'N' or blank
      *  ===========================
      *
     C                   If        DDREVE <> 'Y' And DDREVE <> 'N'
     C                             And DDREVE <> *Blanks
     C                   Move      'N'           OKREVE
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDREVE'
     C                   Eval      MsgIdArr(Idx) = 'USR2035'
     C                   EndIf
      *
      ** If 'Y', the trade must be partly or fully settled already
     C                   If        DDREVE = 'Y'
     C                   If        TNSP = *Zeros And TNSN = *Zeros And
     C                             TVSP = *Zeros And TVSN = *Zeros
     C                   Move      'N'           OKREVE
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDREVE'
     C                   Eval      MsgIdArr(Idx) = 'USR2037'
     C                   EndIf
     C                   EndIf
      *
      *
      ** Check that account is not blocked
      *  =================================
      *
      ** Settlement method 04
      *  --------------------
     C                   If        SMTH = 4
     C                   Eval      PBrch = TDBA
     C                   Movel     TCNR          PCnum
     C                   Eval      PCcyCode = SETC
     C                   Movel     BMACCD        PAcctCode
     C                   Eval      PAcctSeq = '01'
     C                   EndIf
      *
      ** Settlement method 05
      *  --------------------
     C                   If        SMTH = 5
     C                   If        TDTP = 'TP'
     C                   Eval      PBrch = PYFA
     C                   Movel     PYFM          PCnum
     C**********         Move      PYFM          WAcodAcsq         6                          CGL029
     C                   MOVE      PYFM          WAcodAcsq                                    CGL029
     C                   EndIf
     C                   If        TDTP = 'TS'
     C                   Eval      PBrch = PYTA
     C                   Movel     PAYT          PCnum
     C                   Move      PAYT          WAcodAcsq
     C                   EndIf
     C                   Eval      PCcyCode = SETC
     C                   Movel     WAcodAcsq     PAcctCode
     C                   Move      WAcodAcsq     PAcctSeq
     C                   Endif
      *
      ** Settlement method 14
      *  --------------------
     C                   If        SMTH = 14
      *
     C                   If        TDTP = 'TP'
     C                   Movel     PYFM          PRetlAcc
     C                   EndIf
      *
     C                   If        TDTP = 'TS'
     C                   Movel     PAYT          PRetlAcc
     C                   EndIf
      *
     C                   Exsr      SrAccount
      *
     C                   If        PRtcd <> *Blanks  Or
     C                             PRtcd = *Blanks And A_RECI <> 'D'
     C                   Eval      WEndValid = 'Y'
     C                   Else
     C                   Move      A_CNUM        PCnum
     C                   Eval      PCcyCode = A_CCY
     C                   Eval      PBrch = A_BRCA
     C                   Move      A_ACOD        PAcctCode
     C                   Move      A_ACSQ        PAcctSeq
     C                   Endif
      *
     C                   Endif
      *
      *
      ** Settlement method 15
      *  --------------------
     C                   If        SMTH = 15
     C                   If        TDTP = 'TP'
     C                   Movel     PYFM          PCnum
     C                   Movel     PYFA          PBrch
     C**********         Move      PYFM          WCDSQ             6 0                        CGL029
     C                   MOVE      PYFM          WCDSQ                                        CGL029
     C                   EndIf
     C                   If        TDTP = 'TS'
     C                   Movel     PAYT          PCnum
     C                   Movel     PYTA          PBrch
     C                   Move      PAYT          WCDSQ
     C                   EndIf
     C                   Movel     SETC          PCcyCode
      *
      ** If the Account Code and Account Sequence are blank, get the      089949
      *  values from CLINTSE, else, use the input.                        089949
     C                   If        WCDSQ = *Zeros
     C                   CallB     'AOSECSR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY'        POptn
     C                   Parm                    PCnum
     C     SDSECS        Parm      SDSECS        DSSDY
      *
     C                   Movel     BFACCD        PAcctCode
     C                   Move      BFACSN        PAcctSeq
     C                   Else
     C                   Movel     WCDSQ         PAcctCode
     C                   Move      WCDSQ         PAcctSeq
     C                   EndIf
      *
     C                   EndIf
      *
     C                   If        SMTH <> 4 And SMTH <> 5 And
     C                             SMTH <> 14 And SMTH <> 15
     C                   Eval      WEndValid = 'Y'
     C                   Endif
      *
     C                   If        WEndValid <> 'Y'
     C                   Exsr      SrAccount
     C                   If        PRtcd <> *Blanks Or A_RECI <> 'D'
      ** Database Error
     C                   Eval      DBFILE = 'ACCNTAB'
     C                   Eval      DBASE  = 001
     C                   Eval      DBKEY = DSAccount
     C                   Exsr      *PSSR
     C                   Else
      *
     C                   TESTB     '2'           A_RETB                   41
     C                   TESTB     '3'           A_RETB                   42
      *
     C                   If        TDTP = 'TP' And *In41 = '1'
     C                             And DDREVE <> 'Y'  Or
     C                             TDTP = 'TP' And *In42 = '1'
     C                             And DDREVE = 'Y'  Or
     C                             TDTP = 'TS' And *In42 = '1'
     C                             And DDREVE <> 'Y'  Or
     C                             TDTP = 'TS' And *In41 = '1'
     C                             And DDREVE = 'Y'
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2038'
     C                   EndIf
      *
     C                   EndIf
     C                   EndIf
      *
     C                   Endif                                                  C1
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SrRetrieve - Subroutine to retrieve Settlement Details        *
      *                                                               *
      *****************************************************************
     C     SrRetrieve    BEGSR
      *
     C                   If        DDTRDR = *BLANKS
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2020'
     C                   Endif
      *
      ** Must reference an active or historic trade
     C                   If        DDTRDR <> *BLANKS                            A1
      *
     C     DDTRDR        Chain     TRADSDF                            80
     C                   If        *IN80 = '1'
     C     DDTRDR        Chain     HSTTRDF                            80
     C                   Endif
      *
     C                   If        *IN80 = '0'
      * Fetch Security detail
     C     TDSS          Chain     SECTYDF                            81
     C                   If        *In81 = '0' And S_RECI <> 'D'                B1
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Eval      MsgIdArr(Idx) = 'USR2028'
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SrNostro - Subroutine to retrive Nosto Details                *
      *                                                               *
      *****************************************************************
     C     SrNostro      BEGSR
 
     C                   CallB     'AONOSTR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm      *BLANKS       PCnum
     C                   Parm                    PCcyCode
     C                   Parm      *BLANKS       PAcctCode
     C                   Parm      *BLANKS       PAcctSeq
     C                   Parm                    PNonb
     C                   Parm      *BLANKS       PBrcd
     C                   Parm      *BLANKS       PCssn
     C                   Parm      *BLANKS       PPnoi
     C     SDNOST        Parm      SDNOST        DSFDY
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrAcsSec - Access Security Checking                          *
      *                                                               *
      *****************************************************************
     C     SrAcsSec      BEGSR
      *
      ** If not multi-branching, check authority to only action code.
      *
     C                   If        BJSBRC <> *BLANK
 
     C                   Call      'ZVACTU'
     C                   Parm      'I'           PActn
     C                   Parm                    PError
     C                   If        PError <> *ZERO
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Movel     'USR2022'     MsgIdArr(Idx)
     C                   Endif
 
     C                   Else
      *
      ** If multi-branching, check authority to user's default branch.
      *
     C                   Call      'ZVACTBU'
     C                   Parm      'I'           PActn
     C                   Parm      PDBRN         PBrc
     C                   Parm                    PError
 
     C                   If        PError = 1
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Movel     'USR2023'     MsgIdArr(Idx)
     C                   Endif
 
     C                   If        PError = 2
     C                   Move      'N'           OKTRDR
     C                   Add       1             Idx
     C                   Eval      FldNameArr(Idx) = 'DDTRDR'
     C                   Movel     'USR2023'     MsgIdArr(Idx)
     C                   Endif
 
     C                   Endif
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SrAccount - Subroutine to retrieve Account details.           *
      *                                                               *
      *****************************************************************
     C     SrAccount     BEGSR
      *
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY    '    POptn
     C                   Parm                    PRetlAcc         10
     C                   Parm                    PCnum
     C                   Parm                    PCcyCode
     C                   Parm                    PAcctcode
     C                   Parm                    PAcctSeq
     C                   Parm                    PBrch
     C     ACCNT         Parm      ACCNT         DSSDY
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SrBranch -  Subroutine to retrieve branch details.            *
      *                                                               *
      *****************************************************************
     C     SrBranch      BEGSR
      *
     C**********         Call      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm                    PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PDsnb             3
     C*****SDBRCH        Parm      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SrZDate1      BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PADateIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
      *                                                               *
      *****************************************************************
     C     SrZDate2      BEGSR
 
     C                   CallB     'ZDATE2'
     C                   Parm                    PDateIn
     C                   Parm                    BJDFIN
     C                   Parm      *ZERO         PDateOut
     C                   Parm      *BLANKS       PADateOut
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrZChkH - Check if date is a holiday in specified currency   *
      *                                                               *
      *****************************************************************
     C     SrZChkH       BEGSR
 
     C                   CallB     'ZCHKH'
     C                   Parm                    PZDayNoIn
     C                   Parm                    PZCcy
     C                   Parm                    PZLoc
     C                   Parm      *BLANK        PZHolInd
 
     C                   ENDSR
      *
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
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PRespMode
      *
      ** Front Office Transaction Id
     C                   PARM                    PFRNT
      *
      ** Trade Reference
     C                   PARM                    DDTRDR
      *
      ** Movement Date
     C                   PARM                    DDMVDT
      *
      ** Full Settlement
     C                   PARM                    DDFSET
      *
      ** Reversal
     C                   PARM                    DDREVE
      *
      ** Enable detail fields indicator
     C                   PARM                    PEdtFld
      *
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
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
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** OK Trade Reference
     C                   PARM                    OKTRDR
      *
      ** OK Movement Date
     C                   PARM                    OKMVDT
      *
      ** OK Full Settlement
     C                   PARM                    OKFSET
      *
      ** OK Reversal
     C                   PARM                    OKREVE
      *
      ** Security Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Security Details
     C                   PARM                    PSectyd
      *
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
(c) Finastra International Limited 2003
