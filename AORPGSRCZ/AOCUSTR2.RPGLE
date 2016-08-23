     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Client details access object (CSD007)')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOCUSTR2 - Read Access to Client Codes File                  *
      *                                                               *
      *  Function:  This module functions exactly the same with       *
      *   (I/C)     AOCUSTR0/1. It is intoduced in CSD007 only to     *
      *             identify that a record on file, although it may   *
      *             not be live, could be accessed and its information*
      *             retrieved for enquiries and reports.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 17Mar06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007   *CREATE   Date 28Aug00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSD007 - Customer Closing                                    *
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
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Customer details retrieval
     FSDCUSTL1  IF   E           K DISK    USROPN
     F                                     RENAME(@BBREBF:@CNUM)
      *
      ** SD Customer details by unique shortname
     FSDCUSTL2  IF   E           K DISK    USROPN
     F                                     RENAME(@CUSTD5:@CSHT)
 
     F/COPY WNCPYSRC,AOCUSTR0F1
 
      *
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
 
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
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
 
     D D@FMT         E DS                  EXTNAME(SDCUSTPD)
      ** Customer record format data structure
 
     D P@FMT         E DS                  EXTNAME(DSLDY)
      ** External Data structure to hold the outgoing record format of the
      ** file
 
     D P@Key1          DS
      ** Key input data structure
     D  @IN                    1     10
     D                                     DIM(10) ASCEND                       Input array
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
 
     C                   MOVEA     CPY@          CPY2@            80
 
      ** Receive parameter list
 
     C     *ENTRY        PLIST
     C                   PARM                    P@RtCd            7
     C                   PARM                    P@Optn            7
     C                   PARM                    P@Key1
     C                   PARM                    P@Kyst            7
     C                   PARM                    P@FMT
 
      ** Access option *SAME input
 
     C     P@Optn        IFEQ      '*SAME '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   ENDIF
 
      ** Reset error indicators
 
     C                   SETOFF                                       909192
     C                   SETOFF                                       939495
     C                   SETOFF                                       969798
 
      ** Test indicators
 
     C                   SETOFF                                       505152
 
      ** Selection indicators
 
     C                   SETOFF                                       535455
 
      ** Key status
 
     C                   MOVE      *BLANK        P@Kyst
 
      ** Align key
 
     C                   MOVE      *BLANK        W@ALGN           10
 
      ** Check key to determine file to use :
      *****1.*Check*for*all*numeric,*no*embedded*blanks***->*Customer*No.*****                CSD027
      *****2.*Check*for*first*character*=*Alphabetic******->*Shortname********                CSD027
      *****3.*Otherwise,*key*field*is*in*error********************************                CSD027
      *    If the search is for a six long string                                             CSD027
      *         Check against the customer number file                                        CSD027
      *    If the check of SDCUSTPD failed or if search string is not six long                CSD027
      *         Check against the customer shortname file                                     CSD027
      *    If not found key field is in error                                                 CSD027
 
     C     P@Optn        IFEQ      '*KEY   '
     C     P@Optn        OREQ      '*VERIFY'
 
     C/COPY WNCPYSRC,AOCUSTR0C1
 
      ** a) Check for Selection request:
 
      ** Set pointer
 
     C                   Z-ADD     1             P1                3 0
 
     C     W@INIT        IFEQ      '?'
     C                   CALL      'SD0010S'                            55
     C                   PARM      *BLANK        P@RTC2            7
     C                   PARM      *BLANK        P@KEY2            6
 
     C     P@RTC2        COMP      *BLANK                             54
     C     *IN54         CABEQ     '1'           T@SKIP
     C     *IN55         CABEQ     '1'           T@SKIP
     C                   MOVE      *BLANK        P@Key1
     C                   MOVEL     P@KEY2        P@Key1
     C                   ENDIF
 
      ** b) Align and check number or shortname :
 
      ** Set pointer
 
     C                   Z-ADD     1             P1
     C     *BLANK        LOOKUP    @IN(P1)                            97
     C     *IN97         CABEQ     '0'           T@SKIP                   97
     C                   MOVEA     @IN(P1)       W@ALGN
     C                   MOVE      W@ALGN        P@Key1
 
     C*****W@INIT        IFLT      '0'                                                        CSD027
     C***********        SETON                                        50                      CSD027
     C***********        MOVE      '*CSHT  '     P@Kyst                                       CSD027
     C***********        ELSE                                                                 CSD027
     C*****W@BLNK        CABNE     *BLANK        T@SKIP               9797                    CSD027
     C***********        TESTN                   W@CNUM               97                      CSD027
     C******IN97*        CABEQ     '0'           T@SKIP                   97                  CSD027
     C*****W@LAST        CABLT     '0'           T@SKIP                 97                    CSD027
     C***********        MOVE      '*CNUM  '     P@Kyst                   97                  CSD027
     C***********        ENDIF                                                                CSD027
 
     C                   ENDIF
 
      ** First call - open files :
 
     C******IN50*        IFEQ      '0'                                                        CSD027
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SDCUSTL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
     C***********        ELSE                                                                 CSD027
     C     *IN02         IFEQ      '0'
     C                   SETON                                        02
     C                   OPEN      SDCUSTL2                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
 
      ** Open SDCUSTL1 if not already open for Customer number
      ** processing
 
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SDCUSTL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
     C                   ENDIF
     C***********        ENDIF                                                                CSD027
 
      ** Last call - close files and terminate program :
 
     C     P@Optn        IFEQ      '*FREE  '
     C   01              CLOSE     SDCUSTL1                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C   02              CLOSE     SDCUSTL2                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** Caller requests first record :
 
     C     P@Optn        IFEQ      '*FIRST '
     C     *LOVAL        SETLL     @CNUM                              9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@Optn
     C                   ENDIF
      *                                                                                       CSD027
      * Caller requests SETLL record :                                                        CSD027
      *                                                                                       CSD027
     C     P@OPTN        IFEQ      '*SETLL '                                   IF SETLL RECORDCSD027
     C     W@CNUM        SETLL     @CNUM                              9390       Set file     CSD027
     C     *IN93         CABEQ     '1'           T@SKIP                          Empty file   CSD027
     C     *IN90         CABEQ     '1'           T@SKIP                   LR     File error   CSD027
     C                   MOVE      '*NEXT  '     P@OPTN                          Force *Next  CSD027
     C                   END                                                   FI             CSD027
 
      ** Caller requests next record :
 
     C     P@Optn        IFEQ      '*NEXT  '
     C                   READ      @CNUM                                9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
      ** Caller requests last record :
 
     C     P@Optn        IFEQ      '*LAST  '
     C     *HIVAL        SETGT     @CNUM                                90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@Optn
     C                   ENDIF
 
      * Caller requests SETGT record :                                                        CSD027
      *                                                                                       CSD027
     C     P@OPTN        IFEQ      '*SETGT '                                   IF SETGT RECORDCSD027
     C     W@CNUM        SETGT     @CNUM                                90       Set file     CSD027
     C     *IN90         CABEQ     '1'           T@SKIP                   LR     File error   CSD027
     C                   MOVE      '*PREV  '     P@OPTN                          Force *Prev  CSD027
     C                   END                                                   FI             CSD027
      *                                                                                       CSD027
      ** Caller requests previous record :
 
     C     P@Optn        IFEQ      '*PREV  '
     C                   READP     @CNUM                                9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
      ** Caller requests record indicated by key :
 
     C     P@Optn        IFEQ      '*KEY   '
     C     P@Optn        OREQ      '*VERIFY'
     C**N50W@CNUM*       CHAIN     @CNUM                              9590                    CSD027
     C***50W@CSHT*       CHAIN     @CSHT                              9590                    CSD027
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
 
     C                   IF        *IN95 = *off
     C     BBDTDL        IFNE      0
     C                   SETON                                        95
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        *IN95 = *off
     C                   IF        BBCLST = 'Y'
     C                   MOVEL     '1'           *IN95
     C                   ENDIF
     C                   ENDIF
 
     C     *IN95         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
      *
     C     P@Optn        IFNE      '*KEY   '
     C     P@Optn        ANDNE     '*NEXT  '
     C     P@Optn        ANDNE     '*PREV  '
     C     P@Optn        ANDNE     '*VERIFY'
     C     P@Optn        ANDNE     '*FREE  '
     C                   SETON                                          96
     C                   ENDIF
 
      * No record found or End of file - return error code :
 
     C     T@SKIP        TAG
     C                   MOVE      *BLANK        P@RtCd
     C   90              MOVE      '*ERROR '     P@RtCd
     C   91              MOVE      '*OPEN  '     P@RtCd
     C   92              MOVE      '*CLOSE '     P@RtCd
     C   93              MOVE      '*EMPTY '     P@RtCd
     C   94              MOVE      '*EOF   '     P@RtCd
     C   95              MOVE      '*NRF   '     P@RtCd
     C   96              MOVE      '*OPTION'     P@RtCd
     C   97              MOVE      '*KEY   '     P@RtCd
     C   54              MOVE      '*NOSEL '     P@RtCd
     C   55              MOVE      '*CALL  '     P@RtCd
     C   97              MOVE      '*ERROR '     P@Kyst
 
      ** Caller requests message sent to program queue :
 
     C     W@RtCd        IFEQ      '*MSG   '
     C     P@RtCd        ANDNE     *BLANK
     C   90              MOVE      'ACO1001'     P@MGID
     C   91              MOVE      'ACO1002'     P@MGID
     C   92              MOVE      'ACO1003'     P@MGID
     C   93              MOVE      'ACO1004'     P@MGID
     C   94              MOVE      'ACO1005'     P@MGID
     C   95              MOVE      'ACO1006'     P@MGID
     C   96              MOVE      'ACO1007'     P@MGID
     C   97              MOVE      'ACO1008'     P@MGID
     C   54              MOVE      'ACO1009'     P@MGID
     C   55              MOVE      'ACO1010'     P@MGID
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANK        W@RtCd            7
     C                   PARM      PGNAME        P@PGNM           10
     C                   PARM      '*PRV'        P@DEST            5
     C                   PARM                    P@MGID            7
     C                   PARM      *BLANK        P@MSGF           10
     C                   PARM      *BLANK        P@MGKY            4
     C                   PARM                    P@MGDA           50
     C                   PARM      '*DIAG'       P@MGTP            7
     C                   ENDIF
 
      ** Caller Requests DB Error Handling
 
     C     W@RtCd        IFEQ      '*DBERR '
     C     P@RtCd        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C     P@Optn        IFNE      '*VERIFY'
     C     P@Optn        ANDNE     '*FREE  '
     C     P@RtCd        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   ENDIF
 
     C/COPY WNCPYSRC,AOCUSTR0C2
 
      ** Return to caller :
 
     C                   RETURN
 
      *****************************************************
 
** CTDATA @MG
SDCUSTPD  AOCUSTR0  Customer Details
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
