     H DEBUG DATEDIT(*YMD)
     F********************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas ER Assets')
     F********************************************************************
     F*                                                                  *
     F*          MIDAS ABS - EUROPEAN REPORTING                          *
     F*                                                                  *
     F*    ERLU90 - ASSETS AND LIABILITIES   -   AUDIT REPORT            *
     F*                                                                  *
     F*    (c) Finastra International Limited 2005                       *
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
     F*                   ULX004            DATE 22APR98                 *
     F*                   132893            DATE 15APR98                 *
     F*                   65292 DDJ         DATE 13JAN94                 *
     F*                   61875 TLI         DATE 19OCT93                 *
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
     F*    ULX004- IML Circular 97/138                                   *
     F*            Recompile only                                        *
     F*    132893 - SPF/RCF for IBLC/BNB on DBA2.3                       *
     F*     65292 - DO NOT PRINT 'DONT' RUBRIC                           *
     F*     61875 - NEW LIST WITH ASSETS AND LIABILITIES                 *
     F********************************************************************
     F*IMLNARPD* IF   E           K DISK                                                    MD058079
      *
     F***ERLUTRL4IF**E           K        DISK                                                CER001
     FERLTRXL3  IF   E           K DISK
      **  Production Extract
     FERLU90P1  O    E             PRINTER OFLIND(*IN98)
     F*****                                         KINFDS PRTDS          132893
     F                                     INFDS(SPOOL1)                        132893
     F*
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*
     F*       98         OVERFLOW INDICATOR FOR ERLU90P1
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
     D DONT            S              8  0 DIM(16) CTDATA PERRCD(10)
      *
      ** ARRAY FOR COPYRIGHT
      *
      /EJECT
      *
     D******PRTDS       DS                                                132893
      *
      **  Printer file information data structure.
     D******                              B 152 1530PAGLEN                132893
     D******                              B 188 1890OVRLIN                132893
     D******                              B 367 3680CURLIN                132893
      *
     D                 DS
     D  EXSCHA                 1      8  0
     D  FIRST                  1      1  0
      *                                                                   132893
     D LDA             DS           256                                         132893
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
     D  PAGLEN               152    153B 0                                      132893
     D  OVRLIN               188    189B 0                                      132893
     D  CURLIN               367    368B 0                                      132893
      *
     D CPYR@#          DS
      *
      **  Data structure for compilation - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
     D IMLNAX        E DS                  EXTNAME(ERLNAJW0)                                MD058079
      *
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
     C********** *LOVAL    SETLLERLUTRL4                                                      CER001
     C**********           READ ERLUTRL4                 81                                   CER001
     C     *LOVAL        SETLL     ERLTRXL3
     C                   READ      ERLTRXL3                               81
      *
     C     *IN81         IFEQ      '1'                                          - B1
     C                   WRITE     ERLU90H1
     C                   WRITE     ERLU90E1
     C                   GOTO      FIN
     C                   END                                                    - E1
      *
     C                   Z-ADD     EXSCHA        BKSCHA            8 0
     C     FIRST         IFEQ      1
     C                   MOVE      '1'           *IN60
     C                   END
     C*
     C     FIRST         IFEQ      2
     C                   MOVE      '0'           *IN60
     C                   END
     C*
     C*------------ DETAIL PROCESSING ----------------------------
     C*
      *
      **  WRITE report header
     C     *IN81         IFEQ      '0'                                          - B1
     C                   WRITE     ERLU90H1
     C                   WRITE     ERLU90H3
     C                   END                                                    - E1
      *
      ****Do*until*end*of*file*ERLUTRL4                                                       CER001
      **  Do until end of file ERLTRXL3                                                       CER001
     C     *IN81         DOWEQ     '0'                                          - B1
      *
     C     *IN98         IFEQ      '1'
     C                   MOVE      '0'           *IN98
     C                   WRITE     ERLU90H1
     C                   WRITE     ERLU90H3
     C                   END
      *
     C     EXSCHA        IFEQ      BKSCHA                                       - B2
      *
     C     EXDRCR        IFEQ      0                                            - B3
     C                   ADD       EXLAMT        WKTOT2           16 0
     C                   ELSE                                                   - X3
     C                   SUB       EXLAMT        WKTOT2
     C                   END                                                    - E3
     C*
     C                   ELSE                                                   - X2
     C*
     C** RETRIEVE NARRATIVE
     C*****BKSCHA        CHAIN     IMLNARPD                           88                    MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :IMLNAX                                                                        MD058079
     C+ from ERLNAJW0                                                                       MD058079
     C+ where IMSCHA = :BKSCHA                                                              MD058079
     C/END-EXEC                                                                             MD058079
     C******IN88         IFEQ      '1'                                          - B3        MD058079
     C     SQLCODE       IFNE      0                                            - B3        MD058079
     C                   MOVE      *BLANKS       BKNARR
     C                   ELSE                                                   - X3
     C**********         MOVEL     IMLNAR        BKNARR                                     MD058079
     C                   MOVEL     IMLNAX        BKNARR                                     MD058079
     C                   END                                                    - E3
     C*
     C** SETUP AMOUNT
     C                   MOVE      WKTOT2        P1TOT2
     C*
     C** SETUP DEBIT/CREDIT INDICATOR
     C     WKTOT2        IFGE      0                                            - B3
     C                   MOVE      'D'           P2DRCR
     C                   ELSE                                                   - X3
     C                   MOVE      'C'           P2DRCR
     C                   END                                                    - E3
     C*
     C** WRITE TOTAL FOR RUBRIQUE AND IF NOT DONT                        65292
     C     BKSCHA        LOOKUP    DONT                                   26                  65292
     C     *IN26         IFEQ      '0'                                          - B3          65292
     C                   WRITE     ERLU90D2
     C*
     C** ADD ONLY IF NOT RUBRIQUE 'DONT'
     C***********BKSCHA    LOKUPDONT                     26              65292
     C************IN26     IFEQ '0'                        - B3          65292
     C                   ADD       WKTOT2        TOT
     C                   END                                                    - E3
     C*
     C     EXDRCR        IFEQ      0                                            - B3
     C                   Z-ADD     EXLAMT        WKTOT2
     C                   ELSE                                                   - X3
     C                   Z-SUB     EXLAMT        WKTOT2
     C                   END                                                    - E3
     C*
     C** CHECK IF LAST ASSET'S RUBRIQUE
     C     FIRST         IFEQ      2                                            - B3
     C     *IN50         ANDEQ     '0'
     C                   MOVE      '1'           *IN61
     C                   MOVE      TOT           BKTOT
     C     TOT           IFGE      0                                            - B4
     C                   MOVE      'D'           P3DRCR
     C                   ELSE                                                   - X4
     C                   MOVE      'C'           P3DRCR
     C                   END                                                    - E4
      *
     C     *IN98         IFEQ      '1'                                          - B4
     C                   MOVE      '0'           *IN98
     C                   WRITE     ERLU90H1
     C                   WRITE     ERLU90H3
     C                   END                                                    - E4
     C                   Z-ADD     TOT           TOTASS           16 0
      *
     C                   WRITE     ERLU90D3
     C                   MOVE      '1'           *IN50
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN61
     C*
     C                   WRITE     ERLU90H1
     C                   WRITE     ERLU90H3
     C*
     C                   Z-ADD     0             TOT
     C                   END                                                    - E3
     C*
     C                   END                                                    - E2
      *
     C                   Z-ADD     EXSCHA        BKSCHA
      *
      **  Read next record
     C**********           READ ERLUTRL4                 81                                   CER001
     C                   READ      ERLTRXL3                               81
      *
     C                   END                                                    - E1
      *
      ** LAST RUBRIQUE PRINTING
     C*
     C                   MOVE      WKTOT2        P1TOT2
     C*
     C** SETUP DEBIT/CREDIT INDICATOR
     C     WKTOT2        IFGE      0                                            - B1
     C                   MOVE      'D'           P2DRCR
     C                   ELSE                                                   - X1
     C                   MOVE      'C'           P2DRCR
     C                   END                                                    - E1
     C*
     C** WRITE TOTAL FOR RUBRIQUE
     C     BKSCHA        LOOKUP    DONT                                   26                65292
     C     *IN26         IFEQ      '0'                                          - B1        65292
     C                   WRITE     ERLU90D2
     C*
     C** ADD ONLY IF NOT RUBRIQUE 'DONT'
     C***********BKSCHA    LOKUPDONT                     26            65292
     C************IN26     IFEQ '0'                        - B1        65292
     C                   ADD       WKTOT2        TOT
     C                   END                                                    - E1
      *
      ** TOTAL FOR LIABILITIES
     C                   MOVE      TOT           BKTOT
     C     TOT           IFGE      0                                            - B1
     C                   MOVE      'D'           P3DRCR
     C                   ELSE                                                   - X1
     C                   MOVE      'C'           P3DRCR
     C                   END                                                    - E1
      *
     C     *IN98         IFEQ      '1'                                          - B1
     C                   MOVE      '0'           *IN98
     C                   WRITE     ERLU90H1
     C                   WRITE     ERLU90H3
     C                   END                                                    - E1
     C                   Z-ADD     TOT           TOTLIA           16 0
      *
     C                   WRITE     ERLU90D3
      *
      ** CALCULATE DIFFERENCE BETWEEN ASSETS AND LIABILITIES
     C     TOTLIA        IFLT      0                                            - B1
     C                   Z-SUB     TOTLIA        TOTLIA
     C                   END                                                    - E1
     C     TOTASS        SUB       TOTLIA        DIFFN            16 0
     C                   MOVE      DIFFN         DIFFA
      *
     C     DIFFN         IFLT      0                                            - B1
     C                   MOVE      'C'           DRCR4
     C                   ELSE                                                   - X1
     C                   MOVE      'D'           DRCR4
     C                   END                                                    - E1
      *
     C     *IN98         IFEQ      '1'                                          - B1
     C                   MOVE      '0'           *IN98
     C                   WRITE     ERLU90H1
     C                   WRITE     ERLU90H3
     C                   END                                                    - E1
      *
     C                   WRITE     ERLU90D4
      *
     C     FIN           TAG
      *
      ** WRITE END OF REPORT
     C                   WRITE     ERLU90E2
      *
     C                   MOVEL     '1'           *INLR
      *
     C                   RETURN
      *
     C*================================================================
     C*  P R O G R A M     E N D
     C*================================================================
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
     C     *DTAARA       DEFINE                  LDA                                           13289
     C                   MOVEL     'ERLU90P'     DBPGM                                         13289
      *                                                                   132893
      * Record Printer file ERLU90P1 on RCF                               132893
     C                   Z-ADD     SFNUM1        ZSNUM                                         13289
     C                   MOVEL     SFIL1         SFILE                                         13289
      *                                                                   132893
     C                   EXSR      SRZSFL                                                      13289
      *                                                                   132893
      *
      **  Initialize Field
     C                   Z-ADD     0             WKTOT2           16 0
     C                   Z-ADD     0             TOT              16 0
      *
      **  Initialize indicators
     C                   MOVEL     '0'           *IN
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
     C** *PSSR  S/R
     C********************************************************************
     C     *PSSR         BEGSR
     C*
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C                   RETURN
     C**
     C                   ENDSR
     C********************************************************************
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
**CTDATA DONT
10131000101320001021100010212000102210001022200010334000111110001141000020134000
201341002022300020224000207110002072100020910000
**CTDATA CPY@
(c) Finastra International Limited 2005
