     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP File Compare and report')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009006 - File compare and report                           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. AR926961A          Date 28Mar12               *
      *  Prev Amend No. CUP021  *CREATE    Date 20Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR926961A - Menu item does not appear even if user already   *
      *             has permission and menu item                      *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************
     FUP009006P1O    E             PRINTER INFDS(SPOOL)
     FUPAFCPL0  O  A E           K DISK
     FUPAFFDL1  IF   E           K DISK
     FUPAFFDL2  IF   E           K DISK    RENAME(UPAFFDD0:C_UPAFFDD0)
     F                                     PREFIX(C_)
     FUPAFODPD  IF   E             DISK
      *
     D BldHeader       C                   'BUILD - the differences between a +
     D                                     "Before" and "After" system'
     D RvwHeader       C                   'REVIEW - the differences between a +
     D                                     "Before" and "After" system"'
     D CftHeader       C                   'CONFLICT - potential problems +
     D                                     between an Action File and the +
     D                                     current system (target) file'
      *
     D Counter         C                   '---------+---------+---------+------
     D                                     ----+---------+---------+---------+--
     D                                     --------+---------+---------+'
      *
     D RecNotFound     C                   '****** Record not Found ******'
      *
     D PrintAtnF       S              1A
     D GenActn         S              1A
     D TrgOffs         S              3  0
     D RMLN            S              2  0
     D ActnCount       S              5  0
     D STMT            S            500A
     D NExStmt         S            500A
     D ActualFile      S              1A
     D COUNT           S            100
     D Count36         S             36
     D DelAct          S              1A
     D Mode            S              4A
     D FileName        S             10A
     D BefLib          S             10A
     D AftLib          S             10A
     D FData           S           6000A
     D ErrData         S           6000A
     D ErrPrinted      S              1A
     D CompErr         S              1A
     D FieldErr        S              1A
     D Idx             S              4  0
     D StrNum          S             15A
     D EndPos          S              4  0
     D Pos             S              4A
     D Pos2            S              4A
     D Len             S              4A
     D NPos            S              4  0
     D NPos2           S              4  0 DIM(10)
     D NLen            S              4  0 DIM(10)
     D Num             S              3  0
     D Nrfd            S              1A
     D KNum            S              3  0
     D FPos            S             30A
     D FPos2           S             30A
     D*KeyField*       S             50A   DIM(10)                                       //AR926961A
     D*KEY1*****       S             50A                                                 //AR926961A
     D*KEY2*****       S             50A                                                 //AR926961A
     D*KEY3*****       S             50A                                                 //AR926961A
     D*KEY4*****       S             50A                                                 //AR926961A
     D*KEY5*****       S             50A                                                 //AR926961A
     D*KEY6*****       S             50A                                                 //AR926961A
     D*KEY7*****       S             50A                                                 //AR926961A
     D*KEY8*****       S             50A                                                 //AR926961A
     D*KEY9*****       S             50A                                                 //AR926961A
     D*KEY10****       S             50A                                                 //AR926961A
     D KeyField        S            256A   DIM(10)                                       //AR926961A
     D KEY1            S            256A                                                 //AR926961A
     D KEY2            S            256A                                                 //AR926961A
     D KEY3            S            256A                                                 //AR926961A
     D KEY4            S            256A                                                 //AR926961A
     D KEY5            S            256A                                                 //AR926961A
     D KEY6            S            256A                                                 //AR926961A
     D KEY7            S            256A                                                 //AR926961A
     D KEY8            S            256A                                                 //AR926961A
     D KEY9            S            256A                                                 //AR926961A
     D KEY10           S            256A                                                 //AR926961A
     D Operr           S              1A
     D OpenErr         S              1A
     D LineRequire     S              2  0
     D Rmer            S              5  3
     D StPos           S              5  0
     D LnPrt           S              5  0
     D NotSame         S              1A
     D NoRecF          S              1A
     D FFldValue       S             15  0
     D CFldValue       S             15  0
     D CNumber         S             15  0
     D WFile           S             10
     D WKey            S              1
     D DriverName      S             10
     D RecLength       S              5  0
     D ActionFile      S              1
     D FieldOffs       S              3  0
     D Recursive       S              1
      *
     DFmtInp           DS
     D FmtInp30A               1     30A
     D FmtInp01P               1     01P 0
     D FmtInp03P               1     02P 0
     D FmtInp05P               1     03P 0
     D FmtInp07P               1     04P 0
     D FmtInp09P               1     05P 0
     D FmtInp11P               1     06P 0
     D FmtInp13P               1     07P 0
     D FmtInp15P               1     08P 0
     D FmtInp17P               1     09P 0
     D FmtInp19P               1     10P 0
     D FmtInp21P               1     11P 0
     D FmtInp23P               1     12P 0
     D FmtInp25P               1     13P 0
     D FmtInp27P               1     14P 0
     D FmtInp29P               1     15P 0
     D FmtInp01S               1     01S 0
     D FmtInp02S               1     02S 0
     D FmtInp03S               1     03S 0
     D FmtInp04S               1     04S 0
     D FmtInp05S               1     05S 0
     D FmtInp06S               1     06S 0
     D FmtInp07S               1     07S 0
     D FmtInp08S               1     08S 0
     D FmtInp09S               1     09S 0
     D FmtInp10S               1     10S 0
     D FmtInp11S               1     11S 0
     D FmtInp12S               1     12S 0
     D FmtInp13S               1     13S 0
     D FmtInp14S               1     14S 0
     D FmtInp15S               1     15S 0
     D FmtInp16S               1     16S 0
     D FmtInp17S               1     17S 0
     D FmtInp18S               1     18S 0
     D FmtInp19S               1     19S 0
     D FmtInp20S               1     20S 0
     D FmtInp21S               1     21S 0
     D FmtInp22S               1     22S 0
     D FmtInp23S               1     23S 0
     D FmtInp24S               1     24S 0
     D FmtInp25S               1     25S 0
     D FmtInp26S               1     26S 0
     D FmtInp27S               1     27S 0
     D FmtInp28S               1     28S 0
     D FmtInp29S               1     29S 0
     D FmtInp30S               1     30S 0
      *
     DSPOOL            DS
     D SFILE                  83     92
     D SFNUM                 123    124B 0
     D OFLLN                 188    189B 0
     D PRTLN                 367    368B 0
      *
     C                   EVAL      ActnCount = 0
     C                   EVAL      DelAct  = 'N'
     C                   EVAL      FPos = *blanks
     C                   EVAL      STMT = 'select * from UPAFNDPD where '
     C                   EVAL      NExStmt = 'select * from UPAFNDPD a '
     C                             + 'where not exists (select * from '
     C                             + 'UPAFODPD b where '
     C                   EVAL      *IN60 = '0'
     C                   EVAL      KNum = 0
     C                   EVAL      ActualFile = 'Y'
     C                   MOVEL     'UP009006'    RPGM
     C                   EVAL      ErrPrinted = 'N'
      *
     C                   IF        FieldOffs <> 0
     C                             or ActionFile = 'Y'
     C                   EVAL      ActualFile = 'N'
     C                   ENDIF
      *
     C     RecLength     DIV       100           LineRequire
     C                   MVR                     Rmer
     C                   IF        Rmer <> 0
     C                   EVAL      LineRequire = LineRequire + 1
     C                   ENDIF
      *
     C                   MOVE      FileName      WFile
     C                   MOVE      *LOVAL        WKey
      *
      * Get keys to join two files and build SQL Statment.
     C     FFDKey        SETLL     UPAFFDL1
     C                   DOW       *IN60 = '0'
     C     WFile         READE     UPAFFDL1                               60
     C                   IF        *IN60 = '0'
     C                   EVAL      KNum = KNum + 1
     C                   EVAL      NLen(KNum) = AFFDLN
     C                   EVAL      NPos2(KNum) = AFFDPS + FieldOffs
     C                   MOVE      NPos2(KNum)   Pos2
     C                   EVAL      NPos = AFFDPS + TrgOffs
     C                   MOVE      AFFDLN        Len
     C                   MOVE      NPos          Pos
     C                   EXSR      BuildStm
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        KNum > 0 and KNum <= 10
      *
      * Initialise SQL.
     C                   EXSR      PrepSQLStm
     C                   IF        OpenErr = 'N'
      *
      * Read driving file until EOF.
     C     *IN61         DOWEQ     '0'
     C                   READ      UPAFODPD                               61
     C                   IF        *IN61 = '0'
     C                   EVAL      CompErr = 'N'
     C                   EXSR      BuildKey
     C                   EXSR      FetchSQLRec
     C                   EVAL      ErrData = *blanks
     C                   IF        CompErr = 'N'
     C                   EXSR      CompareFlds
     C                   ENDIF
      * If producing a conflict report then some flagged errors may not actually
      *  be errors and vice versa.
     C                   IF        Mode = '*CFT'
     C                   IF        %SUBST(AWDATA:15:1) = 'I' and
     C                             Nrfd = 'N'
     C                   EVAL      CompErr = 'Y'
     C                   ENDIF
     C                   IF        %SUBST(AWDATA:15:1) = 'I' and
     C                             Nrfd = 'Y'
     C                   EVAL      CompErr = 'N'
     C                   ENDIF
     C                   IF        %SUBST(AWDATA:15:1) = 'D' and
     C                             Nrfd = 'Y'
     C                   EVAL      CompErr = 'Y'
     C                   ENDIF
     C                   IF        %SUBST(AWDATA:15:1) = 'D' and
     C                             Nrfd = 'N'
     C                   EVAL      CompErr = 'N'
     C                   ENDIF
      * If 'Ignore Action' is set to 'Y' then do not print anyway.
     C                   IF        %SUBST(AWDATA:17:1) = 'Y'
     C                   EVAL      CompErr = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        CompErr = 'Y'
     C                   EXSR      PrintReport
     C                   IF        GenActn = 'Y'
     C                   EXSR      OutAction
     C                   ENDIF
     C                   EVAL      ErrPrinted = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
      * If comparing actual file, check if there are records missing
      *  in the driving file.
     C                   IF        FieldOffs = 0
     C                   EXSR      CheckExist
     C                   IF        ErrPrinted = 'N'
     C                   WRITE     HEADH                                70
     C                   WRITE     NOERRS                               70
     C                   ENDIF
     C                   ENDIF
      *
      * If key is not setup or incorrect.
     C                   ELSE
     C                   WRITE     HEADH                                70
     C                   WRITE     KEYERR                               70
     C                   ENDIF
      *
     C                   EXSR      Overflow
     C                   WRITE     TRAILP                               70
      *
     C                   SETON                                        LR
      /EJECT
      *****************************************************************
      *                                                               *
      * Prepare SQL statement                                         *
      *                                                               *
      *****************************************************************
     C     PrepSQLStm    BEGSR
      *
     C                   EVAL      OpenErr = 'Y'
     C/exec SQL whenever SQLERROR goto ERRP1
     C/END-EXEC

     C/EXEC SQL
     C+ prepare S1 from :STMT
     C/END-EXEC

     C/EXEC SQL
     C+ DECLARE C1 CURSOR FOR S1
     C/END-EXEC

     C                   EVAL      OpenErr = 'N'
      *
     C     ERRP1         TAG
      *
     C     PrepSQLStmE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Fetch SQL record                                              *
      *                                                               *
      *****************************************************************
     C     FetchSQLRec   BEGSR
      *
     C                   EVAL      FData = *blanks
     C                   EVAL      Operr = 'P'
     C                   EVAL      Nrfd  = 'Y'
      *
     C/exec SQL whenever SQLERROR goto ERROP
     C/END-EXEC
     C                   IF        KNum = 1
     C/EXEC SQL
     C+ open C1 using :KEY1
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 2
     C/EXEC SQL
     C+ open C1 using :KEY1,
     C+               :KEY2
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 3
     C/EXEC SQL
     C+ open C1 using :KEY1,:KEY2,:KEY3
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 4
     C/EXEC SQL
     C+ open C1 using :KEY1,:KEY2,:KEY3,:KEY4
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 5
     C/EXEC SQL
     C+ open C1 using :KEY1,:Key2,:KEY3,:KEY4,:KEY5
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 6
     C/EXEC SQL
     C+ open C1 using :KEY1,:Key2,:KEY3,:KEY4,:KEY5,:KEY6
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 7
     C/EXEC SQL
     C+ open C1 using :KEY1,:Key2,:KEY3,:KEY4,:KEY5,:KEY6,:KEY7
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 8
     C/EXEC SQL
     C+ open C1 using :KEY1,:Key2,:KEY3,:KEY4,:KEY5,:KEY6,:KEY7,
     C+               :KEY8
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 9
     C/EXEC SQL
     C+ open C1 using :KEY1,:Key2,:KEY3,:KEY4,:KEY5,:KEY6,:KEY7,
     C+               :KEY8,:KEY9
     C/END-EXEC
     C                   ENDIF
      *
     C                   IF        KNum = 10
     C/EXEC SQL
     C+ open C1 using :KEY1,:Key2,:KEY3,:KEY4,:KEY5,:KEY6,:KEY7,
     C+               :KEY8,:KEY9,:KEY10
     C/END-EXEC
     C                   ENDIF
     C                   EVAL      Operr = 'O'
      *
     C/exec SQL whenever NOT FOUND goto NRECF
     C/END-EXEC
      *
     C/EXEC SQL
     C+  fetch C1 into :FData
     C/END-EXEC
      *
     C                   EVAL      Nrfd  = 'N'
     C     NRECF         TAG
     C/EXEC SQL
     C+  close C1
     C/END-EXEC
      *
     C     ERROP         TAG
     C                   IF        Nrfd = 'Y'
     C                   EVAL      FData = RecNotFound
     C                   EVAL      CompErr = 'Y'
     C                   ENDIF
      *
     C     FetchSQLRecE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Build statement                                               *
      *                                                               *
      *****************************************************************
     C     BuildStm      BEGSR
      *
      /free
       FPos = %TRIM(Pos) + ',' + %TRIM(Len) + ')';
       FPos2 = %TRIM(Pos2) + ',' + %TRIM(Len) + ')';
       If KNum > 1;
          STMT = %TRIM(STMT) + ' and ';
          NExStmt = %TRIM(NExStmt) + ' and';
       endif;

       STMT = %TRIM(STMT)+ ' SUBSTR(WTDATA,' + %TRIM(FPos)+' =  ?';
       NExStmt = %TRIM(NExStmt) + ' SUBSTR(a.WTDATA,' + %TRIM(FPos)
                   + ' = SUBSTR(b.AWDATA,' + %TRIM(FPOS2);
      /END-free
      *
     C     BuildStmE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Build key                                                     *
      *                                                               *
      *****************************************************************
     C     BuildKey      BEGSR
      *
      /free
       Num = 1;
       DOW  Num < KNum or Num = KNum;
            KeyField(Num) = %SUBST(AWDATA:NPos2(Num):NLen(NUM));
            Num = Num + 1;
       ENDDO;
       KEY1 = KeyField(1);
       KEY2 = KeyField(2);
       KEY3 = KeyField(3);
       KEY4 = KeyField(4);
       KEY5 = KeyField(5);
       KEY6 = KeyField(6);
       KEY7 = KeyField(7);
       KEY8 = KeyField(8);
       KEY9 = KeyField(9);
       KEY10 = KeyField(10);
      /end-free
      *
     C     BuildKeyE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Compare fields                                                *
      *                                                               *
      *****************************************************************
     C     CompareFlds   BEGSR
      *
     C                   MOVE      '0'           *IN60
     C                   IF        Nrfd = 'N'
     C     WFile         SETLL     UPAFFDL2
      *
     C                   DOW       *IN60 = '0'
     C     WFile         READE     UPAFFDL2                               60
     C                   IF        *IN60 = '0'
      *
      * Only compare fields if the field exist.
     C                   IF        RecLength >= C_AFFDPS
      *
      /free
       FieldErr = 'N';
       IF  C_AFFDTP = 'S' or C_AFFDTP = 'P';
           EXSR CompNumeric;
       ELSE;
          IF  %SUBST(AWDATA:C_AFFDPS + FieldOffs :C_AFFDLN)
                <> %SUBST(FData:C_AFFDPS + TrgOffs:C_AFFDLN);
              FieldErr = 'Y';
          ENDIF;
       ENDIF;
       IF  FieldErr = 'Y';
              CompErr = 'Y';
              Idx = 0;
              DOW Idx < C_AFFDLN or Idx = C_AFFDLN;
               %SUBST(ErrData:C_AFFDPS:C_AFFDLN)
                  =  %TRIM(%SUBST(ErrData:C_AFFDPS:C_AFFDLN))
                      + C_AFDIFF;
               Idx = Idx + 1;
              ENDDO;
       ENDIF;
      /end-free
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
     C     CompareFldsE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Print report                                                  *
      *                                                               *
      *****************************************************************
      *
     C     PrintReport   BEGSR
      *
     C                   EVAL      LnPrt = 0
      * Set up Action text.
     C                   EVAL      RACT = *blanks
     C                   IF        ActionFile = 'Y'
     C                   IF        %SUBST(AWDATA:15:1)= 'A'
     C                   EVAL      RACT = 'Amend'
     C                   ENDIF
     C                   IF        %SUBST(AWDATA:15:2)= 'I '
     C                   IF        PrintAtnF = 'Y'
     C                   EVAL      %SUBST(FData:FieldOffs + 1) = RecNotFound
     C                   EVAL      ErrData = *blanks
     C                   ENDIF
     C                   EVAL      RACT = 'Insert'
     C                   ENDIF
     C                   IF        %SUBST(AWDATA:15:2)= 'D '
     C                   IF        PrintAtnF = 'Y'
     C                   EVAL      FData = AWDATA
     C                   EVAL      %SUBST(AWDATA:FieldOffs + 1) = RecNotFound
     C                   EVAL      ErrData = *blanks
     C                   ENDIF
     C                   EVAL      RACT = 'Delete'
     C                   ENDIF
     C                   ENDIF
     C                   DOU       LineRequire <= LnPrt
     C                   EVAL      StPos = (LnPrt * 100) + 1
     C                   EVAL      RDNUM = StPos
     C                   EXSR      Overflow
      *
     C                   EVAL      RCNT = Counter
     C                   EVAL      RINDL = %SUBST(ErrData:StPos:100)
     C                   EVAL      RSYSL = %SUBST(FData:StPos + TrgOffs:100)
     C                   EVAL      RUPDL =
     C                                %SUBST(AWDATA:StPos + FieldOffs:100)
      *
      * For builds work out the Action type for the report.
     C                   IF        RACT = *blanks
     C                   IF        %SUBST(RSYSL:1:10) = '****** Rec'
     C                   EVAL      RACT = 'Insert'
     C                   ELSE
     C                   IF        %SUBST(RUPDL:1:10) = '****** Rec'
     C                   EVAL      RACT = 'Delete'
     C                   ELSE
     C                   EVAL      RACT = 'Amend'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     DTL2                                 70
      *
     C                   EVAL      LnPrt = LnPrt + 1
      *
     C                   ENDDO
      *
     C     PrintReportE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Overflow processing                                           *
      *                                                               *
      *****************************************************************
      *
     C     Overflow      BEGSR
      *
     C     OFLLN         SUB       PRTLN         RMLN
      *
     C                   IF        RMLN <= 8
     C                   WRITE     HEADH                                70
     C                   ENDIF
      *
     C     OverflowE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * Check existence                                               *
      *                                                               *
      *****************************************************************
     C     CheckExist    BEGSR
      *
     C                   EVAL      DelAct  = 'Y'
     C                   EVAL      OpenErr = 'Y'
     C                   EVAL      NExStmt = %TRIM(NExStmt) + ')'
      *
     C/exec SQL whenever SQLERROR goto ErrTag1
     C/END-EXEC
     C/exec SQL whenever NOT FOUND goto NRFTag
     C/END-EXEC
      *
     C/EXEC SQL
     C+ prepare S2 from :NExStmt
     C/END-EXEC
      *
     C/EXEC SQL
     C+ declare C2 cursor for S2
     C/END-EXEC
      *
     C/EXEC SQL
     C+ open C2
     C/END-EXEC
     C                   EVAL      OpenErr = 'N'
      *
     C     ErrTag1       TAG
      *
     C                   IF        OpenErr = 'N'
     C/exec SQL whenever NOT FOUND goto NRFTag
     C/END-EXEC
      *
     C                   MOVE      'N'           NoRecF
     C                   MOVE      'N'           NotSame
     C                   DOW       NoRecF = 'N'
     C                   MOVE      'Y'           NoRecF
     C/EXEC SQL
     C+  fetch C2 into :FData
     C/END-EXEC
     C                   EVAL      ErrData = *blanks
     C                   EVAL      AWDATA = RecNotFound
     C                   EXSR      PrintReport
     C                   EVAL      ErrPrinted = 'Y'
     C                   MOVE      'Y'           NotSame
     C                   MOVE      'N'           NoRecF
     C                   IF        GenActn = 'Y'
     C                   EXSR      OutAction
     C                   ENDIF
      *
     C     NRFTag        TAG
     C                   ENDDO
      *
     C/exec SQL whenever SQLERROR goto ErrTag2
     C/END-EXEC
      *
     C/EXEC SQL
     C+  close C2
     C/END-EXEC
     C                   ENDIF
      *
     C     ErrTag2       TAG
      *
     C     CheckExistE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Compare numerics                                              *
      *                                                               *
      *****************************************************************
     C     CompNumeric   BEGSR
      *
     C                   EVAL      FmtInp30A = *blanks
      /free
          FmtInp30A  =  %SUBST(AWDATA:C_AFFDPS + FieldOffs:C_AFFDLN);
      /end-free
     C                   IF        C_AFFDTP = 'P'
     C                   EXSR      ConvPack
     C                   ELSE
     C                   EXSR      ConvSign
     C                   ENDIF
     C                   EVAL      FFldValue = CNumber
      *
     C                   EVAL      FmtInp30A = *blanks
      /free
        FmtInp30A = %SUBST(FData:C_AFFDPS + TrgOffs:C_AFFDLN);
      /end-free
     C                   IF        C_AFFDTP = 'P'
     C                   EXSR      ConvPack
     C                   ELSE
     C                   EXSR      ConvSign
     C                   ENDIF
     C                   EVAL      CFldValue = CNumber
      *
     C                   IF        FFldValue <> CFldValue
     C                   EVAL      FieldErr = 'Y'
     C                   ENDIF
      *
     C     CompNumericE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Convert packed fields                                         *
      *                                                               *
      *****************************************************************
     C     ConvPack      BEGSR
      *
     C     FmtInp30A     IFEQ      *BLANK
     C                   EVAL      CNumber = 0
     C                   ELSE
      *
     C                   SELECT
     C     C_AFFDLN      WHENEQ    01
     C                   EVAL      CNumber = FmtInp01P
     C     C_AFFDLN      WHENEQ    02
     C                   EVAL      CNumber    = FmtInp03P
     C     C_AFFDLN      WHENEQ    03
     C                   EVAL      CNumber    = FmtInp05P
     C     C_AFFDLN      WHENEQ    04
     C                   EVAL      CNumber    = FmtInp07P
     C     C_AFFDLN      WHENEQ    05
     C                   EVAL      CNumber    = FmtInp09P
     C     C_AFFDLN      WHENEQ    06
     C                   EVAL      CNumber    = FmtInp11P
     C     C_AFFDLN      WHENEQ    07
     C                   EVAL      CNumber    = FmtInp13P
     C     C_AFFDLN      WHENEQ    08
     C                   EVAL      CNumber    = FmtInp15P
     C     C_AFFDLN      WHENEQ    09
     C                   EVAL      CNumber    = FmtInp17P
     C     C_AFFDLN      WHENEQ    10
     C                   EVAL      CNumber    = FmtInp19P
     C     C_AFFDLN      WHENEQ    11
     C                   EVAL      CNumber    = FmtInp21P
     C     C_AFFDLN      WHENEQ    12
     C                   EVAL      CNumber    = FmtInp23P
     C     C_AFFDLN      WHENEQ    13
     C                   EVAL      CNumber    = FmtInp25P
     C     C_AFFDLN      WHENEQ    14
     C                   EVAL      CNumber    = FmtInp27P
     C     C_AFFDLN      WHENEQ    15
     C                   EVAL      CNumber    = FmtInp29P
     C                   OTHER
     C                   EVAL      CNumber    = 0
     C                   ENDSL
     C                   ENDIF
      *
     C     ConvPackE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Convert signed fields                                         *
      *                                                               *
      *****************************************************************
     C     ConvSign      BEGSR
      *
     C     FmtInp30A     IFEQ      *BLANK
     C                   EVAL      CNumber = 0
     C                   ELSE
      *
     C                   SELECT
     C     C_AFFDLN      WHENEQ    01
     C                   EVAL      CNumber = FmtInp01S
     C     C_AFFDLN      WHENEQ    02
     C                   EVAL      CNumber = FmtInp02S
     C     C_AFFDLN      WHENEQ    03
     C                   EVAL      CNumber = FmtInp03S
     C     C_AFFDLN      WHENEQ    04
     C                   EVAL      CNumber = FmtInp04S
     C     C_AFFDLN      WHENEQ    05
     C                   EVAL      CNumber = FmtInp05S
     C     C_AFFDLN      WHENEQ    06
     C                   EVAL      CNumber = FmtInp06S
     C     C_AFFDLN      WHENEQ    07
     C                   EVAL      CNumber = FmtInp07S
     C     C_AFFDLN      WHENEQ    08
     C                   EVAL      CNumber = FmtInp08S
     C     C_AFFDLN      WHENEQ    09
     C                   EVAL      CNumber = FmtInp09S
     C     C_AFFDLN      WHENEQ    10
     C                   EVAL      CNumber = FmtInp10S
     C     C_AFFDLN      WHENEQ    11
     C                   EVAL      CNumber = FmtInp11S
     C     C_AFFDLN      WHENEQ    12
     C                   EVAL      CNumber = FmtInp12S
     C     C_AFFDLN      WHENEQ    13
     C                   EVAL      CNumber = FmtInp13S
     C     C_AFFDLN      WHENEQ    14
     C                   EVAL      CNumber = FmtInp14S
     C     C_AFFDLN      WHENEQ    15
     C                   EVAL      CNumber = FmtInp15S
     C     C_AFFDLN      WHENEQ    16
     C                   EVAL      CNumber = FmtInp16S
     C     C_AFFDLN      WHENEQ    17
     C                   EVAL      CNumber = FmtInp17S
     C     C_AFFDLN      WHENEQ    18
     C                   EVAL      CNumber = FmtInp18S
     C     C_AFFDLN      WHENEQ    19
     C                   EVAL      CNumber = FmtInp19S
     C     C_AFFDLN      WHENEQ    20
     C                   EVAL      CNumber = FmtInp20S
     C     C_AFFDLN      WHENEQ    21
     C                   EVAL      CNumber = FmtInp21S
     C     C_AFFDLN      WHENEQ    22
     C                   EVAL      CNumber = FmtInp22S
     C     C_AFFDLN      WHENEQ    23
     C                   EVAL      CNumber = FmtInp23S
     C     C_AFFDLN      WHENEQ    24
     C                   EVAL      CNumber = FmtInp24S
     C     C_AFFDLN      WHENEQ    25
     C                   EVAL      CNumber = FmtInp25S
     C     C_AFFDLN      WHENEQ    26
     C                   EVAL      CNumber = FmtInp26S
     C     C_AFFDLN      WHENEQ    27
     C                   EVAL      CNumber = FmtInp27S
     C     C_AFFDLN      WHENEQ    28
     C                   EVAL      CNumber = FmtInp28S
     C     C_AFFDLN      WHENEQ    29
     C                   EVAL      CNumber = FmtInp29S
     C     C_AFFDLN      WHENEQ    30
     C                   EVAL      CNumber = FmtInp30S
     C                   OTHER
     C                   EVAL      CNumber = 0
     C                   ENDSL
     C                   ENDIF
      *
     C     ConvSignE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Generate Action File                                          *
      *                                                               *
      *****************************************************************
     C     OutAction     BEGSR
      *
      * Only generate action file if compare is using actual files.
     C                   IF        ActualFile = 'Y'
     C                   EVAL      ATFILE  = FileName
     C                   EVAL      ATIGNA = ' '
      *
     C                   IF        DelAct  = 'N'
     C                   EVAL      ATDATA = AWDATA
      *
     C                   IF        Nrfd = 'Y'
     C                   EVAL      ATACT = 'I'
     C                   ELSE
     C                   EVAL      ATACT = 'A'
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      ATACT = 'D'
     C                   EVAL      ATDATA = FData
     C                   ENDIF
      *
     C                   EVAL      ActnCount = ActnCount + 1
     C                   EVAL      ATNUMB = ActnCount
      *
     C                   WRITE     UPAFCPD0
      *
     C                   IF        ATACT = 'A'
     C                   EVAL      ATACT = 'AB'
     C                   EVAL      ActnCount = ActnCount + 1
     C                   EVAL      ATNUMB = ActnCount
     C                   EVAL      ATDATA = FDATA
     C                   EVAL      ATIGNA = 'Y'
     C                   WRITE     UPAFCPD0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     OutActionE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode
     C                   PARM                    FileName
     C                   PARM                    DriverName
     C                   PARM                    RecLength
     C                   PARM                    ActionFile
     C                   PARM                    FieldOffs
     C                   PARM                    PrintAtnF
     C                   PARM                    BefLib
     C                   PARM                    AftLib
      *
      * Set up program run condition.
     C                   IF        PrintAtnF = 'Y'
     C                   EVAL      TrgOffs = 17
     C                   ELSE
     C                   EVAL      TrgOffs = 0
     C                   ENDIF
     C                   IF        ActionFile = 'Y'
     C                   EVAL      GenActn = 'N'
     C                   ELSE
     C                   EVAL      GenActn = 'Y'
     C                   ENDIF
      *
      * Set up text for report.
     C                   IF        Mode = '*BLD'
     C                   EVAL      RHDR = BldHeader
     C                   EVAL      RFL1T = 'Before file :'
     C                   EVAL      RFL2T = 'After file  :'
     C                   EVAL      RFIL1 = %TRIMR(BefLib) + '/' + FileName
     C                   EVAL      RFIL2 = %TRIMR(AftLib) + '/' + FileName
     C                   EVAL      RTTXT = 'Before     :'
     C                   EVAL      RFTXT = 'After      :'
     C                   ENDIF
      *
     C                   IF        Mode = '*RVW'
     C                   EVAL      RHDR = RvwHeader
     C                   EVAL      RFL1T = 'Before file :'
     C                   EVAL      RFL2T = 'After file  :'
     C                   EVAL      RFIL1 = FileName
     C                   EVAL      RFIL2 = FileName
     C                   EVAL      RTTXT = 'Before     :'
     C                   EVAL      RFTXT = 'After      :'
     C                   ENDIF
      *
     C                   IF        Mode = '*CFT'
     C                   EVAL      RHDR = CftHeader
     C                   EVAL      RFL1T = 'Target file :'
     C                   EVAL      RFL2T = 'Action file :'
     C                   EVAL      RFIL1 = %TRIMR(AftLib) + '/' + FileName
     C                   EVAL      RFIL2 = FileName
     C                   EVAL      RTTXT = 'Target     :'
     C                   EVAL      RFTXT = 'Action     :'
     C                   ENDIF
      *
     C     FFDKey        KLIST
     C                   KFLD                    WFile
     C                   KFLD                    WKey
      *
     C     INZSRE        ENDSR
      /EJECT
      ********************************************************************
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *blanks
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
