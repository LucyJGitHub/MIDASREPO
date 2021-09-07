000100210907                                                       H DEBUG
000101210907     H
000102210907      *****************************************************************
000103210907/*STD *  RPGBASEMOD                                                   *
000104210907/*EXI *  TEXT('Midas XX GLM / EDW Extract files Format')              *
000105210907      *****************************************************************
000106210907      *                                                               *
000107210907      *  Midas - General Ledger Module                                *
000108210907      *                                                               *
000109210907      *  XX005005 - Midas XX GLM / EDW Extract files Format           *
000110210907      *                                                               *
000111210907      *  Function: GLM / EDW Extract format                           *
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
000125210907     FXXFEEDHL0 IF   E           K Disk    InfSR(*PSSR)
000126210907      *
000127210907     FXXFEEDCL0 IF   E           K Disk    InfSR(*PSSR)
000128210907      *
000129210907     FXXFEEDDL2 IF   E           K Disk    InfSR(*PSSR)
000130210907      *
000131210907     FXXPROFFL0 IF   E           K Disk    InfSR(*PSSR)
000132210907      *
000133210907     FXXGLMETD  O    E           K Disk    InfSR(*PSSR)
000134210907      *
000135210907     FXXEDWETD  O    E           K Disk    InfSR(*PSSR)
000136210907      *
000137210907     FXXPRFETD  O    E           K Disk    InfSR(*PSSR)
000138210907      *
000139210907      /Title Function of indicators
000140210907     F*****************************************************************
000141210907     F*                                                               *
000142210907     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
000143210907     F*                                                               *
000144210907     F*                                                               *
000145210907     F*  90-99 - Used by Standard Subroutines                         *
000146210907     F*                                                               *
000147210907     F*  U7+U8 - Database Error                                       *
000148210907     F*                                                               *
000149210907     F*****************************************************************
000150210907      /Title Subroutine Index
000151210907     F*****************************************************************
000152210907     F*                                                               *
000153210907     F*  S U B R O U T I N E   I N D E X                              *
000154210907     F*                                                               *
000155210907     F*  Init      - Initial Processing                               *
000156210907     F*  Proces    - Main processing                                  *
000157210907     F*  Extract   - Main Extract Processing                          *
000158210907     F*                                                               *
000159210907     F*  *PSSR     - Program error handling routine                   *
000160210907     F*                                                               *
000161210907     F*****************************************************************
000162210907     D/Title D-Specifications
000163210907     D CPY@            S             80    Dim(1) CTData PerRCD(1)
000164210907      ***  Array for Object Copyright Statement.
000165210907      *
000166210907     D SDBANK        E DS                  ExtName(SDBANKPD)
000167210907      ** Bank Details
000168210907      *
000169210907     D DSSDY         E DS                  ExtName(DSSDY)
000170210907      ** Second DS For Access Programs, Long Data Structure
000171210907      *
000172210907     D DBERR           DS           256
000173210907      * Data structure for data-base error processing
000174210907     D  DBFILE               134    141
000175210907     D  DBKEY                142    170
000176210907     D  DBPGM                171    180
000177210907     D  DBASE                181    183  0
000178210907      *
000179210907     D                 DS
000180210907
000181210907     D RUNDAT          DS
000182210907      * Data structure for rundate flags
000183210907     D  RUNA                   1      7
000184210907     D  @DLUP                  1      2  0
000185210907     D  @MLUP                  3      5
000186210907     D  @YLUP                  6      7  0
000187210907     D  RUND                   8     10P 0
000188210907     D  @MBIN                 13     13
000189210907
000190210907     D PDateOut        S              6  0
000191210907
000192210907      ** Parameters for ZDATE9
000193210907     D PDaynoIn        S              5P 0
000194210907     D PDateOutZ9      S              8S 0
000195210907     D PRetCodeZ9      S              1  0
000196210907
000197210907      ** YYYYMMDD date format of Rundate
000198210907     D DSRNDDate       DS
000199210907     D  WVYYR                  1      4  0
000200210907     D  WVY2R                  3      4  0
000201210907     D  WVMMR                  5      6  0
000202210907     D  WVDDR                  7      8  0
000203210907     D  WVRND                  1      8  0
000204210907
000205210907      ** YYMMDD date format of Rundate
000206210907     D DSDayDate       DS
000207210907     D  WVY2D                  1      2  0
000208210907     D  WVMMD                  3      4  0
000209210907     D  WVDDD                  5      6  0
000210210907
000211210907      ** YY/MM/DD date format of Rundate
000212210907     D DSPROFD         DS
000213210907     D  WPDDD                  1      2
000214210907     D  WPFI1                  3      3
000215210907     D  WPMMD                  4      5
000216210907     D  WPFI2                  6      6
000217210907     D  WPYYD                  7     10
000218210907
000219210907     D DSHEADER        DS
000220210907     D  DSHDBID                1      3
000221210907     D  DSHFIL1                4     18
000222210907     D  DSHFIL2               19     31
000223210907     D  DSHSYST               32     34
000224210907     D  DSHBUSD               35     42
000225210907     D  DSHTTVJC              43     50
000226210907     D  DSHTTVLJ              51     58
000227210907     D  DSHTVLJD              59     66
000228210907     D  DSHTVLJC              67     74
000229210907     D  DSHTOTD               75     91
000230210907     D  DSHTOTC               92    108
000231210907     D  DSHFIL3              109    234
000232210907      *
000233210907     D DSCONTRL        DS
000234210907     D  DSCDBID                1      3
000235210907     D  DSCVJCC                4      8
000236210907     D  DSCJRNID               9     18
000237210907     D  DSCCCY                15     17
000238210907     D  DSCEFFD               19     26
000239210907     D  DSCJRNSQ              27     31
000240210907     D  DSCCSTCP              32     33
000241210907     D  DSCCSTCY              34     35
000242210907     D  DSCTAMTD              36     50
000243210907     D  DSCTAMTC              51     65
000244210907     D  DSCFIL1               66    234
000245210907      *
000246210907     D DSDETAIL        DS
000247210907     D  DSDDBID                1      3
000248210907     D  DSDVJCC                4      8
000249210907     D  DSDJRNID               9     18
000250210907     D  DSDEFFD               19     26
000251210907     D  DSDJRNSQ              27     31
000252210907     D  DSDGLMCP              32     75
000253210907     D  DSDHOAC               39     43
000254210907     D  DSDHOPC               44     47
000255210907     D  DSDHOMC               48     50
000256210907     D  DSDCCYL               76     78
000257210907     D  DSDCSTS               79     79
000258210907     D  DSDSLID               80     80
000259210907     D  DSDSLAC               81     96
000260210907     D  DSDSRCE               97    106
000261210907     D  DSDJRND              107    181
000262210907     D  DSDDLNO              164    171
000263210907     D  DSDCUST              174    179
000264210907     D  DSDCSTCY             182    183
000265210907     D  DSDCSTCP             184    185
000266210907     D  DSDDRCR              186    186
000267210907     D  DSDLCBE              187    201
000268210907     D  DSDPSTA              202    216
000269210907     D  DSDRATE              217    234
000270210907      *
000271210907     D DSPROOF         DS
000272210907     D  DSPTRDT                1     10
000273210907     D  DSPFIL1               11     11
000274210907     D  DSPPCCY               12     14
000275210907     D  DSPFIL2               15     15
000276210907     D  DSPPACC               16     19
000277210907     D  DSPFIL3               20     20
000278210907     D  DSPPHOP               21     24
000279210907     D  DSPFIL4               25     25
000280210907     D  DSPPHOB               26     28
000281210907     D  DSPFIL5               29     29
000282210907     D  DSPPBLC               30     48
000283210907     D  DSPPSGN               49     49
000284210907
000285210907
000286210907     C/Title Main Processing
000287210907      *================================================================
000288210907      *  P R O G R A M     S T A R T                                  *
000289210907      *================================================================
000290210907      *
000291210907      * Perform Initialisation.
000292210907     C                   ExSR      Init
000293210907      *
000294210907      * Perform Feeder data to GLM and EDW flat file
000295210907     C                   ExSR      Feeder
000296210907      *
000297210907      * Perform Proofing data to flat file
000298210907     C                   ExSR      Proof
000299210907      *
000300210907     C                   SetOn                                        LR
000301210907     C                   Return
000302210907      *================================================================
000303210907      *  P R O G R A M     E N D                                      *
000304210907      *================================================================
000305210907      /Title SR/Init
000306210907      *****************************************************************
000307210907      *                                                               *
000308210907      *  Init   - Subroutine to do Program Initialisation.            *
000309210907      *                                                               *
000310210907      *  Called By: Main Processing                                   *
000311210907      *  Calls    : None                                              *
000312210907      *                                                               *
000313210907      *****************************************************************
000314210907      *
000315210907     C     Init          BegSR
000316210907      *
000317210907      ***  Copyright Statement.
000318210907     C                   MoveA     CPY@          BIS@             80
000319210907      *
000320210907     C     *ENTRY        PLIST
000321210907     C                   PARM                    DAYDATE           6
000322210907      *
000323210907      ** Access Bank Details
000324210907     C                   Call      'AOBANKR0'
000325210907     C                   Parm      '*MSG   '     WRTCD             7
000326210907     C                   Parm      '*FIRST '     WOPTN             7
000327210907     C     SDBANK        Parm      SDBANK        DSSDY
000328210907      *
000329210907     C     WRTCD         IfNE      *BLANKS
000330210907     C                   Z-Add     001           DBASE                          ***************
000331210907     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
000332210907     C                   Move      *Blanks       DBKEY                          ***************
000333210907     C                   ExSR      *PSSR
000334210907     C                   End
000335210907      *
000336210907      ***  Check System Date Format, DDMMYY (*IN98 off)
000337210907      ***                            MMDDYY (*IN98 on).
000338210907      *
000339210907     C                   If        BJDFIN = 'M'
000340210907     C                   SetOn                                        98
000341210907     C                   EndIf
000342210907      *
000343210907     C** Get RUNDAT to access MULTI-BRANCHING flag
000344210907     C     *DTAARA       Define                  RUNDAT
000345210907     C                   In        RUNDAT
000346210907      *
000347210907     C                   Z-ADD     BJRDNB        PDaynoIn
000348210907     C                   EXSR      SRZDate9
000349210907     C                   MOVE      PDateOutZ9    DSRndDate
000350210907      *
000351210907     C                   MOVE      WVY2R         WVY2D
000352210907     C                   MOVE      WVMMR         WVMMD
000353210907     C                   MOVE      WVDDR         WVDDD
000354210907     C                   MOVE      DSDayDate     DAYDATE
000355210907      *
000356210907      ** Klist to access the XXFEEDDTD file
000357210907     C     KFEEDD        KList
000358210907     C                   KFld                    KFEED
000359210907     C                   KFld                    KFEED2            3
000360210907      *
000361210907     C                   EndSR
000362210907      *****************************************************************
000363210907      /Title SR/Feeder
000364210907      *****************************************************************
000365210907      *                                                               *
000366210907      *  Feeder - Subroutine to write Feeder data to flat file        *
000367210907      *                                                               *
000368210907      *  Called By: Main Processing                                   *
000369210907      *  Calls:                                                       *
000370210907      *                                                               *
000371210907      *****************************************************************
000372210907      *
000373210907     C     Feeder        BegSR
000374210907      *
000375210907      ** Access XXFEEDHTD
000376210907      ** Write to GLM EDW flat file
000377210907     C                   MOVE      DSRndDate     KFEED             8 0
000378210907     C     KFEED         CHAIN     XXFEEDHL0                          50
000379210907     C                   if        *IN50 = '0'
000380210907     C                   CLEAR                   XXGLMED0
000381210907     C                   MOVEL     XXHDBID       DSHDBID
000382210907     C                   MOVEL     XXHFIL1       DSHFIL1
000383210907     C                   MOVEL     XXHFIL2       DSHFIL2
000384210907     C                   MOVEL     XXHSYST       DSHSYST
000385210907     C                   MOVEL     XXHBUSD       DSHBUSD
000386210907     C                   MOVEL     XXHTTVJC      DSHTTVJC
000387210907     C                   MOVEL     XXHTTVLJ      DSHTTVLJ
000388210907     C                   MOVEL     XXHTVLJD      DSHTVLJD
000389210907     C                   MOVEL     XXHTVLJC      DSHTVLJC
000390210907     C                   MOVEL     XXHTOTD       DSHTOTD
000391210907     C                   MOVEL     XXHTOTC       DSHTOTC
000392210907     C                   MOVEL     XXHFIL3       DSHFIL3
000393210907      *
000394210907     C                   MOVEL     DSHEADER      XXGLME
000395210907     C                   WRITE     XXGLMED0
000396210907      *
000397210907      ** Access XXFEEDCTD
000398210907      ** Write to GLM and EDW flat files
000399210907     C     KFEED         SETLL     XXFEEDCL0
000400210907     C     KFEED         READE     XXFEEDCL0                              51
000401210907     C                   Dow       *IN51 = '0' and XXCEFFD = KFEED
000402210907     C                   CLEAR                   XXGLMED0
000403210907     C                   MOVEL     XXCDBID       DSCDBID
000404210907     C                   MOVEL     XXCVJCC       DSCVJCC
000405210907     C                   MOVEL     XXCJRNID      DSCJRNID
000406210907     C                   MOVEL     XXCEFFD       DSCEFFD
000407210907     C                   MOVEL     XXCJRNSQ      DSCJRNSQ
000408210907     C                   MOVEL     XXCCSTCP      DSCCSTCP
000409210907     C                   MOVEL     XXCCSTCY      DSCCSTCY
000410210907     C                   MOVEL     XXCTAMTD      DSCTAMTD
000411210907     C                   MOVEL     XXCTAMTC      DSCTAMTC
000412210907     C                   MOVEL     XXCFIL1       DSCFIL1
000413210907      *
000414210907     C                   MOVEL     DSCONTRL      XXGLME
000415210907     C                   WRITE     XXGLMED0
000416210907      *
000417210907     C                   CLEAR                   XXEDWED0
000418210907     C                   MOVEL     DSCONTRL      XXGLMD
000419210907     C                   MOVEL     *BLANKS       XXDLNO
000420210907     C                   MOVEL     *BLANKS       XXCUST
000421210907     C                   MOVEL     *BLANKS       XXHOAC
000422210907     C                   MOVEL     *BLANKS       XXHOPC
000423210907     C                   MOVEL     *BLANKS       XXHOMC
000424210907     C                   WRITE     XXEDWED0
000425210907      *
000426210907     C                   MOVEL     DSCCCY        KFEED2
000427210907      *
000428210907      ** Access XXFEEDDTD
000429210907      ** Write to GLM and EDW flat files
000430210907     C     KFEEDD        SETLL     XXFEEDDL2
000431210907     C     KFEEDD        READE     XXFEEDDL2                              52
000432210907     C                   Dow       *IN52 = '0' and XXDEFFD = KFEED
000433210907     C                             and XXDCCYL = DSCCCY
000434210907     C                   CLEAR                   XXGLMED0
000435210907     C                   MOVE      XXDDBID       DSDDBID
000436210907     C                   MOVE      XXDVJCC       DSDVJCC
000437210907     C                   MOVE      XXDJRNID      DSDJRNID
000438210907     C                   MOVE      XXDEFFD       DSDEFFD
000439210907     C                   MOVE      XXDJRNSQ      DSDJRNSQ
000440210907     C                   MOVE      XXDGLMCP      DSDGLMCP
000441210907     C                   MOVE      XXDCCYL       DSDCCYL
000442210907     C                   MOVE      XXDCSTS       DSDCSTS
000443210907     C                   MOVE      XXDSLID       DSDSLID
000444210907     C                   MOVE      XXDSLAC       DSDSLAC
000445210907     C                   MOVE      XXDSRCE       DSDSRCE
000446210907     C                   MOVE      XXDJRND       DSDJRND
000447210907     C                   MOVE      XXDCSTCY      DSDCSTCY
000448210907     C                   MOVE      XXDCSTCP      DSDCSTCP
000449210907     C                   MOVE      XXDDRCR       DSDDRCR
000450210907     C                   MOVE      XXDLCBE       DSDLCBE
000451210907     C                   MOVE      XXDPSTA       DSDPSTA
000452210907     C                   MOVE      XXDRATE       DSDRATE
000453210907      *
000454210907     C                   MOVEL     DSDETAIL      XXGLME
000455210907     C                   WRITE     XXGLMED0
000456210907      *
000457210907     C                   CLEAR                   XXEDWED0
000458210907     C                   MOVEL     DSDETAIL      XXGLMD
000459210907     C                   MOVEL     DSDDLNO       XXDLNO
000460210907     C                   MOVEL     DSDCUST       XXCUST
000461210907     C                   MOVEL     DSDHOAC       XXHOAC
000462210907     C                   MOVEL     DSDHOPC       XXHOPC
000463210907     C                   MOVEL     DSDHOMC       XXHOMC
000464210907     C                   WRITE     XXEDWED0
000465210907      *
000466210907     C     KFEEDD        READE     XXFEEDDL2                              52
000467210907     C                   ENDDO
000468210907      *
000469210907     C     KFEED         READE     XXFEEDCL0                              51
000470210907      *
000471210907     C                   ENDDO
000472210907      *
000473210907     C                   ENDIF
000474210907      *
000475210907     C                   EndSR
000476210907      *
000477210907      *****************************************************************
000478210907      /Title SR/Proof
000479210907      *****************************************************************
000480210907      *                                                               *
000481210907      *  Proof - Subroutine to write Proofing data to flat file       *
000482210907      *                                                               *
000483210907      *  Called By: Main Processing                                   *
000484210907      *  Calls:                                                       *
000485210907      *                                                               *
000486210907      *****************************************************************
000487210907      *
000488210907     C     Proof         BegSR
000489210907      *
000490210907      ** Write to Proofing flat file
000491210907      *
000492210907     C                   MOVE      WVDDR         WPDDD
000493210907     C                   MOVE      '/'           WPFI1
000494210907     C                   MOVE      WVMMR         WPMMD
000495210907     C                   MOVE      '/'           WPFI2
000496210907     C                   MOVE      WVYYR         WPYYD
000497210907     C                   MOVE      DSPROFD       KPROOF           10
000498210907      *
000499210907     C     KPROOF        SETLL     XXPROFFL0
000500210907     C     KPROOF        READE     XXPROFFL0                              53
000501210907     C                   Dow       *IN53 = '0' and XXTRDT = KPROOF
000502210907     C                   CLEAR                   XXPRFED0
000503210907     C                   MOVEL     XXTRDT        DSPTRDT
000504210907     C                   MOVEL     ','           DSPFIL1
000505210907     C                   MOVEL     XXPCCY        DSPPCCY
000506210907     C                   MOVEL     ','           DSPFIL2
000507210907     C                   MOVEL     XXPACC        DSPPACC
000508210907     C                   MOVEL     ','           DSPFIL3
000509210907     C                   MOVEL     XXPHOP        DSPPHOP
000510210907     C                   MOVEL     ','           DSPFIL4
000511210907     C                   MOVEL     XXPHOB        DSPPHOB
000512210907     C                   MOVEL     ','           DSPFIL5
000513210907     C                   MOVEL     XXPBLC        DSPPBLC
000514210907     C                   MOVEL     XXPSGN        DSPPSGN
000515210907      *
000516210907     C                   MOVEL     DSPROOF       XXPRFE
000517210907     C                   WRITE     XXPRFED0
000518210907     C     KPROOF        READE     XXPROFFL0                              53
000519210907     C                   ENDDO
000520210907      *
000521210907     C                   ENDSR
000522210907      *****************************************************************
000523210907      /EJECT
000524210907      *****************************************************************
000525210907      *                                                               *
000526210907      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
000527210907      *                                                               *
000528210907      *****************************************************************
000529210907      *
000530210907     C     SRZDate9      BEGSR
000531210907      *
000532210907     C                   CALLB     'ZDATE9'
000533210907     C                   PARM                    PDayNoIn
000534210907     C                   PARM      *ZERO         PDateOutZ9
000535210907     C                   PARM                    PRetCodeZ9
000536210907      *
000537210907     C                   ENDSR
000538210907      *
000539210907      *****************************************************************
000540210907      /Title SR/*PSSR
000541210907      *****************************************************************
000542210907      *                                                               *
000543210907      *  *PSSR  - Program Error Processing Subroutine.                *
000544210907      *                                                               *
000545210907      *  Called By: Various                                           *
000546210907      *                                                               *
000547210907      *****************************************************************
000548210907      *
000549210907     C     *PSSR         BegSR                                                  *** *PSSR  ***
000550210907      *
000551210907      ***  Check to see that *PSSR has not already been called.
000552210907     C                   If        WRUN = *BLANK
000553210907     C                   Move      'Y'           WRUN              1
000554210907     C                   MoveL     'XX005005'    DBPGM
000555210907      *
000556210907     C     *DTAARA       Define    LDA           WLDA            256
000557210907     C     *Lock         In        WLDA
000558210907     C                   MoveL     DBERR         WLDA
000559210907     C                   Out       WLDA
000560210907     C                   SetOn                                        U7U8LR
000561210907      *
000562210907     C                   Dump
000563210907     C                   EndIf
000564210907      *
000565210907      ** Exit program
000566210907     C                   Return
000567210907      *
000568210907     C                   EndSR
000569210907      *
000570210907      *****************************************************************
000571210907      ***
000572210907**  CPY@
000573210907(c) Finastra Ltd 2021
