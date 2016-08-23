     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade SWIFT Extended Settlement Detail In')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETSESSIN - Midas SE Trade SWIFT Extended Settlement Detail  *
      *              Input                                            *
      *                                                               *
      *  Function: This is the main screen input function for         *
      *            Extended Settlements of Trades                     *
      *                                                               *
      *  Component of: SETSESSIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG2274            Date 19Aug04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 220395             Date 07Aug03               *
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG2274 - Unable to access SSI information because market    *
      *            not being passed in.                               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  220395 - The repair function loses the extended settlement   *
      *           data stored in the invalid file and works as if     *
      *           they were all blanks.                               *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FTRADSDY2  IF   E           K DISK
      *
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
      *
      ** Securities for file update- file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)
     D                                     PREFIX(S:1)
     D WTRADX2       E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(S:2)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(TRADSDX2)
      *
      ** Extended Settlements screen details from incoming transaction - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      ** Extended Settlements screen details retrieved from file - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(O:1)
      *
      ** Securities screen error indicators
     D SEETES        E DS                  EXTNAME(SEETESPD)
      *
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for security customer details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
     D PDATA         E DS                  EXTNAME(SE50DT)
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D TRADX2        E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(W2:1)
      **  Data structure for breaking up details of TRADSDX2 into
      **  renamed fields
      *
 
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter and work variable declarations
     D PParmLink       S              1A
     D PParmRtcd       S              7A
 
     D PSARd           S              6A
     D PRtcd           S              7A
     D POptn           S              7A
 
     D PKey            S              2A   INZ(*BLANKS)
     D PPgm            S             10A   INZ('SETSESSIN')
     D PAction         S              1A
     D PSpareW         S            256A   INZ(*BLANKS)
 
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKL           S              1A
     D PINKN           S              1A
     D PINKS           S              1A
     D PINKT           S              1A
 
     D PEINKE          S              1A
     D PEINKL          S              1A
 
     D CSE022          S              1A
     D CSE028          S              1A
     D CSE029          S              1A
     D CSW014          S              1A
     D CSW206          S              1A                                                     CSW206E
     D CSW210          S              1A                                                      CSW210
     D CFT004          S              1A                                                      CSW210
 
     D WScrn           S              1A
     D WOScrn          S              1A
      *
      ** Redisplay Flag and Indicator
     D WReDisplay      S              1A   INZ(*BLANK)
      *
      ** Index for arrays of error message IDs
     D IdX             S              3P 0
      *
      ** Index for arrays of warning messages
     D Ex              S              3P 0
     D WiX             S              3P 0
     D WIdX            S              3P 0
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
      *
      ** Work fields
     D PCMD            S              2A
     D PERR            S              1A
     D PSMCC           S              2A
     D DFTFLG          S              1A
     D PWHEN           S              1A
     D PTYPE           S              1A
     D PSAFA           S              6A
     D PGMNAM          S              9A
      *
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      /COPY QWINDSRC,SETSESDTA
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
      *
      ** DO WHILE screen: level 1 screen details.
      *
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRScrn_P
     C                   ENDDO
      *
      ** Screen: Window processing.
      *
     C                   IF        WScrn = 'W'
     C                   EXSR      SRWindow
     C                   ENDIF
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_P - Process Extended Settlement Screen                *
      *                                                               *
      *****************************************************************
 
     C     SRScrn_P      BEGSR
      *
      ** Protect screen fields if necessary and disable function keys
      ** accordingly.
      *
     C                   EVAL      PEINKL  = 'Y'
 
     C                   IF        PACTN = 'I' OR PACTN = 'A'
     C                   EVAL      PEINKE  = 'Y'
     C                   ELSE
     C                   EVAL      PEINKE  = 'N'
     C                   ENDIF
 
      *
      ** Process defaulting of screen details before going to screen.
      *
     C**D**              IF        DFTFLG = 'Y'                                               220395
     C                   EXSR      SRDefScn
     C**D**              ENDIF                                                                220395
 
     C                   MOVE      NwSE1ScnFmt   CrSE1ScnFmt
 
      *
      ** Process Extended Settlement Screen
      *
     C                   CALLB     'SETSESDSP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Security API Trades Extended Settlement details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Security API Trades Extended Settlement details retrieved from file
      ** - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KL = Command key 12 = Cancel
     C                   PARM                    PEINKE
     C                   PARM                    PEINKL
      *
      ** Security API Trades Extended Settlements Error Indicators
     C                   PARM                    SEETES
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
      ** Data for MT5xxs
     C                   PARM                    PDATA
      *
      ** Extra Parameter for TRADSDX2
     C                   PARM                    PWHEN
     C                   PARM                    WWCLTY
     C                   PARM                    WTDTP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - system run date
     C                   PARM                    BJMRDT
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** MT5xx SSI Enhancements
     C                   PARM                    CSE028
      *
      ** ISO15022 Message Generation
     C                   PARM                    CSE029
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KL = command key 12 = Cancel
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKL
     C                   PARM                    PINKN
     C                   PARM                    PINKS
     C                   PARM                    PINKT
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
     C                   EVAL      NwSE1ScnFmt = CrSE1ScnFmt
     C                   EXSR      SREndP
      *
      ** F12 - cancel on primary screen.
     C                   WHEN      PINKL = *ON
      *
      **D** Display initial screen with blank fields.                                         220395
     C**D**              EXSR      SRClearScn                                                 220395
      ** Restore the initial values of the screen fields (cancel changes)                     220395
     C                   EVAL      NwSE1ScnFmt = WTRADX2                                      220395
     C                   EXSR      SREndP
      *
      ** F14 - Exit on Settlement Screen.
     C                   WHEN      PINKN = *ON
     C                   EXSR      SREndP
      *
      ** Enter key was pressed.  Validate input to initial screen.
     C                   OTHER
      *
      ** If Action is Insert or Amend, validate input to screen
     C                   IF        PACTN = 'I' or PACTN = 'A'
     C                   EXSR      SRVal_P
     C                   GOTO      ESRScrn_P
     C                   ENDIF
 
     C                   ENDSL
 
     C     ESRScrn_P     ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScn - Default fields in screen                          *
      *                                                               *
      *****************************************************************
 
     C     SRDefScn      BEGSR
 
     C                   EVAL      CrSEFilFmt = *Blanks                                       220395
     C     KEY001        CHAIN     TRADSDD2                           89
 
     C                   CALLB     'SETSESDFT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    CSE022
 
     C                   PARM                    CSE028
 
     C                   PARM                    SWRTN
 
     C                   PARM                    DFTFLG
 
     C                   PARM                    WWBICN
 
     C                   PARM                    PGMNAM
     C                   PARM                    PSMCC                                       BUG2274
      ** SWIFT 2006                                                                          CSW206E
     C                   PARM                    CSW206                                      CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 1 details retrieved from file - screen format
     C**D**              PARM                    NwSE1ScnFmt                                  220395
     C                   PARM                    CrSE1ScnFmt                                  220395
                                                                                              220395
     C                   IF        NwSE1ScnFmt = *Blanks                                      220395
     C                   EVAL      NwSE1ScnFmt = CrSE1ScnFmt                                  220395
     C                   ELSE                                                                 220395
      *                                                                                       220395
     C                   IF        CrSEFilFmt = *Blanks AND PACTN = 'I' AND                   220395
     C                             (CSE028 <> 'Y' OR DFTFLG <> 'Y')                           220395
     C                   EVAL      ESSRL1 = PTDSI                                             220395
     C                   ENDIF                                                                220395
      *                                                                                       220395
     C                   ENDIF                                                                220395
 
     C     ESRDefScn1    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_P - Validate input to primary details screen           *
      *                                                               *
      *****************************************************************
 
     C     SRVal_P       BEGSR
 
     C                   CALLB     'SETSESVAL'
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
      ** Security API Trades Extended Settlement details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** MT5xx SSI Enhancements
     C                   PARM                    CSE028
      *
      ** ERI Information for non-EMU users
     C                   PARM                    CSW014
      *
      ** SWIFT 2001
     C                   PARM                    CSW201
      *
      ** CSW098
     C                   PARM                    SWRTN
      ** SWIFT 2006                                                                          CSW206E
     C                   PARM                    CSW206                                      CSW206E
      *                                                                                       CSW210
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      *                                                                                       CSW210
      ** CFT004 - IBAN Numbers                                                                CSW210
     C                   PARM                    CFT004                                       CSW210
      *
      ** Other Parameters
     C                   PARM                    PDATA
 
     C                   PARM                    WTDTP
 
     C                   PARM                    WWCLTY
 
     C                   PARM                    PSAFA
      *
      ** Function Keys
     C                   PARM                    PINKS
 
     C                   PARM                    PINKT
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
      ** Security API Trades Extended Settlements Error Indicators
     C                   PARM                    SEETES
      *
      ** Security API Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Populate Valids File
      *
     C                   EVAL      S2TDRF = PTDRF
     C                   EVAL      S2WHEN = PWHEN
 
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
     C                   IF        IdX <> 0 OR WRedisplay = 'Y'
     C                   GOTO      ESRVal_P
     C                   ENDIF
 
     C                   EVAL      WScrn = 'W'
 
     C     ESRVal_P      ENDSR
 
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
      ** Avoid to roll back the changes which could have been done by                         220395
      ** previous windows, called for example from SETRADRPR                                  220395
     C**D**              ROLBK                                                                220395
      *
      ** Set value of return code for linked processing.
      *
     C                   IF        PParmLink = 'Y'
     C                   EVAL      PParmRtcd = 'Y2U9999'
     C                   ENDIF
      *
      ** Set Return Parameter to SETRADEDSP
      *
     C                   SELECT
     C                   WHEN      PINKC = *ON
     C                   EVAL      PCMD = '03'
     C                   WHEN      PINKE = *ON
     C                   EVAL      PCMD = '05'
     C                   WHEN      PINKL = *ON
     C                   EVAL      PCMD = '12'
     C                   WHEN      PINKN = *ON
     C                   EVAL      PCMD = '14'
     C                   ENDSL
      *
      ** Set processing to end program.
      *
     C                   EVAL      WScrn = 'E'
 
     C     ESREndP       ENDSR
 
 
      **D**************************************************************                       220395
      **D**EJECT                                                                              220395
      **D**************************************************************                       220395
      **D**                                                           *                       220395
      **D**  SRClearScn - Clear screen data structures                *                       220395
      **D**                                                           *                       220395
      **D**************************************************************                       220395
      **D**                                                                                   220395
     C**D**SRClearScn    BEGSR                                                                220395
      **D**                                                                                   220395
      **D** Clear screen data structures for new processing.                                  220395
      **D**                                                                                   220395
     C**D**              CLEAR                   CrSE1ScnFmt                                  220395
      **D**                                                                                   220395
     C**D**              CLEAR                   NwSE1ScnFmt                                  220395
      **D**                                                                                   220395
     C**D**ESClearScn    ENDSR                                                                220395
 
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
     C                   EVAL      SEETES = *ALL'Y'
 
     C     ESRResetErr   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWindow - Call window manager program.                       *
      *                                                               *
      *****************************************************************
 
     C     SRWindow      BEGSR
      *
      ** Call window manager.
      *
     C                   CALL      'WN0010'
     C                   PARM      'SETSESSIN'   PPgm
     C                   PARM                    PKey
     C                   PARM      PACTN         PAction
     C                   PARM                    Data
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      *BLANKS       PSpareW
      *
      ** Process returned command keys.
      ** F3, exit and return to calling program.
      *
     C                   IF        PRtcd = 'Y2U9999'
     C                   EVAL      PINKC = *ON                                                220395
     C                   EXSR      SREndP
     C                   GOTO      ESRWindow
     C                   ENDIF
      *
      ** If Cmd12 pressed, return to previous screen;
      ** otherwise, go to confirmation screen.
      *
     C                   IF        PRtcd = 'USR0790'
      *
      ** Redisplay previous screen.
      *
     C**D**              EVAL      WScrn = WOScrn                                             220395
     C                   EVAL      WScrn = 'P'                                                220395
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      PACTN  = 'E'
      *
      ** If securities maintenance has been called by linked
      ** maintenance/enquiry, terminate program.
      *
     C                   IF        PParmLink = 'Y'
     C                   EVAL      PParmRtcd = *BLANK
     C                   EVAL      WScrn = 'E'
     C                   GOTO      ESRWindow
     C                   ENDIF
      *
      ** Read Next Browse Subfile record.
      *
     C**D**              EXSR      SRClearScn                                                 220395
     C**D**              EVAL      WScrn = 'P'                                                220395
     C                   EVAL      WScrn = 'E'                                                220395
 
     C                   OTHER
      *
      ** Otherwise, proceed to confirmation screen.
      *
     C                   EVAL      WScrn = 'E'
 
     C                   ENDSL
 
     C                   ENDIF
 
     C     ESRWindow     ENDSR
 
      *****************************************************************
      /EJECT
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
     C                   PARM                    PCMD
     C                   PARM                    PERR
     C                   PARM                    PDATA
     C                   PARM                    PSMCC
     C                   PARM                    DFTFLG
      *
      **  Extra parameter needed to pass detail from TRADSDX2 to SE1806
      **  for reference trade.
      *
     C                   PARM                    TRADX2
     C                   PARM                    PWHEN
     C                   PARM                    PTYPE
     C                   PARM                    PSAFA
     C                   PARM                    NwSE1ScnFmt
     C                   PARM                    SEETES
      *
      ** Output valid File Extended Settlements for trade
      *
     C                   PARM                    NwSEFilFmt
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
      ** Access Branch Details using Branch Code from TRADSD
      *
     C                   MOVE      PTDBR         WDSNB
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WDSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** Check to see if switchable feature CSW098 is on or if date is
      ** greater than 16 October 1998.
      *
     C                   CALL      'SWIFT98'                            09
     C                   PARM                    SWRTN             7
 
     C                   IF        *IN09 = *ON
     C                   EVAL      DBKey = 'SWIFT98'
     C                   EVAL      DBFile = 'ERR CALL'
     C                   Z-ADD     2             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        SWRTN = 'CSW098 '
     C                   EVAL      *IN09 = *ON
     C                   ELSE
     C                   EVAL      *IN09 = *OFF
     C                   ENDIF
      *
      ** Access SAR file to determine if CSW014 is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSW014'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSW014'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     3             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSW014 = 'Y'
     C                   ELSE
     C                   EVAL      CSW014 = 'N'
     C                   ENDIF
      *
      ** Call SWIF2001 to check if CSW201 is switched on
      *
     C                   CALL      'SWIF2001'                           8383
     C                   PARM      *BLANKS       PRtcd
 
     C                   IF        *IN83 = *ON
     C                   EVAL      DBKey = '*CALL'
     C                   EVAL      DBFile = 'SWIF2001'
     C                   Z-ADD     4             DBase
     C                   EXSR      *PSSR
     C                   ELSE
 
     C     PRtcd         IFEQ      'CSW2001'
     C                   MOVE      'Y'           CSW201            1
     C                   ELSE
     C                   MOVE      'N'           CSW201
     C                   ENDIF
 
     C                   ENDIF
                                                                                             CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD                                       CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *
      ** Access SAR file to determine if CSE028 is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE028'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE028'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     5             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSE028 = 'Y'
     C                   EVAL      *IN82 = *ON
     C                   ELSE
     C                   EVAL      CSE028 = 'N'
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE029 is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE029'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE029'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     6             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSE029 = 'Y'
     C                   ELSE
     C                   EVAL      CSE029 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE022 is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE022'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE022'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     7             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSE022 = 'Y'
     C                   EVAL      PGMNAM = 'SEDORFRTV'
     C                   ELSE
     C                   EVAL      CSE022 = 'N'
     C                   ENDIF
      *                                                                                       CSW210
      ** Check to see if switchable feature CSW210 is on or if date is                        CSW210
      ** equal or greater than 20 November 2010.                                              CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM      *BLANKS       PRTCD                                        CSW210
                                                                                              CSW210
     C                   IF        PRTCD = 'CSW2010'                                          CSW210
     C                   EVAL      CSW210 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Check to see if switchable feature CFT004 in on.                                     CSW210
      *                                                                                       CSW210
     C                   CALLB     'AOSARDR0'                                                 CSW210
     C                   PARM      *BLANKS       PRtcd                                        CSW210
     C                   PARM      '*VERIFY'     POptn                                        CSW210
     C                   PARM      'CFT004'      PSARd                                        CSW210
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW210
      *                                                                                       CSW210
      ** An NRF (No Record Found) return code is valid.                                       CSW210
      ** Issue database error only for error return codes.                                    CSW210
      *                                                                                       CSW210
     C                   EVAL      CFT004 = 'N'                                               CSW210
                                                                                              CSW210
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                    CSW210
     C                   EVAL      DBKey = 'CFT004'                                           CSW210
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSW210
     C                   Z-ADD     7             DBase                                        CSW210
     C                   EXSR      *PSSR                                                      CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   IF        PRtcd = *BLANK                                             CSW210
     C                   EVAL      CFT004 = 'Y'                                               CSW210
     C                   ENDIF                                                                CSW210
      *
      ** Save Branch Internal Customer in workfield
      *
     C**********         MOVE      A8BICN        WWBICN            6 0                        CSD027
     C                   MOVE      A8BICN        WWBICN            6                          CSD027
      *
      ** Allow Safekeeping Account Fields to be Input capable
      *
     C                   EVAL      *IN10 = *OFF
      *
      ** Initialise Clearance Type (1 to 4 is MT580 for Settlements)
      *
     C     PWHEN         IFNE      'B'
     C     PCLTY         OREQ      '1'
     C     PCLTY         OREQ      '3'
 
     C     PCLTY         IFEQ      '1'
     C     PCLTY         OREQ      '2'
     C     PCLTY         OREQ      '3'
     C     PCLTY         OREQ      '4'
     C                   MOVE      '14'          WWCLTY            2
     C                   ENDIF
 
     C                   ELSE
     C     PTDTP         IFEQ      'TP'
     C                   MOVE      PDELF         WCUST
     C                   ELSE
     C                   MOVE      PDELT         WCUST
     C                   END
 
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WCUST             6
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C     BFCLAS        IFEQ      'E'
     C     PCLTY         ANDEQ     '4'
     C     BFCLAS        OREQ      'E'
     C     PCLTY         ANDEQ     '5'
     C     BFCLAS        OREQ      'C'
     C     PCLTY         ANDEQ     '2'
     C     BFCLAS        OREQ      'C'
     C     PCLTY         ANDEQ     '5'
     C                   MOVE      '14'          WWCLTY
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Set up trade type as opposite, if second record
      *
     C     PWHEN         IFEQ      'B'
     C     PTDTP         IFEQ      'TP'
     C                   MOVE      'TS'          WTDTP
     C                   ELSE
     C                   MOVE      'TP'          WTDTP
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      PTDTP         WTDTP             2
     C                   ENDIF
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   EVAL      WScrn = 'P'
 
     C     KEY001        KLIST
     C                   KFLD                    PTDRF
     C                   KFLD                    PWHEN
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
