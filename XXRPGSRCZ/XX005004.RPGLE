000100210907                                                         H DEBUG
000101210907     H
000102210907      *****************************************************************
000103210907/*STD *  RPGBASEMOD                                                   *
000104210907/*EXI *  TEXT('Midas XX GLM Proofing file Generation')                *
000105210907      *****************************************************************
000106210907      *                                                               *
000107210907      *  Midas - General Ledger Module                                *
000108210907      *                                                               *
000109210907      *  XX005004 - Midas XX GLM Proofing file Generation             *
000110210907      *                                                               *
000111210907      *  Function: Proofing File Generation                           *
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
000125210907     FXXACBRC   IF   E           K Disk    InfSR(*PSSR)
000126210907      *
000127210907     FXXACHOML0 IF   E           K Disk    InfSR(*PSSR)
000128210907      *
000129210907     FXXFEEDDL1 IF   E           K Disk    InfSR(*PSSR)
000130210907      *
000131210907     FXXPROFFTD O    E           K Disk    InfSR(*PSSR)
000132210907      *
000133210907      *
000134210907      /Title Function of indicators
000135210907     F*****************************************************************
000136210907     F*                                                               *
000137210907     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
000138210907     F*                                                               *
000139210907     F*                                                               *
000140210907     F*  90-99 - Used by Standard Subroutines                         *
000141210907     F*                                                               *
000142210907     F*  U7+U8 - Database Error                                       *
000143210907     F*                                                               *
000144210907     F*****************************************************************
000145210907      /Title Subroutine Index
000146210907     F*****************************************************************
000147210907     F*                                                               *
000148210907     F*  S U B R O U T I N E   I N D E X                              *
000149210907     F*                                                               *
000150210907     F*  Init      - Initial Processing                               *
000151210907     F*  Proces    - Main processing                                  *
000152210907     F*  EXTPRF    - Proofing File Write                              *
000153210907     F*  ChkSysValue - Retrieve System values                         *
000154210907     F*  SRZDate9  - Date format                                      *
000155210907     F*                                                               *
000156210907     F*  *PSSR     - Program error handling routine                   *
000157210907     F*                                                               *
000158210907     F*****************************************************************
000159210907     D/Title D-Specifications
000160210907     D CPY@            S             80    Dim(1) CTData PerRCD(1)
000161210907      ***  Array for Object Copyright Statement.
000162210907      *
000163210907     D SDBRCH        E DS                  ExtName(SDBRCHPD)
000164210907      ** Branch Details
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
000190210907     D P@OP01          S             20A
000191210907     D P@VL01          S            200A
000192210907     D P@OP02          S             20A
000193210907     D P@VL02          S            200A
000194210907     D P@OP03          S             20A
000195210907     D P@VL03          S            200A
000196210907     D P@OP04          S             20A
000197210907     D P@VL04          S            200A
000198210907     D P@OP05          S             20A
000199210907     D P@VL05          S            200A
000200210907     D P@OP06          S             20A
000201210907     D P@VL06          S            200A
000202210907     D P@OP07          S             20A
000203210907     D P@VL07          S            200A
000204210907     D P@OP08          S             20A
000205210907     D P@VL08          S            200A
000206210907     D P@OP09          S             20A
000207210907     D P@VL09          S            200A
000208210907     D P@OP10          S             20A
000209210907     D P@VL10          S            200A
000210210907      *
000211210907     D PSysVal1        C                   CONST('VLJBranchCode')
000212210907
000213210907     D PBranch         S              3A
000214210907
000215210907     D PDateOut        S              6  0
000216210907
000217210907      ** Parameters for ZDATE9
000218210907     D PDaynoIn        S              5P 0
000219210907     D PDateOutZ9      S              8S 0
000220210907     D PRetCodeZ9      S              1  0
000221210907
000222210907      ** YYMMDD date format of Rundate
000223210907     D DSDayDate       DS
000224210907     D  WVY2D                  1      2  0
000225210907     D  WVMMD                  3      4  0
000226210907     D  WVDDD                  5      6  0
000227210907
000228210907      ** YYYYMMDD date format of Rundate
000229210907     D DSRNDDate       DS
000230210907     D  WVYYR                  1      4  0
000231210907     D  WVY2R                  3      4  0
000232210907     D  WVMMR                  5      6  0
000233210907     D  WVDDR                  7      8  0
000234210907     D  WVRND                  1      8  0
000235210907
000236210907      ** DD/MM/YYYY Format for Rundate
000237210907     D DSRNDDat2       DS
000238210907     D  WRDDR                  1      2
000239210907     D  WRFL1                  3      3
000240210907     D  WRMMR                  4      5
000241210907     D  WRFL2                  6      6
000242210907     D  WRYYR                  7     10
000243210907
000244210907     C/Title Main Processing
000245210907      *================================================================
000246210907      *  P R O G R A M     S T A R T                                  *
000247210907      *================================================================
000248210907      *
000249210907      * Perform Initialisation.
000250210907     C                   ExSR      Init
000251210907      *
000252210907      * Perform Main Processing.
000253210907     C                   ExSR      Process
000254210907      *
000255210907     C                   SetOn                                        LR
000256210907     C                   Return
000257210907      *================================================================
000258210907      *  P R O G R A M     E N D                                      *
000259210907      *================================================================
000260210907      /Title SR/Init
000261210907      *****************************************************************
000262210907      *                                                               *
000263210907      *  Init   - Subroutine to do Program Initialisation.            *
000264210907      *                                                               *
000265210907      *  Called By: Main Processing                                   *
000266210907      *  Calls    : None                                              *
000267210907      *                                                               *
000268210907      *****************************************************************
000269210907      *
000270210907     C     Init          BegSR
000271210907      *
000272210907      ***  Copyright Statement.
000273210907     C                   MoveA     CPY@          BIS@             80
000274210907      *
000275210907      ** Access Bank Details
000276210907     C                   Call      'AOBANKR0'
000277210907     C                   Parm      '*MSG   '     WRTCD             7
000278210907     C                   Parm      '*FIRST '     WOPTN             7
000279210907     C     SDBANK        Parm      SDBANK        DSSDY
000280210907      *
000281210907     C     WRTCD         IfNE      *BLANKS
000282210907     C                   Z-Add     001           DBASE                          ***************
000283210907     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
000284210907     C                   Move      *Blanks       DBKEY                          ***************
000285210907     C                   ExSR      *PSSR
000286210907     C                   End
000287210907      *
000288210907      ***  Check System Date Format, DDMMYY (*IN98 off)
000289210907      ***                            MMDDYY (*IN98 on).
000290210907      *
000291210907     C                   If        BJDFIN = 'M'
000292210907     C                   SetOn                                        98
000293210907     C                   EndIf
000294210907      *
000295210907     C** Get RUNDAT to access MULTI-BRANCHING flag
000296210907     C     *DTAARA       Define                  RUNDAT
000297210907     C                   In        RUNDAT
000298210907      *
000299210907     C                   Z-ADD     BJRDNB        PDaynoIn
000300210907     C                   EXSR      SRZDate9
000301210907     C                   MOVE      PDateOutZ9    DSRndDate
000302210907      *
000303210907     C                   MOVE      WVY2R         WVY2D
000304210907     C                   MOVE      WVMMR         WVMMD
000305210907     C                   MOVE      WVDDR         WVDDD
000306210907     C                   MOVE      DSDayDate     DayDate           6
000307210907
000308210907     C                   MOVE      WVDDR         WRDDR
000309210907     C                   MOVE      '/'           WRFL1
000310210907     C                   MOVE      WVMMR         WRMMR
000311210907     C                   MOVE      '/'           WRFL2
000312210907     C                   MOVE      WVYYR         WRYYR
000313210907      *
000314210907      ***Klist*to*access the ACBRC file
000315210907      ** Klist to access the XXACBRC file
000316210907     C     KList1        KList
000317210907     C                   KFld                    KACO2            10 0
000318210907     C                   KFld                    KCCY              3
000319210907      *
000320210907      ** Klist to access the XXFEEDTD file
000321210907     C     KList2        KList
000322210907     C                   KFld                    K2ACOD           10
000323210907     C                   KFld                    K2CCY             3
000324210907     C                   KFld                    K2RND             5 0
000325210907      *
000326210907      ** Retrieve system values details
000327210907     C                   EXSR      ChkSysValue
000328210907      *
000329210907     C                   EndSR
000330210907      *****************************************************************
000331210907      /Title SR/Process
000332210907      *****************************************************************
000333210907      *                                                               *
000334210907      *  Process - Subroutine to do the Detail Processing.            *
000335210907      *                                                               *
000336210907      *  Called By: Main Processing                                   *
000337210907      *  Calls:                                                       *
000338210907      *                                                               *
000339210907      *****************************************************************
000340210907      *
000341210907     C     Process       BegSR
000342210907      *
000343210907     C                   MOVEL     *BLANKS       KCCY
000344210907     C                   Z-ADD     0             KACO2
000345210907     C                   Z-ADD     0             WKLDBL           19 0
000346210907      *
000347210907      ***  Read the Accound Code file and access ACCNTAB to retrieve
000348210907      ***  Balance by CCY/ACOD
000349210907     C     *LOVAL        Setll     XXACHOML0
000350210907     C                   READ      XXACHOML0                              50
000351210907      *
000352210907b1   C                   Dow       *In50 = '0'
000353210907      *
000354210907      ***  Access the Account details by CCY / ACOD
000355210907     C                   MOVEL     *BLANKS       KCCY
000356210907     C                   Z-ADD     XXMACOD       KACO2            10 0
000357210907     C     KList1        SETLL     XXACBRC
000358210907     C                   READ      XXACBRC                                51
000359210907      *
000360210907b2   C                   If        *IN51 = '0' and CCY <> KCCY
000361210907     C                             and RECI = 'D'
000362210907     C                   MOVE      CCY           KCCY
000363210907e2   C                   ENDIF
000364210907      *
000365210907b2   C                   Dow       *In51 = '0'
000366210907b3   C                   If        CCY = KCCY and ACOD = KACO2
000367210907     C                             and RECI = 'D'
000368210907      ** Calculate Total Ledger Balance
000369210907     C                   Add       LDBL          WKLDBL
000370210907     C                   READ      XXACBRC                                51
000371210907x3   C                   Else
000372210907b4   C                   If        ACOD <> KACO2
000373210907     C                   MOVE      '1'           *IN51
000374210907x4   C                   Else
000375210907      ***  Access the Feeder details for Total DR/CR
000376210907     C                   Z-ADD     BJRDNB        K2RND
000377210907     C                   MOVEL     KCCY          K2CCY
000378210907     C                   MOVEL     XXMACOD       K2ACOD
000379210907     C     Klist2        SETLL     XXFEEDDL1
000380210907     C     Klist2        READE     XXFEEDDL1                              52
000381210907      *
000382210907b5   C                   Dow       *In52 = '0'
000383210907      *
000384210907b6   C                   If        XXDCCYL = K2CCY and XXDACOD = K2ACOD
000385210907      *
000386210907      ** Calculate Total Ledger Balance
000387210907b7   C                   If        XXDDRCR = 'D'
000388210907     C                   Add       XXDPSTA       WKTOTDR          19 0
000389210907     C                   Else
000390210907     C                   Add       XXDPSTA       WKTOTCR          19 0
000391210907e7   C                   Endif
000392210907     C     Klist2        READE     XXFEEDDL1                              52
000393210907x6   C                   Else
000394210907     C                   MOVE      '1'           *IN52
000395210907e6   C                   ENDIF
000396210907e5   C                   EndDo
000397210907      *
000398210907      ** Write Proofing Record
000399210907     C                   EXSR      EXTPRF
000400210907     C                   MOVE      CCY           KCCY
000401210907     C                   Z-ADD     ACOD          KACO2
000402210907     C                   Z-ADD     0             WKLDBL
000403210907e4   C                   Endif
000404210907e3   C                   Endif
000405210907e2   C                   Enddo
000406210907      ** Write Proofing Record
000407210907      *
000408210907     C                   READ      XXACHOML0                              50
000409210907e1   C                   EndDo
000410210907      *
000411210907     C                   EndSR
000412210907      *
000413210907      *****************************************************************
000414210907      *                                                               *
000415210907      * EXTPRF - Write Proofing Record                                *
000416210907      *                                                               *
000417210907      * Called by: Main Processing                                    *
000418210907      *                                                               *
000419210907      * Calls:                                                        *
000420210907      *                                                               *
000421210907      *****************************************************************
000422210907      *
000423210907     C     EXTPRF        BEGSR
000424210907      *
000425210907     C                   CLEAR                   XXPROFFD0
000426210907      ** Rundate
000427210907     C                   MOVEL     DSRndDat2     XXTRDT
000428210907      ** CCY
000429210907     C                   MOVEL     KCCY          XXPCCY
000430210907      ** Account Code
000431210907     C                   MOVEL     KACO2         XXPACC
000432210907      ** HO Product Code
000433210907     C                   MOVE      XXMHOPC       XXPHOP
000434210907      ** Branch
000435210907     C                   MOVE      PBranch       XXPHOB
000436210907      ** Net Balance calculated
000437210907     C     WKLDBL        SUB       WKTOTCR       WKBLC1           19 0
000438210907     C     WKBLC1        ADD       WKTOTDR       WKBLC2           19 0
000439210907     C                   Z-ADD     WKBLC2        XXPBLC
000440210907      ** Sign
000441210907     C                   If        XXPBLC < 0
000442210907     C     WKBLC2        MULT      -1            XXPBLC
000443210907     C                   MOVE      '-'           XXPSGN
000444210907     C                   Else
000445210907     C                   MOVE      ' '           XXPSGN
000446210907     C                   ENDIF
000447210907      *
000448210907     C                   WRITE     XXPROFFD0
000449210907      *
000450210907     C                   Z-ADD     0             WKBLC1
000451210907     C                   Z-ADD     0             WKBLC2
000452210907      *
000453210907     C                   Z-ADD     0             WKTOTCR
000454210907     C                   Z-ADD     0             WKTOTDR
000455210907      *
000456210907     C                   ENDSR
000457210907      *
000458210907      *****************************************************************
000459210907      *                                                               *
000460210907      * ChkSysValue - Check for system values                         *
000461210907      *                                                               *
000462210907      * Called by: Main Processing                                    *
000463210907      *                                                               *
000464210907      * Calls:                                                        *
000465210907      *                                                               *
000466210907      *****************************************************************
000467210907      *
000468210907     C     ChkSysValue   BEGSR
000469210907      *
000470210907      ** Check for system values
000471210907     C                   EVAL      @RTCD = *BLANKS
000472210907     C                   EVAL      P@OP01 = PSysVal1
000473210907      *
000474210907     C                   CALL      'AOSVALR0'
000475210907     C                   PARM                    @RTCD             7
000476210907     C                   PARM                    P@OP01
000477210907     C                   PARM      *BLANKS       P@VL01
000478210907     C                   PARM      *BLANKS       P@OP02
000479210907     C                   PARM      *BLANKS       P@VL02
000480210907     C                   PARM      *BLANKS       P@OP03
000481210907     C                   PARM      *BLANKS       P@VL03
000482210907     C                   PARM      *BLANKS       P@OP04
000483210907     C                   PARM      *BLANKS       P@VL04
000484210907     C                   PARM      *BLANKS       P@OP05
000485210907     C                   PARM      *BLANKS       P@VL05
000486210907     C                   PARM      *BLANKS       P@OP06
000487210907     C                   PARM      *BLANKS       P@VL06
000488210907     C                   PARM      *BLANKS       P@OP07
000489210907     C                   PARM      *BLANKS       P@VL07
000490210907     C                   PARM      *BLANKS       P@OP08
000491210907     C                   PARM      *BLANKS       P@VL08
000492210907     C                   PARM      *BLANKS       P@OP09
000493210907     C                   PARM      *BLANKS       P@VL09
000494210907     C                   PARM      *BLANKS       P@OP10
000495210907     C                   PARM      *BLANKS       P@VL10
000496210907
000497210907      ** Setup work fields
000498210907      * Set PBranch  = P@VL01
000499210907      *
000500210907     C                   EVAL      PBranch = *BLANKS
000501210907      *
000502210907     C                   IF        @RTCD = *BLANKS
000503210907     C                   EVAL      PBranch = P@VL01
000504210907     C                   ENDIF
000505210907      *
000506210907     C                   ENDSR
000507210907      *
000508210907      *****************************************************************
000509210907      /EJECT
000510210907      *****************************************************************
000511210907      *                                                               *
000512210907      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
000513210907      *                                                               *
000514210907      *****************************************************************
000515210907      *
000516210907     C     SRZDate9      BEGSR
000517210907      *
000518210907     C                   CALLB     'ZDATE9'
000519210907     C                   PARM                    PDayNoIn
000520210907     C                   PARM      *ZERO         PDateOutZ9
000521210907     C                   PARM                    PRetCodeZ9
000522210907      *
000523210907     C                   ENDSR
000524210907      *
000525210907      *****************************************************************
000526210907      /Title SR/*PSSR
000527210907      *****************************************************************
000528210907      *                                                               *
000529210907      *  *PSSR  - Program Error Processing Subroutine.                *
000530210907      *                                                               *
000531210907      *  Called By: Various                                           *
000532210907      *                                                               *
000533210907      *****************************************************************
000534210907      *
000535210907     C     *PSSR         BegSR                                                  *** *PSSR  ***
000536210907      *
000537210907      ***  Check to see that *PSSR has not already been called.
000538210907     C                   If        WRUN = *BLANK
000539210907     C                   Move      'Y'           WRUN              1
000540210907     C                   MoveL     'XX005004'    DBPGM
000541210907      *
000542210907     C     *DTAARA       Define    LDA           WLDA            256
000543210907     C     *Lock         In        WLDA
000544210907     C                   MoveL     DBERR         WLDA
000545210907     C                   Out       WLDA
000546210907     C                   SetOn                                        U7U8LR
000547210907      *
000548210907     C                   Dump
000549210907     C                   EndIf
000550210907      *
000551210907      ** Exit program
000552210907     C                   Return
000553210907      *
000554210907     C                   EndSR
000555210907      *
000556210907      *****************************************************************
000557210907      ***
000558210907**  CPY@
000559210907(c) Finastra Ltd 2021
