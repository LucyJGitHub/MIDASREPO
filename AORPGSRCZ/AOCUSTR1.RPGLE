     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Extended client details access object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOCUSTR1  - Read Access to Extended Client Codes File        *
      *                                                               *
      *  Function:  This module will read or access customer additio  *
      *             nal details from extended file PF/SDCUSTPD which  *
      *             the original AOCUSTR0 cannot hold. This program   *
      *             uses an external data structure DSLDY defined as  *
      *             2000 in length much greater compared to DSSDY w/c *
      *             is only 800 long.                                 *
      *                                                               *
      *             *Note : Newly developed or amended programs       *
      *                     accessing customer details file should    *
      *                     use of this module as replacement for the *
      *                     old access object.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 17Mar06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 17Feb00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *           (Recompiled over changed SDCUSTPD)                  *
      *  CSD007 - Customer Closing:                                   *
      *           Check closure status flag.                          *
      *  CDL008 - Continuous Linked Settlement                        *
      *           (Recompiled over changed SDCUSTPD)                  *
      *  CPB001 - 'Private Banking' Module                            *
      *           - Recompiled over changed SDCUSTPD.                 *
      *  CDL006 - Dealing Fiduciary.                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Functions of Indicators                                      *
      *                                                               *
      *       01       Open file                                      *
      *       90       File error                                     *
      *       91       Open error                                     *
      *       92       Close error                                    *
      *       93       Empty file                                     *
      *       94       End of file                                    *
      *       95       No record found                                *
      *       96       Option error                                   *
      *       97       No selection                                   *
      *       98       Call error                                     *
      *       99       Send message error                             *
      *                                                               *
      *****************************************************************
 
     FSDCUSTL1  IF   E           K DISK    USROPN
     F                                     RENAME(@BBREBF:@CNUM)
     FSDCUSTL2  IF   E           K DISK    USROPN
     F                                     RENAME(@CUSTD5:@CSHT)
 
     F/COPY WNCPYSRC,AOCUSTR0F1
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
 
     D PGMDS          SDS
      ** Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
 
     D D@FMT         E DS                  EXTNAME(SDCUSTPD)                    S01230
      ** Customer record format data structure
 
     D P@FMT         E DS                  EXTNAME(DSLDY)                       CDL006
      ** External Data structure to hold the outgoing record format of the
      ** file
 
     D P@Key1          DS
      ** Key input data structure
     D  @IN                    1     10                                         S01117
     D                                     DIM(10) ASCEND                       Input array      S01
     D  W@CSHT                 1     10
     D  W@INIT                 1      1
     D  W@CNUM                 1      6
     D  W@LAST                 6      6
     D  W@BLNK                 7     10
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Set up copyright parameter
 
     C                   MoveA     CPY@          CPY2@            80
 
      ** Receive parameter list
 
     C     *Entry        Plist
     C                   Parm                    P@RtCd            7
     C                   Parm                    P@Optn            7
     C                   Parm                    P@Key1
     C                   Parm                    P@Kyst            7
     C                   Parm                    P@FMT
 
      ** Access option *SAME input
 
     C     P@Optn        IfEq      '*SAME '
     C     *IN01         Comp      '0'                                    91
     C                   Goto      T@SKIP
     C                   EndIf
 
      ** Reset error indicators
 
     C                   SetOff                                       909192
     C                   SetOff                                       939495
     C                   SetOff                                       969798
 
      ** Test indicators
 
     C                   SetOff                                       505152
 
      ** Selection indicators
 
     C                   SetOff                                       535455
 
      ** Key status
 
     C                   Move      *BLANK        P@Kyst
 
      ** Align key
 
     C                   Move      *BLANK        W@ALGN           10
 
      ** Check key to determine file to use :
      *****1.*Check*for*all*numeric,*no*embedded*blanks***->*Customer*No.*****                CSD027
      *****2.*Check*for*first*character*=*Alphabetic******->*Shortname********                CSD027
      *****3.*Otherwise,*key*field*is*in*error********************************                CSD027
      *    If the search is for a six long string                                             CSD027
      *         Check against the customer number file                                        CSD027
      *    If the check of SDCUSTPD failed or if search string is not six long                CSD027
      *         Check against the customer shortname file                                     CSD027
      *    If not found key field is in error                                                 CSD027
 
     C     P@Optn        IfEq      '*KEY   '
     C     P@Optn        OrEq      '*VERIFY'
 
     C/COPY WNCPYSRC,AOCUSTR0C1
 
      ** a) Check for Selection request:
 
      ** Set pointer
 
     C                   Z-Add     1             P1                3 0
 
     C     W@INIT        IfEq      '?'
     C                   Call      'SD0010S'                            55
     C                   Parm      *BLANK        P@RTC2            7
     C                   Parm      *BLANK        P@KEY2            6
 
     C     P@RTC2        Comp      *BLANK                             54
     C     *IN54         CabEq     '1'           T@SKIP
     C     *IN55         CabEq     '1'           T@SKIP
     C                   Move      *BLANK        P@Key1
     C                   MoveL     P@KEY2        P@Key1
     C                   EndIf
 
      ** b) Align and check number or shortname :
 
      ** Set pointer
 
     C                   Z-Add     1             P1
     C     *BLANK        LookUp    @IN(P1)                            97
     C     *IN97         CabEq     '0'           T@SKIP                   97
     C                   MoveA     @IN(P1)       W@ALGN
     C                   Move      W@ALGN        P@Key1
 
     C*****W@INIT        IfLT      '0'                                                        CSD027
     C***********        SetOn                                        50                      CSD027
     C***********        Move      '*CSHT  '     P@Kyst                                       CSD027
     C***********        Else                                                                 CSD027
     C*****W@BLNK        CabNe     *BLANK        T@SKIP               9797                    CSD027
     C***********        TestN                   W@CNUM               97                      CSD027
     C******IN97*        CabEq     '0'           T@SKIP                   97                  CSD027
     C*****W@LAST        CabLT     '0'           T@SKIP                 97                    CSD027
     C***********        Move      '*CNUM  '     P@Kyst                   97                  CSD027
     C***********        EndIf                                                                CSD027
 
     C                   EndIf
 
      ** First call - open files :
 
     C******IN50*        IfEq      '0'                                                        CSD027
     C     *IN01         IfEq      '0'
     C                   SetOn                                        01
     C                   Open      SDCUSTL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   EndIf
     C***********        Else                                                                 CSD027
     C     *IN02         IfEq      '0'
     C                   SetOn                                        02
     C                   Open      SDCUSTL2                             91
     C     *IN91         CabEq     '1'           T@SKIP                   LR
 
      ** Open SDCUSTL1 if not already open for Customer number
      ** processing
 
     C     *IN01         IfEq      '0'
     C                   SetOn                                        01
     C                   Open      SDCUSTL1                             91
     C     *IN91         CabEq     '1'           T@SKIP                   LR
     C                   EndIf
 
     C                   EndIf
     C***********        EndIf                                                                CSD027
 
      ** Last call - close files and terminate program :
 
     C     P@Optn        IfEq      '*FREE  '
     C   01              Close     SDCUSTL1                             92
     C     *IN92         CabEq     '1'           T@SKIP                   LR
     C   02              Close     SDCUSTL2                             92
     C     *IN92         CabEq     '1'           T@SKIP                   LR
     C                   SetOn                                        LR
     C                   Return
     C                   EndIf
 
      ** Caller requests first record :
 
     C     P@Optn        IfEq      '*FIRST '
     C     *LOVAL        SetLL     @CNUM                              9390
     C     *IN93         CabEq     '1'           T@SKIP
     C     *IN90         CabEq     '1'           T@SKIP                   LR
     C                   Move      '*NEXT  '     P@Optn
     C                   EndIf
      *                                                                                       CSD027
      * Caller requests SETLL record :                                                        CSD027
      *                                                                                       CSD027
     C     P@OPTN        IFEQ      '*SETLL '                                   IF SETLL RECORDCSD027
     C     W@CNUM        SETLL     @CNUM                              9390       Set file     CSD027
     C     *IN93         CABEQ     '1'           T@SKIP                          Empty file   CSD027
     C     *IN90         CABEQ     '1'           T@SKIP                   LR     File error   CSD027
     C                   MOVE      '*NEXT  '     P@OPTN                          Force *Next  CSD027
     C                   END                                                   FI             CSD027
      *                                                                                       CSD027
      ** Caller requests next record :
 
     C     P@Optn        IfEq      '*NEXT  '
     C                   Read      @CNUM                                9094
     C     *IN94         CabEq     '1'           T@SKIP
     C     *IN90         CabEq     '1'           T@SKIP                   LR
     C                   EndIf
 
      ** Caller requests last record :
 
     C     P@Optn        IfEq      '*LAST  '
     C     *HIVAL        SetGT     @CNUM                                90
     C     *IN90         CabEq     '1'           T@SKIP                   LR
     C                   Move      '*PREV  '     P@Optn
     C                   EndIf
      *                                                                                       CSD027
      * Caller requests SETGT record :                                                        CSD027
      *                                                                                       CSD027
     C     P@OPTN        IFEQ      '*SETGT '                                   IF SETGT RECORDCSD027
     C     W@CNUM        SETGT     @CNUM                                90       Set file     CSD027
     C     *IN90         CABEQ     '1'           T@SKIP                   LR     File error   CSD027
     C                   MOVE      '*PREV  '     P@OPTN                          Force *Prev  CSD027
     C                   END                                                   FI             CSD027
      *                                                                                       CSD027
      ** Caller requests previous record :
 
     C     P@Optn        IfEq      '*PREV  '
     C                   ReadP     @CNUM                                9094
     C     *IN94         CabEq     '1'           T@SKIP
     C     *IN90         CabEq     '1'           T@SKIP                   LR
     C                   EndIf
 
      ** Caller requests record indicated by key :
 
     C     P@Optn        IfEq      '*KEY   '
     C     P@Optn        OrEq      '*VERIFY'
     C**N50W@CNUM*       Chain     @CNUM                              9590                    CSD027
     C***50W@CSHT*       Chain     @CSHT                              9590                    CSD027
      *                                                                                       CSD027
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
 
      ** Deleted Customer/Bank not valid.
      ** Only check date deleted if chain was successful
 
     C                   If        *IN95 = *off
     C     BBDTDL        IfNe      0
     C                   SetOn                                        95
     C                   EndIf
     C                   EndIf
      *                                                                                       CSD007
     C                   If        *IN95 = *off                                               CSD007
     C                   If        BBCLST = 'Y'                                               CSD007
     C                   Movel     '1'           *IN95                                        CSD007
     C                   EndIf                                                                CSD007
     C                   EndIf                                                                CSD007
 
     C     *IN95         CabEq     '1'           T@SKIP
     C     *IN90         CabEq     '1'           T@SKIP                   LR
     C                   EndIf
      *
     C     P@Optn        IfNe      '*KEY   '
     C     P@Optn        AndNE     '*NEXT  '
     C     P@Optn        AndNE     '*PREV  '
     C     P@Optn        AndNE     '*VERIFY'
     C     P@Optn        AndNE     '*FREE  '
     C                   SetOn                                          96
     C                   EndIf
 
      * No record found or End of file - return error code :
 
     C     T@SKIP        Tag
     C                   Move      *BLANK        P@RtCd
     C   90              Move      '*ERROR '     P@RtCd
     C   91              Move      '*OPEN  '     P@RtCd
     C   92              Move      '*CLOSE '     P@RtCd
     C   93              Move      '*EMPTY '     P@RtCd
     C   94              Move      '*EOF   '     P@RtCd
     C   95              Move      '*NRF   '     P@RtCd
     C   96              Move      '*OPTION'     P@RtCd
     C   97              Move      '*KEY   '     P@RtCd
     C   54              Move      '*NOSEL '     P@RtCd
     C   55              Move      '*CALL  '     P@RtCd
     C   97              Move      '*ERROR '     P@Kyst
 
      ** Caller requests message sent to program queue :
 
     C     W@RtCd        IfEq      '*MSG   '
     C     P@RtCd        AndNe     *BLANK
     C   90              Move      'ACO1001'     P@MGID
     C   91              Move      'ACO1002'     P@MGID
     C   92              Move      'ACO1003'     P@MGID
     C   93              Move      'ACO1004'     P@MGID
     C   94              Move      'ACO1005'     P@MGID
     C   95              Move      'ACO1006'     P@MGID
     C   96              Move      'ACO1007'     P@MGID
     C   97              Move      'ACO1008'     P@MGID
     C   54              Move      'ACO1009'     P@MGID
     C   55              Move      'ACO1010'     P@MGID
     C                   CallB     'ZASNMG'
     C                   Parm      *BLANK        W@RtCd            7
     C                   Parm      PGNAME        P@PGNM           10
     C                   Parm      '*PRV'        P@DEST            5
     C                   Parm                    P@MGID            7
     C                   Parm      *BLANK        P@MSGF           10
     C                   Parm      *BLANK        P@MGKY            4
     C                   Parm                    P@MGDA           50
     C                   Parm      '*DIAG'       P@MGTP            7
     C                   EndIf
 
      ** Caller Requests DB Error Handling
 
     C     W@RtCd        IfEq      '*DBERR '
     C     P@RtCd        AndNe     *BLANK
     C                   Dump
     C                   CallB     'DBERRCTL'
     C                   EndIf
 
     C     P@Optn        IfNe      '*VERIFY'
     C     P@Optn        AndNe     '*FREE  '
     C     P@RtCd        AndNe     '*OPTION'
     C                   MoveL     D@FMT         P@FMT
     C                   EndIf
 
     C/COPY WNCPYSRC,AOCUSTR0C2
 
      ** Return to caller :
 
     C                   Return
 
      *****************************************************
 
** CTDATA @MG
SDCUSTPD  AOCUSTR0  Customer Details
** CTDATA CPY@
(c) Finastra International Limited 2001
