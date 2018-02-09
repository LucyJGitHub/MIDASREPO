     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Exception Rept - Prompt')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000556 - FATCA Exceptions By CUST/NAHO Report - Prompt     *
      *                                                               *
      *  Function:  This module provides a selection screen from      *
      *             which the user can filter for specific exception  *
      *             messages to include in the report.                *
      *                                                               *
      *  Component of: SD000554 FATCA Exceptions By CUST/NAHO Rept    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD FATCA Exceptions Report - Prompt
     FSD000556DFCF   E             WORKSTN SFILE(SD000556S0:SflRRN)
     F                                     INFSR(*PSSR)
 
      **
     FSDEXMAPD  IF   E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  10-11     Field Error - highlight screen fields              *
      *  25        Subfile control                                    *
      *  25        Subfile end                                        *
      *  90-99     Used by standard subroutine                        *
      *  KC        F3 pressed = Exit                                  *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRInit        - Initialise Variables                          *
      * SRProc        - Process Inputs                                *
      * SRVal         - Validate Details                              *
      * SRUpdate      - Update Ouput Parameter Fields                 *
      * SRDisp        - Display Screen                                *
      * *INZSR        - Program Initialisation                        *
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
 
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
 
      ** Job name
     D PSJobName             244    253
 
      ** User name
     D PSUser                254    263
 
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
      *
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *
      ** External DS Based On SDBANKPD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Output DS
     D POutFlds        DS           100
     D  PExceptions            1     30A
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Fields
     D Recursive       S              1    INZ('N')
     D WScrn           S              1A
     D WExceptions     S             30A   INZ(*BLANKS)
     D WExDesc         S             64A   DIM(3)
 
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A
 
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAct            S              1A
     D PCmd            S              1A
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PJob            S             10
     D PUser           S             10
 
     D SFlRRN          S              4  0
 
     D ZAPGM           S             10    INZ(*Blanks)
     D ZAPGRL          S              5    INZ(*Blanks)
     D ZAMSID          S              7    INZ(*Blanks)
     D ZAMSGF          S             10    INZ(*Blanks)
     D ZAMSDA          S            132    INZ(*Blanks)
     D ZAMSTP          S              7    INZ(*Blanks)
      *
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
      *
      ** Initialise.
      *
     C                   EXSR      SRInit
      *
      ** Process inputs.
      *
     C                   EXSR      SRProc
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : SRDisp, SRVal, SRUpdate                          *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
      *
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
     C                   EXSR      ClrMsgQue
      * Initialise subfile.
     C                   EXSR      InitSfl
      *
      * Build  subfile.
     C                   EXSR      BuildSfl
      *
      ** Do while SCREEN : Read details.
      *
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRDisp
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRVal
     C                   ENDIF
     C                   ENDDO
      *
      ** Do file update.
      *
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise variables                                *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
     C                   CLEAR                   POutFlds
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * InitSfl - Initialise subfile                                  *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     InitSfl       BEGSR
      *
     C                   EVAL      SflRRN = 0
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000556C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      D0FIND = 1
     C                   WRITE     SD000556M0
      *
     C     InitSflE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * BuildSfl - Build subfile                                      *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     BuildSfl      BEGSR
      *
     C     1             SETLL     SDEXMAPD
     C                   READ      SDEXMAD0
     C                   IF        %EOF <> '0'
      *
      **  No Data to Display
      *
     C                   EXSR      NoRecords
     C                   ENDIF
      *
      **  Else, Fill SubFile
     C                   DOW       %EOF <> '1'
 
     C                   EVAL      SflRRN = SflRRN + 1
     C                   EVAL      *IN40 = *OFF
     C
     C                   EVAL      XRACTN = *BLANKS
     C                   EVAL      XREXID = FEEXID
     C                   MOVEA     *BLANKS       WExDesc
     C                   MOVEA     FEEXDE        WExDesc
     C                   MOVE      WExDesc(1)    XREXMA
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000556S0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN40 = *ON
      ** If Message Line 2 is not blank
     C                   IF        WExDesc(2) <> *BLANKS
     C                   MOVE      WExDesc(2)    XREXMA
     C                   EVAL      SflRRN = SflRRN + 1
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000556S0
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
      ** If Message Line 3 is not blank
     C                   IF        WExDesc(3) <> *BLANKS
     C                   MOVE      WExDesc(3)    XREXMA
     C                   EVAL      SflRRN = SflRRN + 1
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000556S0
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
 
     C     ReadNext      TAG
     C                   READ      SDEXMAD0
     C                   ENDDO
      *
      ** Only inactive/deleted records exist
      *
     C                   IF        SflRRN < 1
     C                   EXSR      NoRecords
     C                   ENDIF
 
     C     BuildSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * NoRecords - Notify user that there are no active records      *
      *                                                               *
      * Called by: BuildSfl                                           *
      *                                                               *
      *****************************************************************
      *
     C     NoRecords     BEGSR
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      SflRRN = SflRRN + 1
     C                   WRITE     SD000556S0
      *
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0307'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     SD000556M0
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validate details                                     *
      *                                                               *
      *  Called by : SRProc                                           *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR
      *
      ** Validate details entered.
      *
     C                   MOVE      *BLANKS       WExceptions
     C                   READC     SD000556S0
     C                   DOW       %EOF = '0'
     C                   IF        %TRIM(XRACTN) <> *BLANKS
     C                   EVAL      WExceptions = %trim(WExceptions) + XREXID
     C                   ENDIF
     C                   READC     SD000556S0
     C                   ENDDO
 
     C                   EVAL      WScrn = 'U'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update output parameter fields                    *
      *                                                               *
      *  Called by : SRProc                                           *
      *                                                               *
      *  Calls     : None                                             *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
     C                   EVAL      PExceptions = WExceptions
      *
     C                   EVAL      WScrn = 'E'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisp - Display screen                                      *
      *                                                               *
      *  Called by : SRProc                                           *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
     C     SRDisp        BEGSR
      *
      ** Write message subfile, subfile and footer screens.
      *
     C                   TIME                    D0TIME
     C                   WRITE     SD000556M0
     C                   WRITE     SD000556F0
      *
      ** Display subfile / Prompt user selection
      *
     C                   EVAL      *IN82 = *ON
     C                   EXFMT     SD000556C0
     C                   EXSR      ClrMsgQue
     C                   WRITE     SD000556M0
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MOVEA     '0000'        *IN(10)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ClrMsgQue - Clear program message queue                       *
      *                                                               *
      *****************************************************************
      *
     C     ClrMsgQue     BEGSR
 
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C                   IF        ZAMSGF = *BLANKS
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   END
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM                          Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZAMSID                         Message Id
     C                   PARM                    ZAMSGF                         Message file
     C                   PARM                    ZAMSDA                         Message data
     C                   PARM                    ZAMSTP                         Message type
      *
     C                   MOVEL     *BLANKS       ZAMSGF
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAPGRL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *  Called by : Start of the program                             *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
     C                   PARM                    PAct
     C                   PARM                    PCmd
      *
      ** Call The Access Object AOBANKR0
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
     C                   EVAL      WScrn = 'P'
      *
     C                   EVAL      PMsgf = 'SDUSRMSG'
      *
      *
      ** Populate User
      *
     C                   EVAL      D0USER = PSUser
      *
      ** Populate WorkStation ID
      *
     C                   EVAL      D0WID = PsJobName
      *
      ** Populate Midas Run Date
      *
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   EVAL      *IN25 = *ON
     C                   EVAL      ZAPGM = PSProcName
     C                   EVAL      SPGM = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
