     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Avail. Balance Rebuild - COB')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000502 - Midas OF Forecast Avail. Bal. Rebuild - COB        *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD046248           Date 27Oct17               *
      *                 MD024275           Date 27Jan14               *
      *                 MD024013           Date 12Dec13               *
      *                 MD024014           Date 11Dec13               *
      *                 CGL145B  *CREATE   Date 28Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD024275 - Available Balance in Forecast Total is incorrect  *
      *  MD024013 - Conversion rate not correct                       *
      *  MD024014 - Amount of deleted forecast did not add back to    *
      *             the credit line balance                           *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast (Drop 3)      *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     ** File DS
     **   Midas OF Midas OF Forecast Available Balance Table
     D FOAVT         E DS                  EXTNAME(GLFOAVTD)

     **   Midas OF Individual Forecast Table
     D FORIT         E DS                  EXTNAME(GLFORITD)

      ** Data structure for AOSVALR0 string
     D @SVAL1          DS           200
     D  SVAL1                  1    200
     D  SVAL1_1                1      1

      ** Account Details DS
     D PRFACN          DS            24
     D  PRBRCA                 1      3A
     D  PRCNUM                 4      9A
     D  PRCCYD                10     12A
     D  PRACOD                13     22  0
     D  PRACSQ                23     24  0

     D  ACCCYD         S              3A                                                    MD024275
                                                                                            MD024275
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PCcy            S              3

      ** Processing mode
     D ProcMode        S            190

      ** Forecast Include Unmatched in Projected Balance
     D WFIUPB          S              1A

      ** Parameter variables for AOSVALR0 string
     DRTNCDE           S              7
     DSVALK2           S             20
     DSVAL2            S            200
     DSVALK3           S             20
     DSVAL3            S            200
     DSVALK4           S             20
     DSVAL4            S            200
     DSVALK5           S             20
     DSVAL5            S            200
     DSVALK6           S             20
     DSVAL6            S            200
     DSVALK7           S             20
     DSVAL7            S            200
     DSVALK8           S             20
     DSVAL8            S            200
     DSVALK9           S             20
     DSVAL9            S            200
     DSVALK0           S             20
     DSVAL10           S            200

      ** Paramaters for ZXRATE                                                              MD024013
     D  ZRATE1         S             13P 8                                                  MD024013
     D  ZMDI1          S              1A                                                    MD024013
     D  ZRATE2         S             13P 8                                                  MD024013
     D  ZMDI2          S              1A                                                    MD024013
     D  ZRATEX         S             13P 8                                                  MD024013
     D  ZMDIX          S              1A                                                    MD024013
                                                                                            MD024013
      ** Parameters for ZCONVZ1
     D ZEXCH           S             13  8                                                  MD024013
     D ZMD             S              1                                                     MD024013
     D PAmnt           S             15  0
     D PFrXRate        S             13  8
     D PFrMDIn         S              1
     D PFrCCY          S              3
     D PToCCY          S              3
     D PFrDecPlace     S              1  0
     D PToDecPlace     S              1  0
     D POutAmt         S             15  0

      ** Other fields used
     D WRun            S              1A   Inz
     D WConvFAmt       S             15  0
     D WConvOFAmt      S             15  0
     D WAFAVAIL        S             15  0
     D WAFDATE         S              5  0
     D PRTOT           S             15  0
     D PRDATE          S              5  0
     D WFCCUS          S              6A
     D WFACT           S              3  0
     D WFCNO           S              2  0
     D WFrXrate        S                   LIKE(A6SPRT)
     D WFrMDIn         S                   LIKE(A6MDIN)
     D WFrDecPlace     S                   LIKE(A6NBDP)
     D WToXrate        S                   LIKE(A6SPRT)                                     MD024013
     D WToMDIn         S                   LIKE(A6MDIN)                                     MD024013
     D WToDecPlace     S                   LIKE(A6NBDP)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Main Subroutine

     C                   EXSR      SRMain

      ** End Program

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *                                                               *
      *  SRMain - Main Subroutine                                     *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR

     C                   EVAL      PRTOT = *Zeros

      ** Set file pointer to first record of Individual Forecast Table
      ** and do an initial read

     C/exec SQL
     C+ declare LIST1 cursor for
     C+ select * from GLFORITD
     C+ where IFRECI = 'D' and
     C+       IFPROR = 'Y' and
     C+       IFACZR <> 'Y' and
     C+       IFACTL = 0 and
     C+       IFFACN <> ' '
     C+ order by
     C+       IFFACN, IFDATE DESC
     C/end-exec

     C/exec SQL
     C+ open LIST1
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF


     C/exec SQL
     C+ fetch next
     C+ from LIST1
     C+ into: FORIT
     C/end-exec

      ** Read Individual Forecast Table until end of file

     C                   MOVE      0             COUNT             1 0
     C                   MOVE      'N'           FIRSTREAD         1

     C                   DOW       SQLCode <> 100

     C                   IF        WFIUPB = 'N' And IFDATE < BJRDNB
     C                   GOTO      ReadNext
     C                   ENDIF

     C                   EVAL      ACCCYD = %Subst(IFFACN:10:3)                             MD024275
     C                                                                                      MD024275
     C                   IF        FIRSTREAD = 'N'
     C                   EVAL      COUNT = 1
     C                   ENDIF

     C                   IF        COUNT = 1
     C                   EVAL      PRDATE = IFDATE
     C                   EVAL      PRFACN = IFFACN
     C                   EVAL      FIRSTREAD = 'Y'
     C                   EVAL      COUNT = 0
     C                   ENDIF

      ** Convert Forecast Currency if not equal
      ** to Account Currency

     C**********         IF        PRCCYD <> IFCCY                                          MD024275
     C                   IF        ACCCYD <> IFCCY                                          MD024275
     C                   EXSR      SRConvert
     C                   ELSE
     C                   EVAL      WConvFAmt = IFAMNT
     C                   ENDIF


     C                   IF        PRDATE <> IFDATE or
     C                             PRFACN <> IFFACN

     C/exec SQL
     C+ declare LIST2 cursor for
     C+ select * from GLFOAVTD
     C+ where AFBRCA = :PRBRCA and
     C+ AFCNUM = :PRCNUM and
     C+ AFCCY = :PRCCYD and
     C+ AFACOD = :PRACOD and
     C+ AFACSQ = :PRACSQ and
     C+ AFDATE = :PRDATE
     C/end-exec

     C/exec SQL
     C+ open LIST2
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into: FOAVT
     C/end-exec

      ** If record found in GLFOAVTD, then update

     C                   IF        SQLCOD = 0
     C                   EXSR      SRUpd
     C                   ENDIF

      ** If record not found in GLFOAVTD, then write

     C                   IF        SQLCOD = 100
     C                   EXSR      SRWri
     C                   ENDIF

      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw

      ** Save last record read and reset work field

     C                   EVAL      PRDATE = IFDATE
     C                   EVAL      PRFACN = IFFACN
     C                   EVAL      PRTOT = *ZEROS

     C/exec SQL
     C+ close LIST2
     C/end-exec
     C                   ENDIF

     C                   EVAL      PRTOT =  PRTOT + WConvFAmt

     C     ReadNext      TAG
     C/exec SQL
     C+ fetch next from LIST1
     C+ into :FORIT
     C/end-exec

     C                   ENDDO

      ** If End of file and PRTOT not equal to zero

     C                   IF        SQLCOD = 100 And PRTOT <> *Zeros

     C/exec SQL
     C+ declare LIST3 cursor for
     C+ select * from GLFOAVTD
     C+ where AFBRCA = :PRBRCA and
     C+ AFCNUM = :PRCNUM and
     C+ AFCCY = :PRCCYD and
     C+ AFACOD = :PRACOD and
     C+ AFACSQ = :PRACSQ and
     C+ AFDATE = :PRDATE
     C/end-exec

     C/exec SQL
     C+ open LIST3
     C/end-exec

      ** Handle SQL Error (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from LIST3
     C+ into: FOAVT
     C/end-exec

      ** If record found in GLFOAVTD, then update

     C                   IF        SQLCOD = 0
     C                   EXSR      SRUpd
     C                   ENDIF

      ** If record not found in GLFOAVTD, then write

     C                   IF        SQLCOD = 100
     C                   EXSR      SRWri
     C                   ENDIF

      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw

     C/exec SQL
     C+ close LIST3
     C/end-exec

     C                   ENDIF

     C/exec SQL
     C+ close LIST1
     C/end-exec


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert Forecast Amount to Account Currency      *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR

      ** Retrieve currency details for FROM currency (Forecast Currency)

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      IFCCY         PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = IFCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WFrXrate = A6SPRT
     C                   EVAL      WFrMDIn  = A6MDIN
     C                   EVAL      WFrDecPlace = A6NBDP
     C                   ENDIF

      ** Retrieve currency details for TO currency (Account Currency)

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C**********         PARM      PRCCYD        PCCY                                       MD024275
     C                   PARM      ACCCYD        PCCY                                       MD024275
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C**********         EVAL      DBKey = PRCCYD                                           MD024275
     C                   EVAL      DBKey = ACCCYD                                           MD024275
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WToXrate = A6SPRT                                        MD024013
     C                   EVAL      WToMDIn  = A6MDIN                                        MD024013
     C                   EVAL      WToDecPlace = A6NBDP
     C                   ENDIF

      *                                                                                     MD024013
     C                   Z-ADD     WFrXrate      ZRATE1                                     MD024013
     C                   MOVE      WFrMDIn       ZMDI1                                      MD024013
     C                   Z-ADD     WToXrate      ZRATE2                                     MD024013
     C                   MOVE      WToMDIn       ZMDI2                                      MD024013
     C                   CALL      'ZXRATE'                                                 MD024013
     C                   PARM                    ZRATE1                                     MD024013
     C                   PARM                    ZMDI1                                      MD024013
     C                   PARM                    ZRATE2                                     MD024013
     C                   PARM                    ZMDI2                                      MD024013
     C                   PARM                    ZRATEX                                     MD024013
     C                   PARM                    ZMDIX                                      MD024013
                                                                                            MD024013
     C                   Z-ADD     ZRATEX        ZEXCH                                      MD024013
     C                   MOVE      ZMDIX         ZMD                                        MD024013
                                                                                            MD024013
      ** Convert Forecast Amount

     C                   CALL      'ZCONVZ1'
     C                   PARM      IFAMNT        PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      IFCCY         PFrCCY
     C**********         PARM      PRCCYD        PToCCY                                     MD024275
     C                   PARM      ACCCYD        PToCCY                                     MD024275
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt

     C                   EVAL      WConvFAmt = POutAmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpd - Update record in GLFOAVTD                            *
      *                                                               *
      *****************************************************************
     C     SRUpd         BEGSR

      ** Update Forecast Available Amount

     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :PRTOT
     C+ where AFBRCA = :PRBRCA and
     C+ AFCNUM = :PRCNUM and
     C+ AFCCY = :PRCCYD and
     C+ AFACOD = :PRACOD and
     C+ AFACSQ = :PRACSQ and
     C+ AFDATE = :PRDATE
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWri - Write record in GLFOAVTD                             *
      *                                                               *
      *****************************************************************
     C     SRWri         BEGSR


      ** Get Facility Details

     C                   EXSR      SRGetFcltyDtl

      ** Write Forecast Available Amount

     C/exec SQL
     C+ insert into GLFOAVTD
     C+ (
     C+   AFBRCA
     C+ , AFCNUM
     C+ , AFCCY
     C+ , AFACOD
     C+ , AFACSQ
     C+ , AFDATE
     C+ , AFAVAIL
     C+ , AFFCCUS
     C+ , AFFACT
     C+ , AFFCNO
     C+ )
     C+ Values
     C+ (
     C+   :PRBRCA
     C+ , :PRCNUM
     C+ , :PRCCYD
     C+ , :PRACOD
     C+ , :PRACSQ
     C+ , :PRDATE
     C+ , :PRTOT
     C+ , :WFCCUS
     C+ , :WFACT
     C+ , :WFCNO
     C+ )
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForw - Update the Available Bal. for other Forward Dates   *
      *                                                               *
      *****************************************************************
     C     SRForw        BEGSR

      ** Set file pointer to first record of GLFOAVTD

     C/exec SQL
     C+ declare LIST4 cursor for
     C+ select * from GLFOAVTD
     C+ where AFBRCA = :PRBRCA and
     C+ AFCNUM = :PRCNUM and
     C+ AFCCY = :PRCCYD and
     C+ AFACOD = :PRACOD and
     C+ AFACSQ = :PRACSQ
     C+ order by
     C+       AFDATE
     C/end-exec

     C/exec SQL
     C+ open LIST4
     C/end-exec

      ** Handle SQLError (If not %EOF)

     C                   IF        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from LIST4
     C+ into: FOAVT
     C/end-exec

      ** Read Total Forecast Table until end of file

     C                   DOW       SQLCode <> 100

     C                   IF        AFDATE > PRDATE

     C                   EVAL      WAFDATE = *ZEROS
     C                   EVAL      WAFDATE = AFDATE
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL + PRTOT

      ** Update Forecast Available Amount

     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C**where*AFBRCA = :PRDATE and                                                          MD024014
     C**AFCNUM*= :PRCNUM and                                                                MD024014
     C**AFCCY*= :PRCCYD and                                                                 MD024014
     C**AFACOD*= :PRACOD and                                                                MD024014
     C**AFACSQ*= :PRACSQ and                                                                MD024014
     C**AFDATE*= :PRDATE                                                                    MD024014
     C+ where AFBRCA = :AFBRCA and                                                          MD024014
     C+ AFCNUM = :AFCNUM and                                                                MD024014
     C+ AFCCY  = :AFCCY  and                                                                MD024014
     C+ AFACOD = :AFACOD and                                                                MD024014
     C+ AFACSQ = :AFACSQ and                                                                MD024014
     C+ AFDATE = :AFDATE                                                                    MD024014
     C/end-exec

     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from LIST4
     C+ into: FOAVT
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close LIST4
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetFcltyDtl - Get Facility Details                         *
      *                                                               *
      *****************************************************************
     C     SRGetFcltyDtl BEGSR

     C                   MOVE      *Blanks       WFCCUS
     C                   MOVE      *Zeros        WFACT
     C                   MOVE      *Zeros        WFCNO
     C                   MOVE      PRCNUM        @CUST             6
     C                   MOVE      PRCCYD        @CCY              3
     C                   MOVE      PRACOD        @ACCD            10
     C                   MOVE      PRACSQ        @ACSN             2
     C                   MOVE      PRBRCA        @BRCA             3

     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      *BLANKS       @ACNO            10
     C                   PARM                    @CUST
     C                   PARM                    @CCY
     C                   PARM                    @ACCD
     C                   PARM                    @ACSN
     C                   PARM                    @BRCA
     C     SDACCT        PARM      SDACCT        DSSDY

     C     PRTCD         IFEQ      *BLANKS
     C                   EVAL      WFCCUS = A_FCCU
     C                   EVAL      WFACT = A_FACT
     C                   EVAL      WFCNO = A_FCNO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank details
      **   Retrieve Run day number

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      * Retrieve the system value

     C                   EVAL      ProcMode = 'ForecastIncUnmatched'
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE
     C                   PARM                    ProcMode
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10

      * If the system value is not found then issue a database error

     C     RTNCDE        IFNE      '       '
     C                   EXSR      *PSSR
     C                   ENDIF

      * Get the Forecast Include Unmatched in Projected Balance

     C                   EVAL      WFIUPB = SVAL1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   EVAL      PRTCD = '*ERROR'

     C                   RETURN

     C                   ENDSR

