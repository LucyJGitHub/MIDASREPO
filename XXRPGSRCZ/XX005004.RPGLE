000100210908     H DEBUG
000101210908     H
000102210908      *****************************************************************
000103210908/*STD *  RPGBASEMOD                                                   *
000104210908/*EXI *  TEXT('Midas XX GLM Proofing file Generation')                *
000105210908      *****************************************************************
000106210908      *                                                               *
000107210908      *  Midas - General Ledger Module                                *
000108210908      *                                                               *
000109210908      *  XX005004 - Midas XX GLM Proofing file Generation             *
000110210908      *                                                               *
000111210908      *  Function: Proofing File Generation                           *
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
000125210908     FXXACBRC   IF   E           K Disk    InfSR(*PSSR)
000126210908      *
000127210908     FXXACHOML0 IF   E           K Disk    InfSR(*PSSR)
000128210908      *
000129210908     FXXFEEDDL1 IF   E           K Disk    InfSR(*PSSR)
000130210908      *
000131210908     FXXPROFFTD O    E           K Disk    InfSR(*PSSR)
000132210908      *
000133210908      *
000134210908      /Title Function of indicators
000135210908     F*****************************************************************
000136210908     F*                                                               *
000137210908     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
000138210908     F*                                                               *
000139210908     F*                                                               *
000140210908     F*  90-99 - Used by Standard Subroutines                         *
000141210908     F*                                                               *
000142210908     F*  U7+U8 - Database Error                                       *
000143210908     F*                                                               *
000144210908     F*****************************************************************
000145210908      /Title Subroutine Index
000146210908     F*****************************************************************
000147210908     F*                                                               *
000148210908     F*  S U B R O U T I N E   I N D E X                              *
000149210908     F*                                                               *
000150210908     F*  Init      - Initial Processing                               *
000151210908     F*  Proces    - Main processing                                  *
000152210908     F*  EXTPRF    - Proofing File Write                              *
000153210908     F*  ChkSysValue - Retrieve System values                         *
000154210908     F*  SRZDate9  - Date format                                      *
000155210908     F*                                                               *
000156210908     F*  *PSSR     - Program error handling routine                   *
000157210908     F*                                                               *
000158210908     F*****************************************************************
000159210908     D/Title D-Specifications
000160210908     D CPY@            S             80    Dim(1) CTData PerRCD(1)
000161210908      ***  Array for Object Copyright Statement.
000162210908      *
000163210908     D SDBRCH        E DS                  ExtName(SDBRCHPD)
000164210908      ** Branch Details
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
000190210908     D P@OP01          S             20A
000191210908     D P@VL01          S            200A
000192210908     D P@OP02          S             20A
000193210908     D P@VL02          S            200A
000194210908     D P@OP03          S             20A
000195210908     D P@VL03          S            200A
000196210908     D P@OP04          S             20A
000197210908     D P@VL04          S            200A
000198210908     D P@OP05          S             20A
000199210908     D P@VL05          S            200A
000200210908     D P@OP06          S             20A
000201210908     D P@VL06          S            200A
000202210908     D P@OP07          S             20A
000203210908     D P@VL07          S            200A
000204210908     D P@OP08          S             20A
000205210908     D P@VL08          S            200A
000206210908     D P@OP09          S             20A
000207210908     D P@VL09          S            200A
000208210908     D P@OP10          S             20A
000209210908     D P@VL10          S            200A
000210210908      *
000211210908     D PSysVal1        C                   CONST('VLJBranchCode')
000212210908
000213210908     D PBranch         S              3A
000214210908
000215210908     D PDateOut        S              6  0
000216210908
000217210908      ** Parameters for ZDATE9
000218210908     D PDaynoIn        S              5P 0
000219210908     D PDateOutZ9      S              8S 0
000220210908     D PRetCodeZ9      S              1  0
000221210908
000222210908      ** YYMMDD date format of Rundate
000223210908     D DSDayDate       DS
000224210908     D  WVY2D                  1      2  0
000225210908     D  WVMMD                  3      4  0
000226210908     D  WVDDD                  5      6  0
000227210908
000228210908      ** YYYYMMDD date format of Rundate
000229210908     D DSRNDDate       DS
000230210908     D  WVYYR                  1      4  0
000231210908     D  WVY2R                  3      4  0
000232210908     D  WVMMR                  5      6  0
000233210908     D  WVDDR                  7      8  0
000234210908     D  WVRND                  1      8  0
000235210908
000236210908      ** DD/MM/YYYY Format for Rundate
000237210908     D DSRNDDat2       DS
000238210908     D  WRDDR                  1      2
000239210908     D  WRFL1                  3      3
000240210908     D  WRMMR                  4      5
000241210908     D  WRFL2                  6      6
000242210908     D  WRYYR                  7     10
000243210908
000244210908     C/Title Main Processing
000245210908      *================================================================
000246210908      *  P R O G R A M     S T A R T                                  *
000247210908      *================================================================
000248210908      *
000249210908      * Perform Initialisation.
000250210908     C                   ExSR      Init
000251210908      *
000252210908      * Perform Main Processing.
000253210908     C                   ExSR      Process
000254210908      *
000255210908     C                   SetOn                                        LR
000256210908     C                   Return
000257210908      *================================================================
000258210908      *  P R O G R A M     E N D                                      *
000259210908      *================================================================
000260210908      /Title SR/Init
000261210908      *****************************************************************
000262210908      *                                                               *
000263210908      *  Init   - Subroutine to do Program Initialisation.            *
000264210908      *                                                               *
000265210908      *  Called By: Main Processing                                   *
000266210908      *  Calls    : None                                              *
000267210908      *                                                               *
000268210908      *****************************************************************
000269210908      *
000270210908     C     Init          BegSR
000271210908      *
000272210908      ***  Copyright Statement.
000273210908     C                   MoveA     CPY@          BIS@             80
000274210908      *
000275210908      ** Access Bank Details
000276210908     C                   Call      'AOBANKR0'
000277210908     C                   Parm      '*MSG   '     WRTCD             7
000278210908     C                   Parm      '*FIRST '     WOPTN             7
000279210908     C     SDBANK        Parm      SDBANK        DSSDY
000280210908      *
000281210908     C     WRTCD         IfNE      *BLANKS
000282210908     C                   Z-Add     001           DBASE                          ***************
000283210908     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
000284210908     C                   Move      *Blanks       DBKEY                          ***************
000285210908     C                   ExSR      *PSSR
000286210908     C                   End
000287210908      *
000288210908      ***  Check System Date Format, DDMMYY (*IN98 off)
000289210908      ***                            MMDDYY (*IN98 on).
000290210908      *
000291210908     C                   If        BJDFIN = 'M'
000292210908     C                   SetOn                                        98
000293210908     C                   EndIf
000294210908      *
000295210908     C** Get RUNDAT to access MULTI-BRANCHING flag
000296210908     C     *DTAARA       Define                  RUNDAT
000297210908     C                   In        RUNDAT
000298210908      *
000299210908     C                   Z-ADD     BJRDNB        PDaynoIn
000300210908     C                   EXSR      SRZDate9
000301210908     C                   MOVE      PDateOutZ9    DSRndDate
000302210908      *
000303210908     C                   MOVE      WVY2R         WVY2D
000304210908     C                   MOVE      WVMMR         WVMMD
000305210908     C                   MOVE      WVDDR         WVDDD
000306210908     C                   MOVE      DSDayDate     DayDate           6
000307210908
000308210908     C                   MOVE      WVDDR         WRDDR
000309210908     C                   MOVE      '/'           WRFL1
000310210908     C                   MOVE      WVMMR         WRMMR
000311210908     C                   MOVE      '/'           WRFL2
000312210908     C                   MOVE      WVYYR         WRYYR
000313210908      *
000314210908      ***Klist*to*access the ACBRC file
000315210908      ** Klist to access the XXACBRC file
000316210908     C     KList1        KList
000317210908     C                   KFld                    KACO2            10 0
000318210908     C                   KFld                    KCCY              3
000319210908      *
000320210908      ** Klist to access the XXFEEDTD file
000321210908     C     KList2        KList
000322210908     C                   KFld                    K2ACOD           10
000323210908     C                   KFld                    K2CCY             3
000324210908     C                   KFld                    K2RND             5 0
000325210908      *
000326210908      ** Retrieve system values details
000327210908     C                   EXSR      ChkSysValue
000328210908      *
000329210908     C                   EndSR
000330210908      *****************************************************************
000331210908      /Title SR/Process
000332210908      *****************************************************************
000333210908      *                                                               *
000334210908      *  Process - Subroutine to do the Detail Processing.            *
000335210908      *                                                               *
000336210908      *  Called By: Main Processing                                   *
000337210908      *  Calls:                                                       *
000338210908      *                                                               *
000339210908      *****************************************************************
000340210908      *
000341210908     C     Process       BegSR
000342210908      *
000343210908     C                   MOVEL     *BLANKS       KCCY
000344210908     C                   Z-ADD     0             KACO2
000345210908     C                   Z-ADD     0             WKLDBL           19 0
000346210908      *
000347210908      ***  Read the Accound Code file and access ACCNTAB to retrieve
000348210908      ***  Balance by CCY/ACOD
000349210908     C     *LOVAL        Setll     XXACHOML0
000350210908     C                   READ      XXACHOML0                              50
000351210908      *
000352210908b1   C                   Dow       *In50 = '0'
000353210908      *
000354210908      ***  Access the Account details by CCY / ACOD
000355210908     C                   MOVEL     *BLANKS       KCCY
000356210908     C                   Z-ADD     XXMACOD       KACO2            10 0
000357210908     C     KList1        SETLL     XXACBRC
000358210908     C                   READ      XXACBRC                                51
000359210908      *
000360210908b2   C                   If        *IN51 = '0' and CCY <> KCCY
000361210908     C                             and RECI = 'D'
000362210908     C                   MOVE      CCY           KCCY
000363210908e2   C                   ENDIF
000364210908      *
000365210908b2   C                   Dow       *In51 = '0'
000366210908b3   C                   If        CCY = KCCY and ACOD = KACO2
000367210908     C                             and RECI = 'D'
000368210908      ** Calculate Total Ledger Balance
000369210908     C                   Add       LDBL          WKLDBL
000370210908     C                   READ      XXACBRC                                51
000371210908x3   C                   Else
000372210908b4   C                   If        ACOD <> KACO2
000373210908     C                   MOVE      '1'           *IN51
000374210908x4   C                   Else
000375210908      ***  Access the Feeder details for Total DR/CR
000376210908     C                   Z-ADD     BJRDNB        K2RND
000377210908     C                   MOVEL     KCCY          K2CCY
000378210908     C                   MOVEL     XXMACOD       K2ACOD
000379210908     C     Klist2        SETLL     XXFEEDDL1
000380210908     C     Klist2        READE     XXFEEDDL1                              52
000381210908      *
000382210908b5   C                   Dow       *In52 = '0'
000383210908      *
000384210908b6   C                   If        XXDCCYL = K2CCY and XXDACOD = K2ACOD
000385210908      *
000386210908      ** Calculate Total Ledger Balance
000387210908b7   C                   If        XXDDRCR = 'D'
000388210908     C                   Add       XXDPSTA       WKTOTDR          19 0
000389210908     C                   Else
000390210908     C                   Add       XXDPSTA       WKTOTCR          19 0
000391210908e7   C                   Endif
000392210908     C     Klist2        READE     XXFEEDDL1                              52
000393210908x6   C                   Else
000394210908     C                   MOVE      '1'           *IN52
000395210908e6   C                   ENDIF
000396210908e5   C                   EndDo
000397210908      *
000398210908      ** Write Proofing Record
000399210908     C                   EXSR      EXTPRF
000400210908     C                   MOVE      CCY           KCCY
000401210908     C                   Z-ADD     ACOD          KACO2
000402210908     C                   Z-ADD     0             WKLDBL
000403210908e4   C                   Endif
000404210908e3   C                   Endif
000405210908e2   C                   Enddo
000406210908      ** Write Proofing Record
000407210908      *
000408210908     C                   READ      XXACHOML0                              50
000409210908e1   C                   EndDo
000410210908      *
000411210908     C                   EndSR
000412210908      *
000413210908      *****************************************************************
000414210908      *                                                               *
000415210908      * EXTPRF - Write Proofing Record                                *
000416210908      *                                                               *
000417210908      * Called by: Main Processing                                    *
000418210908      *                                                               *
000419210908      * Calls:                                                        *
000420210908      *                                                               *
000421210908      *****************************************************************
000422210908      *
000423210908     C     EXTPRF        BEGSR
000424210908      *
000425210908     C                   CLEAR                   XXPROFFD0
000426210908      ** Rundate
000427210908     C                   MOVEL     DSRndDat2     XXTRDT
000428210908      ** CCY
000429210908     C                   MOVEL     KCCY          XXPCCY
000430210908      ** Account Code
000431210908     C                   MOVEL     KACO2         XXPACC
000432210908      ** HO Product Code
000433210908     C                   MOVE      XXMHOPC       XXPHOP
000434210908      ** Branch
000435210908     C                   MOVE      PBranch       XXPHOB
000436210908      ** Net Balance calculated
000437210908     C     WKLDBL        SUB       WKTOTCR       WKBLC1           19 0
000438210908     C     WKBLC1        ADD       WKTOTDR       WKBLC2           19 0
000439210908     C                   Z-ADD     WKBLC2        XXPBLC
000440210908      ** Sign
000441210908     C                   If        XXPBLC < 0
000442210908     C     WKBLC2        MULT      -1            XXPBLC
000443210908     C                   MOVE      '-'           XXPSGN
000444210908     C                   Else
000445210908     C                   MOVE      ' '           XXPSGN
000446210908     C                   ENDIF
000447210908      *
000448210908     C                   WRITE     XXPROFFD0
000449210908      *
000450210908     C                   Z-ADD     0             WKBLC1
000451210908     C                   Z-ADD     0             WKBLC2
000452210908      *
000453210908     C                   Z-ADD     0             WKTOTCR
000454210908     C                   Z-ADD     0             WKTOTDR
000455210908      *
000456210908     C                   ENDSR
000457210908      *
000458210908      *****************************************************************
000459210908      *                                                               *
000460210908      * ChkSysValue - Check for system values                         *
000461210908      *                                                               *
000462210908      * Called by: Main Processing                                    *
000463210908      *                                                               *
000464210908      * Calls:                                                        *
000465210908      *                                                               *
000466210908      *****************************************************************
000467210908      *
000468210908     C     ChkSysValue   BEGSR
000469210908      *
000470210908      ** Check for system values
000471210908     C                   EVAL      @RTCD = *BLANKS
000472210908     C                   EVAL      P@OP01 = PSysVal1
000473210908      *
000474210908     C                   CALL      'AOSVALR0'
000475210908     C                   PARM                    @RTCD             7
000476210908     C                   PARM                    P@OP01
000477210908     C                   PARM      *BLANKS       P@VL01
000478210908     C                   PARM      *BLANKS       P@OP02
000479210908     C                   PARM      *BLANKS       P@VL02
000480210908     C                   PARM      *BLANKS       P@OP03
000481210908     C                   PARM      *BLANKS       P@VL03
000482210908     C                   PARM      *BLANKS       P@OP04
000483210908     C                   PARM      *BLANKS       P@VL04
000484210908     C                   PARM      *BLANKS       P@OP05
000485210908     C                   PARM      *BLANKS       P@VL05
000486210908     C                   PARM      *BLANKS       P@OP06
000487210908     C                   PARM      *BLANKS       P@VL06
000488210908     C                   PARM      *BLANKS       P@OP07
000489210908     C                   PARM      *BLANKS       P@VL07
000490210908     C                   PARM      *BLANKS       P@OP08
000491210908     C                   PARM      *BLANKS       P@VL08
000492210908     C                   PARM      *BLANKS       P@OP09
000493210908     C                   PARM      *BLANKS       P@VL09
000494210908     C                   PARM      *BLANKS       P@OP10
000495210908     C                   PARM      *BLANKS       P@VL10
000496210908
000497210908      ** Setup work fields
000498210908      * Set PBranch  = P@VL01
000499210908      *
000500210908     C                   EVAL      PBranch = *BLANKS
000501210908      *
000502210908     C                   IF        @RTCD = *BLANKS
000503210908     C                   EVAL      PBranch = P@VL01
000504210908     C                   ENDIF
000505210908      *
000506210908     C                   ENDSR
000507210908      *
000508210908      *****************************************************************
000509210908      /EJECT
000510210908      *****************************************************************
000511210908      *                                                               *
000512210908      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
000513210908      *                                                               *
000514210908      *****************************************************************
000515210908      *
000516210908     C     SRZDate9      BEGSR
000517210908      *
000518210908     C                   CALLB     'ZDATE9'
000519210908     C                   PARM                    PDayNoIn
000520210908     C                   PARM      *ZERO         PDateOutZ9
000521210908     C                   PARM                    PRetCodeZ9
000522210908      *
000523210908     C                   ENDSR
000524210908      *
000525210908      *****************************************************************
000526210908      /Title SR/*PSSR
000527210908      *****************************************************************
000528210908      *                                                               *
000529210908      *  *PSSR  - Program Error Processing Subroutine.                *
000530210908      *                                                               *
000531210908      *  Called By: Various                                           *
000532210908      *                                                               *
000533210908      *****************************************************************
000534210908      *
000535210908     C     *PSSR         BegSR                                                  *** *PSSR  ***
000536210908      *
000537210908      ***  Check to see that *PSSR has not already been called.
000538210908     C                   If        WRUN = *BLANK
000539210908     C                   Move      'Y'           WRUN              1
000540210908     C                   MoveL     'XX005004'    DBPGM
000541210908      *
000542210908     C     *DTAARA       Define    LDA           WLDA            256
000543210908     C     *Lock         In        WLDA
000544210908     C                   MoveL     DBERR         WLDA
000545210908     C                   Out       WLDA
000546210908     C                   SetOn                                        U7U8LR
000547210908      *
000548210908     C                   Dump
000549210908     C                   EndIf
000550210908      *
000551210908      ** Exit program
000552210908     C                   Return
000553210908      *
000554210908     C                   EndSR
000555210908      *
000556210908      *****************************************************************
000557210908      ***
000558210908**  CPY@
000559210908(c) Finastra Ltd 2021
