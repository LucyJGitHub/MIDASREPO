000100210908     H DEBUG
000101210908     H
000102210908      *****************************************************************
000103210908/*STD *  RPGBASEMOD                                                   *
000104210908/*EXI *  TEXT('Midas XX GLM/EDW files Housekeeping')                  *
000105210908      *****************************************************************
000106210908      *                                                               *
000107210908      *  Midas - General Ledger Module                                *
000108210908      *                                                               *
000109210908      *  XX005006 - Midas XX GLM/EDW files Housekeeping               *
000110210908      *                                                               *
000111210908      *  Function: Housekeeping of flat files LNyymmdd and BLyymmdd   *
000112210908      *                                                               *
000113210908      *  Called by: XXC005003 - Midas XX GLM/EDW files Housekeeping   *
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
000125210908      *
000126210908      /Title Function of indicators
000127210908     F*****************************************************************
000128210908     F*                                                               *
000129210908     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
000130210908     F*                                                               *
000131210908     F*                                                               *
000132210908     F*  90-99 - Used by Standard Subroutines                         *
000133210908     F*                                                               *
000134210908     F*  U7+U8 - Database Error                                       *
000135210908     F*                                                               *
000136210908     F*****************************************************************
000137210908      /Title Subroutine Index
000138210908     F*****************************************************************
000139210908     F*                                                               *
000140210908     F*  S U B R O U T I N E   I N D E X                              *
000141210908     F*                                                               *
000142210908     F*  Init      - Initial Processing                               *
000143210908     F*  Proces    - Main processing                                  *
000144210908     F*  ChkSysValue - Retrieve system values                         *
000145210908     F*  SRZDate9  - Date format                                      *
000146210908     F*  SRCvtDate - Convert date format                              *
000147210908     F*                                                               *
000148210908     F*  *PSSR     - Program error handling routine                   *
000149210908     F*                                                               *
000150210908     F*****************************************************************
000151210908     D/Title D-Specifications
000152210908     D CPY@            S             80    Dim(1) CTData PerRCD(1)
000153210908      ***  Array for Object Copyright Statement.
000154210908      *
000155210908     D SDBANK        E DS                  ExtName(SDBANKPD)
000156210908      ** Bank Details
000157210908      *
000158210908     D DSSDY         E DS                  ExtName(DSSDY)
000159210908      ** Second DS For Access Programs, Long Data Structure
000160210908      *
000161210908     D DBERR           DS           256
000162210908      * Data structure for data-base error processing
000163210908     D  DBFILE               134    141
000164210908     D  DBKEY                142    170
000165210908     D  DBPGM                171    180
000166210908     D  DBASE                181    183  0
000167210908      *
000168210908     D                 DS
000169210908
000170210908     D RUNDAT          DS
000171210908      * Data structure for rundate flags
000172210908     D  RUNA                   1      7
000173210908     D  @DLUP                  1      2  0
000174210908     D  @MLUP                  3      5
000175210908     D  @YLUP                  6      7  0
000176210908     D  RUND                   8     10P 0
000177210908     D  @MBIN                 13     13
000178210908      *
000179210908     D P@OP01          S             20A
000180210908     D P@VL01          S            200A
000181210908     D P@OP02          S             20A
000182210908     D P@VL02          S            200A
000183210908     D P@OP03          S             20A
000184210908     D P@VL03          S            200A
000185210908     D P@OP04          S             20A
000186210908     D P@VL04          S            200A
000187210908     D P@OP05          S             20A
000188210908     D P@VL05          S            200A
000189210908     D P@OP06          S             20A
000190210908     D P@VL06          S            200A
000191210908     D P@OP07          S             20A
000192210908     D P@VL07          S            200A
000193210908     D P@OP08          S             20A
000194210908     D P@VL08          S            200A
000195210908     D P@OP09          S             20A
000196210908     D P@VL09          S            200A
000197210908     D P@OP10          S             20A
000198210908     D P@VL10          S            200A
000199210908      *
000200210908     D PSysVal1        C                   CONST('HO_EDW_Ret_Period')
000201210908
000202210908     D PRetPeriod      S              2  0
000203210908
000204210908     D PDateOut        S              6  0
000205210908
000206210908      ** Parameters for ZDATE9
000207210908     D PDaynoIn        S              5P 0
000208210908     D PDateOutZ9      S              8S 0
000209210908     D PRetCodeZ9      S              1  0
000210210908
000211210908      ** YYYYMMDD date format of Retention Date
000212210908     D DSRNDDate       DS
000213210908     D  WVYYR                  1      4  0
000214210908     D  WVY2R                  3      4  0
000215210908     D  WVMMR                  5      6  0
000216210908     D  WVDDR                  7      8  0
000217210908     D  WVRND                  1      8  0
000218210908
000219210908      ** YYYYMMDD date format of Retention Date
000220210908     D DSRetDate       DS
000221210908     D  WRYYR                  1      4  0
000222210908     D  WRY2R                  3      4  0
000223210908     D  WRMMR                  5      6  0
000224210908     D  WRDDR                  7      8  0
000225210908     D  WRRND                  1      8  0
000226210908
000227210908      ** YYMM date format of Retention Date
000228210908     D DSMthRet        DS
000229210908     D  WPYYR                  1      2
000230210908     D  WPMMR                  3      4
000231210908
000232210908     C/Title Main Processing
000233210908      *================================================================
000234210908      *  P R O G R A M     S T A R T                                  *
000235210908      *================================================================
000236210908      *
000237210908      * Perform Initialisation.
000238210908     C                   ExSR      Init
000239210908      *
000240210908      * Perform Main Processing.
000241210908     C                   ExSR      Process
000242210908      *
000243210908     C                   SetOn                                        LR
000244210908     C                   Return
000245210908      *================================================================
000246210908      *  P R O G R A M     E N D                                      *
000247210908      *================================================================
000248210908      /Title SR/Init
000249210908      *****************************************************************
000250210908      *                                                               *
000251210908      *  Init   - Subroutine to do Program Initialisation.            *
000252210908      *                                                               *
000253210908      *  Called By: Main Processing                                   *
000254210908      *  Calls    : None                                              *
000255210908      *                                                               *
000256210908      *****************************************************************
000257210908      *
000258210908     C     Init          BegSR
000259210908      *
000260210908      ***  Copyright Statement.
000261210908     C                   MoveA     CPY@          BIS@             80
000262210908      *
000263210908     C     *ENTRY        PLIST
000264210908     C                   PARM                    PYYMM             4
000265210908      *
000266210908      ** Access Bank Details
000267210908     C                   Call      'AOBANKR0'
000268210908     C                   Parm      '*MSG   '     WRTCD             7
000269210908     C                   Parm      '*FIRST '     WOPTN             7
000270210908     C     SDBANK        Parm      SDBANK        DSSDY
000271210908      *
000272210908     C     WRTCD         IfNE      *BLANKS
000273210908     C                   Z-Add     001           DBASE                          ***************
000274210908     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
000275210908     C                   Move      *Blanks       DBKEY                          ***************
000276210908     C                   ExSR      *PSSR
000277210908     C                   End
000278210908      *
000279210908      ***  Check System Date Format, DDMMYY (*IN98 off)
000280210908      ***                            MMDDYY (*IN98 on).
000281210908      *
000282210908     C                   If        BJDFIN = 'M'
000283210908     C                   SetOn                                        98
000284210908     C                   EndIf
000285210908      *
000286210908     C** Get RUNDAT to access MULTI-BRANCHING flag
000287210908     C     *DTAARA       Define                  RUNDAT
000288210908     C                   In        RUNDAT
000289210908      *
000290210908      ** Retrieve system values details
000291210908     C                   EXSR      ChkSysValue
000292210908      *
000293210908     C                   Z-ADD     BJRDNB        PDaynoIn
000294210908     C                   EXSR      SRZDate9
000295210908     C                   MOVE      PDateOutZ9    DSRndDate
000296210908      *
000297210908     C                   EndSR
000298210908      *****************************************************************
000299210908      /Title SR/Process
000300210908      *****************************************************************
000301210908      *                                                               *
000302210908      *  Process - Subroutine to do the Detail Processing.            *
000303210908      *                                                               *
000304210908      *  Called By: Main Processing                                   *
000305210908      *  Calls:                                                       *
000306210908      *                                                               *
000307210908      *****************************************************************
000308210908      *
000309210908     C     Process       BegSR
000310210908      *
000311210908     C     33            MULT      PretPeriod    KNBDA             5 0
000312210908     C     BJRDNB        SUB       KNBDA         KDAYR             5 0
000313210908      *
000314210908     C                   Z-ADD     KDAYR         PDaynoIn
000315210908     C                   EXSR      SRZDate9
000316210908     C                   MOVE      PDateOutZ9    DSRetDate
000317210908      *
000318210908     C                   MOVE      WRY2R         WPYYR
000319210908     C                   MOVE      WRMMR         WPMMR
000320210908     C                   MOVE      DSMthRet      PYYMM             4
000321210908      *
000322210908     C                   EndSR
000323210908      *
000324210908      *****************************************************************
000325210908      *                                                               *
000326210908      * ChkSysValue - Check for system values                         *
000327210908      *                                                               *
000328210908      * Called by: Main Processing                                    *
000329210908      *                                                               *
000330210908      * Calls:                                                        *
000331210908      *                                                               *
000332210908      *****************************************************************
000333210908      *
000334210908     C     ChkSysValue   BEGSR
000335210908      *
000336210908      ** Check for system values
000337210908     C                   EVAL      @RTCD = *BLANKS
000338210908     C                   EVAL      P@OP01 = PSysVal1
000339210908      *
000340210908     C                   CALL      'AOSVALR0'
000341210908     C                   PARM                    @RTCD             7
000342210908     C                   PARM                    P@OP01
000343210908     C                   PARM      *BLANKS       P@VL01
000344210908     C                   PARM      *BLANKS       P@OP02
000345210908     C                   PARM      *BLANKS       P@VL02
000346210908     C                   PARM      *BLANKS       P@OP03
000347210908     C                   PARM      *BLANKS       P@VL03
000348210908     C                   PARM      *BLANKS       P@OP04
000349210908     C                   PARM      *BLANKS       P@VL04
000350210908     C                   PARM      *BLANKS       P@OP05
000351210908     C                   PARM      *BLANKS       P@VL05
000352210908     C                   PARM      *BLANKS       P@OP06
000353210908     C                   PARM      *BLANKS       P@VL06
000354210908     C                   PARM      *BLANKS       P@OP07
000355210908     C                   PARM      *BLANKS       P@VL07
000356210908     C                   PARM      *BLANKS       P@OP08
000357210908     C                   PARM      *BLANKS       P@VL08
000358210908     C                   PARM      *BLANKS       P@OP09
000359210908     C                   PARM      *BLANKS       P@VL09
000360210908     C                   PARM      *BLANKS       P@OP10
000361210908     C                   PARM      *BLANKS       P@VL10
000362210908
000363210908      ** Setup work fields
000364210908      * Set PRetPeriod = P@VL01
000365210908      *
000366210908     C                   EVAL      PRetPeriod = 0
000367210908      *
000368210908     C                   IF        @RTCD = *BLANKS
000369210908     C                   MOVEL     P@VL01        WKRETP            2
000370210908     C                   MOVEL     WKRETP        PRetPeriod
000371210908     C                   ENDIF
000372210908      *
000373210908     C                   ENDSR
000374210908      *
000375210908      *****************************************************************
000376210908      /EJECT
000377210908      *****************************************************************
000378210908      *                                                               *
000379210908      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
000380210908      *                                                               *
000381210908      *****************************************************************
000382210908
000383210908     C     SRZDate9      BEGSR
000384210908
000385210908     C                   CALLB     'ZDATE9'
000386210908     C                   PARM                    PDayNoIn
000387210908     C                   PARM      *ZERO         PDateOutZ9
000388210908     C                   PARM                    PRetCodeZ9
000389210908
000390210908     C                   ENDSR
000391210908
000392210908      *****************************************************************
000393210908      ** SRCvtDate - Convert date from YYYYMMDD to DDMMYY (or MMDDYY) *
000394210908      *****************************************************************
000395210908     C     SRCvtDate     BEGSR
000396210908
000397210908     C                   CALLB     'ZA0770'
000398210908     C                   PARM      *BLANK        ReturnCode        7
000399210908     C                   PARM                    @DATE             8 0
000400210908     C                   PARM                    BJDFIN
000401210908     C                   PARM      *ZERO         PDateOut
000402210908
000403210908     C                   ENDSR
000404210908      *****************************************************************
000405210908      /Title SR/*PSSR
000406210908      *****************************************************************
000407210908      *                                                               *
000408210908      *  *PSSR  - Program Error Processing Subroutine.                *
000409210908      *                                                               *
000410210908      *  Called By: Various                                           *
000411210908      *                                                               *
000412210908      *****************************************************************
000413210908      *
000414210908     C     *PSSR         BegSR                                                  *** *PSSR  ***
000415210908      *
000416210908      ***  Check to see that *PSSR has not already been called.
000417210908     C                   If        WRUN = *BLANK
000418210908     C                   Move      'Y'           WRUN              1
000419210908     C                   MoveL     'XX005002'    DBPGM
000420210908      *
000421210908     C     *DTAARA       Define    LDA           WLDA            256
000422210908     C     *Lock         In        WLDA
000423210908     C                   MoveL     DBERR         WLDA
000424210908     C                   Out       WLDA
000425210908     C                   SetOn                                        U7U8LR
000426210908      *
000427210908     C                   Dump
000428210908     C                   EndIf
000429210908      *
000430210908      ** Exit program
000431210908     C                   Return
000432210908      *
000433210908     C                   EndSR
000434210908      *
000435210908      *****************************************************************
000436210908      ***
000437210908**  CPY@
000438210908(c) Finastra Ltd 2021
