     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000011 - Retail and Dealing WHT Extract purge              *
      *                                                               *
      *  Function:  This program will remove seelcted records from    *
      *             REIWHTTD and DLIWHTTD during EOY CoB.             *
      *                                                               *
      *  Called By: REC000011                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CRE105   *Create   Date 30Mar15               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE105 - Withholding Tax Extract Report                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Error Indicator                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  *INZSR         - Initialise                                  *
      *  *PSSR          - Error handling subroutine                   *
      *  SrPurge        - Purge data from DLIWHTTD and REIWHTTD       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D SDSBNK        E DS                  EXTNAME(SDSBNKTD)
      ** External DS for Bank Details (Secondary COB)


     D/COPY ZSRSRC,ZDATE9Z2LE

     D/COPY ZACPYSRC,PSDS
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.

      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D/COPY ZSRSRC,ZDATE9Z1LE

      ** Parameter for ZDATE9
     D WDateVar        DS
     D  WDateOut               1      8  0
     D   WYR                   1      4
     D   WMM                   5      6
     D   WDD                   7      8

     D LDA             DS           256
      ** Local data area for database error details

     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for AOSVALR0
     D PRTCD           S              7A
     D PSVK01          S             20A
     D PSVL01          S            200A
     D PSVK02          S             20A
     D PSVL02          S            200A
     D PSVK03          S             20A
     D PSVL03          S            200A
     D PSVK04          S             20A
     D PSVL04          S            200A
     D PSVK05          S             20A
     D PSVL05          S            200A
     D PSVK06          S             20A
     D PSVL06          S            200A
     D PSVK07          S             20A
     D PSVL07          S            200A
     D PSVK08          S             20A
     D PSVL08          S            200A
     D PSVK09          S             20A
     D PSVL09          S            200A
     D PSVK10          S             20A
     D PSVL10          S            200A

     D PPurgDat        S              5S 0 INZ(0)
     D PYear           S              4S 0 INZ(0)
     D PRetPer         S              2S 0 INZ(0)
     D PDateIn         S              8S 0 INZ(0)
     D PDateOut        S              5  0 INZ(0)
     D WMonth          S              2S 0 INZ(12)
     D WDay            S              2S 0 INZ(31)
     D WRtrn           S              1A   INZ(*Blanks)
     D WRun            S              1A   INZ(*Blanks)

      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************

     C/exec SQL
     C+ set option commit = *CHG
     C/end-exec

     C                   Exsr      SrPurge

      ** Terminate program

     C                   Eval      *INLR = *ON
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPurge - Purge data from REIWHTTD and DLIWHTTD               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrPurge       BEGSR

     C/Exec SQL
     C+                  Delete from REIWHTTD
     C+                          where REPSTD <= :PPurgDat
     C/End-Exec

     C/Exec SQL
     C+                  Delete from DLIWHTTD
     C+                          where DLPSTD <= :PPurgDat
     C/End-Exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Read in data area

     C     *DTAARA       Define                  LDA

     C     *LOCK         In        LDA
     C                   Eval      DBPGM  = 'RE000011'
     C                   Eval      DBFILE = *BLANKS
     C                   Eval      DBKEY  = *BLANKS
     C                   Eval      DBTXT  = *BLANKS
     C                   Eval      DBASE  = 0
     C                   Out       LDA

      ** Access Bank details

     C/exec SQL
     C+ select *
     C+ into :SDSBNK
     C+ from SDSBNKTD
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C     *LOCK         In        LDA
     C                   eval      DBKey = '*FIRST'
     C                   eval      DBFile = 'SDSBNKTD'
     C                   eval      DBase = 1
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif

      ** Retrieve System Value

     C                   Eval      PSVK01 = 'WhtExtrRetention'

     C                   Call      'AOSVALR0'
     C                   Parm      *Blanks       PRTCd
     C                   Parm                    PSVK01
     C                   Parm                    PSVL01
     C                   Parm                    PSVK02
     C                   Parm                    PSVL02
     C                   Parm                    PSVK03
     C                   Parm                    PSVL03
     C                   Parm                    PSVK04
     C                   Parm                    PSVL04
     C                   Parm                    PSVK05
     C                   Parm                    PSVL05
     C                   Parm                    PSVK06
     C                   Parm                    PSVL06
     C                   Parm                    PSVK07
     C                   Parm                    PSVL07
     C                   Parm                    PSVK08
     C                   Parm                    PSVL08
     C                   Parm                    PSVK09
     C                   Parm                    PSVL09
     C                   Parm                    PSVK10
     C                   Parm                    PSVL10

     C                   If        PRtcd <> *Blanks
     C                   Eval      DbKey = PSVK01
     C     *LOCK         In        LDA
     C                   Eval      DBase = 2
     C                   Eval      DBFile = 'SDSVALPD'
     C                   Eval      DBPgm  = 'RE000011'
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Else
     C                   movel     PSVL01        PRetPer
     C                   Endif

      ** Convert run date to YYYYMMDD

     C                   z-add     Bjrdnb        @@DAYN            5 0
     C                   Exsr      ZDATE9
     C                   Eval      WDateOut = @@VDT

     C                   move      WYR           PYear
     C     PYear         Sub       PRetPer       PYear

     C                   move      PYear         WYR
     C                   move      WMonth        WMM
     C                   move      WDay          WDD
     C                   Eval      PDateIn = WDateOut

     C                   Call      'ZDATE10'
     C                   Parm                    PDateIn
     C                   Parm                    PDateOut

     C                   Eval      PPurgDat = PDateOut

     C                   ENDSR

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

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

     C/COPY ZSRSRC,ZDATE9Z3LE

      ****************************************************************
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
