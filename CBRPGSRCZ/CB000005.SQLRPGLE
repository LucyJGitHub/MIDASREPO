     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CB Determine Authorised COB User')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business module                             *
      *                                                               *
      *  CB000005 - Midas CB Determine Authorised COB User            *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCB021  *CREATE    Date 06Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB021 - COB Restructure - Non Working Day COB               *
      *                                                               *
      *****************************************************************
      *  Function of indicators                                       *
      *                                                               *
      *****************************************************************
     D COBUSERS      E DS                  EXTNAME(MUSER)
     D CURUSER         S             10A
     D USER            S              5

     C     *ENTRY        PLIST
     C                   PARM                    CURUSER
     C                   PARM                    USER

     C/EXEC SQL
     C+ select * into :COBUSERS from MUSER
     C+ where USRP = :CURUSER
     C/END-EXEC

     C                   IF        SQLCODE = 0
     C                   IF        COBAUT <> 'Y'
     C                   EVAL      USER = '*NO'
     C                   ELSE
     C                   EVAL      USER = '*YES '
     C                   ENDIF
     C                   ELSE
     C                   EVAL      USER = '*NO  '
     C                   ENDIF

     C                   SETON                                        LR
     C                   RETURN
