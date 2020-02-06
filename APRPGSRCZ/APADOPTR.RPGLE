     H DEBUG                                                                                  244122
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AP Transaction Retrieve adoption program')       *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APADOPTR  - Transaction retrieve adoption program            *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022060           Date 27Aug13               *
      *                 AR1096230          Date 11Apr13               *
      *                 AR1060863          Date 06Apr13               *
      *                 AR971184           Date 28May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244122             Date 01DEC06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12784           Date 15Dec06               *
      *                 BUG8011            Date 04Aug05               *
      *                 BG7666             Date 27Jun05               *
      *                 BUG4646            Date 25Oct04               *
      *                 BG2743             Date 15Dec03               *
      *                 BG1105             Date 15Dec03               *
      *                 CSC021             Date 15Dec03               *
      *                 CAP084  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022060 - Reverse fix BUG12784 in APADOPTVU. It limits the  *
      *             system to retrieve a length beyond 4800 for       *
      *             buffer 2 and 3.                                   *
      *  AR1096230 - Apply Gems Fix#263824 to align field layout of   *
      *              SIRS transaction and be able to show Principal   *
      *              Change Schedule Details                          *
      *  AR1060863 - Deal irregular interest schedules lost           *
      *            - Applied for AR1097090                            *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  244122 - Allow for maximum library list entries on 250       *
      *           Also add DEBUG to h-spec so dump is produced on     *
      *           crash                                               *
      *  BUG12784 - Display Rate Change Date schedule during authorise*
      *  BUG8011 - Condition efficiency moves from BG7666             *
      *  BG7666 - Return buffers from Midas API call are inefficient  *
      *  BUG4646- Completion of SIRS api                              *
      *  BG2743 - Error messages not being passed correctly           *
      *  BG1105 - Bug1105 Make MSGARROUT a variable length string     *
      *  CSC021 - Increase Transaction ID to 300                      *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D MidasUser       S             10
     D Lang            S              2
     D TransType       S              4
     D AuthComp        S              1
     D FwdBack         S              1
     D**********TransID         S            100                                              CSC021
     D TransID         S            300                                                       CSC021
     D*VarBuffer       S          32000    VARYING                                           BUG4646
     D VarBuffer       S          29997    VARYING                                           BUG4646
     D VarBuffer2      S          29997    VARYING                                           BUG4646
     D VarBuffer3      S          29997    VARYING                                           BUG4646
     D*MsgArrOUT*******S           2000                                                       BG1105
     D VarMsgArrO      S          32000    VARYING                                            BG1105
     D APIRetC         S              1
     D ApHead          S            200                                                     AR971184
 
     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')
 
     D***Parm            DS          1000                                                    244122
     D Parm            DS          3200                                                      244122
     D OffSetB               361    364B 0
     D LibCountB             365    368B 0
 
     D***Len             S              4B 0 INZ(1000)                                       244122
     D Len             S              4B 0 INZ(3200)                                         244122
 
      * If this buffer needs to increase a separate parameter will need to be added
     D Buffer          S           9999
     D Buffer2         S           9999                                                      BUG4646
     D Buffer3         S           9999                                                      BUG4646
     D Buffer4         S           9999                                                      BUG4646
     D Buffer5         S           9999                                                      BUG4646
     D Buffer6         S           9999                                                      BUG4646
     D Buffer7         S           9999                                                      BUG4646
     D Buffer8         S           9999                                                      BUG4646
     D Buffer9         S           9999                                                      BUG4646
 
      * If this Message array needs to increase a separate parameter will need to be added    BG1105
     D MsgArrOut       S           9999    INZ(*BLANKS)                                       BG1105
                                                                                              BG1105
     D OffLen          S              9  0
     D OffSet          S              9  0
     D InLibl          S           2750
     D Command         S           2764
 
      * Error message format for retrieve jobd libl
     DQUSEC            DS
      *                                             Qus EC
     D QUSBPRV                 1      4B 0
      *                                             Bytes Provided
     D QUSBAVL                 5      8B 0
      *                                             Bytes Available
     D QUSEI                   9     15
      *                                             Exception Id
     D QUSERVED               16     16
      *                                             Reserved
      *QUSED01                17     17
      *                                             Varying length
     D QUSExcData             17     46
      *                                             Varying length field Exception Data
 
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C     System        PARM                    Sys               2
     C                   PARM                    MidasUser
     C                   PARM                    Lang
     C                   PARM                    TransType
     C                   PARM                    AuthComp
     C                   PARM                    FwdBack
     C                   PARM                    TransID
     C                   PARM                    VarBuffer
     C                   PARM                    VarBuffer2                                  BUG4646
     C                   PARM                    VarBuffer3                                  BUG4646
     C**********         PARM                    MsgArrOUT                                    BG1105
     C                   PARM                    VarMsgArrO                                   BG1105
     C                   PARM                    APIRetC
     C                   PARM                    ApHead                                     AR971184
 
     C                   Eval      APIRetC = '1'
      *
      * Set up job description library list
     C                   Call      'QWDRJOBD'                           9697
     C                   Parm                    Parm
     C                   Parm                    Len
     C                   Parm      'JOBD0100'    Format           10
     C                   Parm                    Jobd
     C                   Parm                    QUSEC
     C                   If        QUSEI = 'CPF9801' OR
     C                             QUSEI = 'CPF9810'
     C                   EVAL      APIRetC = '0'
     C**********         EVAL      MsgArrOUT = ':::Midas system job +                         BG1105
     C                   EVAL      VarMsgArrO = ':::Midas system job +                        BG1105
     C                             description not found:'
     C                   Return
     C                   Endif
     C                   If        QUSEI = 'CPF9802' OR
     C                             QUSEI = 'CPF9820'
     C                   EVAL      APIRetC = '0'
     C**********         EVAL      MsgArrOUT = ':::Not authorised to Midas +                  BG1105
     C                   EVAL      VarMsgArrO = ':::Not authorised to Midas +                 BG1105
     C                             system job description:'
     C                   Return
     C                   Endif
      *
     C                   Eval      OffSet = OffSetB + 1
     C                   Eval      OffLen = LibCountB * 11
     C                   Eval      InLibl = %SubSt(Parm:OffSet:OffLen)
     C                   Eval      Command = ('CHGLIBL LIBL(' +
     C                             InLibl + ')')
 
     C                   Call      'QCMDEXC'                              92
     C                   Parm                    Command
     C                   Parm      2764          Length           15 5
 
      * The VarBuffer field is of variable length so should be defined
      * prior to the move to the API buffer
     C**********         Eval      %Len(VarBuffer) = 32000                                   BUG4646
     C**********         Eval      %Len(VarBuffer) = 29997                          BUG4646 BUG12784
     C**********         Eval      %Len(VarBuffer) = 19633                        BUG12784 AR1096230
     C                   Eval      %Len(VarBuffer) = 29997                                 AR1096230
     C                   Eval      %Len(VarBuffer2) = 29997                                  BUG4646
     C                   Eval      %Len(VarBuffer3) = 29997                                  BUG4646
      * Set the buffer to the maximum required currently for API calls
     C                   MOVEL     VarBuffer     Buffer
     C**********         EVAL      Buffer2=%SUBST(VarBuffer:10000:9999)             BUG4646 BUG12784
     C**********         EVAL      Buffer3=%SUBST(VarBuffer:19999:9999)             BUG4646 BUG12784
     C**********         EVAL      Buffer2=%SUBST(VarBuffer:10034:4800)           BUG12784 AR1096230
     C**********         EVAL      Buffer3=%SUBST(VarBuffer:14833:4800)           BUG12784 AR1096230
     C**********         EVAL      Buffer2=%SUBST(VarBuffer:10000:9999)           AR1096230 MD022060
     C**********         EVAL      Buffer3=%SUBST(VarBuffer:19999:9999)           AR1096230 MD022060
     C                   EVAL      Buffer2=%SUBST(VarBuffer:10000:9998)                     MD022060
     C                   EVAL      Buffer3=%SUBST(VarBuffer:19999:9998)                     MD022060
     C                   EVAL      Buffer4=%SUBST(VarBuffer2:1:9999)                         BUG4646
     C                   EVAL      Buffer5=%SUBST(VarBuffer2:10000:9999)                     BUG4646
     C                   EVAL      Buffer6=%SUBST(VarBuffer2:19999:9999)                     BUG4646
     C                   EVAL      Buffer7=%SUBST(VarBuffer3:1:9999)                         BUG4646
     C                   EVAL      Buffer8=%SUBST(VarBuffer3:10000:9999)                     BUG4646
     C                   EVAL      Buffer9=%SUBST(VarBuffer3:19999:9999)                     BUG4646
 
      * Call the API Validate and update program
     C                   CALL      'APCTRANR'
     C                   PARM                    Sys
     C                   PARM                    MidasUser
     C                   PARM                    Lang
     C                   PARM                    TransType
     C                   PARM                    AuthComp
     C                   PARM                    FwdBack
     C                   PARM                    TransID
     C                   PARM                    Buffer
     C                   PARM                    Buffer2                                     BUG4646
     C                   PARM                    Buffer3                                     BUG4646
     C                   PARM                    Buffer4                                     BUG4646
     C                   PARM                    Buffer5                                     BUG4646
     C                   PARM                    Buffer6                                     BUG4646
     C                   PARM                    Buffer7                                     BUG4646
     C                   PARM                    Buffer8                                     BUG4646
     C                   PARM                    Buffer9                                     BUG4646
     C                   PARM                    MsgArrOUT
     C                   PARM                    APIRetC
     C                   PARM                    ApHead                                     AR971184
 
     C                   MoveL     Buffer        VarBuffer
     C**********         EVAL      %SUBST(VarBuffer:10000) = Buffer2                BUG4646 BUG12784
     C**********         EVAL      %SUBST(VarBuffer:10034) = Buffer2              BUG12784 AR1060863
     C**********                   + Buffer3                                       BUG4646 AR1060863
     C**********         EVAL      %SUBST(VarBuffer:10034) = Buffer2             AR1060863 AR1096230
     C**********         EVAL      %SUBST(VarBuffer:14833) = Buffer3             AR1060863 AR1096230
     C                   EVAL      %SUBST(VarBuffer:10000) = Buffer2                       AR1096230
     C                             + Buffer3                                               AR1096230
     C                   EVAL      VarBuffer2 = Buffer4 + Buffer5 +                          BUG4646
     C                                         Buffer6                                       BUG4646
     C                   EVAL      VarBuffer3 = Buffer7 + Buffer8  +                         BUG4646
     C                                         Buffer9                                       BUG4646
     C*******************Eval      VarBuffer = %trimr(VarBuffer)                             BUG4646
     C                   If        VarBuffer3 = *blanks                                      BUG8011
     C                   If        VarBuffer2 = *blanks                                      BUG8011
     C                   Eval      VarBuffer = %trimr(VarBuffer)                              BG7666
     C                   Endif                                                               BUG8011
     C                   Eval      VarBuffer2 = %trimr(VarBuffer2)                            BG7666
     C                   Endif                                                               BUG8011
     C                   Eval      VarBuffer3 = %trimr(VarBuffer3)                           BUG4646
 
     C                   Eval      %Len(VarMsgArrO) = %Len(MsgArrOut)                         BG2743
     C                   MoveL     MsgArrOut     VarMsgArrO                                   BG1105
     C                   Eval      VarMsgArrO = %trimr(VarMsgArrO)                            BG1105
                                                                                              BG1105
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /SPACE 5
      ****************************************************************
      *  Initialisation                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
      **--------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      APIRetC = '0'
     C                   EVAL      MsgArrOUT = ':::System error has +
     C                             occurred in Midas. Please inform +
     C                             a Midas System operator:'
     C                   RETURN
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2003
