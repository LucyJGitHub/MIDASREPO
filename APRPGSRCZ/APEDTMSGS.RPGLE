     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Edit Messages')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APEDTMSGS - Edit Messages                                    *
      *                                                               *
      *  Function: This module takes error and warning messages       *
      *            issued by the APIs and converts them into a        *
      *            single long string.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD024980           Date 26Mar14               *
      *  Prev Amend No. AR218328           Date 23Mar10               *
      *                 MD020915           Date 27Jun13               *
      *                 MD000091           Date 03May13               *
      *                 AR1049767          Date 25Oct12               *
      *                 AR994582           Date 02Jul12               *
      *                 AR896705           Date 19Jan12               *
      *                 AR874144           Date 06Dec11               *
      *                 CBF011             Date 04Jul11               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7970            Date 22Jul05               *
      *                 CLE106             Date 01Aug04               *
      *                 BUG3654            Date 12Jul04               *
      *                 BUG3407            Date 30Jun03               *
      *                 BG1105             Date 15Dec03               *
      *                 BG1639             Date 26Mar04               *
      *                 CAP084  *CREATE    Date 26Apr02               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024980 - Incomplete error description for Blocked and      *
      *             Refer DR and CR, Inactive, Bad debt, Bankrupt     *
      *  AR218328 - M+ is crashing when error messages are too long.  *
      *             Make sure that RPG pass only the right length     *
      *             of error messages that it can handle.             *
      *  MD020915 - A Serious Midas Error has occurred upon complete  *
      *             of NASP.                                          *
      *           - Introduce Monitor in the conversion subroutine    *
      *             so it will pass 'DATA NOT CONVERTIBLE' should     *
      *             there be an error.                                *
      *           - Java side catches this and display error without  *
      *             substitution.                                     *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1049767 - Invalid character displayed in error message     *
      *              (Child:AR1049768)                                *
      *  AR994582 - Display of warning message was doubled            *
      *  AR896705 - Incomplete Warning message displayed for NASP     *
      *  AR874144 - All dealing,securities trading,lending screens    *
      *             experience Serious Bankfusion Midas Errors        *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG7970 - Validation message is truncated                    *
      *  CLE106 - Syndications manager.                               *
      *  BUG3654- Serious error on call to APEDTMSGS                  *
      *  BG3407 - Make #MsgData as 45A in length.                     *
      *  BG1105 - Bug1105 Make MSGARROUT a variable length string     *
      *  BG1639 - Serious error on call to APEDTMSGS                  *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************
 
     D Lower           S              1    DIM(26) CTDATA PERRCD(26)
     D Upper           S              1    DIM(26) CTDATA PERRCD(26)
 
     D FLD             S              1    DIM(75)
 
     D CompMsgArr      S              1    DIM(3000)
 
     D*MsgLen***       C                   CONST(300)                                         CLE106
     D***MsgLen*         C                   CONST(1000)                              CLE106 BUG7970
     D MsgLen          C                   CONST(3000)                                       BUG7970
     D*MsgArrLen**     C                   CONST(2000)                                      AR218328
     D*MsgArrLenE*     C                   CONST(1990)                                      AR218328
     D MsgArrLen       C                   CONST(9999)                                      AR218328
     D MsgArrLenE      C                   CONST(9999)                                      AR218328
     D MsgNotF         C                   CONST('*ERROR - Message not found')
 
     D MsgArr          S              1    DIM(MsgArrLen)
     D Msg             S              1    DIM(MsgLen)
     D BF              S              3  0                                                    CBF011
     D RetCode         S              7                                                       CBF011
     D APIName         S             20                                                       CBF011
      ** Event Code Substitution Work Variables                                             MD000091
     D MsgDtaLen       S              2  0                                                  MD000091
     D DCount          S              2  0                                                  MD000091
     D TmpDta          S             45                                                     MD000091
     D CharDta         S              2                                                     MD000091
     D DtaValue        S             45                                                     MD000091
     D DDta            S              2  0                                                  MD000091
      ** Binary Char Data Structure                                                         MD000091
     D BinChar         DS                                                                   MD000091
     D   WBinChar              1      2                                                     MD000091
     D   WBin                  1      2B 0                                                  MD000091
      ** Message data  S
     D************ #MsgData        S             45A                                          BG1105
     D***#MsgData********S            600A                                            BG1105 BUG3407
     D #MsgData        S             45A                                                     BUG3407
 
      ** Message ID
     D #MsgID          S              7A
 
      ** Message ID for BF Event Codes                                                        CBF011
     D #MsgIDBF        S             50A                                                      CBF011
                                                                                              CBF011
      ** BF Event Codes                                                                       CBF011
     D #BFEvCd         S              8A                                                      CBF011
                                                                                              CBF011
      ** Field Name resized to 20A                                                            CBF011
     D #BFFldN         S             20A                                                      CBF011
                                                                                              CBF011
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
 
      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNamArr      S             10A   DIM(ArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of warning message data.
     D WMsgDtaArr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
      *                                                                                     AR994582
      ** Temporary warning message data.                                                    AR994582
      *                                                                                     AR994582
     D TWMsgDtaArr     S                   DIM(1)                                           AR994582
     D                                     LIKE(#MsgData)                                   AR994582
 
      ** Array of message files
     D MsgFileArr      S                   DIM(5)
     D                                     LIKE(FldNameArr)
     D/COPY WNCPYSRC,APH00064
 
      ** Array of input error message IDs for BF Event Codes                                  CBF011
     D MsgIDArrBF      S                   DIM(ArrayMax)                                      CBF011
     D                                     LIKE(#MsgIDBF)                                     CBF011
                                                                                              CBF011
      ** Array of input warning message IDs for BF Event Codes                                CBF011
     D WMsgIDArrBF     S                   DIM(ArrayMax)                                      CBF011
     D                                     LIKE(#MsgIDBF)                                     CBF011
                                                                                              CBF011
      ** Array of input error field names for BF Event Codes                                  CBF011
     D FldArrBF        S                   DIM(ArrayMax)                                      CBF011
     D                                     LIKE(#BFFldN)                                      CBF011
                                                                                              CBF011
      ** Array of input warning field names for BF Event Codes                                CBF011
     D WFldArrBF       S                   DIM(ArrayMax)                                      CBF011
     D                                     LIKE(#BFFldN)                                      CBF011
                                                                                              CBF011
      ** Array of output error message IDs for BF Event Codes                                 CBF011
     D BFEvcArr        S                   DIM(ArrayMax)                                      CBF011
     D                                     LIKE(#BFEvCd)                                      CBF011
                                                                                              CBF011
      ** Array of output warning message IDs for BF Event Codes                               CBF011
     D WBFEvcArr       S                   DIM(ArrayMax)                                      CBF011
     D                                     LIKE(#BFEvCd)                                      CBF011
                                                                                              CBF011
     C     *ENTRY        PLIST
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFileArr
     C******             PARM                    MsgArrOUT      2000                          BG1105
     C                   PARM                    MsgArrOUT      9999                          BG1105
     C                   PARM                    APIName                                      CBF011
     C/COPY WNCPYSRC,APH00065
 
      ** Move MsgId (7A) to BF Arrays (50A)                                                   CBF011
                                                                                              CBF011
     C                   Z-ADD     1             BF                                           CBF011
     C                   DOW       BF <= ArrayMax AND                                         CBF011
     C                             MsgIDArr(BF) <> *BLANK                                     CBF011
     C                   EVAL      MsgIDArrBF(BF) = MsgIDArr(BF)                              CBF011
     C                   EVAL      BF = BF + 1                                                CBF011
     C                   ENDDO                                                                CBF011
                                                                                              CBF011
     C                   Z-ADD     1             BF                                           CBF011
     C                   DOW       BF <= ArrayMax AND                                         CBF011
     C                             WMsgIDArr(BF) <> *BLANK                                    CBF011
     C                   EVAL      WMsgIDArrBF(BF) = WMsgIDArr(BF)                            CBF011
     C                   EVAL      BF = BF + 1                                                CBF011
     C                   ENDDO                                                                CBF011
      ** Move Field Names (10A) to BF Field Names (20A)                                       CBF011
                                                                                              CBF011
     C                   Z-ADD     1             BF                                           CBF011
     C                   DOW       BF <= ArrayMax AND                                         CBF011
     C                             FldNameArr(BF) <> *BLANK                                   CBF011
     C                   EVAL      FldArrBF(BF) = FldNameArr(BF)                              CBF011
     C                   EVAL      BF = BF + 1                                                CBF011
     C                   ENDDO                                                                CBF011
                                                                                              CBF011
     C                   Z-ADD     1             BF                                           CBF011
     C                   DOW       BF <= ArrayMax AND                                         CBF011
     C                             WFldNamArr(BF) <> *BLANK                                   CBF011
     C                   EVAL      WFldArrBF(BF) = WFldNamArr(BF)                             CBF011
     C                   EVAL      BF = BF + 1                                                CBF011
     C                   ENDDO                                                                CBF011
                                                                                              CBF011
      ** Call Retrieve BF Event Codes and use BF Event Codes                                  CBF011
                                                                                              CBF011
     C                   CALL      'ZABFRTVEVC'                                               CBF011
     C                   PARM      *BLANK        RetCode                                      CBF011
     C                   PARM                    APIName                                      CBF011
     C                   PARM                    FldArrBF                                     CBF011
     C                   PARM                    WFldArrBF                                    CBF011
     C                   PARM                    MsgIDArrBF                                   CBF011
     C                   PARM                    WMsgIDArrBF                                  CBF011
     C                   PARM                    BFEvcArr                                     CBF011
     C                   PARM                    WBFEvcArr                                    CBF011
                                                                                              CBF011
     C                   Z-ADD     1             LP                5 0
     C                   EXSR      EDIT_EMSG
     C                   EXSR      EDIT_WMSG
 
     C                   MOVEA     MsgArr        MsgArrOUT
                                                                                              BG1639
      *                                                                                       BG1639
      * Check that there is an end separator                                                  BG1639
     C     ' :'          CheckR    MsgArrOUT     EndPos            5 0    90                  BG1639
     C                   If        *IN90                                                      BG1639
     C                   If        EndPos = %Len(MsgArrOUT)                                   BG1639
     C                   Eval      %Subst(MsgArrOut:EndPos:1) = ':'                           BG1639
     C                   Else                                                                 BG1639
     C                   If        EndPos = %Len(MsgArrOUT) - 1                              BUG3654
     C                   If        %Subst(MsgArrOut:EndPos+1:1) <> ':'                        BG1639
     C                   Eval      %Subst(MsgArrOut:EndPos+1:1) = ':'                         BG1639
     C                   EndIf                                                                BG1639
     C                   Else                                                                BUG3654
     C                   If        %Subst(MsgArrOut:EndPos+1:1) <> ':'                       BUG3654
     C                             AND %Subst(MsgArrOut:EndPos+2:1) <> ':'                   BUG3654
     C                   Eval      %Subst(MsgArrOut:EndPos+1:1) = ':'                        BUG3654
     C                   EndIf                                                               BUG3654
     C                   EndIf                                                               BUG3654
     C                   EndIf                                                                BG1639
     C                   EndIf                                                                BG1639
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit Error Messages
      ********************************************************************
     C     EDIT_EMSG     BEGSR
 
     C                   Z-ADD     1             C                 2 0
     C     C             DOWLE     75
     C     FldNameArr(C) ANDNE     *BLANKS
     C     LP            ANDLT     MsgArrLenE
 
     C                   MOVEA     FldNameArr(C) FLD
     C                   EXSR      UC_FldName
     C                   MOVEA     FLD           FldNameArr(C)
 
     C                   MOVE      *BLANK        Msg
     C                   MOVEA     FldNameArr(C) FldName          10
     C                   MOVEA     FldName       Msg
     C                   Z-ADD     1             D                 3 0
     C     *BLANK        LOOKUP    Msg(D)                                 99
     C                   MOVEA     ':'           Msg(D)
     C                   ADD       1             D
                                                                                              CBF011
      ** Output BF Event Codes if available else output MsgID                                 CBF011
                                                                                              CBF011
     C                   IF        RetCode = '*NODATA'                                        CBF011
     C                   MOVEA     MsgIdArr(C)   #MsgID
     C                   MOVEA     #MsgID        Msg(D)
     C                   ELSE                                                                 CBF011
     C                   MOVEA     BFEvcArr(C)   #BFEvCd                                      CBF011
     C                   MOVEA     #BFEvCd       Msg(D)                                       CBF011
     C                   ENDIF                                                                CBF011
                                                                                              CBF011
     C     *BLANK        LOOKUP    Msg(D)                                 99
     C                   MOVEA     ':E:'         Msg(D)
     C                   ADD       3             D
 
     C                   IF        RetCode = '*NODATA'                                        CBF011
     C     MsgIdArr(C)   IFNE      *BLANKS                                                    CLE106
     C                   MOVEL     MsgIdArr(C)   @MSGID            7
     C                   MOVEL     MsgDtaArr(C)  @MSGDT           45
     C                   EXSR      GETMSG
     C                   MOVEA     CompMsg       Msg(D)
     C                   ELSE                                                                 CLE106
     C                   MOVEA     ' '           Msg(D)                                       CLE106
     C                   ENDIF                                                                CLE106
     C                   ELSE                                                                 CBF011
     C     MsgDtaArr(C)  IFNE      *BLANKS                                                    CBF011
     C**********         MOVEA     MsgDtaArr(C)  Msg(D)                             CBF011 AR1049767
     C                   CLEAR                   TWMsgDtaArr                               AR1049767
     C                   EVAL      TWMsgDtaArr(1) = MsgDtaArr(C)                           AR1049767
     C                   EXSR      CnvrtMsgDta                                              MD000091
     C                   MOVEA     TWMsgDtaArr(1)Msg(D)                                    AR1049767
     C                   ELSE                                                                 CBF011
     C                   MOVEA     ' '           Msg(D)                                       CBF011
     C                   ENDIF                                                                CBF011
     C                   ENDIF                                                                CBF011
 
     C                   EXSR      AddMsg2Arr
 
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit Warning Messages
      ********************************************************************
     C     EDIT_WMSG     BEGSR
 
     C                   Z-ADD     1             C                 2 0
     C     C             DOWLE     75
     C     WFldNamArr(C) ANDNE     *BLANKS
     C     LP            ANDLT     MsgArrLenE
 
     C                   MOVEA     WFldNamArr(C) FLD
     C                   EXSR      UC_FldName
     C                   MOVEA     FLD           WFldNamArr(C)
 
     C                   MOVE      *BLANK        Msg
     C                   MOVEA     WFldNamArr(C) FldName
     C                   MOVEA     FldName       Msg
     C                   Z-ADD     1             D
     C     *BLANK        LOOKUP    Msg(D)                                 99
     C                   MOVEA     ':'           Msg(D)
     C                   ADD       1             D
                                                                                              CBF011
      ** Output BF Event Codes if available else output MsgID                                 CBF011
                                                                                              CBF011
     C                   IF        RetCode = '*NODATA'                                        CBF011
     C                   MOVEA     WMsgIDArr(C)  #MsgID
     C                   MOVEA     #MsgID        Msg(D)
     C                   ELSE                                                                 CBF011
     C                   MOVEA     WBFEvcArr(C)  #BFEvCd                                      CBF011
     C**********         MOVEA     #BFEvCd       Msg                                 CBF011 AR874144
     C                   MOVEA     #BFEvCd       Msg(D)                                     AR874144
     C                   ENDIF                                                                CBF011
                                                                                              CBF011
     C     *BLANK        LOOKUP    Msg(D)                                 99
     C                   MOVEA     ':W:'         Msg(D)
     C                   ADD       3             D
 
     C                   IF        RetCode = '*NODATA'                                        CBF011
     C                   MOVEL     WMsgIDArr(C)  @MSGID            7
     C                   MOVEL     WMsgDtaArr(C) @MSGDT           45
     C                   EXSR      GETMSG
     C                   MOVEA     CompMsg       Msg(D)
     C                   ELSE                                                                 CBF011
     C     WMsgDtaArr(C) IFNE      *BLANKS                                                    CBF011
     C**********         MOVEA     MsgDtaArr(C)  Msg(D)                              CBF011 AR896705
     C**********         MOVEA     WMsgDtaArr(C) Msg(D)                            AR896705 AR994582
     C                   CLEAR                   TWMsgDtaArr                                AR994582
     C                   EVAL      TWMsgDtaArr(1) = WMsgDtaArr(C)                           AR994582
     C                   EXSR      CnvrtMsgDta                                              MD000091
     C                   MOVEA     TWMsgDtaArr(1)Msg(D)                                     AR994582
     C                   ELSE                                                                 CBF011
     C                   MOVEA     ' '           Msg(D)                                       CBF011
     C                   ENDIF                                                                CBF011
     C                   ENDIF                                                                CBF011
 
     C                   EXSR      AddMsg2Arr
 
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Get Messages
      ********************************************************************
     C     GETMSG        BEGSR
      *
     C                   Eval      CompMsg = *Blank
     C**********         Z-Add     1             M                 2 0                        CER059
     C**********         Eval      #MsgFile = MsgFileArr(M)                                   CER059
     C                   Z-Add     *Zeros        M                 2 0                        CER059
     C                   DoU       CompMsg <> *Blank or
     C                             #Msgfile = *Blank or
     C                             M = 5
     C/COPY WNCPYSRC,APH00066
     C**********         EXSR      ZAMSGRTVMS                                                 CER059
     C                   Add       1             M
     C/COPY WNCPYSRC,APH00067
     C                   Eval      #MsgFile = MsgFileArr(M)
     C/COPY WNCPYSRC,APH00068
     C                   EXSR      ZAMSGRTVMS                                                 CER059
     C                   EndDo
      *
      * If message not found, report this
     C                   If        CompMsg = *Blank
     C                   Eval      CompMsg = MsgNotF
     C                   EndIf
 
      * Replace any colons in the message with semi-colons as the colon
      * will be used as a separator
     C                   MOVEA     CompMsg       CompMsgArr
     C     *in99         DOUEQ     '0'
     C                   Z-ADD     1             X                 4 0
     C     ':'           LOOKUP    CompMsgArr(X)                          99    *
     C   99              MOVEL     ';'           CompMsgArr(X)
     C                   ENDDO
     C                   MOVEA     CompMsgArr    CompMsg
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Retrieve Messages From Message File
      ********************************************************************
     C     ZAMSGRTVMS    BEGSR
 
     C                   CALLB     'ZAMSGRTVMS'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM      *BLANK        CompMsg        3000
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
     C                   PARM                    #MsgFile         10
     C                   PARM      '*LIBL  '     #MsgFLib         10
     C                   PARM      '0'           Level             1
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Add Messages to Array
      ********************************************************************
     C     AddMsg2Arr    BEGSR
      *
      * Get the total length of the message and add a separator
     C                   Clear                   CompMsg
     C                   MOVEA     Msg           CompMsg
     C                   Z-Add     0             Posn              3 0
     C                   Eval      Posn = %CheckR(' ':CompMsg)
     C                   Add       1             Posn
     C                   If        Posn > MsgLen
     C                   Eval      Posn = MsgLen
     C                   EndIf
     C                   Eval      Msg(Posn) = ':'
 
      *                                                                                     AR218328
      ** Do not add message if it will exceed the total length of string                    AR218328
      *                                                                                     AR218328
     C                   If        MsgArrLenE < Posn + LP                                   AR218328
     C                   Eval      LP = MsgArrLenE                                          AR218328
     C                   Else                                                               AR218328
     C                   MOVEA     Msg           MsgArr(LP)
     C                   ADD       Posn          LP
     C                   Endif                                                              AR218328
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert Field Name to Upper Case
      ********************************************************************
     C     UC_FldName    BEGSR
     C                   Z-ADD     1             Cnt               3 0
     C     Cnt           DOUGT     75
     C                   Z-ADD     1             Num               3 0
     C     FLD(Cnt)      LOOKUP    Lower(Num)                             99
     C   99              MOVEL     Upper(Num)    FLD(Cnt)
     C                   ADD       1             Cnt
     C                   ENDDO
     C                   ENDSR
      ********************************************************************                  MD000091
      /SPACE 5                                                                              MD000091
      ********************************************************************                  MD000091
      * Convert Message Data to Decimal for Error Substitution                              MD000091
      ********************************************************************                  MD000091
     C     CnvrtMsgDta   BEGSR                                                              MD000091
     C                   EVAL      MsgDtaLen = %LEN(%TRIM(TWMsgDtaArr(1)))                  MD000091
     C                   EVAL      DCount = 1                                               MD000091
     C                   EVAL      TmpDta = *BLANKS                                         MD024980
     C                   MONITOR                                                            MD020915
     C                   DOW       DCount < MsgDtaLen                                       MD000091
     C                   EVAL      WBinChar = %SUBST(TWMsgDtaArr(1):DCount:2)               MD000091
     C                   EVAL      DDta = %DEC(WBin:2:0)                                    MD000091
     C                   EVAL      DCount = DCount + 2                                      MD000091
     C                   EVAL      DtaValue = %SUBST(TWMsgDtaArr(1):DCount:DDta)            MD000091
     C                   MOVE      DDta          CharDta                                    MD000091
     C                   EVAL      TmpDta = %TRIM(TmpDta) + CharDta +                       MD000091
     C                                      DtaValue                                        MD000091
     C                   EVAL      DCount = DCount + DDta                                   MD000091
     C                   ENDDO                                                              MD000091
     C                   CLEAR                   TWMsgDtaArr(1)                             MD000091
     C                   EVAL      TWMsgDtaArr(1) = TmpDta                                  MD000091
     C                   ON-ERROR                                                           MD020915
     C                   EVAL      TWMSgDtaArr(1) = 'DATA NOT CONVERTIBLE'                  MD020915
     C                   ENDMON                                                             MD020915
     C                   ENDSR                                                              MD000091
      *****************************************************************
      /SPACE 5
      *****************************************************************
** Lower
abcdefghijklmnopqrstuvwxyz
** Upper
ABCDEFGHIJKLMNOPQRSTUVWXYZ
