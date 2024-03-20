     H DEBUG
     H
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas A9 GLM Proofing file Generation')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  A9005004 - Midas A9 GLM Proofing file Generation             *
      *                                                               *
      *  Function: Proofing File Generation                           *
      *                                                               *
      *  Called by: A9C005002 - Midas A9 GLM/EDW Extract file Gen.    *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD059648           Date 11Mar24               *
      *  Prev Amend No. MD059406           Date 11Mar24               *
      *                 MD059134           Date 11Mar24               *
      *                 BA9005  *CREATE    Date 11Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059648 - GLM Proofing file missing last A/c Code Balance   *
      *  MD059406 - Extract issues with Feeder and Proofing files     *
      *              Add PSTA to LDBL if Include Balance is Y only    *
      *  MD059134 - Net Balance not correct in Proofing file          *
      *  BA9005 - HO and EDW Extracts                                 *
      *                                                               *
      *****************************************************************
      *
     FA9ACBRC   IF   E           K Disk    InfSR(*PSSR)
      *
     FA9ACHOML0 IF   E           K Disk    InfSR(*PSSR)
      *
     FA9FEEDDL1 IF   E           K Disk    InfSR(*PSSR)
      *
     FA9PROFFTD O    E           K Disk    InfSR(*PSSR)
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
     F*  EXTPRF    - Proofing File Write                              *
     F*  ChkSysValue - Retrieve System values                         *
     F*  SRZDate9  - Date format                                      *
     F*                                                               *
     F*  *PSSR     - Program error handling routine                   *
     F*                                                               *
     F*****************************************************************
     D/Title D-Specifications
     D CPY@            S             80    Dim(1) CTData PerRCD(1)
      ***  Array for Object Copyright Statement.
      *
     D SDBRCH        E DS                  ExtName(SDBRCHPD)
      ** Branch Details
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
     D PSysVal1        C                   CONST('VLJBranchCode')

     D PBranch         S              3A

     D PDateOut        S              6  0

      ** Parameters for ZDATE9
     D PDaynoIn        S              5P 0
     D PDateOutZ9      S              8S 0
     D PRetCodeZ9      S              1  0

      ** YYMMDD date format of Rundate
     D DSDayDate       DS
     D  WVY2D                  1      2  0
     D  WVMMD                  3      4  0
     D  WVDDD                  5      6  0

      ** YYYYMMDD date format of Rundate
     D DSRNDDate       DS
     D  WVYYR                  1      4  0
     D  WVY2R                  3      4  0
     D  WVMMR                  5      6  0
     D  WVDDR                  7      8  0
     D  WVRND                  1      8  0

      ** DD/MM/YYYY Format for Rundate
     D DSRNDDat2       DS
     D  WRDDR                  1      2
     D  WRFL1                  3      3
     D  WRMMR                  4      5
     D  WRFL2                  6      6
     D  WRYYR                  7     10

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
     C                   Z-ADD     BJRDNB        PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSRndDate
      *
     C                   MOVE      WVY2R         WVY2D
     C                   MOVE      WVMMR         WVMMD
     C                   MOVE      WVDDR         WVDDD
     C                   MOVE      DSDayDate     DayDate           6

     C                   MOVE      WVDDR         WRDDR
     C                   MOVE      '/'           WRFL1
     C                   MOVE      WVMMR         WRMMR
     C                   MOVE      '/'           WRFL2
     C                   MOVE      WVYYR         WRYYR
      *
      ***Klist*to*access the ACBRC file
      ** Klist to access the A9ACBRC file
     C     KList1        KList
     C                   KFld                    KACO2            10 0
     C                   KFld                    KCCY              3
      *
      ** Klist to access the A9FEEDTD file
     C     KList2        KList
     C                   KFld                    K2ACOD           10
     C                   KFld                    K2CCY             3
     C                   KFld                    K2RND             5 0
      *
      ** Retrieve system values details
     C                   EXSR      ChkSysValue
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
     C                   MOVEL     *BLANKS       KCCY
     C                   Z-ADD     0             KACO2
     C                   Z-ADD     0             WKLDBL           19 0
      *
      ***  Read the Accound Code file and access ACCNTAB to retrieve
      ***  Balance by CCY/ACOD
     C     *LOVAL        Setll     A9ACHOML0
     C                   READ      A9ACHOML0                              50
      *
b1   C                   Dow       *In50 = '0'
      *
      ***  Access the Account details by CCY / ACOD
     C                   MOVEL     *BLANKS       KCCY
     C                   Z-ADD     XXMACOD       KACO2            10 0
     C     KList1        SETLL     A9ACBRC
     C                   READ      A9ACBRC                                51
      *
b2   C                   If        *IN51 = '0' and CCY <> KCCY
     C                             and RECI = 'D'
     C                   MOVE      CCY           KCCY
e2   C                   ENDIF
      *
b2   C                   Dow       *In51 = '0'
b3   C                   If        CCY = KCCY and ACOD = KACO2
     C                             and RECI = 'D'
      ** Calculate Total Ledger Balance
     C                   Add       LDBL          WKLDBL
     C                   MOVEL     XXMACOD       WKLSAC           10                        MD059648
     C                   READ      A9ACBRC                                51
x3   C                   Else
b4   C**********         If        ACOD <> KACO2                                            MD059134
     C**********         MOVE      '1'           *IN51                                      MD059134
