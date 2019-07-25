     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update similarity between users - detail')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000039 - Report similarity between users - detail          *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
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
     D Users           S             21
     D Recursive       S              1    INZ('N')

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PUser01
     C                   PARM                    PUser02
      *
     C                   EVAL      Users = PUser01 + ' ' + PUser02
      *
      ** Write matching records to file.
      *
     C/exec SQL
     C+ insert into SMBFDTPD (
     C+ DTTYPE, DTUSRS, DTINDX, DTINAR, DTBRCH,
     C+ DTAC01, DTAC02, DTAC03, DTAC04, DTAC05,
     C+ DTAC06, DTAC07, DTAC08, DTAC09, DTAC10
     C+ )
     C+ select
     C+ 'Match', :Users, ACINDX, ACINAR, ACBRCH,
     C+ ACAC01,  ACAC02, ACAC03, ACAC04, ACAC05,
     C+ ACAC06,  ACAC07, ACAC08, ACAC09, ACAC10
     C+ from SMBFAC01 a where exists
     C+ (select * from SMBFAC02 b where
     C+ a.ACINDX = b.ACINDX and
     C+ a.ACBRCH = b.ACBRCH and
     C+ a.ACAC01 = b.ACAC01 and
     C+ a.ACAC02 = b.ACAC02 and
     C+ a.ACAC03 = b.ACAC03 and
     C+ a.ACAC04 = b.ACAC04 and
     C+ a.ACAC05 = b.ACAC05 and
     C+ a.ACAC06 = b.ACAC06 and
     C+ a.ACAC07 = b.ACAC07 and
     C+ a.ACAC08 = b.ACAC08 and
     C+ a.ACAC09 = b.ACAC09 and
     C+ a.ACAC10 = b.ACAC10)
     C/end-exec
      *
      ** Write mis-matching records to file for first user.
      *
     C/exec SQL
     C+ insert into SMBFDTPD (
     C+ DTTYPE, DTUSRS, DTINDX, DTINAR, DTBRCH,
     C+ DTAC01, DTAC02, DTAC03, DTAC04, DTAC05,
     C+ DTAC06, DTAC07, DTAC08, DTAC09, DTAC10
     C+ )
     C+ select
     C+ 'User1', ACUSER, ACINDX, ACINAR, ACBRCH,
     C+ ACAC01,  ACAC02, ACAC03, ACAC04, ACAC05,
     C+ ACAC06,  ACAC07, ACAC08, ACAC09, ACAC10
     C+ from SMBFAC01 a where not exists
     C+ (select * from SMBFAC02 b where
     C+ a.ACINDX = b.ACINDX and
     C+ a.ACBRCH = b.ACBRCH and
     C+ a.ACAC01 = b.ACAC01 and
     C+ a.ACAC02 = b.ACAC02 and
     C+ a.ACAC03 = b.ACAC03 and
     C+ a.ACAC04 = b.ACAC04 and
     C+ a.ACAC05 = b.ACAC05 and
     C+ a.ACAC06 = b.ACAC06 and
     C+ a.ACAC07 = b.ACAC07 and
     C+ a.ACAC08 = b.ACAC08 and
     C+ a.ACAC09 = b.ACAC09 and
     C+ a.ACAC10 = b.ACAC10)
     C/end-exec
      *
      ** Write mis-matching records to file for second user.
      *
     C/exec SQL
     C+ insert into SMBFDTPD (
     C+ DTTYPE, DTUSRS, DTINDX, DTINAR, DTBRCH,
     C+ DTAC01, DTAC02, DTAC03, DTAC04, DTAC05,
     C+ DTAC06, DTAC07, DTAC08, DTAC09, DTAC10
     C+ )
     C+ select
     C+ 'User2', ACUSER, ACINDX, ACINAR, ACBRCH,
     C+ ACAC01,  ACAC02, ACAC03, ACAC04, ACAC05,
     C+ ACAC06,  ACAC07, ACAC08, ACAC09, ACAC10
     C+ from SMBFAC02 a where not exists
     C+ (select * from SMBFAC01 b where
     C+ a.ACINDX = b.ACINDX and
     C+ a.ACBRCH = b.ACBRCH and
     C+ a.ACAC01 = b.ACAC01 and
     C+ a.ACAC02 = b.ACAC02 and
     C+ a.ACAC03 = b.ACAC03 and
     C+ a.ACAC04 = b.ACAC04 and
     C+ a.ACAC05 = b.ACAC05 and
     C+ a.ACAC06 = b.ACAC06 and
     C+ a.ACAC07 = b.ACAC07 and
     C+ a.ACAC08 = b.ACAC08 and
     C+ a.ACAC09 = b.ACAC09 and
     C+ a.ACAC10 = b.ACAC10)
     C/end-exec
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
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
