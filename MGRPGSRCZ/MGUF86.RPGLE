     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MG Optimize field 86')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MGUF86 - Midas MG Optimize field 86                          *
      * FBMidas 2.1 ---- Base ----------------------------------------*
      *                                                               *
      *  Function:  This program optimizes spaces in fields 86        *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. EML102  *CREATE    Date 22Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML102 - Upgrade of EML004 to FB21 SP21                      *
      *       EML004 - Extended Narrative                             *
      *                                                               *
      *****************************************************************

      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================

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

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================

      ** Named constants
      ** ---------------

      ** Arrays and Data Structures
      ** --------------------------

      ** Extended Narratives
     D  ArExtNarr      S             35A   DIM(16)

      ** Additional Information
     D  ArAddInfo      S             65A   DIM(6)

      ** Declared variables
      ** ------------------

     D LongString      S            600A
     D Index           S              5U 0                                      Index
     D Element         S              5U 0                                      Element
     D Start           S              5U 0                                      Start position
     D End             S              5U 0                                      End position
     D Length          S              5U 0                                      Length
     D LastBlank       S              5U 0                                      Last Blank
     D Pos             S              5U 0                                      Position
     D First           S              1A                                        First Character

      ** Input Specs
      ** -----------

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode                     Return Code
     C                   PARM                    ArExtNarr                      Extended Narrative
     C                   PARM                    ArAddInfo                      Additional Inform.

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

     C                   EVAL      ReturnCode = *BLANKS
     C                   EVAL      Element    = *Zeros
     C                   EVAL      LongString = *Blanks
     C                   CLEAR                   ArAddInfo
     C                   EVAL      Start      = 1
      *
      ** Retrieve extended Narratives
      *
     C                   DO        16            Index
      *
     C                   IF        ArExtNarr(Index) <> *Blanks
      *
      ** Load Additional Information
      *
     C                   ADD       1             Element
     C                   IF        Element <= 6
     C                   EVAL      ArAddInfo(Element) = ArExtNarr(Index)
     C                   ENDIF
      *
      ** Load fields into a Long String with a blank between each field
      ** Thus, at least a blank every 35 characters.
      *
     C                   EVAL      %SUBST(LongString:Start) =
     C                             %TRIM(ArExtNarr(Index))
      *
      ** Calculate next start position
      *
     C                   EVAL      Start = Start +
     C                             %LEN(%TRIM(ArExtNarr(Index))) +              Length Ext. Narr.
     C                             1                                            One blank
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   IF        Element <= 6
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   EVAL      Element    = *Zeros
     C                   CLEAR                   ArAddInfo
     C                   EVAL      End        = Start - 2
     C                   EVAL      Start      = 1
     C                   EVAL      Pos        = *Zeros
     C                   EVAL      LastBlank  = *Zeros
      *
      ** Retrieve blanks in LongString
      *
     C                   DOU       Element >= 6
     C                             OR  Start > End
      *
     C                   ADD       1             Pos
     C                   EVAL      Pos = %SCAN(' ':LongString:Pos)
      *
     C                   EVAL      Length = Pos - Start
      *
     C                   IF        Length > 65 OR LastBlank > End
      *
     C                   EVAL      Length = LastBlank - Start
      *
     C                   ADD       1             Element
     C                   EVAL      ArAddInfo(Element) =
     C                             %SUBST(LongString:Start:Length)
     C                   EVAL      Start = LastBlank + 1
      *
     C                   EVAL      FIRST = ArAddInfo(Element)
     C                   IF        FIRST = ':' OR FIRST = '-'
     C                   EVAL      %SUBST(ArAddInfo(Element):1:1) = ' '
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      LastBlank = Pos
      *
     C                   ENDDO

     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*

     C     *INZSR        BEGSR
      *    ------        -----

      ** Initialise Copyright Array
     C                   MOVEA     CPY@          CPY@@            80

      *    ------        -----
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*

     C     *PSSR         BEGSR
      *    -----         ------

     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      ReturnCode = 'PSSR_Error'
     C                   ENDIF

     C                   DUMP

     C                   EVAL      *INLR = *On

     C                   RETURN

      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**CTDATA CPY@
(C) Misys International Banking Systems Ltd. 2007
