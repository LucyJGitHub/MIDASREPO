     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBIA*  CRTSRCPF FILE(QTEMP/RUNSQLSTM) RCDLEN(112) MBR(RUNSQLSTM)    *
/*XBIB*  RNMOBJ OBJ(QTEMP/RUNSQLSTM) OBJTYPE(*FILE)                   *
/*XBIB*  NEWOBJ(RUNSQL)                                               *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Standard program to help RUNSQLSTM')
      *****************************************************************
      *                                                               *
      *  Midas - Utility module                                       *
      *                                                               *
      *  UTWRTSQL - Standard program to write SQL code to a source    *
      *             file so that RUNSQLSTM can be run.                *
      *                                                               *
      *  Function:  This program is intended to be called from any    *
      *             program that needs to build the contents of a     *
      *             source file with an SQL statement.                *
      *                                                               *
      *             It has two entry parameters.  The first is a 80   *
      *             long string which forms part or all of an SQL     *
      *             statement.  The second can be '*CLEAR' or         *
      *             '*WRITE'.  If it is '*CLEAR the source file will  *
      *             cleared and then written to; if it is '*WRITE'    *
      *             then the source file is written to.               *
      *                                                               *
      *             The calling program must create the source file   *
      *             and rename it (following the /*XBI instructions   *
      *             above.  It must also perform the RUNSQLSTM.       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK020  *CREATE    Date 04Nov04               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK020 - New option for the Bridge to handle stored          *
      *            procedures.                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
     FRUNSQL    IF A E             DISK    USROPN
      *
      * General variables
     D Stmt_String     S             80
     D Mode            S              6
     D Cmd_String      S            100
     D Cmd_StringLen   S             15  5 INZ(%LEN(Cmd_String))
      *
      * Clear source file.
     D CLRPFM_Cmd      C                   'CLRPFM FILE(QTEMP/RUNSQL) +
     D                                     MBR(RUNSQLSTM)'
      *
      /EJECT
     C     *ENTRY        PLIST
     C                   PARM                    Stmt_String
     C                   PARM                    Mode
      *
      * If mode is '*CLEAR' then clear the source file.
     C                   IF        Mode = '*CLEAR'
     C                   EXSR      Clear
     C                   ENDIF
      *
      * Write record to source file.
     C                   OPEN      RUNSQL
     C                   EVAL      SRCDTA = *blanks
     C                   EVAL      SRCDTA = Stmt_String
     C                   WRITE     RUNSQLSTM
     C                   CLOSE     RUNSQL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  Clear - Clear source file for SQL statements                 *
      *                                                               *
      *  Called By: Main processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     Clear         BEGSR
      *
     C                   EVAL      Cmd_String = *blanks
     C                   EVAL      Cmd_String = CLRPFM_Cmd
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_StringLen
      *
     C     ClearE        ENDSR
      *
      *****************************************************************
