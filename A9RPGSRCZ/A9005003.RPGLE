     H DEBUG
     H
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas A9 GLM Feeder Files Generation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  A9005003 - Midas A9 GLM Feeder Files Generation              *
      *                                                               *
      *  Function: Extract posting details                            *
      *                                                               *
      *  Called by: A9C005002 - Midas A9 GLM/EDW Extract file Gen.    *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD059439           Date 11Mar24               *
      *  Prev Amend No. MD059406           Date 11Mar24               *
      *                 MD059075           Date 11Mar24               *
      *                 BA9005  *CREATE    Date 11Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059439 - GLM Feeder Files Extracts issues                  *
      *  MD059406 - Extract issues with Feeder and Proofing files     *
      *              Set new flag for Include Balance (A9FEEDDTD)     *
      *  MD059075 - Journal Feeder Header Filler incorrect (Recompile)*
      *  BA9005 - HO and EDW Extracts                                 *
      *                                                               *
      *****************************************************************
      *
     FA9APOSL0  IF   E           K Disk    InfSR(*PSSR)
      *
     FA9ACHOML0 IF   E           K Disk    InfSR(*PSSR)
      *
     FA9FEEDHTD O    E           K Disk    InfSR(*PSSR)
      *
     FA9FEEDCTD O    E           K Disk    InfSR(*PSSR)
      *
     FA9FEEDDTD O    E           K Disk    InfSR(*PSSR)
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
     F*  Extract   - Main Extract Processing                          *
     F*  ExtDet    - Details Record                                   *
     F*  ExtCtl    - Control Record                                   *
     F*  ExtHed    - Header Record                                    *
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
      *
     DSDDTA            DS
     D SDDATA                  1    256
     D SPREFX                  6      7
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
     D PSysVal1        C                   CONST('VLJRecordFormat')
     D PSysVal2        C                   CONST('VLJCorpEntityCode')
     D PSysVal3        C                   CONST('VLJBranchCode')
     D PSysVal4        C                   CONST('VLJSystem')
     D PSysVal5        C                   CONST('VLJConstantS')
     D PSysVal6        C                   CONST('VLJConstant20')
     D PSysVal7        C                   CONST('VLJConstantCY')
     D PSysVal8        C                   CONST('VLJConstantCP')
     D PSysVal9        C                   CONST('VLJCompany')

     D CDesBal1        C                   CONST('SUMMARIZED ')
     D CDesBal2        C                   CONST(' FROM MIDAS FOR BRN ')

     D PDesBal         DS
     D  PDesBal1               1     11
     D  PDesBal2              12     14
     D  PDesBal3              15     34
     D  PDesBal4              35     37
     D  PDesBal5              38     45

     D PRecFmt         S              3A
     D PCorpEnt        S              5A
     D PBranch         S              3A
     D PSystem         S              3A
     D PConstS         S              1A
     D PConst20        S              2A
     D PConstCY        S              2A
     D PConstCP        S              2A
     D PCompany        S              3A

     D PDateOut        S              6  0

      ** Parameters for ZBKDT
     D WCurr_RunDay    S              5  0 Inz
     D WNext_WrkDay    S              5  0 Inz
     D WPrev_WrkDay    S              5  0 Inz
     D WDayNo          S              5  0 Inz
     D WCcy            S              3    Inz
     D WLoc            S              3    Inz
     D WDays           S              2  0 Inz
      *
      ** Parameters for ZDATE9
     D PDaynoIn        S              5P 0
     D PDateOutZ9      S              8S 0
     D PRetCodeZ9      S              1  0

      ** YYYYMMDD date format of Rundate
     D DSRNDDate       DS
     D  WVYYR                  1      4  0
     D  WVY2R                  3      4  0
     D  WVMMR                  5      6  0
     D  WVDDR                  7      8  0
     D  WVRND                  1      8  0

      ** YYYYMMDD date format of Posting date
     D DSPSTDate       DS
     D  WVYYP                  1      4  0
     D  WVMMP                  5      6  0
     D  WVDDP                  7      8  0
     D  WVPST                  1      8  0

      ** YYYYMMDD date format of Value date
     D DSVLDDate       DS
     D  WVYYV                  1      4  0
     D  WVMMV                  5      6  0
     D  WVDDV                  7      8  0
     D  WVALD                  1      8  0

      ** DDMMYY date format of Value date
     D DSVLDDat1       DS
     D  WVDDV1                 1      2
     D  WVMMV1                 3      4
     D  WVYYV1                 5      6

      ** YYMMDD date format of Rundate
     D DSDayDate       DS
     D  WVY2D                  1      2  0
     D  WVMMD                  3      4  0
     D  WVDDD                  5      6  0

      ** YYYYMMDD date format of Previous Working Date
     D DSPWDDate       DS
     D  PWDYY                  1      4  0
     D  PWDY2                  3      4  0
     D  PWDMM                  5      6  0
     D  PWDDD                  7      8  0
     D  PWRND                  1      8  0

      ** DS For Journal ID
     D DSJRNID         DS
     D  DJRNI1                 1      3
     D  DJRNI2                 4      6
     D  DJRNI3                 7      9
     D  DJRNI4                10     10
      *
      ** DS For GLMCP
     D DSGLMCP         DS
     D  DGLMC1                 1      3
     D  DGLMC2                 4      7
     D  DGLMC3                 8     12
     D  DGLMC4                13     16
     D  DGLMC5                17     19
     D  DGLMC6                20     44
      *
      ** DS For Source
     D DSSRCE          DS
     D  DSRC1                  1      3
     D  DSRC2                  4      4
     D  DSRC3                  5     10
      *
      ** DS For Journal Description
     D DSJRND          DS
     D  DJRND1                 1     30
     D  DJRND2                31     49
     D  DJRND3                50     51
     D  DJRND4                52     53
     D  DJRND5                54     57
     D  DJRND6                58     65
     D  DJRN61                58     59
     D  DJRN62                60     65
     D  DJRND7                66     67
     D  DJRND8                68     73
     D  DJRND9                74     75
      *
     D DSJRNS          DS
     D  DJRNS1                 1      2
     D  DJRNS2                 3      4
     D  DJRNS3                 5      5
      *

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
     C                   EVAL      WCurr_RunDay = 0
     C                   EVAL      WPrev_WrkDay = 0
     C                   EVAL      WNext_WrkDay = 0
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
     C                   Else
     C                   EVAL      WCurr_RunDay = BJRDNB
     C                   EVAL      WNext_WrkDay = BJDNWD
     C                   End
      *
      ** Retrieve Previous Working Day

     C                   Z-add     1             WDays                                      MD059439
     C**********         CALL      'ZBKDT'                                                  MD059439
     C                   CALLB     'ZBKDT'                                                  MD059439
     C                   PARM      WCurr_RunDay  WDayNo
     C                   PARM      BJLCCY        WCcy
     C                   PARM      BJSLCD        WLoc
     C**********         PARM      BJBVPD        WDays                                      MD059439
     C                   PARM                    WDays                                      MD059439
     C                   PARM      *Zero         WPrev_WrkDay
      *
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
      *
     C                   If        BJDFIN = 'M'
     C                   SetOn                                        98
     C                   EndIf
      *
     C** Get system prefix from SDSTAT
     C     *DTAARA       Define    SDSTAT        SDDTA
     C                   In        SDDTA
      *
     C** Get RUNDAT to access MULTI-BRANCHING flag
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
      *
     C                   Z-ADD     BJRDNB        PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSRndDate
      *
     C                   Z-ADD     WPrev_WrkDay  PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSPWDDate
      *
     C                   MOVE      WVY2R         WVY2D
     C                   MOVE      WVMMR         WVMMD
     C                   MOVE      WVDDR         WVDDD
     C                   MOVE      DSDayDate     DayDate           6
      *
      ** Retrieve system values details
     C                   EXSR      ChkSysValue
      *
     C                   Move      *BLANKS       WKCCY             3
     C                   Movel     *BLANKS       WKACOD           10
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
     C                   Z-ADD     BJRDNB        KDAYL             5 0
      *
      ***  Read the Posting file APOSTPD for the rundate
      *** Ordered by CCY
     C     *LOVAL        Setll     A9APOSL0
     C                   READ      A9APOSL0                               50
      *
      * Get Branch Details
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      BRCA          WBRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ***  Process all postings for the day
      *
     C                   Dow       *In50 = '0'
      *
      ***  Read the Account Code HO Details file
     C                   Z-ADD     ACOD          KACOD            10 0
     C     KACOD         Chain     A9ACHOML0                          90
      *
     C                   If        *In90 = '0' AND XXMEXCL = 'N'
     C                             OR *IN90 = '1'
      *
      ** Extract postings details
     C                   EXSR      EXTRACT
     C                   READ      A9APOSL0                               50
      *
     C                   Else
     C                   If        *In90 = '0' AND XXMEXCL = 'Y'
     C                   Read      A9APOSL0                               50
     C                   ENDIF
      *
     C                   Endif
      *
      ***  End of Do While Not End of File.
     C                   EndDo
      *
     C                   EXSR      EXTCTL
      *
      ** Write Feeder Header record
     C                   EXSR      EXTHED
      *
     C                   EndSR
      *
      *****************************************************************
      *                                                               *
      * EXTRACT - Extract postings process                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     EXTRACT       BEGSR
      *
      ** split posting date
     C                   Z-ADD     PSTD          PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSPSTDate
      *
      ** split value date
     C                   Z-ADD     VALD          PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSVLDDate
      *
      ** Extract posting
      *
     C                   If        PSTD = BJRDNB and PSTD = VALD
     C                             OR PSTD = BJRDNB and WVMMP = WVMMV
     C                             OR PSTD = BJRDNB and WVMMP > WVMMV and
     C                                WVYYP = WVYYV
     C                             OR PSTD = BJRDNB and PSTD > VALD and
     C                                WVYYP <> WVYYV and WVMMP < WVMMV
     C                             OR PSTD = WPrev_WrkDay and WVMMP > WVMMV and
     C                                WVYYP <> WVYYV
     C                             OR PSTD = WPrev_WrkDay and WVMMP < WVMMV and
     C                                WVYYP = WVYYV
      *
      ** Process Details record format
     C                   If        CCY = WKCCY OR WKCCY = *BLANKS
     C                   EXSR      EXTDET
      *
      ** Process Control and Details rec format
     C                   Else
     C                   If        CCY <> WKCCY
     C                   EXSR      EXTCTL
     C                   EXSR      EXTDET
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * EXTDET - Write Feeder Details Record                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     EXTDET        BEGSR
      *
     C     SPOS          IFNE      '  GE-XB'
      *
     C                   CLEAR                   A9FEEDDD0
      ** Ccy
     C                   MOVEL     CCY           WKCCY
      ** Acount Code
     C                   MOVEL     ACOD          WKACOD
      ** Record Format
     C                   MOVEL     'VLJ'         XXDDBID
      ** Corporate Entity
     C                   MOVEL     PCorpEnt      XXDVJCC
      ** Journal ID
     C                   MOVEL     PBranch       DJRNI1
     C                   MOVEL     PSystem       DJRNI2
     C                   MOVEL     CCY           DJRNI3
     C                   MOVEL     '0'           DJRNI4
     C                   MOVEL     DSJRNID       XXDJRNID
      ** Effective Date
     C                   MOVE      DSRndDate     XXDEFFD
      ** Journal Seq
     C                   MOVE      WVMMR         DJRNS1
     C                   MOVE      WVDDR         DJRNS2
     C                   MOVE      '0'           DJRNS3
     C                   MOVE      DSJRNS        XXDJRNSQ
      ** GLM Account to Post to
     C                   MOVE      PBranch       DGLMC1
     C                   MOVE      *BLANKS       DGLMC2
     C                   If        *IN90 = '0'
     C                   MOVE      XXMHOAC       DGLMC3
     C                   MOVE      XXMHOPC       DGLMC4
     C                   MOVE      XXMHOMC       DGLMC5
     C                   ELSE
     C                   MOVE      *BLANKS       DGLMC3
     C                   MOVE      *BLANKS       DGLMC4
     C                   MOVE      *BLANKS       DGLMC5
     C                   ENDIF
     C                   MOVE      *BLANKS       DGLMC6
     C                   MOVE      DSGLMCP       XXDGLMCP
      ** CCY
     C                   MOVE      CCY           XXDCCYL
      ** Account Code
     C                   MOVEL     ACOD          XXDACOD
      ** Rundate
     C                   Z-ADD     BJRDNB        XXDRND
      ** Constant S
     C                   MOVE      PConstS       XXDCSTS
      ** Subledger ID
     C                   MOVE      *BLANKS       XXDSLID
      ** Subledger Account
     C                   MOVE      *BLANKS       XXDSLAC
      ** Source
     C                   MOVE      BRCA          DSRC1
     C                   MOVE      *BLANKS       DSRC2
     C** Convert Date Format from YYYYMMDD to DDMMYY
     C                   MOVE      WVYYV         WVYYV1
     C                   MOVE      WVMMV         WVMMV1
     C                   MOVE      WVDDV         WVDDV1
     C                   MOVE      DSVLDDat1     DSRC3
     C                   MOVE      DSSRCE        XXDSRCE
      ** Journal Description
     C                   MOVEL     PNAR          DJRND1
     C                   MOVE      *BLANKS       DJRND2
     C                   MOVEL     OTTP          DJRND3
     C                   MOVEL     OTST          DJRND4
     C                   MOVEL     ACOD          DJRND5
     C                   If        GETP = 'D'
     C                   MOVEL     'DL'          DJRN61
     C                   MOVEL     OTRF          DJRN62
     C                   Else
     C                   If        GETP = 'U'
     C                   MOVEL     'LE'          DJRN61
     C                   MOVEL     OTRF          DJRN62
     C                   Else
     C                   MOVEL     OTRF          DJRND6
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *BLANKS       DJRND7
     C                   MOVE      ASOC          DJRND8
     C                   MOVE      PConst20      DJRND9
     C                   MOVE      DSJRND        XXDJRND
      ** Constant CY
     C                   MOVE      PConstCY      XXDCSTCY
      ** Constant CP
     C                   MOVE      PConstCP      XXDCSTCP
      ** DR/CR Indicator
     C                   If        DRCR = 0
     C                   MOVE      'D'           XXDDRCR
     C                   Else
     C                   MOVE      'C'           XXDDRCR
     C                   ENDIF
      ** Local Book Equivalent
     C                   MOVE      *ALL'0'       XXDLCBE
      ** Posting Amount
     C                   Z-ADD     PSTA          XXDPSTA
      ** Rate
     C                   MOVE      *BLANKS       XXDRATE
      ** Set new flag for Include in Balance (Y/N)                                          MD059406
     C                   If        PSTD = WPrev_WrkDay and WVMMP > WVMMV and                MD059406
     C                                WVYYP <> WVYYV                                        MD059406
     C                             OR PSTD = WPrev_WrkDay and WVMMP < WVMMV and             MD059406
     C                                WVYYP = WVYYV                                         MD059406
     C                   MOVE      'Y'           XXDINBL                                    MD059406
     C                   Else                                                               MD059406
     C                   MOVE      'N'           XXDINBL                                    MD059406
     C                   ENDIF                                                              MD059406
      *
      ** Add up details for Header and Control Format
      *
      ** VLJ Total Debit/Credit Posting and No records
     C                   If        DRCR = 0
     C                   Add       PSTA          WXCTAMTD
     C                   Add       1             WXHTVLJD          8 0
     C                   Add       PSTA          WXHTOTD          19 0
     C                   Else
     C                   Add       PSTA          WXCTAMTC
     C                   Add       1             WXHTVLJC          8 0
     C                   Add       PSTA          WXHTOTC          19 0
     C                   ENDIF
      ** Total VLJ Records
     C                   Add       1             WXHTTVLJ          8 0
      *
      ** Write record to A9FEEDDTD
     C                   WRITE     A9FEEDDD0
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * EXTCTL - Write Feeder Control Record                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     EXTCTL        BEGSR
      *
      ** Calculate Balance and write Details record in case DR <> CR
     C                   If        WXCTAMTC <> WXCTAMTD
      ** if not balanced, need to write Balancing entry
      *
     C                   If        WXCTAMTC < WXCTAMTD
     C     WXCTAMTD      SUB       WXCTAMTC      WKBALNC          19 0
     C                   Else
     C     WXCTAMTC      SUB       WXCTAMTD      WKBALNC
     C                   ENDIF
      *
     C                   CLEAR                   A9FEEDDD0
      ** Record Format
     C                   MOVEL     'VLJ'         XXDDBID
      ** Corporate Entity
     C                   MOVEL     PCorpEnt      XXDVJCC
      ** Journal ID
     C                   MOVEL     PBranch       DJRNI1
     C                   MOVEL     PSystem       DJRNI2
     C                   MOVEL     WKCCY         DJRNI3
     C                   MOVEL     '0'           DJRNI4
     C                   MOVEL     DSJRNID       XXDJRNID
      ** Effective Date
     C                   MOVE      DSRndDate     XXDEFFD
      ** Journal Seq
     C                   MOVE      WVMMR         DJRNS1
     C                   MOVE      WVDDR         DJRNS2
     C                   MOVE      '0'           DJRNS3
     C                   MOVE      DSJRNS        XXDJRNSQ
      ** GLM Account to Post to
     C                   MOVE      PBranch       DGLMC1
     C                   MOVE      *BLANKS       DGLMC2
     C                   If        *IN90 = '0'
     C                   MOVE      XXMHOAC       DGLMC3
     C                   MOVE      XXMHOPC       DGLMC4
     C                   MOVE      XXMHOMC       DGLMC5
     C                   ELSE
     C                   MOVE      *BLANKS       DGLMC3
     C                   MOVE      *BLANKS       DGLMC4
     C                   MOVE      *BLANKS       DGLMC5
     C                   ENDIF
     C                   MOVE      *BLANKS       DGLMC6
     C                   MOVE      DSGLMCP       XXDGLMCP
      ** CCY
     C                   MOVE      WKCCY         XXDCCYL
      ** Account Code
     C                   MOVEL     WKACOD        XXDACOD
      ** Rundate
     C                   Z-ADD     BJRDNB        XXDRND
      ** Constant S
     C                   MOVE      PConstS       XXDCSTS
      ** Subledger ID
     C                   MOVE      *BLANKS       XXDSLID
      ** Subledger Account
     C                   MOVE      *BLANKS       XXDSLAC
      ** Source
     C                   MOVE      BRCA          DSRC1
     C                   MOVE      *BLANKS       DSRC2
     C** Convert Date Format from YYYYMMDD to DDMMYY
     C                   MOVE      WVYYV         WVYYV1
     C                   MOVE      WVMMV         WVMMV1
     C                   MOVE      WVDDV         WVDDV1
     C                   MOVE      DSVLDDat1     DSRC3
     C                   MOVE      DSSRCE        XXDSRCE
      ** Journal Description
     C                   MOVE      CDesBal1      PDesBal1
     C                   MOVE      WKCCY         PDesBal2
     C                   MOVE      CDesBal2      PDesBal3
     C                   MOVE      PBranch       PDesBal4
     C                   MOVE      DSVLDDate     PDesBal5
     C                   MOVE      PDesBal       DJRND1
     C                   MOVE      *BLANKS       DJRND2
     C                   MOVEL     *BLANKS       DJRND3
     C                   MOVEL     *BLANKS       DJRND4
     C                   MOVEL     *BLANKS       DJRND5
     C                   MOVEL     *BLANKS       DJRND6
     C                   MOVEL     *BLANKS       DJRND7
     C                   MOVE      A8BICN        DJRND8
     C                   MOVE      PConst20      DJRND9
     C                   MOVE      DSJRND        XXDJRND
      ** Constant CY
     C                   MOVE      PConstCY      XXDCSTCY
      ** Constant CP
     C                   MOVE      PConstCP      XXDCSTCP
      ** DR/CR Indicator
     C                   If        WXCTAMTC > WXCTAMTD
     C                   MOVE      'D'           XXDDRCR
     C                   Else
     C                   MOVE      'C'           XXDDRCR
     C                   ENDIF
      ** Local Book Equivalent
     C                   MOVE      *ALL'0'       XXDLCBE
      ** Posting Amount
     C                   Z-ADD     WKBALNC       XXDPSTA
      ** Rate
     C                   MOVE      *BLANKS       XXDRATE
      *
      ** Add up details for Header and Control Format
      *
      ** VLJ Total Debit/Credit Posting and No records
     C                   If        WXCTAMTC > WXCTAMTD
     C                   Add       PSTA          WXCTAMTD
     C                   Add       1             WXHTVLJD
     C                   Add       PSTA          WXHTOTD
     C                   Else
     C                   Add       PSTA          WXCTAMTC
     C                   Add       1             WXHTVLJC
     C                   Add       PSTA          WXHTOTC
     C                   ENDIF
      ** Total VLJ Records
     C                   Add       1             WXHTTVLJ
      *
      ** Write record to A9FEEDDTD
     C                   WRITE     A9FEEDDD0
      *
      ** CONTROL RECORD FORMAT
      *
      ** Record Format
     C                   MOVE      'VJC'         XXCDBID
      ** Corporate Entity
     C                   MOVEL     PCorpEnt      XXCVJCC
      ** Journal ID
     C                   MOVEL     PBranch       DJRNI1
     C                   MOVEL     PSystem       DJRNI2
     C                   MOVEL     WKCCY         DJRNI3
     C                   MOVEL     '0'           DJRNI4
     C                   MOVEL     DSJRNID       XXCJRNID
      ** Effective Date
     C                   MOVE      DSRndDate     XXCEFFD
      ** Journal Seq
     C                   MOVE      DSJRNS        XXCJRNSQ
      ** Constant CY
     C                   MOVE      PConstCY      XXCCSTCY
      ** Constant CP
     C                   MOVE      PConstCP      XXCCSTCP
      ** Filler 1
     C                   MOVE      *BLANKS       XXCFIL1
      *
      ** Add up VJC Record added
     C                   Z-ADD     WXCTAMTD      XXCTAMTD
     C                   Z-ADD     WXCTAMTC      XXCTAMTC
     C                   Add       1             WXHTTVJC          8 0
     C                   WRITE     A9FEEDCD0
      *
     C                   ENDIF
      *
      ** CONTROL RECORD FORMAT
     C                   If        WXCTAMTC = WXCTAMTD and
     C                             WXCTAMTC > 0
     C                   CLEAR                   A9FEEDCD0
      ** Record Format
     C                   MOVE      'VJC'         XXCDBID
      ** Corporate Entity
     C                   MOVEL     PCorpEnt      XXCVJCC
      ** Journal ID
     C                   MOVEL     PBranch       DJRNI1
     C                   MOVEL     PSystem       DJRNI2
     C                   MOVEL     WKCCY         DJRNI3
     C                   MOVEL     '0'           DJRNI4
     C                   MOVEL     DSJRNID       XXCJRNID
      ** Effective Date
     C                   MOVE      DSRndDate     XXCEFFD
      ** Journal Seq
     C                   MOVE      DSJRNS        XXCJRNSQ
      ** Constant CY
     C                   MOVE      PConstCY      XXCCSTCY
      ** Constant CP
     C                   MOVE      PConstCP      XXCCSTCP
      ** Filler 1
     C                   MOVE      *BLANKS       XXCFIL1
      *
      ** Add up VJC Record added
     C                   Z-ADD     WXCTAMTD      XXCTAMTD
     C                   Z-ADD     WXCTAMTC      XXCTAMTC
     C                   Add       1             WXHTTVJC
     C                   WRITE     A9FEEDCD0
     C                   ENDIF
      *
      ** Reset total for VJC records
     C                   Z-ADD     0             WXCTAMTC         19 0
     C                   Z-ADD     0             WXCTAMTD         19 0
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * EXTHED - Write Feeder Header Record                           *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     EXTHED        BEGSR
      *
     C                   CLEAR                   A9FEEDHD0
      ** Record Format
     C                   MOVEL     'FCR'         XXHDBID
      ** Filler 1, 2 & 3
     C                   MOVEL     *BLANKS       XXHFIL1
     C                   MOVE      *ALL'0'       XXHFIL2
     C                   MOVEL     *BLANKS       XXHFIL3
      ** System
     C                   MOVE      PSystem       XXHSYST
      ** Rundate
     C                   MOVE      DSRndDate     XXHBUSD
      ** Rest of calculated fields already set in other Sb
     C                   Z-ADD     WXHTTVJC      XXHTTVJC
     C                   Z-ADD     WXHTTVLJ      XXHTTVLJ
     C                   Z-ADD     WXHTVLJD      XXHTVLJD
     C                   Z-ADD     WXHTVLJC      XXHTVLJC
     C                   Z-ADD     WXHTOTD       XXHTOTD
     C                   Z-ADD     WXHTOTC       XXHTOTC
      *
     C                   WRITE     A9FEEDHD0
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
     C                   EVAL      P@OP02 = PSysVal2
     C                   EVAL      P@OP03 = PSysVal3
     C                   EVAL      P@OP04 = PSysVal4
     C                   EVAL      P@OP05 = PSysVal5
     C                   EVAL      P@OP06 = PSysVal6
     C                   EVAL      P@OP07 = PSysVal7
     C                   EVAL      P@OP08 = PSysVal8
     C                   EVAL      P@OP09 = PSysVal9
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD             7
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM                    P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM                    P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM                    P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM                    P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM      *BLANKS       P@OP10
     C                   PARM      *BLANKS       P@VL10

      ** Setup work fields
      * Set PRecFmt  = P@VL01
      * Set PCorpEnt = P@VL02
      * Set PBranch  = P@VL03
      * Set PSystem  = P@VL04
      * Set PConstS  = P@VL05
      * Set PConst20 = P@VL06
      * Set PConstCY = P@VL07
      * Set PConstCP = P@VL08
      * Set PCompany = P@VL09
      *
     C                   EVAL      PRecFmt = *BLANKS
     C                   EVAL      PCorpEnt = *BLANKS
     C                   EVAL      PBranch = *BLANKS
     C                   EVAL      PSystem = *BLANKS
     C                   EVAL      PConstS = *BLANKS
     C                   EVAL      PConst20 = *BLANKS
     C                   EVAL      PConstCY = *BLANKS
     C                   EVAL      PConstCP = *BLANKS
     C                   EVAL      PCompany = *BLANKS
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      PRecFmt = P@VL01
     C                   EVAL      PCorpEnt = P@VL02
     C                   EVAL      PBranch = P@VL03
     C                   EVAL      PSystem = P@VL04
     C                   EVAL      PConstS = P@VL05
     C                   EVAL      PConst20 = P@VL06
     C                   EVAL      PConstCY = P@VL07
     C                   EVAL      PConstCP = P@VL08
     C                   EVAL      PCompany = P@VL09
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
     C                   MoveL     'A9005003'    DBPGM
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
