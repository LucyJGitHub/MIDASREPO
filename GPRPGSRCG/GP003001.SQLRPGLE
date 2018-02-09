     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Set Global journal caching on or off')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP003001 - Midas GP Set Global journal caching on or off     *
      *                                                               *
      *  *  (c) Finastra International Limited 2013                   * 
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD023896*CREATE    Date 06Dec13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023896 - Switching on of Journal Cache for global layer    *
      *                                                               *
      *****************************************************************
      *
      ** Program Status Data Structure
     D/COPY GPCPYSRCG,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PMode           S              4
     D PPrfx           S              2
     D SaveMode        S              4
     D Count           S              5  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PPrfx

      ** Save Mode
     C                   EVAL      SaveMode = PMode

      ** Set Mode parameter as an error catchall
     C                   EVAL      PMode = '*ERR'

     C                   SELECT

     C                   WHEN      SaveMode = '*YES'
      ** Add record to GPJSTSTD
     C/EXEC SQL
     C+ insert into GPJSTSTD (JSZONE) values(:PPrfx)
     C/END-EXEC
     C                   EVAL      PMode = '*YES'

     C                   WHEN      SaveMode = '*NO '
      ** Delete records in GPJSTSTD
     C/EXEC SQL
     C+  delete from GPJSTSTD
     C+  where JSZONE = :PPrfx
     C/END-EXEC

      ** Count records in GPJSTSTD
     C/EXEC SQL
     C+  select count(*) into :Count from GPJSTSTD
     C/END-EXEC
     C                   IF        Count = 0
     C                   EVAL      PMode = '*NO '
     C                   ELSE
     C                   EVAL      PMode = '*IGN'
     C                   ENDIF

     C                   ENDSL

      ** Check for error in SQL execution
     C                   IF        SQLCOD <> 0
     C                   EVAL      PMode = '*ERR'
     C                   EXSR      *PSSR
     C                   ENDIF

      ** End program
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN

     C                   ENDSR
