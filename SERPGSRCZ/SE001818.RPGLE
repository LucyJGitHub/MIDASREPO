     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trades auth extension maintenance')           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE001818 - Trades Input Details - Extension File for MT5xx   *
      *                                                               *
      *  Function:  This module is a replacement for SE1818.          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 222373             Date 23Oct03               *
      *                 213044             Date 09Dec02               *
      *                 CSD015             Date 15Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 18Apr02               *
      *                 201429             Date 15Jan02               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  222373 - Parameter Mismatch                                  *
      *  213044 - DBerr on AOBRCHR0 if F12 press on third scr of AURE.*
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSE028 - Standing Settlement Instructions Enhancement        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File (No record found)                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     - Initial Processing                              *
      *  SRRetry    - Execute specific routine depending on action    *
      *  SRReturn   - Return to calling program                       *
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
 
     FTRADSDY1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** SE Trades MT5xx DS Template
     D PData         E DS                  EXTNAME(SE50DT)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Securities Details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** New Trade in screen format - Primay Details
     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
 
      ** New Trade in screen Format - Secondary Details
     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
 
      ** New Trade in Screen Format - Settlement Details
     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
     D  DDCLTY_S     E                     EXTFLD(DDCLTY)
 
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
 
     D NewTrExts     E DS                  EXTNAME(SETESDPD)                                  222373
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 222373
      ** Error Indicators
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
     D OKTrExts      E DS                  EXTNAME(SEETESPD)                                  222373
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS For Accentt programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
     D PMCWL           DS          9999                                                       CSD015
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D PCommand        S              2A
     D PError          S              1A
     D PPUYAT          S              1A                                                      CSE034
     D PT1NEW          S                   LIKE(T1NEW)                                        CSE034
     D PDftFlag        S              1A                                                      CSE034
 
     D Screen          S              1A
 
     D WWCLTY          S              2A
     D WWRTCD          S              1A
     D WWRANG          S              1A
     D WWSENT          S              5A
     D WWNML           S             11P 0
 
     D OVER1           S              1A
     D OVER2           S              1A
     D SDATE           S              7A
 
     D Idx             S              3P 0
 
     D A_DDROUS        S              6A
     D A_DDROTS        S             12A
     D A_DDROUC        S              6A
     D A_DDROTC        S             12A
 
     D DDSRPN          S             20
 
     D @INKC           S              1A
     D @INKE           S              1A
     D @INKL           S              1A
     D @INKN           S              1A
 
     D Key001          S                   LIKE(T1TDRF) INZ(*Blanks)
 
     D W1TDRF          S                   LIKE(T1TDRF) INZ(*Blanks)
     D W1GMES          S                   LIKE(T1GMES) INZ(*Blanks)
     D W1INST          S                   LIKE(T1INST) INZ(*Blanks)
     D W1INSS          S                   LIKE(T1INSS) INZ(*Blanks)
     D W1EUCL          S                   LIKE(T1EUCL) INZ(*Blanks)
     D W1SAFA          S                   LIKE(T1SAFA) INZ(*Blanks)
     D W1RPTY          S                   LIKE(T1RPTY) INZ(*Blanks)
     D W1GMEC          S                   LIKE(T1GMEC) INZ(*Blanks)
     D W1FID1          S                   LIKE(T1FID1) INZ(*Blanks)
     D W1CCID          S                   LIKE(T1CCID) INZ(*Blanks)
     D W1TRTT          S                   LIKE(T1TRTT) INZ(*Blanks)
     D W1GDEL          S                   LIKE(T1GDEL) INZ(*Blanks)
     D W1FCOD          S                   LIKE(T1FCOD) INZ(*Blanks)
     D W1FTID          S                   LIKE(T1FTID) INZ(*Blanks)
     D W1SROL          S                   LIKE(T1SROL) INZ(*Blanks)
     D W1SNEW          S                   LIKE(T1NEW)  INZ(*Blanks)
     D W1STMP          S                   LIKE(T1STMP) INZ(*Blanks)
     D W1CHID          S                   LIKE(T1CHID) INZ(*Blanks)
     D W1TRRM          S                   LIKE(T1TRRM) INZ(*Blanks)
 
     D PCALL           S              3A                                                      222373
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
 
      ** Initialisation routine
 
     C                   EXSR      SRINIT
 
      ** Execute specific routine depending on action
 
     C                   EXSR      SRRetry
 
      ** Execute routine to setup return code and exit program
 
     C                   EXSR      SRReturn
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Routine to Handle Initial Processing                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Setup keys values using transaction data passed from caller
 
     C                   MOVEL     PTDRF         Key001
 
      ** Initialise error indicators
 
     C                   EVAL      *IN75 = *OFF
 
      ** Initialize Non-screen fields
 
     C                   Z-ADD     *ZEROS        T1LSWS
     C                   Z-ADD     *ZEROS        T1LSSC
     C                   EVAL      T1CONG = 'N'
     C                   EVAL      T1RCDG = 'N'
 
      ** Initialize Clearance type (1 to 4 is MT580 for Settlements)
 
     C                   IF        PCLTY = '1' or PCLTY = '2' or
     C                             PCLTY = '3' or PCLTY = '4'
     C                   EVAL      WWCLTY = '14'
     C                   ENDIF
 
      ** Set up non-input capable screen fields
 
     C                   EVAL      DDACTN = PACTN
     C                   EVAL      DDTDRF = PTDRF
     C                   EVAL      DDBLKR = PBLKR
     C                   EVAL      DDSESN = PSESN
     C                   EVAL      DDSRPN = PSRPN
     C                   EVAL      DDSRNME = PSRPN                                            CAP067
                                                                                              213044
     ** If Branch is blank, get branch field from PDATA                                       213044
                                                                                              213044
     C                   IF        DDBRCD = *Blanks                                           213044
     C                   EVAL      DDBRCD = PTDBR                                             213044
     C                   ENDIF                                                                213044
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetry - Routine to Handle 'Re-entry' Action                 *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     SRRetry       BEGSR
 
      ** Check whether record exists
 
     C     Key001        CHAIN     TRADSDY1                           01
 
      ** If record not found then setup message, protect fields for
      ** display, display screen and handle database error.
 
     C                   IF         *IN01 = *ON
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDArr(Idx) = 'SEW9999'
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      DDACTN = 'E'
     C                   EVAL      PDftFlag = 'N'                                             CSE034
     C                   EVAL      PPUYAT = 'N'                                               CSE034
 
     C                   EXSR      SRScreen
 
     C                   EVAL      DBFILE = 'TRADSDX1'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = Key001
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Handle screens until F3, F5, F12 or F14 taken or no errors
 
     C                   DOU       *IN75 = *OFF or *INKC = *ON or
     C                             *INKE = *ON or *INKL = *ON or
     C                             *INKN = *ON
 
     C                   EVAL      DDACTN = 'I'
     C                   EVAL      PDftFlag = 'Y'                                             CSE034
     C                   EVAL      PPUYAT = 'Y'                                               CSE034
 
     C                   EXSR      SRScreen
 
      ** If F3, F5, F12 and F14 NOT taken then continue
      ** (else repeat 'do until' loop).
 
     C                   IF        *INKC = *OFF and *INKE = *OFF and
     C                             *INKL = *OFF and *INKN = *OFF
 
      ** Clear messages for redisplay
 
     C                   CALL      'ZA0250'
 
     C                   EXSR      SRStow
     C                   EXSR      SRComp
 
      ** If no errors on validation/comparison
 
     C                   IF        *IN75 = *OFF
 
     C                   EXSR      SRPoss
 
      ** if F3 taken in SE1819 (trade amendment lost) return to menu;
 
     C                   SELECT
 
     C                   WHEN       PCommand = '03'
     C                   EVAL       *INKC = *ON
 
     C                   WHEN       PCommand = '05'
     C                   EVAL       *INKE = *ON
 
     C                   WHEN       PCommand = '12'
     C                   EVAL       *INKL = *ON
 
     C                   EXSR      SRScreen
 
     C                   CALL      'ZA0250'
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Reset override indicators
 
     C                   EVAL      OVER1 = *BLANK
     C                   EVAL      OVER2 = *BLANK
 
      ** If Trade sale and non-fungible and Deliver from is Cedel and
      ** F3, F5 and F12 not taken then call certificate numbers program
 
     C                   IF        PTDTP = 'TS' and DDFTID = 'N' and
     C                             PDELF = PDC02 and *INKC = *OFF and
     C                             *INKE = *OFF and *INKL = *OFF and
     C                             *INKN = *OFF
 
     C                   Z-ADD     PNOML         WWNML
 
     C                   CALL      'SE1852'
     C                   PARM                    PSESN
     C                   PARM                    WWNML
     C                   PARM                    PTDRF
     C                   PARM                    PACTN
     C                   PARM                    WWRTCD
     C                   PARM      'R'           WWRANG
 
      ** If error returned from SE1852 then produce error message
 
     C                   IF        WWRTCD = '2'
     C                   EVAL      *IN75 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDArr(Idx) = 'SEW5852'
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      DDACTN = 'E'
     C                   EVAL      PDftFlag = 'N'                                             CSE034
     C                   EVAL      PPUYAT = 'N'                                               CSE034
     C                   EXSR      SRScreen
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScreen - Process Extension (SWIFT) Screen                   *
      *                                                               *
      *  Called by:  Main Processing                                  *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     SRScreen      BEGSR
 
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
 
     C                   PARM                    PTCNR
     C                   PARM                    PTNMC
     C                   PARM                    PNOML
     C                   PARM                    PTDVD
     C                   PARM                    PDELF
     C                   PARM                    PDELT
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM      'Y'           PUYAT             1                          201429
      *                                                                                       201429
      ** ISO15022 indicator - file field                                                      201429
     C                   PARM                    T1NEW                                        201429
                                                                                              CSE034
      ** Default SSI flag                                                                     CSE034
                                                                                              CSE034
     C                   PARM                    PDftFlag                                     CSE034
 
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
 
     C**********         PARM                    DDSRPN                                       CAP067
     C                   PARM                    DDSRNME          41                          CAP067
      * Swift 2001 flag                                                                       CAP067
     C                   PARM                    CSW201            1                          CAP067
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
                                                                                              CSD015
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
 
     C                   EVAL      Idx = 0
 
      ** F3 - End Program
 
     C                   IF        @INKC = *ON
     C                   EVAL      *INKC = *ON
     C                   ENDIF
 
      ** F5 - Go To Initial Screen
 
     C                   IF        @INKE = *ON
     C                   EVAL      *INKE = *ON
     C                   ENDIF
 
      ** F12 - Cancel on Extension Screen
 
     C                   IF        @INKL = *ON
     C                   EVAL      *INKL = *ON
     C                   ENDIF
 
      * F14 - Return from F14 Ext. Settlements
 
     C                   IF        @INKN = *ON
     C                   EVAL      *INKN = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRStow - Routine to Move Screen Fields to File Fields         *
      *                                                               *
      *  Called by: SRRetry - Routine to Handle 'Re-entry' Action     *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     SRStow        BEGSR
 
      ** Move key fields to file fields
 
     C                   EVAL      W1TDRF =  KEY001
 
     C                   EVAL      W1GMES = DDGMES
     C                   EVAL      W1INST = DDINST
     C                   EVAL      W1INSS = DDINSS
     C                   EVAL      W1EUCL = DDEUCL
     C                   EVAL      W1SAFA = DDSAFA
     C                   EVAL      W1RPTY = DDRPTY
     C                   EVAL      W1GMEC = DDGMEC
     C                   EVAL      W1FID1 = DDFID1
     C                   EVAL      W1CCID = DDCCID
     C                   EVAL      W1TRTT = DDTRTT
     C                   EVAL      W1GDEL = DDGDEL
     C                   EVAL      W1FCOD = DDFCOD
     C                   EVAL      W1FTID = DDFTID
     C                   EVAL      W1SROL = DDSROL
     C                   EVAL      W1SNEW = DDSNEW
     C                   EVAL      W1STMP = DDSTMP
     C                   EVAL      W1CHID = DDCHID
     C                   EVAL      W1TRRM = DDTRRM
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRComp - Routine to Compare Screen Fields with File Fields    *
      *                                                               *
      *  Called by: SRRetry - Routine to Handle 'Re-entry' Action     *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     SRComp        BEGSR
 
     C                   IF        W1TDRF = T1TDRF and W1GMES = T1GMES and
     C                             W1INST = T1INST and W1INSS = T1INSS and
     C                             W1EUCL = T1EUCL and W1SAFA = T1SAFA and
     C                             W1RPTY = T1RPTY and W1FID1 = T1FID1 and
     C                             W1CCID = T1CCID and W1TRTT = T1TRTT and
     C                             W1GDEL = T1GDEL and W1FCOD = T1FCOD and
     C                             W1FTID = T1FTID and W1SROL = T1SROL and
     C                             W1GMEC = T1GMEC and W1SNEW = T1NEW and
     C                             W1STMP = T1STMP and W1CHID = T1CHID and
     C                             W1TRRM = T1TRRM
 
     C                   EVAL      *IN75 = *OFF
 
     C                   ELSE
 
     C                   EVAL      *IN75 = *ON
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIDArr(Idx) = 'SEW7007'
     C                   EVAL      FldNameArr(Idx) = '*ANY'
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPoss - Routine to Call Extended Settlements Program         *
      *                                                               *
      *  Called by: SRRetry - Routine to Handle 'Re-entry' Action     *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     SRPoss        BEGSR
 
     C                   EVAL      PSENT = WWSENT
     C                   EVAL      PGMES = DDGMES
     C                   EVAL      PGMEC = DDGMEC
     C                   EVAL      PCCID = DDCCID
     C                   EVAL      PSNEW = DDSNEW
 
     C                   CALL      'SE1819'
     C                   PARM      '00'          PCommand
     C                   PARM      'N'           PError
     C                   PARM                    PDATA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReturn - Routine to Set Up Return Code for Calling Program  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     SRReturn      BEGSR
 
     C                   EVAL      PError = 'N'
     C                   EVAL      PCommand = '00'
 
      ** If re insert matches does not match extension file - 'Y'
 
     C                   IF        *IN75 = *ON
     C                   EVAL      PError = 'Y'
     C                   ENDIF
 
      ** If F12 taken (for previous screen) then set Return Command to '12'
 
     C                   IF        *INKL = *ON
     C                   EVAL      PCommand = '12'
     C                   ELSE
 
      ** If F3 taken (for End) then set Return Command to '03'
 
     C                   IF        *INKC = *ON
     C                   EVAL      PCommand = '03'
     C                   ELSE
 
      ** If F5 taken (for Refresh) then set Return Command to '05'
 
     C                   IF        *INKE = *ON
     C                   EVAL      PCommand = '05'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Move Input field TIME to be an output parameter
 
     C                   MOVEL     DDTRTT        PTRTT
 
      ** Exit program
 
     C                   EVAL      *INLR = *ON
 
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
 
      ** Get parameters from calling program
 
     C     *ENTRY        PLIST
     C                   PARM                    PCommand
     C                   PARM                    PError
     C                   PARM                    PData
      *                                                                                       CAP067
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
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      /EJECT
      ********************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
