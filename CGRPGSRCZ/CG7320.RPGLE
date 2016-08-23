     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Clear Down Pages File')        *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7320 - Interest Scale Report - Clear Down Pages File       *
      *                                                               *
      *  Called By: CGC7320                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CER042 *Create     Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
 
      ** Interest Scale pages file
     FCGISMPPD  UP   E             DISK
 
      ** Data structure for definition of bank specific details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *  Data structure for definition of long dummy data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      *  Data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      *  Program status data structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
     D @RTCD           S              7
     D @OPTN           S              7
     D ZDAYNO          S              5  0
     D ZDATFM          S              1
     D ZDATE           S              6  0
     D ZADATE          S              7
     D MONTH           S              4  0
     D @FIRST          S              3
 
      *----------------------------------------------------------------
      *  Main routine - Main Controlling subroutine
      *
      *  Called by :  None
      *  Calls     :  First  - Initial Housekeeping
      *----------------------------------------------------------------
 
      *  If not already done perform initial housekeeping
     C     @FIRST        IFNE      'YES'
     C                   EXSR      FIRST
     C                   ENDIF
 
      *  If record is not for month of next working day
     C     Z4MNTH        IFNE      MONTH
      *  Delete the record from the file
     C                   DELETE    CGISMPD0
     C                   ENDIF
 
      *----------------------------------------------------------------
      /EJECT
      *----------------------------------------------------------------
      *  FIRST SR. - Initial processing
      *
      *  Called by :  Main Routine
      *  Calls     :  None
      *----------------------------------------------------------------
     C     FIRST         BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Access bank details via an access program
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
      *  Error, record not found
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     PGM           DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get the month and year of the next working day
     C                   CALL      'ZDATE2'
     C                   PARM      BJDNWD        ZDAYNO
     C                   PARM      *BLANKS       ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   Z-ADD     ZDATE         MONTH
 
      ** Set the flag to say the routine has been run
     C                   MOVE      'YES'         @FIRST
 
     C                   ENDSR
      *----------------------------------------------------------------
      * *PSSR  - File exception/ error subroutine
      *
      * Called by: Main routine - Main controlling subroutine
      * Calls:     None
      *----------------------------------------------------------------
     C     *PSSR         BEGSR
 
      ** If a database error set on U8
     C     DBFILE        IFNE      *BLANK
     C                   MOVE      *ON           *INU8
     C                   ENDIF
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
