     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate automatic rollover indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVAUTROLL - Validate automatic rollover indicator           *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             automatic rollover indicator and confirms         *
      *             whether it has a valid value.                     *
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
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 250359             Date 19Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8582            Date 22Sep05               *
      *                 BUG3846            Date 09Aug04               *
      *                 CDL016             Date 03Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250359 - Always default automatic rollover indicator to "N"  *
      *           even when CDL016 is ON.                             *
      *  BUG8582- Rollover details should only be entered for         *
      *           fixed deposit deals.                                *
      *  BUG3846- If CDL016 is ON alway default to 'Automatic'        *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  CGL011 - Collateral Processing for Midas                     *
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
 
      ** Automatic rollover indicator received as a parameter
     D DDAURO          S              1A
 
      ** Automatic Rollover Switchable Feature indicator r'ced as a parm
     D S01434          S              1A
 
     D CGL011          S              1A   IMPORT                                             CGL011
                                                                                              CGL011
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
     C*
     C** Only validate if Enhanced Rollovers processing switched on
     C*
     C     S01434        IFEQ      'Y'
 
     C*
     C***If*indicator*is*blank*default*to*'N'                                                BUG3846
     C*****DDAURO******* IFEQ      *BLANKS                                                   BUG3846
     C****************** MOVEL     'N'           DDAURO                                      BUG3846
     C****************** END                                                                 BUG3846
      *                                                                                       CDL016
      ** If CDL016 is ON and a Fixed Deposit Deal,                                            CDL016
      ** Automatic Rollover can also have a value of 'A'                                      CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
     C     W_Deal_Type   ANDEQ     'IT'                                                       CDL016
     C     CDL016        OREQ      'Y'                                                        CDL016
     C     W_Deal_Type   ANDEQ     'IP'                                                       CDL016
     C     CDL016        OREQ      'Y'                                                        CDL016
     C     W_Deal_Type   ANDEQ     'TD'                                                       CDL016
     C     CDL016        OREQ      'Y'                                                        CDL016
     C     W_Deal_Type   ANDEQ     'TI'                                                       CDL016
      *                                                                                      BUG3846
      ** If indicator is blank default to 'A'                                                BUG3846
     C     DDAURO        IFEQ      *BLANK                                                    BUG3846
     C**********         MOVEL     'A'           DDAURO                               BUG3846 250359
     C                   MOVEL     'N'           DDAURO                                       250359
     C                   ENDIF                                                               BUG3846
      *                                                                                       CDL016
     C     DDAURO        IFNE      'N'                                                        CDL016
     C     DDAURO        ANDNE     'Y'                                                        CDL016
     C     DDAURO        ANDNE     'A'                                                        CDL016
     C                   EVAL      ErrorFound = 'Y'                                           CDL016
     C                   MOVEL     'MMM0330'     Msgid1                                       CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
     C                   ELSE                                                                 CDL016
     C*                                                                                      BUG3846
     C** If indicator is blank default to 'N'                                                BUG3846
     C     DDAURO        IFEQ      *BLANKS                                                   BUG3846
     C                   MOVEL     'N'           DDAURO                                      BUG3846
     C                   ENDIF                                                               BUG3846
     C*
     C** Indicator must be 'Y' or 'N'
     C     DDAURO        IFNE      'N'
     C     DDAURO        ANDNE     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0622'     Msgid1
     C                   END
                                                                                              CDL016
     C                   ENDIF                                                                CDL016
 
      * Auto Rollover field should be 'N' if deal is not a fixed deposit deal                BUG8582
     C                   If        W_Deal_type <> 'IP'                                       BUG8582
     C                             and W_Deal_type <> 'IT'                                   BUG8582
     C                             and W_Deal_type <> 'TD'                                   BUG8582
     C                             and W_Deal_type <> 'TI'                                   BUG8582
     C                             and DDAURO <> 'N'                                         BUG8582
     C                   Eval      ErrorFound = 'Y'                                          BUG8582
     C                   MoveL     'MMM0798'     Msgid1                                      BUG8582
     C                   EndIf                                                               BUG8582
     C*
     C                   ELSE
      ** Force field to 'N' if Enhanced Rollovers processing switched off
     C                   MOVE      'N'           DDAURO
     C                   END
      *                                                                                       CGL011
      ** Perform further validation for Automatic Rollover indicator                          CGL011
      *                                                                                       CGL011
     C     CGL011        IfEq      'Y'                                                        CGL011
     C     W_Collateral  AndEq     'Y'                                                        CGL011
                                                                                              CGL011
     C     W_Deal_type   IfEq      'IT'                                                       CGL011
     C     W_Deal_type   OrEq      'CD'                                                       CGL011
     C     W_Deal_type   OrEq      'TD'                                                       CGL011
     C     W_Deal_type   OrEq      'CI'                                                       CGL011
     C     W_Deal_type   OrEq      'FT'                                                       CGL011
     C     W_Deal_type   OrEq      'DT'                                                       CGL011
     C     W_Deal_type   OrEq      'LT'                                                       CGL011
                                                                                              CGL011
     C     W_Deal_type   IfNe      'CD'                                                       CGL011
     C     W_Deal_type   OrNe      'DT'                                                       CGL011
     C     W_Deal_type   OrNe      'LT'                                                       CGL011
                                                                                              CGL011
     C     DDAURO        IfNe      'Y'                                                        CGL011
     C                   Eval      ErrorFound = 'Y'                                           CGL011
     C                   MoveL     'MMM0117'     Msgid1                                       CGL011
     C                   EndIf                                                                CGL011
                                                                                              CGL011
     C                   Else                                                                 CGL011
                                                                                              CGL011
     C     W_Maturity    IfEq      'Y'                                                        CGL011
     C                                                                                        CGL011
     C     DDAURO        IfNe      'Y'                                                        CGL011
     C                   Eval      ErrorFound = 'Y'                                           CGL011
     C                   MoveL     'MMM0117'     Msgid1                                       CGL011
     C                   EndIf                                                                CGL011
                                                                                              CGL011
     C                   EndIf                                                                CGL011
                                                                                              CGL011
     C                   EndIf                                                                CGL011
                                                                                              CGL011
     C                   EndIf                                                                CGL011
                                                                                              CGL011
     C                   EndIf                                                                CGL011
                                                                                              CGL011
     C*
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
     C                   PARM                    DDAURO
     C                   PARM                    S01434
     C                   Parm                    W_Collateral      1                          CGL011
     C                   Parm                    W_Deal_Type       2                          CGL011
     C                   Parm                    W_Maturity        1                          CGL011
     C                   Parm                    CDL016            1                          CDL016
 
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
