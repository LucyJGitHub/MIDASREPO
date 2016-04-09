     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Format Data for a Indiv. Forecast Wip Msg')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GL010000 - Format Data for a WIP Message - indiv. Forecast  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD025783           Date 19May14               *
      *  Prev Amend No. MD024362           Date 14Jan14               *
      *                 MD023712 *Create   Date 30Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025783 - FORI and SBJB message structure enhancement.      *
      *             Replaced the following compile time arrays from:  *
      *             1. 'for:createHeaderRequest' to 'for:header'      *
      *             2. '/for:createHeaderRequest' to '/for:header'    *
      *             3. 'for:createUserExtensionRequest' to            *
      *                'for:userExtension'                            *
      *             4. '/for:createUserExtensionRequest' to           *
      *                '/for:userExtension'                           *
      *             5. 'keys:forecastKeysRequest' to                  *
      *                'for:forecastKeys'                             *
      *             6. '/keys:forecastKeysRequest' to                 *
      *                '/for:forecastKeys'                            *
      *             7. 'details:forecastDetailsRequest' to            *
      *                'for:forecastDtls'                             *
      *             8. '/details:forecastDetailsRequest' to           *
      *                '/for:forecastDtls'                            *
      *             9. 'amount:forecastAmount' to 'for:amount'        *
      *             10. '/amount:forecastAmount' to '/for:amount'     *
      *             11. 'amount:actualAmount' to 'for:actualAmount'   *
      *             12. '/amount:actualAmount' to '/for:actualAmount' *
      *             Removed the following compile time arrays:        *
      *             1. 'for:createRequest'                            *
      *             2. '/for:createRequest'                           *
      *             3. 'for:updateHeaderRequest'                      *
      *             4. '/for:updateHeaderRequest'                     *
      *             5. 'for:updateRequest'                            *
      *             6. '/for:updateRequest'                           *
      *             7. 'for:updateUserExtensionRequest'               *
      *             8. '/for:updateUserExtensionRequest'              *
      *             Added the following compile time arrays:          *
      *             1. 'for:custKey                                   *
      *             2  'for:retailAcct                                *
      *             3  '/for:custKey                                  *
      *             4  '/for:retailAcct                               *
      *  MD024362 - Subsidiaries Daily Sweeping Forecasts             *
      *             Amendment of GLFORITD and GLFORTTD does not work  *
      *             Missing coding records since last version         *
      *  MD023712 - Subsidiaries Daily Sweeping Forecasts             *
      *             Update of Actual Amounts against Forecasts        *
      *             from the Accounting Rules Process                 *
      *                                                               *
      *****************************************************************
 
     D                 DS
     D Msg                     1  32000    DIM(32000)
 
     D #_FieldTag      S            300A   DIM(999)
     D #_FieldData     S           1000A   DIM(999)
     D #_FieldType     S             10A   DIM(999)
     D #_FieldAttr     S             10A   DIM(999)
 
     D                 DS
     D WrkData                 1   1000
     D WD                      1   1000    DIM(1000)
 
     D****NARJMS          S             30    DIM(11) CTDATA PERRCD(1)                      MD024362
     D****NA2JMS          S             30    DIM(10) CTDATA PERRCD(1)                      MD024362
     D********** NARJMS          S             30    DIM(14) CTDATA PERRCD(1)      MD024362 MD025783
     D********** NA2JMS          S             30    DIM(13) CTDATA PERRCD(1)      MD024362 MD025783
     D NARJMS          S             30    DIM(12) CTDATA PERRCD(1)                         MD025783
     D NA2JMS          S             30    DIM(11) CTDATA PERRCD(1)                         MD025783
 
     D                 DS
     D ZFL15                   1     15  0
     D ZF15                    1     15    DIM(15)
 
     D F1              S             26    INZ('<midasActionAPI apiNames="')
     D F2              S             17    INZ('</midasActionAPI>')
 
     D CHAPTAG         S            300
 
     D                 DS
     D ZOUT21                  1     21
     D ZOUT21Sign             21     21
     D ZOUT21Edit              1     22
     D ZOUT21Digit             1     20
 
     C     *ENTRY        PLIST
      ** IN
     C                   PARM                    p@Mode           10
     C                   PARM                    p@apiNames      100
     C                   PARM                    p@Format        100
     C                   PARM                    p@FieldTag      300
     C                   PARM                    p@FieldData    1000
     C                   PARM                    p@FieldType      10
     C                   PARM                    p@FieldAttr      10
      ** OUT
     C                   PARM                    p@msgbuf      32000
 
     C                   SELECT
     C     p@Mode        WHENEQ    '*CLEAR'
     C                   Z-ADD     1             Z                 4 0
     C                   MOVEL     *BLANK        #_FieldTag
     C                   MOVEL     *BLANK        #_FieldData
     C                   MOVEL     *BLANK        #_FieldType
     C                   MOVEL     *BLANK        #_FieldAttr
 
     C     p@Mode        WHENEQ    '*ENTER'
     C                   MOVEL     p@FieldTag    #_FieldTag(Z)
     C                   MOVEL     p@FieldData   #_FieldData(Z)
     C                   MOVEL     p@FieldType   #_FieldType(Z)
     C                   MOVEL     p@FieldAttr   #_FieldAttr(Z)
     C                   MOVEL     *BLANK        p@FieldTag
     C                   MOVEL     *BLANK        p@FieldData
     C                   MOVEL     *BLANK        p@FieldType
     C                   MOVEL     *BLANK        p@FieldAttr
     C                   ADD       1             Z
 
     C     p@Mode        WHENEQ    '*UPDATE'                                                MD024362
     C                   MOVEL     p@FieldTag    #_FieldTag(Z)                              MD024362
     C                   MOVEL     p@FieldData   #_FieldData(Z)                             MD024362
     C                   MOVEL     p@FieldType   #_FieldType(Z)                             MD024362
     C                   MOVEL     p@FieldAttr   #_FieldAttr(Z)                             MD024362
     C                   MOVEL     *BLANK        p@FieldTag                                 MD024362
     C                   MOVEL     *BLANK        p@FieldData                                MD024362
     C                   MOVEL     *BLANK        p@FieldType                                MD024362
     C                   MOVEL     *BLANK        p@FieldAttr                                MD024362
     C                   ADD       1             Z                                          MD024362
                                                                                            MD024362
     C                   OTHER
     C                   MOVE      *BLANK        Msg
     C                   EXSR      LOAD_MSG
     C                   MOVEA     Msg           p@msgbuf
     C                   ENDSL
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
     C**   LOAD_MSG                                                   *
      *                                                               *
      *****************************************************************
 
     C     LOAD_MSG      BEGSR
 
     C                   Z-ADD     1             X                 4 0
 
      ** Loop through all fields
 
     C                   Z-ADD     1             R                 3 0
     C     #_FieldTag(R) DOWNE     *BLANK
 
      ** Start tag for field
 
     C                   EXSR      STARTofFLDTAG
 
     C                   MOVEA     #_FieldData(R)WrkDATA
     C                   MOVEA     #_FieldAttr(R)WrkATTR          10
 
      ** Date, amount or other
 
     C**********     #_FieldType(R)IFEQ      'keys:date'                                    MD025783
     C     #_FieldType(R)IFEQ      'for:date'                                               MD025783
     C                   EXSR      DET_DATE
     C                   ELSE
     C     #_FieldType(R)IFEQ      '*AMOUNT'
     C                   EXSR      DET_AMOUNT
     C                   ELSE
     C     #_FieldType(R)IFEQ      '*DRCRAMNT'
     C                   EXSR      DET_DRCRAMNT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEA     WrkDATA       Msg(X)
 
     C                   EXSR      DET_EoDATA
     C                   ADD       Size          X
 
      ** End tag for field
 
     C                   EXSR      ENDofFLDTAG
 
     C                   ADD       1             R
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   STARTofFMT                                                 *
      *                                                               *
      *****************************************************************
 
     C     STARTofFMT    BEGSR
     C     #_FieldTag(1) IFNE      NARJMS(1)
     C                   MOVEA     '<'           Msg(X)
     C                   ADD       1             X
     C                   MOVEA     p@Format      Msg(X)
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   MOVEL     '>'           Msg(X)
     C                   ADD       1             X
     C                   END
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   STARTofFLDTAG                                              *
      *                                                               *
      *****************************************************************
 
     C     STARTofFLDTAG BEGSR
     C                   MOVEL     '<'           Msg(X)
     C                   ADD       1             X
     C                   MOVEL     #_FieldTag(R) WrkFldTag       300
     C                   MOVEA     WrkFldTag     Msg(X)
     C                   MOVE      'Y'           Continue          1
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   DOW       Continue = 'Y'
     C                   Z-ADD     X             J                 4 0
     C                   EVAL      J = J + 1
     C                   If        Msg(J) = *Blanks
     C                   Eval      Continue = 'N'
     C                   Else
     C                   EVAL      X = J
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   Endif
     C                   ENDDO
     C                   MOVEL     '>'           Msg(X)
     C                   ADD       1             X
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   ENDofFLDTAG                                                *
      *                                                               *
      *****************************************************************
 
     C     ENDofFLDTAG   BEGSR
      *
      ** Loop through all Narratives
 
     C                   Z-ADD     1             Y                 2 0
     C*****Y             DOWLT     12                                                       MD024362
     C**********     Y             DOWLT     15                                    MD024362 MD025783
     C     Y             DOWLT     13                                                       MD025783
     C                   EVAL      CHAPTAG  = NARJMS(Y)
     C                   MOVE      0             F                 4 0
     C                   EVAL      F =%SCAN(%Trim(CHAPTAG):%Trim(#_FieldTag(R)))
     C     1             IFNE      F
     C                   ADD       1             Y
     C                   ELSE
     C                   Goto      NEXTCHAP
     C                   END
      *
     C                   ENDDO
      *
      ** Loop through all end of Narratives
 
     C                   Z-ADD     1             V                 2 0
     C*****V             DOWLT     11                                                       MD024362
     C**********     V             DOWLT     14                                    MD024362 MD025783
     C     V             DOWLT     12                                                       MD025783
     C                   EVAL      CHAPTAG  = NA2JMS(V)
     C                   MOVE      0             F
     C                   EVAL      F =%SCAN(%Trim(CHAPTAG):%Trim(#_FieldTag(R)))
     C     1             IFNE      F
     C                   ADD       1             V
     C                   ELSE
     C                   Goto      NEXTCHAP
     C                   END
      *
     C                   ENDDO
      *
     C                   MOVEA     '</'          Msg(X)
     C                   ADD       2             X
     C                   MOVEL     #_FieldTag(R) WrkFldTag
     C                   MOVEA     WrkFldTag     Msg(X)
     C                   MOVE      'Y'           Continue
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   DOW       Continue = 'Y'
     C                   Z-ADD     X             J
     C                   EVAL      J = J + 1
     C                   If        Msg(J) = *Blanks
     C                   Eval      Continue = 'N'
     C                   Else
     C                   EVAL      X = J
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   Endif
     C                   ENDDO
     C                   MOVEL     '>'           Msg(X)
     C                   ADD       1             X
      *
     C     NEXTCHAP      TAG
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      **   DET_DATE                                                   *
      *                                                               *
      *****************************************************************
 
     C     DET_DATE      BEGSR
     C                   MOVEL     WrkData       ZDAYNO
     C                   MOVEL     WrkAttr       BJDFIN
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVEL     *BLANK        WrkData
     C                   MOVEL     ZADATE        WrkData
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   DET_AMOUNT                                                 *
      *                                                               *
      *****************************************************************
 
     C     DET_AMOUNT    BEGSR
 
     C                   EXSR      DET_EoDATA
     C                   Z-ADD     *ZERO         ZFL15
     C                   Z-ADD     15            Ix                2 0
     C     SIZE          DOUEQ     0
     C     Ix            OREQ      0
     C                   MOVE      WD(Size)      ZF15(Ix)
     C                   SUB       1             Size
     C                   SUB       1             Ix
     C                   ENDDO
 
     C                   Z-ADD     ZFL15         ZFLD15
 
     C                   MOVEL     WrkAttr       ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   MOVEL     *BLANK        WrkData
     C                   MOVEL     ZOUT21        WrkData
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   DET_DRCRAMNT                                               *
      *                                                               *
      *****************************************************************
 
     C     DET_DRCRAMNT  BEGSR
 
     C                   EXSR      DET_EoDATA
     C                   Z-ADD     *ZERO         ZFL15
     C                   Z-ADD     15            Ix
     C     SIZE          DOUEQ     0
     C     Ix            OREQ      0
     C                   MOVE      WD(Size)      ZF15(Ix)
     C                   SUB       1             Size
     C                   SUB       1             Ix
     C                   ENDDO
 
     C                   Z-ADD     ZFL15         ZFLD15
 
     C                   MOVEL     WrkAttr       ZDECS
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZOUT21
     C     ZOUT21Sign    IFEQ      '-'
     C                   MOVE      'CR'          ZOUT21Edit
     C                   ELSE
     C                   MOVE      'DR'          ZOUT21Edit
     C                   ENDIF
     C                   MOVEL     *BLANK        WrkData
     C                   MOVEL     ZOUT21Edit    WrkData
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   DET_EoDATA                                                 *
      *                                                               *
      *****************************************************************
 
     C     DET_EoDATA    BEGSR
     C                   Z-ADD     1000          Size              4 0
     C     WD(Size)      DOUNE     *BLANK
     C     Size          OREQ      1
     C                   SUB       1             Size
     C                   ENDDO
      *
      * avoid space between each Tag except if Value itself has spaces
      *
     C     #_FieldData(R)IFEQ      *blank
     C                   SUB       1             Size
     C                   END
      *
     C                   ENDSR
 
      *****************************************************************
     C     *INZSR        BEGSR
     C                   ENDSR
      *****************************************************************
**  NARJMS  - Narrative JMS Chapters and Sub Chapters
?xml version
bf:JMSMessageData
for:msgData
for:header                                                                                  MD025783
for:userExtension                                                                           MD025783
header:overridableErrorsCollection
for:forecastKeys                                                                            MD025783
for:forecastDtls                                                                            MD025783
for:amount                                                                                  MD025783
for:actualAmount                                                                            MD025783
for:custKey                                                                                 MD025783
for:retailAcct                                                                              MD025783
**  NA2JMS  - Narrative JMS  End of Sub Chapters
/header:overridableErrorsCollection
/for:header                                                                                 MD025783
/for:forecastKeys                                                                           MD025783
/for:amount                                                                                 MD025783
/for:actualAmount                                                                           MD025783
/for:custKey                                                                                MD025783
/for:retailAcct                                                                             MD025783
/for:forecastDtls                                                                           MD025783
/for:userExtension                                                                          MD025783
/for:msgData
/bf:JMSMessageData
