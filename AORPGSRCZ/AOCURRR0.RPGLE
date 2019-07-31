     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *   CAP002
/*EXI *  TEXT('Midas AO Currency codes access object')                *
      *****************************************************************
      *                                                               *
      *  Midas  ACCESS OBJECTS                                        *
      *                                                               *
      *     AOCURRR0 - CURRENCY CODES                                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *      2000                                                     *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15Nov00               *
      *                 CAP059             Date 15Nov00               *
      *                 CAP058             Date 15Nov00               *
      *                 CAP057             Date 15Nov00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW020             Date 04Jan00               *
      *                 CPB001             Date 14Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                    CSW097             Date 20May99            *
      *                    152522             Date 14Jan99            *
      *                    CAP002             Date 01May98            *
      *                    CEU002             DATE 27OCT97            *
      *                    CRT003             DATE 12MAR97            *
      *                    CSW005             DATE 01AUG96            *
      *                    CRT001             DATE 28FEB95            *
      *                    S01502             DATE 25JUL94            *
      *                    S01433             DATE 27OCT93            *
      *                    S01392             DATE 20JUL92            *
      *                    LN0662             DATE 29JAN91            *
      *                    S01229             DATE 18/12/89           *
      *                    S01230             DATE 23/11/89           *S01230
      *                    S01230             DATE 06/11/89           *S01230
      *                    E01168             DATE 22/02/89           *S01230
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompiled)                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *           (Recompiled over changed SDCURRPD)                  *
      *  CIR007 - Overnight Index Swaps                               *
      *           (Recompiled over changed SDCURRPD)                  *
      *  CSD006 - Market Data Feed                                    *
      *           (Recompiled over changed SDCURRPD)                  *
      *  CAP059 - Conversion of Forward Rates into APIs (recomp)      *
      *  CAP058 - Conversion of MM Interest Rates into APIS (recomp)  *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs (recomp) *
      *  CDL008 - Continuous Linked Settlement                        *
      *           (Recompiled over changed SDCURRPD)                  *
      *  CSW020 - SWIFT Decimal Places                                *
      *           Recompiled over changed SDCURRPD                    *
      *  CPB001 - 'Private Banking' Module                            *
      *              - Recompiled over changed SDCURRPD.              *
      *  CSW097 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *           Recompiled over changed SDCURRPD                    *
      *  152522 - EMU - Enhancement to reverse reciprocal rates.      *
      *           Recompiled over changed SDCURRPD.                   *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     CEU002 - Recompiled over changed SDCURRPD                    *
     F*     CRT003 - RECOMPILED OVER CHANGED SDCURRPD.                *  *
     F*     CSW005 - Recompiled over changed SDCURRPD                    *
     F*     CRT001 - Retail Teller System                                *
     F*              - Recompiled over changed SDCURRPD.                 *
     F*     S01502 - BLI Telekurs Processing                             *
     F*              - Recompiled over changed SDCURRPD.                 *
     F*     S01433 - ENHANCED ROLLOVER PROCESSING DEVELOPMENT:           *
     F*              - RECOMPILED OVER CHANGED SDCLLMPD.                 *
     F*     S01392 - JAP.SUB-MODULE INCORPORATION (CORE)                 *
     F*              PROGRAM RECOMPILED AS NEW FIELD (A6RDFC) ADDED      *
     F*     LN0662 - CHANGES TO SDCURRPD - L0 AND L1 RENAMED             *
     F*     S01230 - STANDARDISE ACCESS PROGRAM & COPYRIGHT ADDED        *S01230
     F*     S01229 - CALL TO RENAMED PROGRAM                             *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
     F*        D F C H L   FUNCTION INDICATOR                            *
     F*                                                                  *
     F*        01     INITIALISATION                                     *
     F*        90     FILE ERROR                                         *
     F*        91     FILE OPEN ERROR                                    *
     F*        92     FILE CLOSE ERROR                                   *
     F*        93     FILE EMPTY                                         *
     F*        94     END OF FILE                                        *
     F*        95     NO RECORD FOUND                                    *
     F*        96     OPTION ERROR                                       *
     F*        97     NO SELECTION                                       *
     F*        98     ERROR ON CALL OF SELECTION PROGRAM(SD0020S)        *
     F*                                                                  *
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     F*SDCURRL0IF  E           K        DISK                           UC LN0662
     FSDCURRL1  IF   E           K DISK    USROPN                               LN0662
      * IN  - @A6REA3 Currencies       (CYCD)
      ************************************************************
      /EJECT
     D*ESTART
      ****************************************************************
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D********************************************************************S01230
      ****************************************************************
      /EJECT
     D*ISTART
      ************************************************************
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
      * Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
     D*                                                                   S01230
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D***********D@FMT     E DSSDCURRD0                                   S01230
     D D@FMT         E DS                  EXTNAME(SDCURRPD)                    S01230
      * @A6REA3 - Currency record format data structure
      *
     D*P@FMT       DS                            206                      E01168
     D*                                     206 206 P@DMMY                E01168
     D P@FMT         E DS                  EXTNAME(DSSDY)                       S01230
     D* External Data structure to hold the outgoing record format        S01230
     D* of the file.                                                      S01230
      *                                                                   S01230
     D*********P@FMT       DS                            202              S01230
     D*********                             202 202 P@DMMY                S01230
      *
     D P@K101          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@K101                         I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME   '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C*********************OPEN SDCURRL0               91    Open file    LN0662
     C                   OPEN      SDCURRL1                             91        Open file    LN066
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C*********************CLOSESDCURRL0               92    Close file   LN0662
     C                   CLOSE     SDCURRL1                             92        Close file   LN066
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     *LOVAL        SETLL     @A6REA3                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C                   READ      @A6REA3                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     *HIVAL        SETGT     @A6REA3                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C                   READP     @A6REA3                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR         ESS
     C     W@SL01        IFEQ      '?'                                          IF 8 SELECT
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C*********************CALL 'SDCUSRR'              98    <SELECT>     S01229
     C                   CALL      'SD0020S'                            98        <SELECT>     S0122
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@K101                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C     P@K101        CHAIN     @A6REA3                            9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*SAME  '                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parm error
     C                   END                                                    FI 8
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
     C   95              MOVE      '*NRF   '     P@RTCD                         No rec found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No rec found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALLB     'ZASNMG'                                       <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Pgm name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
     C     W@RTCD        IFEQ      '*DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *
      *
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE'
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDCURRPD  AOCURRR0  Currency Codes
**CTDATA CPY@
(c) Finastra International Limited 2001
