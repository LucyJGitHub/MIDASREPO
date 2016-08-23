     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*XBIA*  CRTSRCPF FILE(QTEMP/RUNFTPSCR) RCDLEN(1000) MBR(RUNFTPSCR)   *
/*XBIB*  RNMOBJ OBJ(QTEMP/RUNFTPSCR) OBJTYPE(*FILE)                   *
/*XBIB*  NEWOBJ(RUNFTP)                                               *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Standard program to run FTP remote cmds.')
      *****************************************************************
      *                                                               *
      *  Midas - Utility module                                       *
      *                                                               *
      *  UTWRTFTP - Standard program to write FTP scripts to be used  *
      *             in running remote commands.                       *
      *                                                               *
      *  Function:  This program is intended to be called from any    *
      *             program that needs to build an FTP script to be   *
      *             run.                                              *
      *                                                               *
      *             It has two entry parameters.  The first is a 1000 *
      *             long string which forms part of the FTP script.   *
      *             The second can be '*CLEAR' or '*WRITE'.  If it    *
      *             is '*CLEAR the source file will be cleared and    *
      *             then written to; if it is '*WRITE' then the       *
      *             source file is written to only.                   *
      *                                                               *
      *             The calling program must create the source file   *
      *             and rename it (following the /*XBI instructions   *
      *             above.  It must also perform the FTP.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CUT011  *CREATE    Date 04Jan08               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT011 - New general purpose tool to make writing FTP        *
      *           scripts easier.                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutines                                                  *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
     FRUNFTP    IF A E             DISK    USROPN
      *
      * General variables
     D Stmt_String     S           1000
     D Mode            S              6
     D Cmd_String      S            100
     D Cmd_StringLen   S             15  5 INZ(%LEN(Cmd_String))
      *
      * Clear source file.
     D CLRPFM_Cmd      C                   'CLRPFM FILE(QTEMP/RUNFTP) +
     D                                     MBR(RUNFTPSCR)'
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
     C                   OPEN      RUNFTP
     C                   EVAL      SRCDTA = *blanks
     C                   EVAL      SRCDTA = Stmt_String
     C                   WRITE     RUNFTPSCR
     C                   CLOSE     RUNFTP
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  Clear - Clear source file for FTP scripts                    *
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
