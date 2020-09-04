     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Compare all users access rights')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000037 - Compare all users' access rights, summary         *
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
     D UserList1       S             10    DIM(9999) CTDATA PERRCD(1) ASCEND
     D UserList2       S             10    DIM(9999) CTDATA PERRCD(1) ASCEND
      *
     D PMode           S              4
     D LastUser        S             10    INZ(*blanks)
     D CommandLen      S             15  5 INZ(69)
     D First           S              1    INZ('Y')
     D a               S              4  0 INZ(1)
     D b               S              5  0
     D UserCount       S              4  0 INZ(0)
     D Recursive       S              1    INZ('N')
      *
     D BFAC          E DS                  EXTNAME(SMBFACPD)
      *
     D BFCMPUSR        DS
     D  Command                1     14    INZ('BFCMPUSR USR1(')
     D  User01                15     24
     D                        25     31    INZ(') USR2(')
     D  User02                32     41
     D                        42     50    INZ(') MBROPT(')
     D  MbrOpt                51     58    INZ('*REPLACE')
     D                        59     64    INZ(') DTL(')
     D  Mode                  65     68
     D                        69     69    INZ(')')
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
      *
     C                   EVAL      Mode = PMode
      *
     C/exec SQL
     C+ declare ACcursor cursor for
     C+ select * from SMBFACPD
     C+ order by ACUSER
     C/end-exec
      *
     C/exec SQL
     C+ open ACcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from ACcursor
     C+ into: BFAC
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      * Build arrays.
     C                   IF        LastUser <> ACUSER
     C                   EVAL      UserList1(a) = ACUSER
     C                   EVAL      UserList2(a) = ACUSER
     C                   EVAL      LastUser = ACUSER
     C                   EVAL      a = a + 1
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from ACcursor
     C+ into: BFAC
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close ACcursor
     C/end-exec
      *
      ** The number of users will be the array index number minus 1.
      *
     C                   EVAL      UserCount = a - 1
      *
      ** Once the arrays are populated the sort them into
      ** alphabetical order.
      *
     C                   SORTA     UserList1
     C                   SORTA     UserList2
      *
      ** The first entries of the arrays will probably be blank
      **   so set the index to the first pupulated array entry.
      *
     C                   EVAL      a = 9999 - UserCount + 1
      *
      ** Loop to compare user's access rights in the following way:
      **  - compare 1 v 2, 1 v 3, 1 v 4, etc.
      **  - compare 2 v 3, 2 v 4, etc.
      **  - compare 3 v 4, etc.
      ** As comparing 4 v 4 is not necessary the loop needs
      ** to be performed one less than the actual number of users.
      *
     C                   EVAL      UserCount = UserCount - 1
     C                   EVAL      b = a + 1
     C                   DO        UserCount
     C                   EXSR      CompareUsers
     C                   EVAL      a = a + 1
     C                   EVAL      b = a + 1
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *
     C     CompareUsers  BEGSR
      *
     C                   DOW       b <= 9999
     C                   EVAL      User01 = UserList1(a)
     C                   EVAL      User02 = UserList2(b)
     C                   IF        First = 'Y'
     C                   EVAL      First = 'N'
     C                   ELSE
     C                   EVAL      MbrOpt = '*ADD    '
     C                   ENDIF
     C                   CALL      'QCMDEXC'
     C                   PARM                    BFCMPUSR
     C                   PARM                    CommandLen
     C                   EVAL      b = b + 1
     C                   ENDDO
      *
     C     CompareUsersE ENDSR
      *
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
