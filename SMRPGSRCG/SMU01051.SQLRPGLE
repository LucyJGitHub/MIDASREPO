     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update Base rate fields')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU01051 - Update of Base rate fields to conform with new    *
      *              type of base rates which is alphanumeric         *
      *                                                               *
      *  Function: This program will set Base rate fields of files    *
      *            from zero to blanks and from 'X_' to '0X' where X  *
      *            is a single digit number.                          *
      *                                                               *
      *  (c)Finastra International Limited 2020                       *
      *                                                               *
      *  Last Amend No. MD059184           Date 05Nov21               *
      *  Prev Amend No. CSD103    *CREATE  Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059184 - Enhance Update via SQL Command                    *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
      *
      **---------------------------------------------------------------
     F***SMFILUPD  IF   E           K DISK    INFSR(*PSSR)                                  MD059184
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+
     D Layer           S              6A
     D*UFILE****       S             10A                                                    MD059184
     D*UFIELD***       S             10A                                                    MD059184
     D*thisSQL**       S            500                                                     MD059184
     D*thisSQL1*       S            500                                                     MD059184
     D*thisSQL2*       S            500                                                     MD059184
     D*thisSQL3*       S            500                                                     MD059184
     D*thisSQL4*       S            500                                                     MD059184
     D*thisSQL5*       S            500                                                     MD059184
     D*thisSQL6*       S            500                                                     MD059184
     D*thisSQL7*       S            500                                                     MD059184
     D*thisSQL8*       S            500                                                     MD059184
     D*thisSQL9*       S            500                                                     MD059184
      ** Indicator Array
     D*Indicators      DS                  BASED(IndicatorP)                                MD059184
     D**ErrorOnFl             35     35                                                     MD059184
     D**EndOfFile             45     45                                                     MD059184
      ** Pointer for the indicator Array
     D*IndicatorP      S               *   INZ(%Addr(*IN))                                  MD059184
      **
     D Command         S           2764
      ** Additional Field for File Processing                                               MD059184
     D PrevFileName    S             10A   INZ(*BLANKS)                                     MD059184
     D PrevPFMember    S             10A   INZ(*BLANKS)                                     MD059184
     D CurrFileName    S             10A   INZ(*BLANKS)                                     MD059184
     D CurrPFMember    S             10A   INZ(*BLANKS)                                     MD059184
     D IsFileFirstRec  S              1  0 INZ(0)                                           MD059184
     D FieldCounter    S              2  0 INZ(1)                                           MD059184
     D SortSQLStmnt    S           2000A   INZ(*BLANKS)                                     MD059184
     D SMFileUpdate  E DS                  EXTNAME(SMFILUPD)                                MD059184
     D TotFldCount     S              5  0 INZ(0)                                           MD059184
     D ExtFldArray     S             10A   DIM(60)                                          MD059184
     D updStatement    S            500A                                                    MD059184
     D execStatement   S          12000                                                     MD059184
     D sqlStatement    S          12000    DIM(60)                                          MD059184
     D condStatement   S          12000    DIM(60)                                          MD059184
     D Cnt             S              2  0 INZ(0)                                           MD059184
     D ExecCnt         S              2  0 INZ(1)                                           MD059184

      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     C******LOVAL        SETLL     SMFILUPD                                                 MD059184
     C***********        READ      SMFILUD0                             3545                MD059184

      *
      ** Database error
      *
     C**********         IF        ErrorOnFl = True                                         MD059184
     C******LOCK         IN        LDA                                                      MD059184
     C**********         EVAL      DBKey = '*FIRST'                                         MD059184
     C**********         EVAL      DBFile = 'SMFILUD0'                                      MD059184
     C**********         EVAL      DBase = 1                                                MD059184
     C**********         OUT       LDA                                                      MD059184
     C**********         EXSR      *PSSR                                                    MD059184
     C**********         ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** Processing for Zonal Layer                                                         MD059184
      *                                                                                     MD059184
     C     Layer         IFEQ      'Zonal '                                                 MD059184
      *                                                                                     MD059184
      ** SORT FILE INTO ASCENDING ORDER WHERE                                               MD059184
      ** LAYER IS ZONAL.                                                                    MD059184
      *                                                                                     MD059184
     C                   EVAL      SortSQLStmnt = 'SELECT * FROM SMFILUPD ' +               MD059184
     C                             'WHERE LAYR = ''Zonal''' +                               MD059184
     C                             ' ORDER BY PFILE ASC'                                    MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** Processing for Global Layer                                                        MD059184
      *                                                                                     MD059184
     C     Layer         IFEQ      'Global '                                                MD059184
      *                                                                                     MD059184
      ** SORT FILE INTO ASCENDING ORDER WHERE                                               MD059184
      ** LAYER IS GLOBAL.                                                                   MD059184
      *                                                                                     MD059184
     C                   EVAL      SortSQLStmnt = 'SELECT * FROM SMFILUPD ' +               MD059184
     C                             'WHERE LAYR = ''Global''' +                              MD059184
     C                             ' ORDER BY PFILE ASC'                                    MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** PREPARE CURSOR TO FETCH RECORDS FROM THE FILE.                                     MD059184
      *                                                                                     MD059184
     C/EXEC SQL                                                                             MD059184
     C+  PREPARE P1 FROM :SortSQLStmnt                                                      MD059184
     C/END-EXEC                                                                             MD059184
      *                                                                                     MD059184
     C/EXEC SQL                                                                             MD059184
     C+  DECLARE P1 CURSOR FOR P1                                                           MD059184
     C/END-EXEC                                                                             MD059184
      *                                                                                     MD059184
     C/EXEC SQL                                                                             MD059184
     C+  OPEN P1                                                                            MD059184
     C/END-EXEC                                                                             MD059184
      *                                                                                     MD059184
     C/EXEC SQL                                                                             MD059184
     C+  FETCH FROM P1 INTO :SMFileUpdate                                                   MD059184
     C/END-EXEC                                                                             MD059184
      *                                                                                     MD059184
      ** IF TABLE IS NOT OPEN, OPEN TABLE AND FETCH NEXT RECORD                             MD059184
      ** Processing for Zonal Layer                                                         MD059184
      *                                                                                     MD059184
     C                   IF        SQLCOD = -501                                            MD059184
     C/EXEC SQL                                                                             MD059184
     C+  OPEN P1                                                                            MD059184
     C/END-EXEC                                                                             MD059184
      *                                                                                     MD059184
     C/EXEC SQL                                                                             MD059184
     C+  FETCH NEXT FROM P1 INTO :SMFileUpdate                                              MD059184
     C/END-EXEC                                                                             MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** EXECUTE LOOP UNTIL RECORDS ARE FOUND.                                              MD059184
      *                                                                                     MD059184
     C                   DOW       SQLCOD = 0                                               MD059184
      *                                                                                     MD059184
      ** INITIALISE FIRST RECORD FROM FILE.                                                 MD059184
      *                                                                                     MD059184
     C                   EVAL      CurrFileName = %TRIM(PFILE)                              MD059184
     C                   EVAL      CurrPFMember = %TRIM(PMBR)                               MD059184
     C                   IF        IsFileFirstRec = 0                                       MD059184
     C                   EVAL      PrevFileName = %TRIM(CurrFileName)                       MD059184
     C                   EVAL      PrevPFMember = %TRIM(CurrPFMember)                       MD059184
     C                   EVAL      ExtFldArray(FieldCounter) = %TRIM(PFIELD)                MD059184
     C                   EVAL      PMBR = %TRIM(PMBR)                                       MD059184
     C                   EVAL      IsFileFirstRec = 1                                       MD059184
     C                   EVAL      FieldCounter = FieldCounter + 1                          MD059184
     C                   ELSE                                                               MD059184
      *                                                                                     MD059184
      ** Process Update when Current File Name <> Previous File Name                        MD059184
      ** Else Save Extracted Fields Until File Name <> Previous                             MD059184
      *                                                                                     MD059184
     C                   IF        %TRIM(PrevFileName) <> %TRIM(CurrFileName)               MD059184
     C                             OR %TRIM(PrevPFMember) <> %TRIM(CurrPFMember)            MD059184
      *                                                                                     MD059184
      ** Execute Update Subroutine - Based on number of fields                              MD059184
      *                                                                                     MD059184
     C                   EVAL      TotFldCount = FieldCounter                               MD059184
     C                   EVAL      TotFldCount = TotFldCount - 1                            MD059184
     C                   EXSR      EnhSqlUpdate                                             MD059184
      *                                                                                     MD059184
      ** Reset Field Counters and Field Array                                               MD059184
      ** And Set Field Extract and Counter for the Current File                             MD059184
      *                                                                                     MD059184
     C     TotFldCount   DOWNE     0                                                        MD059184
     C                   EVAL      ExtFldArray(TotFldCount) = *BLANKS                       MD059184
     C                   EVAL      sqlStatement(TotFldCount) = *BLANKS                      MD059184
     C                   EVAL      condStatement(TotFldCount) = *BLANKS                     MD059184
     C                   EVAL      TotFldCount = TotFldCount - 1                            MD059184
     C                   ENDDO                                                              MD059184
     C                   EVAL      ExecCnt = 1                                              MD059184
     C                   EVAL      execStatement = *BLANKS                                  MD059184
     C                   EVAL      FieldCounter = 1                                         MD059184
     C                   EVAL      ExtFldArray(FieldCounter) = %TRIM(PFIELD)                MD059184
     C                   EVAL      FieldCounter = FieldCounter + 1                          MD059184
     C                   ELSE                                                               MD059184
      *                                                                                     MD059184
      ** Concatenate extracted fields from the same file name.                              MD059184
      *                                                                                     MD059184
     C                   EVAL      ExtFldArray(FieldCounter) = %TRIM(PFIELD)                MD059184
     C                   EVAL      FieldCounter = FieldCounter + 1                          MD059184
     C                   ENDIF                                                              MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
     C                   EVAL      PrevFileName = %TRIM(CurrFileName)                       MD059184
     C                   EVAL      PrevPFMember = %TRIM(CurrPFMember)                       MD059184
      *                                                                                     MD059184
      ** Fetch next record from file                                                        MD059184
      *                                                                                     MD059184
     C/EXEC SQL FETCH NEXT FROM P1 INTO :SMFileUpdate                                       MD059184
     C/END-EXEC                                                                             MD059184
      *                                                                                     MD059184
     C                   IF        SQLCOD <> 0 AND SQLCOD <> 100                            MD059184
     C                   EXSR      *PSSR                                                    MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
     C                   ENDDO                                                              MD059184
      *                                                                                     MD059184
     C                   IF        SQLCOD = 100                                             MD059184
      *                                                                                     MD059184
      ** Execute Update Subroutine - Based on number of fields                              MD059184
      *                                                                                     MD059184
     C                   EVAL      TotFldCount = FieldCounter                               MD059184
     C                   EVAL      TotFldCount = TotFldCount - 1                            MD059184
     C                   EXSR      EnhSqlUpdate                                             MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
     C/EXEC SQL                                                                             MD059184
     C+ CLOSE P1                                                                            MD059184
     C/END-EXEC                                                                             MD059184
      *                                                                                     MD059184
     C**********         DOW       EndOfFile = False                                        MD059184
      *
      ** Process Update of files
      *
     C*****Layer         IFEQ      'Zonal '                                                 MD059184
     C*****LAYR*         ANDEQ     'Zonal  '                                                MD059184
     C**********         EXSR      SRUpdate                                                 MD059184
     C**********         ENDIF                                                              MD059184
      *                                                                                     MD059184
     C*****Layer         IFEQ      'Global'                                                 MD059184
     C*****LAYR*         ANDEQ     'Global '                                                MD059184
     C**********         EXSR      SRUpdate1                                                MD059184
     C**********         ENDIF                                                              MD059184
      *
      ** Read next record
      *
     C**********         READ      SMFILUD0                             3545                MD059184
      *
     C**********                    IF        ErrorOnFl = True                              MD059184
     C******LOCK         IN        LDA                                                      MD059184
     C**********         EVAL      DBKey = '*NEXT'                                          MD059184
     C**********         EVAL      DBFile = 'SMFILUD0'                                      MD059184
     C**********         EVAL      DBase = 2                                                MD059184
     C**********         OUT       LDA                                                      MD059184
     C**********         EXSR      *PSSR                                                    MD059184
     C**********         ENDIF                                                              MD059184
      *
     C**********         ENDDO                                                              MD059184
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      **SRUpdate*-*Update*files****************************************                     MD059184
      *****************************************************************                     MD059184
      **Called*by:*Main*Processing*************************************                     MD059184
      *****************************************************************                     MD059184
      **Calls:*None****************************************************                     MD059184
      *****************************************************************                     MD059184
      *****************************************************************
     C*****SRUpdate      BEGSR                                                              MD059184
      *
     C**********         IF        PMBR <> *BLANKS                                          MD059184
     C**********         EVAL      Command = ('OVRDBF FILE('+PMBR+') TOFILE('+              MD059184
     C**********                   PFILE+') MBR('+PMBR+')')                                 MD059184
     C**********         CALL      'QCMDEXC'                                                MD059184
     C**********         PARM                    Command                                    MD059184
     C**********         PARM      2764          Length           15 5                      MD059184
      *
     C**********         EVAL      PFILE = PMBR                                             MD059184
     C**********         ENDIF                                                              MD059184
      *
     C**********         EVAL      UFILE = PFILE                                            MD059184
     C**********         EVAL      UFIELD = PFIELD                                          MD059184
      *
     C**********         EVAL      thisSQL = 'Update '+UFILE+' SET '+UFIELD                 MD059184
     C**********                   +' = ''  '' WHERE '+UFIELD+' = ''00'' '                  MD059184
     C**********                   +'OR '+UFIELD+' = ''0 '' '                               MD059184
     C**********                   +'OR '+UFIELD+' = '' 0'' '                               MD059184
     C**********         EVAL      thisSQL1 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''01'' WHERE '+UFIELD+' = ''1 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 1'' '                               MD059184
     C**********         EVAL      thisSQL2 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''02'' WHERE '+UFIELD+' = ''2 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 2'' '                               MD059184
     C**********         EVAL      thisSQL3 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''03'' WHERE '+UFIELD+' = ''3 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 3'' '                               MD059184
     C**********         EVAL      thisSQL4 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''04'' WHERE '+UFIELD+' = ''4 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 4'' '                               MD059184
     C**********         EVAL      thisSQL5 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''05'' WHERE '+UFIELD+' = ''5 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 5'' '                               MD059184
     C**********         EVAL      thisSQL6 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''06'' WHERE '+UFIELD+' = ''6 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 6'' '                               MD059184
     C**********         EVAL      thisSQL7 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''07'' WHERE '+UFIELD+' = ''7 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 7'' '                               MD059184
     C**********         EVAL      thisSQL8 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''08'' WHERE '+UFIELD+' = ''8 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 8'' '                               MD059184
     C**********         EVAL      thisSQL9 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''09'' WHERE '+UFIELD+' = ''9 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 9'' '                               MD059184
      *
     C*/EXEC*SQL*                                                                           MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL                                                         MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL1                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL2                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL3                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL4                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL5                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL6                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL7                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL8                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL9                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
      *
     C**********         IF        SQLCODE <> 0 AND SQLCODE <> 100                          MD059184
     C**********         EXSR      *PSSR                                                    MD059184
     C**********         ENDIF                                                              MD059184
      *
     C**********         IF        PMBR <> *BLANKS                                          MD059184
     C**********         EVAL      Command = ('DLTOVR '+PMBR+'')                            MD059184
     C**********         CALL      'QCMDEXC'                                                MD059184
     C**********         PARM                    Command                                    MD059184
     C**********         PARM      2764          Length                                     MD059184
     C**********         ENDIF                                                              MD059184
      *
     C**********         ENDSR                                                              MD059184
      *****************************************************************
      **SRUpdate*-*Update*files*(Global)*******************************                     MD059184
      *****************************************************************                     MD059184
      **Called*by:*Main*Processing*************************************                     MD059184
      *****************************************************************                     MD059184
      **Calls:*None****************************************************                     MD059184
      *****************************************************************                     MD059184
      *****************************************************************
     C*****SRUpdate1     BEGSR                                                              MD059184
      *
     C**********         IF        PMBR <> *BLANKS                                          MD059184
     C**********         EVAL      Command = ('OVRDBF FILE('+PMBR+') TOFILE('+              MD059184
     C**********                   PFILE+') MBR('+PMBR+')')                                 MD059184
     C**********         CALL      'QCMDEXC'                                                MD059184
     C**********         PARM                    Command                                    MD059184
     C**********         PARM      2764          Length           15 5                      MD059184
      *
     C**********         EVAL      PFILE = PMBR                                             MD059184
     C**********         ENDIF                                                              MD059184
      *
     C**********         EVAL      UFILE = PFILE                                            MD059184
     C**********         EVAL      UFIELD = PFIELD                                          MD059184
      *
     C**********         EVAL      thisSQL = 'Update '+UFILE+' SET '+UFIELD                 MD059184
     C**********                   +' = ''  '' WHERE '+UFIELD+' = ''00'' '                  MD059184
     C**********                   +'OR '+UFIELD+' = ''0 '' '                               MD059184
     C**********                   +'OR '+UFIELD+' = '' 0'' '                               MD059184
     C**********         EVAL      thisSQL1 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''01'' WHERE '+UFIELD+' = ''1 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 1'' '                               MD059184
     C**********         EVAL      thisSQL2 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''02'' WHERE '+UFIELD+' = ''2 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 2'' '                               MD059184
     C**********         EVAL      thisSQL3 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''03'' WHERE '+UFIELD+' = ''3 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 3'' '                               MD059184
     C**********         EVAL      thisSQL4 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''04'' WHERE '+UFIELD+' = ''4 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 4'' '                               MD059184
     C**********         EVAL      thisSQL5 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''05'' WHERE '+UFIELD+' = ''5 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 5'' '                               MD059184
     C**********         EVAL      thisSQL6 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''06'' WHERE '+UFIELD+' = ''6 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 6'' '                               MD059184
     C**********         EVAL      thisSQL7 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''07'' WHERE '+UFIELD+' = ''7 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 7'' '                               MD059184
     C**********         EVAL      thisSQL8 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''08'' WHERE '+UFIELD+' = ''8 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 8'' '                               MD059184
     C**********         EVAL      thisSQL9 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C**********                   +' = ''09'' WHERE '+UFIELD+' = ''9 '''                   MD059184
     C**********                   +'OR '+UFIELD+' = '' 9'' '                               MD059184
      *
     C*/EXEC*SQL*                                                                           MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL                                                         MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL1                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL2                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL3                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL4                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL5                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL6                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL7                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL8                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
     C*/EXEC*SQL                                                                            MD059184
     C*+*EXECUTE*IMMEDIATE*:thisSQL9                                                        MD059184
     C*/END-EXEC*                                                                           MD059184
      *
     C**********         IF        SQLCODE <> 0 AND SQLCODE <> 100                          MD059184
     C**********         EXSR      *PSSR                                                    MD059184
     C**********         ENDIF                                                              MD059184
      *
     C**********         IF        PMBR <> *BLANKS                                          MD059184
     C**********         EVAL      Command = ('DLTOVR '+PMBR+'')                            MD059184
     C**********         CALL      'QCMDEXC'                                                MD059184
     C**********         PARM                    Command                                    MD059184
     C**********         PARM      2764          Length                                     MD059184
     C**********         ENDIF                                                              MD059184
      *
     C**********         ENDSR                                                              MD059184
      *****************************************************************                     MD059184
      *                                                               *                     MD059184
      * EnhSqlUpdate - Update Files (SQL Update Statement)            *                     MD059184
      *                                                               *                     MD059184
      * Called by: Main Processing                                    *                     MD059184
      *                                                               *                     MD059184
      * Calls: None                                                   *                     MD059184
      *                                                               *                     MD059184
      *****************************************************************                     MD059184
     C     EnhSqlUpdate  BEGSR                                                              MD059184
      *                                                                                     MD059184
     C                   IF        PrevPFMember <> *BLANKS                                  MD059184
     C                   EVAL      Command = ('OVRDBF FILE('+PrevPFMember+') +              MD059184
     C                             TOFILE('+PrevFileName+') +                               MD059184
     C                             MBR('+PrevPFMember+')')                                  MD059184
     C                   CALL      'QCMDEXC'                                                MD059184
     C                   PARM                    Command                                    MD059184
     C                   PARM      2764          Length           15 5                      MD059184
      *                                                                                     MD059184
     C                   EVAL      PrevFileName = PrevPFMember                              MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** Prepare Update Statement                                                           MD059184
      *                                                                                     MD059184
     C                   EVAL      updStatement = 'Update '                                 MD059184
     C                             + %TRIM(PrevFileName) + ' SET  '                         MD059184
      *                                                                                     MD059184
     C                   EVAL      Cnt = TotFldCount                                        MD059184
     C     Cnt           DOWNE     0                                                        MD059184
      *                                                                                     MD059184
     C     Cnt           IFEQ      1                                                        MD059184
      *                                                                                     MD059184
      ** Prepare One Field SQL Update Statement.                                            MD059184
      *                                                                                     MD059184
     C                   EVAL      condStatement(Cnt) = '' +                                MD059184
     C                             %TRIM(ExtFldArray(Cnt)) +                                MD059184
     C                             ' = CASE ' +                                             MD059184
     C                             'WHEN (' + %TRIM(ExtFldArray(Cnt)) +                     MD059184
     C                             ' =  ''00''' + ' OR ' +                                  MD059184
     C                             %TRIM(ExtFldArray(Cnt)) + ' =  ''''' +                   MD059184
     C                             ' OR ' + %TRIM(ExtFldArray(Cnt)) +                       MD059184
     C                             ' = '' 0''' +                                            MD059184
     C                             ' OR ' + %TRIM(ExtFldArray(Cnt)) +                       MD059184
     C                             ' = ''0 ''' +                                            MD059184
     C                             ') THEN ''''' +                                          MD059184
     C                             ' WHEN REPLACE (TRANSLATE(' +                            MD059184
     C                             %TRIM(ExtFldArray(Cnt)) + ',''0''' +                     MD059184
     C                             ',''123456789''' + ',''0'')' +                           MD059184
     C                             ',''0'','''')' + ' <> ''''' +                            MD059184
     C                             ' THEN (' + %TRIM(ExtFldArray(Cnt))                      MD059184
     C                             + ') ELSE CHAR(RIGHT (100+' +                            MD059184
     C                             %TRIM(ExtFldArray(Cnt)) + ',2))' + ' END'                MD059184
     C                   EVAL      Cnt = Cnt - 1                                            MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
     C     Cnt           IFGT      1                                                        MD059184
      *                                                                                     MD059184
      ** Prepare Conditional Statement When Fields                                          MD059184
      ** Are Greater Than 1.                                                                MD059184
      *                                                                                     MD059184
     C                   EVAL      condStatement(Cnt) = ' , ' +                             MD059184
     C                             %TRIM(ExtFldArray(Cnt)) +                                MD059184
     C                             ' = CASE ' +                                             MD059184
     C                             'WHEN (' + %TRIM(ExtFldArray(Cnt)) +                     MD059184
     C                             ' =  ''00''' + ' OR ' +                                  MD059184
     C                             %TRIM(ExtFldArray(Cnt)) + ' =  ''''' +                   MD059184
     C                             ' OR ' + %TRIM(ExtFldArray(Cnt)) +                       MD059184
     C                             ' = '' 0''' +                                            MD059184
     C                             ' OR ' + %TRIM(ExtFldArray(Cnt)) +                       MD059184
     C                             ' = ''0 ''' +                                            MD059184
     C                             ') THEN ''''' +                                          MD059184
     C                             ' WHEN REPLACE (TRANSLATE(' +                            MD059184
     C                             %TRIM(ExtFldArray(Cnt)) + ',''0''' +                     MD059184
     C                             ',''123456789''' + ',''0'')' +                           MD059184
     C                             ',''0'','''')' + ' <> ''''' +                            MD059184
     C                             ' THEN (' + %TRIM(ExtFldArray(Cnt))                      MD059184
     C                             + ') ELSE CHAR(RIGHT (100+' +                            MD059184
     C                             %TRIM(ExtFldArray(Cnt)) + ',2))' + ' END'                MD059184
     C                   EVAL      Cnt = Cnt - 1                                            MD059184
     C                   ENDIF                                                              MD059184
     C                   ENDDO                                                              MD059184
      *                                                                                     MD059184
      ** Save SQL Statement Based on Total Field Count                                      MD059184
      *                                                                                     MD059184
     C                   EVAL      Cnt = TotFldCount                                        MD059184
     C     Cnt           DOWNE     0                                                        MD059184
      *                                                                                     MD059184
     C     Cnt           IFEQ      1                                                        MD059184
     C                   EVAL      sqlStatement(1) = %TRIM(updStatement) +                  MD059184
     C                             ' ' + %TRIM(condStatement(1))                            MD059184
     C                   EVAL      Cnt = Cnt - 1                                            MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
     C     Cnt           IFGT      1                                                        MD059184
     C                   EVAL      sqlStatement(Cnt) = %TRIM(sqlStatement(Cnt))             MD059184
     C                             + ' ' + %TRIM(condStatement(Cnt))                        MD059184
     C                   EVAL      Cnt = Cnt - 1                                            MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
     C                   ENDDO                                                              MD059184
      *                                                                                     MD059184
      ** Save Execute Statement when Field Greater Than 1                                   MD059184
      *                                                                                     MD059184
     C                   EVAL      execStatement = %TRIM(sqlStatement(1))                   MD059184
      *                                                                                     MD059184
     C     TotFldCount   IFGT      1                                                        MD059184
      *                                                                                     MD059184
     C     ExecCnt       DOWNE     TotFldCount                                              MD059184
     C                   EVAL      ExecCnt = ExecCnt + 1                                    MD059184
     C                   EVAL      execStatement = %TRIM(execStatement) +                   MD059184
     C                             ' ' + %TRIM(sqlStatement(ExecCnt))                       MD059184
     C                   ENDDO                                                              MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** Execute Statement When Fields Are Saved                                            MD059184
      *                                                                                     MD059184
     C/EXEC SQL                                                                             MD059184
     C+ EXECUTE IMMEDIATE :execStatement                                                    MD059184
     C/END-EXEC                                                                             MD059184
      *                                                                                     MD059184
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100                          MD059184
     C                   EXSR      *PSSR                                                    MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
     C                   IF        PrevPFMember <> *BLANKS                                  MD059184
     C                   EVAL      Command = ('DLTOVR '+PrevPFMember+'')                    MD059184
     C                   CALL      'QCMDEXC'                                                MD059184
     C                   PARM                    Command                                    MD059184
     C                   PARM      2764          Length                                     MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
     C                   ENDSR                                                              MD059184
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *inzsr        BEGSR
      *
     C     *entry        PLIST
      ** Parameters received from caller)
     C                   PARM                    Layer
     C                   ENDSR

      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = *ON                                              MD059184
     C                   DUMP
     C                   RETURN

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2020
