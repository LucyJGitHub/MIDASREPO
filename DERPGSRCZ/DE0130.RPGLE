     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Retail Margin Rate Utility')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export Module                                   *
      *                                                               *
      *  DE0130 - Retail Margin Rate Utility                          *
      *                                                               *
      *  Function:  This program is used to default margin rate       *
      *             whenever Revenue Analysis (CDE002) is installed   *
      *             on an existing account and the margin override    *
      *             has not been set before.                          *
      *                                                               *
      *  Called By: DEC0110 - Input Extract Control Information       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CER055             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 208221  *CREATE    Date 11Dec02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  208221 - Date Export - CCRM Revenue Analysis                 *
      *                                                               *
      *****************************************************************
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)
     FACCNTBY0  UF   E           K DISK    INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D DEEXT         E DS                  EXTNAME(DEEXTCTL)
      ** Extract Control Data
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short date structure
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Read live loans file
      *
     C     DEDRMR        IFEQ      'Y'
     C                   READ      ACCNTL1                                99
      *
     C     *IN99         DOWEQ     *OFF
      *
     C     DRIB          IFNE      *ZERO
     C     CRIB          ORNE      *ZERO
      *
     C     KACNT         SETLL     ACCNTBY0                               99
      *
     C                   READ      ACCNTBY0                               99
      *
      ** SetUp fields for PF/LOAMSDK
      *
     C                   MOVEL     *BLANKS       UPDATE            1
     C                   EXSR      SRSETF
      *
      ** Write record to file
      *
     C     UPDATE        IFNE      *BLANKS
     C                   UPDATE    ACCNTBD0                             81
      *
     C     *IN81         IFEQ      *ON
     C                   MOVEL     'ACCNTBY0'    DBFILE
     C                   Z-ADD     02            DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read the next record
      *
     C                   READ      ACCNTL1                                99
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Return to the calling program
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Processing                                   *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE    DEEXTCTL      DEEXT
     C                   IN        DEEXT
      *
      ** Retrieve bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     01            DBASE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     KACNT         KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETF - SetUp the fields to be added to PF/ACCNTBY0          *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSETF        BEGSR
      *
      ** Default Margin Rate to Rate/Spread if base rate set up and
      ** margin rate override has not been set up
     C** Note if the rate/spread is zero, margin will default to zero
      *
     C     DRIB          IFNE      *ZEROS
     C     ATOVRD        ANDNE     'Y'
     C                   Z-ADD     DRIS          ATDRMG
     C                   Z-ADD     BJRDNB        ATDRMD
     C                   MOVEL     'Y'           ATOVRD
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
      *
     C     CRIB          IFNE      *ZEROS
     C     ATOVRC        ANDNE     'Y'
     C                   Z-SUB     CRIS          ATCRMG
     C                   Z-ADD     BJRDNB        ATCRMD
     C                   MOVEL     'Y'           ATOVRC
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
