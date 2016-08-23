     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas-TI Swift Messages Router')
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      *  MS6200 - MidasPlus-TI Swift Messages Router                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CTI004 *CREATE     Date 12Apr04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           Routing Swift Messages                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
     FTIIMMSL0  IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Array containing Copyright statement
 
     D WCOND           S             65    DIM(20)
     D WCOND20         S             65    DIM(20)
     D WCOND21         S             65    DIM(20)
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
     D                 DS
     D  CR                     1      1    INZ(x'0d')
     D  LF                     2      2    INZ(x'25')
     D  CRLF                   1      2
 
      ** Declared variables
 
     D W1stChar        S              1
     D WLstChar        S              1
     D WMsgFound       S              1
     D WMsg            S             65
     D WChgHeader      S              1
     D W20Found        S              1
     D W21Found        S              1
     D WLength         S              3  0
     D WCOMA           S              3  0
     D WCount          S              3  0
     D WEnd            S              3  0
     D WLent           S              3  0
     D WLstPos         S              3  0
     D WStrt           S              3  0
     D WX              S              3  0
     D W20             S              3  0
     D W21             S              3  0
     D WContnt         S             65
     D WSearch         S             65
     D WTICOND         S             65
     D WTag            S              4
     D CPY2@           S             80
     D WPMTPY          S              3
 
      ** Declare Parameters
 
     D PMTPY           S              3
     D PMSDTA          S           9999
     D MSMDTA          S           9999
     D POKFLG          S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    PMTPY
     C                   PARM                    PMSDTA
     C                   PARM                    POKFLG
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@
 
      ** Check if incoming message satisfy the selection criteria
 
     C                   EXSR      SRChkMsg
 
      ** Terminate
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkMsg - Check if incoming message satisfy the selection    *
      *            criteria.                                          *
      *                                                               *
      *****************************************************************
     C     SRChkMsg      BEGSR
 
     C                   EVAL      WMsgFound = 'N'
 
      ** If message type is 123, look first for '123' in TIIMMSL0
 
     C                   MOVEL     PMTPY         WPMTPY
     C     WPMTPY        CHAIN     TIIMMSL0
     C                   IF        %FOUND(TIIMMSL0)
     C                   MOVEL     TICOND        WTICOND
     C                   EVAL      WMsgFound = 'Y'
     C                   ELSE
 
      ** If not found, check for 12*
 
     C                   MOVE      '*'           WPMTPY
     C     WPMTPY        CHAIN     TIIMMSL0
     C                   IF        %FOUND(TIIMMSL0)
     C                   MOVEL     TICOND        WTICOND
     C                   EVAL      WMsgFound = 'Y'
     C                   ELSE
 
      ** If still not found, check for 1*
 
     C                   MOVE      '* '          WPMTPY
     C     WPMTPY        CHAIN     TIIMMSL0
     C                   IF        %FOUND(TIIMMSL0)
     C                   MOVEL     TICOND        WTICOND
     C                   EVAL      WMsgFound = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If message type is found and TICOND is not blank, check tag
      ** conditions too.
 
     C                   IF        WMsgFound = 'Y' AND
     C                             WTICOND <> *BLANKS
 
     C                   Eval      MSMDTA = PMSDTA
 
     C                   EVAL      W20Found = 'N'
     C                   EVAL      W21Found = 'N'
 
      ** Check if tag 20 is in the criteria selection. Get the value if found
 
     C     ':20:'        SCAN      WTICOND       WStrt
     C                   IF        %FOUND
     C                   EVAL      W20Found = 'Y'
     C                   EVAL      WTAG = ':20:'
     C                   EXSR      SRGetCond
     C                   ENDIF
 
      ** Check if tag 21 is in the criteria selection. Get the value if found
 
     C     ':21:'        SCAN      WTICOND       WStrt
     C                   IF        %FOUND
     C                   EVAL      W21Found = 'Y'
     C                   EVAL      WTAG = ':21:'
     C                   EXSR      SRGetCond
     C                   ENDIF
 
      ** When tag 20 is found, check if message match the criteria selection
 
     C                   IF        W20Found = 'Y'
 
     C                   EVAL      WTAG = ':20:'
     C                   EVAL      WChgHeader = 'N'
     C                   EXSR      SRChkSelCrit
 
     C                   ENDIF
 
      ** When tag 21 is also found, reset change header flag and check if
      ** message match the criteria selection
 
     C                   IF        W21Found = 'Y' and
     C                             WChgHeader = 'Y'
 
     C                   EVAL      WTAG = ':21:'
     C                   EVAL      WChgHeader = 'N'
     C                   EXSR      SRChkSelCrit
 
     C                   ENDIF
 
     C                   IF        WChgHeader = 'Y'
     C                   EVAL      POKFLG = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        WMsgFound = 'Y' AND
     C                             WTICOND = *BLANKS
     C                   EVAL      POKFLG = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRChkSelCrit - Subroutine to check selection criteria in      *
      *                in Incoming Message Data.                      *
      *                                                               *
      *****************************************************************
     C     SRChkSelCrit  BEGSR
 
      ** Put the content of the tag in the incoming message to WMsg
 
     C     WTAG          SCAN      MSMDTA        WStrt
     C                   IF        %FOUND
     C                   EVAL      WStrt = WStrt + 4
     C     CRLF          SCAN      MSMDTA:WStrt  WEnd
     C                   EVAL      WLength = WEnd - WStrt
     C                   EVAL      WMsg = %SUBST(MSMDTA:WStrt:WLength)
 
      ** Retrieve multiple values that was stored in array WCOND20/WCOND21
 
     C                   IF        WTAG = ':20:'
     C                   EVAL      WX = W20
     C                   EVAL      WCOND = WCOND20
     C                   ELSE
     C                   EVAL      WX = W21
     C                   EVAL      WCOND = WCOND21
     C                   ENDIF
 
      ** Loop until checking of all values stored in array is done
 
     C                   EVAL      WCount = 1
     C                   DOW       WCount <= WX
 
      ** Determine the type of wild card by checking for 1st and last char
 
     C                   MOVEL     WCOND(WCount) W1stChar
     C     ' '           SCAN      WCOND(WCount) WLstPos
     C                   EVAL      WLstPos = WLstPos - 1
     C                   EVAL      WLstChar = %SUBST(WCOND(WCount):WLstPos:1)
 
      ** Select on the type of wild card (*, *a, a* and *a*)
 
     C                   SELECT
 
      ** When wild card is '*', move 'Y' to change header flag
 
     C                   WHEN      W1stChar = '*' AND WLstPos = 1
     C                   EVAL      WChgHeader = 'Y'
     C                   LEAVESR
 
      ** When wild card is '*a*', check if search string is within the
      ** content of the message but not at the beginning or the end.
      ** If condition is satisfied, move 'Y' to change header flag
 
     C                   WHEN      W1stChar = '*' AND WLstChar = '*'
     C                   EVAL      WLent = WLstPos - 2
     C                   EVAL      WSearch = %SUBST(WCOND(WCount):2:WLent)
     C     WSearch:WLent SCAN      WMsg          WStrt
     C     ' '           SCAN      WMsg          WEnd
     C                   IF        %FOUND AND WStrt <> 1 AND
     C                             (WEnd - WStrt) <> WLent
     C                   EVAL      WChgHeader = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** When wild card is '*a', check if search string is at the end of the
      ** message. If condition is satisfied, move 'Y' to change header flag.
 
     C                   WHEN      W1stChar = '*' AND WLstChar <> '*'
     C                   EVAL      WLent = WLstPos - 1
     C                   EVAL      WSearch = %SUBST(WCOND(WCount):2:WLent)
     C     WSearch:WLent SCAN      WMsg          WStrt
     C     ' '           SCAN      WMsg          WEnd
     C                   IF        %FOUND AND WStrt <> 1 AND
     C                             (WEnd - WStrt) = WLent
     C                   EVAL      WChgHeader = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** When wild card is 'a*', check if search string is at beginning of the
      ** message. If condition is satisfied, move 'Y' to change header flag.
 
     C                   WHEN      W1stChar <> '*' AND WLstChar = '*'
     C                   EVAL      WLent = WLstPos - 1
     C                   EVAL      WSearch = %SUBST(WCOND(WCount):1:WLent)
     C     WSearch:WLent SCAN      WMsg          WStrt
     C     ' '           SCAN      WMsg          WEnd
     C                   IF        %FOUND AND WStrt = 1 AND
     C                             (WEnd - WStrt) <> WLent
     C                   EVAL      WChgHeader = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** When search string does not contain a wildcard, it must match the
      ** message. If condition is satisfied, move 'Y' to change header flag.
 
     C                   WHEN      W1stChar <> '*' AND WLstChar <> '*'
     C                   IF        WCOND(WCount) = WMsg
     C                   EVAL      WChgHeader = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDSL
 
     C                   EVAL      WCount = WCount + 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * SRGetCond    - Get selection criteria for tag                 *
      *                                                               *
      *****************************************************************
     C     SRGetCond     BEGSR
     C                   EVAL      WStrt = WStrt + 4
 
      ** Determine the length of tag :20:/:21:'s content
 
     C     ':'           SCAN      TICOND:Wstrt  WEnd
     C                   IF        NOT %FOUND
     C     ' '           SCAN      TICOND:WStrt  WEnd
     C                   ENDIF
     C                   EVAL      WLength = WEnd - WStrt
 
      ** Determine content of the tag. If tag's content has multiple
      ** values, store them in array WCOND
 
     C                   EVAL      WContnt = %SUBST(TICOND:WStrt:WLength)
 
     C                   EVAL      WStrt = 1
     C     ','           SCAN      WContnt       WComa
     C                   EVAL      WX = 1
     C                   IF        %FOUND
 
     C                   DOW       %FOUND
     C                   EVAL      WLength = WComa - WStrt
     C                   EVAL      WCOND(WX) = %SUBST(WContnt:WStrt:WLength)
     C                   EVAL      WStrt = WComa + 1
     C     ','           SCAN      WContnt:WStrt WComa
     C                   IF        NOT %FOUND
     C     ' '           SCAN      WContnt:WStrt WComa
     C                   EVAL      WX = WX + 1
     C                   EVAL      WLength = WComa - WStrt
     C                   EVAL      WCOND(WX) = %SUBST(WContnt:WStrt:WLength)
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      WX = WX + 1
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      WCOND(WX) = WContnt
     C                   ENDIF
 
      ** Move contents of tag to array WCOND20/WCOND21
 
     C                   IF        WTAG = ':20:'
     C                   EVAL      W20 = WX
     C                   EVAL      WCOND20 = WCOND
     C                   ELSE
     C                   EVAL      W21 = WX
     C                   EVAL      WCOND21 = WCOND
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
**
(c) Misys International Banking Systems Ltd. 2004
