     H
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Initialise internal contracts')
      *****************************************************************
      *                                                               *
      *  Midas - APIs module                                          *
      *                                                               *
      *  APINZINTC - Switchable features initialisation for           *
      *              internal contracts.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 13JAN06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP004             Date 27Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
 
     FABDEALPP  UP   E             DISK
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
 
     D @ABIC         E DS                  EXTNAME(ABDEALPP)
     D  @DLAD                 61     68  0
     D  @DDAT                113    120  0
     D  @NDAT                171    178  0
     D  @FDAT                179    186  0
 
     D                 DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
 
      * PARAMETERS
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
 
      * Last Action Date
     C     @DLAD         IFNE      *ZERO
     C                   MOVE      @DLAD         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        JPDLAD
     C                   ELSE
     C                   Z-ADD     *ZERO         JPDLAD
     C                   END
 
      * Deal Date
     C     @DDAT         IFNE      *ZERO
     C                   MOVE      @DDAT         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        JPDDAT
     C                   ELSE
     C                   Z-ADD     *ZERO         JPDDAT
     C                   END
 
      * Deal Near Date
     C                   MOVE      @NDAT         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        JPNDAT
 
      * Deal Far Date
     C                   MOVE      @FDAT         @@DTIN
     C                   EXSR      ZA0680
     C                   MOVE      @@MDNO        JPFDAT
 
      * UPDATE DEAL
     C                   EXCEPT    ABDEAL
 
     C*******************************************************************
     C/EJECT
     C*******************************************************************
     C*
     C* ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)
     C*
     C*******************************************************************
 
     C     ZA0680        BEGSR
     C*
     C**  CLEAR OUT ANY 'OLD' DATA IN FIELD
     C                   Z-ADD     0             @@MDNO            5 0
     C*
     C**   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING
     C     @@YYYY        IFGE      2072
     C*
     C**    MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C     @@CC          SUB       19            @@WK2             2 0
     C     @@WK2         MULT      36524         @@MDNO
     C*
     C**  YEAR 2000 IS A LEAP YEAR MUST ALLOW EXTRA DAY
     C                   ADD       1             @@MDNO
     C                   END
     C*
     C     @@YYYY        ADD       28            @@WK2
     C*
     C     @@WK2         DIV       4             @@WK2
     C                   MVR                     @@REM             1 0
     C*
     C**    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     @@WK2         MULT      1461          @@WK5             5 0
     C                   ADD       @@WK5         @@MDNO
     C*
     C**  CHECK REMAINDER AND MONTH NUMBER
     C     @@REM         IFEQ      0
     C     @@MTH         ANDGT     2
     C                   ADD       1             @@MDNO
     C                   END
     C*
     C**  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     @@REM         IFNE      0
     C                   ADD       @YD(@@REM)    @@MDNO
     C                   END
     C*
     C**  ADD MONTHS THIS YEAR
     C                   ADD       @MD(@@MTH)    @@MDNO
     C*
     C**  ADD DAYS THIS MONTH
     C                   ADD       @@DAY         @@MDNO
     C*
     C     ZA0689        ENDSR
     C*****************************************************************
     OABDEALP0  E            ABDEAL
     O                       JPDDAT
     O                       JPNDAT
     O                       JPFDAT
     O                       JPDLAD
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @YD  USED BY SR. ZA0680 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZA0680 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
