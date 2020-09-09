     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Utility to calculate day of week')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  UTJ101 - Midas UT Utility to calculate day of the week       *
      *                                                               *
      *  Function:  This program calculates which day of the week it  *
      *             is and returns it to the calling program          *
      *                                                               *
      ***(c)*Misys*International*Banking Systems Ltd. 2007*************         EML110
      *  (c) Finastra International Limited 2018                      *         EML110
      *                                                               *
      *  Last Amend No. EML110             Date 20Jan20               *
      *  Prev Amend No. TFJ011  *CREATE    Date 23Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML110 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - Account Pooling                                     *
      *                                                               *
      *****************************************************************
     D DOW             S              3    DIM(7) CTDATA PERRCD(7)

      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    Rtn               5
     C                   PARM                    Day               3
      *
     C     *DTAARA       DEFINE                  LDA
      *
      * Get Midas day number of today
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C                   IF        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END

     C                   Z-ADD     BJRDNB        DayNum            5 0

     C     DayNum        IFEQ      1
     C                   MOVE      6             X
     C                   GOTO      STRT
     C                   END
      *
     C     DayNum        SUB       2             DAY1              6 0
     C     DAY1          DIV       7             DAY2              6 0
     C     DAY2          MULT      7             DAY3              6 0
     C     DAY1          SUB       DAY3          X                 1 0
     C     X             IFEQ      0
     C                   Z-ADD     7             X
     C                   END
     C     STRT          TAG
     C                   MOVEL     DOW(X)        Day

     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      Rtn = 'DBASE'
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
**   DOW  - DAY OF WEEK
MONTUEWEDTHUFRISATSUN
