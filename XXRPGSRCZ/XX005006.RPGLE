000100210907                                           H DEBUG
000101210907     H
000102210907      *****************************************************************
000103210907/*STD *  RPGBASEMOD                                                   *
000104210907/*EXI *  TEXT('Midas XX GLM/EDW files Housekeeping')                  *
000105210907      *****************************************************************
000106210907      *                                                               *
000107210907      *  Midas - General Ledger Module                                *
000108210907      *                                                               *
000109210907      *  XX005006 - Midas XX GLM/EDW files Housekeeping               *
000110210907      *                                                               *
000111210907      *  Function: Housekeeping of flat files LNyymmdd and BLyymmdd   *
000112210907      *                                                               *
000113210907      *  Called by: XXC005003 - Midas XX GLM/EDW files Housekeeping   *
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
000125210907      *
000126210907      /Title Function of indicators
000127210907     F*****************************************************************
000128210907     F*                                                               *
000129210907     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
000130210907     F*                                                               *
000131210907     F*                                                               *
000132210907     F*  90-99 - Used by Standard Subroutines                         *
000133210907     F*                                                               *
000134210907     F*  U7+U8 - Database Error                                       *
000135210907     F*                                                               *
000136210907     F*****************************************************************
000137210907      /Title Subroutine Index
000138210907     F*****************************************************************
000139210907     F*                                                               *
000140210907     F*  S U B R O U T I N E   I N D E X                              *
000141210907     F*                                                               *
000142210907     F*  Init      - Initial Processing                               *
000143210907     F*  Proces    - Main processing                                  *
000144210907     F*  ChkSysValue - Retrieve system values                         *
000145210907     F*  SRZDate9  - Date format                                      *
000146210907     F*  SRCvtDate - Convert date format                              *
000147210907     F*                                                               *
000148210907     F*  *PSSR     - Program error handling routine                   *
000149210907     F*                                                               *
000150210907     F*****************************************************************
000151210907     D/Title D-Specifications
000152210907     D CPY@            S             80    Dim(1) CTData PerRCD(1)
000153210907      ***  Array for Object Copyright Statement.
000154210907      *
000155210907     D SDBANK        E DS                  ExtName(SDBANKPD)
000156210907      ** Bank Details
000157210907      *
000158210907     D DSSDY         E DS                  ExtName(DSSDY)
000159210907      ** Second DS For Access Programs, Long Data Structure
000160210907      *
000161210907     D DBERR           DS           256
000162210907      * Data structure for data-base error processing
000163210907     D  DBFILE               134    141
000164210907     D  DBKEY                142    170
000165210907     D  DBPGM                171    180
000166210907     D  DBASE                181    183  0
000167210907      *
000168210907     D                 DS
000169210907
000170210907     D RUNDAT          DS
000171210907      * Data structure for rundate flags
000172210907     D  RUNA                   1      7
000173210907     D  @DLUP                  1      2  0
000174210907     D  @MLUP                  3      5
000175210907     D  @YLUP                  6      7  0
000176210907     D  RUND                   8     10P 0
000177210907     D  @MBIN                 13     13
000178210907      *
000179210907     D P@OP01          S             20A
000180210907     D P@VL01          S            200A
000181210907     D P@OP02          S             20A
000182210907     D P@VL02          S            200A
000183210907     D P@OP03          S             20A
000184210907     D P@VL03          S            200A
000185210907     D P@OP04          S             20A
000186210907     D P@VL04          S            200A
000187210907     D P@OP05          S             20A
000188210907     D P@VL05          S            200A
000189210907     D P@OP06          S             20A
000190210907     D P@VL06          S            200A
000191210907     D P@OP07          S             20A
000192210907     D P@VL07          S            200A
000193210907     D P@OP08          S             20A
000194210907     D P@VL08          S            200A
000195210907     D P@OP09          S             20A
000196210907     D P@VL09          S            200A
000197210907     D P@OP10          S             20A
000198210907     D P@VL10          S            200A
000199210907      *
000200210907     D PSysVal1        C                   CONST('HO_EDW_Ret_Period')
000201210907
000202210907     D PRetPeriod      S              2  0
000203210907
000204210907     D PDateOut        S              6  0
000205210907
000206210907      ** Parameters for ZDATE9
000207210907     D PDaynoIn        S              5P 0
000208210907     D PDateOutZ9      S              8S 0
000209210907     D PRetCodeZ9      S              1  0
000210210907
000211210907      ** YYYYMMDD date format of Retention Date
000212210907     D DSRNDDate       DS
000213210907     D  WVYYR                  1      4  0
000214210907     D  WVY2R                  3      4  0
000215210907     D  WVMMR                  5      6  0
000216210907     D  WVDDR                  7      8  0
000217210907     D  WVRND                  1      8  0
000218210907
000219210907      ** YYYYMMDD date format of Retention Date
000220210907     D DSRetDate       DS
000221210907     D  WRYYR                  1      4  0
000222210907     D  WRY2R                  3      4  0
000223210907     D  WRMMR                  5      6  0
000224210907     D  WRDDR                  7      8  0
000225210907     D  WRRND                  1      8  0
000226210907
000227210907      ** YYMM date format of Retention Date
000228210907     D DSMthRet        DS
000229210907     D  WPYYR                  1      2
000230210907     D  WPMMR                  3      4
000231210907
000232210907     C/Title Main Processing
000233210907      *================================================================
000234210907      *  P R O G R A M     S T A R T                                  *
000235210907      *================================================================
000236210907      *
000237210907      * Perform Initialisation.
000238210907     C                   ExSR      Init
000239210907      *
000240210907      * Perform Main Processing.
000241210907     C                   ExSR      Process
000242210907      *
000243210907     C                   SetOn                                        LR
000244210907     C                   Return
000245210907      *================================================================
000246210907      *  P R O G R A M     E N D                                      *
000247210907      *================================================================
000248210907      /Title SR/Init
000249210907      *****************************************************************
000250210907      *                                                               *
000251210907      *  Init   - Subroutine to do Program Initialisation.            *
000252210907      *                                                               *
000253210907      *  Called By: Main Processing                                   *
000254210907      *  Calls    : None                                              *
000255210907      *                                                               *
000256210907      *****************************************************************
000257210907      *
000258210907     C     Init          BegSR
000259210907      *
000260210907      ***  Copyright Statement.
000261210907     C                   MoveA     CPY@          BIS@             80
000262210907      *
000263210907     C     *ENTRY        PLIST
000264210907     C                   PARM                    PYYMM             4
000265210907      *
000266210907      ** Access Bank Details
000267210907     C                   Call      'AOBANKR0'
000268210907     C                   Parm      '*MSG   '     WRTCD             7
000269210907     C                   Parm      '*FIRST '     WOPTN             7
000270210907     C     SDBANK        Parm      SDBANK        DSSDY
000271210907      *
000272210907     C     WRTCD         IfNE      *BLANKS
000273210907     C                   Z-Add     001           DBASE                          ***************
000274210907     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
000275210907     C                   Move      *Blanks       DBKEY                          ***************
000276210907     C                   ExSR      *PSSR
000277210907     C                   End
000278210907      *
000279210907      ***  Check System Date Format, DDMMYY (*IN98 off)
000280210907      ***                            MMDDYY (*IN98 on).
000281210907      *
000282210907     C                   If        BJDFIN = 'M'
000283210907     C                   SetOn                                        98
000284210907     C                   EndIf
000285210907      *
000286210907     C** Get RUNDAT to access MULTI-BRANCHING flag
000287210907     C     *DTAARA       Define                  RUNDAT
000288210907     C                   In        RUNDAT
000289210907      *
000290210907      ** Retrieve system values details
000291210907     C                   EXSR      ChkSysValue
000292210907      *
000293210907     C                   Z-ADD     BJRDNB        PDaynoIn
000294210907     C                   EXSR      SRZDate9
000295210907     C                   MOVE      PDateOutZ9    DSRndDate
000296210907      *
000297210907     C                   EndSR
000298210907      *****************************************************************
000299210907      /Title SR/Process
000300210907      *****************************************************************
000301210907      *                                                               *
000302210907      *  Process - Subroutine to do the Detail Processing.            *
000303210907      *                                                               *
000304210907      *  Called By: Main Processing                                   *
000305210907      *  Calls:                                                       *
000306210907      *                                                               *
000307210907      *****************************************************************
000308210907      *
000309210907     C     Process       BegSR
000310210907      *
000311210907     C     33            MULT      PretPeriod    KNBDA             5 0
000312210907     C     BJRDNB        SUB       KNBDA         KDAYR             5 0
000313210907      *
000314210907     C                   Z-ADD     KDAYR         PDaynoIn
000315210907     C                   EXSR      SRZDate9
000316210907     C                   MOVE      PDateOutZ9    DSRetDate
000317210907      *
000318210907     C                   MOVE      WRY2R         WPYYR
000319210907     C                   MOVE      WRMMR         WPMMR
000320210907     C                   MOVE      DSMthRet      PYYMM             4
000321210907      *
000322210907     C                   EndSR
000323210907      *
000324210907      *****************************************************************
000325210907      *                                                               *
000326210907      * ChkSysValue - Check for system values                         *
000327210907      *                                                               *
000328210907      * Called by: Main Processing                                    *
000329210907      *                                                               *
000330210907      * Calls:                                                        *
000331210907      *                                                               *
000332210907      *****************************************************************
000333210907      *
000334210907     C     ChkSysValue   BEGSR
000335210907      *
000336210907      ** Check for system values
000337210907     C                   EVAL      @RTCD = *BLANKS
000338210907     C                   EVAL      P@OP01 = PSysVal1
000339210907      *
000340210907     C                   CALL      'AOSVALR0'
000341210907     C                   PARM                    @RTCD             7
000342210907     C                   PARM                    P@OP01
000343210907     C                   PARM      *BLANKS       P@VL01
000344210907     C                   PARM      *BLANKS       P@OP02
000345210907     C                   PARM      *BLANKS       P@VL02
000346210907     C                   PARM      *BLANKS       P@OP03
000347210907     C                   PARM      *BLANKS       P@VL03
000348210907     C                   PARM      *BLANKS       P@OP04
000349210907     C                   PARM      *BLANKS       P@VL04
000350210907     C                   PARM      *BLANKS       P@OP05
000351210907     C                   PARM      *BLANKS       P@VL05
000352210907     C                   PARM      *BLANKS       P@OP06
000353210907     C                   PARM      *BLANKS       P@VL06
000354210907     C                   PARM      *BLANKS       P@OP07
000355210907     C                   PARM      *BLANKS       P@VL07
000356210907     C                   PARM      *BLANKS       P@OP08
000357210907     C                   PARM      *BLANKS       P@VL08
000358210907     C                   PARM      *BLANKS       P@OP09
000359210907     C                   PARM      *BLANKS       P@VL09
000360210907     C                   PARM      *BLANKS       P@OP10
000361210907     C                   PARM      *BLANKS       P@VL10
000362210907
000363210907      ** Setup work fields
000364210907      * Set PRetPeriod = P@VL01
000365210907      *
000366210907     C                   EVAL      PRetPeriod = 0
000367210907      *
000368210907     C                   IF        @RTCD = *BLANKS
000369210907     C                   MOVEL     P@VL01        WKRETP            2
000370210907     C                   MOVEL     WKRETP        PRetPeriod
000371210907     C                   ENDIF
000372210907      *
000373210907     C                   ENDSR
000374210907      *
000375210907      *****************************************************************
000376210907      /EJECT
000377210907      *****************************************************************
000378210907      *                                                               *
000379210907      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
000380210907      *                                                               *
000381210907      *****************************************************************
000382210907
000383210907     C     SRZDate9      BEGSR
000384210907
000385210907     C                   CALLB     'ZDATE9'
000386210907     C                   PARM                    PDayNoIn
000387210907     C                   PARM      *ZERO         PDateOutZ9
000388210907     C                   PARM                    PRetCodeZ9
000389210907
000390210907     C                   ENDSR
000391210907
000392210907      *****************************************************************
000393210907      ** SRCvtDate - Convert date from YYYYMMDD to DDMMYY (or MMDDYY) *
000394210907      *****************************************************************
000395210907     C     SRCvtDate     BEGSR
000396210907
000397210907     C                   CALLB     'ZA0770'
000398210907     C                   PARM      *BLANK        ReturnCode        7
000399210907     C                   PARM                    @DATE             8 0
000400210907     C                   PARM                    BJDFIN
000401210907     C                   PARM      *ZERO         PDateOut
000402210907
000403210907     C                   ENDSR
000404210907      *****************************************************************
000405210907      /Title SR/*PSSR
000406210907      *****************************************************************
000407210907      *                                                               *
000408210907      *  *PSSR  - Program Error Processing Subroutine.                *
000409210907      *                                                               *
000410210907      *  Called By: Various                                           *
000411210907      *                                                               *
000412210907      *****************************************************************
000413210907      *
000414210907     C     *PSSR         BegSR                                                  *** *PSSR  ***
000415210907      *
000416210907      ***  Check to see that *PSSR has not already been called.
000417210907     C                   If        WRUN = *BLANK
000418210907     C                   Move      'Y'           WRUN              1
000419210907     C                   MoveL     'XX005002'    DBPGM
000420210907      *
000421210907     C     *DTAARA       Define    LDA           WLDA            256
000422210907     C     *Lock         In        WLDA
000423210907     C                   MoveL     DBERR         WLDA
000424210907     C                   Out       WLDA
000425210907     C                   SetOn                                        U7U8LR
000426210907      *
000427210907     C                   Dump
000428210907     C                   EndIf
000429210907      *
000430210907      ** Exit program
000431210907     C                   Return
000432210907      *
000433210907     C                   EndSR
000434210907      *
000435210907      *****************************************************************
000436210907      ***
000437210907**  CPY@
000438210907(c) Finastra Ltd 2021
