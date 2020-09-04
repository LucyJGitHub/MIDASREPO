     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Check that users are correct')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000036 - Check that users are correct                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D PUser01         S             10
     D PUser02         S             10
     D NbrRcds         S              7  0
      *
     D Recursive       S              1    INZ('N')
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    PUser01
     C                   PARM                    PUser02
      *
      ** Check if first user has any records.
      *
     C/exec SQL
     C+ select count(*) into :NbrRcds
     C+ from SMBFACPD
     C+ where ACUSER = :PUser01
     C/end-exec
     C                   IF        NbrRcds = 0
     C                   EVAL      *INU1 = *ON
     C                   ENDIF
      *
      ** Check if second user has any records.
      *
     C/exec SQL
     C+ select count(*) into :NbrRcds
     C+ from SMBFACPD
     C+ where ACUSER = :PUser02
     C/end-exec
      *
     C                   IF        NbrRcds = 0
     C                   EVAL      *INU2 = *ON
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
      *
     C                   ENDIF
      *
     C                   DUMP
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
