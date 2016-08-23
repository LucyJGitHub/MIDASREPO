     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Client details access object')
      *****************************************************************
      *                                                               *
      *  Midas Access Objects Module                                  *
      *                                                               *
      *  AOCUSTR0 - READ ACCESS TO CLIENTS CODES FILE                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG17927           Date 23Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 237337             Date 03Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 17Mar06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 22Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU014             Date 28Apr98               *
      *                 CAP002             Date 01May98               *
      *                    097193             DATE 24FEB98            *
      *                    CDL002             DATE 26FEB97            *
      *                    CDL001             DATE 13OCT95            *
      *                    CCF001             DATE 12APR95            *
      *                    042047             DATE 13OCT94            *
      *                    S01505             DATE 18JUL94            *
      *                    S01486             DATE 18JUL94            *
      *                    S01449             DATE 27OCT93            *
      *                    S01429             DATE 26JUL93            *
      *                    E22649             DATE 20SEP90            *
      *                    S01117             DATE 12APR90            *   S01117
      *                    S01230             DATE 10APR90            *   S01117
      *                    S01230             DATE 07/01/90           *   S01117
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BUG17927 - Add new RTCD passed, if record found but customer *
      *             closed.                                           *
      *  237337 - Add new RTCD passed, if record found but customer   *
      *           deleted.                                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSD007 - Customer Closing:                                   *
      *           Check closure status flag.                          *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CPB001 - 'Private Banking' Module                            *
      *           - Recompiled over changed SDCUSTPD.                 *
      *  CDL006 - Dealing Fiduciary :                                 *
      *           Created a duplicate access object named AOCUSTR1    *
      *           to hold the additional customer details which can't *
      *           retrieve by this old access object AOCUSTR0. Ins    *
      *           tead of using DSSDY as external data structure to   *
      *           contain customer details from PF/SDCUSTPD, AOCUSTR1 *
      *           uses a newly created data structure DSLDY defined   *
      *           as 2000 in length to insure that all customer de -  *
      *           tails would be passed back to the calling program.  *
      *                                                               *
      *           *Note: All newly created and amended programs       *
      *           should use the new access object as replacement for *
      *           AOCUSTR0.                                           *
      *  CEU014 - EMU User Defined Correspondence Changes:            *
      *           recompile over extended SDCUSTPD.                   *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
      *         - Fix applied during project to convert Midas inputs  *
      *           to APIs: ILE RPG gives a decimal data error when    *
      *           date deleted is checked after chain fail.           *
      *     097193 - Program opens SDCUSTL1 only if a Customer No is  *
      *              input. If Shortname is specified on first access,*
      *              file SDCUSTL1 is not open, causing error. Fix is *
      *              to open both SDCUSTL1 and SDCUSTL2 the first     *
      *              time Customer Shortname is used.
      *     CDL002 - FX Netting:                                      *
      *            - Recompile over extended SDCUSTPD.                *
      *     CDL001 - Customer Margins:                                *
      *            - Recompile over extended SDCUSTPD.                *
      *     CCF001 - ConCord Interface - Recompile due to SDCUSTPD chg*
      *     042047 - USE DATE DELETED TO CHECK IF A RECORD IS DELETED *
      *     S01505 - Profit Centre Accounting Development:            *
      *              - Recompiled over changed SDCUSTL1 and L2.       *
      *     S01486 - Private Banking Development:                     *
      *              - Recompiled over changed SDCUSTL1 and L2.       *
      *     S01449 - RECOMPILE AFTER ADDITION OF PC SUBSYSTEM FIELD   *
      *              TO CLIENT FILE.                                  *
      *     S01429 - CHIPS 2 incorporation.                           *
      *              - Recompiled over changed SDCUSTPD.              *
      *     E22649 - WHERE DELETED CUSTOMER/BANK ENTERED - NOT VALID  *
      *              AT PRESENT IF DELETED CUSTOMER IN BENEFICIARY    *
      *              PGM CRASHES.DELETED BANKS CURRENTLY VALID.       *
      *     S01117 - '?' PROCESSING AMENDED FOR EXTENDED SETTLEMENTS  *   S01117
      *     S01230 - STANDARDISE ACCESS PROGRAMS                      *   S01230
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L     FUNCTION OF INDICATORS                      *
      *                                                               *
      *       01       OPEN FILE                                      *
      *       90       FILE ERROR                                     *
      *       91       OPEN ERROR                                     *
      *       92       CLOSE ERROR                                    *
      *       93       EMPTY FILE                                     *
      *       94       END OF FILE                                    *
      *       95       NO RECORD FOUND                                *
      *       96       OPTION ERROR                                   *
      *       97       NO SELECTION                                   *
      *       98       CALL ERROR                                     *
      *       99       SEND MESSAGE ERROR                             *
      *                                                               *
      *****************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDCUSTL1  IF   E           K DISK    USROPN
     F                                     RENAME(@BBREBF:@CNUM)
      * IN  - @BBREBF Customers        (CUST) Customer number
      *...........................................................
     FSDCUSTL2  IF   E           K DISK    USROPN
     F                                     RENAME(@CUSTD5:@CSHT)
      * IN  - @CUSTD5 Customers        (CSNM) Customer shortname
     F/COPY WNCPYSRC,AOCUSTR0F1
      ************************************************************
      /SPACE 3
     D*ESTART
      ***************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D********************************************************************S01230
      ************************************************************        S01230
      *-----------------------------------------------------------
      ***************************************************
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
     D***********D@FMT     E DSSDCUSTD0                                   S01230
     D D@FMT         E DS                  EXTNAME(SDCUSTPD)                    S01230
      * @CUST - Customer record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)                       S01230
     D* External Data structure to hold the outgoing record format        S01230
     D* of the file.                                                      S01230
      *                                                                   S01230
     D********P@FMT       DS                            415               S01230
     D*******                               415 415 P@DMMY                S01230
      *
     D P@KEY1          DS
      * Key input data structure
     D  @IN                    1     10                                         S01117
     D                                     DIM(10) ASCEND                       Input array      S01
     D  W@CSHT                 1     10
     D  W@INIT                 1      1
     D  W@CNUM                 1      6
     D  W@LAST                 6      6
     D  W@BLNK                 7     10
      *
     D*                                                                   S01230
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
      * Copyright array
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
     D/COPY WNCPYSRC,AOCUSTR0I1
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@KEY1                         I:Key field
     C                   PARM                    P@KYST            7            O:Key status
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
     C                   SETOFF                                       505152     Test indicator
     C                   SETOFF                                       535455     Selection inds.
     C                   SETOFF                                       80         Cust del ind 237337
     C                   SETOFF                                       81                    BUG17927
     C                   MOVE      *BLANK        P@KYST                          Key status
     C                   MOVE      *BLANK        W@ALGN           10             Align key
      *
      * Check key to determine file to use :
      *
      *****1.*Check*for*all*numeric,*no*embedded*blanks***->*Customer*No.*****                CSD027
      *****2.*Check*for*first*character*=*Alphabetic******->*Shortname********                CSD027
      *****3.*Otherwise,*key*field*is*in*error********************************                CSD027
      *    If the search is for a six long string                                             CSD027
      *         Check against the customer number file                                        CSD027
      *    If the check of SDCUSTPD failed or if search string is not six long                CSD027
      *         Check against the customer shortname file                                     CSD027
      *    If not found key field is in error                                                 CSD027
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                    OR VERIFY
     C/COPY WNCPYSRC,AOCUSTR0C1
      *                    ¦
      * a) Check for Selection request :
      *                    ¦
     C                   Z-ADD     1             P1                3 0            Set pointer
     C***********'?'*******LOKUP@IN,P1                   53  Select requesS01117
     C************IN53*****IFEQ '1'                        IF SELECTION   S01117
     C     W@INIT        IFEQ      '?'                                          IF SELECTION   S0111
     C*********************CALL 'SDEMSRR'              55    <SELECT>
     C*********************CALL 'SD0011S'              55    <SELECT>     S01230
     C                   CALL      'SD0010S'                            55        <SELECT>     S0123
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@KEY2            6              B:Key
     C     P@RTC2        COMP      *BLANK                             54          No selection
     C     *IN54         CABEQ     '1'           T@SKIP                           No selection
     C     *IN55         CABEQ     '1'           T@SKIP                           Program error
     C                   MOVE      *BLANK        P@KEY1                           ¦ Cust.No.to
     C                   MOVEL     P@KEY2        P@KEY1                           ¦ actual key
     C                   END                                                    FI
      *                    ¦
      * b) Align and check number or shortname :
      *                    ¦
     C                   Z-ADD     1             P1                               Set pointer
     C     *BLANK        LOOKUP    @IN(P1)                            97          First non-blank
     C     *IN97         CABEQ     '0'           T@SKIP                   97      -> Key is blank
      *                    ¦
     C                   MOVEA     @IN(P1)       W@ALGN                           ¦ Align
     C                   MOVE      W@ALGN        P@KEY1                           ¦ left
      *                    ¦
     C*****W@INIT*****   IFLT      '0'                                          IF 2 CHARACTERCSD027
     C****************   SETON                                        50          Shortname inCSD027
     C****************   MOVE      '*CSHT  '     P@KYST                           Shortname   CSD027
     C****************   ELSE                                                   EL 2 CUST.NUMBCSD027
     C*****W@BLNK*****   CABNE     *BLANK        T@SKIP               9797        -> Chars.>6 CSD027
     C****************   TESTN                   W@CNUM               97          Numeric?    CSD027
     C******IN97******   CABEQ     '0'           T@SKIP                   97      -> ¬Numeric CSD027
     C*****W@LAST*****   CABLT     '0'           T@SKIP                 97        -> Signed   CSD027
     C****************   MOVE      '*CNUM  '     P@KYST                   97      Client numbeCSD027
     C****************   END                                                    FI 2          CSD027
      *                    ¦
     C                   END                                                    FI 1
      *
      * First call - open files :
      *
     C******IN50*        IFEQ      '0'                                          IF 3 CUST.NUMBCSD027
     C     *IN01         IFEQ      '0'                                          IF 4 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDCUSTL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 4
     C***********        ELSE                                                   EL 3 SHORTNAMECSD027
     C     *IN02         IFEQ      '0'                                          IF 5 FIRST TIME
     C                   SETON                                        02          Set ind.
     C                   OPEN      SDCUSTL2                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
      *                                                                                       097193
      * Open SDCUSTL1 if not already open for Customer number processing                      097193
     C     *IN01         IFEQ      '0'                                          IF 6 FIRST TIM097193
     C                   SETON                                        01          Set ind.    097193
     C                   OPEN      SDCUSTL1                             91        Open file   097193
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error  097193
     C                   END                                                    FI 6          097193
      *                                                                                       097193
     C                   END                                                    FI 5
     C***********        END                                                    FI 3          CSD027
      *
      * Last call - close files and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 6 FREE PROGRAM
     C   01              CLOSE     SDCUSTL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C   02              CLOSE     SDCUSTL2                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   RETURN                                                   Return
     C                   END                                                    FI 6
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST RECORD
     C     *LOVAL        SETLL     @CNUM                              9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests SETLL record :                                                        CSD027
     C     P@OPTN        IFEQ      '*SETLL '                                   IF SETLL RECORDCSD027
     C     W@CNUM        SETLL     @CNUM                              9390       Set file     CSD027
     C     *IN93         CABEQ     '1'           T@SKIP                          Empty file   CSD027
     C     *IN90         CABEQ     '1'           T@SKIP                   LR     File error   CSD027
     C                   MOVE      '*NEXT  '     P@OPTN                          Force *Next  CSD027
     C                   END                                                   FI             CSD027
      *                                                                                       CSD027
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT RECORD
     C                   READ      @CNUM                                9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST RECORD
     C     *HIVAL        SETGT     @CNUM                                90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests SETGT record :                                                        CSD027
     C     P@OPTN        IFEQ      '*SETGT '                                   IF SETGT RECORDCSD027
     C     W@CNUM        SETGT     @CNUM                                90       Set file     CSD027
     C     *IN90         CABEQ     '1'           T@SKIP                   LR     File error   CSD027
     C                   MOVE      '*PREV  '     P@OPTN                          Force *Prev  CSD027
     C                   END                                                   FI             CSD027
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.RECORD
     C                   READP     @CNUM                                9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR
     C**N50W@CNUM********CHAIN     @CNUM                              9590        Get record  CSD027
     C***50W@CSHT********CHAIN     @CSHT                              9590        Get record  CSD027
      *                                                                   E22649
      * Find the customer or shortname                                                        CSD027
      * Could be a customer if only 6 chars                                                   CSD027
     C     W@BLNK        IFEQ      *BLANKS                                       -> Chars.=6  CSD027
     C     W@CNUM        CHAIN     @CNUM                              9590       Get record   CSD027
     C                   ELSE                                                                 CSD027
     C                   SETON                                        95                      CSD027
     C                   END                                                                  CSD027
      *                                                                                       CSD027
      * If found as a customer no then set the P@KYST variable                                CSD027
     C     *IN95         IFEQ      '0'                                                        CSD027
     C     *IN90         ANDEQ     '0'                                                        CSD027
     C                   MOVE      '*CNUM  '     P@KYST                          Client numberCSD027
     C                   ELSE                                                                 CSD027
      * If not a customer no then check as a shortname                                        CSD027
     C                   SETOFF                                       9590                    CSD027
     C     W@CSHT        CHAIN     @CSHT                              9590    Get record      CSD027
      * If found as a shortname then set the P@KYST variable                                  CSD027
     C     *IN95         IFEQ      '0'                                                        CSD027
     C     *IN90         ANDEQ     '0'                                                        CSD027
     C                   MOVE      '*CSHT  '     P@KYST                          Short name   CSD027
     C                   END                                                                  CSD027
     C                   END                                                                  CSD027
      * Deleted Customer/Bank not valid.                                  E22649
      *                                                                   E22649
     C***********BBTYLC    IFEQ 'D'                        IF DELETEE22649042047
      ** Only check date deleted if chain was successful
     C                   IF        *IN95 = *off
     C     BBDTDL        IFNE      0                                            IF DELETED     04204
     C***************    SETON                                        95          No reuE2264 237337
     C                   SETON                                        80          Cust delet  237337
     C                   END                                                    FI             E2264
     C                   ENDIF
      *                                                                                       CSD007
     C**********         IF        *IN95 = *off                                      CSD007 BUG17927
     C                   IF        *IN95 = *off AND *IN80 = *off                            BUG17927
     C                   IF        BBCLST = 'Y'                                               CSD007
     C**********         MOVEL     '1'           *IN95                               CSD007 BUG17927
     C                   MOVEL     '1'           *IN81                          Cust closed BUG17927
     C                   ENDIF                                                                CSD007
     C                   ENDIF                                                                CSD007
      *                                                                   E22649
     C/COPY WNCPYSRC,AOCUSTR0C4
     C     *IN95         CABEQ     '1'           T@SKIP                           No record found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter error
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
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*KEY   '     P@RTCD                         Invalid key
     C   54              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   55              MOVE      '*CALL  '     P@RTCD                         Call error
     C   80              MOVE      '*CUSDEL'     P@RTCD                         Cust deleted  237337
     C   81              MOVE      '*CUSCLS'     P@RTCD                         Cust closed BUG17927
     C   97              MOVE      '*ERROR '     P@KYST                         Key status
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MESSAGE
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No record found
     C   80              MOVE      'ACO1006'     P@MGID                           Cust del    237337
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1008'     P@MGID                           Invalid key
     C   54              MOVE      'ACO1009'     P@MGID                           No selection
     C   55              MOVE      'ACO1010'     P@MGID                           Call error
     C   81              MOVE      'ACO1011'     P@MGID                           Cust clse BUG17927
     C                   CALLB     'ZASNMG'                                       <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
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
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
     C                   MOVEL     D@FMT         P@FMT                          FI 13
     C                   END
     C/COPY WNCPYSRC,AOCUSTR0C2
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDCUSTPD  AOCUSTR0  Customer Details
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
