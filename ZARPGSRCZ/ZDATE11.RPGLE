     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA: Validate & convert date to a day number')
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  ZDATE11 - Validate MMDDCCYY/DDMMCCYY and convert to DayNo.   *
      *                                                               *
      *  This ILE/RPG program validates passed date in MMDDCCYY or    *
      *  DDMMCCYY and calls ZDATE10 for the MIDAS day number          *
      *  equivalent of the said date. The validation mainly checks    *
      *  for non-numeric inputs and invalid century (should range     *
      *  from 19 to 22) before passing off the date to ZDATE10.       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
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
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE065  *CREATE    Date 08Nov04               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defned externally for the original
      ** copy members
      ** +-----------------------------------------------------------------+
 
     D DateIn          S              6A
     D DatIn           S              8A
     D DaynoOut        S              5P 0
     D BJDFIN          S              1A
     D ErrorFlag       S              1A
     D DateISO         s               D   datfmt(*iso)
     D #DateIn2        s              8S 0
 
     C     *entry        PLIST
     C                   PARM                    DatIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      ** Reset the error flag
 
     C                   EVAL      ErrorFlag = 'N'
 
      ** Set *IN98 to reflect the System Date Format Indicator
 
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      *OFF          *IN98
     C                   ELSE
     C                   MOVE      *ON           *IN98
     C                   ENDIF
 
     C                   MOVE      DatIn         #DatIn            8 0
     C                   MOVE      #DatIn        @DatIn            8
 
      ** If not numeric
 
     c                   IF        DatIn <> @DatIn
     C                   EVAL      ErrorFlag = 'Y'
     c                   ELSE
 
     C  N98*eur          TEST(D)                 #DatIn                 97
     C   98*usa          TEST(D)                 #DatIn                 97
     C                   IF        *In97 = *on
     C                   EVAL      ErrorFlag = 'Y'
     C                   ELSE
     C                   IF        %subst(DatIn:5:4) < '1972' or
     C                             %subst(DatIn:5:2) > '22'
     C                   EVAL      ErrorFlag = 'Y'
 
     C                   ELSE
 
      ** If not error, convert date into dayno by calling ZDATE10
 
     C  N98*eur          MOVE      #DatIn        DateIso
     C   98*usa          MOVE      #DatIn        DateIso
     C     *iso          MOVE      DateIso       #DateIn2
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    #DateIn2
     C                   PARM      *ZEROS        DaynoOut
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
