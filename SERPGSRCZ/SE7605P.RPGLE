     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Tax paid by basket detail rpt - prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7605P - Tax Paid by Basket Detail Report Prompt            *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user selection input of From Date and         *
      *             To Date.                                          *
      *                                                               *
      *  Component of: SE7605 Tax Paid by Basket Detail report        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189201             Date 25Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  189201 - Additional selection fields                         *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Allocations per dividend prompt screen
     FSE7605DF  CF   E             WORKSTN
                                                                                              189201
      ** Securities details                                                                   189201
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       189201
                                                                                              189201
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *    01         Chain fail on SECTY                             *                       189201
      *    20         Reverse image/position cursor on From date      *                       189201
      *    21         Reverse image/position cursor on To date        *                       189201
      *    22         Reverse image/position cursor on Security       *                       189201
      *    80         Protect fields.                                 *
      *                                                               *
      *    90         Field value is numeric.                         *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D POutFlds        DS           100
     D  FromDate               1      5  0
     D  ToDate                 6     10  0
     D  SecName               11     20                                                       189201
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ValNumber             90     90
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter descriptions
     D PMode           S              1A
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAction         S              1A
     D PCmd            S              1A
 
     D PRtcd           S              7A
     D POptn           S              7A
      *
      ** Index for arrays of error message IDs
     D IdX             S              3P 0
 
     D PMsgFl          S             10A   INZ('GBSEUSRMSG')
     D PMsgId          S             10A   INZ(*BLANKS)
 
     D WValidSelec     S              1A   INZ('N')
      *
      ** Parameters for ZDATE1
     D PDate           S              6A
     D PDaynoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
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
      ** Process inputs.
      *
     C                   EXSR      SRProc
      *
      ** Return.
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise variables                                *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   EVAL      FromDate = *ZEROS
     C                   EVAL      ToDate = *ZEROS
     C                   EVAL      SecName = *BLANKS                                          189201
     C                   EVAL      SFDAT = *BLANKS
     C                   EVAL      STDAT = *BLANKS
     C                   EVAL      SSECU = *BLANKS                                            189201
      *
      ** Set mode to I/C for report program.
      *
     C                   EVAL      PMode = '1'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
      *
     C                   DOU       WValidSelec = 'Y' OR *INKC = True
      *
      ** Write message subfile and footer screens.
      *
     C                   TIME                    STIME
     C                   WRITE     SE7605C1
     C                   WRITE     SE7605F1
      *
      ** Read details screen.
      *
     C                   EXFMT     SE7605D1
      *
      ** F3, selected.
     C                   IF        *INKC = *ON
 
     C                   EVAL      PCmd = 'E'
 
     C                   ELSE
      *
      ** Clear message subfile.
      *
     C                   CALL      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C***********        MOVEA     '00'          *IN(20)                                      189201
     C                   MOVEA     '000'         *IN(20)                                      189201
 
     C                   EXSR      SRVALIDATE
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = True
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate From Date and To Date                  *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
      *
     C                   EVAL      IdX = *ZEROS
      *
      ** Validate From Date.
      ** Must be numeric.
      *
     C                   TESTN                   SFDAT                90
 
     C                   IF        ValNumber = False
     C                   EVAL      *IN20 = True
     C                   EVAL      IdX = IdX +1
     C                   EVAL      PMsgId = 'SEA0421'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
      *
      ** Must be a valid date.
      *
     C                   MOVE      *BLANKS       PDate
     C                   MOVE      SFDAT         PDate
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      *IN20 = True
     C                   EVAL      IdX = IdX +1
     C                   EVAL      PMsgId = 'SEA0400'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
 
     C                   Z-ADD     PDaynoOut     FromDate
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate To Date.
      ** Must be numeric.
      *
     C                   TESTN                   STDAT                90
 
     C                   IF        ValNumber = False
     C                   EVAL      *IN21 = True
     C                   EVAL      IdX = IdX +1
     C                   EVAL      PMsgId = 'SEA0421'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
      *
      ** Must be a valid date.
      *
     C                   MOVE      *BLANKS       PDate
     C                   MOVE      STDAT         PDate
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      *IN21 = True
     C                   EVAL      IdX = IdX +1
     C                   EVAL      PMsgId = 'SEA0402'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
 
     C                   Z-ADD     PDaynoOut     ToDate
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        IdX = 0
     C                   IF        FromDate > ToDate
     C                   EVAL      *IN20 = True
     C                   EVAL      *IN21 = True
     C                   EVAL      IdX = IdX +1
     C                   EVAL      PMsgId = 'SEA0403'
     C                   EXSR      SRSndMsg
     C                   ENDIF
     C                   ENDIF
                                                                                              189201
      ** Security, if entered, must be a valid and live security                              189201
                                                                                              189201
     C                   EXSR      SRValSec                                                   189201
 
     C                   IF        IdX = 0
     C                   EVAL      WValidSelec = 'Y'
     C                   ELSE
     C                   EVAL      WValidSelec = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       189201
      *                                                               *                       189201
      *  SRValSec - Validate Security                                 *                       189201
      *                                                               *                       189201
      *****************************************************************                       189201
                                                                                              189201
     C     SRValSec      BEGSR                                                                189201
                                                                                              189201
     C                   IF        SSECU <> *Blanks                                           189201
                                                                                              189201
     C     SSECU         CHAIN     SECTYDF                            01                      189201
                                                                                              189201
     C                   IF        ((*IN01 = *On) OR                                          189201
     C                             (*IN01 = *Off) AND  (RECI <> 'D'))                         189201
     C                   EVAL      *IN22 = *On                                                189201
     C                   EVAL      IdX = IdX +1                                               189201
     C                   EVAL      PMsgId = 'SEA0430'                                         189201
     C                   EXSR      SRSndMsg                                                   189201
     C                   ELSE                                                                 189201
     C                   EVAL      SecName = SESN                                             189201
     C                   ENDIF                                                                189201
                                                                                              189201
     C                   ENDIF                                                                189201
                                                                                              189201
     C                   ENDSR                                                                189201
                                                                                              189201
      *****************************************************************                       189201
      /EJECT                                                                                  189201
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Send Message to Screen                            *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFl
     C                   PARM                    PMsgID
 
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
     C                   PARM                    PAction
     C                   PARM                    PCmd
      *
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     1             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SJOBNAME = PsJobName
     C                   EVAL      SDATE = BJMRDT                                             189201
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   EVAL      *IN99 = True
     C                   EVAL      SPGMQ = '*'
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
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
