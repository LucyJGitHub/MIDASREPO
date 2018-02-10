     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT970 Generation Request')                    *
      *****************************************************************
      *                                                               *
      *  Midas - ME Module                                            *
      *                                                               *
      *  ME0902 - MT970 Generation Request                            *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the generation of MT970 statements based on a     *
      *             value date entered by the user                    *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW099  *CREATE    Date 28Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CSW099 - Creation of MT970 Netting Statements                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FME0902DF  CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  10        Field Error - highlight screen fields              *
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
 
      ** Array for command in QCMDEX
     DSTRARR           S             80    DIM(2) CTDATA PERRCD(1)
 
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs - very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
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
     D WVDTE           S              5P 0
 
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A
 
      ** Parameters for ZDATE1
     D PVDTE           S              6A
     D PDaynoOut       S              5P 0
     D ErrorFlag       S              1A
 
      ** Parameters for module AOBANKR0
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** Parameters for QCMDEXC
     D PCmdTxt         DS
     D   PCmdTxt1              1     80
     D   PCmdTxt2             81    160
     D   PParm1               74     78
 
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
 
     C                   if        *in10 = *off and *in11 = *off and
     C                             *in12 = *off and *in14 = *off
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
 
      ** Submit job.
 
     C                   IF        WScrn = 'S'
     C                   EXSR      SRSbmjob
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
 
     C                   CLEAR                   LVDTE
 
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
 
     C                   EXSR      SRValVDTE
 
     C                   if        *in10 = *off and *in11 = *off and
     C                             *in12 = *off and *in14 = *off
     C                   eval      WScrn = 'S'
     C                   endif
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSbmjob - Submit Job                                        *
      *                                                               *
      *****************************************************************
     C     SRSbmjob      BEGSR
 
     C                   EVAL      *IN13 = *ON
     C                   MOVEA     '000'         *IN(10)
     C                   MOVEA     '01'          *IN(14)
     C                   MOVEA     '1'           *IN(20)
     C                   EVAL      PMsgId = 'MEM0013'
     C                   EXSR      SRSndM
     C                   WRITE     ME0902C1
     C**********         WRITE     ME0902F0                                                 AR656294
     C                   WRITE     ME0902F1
     C                   WRITE     ME0902F0                                                 AR656294
     C                   READ      ME0902F0                               01
 
     C                   IF        *INKJ = *ON
 
     C                   EXSR      SRCmdStr
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCmdTxt
     C                   PARM      160           PCmdLen
 
     C                   EVAL      *IN13 = *OFF
     C                   EXSR      SRClrMsgQ
     C                   EVAL      PMsgId = 'MEM0014'
     C                   EXSR      SRSndM
 
     C                   MOVEA     '0'           *IN(20)
 
     C                   WRITE     ME0902C1
     C**********         WRITE     ME0902F0                                                 AR656294
     C                   WRITE     ME0902F1
     C                   WRITE     ME0902F0                                                 AR656294
     C                   READ      ME0902F0                               01
 
     C                   MOVEA     '000'         *IN(10)
     C                   MOVEA     '00'          *IN(14)
     C                   MOVEA     '0'           *IN(20)
     C                   EXSR      SRInit
     C                   CALL      'ZA0250'
     C                   EVAL      WScrn = 'P'
 
     C                   ENDIF
 
      ** F3 pressed. exit program
 
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
 
      ** F12 pressed. exit program
 
     C                   IF        *INKL = *ON
     C                   EVAL      WScrn = 'P'
     C                   MOVEA     '000'         *IN(10)
     C                   MOVEA     '00'          *IN(14)
     C                   MOVEA     '0'           *IN(20)
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
      *  SRCmdStr - Set up parameters for QCMDEX                      *
      *                                                               *
      *****************************************************************
     C     SRCmdStr      BEGSR
 
     C                   MOVEL     STRARR(1)     PCmdTxt1
     C                   MOVEL     STRARR(2)     PCmdTxt2
     C                   MOVEL     WVDTE         PParm1
 
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
     C                   WRITE     ME0902C1
     C**********         WRITE     ME0902F0                                                 AR656294
     C                   WRITE     ME0902F1
     C                   WRITE     ME0902F0                                                 AR656294
 
      ** Read details screen.
 
     C                   READ      ME0902F0                               01
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off.
 
     C                   MOVEA     '000'         *IN(10)
     C                   MOVEA     '00'          *IN(14)
     C                   MOVEA     '0'           *IN(20)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValVDTE - Validate Value Date field                        *
      *                                                               *
      *****************************************************************
     C     SRValVDTE     BEGSR
 
      ** Must be numeric.
 
     C                   TESTN                   LVDTE                01
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'MEM0015'
     C                   EXSR      SRSndM
     C                   GOTO      EValVDTE
     C                   ENDIF
 
      ** Must be a valid date.
 
     C                   MOVE      *BLANKS       PVDTE
     C                   MOVE      LVDTE         PVDTE
     C                   CALLB     'ZDATE1'
     C                   PARM                    PVDTE
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'MEM0016'
     C                   EXSR      SRSndM
     C                   GOTO      EValVDTE
     C                   ENDIF
 
     C                   EVAL      WVDTE = PDaynoOut
 
     C     EValVDTE      ENDSR
 
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
 
      ** Check CSW099 status
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW099'      @SARD             6
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
 
     C                   call      'ZVACTU'
     C                   PARM      'I'           WLACTN            1
     C                   PARM      *ZERO         WLERR             1 0
 
     C                   if        WLERR = *zero
     C                   ENDIF
 
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
 
     C                   EVAL      WScrn = 'P'
 
     C                   EVAL      PMsgf = 'GBMEMSG'
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
 
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
(c) Finastra International Limited 2005
**  STRARR
SBMJOB JOB(MGC0970) JOBD(MBATCH) USER(*JOBD) CMD(CALL PGM(MGC0970) PARM('xxxxx')
) MSGQ(MOPERQ) RTGDTA(*JOBD) INLLIBL(*JOBD)
