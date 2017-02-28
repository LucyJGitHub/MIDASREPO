     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXS *  RPGCVTOPT2                                                   *                       CSD053
/*EXI *  TEXT('Midas AO Alternative names and address')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AOALTNR0 - READ ACCESS TO ALTERNATIVE                        *
     F*                NAMES AND ADDRESSES CODE FILES                    *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      *  Last Amend No. MD043685           Date 23Jan17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 133773             Date 25Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 185134             Date 11Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 159529             Date 14May99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CAP003             Date 06Aug98               *S01522
     F*                 137928             DATE 29Jun98               *S01522
     F*                    097960             DATE 22DEC95               *S01522
     F*                    093368             DATE 19SEP95               *S01522
     F*                    088567             DATE 04MAY95               *S01522
     F*                    S01522             DATE 19OCT94               *S01522
     F*                    S01117             DATE 26APR90               *S01230
     F*                    S01230             DATE 23/11/89              *S01230
     F*                    S01230             DATE 06/11/89              *S01230
     F*                                                                  *
     F*****************************************************************   S01230
     F*                                                               *
      *  MD043685 - If CCG024 is on, alternate address must be        *
      *             retrieved from SDALTNPD.                          *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  133773 - Key for CGCORRL1 needs only to be customer number.  *
      *         - Fix was applied by CER001 enhancement.              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  185134 - Retail advise (RE0880) not showing alternate address*
      *           set in UDC. Fix is to get address details from      *
      *           PF/SDCUSTPD if address in CGCORRPD is blank.        *
     F*  159529 - PM0710 shows wrong details for Alternate Addresses  *
     F*           when S05123 is on.  Program does not access         *
     F*           PF/CGCORRPD, fix is to access PF/CGCORRPD for       *
     F*           *KEYFST parameter and put 'C' to address code if    *
     F*           S01523 is on.                                       *
     F*     CAP003 - Member converted from an OPM program to an ILE      *
     F*              module and an ILE *PGM member of the same name has  *
     F*              been created (in AOPGMSRC).                         *
     F*              ILE modules can make a bound call to the module.    *
     F*              OPM programs can make a dynamic call to the *PGM.   *
     F*     137928 - Error accessing Alt Name & Address from GL3271   *
     F*     097960 - Part of 093368 missed out                        *
     F*     093368 - Add new option '*KEYFST' to access first         *
     F*              alternative address for a customer.              *
     F*     088567 - Do not pass back CGCORRPD, map fields to SDALTNPD*   S01522
     F*     S01522 - Add User Defined Correspondence processing       *   S01522
     F*     S01117 - CHANGE CALL TO SELECT RECORD TO NEW NAME         *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                      *   S01230
     F*                                                               *
     F*****************************************************************   S01230
     F*                                                               *
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE - SDALTNL1
     F*       50       CHECK FOR 1ST KEY CONTAINING A ?  LEN: 6 CHARS
     F*       51       CHECK FOR 2ND KEY CONTAINING A ?  LEN: 1 CHAR
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
     FSDALTNL1  IF   E           K DISK    USROPN
      * IN  - @BCREDE Alt Name & Adds (AENB)
      *                                                                   S01522
     FCGCORRL1  IF   E           K DISK    USROPN                               S01522
      * IN  - @CORRL1 Correspondent details by account id.                S01522
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
     D*************D@FMT     E DSSDALTND0                                 S01230
     D D@FMT         E DS                  EXTNAME(SDALTNPD)                    S01230
      * @BCREDE - Alternative Names & Addresses
      *           Record Format Data Structure
      *
     D E@FMT         E DS                  EXTNAME(CGCORRPD)                    S01522
      * @CORRL1 - Correspondent details by account id.                    S01522
      *           Record Format Data Structure                            S01522
      *                                                                   S01522
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  185134
      * SDCUSTD0 - Customer Details                                                           185134
      *            Record Format Data Structure                                               185134
      *                                                                                       185134
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     185134
      * DSSFMT - Dummy Data Structure for Access Object Programs                              185134
      *          Record Format Data Structure                                                 185134
      *                                                                                       185134
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     D* External Data structure to hold the outgoing record format of     S01230
     D* the file.                                                         S01230
     D*************P@FMT       DS                                         S01230
     D*************                           1 187 P@DMMY                S01230
      *
     D*P@KEY       DS                                                     E01168
     D*                                       1   1 W@SL01                E01168
     D*                                       2   2 W@SL02                E01168
     D*                                       3   3 W@SL03                E01168
     D*                                       4   4 W@SL04                E01168
     D*                                       5   5 W@SL05                E01168
     D*                                       6   6 W@SL06                E01168
     D*                                       7   7 W@SL07                E01168
      *
     D                 DS                                                       S01522
     D  K@CORE                 1      6                                         S01522
     D  K@BLK1                 7      7    INZ(' ')                             S01522
     D  K@ADC1                 8      8                                         S01522
     D  K@BLK2                 9     10    INZ('  ')                            S01522
     D  K@CORR                 1     10
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    S01522
     D** EXTERNAL DS FOR MODULE DETAILS                                   S01522
     D*
     D P@CUST          DS
      * Customer number
      *
     D  K@CUST                 1      6                                         E01168
     D  W@SL01                 1      1                                         E01168
     D  W@SL02                 2      2                                         E01168
     D  W@SL03                 3      3                                         E01168
     D  W@SL04                 4      4                                         E01168
     D  W@SL05                 5      5                                         E01168
     D  W@SL06                 6      6                                         E01168
      *
     D P@ADCD          DS
      * Address code
      *
     D  K@ADCD                 1      1                                         E01168
     D  W@SL07                 1      1                                         E01168
      *
      ************************************************************
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
      ************************************************************        S01230
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@CUST                         I:Customer no.
     C                   PARM                    P@ADCD                         I:Address code
     C                   PARM                    P@FMT                          O:Format
      *                                                                   S01522
     C                   EXSR      SRINIT                                                      S0152
      *****************************************************
      *MAIN
      *
     C     FILUSE        IFNE      'UDC'                                                       S0152
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
     C                   ELSE                                                                  S0152
     C     P@OPTN        IFEQ      '*SAME  '                                                   S0152
     C     *IN01         COMP      '0'                                    91                   S0152
     C                   GOTO      T@SKIP                                                      S0152
     C                   END                                                                   S0152
     C                   END                                                                   S0152
      *                                                                   S01522
     C                   SETOFF                                       5051       ¦
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * DEFINE KEY LIST
      *
     C     K@KEY         KLIST
     C                   KFLD                    K@CUST
     C                   KFLD                    K@ADCD
      *                                                                   S01522
      * DEFINE UDC KEY LIST                                               S01522
      *                                                                   S01522
     C     K@KEY3        KLIST                                                                 S0152
     C**********         KFLD                    K@CORR                                S01522 133773
     C                   KFLD                    K@COR            10                          133773
      *
      * First call - open file :
      *
     C     FILUSE        IFNE      'UDC'                                        FI 1           S0152
     C     *IN01         IFEQ      '0'                                          IF 2 FIRST TIMES0152
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDALTNL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 2           S0152
     C                   ELSE                                                                  S0152
     C     *IN01         IFEQ      '0'                                          IF 2 FIRST TIMES0152
     C                   SETON                                        01          Set ind.     S0152
     C                   OPEN      CGCORRL1                             91        Open file    S0152
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error   S0152
     C                   END                                                    FI 2           S0152
     C                   END                                                    FI 1           S0152
      *
      * Last call - close file and terminate program :
      *
     C     FILUSE        IFNE      'UDC'                                        FI 1           S0152
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROG
     C                   CLOSE     SDALTNL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
     C                   ELSE                                                                  S0152
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROG S0152
     C                   CLOSE     CGCORRL1                             92        Close file   S0152
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error  S0152
     C                   SETON                                        LR          Set ind.     S0152
     C                   END                                                    FI 2           S0152
     C                   END                                                    FI 2           S0152
      *
      * Caller requests first record :
      *
     C     FILUSE        IFNE      'UDC'                                        FI 1           S0152
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     *LOVAL        SETLL     @BCREDE                            9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
     C                   ELSE                                                                  S0152
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC S0152
     C     *LOVAL        SETLL     @CORRL1                            9390        Set file     S0152
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file   S0152
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error   S0152
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next  S0152
     C                   END                                                    FI 3           S0152
     C                   END                                                    FI 1           S0152
      *
      * Caller requests next record :
      *
     C     FILUSE        IFNE      'UDC'                                        FI 1           S0152
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C                   READ      @BCREDE                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
     C                   ELSE                                                                  S0152
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC  S0152
     C                   READ      @CORRL1                              9094      Read record  S0152
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file  S0152
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error   S0152
     C                   END                                                    FI 4           S0152
     C                   END                                                    FI 1           S0152
      *
      * Caller requests last record :
      *
     C     FILUSE        IFNE      'UDC'                                        FI 1           S0152
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     *HIVAL        SETGT     @BCREDE                              90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
     C                   ELSE                                                                  S0152
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC  S0152
     C     *HIVAL        SETGT     @CORRL1                              90        Set file     S0152
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error   S0152
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev  S0152
     C                   END                                                    FI 5           S0152
     C                   END                                                    FI 1           S0152
      *
      * Caller requests previous record :
      *
     C     FILUSE        IFNE      'UDC'                                        FI 1           S0152
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C                   READP     @BCREDE                              9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
     C                   ELSE                                                                  S0152
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC  S0152
     C                   READP     @CORRL1                              9094      Read record  S0152
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file  S0152
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error   S0152
     C                   END                                                    FI 6           S0152
     C                   END                                                    FI 1           S0152
      *
      * Caller requests record indicated by key :
      *
     C     FILUSE        IFNE      'UDC'                                                       S0152
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACCE
     C     P@OPTN        OREQ      '*KEYFST'                                                   09336
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C     W@SL01        IFEQ      '?'                                          IF 8 CHK KEY 1
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C     W@SL04        OREQ      '?'                                           OR
     C     W@SL05        OREQ      '?'                                           OR
     C     W@SL06        OREQ      '?'                                           OR
     C                   SETON                                        50        KEY 1 = ?
     C                   MOVE      *BLANK        K@KEY1            6            INIT KEY NO.1
     C                   ELSE                                                   OTHERWISE
     C                   MOVE      K@CUST        K@KEY1                         SET TO INPUT
     C                   END                                                    FI 8
     C     W@SL07        IFEQ      '?'                                          IF 9 SELECT
     C                   SETON                                        51        KEY 2 = ?
     C                   MOVE      *BLANK        K@KEY2            1            INIT KEY NO.2
     C                   ELSE                                                   OTHERWISE
     C                   MOVE      K@ADCD        K@KEY2                         SET TO INPUT
     C                   END                                                    FI 9
     C     *IN50         IFEQ      '1'                                          IF 10
     C     *IN51         OREQ      '1'                                          OR
     C*********************CALL 'SDMFSRR'              98    <SELECT>     S01230
     C*********************CALL 'SD0301S'              98    <SELE S01230 S01117
     C                   CALL      'SD0300S'                            98        <SELECT>     S0111
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      K@KEY1        K@CUST                           B:Key NO 1
     C                   PARM      K@KEY2        K@ADCD                           B:Key NO 2
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 10
      *                                                                   093368
      * Caller requests first alternate address for customer              093368
      *                                                                   093368
     C     P@OPTN        IFEQ      '*KEYFST'                                    IF 11KEY ACCE  09336
     C     K@CUST        CHAIN     @BCREDE                            9590        Get record   09336
      *                                                                   093368
      * Caller requests specific alternate address for customer           093368
      *                                                                   093368
     C                   ELSE                                                                  09336
     C     K@KEY         CHAIN     @BCREDE                            9590        Get record
     C                   END                                                    FI 11          09336
      *                                                                   093368
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
     C                   END                                                    FI 1           S0152
      *                                                                   S01522
      * Caller requests record indicated by key UDC:                      S01522
      *                                                                   S01522
     C     FILUSE        IFEQ      'UDC'                                                       S0152
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACCE  S0152
     C     P@OPTN        OREQ      '*KEYFST'                                                  159529
     C     P@OPTN        OREQ      '*VERIFY'                                     OR            S0152
     C                   MOVE      *BLANKS       K@COR                                        133773
     C                   MOVEL     P@CUST        K@COR                                        133773
     C     K@KEY3        CHAIN     @CORRL1                            9590        Get record   S0152
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found S0152
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error   S0152
     C                   END                                                                   S0152
     C                   END                                                                   S0152
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 11 NOT KEYED
     C     P@OPTN        ANDNE     '*KEYFST'                                    IF 11 NOT KEYED09796
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter err
     C                   END                                                    FI 11
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
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 12 SEND MESSGE
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
     C                   PARM                    P@MGDA                           I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 12
      *
      * Caller requests DB error handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF 13
     C     P@RTCD        ANDNE     *BLANK                                        AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI 13
      *
     C     FILUSE        IFNE      'UDC'                                                       S0152
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 14
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C     P@RTCD        ANDNE     '*OPTION'                                     AND
     C                   MOVEL     D@FMT         P@FMT
     C                   END                                                    FI 14
     C                   ELSE                                                                  S0152
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 14          S0152
     C     P@OPTN        ANDNE     '*FREE  '                                     AND           S0152
     C     P@RTCD        ANDNE     '*OPTION'                                     AND           S0152
     C***********          MOVELE@FMT     P@FMT                     S01522088567
     C                   MOVEL     P@CUST        BCCUST                                        08856
     C                   MOVEL     P@ADCD        BCADCD                                        08856
      *                                                                                       185134
      ** If address from CGCORRPD is equal to blank and Correpondent                          185134
      ** type is equal to C or D, then address is retreived from                              185134
      ** Customer Details or Counterpary Nostro Details as appropriate.                       185134
      *                                                                                       185134
     C     CDADD1        IFEQ      *BLANKS                                                    185134
     C                   CALL      'AOCUSTR0'                                                 185134
     C                   PARM      *BLANKS       @RTCD                                        185134
     C                   PARM      '*KEY    '    @OPTN                                        185134
     C                   PARM      CDCUST        @KEY1            10                          185134
     C                   PARM      *BLANKS       @KYST             7                          185134
     C     SDCUST        PARM      SDCUST        DSSDY                                        185134
      *                                                                                       185134
     C     @RTCD         IFEQ      *BLANKS                                                    185134
     C                   MOVEL     BBCNA1        BCCNA1                                       185134
     C                   MOVEL     BBCNA2        BCCNA2                                       185134
     C                   MOVEL     BBCNA3        BCCNA3                                       185134
     C                   MOVEL     BBCNA4        BCCNA4                                       185134
     C                   ENDIF                                                                185134
     C                   ELSE                                                                 185134
      *                                                                                       159529
      **  If called from PM0710 put 'C' as the default Address code so                        159529
      **  that it will be shown in the enquiry.                                               159529
      *                                                                                       159529
     C     P@OPTN        IFEQ      '*KEYFST'                                                  159529
     C                   MOVEL     'C'           BCADCD                                       159529
     C                   ENDIF                                                                159529
      *                                                                                       159529
     C                   MOVEL     CDADD1        BCCNA1                                        08856
     C                   MOVEL     CDADD2        BCCNA2                                        08856
     C                   MOVEL     CDADD3        BCCNA3                                        08856
     C                   MOVEL     CDADD4        BCCNA4                                        08856
     C                   ENDIF                                                                185134
      *                                                                                       185134
     C                   MOVEL     CDDESC        BCCRTN                                        08856
     C                   MOVEL     CDTEL         BCCTNB                                        08856
     C                   MOVEL     CDERT         BCTXNB                                        08856
     C                   MOVEL     *BLANKS       BCCNCD                                        08856
     C                   MOVEL     D@FMT         P@FMT                                         13792
     C                   END                                                    FI 14          S0152
     C                   END                                                                   S0152
      *
      * Return to caller :
      *
     C                   RETURN
      *ENDMAIN                                                            S01522
     C********************************************************************S01522
     C/EJECT                                                              S01522
     C********************************************************************S01522
     C**  Subroutine SRINIT provides initialisation and definition.     **S01522
     C********************************************************************S01522
     C     SRINIT        BEGSR                                                  * S R I N I T *S0152
      *                                                                   S01522
      ** CALL ACCESS PROGRAM FOR MIDAS MODULES DETAILS                    S01522
      *                                                                   S01522
     C                   CALLB     'AOMMODR0'                                                  S0152
     C                   PARM      *BLANKS       @RTCD             7                           S0152
     C                   PARM      '*FIRST  '    @OPTN             7                           S0152
     C     SDMMOD        PARM      SDMMOD        P@FMT                                         S0152
      *                                                                   S01522
      *** CALL TO THE SWITCHABLE FEATURES FIEL TO CHECK IF S01447         S01522
      *** IS SWITCHED ON.                                                 S01522
      *                                                                   S01522
     C                   CALLB     'AOSARDR0'                                                  S0152
     C                   PARM      *BLANKS       @RTCD                                         S0152
     C                   PARM      '*VERIFY'     @OPTN                                         S0152
     C                   PARM      'S01523'      @SARD             6                           S0152
      *                                                                   S01522
      ** UDC SWITCHED ON AND SWITCHABLE FEATURE S01523 INSTALLED.         S01522
     C     BGN1ST        IFEQ      'Y'                                                         S0152
     C     @RTCD         ANDEQ     *BLANK                                                      S0152
     C                   MOVEL     'UDC'         FILUSE            3                           S0152
     C                   MOVEL     P@CUST        K@CORE            6                           S0152
     C                   MOVEL     P@ADCD        K@ADC1            1                           S0152
     C                   ENDIF                                                                 S0152
      *                                                                   S01522
      ** Check if CCG024 is on                                                              MD043685
      *                                                                                     MD043685
     C                   CALLB     'AOSARDR0'                                               MD043685
     C                   PARM      *BLANKS       @RTCD                                      MD043685
     C                   PARM      '*VERIFY'     @OPTN                                      MD043685
     C                   PARM      'CCG024'      @SARD                                      MD043685
      *                                                                                     MD043685
     C     @RTCD         IFEQ      *BLANKS                                                  MD043685
     C                   MOVEL     *BLANKS       FILUSE                                     MD043685
     C                   ENDIF                                                              MD043685
      *                                                                                     MD043685
     C                   ENDSR                                                                 S0152
     C********************************************************************S01522
**CTDATA @MG
SDALTNPD  AOALTNR0  Alternative names & address
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
