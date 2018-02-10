     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate rollover frequency')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVROLLFRQ - Validate rollover frequency                     *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             rollover frequency and confirms whether it has a  *
      *             valid value.                                      *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 243842             Date 29Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8582            Date 22Sep05               *
      *                 CDL016             Date 03Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  243842 - Display warning message when system is daily accrual*
      *  BUG8582- Rollover details should only be entered for         *
      *           fixed deposit deals.                                *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D TABFRQ          S              1    DIM(17) CTDATA PERRCD(17)
      **  Array to hold all valid rollover frequencies
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
     D WMsgid1         S                   LIKE(#MsgID)                                       243842
 
      ** Rollover Frequency received as a parameter
     D DDROFQ          S              1A
 
      ** Automatic rollover indicator received as a parameter
     D DDAURO          S              1A
 
      ** Automatic Rollover Switchable Feature indicator r'ced as a parm
     D S01434          S              1A
                                                                                              243842
      ** GELR Accrual Frequency                                                               243842
     D BKAPFQ          S              1A                                                      243842
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1                                      243842
 
      ** Only validate if Enhanced Rollovers processing switched on
 
     C     S01434        IFEQ      'Y'
 
      ** If Automatic Rollover is Y
      **  - It has to be input
      **  - It has to be a valid value
 
      ** If Automatic Rollover is A                                                           CDL016
      **  - It can be input                                                                   CDL016
      **  - It can be left blank                                                              CDL016
                                                                                              CDL016
     C     DDAURO        IFEQ      'Y'
     C     DDAURO        OREQ      'A'                                                        CDL016
 
     C     DDROFQ        IFEQ      *BLANKS
     C     DDAURO        ANDEQ     'Y'                                                        CDL016
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0624'     Msgid1
     C                   ELSE
 
     C     DDROFQ        IFNE      *BLANKS                                                    CDL016
     C     DDROFQ        LOOKUP    TABFRQ                                 82
     C     *IN82         IFEQ      '0'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0625'     Msgid1
     C                   END
                                                                                              243842
     C     *IN82         IFEQ      '1'                                                        243842
     C     DDROFQ        ANDEQ     'A'                                                        243842
                                                                                              243842
     C     BKAPFQ        IFEQ      'D'                                                        243842
     C                   EVAL      WarnFound = 'Y'                                            243842
     C                   MOVEL     'MMM9201'     WMsgid1                                      243842
     C                   ENDIF                                                                243842
     C     BKAPFQ        IFEQ      'W'                                                        243842
     C                   EVAL      WarnFound = 'Y'                                            243842
     C                   MOVEL     'MMM9202'     WMsgid1                                      243842
     C                   ENDIF                                                                243842
     C     BKAPFQ        IFEQ      'F'                                                        243842
     C                   EVAL      WarnFound = 'Y'                                            243842
     C                   MOVEL     'MMM9203'     WMsgid1                                      243842
     C                   ENDIF                                                                243842
                                                                                              243842
     C                   ENDIF                                                                243842
                                                                                              243842
     C                   ENDIF                                                                CDL016
 
     C                   END
     C                   ELSE
 
      ** If Automatic Rollover is not Y
      **  - Field may not be entered
 
     C     DDROFQ        IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0626'     Msgid1
     C                   END
 
     C                   END
                                                                                             BUG8582
      ** Rollover day number should be blank if deal is not a fixed deposit deal             BUG8582
     C                   If        W_Deal_Type <> 'IP'                                       BUG8582
     C                             and W_Deal_Type <> 'IT'                                   BUG8582
     C                             and W_Deal_Type <> 'TD'                                   BUG8582
     C                             and W_Deal_Type <> 'TI'                                   BUG8582
     C                             and DDROFQ <> *blanks                                     BUG8582
     C                   EVAL      ErrorFound = 'Y'                                          BUG8582
     C                   MOVEL     'MMM0798'     Msgid1                                      BUG8582
     C                   EndIf                                                               BUG8582
                                                                                             BUG8582
     C                   ELSE
 
      ** Force field to blank if Enhanced Rollovers processing switched off
 
     C                   MOVE      *BLANKS       DDROFQ
     C                   END
                                                                                              243842
      ** If warning was found, set the return code appropriately                              243842
     C                   IF        WarnFound = 'Y'                                            243842
     C                   EVAL      RetCodeIn = 'Warning'                                      243842
     C                   ENDIF                                                                243842
 
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1                                      243842
     C                   PARM                    DDROFQ
     C                   PARM                    DDAURO
     C                   PARM                    S01434
     C                   PARM                    W_Deal_Type       2                         BUG8582
     C                   PARM                    BKAPFQ                                       243842
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** TABFRQ - Rollover Frequencies
ABDFGHKLMPQRSTWXY