x4   C**********         Else                                                               MD059134
      ***  Access the Feeder details for Total DR/CR
     C                   Z-ADD     BJRDNB        K2RND
     C                   MOVEL     KCCY          K2CCY
     C                   MOVEL     XXMACOD       K2ACOD
     C     Klist2        SETLL     A9FEEDDL1
     C     Klist2        READE     A9FEEDDL1                              52
      *
b5   C                   Dow       *In52 = '0'
      *
b6   C                   If        XXDCCYL = K2CCY and XXDACOD = K2ACOD
      *
      ** Add up Posting Amount only if Include Balance is 'Y'                               MD059406
     C                   If        XXDINBL = 'Y'                                            MD059406
      ** Calculate Total Ledger Balance
b7   C                   If        XXDDRCR = 'D'
     C                   Add       XXDPSTA       WKTOTDR          19 0
     C                   Else
     C                   Add       XXDPSTA       WKTOTCR          19 0
e7   C                   Endif
     C                   Endif                                                              MD059406
     C     Klist2        READE     A9FEEDDL1                              52
x6   C                   Else
     C                   MOVE      '1'           *IN52
e6   C                   ENDIF
e5   C                   EndDo
      *
      ** Write Proofing Record
     C                   EXSR      EXTPRF
     C                   If        ACOD <> KACO2                                            MD059134
     C                   MOVE      '1'           *IN51                                      MD059134
     C                   Endif                                                              MD059134
     C                   MOVE      CCY           KCCY
     C                   Z-ADD     ACOD          KACO2
     C                   Z-ADD     0             WKLDBL
e4   C**********         Endif                                                              MD059134
e3   C                   Endif
e2   C                   Enddo
      ** Write Proofing Record
      *
     C                   READ      A9ACHOML0                              50
e1   C                   EndDo
      *
      ** Process Last Account Code Balance                                                  MD059648
b1   C     WKLSAC        IFNE      WKLSACP                                                  MD059648
      ***  Access the Feeder details for Total DR/CR                                        MD059648
     C                   Z-ADD     BJRDNB        K2RND                                      MD059648
     C                   MOVEL     KCCY          K2CCY                                      MD059648
     C                   MOVEL     WKLSAC        K2ACOD                                     MD059648
     C     Klist2        SETLL     A9FEEDDL1                                                MD059648
     C     Klist2        READE     A9FEEDDL1                              52                MD059648
      *                                                                                     MD059648
b2   C                   Dow       *In52 = '0'                                              MD059648
      *                                                                                     MD059648
b3   C                   If        XXDCCYL = K2CCY and XXDACOD = K2ACOD                     MD059648
      *                                                                                     MD059648
      ** Add up Posting Amount only if Include Balance is 'Y'                               MD059648
b4   C                   If        XXDINBL = 'Y'                                            MD059648
      ** Calculate Total Ledger Balance                                                     MD059648
b5   C                   If        XXDDRCR = 'D'                                            MD059648
     C                   Add       XXDPSTA       WKTOTDR          19 0                      MD059648
x5   C                   Else                                                               MD059648
     C                   Add       XXDPSTA       WKTOTCR          19 0                      MD059648
e5   C                   Endif                                                              MD059648
e4   C                   Endif                                                              MD059648
     C     Klist2        READE     A9FEEDDL1                              52                MD059648
x3   C                   Else                                                               MD059648
     C                   MOVE      '1'           *IN52                                      MD059648
e3   C                   ENDIF                                                              MD059648
e2   C                   EndDo                                                              MD059648
      *                                                                                     MD059648
      ** Write Proofing Record                                                              MD059648
     C                   EXSR      EXTPRF                                                   MD059648
      *                                                                                     MD059648
e1   C                   Endif                                                              MD059648
      *
     C                   EndSR
      *
      *****************************************************************
      *                                                               *
      * EXTPRF - Write Proofing Record                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     EXTPRF        BEGSR
      *
     C                   CLEAR                   A9PROFFD0
      ** Rundate
     C                   MOVEL     DSRndDat2     XXTRDT
      ** CCY
     C                   MOVEL     KCCY          XXPCCY
      ** Account Code
     C                   MOVEL     KACO2         XXPACC
      ** HO Product Code
     C                   MOVE      XXMHOPC       XXPHOP
      ** Branch
     C                   MOVE      PBranch       XXPHOB
      ** Net Balance calculated
     C     WKLDBL        SUB       WKTOTCR       WKBLC1           19 0
     C     WKBLC1        ADD       WKTOTDR       WKBLC2           19 0
     C                   Z-ADD     WKBLC2        XXPBLC
      ** Sign
     C                   If        XXPBLC < 0
     C     WKBLC2        MULT      -1            XXPBLC
     C                   MOVE      '-'           XXPSGN
     C                   Else
     C                   MOVE      ' '           XXPSGN
     C                   ENDIF
      *
     C                   WRITE     A9PROFFD0
      *
     C                   Z-ADD     0             WKBLC1
     C                   Z-ADD     0             WKBLC2
      *
     C                   Z-ADD     0             WKTOTCR
     C                   Z-ADD     0             WKTOTDR
      *
     C                   MOVEL     XXPACC        WKLSACP          10                        MD059648
      *
     C                   ENDSR
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
      * Set PBranch  = P@VL01
      *
     C                   EVAL      PBranch = *BLANKS
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      PBranch = P@VL01
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
      *
     C     SRZDate9      BEGSR
      *
     C                   CALLB     'ZDATE9'
     C                   PARM                    PDayNoIn
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCodeZ9
      *
     C                   ENDSR
      *
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
     C                   MoveL     'A9005004'    DBPGM
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
