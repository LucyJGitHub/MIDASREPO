     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA System Value Amounts')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009692 - Midas SD Validate FATCA System Value Amounts      *
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
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR   - Initialisation Subroutine                         *
      *  *PSSR    - Error processing                                  *
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** System value High Value Account
     D HighSysVal      C                   'FATCAHighValAcc'
      ** System value Low Value Account (Individual)
     D SysVal1         C                   'FATCALowValAccIndiv'
      ** System value Low Value Account (Entity)
     D SysVal2         C                   'FATCALowValAccEntity'
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D SystemValData   DS           200
     D  SysValAmt              1     13
      *
     D MsgIDXArr       S              7A   DIM(99)
     D SystemValue     S             20A
     D ProcMode        S            190A
     D GenError        S              1A
     D Idx             S              2P 0
      *
      ** Parameters for AOSVALR0
      *
     D PRtcd           S              7A
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A
      *
     D PSVal1          DS           200
     D  PSVal113               1     13
     D PSVal2          DS           200
     D  PSVal213               1     13
 
      ** Parameters for ZALIGN
     D ZRTN            S              7
     D ZFIELD          S             16
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZAFLD           S             16
 
     D LowValInd       S             13  0
     D LowValEnt       S             13  0
     D HighValue       S             13  0
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Main Processing
      *
     C                   EVAL      ZADIG = 13
     C                   EVAL      ZADEC = 0
      *
      ** Check amount
     C                   EVAL      ZFIELD = SysValAmt
     C                   EXSR      SRAlgAmount
      *
      ** Invalid amount
     C                   IF        ZRTN <> *BLANKS
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR1510'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Check High Value Account against other system values
     C                   IF        SystemValue = HighSysVal
     C                   MOVE      ZAFLD         HighValue
      *
      ** Retrieve Low Value Account amounts
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SysVal1       PSValK1
     C                   PARM                    PSVal1
     C                   PARM      SysVal2       PSValK2
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10
      *
     C                   IF        PRTCD = *BLANKS
      *
      ** System value Low Value Account (Individual)
     C                   EVAL      ZFIELD = PSVal113
     C                   EXSR      SRAlgAmount
     C                   MOVE      ZAFLD         LowValInd
      *
      ** System value Low Value Account (Entity)
     C                   EVAL      ZFIELD = PSVal213
     C                   EXSR      SRAlgAmount
     C                   MOVE      ZAFLD         LowValEnt
      *
      ** The High Value Account must be greater than the Low Value
      ** Accounts (Individual and Entity)
     C                   IF        HighValue <  LowValInd OR
     C                             HighValue <  LowValEnt
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USS0274'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlgAmount - Align amount                                   *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRAlgAmount   BEGSR
      *
      ** Align amount
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAFLD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR       - Program Initialisation routine                *
      *                                                               *
      *  Called by:   - Implicitly on program activation              *
      *                                                               *
      *  Calls: None  -                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define the *Entry parameter list with the following parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    SystemValue
     C                   PARM                    SystemValData
     C                   PARM                    ProcMode
     c                   PARM                    GenError
     C                   PARM                    Idx
     C                   PARM                    MsgIDXArr
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically IF a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *  Called by:                                                       *
      *                                                                   *
      *  Calls: None                                                      *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   EVAL      GenError = 'Y'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
