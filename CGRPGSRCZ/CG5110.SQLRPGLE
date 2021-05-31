     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
     H*CVTOPT*(*GRAPHIC)***********************************************            MD054955 MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG UDC Print Process Request')
/*OVRF*: OVRDBF (********) (********)                               : *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG5110 - UDC Print Process Request                           *
      *                                                               *
      *  Function:  This program displays a screen that allows a user *
      *             to select items of correspondence to print and    *
      *             the order to print them.                          *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 245055             Date 08Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241824             Date 06Oct06               *
      *                 CSD053             Date 01Jun06               *
      *                 226341             Date 08Jul04               *
      *                 227262             Date 08Jul04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 125920             Date 05Feb98               *
      *                 CCG009             Date 01Jun95               *
      *                 089246             DATE 08JUN95               *
      *                 088837             DATE 08JUN95               *
      *                 088008             DATE 18MAY95               *
      *                 086662             DATE 25APR95               *
      *                 084740             DATE 15MAR95               *
      *                 083786             DATE 16FEB95               *
      *                 S01522             DATE 07DEC94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  245055 - Review 241824.                                      *
      *  241824 - Allow print process request by Module Id and        *
      *           Extract Date. Allow Correspondent type to be        *
      *           displayed correctly and also allow selection on     *
      *           Language ID.                                        *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  226341 - Default as 'Y' the final print field.               *
      *  227262 - Add confirm key before submitting the print process *
      *           to minimize accidental printing.                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  125920 - Validation of Auto-transmission is incorrect.       *
      *  CCG009 - Private Banking UDC                                 *
      *  089246 - Allow *PREVD in To date                             *
      *  088837 - Order to print being incorrectly setup.             *
      *  088008 - Print last confirmation                             *
      *  086662 - Add correspondence type to selection criteria       *
      *  084740 - User is only allowed to select all Correspondents   *
      *           if they are authorised to Action Code 'Q' in SPF    *
      *  083786 - Correct fix of screen for periodic requests         *
      *  S01552 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  KC   -    CF03 key pressed                                   *
      *  KE   -    CF05 key pressed                                   *
      *  KJ   -    CF10 key pressed                                   *
      *  KL   -    CF12 key pressed                                   *
      *  30   -    Error on Correspondent                             *
      *  31   -    Error on Primary Correspondent Only                *
      *  32   -    Error on Print Type                                *
      *  33   -    Error on Sub-Type                                  *
      *  34   -    Error on From Date                                 *
      *  35   -    Error on To Date                                   *
      *  36   -    Error on Language ID                               *
      *  37   -    Error on Status 1                                  *
      *  38   -    Error on Status 2                                  *
      *  39   -    Error on Status 3                                  *
      *  40   -    Error on Status 4                                  *
      *  41   -    Error on Status 5                                  *
      *  42   -    Error on Access Path                               *
      *  43   -    Error on Auto Transmission flag                    *
      *  44   -    Final Print                                        *
      *  46   -    Error on Correspondent type                        *   086662
      *  47   -    Error on Print last conf.                          *   088008
      *  50   -    No Record found on LF/CGCORRL1                     *
      *  51   -    No Record found on LF/CGPTYPL1                     *
      *  52   -    No Record found on Screen Format @5110S1           *
      *  53   -    No Record found on LF/CGCTYPL0                     *   086662
      *  80   -    CHECK indicator                                    *
      *  90   -    General error Indicator                            *
      *  95   -    SFLEND indicator                                   *
      *  98   -    Error on call to AOLANGR0                          *
      *                                                               *
      *                                                               *
      *****************************************************************
     F*CGPTYPL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCG5110DF  CF   E             WORKSTN
     F                                     INFSR(SRFILE)
     FCGISTSL1  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     FCGCTYPL0  IF   E           K DISK                                         086662
     F                                     INFSR(SRFILE)                        086662
      * RTV : Print Item Status         Retrieval index
      *
      *
      /EJECT
      *
      **  Status Fields
     D #STS            S             80    DIM(5)
      *
      **  Copyright array.
     D**********          ##MON  12  12  3                                              241824245055
     D ##MOD           S              2    DIM(8) CTDATA PERRCD(8)
      *COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
      /EJECT
      *
     D*P#PARM      DS                            100                                          241824
     D*P#PARM      DS                            115                                    241824245055
     D P#PARM          DS           100
      **  DS to obtain Data from RCF Parm
     D  ##USER                 1     10
     D  ##DCOR                11     20
     D  ##PRIM                21     21
     D  ##PTYP                22     31
     D  ##PSTP                32     41
     D  ##FRDT                42     46  0
     D  ##TODT                47     51  0
     D**********                             52  61 ##LGID                                    241824
     D  ##LGID                52     53
     D  ##EXDT                54     58  0
     D  ##MODI                59     60
     D***************************************62  71 ##ACCP                CCG009
     D  ##ACCP                62     63                                         CCG009
     D  #WGPTR                64     71                                         CCG009
     D  ##STS1                72     75
     D  ##STS2                76     79
     D  ##STS3                80     83
     D  ##STS4                84     87
     D  ##STS5                88     91
     D  ##ATRM                92     92
     D  ##PPFN                93     93
     D  ##ARCH                94     94
     D  ##COT                 96     96                                         086662
     D  ##PLST                97     97                                         088008
     D**********                             98 104 ##EXDT                              241824245055
     D**********                            105 106 ##MODI                              241824245055
     D/COPY WNCPYSRC,CG5110I001
      *
     D P1PARM          DS           100
      **  Data structure for Correspondent Details
     D  #1CORR                 1     10
     D  #1CUST                11     16
     D  #1BRCH                17     19
     D  #1CTRN                20     27
     D**********                             28  45 #1ACID                                    CGL029
     D**********                             46  49 #1ACOD                                    CGL029
     D  QQACID                28     45
     D  QQACOD                46     49
     D  #1PTYP                50     57
     D  #1ACID                58     81
     D  #1ACOD                82     91
      *
     D P2PARM          DS            33
      **  Data Structure to retrieve Print Type/Sub-Type information
     D  #2PTYP                 1     10
     D  #2PSTP                11     20
      *
     D                 DS
      **  Data Structure to define fields as zoned.
     D  ##DATE                 1      6  0
      *
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D DSRUN           DS
      **  Bank details
     D  ##RDAT                 1      7
     D  ##RUND                 8     10P 0
     D  ##SSF                 11     11
     D  ##DATF                12     12
     D  ##MBIN                13     13
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDLANG        E DS                  EXTNAME(SDLANGPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First data structure for access program, Short data structure
      *
     D O3PARM          DS             4
      * KEY: Print Item Status         Retrieval index
      * I : MAP Item Status
     D  O3ISTS                 1      4
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
     D**********  DS                                                                    241824245055
     D**********                              1   7 S#EXDT                              241824245055
     D**********                              1   2 #DAY                                241824245055
     D**********                              1   20#DAYN                               241824245055
     D**********                              3   5 #MONTH                              241824245055
     D**********                              6   7 #YEAR                               241824245055
     D**********                              6   70#YEARN                              241824245055
      *                                                                   084740
      *                                                                   084740
     D W0DATA          DS           256                                         084740
      *                                                                   084740
      *  Define data structure used to pass parameters                    084740
      *                                                                   084740
     D  B#BRCA                 1      3                                         084740
     D  O#ACTD                 4      4                                         084740
     D  O#CPGM                 5     14                                         084740
      **  Define a constant
     D C#NUMB          C                   CONST('0123456789')
      *
     D CGPTYP        E DS                  EXTNAME(CGPTYJW0)                                MD054955
      *COPY*CGCPYSRC,SRERRI                                                                 MD054955
      /EJECT
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   SRMAIN - Main processing                                    *
      *   SRSCRN - Process Input Screen Data                          *
      *   SRCLRS - Clear Data Fields on Screen                        *
      *   SRSINT - Initialise Screen Indicators                       *
      *   SRINIT - Initial processing - On First Call                 *
      *   SRTERM - Termination Processing                             *
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRMAIN - Main Processing                       *
      *                SRTERM - Termination Processing                *
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    P#RSEQ            5
     C                   PARM                    P#RLVL            1
     C**********           PARM           P#RENT  1                       084740
     C                   PARM                    P#RENT            3                           08474
     C                   PARM                    P#PARM
     C                   PARM                    P#RACT            1
     C                   PARM                    P#RCMD            1
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
      *
      **  Set up screen depending on action
     C                   EXSR      SRCLRS
      *
      **  Detail process
     C                   EXSR      SRMAIN
      *
      **  Termination Process
     C                   EXSR      SRTERM
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRMAIN                                         *
      * Function    :  Main processing                                *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  SRSINT - Initialise Screen Indicators          *
      *                SRSCRN - Process Input Screen Data             *
      *                SRCLRS - Clear Data Fields on Screen           *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      *................................................................
      *
      **  Continue Processing while CF03 and CF12 have not been input
      **  and errors exist.
     C                   MOVE      'Y'           ##ERR
     C     *INKC         DOWEQ     *OFF
     C     *INKL         ANDEQ     *OFF
     C     *INKJ         ANDEQ     *OFF
     C     ##ERR         ANDEQ     'Y'
      *
      **  Update the displayed time.
     C                   TIME                    S#TIME
      *
      **  Display and read the main screen
     C                   WRITE     SFLMSGC
     C                   WRITE     @5110S9
     C                   WRITE     @5110S1
     C                   READ      @5110S1                                52
      *
      **  Clear the Program Message Queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      'CG5110  '    PGMQ
     C                   PARM      '*SAME'       ##REL             5
      *
      **  Initialise the screen indicators.
     C                   EXSR      SRSINT
      *
      **  If CF03 and CF12 have not been input, process input.
     C     *INKC         IFEQ      *OFF
     C     *INKL         ANDEQ     *OFF
     C     *INKJ         ANDEQ     *OFF
      *
      **  If CF05 has been input, clear fields and do not validate.
     C     *INKE         IFEQ      *ON
     C                   EXSR      SRCLRS
     C                   MOVE      'Y'           ##ERR
     C                   ELSE
      *
      **  If CF05 has not been input process the screen fields.
      *
      **  and either amend or insert processing
     C     P#RACT        IFNE      'E'
     C     P#RACT        ANDNE     'D'
     C                   EXSR      SRSCRN
     C     *INKF         IFNE      *ON
     C     ##ERR         ANDNE     'Y'
     C                   MOVEL     'CGD3000'     ##MGID           10
     C                   EXSR      SRSMSG
     C                   MOVE      'Y'           ##ERR
     C                   MOVE      *ON           *IN78
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      *................................................................
      *
     C     EXMAIN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRSCRN                                         *
      * Function    :  Process Input Screen Data                      *
      *                                                               *
      * Called by   :  SRMAIN - Main Processing                       *
      * Calls       :  SRSMSG - Send Message                          *
      *****************************************************************
     C     SRSCRN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRSCRN'      @STK(Q)
      *
      *................................................................
      *
      *---------------------------------------------------------------*
      *  Correspondent                                                *
      *---------------------------------------------------------------*
     C     S#DCOR        IFNE      *BLANKS
      *
      **  Determine whether selection has been requested.
     C     ' ?'          CHECK     S#DCOR                                 80
      *
      **  If selection has been requested, process the selection
     C     *IN80         IFEQ      *OFF
     C                   MOVEL     *BLANKS       P1PARM
     C                   CALL      'CG0021'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      'S'           ##ACTC            1
     C                   PARM                    P1PARM
      *
      **  Error in called program.
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     'USR0790'
     C     ##RTCD        ANDNE     'Y2U9999'
     C                   MOVEL     ##RTCD        W0KEY
      *                                                    ***************
     C                   MOVEL     'CG0021  '    W0FILE                         * DB ERROR 01 *
     C                   Z-ADD     01            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Set up the retrieved Correspondent, and set the error flag to
      **  cause the full selection to be redisplayed.
     C                   MOVEL     #1CORR        S#DCOR
     C                   MOVE      'Y'           ##ERR             1
     C                   ENDIF
      *
      **  Validate the Correspondent, whether input or selected.
     C     S#DCOR        IFNE      *BLANKS
     C     S#DCOR        CHAIN     @CORRL1                            50
      *
      **  If no record found process error.
     C     *IN50         IFEQ      *ON
     C***********CDRTYP    ORNE 'C'                                       086662
     C                   MOVEL     'CGD1157'     ##MGID           10
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN30
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                   084740
      **  If the Correspondent is blank, ie all Correspondents,           084740
      **  determine whether the user is allowed to select 'ALL'.          084740
     C     S#DCOR        IFEQ      *BLANKS                                                     08474
      *                                                                   084740
      **  Determine whether the user is authorised to Action Code 'Q'     084740
      *                                                                   084740
      *                                                                   084740
      * Check all valid action 'Q'                                        084740
      *                                                                   084740
     C                   CLEAR                   W0DATA                                        08474
     C                   MOVEL     *BLANKS       B#BRCA                                        08474
     C                   MOVEL     'CG1020'      O#CPGM                                        08474
     C                   MOVEL     'Q'           O#ACTD                                        08474
      *                                                                   084740
     C                   CALL      'CG1020'                             9090                   08474
     C                   PARM      *BLANKS       P0RTN             7                           08474
     C                   PARM      '*ACTCODE'    W0ACT             8                           08474
     C                   PARM                    W0DATA                                        08474
      *                                                                   084740
      **  User has no authority to action                                 084740
     C***********P0RTN     IFNE *ZEROS                              084740086662
     C     P0RTN         IFNE      *BLANKS                                                     08666
     C     *IN90         OREQ      *ON                                          *IF            08474
     C                   MOVEL     'CGD2415'     ##MGID                                        08474
     C                   EXSR      SRSMSG                                                      08474
     C                   MOVE      *ON           *IN30                                         08474
     C                   MOVE      'Y'           ##ERR                                         08474
     C                   ENDIF                                                                 08474
     C                   ENDIF                                                                 08474
      *                                                                   086662
      *---------------------------------------------------------------*   086662
      *  Correspondent type?                                          *   086662
      *---------------------------------------------------------------*   086662
      *                                                                   086662
     C     S#CTYP        IFNE      *BLANKS                                                     08666
      *                                                                   086662
      **  Determine whether selection has been requested.                 086662
     C     ' ?'          CHECK     S#CTYP                                 80                   08666
      *                                                                   086662
      **  If selection has been requested, process the selection          086662
     C     *IN80         IFEQ      *OFF                                                        08666
     C                   CALL      'CG0040'                                                    08666
     C                   PARM      *BLANKS       ##RTCD                                        08666
     C                   PARM      'S'           ##ACTC                                        08666
     C                   PARM      *BLANKS       P3PARM           10                           08666
      *                                                                   086662
      **  Error in called program.                                        086662
     C     ##RTCD        IFNE      *BLANK                                                      08666
     C     ##RTCD        ANDNE     'USR0790'                                                   08666
     C     ##RTCD        ANDNE     'Y2U9999'                                                   08666
     C                   MOVEL     ##RTCD        W0KEY                                         08666
      *                                                    ***************086662
     C                   MOVEL     'CG0040  '    W0FILE                         * DB ERROR 06 *08666
     C                   Z-ADD     06            W0ERNB                         ***************08666
     C                   MOVEL     'MEM5003'     W0MSGD                                        08666
     C                   MOVEL     'MIDAS  '     W0MSGF                                        08666
     C                   EXSR      SRERR                                                       08666
     C                   ENDIF                                                                 08666
      *                                                                   086662
      **  Set up the retrieved Correspondent type, and set the error      086662
      **  flag to cause the full selection to be redisplayed.             086662
     C                   MOVEL     P3PARM        S#CTYP                                        08666
     C                   MOVE      'Y'           ##ERR                                         08666
     C                   ENDIF                                                                 08666
      *                                                                   086662
      **  Validate the Correspondent, whether input or selected.          086662
     C     S#CTYP        IFNE      *BLANKS                                                     08666
     C     S#CTYP        CHAIN     @CTYPL0                            53                       08666
      *                                                                   086662
      **  If no record found process error.                               086662
     C     *IN53         IFEQ      *ON                                                         08666
     C     CTRECI        ORNE      'D'                                                         08666
     C                   MOVEL     'CGD1279'     ##MGID                                        08666
     C                   EXSR      SRSMSG                                                      08666
     C                   MOVE      *ON           *IN46                                         08666
     C                   MOVE      'Y'           ##ERR                                         08666
     C                   ENDIF                                                                 08666
     C                   ENDIF                                                                 08666
     C                   ENDIF                                                                 08666
      *                                                                   086662
      **  Correspondent and Correspondent type are mutually exclusive.    086662
     C     S#DCOR        IFNE      *BLANKS                                                     08666
     C     S#CTYP        ANDNE     *BLANKS                                                     08666
     C                   MOVEL     'CGD1850'     ##MGID                                        08666
     C                   EXSR      SRSMSG                                                      08666
     C                   SETON                                        3046                     08666
     C                   MOVE      'Y'           ##ERR                                         08666
     C                   ENDIF                                                                 08666
      *
      *---------------------------------------------------------------*
      *  Primary Correspondent?                                       *
      *---------------------------------------------------------------*
      *
      **  If the input value is not 'Y' or 'N', process an error.
     C     S#PRIM        IFNE      'Y'
     C     S#PRIM        ANDNE     'N'
     C                   MOVEL     'CGD1571'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN31
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  Print Type/Sub-Type                                          *
      *---------------------------------------------------------------*
     C     S#PTYP        IFNE      *BLANKS
      *
      **  Determine whether selection has been requested.
     C     ' ?'          CHECK     S#PTYP                                 80
      *
      **  If selection has been requested, process the selection
     C     *IN80         IFEQ      *OFF
     C                   MOVEL     *BLANKS       P2PARM
     C                   CALL      'CG1180'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      'S'           ##ACTC            1
     C                   PARM                    P2PARM
      *
      **  Error in called program.
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     'USR0790'
     C     ##RTCD        ANDNE     'Y2U9999'
     C                   MOVEL     ##RTCD        W0KEY
      *                                                    ***************
     C                   MOVEL     'CG1180  '    W0FILE                         * DB ERROR 02 *
     C                   Z-ADD     02            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Set up the retrieved Print Type/Sub-Type and set the error
      **  flag to cause the full selection to be redisplayed.
     C                   MOVEL     #2PTYP        S#PTYP
     C     S#PSTP        IFEQ      *BLANKS
     C                   MOVEL     #2PSTP        S#PSTP
     C                   ENDIF
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
      **  Print Sub-Type specific validation.
     C     S#PSTP        IFNE      *BLANKS
      *
      **  If data has been input but Print Type is blank, process an
      **  error.
     C     S#PTYP        IFEQ      *BLANKS
     C                   MOVEL     'CGD1572'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN33
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *
      **  Determine whether selection has been requested.
     C     ' ?'          CHECK     S#PSTP                                 80
      *
      **  If selection has been requested, process an error.
     C     *IN80         IFEQ      *OFF
     C                   MOVEL     'CGD1573'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN33
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
      **  Validate the Print Type/Sub-Type, whether input or selected.
     C     S#PTYP        IFNE      *BLANKS
     C     S#PSTP        ORNE      *BLANKS
      *
     C*****S#PTYP        SETLL     @PTYPL1                                                  MD054955
     C*****S#PTYP        READE     @PTYPL1                                51                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare PCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGPTYJW0                                                              MD054955
     C+ where ITPTYP = :S#PTYP and ITPSTP = :S#PSTP and ITRECI = 'D'                        MD054955
     C+ order by ITPTYP, ITPSTP                                                             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open PCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from PCursor into :CGPTYP                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
      **  If a record is found and a Sub-Type has been input, continue
      **  until a match is found or end of file reached.
     C                   MOVE      *OFF          *IN80                                         CCG00
     C     S#PSTP        IFNE      *BLANKS
     C******IN51         DOWEQ     *OFF                                                     MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
     C     S#PSTP        IFEQ      ITPSTP
      *                                                                   CCG009
      **  If the Type/Sub-Type is part of a group,                        CCG009
      **  only the Type may be selected for printing                      CCG009
     C     ITGPHD        IFNE      *BLANK                                                      CCG00
     C                   MOVE      *ON           *IN80                                         CCG00
     C                   END                                                                   CCG00
      *                                                                   CCG009
     C                   LEAVE
     C                   ENDIF
     C*****S#PTYP        READE     @PTYPL1                                51                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from PCursor into :CGPTYP                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ENDDO
     C                   ENDIF
      *
      **  If no record found process error.
     C******IN51         IFEQ      *ON                                                      MD054955
     C                   IF        SQLCODE = 100                                            MD054955
     C                   MOVEL     'CGD1357'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN33
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C/EXEC SQL                                                                             MD054955
     C+ close PCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
      *                                                                   CCG009
      **  If an invalid Sub-Type has been selected for printing           CCG009
     C     *IN80         IFEQ      *ON                                                         CCG00
     C                   MOVEL     'CGD1529'     ##MGID                                        CCG00
     C                   EXSR      SRSMSG                                                      CCG00
     C                   MOVE      *ON           *IN33                                         CCG00
     C                   MOVE      'Y'           ##ERR                                         CCG00
     C                   ENDIF                                                                 CCG00
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  From Date                                                    *
      *---------------------------------------------------------------*
     C                   Z-ADD     *ZEROS        ##FRDT
     C     S#FRDT        IFNE      *BLANKS
     C     S#FRDT        IFNE      '*TODAY'
      *
      **  Check input date is numeric.
     C     C#NUMB        CHECK     S#FRDT                                 80
     C     *IN80         IFEQ      *ON
     C                   MOVE      '1'           ##RTN
     C                   ELSE
      *
      **  Call ZA0270 to validate the input date and convert it to a
      **  Day Number.
     C                   MOVE      S#FRDT        ##DATE
     C                   Z-ADD     ##DATE        ##DATP
      *
     C                   CALL      'ZA0270'
     C                   PARM                    ##DATP            6 0
     C                   PARM      BJDFIN        ##DFMT            1
     C                   PARM      *ZERO         ##RTN             1
     C                   PARM      *ZERO         ##DAYN            5 0
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-SUB     1             ##DAYN
     C                   MOVEL     '0'           ##RTN
     C                   ENDIF
      *
      **  If the date is invalid, process error.
     C     ##RTN         IFNE      *ZERO
     C                   MOVEL     'CGD1574'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN34
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *
      **  If the input Date is after the Run Date, process an error.
     C     ##DAYN        IFGT      ##RUND
     C                   MOVEL     'CGD1575'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN34
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   Z-ADD     ##DAYN        ##FRDT
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  To Date                                                      *
      *---------------------------------------------------------------*
     C                   Z-ADD     *ZEROS        ##TODT
     C     S#TODT        IFNE      *BLANKS
     C     S#TODT        IFNE      '*PREVD'                                                    08924
      *
      **  Check input date is numeric.
     C     C#NUMB        CHECK     S#TODT                                 80
     C     *IN80         IFEQ      *ON
     C                   MOVE      '1'           ##RTN
     C                   ELSE
      *
      **  Call ZA0270 to validate the input date and convert it to a
      **  Day Number.
     C                   MOVE      S#TODT        ##DATE
     C                   Z-ADD     ##DATE        ##DATP
      *
     C                   CALL      'ZA0270'
     C                   PARM                    ##DATP
     C                   PARM      BJDFIN        ##DFMT            1
     C                   PARM      *ZERO         ##RTN             1
     C                   PARM      *ZERO         ##DAYN            5 0
     C                   ENDIF
      *
     C                   ELSE                                                                  08924
     C                   Z-SUB     2             ##DAYN                                        08924
     C                   MOVEL     '0'           ##RTN                                         08924
     C                   ENDIF                                                                 08924
      **  If the date is invalid, process error.
     C     ##RTN         IFNE      *ZERO
     C                   MOVEL     'CGD1576'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN35
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *
      **  If the input Date is after the Run Date, process an error.
     C     ##DAYN        IFGT      ##RUND
     C                   MOVEL     'CGD1577'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN35
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   Z-ADD     ##DAYN        ##TODT
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  From Date/To Date                                            *
      *---------------------------------------------------------------*
      *
      **  If the From and To dates have been entered and are both valid
      **  check that the From Date is before the To Date.
     C     S#FRDT        IFNE      *BLANKS
     C     S#TODT        ANDNE     *BLANKS
     C     *IN34         ANDEQ     *OFF
     C     *IN35         ANDEQ     *OFF
      *
     C     ##FRDT        IFGT      ##TODT
     C                   MOVEL     'CGD1578'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN35
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
      **  If the From date *TODAY then To date not allowed
     C     S#FRDT        IFEQ      '*TODAY'
     C     S#TODT        ANDNE     *BLANKS
     C     *IN34         ANDEQ     *OFF
     C     *IN35         ANDEQ     *OFF
      *
     C     ##FRDT        IFGT      ##TODT
     C                   MOVEL     'CGD1578'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN35
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  Language ID                                                  *
      *---------------------------------------------------------------*
     C     S#LGID        IFNE      *BLANKS
      *
      **  Determine whether Input language ID valid
     C                   MOVEL     S#LGID        #3LGID
      *
     C                   CALL      'AOLANGR0'                           9898
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY'        ##OPTN
     C                   PARM                    #3LGID            2
     C     SDLANG        PARM      *BLANKS       DSFDY
      *
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'AOLANGR0'    W0FILE                         ***************
     C                   MOVEL     #3LGID        W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  If no record is found, process an error
     C     ##RTCD        IFNE      *BLANKS
      *
     C                   MOVEL     'CGD1280'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN36
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  Status Fields                                                *
      *---------------------------------------------------------------*
      *
      **  Load non-blank status fields into an array
     C                   Z-ADD     1             J                 3 0
     C                   MOVEA     *BLANKS       #STS
      *
     C     S#STS1        IFNE      *BLANKS
     C                   MOVE      S#STS1        #STS(J)
     C                   ADD       1             J
     C                   ELSE
     C                   MOVE      'SCHD'        #STS(1)
     C                   ENDIF
      *
     C     S#STS2        IFNE      *BLANKS
     C     S#STS2        ANDNE     S#STS1
     C                   MOVE      S#STS2        #STS(J)
     C                   ADD       1             J
     C                   ENDIF
      *
     C     S#STS3        IFNE      *BLANKS
     C     S#STS3        ANDNE     S#STS1
     C     S#STS3        ANDNE     S#STS2
     C                   MOVE      S#STS3        #STS(J)
     C                   ADD       1             J
     C                   ENDIF
      *
     C     S#STS4        IFNE      *BLANKS
     C     S#STS4        ANDNE     S#STS1
     C     S#STS4        ANDNE     S#STS2
     C     S#STS4        ANDNE     S#STS3
     C                   MOVE      S#STS4        #STS(J)
     C                   ADD       1             J
     C                   ENDIF
      *
     C     S#STS5        IFNE      *BLANKS
     C     S#STS5        ANDNE     S#STS1
     C     S#STS5        ANDNE     S#STS2
     C     S#STS5        ANDNE     S#STS3
     C     S#STS5        ANDNE     S#STS4
     C                   MOVE      S#STS5        #STS(J)
     C                   ADD       1             J
     C                   ENDIF
     C                   MOVE      *BLANKS       S#STS1
     C                   MOVE      *BLANKS       S#STS2
     C                   MOVE      *BLANKS       S#STS3
     C                   MOVE      *BLANKS       S#STS4
     C                   MOVE      *BLANKS       S#STS5
      *
      **  If an entry has been made, validate it.
     C     J             IFNE      1
      *
     C     J             IFGT      1
     C                   MOVE      #STS(1)       ##STAT
     C                   EXSR      SRSTAT
     C                   MOVE      ##STAT        S#STS1
     C     W0RTN         IFNE      *BLANKS
     C                   MOVE      *ON           *IN37
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
     C     J             IFGT      2
     C                   MOVE      #STS(2)       ##STAT
     C                   EXSR      SRSTAT
     C                   MOVE      ##STAT        S#STS2
     C     W0RTN         IFNE      *BLANKS
     C                   MOVE      *ON           *IN38
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
     C     J             IFGT      3
     C                   MOVE      #STS(3)       ##STAT
     C                   EXSR      SRSTAT
     C                   MOVE      ##STAT        S#STS3
     C     W0RTN         IFNE      *BLANKS
     C                   MOVE      *ON           *IN39
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
     C     J             IFGT      4
     C                   MOVE      #STS(4)       ##STAT
     C                   EXSR      SRSTAT
     C                   MOVE      ##STAT        S#STS4
     C     W0RTN         IFNE      *BLANKS
     C                   MOVE      *ON           *IN40
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *
     C     J             IFGT      5
     C                   MOVE      #STS(5)       ##STAT
     C                   EXSR      SRSTAT
     C                   MOVE      ##STAT        S#STS5
     C     W0RTN         IFNE      *BLANKS
     C                   MOVE      *ON           *IN41
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  Auto Transmission Flag                                       *
      *---------------------------------------------------------------*
      *
      **  If the input value is not blank, 'L' or 'C' process an error.
     C     S#ATRM        IFNE      *BLANK
     C***********S#ATRM    ANDNE'L'                                       125920
     C***********S#ATRM    ANDNE'C'                                       125920
     C     S#ATRM        ANDNE     'Y'                                                         12592
     C     S#ATRM        ANDNE     'N'                                                         12592
     C                   MOVEL     'CGD1610'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN43
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *---------------------------------------------------------------*                       241824
      *  Extract Date                                                 *                       241824
      *---------------------------------------------------------------*                       241824
      *                                                                                       241824
      **  If the input value is not in correct format process an error.                       241824
     C********** S#EXDT    IFNE *BLANK                                                  241824245055
     C********** #MONTH    LOKUP##MON                    98                             241824245055
     C********** *IN98     IFEQ '0'                                                     241824245055
     C********** #DAYN     ORLT 1                                                       241824245055
     C********** #DAYN     ORGT 31                                                      241824245055
     C********** #YEARN    ORLT 0                                                       241824245055
     C********** #YEARN    ORGT 99                                                      241824245055
     C**********           MOVEL'CGD1556' ##MGID                                        241824245055
     C**********           EXSR SRSMSG                                                  241824245055
     C**********           MOVE *ON       *IN88                                         241824245055
     C**********           MOVE 'Y'       ##ERR                                         241824245055
     C**********           ENDIF                                                        241824245055
     C**********           ENDIF                                                        241824245055
      *                                                                                       241824
     C                   Z-ADD     *ZEROS        ##EXDT
     C     S#EXDT        IFNE      *BLANKS
     C     S#EXDT        IFNE      '*TODAY'
      *                                                                                       245055
      **  Check input date is numeric.                                                        245055
     C     C#NUMB        CHECK     S#EXDT                                 80
     C     *IN80         IFEQ      *ON
     C                   MOVE      '1'           ##RTN
     C                   ELSE
      *                                                                                       245055
      **  Call ZA0270 to validate the input date and convert it to a                          245055
      **  Day Number.                                                                         245055
     C                   MOVE      S#EXDT        ##DATE
     C                   Z-ADD     ##DATE        ##DATP
      *                                                                                       245055
     C                   CALL      'ZA0270'
     C                   PARM                    ##DATP            6 0
     C                   PARM      BJDFIN        ##DFMT            1
     C                   PARM      *ZERO         ##RTN             1
     C                   PARM      *ZERO         ##DAYN            5 0
     C                   ENDIF
      *                                                                                       245055
     C                   ELSE
     C                   Z-SUB     1             ##DAYN
     C                   MOVEL     '0'           ##RTN
     C                   ENDIF
      *                                                                                       245055
      **  If the date is invalid, process error.                                              245055
     C     ##RTN         IFNE      *ZERO
     C                   MOVEL     'CGD1556'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN88
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *                                                                                       245055
      **  If the input Date is after the Run Date, process an error.                          245055
     C     ##DAYN        IFGT      ##RUND
     C                   MOVEL     'CGD1575'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN88
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   Z-ADD     ##DAYN        ##EXDT
     C                   ENDIF
      *                                                                                       245055
      *---------------------------------------------------------------*                       241824
      *  Module Id.                                                                           241824
      *---------------------------------------------------------------*                       241824
      *                                                                                       241824
      **  If the module Id does not exist format process an error.                            241824
     C     S#MODI        IFNE      *BLANK
     C     S#MODI        LOOKUP    ##MOD                                  99
     C     *IN99         IFEQ      '0'
     C                   MOVEL     'CGD1561'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN87
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       241824
     C/COPY WNCPYSRC,CG5110C001
      *
      *---------------------------------------------------------------*
      *  Access Path                                                  *
      *---------------------------------------------------------------*
      *
      **  If the input value is not 'L' or 'C', process an error.
     C     S#ACCP        IFNE      'L'
     C     S#ACCP        ANDNE     'C'
     C                   MOVEL     'CGD1580'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN42
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  Print Final                                                  *
      *---------------------------------------------------------------*
      *
      **  If the input value is not 'Y' or blank , process an error.
     C     S#PPFN        IFNE      'Y'
     C     S#PPFN        ANDNE     *BLANKS
     C                   MOVEL     'CGD1651'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN44
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *
      *---------------------------------------------------------------*
      *  Current or Archive files                                     *
      *---------------------------------------------------------------*
      *
      **  If the input value is not 'C' or 'A', process an error.
     C     S#ARCH        IFNE      'C'
     C     S#ARCH        ANDNE     'A'
     C                   MOVEL     'CGD1666'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVE      *ON           *IN45
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *
      **  If no error then compare Final Print and "A"
     C     S#ARCH        IFEQ      'A'
     C     S#PPFN        ANDEQ     'Y'
     C     ##ERR         ANDEQ     'N'
     C                   MOVEL     'CGD1667'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVEA     '11'          *IN(44)
     C                   MOVE      'Y'           ##ERR
     C                   ENDIF
      *                                                                   088008
      *---------------------------------------------------------------*   088008
      *  Print last confirmation                                      *   088008
      *---------------------------------------------------------------*   088008
      *                                                                   088008
      **  If the input value is not 'Y or blank process an error.         088008
     C     S#PLST        IFNE      'Y'                                                         08800
     C     S#PLST        ANDNE     *BLANKS                                                     08800
     C                   MOVEL     'CGD2499'     ##MGID                                        08800
     C                   EXSR      SRSMSG                                                      08800
     C                   MOVE      *ON           *IN47                                         08800
     C                   MOVE      'Y'           ##ERR                                         08800
     C                   ENDIF                                                                 08800
      *                                                                   088008
      **  If print last confirmation is Y,Current or Archive must be C.   088008
     C     S#PLST        IFEQ      'Y'                                                         08800
     C     S#ARCH        ANDNE     'C'                                                         08800
     C                   MOVEL     'CGD2522'     ##MGID                                        08800
     C                   EXSR      SRSMSG                                                      08800
     C                   MOVE      *ON           *IN45                                         08800
     C                   MOVE      'Y'           ##ERR                                         08800
     C                   ENDIF                                                                 08800
      *
      *................................................................
      *
     C     EXSCRN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRSTAT                                         *
      * Function    :  Validate Status                                *
      *                                                               *
      * Called by   :  SRSCRN - process Input Screen Data             *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRSTAT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRSTAT'      @STK(Q)
      *
      *................................................................
     C                   MOVEL     *BLANK        W0RTN             7
     C     *LIKE         DEFINE    ISISTS        ##STAT
      * If all low order keys not entered, exit
     C     ##STAT        IFEQ      *BLANK                                       Status
     C                   GOTO      EXSTAT
     C                   END
      *
      * Check for selection
      *
     C     ' ?'          CHECK     ##STAT                                 90
     C     *IN90         IFEQ      '0'
     C     ##STAT        ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       O3PARM
     C                   CALL      'CG1200'                             9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      'S'           O3ACTC            1            Action Code
     C                   PARM                    O3PARM                         B:RDE
      *
      * Analyse return code
      *
     C     *IN90         IFEQ      '0'
     C     P@RTCD        ANDEQ     *BLANKS
      * Record found
     C                   MOVEL     O3ISTS        ##STAT
      *
      * Delay
      *
     C                   MOVEL     'Y'           ##ERR
     C                   GOTO      EXSTAT
     C                   END
      *
     C                   END
      *
     C     KLSTAT        KLIST
     C                   KFLD                    ISISTS                         Item Status
      * Setup key
     C                   MOVEL     ##STAT        ISISTS                         Item Status
     C     KLSTAT        CHAIN     @ISTSL1                            9091      *
     C     *IN90         IFEQ      '0'
      *
      * Item status may not be deleted
      *
     C     ##STAT        IFEQ      'DLTD'
     C                   MOVEL     'CGD1669'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVEL     'CGD1669'     W0RTN
     C                   END
      *
      * Item status may not be PRTD  for final print
      *
     C     ##STAT        IFEQ      'PRTD'
     C     S#PPFN        ANDEQ     'Y'
     C                   MOVEL     'CGD1670'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVEL     'CGD1670'     W0RTN
     C                   END
      * Record found - move back any virtuals
     C                   MOVEL     ISISTS        ##STAT                         Item Status
     C                   GOTO      EXSTAT
     C                   END
      * Send message 'Item Status            NF'
     C                   MOVEL     'CGD1668'     ##MGID
     C                   EXSR      SRSMSG
     C                   MOVEL     'CGD1668'     W0RTN
      *................................................................
      *
     C     EXSTAT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRSMSG                                         *
      * Function    :  Send a Message to the Program Message Queue    *
      *                                                               *
      * Called by   :  SRSCRN - process Input Screen Data             *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRSMSG        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRSMSG'      @STK(Q)
     C/COPY WNCPYSRC,CG5110C002
      *
      *................................................................
      *
      **  Send the message.
     C                   CALL      'Y2SNMGC'
     C                   PARM      'CG5110  '    PGMQ
     C                   PARM      *BLANKS       ##REL
     C                   PARM                    ##MGID
     C/COPY WNCPYSRC,CG5110C003
     C                   PARM      'CGUSRMSG'    ##MSGF           10
     C/COPY WNCPYSRC,CG5110C004
     C                   PARM                    ##MDTA          132
     C                   PARM                    ##MSTP            7
      *
     C                   MOVE      *BLANKS       ##REL
     C                   MOVE      *BLANKS       ##MDTA
     C                   MOVE      *BLANKS       ##MSTP
      *
      *................................................................
      *
     C     EXSMSG        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRCLRS                                         *
      * Function    :  Clear data fields on screen                    *
      *                                                               *
      * Called by   :  SRMAIN - Main Processing                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRCLRS        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRCLRS'      @STK(Q)
      *
      *................................................................
      *
      **  Clear all screen data fields.
     C                   SELECT
     C     P#RACT        WHENEQ    ' '
     C     P#RACT        OREQ      'I'
     C                   MOVE      *BLANKS       S#DCOR
     C                   MOVE      *BLANKS       S#CTYP                                        08666
     C                   MOVE      'N'           S#PRIM
     C                   MOVE      *BLANKS       S#PTYP
     C                   MOVE      *BLANKS       S#PSTP
     C                   MOVE      *BLANKS       S#FRDT
     C                   MOVE      *BLANKS       S#TODT
     C                   MOVE      *BLANKS       S#LGID
     C                   MOVEL     'SCHD'        S#STS1
     C                   MOVE      *BLANKS       S#STS2
     C                   MOVE      *BLANKS       S#STS3
     C                   MOVE      *BLANKS       S#STS4
     C                   MOVE      *BLANKS       S#STS5
     C                   MOVE      'L'           S#ACCP
     C                   MOVE      *BLANKS       S#ATRM
     C                   MOVE      *BLANKS       S#PPFN
     C                   MOVE      'Y'           S#PPFN
     C                   MOVEL     'C'           S#ARCH
     C                   MOVEL     *BLANKS       S#PLST                                        08800
     C                   MOVEL     *BLANKS       S#EXDT
     C                   MOVEL     *BLANKS       S#MODI
      *
      **  If other set fields from that passed
     C                   OTHER
     C     ##COT         IFEQ      'T'
     C                   MOVE      ##DCOR        S#CTYP
     C                   ELSE
     C                   MOVE      ##DCOR        S#DCOR
     C                   ENDIF
     C                   MOVE      ##PRIM        S#PRIM
     C                   MOVE      ##PTYP        S#PTYP
     C                   MOVE      ##PSTP        S#PSTP
     C                   MOVE      ##LGID        S#LGID
     C                   MOVE      ##STS1        S#STS1
     C                   MOVE      ##STS2        S#STS2
     C                   MOVE      ##STS3        S#STS3
     C                   MOVE      ##STS4        S#STS4
     C                   MOVE      ##STS5        S#STS5
     C                   MOVE      ##ATRM        S#ATRM
     C                   MOVE      ##PPFN        S#PPFN
     C                   MOVE      ##ARCH        S#ARCH
     C                   MOVEL     ##PLST        S#PLST                                        08800
     C**********           MOVEL##EXDT    S#EXDT                                        241824245055
     C                   MOVEL     ##MODI        S#MODI
      *                                                                   083786
      **  Set up L or C for order to print                                083786
     C***********##ACCP    IFEQ 'CGPGENL3'                         083786 CCG009
     C     ##ACCP        IFEQ      'L3'                                                        CCG00
     C                   MOVEL     'L'           S#ACCP                                        08378
     C                   ELSE                                                                  08378
     C***********          MOVEL'C'       ##ACCP                    083786088837
     C                   MOVEL     'C'           S#ACCP                                        08883
     C                   ENDIF                                                                 08378
      *
      **  If To Date not 0 format
     C                   MOVEL     *BLANKS       S#TODT
     C                   SELECT                                                                08924
     C     ##TODT        WHENEQ    -2                                                          08924
     C                   MOVEL     '*PREVD'      S#TODT                                        08924
     C     ##TODT        WHENNE    *ZEROS                                                      08924
     C***********##TODT    IFNEC*ZEROS                                    089246
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      BJDFIN        W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        S#TODT                         Creation date
     C***********          ENDIF                                          089246
     C                   ENDSL                                                                 08924
      *
      **  If From Date not 0 format
     C                   MOVEL     *BLANKS       S#FRDT
     C                   SELECT
     C     ##FRDT        WHENEQ    -1
     C                   MOVEL     '*TODAY'      S#FRDT
     C     ##FRDT        WHENNE    *ZEROS
      *
      *  Convert Midas Day no. to system date
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      BJDFIN        W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *
     C                   MOVEL     W2DATE        S#TODT                         Creation date
     C                   ENDSL
      *                                                                                       245055
      **  If Extract date not 0 format                                                        245055
     C                   MOVEL     *BLANKS       S#EXDT
     C                   SELECT
     C     ##EXDT        WHENEQ    -1
     C                   MOVEL     '*TODAY'      S#EXDT
     C     ##EXDT        WHENNE    *ZEROS
      *                                                                                       245055
      *  Convert Midas Day no. to system date                                                 245055
      *                                                                                       245055
     C                   CALL      'ZDATE2'                             90
     C                   PARM                    W2DAYN            5 0          Day No.
     C                   PARM      BJDFIN        W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       W2FDAT            7            DDMMMYY
      *                                                                                       245055
     C                   MOVEL     W2DATE        S#EXDT                         Creation date
     C                   ENDSL
     C                   ENDSL
     C/COPY WNCPYSRC,CG5110C007
      *
      **  Set indicators
     C                   EXSR      SRSINT
      *
      *................................................................
      *
     C     EXCLRS        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRSINT                                         *
      * Function    :  Initialise Screen Indicators                   *
      *                                                               *
      * Called by   :  SRMAIN - Main Processing                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRSINT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRSINT'      @STK(Q)
      *
      *................................................................
      *
      **  Initialise Indicators.
     C***********          MOVEL*ALL'0'   ##OFF1 16                       086662
     C***********          MOVEL*ALL'0'   ##OFF1 17                 086662088008
     C                   MOVEL     *ALL'0'       ##OFF1           18                           08800
     C                   MOVEA     ##OFF1        *IN(30)
     C                   MOVE      'N'           ##ERR
      *
      **  If delete allow F10  .
     C                   MOVEL     '0'           *IN79
     C     P#RACT        IFEQ      'D'
     C                   MOVEL     '1'           *IN79
     C                   ENDIF
      *
      **  If delete or enquire inhibit input
     C                   MOVEL     '0'           *IN78
     C     P#RACT        IFEQ      'D'
     C     P#RACT        OREQ      'E'
     C                   MOVEL     '1'           *IN78
     C                   ENDIF
      *
     C                   SETOFF                                       88
     C                   SETOFF                                       87
      *................................................................
      *
     C     EXSINT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      *
      **  Key list ...
      *
      **  Initialise work fields .....
     C                   MOVEL     'CG5110'      PGMQ             10
     C                   MOVEL     *BLANKS       MSGKEY            4
      *
     C     P#RACT        IFEQ      ' '
     C***********P#RACT    OREQ 'A'                                       083786
     C     P#RACT        OREQ      'I'                                                         08378
     C                   CLEAR                   P#PARM
     C                   ENDIF
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##BIS            80
      *
      **  Access SDBANKPD
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBMSG  '    ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Error handling for access object
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'AOBANKR0'    W0FILE                         ***************
     C                   MOVEL     '*FIRST  '    W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Access data area DSRUN to find date
     C     *DTAARA       DEFINE    RUNDAT        DSRUN
     C     *LOCK         IN        DSRUN
     C                   OUT       DSRUN
      *
      **  If data area not found then perform database error processing
     C     ##RDAT        IFEQ      *BLANKS
     C                   MOVEL     'RUNDAT  '    W0FILE                         ***************
     C                   MOVEL     'ONLY    '    W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5002'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Default screen fields.
     C     P#RACT        IFEQ      ' '                                                         08378
     C     P#RACT        OREQ      'I'                                                         08378
     C                   MOVE      'N'           S#PRIM
     C                   MOVE      'L'           S#ACCP
     C                   MOVEL     'SCHD'        S#STS1
     C                   MOVEL     'C'           S#ARCH
     C                   MOVEL     'Y'           S#PPFN
     C                   ENDIF                                                                 08378
      *
      **  Screen header fields.
     C                   MOVEL     ##USR         S#USER
     C                   MOVEL     ##USR         ##USER
     C                   MOVEL     ##PGM         S#PGM
     C                   MOVEL     ##RDAT        S#MRDT
     C                   MOVEL     ##JOB         S#JOB
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1671'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        S#TITL
      *
      * Function keys
      *
     C     P#RACT        IFNE      'D'
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   ELSE
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1025'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   ENDIF
      *
     C                   MOVEL     #MSTX1        S#CMDT
      *
      **  Open Item Status
     C                   OPEN      CGISTSL1
     C/COPY WNCPYSRC,CG5110C005
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Subroutine  :  SRTERM                                         *
      * Function    :  Termination processing                         *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRTERM        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRTERM'      @STK(Q)
      *
      *................................................................
      *
      **  If F3 was pressed send termination code of 'E' back to RCF
     C     *INKC         IFEQ      *ON
     C                   MOVE      'E'           P#RCMD
     C                   ENDIF
      *
      **  If F10 was pressed send termination code of 'D' back to RCF
     C     *INKJ         IFEQ      *ON
     C                   MOVE      'D'           P#RCMD
     C                   ENDIF
      *
      **  If F12 was pressed send termination code of 'F' back to RCF
     C     *INKL         IFEQ      *ON
     C                   MOVE      'F'           P#RCMD
     C                   ENDIF
      *
      **  If there are no errors, set up the RCF data parameter with
      **  the input data.
     C     ##ERR         IFEQ      'N'
      *
      **  Correspondent type cannot be added as a seperate field to       086662
      **  P#PARM as this would take P#PARM greater than 100 and would     086662
      **  necessitate changes throughout RCF.Subsequently ##COT has       086662
      **  been added which will contain 'C' if a correspondent is         086662
      **  selected and 'T' if a correspondent type is selected.           086662
      **                                                                  086662
     C     S#DCOR        IFNE      *BLANK                                                      08666
     C                   MOVE      S#DCOR        ##DCOR
     C                   MOVEL     'C'           ##COT                                         08666
     C                   ENDIF                                                                 08666
      *                                                                   086662
     C     S#CTYP        IFNE      *BLANK                                                      08666
     C                   MOVE      S#CTYP        ##DCOR                                        08666
     C                   MOVEL     'T'           ##COT                                         08666
     C                   ENDIF                                                                 08666
      *                                                                   086662
     C                   MOVE      S#PRIM        ##PRIM
     C                   MOVE      S#PTYP        ##PTYP
     C                   MOVE      S#PSTP        ##PSTP
     C                   MOVE      S#LGID        ##LGID
     C                   MOVE      S#STS1        ##STS1
     C                   MOVE      S#STS2        ##STS2
     C                   MOVE      S#STS3        ##STS3
     C                   MOVE      S#STS4        ##STS4
     C                   MOVE      S#STS5        ##STS5
     C                   MOVE      S#ATRM        ##ATRM
     C                   MOVE      S#PPFN        ##PPFN
     C                   MOVE      S#ARCH        ##ARCH
     C                   MOVEL     S#PLST        ##PLST                                        08800
     C**********           MOVELS#EXDT    ##EXDT                                        241824245055
     C                   MOVEL     S#MODI        ##MODI
     C     S#ACCP        IFEQ      'L'
     C***********          MOVEL'CGPGENL3'##ACCP                          CCG009
     C                   MOVEL     'L3'          ##ACCP                                        CCG00
     C                   ELSE
     C***********          MOVEL'CGPGENL2'##ACCP                          CCG009
     C                   MOVEL     'L2'          ##ACCP                                        CCG00
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,CG5110C006
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *................................................................
      *
     C     EXTERM        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *
     C                   ENDSR
      ************************************************************
      /EJECT
      *COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
      /EJECT
      *COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
      /EJECT
      ** ##MON removed                                                                        245055
**CTDATA ##CPY
(c) Finastra International Limited 2001
**CTDATA ##MOD
GLFTDLRELEPBSEFF                                                                              241824
