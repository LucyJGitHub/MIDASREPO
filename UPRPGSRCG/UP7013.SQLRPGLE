     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR check job activity')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP7013 - Midas UP OTR check job server activity              *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *   Last Amend No. MD061067 *CREATE   Date 17Jul23              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061067 - Missing process for UDF tables                    *
      *           - Applied for MD061569.                             *
      *                                                               *
      *****************************************************************
      /EJECT
     D JOB             S             40
     D Subs            S             40
      /EJECT
     C     *ENTRY        PLIST
     C                   PARM                    SBS              10
     C                   PARM                    ACTIVE            1

     C                   EVAL      ACTIVE = *BLANKS
     C                   EVAL      SubS = SBS

     C/EXEC SQL
     C+ select JOB_NAME into :JOB
     C+ FROM TABLE(QSYS2.ACTIVE_JOB_INFO ()) A
     C+ where JOB_NAME like '%OTBRSERVER%' and SUBSYSTEM = :Subs
     C/END-EXEC
     C                   IF        SQLCODE = 0
     C                   EVAL      ACTIVE = 'Y'
     C                   ELSE
     C                   EVAL      ACTIVE = 'N'
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN
