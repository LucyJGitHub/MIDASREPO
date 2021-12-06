     H
     F********************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas ER Production Extract Report-Only Guaranties')
     F********************************************************************
     F*                                                                  *
     F*    Midas - European Reporting                                    *
     F*                                                                  *
     F*    ERLU87 - Production Extract - Audit Report - Only Guaranties  *
     F*                                                                  *
      *  (c) Finastra International Limited 2005                      *
     F*                                                                  *
     F*                                                                  *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 225555             Date 01Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 06May06               *
      *                 CER001             Date 25Apr05               *
      *                 ULX046             Date 31Oct02               *
      *                 187689             Date 20Dec00               *
     F*                   132893            DATE 15APR98                 *
     F*                   ULX004            DATE 26MAR97                 *
     F*                   ERL425 PT         DATE 25AUG94                 *
     F*                   71013  DDJ        DATE 15OCT93                 *
     F*                   61874  TLI        DATE 19JAN94                 *
     F*                   ERL371 TLI        DATE 13JAN94                 *
     F*                   ERL349 TLI        DATE 03JUN93                 *
     F*                   ER0336 TLI        DATE 16APR93                 *
     F*                   ERL334 TLi        DATE 01MAR93                 *
     F*                   ERL305 TLi        DATE 26JAN93                 *
     F*                   ERL303 TLi        DATE 21JAN93                 *
     F*                                                                  *
     F********************************************************************
      *                                                                  *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *    225555 - Add discount/premium amount, amount to amortize      *
      *             and 'Prix d'Acquisition'. Recompile over changed     *
      *             ERLUTRPD.                                            *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  CER001 - LUX Upgrade to MidasPlus                            *
     F*    ULX046 - Circulars 2002/170-174-175 Integration               *
     F*             Recompiled due to changes in file layout             *
     F*    187689 - "GRD" currency in EMU                                *
     F*             Just recompile over new PF/ERLUTRPD description      *
     F*    132893 - SPF/RCF for IBLC/BNB on DBA2.3                       *
     F*    ULX004 - CAPITAL ADEQUACY                                     *
     F*           - IML Circular 97/138                                  *
     F*             Recompile only                                       *
     F*    ERL425 - TO PRINT GUARANTOR DETAILS INSTEAD OF COUNTERPARTY   *
     F*    71013  - CHANGE LENGTH OF IML RUBRIC (RECOMPILE)              *
     F*    61874  - AMOUNTS SHOULD BE EDITED                             *
     F*    ERL371 - IML 1.4 DEVELOPMENT                                  *
     F*    ERL349 - RECOMPILED Due to change between EXCUCL and EXCNCZ   *
     F*    ER0336 - IML 2.3 DEVELOPMENT - Add total by Guarantee type    *
     F*    ERL334 - For Securities print Security Report Name            *
     F*    ERL305 - Add Guarantie Type on report                         *
     F*    ERL303 - Written for new layout - Only Guaranties             *
     F********************************************************************
     F*IMLNARPD* IF   E           K DISK                                         71013      MD058079
      ** Narrative for IML code                                           71013
     F*                                                                   71013
     F***ERLUTRL1IF**E           K        DISK                                                CER001
     FERLTRXL1  IF   E           K DISK
      **  Production Extract - Only Guaranties
     FERLU87P1  O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(SPOOL1)                        132893
     FERLU88P1  O    E             PRINTER OFLIND(*IN98)
     F******                                        KINFDS PRTDS
     F                                     INFDS(SPOOL2)                        132893
     F*
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*
     F*       97         OVERFLOW INDICATOR FOR ERLU87P1
     F*       98         OVERFLOW INDICATOR FOR ERLU88P1
     F*
     F*       U7         DATABASE ERROR
     F*       U8         PROGRAM  ERROR
     F*
     F**               *************************                         *
     F**               ** INDICATORS NOT USED **                         *
     F**               ** ------------------- **                         *
     F**               *************************                         *
     F**                                                                 *
     F**      ***************************************************        *
     F**      * 01   02   03   04   05   06   07   08   09   10 *        *
     F**      * 11   12   13   14   15   16   17   18   19   20 *        *
     F**      * 21   22   23   24   25   26   27   28   29   30 *        *
     F**      * 31   32   33   34   35   36   37   38   39   40 *        *
     F**      * 41   42   43   44   45   46   47   48   49   50 *        *
     F**      * 51   52   53   54   55   56   57   58   59   60 *        *
     F**      * 61   62   63   64   65   66   67   68   69   70 *        *
     F**      * 71   72   73   74   75   76   77   78   79   80 *        *
     F**      * 81   82   83   84   85   86   87   88   89   90 *        *
     F**      * 91   92   93   94   95   96   97   98   99      *        *
     F**      ***************************************************        *
     F********************************************************************
      *
      /EJECT
      *
      *
      ** ARRAY FOR COPYRIGHT
      *
      /EJECT
      *
     D****PRTDS       DS                                                  132893
      *
      **  Printer file information data structure.
     D****                                B 152 1530PAGLEN                132893
     D****                                B 188 1890OVRLIN                132893
     D****                                B 367 3680CURLIN                132893
      *
     D CPYR@#          DS
      *
      **  Data structure for compilation - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      *
     D                 DS
      *
      **  Data structure for Start Date
     D  EXSTRD                 1      8  0
     D  YY1                    1      4
     D  MM1                    5      6
     D  DD1                    7      8
     D                 DS
      *
      **  Data structure for End Date
     D  EXENDD                 1      8  0
     D  YY2                    1      4
     D  MM2                    5      6
     D  DD2                    7      8
     D                 DS
      *
      **  Data structure for Revision Date
     D  EXREVD                 1      8  0
     D  YY3                    1      4
     D  MM3                    5      6
     D  DD3                    7      8
     D                 DS
      *
      **  Data structure for Start Date new format to print
     D  P1STRD                 1      8
     D  STDD                   1      2
     D  STMM                   3      4
     D  STYY                   5      8
     D                 DS
      *
      **  Data structure for End Date new format to print
     D  P1ENDD                 1      8
     D  EDDD                   1      2
     D  EDMM                   3      4
     D  EDYY                   5      8
     D                 DS
      *
      **  Data structure for Revision Date new format to print
     D  P1REVD                 1      8
     D  REDD                   1      2
     D  REMM                   3      4
     D  REYY                   5      8
      *                                                                   132893
     D LDA1            DS           256                                         132893
     D*  DATA AREA DATA STRUCTURE FOR HANDLING DB ERRORS                  132893
     D*                                                                   132893
     D  DBFILE               134    141                                         132893
     D  DBKEY                142    170                                         132893
     D  DBPGM                171    180                                         132893
     D  DBASE                181    183                                         132893
     D SPOOL1          DS                                                       132893
      *                                                                   132893
      **  File Information Data Structure - P1 report                     132893
     D  SFIL1                 83     92                                         132893
     D  SFNUM1               123    124B 0                                      132893
     D SPOOL2          DS                                                       132893
      *                                                                   132893
      **  File Information Data Structure - P1 report                     132893
     D  SFIL2                 83     92                                         132893
     D  SFNUM2               123    124B 0                                      132893
     D  PAGLEN               152    153B 0                                      132893
     D  OVRLIN               188    189B 0                                      132893
     D  CURLIN               367    368B 0                                      132893
     D                 DS                                                       ULX004
      *                                                                   ULX004
      **  Data structure for Facility reference                           ULX004
     D  P1FACL                 1     13                                         ULX004
     D  WWFCUS                 1      6                                         ULX004
     D  WWFACT                 8     10                                         ULX004
     D  WWFCNO                12     13                                         ULX004
     D IMLNAX        E DS                  EXTNAME(ERLNAJW0)                                MD058079
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * INDEX OF SUBROUTINES                                             *
      * MAIN     -                                                       *
      * PRTLGN   - S/R TO PRINT REPORT DETAIL LIGNE                      *
      * INIT     - S/R TO INITIALIZE STATIC FIELDS                       *
      *                                                                  *
      * EXTERNAL ROUTINES CALLED                                         *
      *                                                                  *
      ********************************************************************
     C*================================================================
     C*  P R O G R A M     S T A R T
     C*================================================================
     C*
     C*----------------- FIRST CYCLE -----------------------------
     C*
      *
     C                   EXSR      INIT
      *
     C********** *LOVAL    SETLLERLUTRL1                                                      CER001
     C**********           READ ERLUTRL1                 81                                   CER001
     C     *LOVAL        SETLL     ERLTRXL1
     C                   READ      ERLTRXL1                               81
      *
     C     *IN81         IFEQ      '1'
     C                   WRITE     ERLU87H1
     C                   WRITE     ERLU87E1
     C                   WRITE     ERLU88H1
     C                   WRITE     ERLU88E1
     C                   END
      *
     C                   Z-ADD     EXSCHA        BKSCHA            8 0
     C                   Z-ADD     EXRECT        BKRECT            3 0
     C                   MOVE      EXGUAT        BKGUAT            1                           ER033
     C*
     C*------------ DETAIL PROCESSING ----------------------------
     C*
      *
      **  Write report header
     C     *IN81         IFEQ      '0'
     C*
     C** RETRIEVE IML CODE NARRATIVE                                      71013
     C*****EXSCHA        CHAIN     IMLNARPD                           88              71013 MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :IMLNAX                                                                        MD058079
     C+ from ERLNAJW0                                                                       MD058079
     C+ where IMSCHA = :EXSCHA                                                              MD058079
     C/END-EXEC                                                                             MD058079
     C******IN88         IFEQ      '1'                                          - B3        MD058079
     C     SQLCODE       IFNE      0                                            - B3        MD058079
     C**********         MOVE      *BLANKS       IMLNAR                               71013 MD058079
     C                   MOVE      *BLANKS       IMLNAX                                     MD058079
     C                   END                                                                   71013
     C*                                                                   71013
     C                   WRITE     ERLU87H1
     C                   WRITE     ERLU87H2
     C                   WRITE     ERLU87H3
     C                   WRITE     ERLU88H1
     C                   WRITE     ERLU88H2
     C                   WRITE     ERLU88H3
     C                   END
      *
      ****Do*until*end*of*file*ERLUTRL1                                                       CER001
      **  Do until end of file ERLTRXL1                                                       CER001
     C     *IN81         DOWEQ     '0'
      *
     C                   MOVEL     '0'           *IN50
      *
      **  If there is not enough space on the physical page
      **  for this format :
     C     PAGLEN        SUB       CURLIN        WRKPAG            4 0
     C     WRKPAG        IFLE      8
      *
      **  Signal artificial overflow
     C                   SETON                                        97
      *
      **  Print page header
     C                   WRITE     ERLU87H1
     C                   WRITE     ERLU88H1
      *
     C     EXSCHA        IFNE      BKSCHA
     C     EXRECT        ORNE      BKRECT
      *                                                                   ER0336
     C                   MOVE      WKTOT1        P1TOT1                                        ER033
      *                                                                   ER0336
     C     WKTOT1        IFGE      0                                                           ER033
     C                   MOVE      'D'           P3DRCR                                        ER033
     C                   ELSE                                                                  ER033
     C                   MOVE      'C'           P3DRCR                                        ER033
     C                   END                                                                   ER033
     C                   WRITE     ERLU87D3                                                    ER033
     C                   WRITE     ERLU88D3                                                    ER033
     C                   Z-ADD     0             P1TOT1                                        ER033
     C                   Z-ADD     0             WKTOT1                                        ER033
      *                                                                   ER0336
     C                   MOVE      WKTOT2        P1TOT2
      *
     C     WKTOT2        IFGE      0
     C                   MOVE      'D'           P2DRCR
     C                   ELSE
     C                   MOVE      'C'           P2DRCR
     C                   END
      *
     C                   WRITE     ERLU87D2
     C*********************WRITEERLU87H2                                  ER0336
     C                   WRITE     ERLU88D2
     C*********************WRITEERLU88H2                                  ER0336
     C                   Z-ADD     0             P1TOT2
     C                   Z-ADD     0             WKTOT2
     C                   Z-ADD     EXSCHA        BKSCHA                                        ERL37
     C                   Z-ADD     EXRECT        BKRECT                                        ERL37
     C                   MOVE      EXGUAT        BKGUAT                                        ERL37
     C                   WRITE     ERLU87H1                                                    ERL37
     C                   WRITE     ERLU88H1                                                    ERL37
     C                   END
      *
     C                   WRITE     ERLU87H2                                                    ER033
     C                   WRITE     ERLU88H2                                                    ER033
     C                   WRITE     ERLU87H3
     C                   WRITE     ERLU88H3
     C                   MOVEL     '0'           *IN50
     C                   END
      *
      **  Print ligne data
     C                   EXSR      PRTLGN
      *
      **  Save Code Schema A to check if rupture
     C                   Z-ADD     EXSCHA        BKSCHA            8 0
      **  Save Record Type to check if rupture
     C                   Z-ADD     EXRECT        BKRECT            3 0
      **  Save Guarantee type to check if rupture                         ER0336
     C                   MOVE      EXGUAT        BKGUAT                                        ER033
      *
      **  Read next record
     C**********           READ ERLUTRL1                 81                                   CER001
     C                   READ      ERLTRXL1                               81
      *
     C     EXSCHA        IFNE      BKSCHA                                                      71013
     C*****EXSCHA        CHAIN     IMLNARPD                           88              71013 MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :IMLNAX                                                                        MD058079
     C+ from ERLNAJW0                                                                       MD058079
     C+ where IMSCHA = :EXSCHA                                                              MD058079
     C/END-EXEC                                                                             MD058079
     C******IN88         IFEQ      '1'                                          - B3        MD058079
     C     SQLCODE       IFNE      0                                            - B3        MD058079
     C**********         MOVE      *BLANKS       IMLNAR                               71013 MD058079
     C                   MOVE      *BLANKS       IMLNAX                                     MD058079
     C                   END                                                                   71013
     C                   END                                                                   71013
      *
      **  End CC1
     C                   END
      *
     C     *IN81         IFEQ      '1'
     C     EXSCHA        ANDNE     0
     C                   MOVE      WKTOT2        P1TOT2
      *
     C     WKTOT2        IFGE      0
     C                   MOVE      'D'           P2DRCR
     C                   ELSE
     C                   MOVE      'C'           P2DRCR
     C                   END
      *                                                                   ER0336
     C                   MOVE      WKTOT1        P1TOT1                                        ER033
      *                                                                   ER0336
     C     WKTOT1        IFGE      0                                                           ER033
     C                   MOVE      'D'           P3DRCR                                        ER033
     C                   ELSE                                                                  ER033
     C                   MOVE      'C'           P3DRCR                                        ER033
     C                   END                                                                   ER033
      *                                                                   ER0336
     C                   WRITE     ERLU87D3                                                    ER033
      *
     C                   WRITE     ERLU87D2
     C                   WRITE     ERLU87E2
     C                   WRITE     ERLU88D2
     C                   WRITE     ERLU88E2
     C                   END
      *
     C                   MOVEL     '1'           *INLR
      *
     C                   RETURN
      *
     C*================================================================
     C*  P R O G R A M     E N D
     C*================================================================
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * PRTLGN   - S/R TO PRINT REPORT DETAIL LIGNE                      *
      *                                                                  *
      * SUBROUTINE CALLS:                                                *
      * GLZADD   - S/R TO ADD AMOUNT (ZZAMT) TO TOTAL (ZZTOTI,ZZTOTD)    *
      * ZSEDIT   - S/R TO INSERT DEC. POINT AND SIGN INTO NUM. FIELD     *
      * ZDATE2   - S/R TO CONVERT A DAY NUMBER TO DATE FORMATS           *
      *                                                                  *
      * SUBROUTINE CALLED FROM:                                          *
      * MAIN     -                                                       *
      *                                                                  *
      * ROUTINE USES VARIABLES:                                          *
      *                                                                  *
      ********************************************************************
     C     PRTLGN        BEGSR
      *
      **  Load detail line
      *
      **  Accumulate controls
     C     RECTOT        ADD       1             RECTOT
      *                                                                   ER0336
     C     EXGUAT        IFNE      BKGUAT                                                      ER033
     C     EXGUAT        OREQ      BKGUAT                                                      ER033
     C     EXSCHA        ANDNE     BKSCHA                                                      ER033
     C                   MOVE      WKTOT1        P1TOT1                                        ER033
      *                                                                   ER0336
     C     WKTOT2        IFGE      0                                                           ER033
     C                   MOVE      'D'           P3DRCR                                        ER033
     C                   ELSE                                                                  ER033
     C                   MOVE      'C'           P3DRCR                                        ER033
     C                   END                                                                   ER033
      *                                                                   ER0336
     C                   WRITE     ERLU87D3                                                    ER033
     C                   WRITE     ERLU88D3                                                    ER033
     C                   Z-ADD     0             P1TOT1                                        ER033
     C                   Z-ADD     0             WKTOT1                                        ER033
     C                   END                                                                   ER033
      *                                                                   ER0336
      *
      **  If there is not enough space on the physical page
      **  for this format :
     C     PAGLEN        SUB       CURLIN        WRKPAG            4 0
     C     WRKPAG        IFLE      8
      *
      **  Signal artificial overflow
     C                   SETON                                        97
      *
      **  Print page header
     C                   WRITE     ERLU87H1
     C                   WRITE     ERLU88H1
     C     EXSCHA        IFNE      BKSCHA
     C     EXRECT        ORNE      BKRECT
      *                                                                   ER0336
     C                   MOVE      WKTOT1        P1TOT1                                        ER033
      *                                                                   ER0336
     C     WKTOT1        IFGE      0                                                           ER033
     C                   MOVE      'D'           P3DRCR                                        ER033
     C                   ELSE                                                                  ER033
     C                   MOVE      'C'           P3DRCR                                        ER033
     C                   END                                                                   ER033
     C                   WRITE     ERLU87D3                                                    ER033
     C                   WRITE     ERLU88D3                                                    ER033
     C                   Z-ADD     0             P1TOT1                                        ER033
     C                   Z-ADD     0             WKTOT1                                        ER033
      *                                                                   ER0336
     C                   MOVE      WKTOT2        P1TOT2
      *
     C     WKTOT2        IFGE      0
     C                   MOVE      'D'           P2DRCR
     C                   ELSE
     C                   MOVE      'C'           P2DRCR
     C                   END
      *
     C                   WRITE     ERLU87D2
     C*********************WRITEERLU87H2                                  ER0336
     C                   WRITE     ERLU88D2
     C*********************WRITEERLU88H2                                  ER0336
     C                   Z-ADD     0             P1TOT2
     C                   Z-ADD     0             WKTOT2
     C                   END
     C                   WRITE     ERLU87H2                                                    ER033
     C                   WRITE     ERLU88H2                                                    ER033
     C                   WRITE     ERLU87H3
     C                   WRITE     ERLU88H3
     C                   MOVEL     '0'           *IN50
     C                   END
      *
      **  Print report detail line
     C     EXSCHA        IFNE      BKSCHA
     C     EXRECT        ORNE      BKRECT
     C                   MOVE      WKTOT2        P1TOT2
      *
     C     WKTOT2        IFGE      0
     C                   MOVE      'D'           P2DRCR
     C                   ELSE
     C                   MOVE      'C'           P2DRCR
     C                   END
      *
     C                   WRITE     ERLU87D2
     C                   WRITE     ERLU87H1
     C*********************WRITEERLU87H2                                  ER0336
     C                   WRITE     ERLU88D2
     C                   WRITE     ERLU88H1
     C*********************WRITEERLU88H2                                  ER0336
     C                   Z-ADD     0             P1TOT2
     C                   Z-ADD     0             WKTOT2
     C                   WRITE     ERLU87H2                                                    ER033
     C                   WRITE     ERLU88H2                                                    ER033
     C                   WRITE     ERLU87H3
     C                   WRITE     ERLU88H3
     C                   END
      *
      **  Reset date format in DDMMYYY for start date
     C     EXSTRD        IFEQ      0
     C                   MOVE      *BLANK        P1STRD
     C                   MOVE      *BLANK        P2STRD                                        ERL30
     C                   ELSE
     C                   MOVE      DD1           STDD
     C                   MOVE      MM1           STMM
     C                   MOVE      YY1           STYY
     C                   MOVEL     P1STRD        P2STRD            6                           ERL30
     C                   MOVE      STYY          STYY2             2                           ERL30
     C                   MOVE      STYY2         P2STRD                                        ERL30
     C                   END
      *
      **  Reset date format in DDMMYYY for end date
     C     EXENDD        IFEQ      0
     C                   MOVE      *BLANK        P1ENDD
     C                   MOVE      *BLANK        P2ENDD                                        ERL30
     C                   ELSE
     C                   MOVE      DD2           EDDD
     C                   MOVE      MM2           EDMM
     C                   MOVE      YY2           EDYY
     C                   MOVEL     P1ENDD        P2ENDD            6                           ERL30
     C                   MOVE      EDYY          EDYY2             2                           ERL30
     C                   MOVE      EDYY2         P2ENDD                                        ERL30
     C                   END
      *
      **  Reset date format in DDMMYYY for revision date
     C     EXREVD        IFEQ      0
     C                   MOVE      *BLANK        P1REVD
     C                   MOVE      *BLANK        P2REVD                                        ERL30
     C                   ELSE
     C                   MOVE      DD3           REDD
     C                   MOVE      MM3           REMM
     C                   MOVE      YY3           REYY
     C                   MOVEL     P1REVD        P2REVD            6                           ERL30
     C                   MOVE      REYY          REYY2             2                           ERL30
     C                   MOVE      REYY2         P2REVD                                        ERL30
     C                   END
      *
     C                   MOVE      EXAMNT        P1AMNT
     C                   MOVE      EXLAMT        P1LAMT
      *
     C     EXDRCR        IFEQ      0
     C                   ADD       EXLAMT        WKTOT2           16 0
     C                   ADD       EXLAMT        WKTOT1           16 0                         ER033
     C                   ELSE
     C                   SUB       EXLAMT        WKTOT2
     C                   SUB       EXLAMT        WKTOT1                                        ER033
     C                   END
      *
     C     EXDRCR        IFEQ      0
     C                   MOVE      'D'           P1DRCR
     C                   ELSE
     C                   MOVE      'C'           P1DRCR
     C                   END
      *
     C                   MOVE      EXORIG        EXTREF
      *
      ***FOR*SECURITIES*PRINT*SECURITY*REPORT*NAME                 ERL334 ERL425
     C***********EXLOTD    IFEQ 'SEC'                              ERL334 ERL425
     C***********EXLOTD    OREQ 'SEF'                              ERL334 ERL425
     C***********          MOVE '1'       *IN60                    ERL334 ERL425
     C***********          MOVELEXSECY    WWSECD                   ER0336 ERL425
     C***********          ELSE                                    ERL334 ERL425
     C***********          MOVE '0'       *IN60                    ERL334 ERL425
     C***********          END                                     ERL334 ERL425
      *
     C******************** MOVELEXCRNM    WWCRNM                   61874  ERL425
     C                   MOVEL     EXGURN        WWGURN                                        ERL42
      *                                                                   ERL425
      ** Load facility reference if exists                                ULX004
      *                                                                   ULX004
     C     EXFCUS        IFNE      *BLANKS                                                     ULX00
     C                   MOVE      EXFCUS        WWFCUS                                        ULX00
     C                   MOVE      EXFACT        WWFACT                                        ULX00
     C                   MOVE      EXFCNO        WWFCNO                                        ULX00
     C                   ELSE                                                                  ULX00
     C                   MOVE      *BLANKS       P1FACL                                        ULX00
     C                   ENDIF                                                                 ULX00
      *                                                                   ULX004
     C                   WRITE     ERLU87D1
     C                   WRITE     ERLU88D1
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * INIT     - S/R TO INITIALIZE STATIC FIELDS                       *
      *                                                                  *
      * SUBROUTINE CALLS:                                                *
      *                                                                  *
      * SUBROUTINE CALLED FROM:                                          *
      * MAIN     -                                                       *
      *                                                                  *
      * ROUTINE USES VARIABLES:                                          *
      *                                                                  *
      ********************************************************************
     C     INIT          BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    BJMRDT            7
     C                   PARM                    BJURPT           53
     C                   PARM                    @RSEQ             5                           13289
     C                   PARM                    @RLEV             1                           13289
      *                                                                   132893
      **  PREPARE LDA:                                                    132893
     C     *DTAARA       DEFINE                  LDA1                                          13289
     C                   MOVEL     'ERLU87P'     DBPGM                                         13289
      *                                                                   132893
      * Record Printer file ERLU87P1 on RCF                               132893
     C                   Z-ADD     SFNUM1        ZSNUM                                         13289
     C                   MOVEL     SFIL1         SFILE                                         13289
      *                                                                   132893
     C                   EXSR      SRZSFL                                                      13289
      *                                                                   132893
      * Record Printer file ERLU88P1 on RCF                               132893
     C                   Z-ADD     SFNUM2        ZSNUM                                         13289
     C                   MOVEL     SFIL2         SFILE                                         13289
      *                                                                   132893
     C                   EXSR      SRZSFL                                                      13289
      *
      **  Initialize Field
     C                   Z-ADD     0             P1TOT2
     C                   Z-ADD     0             WKTOT2
     C                   Z-ADD     0             P1TOT1                                        ER033
     C                   Z-ADD     0             WKTOT1                                        ER033
      *
      **  Initialize indicators
     C                   MOVEL     '0'           *IN
      *
      *
      **  Define/Clear constante & variable
     C                   Z-ADD     1             RECTOT            5 0          Total report
      *
      **  Adjust page lengh and overflow as necessary
     C     PAGLEN        SUB       2             WPAGL             4 0
      *
     C     OVRLIN        IFGE      WPAGL
     C     WPAGL         SUB       2             WOVRL             4 0
     C                   ELSE
     C                   Z-ADD     OVRLIN        WOVRL
     C                   END
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
     C*****************************************************************   132893
     C* SRZSFL - Subroutine to call ZSFILE                                132893
     C*****************************************************************   132893
     C*                                                                   132893
     C     SRZSFL        BEGSR                                                                 13289
     C*                                                                   132893
     C                   CALL      'ZSFILE'                                                    13289
     C                   PARM                    @RSEQ             5                           13289
     C                   PARM                    @RENT             3                           13289
     C                   PARM                    SFILE            10                           13289
     C                   PARM                    ZSNUM             6 0                         13289
     C                   PARM                    ZSERR             1                           13289
     C*                                                                   132893
     C** If an error occurred during ZSFILE processing,                   132893
     C** return to the calling program.                                   132893
     C*                                                                   132893
     C     ZSERR         IFEQ      'Y'                                                         13289
     C                   SETON                                        U7U8LR                   13289
     C                   RETURN                                                                13289
     C                   END                                                                   13289
     C*                                                                   132893
     C                   ENDSR                                                                 13289
      ****************************************************************    132893
      /EJECT                                                              132893
**CTDATA CPY@
(c) Finastra International Limited 2005
