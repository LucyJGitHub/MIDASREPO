     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP WIP Configuration Updater')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAOWIPBU0 - Midas GP WIP Configuration Updater              *
      *                                                               *
      *  Function:  This program updates the WC_AUTOA field of        *
      *             GPWIPBTD file for CLE125 enhancement.             *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. CLE125  *CREATE    Date Date 02Nov21          *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE125 - Amendment to LE Authorization Rules                 *
      *                                                               *
      *****************************************************************
      *
      ** Program Status Data Structure
     D/COPY GPCPYSRCG,PSDS
     D PMode           S              4
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Update records in GPWIPBTD
      *
     C/EXEC SQL
     C+ update GPWIPBTD
     C+ set WC_AUTOA = 'Y' where WC_API in ('CLIP', 'FAMD', 'FCIP', 'FEAD',
     C+                     'FEEM', 'FEST', 'LERI', 'LOAM', 'MAPY', 'RPSC')
     C/END-EXEC
      *
      ** Check for error in SQL execution
      *
     C                   IF        SQLCOD <> 0
     C                   EVAL      PMode = '*ERR'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** End program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
