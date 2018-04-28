     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPSVALTPD) TOFILE(SDSVALL0)                      *                     MD019975
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update "new" System Values')                  *
/*E*I****DBGVIEW(*LIST)************************************************                     MD019975
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000026 - Update 'to' System Values                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. MD019975           Date 10Apr13               *
      *  Prev Amend No. CUP003  *CREATE    Date 23Sep10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD019975 - Use different version of SDSVAL* file.            *
      *  CUP003 - Enhancement to update System Values.                *
      *                                                               *
      *****************************************************************
     FSDSVALPD  UF   E             DISK    INFSR(*PSSR)
     FUPSVALTPD IF   E           K DISK    INFSR(*PSSR)
     F**********                           RENAME(GPSVALD0:SVALF)                           MD019975
     F                                     RENAME(@SVALL0:SVALF)                            MD019975
     F                                     PREFIX(F)
      *
     D Recursive       S              1    INZ('N')
      *
     C     1             SETLL     SDSVALPD
     C                   READ      SDSVALPD
      *
     C                   DOW       NOT(%EOF)
      *
      * Check for System Value on 'from' file.
     C     GISVAL        CHAIN     UPSVALTPD
     C                   IF        %FOUND
     C                   EVAL      GIVAL = FGIVAL
     C                   UPDATE    SDSVALD0
     C                   ENDIF
      *
     C                   READ      SDSVALPD
     C                   ENDDO
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
