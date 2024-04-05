     H DEBUG
     H
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas A9 GLM / EDW Extract Files Format')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  A9005005 - Midas A9 GLM / EDW Extract files Format           *
      *                                                               *
      *  Function: GLM / EDW Extract format                           *
      *                                                               *
      *  Called by: A9C005002 - Midas A9 GLM/EDW Extract file Gen.    *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. MD059773           Date 11Mar24               *
      *  Prev Amend No. MD059406           Date 11Mar24               *
      *                 MD059075           Date 11Mar24               *
      *                 BA9005  *CREATE    Date 11Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059773 - EDW Layout file changes                           *
      *  MD059406 - Extract issues with Feeder and Proofing files     *
      *              Remove Product Code from Proofing file           *
      *              Recompile for changes in A9FEEDDTD               *
      *  MD059075 - Journal Feeder Header Filler incorrect (Recompile)*
      *  BA9005 - HO and EDW Extracts                                 *
      *                                                               *
      *****************************************************************
      *
     FA9FEEDHL0 IF   E           K Disk    InfSR(*PSSR)
      *
     FA9FEEDCL0 IF   E           K Disk    InfSR(*PSSR)
      *
     FA9FEEDDL2 IF   E           K Disk    InfSR(*PSSR)
      *
     FA9PROFFL0 IF   E           K Disk    InfSR(*PSSR)
      *
     FA9GLMETD  O    E           K Disk    InfSR(*PSSR)
      *
     FA9EDWETD  O    E           K Disk    InfSR(*PSSR)
      *
     FA9PRFETD  O    E           K Disk    InfSR(*PSSR)
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

     D PDateOut        S              6  0

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

      ** YYMMDD date format of Rundate
     D DSDayDate       DS
     D  WVY2D                  1      2  0
     D  WVMMD                  3      4  0
     D  WVDDD                  5      6  0

      ** YY/MM/DD date format of Rundate
     D DSPROFD         DS
     D  WPDDD                  1      2
     D  WPFI1                  3      3
     D  WPMMD                  4      5
     D  WPFI2                  6      6
     D  WPYYD                  7     10

     D DSHEADER        DS
     D  DSHDBID                1      3
     D  DSHFIL1                4     18
     D  DSHFIL2               19     31
     D  DSHSYST               32     34
     D  DSHBUSD               35     42
     D  DSHTTVJC              43     50
     D  DSHTTVLJ              51     58
     D  DSHTVLJD              59     66
     D  DSHTVLJC              67     74
     D  DSHTOTD               75     91
     D  DSHTOTC               92    108
     D  DSHFIL3              109    234
      *
     D DSCONTRL        DS
     D  DSCDBID                1      3
     D  DSCVJCC                4      8
     D  DSCJRNID               9     18
     D  DSCCCY                15     17
     D  DSCEFFD               19     26
     D  DSCJRNSQ              27     31
     D  DSCCSTCP              32     33
     D  DSCCSTCY              34     35
     D  DSCTAMTD              36     50
     D  DSCTAMTC              51     65
     D  DSCFIL1               66    234
      *
     D DSDETAIL        DS
     D  DSDDBID                1      3
     D  DSDVJCC                4      8
     D  DSDJRNID               9     18
     D  DSDEFFD               19     26
     D  DSDJRNSQ              27     31
     D  DSDGLMCP              32     75
     D  DSDHOAC               39     43
     D  DSDHOPC               44     47
     D  DSDHOMC               48     50
     D  DSDCCYL               76     78
     D  DSDCSTS               79     79
     D  DSDSLID               80     80
     D  DSDSLAC               81     96
     D  DSDSRCE               97    106
     D  DSDJRND              107    181
     D  DSDDLNO              164    171
     D  DSDDLTP              164    165                                                     MD059773
     D  DSDDLNS              166    171                                                     MD059773
     D  DSDDLFL              170    171                                                     MD059773
     D  DSDCUST              174    179
     D  DSDCSTCY             182    183
     D  DSDCSTCP             184    185
     D  DSDDRCR              186    186
     D  DSDLCBE              187    201
     D  DSDPSTA              202    216
     D  DSDRATE              217    234
      *
     D DSPROOF         DS
     D  DSPTRDT                1     10
     D  DSPFIL1               11     11
     D  DSPPCCY               12     14
     D  DSPFIL2               15     15
     D  DSPPACC               16     19
     D  DSPFIL3               20     20
     D**DSPPHOP               21     24                                                     MD059406
     D**DSPFIL4               25     25                                                     MD059406
     D**DSPPHOB               26     28                                                     MD059406
     D**DSPFIL5               29     29                                                     MD059406
     D**DSPPBLC               30     48                                                     MD059406
     D**DSPPSGN               49     49                                                     MD059406
     D  DSPPHOB               21     23                                                     MD059406
     D  DSPFIL5               24     24                                                     MD059406
     D  DSPPBLC               25     43                                                     MD059406
     D  DSPPSGN               44     44                                                     MD059406


     C/Title Main Processing
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
      * Perform Initialisation.
     C                   ExSR      Init
      *
      * Perform Feeder data to GLM and EDW flat file
     C                   ExSR      Feeder
      *
      * Perform Proofing data to flat file
     C                   ExSR      Proof
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
     C                   PARM                    DAYDATE           6
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
     C                   MOVE      DSDayDate     DAYDATE
      *
      ** Klist to access the A9FEEDDTD file
     C     KFEEDD        KList
     C                   KFld                    KFEED
     C                   KFld                    KFEED2            3
      *
     C                   EndSR
      *****************************************************************
      /Title SR/Feeder
      *****************************************************************
      *                                                               *
      *  Feeder - Subroutine to write Feeder data to flat file        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     Feeder        BegSR
      *
      ** Access A9FEEDHTD
      ** Write to GLM EDW flat file
     C                   MOVE      DSRndDate     KFEED             8 0
     C     KFEED         CHAIN     A9FEEDHL0                          50
     C                   if        *IN50 = '0'
     C                   CLEAR                   A9GLMED0
     C                   MOVEL     XXHDBID       DSHDBID
     C                   MOVEL     XXHFIL1       DSHFIL1
     C                   MOVEL     XXHFIL2       DSHFIL2
     C                   MOVEL     XXHSYST       DSHSYST
     C                   MOVEL     XXHBUSD       DSHBUSD
     C                   MOVEL     XXHTTVJC      DSHTTVJC
     C                   MOVEL     XXHTTVLJ      DSHTTVLJ
     C                   MOVEL     XXHTVLJD      DSHTVLJD
     C                   MOVEL     XXHTVLJC      DSHTVLJC
     C                   MOVEL     XXHTOTD       DSHTOTD
     C                   MOVEL     XXHTOTC       DSHTOTC
     C                   MOVEL     XXHFIL3       DSHFIL3
      *
     C                   MOVEL     DSHEADER      XXGLME
     C                   WRITE     A9GLMED0
      *
      ** Access A9FEEDCTD
      ** Write to GLM and EDW flat files
     C     KFEED         SETLL     A9FEEDCL0
     C     KFEED         READE     A9FEEDCL0                              51
     C                   Dow       *IN51 = '0' and XXCEFFD = KFEED
     C                   CLEAR                   A9GLMED0
     C                   MOVEL     XXCDBID       DSCDBID
     C                   MOVEL     XXCVJCC       DSCVJCC
     C                   MOVEL     XXCJRNID      DSCJRNID
     C                   MOVEL     XXCEFFD       DSCEFFD
     C                   MOVEL     XXCJRNSQ      DSCJRNSQ
     C                   MOVEL     XXCCSTCP      DSCCSTCP
     C                   MOVEL     XXCCSTCY      DSCCSTCY
     C                   MOVEL     XXCTAMTD      DSCTAMTD
     C                   MOVEL     XXCTAMTC      DSCTAMTC
     C                   MOVEL     XXCFIL1       DSCFIL1
      *
     C                   MOVEL     DSCONTRL      XXGLME
     C                   WRITE     A9GLMED0
      *
     C                   CLEAR                   A9EDWED0
     C                   MOVEL     DSCONTRL      XXGLMD
     C                   MOVEL     *BLANKS       XXDLNO
     C                   MOVEL     *BLANKS       XXCUST
     C                   MOVEL     *BLANKS       XXHOAC
     C                   MOVEL     *BLANKS       XXHOPC
     C                   MOVEL     *BLANKS       XXHOMC
     C                   WRITE     A9EDWED0
      *
     C                   MOVEL     DSCCCY        KFEED2
      *
      ** Access A9FEEDDTD
      ** Write to GLM and EDW flat files
     C     KFEEDD        SETLL     A9FEEDDL2
     C     KFEEDD        READE     A9FEEDDL2                              52
     C                   Dow       *IN52 = '0' and XXDEFFD = KFEED
     C                             and XXDCCYL = DSCCCY
     C                   CLEAR                   A9GLMED0
     C                   MOVE      XXDDBID       DSDDBID
     C                   MOVE      XXDVJCC       DSDVJCC
     C                   MOVE      XXDJRNID      DSDJRNID
     C                   MOVE      XXDEFFD       DSDEFFD
     C                   MOVE      XXDJRNSQ      DSDJRNSQ
     C                   MOVE      XXDGLMCP      DSDGLMCP
     C                   MOVE      XXDCCYL       DSDCCYL
     C                   MOVE      XXDCSTS       DSDCSTS
     C                   MOVE      XXDSLID       DSDSLID
     C                   MOVE      XXDSLAC       DSDSLAC
     C                   MOVE      XXDSRCE       DSDSRCE
     C                   MOVE      XXDJRND       DSDJRND
     C                   MOVE      XXDCSTCY      DSDCSTCY
     C                   MOVE      XXDCSTCP      DSDCSTCP
     C                   MOVE      XXDDRCR       DSDDRCR
     C                   MOVE      XXDLCBE       DSDLCBE
     C                   MOVE      XXDPSTA       DSDPSTA
     C                   MOVE      XXDRATE       DSDRATE
      *
     C                   MOVEL     DSDETAIL      XXGLME
     C                   WRITE     A9GLMED0
      *
     C                   CLEAR                   A9EDWED0
     C                   MOVEL     DSDETAIL      XXGLMD
     C     DSDDLFL       IFEQ      '  '                                                     MD059773
     C                   MOVEL     DSDDLNO       XXDLNO
     C                   ELSE                                                               MD059773
     C                   MOVEL     DSDDLNS       XXDLNO                                     MD059773
     C                   ENDIF                                                              MD059773
     C                   MOVEL     DSDCUST       XXCUST
     C                   MOVEL     DSDHOAC       XXHOAC
     C                   MOVEL     DSDHOPC       XXHOPC
     C                   MOVEL     DSDHOMC       XXHOMC
     C                   WRITE     A9EDWED0
      *
     C     KFEEDD        READE     A9FEEDDL2                              52
     C                   ENDDO
      *
     C     KFEED         READE     A9FEEDCL0                              51
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   EndSR
      *
      *****************************************************************
      /Title SR/Proof
      *****************************************************************
      *                                                               *
      *  Proof - Subroutine to write Proofing data to flat file       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     Proof         BegSR
      *
      ** Write to Proofing flat file
      *
     C                   MOVE      WVDDR         WPDDD
     C                   MOVE      '/'           WPFI1
     C                   MOVE      WVMMR         WPMMD
     C                   MOVE      '/'           WPFI2
     C                   MOVE      WVYYR         WPYYD
     C                   MOVE      DSPROFD       KPROOF           10
      *
     C     KPROOF        SETLL     A9PROFFL0
     C     KPROOF        READE     A9PROFFL0                              53
     C                   Dow       *IN53 = '0' and XXTRDT = KPROOF
     C                   CLEAR                   A9PRFED0
     C                   MOVEL     XXTRDT        DSPTRDT
     C                   MOVEL     ','           DSPFIL1
     C                   MOVEL     XXPCCY        DSPPCCY
     C                   MOVEL     ','           DSPFIL2
     C                   MOVEL     XXPACC        DSPPACC
     C                   MOVEL     ','           DSPFIL3
     C**********         MOVEL     XXPHOP        DSPPHOP                                    MD059406
     C**********         MOVEL     ','           DSPFIL4                                    MD059406
     C                   MOVEL     XXPHOB        DSPPHOB
     C                   MOVEL     ','           DSPFIL5
     C                   MOVEL     XXPBLC        DSPPBLC
     C                   MOVEL     XXPSGN        DSPPSGN
      *
     C                   MOVEL     DSPROOF       XXPRFE
     C                   WRITE     A9PRFED0
     C     KPROOF        READE     A9PROFFL0                              53
     C                   ENDDO
      *
     C                   ENDSR
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
     C                   MoveL     'A9005005'    DBPGM
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
