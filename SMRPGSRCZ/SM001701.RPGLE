     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update Trailer file REDEFZ')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM001701 - Update Trailer file REDEFZ                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025             Date 30May06               *
      *  Prev Amend No. CGL029  *CREATE    Date 23Apr04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK025 - Check that file isn't empty.                        *
      *  CGL029 - 10 long account code changes.                       *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FREDEFZ    UF   E             DISK    INFSR(*PSSR)
      ** Default Retail Accounts Trailer
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
     D PRtCd           S              7A
      *
      ** Working Variables
     D WAcod1          S              5A
     D WAcod2          S              5A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Read trailer file.
      *
     C                   READ      REDEFZ
     C                   IF        NOT %EOF                                                   CPK025
      *
     C                   MOVE      WAcod1        ACOD
     C                   MOVEL     WAcod2        ACOD
      *
     C                   UPDATE    REDEFZF
      *
     C                   ENDIF                                                                CPK025
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtCd
      *
     C                   EVAL      WAcod1 = '99999'
     C                   EVAL      WAcod2 = '99999'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      PRtCd = '*ERROR '
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
