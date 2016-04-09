     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
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
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. CSD013 *CREATE     Date 05Sep02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CSD013R01.                         *
      *  CSD013  - This program will initialise the SDSVALPD file     *
      *            records from the existing Midas data areas.        *
      *                                                               *
      *****************************************************************
     FSDSVALL0  UF   E           K DISK    INFSR(*PSSR)
 
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
 
     C     *LOVAL        SETLL     SDSVALL0
     C     @@SVAL        CHAIN     @SVALL0                            99
 
     C                   IF        *IN99 = *ON
     C                   EXSR      *PSSR
     C                   END
 
     C                   EVAL      GIVAL = PRSWFT
     C                   UPDATE    @SVALL0
 
     C                   ENDIF
 
      ** Initialise ReopenAutoRecs
 
     C     PRATRC        IFEQ      'N'
     C     PRATRC        OREQ      ' '
 
     C                   EVAL      @@SVAL = 'ReopenAutoRecs'
 
     C     *LOVAL        SETLL     SDSVALL0
     C     @@SVAL        CHAIN     @SVALL0                            99
 
     C                   IF        *IN99 = *ON
     C                   EXSR      *PSSR
     C                   END
 
     C                   EVAL      GIVAL = PRATRC
     C                   UPDATE    @SVALL0
 
     C                   ENDIF
 
      ** Initialise ReopenFXNets
 
     C     PRFXNT        IFEQ      'N'
     C     PRFXNT        OREQ      ' '
 
     C                   EVAL      @@SVAL = 'ReopenFXNets'
 
     C     *LOVAL        SETLL     SDSVALL0
     C     @@SVAL        CHAIN     @SVALL0                            99
 
     C                   IF        *IN99 = *ON
     C                   EXSR      *PSSR
     C                   END
 
     C                   EVAL      GIVAL = PRFXNT
     C                   UPDATE    @SVALL0
 
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
