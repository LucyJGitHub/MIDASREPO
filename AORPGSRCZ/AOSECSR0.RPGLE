     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Securities clients')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AOSECSR0 - READ ACCESS TO SECURITIES CLIENTS CODES FILE      *
     F*                                                                  *
     F*  (c) Finastra International Limited 2001                         *
     F*                                                                  *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 202355             Date 29Jan02               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039             Date 29Mar00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CAP003             DATE 06AUG98               *
     F*                 S01496             DATE 15AUG94               *
     F*                    S01464             DATE 12AUG94               *
     F*                    S01230             DATE 23/11/89              *
     F*                    S01230             DATE 06/11/89              *
     F*                                                                  *
     F********************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE042 - Auto Feed of Trades and Movements (Recompile)       *
      *  CSE041 - DVP/RVP Processing (Recompile)                      *
      *  CSE039 - Automatic Settlement of Trades (Recompile)          *
      *  202355 - Using a CALLB rather than a CALL to AOCUSTR0        *
      *           results in a lost pointer.                          *
      *  CSE022 - Depository Definition Enhancement                   *
     F*  CSD007 - Customer Closing:                                   *
     F*           Access main customer details using AOCUSTR0.        *
      *     CAP039 - Conversion of SD inputs into modular structure to   *
      *              use as APIs. SECURITY CUSTOMER DETAILS API          *
     F*     CAP003 - Member converted from an OPM program to an ILE      *
     F*              module and an ILE *PGM member of the same name has  *
     F*              been created (in AOPGMSRC).                         *
     F*              ILE modules can make a bound call to the module.    *
     F*              OPM programs can make a dynamic call to the *PGM.   *
     F*     S01496 - RECOMPILED FOR JYSKE ENHANCEMENTS.                  *
     F*     S01464 - RECOMPILED FOR SAFE CUSTODY FEES                    *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                         *
     F********************************************************************S01230
     F*
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE - SDSECSL1
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR
     F*       99       SEND MESSAGE ERROR
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDSECSL1  IF   E           K DISK    USROPN
      * IN  - @BFREDQ Securities Clients (CUST)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D*                                                                   S01230
     D********************************************************************S01230
      ************************************************************        S01230
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
     D***********D@FMT     E DSSDSECSD0                                   S01230
     D D@FMT         E DS                  EXTNAME(SDSECSPD)                    S01230
      * @BFREDQ - Securities Clients record format data structure
      *
     D***P@FMT         E DS                  EXTNAME(DSSDY)                            S01230 CSD007
     D***P@FMT**       E DS                  EXTNAME(DSFDY)                            CSD007 CSE022
     D P@FMT         E DS                  EXTNAME(DSSDY)                                     CSE022
     D                                     PREFIX(ES)                                         CSE022
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT        S01230
     D* OF THE FILE.                                                      S01230
      *                                                                   S01230
     D*******P@FMT       DS                            158                S01230
     D*******                                 1 158 P@DMMY                S01230
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD007
      * SDCUSTP0 - Customer Details                                                           CSD007
      *                                                                                       CSD007
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD007
      * External Data structure for accessin customer details                                 CSD007
      *                                                                                       CSD007
     D P@CUST          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
     D  W@SL04                 4      4
     D  W@SL05                 5      5
     D  W@SL06                 6      6
      *
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@CUST                         I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDSECSL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROG
     C                   CLOSE     SDSECSL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     *LOVAL        SETLL     @BFREDQ                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C                   READ      @BFREDQ                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     *HIVAL        SETGT     @BFREDQ                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C                   READP     @BFREDQ                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACC
     C     P@OPTN        OREQ      '*VERIFY'                                      OR
     C     W@SL01        IFEQ      '?'                                          IF 8 SELECT
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C     W@SL04        OREQ      '?'                                           OR
     C     W@SL05        OREQ      '?'                                           OR
     C     W@SL06        OREQ      '?'                                           OR
     C*********************CALL 'SDMXSRR'              98    <SELECT>     S01230
     C                   CALL      'SD0340S'                            98        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C*********************PARM *BLANK    P@AENB             B:Key        S01229
     C                   PARM      *BLANK        P@CUST                           B:Key        S0122
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C***********P@AENB    CHAIN@BFREDQ              9590    Get record   S01229
     C     P@CUST        CHAIN     @BFREDQ                            9590        Get record   S0122
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
      *                                                                                       CSD007
     C**********         CALLB     'AOCUSTR0'                                          CSD007 202355
     C                   CALL      'AOCUSTR0'                                                 202355
     C                   PARM      P@RTCD        RTCD              7                          CSD007
     C                   PARM      '*KEY   '     OPTN              7                          CSD007
     C                   PARM      P@CUST        KEYC             10                          CSD007
     C                   PARM      *BLANKS       KYST              7                          CSD007
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD007
      *                                                                                       CSD007
     C     RTCD          IFNE      *BLANKS                                                    CSD007
     C                   MOVEL     *ON           *IN95                                        CSD007
     C                   END                                                                  CSD007
      *                                                                                       CSD007
     C     *IN95         CABEQ     '1'           T@SKIP                                       CSD007
      *                                                                                       CSD007
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter err
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
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 13
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C*          P@OPTN    ANDNE'*OPTION'                    AND          E01168
     C     P@RTCD        ANDNE     '*OPTION'                                      AND          E0116
     C                   MOVEL     D@FMT         P@FMT                          FI 13
     C                   END
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
AOSECSPD  AOSECSR0  Securities Clients
**CTDATA CPY@
(c) Finastra International Limited 2001
