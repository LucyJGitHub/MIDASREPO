     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Update Forward Revaluation Details')          *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL4420 - Update Forward Revaluation Details                  *
      *                                                               *
      *  Function:  This program reads DEALSBX1 and updates fields    *
      *  in each record according to previous values in other fields. *
      *  Note that an OPNQRYF in the calling CL program overrides     *
      *  DEALSBX1                                                     *
      *                                                               *
      *  Called by : DLC4420 - Update Forward Revaluation Details     *
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
      *  90 - End of File DEALSBX1                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initial processing                                   *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *
      * FX Forward Revaluation Amounts and Rates file (Overidden)
      * This is a subset of records >= Run Day AND < Next Working Day
      *
     FDEALSBX1  UF   E           K DISK    INFSR(*PSSR)
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
      /SPACE 5
      *****************************************************************
      *
      * Read records sequentially until end of file
      *
     C                   READ      DEALSBD1                               90
     C     *IN90         DOWEQ     *OFF
      *
      * Update fields in DEALSBX1
      *
     C                   Z-ADD     LCBRA         LLBRA
     C                   Z-ADD     LCSRA         LLSRA
     C                   Z-ADD     0             LCBRA
     C                   Z-ADD     0             LCSRA
     C                   Z-ADD     LCBRR         LLBRR
     C                   Z-ADD     LCSRR         LLSRR
     C                   Z-ADD     0             LCBRR
     C                   Z-ADD     0             LCSRR
     C                   UPDATE    DEALSBD1
      *
      * Read the next record and loop
      *
     C                   READ      DEALSBD1                               90
     C                   ENDDO
      *
      * End the program normally
      *
     C                   SETON                                        LR
     C                   RETURN
      *
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
     C                   MOVEL     '*NEXT'       DBKEY
     C                   MOVEL     'DL4420  '    DBPGM
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
      /SPACE 5
      *****************************************************************
**  @CPY - Object Copyright
(c) Finastra International Limited 2001
