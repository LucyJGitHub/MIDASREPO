     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas AO Check for COM exclusions')
      *****************************************************************
      *                                                               *
      *  Midas Access Objects                                         *
      *                                                               *
      *  AOCOMR0 - Midas AO Check for COM exclusions                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP040             Date 06Mar14               *
      *                 CCB022  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP040 - Restructure of deliverable data files.              *
      *  CCB022 - COB Restructure - COB File Manager                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

     D PName           S             10
     D PCSeq           S              5
     D PSctn           S             10
     D PRtcd           S              7
     D Found           S              4  0

      ** Main Processing

     C                   IF        PCSeq = '*ALL'

     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C**select***from*SCCOMJK0*                                                               CUP040
     C+ select * from SCCOMJW0                                                                CUP040
     C+ where FMNAME = :PName
     C+ and FMTYPE = 'X'
     C+ and FMMBR = :PSctn
     C+ and FMDEL = 'N'
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC

     C                   ELSE

     C/EXEC SQL
     C+ declare BCursor insensitive scroll cursor for
     C**select***from*SCCOMJK0*                                                               CUP040
     C+ select * from SCCOMJW0                                                                CUP040
     C+ where FMNAME = :PName
     C+ and FMTYPE = 'X'
     C+ and FMCSEQ = :PCSeq
     C+ and FMMBR = :PSctn
     C+ and FMDEL = 'N'
     C/END-EXEC

     C/EXEC SQL
     C+ open BCursor
     C/END-EXEC

     C                   ENDIF

     C/EXEC SQL
     C+ get diagnostics :Found = DB2_NUMBER_ROWS
     C/END-EXEC

     C                   IF        Found > 0
     C                   EVAL      PRtcd = 'Y'
     C                   ELSE
     C                   EVAL      PRtcd = 'N'
     C                   ENDIF

     C                   IF        PCSeq = '*ALL'
     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC
     C                   ELSE

     C/EXEC SQL
     C+ close BCursor
     C/END-EXEC
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      *                                                               *
      *  INZSR - Initial Subroutine.                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PName
     C                   PARM                    PCSeq
     C                   PARM                    PSctn
     C                   PARM                    PRtcd
     C
     C                   ENDSR
      *****************************************************************
