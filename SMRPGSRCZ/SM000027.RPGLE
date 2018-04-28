     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  DBGVIEW(*LIST)                                               *
/*EXI *  TEXT('Midas SM Report on RCF changed parameters')            *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000027 - Report on RCF changed parameters                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CUP003  *CREATE    Date 29Sep10               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP003 - New utility for RCF.                                *
      *                                                               *
      *****************************************************************
     FFCPARPPD  IF   E             DISK    INFSR(*PSSR)
     FSMRCFPPD  IF   E           K DISK    INFSR(*PSSR)
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
     C     D8RNAM        CHAIN     SMRCFPPD
     C                   IF        %FOUND
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
