     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Allocation per dividend report prompt')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7603P - Allocations per dividend payment Report Prompt     *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user selection input of Security, Date of     *
      *             payment and Event Type Report                     *
      *                                                               *
      *  Component of: SE7603 Allocations per dividend report         *
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
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security details file
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Allocations per dividend prompt screen
     FSE7603DF  CF   E             WORKSTN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *    80         Protect fields.                                 *
      *                                                               *
      *    90         Field value is numeric.                         *
      *                                                               *
      *    91         Record not found.                               *
      *    92         End of physical file reached.                   *
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
     D  SecSName               1     10A
     D  DateOPay              11     15  0
     D  EvenType              16     17A
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ValNumber             90     90
     D  RecNotFnd             91     91
     D  EndOfFile             92     92
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
 
     C                   EVAL      SecSName = *BLANKS
     C                   EVAL      DateOPay = *ZEROS
     C                   EVAL      EvenType = *BLANKS
     C                   EVAL      SPSSH = *BLANKS
     C                   EVAL      SPSVL = *BLANKS
     C                   EVAL      SPEVT = *BLANKS
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
     C                   WRITE     SE7603C1
     C                   WRITE     SE7603F1
      *
      ** Read details screen.
      *
     C                   EXFMT     SE7603D1
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
     C                   MOVEA     '000'         *IN(20)
 
     C                   EXSR      SRVALIDATE
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = True
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate date of payment                        *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
      *
     C                   EVAL      IdX = *ZEROS
      *
      ** Validate security short name.
      ** Must be a live security.
      *
     C     SPSSH         CHAIN     SECTY                              91
 
     C                   IF        RecNotFnd = True
     C                   EVAL      *IN20 = True
     C                   EVAL      IdX = IdX +1
     C                   EVAL      PMsgId = 'SEA0420'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      SecSName = SPSSH
     C                   ENDIF
      *
      ** Validate date of payment.
      ** Must be numeric.
      *
     C                   TESTN                   SPSVL                90
 
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
     C                   MOVE      SPSVL         PDate
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZEROS        PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
 
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      *IN21 = True
     C                   EVAL      IdX = IdX +1
     C                   EVAL      PMsgId = 'SEA0422'
     C                   EXSR      SRSndMsg
 
     C                   ELSE
 
     C                   Z-ADD     PDaynoOut     DateOPay
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate event type.
      ** If entered, event type must only be CP, DV or MT.
      *
     C                   IF        SPEVT <> 'CP' AND SPEVT <> 'DV' AND
     C                             SPEVT <> 'MA'
     C                   EVAL      *IN22 = True
     C                   EVAL      IdX = IdX +1
     C                   EVAL      PMsgId = 'SEA0423'
     C                   EXSR      SRSndMsg
     C                   ELSE
     C                   EVAL      EvenType = SPEVT
     C                   ENDIF
 
     C                   IF        IdX = 0
     C                   EVAL      WValidSelec = 'Y'
     C                   ELSE
     C                   EVAL      WValidSelec = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
