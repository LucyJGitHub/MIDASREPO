     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MS Scan job desc. lib. list - CREATEZONE')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM001033 - Scan job description library list                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSM006  *CREATE    Date 31Mar05               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSM006 - Create new zone based on existing zone.             *
      *                                                               *
      *****************************************************************
     D FoundPos        S              4  0
     D FoundPosChk     S              4  0
     D StartPos        S              4  0 INZ(1)
     D                 DS
     D DivideCheckN            1      6  3
     D DivideCheckA            1      6
     D Remainder               4      6
      /EJECT
     C     *ENTRY        PLIST
     C                   PARM                    Pattern           2
     C                   PARM                    String         2750
     C                   PARM                    NewZone           2
      *
     C                   DOU       FoundPos = 0
     C                   EVAL      FoundPos = %SCAN(Pattern:String:StartPos)
      * If pattern is found then check if it is first two characters.
     C                   IF        FoundPos <> 0
     C                   EVAL      FoundPosChk = FoundPos - 1
     C                   EVAL      DivideCheckN = FoundPosChk/10
     C                   IF        Remainder = *blanks
     C                   EVAL      %SUBST(String:FoundPos:2) = NewZone
     C                   ENDIF
     C                   EVAL      StartPos = FoundPos + 1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
