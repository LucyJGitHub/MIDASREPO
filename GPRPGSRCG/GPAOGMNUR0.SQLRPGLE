     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP AO Check for GPMNU file')
      *****************************************************************
      *                                                               *
      *  Midas Global Processing                                      *
      *                                                               *
      *  GPAOGMNUR0 - Midas AO check for GPMNU*TD                     *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD056561 *CREATE   Date 31Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056561 - Deliverable Data Split for SFMENUPD and GPMTXTPD  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

     D PMenuC          S             10
     D PRtcd           S              7
     D Found           S              4  0

      ** Main Processing

     C                   eval      PMenuC = MenuCode

     C/EXEC SQL
     C+ declare ACursor insensitive scroll cursor for
     C+ select * from GPMNUJW0
     C+ where MIINDX = :PMenuC
     C/END-EXEC

     C/EXEC SQL
     C+ open ACursor
     C/END-EXEC


     C/EXEC SQL
     C+ get diagnostics :Found = DB2_NUMBER_ROWS
     C/END-EXEC

     C                   IF        Found > 0
     C                   EVAL      PRtcd = 'Y'
     C                   ELSE
     C                   EVAL      PRtcd = 'N'
     C                   ENDIF

     C/EXEC SQL
     C+ close ACursor
     C/END-EXEC

     C                   RETURN
      *****************************************************************
      *                                                               *
      *  INZSR - Initial Subroutine.                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    MenuCode         10
     C                   PARM                    PRtcd

     C                   ENDSR
      *****************************************************************
