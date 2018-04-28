     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')           CAP084
      *****************************************************************
/*S******RPGBASE*******************************************************         CAP084
/*STD *  RPGBASEMOD                                                   *         CAP084
/*EXI *  TEXT('Midas AB Upd fx Positions & Profits')
     F*****************************************************************
     F*                                                               *
     F*  Midas  -  Internal Contracts & Arbitrage Dealing
     F*                                                               *
     F*     AB0260    - Update FX Positions & Profits file            *
     F*                                                               *
     F*     Function: This program updates the Foreign Exchange       *
     F*     (I/C)     equivalents, positions and profits (FXEPOSPP),  *
     F*               and cross currency positions kept (FXCRSCPP).   *
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
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 13Jan06               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 06Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAC001             Date 01Feb96               *
     F*                 S01319             Date 13Aug91               *
     F*                 S01277             Date 08Feb91               *
     F*                  S01117             Date 31JAN90              *
     F*                  S01194             Date 31JAN90              *
     F*                  E17063             DATE 07/07/89             *
     F*                  E17321             DATE 15/03/89             *
     F*                  AB0205             DATE 27/04/88             *
     F*                  AB0108             DATE 03/03/88             *
     F*                  AB0089             DATE 15/02/88             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Convert to ILE.                                     *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Recompiled only.                                    *
     F*  S01319 - Remove references to FDINSTLL
     F*  S01277 - Cross currencies position update.                   *   S01277
     F*         - SIGNS WRONG ON X-CCY UPDATES                        *
     F*  S01194 - NEW STANDING DATA                                   *
     F*  S01117 - MULTI-BRANCHING.                                    *
     F*                                                               *
     F*  E17063 - Recompiled using IGNDECERR(*YES).                   *
     F*                                                               *
     F*  E17321 - FIX DATE/DAY NUMBER CONFUSION. AND IGNDECERR(*YES)  *
     F*                                                               *
     F*  AB0205 - IF DBERR MUST DMP & ERR0R 004 SETS UP DBASE WRONG   *
     F*                                                               *
     F*  AB0108 - CCYS MUST BE PROCESSED IN ALPHABETIC ORDER SO AS    *
     F*           TO AVOID A DEADLY EMBRACE BETWEEN TWO TERMINALS.    *
     F*                                                               *
     F*  AB0089 - *ENTRY PARMS ARE BACK TO FRONT. AND FIELD @IVACT    *
     F*           NOT INITIALISED WITH EACH CALL                      *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  CREATION PARAMETERS                                          *
     F*                                                               *
*****F** SNPDUMP(*NONE) CODELIST(*NONE) IGNDECERR(*NO)              : *   E17063
     F*                                                               *
     F*****************************************************************
     F*
     F**  Indicator Function Summary
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     F*       50  TABLE LOOKUP INDICATOR
     F*       63  FILE ACCESS INDICATOR - GENERAL
     F*       66  FILE ACCESS INDICATOR - FXEPOULL
     F*       67  FILE ACCESS INDICATOR - FXCRSCLL                        S01277
     F*       68  FILE ACCESS INDICATOR - FXEPOCLL                        S01277
     F********80**FILE*ACCESS*FOR*FDINSTLL********************************S01319
     F*       U6  PROGRAM ERROR
     F*     U7+U8 DATA BASE ERROR
     F*
     F*
     FFXREVHLL  IF   E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F*FDICDRLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F*FDINSTLLIF**E*******************DISK***************************UC**S01319
     FFDCCYPLL  IF   E           K DISK    INFSR(INFSR)
     F                                     USROPN
     FFXEPOULL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT
     F*FDCCYTLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F**********************************************KCOMIT                AB0089
     FFXCRSCLL  IF   E           K DISK    INFSR(INFSR)                         S01277
     FFXEPOCLL  UF A E           K DISK    INFSR(INFSR)                         S01277
     F                                     RENAME(FXEPOSP0:FXEPOCL1)            S01277
     D/EJECT
     D*
     D**  ARRAY TO HOLD COPYRIGHT STATEMENT
     D*
     D**  ARRAY FOR SR. ZA0620 - DECIMAL PLACES CORRECTION
     D**  ( ie 1000  100  10  1  .1  .01  .001)
     D @DP             S              7  3 DIM(7) CTDATA PERRCD(7)
     D*
     D**  ARRAY FOR SR. ZA0680 - CUMULATIVE DAYS IN YEAR FOR 4 YEAR PERIOD
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D*
     D**  ARRAY FOR SR. ZA0680 - CUMULATIVE DAYS IN YEAR PER MONTH
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
     D*
     D*
     D** TABLES FOR SHORT OR FORWARD P/L
     D TAB1            S              4    DIM(12) CTDATA PERRCD(1)
     D TAB2            S              2    DIM(12) ALT(TAB1)
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
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
      ** BANK DETAILS ACCESSED VIA ACCESS PROGRAM                         S01194
     D  RUND                  34     36P 0                                      S01194
     D  @RUND                 43     44                                         S01194
     D  @RUNM                 45     47                                         S01194
     D  @RUNY                 48     49                                         S01194
      *                                                                   S01194
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    S01194
      ** CURRENCY DETAILS ACCESSED VIA ACCESS PROGRAM                     S01194
      *                                                                   S01194
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                    S01319
     D** EXTERNAL DS FOR DEALING DETAILS                                  S01319
     D SDTRMA        E DS                  EXTNAME(SDTRMAPD)                    S01319
     D** EXTERNAL DS FOR TREASURY MANAGEMENT DETAILS                      S01319
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                S01194
     D*                                                                   S01194
     D*RUNS1******DS***************************                           S01194
     D****************************************1   7 RUNA                  S01194
     D****************************************1   2 @RUND                 S01194
     D****************************************3   5 @RUNM                 S01194
     D****************************************6   7 @RUNY                 S01194
     D*
     D** STANDARD DEAL EXTERNALLY DEFINED DATA STRUCTURE
     D @STDDL        E DS                  EXTNAME(ABSTDDPP)
      *
     D**  DATA STRUCTURE FOR SR. ZA0680 - DATE INPUT TO SUBROUTINE
     D DATIN           DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
      *
     D                 DS                                                       E17321
      *                                                                   E17321
     D  @@VLDT                 1      8  0                                      E17321
     D  @@VDYY                 1      4  0                                      E17321
     D  @@VDMM                 5      6  0                                      E17321
     D  @@VDDD                 7      8  0                                      E17321
     //EJECT
     C****************************************************************
     C*                 MAIN PROGRAM
     C*                 ~~~~~~~~~~~~
     C** INITIAL PROCESSING
     C                   EXSR      #A
     C*
     C** MAIN PROCESSING FXP0035
     C     *INU7         IFNE      '1'                                          B1
     C     @TERM         ANDNE     'T'                                          *1
     C     @IVACT        ANDNE     'Y'
     C                   EXSR      #B                                           *1
     C                   END                                                    E1
     C*
     C** FINAL PROCESSING
     C     ENDPGM        TAG                                                    *** ENDPGM ***
     C                   EXSR      #C
     C*
     C                   RETURN
     C****************************************************************
     //EJECT
     C****************************************************************
     C*                                                              *
     C*            INDEX TO SUBROUTINES                              *
     C*            ~~~~~~~~~~~~~~~~~~~~                              *
     C*   1. #B           UPDATE EQUIVALENTS POSITIONS & PROFITS     *
     C*   2. #BA          UPDATE FXEPOUP0 - ADD/DELETE/UPDATE DEAL   *
     C*   3. #BAB         CALCULATE PROFIT/LOSS.                     *
     C*   4. #BB          PHYSICALLY UPDATE DEAL ON FILE - FXEOUPLL  *
     C*   6. #BCA         CREATE ZERO RECORD FOR FXEPOULL            *
     C*   7. #A           INITIAL PROCESSING                         *
     C*   8. #C           FINAL PROCESSING                           *
     C*   9. #BC          DO INSERT OR DELETE CHAIN TO FXEPOULL      *
     C*      #BD          UPDATE FXEPOCLL - CROSS CURRENCIES         *    S01277
     C*  10. ZA0680       CONVERT YYYYMMDD TO DAY NUMBER             *
     C*  11. ZA0620       CALCULATE REVALUATION P/L                  *
     C*  12. ZA0640       CALCULATE FORWARD OUTRIGHT RATE            *
     C*  13. *PSSR        PROGRAM ERROR SUBROUTINE                   *
     C*  14. INFSR        FILE ERROR SUBROUTINE                      *
     C*                                                              *
     C*                                                              *
     C*                                                              *
     C****************************************************************
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #B    UPDATE EQUIVALENTS POSITIONS AND          *
     C*                    PROFITS                                   *
     C*                                                              *
     C*  FIELDS USED   :   @@DTIN -  INPUT DATE FOR ZA0680           *
     C*                    @@MDNO -  OUTPUT DATE FROM ZA0680         *
     C*                    @@ACT  -  DEAL ACTION DATE(MIDAS)         *
     C*                    @@RCCY -  FIRST CURRENCY FOR SUBROUTINE   *
     C*                    @@LCCY -  SECOND CURRENCY FOR SUBROUTINE  *    AB0108
     C*                    @@RAMT -  AMOUNT FOR SUBROUTINE           *
     C*                    @@RAM2 -  SAVE 2ND AMOUNT FOR SUBROUTINE  *    AB0108
     C*                    @@LAMT -  LOWER CCY AMOUNT FOR SUB        *    AB0108
     C*                    @@LAM2 -  LOWER CCY 2ND AMOUNT FOR SUB    *    AB0108
     C*                                                              *
     C*  CALLS :           #BB #BC #BD                               *
     C*                    ZA0680                                    *
     C*                                                              *
     C****************************************************************
     C     #B            BEGSR
     C*
     C     JUDSCY        IFLT      JUDFCY                                       B1             AB010
     C                   MOVE      JUDSCY        @@RCCY            3            *1             AB010
     C                   MOVE      JUDFCY        @@LCCY            3            *1             AB010
     C                   Z-ADD     JUNDA2        @@RAMT           15 0          *1             AB010
     C                   Z-ADD     JUFDA2        @@RAM2           15 0          *1             AB010
     C                   Z-ADD     JUNDA1        @@LAMT           15 0          *1             AB010
     C                   Z-ADD     JUFDA1        @@LAM2           15 0          *1             AB010
     C                   ELSE                                                   X1             AB010
     C                   MOVE      JUDFCY        @@RCCY                         *1             AB010
     C                   MOVE      JUDSCY        @@LCCY                         *1             AB010
     C                   Z-ADD     JUNDA1        @@RAMT                         *1             AB010
     C                   Z-ADD     JUFDA1        @@RAM2                         *1             AB010
     C                   Z-ADD     JUNDA2        @@LAMT                         *1             AB010
     C                   Z-ADD     JUFDA2        @@LAM2                         *1             AB010
     C                   END                                                    E1             AB010
     C*                                                                   AB0108
     C*****                MOVE JUDFCY    @@RCCY  3                       AB0108
     C*                                                                   AB0108
     C                   EXSR      #BC
     C*
     C     *INU7         IFEQ      '1'                                          B1
     C                   GOTO      #B9                                          *1
     C                   END                                                    E1
     C*
     C                   Z-ADD     JUNDYY        @@VDYY                                        E1732
     C                   Z-ADD     JUNDMM        @@VDMM                                        E1732
     C                   Z-ADD     JUNDDD        @@VDDD                                        E1732
     C                   Z-ADD     JUNDAT        @@ACT             5 0
     C*****                Z-ADDJUNDA1    @@RAMT 150                      AB0108
     C                   Z-ADD     JUNBCD        @@BCD            15 0
     C                   Z-ADD     JUNSBC        @@SBC            15 0
     C                   EXSR      #BA
     C                   Z-ADD     JUFDYY        @@VDYY                                        E1732
     C                   Z-ADD     JUFDMM        @@VDMM                                        E1732
     C                   Z-ADD     JUFDDD        @@VDDD                                        E1732
     C                   Z-ADD     JUFDAT        @@ACT
     C*****                Z-ADDJUFDA1    @@RAMT                          AB0108
     C                   Z-ADD     @@RAM2        @@RAMT                                        AB010
     C                   Z-ADD     JUFBCD        @@BCD
     C                   Z-ADD     JUFSBC        @@SBC
     C                   EXSR      #BA
     C*
     C**  Update the file - FXEOUPLL.
     C                   EXSR      #BB
     C*
     C     *INU7         IFEQ      '1'                                          B1
     C                   GOTO      #B9                                          *1
     C                   END                                                    E1
     C*
     C*****                MOVE JUDSCY    @@RCCY                          AB0108
     C                   MOVE      @@LCCY        @@RCCY                                        AB010
     C                   EXSR      #BC
     C*
     C     *INU7         IFEQ      '1'                                          B1
     C                   GOTO      #B9                                          *1
     C                   END                                                    E1
     C*
     C                   Z-ADD     JUNDYY        @@VDYY                                        E1732
     C                   Z-ADD     JUNDMM        @@VDMM                                        E1732
     C                   Z-ADD     JUNDDD        @@VDDD                                        E1732
     C                   Z-ADD     JUNDAT        @@ACT
     C*****                Z-ADDJUNDA2    @@RAMT                          AB0108
     C                   Z-ADD     @@LAMT        @@RAMT                                        AB010
     C                   Z-ADD     JUNBCD        @@BCD
     C                   Z-ADD     JUNSBC        @@SBC
     C                   EXSR      #BA
     C*
     C                   Z-ADD     JUFDYY        @@VDYY                                        E1732
     C                   Z-ADD     JUFDMM        @@VDMM                                        E1732
     C                   Z-ADD     JUFDDD        @@VDDD                                        E1732
     C                   Z-ADD     JUFDAT        @@ACT
     C*****                Z-ADDJUFDA2    @@RAMT                          AB0108
     C                   Z-ADD     @@LAM2        @@RAMT                                        AB010
     C                   Z-ADD     JUFBCD        @@BCD
     C                   Z-ADD     JUFSBC        @@SBC
     C                   EXSR      #BA
     C*
     C     *INU7         IFEQ      '1'
     C                   GOTO      #B9
     C                   END
     C*
     C**  Update the file - FXEOUPLL.
     C                   EXSR      #BB
     C*
     C** CROSS CURRENCIES POSITION UPDATE PROCESSING                      S01277
     C*                                                                   S01277
     C** If first currency of deal is not base currency for               S01277
     C** dealing check cross currency file to see whether                 S01277
     C** a position is being kept for this currency combination.          S01277
     C*                                                                   S01277
     C***********JUDFCY****IFNE*IDCYDL*********************B1*******S01277S01319
     C     JUDFCY        IFNE      BNCYDL                                       B1             S0131
     C*                                                                   S01277
     C                   MOVE      JUDFCY        @CPCCY                                        S0127
     C                   MOVE      JUDSCY        @CSCCY                                        S0127
     C*                                                                   S01277
     C     @CCKEY        CHAIN     FXCRSCLL                           67                       S0127
     C*                                                                   S01277
     C** If record found then a position is being kept                    S01277
     C** which needs updating for this deal.                              S01277
     C*                                                                   S01277
     C     *IN67         IFEQ      '0'                                          B*2            S0127
     C*                                                                   S01277
     C                   MOVE      JUDSCY        @@RCCY                                        S0127
     C                   MOVE      JUDSCY        @EECCY                                        S0127
     C                   MOVE      JUDFCY        @EPCCY                                        S0127
     C                   Z-ADD     JUNDA2        @CCAMT           15 0                         S0127
     C                   ADD       JUFDA2        @CCAMT                                        S0127
     C                   Z-ADD     JUNDA1        @CCEQV           15 0                         S0127
     C                   ADD       JUFDA1        @CCEQV                                        S0127
     C*                                                                   S01277
     C                   EXSR      #BD                                                         S0127
     C                   END                                                    E*2            S0127
     C*                                                                   S01277
     C                   END                                                    E1             S0127
     C*                                                                   S01277
     C** If second currency of deal is not base currency for              S01277
     C** dealing check cross currency file to see whether                 S01277
     C** a position is being kept for this currency combination.          S01277
     C*                                                                   S01277
     C***********JUDSCY****IFNE*IDCYDL*********************B1*******S01277S01319
     C     JUDSCY        IFNE      BNCYDL                                       B1             S0131
     C*                                                                   S01277
     C                   MOVE      JUDSCY        @CPCCY                                        S0127
     C                   MOVE      JUDFCY        @CSCCY                                        S0127
     C*                                                                   S01277
     C     @CCKEY        CHAIN     FXCRSCLL                           67                       S0127
     C*                                                                   S01277
     C** If record found then a position is being kept                    S01277
     C** which needs updating for this deal.                              S01277
     C*                                                                   S01277
     C     *IN67         IFEQ      '0'                                          B*2            S0127
     C*                                                                   S01277
     C                   MOVE      JUDFCY        @@RCCY                                        S0127
     C                   MOVE      JUDFCY        @EECCY                                        S0127
     C                   MOVE      JUDSCY        @EPCCY                                        S0127
     C                   Z-ADD     JUNDA1        @CCAMT                                        S0127
     C                   ADD       JUFDA1        @CCAMT                                        S0127
     C                   Z-ADD     JUNDA2        @CCEQV                                        S0127
     C                   ADD       JUFDA2        @CCEQV                                        S0127
     C*                                                                   S01277
     C                   EXSR      #BD                                                         S0127
     C                   END                                                    E*2            S0127
     C*                                                                   S01277
     C                   END                                                    E1             S0127
     C*                                                                   S01277
     C     #B9           ENDSR
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #BA   UPDATE FXEPOULL                           *
     C*                    ADD IN EXPOSURES FOR THIS DEAL            *
     C*                    CURRENT AMOUNTS AND NOT REVERSING SIGNS   *
     C*                                                              *
     C*  FIELDS USED :     @@RCCY -  CURRENCY                        *
     C*                    @@RAMT -  AMOUNT                          *
     C*                    @ACT   -  ACTION DATE(MIDAS)              *
     C*                    @@BYSL -  INPUT FLAG FOR ZA0620           *
     C*                    @@RPL  -  P/L FROM ZA0620                 *
     C*                    @RUND  -  RUN DATE (DAY)                  *
     C*                    @RUNM  -  RUN DATE (MONTH)                *
     C*                    @RUNY  -  RUN DATE (YEAR)                 *
     C*                    @USER  -  USER FROM PSDS                  *
     C*                                                              *
     C*  CALLED BY :       #B   UPDATE EQUIV POSITIONS & PROFITS     *
     C*                                                              *
     C*  CALLS :           #BCA ZA0620                               *
     C*                                                              *
     C****************************************************************
     C     #BA           BEGSR
     C*
     C                   MOVE      @@RCCY        FOCCY
     C*
     C** IF INSERT ADD IN EXPOSURES FOR THIS DEAL
     C     JULACT        IFEQ      'I'                                          B1
     C*
     C** IF ACTION DATE LT RUN DATE
     C     @@ACT         IFLT      RUND                                         B*2
     C     FONNCP        ADD       @@RAMT        FONNCP                         **2
     C*
     C     @@RAMT        IFGE      0                                            B**3
     C     FONDBC        ADD       @@BCD         FONDBC                         ***3
     C                   ELSE                                                   X**3
     C     FONDBC        SUB       @@BCD         FONDBC                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C     FOTNTP        ADD       @@RAMT        FOTNTP                         *1
     C*
     C     @@RAMT        IFGE      0                                            B*2
     C     FOBDSE        ADD       @@SBC         FOBDSE                         **2
     C     FOTDPE        ADD       @@BCD         FOTDPE                         **2
     C                   ELSE                                                   X*2
     C     FOBDSE        SUB       @@SBC         FOBDSE                         **2
     C     FOTDPE        SUB       @@BCD         FOTDPE                         **2
     C                   END                                                    E*2
     C*
     C                   ELSE                                                   X1
     C*
     C** IF ACTION DATE LT RUN DATE
     C     @@ACT         IFLT      RUND                                         B*2
     C     FONNCP        SUB       @@RAMT        FONNCP                         **2
     C*
     C     @@RAMT        IFGE      0                                            B**3
     C     FONDBC        SUB       @@BCD         FONDBC                         ***3
     C                   ELSE                                                   X**3
     C     FONDBC        ADD       @@BCD         FONDBC                         ***3
     C                   END                                                    E**3
     C                   END                                                    E*2
     C*
     C     FOTNTP        SUB       @@RAMT        FOTNTP                         *1
     C*
     C     @@RAMT        IFGE      0                                            B*2
     C     FOBDSE        SUB       @@SBC         FOBDSE                         **2
     C     FOTDPE        SUB       @@BCD         FOTDPE                         **2
     C                   ELSE                                                   X*2
     C     FOBDSE        ADD       @@SBC         FOBDSE                         **2
     C     FOTDPE        ADD       @@BCD         FOTDPE                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     @@ACT         IFGE      RUND                                         B1
     C*
     C** IF ACTION DATE GREATER THAN OR EQUAL TO MIDAS RUND
     C*
     C                   EXSR      #BAB                                         *1
     C                   END                                                    E1
     C*
     C     #BA9          ENDSR
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #BAB  UPDATE FXEPOULL                           *
     C*                    CALCULATE SHORT AND FORWARD PROFIT/LOSS   *
     C*                                                              *
     C*  FIELDS USED :     @@RCCY -  CURRENCY                        *
     C*                    @@RAMT -  AMOUNT                          *
     C*                    @FWD5  -  1 MONTH FORWARD DATE LOCAL CCY  *
     C*                    @@BYSL -  INPUT FLAG FOR ZA0620           *
     C*                    @@RPL  -  P/L FROM ZA0620                 *
     C*                    @RUND  -  RUN DATE (DAY)                  *
     C*                    @RUNM  -  RUN DATE (MONTH)                *
     C*                    @RUNY  -  RUN DATE (YEAR)                 *
     C*                    @USER  -  USER FROM PSDS                  *
     C*                                                              *
     C*  CALLED BY :       #BA  UPDATE EQUIV POSITIONS & PROFITS     *
     C*                                                              *
     C*  CALLS :           ZA0620                                    *
     C*                                                              *
     C*  COMMENT :         ONLY EXECUTED IF ACTION DATE >= RUN DATE  *
     C*                                                              *
     C****************************************************************
     C     #BAB          BEGSR
      *
      *  Test if code is NOT spot
     C***********IDPRDE****IFNE*'SP**'*********************B1*************S01319
     C     ERSPRE        IFNE      'SP  '                                       B1             S0131
     C*
     C** ACCESS FDCCYPLL TO GET FORWARD DATE
     C     KEY1          KLIST                                                  *1
     C                   KFLD                    XPCCY                          *1
     C                   KFLD                    XPTPRD                         *1
     C                   KFLD                    XPPRD                          *1
     C*
     C** LOOKUP TYPE & PERIOD CODES TO USE AS KEY FOR ACCESS
     C***********IDPRDE****LOKUPTAB1******TAB2***********50*1*************S01319
     C     ERSPRE        LOOKUP    TAB1          TAB2                     50    *1             S0131
     C                   MOVEL     TAB2          @TEMP             1            *1
     C                   MOVE      TAB2          XPTPRD                         *1
     C                   MOVE      @TEMP         XPPRD                          *1
     C                   MOVEL     @@RCCY        XPCCY                          *1
     C*
     C     KEY1          CHAIN     FDCCYPLL                           63        *1
     C     *IN63         IFEQ      '1'                                          B*2
     C     XPDLTF        OREQ      '*'                                          **2
     C**  Set up error output for screen.
     C*********************MOVELKEY       DBKEY            ***************AB0205
     C                   MOVEL     XPCCY         DBKEY                          ***************AB020
     C                   MOVEL     XPTPRD        @TEMP3            3                           AB020
     C                   MOVE      XPPRD         @TEMP3                                        AB020
     C                   MOVE      @TEMP3        DBKEY                                         AB020
     C                   MOVEL     'FDCCYPLL'    DBFILE                         * DB ERROR 004*
     C                   MOVEL     '004'         DBASE                          ***************
     C                   MOVE      '1'           *INU7                          **2
     C                   MOVE      '1'           *INU8                          **2
     C                   DUMP                                                   **2            AB020
     C                   GOTO      #BAB9                                        **2
     C                   END                                                    E*2
     C                   MOVE      XPPRDD        @@DTIN                         *1
     C                   ELSE                                                   X1
      *
      *  Access Currency file
     C*********************MOVEL'20      '@@1200                          S01194
     C*********************MOVE '1'       @@1201                          S01194
     C*********************MOVELLOCY      @@1201                          S01194
     C*********************MOVE @@1201    @@1200                          S01194
     C***********@@1200****CHAINFDCCYTLL             80                   S01194
      *********************                                               S01194
     C********** *IN80*****IFEQ '1'                        B*2            S01194
     C                   CALL      'AOCURRR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*KEY   '     @OPTN             7                           S0119
     C                   PARM      BJLCCY        @AJCD             3                           S0119
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   SETON                                        U7U8      **2
     C*********************MOVEL'FDCCYTLL'DBFILE           **2            S01194
     C                   MOVEL     'SDCURRPD'    DBFILE                                        S0119
     C                   MOVEL     '005'         DBASE                          **2
     C                   MOVEL     @OPTN         DBOPTN            7            **2            S0119
     C*********************MOVEL@@RCCY    DBKEY            **2            S01194
     C                   MOVEL     BJLCCY        DBKEY                          **2            S0119
     C                   DUMP                                                   **2            AB020
     C                   GOTO      #BAB9                                        **2
     C                   END                                                    E*2
     C*********************MOVE FXSP      @@DTIN           *1             S01194
     C                   MOVE      A6FXSD        @@DTIN                         *1             S0119
     C                   END                                                    E1
     C*
     C** CONVERT EITHER PERIOD OR SPOT DATE TO 5N.
     C     @@DTIN        IFNE      *ZEROS                                       B1
     C                   EXSR      ZA0680                                       *1
     C     *INU7         IFEQ      '1'                                          B*2
     C                   GOTO      #BAB9                                        **2
     C                   END                                                    E*2
     C                   MOVE      @@MDNO        @FWD5             5 0          *1
     C                   ELSE                                                   X1
     C                   MOVE      *ZEROS        @FWD5                          *1
     C                   END                                                    E1
     C*
     C     @@RAMT        IFGE      0                                            B1
     C                   MOVE      'S'           @@BYSL                         *1
     C                   ELSE                                                   X1
     C                   MOVE      'B'           @@BYSL                         *1
     C                   END                                                    E1
      *
      *  Access Currency file
     C*********************MOVEL'20      '@@1200 12                       S01194
     C*********************MOVE '1'       @@1201  4                       S01194
     C*********************MOVEL@@RCCY    @@1201                          S01194
     C*********************MOVE @@1201    @@1200                          S01194
     C***********@@1200****CHAINFDCCYTLL             80                   S01194
      *********************                                               S01194
     C********** *IN80*****IFEQ '1'                        B1             S01194
     C                   CALL      'AOCURRR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD                                         S0119
     C                   PARM      '*KEY   '     @OPTN                                         S0119
     C                   PARM      @@RCCY        @AJCD                                         S0119
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   SETON                                        U7U8      *1
     C*********************MOVEL'FDCCYTLL'DBFILE           *1             S01194
     C                   MOVEL     'SDCURRPD'    DBFILE                         *1             S0119
     C                   MOVEL     '006'         DBASE                          *1
     C                   MOVEL     @OPTN         DBOPTN                         *1             S0119
     C                   MOVEL     @@RCCY        DBKEY                          *1
     C                   DUMP                                                   *1             AB020
     C                   GOTO      #BAB9
     C                   END                                                    E1
      *
      *  If Action date less than Forward date
     C     @@ACT         IFLT      @FWD5                                        B1
      *
      *  Calculate SHORT profit/loss
     C                   EXSR      ZA0620                                       *1
     C*
     C     *INU7         IFEQ      '1'                                          B*2
     C                   GOTO      #BAB9                                        **2
     C                   END                                                    E*2
     C*
     C     JULACT        IFEQ      'I'                                          B*2
     C     FOSHPL        ADD       @@RPL         FOSHPL                         **2
     C                   ELSE                                                   X*2
     C     FOSHPL        SUB       @@RPL         FOSHPL                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     @@ACT         IFGE      @FWD5                                        B1
      *
      *  Calculate FORWARd profit/loss
     C                   EXSR      ZA0620                                       *1
     C*
     C     *INU7         IFEQ      '1'                                          B*2
     C                   GOTO      #BAB9                                        **2
     C                   END                                                    E*2
     C*
     C     JULACT        IFEQ      'I'                                          B*2
     C     FOFWPL        ADD       @@RPL         FOFWPL                         **2
     C                   ELSE                                                   X*2
     C     FOFWPL        SUB       @@RPL         FOFWPL                         **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C     #BAB9         ENDSR
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #BB   UPDATE FXEPOULL                           *
     C*                                                              *
     C*  FIELDS USED :     @RUND  -  RUN DATE DAY                    *
     C*                    @RUNM  -  RUN DATE MONTH                  *
     C*                    @RUNY  -  RUN DATE YEAR                   *
     C*                    @USER  -  USER FROM PSDS                  *
     C*                    @@RCCY -  CURRENCY                        *
     C*                                                              *
     C*  CALLED BY :       #B    UPDATE EQUIVILENT POSITIONS & PFTS. *
     C*  CALLS :                                                     *
     C*                                                              *
     C****************************************************************
     C     #BB           BEGSR
     C*
     C** IF INSERT ADD IN EXPOSURES FOR THIS DEAL
     C     JULACT        IFEQ      'I'                                          B1
     C     *IN66         ANDEQ     '1'                                          B1
     C                   WRITE     FXEPOSP0                                     *1
     C                   GOTO      #BB9                                         *1
     C                   END                                                    E1
     C*
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   MOVE      'A'           FOCHTP
     C                   TIME                    FOTLUP
     C                   MOVE      RUND          FOLCD
     C                   MOVEL     @USER         FOLUID
     C                   UPDATE    FXEPOSP0
     C*
     C     #BB9          ENDSR
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #BCA  CREATE ZERO RECORD FOR FXEPOULL           *
     C*                                                              *
     C*  FIELDS USED :     @RUND  -  RUN DATE DAY                    *
     C*                    @RUNM  -  RUN DATE MONTH                  *
     C*                    @RUNY  -  RUN DATE YEAR                   *
     C*                    @USER  -  USER FROM PSDS                  *
     C*                    @@RCCY -  CURRENCY                        *
     C*                                                              *
     C*  CALLED BY :       #BB  UPDATE FXEPOULL FXR0017              *
     C*  CALLS :                                                     *
     C*                                                              *
     C****************************************************************
     C     #BCA          BEGSR
     C                   MOVE      'FO'          FORCID
     C                   MOVE      *BLANKS       FODLTF
     C                   MOVE      @RUND         FODLUP
     C                   MOVE      @RUNM         FOMLUP
     C                   MOVE      @RUNY         FOYLUP
     C                   TIME                    FOTLUP
     C                   MOVE      'I'           FOCHTP
     C                   MOVE      RUND          FOLCD
     C                   MOVEL     @USER         FOLUID
     C                   MOVE      @@RCCY        FOCCY
     C                   MOVE      *ZEROS        FONNCP
     C                   MOVE      *ZEROS        FONDBC
     C                   MOVE      *ZEROS        FOTNTP
     C                   MOVE      *ZEROS        FOTDPE
     C                   MOVE      *ZEROS        FOBDSE
     C                   MOVE      *ZEROS        FOSHPL
     C                   MOVE      *ZEROS        FOFWPL
     C                   MOVE      *ZEROS        FOCTNP                                        S0127
     C                   MOVE      *ZEROS        FOCTEP                                        S0127
     C                   MOVE      *BLANKS       FOPCCY                                        S0127
     C     #BCA9         ENDSR
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #A    INITIAL PROCESSING                        *
     C*                                                              *
     C*  FIELDS USED :     @TERM  -  TERMINATION PARAMETER           *
     C*                    @STDDL -  STANDARD DEAL PARAMETER         *
     C*                    @FIRST -  FIRST TIME CALLED FLAG          *
     C*                    @@DTIN -  INPUT DATE FOR ZA0680           *
     C*                    @@MDNO -  OUTPUT DATE FROM ZA0680         *
     C*                                                              *
     C*  CALLED BY :       MAIN PROGRAM                              *
     C*                                                              *
     C*  CALLS :           ZA0680                                    *
     C*                                                              *
     C****************************************************************
     C     #A            BEGSR
     C**  INPUT PARAMETERS
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1                           AB008
     C                   PARM                    @STDDL                                        AB008
     C*********************PARM           @STDDL                          AB0089
     C*********************PARM           @TERM   1                       AB0089
     C*
     C** Keylist for FXCRSCLL                                             S01277
     C*                                                                   S01277
     C     @CCKEY        KLIST                                                                 S0127
     C                   KFLD                    @CPCCY            3                           S0127
     C                   KFLD                    @CSCCY            3                           S0127
     C*                                                                   S01277
     C** Keylist for FXEPOCLL                                             S01277
     C*                                                                   S01277
     C     @EPKEY        KLIST                                                                 S0127
     C                   KFLD                    @EECCY            3                           S0127
     C                   KFLD                    @EPCCY            3                           S0127
     C*                                                                   S01277
     C**  IF TERMINATION FLAG SET MUST TERMINATE PROGRAM IMMEDIATELY
     C     @TERM         IFEQ      'T'                                          B1
     C                   GOTO      #A9                                          *1
     C                   END                                                    E1
     C*
     C     JULACT        IFNE      'I'                                          B1
     C     JULACT        ANDNE     'D'                                          B1
     C                   MOVE      'Y'           @IVACT            1            *1
     C                   GOTO      #A9                                          *1
     C                   ELSE                                                   X1             AB008
     C                   MOVE      *BLANKS       @IVACT                         *1             AB008
     C                   END                                                    E1
     C*
     C**  CHECK IF THIS IS THE FIRST RUN OF THE PGM
     C     @FIRST        IFEQ      *BLANK                                       B1
     C                   MOVE      'N'           @FIRST            1            *1
     C                   MOVEL     'AB0260 '     DBPGM                          *1
     C*********************OPEN FDICDRLL                   *1             S01194
     C                   OPEN      FDCCYPLL                                     *1
     C*********************OPEN FDCCYTLL                                  S01194
     C                   OPEN      FXEPOULL                                     *1
     C                   OPEN      FXREVHLL                                     *1
     C*********************OPEN*FDINSTLL********************1*************S01319
     C*
     C                   EXSR      ZA0870
     C*
     C     *INU7         IFEQ      '1'                                          B1
     C                   GOTO      #A9                                          *1
     C                   END                                                    E1
     C*
     C***ACCESS*FDICDRLL*TO*GET*RUN*DATES                                 S01194
     C*********************MOVE *BLANKS   KEY                             S01194
     C*********************MOVEL'01'      KEY              *1             S01194
     C*********************MOVE '10'      KEY              *1             S01194
     C***********KEY*******CHAINFDICDRLL             63    *1             S01194
     C********** *IN63*****IFEQ '1'                        B*2            S01194
     C****Set*up*error*output for screen.                                 S01194
     C*********************MOVELKEY       DBKEY            ***************S01194
     C*********************MOVEL'FDICDRLL'DBFILE           * DB ERROR 001*S01194
     C*********************MOVEL'001'     DBASE            ***************S01194
     C*********************MOVEL'AB0260 ' DBPGM            **2            S01194
     C*********************MOVE '1'       *INU7            **2            S01194
     C*********************MOVE '1'       *INU8            **2            S01194
     C*********************DUMP                            **2            S01194
     C*********************GOTO #A9                        **2            S01194
     C*********************END                             E*2            S01194
     C**********************                                              S01194
     C***ACCESS*FDICDRLL*TO*GET LOCAL CCY                                 S01194
     C*********************MOVE *BLANKS   KEY              *1             S01194
     C*********************MOVEL'01'      KEY              *1             S01194
     C*********************MOVE '11'      KEY              *1             S01194
     C***********KEY*******CHAINFDICDRLL             63    *1             S01194
     C********** *IN63*****IFEQ '1'                        B*2            S01194
     C****Set*up*error*output for screen.                                 S01194
     C                   CALL      'AOBANKR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD                                         S0119
     C                   PARM      '*FIRST '     @OPTN                                         S0119
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   MOVEL     @OPTN         DBOPTN                                        S0119
     C*********************MOVELKEY       DBKEY            ***************S01194
     C*********************MOVEL'FDICDRLL'DBFILE           * DB ERROR 002*S01194
     C                   MOVEL     'SDBANKPD'    DBFILE                                        S0119
     C                   MOVEL     '002'         DBASE                          ***************
     C                   MOVE      '1'           *INU7                          **2
     C                   MOVE      '1'           *INU8                          **2
     C                   DUMP                                                   **2            AB020
     C                   GOTO      #A9                                          **2
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #A9           ENDSR
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #C    FINAL PROCESSING                          *
     C*                                                              *
     C*  FIELDS USED :     @TERM  -  TERMINATION PARAMETER           *
     C*                                                              *
     C*  CALLED BY :       MAIN PROGRAM                              *
     C*                                                              *
     C*  CALLS :                                                     *
     C*                                                              *
     C****************************************************************
     C     #C            BEGSR
     C     *INU7         IFEQ      '1'                                          B1
     C                   MOVE      '1'           *INLR                          *1
     C                   MOVE      'E'           @TERM                          *1
     C                   END                                                    E1
     C     @TERM         IFEQ      'T'                                          B1
     C                   MOVE      '1'           *INLR                          *1
     C                   END                                                    E1
      *
      **  Return to calling program.
     C                   RETURN
     C     #C9           ENDSR
     C*******************************************************************
     //EJECT
     C****************************************************************
     C*                                                              *
     C*  SUBROUTINE: #BC   Access FXEPOULL with the relevent ccy     *
     C*                                                              *
     C*  FIELDS USED :     @@RCCY -  Relevant currency               *
     C*                    @@RCCY -  Relevant currency               *
     C*                                                              *
     C*  CALLED BY :       MAIN PROGRAM                              *
     C*                                                              *
     C*  CALLS :           #BCA                                      *
     C*                                                              *
     C****************************************************************
     C     #BC           BEGSR
     C*
     C** ACCESS FXEPOULL
     C     @@RCCY        CHAIN     FXEPOULL                           66
     C     JULACT        IFEQ      'I'                                          B1
     C     *IN66         IFEQ      '1'                                          B*2
     C*
     C** CREATE A ZERO RECORD FOR FXEPOSP0
     C                   EXSR      #BCA                                         **2
     C                   END                                                    E*2
     C                   ELSE                                                   X1
     C     *IN66         IFEQ      '1'                                          B*2
     C*
     C**  Set up error output for screen.
     C                   MOVEL     @@RCCY        DBKEY                          ***************
     C                   MOVEL     'FXEPOULL'    DBFILE                         * DB ERROR 003*
     C                   MOVEL     '003'         DBASE                          ***************
     C                   MOVE      '1'           *INU7                          **2
     C                   MOVE      '1'           *INU8                          **2
     C                   DUMP                                                   **2            AB020
     C                   END                                                    E*2
     C                   END                                                    E1
     C     #BC9          ENDSR
     C*******************************************************************
     //EJECT
     C****************************************************************    S01277
     C*                                                              *    S01277
     C*  SUBROUTINE: #BD   UPDATE FXEPOCLL                           *    S01277
     C*                    ADD IN EXPOSURES FOR THIS DEAL            *    S01277
     C*                    CURRENT AMOUNTS AND NOT REVERSING SIGNS   *    S01277
     C*                                                              *    S01277
     C*  FIELDS USED :                                               *    S01277
     C*                    @RUND  -  RUN DATE (DAY)                  *    S01277
     C*                    @RUNM  -  RUN DATE (MONTH)                *    S01277
     C*                    @RUNY  -  RUN DATE (YEAR)                 *    S01277
     C*                    @USER  -  USER FROM PSDS                  *    S01277
     C*                                                              *    S01277
     C*  CALLED BY :       #BA  UPDATE FXEPOULL                      *    S01277
     C*                                                              *    S01277
     C*  CALLS :           #BCA                                      *    S01277
     C*                                                              *    S01277
     C****************************************************************    S01277
     C     #BD           BEGSR                                                                 S0127
     C*                                                                   S01277
     C** Access positions file.                                           S01277
     C*                                                                   S01277
     C     @EPKEY        CHAIN     FXEPOCLL                           68                       S0127
     C*                                                                   S01277
     C** If record not found currency combination is newly                S01277
     C** set up so need to initialise record                              S01277
     C*                                                                   S01277
     C     *IN68         IFEQ      '1'                                          B1             S0127
     C                   EXSR      #BCA                                         *1             S0127
     C                   MOVE      @EPCCY        FOPCCY                         *1             S0127
     C                   END                                                    E1             S0127
     C*                                                                   S01277
     C** Set up Cross currency total net position (FOCTNP) and            S01277
     C** Cross currency equivalent in primary currency (FOCTEP)           S01277
     C*                                                                   S01277
     C** If action code is insert:                                        S01277
     C*                                                                   S01277
     C     JULACT        IFEQ      'I'                                          B1             S0127
     C     FOCTNP        ADD       @CCAMT        FOCTNP                                        S0127
     C***********FOCTEP    ADD  @CCEQV    FOCTEP                    S01277S01277
     C     FOCTEP        SUB       @CCEQV        FOCTEP                                        S0127
     C                   END                                                    E1             S0127
     C*                                                                   S01277
     C** If action code is delete:                                        S01277
     C*                                                                   S01277
     C     JULACT        IFEQ      'D'                                          B1             S0127
     C     FOCTNP        SUB       @CCAMT        FOCTNP                                        S0127
     C***********FOCTEP    SUB  @CCEQV    FOCTEP                    S01277S01277
     C     FOCTEP        ADD       @CCEQV        FOCTEP                                        S0127
     C                   END                                                    E1             S0127
     C*                                                                   S01277
     C     *IN68         IFEQ      '1'                                          B1             S0127
     C                   WRITE     FXEPOCL1                                     *1             S0127
     C                   ELSE                                                   X1             S0127
     C                   MOVE      @RUND         FODLUP                         *1             S0127
     C                   MOVE      @RUNM         FOMLUP                         *1             S0127
     C                   MOVE      @RUNY         FOYLUP                         *1             S0127
     C                   TIME                    FOTLUP                         *1             S0127
     C                   MOVE      'A'           FOCHTP                         *1             S0127
     C                   MOVE      RUND          FOLCD                          *1             S0127
     C                   MOVEL     @USER         FOLUID                         *1             S0127
     C                   UPDATE    FXEPOCL1                                     *1             S0127
     C                   END                                                    E1             S0127
     C     #BD9          ENDSR                                                                 S0127
     //EJECT                                                              S01277
     C*******************************************************************
     C*                                                               *
     C* ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO     *
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)     *
     C*                                                               *
     C* CALLED BY : #A #B                                             *
     C*                                                               *
     C* CALLS :                                                       *
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
     C*****************************************************************
     //EJECT
     C****************************************************************
     C*                                                              *
     C* ZA0620 - THIS SUBROUTINE CALCULATES THE REVALUATION PROFIT   *
     C*          AND LOSS (IN BASE CCY)                              *
     C*                                                              *
     C* CALLED BY :   #BC                                            *
     C*                                                              *
     C* CALLS :  ZA0640  TO OBTAIN MARKET OUTRIGHT RATE              *
     C*                                                              *
     C* INPUT  : @@ACT   ACTION DATE(MIDAS DAY NO)      (ZA0640)     *
     C*          @@VLDT  VALUE DATE (YYYY/MM/DD)        (ZA0640)     *    E17321
     C*          @@RAMT  AMOUNT                                      *
     C*          @@BCD   DEALT BASE CURRENCY EQUIV    (SIZE : 15,0)  *
     C*          @@RCCY  CURRENCY CODE                  (ZA0640)     *
     C*          @@BYSL  BUY OR SELL RATE REQUIRED      (ZA0640)     *
     C*          CDP     CURRENCY DECIMAL PLACES       (S/TABTG10)   *
     C*          XRMD    EXCHANGE RATE MULTIPLY/DIVIDE (S/TABTG10)   *
     C*                                                              *
     C* OUTPUT : @@RPL   REVALUATION PROFIT/LOSS    (SIZE : 15,0)    *
     C*                                                              *
     C* USES :   @@RBCE  REVALUED BASE CURRENCY EQUIVALENT           *
     C*          @DP     DECIMAL PLACES CORRECTION ARRAY             *
     C*          @@MOR   MARKET OUTRIGHT RATE                        *
     C*          @@NDPB  BASE CURRENCY DECIMAL PLACES                *
     C*          @@P     DECIMAL PLACES CORRECTION ARRAY INDEX       *
     C*          @@DEC   DECIMAL VALUS OF @@RBCE FIELD.              *
     C*          @@MDEC  DECIMAL VALUS OF @@RBCE FIELD AFTER         *
     C*                  DECIMAL CORRECTION.                         *
     C*                                                              *
     C*                                                              *
     C*****************************************************************
     C*
     C     ZA0620        BEGSR
     C*
     C**   OBTAIN MARKET OUTRIGHT RATE
     C                   EXSR      ZA0640
     C     *INU7         CABEQ     '1'           ZA0629
     C*
     C**   CHECK MULTIPLY/DIVIDE INDICATOR
     C***********XRMD******IFEQ 'M'                        B1             S01194
     C     A6MDEX        IFEQ      'M'                                          B1             S0119
     C*
     C**   CALCULATE THE RETURN BASE CURRENCY EQUIVALENT, AND ALSO
     C**   STORE THE RESULTING DECIMAL PLACES.
     C     @@RAMT        MULT      @@MOR         @@RBCE           15 0          *1
     C     @@RAMT        MULT(H)   @@MOR         @@DEC             3 3          *1
     C                   ELSE                                                   X1
     C     @@RAMT        DIV       @@MOR         @@RBCE                         *1
     C     @@RAMT        DIV(H)    @@MOR         @@DEC                          *1
     C                   END                                                    E1
     C*
     C**   CHECK FOR -VE AMOUNT; IF IT IS THEN MAKE IT +VE.
     C     @@RAMT        IFLT      0
     C                   END                                                    E1
     C*
     C**  CORRECT DECIMAL PLACES OF REVALUED BASE CCY EQUIVALENT
     C***********CDP*******SUB  @@NDPB    @@P     10                      S01194
     C     A6NBDP        SUB       @@NDPB        @@P               1 0                         S0119
     C                   ADD       4             @@P
     C     @@RBCE        MULT(H)   @DP(@@P)      @@RBCE
     C     @@DEC         MULT      @DP(@@P)      @@MDEC            6 3
     C*
     C**  CALCULATE EXACT VALUE OF @@RBCE (INCLUDES DEC. PLACES FIGURE)
     C     @@MDEC        ADD(H)    @@RBCE        @@RBCE
     C*
     C**  CALCULATE PROFIT/LOSS
     C     @@RBCE        SUB       @@BCD         @@RPL            15 0
     C*
     C     ZA0629        ENDSR                                                  **ZA0629 TAG**
     //EJECT
     C*****************************************************************
     C*                                                               *
     C* ZA0640 - THIS SUBROUTINE CALCULATES THE FORWARD OUTRIGHT      *
     C*          RATE FOR A DATE AND CURRENCY                         *
     C*                                                               *
     C* CALLED BY :      ZA0620                                       *
     C*                                                               *
     C* CALLS :  ZA0680  TO CONVERT DATES TO MIDAS DAY NUMBER FORMAT  *
     C*                                                               *
     C* INPUT  : @@RCCY  CURRENCY CODE                                *
     C*          @@BYSL  BUY OR SELL RATE REQUIRED                    *
     C*          @@ACT   ACTION DATE (MIDAS DAY NO)                   *
     C*          @@VLDT  VALUE DATE  (YYYY/MM/DD)                     *   E17321
     C*          XRMD    EXCHANGE RATE MULTIPLY/DIVIDE (S/TABTG10)    *
     C*                                                               *
     C* OUTPUT : @@MOR   FORWARD MARKET OUTRIGHT RATE  (SIZE : 13,8)  *
     C*                                                               *
     C* USES :   @@DATD  DATE EXCESS (VALUE DATE AND LOWER LIMIT DATE)*
     C*          @@DATD  DATE DIFFERENCE BETWEEN THE TWO READ'S       *
     C*          @@FCCY  CURRENCY FROM FIRST READ                     *
     C*          @@FRAT  OUTRIGHT RATE FROM FIRST READ (HIGH OR LOW)  *
     C*          @@HRT1  HIGH OUTRIGHT RATE FROM FIRST READ           *
     C*          @@KDCY  KLIST FOR ACCESS TO S/FDCCYTLL (EXPECTED)    *
     C*          @@KREV  KEY FOR READ OF S/FXREVHLL                   *
     C*          @@LRT1  LOW OUTRIGHT RATE FROM FIRST READ            *
     C*          @@PRD1  PERIOD DATE FROM FIRST READ (MIDAS DAY NO.)  *
     C*          @@PRD2  PERIOD DATE FROM SECOND READ (MIDAS DAY NO.) *
     C*          @@RATD  RATE DIFFERENCE BETWEEN THE TWO READ'S       *
     C*          @@SRAT  OUTRIGHT RATE FROM SECOND READ (HIGH OR LOW) *
     C***********@@VDAT**VALUE DATE IN MIDAS DAY NUMBER FORMAT*********   E17321
     C***********@@VTE***VALUE DATE IN ZONED FORMAT********************   E17321
     C*          @@WK5   WORK FIELD                                   *
     C*          @@WK6   WORK FIELD                                   *
     C***********IDCYDL**BASE*CURRENCY*FOR*DEALING.****(S/FDINSTLL)*******S01319
     C*          BNCYDL  BASE CURRENCY FOR DEALING.    (S/SDDEALPD)   *   S01319
     C*          FVCCY   CURRENCY CODE                 (S/FXREVHLL)   *
     C*          FVHORT  HIGH OUTRIGHT RATE            (S/FXREVHLL)   *
     C*          FVLORT  LOW OUTRIGHT RATE             (S/FXREVHLL)   *
     C*          FVPRDT  PERIOD DATE                   (S/FXREVHLL)   *
     C*          SPDT    SPOT DATE                     (S/TABTG10)    *
     C*          XRMD    MULTIPLY/DIVIDE INDICATOR     (S/TABTG10)    *
     C*          *IN85   ERROR/RESULT *IN FOR READ'S (NOT REFERRED TO)*
     C*                                                               *
     C*****************************************************************
     C*
     C     ZA0640        BEGSR
     C*
      *
      **   If the currency requested is Base for dealing, assume
      **     a Rate of 1.00.
     C***********IDCYDL****IFEQ*@@RCCY*********************B1*************S01319
     C     BNCYDL        IFEQ      @@RCCY                                       B1             S0131
     C                   Z-ADD     0001.00       @@MOR                          *1
     C                   ELSE                                                   X1
     C*
     C**  CHECK IF VALUE DATE FROM S/TABTG10 IS BEFORE TWO
     C**  DAYS BEFORE SPOT DATE
     C*********************Z-ADDFXSP      @@DTIN           *1             S01194
     C                   Z-ADD     A6FXSD        @@DTIN                         *1             S0119
     C                   EXSR      ZA0680                                       *1
     C     @@MDNO        SUB       @@ACT         @@WK5             5 0          *1
     C*
     C**  IF SO USE SPOT RATE
     C     @@WK5         IFGT      2                                            B*2
     C*********************Z-ADDSPOT      @@MOR            **2            S01194
     C                   Z-ADD     A6SPRT        @@MOR                          **2            S0119
     C*
     C**  EXIT ROUTINE
     C                   GOTO      ZA0649                                       **2
     C                   END                                                    E*2
     C*
     C**  KEY LIST FOR FXREVHLL READ
     C**  DATE KEY MUST BE ZONED NOT PACKED
     C*********************Z-ADD@@ACT*****@@VTE***************************E17321
     C     @@KREV        KLIST                                                  *1
     C                   KFLD                    @@RCCY                         *1
     C*********************KFLD***********@@VTE***************************E17321
     C                   KFLD                    @@VLDT                         *1             E1732
      *
      **  Clear database field from previous executions.
     C                   MOVE      *BLANKS       FVCCY                          *1
     C*
     C**  SETLL FOR NEXT READP
     C     @@KREV        SETLL     FXREVHP0                                     *1
     C     @@RCCY        READE     FXREVHP0                             8685    *1
     C*
     C**  If record not found, or locked, try for record
     C**   with date less than that provided. Read last
     C**   record for currency.
     C     *IN85         IFEQ      '1'                                          B*2
     C     *IN86         OREQ      '1'                                          B*2
     C     @@RCCY        SETGT     FXREVHP0                                     **2
     C                   READP     FXREVHP0                             8685    **2
      *
      **  No record whatsoever exists for the currency,
      **   perform error processing. Set IN85, cause
      **   Non Extrapolation processing.
     C     @@RCCY        CABNE     FVCCY         ZA0648                         **2
     C                   MOVE      '1'           *IN85                          **2
     C                   END                                                    E*2
     C*
     C**  RECORD EXISTS FOR CCY
     C**         and ACTION DATE = that on file.
     C**         or  ACTION DATE > than any on file.
      *
     C***********@@VTE*****IFEQ*FVPRDT************************************E17321
     C     @@VLDT        IFEQ      FVPRDT                                       B*2            E1732
     C     *IN85         OREQ      '1'                                          B*2
     C*
     C**  CHECK IF HIGH OR LOW OUTRIGHT RATE IS REQUIRED
     C***********XRMD******IFEQ 'M'                        B**3           S01194
     C     A6MDEX        IFEQ      'M'                                          B**3           S0119
     C     @@BYSL        ANDEQ     'B'                                          B**3
     C*
     C***********XRMD******OREQ 'D'                        B**3           S01194
     C     A6MDEX        OREQ      'D'                                          B**3           S0119
     C     @@BYSL        ANDEQ     'S'                                          B**3
     C*
     C**   USE HIGH OUTRATE RATE
     C                   Z-ADD     FVHORT        @@MOR                          ***3
     C                   ELSE                                                   X**3
     C*
     C**   USE LOW OUTRATE RATE
     C                   Z-ADD     FVLORT        @@MOR                          ***3
     C                   END                                                    E**3
     C*
     C**  EXIT ROUTINE
     C                   GOTO      ZA0649                                       **2
     C                   END                                                    E*2
     C*
     C**  SAVE FIRST READ VALUES
     C                   MOVE      FVCCY         @@FCCY                         *1
     C                   MOVE      *BLANKS       FVCCY                          *1
     C*
     C** CONVERT TO MIDAS DAY NUMBER FORMAT
     C                   Z-ADD     FVPRDT        @@DTIN                         *1
     C                   EXSR      ZA0680                                       *1
     C                   Z-ADD     @@MDNO        @@PRD1                         *1
     C                   Z-ADD     FVHORT        @@HRT1                         *1
     C                   Z-ADD     FVLORT        @@LRT1                         *1
     C*
     C**  READ PREVIOUS RECORD
     C                   READP     FXREVHP0                               85
     C*
     C**  MUST EXTRAPOLATE TO GET RATE FOR VALUE DATE
     C     @@FCCY        IFEQ      @@RCCY                                       B*2
     C     FVCCY         ANDEQ     @@RCCY                                       B*2
     C     @@PRD1        ANDGT     @@ACT                                        B*2
     C     *IN85         ANDEQ     '0'                                          B*2
     C*
     C**  CHECK IF HIGH OR LOW OUTRIGHT RATE IS REQUIRED
     C***********XRMD******IFEQ 'M'                        B**3           S01194
     C     A6MDEX        IFEQ      'M'                                          B**3           S0119
     C     @@BYSL        ANDEQ     'B'                                          B**3
     C*
     C***********XRMD******OREQ 'D'                        B**3           S01194
     C     A6MDEX        OREQ      'D'                                          B**3           S0119
     C     @@BYSL        ANDEQ     'S'                                          B**3
     C*
     C**   USE HIGH OUTRATE RATE
     C                   Z-ADD     FVHORT        @@SRAT                         ***3
     C                   Z-ADD     @@HRT1        @@FRAT                         ***3
     C                   ELSE                                                   X**3
     C*
     C**   USE LOW OUTRATE RATE
     C                   Z-ADD     FVLORT        @@SRAT                         ***3
     C                   Z-ADD     @@LRT1        @@FRAT                         ***3
     C                   END                                                    E**3
     C*
     C**  CALCULATION:
     C**  RATE DIFFERENCE
     C     @@FRAT        SUB       @@SRAT        @@RATD                         **2
     C*
     C**  DATE DIFFERENCE
     C**  CONVERT TO MIDAS DAY NUMBER FORMAT
     C                   Z-ADD     FVPRDT        @@DTIN                         **2
     C                   EXSR      ZA0680                                       **2
     C                   Z-ADD     @@MDNO        @@PRD2                         **2
     C*
     C**  DATE EXCESS
     C     @@ACT         SUB       @@PRD2        @@EDAT                         **2
     C*
     C     @@PRD1        SUB       @@PRD2        @@DATD                         **2
     C*
     C     @@EDAT        DIV(H)    @@DATD        @@WK6            10 9          **2
     C     @@WK6         MULT(H)   @@RATD        @@MOR                          **2
     C                   ADD       @@SRAT        @@MOR                          **2
     C*
     C**  EXIT ROUTINE
     C                   GOTO      ZA0649                                       **2
     C                   END                                                    E*2
     C*
     C**  ONLY ONE REVALUATION RECORD FOR THIS CCY SO CANNOT EXTRAPOLATE
     C     @@FCCY        IFEQ      @@RCCY                                       B*2
     C     FVCCY         ANDNE     @@RCCY                                       B*2
     C*
     C*
     C**  CHECK IF HIGH OR LOW OUTRIGHT RATE IS REQUIRED
     C***********XRMD******IFEQ 'M'                        B**3           S01194
     C     A6MDEX        IFEQ      'M'                                          B**3           S0119
     C     @@BYSL        ANDEQ     'B'                                          B**3
     C*
     C***********XRMD******OREQ 'D'                        B**3           S01194
     C     A6MDEX        OREQ      'D'                                          B**3           S0119
     C     @@BYSL        ANDEQ     'S'                                          B**3
     C*
     C**   USE HIGH OUTRATE RATE
     C                   Z-ADD     @@HRT1        @@MOR                          ***3
     C                   ELSE                                                   X**3
     C*
     C**   USE LOW OUTRATE RATE
     C                   Z-ADD     @@LRT1        @@MOR                          ***3
     C                   END                                                    E**3
     C*
     C**  EXIT ROUTINE
     C                   GOTO      ZA0649                                       **2
     C                   END                                                    E*2
     C*
     C**  ONLY ONE REVALUATION RECORD FOR THIS CCY SO CANNOT EXTRAPOLATE
     C     FVCCY         IFEQ      @@RCCY                                       B*2
     C     @@FCCY        ANDNE     @@RCCY                                       B*2
     C*
     C*
     C**  CHECK IF HIGH OR LOW OUTRIGHT RATE IS REQUIRED
     C***********XRMD******IFEQ 'M'                        B**3           S01194
     C     A6MDEX        IFEQ      'M'                                          B**3           S0119
     C     @@BYSL        ANDEQ     'B'                                          B**3
     C*
     C***********XRMD******OREQ 'D'                        B**3           S01194
     C     A6MDEX        OREQ      'D'                                          B**3           S0119
     C     @@BYSL        ANDEQ     'S'                                          B**3
     C*
     C**   USE HIGH OUTRATE RATE
     C                   Z-ADD     FVHORT        @@MOR                          ***3
     C                   ELSE                                                   X**3
     C*
     C**   USE LOW OUTRATE RATE
     C                   Z-ADD     FVLORT        @@MOR                          ***3
     C                   END                                                    E**3
     C*
     C**  EXIT ROUTINE
     C                   GOTO      ZA0649                                       **2
     C                   END                                                    E*2
     C*
     C**  ANY OTHER RESULTS MUST BE A DATABASE ERROR
     C     ZA0648        TAG                                                    **ZA0648 TAG**
     C                   MOVE      @@RCCY        DBKEY                          ***************
     C                   MOVEL     'FXREVHLL'    DBFILE                         * DB ERROR 920*
     C                   MOVE      '920'         DBASE                          ***************
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
     C                   DUMP                                                   *1             AB020
      *
     C                   END
      *                                                    E1
     C*
     C**  FIELD DEFINITIONS
     C     *LIKE         DEFINE    @@MDNO        @@EDAT
     C     *LIKE         DEFINE    FVHORT        @@RATD
     C     *LIKE         DEFINE    FVCCY         @@FCCY
     C********** *LIKE*****DEFN SPOT      @@MOR                           S01194
     C     *LIKE         DEFINE    A6SPRT        @@MOR                                         S0119
     C************LIKE*****DEFN*FVPRDT****@@VTE***************************E17321
     C     *LIKE         DEFINE    @@MDNO        @@PRD1
     C     *LIKE         DEFINE    FVHORT        @@HRT1
     C     *LIKE         DEFINE    FVLORT        @@LRT1
     C     *LIKE         DEFINE    FVHORT        @@SRAT
     C     *LIKE         DEFINE    FVHORT        @@FRAT
     C     *LIKE         DEFINE    @@MDNO        @@PRD2
     C     *LIKE         DEFINE    @@MDNO        @@DATD
      *
     C                   GOTO      ZA0649
      *  FOR DEFN ONLY.
     C                   MOVE      @@BYSL        @@BYSL            1
     C                   Z-ADD     @@DBCE        @@DBCE           15 0
     C*
     C     ZA0649        ENDSR                                                  **ZA0649 TAG**
     C*****************************************************************
     //EJECT
     C*****************************************************************
     C*       ZA0870      :                                           *
     C*                                                               *
     C********FIELDS*USED*:*IDCYDL*-*CURRENCY*CODE*FROM*FDINSTLL**********S01319
     C*       FIELDS USED : BNCYDL - CURRENCY CODE FROM SDDEALPD      *   S01319
     C*                     @@NDPB - NO.OF DEC.PLACES IN BASE CURR.   *
     C*                                                               *
     C********INPUT*FIELDS:*IDCYDL****************************************S01319
     C*       INPUT FIELDS: BNCYDL                                    *   S01319
     C*                                                               *
     C*       OUTPUT FIELD: @@NDPB                                    *
     C*                                                               *
     C*   CHECKS MADE ARE :                                           *
     C*                                                               *
     C*   A) IF RECORD NOT FOUND ON LOGICAL FILE 'FDCCYDL' OR         *
     C***********'FDINSTLL'*SETON*INDICATORS*U7*,*U8*&*80*****************S01319
     C*          'SDDEALPD' SETON INDICATORS U7 , U8 & 80             *   S01319
     C*            AND EXIT                                           *
     C*      ELSE                                                     *
     C*           STORE CDP IN FIELD @@NDPB.                          *
     C*                                                               *
     C*   CALLED BY:  #A                                              *
     C*****************************************************************
     C*
     C     ZA0870        BEGSR
     C*
     C********** *LIKE*****DEFN CDP       @@NDPB                          S01194
     C     *LIKE         DEFINE    A6NBDP        @@NDPB                                        S0119
     C                   Z-ADD     0             @@NDPB
      *
      *  Access Installation control data for Base Currency Dealing.
     C***********1*********SETLLFDINSTLL**********************************S01319
     C*********************READ*FDINSTLL*****************80***************S01319
     C********************************************************************S01319
     C************IN80*****IFEQ*'1'************************B1*************S01319
     C*********************SETON*********************U7U8***1*************S01319
     C*********************MOVEL'FDINSTLL'DBFILE************1*************S01319
     C**********         CALL      'AODEALR0'                                           S0131 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '       '     @RTCD             7                           S0131
     C                   PARM      '*FIRST '     @OPTN             7                           S0131
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                  S0131 CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                      B1             S0131
     C                   SETON                                        U7U8      *1             S0131
     C                   MOVEL     'SDDEALPD'    DBFILE                         *1             S0131
     C                   MOVEL     '922'         DBASE                          *1
     C                   MOVEL     *BLANKS       DBKEY                          *1
     C                   DUMP                                                   *1             AB020
     C                   GOTO      ZA0879
     C                   END
      *                                                                   S01319
     C                   CALL      'AOTRMAR0'                                                  S0131
     C                   PARM      '       '     @RTCD             7                           S0131
     C                   PARM      '*FIRST '     @OPTN             7                           S0131
     C     SDTRMA        PARM      SDTRMA        DSFDY                                         S0131
     C     @RTCD         IFNE      *BLANKS                                      B1             S0131
     C                   SETON                                        U7U8      *1             S0131
     C                   MOVEL     'SDTRMAPD'    DBFILE                         *1             S0131
     C                   MOVEL     '923'         DBASE                          *1             S0131
     C                   MOVEL     *BLANKS       DBKEY                          *1             S0131
     C                   DUMP                                                   *1             S0131
     C                   GOTO      ZA0879                                                      S0131
     C                   END                                                                   S0131
      *
     C*********************MOVEL'20      '@@1200 12                       S01194
     C*********************MOVE '1'       @@1201  4                       S01194
     C*********************MOVELIDCYDL    @@1201                          S01194
     C*********************MOVE @@1201    @@1200                          S01194
      *********************                                               S01194
      *  Access Currency file for Base decimal places.                    S01194
     C***********@@1200****CHAINFDCCYTLL             80                   S01194
      *********************                                               S01194
     C********** *IN80*****IFEQ '1'                        B1             S01194
     C                   CALL      'AOCURRR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*KEY   '     @OPTN             7                           S0119
     C*********************PARM*IDCYDL****@AJCD***3*****************S01194S01319
     C                   PARM      BNCYDL        @AJCD             3                           S0131
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                                     S0119
     C                   SETON                                        U7U8      *1
     C*********************MOVEL'FDCCYTLL'DBFILE           *1             S01194
     C                   MOVEL     'SDCURRPD'    DBFILE                                        S0119
     C                   MOVEL     '921'         DBASE                          *1
     C                   MOVEL     @OPTN         DBOPTN                                        S0119
     C*********************MOVEL@@1200    DBKEY            *1             S01194
     C*********************MOVELIDCYDL****DBKEY*************1*******S01194S01319
     C                   MOVEL     BNCYDL        DBKEY                          *1             S0131
     C                   DUMP                                                   *1             AB020
     C                   GOTO      ZA0879
     C                   END
     C*
     C*********************Z-ADDCDP       @@NDPB                          S01194
     C                   Z-ADD     A6NBDP        @@NDPB                                        S0119
     C*
     C     ZA0879        ENDSR
     C*****************************************************************
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
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA @DP
1000000010000000100000001000000010000000100000001
**CTDATA @YD
00366007310109601461
**CTDATA @MD
00000000310005900090001200015100181002120024300273003040033400365
**CTDATA TAB1
OVR 0D
TOMN1D
SPN 2D
SP1W1W
SP2W2W
SP3W3W
SP1M1M
SP2M2M
SP3M3M
SP6M6M
SP9M9M
SPYR1Y
