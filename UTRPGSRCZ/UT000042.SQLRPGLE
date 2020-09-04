      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
     F*****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas UT Locate Program Source')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000042 - Report reference users                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CBF011   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
     F*****************************************************************

     D LibLDS          DS
     D Libr                          10A   DIM(10)

     D SrcList         DS
     D Srcf                          10A   DIM(4)

     D FileFound       S              1A
     D OpenErr         S              1A
     D RecCount        S              5  0
     D LibS            S            100A

     D ModulePrx       S              2A
     D PgmType         S              1A
     D FileName        S             10A
     D LibName         S             10A
     D MemberName      S             10A
     D OutFile         S             10A
     D STMT            S            100A
     D SubFd           S              4A
     D FdLen           S              2  0
     D Idx             S              2  0
     D FIdx            S              2  0

     D @UC             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D @LC             C                   'abcdefghijklmnopqrstuvwxyz'

      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************

     C                   EVAL      MemberName = %XLATE(@LC:@UC:MemberName)
     C                   EVAL      OutFile = *BLANKS
     C                   EVAL      LibName = *BLANKS
     C                   EVAL      ModulePrx = %Subst(%Trim(MemberName):1:2)
     C                   EVAL      PGMTYPE = %Subst(%Trim(MemberName):3:1)

     C                   IF        PGMTYPE = 'C'
     C                   EVAL      SubFd = %SUBST(MemberName:4:4)
     C                   TESTN                   SubFd                212223
     C                   IF        *IN21 = '0'
     C                   EVAL      PGMTYPE = 'R'
     C                   ENDIF
     C                   ENDIF

     C                   EXSR      GetLibList

     C                   IF        PgmType <> 'C'
     C                   EVAL      Srcf(1)  = ModulePrx + 'RPGSRCZ'
     C                   EVAL      Srcf(2)  = ModulePrx + 'RPGCTRZ'
     C                   EVAL      Srcf(3)  = ModulePrx + 'RPGSRCG'
     C                   EVAL      Srcf(4)  = ModulePrx + 'RPGCTRG'

     C                   Eval      FIdx = 0

     C                   DOW       FIdx < 4
     C                   EVAL      FIdx = FIdx +1
     C                   EVAL      FileName = Srcf(FIdx)
     C                   EVAL      Idx = 0

     C                   DOW       Idx < 10
     C                   EVAL      Idx = Idx + 1

     C                   IF        Libr(Idx) <> *BLANKS
     C                   EVAL      LibName = Libr(Idx)
     C                   EXSR      CheckExist
     C                   IF        FileFound = 'Y'
     C                   EVAL      Idx = 11
     C                   EVAL      FIdx = 5
     C                   EVAL      OutFile = FileName
     C                   ENDIF
     C                   ELSE
     C                   EVAL      Idx = 11
     C                   ENDIF

     C                   ENDDO
     C                   ENDDO

     C                   ELSE
     C                   EVAL      OutFile = 'CLP'
     C                   ENDIF

     C                   SETON                                            LR

      *****************************************************************
      *                                                               *
      * GetLibList - Get Library List for finding the latest Source   *
      *                                                               *
      *****************************************************************
     C     GetLibList    BEGSR

     C                   EVAL      OpenErr = 'Y'

     C/EXEC SQL WHENEVER SQLERROR GOTO LibErr
     C/END-EXEC

     C/EXEC SQL
     C+ Select LibLst  into :LibS  from UTLIBLPD
     C/END-EXEC

     C                   EVAL      OpenErr = 'N'
     C                   EVAL      LibLDS = LibS

     C     LibErr        TAG

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * CheckExist - Check if the Source Member in the Library and    *
      *              File                                             *
      *                                                               *
      *****************************************************************
     C     CheckExist    BEGSR

     C                   EVAL      FileFound = 'N'
     C                   EVAL      RecCount = 0

      /free
        Stmt = 'CREATE ALIAS QTEMP/TempX for ' + %trim(LibName)
                + '/' + %trim(FileName) + '  (' + %trim(MemberName) + ')';
      /end-free

     C/EXEC SQL WHENEVER SQLERROR GOTO NotFound
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :Stmt
     C/END-EXEC

     C/EXEC SQL
     C+ Select count(*) into :RecCount from TempX
     C/END-EXEC

     C                   IF        RecCount > 0
     C                   EVAL      FileFound = 'Y'
     C                   ENDIF

     C     NotFound      TAG

     C/EXEC SQL
     C+ Drop ALIAS QTEMP/TempX
     C/END-EXEC

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    MemberName
     C                   PARM                    LibName
     C                   PARM                    OutFile

     C                   ENDSR

