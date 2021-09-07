000100210907                                             H DEBUG
000101210907     H
000102210907      *****************************************************************
000103210907/*STD *  RPGBASEMOD                                                   *
000104210907/*EXI *  TEXT('Midas XX GLM Feeder Files Generation')                 *
000105210907      *****************************************************************
000106210907      *                                                               *
000107210907      *  Midas - General Ledger Module                                *
000108210907      *                                                               *
000109210907      *  XX005003 - Midas XX GLM Feeder Files Generation              *
000110210907      *                                                               *
000111210907      *  Function: Extract posting details                            *
000112210907      *                                                               *
000113210907      *  Called by: XXC005002 - Midas XX GLM/EDW Extract file Gen.    *
000114210907      *                                                               *
000115210907      *  (c) Finastra International Limited 2021                      *
000116210907      *                                                               *
000117210907      *  Last Amend No. DRI005  *CREATE    Date 13Apr21               *
000118210907      *                                                               *
000119210907      *---------------------------------------------------------------*
000120210907      *                                                               *
000121210907      *  DRI005 - HO and EDW Extracts                                 *
000122210907      *                                                               *
000123210907      *****************************************************************
000124210907      *
000125210907     FXXAPOSL0  IF   E           K Disk    InfSR(*PSSR)
000126210907      *
000127210907     FXXACHOML0 IF   E           K Disk    InfSR(*PSSR)
000128210907      *
000129210907     FXXFEEDHTD O    E           K Disk    InfSR(*PSSR)
000130210907      *
000131210907     FXXFEEDCTD O    E           K Disk    InfSR(*PSSR)
000132210907      *
000133210907     FXXFEEDDTD O    E           K Disk    InfSR(*PSSR)
000134210907      *
000135210907      /Title Function of indicators
000136210907     F*****************************************************************
000137210907     F*                                                               *
000138210907     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
000139210907     F*                                                               *
000140210907     F*                                                               *
000141210907     F*  90-99 - Used by Standard Subroutines                         *
000142210907     F*                                                               *
000143210907     F*  U7+U8 - Database Error                                       *
000144210907     F*                                                               *
000145210907     F*****************************************************************
000146210907      /Title Subroutine Index
000147210907     F*****************************************************************
000148210907     F*                                                               *
000149210907     F*  S U B R O U T I N E   I N D E X                              *
000150210907     F*                                                               *
000151210907     F*  Init      - Initial Processing                               *
000152210907     F*  Proces    - Main processing                                  *
000153210907     F*  Extract   - Main Extract Processing                          *
000154210907     F*  ExtDet    - Details Record                                   *
000155210907     F*  ExtCtl    - Control Record                                   *
000156210907     F*  ExtHed    - Header Record                                    *
000157210907     F*  ChkSysValue - Retrieve system values                         *
000158210907     F*  SRZDate9  - Date format                                      *
000159210907     F*  SRCvtDate - Convert date format                              *
000160210907     F*                                                               *
000161210907     F*  *PSSR     - Program error handling routine                   *
000162210907     F*                                                               *
000163210907     F*****************************************************************
000164210907     D/Title D-Specifications
000165210907     D CPY@            S             80    Dim(1) CTData PerRCD(1)
000166210907      ***  Array for Object Copyright Statement.
000167210907      *
000168210907     D SDBRCH        E DS                  ExtName(SDBRCHPD)
000169210907      ** Branch Details
000170210907      *
000171210907     D SDBANK        E DS                  ExtName(SDBANKPD)
000172210907      ** Bank Details
000173210907      *
000174210907     D DSSDY         E DS                  ExtName(DSSDY)
000175210907      ** Second DS For Access Programs, Long Data Structure
000176210907      *
000177210907     D DBERR           DS           256
000178210907      * Data structure for data-base error processing
000179210907     D  DBFILE               134    141
000180210907     D  DBKEY                142    170
000181210907     D  DBPGM                171    180
000182210907     D  DBASE                181    183  0
000183210907      *
000184210907     D                 DS
000185210907
000186210907     D RUNDAT          DS
000187210907      * Data structure for rundate flags
000188210907     D  RUNA                   1      7
000189210907     D  @DLUP                  1      2  0
000190210907     D  @MLUP                  3      5
000191210907     D  @YLUP                  6      7  0
000192210907     D  RUND                   8     10P 0
000193210907     D  @MBIN                 13     13
000194210907      *
000195210907     DSDDTA            DS
000196210907     D SDDATA                  1    256
000197210907     D SPREFX                  6      7
000198210907      *
000199210907     D P@OP01          S             20A
000200210907     D P@VL01          S            200A
000201210907     D P@OP02          S             20A
000202210907     D P@VL02          S            200A
000203210907     D P@OP03          S             20A
000204210907     D P@VL03          S            200A
000205210907     D P@OP04          S             20A
000206210907     D P@VL04          S            200A
000207210907     D P@OP05          S             20A
000208210907     D P@VL05          S            200A
000209210907     D P@OP06          S             20A
000210210907     D P@VL06          S            200A
000211210907     D P@OP07          S             20A
000212210907     D P@VL07          S            200A
000213210907     D P@OP08          S             20A
000214210907     D P@VL08          S            200A
000215210907     D P@OP09          S             20A
000216210907     D P@VL09          S            200A
000217210907     D P@OP10          S             20A
000218210907     D P@VL10          S            200A
000219210907      *
000220210907     D PSysVal1        C                   CONST('VLJRecordFormat')
000221210907     D PSysVal2        C                   CONST('VLJCorpEntityCode')
000222210907     D PSysVal3        C                   CONST('VLJBranchCode')
000223210907     D PSysVal4        C                   CONST('VLJSystem')
000224210907     D PSysVal5        C                   CONST('VLJConstantS')
000225210907     D PSysVal6        C                   CONST('VLJConstant20')
000226210907     D PSysVal7        C                   CONST('VLJConstantCY')
000227210907     D PSysVal8        C                   CONST('VLJConstantCP')
000228210907     D PSysVal9        C                   CONST('VLJCompany')
000229210907
000230210907     D CDesBal1        C                   CONST('SUMMARIZED ')
000231210907     D CDesBal2        C                   CONST(' FROM MIDAS FOR BRN ')
000232210907
000233210907     D PDesBal         DS
000234210907     D  PDesBal1               1     11
000235210907     D  PDesBal2              12     14
000236210907     D  PDesBal3              15     34
000237210907     D  PDesBal4              35     37
000238210907     D  PDesBal5              38     45
000239210907
000240210907     D PRecFmt         S              3A
000241210907     D PCorpEnt        S              5A
000242210907     D PBranch         S              3A
000243210907     D PSystem         S              3A
000244210907     D PConstS         S              1A
000245210907     D PConst20        S              2A
000246210907     D PConstCY        S              2A
000247210907     D PConstCP        S              2A
000248210907     D PCompany        S              3A
000249210907
000250210907     D PDateOut        S              6  0
000251210907
000252210907      ** Parameters for ZBKDT
000253210907     D WCurr_RunDay    S              5  0 Inz
000254210907     D WNext_WrkDay    S              5  0 Inz
000255210907     D WPrev_WrkDay    S              5  0 Inz
000256210907     D WDayNo          S              5  0 Inz
000257210907     D WCcy            S              3    Inz
000258210907     D WLoc            S              3    Inz
000259210907     D WDays           S              2  0 Inz
000260210907      *
000261210907      ** Parameters for ZDATE9
000262210907     D PDaynoIn        S              5P 0
000263210907     D PDateOutZ9      S              8S 0
000264210907     D PRetCodeZ9      S              1  0
000265210907
000266210907      ** YYYYMMDD date format of Rundate
000267210907     D DSRNDDate       DS
000268210907     D  WVYYR                  1      4  0
000269210907     D  WVY2R                  3      4  0
000270210907     D  WVMMR                  5      6  0
000271210907     D  WVDDR                  7      8  0
000272210907     D  WVRND                  1      8  0
000273210907
000274210907      ** YYYYMMDD date format of Posting date
000275210907     D DSPSTDate       DS
000276210907     D  WVYYP                  1      4  0
000277210907     D  WVMMP                  5      6  0
000278210907     D  WVDDP                  7      8  0
000279210907     D  WVPST                  1      8  0
000280210907
000281210907      ** YYYYMMDD date format of Value date
000282210907     D DSVLDDate       DS
000283210907     D  WVYYV                  1      4  0
000284210907     D  WVMMV                  5      6  0
000285210907     D  WVDDV                  7      8  0
000286210907     D  WVALD                  1      8  0
000287210907
000288210907      ** DDMMYY date format of Value date
000289210907     D DSVLDDat1       DS
000290210907     D  WVDDV1                 1      2
000291210907     D  WVMMV1                 3      4
000292210907     D  WVYYV1                 5      6
000293210907
000294210907      ** YYMMDD date format of Rundate
000295210907     D DSDayDate       DS
000296210907     D  WVY2D                  1      2  0
000297210907     D  WVMMD                  3      4  0
000298210907     D  WVDDD                  5      6  0
000299210907
000300210907      ** YYYYMMDD date format of Previous Working Date
000301210907     D DSPWDDate       DS
000302210907     D  PWDYY                  1      4  0
000303210907     D  PWDY2                  3      4  0
000304210907     D  PWDMM                  5      6  0
000305210907     D  PWDDD                  7      8  0
000306210907     D  PWRND                  1      8  0
000307210907
000308210907      ** DS For Journal ID
000309210907     D DSJRNID         DS
000310210907     D  DJRNI1                 1      3
000311210907     D  DJRNI2                 4      6
000312210907     D  DJRNI3                 7      9
000313210907     D  DJRNI4                10     10
000314210907      *
000315210907      ** DS For GLMCP
000316210907     D DSGLMCP         DS
000317210907     D  DGLMC1                 1      3
000318210907     D  DGLMC2                 4      7
000319210907     D  DGLMC3                 8     12
000320210907     D  DGLMC4                13     16
000321210907     D  DGLMC5                17     19
000322210907     D  DGLMC6                20     44
000323210907      *
000324210907      ** DS For Source
000325210907     D DSSRCE          DS
000326210907     D  DSRC1                  1      3
000327210907     D  DSRC2                  4      4
000328210907     D  DSRC3                  5     10
000329210907      *
000330210907      ** DS For Journal Description
000331210907     D DSJRND          DS
000332210907     D  DJRND1                 1     30
000333210907     D  DJRND2                31     49
000334210907     D  DJRND3                50     51
000335210907     D  DJRND4                52     53
000336210907     D  DJRND5                54     57
000337210907     D  DJRND6                58     65
000338210907     D  DJRN61                58     59
000339210907     D  DJRN62                60     65
000340210907     D  DJRND7                66     67
000341210907     D  DJRND8                68     73
000342210907     D  DJRND9                74     75
000343210907      *
000344210907     D DSJRNS          DS
000345210907     D  DJRNS1                 1      2
000346210907     D  DJRNS2                 3      4
000347210907     D  DJRNS3                 5      5
000348210907      *
000349210907
000350210907     C/Title Main Processing
000351210907      *================================================================
000352210907      *  P R O G R A M     S T A R T                                  *
000353210907      *================================================================
000354210907      *
000355210907      * Perform Initialisation.
000356210907     C                   ExSR      Init
000357210907      *
000358210907      * Perform Main Processing.
000359210907     C                   ExSR      Process
000360210907      *
000361210907     C                   SetOn                                        LR
000362210907     C                   Return
000363210907      *================================================================
000364210907      *  P R O G R A M     E N D                                      *
000365210907      *================================================================
000366210907      /Title SR/Init
000367210907      *****************************************************************
000368210907      *                                                               *
000369210907      *  Init   - Subroutine to do Program Initialisation.            *
000370210907      *                                                               *
000371210907      *  Called By: Main Processing                                   *
000372210907      *  Calls    : None                                              *
000373210907      *                                                               *
000374210907      *****************************************************************
000375210907      *
000376210907     C     Init          BegSR
000377210907      *
000378210907      ***  Copyright Statement.
000379210907     C                   MoveA     CPY@          BIS@             80
000380210907      *
000381210907     C                   EVAL      WCurr_RunDay = 0
000382210907     C                   EVAL      WPrev_WrkDay = 0
000383210907     C                   EVAL      WNext_WrkDay = 0
000384210907      *
000385210907      ** Access Bank Details
000386210907     C                   Call      'AOBANKR0'
000387210907     C                   Parm      '*MSG   '     WRTCD             7
000388210907     C                   Parm      '*FIRST '     WOPTN             7
000389210907     C     SDBANK        Parm      SDBANK        DSSDY
000390210907      *
000391210907     C     WRTCD         IfNE      *BLANKS
000392210907     C                   Z-Add     001           DBASE                          ***************
000393210907     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
000394210907     C                   Move      *Blanks       DBKEY                          ***************
000395210907     C                   ExSR      *PSSR
000396210907     C                   Else
000397210907     C                   EVAL      WCurr_RunDay = BJRDNB
000398210907     C                   EVAL      WNext_WrkDay = BJDNWD
000399210907     C                   End
000400210907      *
000401210907      ** Retrieve Previous Working Day
000402210907
000403210907     C                   CALL      'ZBKDT'
000404210907     C                   PARM      WCurr_RunDay  WDayNo
000405210907     C                   PARM      BJLCCY        WCcy
000406210907     C                   PARM      BJSLCD        WLoc
000407210907     C                   PARM      BJBVPD        WDays
000408210907     C                   PARM      *Zero         WPrev_WrkDay
000409210907      *
000410210907      ***  Check System Date Format, DDMMYY (*IN98 off)
000411210907      ***                            MMDDYY (*IN98 on).
000412210907      *
000413210907     C                   If        BJDFIN = 'M'
000414210907     C                   SetOn                                        98
000415210907     C                   EndIf
000416210907      *
000417210907     C** Get system prefix from SDSTAT
000418210907     C     *DTAARA       Define    SDSTAT        SDDTA
000419210907     C                   In        SDDTA
000420210907      *
000421210907     C** Get RUNDAT to access MULTI-BRANCHING flag
000422210907     C     *DTAARA       Define                  RUNDAT
000423210907     C                   In        RUNDAT
000424210907      *
000425210907     C                   Z-ADD     BJRDNB        PDaynoIn
000426210907     C                   EXSR      SRZDate9
000427210907     C                   MOVE      PDateOutZ9    DSRndDate
000428210907      *
000429210907     C                   Z-ADD     WPrev_WrkDay  PDaynoIn
000430210907     C                   EXSR      SRZDate9
000431210907     C                   MOVE      PDateOutZ9    DSPWDDate
000432210907      *
000433210907     C                   MOVE      WVY2R         WVY2D
000434210907     C                   MOVE      WVMMR         WVMMD
000435210907     C                   MOVE      WVDDR         WVDDD
000436210907     C                   MOVE      DSDayDate     DayDate           6
000437210907      *
000438210907      ** Retrieve system values details
000439210907     C                   EXSR      ChkSysValue
000440210907      *
000441210907     C                   Move      *BLANKS       WKCCY             3
000442210907     C                   Movel     *BLANKS       WKACOD           10
000443210907      *
000444210907     C                   EndSR
000445210907      *****************************************************************
000446210907      /Title SR/Process
000447210907      *****************************************************************
000448210907      *                                                               *
000449210907      *  Process - Subroutine to do the Detail Processing.            *
000450210907      *                                                               *
000451210907      *  Called By: Main Processing                                   *
000452210907      *  Calls:                                                       *
000453210907      *                                                               *
000454210907      *****************************************************************
000455210907      *
000456210907     C     Process       BegSR
000457210907      *
000458210907     C                   Z-ADD     BJRDNB        KDAYL             5 0
000459210907      *
000460210907      ***  Read the Posting file APOSTPD for the rundate
000461210907      *** Ordered by CCY
000462210907     C     *LOVAL        Setll     XXAPOSL0
000463210907     C                   READ      XXAPOSL0                               50
000464210907      *
000465210907      * Get Branch Details
000466210907      *
000467210907     C                   CALL      'AOBRCHR1'
000468210907     C                   PARM      *BLANKS       WRTCD
000469210907     C                   PARM      '*KEY   '     WOPTN
000470210907     C                   PARM      BRCA          WBRCA             3
000471210907     C     SDBRCH        PARM      SDBRCH        DSSDY
000472210907      *
000473210907      ***  Process all postings for the day
000474210907      *
000475210907     C                   Dow       *In50 = '0'
000476210907      *
000477210907      ***  Read the Account Code HO Details file
000478210907     C                   Z-ADD     ACOD          KACOD            10 0
000479210907     C     KACOD         Chain     XXACHOML0                          90
000480210907      *
000481210907     C                   If        *In90 = '0' AND XXMEXCL = 'N'
000482210907     C                             OR *IN90 = '1'
000483210907      *
000484210907      ** Extract postings details
000485210907     C                   EXSR      EXTRACT
000486210907     C                   READ      XXAPOSL0                               50
000487210907      *
000488210907     C                   Else
000489210907     C                   If        *In90 = '0' AND XXMEXCL = 'Y'
000490210907     C                   Read      XXAPOSL0                               50
000491210907     C                   ENDIF
000492210907      *
000493210907     C                   Endif
000494210907      *
000495210907      ***  End of Do While Not End of File.
000496210907     C                   EndDo
000497210907      *
000498210907     C                   EXSR      EXTCTL
000499210907      *
000500210907      ** Write Feeder Header record
000501210907     C                   EXSR      EXTHED
000502210907      *
000503210907     C                   EndSR
000504210907      *
000505210907      *****************************************************************
000506210907      *                                                               *
000507210907      * EXTRACT - Extract postings process                            *
000508210907      *                                                               *
000509210907      * Called by: Main Processing                                    *
000510210907      *                                                               *
000511210907      * Calls:                                                        *
000512210907      *                                                               *
000513210907      *****************************************************************
000514210907      *
000515210907     C     EXTRACT       BEGSR
000516210907      *
000517210907      ** split posting date
000518210907     C                   Z-ADD     PSTD          PDaynoIn
000519210907     C                   EXSR      SRZDate9
000520210907     C                   MOVE      PDateOutZ9    DSPSTDate
000521210907      *
000522210907      ** split value date
000523210907     C                   Z-ADD     VALD          PDaynoIn
000524210907     C                   EXSR      SRZDate9
000525210907     C                   MOVE      PDateOutZ9    DSVLDDate
000526210907      *
000527210907      ** Extract posting
000528210907      *
000529210907     C                   If        PSTD = BJRDNB and PSTD = VALD
000530210907     C                             OR PSTD = BJRDNB and WVMMP = WVMMV
000531210907     C                             OR PSTD = BJRDNB and WVMMP > WVMMV and
000532210907     C                                WVYYP = WVYYV
000533210907     C                             OR PSTD = BJRDNB and PSTD > VALD and
000534210907     C                                WVYYP <> WVYYV and WVMMP < WVMMV
000535210907     C                             OR PSTD = WPrev_WrkDay and WVMMP > WVMMV and
000536210907     C                                WVYYP <> WVYYV
000537210907     C                             OR PSTD = WPrev_WrkDay and WVMMP < WVMMV and
000538210907     C                                WVYYP = WVYYV
000539210907      *
000540210907      ** Process Details record format
000541210907     C                   If        CCY = WKCCY OR WKCCY = *BLANKS
000542210907     C                   EXSR      EXTDET
000543210907      *
000544210907      ** Process Control and Details rec format
000545210907     C                   Else
000546210907     C                   If        CCY <> WKCCY
000547210907     C                   EXSR      EXTCTL
000548210907     C                   EXSR      EXTDET
000549210907     C                   ENDIF
000550210907      *
000551210907     C                   ENDIF
000552210907      *
000553210907     C                   ENDIF
000554210907      *
000555210907     C                   ENDSR
000556210907      *
000557210907      *****************************************************************
000558210907      *                                                               *
000559210907      * EXTDET - Write Feeder Details Record                          *
000560210907      *                                                               *
000561210907      * Called by: Main Processing                                    *
000562210907      *                                                               *
000563210907      * Calls:                                                        *
000564210907      *                                                               *
000565210907      *****************************************************************
000566210907      *
000567210907     C     EXTDET        BEGSR
000568210907      *
000569210907     C     SPOS          IFNE      '  GE-XB'
000570210907      *
000571210907     C                   CLEAR                   XXFEEDDD0
000572210907      ** Ccy
000573210907     C                   MOVEL     CCY           WKCCY
000574210907      ** Acount Code
000575210907     C                   MOVEL     ACOD          WKACOD
000576210907      ** Record Format
000577210907     C                   MOVEL     'VLJ'         XXDDBID
000578210907      ** Corporate Entity
000579210907     C                   MOVEL     PCorpEnt      XXDVJCC
000580210907      ** Journal ID
000581210907     C                   MOVEL     PBranch       DJRNI1
000582210907     C                   MOVEL     PSystem       DJRNI2
000583210907     C                   MOVEL     CCY           DJRNI3
000584210907     C                   MOVEL     '0'           DJRNI4
000585210907     C                   MOVEL     DSJRNID       XXDJRNID
000586210907      ** Effective Date
000587210907     C                   MOVE      DSRndDate     XXDEFFD
000588210907      ** Journal Seq
000589210907     C                   MOVE      WVMMR         DJRNS1
000590210907     C                   MOVE      WVDDR         DJRNS2
000591210907     C                   MOVE      '0'           DJRNS3
000592210907     C                   MOVE      DSJRNS        XXDJRNSQ
000593210907      ** GLM Account to Post to
000594210907     C                   MOVE      PBranch       DGLMC1
000595210907     C                   MOVE      *BLANKS       DGLMC2
000596210907     C                   If        *IN90 = '0'
000597210907     C                   MOVE      XXMHOAC       DGLMC3
000598210907     C                   MOVE      XXMHOPC       DGLMC4
000599210907     C                   MOVE      XXMHOMC       DGLMC5
000600210907     C                   ELSE
000601210907     C                   MOVE      *BLANKS       DGLMC3
000602210907     C                   MOVE      *BLANKS       DGLMC4
000603210907     C                   MOVE      *BLANKS       DGLMC5
000604210907     C                   ENDIF
000605210907     C                   MOVE      *BLANKS       DGLMC6
000606210907     C                   MOVE      DSGLMCP       XXDGLMCP
000607210907      ** CCY
000608210907     C                   MOVE      CCY           XXDCCYL
000609210907      ** Account Code
000610210907     C                   MOVEL     ACOD          XXDACOD
000611210907      ** Rundate
000612210907     C                   Z-ADD     BJRDNB        XXDRND
000613210907      ** Constant S
000614210907     C                   MOVE      PConstS       XXDCSTS
000615210907      ** Subledger ID
000616210907     C                   MOVE      *BLANKS       XXDSLID
000617210907      ** Subledger Account
000618210907     C                   MOVE      *BLANKS       XXDSLAC
000619210907      ** Source
000620210907     C                   MOVE      BRCA          DSRC1
000621210907     C                   MOVE      *BLANKS       DSRC2
000622210907     C** Convert Date Format from YYYYMMDD to DDMMYY
000623210907     C                   MOVE      WVYYV         WVYYV1
000624210907     C                   MOVE      WVMMV         WVMMV1
000625210907     C                   MOVE      WVDDV         WVDDV1
000626210907     C                   MOVE      DSVLDDat1     DSRC3
000627210907     C                   MOVE      DSSRCE        XXDSRCE
000628210907      ** Journal Description
000629210907     C                   MOVEL     PNAR          DJRND1
000630210907     C                   MOVE      *BLANKS       DJRND2
000631210907     C                   MOVEL     OTTP          DJRND3
000632210907     C                   MOVEL     OTST          DJRND4
000633210907     C                   MOVEL     ACOD          DJRND5
000634210907     C                   If        GETP = 'D'
000635210907     C                   MOVEL     'DL'          DJRN61
000636210907     C                   MOVEL     OTRF          DJRN62
000637210907     C                   Else
000638210907     C                   If        GETP = 'U'
000639210907     C                   MOVEL     'LE'          DJRN61
000640210907     C                   MOVEL     OTRF          DJRN62
000641210907     C                   Else
000642210907     C                   MOVEL     OTRF          DJRND6
000643210907     C                   ENDIF
000644210907     C                   ENDIF
000645210907     C                   MOVE      *BLANKS       DJRND7
000646210907     C                   MOVE      ASOC          DJRND8
000647210907     C                   MOVE      PConst20      DJRND9
000648210907     C                   MOVE      DSJRND        XXDJRND
000649210907      ** Constant CY
000650210907     C                   MOVE      PConstCY      XXDCSTCY
000651210907      ** Constant CP
000652210907     C                   MOVE      PConstCP      XXDCSTCP
000653210907      ** DR/CR Indicator
000654210907     C                   If        DRCR = 0
000655210907     C                   MOVE      'D'           XXDDRCR
000656210907     C                   Else
000657210907     C                   MOVE      'C'           XXDDRCR
000658210907     C                   ENDIF
000659210907      ** Local Book Equivalent
000660210907     C                   MOVE      *ALL'0'       XXDLCBE
000661210907      ** Posting Amount
000662210907     C                   Z-ADD     PSTA          XXDPSTA
000663210907      ** Rate
000664210907     C                   MOVE      *BLANKS       XXDRATE
000665210907      *
000666210907      ** Add up details for Header and Control Format
000667210907      *
000668210907      ** VLJ Total Debit/Credit Posting and No records
000669210907     C                   If        DRCR = 0
000670210907     C                   Add       PSTA          WXCTAMTD
000671210907     C                   Add       1             WXHTVLJD          8 0
000672210907     C                   Add       PSTA          WXHTOTD          19 0
000673210907     C                   Else
000674210907     C                   Add       PSTA          WXCTAMTC
000675210907     C                   Add       1             WXHTVLJC          8 0
000676210907     C                   Add       PSTA          WXHTOTC          19 0
000677210907     C                   ENDIF
000678210907      ** Total VLJ Records
000679210907     C                   Add       1             WXHTTVLJ          8 0
000680210907      *
000681210907      ** Write record to XXFEEDDTD
000682210907     C                   WRITE     XXFEEDDD0
000683210907      *
000684210907     C                   ENDIF
000685210907      *
000686210907     C                   ENDSR
000687210907      *
000688210907      *****************************************************************
000689210907      *                                                               *
000690210907      * EXTCTL - Write Feeder Control Record                          *
000691210907      *                                                               *
000692210907      * Called by: Main Processing                                    *
000693210907      *                                                               *
000694210907      * Calls:                                                        *
000695210907      *                                                               *
000696210907      *****************************************************************
000697210907      *
000698210907     C     EXTCTL        BEGSR
000699210907      *
000700210907      ** Calculate Balance and write Details record in case DR <> CR
000701210907     C                   If        WXCTAMTC <> WXCTAMTD
000702210907      ** if not balanced, need to write Balancing entry
000703210907      *
000704210907     C                   If        WXCTAMTC < WXCTAMTD
000705210907     C     WXCTAMTD      SUB       WXCTAMTC      WKBALNC          19 0
000706210907     C                   Else
000707210907     C     WXCTAMTC      SUB       WXCTAMTD      WKBALNC
000708210907     C                   ENDIF
000709210907      *
000710210907     C                   CLEAR                   XXFEEDDD0
000711210907      ** Record Format
000712210907     C                   MOVEL     'VLJ'         XXDDBID
000713210907      ** Corporate Entity
000714210907     C                   MOVEL     PCorpEnt      XXDVJCC
000715210907      ** Journal ID
000716210907     C                   MOVEL     PBranch       DJRNI1
000717210907     C                   MOVEL     PSystem       DJRNI2
000718210907     C                   MOVEL     WKCCY         DJRNI3
000719210907     C                   MOVEL     '0'           DJRNI4
000720210907     C                   MOVEL     DSJRNID       XXDJRNID
000721210907      ** Effective Date
000722210907     C                   MOVE      DSRndDate     XXDEFFD
000723210907      ** Journal Seq
000724210907     C                   MOVE      WVMMR         DJRNS1
000725210907     C                   MOVE      WVDDR         DJRNS2
000726210907     C                   MOVE      '0'           DJRNS3
000727210907     C                   MOVE      DSJRNS        XXDJRNSQ
000728210907      ** GLM Account to Post to
000729210907     C                   MOVE      PBranch       DGLMC1
000730210907     C                   MOVE      *BLANKS       DGLMC2
000731210907     C                   If        *IN90 = '0'
000732210907     C                   MOVE      XXMHOAC       DGLMC3
000733210907     C                   MOVE      XXMHOPC       DGLMC4
000734210907     C                   MOVE      XXMHOMC       DGLMC5
000735210907     C                   ELSE
000736210907     C                   MOVE      *BLANKS       DGLMC3
000737210907     C                   MOVE      *BLANKS       DGLMC4
000738210907     C                   MOVE      *BLANKS       DGLMC5
000739210907     C                   ENDIF
000740210907     C                   MOVE      *BLANKS       DGLMC6
000741210907     C                   MOVE      DSGLMCP       XXDGLMCP
000742210907      ** CCY
000743210907     C                   MOVE      WKCCY         XXDCCYL
000744210907      ** Account Code
000745210907     C                   MOVEL     WKACOD        XXDACOD
000746210907      ** Rundate
000747210907     C                   Z-ADD     BJRDNB        XXDRND
000748210907      ** Constant S
000749210907     C                   MOVE      PConstS       XXDCSTS
000750210907      ** Subledger ID
000751210907     C                   MOVE      *BLANKS       XXDSLID
000752210907      ** Subledger Account
000753210907     C                   MOVE      *BLANKS       XXDSLAC
000754210907      ** Source
000755210907     C                   MOVE      BRCA          DSRC1
000756210907     C                   MOVE      *BLANKS       DSRC2
000757210907     C** Convert Date Format from YYYYMMDD to DDMMYY
000758210907     C                   MOVE      WVYYV         WVYYV1
000759210907     C                   MOVE      WVMMV         WVMMV1
000760210907     C                   MOVE      WVDDV         WVDDV1
000761210907     C                   MOVE      DSVLDDat1     DSRC3
000762210907     C                   MOVE      DSSRCE        XXDSRCE
000763210907      ** Journal Description
000764210907     C                   MOVE      CDesBal1      PDesBal1
000765210907     C                   MOVE      WKCCY         PDesBal2
000766210907     C                   MOVE      CDesBal2      PDesBal3
000767210907     C                   MOVE      PBranch       PDesBal4
000768210907     C                   MOVE      DSVLDDate     PDesBal5
000769210907     C                   MOVE      PDesBal       DJRND1
000770210907     C                   MOVE      *BLANKS       DJRND2
000771210907     C                   MOVEL     *BLANKS       DJRND3
000772210907     C                   MOVEL     *BLANKS       DJRND4
000773210907     C                   MOVEL     *BLANKS       DJRND5
000774210907     C                   MOVEL     *BLANKS       DJRND6
000775210907     C                   MOVEL     *BLANKS       DJRND7
000776210907     C                   MOVE      A8BICN        DJRND8
000777210907     C                   MOVE      PConst20      DJRND9
000778210907     C                   MOVE      DSJRND        XXDJRND
000779210907      ** Constant CY
000780210907     C                   MOVE      PConstCY      XXDCSTCY
000781210907      ** Constant CP
000782210907     C                   MOVE      PConstCP      XXDCSTCP
000783210907      ** DR/CR Indicator
000784210907     C                   If        WXCTAMTC > WXCTAMTD
000785210907     C                   MOVE      'D'           XXDDRCR
000786210907     C                   Else
000787210907     C                   MOVE      'C'           XXDDRCR
000788210907     C                   ENDIF
000789210907      ** Local Book Equivalent
000790210907     C                   MOVE      *ALL'0'       XXDLCBE
000791210907      ** Posting Amount
000792210907     C                   Z-ADD     WKBALNC       XXDPSTA
000793210907      ** Rate
000794210907     C                   MOVE      *BLANKS       XXDRATE
000795210907      *
000796210907      ** Add up details for Header and Control Format
000797210907      *
000798210907      ** VLJ Total Debit/Credit Posting and No records
000799210907     C                   If        WXCTAMTC > WXCTAMTD
000800210907     C                   Add       PSTA          WXCTAMTD
000801210907     C                   Add       1             WXHTVLJD
000802210907     C                   Add       PSTA          WXHTOTD
000803210907     C                   Else
000804210907     C                   Add       PSTA          WXCTAMTC
000805210907     C                   Add       1             WXHTVLJC
000806210907     C                   Add       PSTA          WXHTOTC
000807210907     C                   ENDIF
000808210907      ** Total VLJ Records
000809210907     C                   Add       1             WXHTTVLJ
000810210907      *
000811210907      ** Write record to XXFEEDDTD
000812210907     C                   WRITE     XXFEEDDD0
000813210907      *
000814210907      ** CONTROL RECORD FORMAT
000815210907      *
000816210907      ** Record Format
000817210907     C                   MOVE      'VJC'         XXCDBID
000818210907      ** Corporate Entity
000819210907     C                   MOVEL     PCorpEnt      XXCVJCC
000820210907      ** Journal ID
000821210907     C                   MOVEL     PBranch       DJRNI1
000822210907     C                   MOVEL     PSystem       DJRNI2
000823210907     C                   MOVEL     WKCCY         DJRNI3
000824210907     C                   MOVEL     '0'           DJRNI4
000825210907     C                   MOVEL     DSJRNID       XXCJRNID
000826210907      ** Effective Date
000827210907     C                   MOVE      DSRndDate     XXCEFFD
000828210907      ** Journal Seq
000829210907     C                   MOVE      DSJRNS        XXCJRNSQ
000830210907      ** Constant CY
000831210907     C                   MOVE      PConstCY      XXCCSTCY
000832210907      ** Constant CP
000833210907     C                   MOVE      PConstCP      XXCCSTCP
000834210907      ** Filler 1
000835210907     C                   MOVE      *BLANKS       XXCFIL1
000836210907      *
000837210907      ** Add up VJC Record added
000838210907     C                   Z-ADD     WXCTAMTD      XXCTAMTD
000839210907     C                   Z-ADD     WXCTAMTC      XXCTAMTC
000840210907     C                   Add       1             WXHTTVJC          8 0
000841210907     C                   WRITE     XXFEEDCD0
000842210907      *
000843210907     C                   ENDIF
000844210907      *
000845210907      ** CONTROL RECORD FORMAT
000846210907     C                   If        WXCTAMTC = WXCTAMTD and
000847210907     C                             WXCTAMTC > 0
000848210907     C                   CLEAR                   XXFEEDCD0
000849210907      ** Record Format
000850210907     C                   MOVE      'VJC'         XXCDBID
000851210907      ** Corporate Entity
000852210907     C                   MOVEL     PCorpEnt      XXCVJCC
000853210907      ** Journal ID
000854210907     C                   MOVEL     PBranch       DJRNI1
000855210907     C                   MOVEL     PSystem       DJRNI2
000856210907     C                   MOVEL     WKCCY         DJRNI3
000857210907     C                   MOVEL     '0'           DJRNI4
000858210907     C                   MOVEL     DSJRNID       XXCJRNID
000859210907      ** Effective Date
000860210907     C                   MOVE      DSRndDate     XXCEFFD
000861210907      ** Journal Seq
000862210907     C                   MOVE      DSJRNS        XXCJRNSQ
000863210907      ** Constant CY
000864210907     C                   MOVE      PConstCY      XXCCSTCY
000865210907      ** Constant CP
000866210907     C                   MOVE      PConstCP      XXCCSTCP
000867210907      ** Filler 1
000868210907     C                   MOVE      *BLANKS       XXCFIL1
000869210907      *
000870210907      ** Add up VJC Record added
000871210907     C                   Z-ADD     WXCTAMTD      XXCTAMTD
000872210907     C                   Z-ADD     WXCTAMTC      XXCTAMTC
000873210907     C                   Add       1             WXHTTVJC
000874210907     C                   WRITE     XXFEEDCD0
000875210907     C                   ENDIF
000876210907      *
000877210907      ** Reset total for VJC records
000878210907     C                   Z-ADD     0             WXCTAMTC         19 0
000879210907     C                   Z-ADD     0             WXCTAMTD         19 0
000880210907      *
000881210907     C                   ENDSR
000882210907      *
000883210907      *****************************************************************
000884210907      *                                                               *
000885210907      * EXTHED - Write Feeder Header Record                           *
000886210907      *                                                               *
000887210907      * Called by: Main Processing                                    *
000888210907      *                                                               *
000889210907      * Calls:                                                        *
000890210907      *                                                               *
000891210907      *****************************************************************
000892210907      *
000893210907     C     EXTHED        BEGSR
000894210907      *
000895210907     C                   CLEAR                   XXFEEDHD0
000896210907      ** Record Format
000897210907     C                   MOVEL     'FCR'         XXHDBID
000898210907      ** Filler 1, 2 & 3
000899210907     C                   MOVEL     *BLANKS       XXHFIL1
000900210907     C                   MOVE      *ALL'0'       XXHFIL2
000901210907     C                   MOVEL     *BLANKS       XXHFIL3
000902210907      ** System
000903210907     C                   MOVE      PSystem       XXHSYST
000904210907      ** Rundate
000905210907     C                   MOVE      DSRndDate     XXHBUSD
000906210907      ** Rest of calculated fields already set in other Sb
000907210907     C                   Z-ADD     WXHTTVJC      XXHTTVJC
000908210907     C                   Z-ADD     WXHTTVLJ      XXHTTVLJ
000909210907     C                   Z-ADD     WXHTVLJD      XXHTVLJD
000910210907     C                   Z-ADD     WXHTVLJC      XXHTVLJC
000911210907     C                   Z-ADD     WXHTOTD       XXHTOTD
000912210907     C                   Z-ADD     WXHTOTC       XXHTOTC
000913210907      *
000914210907     C                   WRITE     XXFEEDHD0
000915210907      *
000916210907     C                   ENDSR
000917210907      *
000918210907      *****************************************************************
000919210907      *                                                               *
000920210907      * ChkSysValue - Check for system values                         *
000921210907      *                                                               *
000922210907      * Called by: Main Processing                                    *
000923210907      *                                                               *
000924210907      * Calls:                                                        *
000925210907      *                                                               *
000926210907      *****************************************************************
000927210907      *
000928210907     C     ChkSysValue   BEGSR
000929210907      *
000930210907      ** Check for system values
000931210907     C                   EVAL      @RTCD = *BLANKS
000932210907     C                   EVAL      P@OP01 = PSysVal1
000933210907     C                   EVAL      P@OP02 = PSysVal2
000934210907     C                   EVAL      P@OP03 = PSysVal3
000935210907     C                   EVAL      P@OP04 = PSysVal4
000936210907     C                   EVAL      P@OP05 = PSysVal5
000937210907     C                   EVAL      P@OP06 = PSysVal6
000938210907     C                   EVAL      P@OP07 = PSysVal7
000939210907     C                   EVAL      P@OP08 = PSysVal8
000940210907     C                   EVAL      P@OP09 = PSysVal9
000941210907      *
000942210907     C                   CALL      'AOSVALR0'
000943210907     C                   PARM                    @RTCD             7
000944210907     C                   PARM                    P@OP01
000945210907     C                   PARM      *BLANKS       P@VL01
000946210907     C                   PARM                    P@OP02
000947210907     C                   PARM      *BLANKS       P@VL02
000948210907     C                   PARM                    P@OP03
000949210907     C                   PARM      *BLANKS       P@VL03
000950210907     C                   PARM                    P@OP04
000951210907     C                   PARM      *BLANKS       P@VL04
000952210907     C                   PARM                    P@OP05
000953210907     C                   PARM      *BLANKS       P@VL05
000954210907     C                   PARM                    P@OP06
000955210907     C                   PARM      *BLANKS       P@VL06
000956210907     C                   PARM                    P@OP07
000957210907     C                   PARM      *BLANKS       P@VL07
000958210907     C                   PARM                    P@OP08
000959210907     C                   PARM      *BLANKS       P@VL08
000960210907     C                   PARM                    P@OP09
000961210907     C                   PARM      *BLANKS       P@VL09
000962210907     C                   PARM      *BLANKS       P@OP10
000963210907     C                   PARM      *BLANKS       P@VL10
000964210907
000965210907      ** Setup work fields
000966210907      * Set PRecFmt  = P@VL01
000967210907      * Set PCorpEnt = P@VL02
000968210907      * Set PBranch  = P@VL03
000969210907      * Set PSystem  = P@VL04
000970210907      * Set PConstS  = P@VL05
000971210907      * Set PConst20 = P@VL06
000972210907      * Set PConstCY = P@VL07
000973210907      * Set PConstCP = P@VL08
000974210907      * Set PCompany = P@VL09
000975210907      *
000976210907     C                   EVAL      PRecFmt = *BLANKS
000977210907     C                   EVAL      PCorpEnt = *BLANKS
000978210907     C                   EVAL      PBranch = *BLANKS
000979210907     C                   EVAL      PSystem = *BLANKS
000980210907     C                   EVAL      PConstS = *BLANKS
000981210907     C                   EVAL      PConst20 = *BLANKS
000982210907     C                   EVAL      PConstCY = *BLANKS
000983210907     C                   EVAL      PConstCP = *BLANKS
000984210907     C                   EVAL      PCompany = *BLANKS
000985210907      *
000986210907     C                   IF        @RTCD = *BLANKS
000987210907     C                   EVAL      PRecFmt = P@VL01
000988210907     C                   EVAL      PCorpEnt = P@VL02
000989210907     C                   EVAL      PBranch = P@VL03
000990210907     C                   EVAL      PSystem = P@VL04
000991210907     C                   EVAL      PConstS = P@VL05
000992210907     C                   EVAL      PConst20 = P@VL06
000993210907     C                   EVAL      PConstCY = P@VL07
000994210907     C                   EVAL      PConstCP = P@VL08
000995210907     C                   EVAL      PCompany = P@VL09
000996210907     C                   ENDIF
000997210907      *
000998210907     C                   ENDSR
000999210907      *
001000210907      *****************************************************************
001001210907      /EJECT
001002210907      *****************************************************************
001003210907      *                                                               *
001004210907      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
001005210907      *                                                               *
001006210907      *****************************************************************
001007210907
001008210907     C     SRZDate9      BEGSR
001009210907
001010210907     C                   CALLB     'ZDATE9'
001011210907     C                   PARM                    PDayNoIn
001012210907     C                   PARM      *ZERO         PDateOutZ9
001013210907     C                   PARM                    PRetCodeZ9
001014210907
001015210907     C                   ENDSR
001016210907
001017210907      *****************************************************************
001018210907      ** SRCvtDate - Convert date from YYYYMMDD to DDMMYY (or MMDDYY) *
001019210907      *****************************************************************
001020210907     C     SRCvtDate     BEGSR
001021210907
001022210907     C                   CALLB     'ZA0770'
001023210907     C                   PARM      *BLANK        ReturnCode        7
001024210907     C                   PARM                    @DATE             8 0
001025210907     C                   PARM                    BJDFIN
001026210907     C                   PARM      *ZERO         PDateOut
001027210907
001028210907     C                   ENDSR
001029210907      *****************************************************************
001030210907      /Title SR/*PSSR
001031210907      *****************************************************************
001032210907      *                                                               *
001033210907      *  *PSSR  - Program Error Processing Subroutine.                *
001034210907      *                                                               *
001035210907      *  Called By: Various                                           *
001036210907      *                                                               *
001037210907      *****************************************************************
001038210907      *
001039210907     C     *PSSR         BegSR                                                  *** *PSSR  ***
001040210907      *
001041210907      ***  Check to see that *PSSR has not already been called.
001042210907     C                   If        WRUN = *BLANK
001043210907     C                   Move      'Y'           WRUN              1
001044210907     C                   MoveL     'XX005002'    DBPGM
001045210907      *
001046210907     C     *DTAARA       Define    LDA           WLDA            256
001047210907     C     *Lock         In        WLDA
001048210907     C                   MoveL     DBERR         WLDA
001049210907     C                   Out       WLDA
001050210907     C                   SetOn                                        U7U8LR
001051210907      *
001052210907     C                   Dump
001053210907     C                   EndIf
001054210907      *
001055210907      ** Exit program
001056210907     C                   Return
001057210907      *
001058210907     C                   EndSR
001059210907      *
001060210907      *****************************************************************
001061210907      ***
001062210907**  CPY@
001063210907(c) Finastra Ltd 2021
