     H DEBUG                                                                                  244122
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AP Transaction validate and update adoption')    *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APADOPTVU - Transaction validate and update adoption         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CAP702             Date 12May20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD022060           Date 27Aug13               *
      *                 AR971184           Date 28May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 244122             Date 01DEC06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12784           Date 15Dec06               *
      *                 BUG8011            Date 04Aug05               *
      *                 BG7666             Date 27Jun05               *
      *                 BUG4646            Date 25Oct04               *
      *                 BUG2480            Date 26May04               *
      *                 BG2743             Date 15Dec03               *
      *                 BG1105             Date 15Dec03               *
      *                 CAP084  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP702 - 24x7 APIs - Common processing.                      *
      *  CSD102 - Password Length Extension                           *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022060 - Reverse fix BUG12784. It limits the system to     *
      *             retrieve a length beyond 4800 for buffer 2 and 3  *
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
      *  BUG2480 - Send the reservation id to the back end            *
      *  BG2743 - Error messages not being passed correctly           *
      *  BG1105 - Bug1105 Make MSGARROUT a variable length string     *
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
     D UpdateYN        S              1
     D*VarBuffer       S          32000    VARYING                                           BUG4646
     D VarBuffer       S          29997    VARYING                                           BUG4646
     D VarBuffer2      S          29997    VARYING                                           BUG4646
     D VarBuffer3      S          29997    VARYING                                           BUG4646
     D ReservId        S             15                                         BUG2480
     D*MsgArrOUT*******S           2000                                                       BG1105
     D VarMsgArrO      S          32000    VARYING                                            BG1105
     D APIRetC         S              1
     D***ApHead*         S            200                                            AR971184 CSD102
     D ApHead          S            318                                                       CSD102

     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')
     D Jobd24x7        DS            20                                         CAP702
     D Name24x7                1     10    INZ('MIDAS24X7 ')                    CAP702
     D Sys24x7                11     12                                         CAP702
     D Lib24x7                13     20    INZ('X24LIB  ')                      CAP702
      *                                                                         CAP702
     D*SCND24X7******E*DS                  EXTNAME(SCND24X7)                    CAP702
     D SCND24X7S     E DS                  EXTNAME(SCND24X7)                    CAP702
      *                                                                         CAP702
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP702
      *                                                                         CAP702
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CAP702
      *                                                                         CAP702
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
     C                   PARM                    UpdateYN
     C                   PARM                    VarBuffer
     C                   PARM                    VarBuffer2                                  BUG4646
     C                   PARM                    VarBuffer3                                  BUG4646
     C**********         PARM                    MsgArrOUT                                    BG1105
     C                   PARM                    VarMsgArrO                                   BG1105
     C                   PARM                    APIRetC
     C                   PARM                    ReservId                       BUG2480
     C                   PARM                    ApHead                                     AR971184

     C                   Eval      APIRetC = '1'
      *
     C                   Z-ADD     0             A                 3 0
     C                   Eval      A = %SCAN('MIDASCOB':APHEAD)                 CAP702
     C     A             IFGT      0                                            CAP702
      * Set up job description library list                                     CAP702
     C                   Call      'QWDRJOBD'                           9697    CAP702
     C                   Parm                    Parm                           CAP702
     C                   Parm                    Len                            CAP702
     C                   Parm      'JOBD0100'    Format           10            CAP702
     C                   Parm                    Jobd                           CAP702
     C                   Parm                    QUSEC                          CAP702
     C                   ELSE                                                   CAP702
      *                                                                         CAP702
     C     CAP702        IFEQ      'Y'                                          CAP702
     C***  *DTAARA       DEFINE                  SCND24X7                       CAP702
     C***                IN        SCND24X7                                     CAP702
     C     *DtaAra       Define    SCND24X7      SCND24X7S                      CAP702
     C                   In        SCND24X7S                                    CAP702
     C                   Move      NDMODE        SNMODE            5            CAP702
      * Set up job description library list                                     CAP702
      *                                                                         CAP702
      *
     C                   Move      System        Sys24x7                        CAP702
      *                                                                         CAP702
     C**** SCND24X7      IFEQ      'NIGHT'                                      CAP702
     C     SNMODE        IFEQ      'NIGHT'                                      CAP702
     C                   Call      'QWDRJOBD'                           9697    CAP702
     C                   Parm                    Parm                           CAP702
     C                   Parm                    Len                            CAP702
     C                   Parm      'JOBD0100'    Format           10            CAP702
     C                   Parm                    Jobd24x7                       CAP702
     C                   Parm                    QUSEC                          CAP702
     C                   ELSE                                                   CAP702
      * Set up job description library list                                     CAP702
     C                   Call      'QWDRJOBD'                           9697    CAP702
     C                   Parm                    Parm                           CAP702
     C                   Parm                    Len                            CAP702
     C                   Parm      'JOBD0100'    Format           10            CAP702
     C                   Parm                    Jobd                           CAP702
     C                   Parm                    QUSEC                          CAP702
     C                   ENDIF                                                  CAP702
      *                                                                         CAP702
      *
     C                   ELSE                                                   CAP702
      *
      * Set up job description library list
     C                   Call      'QWDRJOBD'                           9697
     C                   Parm                    Parm
     C                   Parm                    Len
     C                   Parm      'JOBD0100'    Format           10
     C                   Parm                    Jobd
     C                   Parm                    QUSEC
     C                   ENDIF                                                  CAP702
     C                   ENDIF                                                  CAP702
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
     C**********         Eval      %Len(VarBuffer) = 19633                         BUG12784 MD022060
     C                   EVAL      %LEN(VarBuffer) = 29997                                  MD022060
     C                   Eval      %Len(VarBuffer2) = 29997                                  BUG4646
     C                   Eval      %Len(VarBuffer3) = 29997                                  BUG4646
      * Set the buffer to the maximum required currently for API calls
     C                   MOVEL     VarBuffer     Buffer
     C**********         EVAL      Buffer2=%SUBST(VarBuffer:10000:9999)             BUG4646 BUG12784
     C**********         EVAL      Buffer3=%SUBST(VarBuffer:19999:9999)             BUG4646 BUG12784
     C**********         EVAL      Buffer2=%SUBST(VarBuffer:10034:4800)            BUG12784 MD022060
     C**********         EVAL      Buffer3=%SUBST(VarBuffer:14833:4800)            BUG12784 MD022060
     C                   EVAL      Buffer2=%SUBST(VarBuffer:10000:9999)                     MD022060
     C                   EVAL      Buffer3=%SUBST(VarBuffer:19999:9999)                     MD022060
     C                   EVAL      Buffer4=%SUBST(VarBuffer2:1:9999)                         BUG4646
     C                   EVAL      Buffer5=%SUBST(VarBuffer2:10000:9999)                     BUG4646
     C                   EVAL      Buffer6=%SUBST(VarBuffer2:19999:9999)                     BUG4646
     C                   EVAL      Buffer7=%SUBST(VarBuffer3:1:9999)                         BUG4646
     C                   EVAL      Buffer8=%SUBST(VarBuffer3:10000:9999)                     BUG4646
     C                   EVAL      Buffer9=%SUBST(VarBuffer3:19999:9999)                     BUG4646

      * Call the API Validate and update program
     C                   CALL      'APCTRANVU'
     C                   PARM                    Sys
     C                   PARM                    MidasUser
     C                   PARM                    Lang
     C                   PARM                    TransType
     C                   PARM                    UpdateYN
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
     C                   PARM                    ReservId                       BUG2480
     C                   PARM                    ApHead                                     AR971184

      * Set the variable buffer to have the smallest required length
     C                   MOVEL     Buffer        VarBuffer
     C**********         EVAL      %SUBST(VarBuffer:10000) = Buffer2                BUG4646 BUG12784
     C**********         EVAL      %SUBST(VarBuffer:10034) = Buffer2               BUG12784 MD022060
     C                   EVAL      %SUBST(VarBuffer:10000) = Buffer2                        MD022060
     C                             + Buffer3                                                 BUG4646
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

      * Set the variable message array to have the smallest required length                   BG1105
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

      ** Check for switchable feature CAP702                                    CAP702
     C                   Call      'AOSARDR0'                                   CAP702
     C                   Parm      *Blanks       @RTCD             7            CAP702
     C                   Parm      '*VERIFY'     @OPTN             7            CAP702
     C                   Parm      'CAP702'      @SARD             6            CAP702
     C     SCSARD        Parm      SCSARD        DSFDY                          CAP702
                                                                                CAP702
     C                   If        @RTCD = *Blanks                              CAP702
     C                   Movel     'Y'           CAP702            1            CAP702
     C                   Else                                                   CAP702
     C                   Movel     'N'           CAP702                         CAP702
     C                   EndIf                                                  CAP702
      *

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
