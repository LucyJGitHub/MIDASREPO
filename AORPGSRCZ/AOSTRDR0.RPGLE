     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP003
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Securities trading ICD access obj')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS                                           *
     F*                                                                  *
     F*     AOSTRDR0 - READ ACCESS TO SECURITIES TRADING DATA            *
     F*                                                                  *
     F*  (c) Finastra International Limited 2001                         *
     F*                                                                  *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
     F*                 CSE006             Date 17Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                    137886             DATE 14Jul98               *
     F*                  . CAP003             DATE 06AUG98               *
     F*                    CSE007             Date  1Dec97               *
     F*                    CAC001             DATE 05DEC95               *
     F*                    S01502             DATE 25JUL94               *
     F*                    S01448             DATE 11OCT93               *
     F*                    S01446             DATE 11OCT93               *
     F*                    S01230             DATE 23/11/89              *S01230
     F*                    S01230             DATE 06/11/89              *S01230
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *  MD046248 - Finastra Rebranding                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha                 *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                   *
     F*  CSE006 - Recompile only                                         *
     F*  137886 - Corporate Actions: Add the possibility to allocate     *
     F*           (or not) the balancing difference directly to the      *
     F*           Dummy Customer.                                        *
     F*           (Just recompiled)                                      *
     F*     CAP003 - Member converted from an OPM program to an ILE      *
     F*              module and an ILE *PGM member of the same name has  *
     F*              been created (in AOPGMSRC).                         *
     F*              ILE modules can make a bound call to the module.    *
     F*              OPM programs can make a dynamic call to the *PGM.   *
     F*     CSE007 - Corporate Actions. Recompile only.                  *
     F*     CAC001 - Profit Centre Accounting: Addition of               *
     F*              FX Profit Centre.                                   *
     F*     S01502 - BLI Telekurs Processing                             *
     F*              - Recompiled over changed SDSTRDPD.                 *
     F*     S01448 - BULK INPUT ENHANCEMENTS:                            *
     F*              - ADD 'DEFAULT AGENCY TRADE' FIELD.                 *
     F*              - ADD 'REVIEW BULK TRADES DEFAULT' FIELD.           *
     F*              - ADD 'ALLOW TRADES BETWEEN PORTFOLIO               *
     F*                CUSTOMERS' FIELD.                                 *
     F*     S01446 - CUSTOMER COMMISSIONS DEVELOPMENT:                   *
     F*              - ADD 'CHARGES CURRENCY' FIELD.                     *
     F*              - ADD 'ADJUST COMMISSIONS SAME DAY TRADE' FIELD.    *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                         *S01230
     F********************************************************************S01230
     F* ID F  C  H  L  FUNCTION OF INDICATORS
     F*
     F*       01       OFF ON THE FIRST RUN
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       96       OPTION ERROR
     F*
      /EJECT
     F*FSTART
      ************************************************************
     FSDSTRDL1  IF   E           K DISK    USROPN
      * IN  - @BVREFF SECURITIES TRADING DATA (CBCD)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D*                                                                   S01230
     D********************************************************************S01230
     D********************************************************************S01230
      /EJECT
     D*ISTART
      ************************************************************
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D*******D@FMT     E DSSDSTRDD0                                       S01230
     D D@FMT         E DS                  EXTNAME(SDSTRDPD)                    S01230
      * @BVREFF - SECURITIES TRADING RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)                       S01230
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT        S01230
     D* OF THE FILE.                                                      S01230
      *                                                                   S01230
     D********P@FMT       DS                                              S01230
     D********                                1 181 BKCOPY                S01230
      *
      ************************************************************
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
      ************************************************************        S01230
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      D@FMT         P@FMT                          O:Format
      *****************************************************
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       9396       ¦ error
     C     P@OPTN        IFEQ      '*KEY'
     C     P@OPTN        OREQ      '*FIRST'
     C     P@OPTN        OREQ      '*LAST'
     C     P@OPTN        OREQ      '*NEXT'
     C     P@OPTN        OREQ      '*PREV'
     C     P@OPTN        OREQ      '*FREE'
     C     P@OPTN        OREQ      '*VERIFY'
     C     P@OPTN        OREQ      '*SAME'
     C     *IN01         IFEQ      '0'                                            IF2
     C                   SETON                                        01
     C                   OPEN      SDSTRDL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     *LOVAL        SETLL     @BVREFF                            9390        Set file
     C  N93              READ      @BVREFF                                93
     C                   CLOSE     SDSTRDL1                             92        Close file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                      FI2
     C                   ELSE
     C                   SETON                                        96          Parm error
     C                   END
      *
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
     C   96              MOVE      '*OPTION'     P@RTCD                         No selection
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   96              MOVE      'ACO1007'     P@MGID
     C                   CALLB     'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
AOSTRDPD  AOSTRDR0  Securities Trading Data
**CTDATA CPY@
(c) Finastra International Limited 2001
