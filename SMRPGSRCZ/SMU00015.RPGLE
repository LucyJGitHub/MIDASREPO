     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Set balances on new MEMOS file')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00015 - Set balances on new MEMOS file                    *
      *                                                               *
      *  Function:  This program writes a record to MEMOS for every   *
      *             Retail account.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. CCB002             Date 11Jul96               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CCB00201.                          *
      *  CCB002 - COB Performance Enhancements                        *
      *           Access now via access object                        *
      *           Write a record to MEMOS for all Retail Accounts -the*
      *           MEMOS record will now contain Retail Account Number.*
      *                                                               *
      *****************************************************************
      /EJECT
     FACNUM     IF   E           K DISK
     FSMU001PD  IF   E             DISK
     F                                     RENAME(SMU001D0:@MEMOSOL)
     FMEMOSL2   O    E           K DISK
      /EJECT
      *
      /SPACE 3
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     C     *DTAARA       DEFINE                  LDA
      *
      * Set key for ACNUM.
     C     *LOVAL        SETLL     ACNUM
     C                   READ      ACNUM                                  50
      *
      * Process all Retail Accounts.
     C     *IN50         DOWEQ     *OFF
      *
      * Using Relative Record Number access respective MEMOS record.
     C     RRNM          CHAIN     SMU001PD                           51
      *
      * Data base error if no record found.
     C     *IN51         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'MEMOS '      DBFILE                         *DB ERROR 001 *
     C                   MOVEL     RRNM          DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * N.B The new fields for MEMOS (CNUM,CCY,ACOD,ACSQ,BRCA and ACNO)
      * will have been automatically filled as they are named as in
      * ACNUM.
     C                   WRITE     MEMOSMDF
      *
     C                   READ      ACNUM                                  50
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Mainline                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
      **                                                               ***
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
