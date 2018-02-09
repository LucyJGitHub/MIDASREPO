     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Perform SQL for SCRAMBLE')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000024 - Perform SQL for SCRAMBLE                          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27787 *CREATE   Date 15Jul10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27787 - New version of SCRAMBLE utility                   *
      *                                                               *
      *****************************************************************
     FUTSCRMPD  IF   E           K DISK    INFSR(*PSSR)
      *
     D PFile           S             10
     D PField          S             10
     D PFmt            S             10
     D KFile           S             10
     D KField          S             10
     D SQL_Line        S             80
     D Clear           S              6    INZ('*CLEAR')
     D Write           S              6    INZ('*WRITE')
     D SQL_Mode        S              6
     D FirstRec        S              1    INZ('Y')
     D Mode            S              7
     D FieldData       S           2000
     D ReturnCode      S              7
     D Recursive       S              1
      *
     D RUNSQL_Cmd      C                   'RUNSQLSTM SRCFILE(QTEMP/RUNSQL) +
     D                                     SRCMBR(RUNSQLSTM) COMMIT(*NONE)'
     D Cmd_String      S             63
     D Cmd_StringLen   S             15  5 INZ(%LEN(Cmd_String))
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    PField
     C                   PARM                    PFmt
      *
     C     FileFld       KLIST
     C                   KFLD                    KFile
     C                   KFLD                    KField
      *
     C                   EVAL      Cmd_String = RUNSQL_Cmd
     C                   EVAL      KFile  = PFile
     C                   EVAL      KField = PField
      * Write first part of SQL statement.
     C                   EVAL      SQL_Line = 'Update ' + %TRIMR(PFile) +
     C                             ' set ' + %TRIMR(PField) +' = ('
      *
      * Find records for file / field combination.
     C     FileFld       SETLL     UTSCRMPD
     C     FileFld       READE     UTSCRMPD
      *
     C                   DOW       NOT(%EOF)                                    D01
      * If the SQL expression is for concatenation ...
     C                   IF        SBSQLT = 'C'                                 B01
      * If this is the first record do not specify CONCAT expression.
     C                   IF        FirstRec <> 'Y'                              B02
     C                   EVAL      SQL_Line = %TRIMR(SQL_Line) + ' CONCAT'
     C                   EVAL      SQL_Mode = Write
     C                   ELSE                                                   X02
     C                   EVAL      FirstRec = 'N'
     C                   EVAL      SQL_Mode = Clear
     C                   ENDIF                                                  E02
      *
      * If the substitute value is a field then check if the field is numeric.
     C                   IF        SBSTYP = 'F'                                 B02
     C                   CALL      'UTAOFFDS'
     C                   PARM                    PFile
     C                   PARM                    PFmt
     C                   PARM                    SBSVAL
     C                   PARM      '*RTV'        Mode
     C                   PARM                    ReturnCode
     C                   PARM                    FieldData
     C                   IF        ReturnCode <> *blank
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If the field is numeric then use DIGITS function.
     C                   IF        %SUBST(FieldData:322:1) = 'P' or
     C                             %SUBST(FieldData:322:1) = 'S'                B03
     C                   EVAL      SQL_Line = %TRIMR(SQL_Line) + ' DIGITS(' +
     C                             %TRIMR(SBSVAL) + ')'
     C                   ELSE                                                   X03
     C                   EVAL      SQL_Line = %TRIMR(SQL_Line) + ' ' + SBSVAL
     C                   ENDIF                                                  E03
      *
     C                   ELSE                                                   X02
     C                   EVAL      SQL_Line = %TRIMR(SQL_Line) + ' ' + SBSVAL
     C                   ENDIF                                                  E02
      *
      * ... else if it is a conditional update.
     C                   ELSE                                                   X01
      * Close concatenation string with bracket.
     C                   EVAL      SQL_Line = ')'
     C                   EVAL      SQL_Mode = Write
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    SQL_Mode
     C                   EVAL      SQL_Line = *blanks
     C                   EVAL      SQL_Line = %TRIMR(SQL_Line) + ' where ' +
     C                             SBSVAL
     C                   ENDIF                                                  E01
      *
      * Write line of SQL.
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    SQL_Mode
     C                   EVAL      SQL_Line = *blanks
      *
     C     FileFld       READE     UTSCRMPD
      *
     C                   ENDDO                                                  ED01
      *
      * Run SQL statement.
     C                   IF        SBSQLT = 'C'
     C                   EVAL      SQL_Line = ')'
     C                   EVAL      SQL_Mode = Write
     C                   CALL      'UTWRTSQL'
     C                   PARM                    SQL_Line
     C                   PARM                    SQL_Mode
     C                   ENDIF
     C                   CALL      'QCMDEXC'
     C                   PARM                    Cmd_String
     C                   PARM                    Cmd_StringLen
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
