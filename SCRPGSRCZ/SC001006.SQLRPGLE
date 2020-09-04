     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SC Add Removed members back to logical files')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC001006 - Midas SC Add Removed members back to logical      *
      *             files                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD024006A *REWRITE Date 08Jan14               *
      *  Prev Amend No. MD023005           Date 23Oct13               *
      *                 MD022394C          Date 18Oct13               *
      *                 MD022394B          Date 16Oct13               *
      *                 MD022394A          Date 11Oct13               *
      *                 MD022554           Date 02Oct13               *
      *                 MD022394           Date 12Sep13               *
      *                 CCB022  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024006A - Inefficiency of COB File Manager                 *
      *  MD023005 - Change of LF access path during reopen IC proc    *
      *  MD022394C - Incorrect variable declaration                   *
      *  MD022394B - Error in program process                         *
      *  MD022394A - Lack in functionality of Reopen IC procedure     *
      *  MD022554 - CBC022001 issues on missing members               *
      *  MD022394 - BankFusion_Close of Business: Lack in             *
      *             functionality of Reopen IC procedure.             *
      *  CCB022 - COB Restructure - COB File Manager                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *       LR - End of Program                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  RUNCL - Subroutine that calls QCMDEXC                        *
      *                                                               *
      *****************************************************************
      /EJECT
     D File            S             10
     D Member          S             10
     D Action          S              4
     D ActionType      S              6
     D WCFile          S             10A   INZ
     D WCMaint         S              1A   INZ
     D AccPthMaint     S              6A   INZ
     D Recursive       S              1
      *
     D FMBR          E DS                  EXTNAME(SCFMBRTD)
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  MAIN processing                                              *
      *                                                               *
      *****************************************************************
 
      ** Add back members
 
     C                   EXSR      ADDMBR
 
      ** Change back Logical file access path to *IMMED
 
     C                   EXSR      CHGIMD
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  ADDMBR - Add back members of logical files                   *
      *                                                               *
      *****************************************************************
     C     ADDMBR        BEGSR
 
     C/exec SQL
     C+ declare Update cursor for
     C+ select distinct
     C+   MBFILE
     C+ from SCFMBRTD
     C+ where
     C+     MBPERM = 'N'
     C/end-exec
      *
     C/exec SQL
     C+ open Update
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from Update
     C+ into :File
     C/end-exec
      *
      * Do nothing if there are no records found.
     C                   DOW       SQLCODE = 0
      *
     C                   CALL      'CBC022001'
     C                   PARM                    File
     C                   PARM      '*ALL'        Member
     C                   PARM      '*ADD'        Action
     C                   PARM      *blanks       ActionType
      *
     C/exec SQL
     C+ fetch next
     C+ from Update
     C+ into :File
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close Update
     C/end-exec
      *
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  CHGIMD - Change back access path maintenance to *IMMED       *
      *                                                               *
      *****************************************************************
     C     CHGIMD        BEGSR
 
     C/EXEC SQL
     C+ declare ICursor insensitive scroll cursor for
     C+ select
     C+    FNAME
     C+   ,MAINT
     C+ from
     C+   SCACCPTD
     C+ for read only
     C+ optimize for 1 row
     C/END-EXEC
 
     C/EXEC SQL
     C+ open ICursor
     C/END-EXEC
 
     C/EXEC SQL
     C+ fetch next from ICursor into
     C+   :WCFile
     C+  ,:WCMaint
     C/END-EXEC
 
     C                   DOW       SQLCODE = 0
     C                   IF        WCFile <> *BLANKS
 
     C                   SELECT
     C                   WHEN      WCMaint = 'R'
     C                   EVAL      AccPthMaint  = '*REBLD'
     C                   WHEN      WCMaint = 'D'
     C                   EVAL      AccPthMaint  = '*DLY'
     C                   OTHER
     C                   EVAL      AccPthMaint  = '*IMMED'
     C                   ENDSL
     C                   CALL      'CBC022001'
     C                   PARM                    WCFile
     C                   PARM      *BLANKS       Member
     C                   PARM      '*CHG'        Action
     C                   PARM      AccPthMaint   ActionType
     C                   ENDIF
 
     C/EXEC SQL
     C+ fetch next from ICursor into
     C+   :WCFile
     C+  ,:WCMaint
     C/END-EXEC
     C                   ENDDO
 
     C/EXEC SQL
     C+ close ICursor
     C/END-EXEC
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Exception Error Routine                              *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     Recursive     IFEQ      *BLANKS
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
