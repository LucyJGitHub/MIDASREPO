     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  DBGVIEW(*LIST)                                               *
/*EXI *  TEXT('Midas SM Update "new" System Values')                  *
/*XBI *  OVRDBF FILE(UPSVALTPD) TOFILE(GPSVALL0)                      *                     AR933964
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000024 - Update 'to' System Values                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR933964           Date 13Mar12               *
      *  Prev Amend No. CUP003  *CREATE    Date 23Sep10               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR933964 - UPSVALTPD has been made redundant.                *
      *  CUP003 - Enhancement to update System Values.                *
      *                                                               *
      *****************************************************************
     FGPSVALPD  UF   E             DISK    INFSR(*PSSR)
     FUPSVALTPD IF   E           K DISK    INFSR(*PSSR)
     F**********                           RENAME(GPSVALD0:SVALF)                           AR933964
     F                                     PREFIX(F)
      *
     D Recursive       S              1    INZ('N')
      *
     C     1             SETLL     GPSVALPD
     C                   READ      GPSVALPD
      *
     C                   DOW       NOT(%EOF)
      *
      * Check for System Value on 'from' file.
     C     GISVAL        CHAIN     UPSVALTPD
     C                   IF        %FOUND
     C                   EVAL      GIVAL = FGIVAL
     C                   UPDATE    GPSVALD0
     C                   ENDIF
      *
     C                   READ      GPSVALPD
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
