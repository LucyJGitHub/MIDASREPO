     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Extend Acct Length in External Acct Id')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000019 - Extend Account Length in External Account Id      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. BUG5222 *CREATE    Date 14Dec04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5222 - Extend Account Length in External Account Id       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FTIPOSTL9  UF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area Giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WkOldEXAC       DS
     D   WOBRCA                1      3
     D   WOCUST                4      9
     D   WOCCY                10     12
     D   WOACOD               13     16
     D   WOACSQ               17     18
     D   WOFILL               19     25
 
     D WkNewEXAC       DS
     D   WNBRCA                1      3
     D   WNCUST                4      9
     D   WNCCY                10     12
     D   WNACOD               13     22
     D   WNACSQ               23     24
     D   WNFILL               25     25
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D WRUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Access TI Postings file
 
     C     *LOVAL        SETLL     TIPOSTL9
     C                   READ      TIPOSTL9
 
     C                   DOW       NOT %EOF(TIPOSTL9)
 
     C                   EVAL      WkOldEXAC = TIEXAC
 
     C                   IF        WOFILL = *BLANKS
 
     C                   EVAL      WNBRCA = WOBRCA
     C                   EVAL      WNCUST = WOCUST
     C                   EVAL      WNCCY = WOCCY
     C                   MOVEL     ACOD          WNACOD
     C                   EVAL      WNACSQ = WOACSQ
     C                   EVAL      WNFILL = *BLANKS
     C                   EVAL      TIEXAC = WkNewEXAC
 
      ** Update record
 
     C                   UPDATE    TIPOSTD0
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      TIPOSTL9
 
     C                   ENDDO
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
 
     C                   EVAL      PRTCD = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      PRTCD = '*ERROR '
 
     C                   IF        WRUN = *BLANKS
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
