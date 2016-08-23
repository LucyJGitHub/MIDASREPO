     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate rollover day number')                *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVROLLDAY - Validate rollover day number                    *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             rollover day number and confirms whether it       *
      *             has a valid value.                                *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR798312           Date 15Jul11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG8582            Date 22Sep05               *
      *                 CDL016             Date 03Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR798312 - Rollover Day No. is required by system even if it *
      *             is not required by Rollover Frequency. Rollover   *
      *             Day No. will be validated when it is a numeric    *
      *             value and required by Rollover Frequency.         *
      *             (Child: AR798313)                                 *
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
 
     D TABFQ2          S              1    DIM(8) CTDATA PERRCD(8)
      **  Array to hold all rollover frequencies which need day numbers
 
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
 
      ** Rollover Day Number received as a parameter
     D DDRLDN          S              2A
 
      ** Rollover Frequency received as a parameter
     D DDROFQ          S              1A
 
      ** Automatic rollover indicator received as a parameter
     D DDAURO          S              1A
 
      ** Automatic Rollover Switchable Feature indicator r'ced as a parm
     D S01434          S              1A
                                                                                              CDL016
      ** CDL016 Switchable Feature indicator received as a parameter                          CDL016
     D CDL016          S              1A                                                      CDL016
 
      ** Work fields
     D @TEST           S              1A
     D @WK20           S              2P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      ** Only validate if Enhanced Rollovers processing switched on
     C     S01434        IFEQ      'Y'
     C     DDAURO        ANDNE     'A'                                                        CDL016
 
      ** Test for frequency that needs a day number
     C     DDROFQ        LOOKUP    TABFQ2                                 83
 
      ** Entry is only permitted if Automatic Rollover is Y
     C     DDAURO        IFEQ      'Y'
 
      ** If a frequency needing a day number was found
     C     *IN83         IFEQ      '1'
 
      ** Rollover Day Number has to be input if the Rollover
      ** Frequency requires a day number
     C     DDRLDN        IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0627'     Msgid1
     C                   ELSE
 
      ** Rollover Day Number has to be a number
      **  *IN62 or *IN63 On means that a the entry seemed valid, but some
      **    letters can get through this test
      **  *IN73 On means that a the entry is not a letter
      **  (*IN62 & *IN73) OR (*IN63 & *IN73) =valid, all 3 off =invalid
 
     C                   TESTN                   DDRLDN               6263
     C                   MOVE      DDRLDN        @TEST
     C                   TESTZ                   @TEST                    73
 
     C     *IN62         IFEQ      '0'
     C     *IN63         ANDEQ     '0'
     C     *IN73         OREQ      '0'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0628'     Msgid1
     C                   END
 
      ** Rollover Day Number has to be a valid day number
     C     *IN62         IFEQ      '1'
     C     *IN73         ANDEQ     '1'
     C     *IN73         OREQ      '1'
     C     *IN63         ANDEQ     '1'
     C                   MOVE      DDRLDN        @WK20
     C     @WK20         IFLT      0
     C     @WK20         ORGT      31
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0629'     Msgid1
     C                   END
     C                   END
 
     C                   END
     C                   ELSE
 
      ** Rollover Frequency does not require a day number therefore
      ** Rollover Day Number may not be input
     C     DDRLDN        IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0630'     Msgid1
     C                   END
 
     C                   END
     C                   ELSE
 
      ** May not be input if Automatic Rollover is No
     C     DDRLDN        IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0652'     Msgid1
     C                   END
 
     C                   END
     C                   ELSE
                                                                                              CDL016
      ** Only validate if Enhanced Rollovers processing switched on                           CDL016
      ** and Automatic Rollover = 'A'.                                                        CDL016
     C     S01434        IFEQ      'Y'                                                        CDL016
     C     DDAURO        ANDEQ     'A'                                                        CDL016
                                                                                              CDL016
      ** Test for frequency that needs a day number.                                        AR798312
                                                                                            AR798312
     C     DDROFQ        LOOKUP    TABFQ2                                 83                AR798312
                                                                                            AR798312
     C                   IF        *IN83 = *ON                                              AR798312
     C                             OR DDROFQ = *BLANKS                                      AR798312
     C                             AND DDRLDN <>  *BLANKS                                   AR798312
                                                                                            AR798312
      ** Rollover Day Number has to be a number                                               CDL016
      **  *IN62 or *IN63 On means that a the entry seemed valid, but some                     CDL016
      **    letters can get through this test                                                 CDL016
      **  *IN73 On means that a the entry is not a letter                                     CDL016
      **  (*IN62 & *IN73) OR (*IN63 & *IN73) =valid, all 3 off =invalid                       CDL016
                                                                                              CDL016
     C                   TESTN                   DDRLDN               6263                    CDL016
     C                   MOVE      DDRLDN        @TEST                                        CDL016
     C                   TESTZ                   @TEST                    73                  CDL016
                                                                                              CDL016
     C     *IN62         IFEQ      '0'                                                        CDL016
     C     *IN63         ANDEQ     '0'                                                        CDL016
     C     *IN73         OREQ      '0'                                                        CDL016
     C                   EVAL      ErrorFound = 'Y'                                           CDL016
     C                   MOVEL     'MMM0628'     Msgid1                                       CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
      ** Rollover Day Number has to be a valid day number                                     CDL016
     C     *IN62         IFEQ      '1'                                                        CDL016
     C     *IN73         ANDEQ     '1'                                                        CDL016
     C     *IN73         OREQ      '1'                                                        CDL016
     C     *IN63         ANDEQ     '1'                                                        CDL016
     C                   MOVE      DDRLDN        @WK20                                        CDL016
     C     @WK20         IFLT      0                                                          CDL016
     C     @WK20         ORGT      31                                                         CDL016
     C                   EVAL      ErrorFound = 'Y'                                           CDL016
     C                   MOVEL     'MMM0629'     Msgid1                                       CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
      ** Rollover day number should be blank if deal is not a fixed deposit deal             BUG8582
     C                   If        W_Deal_Type <> 'IP'                                       BUG8582
     C                             and W_Deal_Type <> 'IT'                                   BUG8582
     C                             and W_Deal_Type <> 'TD'                                   BUG8582
     C                             and W_Deal_Type <> 'TI'                                   BUG8582
     C                             and DDRLDN <> *blanks                                     BUG8582
     C                   EVAL      ErrorFound = 'Y'                                          BUG8582
     C                   MOVEL     'MMM0798'     Msgid1                                      BUG8582
     C                   EndIf                                                               BUG8582
     C                   ELSE                                                               AR798312
                                                                                            AR798312
      ** If Rollover Frequency is blank, Rollover day number                                AR798312
      ** should be present for DDAURO = "A".                                                AR798312
                                                                                            AR798312
     C                   IF        DDROFQ = *BLANKS                                         AR798312
     C                             AND DDRLDN = *BLANKS                                     AR798312
     C                   EVAL      ErrorFound = 'Y'                                         AR798312
     C                   MOVEL     '5045476'     Msgid1                                     AR798312
     C                   ELSE                                                               AR798312
                                                                                            AR798312
      ** Rollover Frequency does not require a day number. Therefore,                       AR798312
      ** Rollover Day Number may not be inputted.                                           AR798312
                                                                                            AR798312
     C                   IF        DDRLDN <> *BLANKS                                        AR798312
     C                   EVAL      ErrorFound = 'Y'                                         AR798312
     C                   MOVEL     'MMM0630'     Msgid1                                     AR798312
     C                   ENDIF                                                              AR798312
                                                                                            AR798312
     C                   ENDIF                                                              AR798312
     C                   ENDIF                                                              AR798312
                                                                                             BUG8582
     C                   ELSE                                                                 CDL016
 
      ** Force field to blank if Enhanced Rollovers processing switched off
     C                   MOVE      *BLANKS       DDRLDN
     C                   END
     C*
     C                   ENDIF                                                                CDL016
 
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
     C                   PARM                    DDRLDN
     C                   PARM                    DDROFQ
     C                   PARM                    DDAURO
     C                   PARM                    S01434
     C                   PARM                    W_Deal_Type       2                         BUG8582
 
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
(c) Misys International Banking Systems Ltd. 2001
** TABFQ2 - Rollover Frequencies requiring day numbers
BLMQRTXY
