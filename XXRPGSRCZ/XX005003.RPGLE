000100210908     H DEBUG
000101210908     H
000102210908      *****************************************************************
000103210908/*STD *  RPGBASEMOD                                                   *
000104210908/*EXI *  TEXT('Midas XX GLM Feeder Files Generation')                 *
000105210908      *****************************************************************
000106210908      *                                                               *
000107210908      *  Midas - General Ledger Module                                *
000108210908      *                                                               *
000109210908      *  XX005003 - Midas XX GLM Feeder Files Generation              *
000110210908      *                                                               *
000111210908      *  Function: Extract posting details                            *
000112210908      *                                                               *
000113210908      *  Called by: XXC005002 - Midas XX GLM/EDW Extract file Gen.    *
000114210908      *                                                               *
000115210908      *  (c) Finastra International Limited 2021                      *
000116210908      *                                                               *
000117210908      *  Last Amend No. DRI005  *CREATE    Date 13Apr21               *
000118210908      *                                                               *
000119210908      *---------------------------------------------------------------*
000120210908      *                                                               *
000121210908      *  DRI005 - HO and EDW Extracts                                 *
000122210908      *                                                               *
000123210908      *****************************************************************
000124210908      *
000125210908     FXXAPOSL0  IF   E           K Disk    InfSR(*PSSR)
000126210908      *
000127210908     FXXACHOML0 IF   E           K Disk    InfSR(*PSSR)
000128210908      *
000129210908     FXXFEEDHTD O    E           K Disk    InfSR(*PSSR)
000130210908      *
000131210908     FXXFEEDCTD O    E           K Disk    InfSR(*PSSR)
000132210908      *
000133210908     FXXFEEDDTD O    E           K Disk    InfSR(*PSSR)
000134210908      *
000135210908      /Title Function of indicators
000136210908     F*****************************************************************
000137210908     F*                                                               *
000138210908     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
000139210908     F*                                                               *
000140210908     F*                                                               *
000141210908     F*  90-99 - Used by Standard Subroutines                         *
000142210908     F*                                                               *
000143210908     F*  U7+U8 - Database Error                                       *
000144210908     F*                                                               *
000145210908     F*****************************************************************
000146210908      /Title Subroutine Index
000147210908     F*****************************************************************
000148210908     F*                                                               *
000149210908     F*  S U B R O U T I N E   I N D E X                              *
000150210908     F*                                                               *
000151210908     F*  Init      - Initial Processing                               *
000152210908     F*  Proces    - Main processing                                  *
000153210908     F*  Extract   - Main Extract Processing                          *
000154210908     F*  ExtDet    - Details Record                                   *
000155210908     F*  ExtCtl    - Control Record                                   *
000156210908     F*  ExtHed    - Header Record                                    *
000157210908     F*  ChkSysValue - Retrieve system values                         *
000158210908     F*  SRZDate9  - Date format                                      *
000159210908     F*  SRCvtDate - Convert date format                              *
000160210908     F*                                                               *
000161210908     F*  *PSSR     - Program error handling routine                   *
000162210908     F*                                                               *
000163210908     F*****************************************************************
000164210908     D/Title D-Specifications
000165210908     D CPY@            S             80    Dim(1) CTData PerRCD(1)
000166210908      ***  Array for Object Copyright Statement.
000167210908      *
000168210908     D SDBRCH        E DS                  ExtName(SDBRCHPD)
000169210908      ** Branch Details
000170210908      *
000171210908     D SDBANK        E DS                  ExtName(SDBANKPD)
000172210908      ** Bank Details
000173210908      *
000174210908     D DSSDY         E DS                  ExtName(DSSDY)
000175210908      ** Second DS For Access Programs, Long Data Structure
000176210908      *
000177210908     D DBERR           DS           256
000178210908      * Data structure for data-base error processing
000179210908     D  DBFILE               134    141
000180210908     D  DBKEY                142    170
000181210908     D  DBPGM                171    180
000182210908     D  DBASE                181    183  0
000183210908      *
000184210908     D                 DS
000185210908
000186210908     D RUNDAT          DS
000187210908      * Data structure for rundate flags
000188210908     D  RUNA                   1      7
000189210908     D  @DLUP                  1      2  0
000190210908     D  @MLUP                  3      5
000191210908     D  @YLUP                  6      7  0
000192210908     D  RUND                   8     10P 0
000193210908     D  @MBIN                 13     13
000194210908      *
000195210908     DSDDTA            DS
000196210908     D SDDATA                  1    256
000197210908     D SPREFX                  6      7
000198210908      *
000199210908     D P@OP01          S             20A
000200210908     D P@VL01          S            200A
000201210908     D P@OP02          S             20A
000202210908     D P@VL02          S            200A
000203210908     D P@OP03          S             20A
000204210908     D P@VL03          S            200A
000205210908     D P@OP04          S             20A
000206210908     D P@VL04          S            200A
000207210908     D P@OP05          S             20A
000208210908     D P@VL05          S            200A
000209210908     D P@OP06          S             20A
000210210908     D P@VL06          S            200A
000211210908     D P@OP07          S             20A
000212210908     D P@VL07          S            200A
000213210908     D P@OP08          S             20A
000214210908     D P@VL08          S            200A
000215210908     D P@OP09          S             20A
000216210908     D P@VL09          S            200A
000217210908     D P@OP10          S             20A
000218210908     D P@VL10          S            200A
000219210908      *
000220210908     D PSysVal1        C                   CONST('VLJRecordFormat')
000221210908     D PSysVal2        C                   CONST('VLJCorpEntityCode')
000222210908     D PSysVal3        C                   CONST('VLJBranchCode')
000223210908     D PSysVal4        C                   CONST('VLJSystem')
000224210908     D PSysVal5        C                   CONST('VLJConstantS')
000225210908     D PSysVal6        C                   CONST('VLJConstant20')
000226210908     D PSysVal7        C                   CONST('VLJConstantCY')
000227210908     D PSysVal8        C                   CONST('VLJConstantCP')
000228210908     D PSysVal9        C                   CONST('VLJCompany')
000229210908
000230210908     D CDesBal1        C                   CONST('SUMMARIZED ')
000231210908     D CDesBal2        C                   CONST(' FROM MIDAS FOR BRN ')
000232210908
000233210908     D PDesBal         DS
000234210908     D  PDesBal1               1     11
000235210908     D  PDesBal2              12     14
000236210908     D  PDesBal3              15     34
000237210908     D  PDesBal4              35     37
000238210908     D  PDesBal5              38     45
000239210908
000240210908     D PRecFmt         S              3A
000241210908     D PCorpEnt        S              5A
000242210908     D PBranch         S              3A
000243210908     D PSystem         S              3A
000244210908     D PConstS         S              1A
000245210908     D PConst20        S              2A
000246210908     D PConstCY        S              2A
000247210908     D PConstCP        S              2A
000248210908     D PCompany        S              3A
000249210908
000250210908     D PDateOut        S              6  0
000251210908
000252210908      ** Parameters for ZBKDT
000253210908     D WCurr_RunDay    S              5  0 Inz
000254210908     D WNext_WrkDay    S              5  0 Inz
000255210908     D WPrev_WrkDay    S              5  0 Inz
000256210908     D WDayNo          S              5  0 Inz
000257210908     D WCcy            S              3    Inz
000258210908     D WLoc            S              3    Inz
000259210908     D WDays           S              2  0 Inz
000260210908      *
000261210908      ** Parameters for ZDATE9
000262210908     D PDaynoIn        S              5P 0
000263210908     D PDateOutZ9      S              8S 0
000264210908     D PRetCodeZ9      S              1  0
000265210908
000266210908      ** YYYYMMDD date format of Rundate
000267210908     D DSRNDDate       DS
000268210908     D  WVYYR                  1      4  0
000269210908     D  WVY2R                  3      4  0
000270210908     D  WVMMR                  5      6  0
000271210908     D  WVDDR                  7      8  0
000272210908     D  WVRND                  1      8  0
000273210908
000274210908      ** YYYYMMDD date format of Posting date
000275210908     D DSPSTDate       DS
000276210908     D  WVYYP                  1      4  0
000277210908     D  WVMMP                  5      6  0
000278210908     D  WVDDP                  7      8  0
000279210908     D  WVPST                  1      8  0
000280210908
000281210908      ** YYYYMMDD date format of Value date
000282210908     D DSVLDDate       DS
000283210908     D  WVYYV                  1      4  0
000284210908     D  WVMMV                  5      6  0
000285210908     D  WVDDV                  7      8  0
000286210908     D  WVALD                  1      8  0
000287210908
000288210908      ** DDMMYY date format of Value date
000289210908     D DSVLDDat1       DS
000290210908     D  WVDDV1                 1      2
000291210908     D  WVMMV1                 3      4
000292210908     D  WVYYV1                 5      6
000293210908
000294210908      ** YYMMDD date format of Rundate
000295210908     D DSDayDate       DS
000296210908     D  WVY2D                  1      2  0
000297210908     D  WVMMD                  3      4  0
000298210908     D  WVDDD                  5      6  0
000299210908
000300210908      ** YYYYMMDD date format of Previous Working Date
000301210908     D DSPWDDate       DS
000302210908     D  PWDYY                  1      4  0
000303210908     D  PWDY2                  3      4  0
000304210908     D  PWDMM                  5      6  0
000305210908     D  PWDDD                  7      8  0
000306210908     D  PWRND                  1      8  0
000307210908
000308210908      ** DS For Journal ID
000309210908     D DSJRNID         DS
000310210908     D  DJRNI1                 1      3
000311210908     D  DJRNI2                 4      6
000312210908     D  DJRNI3                 7      9
000313210908     D  DJRNI4                10     10
000314210908      *
000315210908      ** DS For GLMCP
000316210908     D DSGLMCP         DS
000317210908     D  DGLMC1                 1      3
000318210908     D  DGLMC2                 4      7
000319210908     D  DGLMC3                 8     12
000320210908     D  DGLMC4                13     16
000321210908     D  DGLMC5                17     19
000322210908     D  DGLMC6                20     44
000323210908      *
000324210908      ** DS For Source
000325210908     D DSSRCE          DS
000326210908     D  DSRC1                  1      3
000327210908     D  DSRC2                  4      4
000328210908     D  DSRC3                  5     10
000329210908      *
000330210908      ** DS For Journal Description
000331210908     D DSJRND          DS
000332210908     D  DJRND1                 1     30
000333210908     D  DJRND2                31     49
000334210908     D  DJRND3                50     51
000335210908     D  DJRND4                52     53
000336210908     D  DJRND5                54     57
000337210908     D  DJRND6                58     65
000338210908     D  DJRN61                58     59
000339210908     D  DJRN62                60     65
000340210908     D  DJRND7                66     67
000341210908     D  DJRND8                68     73
000342210908     D  DJRND9                74     75
000343210908      *
000344210908     D DSJRNS          DS
000345210908     D  DJRNS1                 1      2
000346210908     D  DJRNS2                 3      4
000347210908     D  DJRNS3                 5      5
000348210908      *
000349210908
000350210908     C/Title Main Processing
000351210908      *================================================================
000352210908      *  P R O G R A M     S T A R T                                  *
000353210908      *================================================================
000354210908      *
000355210908      * Perform Initialisation.
000356210908     C                   ExSR      Init
000357210908      *
000358210908      * Perform Main Processing.
000359210908     C                   ExSR      Process
000360210908      *
000361210908     C                   SetOn                                        LR
000362210908     C                   Return
000363210908      *================================================================
000364210908      *  P R O G R A M     E N D                                      *
000365210908      *================================================================
000366210908      /Title SR/Init
000367210908      *****************************************************************
000368210908      *                                                               *
000369210908      *  Init   - Subroutine to do Program Initialisation.            *
000370210908      *                                                               *
000371210908      *  Called By: Main Processing                                   *
000372210908      *  Calls    : None                                              *
000373210908      *                                                               *
000374210908      *****************************************************************
000375210908      *
000376210908     C     Init          BegSR
000377210908      *
000378210908      ***  Copyright Statement.
000379210908     C                   MoveA     CPY@          BIS@             80
000380210908      *
000381210908     C                   EVAL      WCurr_RunDay = 0
000382210908     C                   EVAL      WPrev_WrkDay = 0
000383210908     C                   EVAL      WNext_WrkDay = 0
000384210908      *
000385210908      ** Access Bank Details
000386210908     C                   Call      'AOBANKR0'
000387210908     C                   Parm      '*MSG   '     WRTCD             7
000388210908     C                   Parm      '*FIRST '     WOPTN             7
000389210908     C     SDBANK        Parm      SDBANK        DSSDY
000390210908      *
000391210908     C     WRTCD         IfNE      *BLANKS
000392210908     C                   Z-Add     001           DBASE                          ***************
000393210908     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
000394210908     C                   Move      *Blanks       DBKEY                          ***************
000395210908     C                   ExSR      *PSSR
000396210908     C                   Else
000397210908     C                   EVAL      WCurr_RunDay = BJRDNB
000398210908     C                   EVAL      WNext_WrkDay = BJDNWD
000399210908     C                   End
000400210908      *
000401210908      ** Retrieve Previous Working Day
000402210908
000403210908     C                   CALL      'ZBKDT'
000404210908     C                   PARM      WCurr_RunDay  WDayNo
000405210908     C                   PARM      BJLCCY        WCcy
000406210908     C                   PARM      BJSLCD        WLoc
000407210908     C                   PARM      BJBVPD        WDays
000408210908     C                   PARM      *Zero         WPrev_WrkDay
000409210908      *
000410210908      ***  Check System Date Format, DDMMYY (*IN98 off)
000411210908      ***                            MMDDYY (*IN98 on).
000412210908      *
000413210908     C                   If        BJDFIN = 'M'
000414210908     C                   SetOn                                        98
000415210908     C                   EndIf
000416210908      *
000417210908     C** Get system prefix from SDSTAT
000418210908     C     *DTAARA       Define    SDSTAT        SDDTA
000419210908     C                   In        SDDTA
000420210908      *
000421210908     C** Get RUNDAT to access MULTI-BRANCHING flag
000422210908     C     *DTAARA       Define                  RUNDAT
000423210908     C                   In        RUNDAT
000424210908      *
000425210908     C                   Z-ADD     BJRDNB        PDaynoIn
000426210908     C                   EXSR      SRZDate9
000427210908     C                   MOVE      PDateOutZ9    DSRndDate
000428210908      *
000429210908     C                   Z-ADD     WPrev_WrkDay  PDaynoIn
000430210908     C                   EXSR      SRZDate9
000431210908     C                   MOVE      PDateOutZ9    DSPWDDate
000432210908      *
000433210908     C                   MOVE      WVY2R         WVY2D
000434210908     C                   MOVE      WVMMR         WVMMD
000435210908     C                   MOVE      WVDDR         WVDDD
000436210908     C                   MOVE      DSDayDate     DayDate           6
000437210908      *
000438210908      ** Retrieve system values details
000439210908     C                   EXSR      ChkSysValue
000440210908      *
000441210908     C                   Move      *BLANKS       WKCCY             3
000442210908     C                   Movel     *BLANKS       WKACOD           10
000443210908      *
000444210908     C                   EndSR
000445210908      *****************************************************************
000446210908      /Title SR/Process
000447210908      *****************************************************************
000448210908      *                                                               *
000449210908      *  Process - Subroutine to do the Detail Processing.            *
000450210908      *                                                               *
000451210908      *  Called By: Main Processing                                   *
000452210908      *  Calls:                                                       *
000453210908      *                                                               *
000454210908      *****************************************************************
000455210908      *
000456210908     C     Process       BegSR
000457210908      *
000458210908     C                   Z-ADD     BJRDNB        KDAYL             5 0
000459210908      *
000460210908      ***  Read the Posting file APOSTPD for the rundate
000461210908      *** Ordered by CCY
000462210908     C     *LOVAL        Setll     XXAPOSL0
000463210908     C                   READ      XXAPOSL0                               50
000464210908      *
000465210908      * Get Branch Details
000466210908      *
000467210908     C                   CALL      'AOBRCHR1'
000468210908     C                   PARM      *BLANKS       WRTCD
000469210908     C                   PARM      '*KEY   '     WOPTN
000470210908     C                   PARM      BRCA          WBRCA             3
000471210908     C     SDBRCH        PARM      SDBRCH        DSSDY
000472210908      *
000473210908      ***  Process all postings for the day
000474210908      *
000475210908     C                   Dow       *In50 = '0'
000476210908      *
000477210908      ***  Read the Account Code HO Details file
000478210908     C                   Z-ADD     ACOD          KACOD            10 0
000479210908     C     KACOD         Chain     XXACHOML0                          90
000480210908      *
000481210908     C                   If        *In90 = '0' AND XXMEXCL = 'N'
000482210908     C                             OR *IN90 = '1'
000483210908      *
000484210908      ** Extract postings details
000485210908     C                   EXSR      EXTRACT
000486210908     C                   READ      XXAPOSL0                               50
000487210908      *
000488210908     C                   Else
000489210908     C                   If        *In90 = '0' AND XXMEXCL = 'Y'
000490210908     C                   Read      XXAPOSL0                               50
000491210908     C                   ENDIF
000492210908      *
000493210908     C                   Endif
000494210908      *
000495210908      ***  End of Do While Not End of File.
000496210908     C                   EndDo
000497210908      *
000498210908     C                   EXSR      EXTCTL
000499210908      *
000500210908      ** Write Feeder Header record
000501210908     C                   EXSR      EXTHED
000502210908      *
000503210908     C                   EndSR
000504210908      *
000505210908      *****************************************************************
000506210908      *                                                               *
000507210908      * EXTRACT - Extract postings process                            *
000508210908      *                                                               *
000509210908      * Called by: Main Processing                                    *
000510210908      *                                                               *
000511210908      * Calls:                                                        *
000512210908      *                                                               *
000513210908      *****************************************************************
000514210908      *
000515210908     C     EXTRACT       BEGSR
000516210908      *
000517210908      ** split posting date
000518210908     C                   Z-ADD     PSTD          PDaynoIn
000519210908     C                   EXSR      SRZDate9
000520210908     C                   MOVE      PDateOutZ9    DSPSTDate
000521210908      *
000522210908      ** split value date
000523210908     C                   Z-ADD     VALD          PDaynoIn
000524210908     C                   EXSR      SRZDate9
000525210908     C                   MOVE      PDateOutZ9    DSVLDDate
000526210908      *
000527210908      ** Extract posting
000528210908      *
000529210908     C                   If        PSTD = BJRDNB and PSTD = VALD
000530210908     C                             OR PSTD = BJRDNB and WVMMP = WVMMV
000531210908     C                             OR PSTD = BJRDNB and WVMMP > WVMMV and
000532210908     C                                WVYYP = WVYYV
000533210908     C                             OR PSTD = BJRDNB and PSTD > VALD and
000534210908     C                                WVYYP <> WVYYV and WVMMP < WVMMV
000535210908     C                             OR PSTD = WPrev_WrkDay and WVMMP > WVMMV and
000536210908     C                                WVYYP <> WVYYV
000537210908     C                             OR PSTD = WPrev_WrkDay and WVMMP < WVMMV and
000538210908     C                                WVYYP = WVYYV
000539210908      *
000540210908      ** Process Details record format
000541210908     C                   If        CCY = WKCCY OR WKCCY = *BLANKS
000542210908     C                   EXSR      EXTDET
000543210908      *
000544210908      ** Process Control and Details rec format
000545210908     C                   Else
000546210908     C                   If        CCY <> WKCCY
000547210908     C                   EXSR      EXTCTL
000548210908     C                   EXSR      EXTDET
000549210908     C                   ENDIF
000550210908      *
000551210908     C                   ENDIF
000552210908      *
000553210908     C                   ENDIF
000554210908      *
000555210908     C                   ENDSR
000556210908      *
000557210908      *****************************************************************
000558210908      *                                                               *
000559210908      * EXTDET - Write Feeder Details Record                          *
000560210908      *                                                               *
000561210908      * Called by: Main Processing                                    *
000562210908      *                                                               *
000563210908      * Calls:                                                        *
000564210908      *                                                               *
000565210908      *****************************************************************
000566210908      *
000567210908     C     EXTDET        BEGSR
000568210908      *
000569210908     C     SPOS          IFNE      '  GE-XB'
000570210908      *
000571210908     C                   CLEAR                   XXFEEDDD0
000572210908      ** Ccy
000573210908     C                   MOVEL     CCY           WKCCY
000574210908      ** Acount Code
000575210908     C                   MOVEL     ACOD          WKACOD
000576210908      ** Record Format
000577210908     C                   MOVEL     'VLJ'         XXDDBID
000578210908      ** Corporate Entity
000579210908     C                   MOVEL     PCorpEnt      XXDVJCC
000580210908      ** Journal ID
000581210908     C                   MOVEL     PBranch       DJRNI1
000582210908     C                   MOVEL     PSystem       DJRNI2
000583210908     C                   MOVEL     CCY           DJRNI3
000584210908     C                   MOVEL     '0'           DJRNI4
000585210908     C                   MOVEL     DSJRNID       XXDJRNID
000586210908      ** Effective Date
000587210908     C                   MOVE      DSRndDate     XXDEFFD
000588210908      ** Journal Seq
000589210908     C                   MOVE      WVMMR         DJRNS1
000590210908     C                   MOVE      WVDDR         DJRNS2
000591210908     C                   MOVE      '0'           DJRNS3
000592210908     C                   MOVE      DSJRNS        XXDJRNSQ
000593210908      ** GLM Account to Post to
000594210908     C                   MOVE      PBranch       DGLMC1
000595210908     C                   MOVE      *BLANKS       DGLMC2
000596210908     C                   If        *IN90 = '0'
000597210908     C                   MOVE      XXMHOAC       DGLMC3
000598210908     C                   MOVE      XXMHOPC       DGLMC4
000599210908     C                   MOVE      XXMHOMC       DGLMC5
000600210908     C                   ELSE
000601210908     C                   MOVE      *BLANKS       DGLMC3
000602210908     C                   MOVE      *BLANKS       DGLMC4
000603210908     C                   MOVE      *BLANKS       DGLMC5
000604210908     C                   ENDIF
000605210908     C                   MOVE      *BLANKS       DGLMC6
000606210908     C                   MOVE      DSGLMCP       XXDGLMCP
000607210908      ** CCY
000608210908     C                   MOVE      CCY           XXDCCYL
000609210908      ** Account Code
000610210908     C                   MOVEL     ACOD          XXDACOD
000611210908      ** Rundate
000612210908     C                   Z-ADD     BJRDNB        XXDRND
000613210908      ** Constant S
000614210908     C                   MOVE      PConstS       XXDCSTS
000615210908      ** Subledger ID
000616210908     C                   MOVE      *BLANKS       XXDSLID
000617210908      ** Subledger Account
000618210908     C                   MOVE      *BLANKS       XXDSLAC
000619210908      ** Source
000620210908     C                   MOVE      BRCA          DSRC1
000621210908     C                   MOVE      *BLANKS       DSRC2
000622210908     C** Convert Date Format from YYYYMMDD to DDMMYY
000623210908     C                   MOVE      WVYYV         WVYYV1
000624210908     C                   MOVE      WVMMV         WVMMV1
000625210908     C                   MOVE      WVDDV         WVDDV1
000626210908     C                   MOVE      DSVLDDat1     DSRC3
000627210908     C                   MOVE      DSSRCE        XXDSRCE
000628210908      ** Journal Description
000629210908     C                   MOVEL     PNAR          DJRND1
000630210908     C                   MOVE      *BLANKS       DJRND2
000631210908     C                   MOVEL     OTTP          DJRND3
000632210908     C                   MOVEL     OTST          DJRND4
000633210908     C                   MOVEL     ACOD          DJRND5
000634210908     C                   If        GETP = 'D'
000635210908     C                   MOVEL     'DL'          DJRN61
000636210908     C                   MOVEL     OTRF          DJRN62
000637210908     C                   Else
000638210908     C                   If        GETP = 'U'
000639210908     C                   MOVEL     'LE'          DJRN61
000640210908     C                   MOVEL     OTRF          DJRN62
000641210908     C                   Else
000642210908     C                   MOVEL     OTRF          DJRND6
000643210908     C                   ENDIF
000644210908     C                   ENDIF
000645210908     C                   MOVE      *BLANKS       DJRND7
000646210908     C                   MOVE      ASOC          DJRND8
000647210908     C                   MOVE      PConst20      DJRND9
000648210908     C                   MOVE      DSJRND        XXDJRND
000649210908      ** Constant CY
000650210908     C                   MOVE      PConstCY      XXDCSTCY
000651210908      ** Constant CP
000652210908     C                   MOVE      PConstCP      XXDCSTCP
000653210908      ** DR/CR Indicator
000654210908     C                   If        DRCR = 0
000655210908     C                   MOVE      'D'           XXDDRCR
000656210908     C                   Else
000657210908     C                   MOVE      'C'           XXDDRCR
000658210908     C                   ENDIF
000659210908      ** Local Book Equivalent
000660210908     C                   MOVE      *ALL'0'       XXDLCBE
000661210908      ** Posting Amount
000662210908     C                   Z-ADD     PSTA          XXDPSTA
000663210908      ** Rate
000664210908     C                   MOVE      *BLANKS       XXDRATE
000665210908      *
000666210908      ** Add up details for Header and Control Format
000667210908      *
000668210908      ** VLJ Total Debit/Credit Posting and No records
000669210908     C                   If        DRCR = 0
000670210908     C                   Add       PSTA          WXCTAMTD
000671210908     C                   Add       1             WXHTVLJD          8 0
000672210908     C                   Add       PSTA          WXHTOTD          19 0
000673210908     C                   Else
000674210908     C                   Add       PSTA          WXCTAMTC
000675210908     C                   Add       1             WXHTVLJC          8 0
000676210908     C                   Add       PSTA          WXHTOTC          19 0
000677210908     C                   ENDIF
000678210908      ** Total VLJ Records
000679210908     C                   Add       1             WXHTTVLJ          8 0
000680210908      *
000681210908      ** Write record to XXFEEDDTD
000682210908     C                   WRITE     XXFEEDDD0
000683210908      *
000684210908     C                   ENDIF
000685210908      *
000686210908     C                   ENDSR
000687210908      *
000688210908      *****************************************************************
000689210908      *                                                               *
000690210908      * EXTCTL - Write Feeder Control Record                          *
000691210908      *                                                               *
000692210908      * Called by: Main Processing                                    *
000693210908      *                                                               *
000694210908      * Calls:                                                        *
000695210908      *                                                               *
000696210908      *****************************************************************
000697210908      *
000698210908     C     EXTCTL        BEGSR
000699210908      *
000700210908      ** Calculate Balance and write Details record in case DR <> CR
000701210908     C                   If        WXCTAMTC <> WXCTAMTD
000702210908      ** if not balanced, need to write Balancing entry
000703210908      *
000704210908     C                   If        WXCTAMTC < WXCTAMTD
000705210908     C     WXCTAMTD      SUB       WXCTAMTC      WKBALNC          19 0
000706210908     C                   Else
000707210908     C     WXCTAMTC      SUB       WXCTAMTD      WKBALNC
000708210908     C                   ENDIF
000709210908      *
000710210908     C                   CLEAR                   XXFEEDDD0
000711210908      ** Record Format
000712210908     C                   MOVEL     'VLJ'         XXDDBID
000713210908      ** Corporate Entity
000714210908     C                   MOVEL     PCorpEnt      XXDVJCC
000715210908      ** Journal ID
000716210908     C                   MOVEL     PBranch       DJRNI1
000717210908     C                   MOVEL     PSystem       DJRNI2
000718210908     C                   MOVEL     WKCCY         DJRNI3
000719210908     C                   MOVEL     '0'           DJRNI4
000720210908     C                   MOVEL     DSJRNID       XXDJRNID
000721210908      ** Effective Date
000722210908     C                   MOVE      DSRndDate     XXDEFFD
000723210908      ** Journal Seq
000724210908     C                   MOVE      WVMMR         DJRNS1
000725210908     C                   MOVE      WVDDR         DJRNS2
000726210908     C                   MOVE      '0'           DJRNS3
000727210908     C                   MOVE      DSJRNS        XXDJRNSQ
000728210908      ** GLM Account to Post to
000729210908     C                   MOVE      PBranch       DGLMC1
000730210908     C                   MOVE      *BLANKS       DGLMC2
000731210908     C                   If        *IN90 = '0'
000732210908     C                   MOVE      XXMHOAC       DGLMC3
000733210908     C                   MOVE      XXMHOPC       DGLMC4
000734210908     C                   MOVE      XXMHOMC       DGLMC5
000735210908     C                   ELSE
000736210908     C                   MOVE      *BLANKS       DGLMC3
000737210908     C                   MOVE      *BLANKS       DGLMC4
000738210908     C                   MOVE      *BLANKS       DGLMC5
000739210908     C                   ENDIF
000740210908     C                   MOVE      *BLANKS       DGLMC6
000741210908     C                   MOVE      DSGLMCP       XXDGLMCP
000742210908      ** CCY
000743210908     C                   MOVE      WKCCY         XXDCCYL
000744210908      ** Account Code
000745210908     C                   MOVEL     WKACOD        XXDACOD
000746210908      ** Rundate
000747210908     C                   Z-ADD     BJRDNB        XXDRND
000748210908      ** Constant S
000749210908     C                   MOVE      PConstS       XXDCSTS
000750210908      ** Subledger ID
000751210908     C                   MOVE      *BLANKS       XXDSLID
000752210908      ** Subledger Account
000753210908     C                   MOVE      *BLANKS       XXDSLAC
000754210908      ** Source
000755210908     C                   MOVE      BRCA          DSRC1
000756210908     C                   MOVE      *BLANKS       DSRC2
000757210908     C** Convert Date Format from YYYYMMDD to DDMMYY
000758210908     C                   MOVE      WVYYV         WVYYV1
000759210908     C                   MOVE      WVMMV         WVMMV1
000760210908     C                   MOVE      WVDDV         WVDDV1
000761210908     C                   MOVE      DSVLDDat1     DSRC3
000762210908     C                   MOVE      DSSRCE        XXDSRCE
000763210908      ** Journal Description
000764210908     C                   MOVE      CDesBal1      PDesBal1
000765210908     C                   MOVE      WKCCY         PDesBal2
000766210908     C                   MOVE      CDesBal2      PDesBal3
000767210908     C                   MOVE      PBranch       PDesBal4
000768210908     C                   MOVE      DSVLDDate     PDesBal5
000769210908     C                   MOVE      PDesBal       DJRND1
000770210908     C                   MOVE      *BLANKS       DJRND2
000771210908     C                   MOVEL     *BLANKS       DJRND3
000772210908     C                   MOVEL     *BLANKS       DJRND4
000773210908     C                   MOVEL     *BLANKS       DJRND5
000774210908     C                   MOVEL     *BLANKS       DJRND6
000775210908     C                   MOVEL     *BLANKS       DJRND7
000776210908     C                   MOVE      A8BICN        DJRND8
000777210908     C                   MOVE      PConst20      DJRND9
000778210908     C                   MOVE      DSJRND        XXDJRND
000779210908      ** Constant CY
000780210908     C                   MOVE      PConstCY      XXDCSTCY
000781210908      ** Constant CP
000782210908     C                   MOVE      PConstCP      XXDCSTCP
000783210908      ** DR/CR Indicator
000784210908     C                   If        WXCTAMTC > WXCTAMTD
000785210908     C                   MOVE      'D'           XXDDRCR
000786210908     C                   Else
000787210908     C                   MOVE      'C'           XXDDRCR
000788210908     C                   ENDIF
000789210908      ** Local Book Equivalent
000790210908     C                   MOVE      *ALL'0'       XXDLCBE
000791210908      ** Posting Amount
000792210908     C                   Z-ADD     WKBALNC       XXDPSTA
000793210908      ** Rate
000794210908     C                   MOVE      *BLANKS       XXDRATE
000795210908      *
000796210908      ** Add up details for Header and Control Format
000797210908      *
000798210908      ** VLJ Total Debit/Credit Posting and No records
000799210908     C                   If        WXCTAMTC > WXCTAMTD
000800210908     C                   Add       PSTA          WXCTAMTD
000801210908     C                   Add       1             WXHTVLJD
000802210908     C                   Add       PSTA          WXHTOTD
000803210908     C                   Else
000804210908     C                   Add       PSTA          WXCTAMTC
000805210908     C                   Add       1             WXHTVLJC
000806210908     C                   Add       PSTA          WXHTOTC
000807210908     C                   ENDIF
000808210908      ** Total VLJ Records
000809210908     C                   Add       1             WXHTTVLJ
000810210908      *
000811210908      ** Write record to XXFEEDDTD
000812210908     C                   WRITE     XXFEEDDD0
000813210908      *
000814210908      ** CONTROL RECORD FORMAT
000815210908      *
000816210908      ** Record Format
000817210908     C                   MOVE      'VJC'         XXCDBID
000818210908      ** Corporate Entity
000819210908     C                   MOVEL     PCorpEnt      XXCVJCC
000820210908      ** Journal ID
000821210908     C                   MOVEL     PBranch       DJRNI1
000822210908     C                   MOVEL     PSystem       DJRNI2
000823210908     C                   MOVEL     WKCCY         DJRNI3
000824210908     C                   MOVEL     '0'           DJRNI4
000825210908     C                   MOVEL     DSJRNID       XXCJRNID
000826210908      ** Effective Date
000827210908     C                   MOVE      DSRndDate     XXCEFFD
000828210908      ** Journal Seq
000829210908     C                   MOVE      DSJRNS        XXCJRNSQ
000830210908      ** Constant CY
000831210908     C                   MOVE      PConstCY      XXCCSTCY
000832210908      ** Constant CP
000833210908     C                   MOVE      PConstCP      XXCCSTCP
000834210908      ** Filler 1
000835210908     C                   MOVE      *BLANKS       XXCFIL1
000836210908      *
000837210908      ** Add up VJC Record added
000838210908     C                   Z-ADD     WXCTAMTD      XXCTAMTD
000839210908     C                   Z-ADD     WXCTAMTC      XXCTAMTC
000840210908     C                   Add       1             WXHTTVJC          8 0
000841210908     C                   WRITE     XXFEEDCD0
000842210908      *
000843210908     C                   ENDIF
000844210908      *
000845210908      ** CONTROL RECORD FORMAT
000846210908     C                   If        WXCTAMTC = WXCTAMTD and
000847210908     C                             WXCTAMTC > 0
000848210908     C                   CLEAR                   XXFEEDCD0
000849210908      ** Record Format
000850210908     C                   MOVE      'VJC'         XXCDBID
000851210908      ** Corporate Entity
000852210908     C                   MOVEL     PCorpEnt      XXCVJCC
000853210908      ** Journal ID
000854210908     C                   MOVEL     PBranch       DJRNI1
000855210908     C                   MOVEL     PSystem       DJRNI2
000856210908     C                   MOVEL     WKCCY         DJRNI3
000857210908     C                   MOVEL     '0'           DJRNI4
000858210908     C                   MOVEL     DSJRNID       XXCJRNID
000859210908      ** Effective Date
000860210908     C                   MOVE      DSRndDate     XXCEFFD
000861210908      ** Journal Seq
000862210908     C                   MOVE      DSJRNS        XXCJRNSQ
000863210908      ** Constant CY
000864210908     C                   MOVE      PConstCY      XXCCSTCY
000865210908      ** Constant CP
000866210908     C                   MOVE      PConstCP      XXCCSTCP
000867210908      ** Filler 1
000868210908     C                   MOVE      *BLANKS       XXCFIL1
000869210908      *
000870210908      ** Add up VJC Record added
000871210908     C                   Z-ADD     WXCTAMTD      XXCTAMTD
000872210908     C                   Z-ADD     WXCTAMTC      XXCTAMTC
000873210908     C                   Add       1             WXHTTVJC
000874210908     C                   WRITE     XXFEEDCD0
000875210908     C                   ENDIF
000876210908      *
000877210908      ** Reset total for VJC records
000878210908     C                   Z-ADD     0             WXCTAMTC         19 0
000879210908     C                   Z-ADD     0             WXCTAMTD         19 0
000880210908      *
000881210908     C                   ENDSR
000882210908      *
000883210908      *****************************************************************
000884210908      *                                                               *
000885210908      * EXTHED - Write Feeder Header Record                           *
000886210908      *                                                               *
000887210908      * Called by: Main Processing                                    *
000888210908      *                                                               *
000889210908      * Calls:                                                        *
000890210908      *                                                               *
000891210908      *****************************************************************
000892210908      *
000893210908     C     EXTHED        BEGSR
000894210908      *
000895210908     C                   CLEAR                   XXFEEDHD0
000896210908      ** Record Format
000897210908     C                   MOVEL     'FCR'         XXHDBID
000898210908      ** Filler 1, 2 & 3
000899210908     C                   MOVEL     *BLANKS       XXHFIL1
000900210908     C                   MOVE      *ALL'0'       XXHFIL2
000901210908     C                   MOVEL     *BLANKS       XXHFIL3
000902210908      ** System
000903210908     C                   MOVE      PSystem       XXHSYST
000904210908      ** Rundate
000905210908     C                   MOVE      DSRndDate     XXHBUSD
000906210908      ** Rest of calculated fields already set in other Sb
000907210908     C                   Z-ADD     WXHTTVJC      XXHTTVJC
000908210908     C                   Z-ADD     WXHTTVLJ      XXHTTVLJ
000909210908     C                   Z-ADD     WXHTVLJD      XXHTVLJD
000910210908     C                   Z-ADD     WXHTVLJC      XXHTVLJC
000911210908     C                   Z-ADD     WXHTOTD       XXHTOTD
000912210908     C                   Z-ADD     WXHTOTC       XXHTOTC
000913210908      *
000914210908     C                   WRITE     XXFEEDHD0
000915210908      *
000916210908     C                   ENDSR
000917210908      *
000918210908      *****************************************************************
000919210908      *                                                               *
000920210908      * ChkSysValue - Check for system values                         *
000921210908      *                                                               *
000922210908      * Called by: Main Processing                                    *
000923210908      *                                                               *
000924210908      * Calls:                                                        *
000925210908      *                                                               *
000926210908      *****************************************************************
000927210908      *
000928210908     C     ChkSysValue   BEGSR
000929210908      *
000930210908      ** Check for system values
000931210908     C                   EVAL      @RTCD = *BLANKS
000932210908     C                   EVAL      P@OP01 = PSysVal1
000933210908     C                   EVAL      P@OP02 = PSysVal2
000934210908     C                   EVAL      P@OP03 = PSysVal3
000935210908     C                   EVAL      P@OP04 = PSysVal4
000936210908     C                   EVAL      P@OP05 = PSysVal5
000937210908     C                   EVAL      P@OP06 = PSysVal6
000938210908     C                   EVAL      P@OP07 = PSysVal7
000939210908     C                   EVAL      P@OP08 = PSysVal8
000940210908     C                   EVAL      P@OP09 = PSysVal9
000941210908      *
000942210908     C                   CALL      'AOSVALR0'
000943210908     C                   PARM                    @RTCD             7
000944210908     C                   PARM                    P@OP01
000945210908     C                   PARM      *BLANKS       P@VL01
000946210908     C                   PARM                    P@OP02
000947210908     C                   PARM      *BLANKS       P@VL02
000948210908     C                   PARM                    P@OP03
000949210908     C                   PARM      *BLANKS       P@VL03
000950210908     C                   PARM                    P@OP04
000951210908     C                   PARM      *BLANKS       P@VL04
000952210908     C                   PARM                    P@OP05
000953210908     C                   PARM      *BLANKS       P@VL05
000954210908     C                   PARM                    P@OP06
000955210908     C                   PARM      *BLANKS       P@VL06
000956210908     C                   PARM                    P@OP07
000957210908     C                   PARM      *BLANKS       P@VL07
000958210908     C                   PARM                    P@OP08
000959210908     C                   PARM      *BLANKS       P@VL08
000960210908     C                   PARM                    P@OP09
000961210908     C                   PARM      *BLANKS       P@VL09
000962210908     C                   PARM      *BLANKS       P@OP10
000963210908     C                   PARM      *BLANKS       P@VL10
000964210908
000965210908      ** Setup work fields
000966210908      * Set PRecFmt  = P@VL01
000967210908      * Set PCorpEnt = P@VL02
000968210908      * Set PBranch  = P@VL03
000969210908      * Set PSystem  = P@VL04
000970210908      * Set PConstS  = P@VL05
000971210908      * Set PConst20 = P@VL06
000972210908      * Set PConstCY = P@VL07
000973210908      * Set PConstCP = P@VL08
000974210908      * Set PCompany = P@VL09
000975210908      *
000976210908     C                   EVAL      PRecFmt = *BLANKS
000977210908     C                   EVAL      PCorpEnt = *BLANKS
000978210908     C                   EVAL      PBranch = *BLANKS
000979210908     C                   EVAL      PSystem = *BLANKS
000980210908     C                   EVAL      PConstS = *BLANKS
000981210908     C                   EVAL      PConst20 = *BLANKS
000982210908     C                   EVAL      PConstCY = *BLANKS
000983210908     C                   EVAL      PConstCP = *BLANKS
000984210908     C                   EVAL      PCompany = *BLANKS
000985210908      *
000986210908     C                   IF        @RTCD = *BLANKS
000987210908     C                   EVAL      PRecFmt = P@VL01
000988210908     C                   EVAL      PCorpEnt = P@VL02
000989210908     C                   EVAL      PBranch = P@VL03
000990210908     C                   EVAL      PSystem = P@VL04
000991210908     C                   EVAL      PConstS = P@VL05
000992210908     C                   EVAL      PConst20 = P@VL06
000993210908     C                   EVAL      PConstCY = P@VL07
000994210908     C                   EVAL      PConstCP = P@VL08
000995210908     C                   EVAL      PCompany = P@VL09
000996210908     C                   ENDIF
000997210908      *
000998210908     C                   ENDSR
000999210908      *
001000210908      *****************************************************************
001001210908      /EJECT
001002210908      *****************************************************************
001003210908      *                                                               *
001004210908      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
001005210908      *                                                               *
001006210908      *****************************************************************
001007210908
001008210908     C     SRZDate9      BEGSR
001009210908
001010210908     C                   CALLB     'ZDATE9'
001011210908     C                   PARM                    PDayNoIn
001012210908     C                   PARM      *ZERO         PDateOutZ9
001013210908     C                   PARM                    PRetCodeZ9
001014210908
001015210908     C                   ENDSR
001016210908
001017210908      *****************************************************************
001018210908      ** SRCvtDate - Convert date from YYYYMMDD to DDMMYY (or MMDDYY) *
001019210908      *****************************************************************
001020210908     C     SRCvtDate     BEGSR
001021210908
001022210908     C                   CALLB     'ZA0770'
001023210908     C                   PARM      *BLANK        ReturnCode        7
001024210908     C                   PARM                    @DATE             8 0
001025210908     C                   PARM                    BJDFIN
001026210908     C                   PARM      *ZERO         PDateOut
001027210908
001028210908     C                   ENDSR
001029210908      *****************************************************************
001030210908      /Title SR/*PSSR
001031210908      *****************************************************************
001032210908      *                                                               *
001033210908      *  *PSSR  - Program Error Processing Subroutine.                *
001034210908      *                                                               *
001035210908      *  Called By: Various                                           *
001036210908      *                                                               *
001037210908      *****************************************************************
001038210908      *
001039210908     C     *PSSR         BegSR                                                  *** *PSSR  ***
001040210908      *
001041210908      ***  Check to see that *PSSR has not already been called.
001042210908     C                   If        WRUN = *BLANK
001043210908     C                   Move      'Y'           WRUN              1
001044210908     C                   MoveL     'XX005002'    DBPGM
001045210908      *
001046210908     C     *DTAARA       Define    LDA           WLDA            256
001047210908     C     *Lock         In        WLDA
001048210908     C                   MoveL     DBERR         WLDA
001049210908     C                   Out       WLDA
001050210908     C                   SetOn                                        U7U8LR
001051210908      *
001052210908     C                   Dump
001053210908     C                   EndIf
001054210908      *
001055210908      ** Exit program
001056210908     C                   Return
001057210908      *
001058210908     C                   EndSR
001059210908      *
001060210908      *****************************************************************
001061210908      ***
001062210908**  CPY@
001063210908(c) Finastra Ltd 2021
