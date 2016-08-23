     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update Trailer file STOPCSE')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM001701 - Update Trailer file STOPCSE.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025             Date 30May06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029  *CREATE    Date 23Apr04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK025 - Check that file isn't empty.                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - 10 long account code changes.                       *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FSTOPCSE   UF   E             DISK    INFSR(*PSSR)
      ** Retail Stopped Cheques Trailer
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
      ** Read file STOPCSE
      *
     C                   READ      STOPCSE
     C                   IF        NOT %EOF                                                   CPK025
      *
     C                   MOVE      WAcod1        ACOD
     C                   MOVEL     WAcod2        ACOD
      *
     C                   UPDATE    STOPCSEF
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
