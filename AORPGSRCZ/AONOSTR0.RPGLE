     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Nostro details access object')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AONOSTR0 - READ ACCESS TO NOSTRO DETAILS FILE                *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 210796             Date 22Nov02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 196833             Date 16Aug01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
     F*                     S01437            DATE 27OCT93               *
     F*                     LN1118            DATE 29MAY91               *
     F*                     S01230            DATE 01FEB90               *S01230
     F*                     S01230            DATE 23NOV89               *S01230
     F*                     S01230            DATE 06NOV89               *S01230
     F*                     S01230            DATE 23OCT89               *S01230
     F*                     E01168            DATE 27APR89               *
     F*                                                                  *
     F********************************************************************
      *                                                                  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  210796 - Extend Our a/c at Nostro field                      *
      *  196833 - Additional SWIFT Address for CLS Nostros (Recompile)*
      *  CDL008 - Continuous Linked Settlement. Recompile.               *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*      S01437 - MIDAS EXPORT MODULE DEVELOPMENT:                   *
     F*               - RECOMPILED OVER CHANGED SDNOSTPD.                *
     F*      LN1118 - CORRECT THE ERROR CODES THAT ARE RETURNED          *
     F*      S01230 - STANDARDISE ACCESS PROGRAM & COPYRIGHT ADDED    *   S01230
     F*      S01168 - Upgrade to release 10                              *S01168
     F*      S01168 - Standardise Access Programs                        *S01168
     F*                                                                  *S01168
     F*  ID  F  C  H  L    FUNCTION OF INDICATORS                        *
     F*                                                                  *
     F*         01      OFF 1ST TIME ROUND                               *
     F*         26      QUESTION MARK IN KEY FIELDS                      *S01230
     F*         90      FILE ERROR                                       *
     F*         91      FILE OPEN ERROR                                  *
     F*         92      ERROR ON FILE CLOSE                              *
     F*         93      FILE EMPTY                                       *
     F*         94      EOF                                              *
     F*         95      NO RECORD FOUND                                  *
     F*         96      PARAMETER ERROR                                  *
     F*         LR      LAST RECORD                                      *
     F*                                                                  *
      ********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDNOSTL0  IF   E           K DISK    USROPN
      * IN  - @A7REBE Nostros          (CYCD¦NONB)
      *...........................................................
     F*DNOSTL4IF**E***********K        DISK                           UC  S01168
      **IN**-*@NOSTF4*Nostros**********(CUST¦CYCD¦ACCD¦ACSN)              S01168
     FSDNOSTL2  IF   E           K DISK    USROPN                               S01168
      * IN  - @NOSTBH Nostros          (CUST¦CYCD¦ACCD¦ACSN¦BRCD)         S01230
     FSDNOSTL6  IF   E           K DISK    USROPN                               S01230
      * IN  - @NOSTIG                  (CUST¦CYCD¦PNOI)                   S01230
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
     D @QM             S              1    DIM(5) ASCEND                                         S01
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D********************************************************************S01230
      ************************************************************
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
     D*D@FMT     E DSSDNOSTD0                                             S01230
     D D@FMT         E DS                  EXTNAME(SDNOSTPD)                    S01230
      * @A7REBE - Nostro record format data structure
      *
     D*P@FMT       DS                             61                      E01168
     D*                                      61  61 P@DMMY                E01168
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D*                                                                   S01230
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT OF     S01230
     D* THE FILE                                                          S01230
     D******P@FMT       DS                             74         E01168  S01230
     D******                                 74  74 P@DMMY        E01168  S01230
      *
     D************P@KEYD      DS                                          S01230
     D P@ACSN          DS                                                       S01230
      * Account Sequence character->zoned conversion data structure
     D****************************************1   20W@KEYD                S01230
     D  W@ACSN                 1      2  0                                      S01230
      *
     D P@KEYS          DS                                                       S01230
     D****************************************1   3 WUKEYB                S01230
     D****************************************4   5 WUKEYE                S01230
     D  WUCYCD                 1      3                                         S01230
     D  WUNONB                 4      5                                         S01230
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option       S0123
     C*********************PARM           P@KEYA  6        I:Key field A  S01230
     C*********************PARM           P@KEYB  3        I:Key field B  S01230
     C*********************PARM           P@KEYC  4        I:Key field C  S01230
     C*********************PARM           P@KEYD  2        I:Key field D  S01230
     C*********************PARM           P@KEYE  2        I:Key field E  S01230
     C                   PARM                    P@CUST            6            I:Customer No  S0123
     C                   PARM                    P@CYCD            3            I:Currency     S0123
     C**********         PARM                    P@ACCD            4         I:A/c Code S0123 CGL029
     C                   PARM                    P@ACCD           10                          CGL029
     C                   PARM                    P@ACSN            2            I:A/c Seq      S0123
     C                   PARM                    P@NONB            2            I:Nostro No    S0123
     C                   PARM                    P@BRCD            3            I:Branch Code  S0123
     C                   PARM                    P@CSSN           10            I:Cust ShortN  S0123
     C                   PARM                    P@PNOI            1            I:Prime Nost InS0123
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
     C     K@CSPN        KLIST                                                                 S0123
     C                   KFLD                    P@CSSN                           Cust ShNam   S0123
     C                   KFLD                    P@CYCD                           Currency     S0123
     C                   KFLD                    P@PNOI                           Prime Nost InS0123
      *
     C     K@A7RE        KLIST                                                  Nostro ID      S0123
     C*********************KFLD           P@KEYB             Currency     S01230
     C*********************KFLD           P@KEYE             Nostro No.   S01230
     C                   KFLD                    P@CYCD                           Currency     S0123
     C                   KFLD                    P@NONB                           Nostro No.   S0123
      *                                                                   S01230
     C     K@NOST        KLIST                                                  Account ID
     C*********************KFLD           P@KEYA             Customer     S01230
     C*********************KFLD           P@KEYB             Currency     S01230
     C*********************KFLD           P@KEYC             Acc.code     S01230
     C*********************KFLD           W@KEYD             Acc.seq.     S01230
     C                   KFLD                    P@CUST                           Customer     S0123
     C                   KFLD                    P@CYCD                           Currency     S0123
     C                   KFLD                    P@ACCD                           Acc.code     S0123
     C                   KFLD                    W@ACSN                           Acc.seq.     S0123
     C                   KFLD                    P@BRCD                           Branch code  S0123
      *
     C/COPY WNCPYSRC,AONOSTR0C1
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME '
     C     *IN01         COMP      '0'                                    91
     C     *IN02         IFEQ      '1'
     C                   SETOFF                                       91
     C                   END
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       506070     ¦             S0123
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      *
      * Check file to use :
      *
     C***********P@KEYA    IFNE *BLANK                     IF    ¦FULL    S01230
     C***********P@KEYB    ANDNE*BLANK                      AND  ¦ACCOUNT S01230
     C***********P@KEYC    ANDNE*BLANK                      AND  ¦ID      S01230
     C***********P@KEYD    ANDNE*BLANK                      AND           S01230
     C     P@CUST        IFNE      *BLANK                                       IF    ¦FULL    S0123
     C     P@CYCD        ANDNE     *BLANK                                        AND  ¦ACCOUNT S0123
     C     P@ACCD        ANDNE     *BLANK                                        AND  ¦ID      S0123
     C     P@ACSN        ANDNE     *BLANK                                        AND           S0123
     C     P@BRCD        ANDNE     *BLANK                                        AND           S0116
     C                   SETON                                        50          Set ind.
     C                   END                                                    FI
      *
     C***********P@KEYB    IFNE *BLANK                     IF    ¦NOSTRO  S01230
     C***********P@KEYE    ANDNE*BLANK                      AND  ¦ID      S01230
     C     *IN50         IFNE      '1'                                          IF 1 --.       S0123
     C     P@CYCD        IFNE      *BLANK                                       IF 2 -.NOSTRO  S0123
     C     P@NONB        ANDNE     *BLANK                                        AND  ¦ID      S0123
     C*********************SETOF                     50      Set ind.     S01230
     C                   SETON                                        60          Set ind.     S0123
     C                   END                                                    FI 2 -'¦       S0123
     C                   END                                                    FI 1 --'       S0123
      *
     C     *IN50         IFNE      '1'                                          IF 1           S0123
     C     *IN60         ORNE      '1'                                                         S0123
     C     P@CSSN        IFNE      *BLANK                                       IF 2 -.        S0123
     C     P@CYCD        ANDNE     *BLANK                                        AND  ¦        S0123
     C                   SETON                                        70          Set ind.     S0123
     C                   END                                                    FI 2 -'        S0123
     C                   END                                                    FI 1           S0123
      *                                                                   S01230
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 1           S0123
     C     *IN50         IFEQ      '0'                                            IF 2         S0123
     C     *IN60         ANDEQ     '0'                                                         S0123
     C     *IN70         ANDEQ     '0'                                                         S0123
     C                   SETON                                        97                       S0123
     C                   GOTO      T@SKIP                                                      S0123
     C                   END                                                      FI 2         S0123
     C                   END                                                    FI 1           S0123
      *                                                                   S01230
     C     P@OPTN        IFNE      '*KEY   '                                    IF NOT KEYED
     C     P@OPTN        ANDNE     '*VERIFY'                                      OR
     C*********************SETOF                     50      Nostro AccessS01230
     C                   SETOFF                                       5070                     S0123
     C                   SETON                                        60                       S0123
     C                   END                                                    FI
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF   FIRST TIME
     C     *IN50         ANDEQ     '1'                                           AND ACC.ACCESS
     C                   SETON                                        01          Set ind.
     C*********************OPEN SDNOSTL4               91    Open file    S01168
     C                   OPEN      SDNOSTL2                             91        Open file    S0116
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *
     C     *IN02         IFEQ      '0'                                          IF   FIRST TIME
     C************IN50     ANDEQ'0'                         AND NOSTRO ACCS01230
     C     *IN60         ANDEQ     '1'                                           AND NOSTRO ACCS0123
     C                   SETON                                        02          Set ind.
     C                   OPEN      SDNOSTL0                             91        Open file    S0123
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI
      *                                                                   S01230
     C     *IN03         IFEQ      '0'                                          IF   FIRST TIMES0123
     C     *IN70         ANDEQ     '1'                                           AND ACC ACCESSS0123
     C                   SETON                                        03          Set ind.     S0123
     C                   OPEN      SDNOSTL6                             91        Open file    S0123
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error   S0123
     C                   END                                                    FI             S0123
      *
      * Last call - close files and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF FREE PROGORD
     C***01****************CLOSESDNOSTL4               92    Close file   S01168
     C   01              CLOSE     SDNOSTL2                             92        Close file   S0116
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C   02              CLOSE     SDNOSTL0                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C   03              CLOSE     SDNOSTL6                             92        Close file   S0123
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error  S0123
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF FIRST RECORD
     C     *LOVAL        SETLL     @A7REBE                            9390        Set file
     C/COPY WNCPYSRC,AONOSTR0C2
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF NEXT RECORD
     C                   READ      @A7REBE                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF LAST RECORD
     C     *HIVAL        SETGT     @A7REBE                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF PREV.RECORD
     C                   READP     @A7REBE                              9094      Read record
     C/COPY WNCPYSRC,AONOSTR0C3
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                    OR
     C*********************MOVELP@KEYB    WUKEYB                          S01230
     C*********************MOVELP@KEYE    WUKEYE                          S01230
     C                   MOVEL     P@CYCD        WUCYCD                                        S0123
     C                   MOVEL     P@NONB        WUNONB                                        S0123
     C                   MOVEA     P@KEYS        @QM                                           S0123
     C                   MOVEL     '?'           QMCHK             1
     C     QMCHK         LOOKUP    @QM                                    26      CHECK ?      S0123
     C     *IN26         IFEQ      '1'                                          IF 8 selection S0123
     C*********************CALL 'SDJ6SRR'              98    <SELECT>     S01230
     C                   CALL      'SD0151S'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return codeS0123
     C*********************PARM *BLANK    P@KEYB             B:Key A      S01230
     C*********************PARM *BLANK    P@KEYE             B:Key B      S01230
     C                   PARM      *BLANK        P@CYCD                           B:Currency   S0123
     C                   PARM      *BLANK        P@NONB                           B:Nostro No  S0123
     C     P@RTC2        COMP      *BLANK                             97          No selection S0123
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection S0123
     C     *IN98         CABEQ     '1'           T@SKIP                           Program errorS0123
     C                   END                                                                   S0123
     C**N50******K@A7RE****CHAIN@A7REBE              9590    Get record   S01230
     C   60K@A7RE        CHAIN     @A7REBE                            9590        Get record   S0123
     C***50******K@NOST****CHAIN@NOSTF4              9590    Get record   S01168
     C***50******K@NOST    CHAIN@NOSTHI              9590    Get record   S01168
     C   50K@NOST        CHAIN     @NOSTBH                            9590        Get record   S0116
     C   70K@CSPN        CHAIN     @NOSTIG                            9590        Get record   S0123
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C/COPY WNCPYSRC,AONOSTR0C4
     C                   END                                                    FI 7
      *
      * Check option :
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 10 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter error
     C                   END                                                    FI 10
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
      * No record found or End of file - return error code :
      *
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C***97****************MOVE '*KEY   ' P@RTCD           Invalid S01230 LN1118
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection   LN111
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.LN111
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 11 SEND MSG.
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No record found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C***97****************MOVE 'ACO1008' P@MGID             InvaliS01230 LN1118
     C   97              MOVE      'ACO1009'     P@MGID                           No selection LN111
     C   98              MOVE      'ACO1010'     P@MGID                           Call error   LN111
     C                   CALLB     'ZASNMG'                                       <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
     C                   END                                                    FI 11
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 13
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
     C                   MOVEL     D@FMT         P@FMT                          FI 13
     C                   END
      *
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDNOSTPD  AONOSTR0  Nostro Details
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
