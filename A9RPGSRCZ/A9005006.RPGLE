     H DEBUG
     H
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas A9 GLM/EDW files Housekeeping')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  A9005006 - Midas A9 GLM/EDW files Housekeeping               *
      *                                                               *
      *  Function: Housekeeping of flat files LNyymmdd and BLyymmdd   *
      *                                                               *
      *  Called by: A9C005003 - Midas A9 GLM/EDW files Housekeeping   *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. BA9005  *CREATE    Date 11Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BA9005 - HO and EDW Extracts                                 *
      *                                                               *
      *****************************************************************
      *
      *
      /Title Function of indicators
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
     F*                                                               *
     F*  90-99 - Used by Standard Subroutines                         *
     F*                                                               *
     F*  U7+U8 - Database Error                                       *
     F*                                                               *
     F*****************************************************************
      /Title Subroutine Index
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E   I N D E X                              *
     F*                                                               *
     F*  Init      - Initial Processing                               *
     F*  Proces    - Main processing                                  *
     F*  ChkSysValue - Retrieve system values                         *
     F*  SRZDate9  - Date format                                      *
     F*  SRCvtDate - Convert date format                              *
     F*                                                               *
     F*  *PSSR     - Program error handling routine                   *
     F*                                                               *
     F*****************************************************************
     D/Title D-Specifications
     D CPY@            S             80    Dim(1) CTData PerRCD(1)
      ***  Array for Object Copyright Statement.
      *
     D SDBANK        E DS                  ExtName(SDBANKPD)
      ** Bank Details
      *
     D DSSDY         E DS                  ExtName(DSSDY)
      ** Second DS For Access Programs, Long Data Structure
      *
     D DBERR           DS           256
      * Data structure for data-base error processing
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D                 DS

     D RUNDAT          DS
      * Data structure for rundate flags
     D  RUNA                   1      7
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  RUND                   8     10P 0
     D  @MBIN                 13     13
      *
     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A
      *
     D PSysVal1        C                   CONST('HO_EDW_Ret_Period')

     D PRetPeriod      S              2  0

     D PDateOut        S              6  0

      ** Parameters for ZDATE9
     D PDaynoIn        S              5P 0
     D PDateOutZ9      S              8S 0
     D PRetCodeZ9      S              1  0

      ** YYYYMMDD date format of Retention Date
     D DSRNDDate       DS
     D  WVYYR                  1      4  0
     D  WVY2R                  3      4  0
     D  WVMMR                  5      6  0
     D  WVDDR                  7      8  0
     D  WVRND                  1      8  0

      ** YYYYMMDD date format of Retention Date
     D DSRetDate       DS
     D  WRYYR                  1      4  0
     D  WRY2R                  3      4  0
     D  WRMMR                  5      6  0
     D  WRDDR                  7      8  0
     D  WRRND                  1      8  0

      ** YYMM date format of Retention Date
     D DSMthRet        DS
     D  WPYYR                  1      2
     D  WPMMR                  3      4

     C/Title Main Processing
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
      * Perform Initialisation.
     C                   ExSR      Init
      *
      * Perform Main Processing.
     C                   ExSR      Process
      *
     C                   SetOn                                        LR
     C                   Return
      *================================================================
      *  P R O G R A M     E N D                                      *
      *================================================================
      /Title SR/Init
      *****************************************************************
      *                                                               *
      *  Init   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     Init          BegSR
      *
      ***  Copyright Statement.
     C                   MoveA     CPY@          BIS@             80
      *
     C     *ENTRY        PLIST
     C                   PARM                    PYYMM             4
      *
      ** Access Bank Details
     C                   Call      'AOBANKR0'
     C                   Parm      '*MSG   '     WRTCD             7
     C                   Parm      '*FIRST '     WOPTN             7
     C     SDBANK        Parm      SDBANK        DSSDY
      *
     C     WRTCD         IfNE      *BLANKS
     C                   Z-Add     001           DBASE                          ***************
     C                   MoveL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *
     C                   Move      *Blanks       DBKEY                          ***************
     C                   ExSR      *PSSR
     C                   End
      *
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
      *
     C                   If        BJDFIN = 'M'
     C                   SetOn                                        98
     C                   EndIf
      *
     C** Get RUNDAT to access MULTI-BRANCHING flag
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
      *
      ** Retrieve system values details
     C                   EXSR      ChkSysValue
      *
     C                   Z-ADD     BJRDNB        PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSRndDate
      *
     C                   EndSR
      *****************************************************************
      /Title SR/Process
      *****************************************************************
      *                                                               *
      *  Process - Subroutine to do the Detail Processing.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     Process       BegSR
      *
     C     33            MULT      PretPeriod    KNBDA             5 0
     C     BJRDNB        SUB       KNBDA         KDAYR             5 0
      *
     C                   Z-ADD     KDAYR         PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSRetDate
      *
     C                   MOVE      WRY2R         WPYYR
     C                   MOVE      WRMMR         WPMMR
     C                   MOVE      DSMthRet      PYYMM             4
      *
     C                   EndSR
      *
      *****************************************************************
      *                                                               *
      * ChkSysValue - Check for system values                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ChkSysValue   BEGSR
      *
      ** Check for system values
     C                   EVAL      @RTCD = *BLANKS
     C                   EVAL      P@OP01 = PSysVal1
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD             7
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      *BLANKS       P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM      *BLANKS       P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      *BLANKS       P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      *BLANKS       P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM      *BLANKS       P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM      *BLANKS       P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM      *BLANKS       P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM      *BLANKS       P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10

      ** Setup work fields
      * Set PRetPeriod = P@VL01
      *
     C                   EVAL      PRetPeriod = 0
      *
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     P@VL01        WKRETP            2
     C                   MOVEL     WKRETP        PRetPeriod
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
      *                                                               *
      *****************************************************************

     C     SRZDate9      BEGSR

     C                   CALLB     'ZDATE9'
     C                   PARM                    PDayNoIn
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCodeZ9

     C                   ENDSR

      *****************************************************************
      ** SRCvtDate - Convert date from YYYYMMDD to DDMMYY (or MMDDYY) *
      *****************************************************************
     C     SRCvtDate     BEGSR

     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        ReturnCode        7
     C                   PARM                    @DATE             8 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut

     C                   ENDSR
      *****************************************************************
      /Title SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BegSR                                                  *** *PSSR  ***
      *
      ***  Check to see that *PSSR has not already been called.
     C                   If        WRUN = *BLANK
     C                   Move      'Y'           WRUN              1
     C                   MoveL     'A9005006'    DBPGM
      *
     C     *DTAARA       Define    LDA           WLDA            256
     C     *Lock         In        WLDA
     C                   MoveL     DBERR         WLDA
     C                   Out       WLDA
     C                   SetOn                                        U7U8LR
      *
     C                   Dump
     C                   EndIf
      *
      ** Exit program
     C                   Return
      *
     C                   EndSR
      *
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2024
