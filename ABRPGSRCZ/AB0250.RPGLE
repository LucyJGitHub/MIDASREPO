     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')           CAP084
      *****************************************************************
/*S******RPGBASE*******************************************************         CAP084
/*STD *  RPGBASEMOD                                                   *         CAP084
/*EXI *  TEXT('Midas AB Arbitrage - Update FX forward book')
     F*****************************************************************
     F*                                                               *
     F*  Midas  -  Internal Contracts & Arbitrage Dealing
     F*                                                               *
     F*     AB0250    - Update FX Forward Book enquiry file           *
     F*                                                               *
     F*     Function: This program updates the Foreign Exchange       *
     F*     (I/C)     forward book file (FXFWDDPP)                    *
     F*                                                               *
     F*     Called by: AB0330  - AB Back office Internal Contracts    *
     F*                          maintenance                          *
     F*                                                               *
     F*     Calls    : none                                           *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 13Jan06               *
      *  Prev Amend No. CDL038             Date 10May05               *
      *                 CAP084             Date 06Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CAC001             Date 01Feb96               *
     F*                 S01117             Date 06Feb90               *
     F*                 S01194             Date 06Feb90               *
     F*                  E17063             DATE 04/05/89             *
     F*                  AB0090             DATE 15/02/88             *
     F*                  AB0088             DATE 15/02/88             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP084 - Convert to ILE.                                     *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Recompiled only.                                    *
     F* S01194 - NEW STANDING DATA                                    *
     F* S01117 - MULTI-BRANCHING.                                     *
     F*                                                               *
     F*  E17063 - Recompiled using IGNDECERR(*YES).                   *
     F*                                                               *
     F*  AB0088 - MUST OPEN FILES UNDER COMMITMENT CONTROL            *
     F*                                                               *
     F*  AB0090 - IF UPDATE FILES IN BUY THEN SELL ORDER A 2 WRKSTN   *
     F*           ENTRY OF DEALS WITH CCY1 = CCY2 AND VICE VERSA      *
     F*           WILL CAUSE A FATAL EMBRACE. FIX IS TO UPDATE        *
     F*           FILE IN ALPHABETIC CCY ORDER.                       *
     F*****************************************************************
     F*                                                               *
     F*  CREATION PARAMETERS                                          *
     F*                                                               *
*****F** SNPDUMP(*NONE) CODELIST(*NONE) IGNDECERR(*NO)              : *   E17063
     F*                                                               *
     F*****************************************************************
     F*
     F*
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*       63  FILE ACCESS INDICATOR - GENERAL
     F*       64  FILE ACCESS INDICATOR - FXFWDULL
     F*       65  FILE ACCESS INDICATOR - FXFWMULL
     F*       80  ZA0870 FILE ACCESS FOR FDINSTLL
     F*       80  ZA0710 LOKUP RESULTING INDICATOR
     F*       81  ZA0710 LOKUP RESULTING INDICATOR
     F*       U6  PROGRAM ERROR
     F*     U7+U8 DATA BASE ERROR
     F*
     F*
     F*
     FFXFWDULL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT                               AB0088
     FFXFWMULL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT                               AB0088
     F*FDICDRLLIF*E           K        DISK         KINFSR INFSR      UC  S01194
     D*
     D**  ARRAY TO HOLD COPYRIGHT STATEMENT
     D*
     D**  ARRAY FOR SR. ZA0680 - CUMULATIVE DAYS IN YEAR FOR 4 YEAR PERIOD
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D*
     D**  ARRAY FOR SR. ZA0680 - CUMULATIVE DAYS IN YEAR PER MONTH
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
     D*
     D*
     D @AF             S              1    DIM(15)
     D*
     D** USED TO PREPARE FIELDS FOR TESTN
     D/EJECT
     D @CPYRT          DS
     D*
     D**  DATA STRUCTURE FOR COMPILATION - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D*
     D PSDS           SDS
     D*
     D**  Program status data structure.
     D**  Field containing FILE NAME
     D  @FILE                201    208
     D**  Field containing workstaion  ID.
     D  @JOB                 244    253
     D**  Field containing user ID.
     D  @USER                254    263
     D*
     D                UDS
     D**  Local data area for data base errors.
     D**  Field containing name of database file in error.
     D  DBFILE               134    141
     D**  Field containing key value causing database error.
     D  DBKEY                142    170
     D**  Field containing name of program causing database error.
     D  DBPGM                171    180
     D**  Field containing number of database error.
     D  DBASE                181    183
     D DATE1           DS
     D  @DATE1                 1      8
     D  @D1YY                  1      4
     D  @D1MM                  5      6
     D  @D1DD                  7      8
     D*RUNS1******DS***************************                           S01194
     D****************************************1   7 RUNA                  S01194
     D****************************************1   2 @RUND                 S01194
     D****************************************3   5 @RUNM                 S01194
     D****************************************6   7 @RUNY                 S01194
     D*
     D** STANDARD DEAL EXTERNALLY DEFINED DATA STRUCTURE
     D @STDDL        E DS                  EXTNAME(ABSTDDPP)
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
      ** BANK DETAILS ACCESSED VIA ACCESS PROGRAM                         S01194
     D  RUND                  34     36P 0                                      S01194
     D  @RUND                 43     44                                         S01194
     D  @RUNM                 45     47                                         S01194
     D  @RUNY                 48     49                                         S01194
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
      *                                                                   S01194
     D**  DATA STRUCTURE FOR SR. ZA0680 - DATE INPUT TO SUBROUTINE
     D                 DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
     D*
     D****DATA*STRUCTURE*FOR*TABTG20*ACCESS                               S01194
     D*@@KDCY*****DS**************************                            S01194
     D****************************************1   2 @@K20                 S01194
     D****************************************9  11 @@CCY                 S01194
     D***************************************12  12 @@K1                  S01194
     D*
     D**  DATA STRUCTURE FOR SR. ZA0710 - FIELD IS @@Z71Y
     D                 DS
     D  @@Z71Y                 1      4  0
     D  @@SSY1                 1      1  0
     D  @@SSY2                 2      2  0
     D  @@SSY3                 3      3  0
     D  @@SSY4                 4      4  0
     D*
     D**  DATA STRUCTURE FOR SR. ZA0710 - FIELD IS @@VDT
     D                 DS
     D  @@VDT                  1      8  0
     D  @@YR                   1      4  0
     D  @@Z71M                 5      6  0
     D  @@Z71D                 7      8  0
     D*
     D** USED IN ALIGN FIGURE ROUTINE
     D @ALIGD          DS
     D  @AD                    1      3
     D                                     DIM(3)
     D  @ALDEC                 1      3  0
     D @ALIGI          DS
     D  @AI                    1     15
     D                                     DIM(15)
     D  @ALINT                 1     15  0
     D @INAMT          DS
     D  @IN                    1     10
     D  @IA                    1     10
     D                                     DIM(10)
     D @OUTAM          DS
     D  @OUT                   1     10
     D  @O                     1     10
     D                                     DIM(10)
     D*
     D @PRLOS          DS                  OCCURS(2)
     D* USED IN REVALUATION PROFIT/LOSS CALCULATION  FOR ADJUSTMENT
     D* TO EXPOSURE,POSITIONS AND P/L FILE WHEN FORWARD BOOK DAILY
     D* RECORDS ARE UPDATED
     D  @PCCY                  1      3
     D  @SPLO                  4     18  0
     D  @FPLO                 19     33  0
     D  @ADJAD                34     34
     //EJECT
     C*****************************************************************
     C*                                                               *
     C*  MAIN PROCESSING                                              *
     C*                                                               *
     C*  FIELDS USED:      @TERM  -  PROGRAM TERMINATION PARAMETER    *
     C*                                                               *
     C*  CALLED BY:        AB0190 AB8020                              *
     C*                                                               *
     C*  CALLS:            #A #B #C                                   *
     C*                                                               *
     C*****************************************************************
     C*
     C** EXECUTE PROGRAM INITIALISATION
     C                   EXSR      #A
     C*
     C** EXECUTE PROGRAM BODY
     C     @TERM         IFNE      'T'
     C     *INU7         ANDNE     '1'
     C                   EXSR      #B
     C                   END
     C*
     C** EXECUTE PROGRAM TERMINATION
     C                   EXSR      #C
     C*
     C                   RETURN
     C*
     C*
     //EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #A    PROGRAM INITIALISATION                     *
     C*                                                               *
     C*  FIELDS USED:      @TERM  -  PROGRAM TERMINATION PARAMETER    *
     C*                    @STDDL -  STANDARD DEAL PARAMETER          *
     C*                    @FIRST -  FIRST CALL OF PROGRAM FLAG       *
     C*                                                               *
     C*  CALLED BY:        MAIN PROCESSING                            *
     C*                                                               *
     C*  CALLS:            (NONE)                                     *
     C*                                                               *
     C*****************************************************************
     C     #A            BEGSR
     C*
     C*
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1
     C                   PARM                    @STDDL
     C*
     C**  CHECK IF THIS IS THE FIRST RUN OF THE PGM
     C     @TERM         IFNE      'T'
     C     @FIRST        ANDEQ     *BLANK                                       B1
     C                   MOVE      'N'           @FIRST            1            *1
     C                   MOVEL     'AB0250 '     DBPGM
     C                   OPEN      FXFWDULL                                     *1
     C                   OPEN      FXFWMULL
     C*********************OPEN FDICDRLL                   *1             S01194
     C*********************                                               S01194
     C***ACCESS*FDICDRLL*TO GET RUN DATES                                 S01194
     C*********************MOVE *BLANKS   KEY                             S01194
     C*********************MOVEL'01'      KEY              *1             S01194
     C*********************MOVE '10'      KEY              *1             S01194
     C***********KEY*******CHAINFDICDRLL             63    *1             S01194
     C********** *IN63*****IFEQ '1'                        B*2            S01194
     C****Set*up*error*output for screen.
     C                   CALL      'AOBANKR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*FIRST '     @OPTN             7                           S0119
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   MOVEL     @OPTN         DBOPTN            7                           S0119
     C*********************MOVELKEY       DBKEY            ***************S01194
     C*********************MOVEL'FDICDRLL'DBFILE           * DB ERROR 001*S01194
     C                   MOVEL     'SDBANKPD'    DBFILE                                        S0119
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'AB0250 '     DBPGM                          **2
     C                   MOVE      '1'           *INU7                          **2
     C                   MOVE      '1'           *INU8                          **2
     C                   END                                                    E*2
     C                   END
     C*
     C     #A9           ENDSR
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #B    PROGRAM BODY                              *
     C*                                                              *
     C*  FIELDS USED  :                                              *
     C*                                                              *
     C*  CALLED BY :       MAIN PROCESSING                           *
     C*                                                              *
     C*  CALLS :           #BA  #BB                                  *
     C*                                                              *
     C****************************************************************
     C     #B            BEGSR
     C*
     C** PROCESS DELETE
     C     JULACT        IFEQ      'D'                                          B1
     C                   MOVE      'R'           @RREV             1            *1             AB009
     C                   EXSR      #BA                                          *1
     C                   END                                                    E1
     C     *INU7         IFEQ      '1'                                          B1
     C                   GOTO      #B9                                          *1
     C                   END                                                    E1
     C*
     C** PROCESS INSERT
     C     JULACT        IFEQ      'I'                                          B1
     C                   MOVE      ' '           @RREV                          *1             AB009
     C                   EXSR      #BA                                          *1             AB009
     C******************   EXSR #BB                        *1             AB0090
     C                   END                                                    E1
     C*
     C*
     C     #B9           ENDSR
     C*
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #BA   DELETE FX FORWARD DEAL                    *
     C*                                                              *
     C*  FIELDS USED  :    @ACTD  -  DEAL ACTION DATE(CHAR)          *
     C*                    @D1YY  -  DATE FIELD - YEAR               *
     C*                    @D1MM  -  DATE FIELD - MONTH              *
     C*                    @D1DD  -  DATE FIELD - DAY                *
     C*                    @DATE1 -  DATA STRUCTURE DATE             *
     C*                    @@DTIN -  INPUT DATE FOR ZA0680           *
     C*                    @@MDNO -  OUTPUT DATE FROM ZA0680         *
     C*                    @MDACT -  DEAL ACTION DATE(NUM)           *
     C*                    @RREV  -  REVERSE INDICATOR               *
     C*                    @RCCY  -  CURRENCY FOR SUBROUTINE         *
     C*                    @RAMT  -  AMOUNT FOR SUBROUTINE           *
     C*                    @RBCD  -  BCDE FOR SUBROUTINE             *
     C*                    @RACT  -  ACTION DATE FOR SUBROUTINE      *
     C**********           @BUYC  -  DEAL BUY CURRENCY               *    AB0090
     C**********           @SELC  -  DEAL SELL CURRENCY              *    AB0090
     C**********           @BUYA  -  DEAL BUY AMOUNT                 *    AB0090
     C**********           @SELA  -  DEAL SELL AMOUNT                *    AB0090
     C*                    @HICCY -  HIGH CCY (ALPHABETICALLY)       *    AB0090
     C*                    @LOCCY -  LOW CCY (ALPHABETICALLY)        *    AB0090
     C*                    @HIAMT -  NEAR DATE HIGH CCY AMOUNT       *    AB0090
     C*                              (ALPHABETICALLY)                *    AB0090
     C*                    @LOAMT -  NEAR DATE LOW CCY AMOUNT        *    AB0090
     C*                              (ALPHABETICALLY)                *    AB0090
     C*                    @HIATF -  FAR DATE HIGH CCY AMOUNT        *    AB0090
     C*                              (ALPHABETICALLY)                *    AB0090
     C*                    @LOATF -  FAR DATE LOW CURRENCY AMOUNT    *    AB0090
     C*                              (ALPHABETICALLY)                *    AB0090
     C*                                                              *
     C*  CALLED BY :       #B                                        *
     C*                                                              *
     C*  CALLS :           #ZA ZA0680                                *
     C*                                                              *
     C****************************************************************
     C*
     C     #BA           BEGSR
     C***************************************************************     AB0090
      *                                                                   AB0090
      *     CODE FOR THIS SUBROUTINE REPLACED BY FIX AB0090               AB0090
      *         SEE BELOW                                                 AB0090
     C******
     C** DETERMINE BUY AND SELL CURRENCY FOR NEAR DATE
     C****       JUNDA1    IFGE 0                                         AB0090
     C****                 MOVE JUDFCY    @BUYC   3                       AB0090
     C****                 MOVE JUDSCY    @SELC   3                       AB0090
     C****                 MOVE JUNDA1    @BUYA  150                      AB0090
     C****                 MOVE JUNDA2    @SELA  150                      AB0090
     C****                 ELSE                                           AB0090
     C****                 MOVE JUDFCY    @SELC                           AB0090
     C****                 MOVE JUDSCY    @BUYC                           AB0090
     C****                 MOVE JUNDA1    @SELA                           AB0090
     C****                 MOVE JUNDA2    @BUYA                           AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****OVE NEAR DATE TO ACTION DATE AND CONVERT TO MIDAS DAY NO        AB0090
     C****                 MOVE JUNDYY    @D1YY                           AB0090
     C****                 MOVE JUNDMM    @D1MM                           AB0090
     C****                 MOVE JUNDDD    @D1DD                           AB0090
     C****                 MOVE @DATE1    @ACTD   8                       AB0090
     C****                 MOVE @DATE1    @@DTIN                          AB0090
     C****                                                                AB0090
     C****       @@DTIN    IFNE *ZEROS                                    AB0090
     C****                 EXSR ZA0680                                    AB0090
     C****                 MOVE @@MDNO    @MDACT  50                      AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BA9                                      AB0090
     C****                 END                                            AB0090
     C****                 ELSE                                           AB0090
     C****                 MOVE *ZEROS    @MDACT                          AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C** NEAR DATE >= MIDAS RUN DATE                                      AB0090
     C****       @MDACT    IFGE RUND                                      AB0090
     C****                                                                AB0090
     C****ERFORM REVERSE OUT FOR BUY CCY                                  AB0090
     C****                 MOVE 'R'       @RREV   1                       AB0090
     C****                 MOVE @BUYC     @RCCY   3                       AB0090
     C****                 MOVE @BUYA     @RAMT  150                      AB0090
     C****                 MOVE JUNBCD    @RBCD  150                      AB0090
     C****                 MOVE @MDACT    @RACT   80                      AB0090
     C****                 EXSR #ZA                                       AB0090
     C****                                                                AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BA9                                      AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****ERFORM REVERSE OUT FOR SELL CCY                                 AB0090
     C****                 MOVE 'R'       @RREV                           AB0090
     C****                 MOVE @SELC     @RCCY                           AB0090
     C****                 MOVE @SELA     @RAMT                           AB0090
     C****                 MOVE JUNBCD    @RBCD                           AB0090
     C****                 MOVE @MDACT    @RACT                           AB0090
     C****                 EXSR #ZA                                       AB0090
     C****                                                                AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BA9                                      AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****                                                                AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****ETERMINE BUY AND SELL CURRENCY FOR FAR DATE                     AB0090
     C****       JUFDA1    IFGE 0                                         AB0090
     C****                 MOVE JUDFCY    @BUYC                           AB0090
     C****                 MOVE JUDSCY    @SELC                           AB0090
     C****                 MOVE JUFDA1    @BUYA                           AB0090
     C****                 MOVE JUFDA2    @SELA                           AB0090
     C****                 ELSE                                           AB0090
     C****                 MOVE JUDFCY    @SELC                           AB0090
     C****                 MOVE JUDSCY    @BUYC                           AB0090
     C****                 MOVE JUFDA1    @SELA                           AB0090
     C****                 MOVE JUFDA2    @BUYA                           AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****OVE FAR DATE TO ACTION DATE AND CONVERT TO MIDAS DAY NO         AB0090
     C****                 MOVE JUFDYY    @D1YY                           AB0090
     C****                 MOVE JUFDMM    @D1MM                           AB0090
     C****                 MOVE JUFDDD    @D1DD                           AB0090
     C****                 MOVE @DATE1    @ACTD                           AB0090
     C****                 MOVE @DATE1    @@DTIN                          AB0090
     C****                                                                AB0090
     C****       @@DTIN    IFNE *ZEROS                                    AB0090
     C****                 EXSR ZA0680                                    AB0090
     C****                 MOVE @@MDNO    @MDACT                          AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BA9                                      AB0090
     C****                 END                                            AB0090
     C****                 ELSE                                           AB0090
     C****                 MOVE *ZEROS    @MDACT                          AB0090
     C****                 END                                            AB0090
     C*                                                                   AB0090
     C** FAR DATE >= MIDAS RUN DATE                                       AB0090
     C****       @MDACT    IFGE RUND                                      AB0090
     C****                                                                AB0090
     C****ERFORM REVERSE OUT FOR BUY CCY                                  AB0090
     C****                 MOVE 'R'       @RREV                           AB0090
     C****                 MOVE @BUYC     @RCCY                           AB0090
     C****                 MOVE @BUYA     @RAMT                           AB0090
     C****                 MOVE JUFBCD    @RBCD                           AB0090
     C****                 MOVE @MDACT    @RACT                           AB0090
     C****                 EXSR #ZA                                       AB0090
     C****                                                                AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BA9                                      AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****ERFORM REVERSE OUT FOR SELL CCY                                 AB0090
     C****                 MOVE 'R'       @RREV                           AB0090
     C****                 MOVE @SELC     @RCCY                           AB0090
     C****                 MOVE @SELA     @RAMT                           AB0090
     C****                 MOVE JUFBCD    @RBCD                           AB0090
     C****                 MOVE @MDACT    @RACT                           AB0090
     C****                 EXSR #ZA                                       AB0090
     C****                 END                                            AB0090
     C*                                                                   AB0090
      *                                                                   AB0090
     C*   NEW CODE FOR FIX AB0090 NOW FOLLOWS                             AB0090
      *********************************************************           AB0090
      *                                                                   AB0090
      **  MUST PROCESS CCY'S IN ALPHABETIC ORDER B'COS ENTRY OF TWO       AB0090
      **  DEALS SIMULTANEOUSLY WITH CCY1(1ST DEAL) = CCY2(2ND DEAL)       AB0090
      **  WILL CAUSE A DEADLY EMBRACE SITUATION                           AB0090
     C     JUDSCY        IFGT      JUDFCY                                       B1             AB009
     C                   MOVE      JUDSCY        @HICCY            3            *1             AB009
     C                   MOVE      JUDFCY        @LOCCY            3            *1             AB009
     C                   Z-ADD     JUNDA2        @HIAMT           15 0          *1             AB009
     C                   Z-ADD     JUNDA1        @LOAMT           15 0          *1             AB009
     C                   Z-ADD     JUFDA2        @HIATF           15 0          *1             AB009
     C                   Z-ADD     JUFDA1        @LOATF           15 0          *1             AB009
      *                                                                   AB0090
     C                   ELSE                                                   X1             AB009
     C                   MOVE      JUDFCY        @HICCY                         *1             AB009
     C                   MOVE      JUDSCY        @LOCCY                         *1             AB009
     C                   Z-ADD     JUNDA1        @HIAMT                         *1             AB009
     C                   Z-ADD     JUNDA2        @LOAMT                         *1             AB009
     C                   Z-ADD     JUFDA1        @HIATF                         *1             AB009
     C                   Z-ADD     JUFDA2        @LOATF                         *1             AB009
     C                   END                                                    E1             AB009
     C*                                                                   AB0090
     C** PERFORM ADD IN/REVERSE OUT FOR HIGH CCY NEAR DATE                AB0090
      ** IF >= RUN DATE
     C     JUNDAT        IFGE      RUND                                         B1             AB009
      *                                                                   AB0090
     C                   MOVE      @HICCY        @RCCY             3            *1             AB009
     C                   Z-ADD     @HIAMT        @RAMT            15 0          *1             AB009
     C                   MOVE      JUNBCD        @RBCD            15 0          *1             AB009
     C                   MOVE      JUNDAT        @RACT             5 0          *1             AB009
     C                   EXSR      #ZA                                          *1             AB009
     C*                                                                   AB0090
     C     *INU7         IFEQ      '1'                                          B*2            AB009
     C                   GOTO      #BA9                                         **2            AB009
     C                   END                                                    E*2            AB009
     C                   END                                                    E1             AB009
     C*                                                                   AB0090
     C** PERFORM ADD IN/REVERSE OUT FOR HIGH CCY FAR DATE                 AB0090
      ** IF >= RUN DATE
     C     JUFDAT        IFGE      RUND                                         B1             AB009
     C*                                                                   AB0090
     C                   MOVE      @HICCY        @RCCY                          *1             AB009
     C                   Z-ADD     @HIATF        @RAMT                          *1             AB009
     C                   MOVE      JUFBCD        @RBCD                          *1             AB009
     C                   MOVE      JUFDAT        @RACT                          *1             AB009
     C                   EXSR      #ZA                                          *1             AB009
     C*                                                                   AB0090
     C     *INU7         IFEQ      '1'                                          B*2            AB009
     C                   GOTO      #BA9                                         **2            AB009
     C                   END                                                    E*2            AB009
     C                   END                                                    E1             AB009
      *                                                                   AB0090
      ** NOW PROCESS THE LOW CCY                                          AB0090
      *                                                                   AB0090
     C** PERFORM ADD IN/REVERSE OUT FOR LOW CCY NEAR DATE                 AB0090
      ** IF >= RUN DATE
     C     JUNDAT        IFGE      RUND                                         B1             AB009
      *                                                                   AB0090
     C                   MOVE      @LOCCY        @RCCY                          *1             AB009
     C                   Z-ADD     @LOAMT        @RAMT                          *1             AB009
     C                   MOVE      JUNBCD        @RBCD                          *1             AB009
     C                   MOVE      JUNDAT        @RACT                          *1             AB009
     C                   EXSR      #ZA                                          *1             AB009
     C*                                                                   AB0090
     C     *INU7         IFEQ      '1'                                          B*2            AB009
     C                   GOTO      #BA9                                         **2            AB009
     C                   END                                                    E*2            AB009
     C                   END                                                    E1             AB009
      *                                                                   AB0090
     C** PERFORM ADD IN/REVERSE OUT FOR LOW CCY FAR DATE                  AB0090
      ** IF >= RUN DATE
     C     JUFDAT        IFGE      RUND                                         B1             AB009
      *                                                                   AB0090
     C                   MOVE      @LOCCY        @RCCY                          *1             AB009
     C                   Z-ADD     @LOATF        @RAMT                          *1             AB009
     C                   MOVE      JUFBCD        @RBCD                          *1             AB009
     C                   MOVE      JUFDAT        @RACT                          *1             AB009
     C                   EXSR      #ZA                                          *1             AB009
     C                   END                                                    E1             AB009
     C*                                                                   AB0090
     C     #BA9          ENDSR
     //EJECT
     C****************************************************************
     C*****                                                          *    AB0090
     C*****BROUTINE: #BB   INSERT FX FORWARD DEAL                    *    AB0090
     C*****                                                          *    AB0090
     C*****ELDS USED  :    @ACTD  -  DEAL ACTION DATE(CHAR)          *    AB0090
     C*****                @D1YY  -  DATE FIELD - YEAR               *    AB0090
     C*****                @D1MM  -  DATE FIELD - MONTH              *    AB0090
     C*****                @D1DD  -  DATE FIELD - DAY                *    AB0090
     C*****                @DATE1 -  DATA STRUCTURE DATE             *    AB0090
     C*****                @@DTIN -  INPUT DATE FOR ZA0680           *    AB0090
     C*****                @@MDNO -  OUTPUT DATE FROM ZA0680         *    AB0090
     C*****                @MDACT -  DEAL ACTION DATE(NUM)           *    AB0090
     C*****                @RREV  -  REVERSE INDICATOR               *    AB0090
     C****                 @RCCY  -  CURRENCY FOR SUBROUTINE         *    AB0090
     C****                 @RAMT  -  AMOUNT FOR SUBROUTINE           *    AB0090
     C****                 @RBCD  -  BCDE FOR SUBROUTINE             *    AB0090
     C****                 @RACT  -  ACTION DATE FOR SUBROUTINE      *    AB0090
     C****                 @BUYC  -  DEAL BUY CURRENCY               *    AB0090
     C****                 @SELC  -  DEAL SELL CURRENCY              *    AB0090
     C****                 @BUYA  -  DEAL BUY AMOUNT                 *    AB0090
     C****                 @SELA  -  DEAL SELL AMOUNT                *    AB0090
     C****                                                           *    AB0090
     C****ALLED BY :       #B                                        *    AB0090
     C****                                                           *    AB0090
     C****ALLS :           #ZA ZA0680                                *    AB0090
     C*****                                                          *    AB0090
     C****************************************************************    AB0090
     C******                                                              AB0090
     C*****      #BB       BEGSR                                          AB0090
     C** DETERMINE BUY AND SELL CURRENCY FOR NEAR DATE                    AB0090
     C********** JUNDA1    IFGE 0                                         AB0090
     C**********           MOVE JUDFCY    @BUYC                           AB0090
     C****                 MOVE JUDSCY    @SELC                           AB0090
     C****                 MOVE JUNDA1    @BUYA                           AB0090
     C****                 MOVE JUNDA2    @SELA                           AB0090
     C****                 ELSE                                           AB0090
     C****                 MOVE JUDFCY    @SELC                           AB0090
     C****                 MOVE JUDSCY    @BUYC                           AB0090
     C****                 MOVE JUNDA1    @SELA                           AB0090
     C****                 MOVE JUNDA2    @BUYA                           AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****OVE NEAR DATE TO ACTION DATE AND CONVERT TO MIDAS DAY NO        AB0090
     C****                 MOVE JUNDYY    @D1YY                           AB0090
     C****                 MOVE JUNDMM    @D1MM                           AB0090
     C****                 MOVE JUNDDD    @D1DD                           AB0090
     C****                 MOVE @DATE1    @ACTD                           AB0090
     C****                 MOVE @DATE1    @@DTIN                          AB0090
     C****                                                                AB0090
     C****       @@DTIN    IFNE *ZEROS                                    AB0090
     C****                 EXSR ZA0680                                    AB0090
     C****                 MOVE @@MDNO    @MDACT                          AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BB9                                      AB0090
     C****                 END                                            AB0090
     C****                 ELSE                                           AB0090
     C****                 MOVE *ZEROS    @MDACT                          AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****EAR DATE >= MIDAS RUN DATE                                      AB0090
     C****       @MDACT    IFGE RUND                                      AB0090
     C****                                                                AB0090
     C****ERFORM ADD IN FOR BUY CCY                                       AB0090
     C****                 MOVE ' '       @RREV   1                       AB0090
     C****                 MOVE @BUYC     @RCCY   3                       AB0090
     C****                 MOVE @BUYA     @RAMT  150                      AB0090
     C****                 MOVE JUNBCD    @RBCD  150                      AB0090
     C****                 MOVE @MDACT    @RACT   80                      AB0090
     C****                 EXSR #ZA                                       AB0090
     C****                                                                AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BB9                                      AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****ERFORM ADD IN FOR SELL CCY                                      AB0090
     C****                 MOVE ' '       @RREV                           AB0090
     C****                 MOVE @SELC     @RCCY                           AB0090
     C****                 MOVE @SELA     @RAMT                           AB0090
     C****                 MOVE JUNBCD    @RBCD                           AB0090
     C****                 MOVE @MDACT    @RACT                           AB0090
     C****                 EXSR #ZA                                       AB0090
     C****                                                                AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BB9                                      AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****                                                                AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****ETERMINE BUY AND SELL CURRENCY FOR FAR DATE                     AB0090
     C****       JUFDA1    IFGE 0                                         AB0090
     C****                 MOVE JUDFCY    @BUYC                           AB0090
     C****                 MOVE JUDSCY    @SELC                           AB0090
     C****                 MOVE JUFDA1    @BUYA                           AB0090
     C****                 MOVE JUFDA2    @SELA                           AB0090
     C****                 ELSE                                           AB0090
     C****                 MOVE JUDFCY    @SELC                           AB0090
     C****                 MOVE JUDSCY    @BUYC                           AB0090
     C****                 MOVE JUFDA1    @SELA                           AB0090
     C****                 MOVE JUFDA2    @BUYA                           AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****OVE FAR DATE TO ACTION DATE AND CONVERT TO MIDAS DAY NO         AB0090
     C****                 MOVE JUFDYY    @D1YY                           AB0090
     C****                 MOVE JUFDMM    @D1MM                           AB0090
     C****                 MOVE JUFDDD    @D1DD                           AB0090
     C****                 MOVE @DATE1    @ACTD                           AB0090
     C****                 MOVE @DATE1    @@DTIN                          AB0090
     C****                                                                AB0090
     C****       @@DTIN    IFNE *ZEROS                                    AB0090
     C****                 EXSR ZA0680                                    AB0090
     C****                 MOVE @@MDNO    @MDACT                          AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BB9                                      AB0090
     C****                 END                                            AB0090
     C****                 ELSE                                           AB0090
     C****                 MOVE *ZEROS    @MDACT                          AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****AR DATE >= MIDAS RUN DATE                                       AB0090
     C****       @MDACT    IFGE RUND                                      AB0090
     C****                                                                AB0090
     C****ERFORM ADD IN FOR BUY CCY                                       AB0090
     C****                 MOVE ' '       @RREV                           AB0090
     C****                 MOVE @BUYC     @RCCY                           AB0090
     C****                 MOVE @BUYA     @RAMT                           AB0090
     C****                 MOVE JUFBCD    @RBCD                           AB0090
     C****                 MOVE @MDACT    @RACT                           AB0090
     C****                 EXSR #ZA                                       AB0090
     C****                                                                AB0090
     C****       *INU7     IFEQ '1'                                       AB0090
     C****                 GOTO #BB9                                      AB0090
     C****                 END                                            AB0090
     C****                                                                AB0090
     C****ERFORM ADD IN FOR SELL CCY                                      AB0090
     C****                 MOVE ' '       @RREV                           AB0090
     C****                 MOVE @SELC     @RCCY                           AB0090
     C****                 MOVE @SELA     @RAMT                           AB0090
     C****                 MOVE JUFBCD    @RBCD                           AB0090
     C****                 MOVE @MDACT    @RACT                           AB0090
     C****                 EXSR #ZA                                       AB0090
     C****                 END                                            AB0090
     C********** #BB9      ENDSR
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #ZA   UPDATE FORWARD BOOK DAILY SCHEDULE        *
     C*                                                              *
     C*  FIELDS USED :     @RACT8 -  ACTION DATE(NUM)                *
     C*                    @RBCD  -  BCD INPUT                       *
     C*                    @RACT  -  ACTION DATE INPUT               *
     C*                    @RREV  -  REVERSE INDICATOR INPUT         *
     C*                    @RAMT  -  AMOUNT INPUT                    *
     C*                    @@DAYN -  INPUT DATE FOR ZA0710           *
     C*                    @@RTN  -  RETURN FLAG FROM ZA0710         *
     C*                    @@VDT  -  OUTPUT DATE FROM ZA0710         *
     C*                    @D1YY  -  DATE FIELD - YEAR               *
     C*                    @D1MM  -  DATE FIELD - MONTH              *
     C*                    @D1DD  -  DATE FIELD - DAY                *
     C*                    @DATE1 -  DATA STRUCTURE DATE             *
     C*                    @RUND  -  RUN DATE (DAY)                  *
     C*                    @RUNM  -  RUN DATE (MONTH)                *
     C*                    @RUNY  -  RUN DATE (YEAR)                 *
     C*                    @USER  -  USER FROM PSDS                  *
     C*                    @PLADJ - PROFIT/LOSS ADJUSTMENT WORK FIELD*
     C*                                                              *
     C*  CALLED BY :       #B   UPDATE FORWARD BOOK DETAILS          *
     C*                                                              *
     C*  CALLS :           ZA0710                                    *
     C*                                                              *
     C****************************************************************
     C     #ZA           BEGSR
     C*
     C** ACCESS FXFWDULL
     C*
     C     KEY5          KLIST
     C                   KFLD                    FPCCY
     C                   KFLD                    FPFWBY
     C                   KFLD                    FPFWBM
     C                   KFLD                    FPFWBD
     C*
     C** CONVERT ACTION DATE TO YYYYMMDD FORM
     C                   MOVE      @RACT         @@DAYN            5 0
     C     @@DAYN        IFNE      *ZEROS                                       B1
     C                   EXSR      ZA0710                                       *1
     C     *INU7         IFEQ      '1'                                          B*2
     C                   GOTO      #ZA9                                         **2
     C                   END                                                    E*2
     C** IF RETURN IS SET THEN DATABASE ERROR
     C     @@RTN         IFEQ      1                                            B*2
     C**  Set up error output for screen.
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     *BLANKS       DBFILE                         * DB ERROR 024*
     C                   MOVEL     '024'         DBASE                          ***************
     C                   MOVE      '1'           *INU7                          **2
     C                   MOVE      '1'           *INU8                          **2
     C                   GOTO      #ZA9                                         **2
     C                   END                                                    E*2
     C                   MOVE      @@VDT         @RACT8            8 0          *1
     C                   ELSE                                                   X1
     C                   MOVE      *ZEROS        @RACT8                         *1
     C                   END                                                    E1
     C*
     C** ACCESS FX FORWARD BOOK DAILY DETAILS
     C                   MOVE      @RACT8        @DATE1
     C                   MOVE      @D1YY         FPFWBY
     C                   MOVE      @D1MM         FPFWBM
     C                   MOVE      @D1DD         FPFWBD
     C                   MOVE      @RCCY         FPCCY
     C     KEY5          CHAIN     FXFWDULL                           64
     C     *IN64         IFEQ      '1'                                          B1
     C*
     C** CREATE A ZERO RECORD FOR FXFWDDP0
     C                   MOVE      'FP'          FPRCID                         *1
     C                   MOVE      *BLANKS       FPDLTF                         *1
     C                   MOVE      @RUND         FPDLUP                         *1
     C                   MOVE      @RUNM         FPMLUP                         *1
     C                   MOVE      @RUNY         FPYLUP                         *1
     C                   TIME                    FPTLUP                         *1
     C                   MOVE      'I'           FPCHTP                         *1
     C                   MOVE      RUND          FPLCD                          *1
     C                   MOVEL     @USER         FPLUID                         *1
     C                   MOVE      *ZEROS        FPDYCI                         *1
     C                   MOVE      *ZEROS        FPDYCO                         *1
     C                   MOVE      *ZEROS        FPDYNM                         *1
     C                   MOVE      *ZEROS        FPDYDE                         *1
     C                   END                                                    E1
     C*
     C** DAILY CASH IN AND OUT
     C*
     C** IF REVERSE SIGN INDICATOR NOT SET
     C     @RREV         IFNE      'R'                                          B1
     C     @RAMT         IFGE      0                                            B2
     C     FPDYCI        ADD       @RAMT         FPDYCI                         **2
     C                   ELSE                                                   X*2
     C     FPDYCO        SUB       @RAMT         FPDYCO                         **2
     C                   END                                                    E2
     C                   END                                                    E1
     C*
     C** IF REVERSE SIGN INDICATOR SET
     C     @RREV         IFEQ      'R'                                          B1
     C     @RAMT         IFGE      0                                            B*2
     C     FPDYCI        SUB       @RAMT         FPDYCI                         **2
     C                   ELSE                                                   X*2
     C     FPDYCO        ADD       @RAMT         FPDYCO                         **2
     C                   END                                                    E2
     C                   END                                                    E1
     C*
     C** DAILY NET MOVEMENT
     C     FPDYCI        SUB       FPDYCO        FPDYNM
     C*
     C** DAILY NET DEALT BASE CCY EQUIV
     C*
     C** IF REVERSE SIGN INDICATOR NOT SET
     C     @RREV         IFNE      'R'                                          B1
     C     @RAMT         IFGE      0                                            B*2
     C     FPDYDE        ADD       @RBCD         FPDYDE                         **2
     C                   ELSE                                                   X*2
     C     FPDYDE        SUB       @RBCD         FPDYDE                         **2
     C                   END                                                    E2
     C                   END                                                    E1
     C*
     C** IF REVERSE SIGN INDICATOR SET
     C     @RREV         IFEQ      'R'                                          B1
     C     @RAMT         IFGE      0                                            B*2
     C     FPDYDE        SUB       @RBCD         FPDYDE                         **2
     C                   ELSE                                                   X*2
     C     FPDYDE        ADD       @RBCD         FPDYDE                         **2
     C                   END                                                    E2
     C                   END                                                    E1
     C*
     C     *IN64         IFEQ      '0'                                          B1
     C                   MOVE      @RUND         FPDLUP                         *1
     C                   MOVE      @RUNM         FPMLUP                         *1
     C                   MOVE      @RUNY         FPYLUP                         *1
     C                   TIME                    FPTLUP                         *1
     C                   MOVE      'A'           FPCHTP                         *1
     C                   MOVE      RUND          FPLCD                          *1
     C                   MOVEL     @USER         FPLUID                         *1
     C                   UPDATE    FXFWDDP0                                     *1
     C                   ELSE                                                   X1
     C                   WRITE     FXFWDDP0                                     *1
     C                   END                                                    E1
     C*
     C** ACCESS FXFWMULL
     C     KEY6          KLIST
     C                   KFLD                    FQCCY
     C                   KFLD                    FQFWBY
     C                   KFLD                    FQFWBM
     C                   KFLD                    FQFBHM
     C                   MOVE      @RACT8        DATE1
     C                   MOVE      @D1YY         FQFWBY
     C                   MOVE      @D1MM         FQFWBM
     C*
     C** FORWARD BOOK HALF MONTH
     C     @D1DD         IFGE      '01'                                         B1
     C     @D1DD         ANDLE     '15'                                         *1
     C                   Z-ADD     1             FQFBHM                         *1
     C                   ELSE                                                   X1
     C                   Z-ADD     2             FQFBHM                         *1
     C                   END                                                    E1
     C                   MOVE      @RCCY         FQCCY
     C     KEY6          CHAIN     FXFWMULL                           65
     C*
     C** CREATE A ZERO RECORD FOR FXFWDHP0
     C     *IN65         IFEQ      '1'                                          B1
     C                   MOVE      'FQ'          FQRCID                         *1
     C                   MOVE      *BLANKS       FQDLTF                         *1
     C                   MOVE      @RUND         FQDLUP                         *1
     C                   MOVE      @RUNM         FQMLUP                         *1
     C                   MOVE      @RUNY         FQYLUP                         *1
     C                   TIME                    FQTLUP                         *1
     C                   MOVE      'I'           FQCHTP                         *1
     C                   MOVE      RUND          FQLCD                          *1
     C                   MOVEL     @USER         FQLUID                         *1
     C                   MOVE      *BLANKS       FQHMCI                         *1
     C                   MOVE      *BLANKS       FQHMCO                         *1
     C                   MOVE      *BLANKS       FQHMNM                         *1
     C                   MOVE      *BLANKS       FQHMDE                         *1
     C                   END                                                    E1
     C*
     C** HALF MONTH CASH IN AND OUT
     C*
     C** IF REVERSE SIGN INDICATOR NOT SET
     C     @RREV         IFNE      'R'                                          B1
     C     @RAMT         IFGE      0                                            B*2
     C     FQHMCI        ADD       @RAMT         FQHMCI                         **2
     C                   ELSE                                                   X*2
     C     FQHMCO        SUB       @RAMT         FQHMCO                         **2
     C                   END                                                    E2
     C                   END                                                    E1
     C*
     C** IF REVERSE SIGN INDICATOR SET
     C     @RREV         IFEQ      'R'                                          B1
     C     @RAMT         IFGE      0                                            B*2
     C     FQHMCI        SUB       @RAMT         FQHMCI                         **2
     C                   ELSE                                                   X*2
     C     FQHMCO        ADD       @RAMT         FQHMCO                         **2
     C                   END                                                    E2
     C                   END                                                    E1
     C*
     C** HALF MONTH NET MOVEMENT
     C     FQHMCI        SUB       FQHMCO        FQHMNM
     C*
     C** HALF MONTH NET MM INTEREST NOT UPDATED
     C*
     C** HALF MONTH NET DEALT BASE CCY EQUIV
     C*
     C** IF REVERSE SIGN INDICATOR NOT SET
     C     @RREV         IFNE      'R'                                          B1
     C     @RAMT         IFGE      0                                            B*2
     C     FQHMDE        ADD       @RBCD         FQHMDE                         **2
     C                   ELSE                                                   X*2
     C     FQHMDE        SUB       @RBCD         FQHMDE                         **2
     C                   END                                                    E2
     C                   END                                                    E1
     C*
     C** IF REVERSE SIGN INDICATOR SET
     C     @RREV         IFEQ      'R'                                          B1
     C     @RAMT         IFGE      0                                            B*2
     C     FQHMDE        SUB       @RBCD         FQHMDE                         **2
     C                   ELSE                                                   X*2
     C     FQHMDE        ADD       @RBCD         FQHMDE                         **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C** IF FORWARD BOOK DAILY DETAILS RECORD EXISTS UPDATE WITH
     C** NEW DATA ELSE CREATE A BLANK RECORD
     C     *IN65         IFEQ      '0'                                          B1
     C                   MOVE      @RUND         FQDLUP                         *1
     C                   MOVE      @RUNM         FQMLUP                         *1
     C                   MOVE      @RUNY         FQYLUP                         *1
     C                   TIME                    FQTLUP                         *1
     C                   MOVE      'A'           FQCHTP                         *1
     C                   MOVE      RUND          FQLCD                          *1
     C                   MOVEL     @USER         FQLUID                         *1
     C                   UPDATE    FXFWDHP0                                     *1
     C                   ELSE                                                   X1
     C                   WRITE     FXFWDHP0                                     *1
     C                   END                                                    E1
     C     #ZA9          ENDSR
     //TITLE
     C*****************************************************************
     C*                                                               *
     C* SUBROUTINE: #C    PROGRAM TERMINATION                         *
     C*                                                               *
     C* FIELDS USED:      @TERM - TERMINATION PARAMETER               *
     C*                                                               *
     C* CALLED BY:        MAIN PROGRAM                                *
     C*                                                               *
     C* CALLS:            (none)                                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     #C            BEGSR
     C*
     C     *INU7         IFEQ      '1'
     C                   MOVE      'E'           @TERM
     C                   MOVE      *BLANKS       @FIRST
     C                   SETON                                        LR
     C                   END
     C*
     C     @TERM         IFEQ      'T'
     C                   MOVE      *BLANKS       @FIRST
     C                   SETON                                        LR
     C                   END
     C*
     C                   ENDSR
     C*
     //EJECT
     C*******************************************************************
     C*                                                               *
     C* ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO     *
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)     *
     C*                                                               *
     C* CALLED BY : #BA  #BB                                          *
     C*                                                               *
     C* CALLS :  (NONE)                                               *
     C*                                                               *
     C* INPUT  : @@DTIN DATE (YYYYMMDD) - IN DATA STRUCTURE (SIZE : 8N)
     C*                                                               *
     C* OUTPUT : @@MDNO MIDAS DAY NUMBER  (SIZE : 5N)                 *
     C*                                                               *
     C* USES :   @@CC   NUMBER OF CENTURIES IN DATE                   *
     C*          @@DAY  DAY NUMBER                                    *
     C*          @@REM  REMAINDER FROM DIVIDE                         *
     C*          @@MTH  MONTH NUMBER                                  *
     C*          @MD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN *
     C*                 MONTH                                         *
     C*          @@WK2  WORK FIELD (2,0)                              *
     C*          @@WK5  WORK FIELD (5,0)                              *
     C*          @@YYYY YEAR (4 CHARACTER)                            *
     C*          @@YY   YEAR (2 CHARACTER)                            *
     C*          @YD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN *
     C*                 A FOUR YEAR PERIOD                            *
     C*                                                               *
     C*******************************************************************
     C*
     C     ZA0680        BEGSR
     C*
     C**  CLEAR OUT ANY 'OLD' DATA IN FIELD
     C                   Z-ADD     0             @@MDNO            5 0
     C*
     C**   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING
     C     @@YYYY        IFGE      2072                                         B1
     C*
     C**    MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C     @@CC          SUB       19            @@WK2             2 0          *1
     C     @@WK2         MULT      36524         @@MDNO                         *1
     C*
     C**  YEAR 2000 IS A LEAP YEAR MUST ALLOW EXTRA DAY
     C                   ADD       1             @@MDNO                         *1
     C                   END                                                    E1
     C*
     C     @@YYYY        ADD       28            @@WK2
     C*
     C     @@WK2         DIV       4             @@WK2
     C                   MVR                     @@REM             1 0
     C*
     C**    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     @@WK2         MULT      1461          @@WK5             5 0
     C                   ADD       @@WK5         @@MDNO
     C*
     C**  CHECK REMAINDER AND MONTH NUMBER
     C     @@REM         IFEQ      0                                            B1
     C     @@MTH         ANDGT     2                                            B1
     C                   ADD       1             @@MDNO                         *1
     C                   END                                                    E1
     C*
     C**  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     @@REM         IFNE      0                                            B1
     C                   ADD       @YD(@@REM)    @@MDNO                         *1
     C                   END                                                    E1
     C*
     C**  ADD MONTHS THIS YEAR
     C                   ADD       @MD(@@MTH)    @@MDNO
     C*
     C**  ADD DAYS THIS MONTH
     C                   ADD       @@DAY         @@MDNO
     C*
     C     ZA0689        ENDSR                                                  **ZA0689 TAG**
     //TITLE
     C*****************************************************************
     C*                                                               *
     C*       TITLE:CALCULATE MIDAS DAY NO. TO DRS (YYYYMMDD) FORMAT. *
     C*                                                               *
     C*       SUBROUTINE ZA0710 EXPECTS FIELD '@@DAYN' TO BE          *
     C*       PASSED TO IT IN 5,0 FORMAT.IF THE ABOVE FIELD IS LESS   *
     C*       THAN 1 IT RETURNS 1 IN FIELD '@@RTN'.THE MAIN PROGRAM   *
     C*       SHOULD CHECK FOR THIS CONDITION AND DO THE NECESSARY.   *
     C*       IF '@@RTN' IS NOT EQUAL TO 1 IT RETURNS THE FIELD       *
     C*       '@@VDT'  IN 'YYYYMMDD' FORMAT.                          *
     C*                                                               *
     C* NOTE: FIELD TO BE DEFINED BY EXTERNAL ROUTINE IS
     C*                                                               *
     C*       1) @@DAYN   LENGTH 5,0.                                 *
     C*                                                               *
     C*       FIELDS USED AND ALREADY DEFINED IN THE ROUTINE ARE:     *
     C*                                                               *
     C*       1) @@VDT    LENGTH 8,0 DEFINED BY A DS.                 *
     C*       2) @@RTN    LENGTH 1,0.                                 *
     C*       3) @@I      LENGTH 2,0 USED TO ACCESS ARRAY @YD         *
     C*       4) @@J      LENGTH 2,0 USED TO ACCESS ARRAY @MD         *
     C*       5) @@Z71Y   LENGTH 4,0 DEFINED BY A DS.                 *
     C*       6) @@RDAY   LENGTH 5,0.                                 *
     C*       7) @@LEAP   LENGTH 1,0.
     C*                                                               *
     C*       INDICATORS USED ARE:                                    *
     C*                                                               *
     C*       1) 80       CHECK FOR LOW AND EQUAL ON ARRAY @YD        *
     C*       2) 81       CHECK FOR LOW ON ARRAY @MD.                 *
     C*                                                               *
     C* INPUT FIELD:       @@DAYN                                     *
     C*                                                               *
     C* OUTPUT FIELD:      @@VDT                                      *
     C*                                                               *
     C* WORK FIELDS:       @@RTN                                      *
     C*                    @@Z71Y                                     *
     C*                    @@RDAY                                     *
     C*                    @@LEAP                                     *
     C*                    @@I                                        *
     C*                    @@J                                        *
     C*                                                               *
     C* ARRAYS USED:       @YD COMPILE TIME ARRAY.                    *
     C*                    @MD COMPILE TIME ARRAY.                    *
     C*                                                               *
     C* CALLED BY:    #ZA                                             *
     C*****************************************************************
     C*
     C     ZA0710        BEGSR
     C*
     C                   SETOFF                                       8081
     C                   Z-ADD     0             @@RTN             1 0
     C                   Z-ADD     0             @@VDT
     C                   Z-ADD     1             @@I               2 0
     C                   Z-ADD     1             @@J               2 0
     C                   Z-ADD     1             @@LEAP            1 0
     C*
     C     @@DAYN        IFLT      1
     C                   Z-ADD     1             @@RTN
     C                   GOTO      ZA0719
     C                   END
     C*
     C* DIVISION TO DETERMINE WETHER LEAP YEAR.
     C*
     C     @@DAYN        DIV       1461          @@Z71Y
     C                   MVR                     @@RDAY            5 0
     C*
     C* CALCULATING YEAR.
     C*
     C     @@Z71Y        MULT      4             @@Z71Y
     C                   ADD       1972          @@Z71Y
     C*
     C* CHECKING IF YEAR IS GREATER THAN OR EQUAL TO 2100
     C*
     C     @@Z71Y        IFGE      2100
     C                   ADD       @@SSY2        @@RDAY
     C                   END
     C*
     C* LOKUP ARRAY @YD TO SEE HOW MANY YEARS OF A FOUR YEAR CYCLE
     C* HAVE PASSED.
     C*
     C     @@RDAY        LOOKUP    @YD(@@I)                             8080
     C*
     C* IF YEAR IS A LEAP YEAR SSLEAP IS SET TO ZERO.
     C*
     C     *IN80         IFEQ      '0'
     C                   Z-ADD     0             @@LEAP
     C                   END
     C*
     C* ADD INDEX TO YEAR TO GIVE CORRECT YEAR AND ADJUST '@@RDAY'.
     C*
     C     @@LEAP        IFEQ      1
     C     @@RDAY        SUB       @YD(@@I)      @@RDAY
     C                   ADD       @@I           @@Z71Y
     C                   END
     C*
     C* PROCESSING FOR A LEAP YEAR.
     C*
     C     @@LEAP        IFEQ      0
     C*
     C* IF '@@RDAY' = 60 DATE MUST BE 29TH OF FEBRUARY.
     C*
     C     @@RDAY        IFEQ      60
     C                   Z-ADD     29            @@Z71D
     C                   Z-ADD     2             @@Z71M
     C                   GOTO      ZA0711
     C                   END
     C*
     C* IF '@@RDAY' > 60 DATE IS AFTER 29TH OF FEBRUARY,CONVERSION CAN
     C* PROCEED AS USUAL AFTER SUBTRACTING THE EXTRA DAY FOR THE LEAP
     C* YEAR. NOTE : '@@RDAY' < 60 CONVERSION PROCEEDS AS USUAL.
     C*
     C     @@RDAY        IFGT      60
     C     @@RDAY        SUB       1             @@RDAY
     C                   END
     C*
     C                   END
     C*
     C* IF DAY '@@DAYN' IS EXACTLY DIVISIBLE BY 1461 (NUMBER OF DAYS
     C* IN 4 YEARS) THEN DATE MUST BE LAST DAY OF PREVIOUS FOUR YEAR
     C* GROUP.
     C*
     C     @@RDAY        IFEQ      0
     C                   Z-ADD     31            @@Z71D
     C                   Z-ADD     12            @@Z71M
     C                   SUB       1             @@Z71Y
     C                   GOTO      ZA0711
     C                   END
     C*
     C* LOOK UP ARRAY ARRAY @MD TO DETERMINE WHICH MONTH '@@RDAY'
     C* OCCURS IN
     C*
     C     @@RDAY        LOOKUP    @MD(@@J)                             81
     C                   Z-ADD     @@J           @@Z71M
     C     @@RDAY        SUB       @MD(@@J)      @@Z71D
     C*
     C* DS @@VDT  IS RETURNED IN YYYYMMDD FORMAT
     C*
     C     ZA0711        TAG
     C*
     C                   MOVE      @@Z71Y        @@YR
     C*
     C     ZA0719        ENDSR
     //EJECT
     C*****************************************************************
     C*                                                               *
     C* *PSSR - PROGRAM ERROR SUBROUTINE                              *
     C*                                                               *
     C* CALLED BY:   EXECUTES WHENEVER PROGRAM ERROR OCCURS           *
     C*                                                               *
     C* CALLS:                                                        *
     C*                                                               *
     C* USES :  @ERR1  - FLAG TO PREVENT LOOPING IF FURTHER ERRORS    *
     C*         @TERM  - TERMINATION PARAMETER                        *
     C*                                                               *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C** SET @ERR1 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR1         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR1             1            *1
     C*                                                    *1
     C** SET UP FIELDS IN LOCAL DATA AREA                  *1
     C                   MOVE      '991'         DBASE                          *1
     C*                                                    *1
     C** DUMP THE PROGRAM                                  *1
     C                   DUMP                                                   *1
     C                   MOVE      'E'           @TERM
     C                   END                                                    E1
     C*
     C** TERMINATE THE PROGRAM
     C                   MOVE      '1'           *INU6
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     //EJECT
     C*****************************************************************
     C*                                                               *
     C* INFSR - FILE EXCEPTION/ERROR SUBROUTINE                       *
     C*                                                               *
     C* CALLED BY:   EXECUTES WHENEVER FILE EXCEPTION/ERROR OCCURS    *
     C*                                                               *
     C* CALLS:                                                        *
     C*                                                               *
     C* USES :  @ERR2  - FLAG TO PREVENT LOOPING IF FURTHER ERRORS    *
     C*         @FILE  - FILENAME FOR WHICH EXCEPTION/ERROR           *
     C*                  OCCURRED (POSNS 201-208 OF PSDS)             *
     C*         @TERM  - TERMINATION PARAMETER                        *
     C*                                                               *
     C*****************************************************************
     C*
     C     INFSR         BEGSR
     C*
     C** SET @ERR2 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR2         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR2             1            *1
     C*                                                    *1
     C** SET UP FIELDS IN LOCAL DATA AREA                  *1
     C                   MOVEL     @FILE         DBFILE                         *1
     C                   MOVE      '992'         DBASE                          *1
     C*                                                    *1
     C** DUMP THE PROGRAM                                  *1
     C                   DUMP                                                   *1
     C                   MOVE      'E'           @TERM
     C                   END                                                    E1
     C*
     C** TERMINATE THE PROGRAM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     //TITLE
     C** @DP USED BY SR. ZA0680 - DECIMAL PLACES CORRECTION ARRAY
     C** 1000000010000000100000001000000010000000100000001
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA @YD
00366007310109601461
**CTDATA @MD
00000000310005900090001200015100181002120024300273003040033400365
