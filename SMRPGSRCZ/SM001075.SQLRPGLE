     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Copy Selected Account keys to new acct')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM001075 - Midas SM Copy Selected Account keys to new acct   *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. MD027475 *CREATE   Date 29Aug14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027475 - Narrative PDCL_loan event (subtype_change)        *
/*    *             Utility to correct PF/ACKEYAL.                    *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D AccountKey    E DS                  EXTNAME(ACKEYAL)
     D AAKEY           DS            14
     D   EVENTID               3      3A

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D SQLSTR          S           2000A   INZ(*BLANKS)

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   EVAL      SQLSTR = 'SELECT * FROM ACKEYAL ' +
     C                             'WHERE   SUBSTRING(AKEY,3,1) = ''R'' ' +
     C                             'AND SUBSTRING(AKEY,6,1) = ''T'' ' +
     C                             'AND SUBSTRING(AKEY,10,1) = ''A'' ' +
     C                             'AND SUBSTRING(AKEY,7,3) = ''   '' ' +
     C                              'AND RECI = ''D'' ' +
     C                              'OR ' +
     C                             'SUBSTRING(AKEY,3,1) = ''R'' ' +
     C                             'AND SUBSTRING(AKEY,6,1) = ''F'' ' +
     C                             'AND SUBSTRING(AKEY,10,1) = ''A'' ' +
     C                             'AND SUBSTRING(AKEY,7,3) = ''   '' ' +
     C                              'AND RECI = ''D'' ' +
     C                              'OR ' +
     C                             'SUBSTRING(AKEY,3,1) = ''R'' ' +
     C                             'AND SUBSTRING(AKEY,10,1) = ''A'' ' +
     C                             'AND SUBSTRING(AKEY,6,4) = ''    '' ' +
     C                              'AND RECI = ''D'' ' +
     C                              'OR ' +
     C                             'SUBSTRING(AKEY,3,1) = ''V'' ' +
     C                             'AND SUBSTRING(AKEY,6,1) = ''N'' ' +
     C                             'AND SUBSTRING(AKEY,10,1) = ''D'' ' +
     C                              'AND RECI = ''D'' ' +
     C                              'OR ' +
     C                             'SUBSTRING(AKEY,3,1) = ''V'' ' +
     C                             'AND SUBSTRING(AKEY,10,1) = ''D'' ' +
     C                              'AND RECI = ''D'''
      *
      ** Prepare and declare cursor
      *
     C/Exec SQL
     C+ PREPARE P1 FROM :SQLSTR
     C/End-Exec
     C/EXEC SQL
     C+ DECLARE P1 CURSOR FOR P1
     C/END-EXEC
      *
      ** Open SQL cursor
      *
     C/EXEC SQL
     C+ OPEN P1
     C/END-EXEC
      *
      ** Read first row
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM P1
     C+ INTO: AccountKey
     C/END-EXEC
      *
     C                   DOW       SQLCODE = 0
     C                   MOVE      AKEY          AAKEY
     C                   MOVEL     'T'           EVENTID
     C                   Z-ADD     0             EACC
     C                   MOVE      AAKEY         AKEY
      *
      ** Insert a record to temporary account key file
      *
     C/EXEC SQL
     C+ INSERT INTO XACKEYAL
     C+ VALUES :AccountKey
     C/END-EXEC
     C                   IF        SQLCOD <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Read next row
      *
     C/EXEC SQL
     C+ FETCH NEXT
     C+ FROM P1
     C+ INTO: AccountKey
     C/END-EXEC
      *
     C                   ENDDO
      *
      ** Close cursors
      *
     C/EXEC SQL
     C+ CLOSE P1
     C/END-EXEC
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
      *
     C                   RETURN
     C                   EVAL      *INLR = *ON
     C                   ENDSR
