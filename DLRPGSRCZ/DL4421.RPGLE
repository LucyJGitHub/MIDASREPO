     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Drop FX Deals Extension Records')             *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL4421 - Drop FX Deals Extension Records                     *
      *                                                               *
      *  Function:  This program drops DEALSBX1 records when they     *
      *  are no longer required.                                      *
      *                                                               *
      *                                                               *
      *  Called by : DLC4421 - Drop FX Deals Extension Records        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. LLE028  *CREATE    Date 24Feb20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLE028 - Store FX Revaluation Amounts and Rates              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  80 - End of File DEALSBX1                                    *
      *  90 - No record found in DEALSDB                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * MAIN   - Main Processing                                      *
      * TERM   - Program Termination                                  *
      * *INZSR - Initial processing                                   *
      * *PSSR  - Error processing                                     *
      *                                                               *
      *****************************************************************
      *
      * FX Deal extension file
      *
     FDEALSBX1  UF   E           K DISK    INFSR(*PSSR)
      *
      * Deals master file
      *
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDBF)
      *
      ********************************************************************
      *
      * Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      * Local Data Area
      *
     D LDA           E DS                  EXTNAME(LDA)
      *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * M A I N  P R O C E S S I N G                                  *
      *****************************************************************
      *
      * Main Processing
      *
     C                   EXSR      MAIN
      *
      * Termination Processing
      *
     C                   EXSR      TERM
      *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * MAIN - Main Processing                                        *
      *****************************************************************
     C     MAIN          BEGSR
      *
      * Read through extention file, only delete records on this file
      * when they do not appear in fx deals master
      *
     C     *LOVAL        SETLL     DEALSBX1
     C                   READ      DEALSBX1                               80
      *
     C     *IN80         DOWEQ     *OFF
      *
     C     KEYDL         CHAIN     DEALS                              90
      *
      * Perform the delete if corresponding record not found
     C     *IN90         IFEQ      *ON
     C                   DELETE    DEALSBD1
     C                   ENDIF
      *
     C                   READ      DEALSBX1                               80
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      * Define Local Data Area
      *
     C     *DTAARA       DEFINE                  LDA
      *
      * Set up key list FX deals master
     C     KEYDL         KLIST
     C                   KFLD                    LDLNO
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * TERM - Program Termination                                    *
      *****************************************************************
     C     TERM          BEGSR
     C*
     C                   MOVEL     *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ****************************************************************
      *                                                              *
      * *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,     *
      *          or directly by the program code using EXSR.         *
      *          This subroutine DUMPs the program just once.        *
      *                                                              *
      ****************************************************************
     C     *PSSR         BEGSR
      *
      ** Only run once
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVEL     'Y'           WRUN              1
      *
      ** Details of error
      *
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'DEALSBX1'    DBFILE
     C                   MOVEL     '*PSSR'       DBKEY
     C                   MOVEL     'DL4421  '    DBPGM
     C                   OUT       LDA
     C                   DUMP
     C                   ENDIF
      *
      ** End program with error
      *
     C                   SETON                                        LRU7U8
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@ - Object Copyright
(c) Finastra International Limited 2001
