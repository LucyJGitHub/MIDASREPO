     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Format Data for a WIP Message')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPFMT4WIP - Format Data for a WIP Message                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG27831A *CREATE  Date 03Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27831A - Forward Account Transfer Processing              *
      *                                                               *
      *****************************************************************
 
     D                 DS
     D Msg                     1  32000    DIM(32000)
 
     D #_FieldTag      S             10A   DIM(999)
     D #_FieldData     S           1000A   DIM(999)
     D #_FieldType     S             10A   DIM(999)
     D #_FieldAttr     S             10A   DIM(999)
 
     D                 DS
     D WrkData                 1   1000
     D WD                      1   1000    DIM(1000)
 
     D                 DS
     D ZFL15                   1     15  0
     D ZF15                    1     15    DIM(15)
 
     D F1              S             26    INZ('<midasActionAPI apiNames="')
     D F2              S             17    INZ('</midasActionAPI>')
 
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
     C                   PARM                    p@FieldTag       10
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
 
      ** <midasActionAPI>
     C                   EXSR      STARTofMSG
 
      ** <FMT>
     C                   EXSR      STARTofFMT
 
      ** Loop through all fields
 
     C                   Z-ADD     1             R                 3 0
     C     #_FieldTag(R) DOWNE     *BLANK
 
      ** Start tag for field
 
     C                   EXSR      STARTofFLDTAG
 
     C                   MOVEA     #_FieldData(R)WrkDATA
     C                   MOVEA     #_FieldAttr(R)WrkATTR          10
 
      ** Date, amount or other
 
     C     #_FieldType(R)IFEQ      '*DATE'
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
 
      ** </FMT >
     C                   EXSR      ENDofFMT
      ** </midasActionAPI>
     C                   EXSR      ENDofMSG
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   STARTofMSG                                                 *
      *                                                               *
      *****************************************************************
 
     C     STARTofMSG    BEGSR
 
      * <midasActionAPI>
     C                   MOVEA     F1            Msg(1)
     C                   MOVEA     p@apiNames    Msg(27)
     C                   Z-ADD     28            X
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   MOVEA     '">'          Msg(X)
     C                   ADD       2             X
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   STARTofFMT                                                 *
      *                                                               *
      *****************************************************************
 
     C     STARTofFMT    BEGSR
     C                   MOVEA     '<'           Msg(X)
     C                   ADD       1             X
     C                   MOVEA     p@Format      Msg(X)
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   MOVEL     '>'           Msg(X)
     C                   ADD       1             X
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   STARTofFLDTAG                                              *
      *                                                               *
      *****************************************************************
 
     C     STARTofFLDTAG BEGSR
     C                   MOVEL     '<'           Msg(X)
     C                   ADD       1             X
     C                   MOVEL     #_FieldTag(R) WrkFldTag        10
     C                   MOVEA     WrkFldTag     Msg(X)
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   MOVEL     '>'           Msg(X)
     C                   ADD       1             X
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   ENDofFLDTAG                                                *
      *                                                               *
      *****************************************************************
 
     C     ENDofFLDTAG   BEGSR
     C                   MOVEA     '</'          Msg(X)
     C                   ADD       2             X
     C                   MOVEL     #_FieldTag(R) WrkFldTag
     C                   MOVEA     WrkFldTag     Msg(X)
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   MOVEL     '>'           Msg(X)
     C                   ADD       1             X
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   ENDofFMT                                                   *
      *                                                               *
      *****************************************************************
 
     C     ENDofFMT      BEGSR
     C                   MOVEA     '</'          Msg(X)
     C                   ADD       2             X
     C                   MOVEA     p@Format      Msg(X)
     C     *BLANK        LOOKUP    Msg(X)                                 99    *
     C                   MOVEL     '>'           Msg(X)
     C                   ADD       1             X
     C                   ENDSR
      *****************************************************************
      *                                                               *
      **   ENDofMSG                                                   *
      *                                                               *
      *****************************************************************
 
     C     ENDofMSG      BEGSR
      ** </midasActionAPI>
     C                   MOVEA     F2            Msg (X)
     C                   ENDSR
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
     C                   ENDSR
 
      *****************************************************************
     C     *INZSR        BEGSR
     C                   ENDSR
      *****************************************************************
