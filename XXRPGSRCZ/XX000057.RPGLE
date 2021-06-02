     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('EODRUN END OF MONTH CHECK')                            *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Processing                         *
      *                                                               *
      ******GLM057*-*EODRUN*END*OF*MONTH*CHECk*************************                       LUC109
      *     XX000057 - EODRUN END OF MONTH CHECK                      *                       LUC109
      *     ( Based on SD2000)                                        *
      *                                                               *
      *****************************************************************
      * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
      * OF LIBL ***                                                   *
      *****************************************************************
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1980,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MMI043  *CREATE    Date 02Mar99               *
      * Midas DBA 2.0 --------------- Base ---------------------------*
      *                 S01194             Date 02Feb90               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043 - Interface to Head Office Reporting                  *
      *           Remove AOBANKR0.                                    *
      *  S01194 - NEW STANDING DATA FILES                             *
      *                                                               *
      *****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *                                                               *
      *****************************************************************
     F*** Start MMI043
     FSDBANKPD  IF   E           K DISK
     F*** End MMI043
     F***TABTB10 IP  F      96            DISK                            S01194
     F***TABTB11 IS  F      96            DISK                            S01194
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F**01***************ICDR 1                                           S01194
     F**02***************ICDR 2                                           S01194
     F*      42          END OF MONTH
     F*      43          END OF YEAR
     F*      99          ERROR IN SUBROUTINE
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR.ARRAY
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*****TABLE*FILE*-*INSTALLATION*CONTROL*DATA*RECORD*1.               S01194
     D***                                                                 S01194
     D***TABTB10 NS  01   2 C0   3 C1  12 C1                              S01194
     D***    AND      13 C0                                               S01194
     D***                                     1   1 RECI                  S01194
     D***                                     2   30RECT                  S01194
     D***                                    12  130RCDE                  S01194
     D***                                    14  66 TITL                  S01194
     D***                                    67  67 DATF                  S01194
     D***                                    68  700DFBR                  S01194
     D***                                    74  74 MODI1                 S01194
     D***                                    75  75 MODI2                 S01194
     D***                                    76  76 MODI3                 S01194
     D***                                 P  77  790RUND                  S01194
     D***                                    80  86 RUNA                  S01194
     D***                                    87  870SFLG                  S01194
     D***                                                                 S01194
     D***TABTB10 NS                                                       S01194
     D***                                     1   1 RECI                  S01194
     D***                                                                 S01194
     D*****TABLE*FILE*-*INSTALLATION*CONTROL*DATA*RECORD*2.               S01194
     D***                                                                 S01194
     D***TABTB11 NS  02   2 C0   3 C1                                     S01194
     D***    AND      12 C1  13 C1                                        S01194
     D***                                     1   1 RECI
     D***                                     2   30RECT                  S01194
     D***                                    12  130RCDE                  S01194
     D***                                    14  16 BCCY                  S01194
     D***                                    17  19 BCYL                  S01194
     D***                                    20  22 HOCY                  S01194
     D***                                    23  280HEAD                  S01194
     D***                                 P  29  310APDA                  S01194
     D***                                    35  35 APFQ                  S01194
     D***                                 P  36  380LOGS                  S01194
     D***                                    39  40 CUZR                  S01194
     D***                                 P  41  430DNWD                  S01194
     D***                                    44  460BVLP                  S01194
     D***                                    47  49 LOCY                  S01194
     D***                                    50  510FDAY                  S01194
     D***                                    52  52 ACLD                  S01194
     D***                                    53  53 MBIN                  S01194
     D***                                    86  86 ISAV                  S01194
     D***                                 P  87  890LLOG                  S01194
     D***TABTB11 NS                                                       S01194
     D***                                     1   1 RECI                  S01194
     D***                                                                 S01194
     D***                                                                 S01194
     D LDA            UDS           256                                         S01194
     D  DBFILE               134    141                                         S01194
     D  DBKEY                142    170                                         S01194
     D  DBPGM                171    180                                         S01194
     D  DBASE                181    183  0                                      S01194
     D**     LOCAL DATA AREA                                              S01194
     D*                                                                   S01194
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
     D** EXTERNAL DATA STRUCTURE FOR ACCESS PROGRAM FORMAT                S01194
     D*                                                                   S01194
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     I** FIRST DATA STRUCTURE FOR ACCESS PROGRAM, SHORT DATA STRUCTURE    S01194
     I*                                                                   S01194
     C********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EOM
     C                   PARM                    EOY
     C                   PARM                    ERROR                                         S0119
     C**
     C                   MOVEA     CPY@          BIS@             80
     C*                                                                   S01194
     C     *DTAARA       DEFINE                  LDA                                           S0119
     C*                                                                   S01194
     C*    CHECK INSTALLATION CONTROL DATA                                S01194
     C*    USE ACCESS OBJECT TO OBTAIN RECORD FROM SDBANKPD               S01194
     C*                                                                   S01194
     C*** Start MMI043
     C*                    CALL 'AOBANKR0'                                S01194
     C*                    PARM '*MSG   ' P@RTCD  7                       S01194
     C*                    PARM '*FIRST ' P@OPTN  7                       S01194
     C*          SDBANK    PARM SDBANK    DSFDY                           S01194
     C                   READ      SDBANKPD                               88
     C*** End MMI043
     C*                                                                   S01194
     C** DATABASE ERROR HANDLING IF BLANK RETURN                          S01194
     C** CODE NOT RECEIVED FROM ACCESS PROGRAM                            S01194
     C*                                                                   S01194
     C*** Start MMI043
     C*          P@RTCD    IFNE *BLANK                                    S01194
     C     *IN88         IFEQ      *ON                                                         S0119
     C*** End MMI043
     C     *LOCK         IN        LDA                                                         S0119
     C*** Start MMI043
     C*                    MOVELP@RTCD    DBKEY                           S01194
     C                   MOVEL     *BLANKS       DBKEY                                         S0119
     C*** End MMI043
     C                   MOVEL     'SDBANK'      DBFILE                         ************   S0119
     C                   Z-ADD     1             DBASE                          * DBERR 01 *   S0119
     C                   MOVEL     'SD2000'      DBPGM                          ************   S0119
     C                   OUT       LDA                                                         S0119
     C                   MOVE      'Y'           ERROR             1                           S0119
     C                   SETON                                        U7U8LR                   S0119
     C                   RETURN                                                                S0119
     C                   END                                                                   S0119
     C*                                                                   S01194
     C**   CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.
     C***01      DATF      COMP 'M'                      98MMDDYY, 98 ON  S01194
     C     BJDFIN        COMP      'M'                                    98    MMDDYY, 98 ON  S0119
     C**
     C**
     C********************************************************************
     C**
     C***** SET DEFAULT VALUES OF PARAMETERS
     C**
     C                   MOVE      'N'           EOM               1
     C                   MOVE      'N'           EOY               1
     C*                                                                   S01194
     C**  SET ON LR FOR REMAINDER OF PROCESSING                           S01194
     C*                                                                   S01194
     C                   SETON                                        LR                       S0119
     C**
     C***** SET UP YEAR NUMBER AND MONTH NUMBER OF TODAY
     C**
     C***LR                MOVE RUNA      WRK5    5                       S01194
     CLR                 MOVE      BJMRDT        WRK5              5                           S0119
     CLR                 MOVEL     WRK5          MONTH             3
     C***LR                MOVE RUNA      YEAR    20                      S01194
     CLR                 MOVE      BJMRDT        YEAR              2 0                         S0119
     C**
     C***** SET UP YEAR NUMBER AND MONTH NUMBER OF NEXT WORKING DAY
     C**
     C***LR                MOVE DNWD      ZDAYNO                          S01194
     CLR                 MOVE      BJDNWD        ZDAYNO                                        S0119
     CLR                 EXSR      ZDATE2
     C**
     C***** CHECK TODAYS AND TOMORROWS VALUES
     C**
     CLR   ZYEAR         COMP      YEAR                               4343
     CLRN43ZMNM(ZMTH)    COMP      MONTH                              4242
     CLR 43              SETON                                        42
     C**
     C***** SET PARAMETER VALUES
     C**
     CLR 43              MOVE      'Y'           EOY
     CLR 42              MOVE      'Y'           EOM
     C**
     CLR                 RETURN                                                                S0119
     C********************************************************************
     C**
     C**   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
     C**
     C**   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
     C**
     C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
     C**
     C**   CLEAR DATE FIELDS.
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
     C**
     C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C**
     C**   DETERMINE YEAR NUMBER.
     C**
     C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     C     ZDAYNO        SUB       1             ZDAYN1            5 0  99
     C   99              GOTO      ZDEND2
     C**
     C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1                         SAVE REMAINING
     C**                                                   DAYS
     C**   CALCULATE NUMBER OF REMAINING YEARS.
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
     C     ZDAYN1        COMP      ZYDY(ZWRK2)                          90
     C  N90ZWRK2         ADD       1             ZWRK2
     C  N90              GOTO      ZDTAG1
     C     ZWRK2         SUB       1             ZWRK2                    91    LEAP YR, 91 ON
     C**
     C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     C  N91ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C**
     C**   CALCULATE ACTUAL YEAR NUMBER.
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
     C**
     C**   DETERMINE MONTH NUMBER.
     C**
     C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     C                   SETOFF                                       9293
     C   91ZDAYN1        COMP      59                                   9293
     C   91
     CANN92ZDAYN1        SUB       1             ZDAYN1
     C**
     C**   CALCULATE MONTH NUMBER.
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
     C     ZDAYN1        COMP      ZMDY(ZWRK2)                          94
     C  N94ZWRK2         ADD       1             ZWRK2
     C  N94              GOTO      ZDTAG2
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
     C**
     C**   DETERMINE DAY OF MONTH.
