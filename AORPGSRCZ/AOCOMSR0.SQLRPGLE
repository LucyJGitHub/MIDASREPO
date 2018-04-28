     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas AO COB Components Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  AOCOMSR0 - Midas AO COB Components Access Object             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CCB023  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *                                                               *
      *****************************************************************
      *
      ** Define variables
      *
     DCSTAT            S              1
      *
      ** Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    CNAM             10
     C                   PARM                    CSEQ              5
     C                   PARM                    RTCD              4
      *
      ** Initialise variables
      *
     C                   EVAL      CSTAT = *BLANKS
      *
      ** Chain using SQL
      *
     C/EXEC SQL
     C+ Declare Cursor Insensitive scroll cursor for
     C+ SELECT DHCSTS FROM CBCOMSPD WHERE
     C+ DHCOTT = :CNAM AND DHCSEQ = :CSEQ
     C/END-EXEC
      *
     C/EXEC SQL
     C+ Open Cursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ FETCH NEXT FROM Cursor INTO :CSTAT
     C/END-EXEC
      *
      ** If record not found
      *
     C                   IF        SQLCOD <> 0
     C                   EVAL      RTCD = '*NRF'
      *
      ** If record found
      *
     C                   ELSE
     C                   EVAL      RTCD = CSTAT
     C                   ENDIF
      *
      *  Terminate program and return to caller.
      *
     C/EXEC SQL
     C+ Close Cursor
     C/END-EXEC
     C                   RETURN
      /EJECT
