000100210908     H DEBUG
000101210908     H
000102210908      *****************************************************************
000103210908/*STD *  RPGBASEMOD                                                   *
000104210908/*EXI *  TEXT('Midas XX GLM / EDW Extract files Format')              *
000105210908      *****************************************************************
000106210908      *                                                               *
000107210908      *  Midas - General Ledger Module                                *
000108210908      *                                                               *
000109210908      *  XX005005 - Midas XX GLM / EDW Extract files Format           *
000110210908      *                                                               *
000111210908      *  Function: GLM / EDW Extract format                           *
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
000125210908     FXXFEEDHL0 IF   E           K Disk    InfSR(*PSSR)
000126210908      *
000127210908     FXXFEEDCL0 IF   E           K Disk    InfSR(*PSSR)
000128210908      *
000129210908     FXXFEEDDL2 IF   E           K Disk    InfSR(*PSSR)
000130210908      *
000131210908     FXXPROFFL0 IF   E           K Disk    InfSR(*PSSR)
000132210908      *
000133210908     FXXGLMETD  O    E           K Disk    InfSR(*PSSR)
000134210908      *
000135210908     FXXEDWETD  O    E           K Disk    InfSR(*PSSR)
000136210908      *
000137210908     FXXPRFETD  O    E           K Disk    InfSR(*PSSR)
000138210908      *
000139210908      /Title Function of indicators
000140210908     F*****************************************************************
000141210908     F*                                                               *
000142210908     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
000143210908     F*                                                               *
000144210908     F*                                                               *
000145210908     F*  90-99 - Used by Standard Subroutines                         *
000146210908     F*                                                               *
000147210908     F*  U7+U8 - Database Error                                       *
000148210908     F*                                                               *
000149210908     F*****************************************************************
000150210908      /Title Subroutine Index
000151210908     F*****************************************************************
000152210908     F*                                                               *
000153210908     F*  S U B R O U T I N E   I N D E X                              *
000154210908     F*                                                               *
000155210908     F*  Init      - Initial Processing                               *
000156210908     F*  Proces    - Main processing                                  *
000157210908     F*  Extract   - Main Extract Processing                          *
000158210908     F*                                                               *
000159210908     F*  *PSSR     - Program error handling routine                   *
000160210908     F*                                                               *
000161210908     F*****************************************************************
000162210908     D/Title D-Specifications
000163210908     D CPY@            S             80    Dim(1) CTData PerRCD(1)
000164210908      ***  Array for Object Copyright Statement.
000165210908      *
000166210908     D SDBANK        E DS                  ExtName(SDBANKPD)
000167210908      ** Bank Details
000168210908      *
000169210908     D DSSDY         E DS                  ExtName(DSSDY)
000170210908      ** Second DS For Access Programs, Long Data Structure
000171210908      *
000172210908     D DBERR           DS           256
000173210908      * Data structure for data-base error processing
000174210908     D  DBFILE               134    141
000175210908     D  DBKEY                142    170
000176210908     D  DBPGM                171    180
000177210908     D  DBASE                181    183  0
000178210908      *
000179210908     D                 DS
000180210908
000181210908     D RUNDAT          DS
000182210908      * Data structure for rundate flags
000183210908     D  RUNA                   1      7
000184210908     D  @DLUP                  1      2  0
000185210908     D  @MLUP                  3      5
000186210908     D  @YLUP                  6      7  0
000187210908     D  RUND                   8     10P 0
000188210908     D  @MBIN                 13     13
000189210908
000190210908     D PDateOut        S              6  0
000191210908
000192210908      ** Parameters for ZDATE9
000193210908     D PDaynoIn        S              5P 0
000194210908     D PDateOutZ9      S              8S 0
000195210908     D PRetCodeZ9      S              1  0
000196210908
000197210908      ** YYYYMMDD date format of Rundate
000198210908     D DSRNDDate       DS
000199210908     D  WVYYR                  1      4  0
000200210908     D  WVY2R                  3      4  0
000201210908     D  WVMMR                  5      6  0
000202210908     D  WVDDR                  7      8  0
000203210908     D  WVRND                  1      8  0
000204210908
000205210908      ** YYMMDD date format of Rundate
000206210908     D DSDayDate       DS
000207210908     D  WVY2D                  1      2  0
000208210908     D  WVMMD                  3      4  0
000209210908     D  WVDDD                  5      6  0
000210210908
000211210908      ** YY/MM/DD date format of Rundate
000212210908     D DSPROFD         DS
000213210908     D  WPDDD                  1      2
000214210908     D  WPFI1                  3      3
000215210908     D  WPMMD                  4      5
000216210908     D  WPFI2                  6      6
000217210908     D  WPYYD                  7     10
000218210908
000219210908     D DSHEADER        DS
000220210908     D  DSHDBID                1      3
000221210908     D  DSHFIL1                4     18
000222210908     D  DSHFIL2               19     31
000223210908     D  DSHSYST               32     34
000224210908     D  DSHBUSD               35     42
000225210908     D  DSHTTVJC              43     50
000226210908     D  DSHTTVLJ              51     58
000227210908     D  DSHTVLJD              59     66
000228210908     D  DSHTVLJC              67     74
000229210908     D  DSHTOTD               75     91
000230210908     D  DSHTOTC               92    108
000231210908     D  DSHFIL3              109    234
000232210908      *
000233210908     D DSCONTRL        DS
000234210908     D  DSCDBID                1      3
000235210908     D  DSCVJCC                4      8
000236210908     D  DSCJRNID               9     18
000237210908     D  DSCCCY                15     17
000238210908     D  DSCEFFD               19     26
000239210908     D  DSCJRNSQ              27     31
000240210908     D  DSCCSTCP              32     33
000241210908     D  DSCCSTCY              34     35
000242210908     D  DSCTAMTD              36     50
000243210908     D  DSCTAMTC              51     65
000244210908     D  DSCFIL1               66    234
000245210908      *
000246210908     D DSDETAIL        DS
000247210908     D  DSDDBID                1      3
000248210908     D  DSDVJCC                4      8
000249210908     D  DSDJRNID               9     18
000250210908     D  DSDEFFD               19     26
000251210908     D  DSDJRNSQ              27     31
000252210908     D  DSDGLMCP              32     75
000253210908     D  DSDHOAC               39     43
000254210908     D  DSDHOPC               44     47
000255210908     D  DSDHOMC               48     50
000256210908     D  DSDCCYL               76     78
000257210908     D  DSDCSTS               79     79
000258210908     D  DSDSLID               80     80
000259210908     D  DSDSLAC               81     96
000260210908     D  DSDSRCE               97    106
000261210908     D  DSDJRND              107    181
000262210908     D  DSDDLNO              164    171
000263210908     D  DSDCUST              174    179
000264210908     D  DSDCSTCY             182    183
000265210908     D  DSDCSTCP             184    185
000266210908     D  DSDDRCR              186    186
000267210908     D  DSDLCBE              187    201
000268210908     D  DSDPSTA              202    216
000269210908     D  DSDRATE              217    234
000270210908      *
000271210908     D DSPROOF         DS
000272210908     D  DSPTRDT                1     10
000273210908     D  DSPFIL1               11     11
000274210908     D  DSPPCCY               12     14
000275210908     D  DSPFIL2               15     15
000276210908     D  DSPPACC               16     19
000277210908     D  DSPFIL3               20     20
000278210908     D  DSPPHOP               21     24
000279210908     D  DSPFIL4               25     25
000280210908     D  DSPPHOB               26     28
000281210908     D  DSPFIL5               29     29
000282210908     D  DSPPBLC               30     48
000283210908     D  DSPPSGN               49     49
000284210908
000285210908
000286210908     C/Title Main Processing
000287210908      *================================================================
000288210908      *  P R O G R A M     S T A R T                                  *
000289210908      *================================================================
000290210908      *
000291210908      * Perform Initialisation.
000292210908     C                   ExSR      Init
000293210908      *
000294210908      * Perform Feeder data to GLM and EDW flat file
000295210908     C                   ExSR      Feeder
000296210908      *
000297210908      * Perform Proofing data to flat file
000298210908     C                   ExSR      Proof
000299210908      *
000300210908     C                   SetOn                                        LR
000301210908     C                   Return
000302210908      *================================================================
000303210908      *  P R O G R A M     E N D                                      *
000304210908      *================================================================
000305210908      /Title SR/Init
000306210908      *****************************************************************
000307210908      *                                                               *
000308210908      *  Init   - Subroutine to do Program Initialisation.            *
000309210908      *                                                               *
000310210908      *  Called By: Main Processing                                   *
000311210908      *  Calls    : None                                              *
000312210908      *                                                               *
000313210908      *****************************************************************
000314210908      *
000315210908     C     Init          BegSR
000316210908      *
000317210908      ***  Copyright Statement.
000318210908     C                   MoveA     CPY@          BIS@             80
000319210908      *
000320210908     C     *ENTRY        PLIST
000321210908     C                   PARM                    DAYDATE           6
000322210908      *
000323210908      ** Access Bank Details
000324210908     C                   Call      'AOBANKR0'
000325210908     C                   Parm      '*MSG   '     WRTCD             7
000326210908     C                   Parm      '*FIRST '     WOPTN             7
000327210908     C     SDBANK        Parm      SDBANK        DSSDY
000328210908      *
000329210908     C     WRTCD         IfNE      *BLANKS
000330210908     C                   Z-Add     001           DBASE                          ***************
000331210908     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
000332210908     C                   Move      *Blanks       DBKEY                          ***************
000333210908     C                   ExSR      *PSSR
000334210908     C                   End
000335210908      *
000336210908      ***  Check System Date Format, DDMMYY (*IN98 off)
000337210908      ***                            MMDDYY (*IN98 on).
000338210908      *
000339210908     C                   If        BJDFIN = 'M'
000340210908     C                   SetOn                                        98
000341210908     C                   EndIf
000342210908      *
000343210908     C** Get RUNDAT to access MULTI-BRANCHING flag
000344210908     C     *DTAARA       Define                  RUNDAT
000345210908     C                   In        RUNDAT
000346210908      *
000347210908     C                   Z-ADD     BJRDNB        PDaynoIn
000348210908     C                   EXSR      SRZDate9
000349210908     C                   MOVE      PDateOutZ9    DSRndDate
000350210908      *
000351210908     C                   MOVE      WVY2R         WVY2D
000352210908     C                   MOVE      WVMMR         WVMMD
000353210908     C                   MOVE      WVDDR         WVDDD
000354210908     C                   MOVE      DSDayDate     DAYDATE
000355210908      *
000356210908      ** Klist to access the XXFEEDDTD file
000357210908     C     KFEEDD        KList
000358210908     C                   KFld                    KFEED
000359210908     C                   KFld                    KFEED2            3
000360210908      *
000361210908     C                   EndSR
000362210908      *****************************************************************
000363210908      /Title SR/Feeder
000364210908      *****************************************************************
000365210908      *                                                               *
000366210908      *  Feeder - Subroutine to write Feeder data to flat file        *
000367210908      *                                                               *
000368210908      *  Called By: Main Processing                                   *
000369210908      *  Calls:                                                       *
000370210908      *                                                               *
000371210908      *****************************************************************
000372210908      *
000373210908     C     Feeder        BegSR
000374210908      *
000375210908      ** Access XXFEEDHTD
000376210908      ** Write to GLM EDW flat file
000377210908     C                   MOVE      DSRndDate     KFEED             8 0
000378210908     C     KFEED         CHAIN     XXFEEDHL0                          50
000379210908     C                   if        *IN50 = '0'
000380210908     C                   CLEAR                   XXGLMED0
000381210908     C                   MOVEL     XXHDBID       DSHDBID
000382210908     C                   MOVEL     XXHFIL1       DSHFIL1
000383210908     C                   MOVEL     XXHFIL2       DSHFIL2
000384210908     C                   MOVEL     XXHSYST       DSHSYST
000385210908     C                   MOVEL     XXHBUSD       DSHBUSD
000386210908     C                   MOVEL     XXHTTVJC      DSHTTVJC
000387210908     C                   MOVEL     XXHTTVLJ      DSHTTVLJ
000388210908     C                   MOVEL     XXHTVLJD      DSHTVLJD
000389210908     C                   MOVEL     XXHTVLJC      DSHTVLJC
000390210908     C                   MOVEL     XXHTOTD       DSHTOTD
000391210908     C                   MOVEL     XXHTOTC       DSHTOTC
000392210908     C                   MOVEL     XXHFIL3       DSHFIL3
000393210908      *
000394210908     C                   MOVEL     DSHEADER      XXGLME
000395210908     C                   WRITE     XXGLMED0
000396210908      *
000397210908      ** Access XXFEEDCTD
000398210908      ** Write to GLM and EDW flat files
000399210908     C     KFEED         SETLL     XXFEEDCL0
000400210908     C     KFEED         READE     XXFEEDCL0                              51
000401210908     C                   Dow       *IN51 = '0' and XXCEFFD = KFEED
000402210908     C                   CLEAR                   XXGLMED0
000403210908     C                   MOVEL     XXCDBID       DSCDBID
000404210908     C                   MOVEL     XXCVJCC       DSCVJCC
000405210908     C                   MOVEL     XXCJRNID      DSCJRNID
000406210908     C                   MOVEL     XXCEFFD       DSCEFFD
000407210908     C                   MOVEL     XXCJRNSQ      DSCJRNSQ
000408210908     C                   MOVEL     XXCCSTCP      DSCCSTCP
000409210908     C                   MOVEL     XXCCSTCY      DSCCSTCY
000410210908     C                   MOVEL     XXCTAMTD      DSCTAMTD
000411210908     C                   MOVEL     XXCTAMTC      DSCTAMTC
000412210908     C                   MOVEL     XXCFIL1       DSCFIL1
000413210908      *
000414210908     C                   MOVEL     DSCONTRL      XXGLME
000415210908     C                   WRITE     XXGLMED0
000416210908      *
000417210908     C                   CLEAR                   XXEDWED0
000418210908     C                   MOVEL     DSCONTRL      XXGLMD
000419210908     C                   MOVEL     *BLANKS       XXDLNO
000420210908     C                   MOVEL     *BLANKS       XXCUST
000421210908     C                   MOVEL     *BLANKS       XXHOAC
000422210908     C                   MOVEL     *BLANKS       XXHOPC
000423210908     C                   MOVEL     *BLANKS       XXHOMC
000424210908     C                   WRITE     XXEDWED0
000425210908      *
000426210908     C                   MOVEL     DSCCCY        KFEED2
000427210908      *
000428210908      ** Access XXFEEDDTD
000429210908      ** Write to GLM and EDW flat files
000430210908     C     KFEEDD        SETLL     XXFEEDDL2
000431210908     C     KFEEDD        READE     XXFEEDDL2                              52
000432210908     C                   Dow       *IN52 = '0' and XXDEFFD = KFEED
000433210908     C                             and XXDCCYL = DSCCCY
000434210908     C                   CLEAR                   XXGLMED0
000435210908     C                   MOVE      XXDDBID       DSDDBID
000436210908     C                   MOVE      XXDVJCC       DSDVJCC
000437210908     C                   MOVE      XXDJRNID      DSDJRNID
000438210908     C                   MOVE      XXDEFFD       DSDEFFD
000439210908     C                   MOVE      XXDJRNSQ      DSDJRNSQ
000440210908     C                   MOVE      XXDGLMCP      DSDGLMCP
000441210908     C                   MOVE      XXDCCYL       DSDCCYL
000442210908     C                   MOVE      XXDCSTS       DSDCSTS
000443210908     C                   MOVE      XXDSLID       DSDSLID
000444210908     C                   MOVE      XXDSLAC       DSDSLAC
000445210908     C                   MOVE      XXDSRCE       DSDSRCE
000446210908     C                   MOVE      XXDJRND       DSDJRND
000447210908     C                   MOVE      XXDCSTCY      DSDCSTCY
000448210908     C                   MOVE      XXDCSTCP      DSDCSTCP
000449210908     C                   MOVE      XXDDRCR       DSDDRCR
000450210908     C                   MOVE      XXDLCBE       DSDLCBE
000451210908     C                   MOVE      XXDPSTA       DSDPSTA
000452210908     C                   MOVE      XXDRATE       DSDRATE
000453210908      *
000454210908     C                   MOVEL     DSDETAIL      XXGLME
000455210908     C                   WRITE     XXGLMED0
000456210908      *
000457210908     C                   CLEAR                   XXEDWED0
000458210908     C                   MOVEL     DSDETAIL      XXGLMD
000459210908     C                   MOVEL     DSDDLNO       XXDLNO
000460210908     C                   MOVEL     DSDCUST       XXCUST
000461210908     C                   MOVEL     DSDHOAC       XXHOAC
000462210908     C                   MOVEL     DSDHOPC       XXHOPC
000463210908     C                   MOVEL     DSDHOMC       XXHOMC
000464210908     C                   WRITE     XXEDWED0
000465210908      *
000466210908     C     KFEEDD        READE     XXFEEDDL2                              52
000467210908     C                   ENDDO
000468210908      *
000469210908     C     KFEED         READE     XXFEEDCL0                              51
000470210908      *
000471210908     C                   ENDDO
000472210908      *
000473210908     C                   ENDIF
000474210908      *
000475210908     C                   EndSR
000476210908      *
000477210908      *****************************************************************
000478210908      /Title SR/Proof
000479210908      *****************************************************************
000480210908      *                                                               *
000481210908      *  Proof - Subroutine to write Proofing data to flat file       *
000482210908      *                                                               *
000483210908      *  Called By: Main Processing                                   *
000484210908      *  Calls:                                                       *
000485210908      *                                                               *
000486210908      *****************************************************************
000487210908      *
000488210908     C     Proof         BegSR
000489210908      *
000490210908      ** Write to Proofing flat file
000491210908      *
000492210908     C                   MOVE      WVDDR         WPDDD
000493210908     C                   MOVE      '/'           WPFI1
000494210908     C                   MOVE      WVMMR         WPMMD
000495210908     C                   MOVE      '/'           WPFI2
000496210908     C                   MOVE      WVYYR         WPYYD
000497210908     C                   MOVE      DSPROFD       KPROOF           10
000498210908      *
000499210908     C     KPROOF        SETLL     XXPROFFL0
000500210908     C     KPROOF        READE     XXPROFFL0                              53
000501210908     C                   Dow       *IN53 = '0' and XXTRDT = KPROOF
000502210908     C                   CLEAR                   XXPRFED0
000503210908     C                   MOVEL     XXTRDT        DSPTRDT
000504210908     C                   MOVEL     ','           DSPFIL1
000505210908     C                   MOVEL     XXPCCY        DSPPCCY
000506210908     C                   MOVEL     ','           DSPFIL2
000507210908     C                   MOVEL     XXPACC        DSPPACC
000508210908     C                   MOVEL     ','           DSPFIL3
000509210908     C                   MOVEL     XXPHOP        DSPPHOP
000510210908     C                   MOVEL     ','           DSPFIL4
000511210908     C                   MOVEL     XXPHOB        DSPPHOB
000512210908     C                   MOVEL     ','           DSPFIL5
000513210908     C                   MOVEL     XXPBLC        DSPPBLC
000514210908     C                   MOVEL     XXPSGN        DSPPSGN
000515210908      *
000516210908     C                   MOVEL     DSPROOF       XXPRFE
000517210908     C                   WRITE     XXPRFED0
000518210908     C     KPROOF        READE     XXPROFFL0                              53
000519210908     C                   ENDDO
000520210908      *
000521210908     C                   ENDSR
000522210908      *****************************************************************
000523210908      /EJECT
000524210908      *****************************************************************
000525210908      *                                                               *
000526210908      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
000527210908      *                                                               *
000528210908      *****************************************************************
000529210908      *
000530210908     C     SRZDate9      BEGSR
000531210908      *
000532210908     C                   CALLB     'ZDATE9'
000533210908     C                   PARM                    PDayNoIn
000534210908     C                   PARM      *ZERO         PDateOutZ9
000535210908     C                   PARM                    PRetCodeZ9
000536210908      *
000537210908     C                   ENDSR
000538210908      *
000539210908      *****************************************************************
000540210908      /Title SR/*PSSR
000541210908      *****************************************************************
000542210908      *                                                               *
000543210908      *  *PSSR  - Program Error Processing Subroutine.                *
000544210908      *                                                               *
000545210908      *  Called By: Various                                           *
000546210908      *                                                               *
000547210908      *****************************************************************
000548210908      *
000549210908     C     *PSSR         BegSR                                                  *** *PSSR  ***
000550210908      *
000551210908      ***  Check to see that *PSSR has not already been called.
000552210908     C                   If        WRUN = *BLANK
000553210908     C                   Move      'Y'           WRUN              1
000554210908     C                   MoveL     'XX005005'    DBPGM
000555210908      *
000556210908     C     *DTAARA       Define    LDA           WLDA            256
000557210908     C     *Lock         In        WLDA
000558210908     C                   MoveL     DBERR         WLDA
000559210908     C                   Out       WLDA
000560210908     C                   SetOn                                        U7U8LR
000561210908      *
000562210908     C                   Dump
000563210908     C                   EndIf
000564210908      *
000565210908      ** Exit program
000566210908     C                   Return
000567210908      *
000568210908     C                   EndSR
000569210908      *
000570210908      *****************************************************************
000571210908      ***
000572210908**  CPY@
000573210908(c) Finastra Ltd 2021