2492 C**
2493 C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
2494 C     ZDAYN1        ADD       1             ZDAYN1
2495 C**
2496 C**   CALCULATE DAY OF MONTH.
2497 C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
2498 C**
2499 C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
2500 C   93ZDAY          ADD       1             ZDAY
2501 C**
2502 C**   FORMAT DATE, DDMMYY OR MMDDYY.
2503 C  N98              MOVEL     ZDAY          ZWRK4             4 0
2504 C   98              MOVE      ZDAY          ZWRK4
2505 C  N98              MOVE      ZMTH          ZWRK4
2506 C   98              MOVEL     ZMTH          ZWRK4
2507 C                   MOVEL     ZWRK4         ZDATE
2508 C                   MOVE      ZYEAR         ZDATE
2509 C**
2510 C**   FORMAT ALPHA DATE, DDMMMYY.
2511 C     ZDAY          COMP      10                                   95
2512 C                   MOVEL     ZDAY          ZWRK5             5
2513 C   95              MOVEL     ' '           ZWRK5
2514 C                   MOVE      ZMNM(ZMTH)    ZWRK5
2515 C                   MOVEL     ZWRK5         ZADATE
2516 C                   MOVE      ZYEAR         ZADATE
2517 C**
2518 C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
2519 C**
2520 C**
2521 C********************************************************************
**   ZYDY - YEARS IN DAYS CUMULATIVE IN FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** CPY@   OBJECT COPYRIGHT
(c) Finastra International Limited 2016
