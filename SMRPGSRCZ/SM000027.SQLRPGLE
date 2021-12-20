     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD058089
/*STD *  RPGSQLBND                                                    *                     MD058089
/**** *  DBGVIEW(*LIST)                                               *                     MD058089
/*EXI *  TEXT('Midas SM Report on RCF changed parameters')            *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000027 - Report on RCF changed parameters                  *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD058089           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CUP003  *CREATE    Date 29Sep10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058089 - Deliverable Data Split for SM and UP              *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP003 - New utility for RCF.                                *
      *                                                               *
      *****************************************************************
     FFCPARPPD  IF   E             DISK    INFSR(*PSSR)
     F*SMRCFPPD* IF   E           K DISK    INFSR(*PSSR)                                    MD058089
      *
     D Found           S              1    INZ('N')
     D Action          S              7    INZ(' ')
     D GenPgm          S             10    INZ(' ')
     D Recursive       S              1    INZ('N')
      *
     D                 DS
     D  ErrorMsg               1    100
     D   RptName               1     10
     D   RptParm              11    100
     D SMRCFP        E DS                  EXTNAME(SMRCFJW0)                                MD058089
      *
      * Write 'header' record for report.
     C                   EVAL      RptName = 'Report'
     C                   EVAL      RptParm = 'Parameters'
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      Action
     C                   PARM      'SM000027'    GenPgm
     C                   PARM                    ErrorMsg

     C                   EVAL      RptName = *blanks
     C                   EVAL      RptParm = *blanks
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      Action
     C                   PARM      'SM000027'    GenPgm
     C                   PARM                    ErrorMsg

     C     1             SETLL     FCPARPPD
     C                   READ      FCPARPPD
      *
     C                   DOW       NOT(%EOF)
      *
     C                   EVAL      RptName = *blanks
     C                   EVAL      RptParm = *blanks
      *
      * Check if report is on possible changed parameters file.
     C*****D8RNAM        CHAIN     SMRCFPPD                                                 MD058089
     C/EXEC SQL                                                                             MD058089
     C+ SELECT *                                                                            MD058089
     C+ into :SMRCFP                                                                        MD058089
     C+ from SMRCFJW0                                                                       MD058089
     C+ where RPRNAM = :D8RNAM                                                              MD058089
     C/END-EXEC                                                                             MD058089
     C**********         IF        %FOUND                                                   MD058089
     C                   IF        SQLCODE = 0                                              MD058089
     C                   EVAL      Found = 'Y'
     C                   EVAL      RptName = D8RNAM
     C                   EVAL      RptParm = D8PARM
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      Action
     C                   PARM      'SM000027'    GenPgm
     C                   PARM                    ErrorMsg
      *
     C                   ENDIF
      *
     C                   READ      FCPARPPD
     C                   ENDDO
      *
     C                   IF        Found <> 'Y'
     C                   EVAL      RptName = *blanks
     C                   EVAL      RptParm = 'No records found'
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      Action
     C                   PARM      'SM000027'    GenPgm
     C                   PARM                    ErrorMsg
     C                   ENDIF
      *
      * Write final report.
     C                   CALL      'UP008010'
     C                   PARM      '*REPORT'     Action
     C                   PARM      'SM000027'    GenPgm
     C                   PARM      *blanks       ErrorMsg
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
