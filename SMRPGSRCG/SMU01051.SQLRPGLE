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
      *  Last Amend No. MD059184  *CREATE  Date 05Nov21               *
      *  Prev Amend No. CSD103    *CREATE  Date 10Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059184 - Enhance Update via SQL Command                    *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************
     FSMFILUPD  IF   E           K DISK    INFSR(*PSSR)
      *Midas SD File Base Rate Fields to Update
      *
      **---------------------------------------------------------------
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
     D UFILE           S             10A
     D UFIELD          S             10A
     D thisSQL         S            500
     D thisSQL1        S            500
     D thisSQL2        S            500
     D thisSQL3        S            500
     D thisSQL4        S            500
     D thisSQL5        S            500
     D thisSQL6        S            500
     D thisSQL7        S            500
     D thisSQL8        S            500
     D thisSQL9        S            500
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             35     35
     D  EndOfFile             45     45
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      **
     D Command         S           2764
      ** Additional Field for File Processing                                               MD059184
     D PrevFileName    S             10A   INZ(*BLANKS)                                     MD059184
     D PrevPFMember    S             10A   INZ(*BLANKS)                                     MD059184
     D CurrFileName    S             10A   INZ(*BLANKS)                                     MD059184
     D IsFileFirstRec  S              1  0 INZ(0)                                           MD059184
     D FieldCounter    S             10  0 INZ(1)                                           MD059184
     D SortSQLStmnt    S           2000A   INZ(*BLANKS)                                     MD059184
     D SMFileUpdate  E DS                  EXTNAME(SMFILUPD)                                MD059184
     D TotFldCount     S              5  0 INZ(0)                                           MD059184
     D FldExtArray     S              4A   DIM(5)                                           MD059184
     D sqlStatement1   S            500                                                     MD059184
     D sqlStatement2   S            500                                                     MD059184
     D sqlStatement3   S            500                                                     MD059184
     D sqlStatement4   S            500                                                     MD059184
     D sqlStatement5   S            500                                                     MD059184

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
     C***********        IF        ErrorOnFl = True                                         MD059184
     C******LOCK*        IN        LDA                                                      MD059184
     C***********        EVAL      DBKey = '*FIRST'                                         MD059184
     C***********        EVAL      DBFile = 'SMFILUD0'                                      MD059184
     C***********        EVAL      DBase = 1                                                MD059184
     C***********        OUT       LDA                                                      MD059184
     C***********        EXSR      *PSSR                                                    MD059184
     C***********        ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** SORT FILE INTO ASCENDING ORDER.                                                    MD059184
      *                                                                                     MD059184
       SortSQLStmnt = 'SELECT * FROM SMFILUPD ' +
                             'ORDER BY PFILE ASC';
      *                                                                                     MD059184
      ** PREPARE CURSOR TO FETCH RECORDS FROM THE FILE.                                     MD059184
      *                                                                                     MD059184
                   EXEC SQL PREPARE P1 FROM :SortSQLStmnt;
                   EXEC SQL DECLARE P1 CURSOR FOR P1;
                   EXEC SQL OPEN P1;
                   EXEC SQL FETCH FROM P1 INTO :SMFileUpdate;

      *
      ** IF TABLE IS NOT OPEN, OPEN TABLE AND FETCH NEXT RECORD
      *
                   IF SQLCOD = -501;
                      EXEC SQL OPEN P1;
                      EXEC SQL FETCH NEXT FROM P1 INTO :SMFileUpdate;
                   ENDIF;

      *
      ** IF TABLE FINDS ERROR OR NO RECORD.
      *
                   IF SQLCOD <> 0 AND SQLCOD <> 100;
                      EXSR *PSSR;
                   ENDIF;

      *                                                                                     MD059184
      ** EXECUTE LOOP UNTIL RECORDS ARE FOUND.                                              MD059184
      *                                                                                     MD059184
                   DOW SQLCOD = 0;

      *                                                                                     MD059184
      ** INITIALISE FIRST RECORD FROM FILE.                                                 MD059184
      *                                                                                     MD059184
     C                   EVAL      CurrFileName = %TRIM(PFILE)                              MD059184
     C                   EVAL      CurrPFMember = %TRIM(PMBR)                               MD059184
     C                   IF        IsFileFirstRec = 0                                       MD059184
     C                   EVAL      PrevFileName = CurrFileName                              MD059184
     C                   EVAL      PrevPFMember = CurrPFMember                              MD059184
     C                   EVAL      FldExtArray(FieldCounter) = %TRIM(PFIELD)                MD059184
     C                   EVAL      Layer = %TRIM(LAYR)                                      MD059184
     C                   EVAL      PMBR = %TRIM(PMBR)                                       MD059184
     C                   EVAL      IsFileFirstRec = 1                                       MD059184
     C                   EVAL      FieldCounter = FieldCounter + 1                          MD059184
     C                   ELSE                                                               MD059184
      *                                                                                     MD059184
      ** Process Update when Current File Name <> Previous File Name                        MD059184
      ** Else Save Extracted Fields Until File Name <> Previous                             MD059184
      *                                                                                     MD059184
     C                   IF        PrevFileName <> CurrFileName                             MD059184
     C                             AND PrevPFMember = CurrPFMember                          MD059184
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
     C                   EVAL      FldExtArray(TotFldCount) = *BLANKS                       MD059184
     C                   EVAL      TotFldCount = TotFldCount - 1                            MD059184
     C                   ENDDO                                                              MD059184
     C                   EVAL      FieldCounter = 1                                         MD059184
     C                   EVAL      FldExtArray(FieldCounter) = %TRIM(PFIELD)                MD059184
     C                   EVAL      FieldCounter = FieldCounter + 1                          MD059184
     C                   ELSE                                                               MD059184
      *                                                                                     MD059184
      ** Concatenate extracted fields from the same file name.                              MD059184
      *                                                                                     MD059184
     C                   EVAL      FldExtArray(FieldCounter) = %TRIM(PFIELD)                MD059184
     C                   EVAL      FieldCounter = FieldCounter + 1                          MD059184
     C                   ENDIF                                                              MD059184
     C                   ENDIF                                                              MD059184

     C                   EVAL      PrevFileName = CurrFileName                              MD059184
     C                   EVAL      PrevPFMember = CurrPFMember                              MD059184
                      EXEC SQL FETCH NEXT FROM P1 INTO :SMFileUpdate;

                      IF SQLCOD <> 0 AND SQLCOD <> 100;
                         EXSR *PSSR;
                      ENDIF;

                   ENDDO;

                   EXEC SQL CLOSE P1;

     C***********        DOW       EndOfFile = False                                        MD059184
      *
      ** Process Update of files
      *
     C*****Layer*        IFEQ      'Zonal '                                                 MD059184
     C*****LAYR**        ANDEQ     'Zonal  '                                                MD059184
     C***********        EXSR      SRUpdate                                                 MD059184
     C***********        ENDIF                                                              MD059184
      *                                                                                     MD059184
     C*****Layer*        IFEQ      'Global'                                                 MD059184
     C*****LAYR**        ANDEQ     'Global '                                                MD059184
     C***********        EXSR      SRUpdate1                                                MD059184
     C***********        ENDIF                                                              MD059184
      *
      ** Read next record
      *
     C***********        READ      SMFILUD0                             3545                MD059184
      *
     C***********                   IF        ErrorOnFl = True                              MD059184
     C******LOCK*        IN        LDA                                                      MD059184
     C***********        EVAL      DBKey = '*NEXT'                                          MD059184
     C***********        EVAL      DBFile = 'SMFILUD0'                                      MD059184
     C***********        EVAL      DBase = 2                                                MD059184
     C***********        OUT       LDA                                                      MD059184
     C***********        EXSR      *PSSR                                                    MD059184
     C***********        ENDIF                                                              MD059184
      *
     C***********        ENDDO
     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *                                                               *
      * SRUpdate - Update files                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C*****SRUpdate      BEGSR                                                              MD059184
      *
     C***********        IF        PMBR <> *BLANKS                                          MD059184
     C***********        EVAL      Command = ('OVRDBF FILE('+PMBR+') TOFILE('+              MD059184
     C***********                  PFILE+') MBR('+PMBR+')')                                 MD059184
     C***********        CALL      'QCMDEXC'                                                MD059184
     C***********        PARM                    Command                                    MD059184
     C***********        PARM      2764          Length           15 5                      MD059184
      *
     C***********        EVAL      PFILE = PMBR                                             MD059184
     C***********        ENDIF                                                              MD059184
      *
     C***********        EVAL      UFILE = PFILE                                            MD059184
     C***********        EVAL      UFIELD = PFIELD                                          MD059184
      *
     C***********        EVAL      thisSQL = 'Update '+UFILE+' SET '+UFIELD                 MD059184
     C***********                  +' = ''  '' WHERE '+UFIELD+' = ''00'' '                  MD059184
     C***********                  +'OR '+UFIELD+' = ''0 '' '                               MD059184
     C***********                  +'OR '+UFIELD+' = '' 0'' '                               MD059184
     C***********        EVAL      thisSQL1 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''01'' WHERE '+UFIELD+' = ''1 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 1'' '                               MD059184
     C***********        EVAL      thisSQL2 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''02'' WHERE '+UFIELD+' = ''2 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 2'' '                               MD059184
     C***********        EVAL      thisSQL3 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''03'' WHERE '+UFIELD+' = ''3 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 3'' '                               MD059184
     C***********        EVAL      thisSQL4 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''04'' WHERE '+UFIELD+' = ''4 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 4'' '                               MD059184
     C***********        EVAL      thisSQL5 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''05'' WHERE '+UFIELD+' = ''5 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 5'' '                               MD059184
     C***********        EVAL      thisSQL6 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''06'' WHERE '+UFIELD+' = ''6 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 6'' '                               MD059184
     C***********        EVAL      thisSQL7 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''07'' WHERE '+UFIELD+' = ''7 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 7'' '                               MD059184
     C***********        EVAL      thisSQL8 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''08'' WHERE '+UFIELD+' = ''8 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 8'' '                               MD059184
     C***********        EVAL      thisSQL9 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''09'' WHERE '+UFIELD+' = ''9 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 9'' '                               MD059184
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
     C***********        IF        SQLCODE <> 0 AND SQLCODE <> 100                          MD059184
     C***********        EXSR      *PSSR                                                    MD059184
     C***********        ENDIF                                                              MD059184
      *
     C***********        IF        PMBR <> *BLANKS                                          MD059184
     C***********        EVAL      Command = ('DLTOVR '+PMBR+'')                            MD059184
     C***********        CALL      'QCMDEXC'                                                MD059184
     C***********        PARM                    Command                                    MD059184
     C***********        PARM      2764          Length                                     MD059184
     C***********        ENDIF                                                              MD059184
      *
     C***********        ENDSR                                                              MD059184
      *****************************************************************
      *                                                               *
      * SRUpdate - Update files (Global)                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C*****SRUpdate1     BEGSR                                                              MD059184
      *
     C***********        IF        PMBR <> *BLANKS                                          MD059184
     C***********        EVAL      Command = ('OVRDBF FILE('+PMBR+') TOFILE('+              MD059184
     C***********                  PFILE+') MBR('+PMBR+')')                                 MD059184
     C***********        CALL      'QCMDEXC'                                                MD059184
     C***********        PARM                    Command                                    MD059184
     C***********        PARM      2764          Length           15 5                      MD059184
      *
     C***********        EVAL      PFILE = PMBR                                             MD059184
     C***********        ENDIF                                                              MD059184
      *
     C***********        EVAL      UFILE = PFILE                                            MD059184
     C***********        EVAL      UFIELD = PFIELD                                          MD059184
      *
     C***********        EVAL      thisSQL = 'Update '+UFILE+' SET '+UFIELD                 MD059184
     C***********                  +' = ''  '' WHERE '+UFIELD+' = ''00'' '                  MD059184
     C***********                  +'OR '+UFIELD+' = ''0 '' '                               MD059184
     C***********                  +'OR '+UFIELD+' = '' 0'' '                               MD059184
     C***********        EVAL      thisSQL1 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''01'' WHERE '+UFIELD+' = ''1 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 1'' '                               MD059184
     C***********        EVAL      thisSQL2 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''02'' WHERE '+UFIELD+' = ''2 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 2'' '                               MD059184
     C***********        EVAL      thisSQL3 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''03'' WHERE '+UFIELD+' = ''3 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 3'' '                               MD059184
     C***********        EVAL      thisSQL4 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''04'' WHERE '+UFIELD+' = ''4 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 4'' '                               MD059184
     C***********        EVAL      thisSQL5 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''05'' WHERE '+UFIELD+' = ''5 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 5'' '                               MD059184
     C***********        EVAL      thisSQL6 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''06'' WHERE '+UFIELD+' = ''6 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 6'' '                               MD059184
     C***********        EVAL      thisSQL7 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''07'' WHERE '+UFIELD+' = ''7 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 7'' '                               MD059184
     C***********        EVAL      thisSQL8 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''08'' WHERE '+UFIELD+' = ''8 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 8'' '                               MD059184
     C***********        EVAL      thisSQL9 = 'Update '+UFILE+' SET '+UFIELD                MD059184
     C***********                  +' = ''09'' WHERE '+UFIELD+' = ''9 '''                   MD059184
     C***********                  +'OR '+UFIELD+' = '' 9'' '                               MD059184
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
     C***********        IF        SQLCODE <> 0 AND SQLCODE <> 100                          MD059184
     C***********        EXSR      *PSSR                                                    MD059184
     C***********        ENDIF                                                              MD059184
      *
     C***********        IF        PMBR <> *BLANKS                                          MD059184
     C***********        EVAL      Command = ('DLTOVR '+PMBR+'')                            MD059184
     C***********        CALL      'QCMDEXC'                                                MD059184
     C***********        PARM                    Command                                    MD059184
     C***********        PARM      2764          Length                                     MD059184
     C***********        ENDIF                                                              MD059184
      *
     C***********        ENDSR                                                              MD059184
      *****************************************************************                     MD059184
      *                                                               *                     MD059184
      * EnhSqlUpdate - Update Files (Zonal & Global)                  *                     MD059184
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
     C                   PARM      2764          Length                                     MD059184
      *                                                                                     MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** Check for number of fields to be updated                                           MD059184
      *                                                                                     MD059184
     C                   IF        TotFldCount = 1                                          MD059184
     C                   EVAL      sqlStatement1 = 'Update ' + PrevFileName +               MD059184
     C                             ' SET ' + ExtFldArray(1) + ' = CASE ' +                  MD059184
     C                             'WHEN (' + ExtFldArray(1) + ') THEN ' +                  MD059184
     C                             ''' '' WHEN'  + ExtFldArray(1) + ' = ' +                 MD059184
     C                             ''' '' THEN ' + ''' ''' + ' WHEN (' +                    MD059184
     C                             ExtFldArray(1) + ' =  '' 1'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''1 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''01'' THEN ' +                    MD059184
     C                             '''01''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(1) + ' =  '' 2'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''2 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''02'' THEN ' +                    MD059184
     C                             '''02''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(1) + ' =  '' 3'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''3 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''03'' THEN ' +                    MD059184
     C                             '''03''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(1) + ' =  '' 4'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''4 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''04'' THEN ' +                    MD059184
     C                             '''04''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(1) + ' =  '' 5'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''5 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''05'' THEN ' +                    MD059184
     C                             '''05''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(1) + ' =  '' 6'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''6 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''06'' THEN ' +                    MD059184
     C                             '''06''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(1) + ' =  '' 7'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''7 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''07'' THEN ' +                    MD059184
     C                             '''07''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(1) + ' =  '' 8'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''8 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''08'' THEN ' +                    MD059184
     C                             '''08''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(1) + ' =  '' 9'' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''9 '' OR ' +                      MD059184
     C                             ExtFldArray(1) + ' =  ''09'' THEN ' +                    MD059184
     C                             '''09''' + ' ELSE ' + ExtFldArray(1) + ' END'            MD059184
     C/EXEC SQL                                                                             MD059184
     C+ EXECUTE IMMEDIATE :sqlStatement1                                                    MD059184
     C/END-EXEC                                                                             MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** When Field Count is Equal to 2.                                                    MD059184
      *                                                                                     MD059184
     C                   IF        TotFldCount = 2                                          MD059184
     C                   EVAL      sqlStatement2 = sqlStatement1 + ' ' +                    MD059184
      *                                                                                     MD059184
      ** Update Second Field From Extract Field Array.                                      MD059184
      *                                                                                     MD059184
     C                             + ', ' + ExtFldArray(2) + ' = CASE ' +                   MD059184
     C                             'WHEN (' + ExtFldArray(2) + ') THEN ' +                  MD059184
     C                             ''' '' WHEN'  + ExtFldArray(2) + ' = ' +                 MD059184
     C                             ''' '' THEN ' + ''' ''' + ' WHEN (' +                    MD059184
     C                             ExtFldArray(2) + ' =  '' 1'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''1 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''01'' THEN ' +                    MD059184
     C                             '''01''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(2) + ' =  '' 2'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''2 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''02'' THEN ' +                    MD059184
     C                             '''02''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(2) + ' =  '' 3'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''3 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''03'' THEN ' +                    MD059184
     C                             '''03''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(2) + ' =  '' 4'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''4 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''04'' THEN ' +                    MD059184
     C                             '''04''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(2) + ' =  '' 5'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''5 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''05'' THEN ' +                    MD059184
     C                             '''05''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(2) + ' =  '' 6'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''6 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''06'' THEN ' +                    MD059184
     C                             '''06''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(2) + ' =  '' 7'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''7 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''07'' THEN ' +                    MD059184
     C                             '''07''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(2) + ' =  '' 8'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''8 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''08'' THEN ' +                    MD059184
     C                             '''08''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(2) + ' =  '' 9'' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''9 '' OR ' +                      MD059184
     C                             ExtFldArray(2) + ' =  ''09'' THEN ' +                    MD059184
     C                             '''09''' + ' ELSE ' + ExtFldArray(2) + ' END'            MD059184
     C/EXEC SQL                                                                             MD059184
     C+ EXECUTE IMMEDIATE :sqlStatement2                                                    MD059184
     C/END-EXEC                                                                             MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** When Field Count is equal to 3.                                                    MD059184
      *                                                                                     MD059184
     C                   IF        TotFldCount = 3                                          MD059184
     C                   EVAL      sqlStatement3 = sqlStatement2 + ' ' +                    MD059184
      *                                                                                     MD059184
      ** Update Third Field From Extract Field Array.                                       MD059184
      *                                                                                     MD059184
     C                             + ', ' + ExtFldArray(3) + ' = CASE ' +                   MD059184
     C                             'WHEN (' + ExtFldArray(3) + ') THEN ' +                  MD059184
     C                             ''' '' WHEN'  + ExtFldArray(2) + ' = ' +                 MD059184
     C                             ''' '' THEN ' + ''' ''' + ' WHEN (' +                    MD059184
     C                             ExtFldArray(3) + ' =  '' 1'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''1 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''01'' THEN ' +                    MD059184
     C                             '''01''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(3) + ' =  '' 2'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''2 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''02'' THEN ' +                    MD059184
     C                             '''02''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(3) + ' =  '' 3'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''3 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''03'' THEN ' +                    MD059184
     C                             '''03''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(3) + ' =  '' 4'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''4 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''04'' THEN ' +                    MD059184
     C                             '''04''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(3) + ' =  '' 5'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''5 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''05'' THEN ' +                    MD059184
     C                             '''05''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(3) + ' =  '' 6'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''6 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''06'' THEN ' +                    MD059184
     C                             '''06''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(3) + ' =  '' 7'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''7 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''07'' THEN ' +                    MD059184
     C                             '''07''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(3) + ' =  '' 8'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''8 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''08'' THEN ' +                    MD059184
     C                             '''08''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(3) + ' =  '' 9'' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''9 '' OR ' +                      MD059184
     C                             ExtFldArray(3) + ' =  ''09'' THEN ' +                    MD059184
     C                             '''09''' + ' ELSE ' + ExtFldArray(3) + ' END'            MD059184
     C/EXEC SQL                                                                             MD059184
     C+ EXECUTE IMMEDIATE :sqlStatement3                                                    MD059184
     C/END-EXEC                                                                             MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** When Field Count is equal to 4.                                                    MD059184
      *                                                                                     MD059184
     C                   IF        TotFldCount = 4                                          MD059184
     C                   EVAL      sqlStatement4 = sqlStatement3 + ' ' +                    MD059184
      *                                                                                     MD059184
      ** Update Fourth Field From Extract Field Array.                                      MD059184
      *                                                                                     MD059184
     C                             + ', ' + ExtFldArray(4) + ' = CASE ' +                   MD059184
     C                             'WHEN (' + ExtFldArray(4) + ') THEN ' +                  MD059184
     C                             ''' '' WHEN'  + ExtFldArray(4) + ' = ' +                 MD059184
     C                             ''' '' THEN ' + ''' ''' + ' WHEN (' +                    MD059184
     C                             ExtFldArray(4) + ' =  '' 1'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''1 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''01'' THEN ' +                    MD059184
     C                             '''01''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(4) + ' =  '' 2'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''2 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''02'' THEN ' +                    MD059184
     C                             '''02''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(4) + ' =  '' 3'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''3 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''03'' THEN ' +                    MD059184
     C                             '''03''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(4) + ' =  '' 4'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''4 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''04'' THEN ' +                    MD059184
     C                             '''04''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(4) + ' =  '' 5'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''5 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''05'' THEN ' +                    MD059184
     C                             '''05''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(4) + ' =  '' 6'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''6 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''06'' THEN ' +                    MD059184
     C                             '''06''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(4) + ' =  '' 7'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''7 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''07'' THEN ' +                    MD059184
     C                             '''07''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(4) + ' =  '' 8'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''8 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''08'' THEN ' +                    MD059184
     C                             '''08''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(4) + ' =  '' 9'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''9 '' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''09'' THEN ' +                    MD059184
     C                             '''09''' + ' ELSE ' + ExtFldArray(4) + ' END'            MD059184
     C/EXEC SQL                                                                             MD059184
     C+ EXECUTE IMMEDIATE :sqlStatement4                                                    MD059184
     C/END-EXEC                                                                             MD059184
     C                   ENDIF                                                              MD059184
      *                                                                                     MD059184
      ** When Field Count is equal to 5.                                                    MD059184
      *                                                                                     MD059184
     C                   IF        TotFldCount = 5                                          MD059184
     C                   EVAL      sqlStatement5 = sqlStatement4 + ' ' +                    MD059184
      *                                                                                     MD059184
      ** Update Fifth Field From Extract Field Array.                                       MD059184
      *                                                                                     MD059184
     C                             + ', ' + ExtFldArray(5) + ' = CASE ' +                   MD059184
     C                             'WHEN (' + ExtFldArray(5) + ') THEN ' +                  MD059184
     C                             ''' '' WHEN'  + ExtFldArray(5) + ' = ' +                 MD059184
     C                             ''' '' THEN ' + ''' ''' + ' WHEN (' +                    MD059184
     C                             ExtFldArray(5) + ' =  '' 1'' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''1 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''01'' THEN ' +                    MD059184
     C                             '''01''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(5) + ' =  '' 2'' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''2 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''02'' THEN ' +                    MD059184
     C                             '''02''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(5) + ' =  '' 3'' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''3 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''03'' THEN ' +                    MD059184
     C                             '''03''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(5) + ' =  '' 4'' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''4 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''04'' THEN ' +                    MD059184
     C                             '''04''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(5) + ' =  '' 5'' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''5 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''05'' THEN ' +                    MD059184
     C                             '''05''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(5) + ' =  '' 6'' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''6 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''06'' THEN ' +                    MD059184
     C                             '''06''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(5) + ' =  '' 7'' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''7 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''07'' THEN ' +                    MD059184
     C                             '''07''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(5) + ' =  '' 8'' OR ' +                      MD059184
     C                             ExtFldArray(4) + ' =  ''8 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''08'' THEN ' +                    MD059184
     C                             '''08''' + ' WHEN (' +                                   MD059184
     C                             ExtFldArray(5) + ' =  '' 9'' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''9 '' OR ' +                      MD059184
     C                             ExtFldArray(5) + ' =  ''09'' THEN ' +                    MD059184
     C                             '''09''' + ' ELSE ' + ExtFldArray(5) + ' END'            MD059184
     C/EXEC SQL                                                                             MD059184
     C+ EXECUTE IMMEDIATE :sqlStatement5                                                    MD059184
     C/END-EXEC                                                                             MD059184
     C                   ENDIF                                                              MD059184
      *
      *
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PMBR <> *BLANKS
     C                   EVAL      Command = ('DLTOVR '+PMBR+'')
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM      2764          Length
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   DUMP
     C                   RETURN

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2020

