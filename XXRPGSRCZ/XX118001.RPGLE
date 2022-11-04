     H DEBUG
     H COPYRIGHT('(Finastra Ltd 2022')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  XX118001 - On-Line Positions Generation                      *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user selection input of On-Line generation    *
      *             for back-valued positions                         *
      *                                                               *
      *  Component of: XX118001 On-Line Position Generation           *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. HUT118  *CREATE    Date 03Nov22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT118 - On-line Position Settlement Generation              *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Allocations per dividend payment summary report display file
     FXX118001DFCF   E             WORKSTN

      ** Securities details
     FSECTY     IF   E           K DISK    INFSR(*PSSR)

      ** Securities diary events file
     FXXDEVLV0  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  08        Generated Position Setttlements report             *
      *  09        Field Error - highlight screen fields              *
      *  11-12     Field Error - highlight screen fields              *
      *  14        Field Error - highlight screen fields              *
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

      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Standard Data Area Layout for System flags and Run Date
     D RUNDAT        E DS

      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Work Fields
     D WScrn           S              1A
     D WEDte           S              5P 0
     D WPDte           S              5P 0
     D WEvtp           S              2A

     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A

      ** Parameters for ZDATE1
     D PEDte           S              6A
     D PPDte           S              6A
     D PDaynoOut       S              5P 0
     D ErrorFlag       S              1A

      ** Parameters for module AOBANKR0
     D PRtCd           S              7A
     D POptn           S              7A

      ** Parameters for QCMDEXC
     D PCmdTxt         DS
     D   PCmdTxt1              1     80
     D   PCmdTxt2             81    160
     D   PCmdTxt3            161    240
     D   PParm1               82     91
     D   PParm2               97    101
     D   PParm3              107    111
     D   PParm4              117    118
     D   PParm6              132    137
     D   PParm7              143    148

     D PCmdLen         S             15  5

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

     C                   EXSR      SRInit

      ** Process inputs.

     C                   EXSR      SRProc

      ** Return.

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR

      ** Do while SCREEN

     C                   DOW       WScrn = 'P' or WScrn = 'S'

      ** Before sending the messages to the program message queue,
      ** clear the program message queue.

     C                   if        *in09 = *off and *in11 = *off and
     C                             *in12 = *off and *in14 = *off and
     C                             *in16 = *off and *in17 = *off and
     C                             *in18 = *off
     C                   EXSR      SRClrMsgQ
     C                   endif

      ** Read details.

     C                   if        WScrn = 'P'
     C                   exsr      SRDisp
     C                   endif
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRVal

      ** Execute On-line Generation.

     C                   IF        WScrn = 'S'
     C                   EXSR      SRExecGen
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

      ** Terminate program.

     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise variables                                *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR

     C                   CLEAR                   SSECU
     C                   CLEAR                   SEDTE
     C                   CLEAR                   SPDTE
     C                   CLEAR                   SEVTP

     C                   ENDSR

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
     C                   EXSR      SRValEDte
     C                   EXSR      SRValPDte
     C                   EXSR      SRValEVtp

     C                   if        *in09 = *off and *in11 = *off and
     C                             *in12 = *off and *in14 = *off
     C                   EXSR      SRValEVent
     C                   endif

     C                   if        *in09 = *off and *in11 = *off and
     C                             *in12 = *off and *in14 = *off
     C                   eval      WScrn = 'S'
     C                   endif

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExecGen - Execute Generation                               *
      *                                                               *
      *****************************************************************
     C     SRExecGen     BEGSR

     C                   EVAL      *IN13 = *ON
     C                   MOVEA     '0'           *IN(09)
     C                   MOVEA     '00'          *IN(11)
     C                   MOVEA     '01'          *IN(14)
     C                   MOVEA     '1'           *IN(20)
     C                   MOVEA     '0'           *IN(16)
     C                   MOVEA     '00'          *IN(17)
     C                   EVAL      PMsgId = 'HUT1132'
     C                   EXSR      SRSndM
     C                   WRITE     XX118001C1
     C                   WRITE     XX118001F0
     C                   WRITE     XX118001F1
     C                   READ      XX118001F0                             01

     C                   IF        *INKJ = *ON

     C                   MOVE      WEDte         WEDteT
     C                   MOVE      WPDte         WPDteT
     C
     C                   CALL      'XXC118003'
     C                   PARM                    SSECU
     C                   PARM                    WEDteT            5
     C                   PARM                    WPDteT            5
     C                   PARM                    SEVTP
     C                   PARM      *ZEROS        GENTD             6 0
     C                   PARM                    RetCd             7

      * Inform the user of the outcome
     C     RetCd         IFEQ      *BLANKS
     C     GENTD         IFNE      *ZEROS
     C                   MOVE      *ON           *IN30
     C                   EVAL      PMsgId = 'HUT1133'
     C                   ELSE
     C                   EVAL      PMsgId = 'HUT1141'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      PMsgId = 'HUT1142'
     C                   ENDIF
     C
     C                   EVAL      *IN13 = *OFF
     C                   EXSR      SRClrMsgQ
     C                   EXSR      SRSndM

     C*****              MOVEA     '0'           *IN(20)                                     HUT118

     C                   WRITE     XX118001C1
     C                   WRITE     XX118001F0
     C                   WRITE     XX118001F1
     C                   READ      XX118001F0                             01

      * Execute the report if F8 is taken
     C                   IF        *INKH = *ON
     C                             AND GENTD > 0
      *
      * Parameters will be passed using a data area
     C                   CALL      'XXC118002A'
     C                   PARM      SSECU         WSSECU           10
     C                   PARM      SEDTE         WSEDTE            6
     C                   PARM      SPDTE         WSPDTE            6
     C                   PARM      SEVTP         WSEVTP            2
      *
      * Execute report
     C                   CALL      'FCC0201'
     C                   PARM      'XXC118002'   WWCOMP           10
     C                   PARM      '10001'       WWSEQ             5
     C                   PARM      'XX118002'    WWPRGM           10
     C                   PARM      'B'           WWBRCH            1
     C                   ENDIF
      *
     C                   MOVEA     '0'           *IN(09)
     C                   MOVEA     '00'          *IN(11)
     C                   MOVEA     '00'          *IN(14)
     C                   MOVEA     '0'           *IN(20)
     C                   MOVEA     '0'           *IN(16)
     C                   MOVEA     '00'          *IN(17)
     C                   IF        *INKH = *ON OR
     C                             (*INKC = *OFF AND *INKL = *OFF)
     C                   MOVEA     '0'           *IN(30)
     C                   EXSR      SRInit
     C                   ENDIF
     C                   CALL      'ZA0250'
     C                   EVAL      WScrn = 'P'

     C                   ENDIF

      ** F3 pressed. exit program

     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE

      ** F12 pressed. return to input

     C                   IF        *INKL = *ON
     C                   EVAL      WScrn = 'P'
     C                   MOVEA     '0'           *IN(09)
     C                   MOVEA     '00'          *IN(11)
     C                   MOVEA     '00'          *IN(14)
     C                   MOVEA     '0'           *IN(20)
     C                   MOVEA     '0'           *IN(16)
     C                   MOVEA     '00'          *IN(17)
     C                   MOVEA     '0'           *IN(30)
     C                   CALL      'ZA0250'
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
     C     SEDTE         IFEQ      *BLANKS
     C                   MOVE      PEDteW        SEDTE
     C                   ENDIF
     C     SEVTP         IFEQ      *BLANKS
     C                   MOVE      WEVTP         SEVTP
     C                   ENDIF
     C                   WRITE     XX118001C1
     C                   WRITE     XX118001F0
     C                   WRITE     XX118001F1

      ** Read details screen.

     C                   READ      XX118001F0                             01

      ** Clear message subfile.

     C                   CALL      'ZA0250'

      ** Set screen error indicators off.

     C                   MOVEA     '0'           *IN(09)
     C                   MOVEA     '00'          *IN(11)
     C                   MOVEA     '00'          *IN(14)
     C                   MOVEA     '0'           *IN(20)
     C                   MOVEA     '0'           *IN(16)
     C                   MOVEA     '00'          *IN(17)

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

     C                   IF        (*IN01 = *ON) or
     C                             (*IN01 = *OFF and RECI <> 'D')
     C                   EVAL      *IN09 = *ON
     C                   EVAL      PMsgId = 'HUT1134'
     C                   EXSR      SRSndM
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEvent - Validate that event exists                      *
      *                                                               *
      *****************************************************************
     C     SRValEvent    BEGSR
      *
     C                   Movel     Sevtp         WEvent
      *
     C                   move      *off          *in92             1
     C                   move      *blanks       Weveok            1
      *
     C     SEVTP         IFeq      'DV'
     C     KeyEve        Setll     XXDEVLV0
     C     KeyEvP        reade     XXDEVLV0                               92
      *
     C     *in92         DOweq     *oFF
     C     Weveok        andne     'Y'
     C                   Move      'Y'           Weveok
      *
      * check details
     C     RECI          ifne      'D'
     C                   Move      'N'           Weveok
     C                   Endif
      *
     C     SDET          ifne      Wevent
     C     Wevent        andne     *blanks
     C                   Move      'N'           Weveok
     C                   Endif
      *
     C     WPDTE         ifne      *zeros
     C     Wpdte         andne     SDPD
     C                   Move      'N'           Weveok
     C                   Endif
      *
     C     KeyEvP        reade     XXDEVLV0                               92
     C                   Enddo
      *
     C     WeveOk        ifne      'Y'
     C                   EVAL      *IN09 = *ON
     C                   EVAL      *IN11 = *ON
     C                   EVAL      *IN12 = *ON
     C                   EVAL      *IN14 = *ON
     C                   EVAL      PMsgId = 'HUT1140'
     C                   EXSR      SRSndM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEDte - Validate Event Date field                        *
      *                                                               *
      *****************************************************************
     C     SRValEDte     BEGSR

      ** Must be numeric.

     C                   TESTN                   SEDTE                01

     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'HUT1135'
     C                   EXSR      SRSndM
     C                   GOTO      EValEdte
     C                   ENDIF

      ** Must be a valid date.

     C                   MOVE      *BLANKS       PEDte
     C                   MOVE      SEDTE         PEDte
     C                   CALLB     'ZDATE1'
     C                   PARM                    PEDte
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag

     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'HUT1136'
     C                   EXSR      SRSndM
     C                   GOTO      EValEdte
     C                   ENDIF

      ** must be a valid numeric date not later than rundate

     C                   IF        PDaynoOut > BJRDNB
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'HUT1138'
     C                   EXSR      SRSndM
     C                   GOTO      EValEdte
     C                   ENDIF

     C                   EVAL      WEDte = PDaynoOut

     C     EValEdte      ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValPDte - Validate Payment Date field                      *
      *                                                               *
      *****************************************************************
     C     SRValPDte     BEGSR

      ** Must be numeric.

     C                   TESTN                   SPDTE                01

     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'HUT1135'
     C                   EXSR      SRSndM
     C                   GOTO      EValPDte
     C                   ENDIF

      ** Must be a valid date.

     C                   MOVE      *BLANKS       PPDte
     C                   MOVE      SPDTE         PPDte
     C                   CALLB     'ZDATE1'
     C                   PARM                    PPDte
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag

     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'HUT1136'
     C                   EXSR      SRSndM
     C                   GOTO      EValPDte
     C                   ENDIF

      ** must be a valid numeric date not later than rundate

     C                   IF        PDaynoOut > BJRDNB
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'HUT1138'
     C                   EXSR      SRSndM
     C                   GOTO      EValPDte
     C                   ENDIF

     C                   EVAL      WPDte = PDaynoOut

     C     EValPDte      ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValEVtp - Validate Event Type field                        *
      *                                                               *
      *****************************************************************
     C     SRValEVtp     BEGSR

      ** If entered, event type must only be DV

     C                   IF        (SEVTP <> 'DV  ')

     C                   EVAL      *IN14 = *ON
     C                   EVAL      PMsgId = 'HUT1139'
     C                   EXSR      SRSndM
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

      ** Check HUT118 status

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'HUT118'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Continue with the program only if active

     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      ** Retrieve ZMUSER details.

     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER

      ** Retrieve RUNDAT details.

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      **  Check if user is authorised to action 'Insert'

     C                   if        AGMBIN = 'Y'

      **  If single branch environment

     C                   call      'ZVACTU'
     C                   PARM      'I'           WLACTN            1
     C                   PARM      *ZERO         WLERR             1 0

     C                   if        WLERR = *zero
     C                   seton                                        LR
     C                   return
     C                   ENDIF

     C                   else

      **  If multibranching environment

     C                   call      'ZVACTU'
     C                   PARM      'I'           WLACTN
     C                   PARM      PDBRN         WLBRCH            3
     C                   PARM      *ZERO         WLERR

     C                   if        WLERR = 1
     C                   seton                                        LR
     C                   return
     C                   else
     C                   if        WLERR = 2
     C                   seton                                        LR
     C                   return
     C                   endif
     C                   endif

     C                   endif

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

      ** Prepare default value date

     C                   CALL      'ZDATE2'
     C                   PARM      BJRDNB        PRunDay           5 0
     C                   PARM      BJDFIN        PDatFmt           1
     C                   PARM      *ZERO         POutDat6          6 0
     C                   PARM      *BLANKS       POutDat7          7
     C                   MOVE      POutDat6      PEDteW            6

      ** Prepare default Event Type

     C                   MOVE      'DV'          WEVTP             2

      ** Prepare more variables

     C                   EVAL      WScrn = 'P'

     C                   EVAL      PMsgf = 'GBXXUSRMSG'

     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName

      ** Message subfile control and program queue initialisation.

     C                   EVAL      *IN25 = *ON
     C                   EVAL      SPGM = '*'
      *
     C     *LIKE         DEFINE    SSECU         WSECU
     C     KCOAT         KLIST
     C                   KFLD                    WSECU
     C                   KFLD                    WEDte
     C                   KFLD                    WEvent            2
      *
     C     KEYEVE        KLIST
     C                   KFLD                    SSECU
     C                   KFLD                    WEDte
     C                   KFLD                    WEvent            2
      *
     C     KEYEVP        KLIST
     C                   KFLD                    SSECU
     C                   KFLD                    WEDte
      *

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
(c) Finastra Ltd 2022
