     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Sec diary events retrieve + actn/key val')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDERTV - Security Diary Events Retrieve and Action Code / *
      *              Key Validation                                   *
      *                                                               *
      *  Function: This module retrieves security diary events        *
      *            details from the database. As it does, it vali-    *
      *            dates the action code and key fields.              *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                SESEDECTL                                      *
      *                SESEDERPR                                      *
      *                SESEDEUPC                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD038918           Date 31May16               *
      *  Prev Amend No. 260331             Date 31Mar16               *
      *                 MD000091           Date 17May13               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210122             Date 07Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 09Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD038918 - Rate reset in Bank Fusion. Allow insertion of IR  *
      *             event for an FRN security with event date equal   *
      *             to the coupon array or the adjusted coupon date.  *
      *  260331 - Incorrect posting created due to a deleted diary    *
      *           event. Applied fix 255857.                          *
      *         - Applied for MD-37742.                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  210122 - Not possible to insert dividend position settle-    *
      *           ments and dividend diary events for securities      *
      *           with processing type '7'.                           *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inpyts into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    70-72      Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit - Routine to initialise fields                        *
      *  SRValFrnt - Routine to validate Front Office Transaction     *
      *              Interface                                        *
      *  SRValAct - Routine to validate Action Code and Key fields    *
      *  SRValIns - Routine to validate Action Code 'I'               *
      *  SRValAmd - Routine to validate Action Code 'A'               *
      *  SRValDel - Routine to validate Action Code 'D'               *
      *  SRValEnq - Routine to validate Action Code 'E'               *
      *  SRAcsSec - Access Security Checking                          *
      *  SREvtDate - Extra validation for Event Date                  *
      *  SREvtDate - Extra validation for Event Type                  *
      *  SRNchDay - Check if Next Change Day is allowed to differ     *
      *             to Event Day                                      *
      *  SRZDate1 - Validate and convert date to day number           *
      *  SRZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
      *  SRZChkH - Check if date is a holiday in specified currency   *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Diary Events
     FSEDEV     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Security Diary Events by Front Office Id
     FSEDEVL2   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVD4)
      *
      ** Securities by security shortname
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F1)
      *
      ** Trades by security shortname
     FTRADSE    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F2)
      *
      ** Position Settlement by Security
     FPOSET3    IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F3)
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
      ** Security diary events retrieved from file - file format
     D SEDEFmt       E DS                  EXTNAME(SEDEVD)
      *
      ** Security diary events retrieved from file - file format
      ** This DS will be passed to the calling module.
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
     D                                     PREFIX(CR)
      *
      ** Investment types details
     D PInvtpd       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(D1)
      *
      ** Security Details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(F1)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             70     70
     D  FrntNotFnd            71     71
     D  EndOfFile             72     72
      *
      ** Coupon Rate Days array
     D WCD             S              4  0 DIM(12)
      *
      ** Coupon Rate Ind. array
     D WCR             S              1    DIM(12)
      *
     D WDat            S              6  0 DIM(12)
     D TABMTH          S              2  0 DIM(12) CTDATA PERRCD(12)
     D TABDAY          S              2  0 DIM(12) ALT(TABMTH)
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
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Entry parameter list definition
     D PMode           S              6A
     D PResponse       S              1A
     D DDACTN          S              1A
     D FOTRID          S             20A
     D DDSDSN          S             10A
     D DDSDED          S              6A
     D DDSDET          S              2A
     D BJSBRC          S              3A
     D BJRDNB          S              5P 0
     D BJDFIN          S              1A
     D BVBVP           S              3P 0
     D PDBRN           S              3A
     D CSE010          S              1A
     D S01509          S              1A
     D OKACTN          S              1A
     D OKSDSN          S              1A
     D OKSDED          S              1A
     D OKSDET          S              1A
      *
      ** Parameter list for validation of action code
     D PActn           S              1A
     D PError          S              1P 0
     D PBrc            S              3A
      *
     D PRtCd           S              7A
     D POptn           S              7A
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
      *
      ** Work fields
     D WEvtDNo         S              5P 0
     D WEvtDat         S              6P 0
     D Wk2N            S              2P 0
     D Wk4N            S              4P 0
     D WBKVP           S              5P 0
     D WNum4           S              4P 0
     D WZDay           S              2P 0
     D WZMth           S              2P 0
     D WZYear          S              2P 0
     D WEDay           S              2P 0
     D WEMth           S              2P 0
     D WEYear          S              2P 0
     D WEOMDay         S              2P 0
     D WMYr            S              2P 0
     D WMYrC           S              3P 0
     D WIYr            S              2P 0
     D WIYrC           S              3P 0
     D WIx             S              2P 0
     D Work5N          S              5P 0
     D Work2N          S              2P 0
     D Work1N          S              1P 0
      *
      ** Work fields for parameter
     D PReDsp          S              1A
     D PSDSN           S             10A
     D WESC            S              1A
     D PPROT           S              1A
     D WSEDE           S                   LIKE(SEDEFMT)
     D PEvtDno         S                   LIKE(WEvtDNo)
     D PCpd            S                   LIKE(PDayNoOut)                                  MD038918
                                                                                              CSE065
     D CSE065          S              1A                                                      CSE065
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
     C                             OKSDED = 'N' OR OKSDET = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate action code and key fields.
      *
     C                   EXSR      SRValAct
      *
      ** No further validation if errors occurred.
      *
     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
     C                             OKSDED = 'N' OR OKSDET = 'N'
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
     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
     C                             OKSDED = 'N' OR OKSDET = 'N'
     C                   RETURN
     C                   ENDIF
      *
      ** Do some extra validation for event date and event type.
      *
     C                   EXSR      SrEvtDate
     C                   EXSR      SrEvtType
      *
      ** No further validation if errors occurred.
      *
     C                   IF        OKACTN = 'N' OR OKSDSN = 'N' OR
     C                             OKSDED = 'N' OR OKSDET = 'N'
     C                   RETURN
     C                   ENDIF
      *
      ** If Action is not Insert, move file values to outout
      ** parameter if action code and key fields are valid.
      *
     C     DDACTN        IFNE      'I'
     C                   EVAL      CrDEFilFmt = SEDEFmt
     C                   ENDIF
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
     C                   CLEAR                   CrDEFilFmt
     C                   Z-ADD     0             CrSDED
     C                   Z-ADD     0             CrSDVA
     C                   Z-ADD     0             CrSRPT
     C                   Z-ADD     0             CrSDTR
     C                   Z-ADD     0             CrSDPD
     C                   Z-ADD     0             CrSDNC
     C                   Z-ADD     0             CrSDPP
     C                   Z-ADD     0             CrSDPC
     C                   Z-ADD     0             CrSDTA
     C                   Z-ADD     0             CrSDTP
     C                   Z-ADD     0             CrSDRP
     C                   Z-ADD     0             CrSDCE
     C                   Z-ADD     0             CrSDAD
     C                   Z-ADD     0             CrSDDT
     C                   Z-ADD     0             CrLCD
     C                   Z-ADD     0             CrTNLU
     C                   Z-ADD     0             CrSDCP
     C                   Z-ADD     0             CrSDXD
     C                   Z-ADD     0             CrSCRS                                       CAS006
     C                   Z-ADD     0             CrSLQP                                       CAS006
     C                   Z-ADD     0             CrSDNN                                       CAS006
 
     C                   CLEAR                   SEDEFmt
     C                   Z-ADD     0             SDED
     C                   Z-ADD     0             SDVA
     C                   Z-ADD     0             SRPT
     C                   Z-ADD     0             SDTR
     C                   Z-ADD     0             SDPD
     C                   Z-ADD     0             SDNC
     C                   Z-ADD     0             SDPP
     C                   Z-ADD     0             SDPC
     C                   Z-ADD     0             SDTA
     C                   Z-ADD     0             SDTP
     C                   Z-ADD     0             SDRP
     C                   Z-ADD     0             SDCE
     C                   Z-ADD     0             SDAD
     C                   Z-ADD     0             SDDT
     C                   Z-ADD     0             LCD
     C                   Z-ADD     0             TNLU
     C                   Z-ADD     0             SDCP
     C                   Z-ADD     0             SDXD
     C                   Z-ADD     0             SCRS                                         CAS006
     C                   Z-ADD     0             SLQP                                         CAS006
     C                   Z-ADD     0             SDNN                                         CAS006
 
     C                   CLEAR                   PSectyd
     C                   Z-ADD     0             F1NMDP
     C                   Z-ADD     0             F1SIDY
     C                   Z-ADD     0             F1SLCA
     C**********         Z-ADD     0             F1ISSR                                       CSD027
     C                   EVAL      F1ISSR = *BLANKS                                           CSD027
     C                   Z-ADD     0             F1SDNM
     C                   Z-ADD     0             F1IDIV
     C                   Z-ADD     0             F1CD01
     C                   Z-ADD     0             F1CD02
     C                   Z-ADD     0             F1CD03
     C                   Z-ADD     0             F1CD04
     C                   Z-ADD     0             F1CD05
     C                   Z-ADD     0             F1CD06
     C                   Z-ADD     0             F1CD07
     C                   Z-ADD     0             F1CD08
     C                   Z-ADD     0             F1CD09
     C                   Z-ADD     0             F1CD10
     C                   Z-ADD     0             F1CD11
     C                   Z-ADD     0             F1CD12
     C                   Z-ADD     0             F1NEXD
     C                   Z-ADD     0             F1LCPN
     C                   Z-ADD     0             F1CPNR
     C                   Z-ADD     0             F1BASC
     C                   Z-ADD     0             F1BASS
     C                   Z-ADD     0             F1MCPN
     C                   Z-ADD     0             F1MATY
     C**********         Z-ADD     0             F1RSKC                                       CSD027
     C                   EVAL      F1RSKC = *BLANKS                                           CSD027
     C                   Z-ADD     0             F1IADJ
     C                   Z-ADD     0             F1ITLD
     C                   Z-ADD     0             F1FCPN
     C                   Z-ADD     0             F1NCHD
     C                   Z-ADD     0             F1SINP
     C                   Z-ADD     0             F1SFPP
     C                   Z-ADD     0             F1ISSD
     C                   Z-ADD     0             F1ISSP
     C**********         Z-ADD     0             F1LMGR                                       CSD027
     C                   EVAL      F1LMGR = *BLANKS                                           CSD027
     C                   Z-ADD     0             F1ISSA
     C                   Z-ADD     0             F1TOTU
     C                   Z-ADD     0             F1ALRQ
     C                   Z-ADD     0             F1ALRC
     C                   Z-ADD     0             F1MGFD
     C                   Z-ADD     0             F1MGRC
     C                   Z-ADD     0             F1UNFD
     C                   Z-ADD     0             F1UNFR
     C                   Z-ADD     0             F1DCOM
     C                   Z-ADD     0             F1MKPR
     C                   Z-ADD     0             F1ORED
     C                   Z-ADD     0             F1NDVD
     C                   Z-ADD     0             F1SEXR
     C                   Z-ADD     0             F1LPRU
     C                   Z-ADD     0             F1CPDP
     C                   Z-ADD     0             F1TPHD
     C                   Z-ADD     0             F1SCPP
     C                   Z-ADD     0             F1SCPD
     C                   Z-ADD     0             F1LCD
     C                   Z-ADD     0             F1TNLU
     C                   Z-ADD     0             F1CMFQ
     C                   Z-ADD     0             F1CFCT
     C                   Z-ADD     0             F1SRBK
     C**********         Z-ADD     0             F1PPAG                                       CSD027
     C**********         Z-ADD     0             F1GUAR                                       CSD027
     C                   EVAL      F1PPAG = *BLANKS                                           CSD027
     C                   EVAL      F1GUAR = *BLANKS                                           CSD027
     C                   Z-ADD     0             F1WEIC
 
     C                   CLEAR                   PInvtpd
     C**********         Z-ADD     0             D1SDC1                                       CSD027
     C**********         Z-ADD     0             D1SDC2                                       CSD027
     C**********         Z-ADD     0             D1SDC3                                       CSD027
     C                   EVAL      D1SDC1 = *BLANKS                                           CSD027
     C                   EVAL      D1SDC2 = *BLANKS                                           CSD027
     C                   EVAL      D1SDC3 = *BLANKS                                           CSD027
     C                   Z-ADD     0             D1CMGN
     C                   Z-ADD     0             D1EXPC
     C                   Z-ADD     0             D1DTRD
     C                   Z-ADD     0             D1LCD
     C                   Z-ADD     0             D1TNLU
     C                   Z-ADD     0             D1DCMF
     C                   Z-ADD     0             D1PRTO
 
 
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKSDSN
     C                   MOVEL     'Y'           OKSDED
     C                   MOVEL     'Y'           OKSDET
      *
      ** Initialise work variables.
      *
     C                   Z-ADD     0             WEvtDNo
     C                   Z-ADD     0             WEvtDat
 
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
      ** Access security diary events details file using Front Office
      ** Transaction Id.
      *
     C     FOTRID        CHAIN     SEDEVL2                            71
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
     C                   EVAL      MsgDtaArr(IDX) = LenStr +%TRIM(FOTRID)                   MD000091
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
     C                   EVAL      MsgDtaArr(IDX) = LenStr +%TRIM(FOTRID)                   MD000091
     C                   GOTO      EValFrnt
     C                   ENDIF
      *
      ** If not insert, update security diary events key fields.
      *
     C                   MOVEL     SDSN          DDSDSN
     C                   MOVEL     SDET          DDSDET
 
     C                   IF        SDED = 99999
     C                   MOVE      '999999'      DDSDED
     C                   ELSE
     C                   Z-ADD     SDED          PDateIn
     C                   EXSR      SrZDATE2
     C                   MOVE      PDateOut      DDSDED
     C                   ENDIF
 
     C                   ENDIF
 
     C     EValFrnt      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAct - Routine to validate Action Code and Key fields    *
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
      ** Check Security Shortname and call Securities Selection.
      *
     C     '?'           SCAN      DDSDSN                                 01
 
     C                   IF        CSE010 = 'Y' AND
     C                             PMODE <> '*FRONT' AND *IN01
     C                   CALL      'SE0043'
     C                   PARM                    PACTN
     C                   PARM      '?'           PSDSN
     C                   IF        PSDSN <> *BLANKS
     C                   EVAL      DDSDSN = PSDSN
     C                   ELSE
     C                   EVAL      DDSDSN = *BLANKS
     C                   ENDIF
     C                   EVAL      PReDsp = 'Y'
     C                   ENDIF
      *
      ** If the security shortname is blank, it is an error.
      *
     C                   IF        DDSDSN = *BLANKS
     C                   MOVE      'N'           OKSDSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0399'
     C                   ELSE
      *
      ** Security shortname must not be a reserved word.
      *
     C                   IF        DDSDSN = 'ALL'
     C                   MOVE      'N'           OKSDSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0231'
     C                   ENDIF
      *
      ** Retrieve security shortname details inorder to check investment
      ** type details. Check that the security shortname exists. If
      ** Insert, security must be an active security.
      *
     C     DDSDSN        CHAIN     SECTY                              70
     C                   IF        RecNotFnd = True OR
     C                             (DDACTN = 'I' AND F1RECI <> 'D')
     C                   MOVE      'N'           OKSDSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0444'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate event date. If the event date is blank, it is an
      ** error.
      *
     C                   IF        DDSDED = *BLANKS
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0442'
     C                   ELSE
      *
      ** Convert event date into day number for key.
      *
     C                   IF        DDSDED <> *ALL'9'
 
     C                   TESTN                   DDSDED               01
 
     C                   IF        *IN01 = *OFF
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0315'
     C                   ELSE
 
     C                   EVAL      PADateIn = DDSDED
     C                   EXSR      SrZDATE1
     C                   IF        PErrorFlag = 'Y'
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0315'
     C                   ELSE
     C                   Z-ADD     PDayNoOut     WEvtDNo
     C                   ENDIF
     C                   ENDIF
      *
      ** Event date equal to '999999'.
     C                   ELSE
     C                   Z-ADD     99999         WEvtDNo
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate event type. If the event type is blank, it is
      ** an error.
      *
     C                   IF        DDSDET = *BLANKS
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0443'
     C                   GOTO      EValAct
     C                   ENDIF
      *
      ** Event type - check for allowable entries.
      *
     C                   IF        DDSDET <> 'DV' AND DDSDET <> 'PP'
     C                             AND DDSDET <> 'MP' AND DDSDET <> 'IR'
     C                             AND DDSDET <> 'XR' AND DDSDET <> 'RC'
     C                             AND DDSDET <> 'RP' AND DDSDET <> 'CV'
     C                             AND DDSDET <> 'BI' AND DDSDET <> 'RI'
     C                             AND DDSDET <> 'CR' AND DDSDET <> 'OC'
     C                             AND DDSDET <> 'AL' OR (DDSDET = 'AL'                       CSE065
     C                             AND CSE065 <> 'Y')                                         CSE065
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   IF        CSE065 <> 'Y'                                              CSE065
     C                   EVAL      MsgIdArr(Idx) = 'SEA0320'
      *                                                                                       CSE065
      ** If CSE065 is on, send this error message instead: "The Event Type                    CSE065
      ** must be DV, PP, MP, IR, XR, RC, RP, CV, BI, RI, CR, OC or AL.                        CSE065
     C                   ELSE                                                                 CSE065
     C                   EVAL      MsgIdArr(Idx) = 'SEA0567'                                  CSE065
     C                   ENDIF                                                                CSE065
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
      ** An active Diary Events with a duplicate key must not already
      ** exist.
      *
     C     KSEDEV        CHAIN     SEDEV                              70
     C                   IF        RecNotFnd = False and RECI <> 'C'
     C                   MOVE      'N'           OKSDSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0316'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmd - Routine to validate Action Code 'A'               *
      *                                                               *
      *****************************************************************
 
     C     SRValAmd      BEGSR
      *
      ** Diary Events must exist as live on file
      *
     C     KSEDEV        CHAIN     SEDEV                              70
     C                   IF        RecNotFnd = True OR RECI <> 'D'
     C                   MOVE      'N'           OKSDSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0318'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDel - Routine to validate Action Code 'D'               *
      *                                                               *
      *****************************************************************
 
     C     SRValDel      BEGSR
      *
      ** Diary Events must exist as live on file
      *
     C     KSEDEV        CHAIN     SEDEV                              70
     C                   IF        RecNotFnd = True OR
     C                             (RECI <> 'D' AND RECI <> 'M')
     C                   MOVE      'N'           OKSDSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0318'
     C                   GOTO      EValDel
     C                   ENDIF
      *
      ** If there are any live position settlements for this security
      ** event, output message to screen, and prevent deletion.
      *
     C     SDSN          SETLL     POSETDF
     C     SDSN          READE     POSETDF                                02
     C                   DOW       NOT *IN02
      *                                                                                       260331
     C     SDET          IFEQ      'MP'                                                       260331
     C     SDET          OREQ      'DV'                                                       260331
     C     S01512        ANDNE     'Y'                                                        260331
     C                   Z-ADD     SDPD          WWPDUD            5 0                        260331
     C                   ELSE                                                                 260331
     C                   Z-ADD     SDED          WWPDUD                                       260331
     C                   ENDIF                                                                260331
      *                                                                                       260331
     C**********         IF        F3RECI= 'D' AND SDED = F3PDUD                              260331
     C**********                   AND SDET = F3PEVT                                          260331
     C                   IF        F3RECI = 'D' AND WWPDUD = F3PDUD                           260331
     C                             AND SDET = F3PEVT AND RECI = 'D'                           260331
     C                   MOVE      'N'           OKSDSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0357'
     C                   LEAVE
     C                   ENDIF
     C     SDSN          READE     POSETDF                                02
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
      ** Diary Events must exist on file
      *
     C     KSEDEV        CHAIN     SEDEV                              70
     C                   IF        RecNotFnd = True
     C                   MOVE      'N'           OKSDSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDSN'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0318'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREvtDate - Extra validation for Event Date                  *
      *                                                               *
      *****************************************************************
 
     C     SREvtDate     BEGSR
      *
      ** If Date is Backvalued, check that it does not go past the
      ** Backvalue Period specified on SE ICD.
      *
     C     BJRDNB        SUB       BVBVP         WBKVP
     C                   IF        WEvtDNo < WBKVP
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0331'
     C                   ENDIF
      *
      ** Check that date is not after date of maturity.
      *
     C                   IF        WEvtDNo > F1MATY AND F1MATY <> *ZERO
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0332'
     C                   ELSE
      *
      ** Check event date not holiday in value currency (nominal is
      ** blank). Send warning error.
      *
     C                   IF        DDACTN = 'I'
     C                   IF        F1VLCY <> *BLANKS
     C                   EVAL      PZCcy = F1VLCY
     C                   ELSE
     C                   EVAL      PZCcy = F1NMCY
     C                   ENDIF
 
     C                   Z-ADD     WEvtDNo       PZDayNoIn
     C                   EVAL      PZLoc = *BLANKS
     C                   EXSR      SrZChkH
 
     C                   IF        PZHolInd = 'H'
     C                   MOVE      'W'           OKSDED
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0317'
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSE031
      ** Allow Amendment of an Event type 'IR' which has been actioned                        CSE031
      *                                                                                       CSE031
     C     CSE031        IFEQ      'Y'                                                        CSE031
     C     DDSDET        ANDNE     'IR'                                                       CSE031
     C     CSE031        ORNE      'Y'                                                        CSE031
      *
      ** Check event date not already actioned.
      *
     C                   IF        DDACTN = 'A' AND WEvtDNo < BJRDNB
     C                             AND SDAD <> *ZEROS
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0319'
     C                   ENDIF
      *                                                                                       CSE031
     C                   ENDIF                                                                CSE031
      *
      ** If type 'IR', check event date matches a rate change date on
      ** security detail record - not if a Rate change frequency has been
      ** entered.
      *
     C                   IF        DDSDET = 'IR' AND
     C                             F1RCFQ = *BLANKS
 
     C                   Z-ADD     *ZEROS        WDat
     C                   Z-ADD     1             WIx
 
     C                   Z-ADD     F1CD01        WCD(1)
     C                   Z-ADD     F1CD02        WCD(2)
     C                   Z-ADD     F1CD03        WCD(3)
     C                   Z-ADD     F1CD04        WCD(4)
     C                   Z-ADD     F1CD05        WCD(5)
     C                   Z-ADD     F1CD06        WCD(6)
     C                   Z-ADD     F1CD07        WCD(7)
     C                   Z-ADD     F1CD08        WCD(8)
     C                   Z-ADD     F1CD09        WCD(9)
     C                   Z-ADD     F1CD10        WCD(10)
     C                   Z-ADD     F1CD11        WCD(11)
     C                   Z-ADD     F1CD12        WCD(12)
     C                   EVAL      WCR(01) = F1CR01
     C                   EVAL      WCR(02) = F1CR02
     C                   EVAL      WCR(03) = F1CR03
     C                   EVAL      WCR(04) = F1CR04
     C                   EVAL      WCR(05) = F1CR05
     C                   EVAL      WCR(06) = F1CR06
     C                   EVAL      WCR(07) = F1CR07
     C                   EVAL      WCR(08) = F1CR08
     C                   EVAL      WCR(09) = F1CR09
     C                   EVAL      WCR(10) = F1CR10
     C                   EVAL      WCR(11) = F1CR11
     C                   EVAL      WCR(12) = F1CR12
 
     C                   DO        12            WIx
     C     WCD(WIx)      IFNE      *ZEROS
     C                   IF        BJDFIN = 'M'
     C                   MOVE      WCD(WIx)      WDat(WIx)
     C                   ELSE
     C                   MOVEL     WCD(Wix)      Wk2N
     C                   MOVE      Wk2N          Wk4N
     C                   MOVE      WCD(WIx)      Wk2N
     C                   MOVEL     Wk2N          Wk4N
     C                   MOVE      Wk4N          WDat(WIx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** Find the year for the event.
      *
     C                   Z-ADD     WEvtDNo       PDateIn
     C                   EXSR      SrZDATE2
     C                   MOVE      PDateOut      WIYr
      *
      ** Fetch Maturity date year.
      *
     C                   Z-ADD     F1MATY        PDateIn
     C                   EXSR      SrZDATE2
     C                   MOVE      PDateOut      WMYr
      *
      ** Assemble Event date into compatible format and take date
      ** format M into consideration.
      *
     C                   MOVE      DDSDED        Wk2N
     C                   MOVEL     Wk2N          WEvtDat
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     DDSDED        Wk4N
     C                   ELSE
     C                   MOVE      DDSDED        Wk4N
     C                   MOVEL     DDSDED        Wk2N
     C                   MOVE      Wk2N          Wk4N
     C                   ENDIF
     C                   MOVE      Wk4N          WEvtDat
      *
      ** Only Compare Event date against the change date within the
      ** the event year.
      *
     C                   IF        WMYr < 72
     C     WMYr          ADD       100           WMYrC
     C                   ELSE
     C                   Z-ADD     WMYr          WMYrC
     C                   ENDIF
 
     C                   IF        WIYr < 72
     C     WIYr          ADD       100           WIYrC
     C                   ELSE
     C                   Z-ADD     WIYr          WIYrC
     C                   ENDIF
 
     C                   EVAL      WESC = 'N'
     C                   DOW       WIYrC <= WMYrC AND WESC = 'N'
     C                   Z-ADD     1             WIx
     C                   MOVE      *OFF          *IN34
 
     C                   DO        12            WIx
     C                   IF        WDat(WIx) <> *ZEROS
     C                   MOVEL     WIYr          WDat(WIx)
 
     C                   IF        WEvtDat = WDat(WIx)
     C                   IF        WCR(WIx) = 'R' OR WCR(WIx) = 'C'
     C                   IF        F1RCFQ = *BLANKS
     C                   MOVE      *ON           *IN34
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      WESC = 'Y'
     C                   LEAVE
     C                   ENDIF
      *                                                                                     MD038918
      ** If coupon date is to be adjusted, event date equal to the                          MD038918
      ** adjusted coupon date will also be accepted.                                        MD038918
      *                                                                                     MD038918
     C                   IF        NOT *IN34                                                MD038918
     C                   MOVE      WDat(WIx)     Wk2N                                       MD038918
     C                   MOVEL     WDat(WIx)     Wk4N                                       MD038918
     C                   MOVEL     Wk2N          Wk4N                                       MD038918
     C                   MOVEL     WDat(WIx)     Wk2N                                       MD038918
     C                   MOVEL     Wk4N          PADateIn                                   MD038918
     C                   MOVE      Wk2N          PADateIn                                   MD038918
     C                   EXSR      SRZDate1                                                 MD038918
     C                   Z-ADD     PDayNoOut     PCpd                                       MD038918
     C     F1BCNV        IFNE      ' '                                                      MD038918
     C     F1BCNV        ANDNE     'N'                                                      MD038918
     C     F1BCNV        IFEQ      'C'                                                      MD038918
     C                   MOVE      'N'           NCI               1                        MD038918
     C                   ELSE                                                               MD038918
     C                   MOVE      'L'           NCI               1                        MD038918
     C                   ENDIF                                                              MD038918
     C                   Z-ADD     F1LCPN        WLCPN             5 0                      MD038918
     C                   Z-ADD     0             F1LCPN                                     MD038918
     C                   CALL      'SE0045'                                                 MD038918
     C                   PARM                    F1SITP                                     MD038918
     C                   PARM                    PCpd                                       MD038918
     C                   PARM                    F1ITLD                                     MD038918
     C                   PARM                    F1FCPN                                     MD038918
     C                   PARM                    WCD                                        MD038918
     C                   PARM                    WCR                                        MD038918
     C                   PARM                    F1NMCY                                     MD038918
     C                   PARM                    PCpd                                       MD038918
     C                   PARM                    NCI                                        MD038918
     C                   PARM                    F1BCNV                                     MD038918
     C                   PARM                    F1MATY                                     MD038918
     C                   PARM                    F1LCPN                                     MD038918
     C                   PARM      *BLANKS       HCY1              3                        MD038918
     C                   PARM      *BLANKS       HCY2              3                        MD038918
     C                   PARM      *BLANKS       HCY3              3                        MD038918
     C                   PARM      *BLANKS       HCY4              3                        MD038918
     C                   PARM      *BLANKS       HCY5              3                        MD038918
     C                   PARM      *BLANKS       HCY6              3                        MD038918
     C                   PARM      *BLANKS       HCY7              3                        MD038918
     C                   PARM      *BLANKS       HCY8              3                        MD038918
     C                   PARM      *BLANKS       HCY9              3                        MD038918
     C                   Z-ADD     WLCPN         F1LCPN                                     MD038918
     C                   ENDIF                                                              MD038918
     C     WEvtDNo       IFEQ      PCpd                                                     MD038918
     C                   MOVE      *ON           *IN34                                      MD038918
     C                   EVAL      WESC = 'Y'                                               MD038918
     C                   LEAVE                                                              MD038918
     C                   ENDIF                                                              MD038918
     C                   ENDIF                                                              MD038918
                                                                                            MD038918
 
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        WESC = 'Y'
     C                   ITER
     C                   ENDIF
 
     C                   IF        WIYr = 99
     C                   Z-ADD     0             WIYr
     C                   ADD       1             WIYrC
     C                   ELSE
     C                   ADD       1             WIYr
     C                   ADD       1             WIYrC
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        NOT *IN34
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0333'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If Event type 'IR', validate Input and Amend modes.
      *
     C                   IF        DDSDET = 'IR'
 
     C                   IF        (DDACTN = 'I' OR DDACTN = 'A')
     C                             AND WEvtDNo < BJRDNB
      *
      ** Check no Trades input on this security that have value date
      ** greater than or equal to the event date.
      *
     C     DDSDSN        SETLL     TRADSDF
     C     DDSDSN        READE     TRADSDF                                01
      *
     C                   DOW       *IN01 = *OFF AND OKSDED = 'Y'
     C                   IF        F2TDVD >= WEvtDNo
     C                   MOVE      'W'           OKSDED
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0334'
     C                   ELSE
     C     DDSDSN        READE     TRADSDF                                01
     C                   ENDIF
     C                   ENDDO
      *
      ** Check this event not before last 'IR' event.
      *
     C                   EVAL      WSEDE = SEDEFmt
     C     DDSDSN        SETGT     SEDEVDF
     C                   READP     SEDEVDF                                01
      *
     C                   DOW       NOT *IN01
      *
      ** Check record is not a cancelled record.
     C                   IF        RECI <> 'C'
      *
      ** Check same Security.
     C                   IF        DDSDSN = SDSN
      *
      ** Check same Event type.
     C                   IF        SDET = 'IR'
     C                   IF        WEvtDNo < SDED
     C                   MOVE      'W'           OKSDED
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0335'
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
      ** Exit loop if securities are not the same.
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READP     SEDEVDF                                01
     C                   ENDDO
 
     C                   EVAL      SEDEFmt = WSEDE
 
     C                   ENDIF
      *
      ** If Rate change frequency is 'W', Check if date not equal to or a
      ** multiple of 7 days after Next change date (or multiple of 7
      ** days before NCD if date < run date).
      *
     C                   IF        F1RCFQ = 'W' AND WEvtDNo <> F1NCHD
      *
     C                   IF        WEvtDNo > BJRDNB
      *
     C                   IF        WEvtDNo < F1NCHD
     C                   MOVE      'W'           OKSDED
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0336'
     C                   ENDIF
 
     C     WEvtDNo       SUB       F1NCHD        Work5N
     C     Work5N        DIV       7             Work5N
     C                   MVR                     Work1N               01
     C*
     C                   IF        *IN01
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0337'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WEvtDNo > F1NCHD
     C                   MOVE      'W'           OKSDED
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0336'
     C                   ENDIF
      *
     C     WEvtDNo       SUB       F1NCHD        Work5N
     C     Work5N        DIV       7             Work5N
     C                   MVR                     Work1N               01
 
     C                   IF        *IN01
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0337'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
      ** If Rate change frequency is 'F', Check if date not equal to or a
      ** multiple of 14 days after Next change date
      *
     C                   IF        F1RCFQ = 'F' AND WEvtDNo <> F1NCHD
      *
     C                   IF        WEvtDNo > BJRDNB
      *
     C                   IF        WEvtDNo < F1NCHD
     C                   MOVE      'W'           OKSDED
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0338'
     C                   ENDIF
      *
     C     WEvtDNo       SUB       F1NCHD        Work5N
     C     Work5N        DIV       14            Work5N
     C                   MVR                     Work2N               01
 
     C                   IF        *IN01
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0339'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WEvtDNo > F1NCHD
     C                   MOVE      'W'           OKSDED
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSDED'
     C                   EVAL      WMsgIdArr(WIdx) = 'SEA0338'
     C                   ENDIF
 
     C     WEvtDNo       SUB       F1NCHD        Work5N
     C     Work5N        DIV       14            Work5N
     C                   MVR                     Work2N               01
 
     C                   IF        *IN01
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0339'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If Rate change frequency is 'M', Check if date is not the same day
      ** of the month as the Next change date.
      *
     C                   IF        F1RCFQ = 'M' AND WEvtDNo <> F1NCHD
 
     C                   Z-ADD     WEvtDNo       PDateIn
     C                   EXSR      SrZDATE2
     C                   MOVE      PDateOut      WEYear
     C                   MOVEL     PDateOut      WNum4
     C                   IF        BJDFIN = 'M'
     C                   MOVEL     PDateOut      WEMth
     C                   MOVE      WNum4         WEDay
     C                   ELSE
     C                   MOVEL     PDateOut      WEDay
     C                   MOVE      WNum4         WEMth
     C                   ENDIF
 
     C                   Z-ADD     F1NCHD        PDateIn
     C                   EXSR      SrZDATE2
     C                   MOVE      PDateOut      WZYear
     C                   MOVEL     PDateOut      WNum4
     C                   IF        BJDFIN = 'M'
     C                   MOVEL     PDateOut      WZMth
     C                   MOVE      WNum4         WZDay
     C                   ELSE
     C                   MOVEL     PDateOut      WZDay
     C                   MOVE      WNum4         WZMth
     C                   ENDIF
      *
      ** Check if Event Day is allowed to differ from the Next
      ** Change Day.
      *
     C                   EXSR      SRNchDay
 
     C                   ENDIF
     C                   ENDIF
      *
      ** If Event type 'PP', validate Input and Amend modes.
      *
     C                   IF        DDSDET = 'PP' AND WEvtDNo < BJRDNB
     C                             AND (DDACTN = 'I' OR DDACTN = 'A')
      *
      ** Check no Trades input on this security that have value date
      ** greater than or equal to the event date.
      *
     C     DDSDSN        SETLL     TRADSDF
     C     DDSDSN        READE     TRADSDF                                01
      *
     C                   DOW       NOT *IN01 AND OKSDED = 'Y'
      *
     C                   IF        F2TDVD >= WEvtDNo
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0341'
     C                   ELSE
     C     DDSDSN        READE     TRADSDF                                01
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Check this event not before last 'PP' event.
      *
     C                   EVAL      WSEDE = SEDEFmt
     C     DDSDSN        SETGT     SEDEVDF
     C                   READP     SEDEVDF                                01
      *
     C                   DOW       NOT *IN01
      *
      ** Check record is not a cancelled record.
     C                   IF        RECI <> 'C'
      *
      ** Check same security.
     C                   IF        DDSDSN = SDSN
      *
      ** Check same event type.
     C                   IF        SDET = 'PP'
     C                   IF        WEvtDNo < SDED
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0342'
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
      ** Exit loop if security are not the same.
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READP     SEDEVDF                                01
     C                   ENDDO
 
     C                   EVAL      SEDEFmt = WSEDE
 
     C                   ENDIF
      *
      ** Event date cannot be before run date for following codes.
      *
     C                   IF        DDSDET = 'RC' OR DDSDET = 'RP'
     C                             OR DDSDET = 'CV' OR DDSDET = 'BI'
     C                             OR DDSDET = 'RI' OR DDSDET = 'CR'
     C                             OR DDSDET = 'OC'
 
     C                   IF        (DDACTN = 'I' OR DDACTN = 'A')
     C                             AND WEvtDNo < BJRDNB
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0330'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNchDay - Check if Next Change Day is allowed to differ     *
      *             to Event Day                                      *
      *                                                               *
      *****************************************************************
     C     SRNchDay      BEGSR
      *
      ** The Event Day is only allowed to differ from the Next Change
      ** Day for one of two reasons:-
      ** 1 - The day prior to the Event Day is a holiday or
      ** 2 - The two days are the last days of their respective months.
      *
     C                   IF        WEDay <> WZDay
      *
      ** Check if day prior to the Event Day is a holiday.
      *
     C     WEvtDNo       SUB       1             PZDayNoIn
     C                   IF        F1VLCY <> *BLANKS
     C                   EVAL      PZCcy = F1VLCY
     C                   ELSE
     C                   EVAL      PZCcy = F1NMCY
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
     C                   EXSR      SrZChkH
      *
      ** If it wasn't a holiday, check to see if the two days are at the
      **  ends of their months.
     C                   IF        PZHolInd <> 'H'
 
     C     WZMth         LOOKUP    TABMTH        TABDAY                   01
 
     C     WZDay         IFNE      TABDAY
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0340'
     C                   ELSE
 
     C     WEMth         LOOKUP    TABMTH        TABDAY                   01
     C                   Z-ADD     TABDAY        WEOMDay
 
     C                   IF        WEMth = 2
     C     WEYear        DIV       4             Work2N
     C                   MVR                     Work1N                   01
     C                   IF        *IN01
     C                   ADD       1             WEOMDay
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WEDay <> WEOMDay
     C                   MOVE      'N'           OKSDED
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDED'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0340'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREvtType - Routine to further validate event type.          *
      *                                                               *
      *****************************************************************
 
     C     SREvtType     BEGSR
      *
      ** Access investment type details via access object.
      *
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    F1SITP
     C                   PARM                    F1NMCY
     C     PInvtpd       PARM      PInvtpd       DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C                   CLEAR                   PInvtpd
     C                   ENDIF
      *
      ** If entry 'DV', check Investment type is a share (D1PROT '4').
      *
     C                   IF        DDSDET = 'DV' AND D1PROT <> '4'
     C                             AND D1PROT <> '7'                                    210122
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0321'
     C                   ENDIF
      *
      ** Entry 'PP' but Security is not partly-paid.
      *
     C                   IF        DDSDET = 'PP' AND F1PPDI <> 'Y'
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0322'
     C                   ENDIF
      *
      ** Entry 'PP' but Security is not complete.
      *
     C                   IF        DDSDET = 'PP' AND F1INCS <> 'C'
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0329'
     C                   ENDIF
      *
      ** If entry 'MP', check Investment type is Mortgage backed
      ** Mortgage backed (D1PROT '8').
      *
     C                   IF        DDSDET = 'MP' AND D1PROT <> '8'
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0323'
     C                   ENDIF
      *
      ** If entry 'IR', check Investment type is either a Floating Rate
      ** Note (D1PROT '3'), a Yen Bond (D1PROT '5') or a Mortgage Backed
      ** Security (D1PROT '8').
      *
     C                   IF        DDSDET = 'IR' AND D1PROT <> '3'
     C                             AND D1PROT <> '5' AND D1PROT <> '8'
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0324'
     C                   ENDIF
      *
      ** If entry 'XR', check for Multi-currency or Value currency.
      *
     C                   IF        DDSDET = 'XR' AND F1MLTI <> 'Y'
     C                             AND S01509 = 'N'
     C                   IF        F1VLCY = *BLANKS OR F1VLCY = F1NMCY
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0325'
     C                   ENDIF
     C                   ENDIF
      *
      ** If entry 'RC', check for Early Repayment indicator.
      *
     C                   IF        DDSDET = 'RC' AND F1ERPY <> 'Y'
     C                             AND WEvtDNo <> F1MATY
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0326'
     C                   ENDIF
      *
      ** If entry 'RP', check for Early Repayment indicator.
      *
     C                   IF        DDSDET = 'RP' AND F1ERPY <> 'Y'
     C                             AND WEvtDNo <> F1MATY
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0327'
     C                   ENDIF
      *
      ** If entry 'CV', check for Convertible indicator.
      *
     C                   IF        DDSDET = 'CV' AND D1CNVI <> 'Y'
     C                   MOVE      'N'           OKSDET
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'
     C                   EVAL      MsgIdArr(Idx) = 'SEA0328'
     C                   ENDIF
                                                                                              CSE065
      ** If CSE065 is installed and entry is 'AL',                                            CSE065
      ** validate processing type.                                                            CSE065
                                                                                              CSE065
     C                   IF        DDSDET = 'AL' AND D1PROT <> '1' AND                        CSE065
     C                             D1PROT <> '3' AND D1PROT <> '5' AND                        CSE065
     C                             D1PROT <> '6' AND D1PROT <> '8' AND                        CSE065
     C                             D1PROT <> '9' AND CSE065 = 'Y'                             CSE065
     C                   MOVE      'N'           OKSDET                                       CSE065
     C                   ADD       1             Idx                                          CSE065
     C                   EVAL      FldNameArr(Idx) = 'DDSDET'                                 CSE065
     C                   EVAL      MsgIdArr(Idx) = 'SEA0560'                                  CSE065
     C                   ENDIF                                                                CSE065
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SRZDate1      BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PADateIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
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
      *  SRZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
      *                                                               *
      *****************************************************************
     C     SRZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZChkH - Check if date is a holiday in specified currency   *
      *                                                               *
      *****************************************************************
     C     SRZChkH       BEGSR
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDayNoIn
     C                   PARM                    PZCcy
     C                   PARM                    PZLoc
     C                   PARM      *BLANK        PZHolInd
 
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
     C                   PARM                    PResponse
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction Id
     C                   PARM                    FOTRID
      *
      ** Security Shortname
     C                   PARM                    DDSDSN
      *
      ** Event Date
     C                   PARM                    DDSDED
      *
      ** Event Type
     C                   PARM                    DDSDET
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
      ** SDBANK - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transaction Enhancement
     C                   PARM                    CSE010
      *
      ** value Ccy to be Ccy of Issuer Payment
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031            1                          CSE031
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CSE065
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
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Security Shortname
     C                   PARM                    OKSDSN
      *
      ** OK Event Date
     C                   PARM                    OKSDED
      *
      ** OK Event Type
     C                   PARM                    OKSDET
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Security Details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM      D1PROT        PPROT
      *
      ** Event Date in numeric format.
     C                   PARM      WEvtDNo       PEvtDno
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Key fields for LF/SEDEV
     C     KSEDEV        KLIST
     C                   KFLD                    DDSDSN
     C                   KFLD                    WEvtDNo
     C                   KFLD                    DDSDET
      *                                                                                       260331
      ** Check if S01512 is installed                                                         260331
      *                                                                                       260331
     C                   CALL      'AOSARDR0'                                                 260331
     C                   PARM      *BLANKS       @RTCD             7                          260331
     C                   PARM      '*VERIFY'     @OPTN             7                          260331
     C                   PARM      'S01512'      @SARD             6                          260331
      *                                                                                       260331
     C                   IF        @RTCD = *BLANKS                                            260331
     C                   MOVE      'Y'           S01512            1                          260331
     C                   ELSE                                                                 260331
     C                   MOVE      'N'           S01512                                       260331
     C                   ENDIF                                                                260331
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
(c) Misys International Banking Systems Ltd. 2001
**   TABMTH/TABDAY     Month No/No of days in month
013102280331043005310630073108310930103111301231
