     H
     F********************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('MIDAS ER Production Extract Report')
     F********************************************************************
     F*                                                                  *
     F*          MIDAS ABS - EUROPEAN REPORTING                          *
     F*                                                                  *
     F*    ERLU85 - Production Extract - Audit Report                    *
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
      *                 IL0040             Date 14Jan02               *
     F*                   182312            Date 14Feb01                 *
     F*                   187689            Date 20Dec00                 *
     F*                   157278            DATE 21FEB00                 *
     F*                   CAD025 PT         DATE 08JAN98                 *
     F*                   ULX004            Date 22apr98                 *
     F*                   132893            DATE 15APR98                 *
     F*                   88390  PT         DATE 08JUN95                 *
     F*                   61870             DATE 20MAI94                 *
     F*                   64630  DDJ        DATE 22FEB94                 *
     F*                   61875  TLi        DATE 19OCT93                 *
     F*                   61870  TLi        DATE 15OCT93                 *
     F*                   61874  TLi        DATE 15OCT93                 *
     F*                   ERL356 TLi        DATE 01JUL93                 *
     F*                   ERL343 TLi        DATE 27MAY93                 *
     F*                   ERL349 TLI        DATE 03JUN93                 *
     F*                   ER0336 TLi        DATE 16APR93                 *
     F*                   ERL334 TLi        DATE 01MAR93                 *
     F*                   ERL323 AF         DATE 03MAR93                 *
     F*                   ERL303 TLI        DATE 21JAN93                 *
     F*                   ERL202 ADs        DATE 14JAN93                 *
     F*                   ERL005 ADs        DATE 22DEC92                 *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *    225555 - Add discount/premium amount, amount to amortize      *
      *             and 'Prix d'Acquisition'. Recompile over changed     *
      *             ERLUTRPD.                                            *
      *  CSD027A - Conversion Of Customer Number to Alpha (Recompile) *
      *  CER001 - LUX Upgrade to MidasPlus                            *
     F*    ULX046 - Circulars 2002/170-174-175 Integration               *
     F*             Recompiled due to changes in file layout             *
     F*    IL0040 - ULX043 IBLC 2002. The monthly IBLC is no more        *
     F*             required                                             *
     F*    182312 - Credit interest to accrue amounts must be set        *
     F*             positive to get correct totals                       *
     F*    187689 - "GRD" currency in EMU                                *
     F*             Just recompile over new PF/ERLUTRPD description      *
     F*    157278 - FOR ACCOUNT (EXLOTD=GLA') PRINT CORRECT AMOUNT       *
     F*    CAD025 - To print 'CUS.POSITION4 for customer positions       *
     F*             consolidated records.                                *
     F*    ULX004 - IML Circular 97/138                                  *
     F*             Recompile only                                       *
     F*    132893 - SPF/RCF for IBLC/BNB on DBA2.3                       *
     F*    88390  - Report margin amount for codes 302410 & 302420       *
     F*    61870  - RECOMPILE FOR CHANGE OF LENGTH OF IML RUBRIQUE NAME  *
     F*    64630  - FOR SE Security Report Name never initialised        *
     F*    61875  - NEW LIST WITH ASSETS AND LIABILITIES                 *
     F*    61870  - PRINT THE IML RUBRIQUE NAME                          *
     F*    61874  - AMOUNTS SHOULD BE EDITED                             *
     F*    ERL356 - ADD ECONOMIQUE SECTOR CODE AND SUPPRESS CENTURY      *
     F*    ERL343 - IBLC AUDIT LIST                                      *
     F*    ERL349 - RECOMPILED Due to change between EXCUCL and EXCNCZ   *
     F*    ER0336 - IML 2.3 DEVELOPMENT - Add IML rubrique on each page  *
     F*    ERL334 - For Securities print Security Report Name            *
     F*    ERL323 - Add total by currency                                *
     F*    ERL303 - New layout - Only Guaranties                         *
     F*    ERL202 - Recompilation due to LF/ERLUTRL0 changement          *
     F*    ERL005 - Audit List corrections.                              *
     F*                                                                  *
     F********************************************************************
     F*IMLNARPD* IF   E           K DISK                                         61870      MD058079
      ** Narrative for IML code                                           61870
     F*                                                                   61870
     F***ERLUTRL0IF**E           K        DISK                                                CER001
     FERLTRXL0  IF   E           K DISK
      **  Production Extract
     FERLU85P1  O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(SPOOL1)                        132893
     FERLU86P1  O    E             PRINTER OFLIND(*IN98)                        ERL005
     F******                                        KINFDS PRTDS
     F                                     INFDS(SPOOL2)                        132893
     FERLU85AU  O    E             PRINTER INFDS(SPOOLU)                        132893
     F*                                                                   132893
     F*
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*
     F*       97         OVERFLOW INDICATOR FOR ERLU85P1
     F*       98         OVERFLOW INDICATOR FOR ERLU86P1                  ERL005
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
     D****************************************1   8 P1STRD                ERL356
     D  P1STRD                 1      6                                         ERL356
     D  STDD                   1      2
     D  STMM                   3      4
     D****************************************5   8 STYY                  ERL356
     D  STYY                   5      6                                         ERL356
     D                 DS
      *
      **  Data structure for End Date new format to print
     D****************************************1   8 P1ENDD                ERL356
     D  P1ENDD                 1      6                                         ERL356
     D  EDDD                   1      2
     D  EDMM                   3      4
     D****************************************5   8 EDYY                  ERL356
     D  EDYY                   5      6                                         ERL356
     D                 DS
      *
      **  Data structure for Revision Date new format to print
     D****************************************1   8 P1REVD                ERL356
     D  P1REVD                 1      6                                         ERL356
     D  REDD                   1      2
     D  REMM                   3      4
     D****************************************5   8 REYY                  ERL356
     D  REYY                   5      6                                         ERL356
      *                                                                   132893
     D LDA             DS           256                                         132893
     D*  DATA AREA DATA STRUCTURE FOR HANDLING DB ERRORS                  132893
     D*                                                                   132893
     D  DBFILE               134    141                                         132893
     D  DBKEY                142    170                                         132893
     D  DBPGM                171    180                                         132893
     D  DBASE                181    183                                         132893
     D SPOOLU          DS                                                       132893
      *                                                                   132893
      **  File Information Data Structure - AU report                     132893
     D  SFILEU                83     92                                         132893
     D  SFNUMU               123    124B 0                                      132893
     D SPOOL1          DS                                                       132893
      *                                                                   132893
      **  File Information Data Structure - P1 report                     132893
     D  SFIL1                 83     92                                         132893
     D  SFNUM1               123    124B 0                                      132893
     D  PAGLEN               152    153B 0                                      132893
     D  OVRLIN               188    189B 0                                      132893
     D  CURLIN               367    368B 0                                      132893
     D SPOOL2          DS                                                       132893
      *                                                                   132893
      **  File Information Data Structure - P1 report                     132893
     D  SFIL2                 83     92                                         132893
     D  SFNUM2               123    124B 0                                      132893
     D  PAGLE2               152    153B 0                                      132893
     D  OVRLI2               188    189B 0                                      132893
     D  CURLI2               367    368B 0                                      132893
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
     C********** *LOVAL    SETLLERLUTRL0                                                      CER001
     C**********           READ ERLUTRL0                 81                                   CER001
     C     *LOVAL        SETLL     ERLTRXL0
     C                   READ      ERLTRXL0                               81
      *
     C     *IN81         IFEQ      '1'
     C******               WRITEERLU85H1                                  132893
     C******               WRITEERLU85E1                                  132893
     C                   WRITE     HEADAU                                                      13289
     C                   WRITE     NODTLS                                                      13289
     C                   WRITE     ERLU86H1                                                    ERL00
     C                   WRITE     ERLU86E1                                                    ERL00
     C                   END
      *
     C                   Z-ADD     EXSCHA        BKSCHA            8 0
     C                   Z-ADD     EXRECT        BKRECT            3 0                         ERL00
     C                   MOVE      EXCCYL        BKCCYL            3                           ERL32
     C*
     C*------------ DETAIL PROCESSING ----------------------------
     C*
      *
      **  Write report header
     C     *IN81         IFEQ      '0'
     C*
     C** RETRIEVE IML CODE NARRATIVE                                      61870
     C*****EXSCHA        CHAIN     IMLNARPD                           88              61870 MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :IMLNAX                                                                        MD058079
     C+ from ERLNAJW0                                                                       MD058079
     C+ where IMSCHA = :EXSCHA                                                              MD058079
     C/END-EXEC                                                                             MD058079
     C******IN88         IFEQ      '1'                                          - B3        MD058079
     C     SQLCODE       IFNE      0                                            - B3        MD058079
     C**********         MOVE      *BLANKS       IMLNAR                               61870 MD058079
     C                   MOVE      *BLANKS       IMLNAX                                     MD058079
     C                   END                                                                   61870
     C*                                                                   61870
     C                   WRITE     ERLU85H1
     C                   WRITE     ERLU85H2
     C                   WRITE     ERLU85H3
     C                   WRITE     ERLU86H1                                                    ERL00
     C                   WRITE     ERLU86H2                                                    ERL00
     C                   WRITE     ERLU86H3                                                    ERL00
     C                   END
      *
      ****Do*until*end*of*file*ERLUTRL0                                                       CER001
      **Do until end of file ERLTRXL0                                                         CER001
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
     C                   WRITE     ERLU85H1
     C                   WRITE     ERLU86H1                                                    ERL00
     C     EXSCHA        IFNE      BKSCHA
     C     EXRECT        ORNE      BKRECT                                                      ERL00
      *                                                                   ERL323
     C                   MOVE      WKTOT1        P1TOT1                                        ERL32
      *                                                                   ERL323
     C     WKTOT1        IFGE      0                                                           ERL32
     C                   MOVE      'D'           P3DRCR                                        ERL32
     C                   ELSE                                                                  ERL32
     C                   MOVE      'C'           P3DRCR                                        ERL32
     C                   END                                                                   ERL32
     C                   WRITE     ERLU85D3                                                    ERL32
     C                   WRITE     ERLU86D3                                                    ERL32
     C                   Z-ADD     0             P1TOT1                                        ERL32
     C                   Z-ADD     0             WKTOT1                                        ERL32
      *                                                                   ERL323
     C                   MOVE      WKTOT2        P1TOT2
      *
     C     WKTOT2        IFGE      0
     C                   MOVE      'D'           P2DRCR
     C                   ELSE
     C                   MOVE      'C'           P2DRCR
     C                   END
      *
     C                   WRITE     ERLU85D2
     C*********************WRITEERLU85H2                                  ER0336
     C                   WRITE     ERLU86D2                                                    ERL00
     C*********************WRITEERLU86H2                           ERL005 ER0336
     C                   Z-ADD     0             P1TOT2
     C                   Z-ADD     0             WKTOT2
     C                   END
      *
     C                   WRITE     ERLU85H2                                                    ER033
     C                   WRITE     ERLU86H2                                                    ER033
     C                   WRITE     ERLU85H3
     C                   WRITE     ERLU86H3                                                    ERL00
     C                   MOVEL     '0'           *IN50
     C                   END
      *
      **  Print ligne data
     C                   EXSR      PRTLGN
      *
      **  Save Code Schema A to check if rupture
     C                   Z-ADD     EXSCHA        BKSCHA            8 0
      **  Save Record Type to check if rupture                            ERL005
     C                   Z-ADD     EXRECT        BKRECT            3 0                         ERL00
      **  Save Currency to check if rupture                               ERL323
     C                   MOVE      EXCCYL        BKCCYL            3                           ERL32
      *
      **  Read next record
     C**********           READ ERLUTRL0                 81                                   CER001
     C                   READ      ERLTRXL0                               81
      *
     C     EXSCHA        IFNE      BKSCHA                                                      61870
     C*****EXSCHA        CHAIN     IMLNARPD                           88              61870 MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :IMLNAX                                                                        MD058079
     C+ from ERLNAJW0                                                                       MD058079
     C+ where IMSCHA = :EXSCHA                                                              MD058079
     C/END-EXEC                                                                             MD058079
     C******IN88         IFEQ      '1'                                          - B3        MD058079
     C     SQLCODE       IFNE      0                                            - B3        MD058079
     C**********         MOVE      *BLANKS       IMLNAR                               61870 MD058079
     C                   MOVE      *BLANKS       IMLNAX                                     MD058079
     C                   END                                                                   61870
     C                   END                                                                   61870
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
      *                                                                   ERL323
     C                   MOVE      WKTOT1        P1TOT1                                        ERL32
      *                                                                   ERL323
     C     WKTOT1        IFGE      0                                                           ERL32
     C                   MOVE      'D'           P3DRCR                                        ERL32
     C                   ELSE                                                                  ERL32
     C                   MOVE      'C'           P3DRCR                                        ERL32
     C                   END                                                                   ERL32
      *                                                                   ERL323
     C                   WRITE     ERLU85D3                                                    ERL32
      *
     C                   WRITE     ERLU85D2
     C                   WRITE     ERLU85E2
     C                   WRITE     ERLU86D2                                                    ERL00
     C                   WRITE     ERLU86E2                                                    ERL00
     C                   END
      *
      ** CALL NEW LAYOUT PROGRAM ONLY FOR GUARANTIES                      ERL303
     C                   CALL      'ERLU87'                                                    ERL30
     C                   PARM                    BJMRDT                                        ERL30
     C                   PARM                    BJURPT                                        ERL30
     C                   PARM                    @RSEQ             5                           13289
     C                   PARM                    @RLEV             1                           13289
      *
      ** CALL NEW LIST PROGRAM WITH ASSETS AND LIABILITIES                61875
     C                   CALL      'ERLU90'                                                    61875
     C                   PARM                    BJMRDT                                        61875
     C                   PARM                    BJURPT                                        61875
     C                   PARM                    @RSEQ             5                           13289
     C                   PARM                    @RLEV             1                           13289
      *
      *                                                            ERL343  IL0040
      ** CALL IBLC EXTRACT PROGRAM                                 ERL343  IL0040
     C*                    CALL 'ERLUIB89'                         ERL343  IL0040
      *                                                            ERL343  IL0040
      ** CALL IBLC AUDIT LIST                                      ERL343  IL0040
     C*                    CALL 'ERLU89'                           ERL343  IL0040
     C*                    PARM           BJMRDT                   ERL343  IL0040
     C*                    PARM           BJURPT                   ERL343  IL0040
     C*                    PARM           @RSEQ   5                132893  IL0040
     C*                    PARM           @RLEV   1                132893  IL0040
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
      *                                                                   ERL323
     C     EXCCYL        IFNE      BKCCYL                                                      ERL32
     C     EXCCYL        OREQ      BKCCYL                                                      ERL32
     C     EXSCHA        ANDNE     BKSCHA                                                      ERL32
     C                   MOVE      WKTOT1        P1TOT1                                        ERL32
      *                                                                   ERL323
     C     WKTOT1        IFGE      0                                                           ERL32
     C                   MOVE      'D'           P3DRCR                                        ERL32
     C                   ELSE                                                                  ERL32
     C                   MOVE      'C'           P3DRCR                                        ERL32
     C                   END                                                                   ERL32
      *                                                                   ERL323
     C                   WRITE     ERLU85D3                                                    ERL32
     C                   WRITE     ERLU86D3                                                    ERL32
     C                   Z-ADD     0             P1TOT1                                        ERL32
     C                   Z-ADD     0             WKTOT1                                        ERL32
     C                   END                                                                   ERL32
      *                                                                   ERL323
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
     C                   WRITE     ERLU85H1
     C                   WRITE     ERLU86H1                                                    ERL00
     C     EXSCHA        IFNE      BKSCHA
     C     EXRECT        ORNE      BKRECT                                                      ERL00
      *                                                                   ERL323
     C                   MOVE      WKTOT1        P1TOT1                                        ERL32
      *                                                                   ERL323
     C     WKTOT1        IFGE      0                                                           ERL32
     C                   MOVE      'D'           P3DRCR                                        ERL32
     C                   ELSE                                                                  ERL32
     C                   MOVE      'C'           P3DRCR                                        ERL32
     C                   END                                                                   ERL32
     C                   WRITE     ERLU85D3                                                    ERL32
     C                   WRITE     ERLU86D3                                                    ERL32
     C                   Z-ADD     0             P1TOT1                                        ERL32
     C                   Z-ADD     0             WKTOT1                                        ERL32
      *                                                                   ERL323
     C                   MOVE      WKTOT2        P1TOT2
      *
     C     WKTOT2        IFGE      0
     C                   MOVE      'D'           P2DRCR
     C                   ELSE
     C                   MOVE      'C'           P2DRCR
     C                   END
      *
     C                   WRITE     ERLU85D2
     C*********************WRITEERLU85H2                                  ER0336
     C                   WRITE     ERLU86D2                                                    ERL00
     C*********************WRITEERLU86H2                           ERL005 ER0336
     C                   Z-ADD     0             P1TOT2
     C                   Z-ADD     0             WKTOT2
     C                   END
     C                   WRITE     ERLU85H2                                                    ER033
     C                   WRITE     ERLU86H2                                                    ER033
     C                   WRITE     ERLU85H3
     C                   WRITE     ERLU86H3                                                    ERL00
     C                   MOVEL     '0'           *IN50
     C                   END
      *
      **  Print report detail line
     C     EXSCHA        IFNE      BKSCHA
     C     EXRECT        ORNE      BKRECT                                                      ERL00
     C                   MOVE      WKTOT2        P1TOT2
      *
     C     WKTOT2        IFGE      0
     C                   MOVE      'D'           P2DRCR
     C                   ELSE
     C                   MOVE      'C'           P2DRCR
     C                   END
      *
     C                   WRITE     ERLU85D2
     C                   WRITE     ERLU85H1
     C*********************WRITEERLU85H2                                  ER0336
     C                   WRITE     ERLU86D2                                                    ERL00
     C                   WRITE     ERLU86H1                                                    ERL00
     C*********************WRITEERLU86H2                           ERL005 ER0336
     C                   Z-ADD     0             P1TOT2
     C                   Z-ADD     0             WKTOT2
     C                   WRITE     ERLU85H2                                                    ER033
     C                   WRITE     ERLU86H2                                                    ER033
     C                   WRITE     ERLU85H3
     C                   WRITE     ERLU86H3                                                    ERL00
     C                   END
      *
      **  Reset date format in DDMMYYY for start date
     C     EXSTRD        IFEQ      0
     C                   MOVE      *BLANK        P1STRD
     C                   ELSE
     C                   MOVE      DD1           STDD
     C                   MOVE      MM1           STMM
     C                   MOVE      YY1           STYY
     C                   END
      *
      **  Reset date format in DDMMYYY for end date
     C     EXENDD        IFEQ      0
     C                   MOVE      *BLANK        P1ENDD
     C                   ELSE
     C                   MOVE      DD2           EDDD
     C                   MOVE      MM2           EDMM
     C                   MOVE      YY2           EDYY
     C                   END
      *
      **  Reset date format in DDMMYYY for revision date
     C     EXREVD        IFEQ      0
     C                   MOVE      *BLANK        P1REVD
     C                   ELSE
     C                   MOVE      DD3           REDD
     C                   MOVE      MM3           REMM
     C                   MOVE      YY3           REYY
     C                   END
      *                                                                   182312
     C     EXSCHA        IFEQ      99000000                                                    18231
     C     EXAMNT        ANDLT     0                                                           18231
     C                   Z-SUB     EXAMNT        EXAMNT                                        18231
     C                   END                                                                   18231
      *
     C     EXSCHA        IFEQ      30240000                                                    ER033
     C     EXSCHA        OREQ      30241000                                                    88390
     C     EXSCHA        OREQ      30242000                                                    88390
     C     EXLOTD        IFNE      'GLA'                                        B1             15727
     C                   MOVE      EXMARA        P1AMNT                                        ER033
     C                   MOVE      EXLMAR        P1LAMT                                        ER033
     C                   ELSE                                                   X1             15727
     C                   MOVE      EXAMNT        P1AMNT                                        15727
     C                   MOVE      EXLAMT        P1LAMT                                        15727
     C                   ENDIF                                                  E1             15727
     C                   ELSE                                                                  ER033
     C                   MOVE      EXAMNT        P1AMNT
     C                   MOVE      EXLAMT        P1LAMT
     C                   END                                                                   ER033
      *
     C     EXDRCR        IFEQ      0
      *
     C     EXSCHA        IFEQ      30240000                                                    ER033
     C     EXSCHA        OREQ      30241000                                                    88390
     C     EXSCHA        OREQ      30242000                                                    88390
     C     EXLOTD        IFNE      'GLA'                                                       15727
     C                   ADD       EXLMAR        WKTOT2                                        ER033
     C                   ADD       EXMARA        WKTOT1                                        ER033
     C                   ELSE                                                                  15727
     C                   ADD       EXLAMT        WKTOT2                                        15727
     C                   ADD       EXAMNT        WKTOT1                                        15727
     C                   ENDIF                                                                 15727
     C                   ELSE                                                                  ER033
     C                   ADD       EXLAMT        WKTOT2           16 0
     C                   ADD       EXAMNT        WKTOT1           16 0                         ERL32
     C                   END                                                                   ER033
      *
     C                   ELSE
      *
     C     EXSCHA        IFEQ      30240000                                                    ER033
     C     EXSCHA        OREQ      30241000                                                    88390
     C     EXSCHA        OREQ      30242000                                                    88390
     C     EXLOTD        IFNE      'GLA'                                                       15727
     C                   SUB       EXLMAR        WKTOT2                                        ER033
     C                   SUB       EXMARA        WKTOT1                                        ER033
     C                   ELSE                                                                  15727
     C                   SUB       EXLAMT        WKTOT2                                        15727
     C                   SUB       EXAMNT        WKTOT1                                        15727
     C                   ENDIF                                                                 15727
     C                   ELSE                                                                  ER033
     C                   SUB       EXLAMT        WKTOT2
     C                   SUB       EXAMNT        WKTOT1                                        ERL32
     C                   END                                                                   ER033
      *
     C                   END
      *
     C     EXDRCR        IFEQ      0
     C                   MOVE      'D'           P1DRCR
     C                   ELSE
     C                   MOVE      'C'           P1DRCR
     C                   END
      *                                                                   ERL005
     C                   MOVE      EXORIG        EXTREF                                        ERL00
      *
      ** FOR SECURITIES PRINT SECURITY REPORT NAME                        ERL334
     C     EXLOTD        IFEQ      'SEC'                                                       ERL33
     C     EXLOTD        OREQ      'SEF'                                                       ERL33
     C                   MOVE      '1'           *IN60                                         ERL33
     C*                    MOVELEXSECY    WWSECD                          ER0336
     C                   MOVEL     EXSECY        WWSECD                                        64630
     C                   ELSE                                                                  ERL33
     C                   MOVE      '0'           *IN60                                         ERL33
     C                   END                                                                   ERL33
      *
     C                   MOVEL     EXCRNM        WWCRNM                                        61874
      *
     C     EXLOTD        IFEQ      'CPO'                                                       CAD02
     C     ULX046        ANDNE     'Y'                                                         ULX04
     C                   MOVE      *BLANKS       EXCUST                                        CAD02
     C                   MOVEL     'CUS.'        WWCRNM                                        CAD02
     C                   MOVE      'POSITION'    WWCRNM                                        CAD02
     C                   END                                                                   CAD02
      *                                                                   CAD025
     C                   WRITE     ERLU85D1
     C                   WRITE     ERLU86D1                                                    ERL00
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
     C     *DTAARA       DEFINE                  LDA                                           13289
     C                   MOVEL     'ERLU85P'     DBPGM                                         13289
      *                                                                   132893
      * Record Printer file ERLU85AU on RCF                               132893
     C                   Z-ADD     SFNUMU        ZSNUM                                         13289
     C                   MOVEL     SFILEU        SFILE                                         13289
      *                                                                   132893
     C                   EXSR      SRZSFL                                                      13289
      *                                                                   132893
      * Record Printer file ERLU85P1 on RCF                               132893
     C                   Z-ADD     SFNUM1        ZSNUM                                         13289
     C                   MOVEL     SFIL1         SFILE                                         13289
      *                                                                   132893
     C                   EXSR      SRZSFL                                                      13289
      *                                                                   132893
      * Record Printer file ERLU86P1 on RCF                               132893
     C                   Z-ADD     SFNUM2        ZSNUM                                         13289
     C                   MOVEL     SFIL2         SFILE                                         13289
      *                                                                   132893
     C                   EXSR      SRZSFL                                                      13289
      *
      *                                                                   ULX046
      ***  Check if the feature ULX046 is installed.                      ULX046
      *                                                                   ULX046
     C                   MOVEL     'N'           ULX046            1                           ULX04
     C                   CALL      'AOSARDR0'                                                  ULX04
     C                   PARM      *BLANKS       @RTCD             7                           ULX04
     C                   PARM      '*VERIFY'     @OPTN             7                           ULX04
     C                   PARM      'ULX046'      @SARD             6                           ULX04
      *                                                                   ULX046
     C     @RTCD         IFEQ      *BLANKS                                                     ULX04
     C                   MOVEL     'Y'           ULX046                                        ULX04
     C                   ENDIF                                                                 ULX04
      *
      **  Initialize Field
     C                   Z-ADD     0             P1TOT1                                        ERL32
     C                   Z-ADD     0             WKTOT1                                        ERL32
     C                   Z-ADD     0             P1TOT2
     C                   Z-ADD     0             WKTOT2
      *
      **  Initialize indicators
     C                   MOVEL     '0'           *IN
      *
      *
      **  Define/Clear constante & variable
     C                   Z-ADD     1             RECTOT            5 0          Total report
      *
      **  Adjust page lengh and overflow as necessary
      **  ERLU85P1                                                        132893
      *                                                                   132893
     C     PAGLEN        SUB       2             WPAGL             4 0
      *
     C     OVRLIN        IFGE      WPAGL
     C     WPAGL         SUB       2             WOVRL             4 0
     C                   ELSE
     C                   Z-ADD     OVRLIN        WOVRL
     C                   END
      *
      **  ERLU86P1                                                        132893
      *                                                                   132893
     C     PAGLE2        SUB       2             WPAGL2            4 0                         13289
      *                                                                   132893
     C     OVRLI2        IFGE      WPAGL2                                                      13289
     C     WPAGL2        SUB       2             WOVRL2            4 0                         13289
     C                   ELSE                                                                  13289
     C                   Z-ADD     OVRLI2        WOVRL2                                        13289
     C                   END                                                                   13289
      *                                                                   132893
     C                   ENDSR
      /EJECT
      ********************************************************************
      *                                                                  *
      * GLZADD   - S/R TO ADD AMOUNT (ZZAMT) TO TOTAL (ZZTOTI,ZZTOTD)    *
      *                                                                  *
      * SUBROUTINE CALLS:                                                *
      * GLZSUM   - S/R TO CARRY OUT ADD. FOR SR GLZADD,GLZSUB,GLZCMP     *
      *                                                                  *
      * SUBROUTINE CALLED FROM:                                          *
      * PRTLGN   - S/R TO PRINT REPORT DETAIL LIGNE                      *
      *                                                                  *
      * ROUTINE USES VARIABLES:                                          *
      *                                                                  *
      ********************************************************************
      * NOTE :  IND '99' IS SET BY AN OVERFLOW ERROR                     *
      ********************************************************************
     C     GLZADD        BEGSR                                                  *** GLZADD ****
     C*
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS
     C*
     C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     C                   MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
     C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
     C*
     C                   EXSR      GLZSUM
     C     ZZAEND        ENDSR                                                  ** ZZAEND TAG *
      ********************************************************************
      /EJECT
      ********************************************************************
      *                                                                  *
      * GLZSUM   - S/R TO CARRY OUT ADD. FOR SR GLZADD,GLZSUB,GLZCMP     *
      *                                                                  *
      * SUBROUTINE CALLS:                                                *
      *                                                                  *
      * SUBROUTINE CALLED FROM:                                          *
      * GLZADD   - S/R TO ADD AMOUNT (ZZAMT) TO TOTAL (ZZTOTI,ZZTOTD)    *
      *                                                                  *
      * ROUTINE USES VARIABLES:                                          *
      *                                                                  *
      ********************************************************************
      *                                                                  *
      *          PARAMETERS PASSED -                                     *
      *                     I/P ZZAMTI ZZAMTD                            *
      *                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.      *
      *                                                                  *
      ********************************************************************
     C     GLZSUM        BEGSR                                                  *** GLZSUM ****
     C*
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
     C*
     C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
     C*
     C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
     C*
     C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
     C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93        '93' = CARRY
     C  N93ZZWK2         COMP      -999                                 93        INTO INTEGER.
     C*
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
     C*
     C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
     C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
     C   92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
     C*
     C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
     C*
     C* THE 'SIGNS' ARE DIFFERENT
     C     ZZOFPS        TAG                                                    ** ZZOFPS TAG**
     C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
     C*
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
     C*
     C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
     C*
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
     C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
     C*
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
     C*
     C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
     C*
     C* IF ZZTOT GT. ZZAMT.
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C*
     C*
     C* IF ZZAMT GT. ZZTOT.
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C*
     C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
     C**
     C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG                                                    ** ZZSEND TAG *
     C**
     C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
     C                   ENDSR                                                    ** ENDSR **
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
