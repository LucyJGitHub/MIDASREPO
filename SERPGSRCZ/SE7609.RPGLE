     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Flag Pos. Setl'mt for MG0565 regeneration')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7609 - Flag Position Settlements for MG0565 to be          *
      *             re-generated at COB.                              *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user selection input of Re-Generation of      *
      *             MG0565 message.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187435             Date 07Dec00               *
      *                 185571  *CREATE    Date 26Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  187435 - Title on the screen incorrect.                      *
      *  185571 - Unable to re-generate MG0565 message                *
      *           (CSE023 - Treaty Withholding Tax)                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Allocations per dividend payment summary report display file
     FSE7609DF  CF   E             WORKSTN
 
      ** Securities details
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Security Events - by Security, Event Type and date
     FSECEO     IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  10-12     Field Error - highlight screen fields              *
      *  13        F10 Confirm enabled                                *
      *  25        Subfile control                                    *
      *  25        Subfile end                                        *
      *  90-99     Used by standard subroutine                        *
      *  KC        F3 pressed = Exit                                  *
      *  KJ        F10 pressed = Confirm                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
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
 
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DATA STRUCTURE FOR USER DETAILS
     D D@USER        E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(Ur_)
 
      ** Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Security Customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
 
     D @PDUD           S              5P 0
     D*@PCPY****       S              6P 0                                                    CSD027
     D @PCPY           S              6A                                                      CSD027
     D WScrn           S              1A
     D WDdte           S              5P 0
     D WEvtp           S              2A
     D EEvtp           S                   LIKE(SDET)
     D EDdte           S                   LIKE(SDED)
 
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A
 
      ** Parameters for ZDATE1
     D PDate           S              6A
     D PDaynoOut       S              5P 0
     D ErrorFlag       S              1A
 
      ** Parameters for module AOBANKR0
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
 
      ** Initialise.
 
     C                   CLEAR                   SSECU
     C                   CLEAR                   SDDTE
     C                   CLEAR                   SEVTP
     C                   CLEAR                   SDEPT
 
      ** Process inputs.
 
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
 
     C                   EXSR      SRClrMsgQ
 
      ** Do while SCREEN : Read details.
 
     C                   DOW       WScrn = 'P'
 
     C                   EXSR      SRDisp
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRVal
 
     C                   IF        WScrn = 'S'
 
     C                   EVAL      @PBCA = Ur_DBRN
     C                   EVAL      @PSSH = SSECU
     C                   EVAL      @PDUD = PDaynoOut
     C                   EVAL      @PEVT = SEVTP
     C                   IF        @PEVT = 'MA'
     C                   EVAL      @PEVT = 'MT'
     C                   ENDIF
 
     C                   CALL      'SE1878'
     C                   PARM                    @PBCA             3
     C                   PARM                    @PSSH            10
     C                   PARM                    @PDUD
     C                   PARM                    @PEVT             2
     C                   PARM                    @PCPY
     C                   PARM                    @PREF             6
     C                   PARM                    @PSEQ             3 0
 
     C                   EVAL      WScrn = 'P'
     C                   CLEAR                   SSECU
     C                   CLEAR                   SDDTE
     C                   CLEAR                   SEVTP
     C                   CLEAR                   SDEPT
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Terminate program.
 
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      ** Return.
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrMsgQ - Initialise variables                             *
      *                                                               *
      *****************************************************************
     C     SRClrMsgQ     BEGSR
 
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
 
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validate details                                     *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR
 
      ** Validate details entered.
 
     C                   EXSR      SRValSEcu
     C                   EXSR      SRValDDte
     C                   EXSR      SRValEVtp
     C                   EXSR      SRValDept
 
      ** If no errors, chain to LF/SECEO to see if a record exist for this  .
 
     C                   IF        ((*IN10 = *OFF) AND  (*IN11 = *OFF) AND
     C                             (*IN12 = *OFF)) AND  (*IN14 = *OFF)
 
     C     WKey1         CHAIN     SECEO                              01
 
     C                   IF        *IN01
 
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN11 = *ON
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'SEA0434'
     C                   EXSR      SRSndM
 
     C                   ELSE
     C                   EVAL      WScrn = 'S'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send Message to Screen                              *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
 
      ** Call screen message handler.
 
     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    PMsgF
     C                   PARM                    PMsgId
     C                   PARM                    PMsgD
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisp - Display screen                                      *
      *                                                               *
      *****************************************************************
     C     SRDisp        BEGSR
 
      ** Write message subfile, details and footer screens.
 
     C                   EVAL      *IN13 = *OFF
     C                   TIME                    STIME
     C                   WRITE     SE7609C1
     C**********         WRITE     SE7609F0                                                 AR656294
     C                   WRITE     SE7609F1
     C                   WRITE     SE7609F0                                                 AR656294
 
      ** Read details screen.
 
     C                   READ      SE7609F0                               01
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off.
 
     C                   MOVEA     '000'         *IN(10)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValSEcu - Validate Security                                *
      *                                                               *
      *****************************************************************
     C     SRValSEcu     BEGSR
 
      ** Must reference an active record on SECTY
 
     C     SSECU         CHAIN     SECTYDF                            01
 
     C                   IF        ((*IN01 = *ON) OR  (*IN01 = *OFF)
     C                             AND  (RECI <> 'D'))  OR
     C                             CRTT = *BLANK
     C                   EVAL      *IN10 = *ON
     C                   EVAL      PMsgId = 'SEA0436'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDDte - Validate To Date field                           *
      *                                                               *
      *****************************************************************
     C     SRValDDte     BEGSR
 
      ** Must be numeric.
 
     C                   TESTN                   SDDTE                01
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SEA0437'
     C                   EXSR      SRSndM
     C                   GOTO      EValDdte
     C                   ENDIF
 
      ** Must be a valid date.
 
     C                   MOVE      *BLANKS       PDate
     C                   MOVE      SDDTE         PDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SEA0438'
     C                   EXSR      SRSndM
     C                   GOTO      EValDdte
     C                   ENDIF
 
      ** Must be greater than rundate
 
     C                   IF        PDaynoOut < BJRDNB
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'SEA0439'
     C                   EXSR      SRSndM
     C                   GOTO      EValDdte
     C                   ENDIF
 
     C                   EVAL      WDdte = PDaynoOut
     C                   EVAL      EDdte = WDdte
 
     C     EValDdte      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEVtp - Validate Country of Tax Treaty                   *
      *                                                               *
      *****************************************************************
     C     SRValEVtp     BEGSR
 
      ** If entered, event type must only be CP , DV or MA.
 
     C                   IF        ((SEVTP = *BLANKS) OR
     C                             (SEVTP <> 'CP') AND
     C                             (SEVTP <> 'DV') AND
     C                             (SEVTP <> 'MA'))
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'SEA0440'
     C                   EXSR      SRSndM
 
     C                   ELSE
 
     C                   IF        SEVTP = 'MA'
     C                   EVAL      WEvtp = 'MT'
     C                   EVAL      EEvtp = 'MG'
     C                   ELSE
     C                   EVAL      WEvtp = SEVTP
     C                   EVAL      EEvtp = SEVTP
     C                   IF        SEVTP = 'CP'
     C                   EVAL      EEvtp = 'CG'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDept - Validate Depot                                   *
      *                                                               *
      *****************************************************************
     C     SRValDept     BEGSR
 
      ** If entered, check for valid customer
 
     C                   MOVE      '0'           *IN14
 
     C                   IF        SDEPT <> *BLANK
     C
      * If '?' entered, display securities customers
 
     C     SDEPT         IFEQ      '?'
     C                   MOVEL     *BLANK        SDEPT
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD                                         S0111
     C                   PARM      '*KEY   '     @OPTN                                         S0111
     C                   PARM      '?      '     @SCKY                                         S0111
     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BFCUST        SDEPT
     C                   END
     C                   END
      *
      ** Client Number/Name
      * If entered, must be a valid shortname or number on SDCUSTPD
 
     C     SDEPT         IFNE      *BLANKS
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SDEPT         @KEY1            10                           S0111
     C                   PARM                    @KYST             7                           S0111
     C     SDCUST        PARM      SDCUST        DSSDY                          O:Format
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '1'           *IN14
     C                   EVAL      PMsgId = 'MMA0116'
     C                   EXSR      SRSndM
     C                   ELSE
      *
      ** .. and must be a valid client number on SDSECSPD
      *
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD                                         S0111
     C                   PARM      '*KEY   '     @OPTN                                         S0111
     C                   PARM      BBCUST        @SCKY             6                           S0111
     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '1'           *IN14
     C                   EVAL      PMsgId = 'MMA0116'
     C                   EXSR      SRSndM
     C                   ELSE
 
      ** Must be a valid classification
 
     C     BFCLAS        IFEQ      'I'
     C     BFCLAS        OREQ      'S'
     C     BFCLAS        OREQ      'D'
     C                   MOVE      '1'           *IN14
     C                   EVAL      PMsgId = 'MMA0116'
     C                   EXSR      SRSndM
     C                   ELSE
 
     C**********         MOVE      BFCUST        @CNUM             6 0                        CSD027
     C                   MOVE      BFCUST        @CNUM             6                          CSD027
     C                   EVAL      @PCPY = @CNUM
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If Depot is not enter
      *
     C                   ELSE
     C**********         EVAL      @PCPY = 0                                                  CSD027
     C                   EVAL      @PCPY = *BLANKS                                            CSD027
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
 
      ** Access bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key fields for SECEO
     C     WKey1         KLIST
     C                   KFLD                    SSECU
     C                   KFLD                    EEvtp
     C                   KFLD                    EDdte
 
     C                   EVAL      WScrn = 'P'
 
     C                   EVAL      PMsgf = 'GBSEUSRMSG'
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
 
     C                   CALL      'AOUSERR0'
     C                   PARM                    WUAPRC            7            B:Return Cde
     C                   PARM      '*KEY'        UUAPOP            7            I:Option
     C                   PARM      PSUser        UUUSID           10            I:User Profile
     C     D@USER        PARM      D@USER        DSSDY                          O:MUSER fmt
 
      ** Message subfile control and program queue initialisation.
 
     C                   EVAL      *IN25 = *ON
     C                   EVAL      SPGM = '*'
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
