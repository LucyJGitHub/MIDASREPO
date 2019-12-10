     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD054605
/*STD *  RPGSQLBND                                                    *                     MD054605
/*EXI *  TEXT('Midas SM Initialise SDSVALPD from existing data')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00057 - Initialise SDSVALPD from Existing Data:           *
      *                                                               *
      *              ReopenSwiftTrans (DTAARA/CBPROMPT: PRSWFT)       *
      *              ReopenAutoRecs   (DTAARA/CBPROMPT: PRATRC)       *
      *              ReopenFXNets     (DTAARA/CBPROMPT: PRFXNT)       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CSD013 *C *CREATE  Date 05Sep02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CSD013R01.                         *
      *  CSD013  - This program will initialise the SDSVALPD file     *
      *            records from the existing Midas data areas.        *
      *                                                               *
      *****************************************************************
     F*SDSVALL0* UF   E           K DISK    INFSR(*PSSR)                                    MD054605

     D @@SVAL          S             20A
     D @RUN            S              1A

     D CBPROMPT        DS           256    DTAARA(CBPROMPT)
     D  PRSWFT                 1      1
     D  PRATRC                 2      2
     D  PRFXNT                 3      3

      * Process CBPROMPT replacements

     C                   IN        CBPROMPT
     C
      ** Initialise ReopenSwiftTrans

     C     PRSWFT        IFEQ      'N'
     C     PRSWFT        OREQ      ' '

     C                   EVAL      @@SVAL = 'ReopenSwiftTrans'

     C******LOVAL        SETLL     SDSVALL0                                                 MD054605
     C*****@@SVAL        CHAIN     @SVALL0                            99                    MD054605

     C**********         IF        *IN99 = *ON                                              MD054605
     C**********         EXSR      *PSSR                                                    MD054605
     C**********         END                                                                MD054605

     C**********         EVAL      GIVAL = PRSWFT                                           MD054605
     C**********         UPDATE    @SVALL0                                                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLXTD                                                                     MD054605
     C+  SET GIVAL = :PRSWFT                                                                MD054605
     C+ where GISVAL = :@@SVAL                                                              MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   EXSR      *PSSR                                                    MD054605
     C                   ENDIF                                                              MD054605

     C                   ENDIF

      ** Initialise ReopenAutoRecs

     C     PRATRC        IFEQ      'N'
     C     PRATRC        OREQ      ' '

     C                   EVAL      @@SVAL = 'ReopenAutoRecs'

     C******LOVAL        SETLL     SDSVALL0                                                 MD054605
     C*****@@SVAL        CHAIN     @SVALL0                            99                    MD054605

     C**********         IF        *IN99 = *ON                                              MD054605
     C**********         EXSR      *PSSR                                                    MD054605
     C**********         END                                                                MD054605

     C**********         EVAL      GIVAL = PRATRC                                           MD054605
     C**********         UPDATE    @SVALL0                                                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLXTD                                                                     MD054605
     C+  SET GIVAL = :PRATRC                                                                MD054605
     C+ where GISVAL = :@@SVAL                                                              MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   EXSR      *PSSR                                                    MD054605
     C                   ENDIF                                                              MD054605

     C                   ENDIF

      ** Initialise ReopenFXNets

     C     PRFXNT        IFEQ      'N'
     C     PRFXNT        OREQ      ' '

     C                   EVAL      @@SVAL = 'ReopenFXNets'

     C******LOVAL        SETLL     SDSVALL0                                                 MD054605
     C*****@@SVAL        CHAIN     @SVALL0                            99                    MD054605

     C**********         IF        *IN99 = *ON                                              MD054605
     C**********         EXSR      *PSSR                                                    MD054605
     C**********         END                                                                MD054605

     C**********         EVAL      GIVAL = PRFXNT                                           MD054605
     C**********         UPDATE    @SVALL0                                                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLXTD                                                                     MD054605
     C+  SET GIVAL = :PRFXNT                                                                MD054605
     C+ where GISVAL = :@@SVAL                                                              MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   EXSR      *PSSR                                                    MD054605
     C                   ENDIF                                                              MD054605

     C                   ENDIF

     C                   EVAL      *INLR = '1'
     C                   RETURN

      *****************************************************************
      *
      *  *PSSR - Subroutine to handle error conditions
      *
      *  Called from:  After abnormal operation occurs
      *
      *  Calls: Nothing
      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANKS
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
