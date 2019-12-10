     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD054605
/*STD *  RPGSQLBND                                                    *                     MD054605
/**** *  DBGVIEW(*LIST)                                               *                     MD054605
/*EXI *  TEXT('Midas SM Update "new" System Values')                  *
/**** *  OVRDBF FILE(UPSVALTPD) TOFILE(GPSVALL0)                      *            AR933964 MD054606
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000024 - Update 'to' System Values                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR933964           Date 13Mar12               *
      *                 CUP003  *CREATE    Date 23Sep10               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR933964 - UPSVALTPD has been made redundant.                *
      *  CUP003 - Enhancement to update System Values.                *
      *                                                               *
      *****************************************************************
     F*GPSVALPD* UF   E             DISK    INFSR(*PSSR)                                    MD054605
     F*UPSVALTPD IF   E           K DISK    INFSR(*PSSR)                                    MD054605
     F**********                           RENAME(GPSVALD0:SVALF)                           AR933964
     F**********                           PREFIX(F)                                        MD054605
      *
     D Recursive       S              1    INZ('N')
      *
     C*****1****         SETLL     GPSVALPD                                                 MD054605
     C**********         READ      GPSVALPD                                                 MD054605
      *
     C**********         DOW       NOT(%EOF)                                                MD054605
      *
      * Check for System Value on 'from' file.
     C*****GISVAL        CHAIN     UPSVALTPD                                                MD054605
     C**********         IF        %FOUND                                                   MD054605
     C**********         EVAL      GIVAL = FGIVAL                                           MD054605
     C**********         UPDATE    GPSVALD0                                                 MD054605
     C*********          ENDIF                                                              MD054605
      *
     C**********         READ      GPSVALPD                                                 MD054605
     C**********         ENDDO                                                              MD054605
      *
     C/EXEC SQL                                                                             MD054605
     C+ update GPSVLXTD A                                                                   MD054605
     C+  SET GIVAL = (SELECT B.GIVAL from UPSVALTPD B where                                 MD054605
     C+ A.GISVAL = B.GISVAL) where exists (select * from                                    MD054605
     C+ UPSVALTPD B where A.GISVAL = B.GISVAL)                                              MD054605
     C/END-EXEC                                                                             MD054605
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
