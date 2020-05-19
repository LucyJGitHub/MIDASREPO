     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Submit report using command key')             *
      *****************************************************************
      *                                                               *
      *  Midas - (module name) Module                                 *
      *                                                               *
      *  FC0040X- Submit report using command key                     *
      *                                                               *
      *  Function:  This program submits a report using command key   *
      *  (phase(s))                                                   *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 262779             Date 23Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 255781             Date 01Aug08               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG3500            Date 06Jul04               *
      *                 TDA035             Date 02Apr04               *
      *                 CSC023             Date 28Jan04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 14Nov01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CGL008             Date 03Mar99               *
      *                 105398             Date 08May97               *
      *                 087380             Date 10May95               *
      *                 E39022             Date 30APR92               *
      *                 S01117             Date 25MAR92               *
      *                 S01269             Date 25JUN91               *
      *                 LN1190             Date 29APR91               *
      *                 RT0032             Date 14MAY91               *
      *                 RT0078             Date 10MAY91               *
      *                 LN1197             Date 13MAR91               *
      *                 LN1128             Date 13MAR91               *
      *                 LN1063             Date 13MAR91               *
      *                 LN0911             Date 28OCT90               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  262779 - Job GL0101C fails with authority issues when trying *
      *           to access data areas in xxGTALIB. Reverse fix 255781*
      *           to include parameter USER(*JODB) in the submit cmd. *
      *  255781 - SBMJOB user must be the default (i.e., *CURRENT)    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *      BUG3500- Get user name from ZMUSER for java users        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *      CPK014 - Submit jobs with user *JOBD                     *
      *      CGL008 - Security on Journal Entry. Recompile.           *
      *      105398 - Change the report distribution to output queue  *
      *               defined for the user in SPF. If outq not        *
      *               defined, MPRINT will be used.                   *
      *      087380 - Enlarge parameter for AOUSERR0                  *
      *      E39022 - SHOULD ACCESS USER'S BRANCH REGARDLESS OF MBIN  *
      *      S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD              *
      *      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO
      *               MUSERDD
      *      LN1190 - REMOVE 'USR' MESSAGES AND REPLACE WITH 'RCF'    *
      *               MESSAGES.                                       *
      *      RT0032 - AMEND PROGRAM TO SUBMIT THE INCUT CYCLE REPORT  *
      *               VIA A NEW PROGRAM CLP/FCC0200. THIS ENHANCEMENT *
      *               ALLOWS MULTIPLE LANGUAGE SUPPORT OVERRIDES TO   *
      *               BE APPLIED TO THE BATCH JOB IN WHICH THE REPORT *
      *               RUNS. AT PRESENT THE OVERRIDES ARE LOST WHEN    *
      *               QCMDEXC IS CALLED.                              *
      *      RT0078 - LN1128 CREATED A PROBLEM WITH A SINGLE BATCH    *
      *               REQUEST. THE 'QUOTE' MARKS SHOULD ONLY BY PUT ON*
      *               THE SBMJOB CMD IF A PARAMETER IS BEING PASSED.  *
      *               PLEASE NOTE THAT THE COMPILE TIME ARRAY UUSB HAS*
      *               ALSO BEEN CHANGED.
      *      LN1197 - ADD DEFAULTS FOR OUTQ AND INLLIBL TO SBMJOB CMD *
      *      LN1128 - CALLING PARAMETER (100) SHOULD HAVE QUOTES IN   *
      *               ARRAY UUSB                                      *
      *      LN1063 - SEND 'MIDAS' MESSAGE TO MSTATUS AND SUBMIT      *
      *               MIDASRMV BATCH JOB AFTER SUBMITTING REPORT      *
      *      LN0911 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.         *
      *                                                               *
      *****************************************************************
      *
     F*FCREPTL1* IF   E           K DISK                                                    MD055265
      * RTV: Report Descriptions       Retrieval index
      *
     F*FCRCOML1* IF   E           K DISK                                                    MD055265
      * RTV: Report Components         Retrieval index
      *
     FFCRREQL0  IF A E           K DISK
      * UPD: Report Requests           Update index
      *
     D**********          UUSB    1   2 80                                LN0911
     D**********          UUSB    1   3 80                                LN0911
     D********************UUSB    1   5 80                          LN1063RT0032
     D**********          UUSB    1   6 80                                RT0032              CPK014
     D UUSB            S             80    DIM(7) CTDATA PERRCD(1)
     D*
     D** ARRAY TO CONTAIN SBMJOB COMMAND
     D*
     D**********          @CN     1   6 25               Long constants.
     D @CN             S             25    DIM(7) CTDATA PERRCD(1)              Long constants.
     D*
     D*
     D*
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
     D ZMUSER        E DS                  EXTNAME(ZMUSER)                                         B
     D  ##DPPT       E                     EXTFLD(DPPT)                                            B
     D  ##DBRN       E                     EXTFLD(DBRN)                                            B
     D  ##BANK       E                     EXTFLD(BANK)                                            B
      * Program data structure.
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D D@USER        E DS                  EXTNAME(MUSERDD)
     D*
     D* USER DETAILS DATA STRUCTURE FOR ASSIGNING DATA FROM ACCESS PGM
     D*
     D***UUFDY*****E*DSDSFDY                                              087380
     D UUSDY         E DS                  EXTNAME(DSSDY)                       087380
     D*
     D* 200 BYTE DATA STRUCTURE FOR INCOMING DATA ROM ACCESS PGM
     D*
     D REPSEQ          DS
     D*
     D** REPORT SEQUENCE NUMBER DATA AREA
     D*
     D  UUSEQ                  1      5  0
     D UUCMD           DS
     D*
     D** DATA STRUCTURE FOR SETTING UP SBMJOB COMMAND
     D*
     D****************************************1  80 UU1                   RT0032
     D***************************************12  21 UURNAM                RT0032
     D***************************************46  55 UUCNAM                RT0032
     D  UU1                    1     51                                         RT0032
     D/COPY WNCPYSRC,FC0040XI01
     D  UU6                  183    199                                         RT0032
     D  UURNAM               187    196                                         RT0032
     D/COPY WNCPYSRC,FC0040XI02
     D  UUCOTT                52     61                                         RT0032
     D*
     D** PARAMETERS IF REQUIRED
     D*
     D***************************************62 161 UU2                   RT0032
     D  UUCNAM                12     21                                         RT0032
     D*
     D** SEQUENCE/LEVEL/ENTITY
     D*
     D**************************************162 241 UU3                   RT0032
     D**************************************163 167 UURQSQ                RT0032
     D**************************************171 171 UULVL                 RT0032
     D**************************************175 177 UUETTY                RT0032
     D**************************************180 180 @QUOT1          RT0078RT0032
     D*************                         179 278 UUPARM                LN1128
     D**************************************181 280 UUPARM          LN1128RT0032
     D*************                         281 281 @QUOTE          LN1128RT0078
     D**************************************281 281 @QUOT2          RT0078RT0032
     D*************                         279 280 UUBRAK                LN1128
     D**************************************282 283 UUBRAK          LN1128RT0032
     D*************                         281 294 UU4             LN0911LN1197
     D**************************************284 327 UU4             LN1197RT0032
     D  UU3                   62     82                                         RT0032
     D  UURQSQ                65     69                                         RT0032
     D  UULVL                 73     73                                         RT0032
     D  UUETTY                77     79                                         RT0032
     D/COPY WNCPYSRC,FC0040XI03
     D  UUPARM                83    182                                         RT0032
     D********                              205 261 UU4                   RT0032              CPK014
     D**********                            205 273 UU4                                CPK014 255781
     D**********                            205 261 UU4                                255781 262779
     D  UU4                  205    273
     D  UUCSEQ               200    204                                         RT0032
     D/COPY WNCPYSRC,FC0040XI04
     D*
     D UUCMD2          DS
      *                                                                                       CPK014
      ** Data structure for MIDASRMV SBMJOB command                                           CPK014
      *                                                                                       CPK014
     D  UUSBM1                 1     71
     D**********                             73  83 UUSBM2                             CPK014 CSC023
     D  UUSBM2                73     95
      *                                                                                       CPK014
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * I:    Report name
     D  P1RNAM                 1     10
     D P2PARM          DS
      * I:    Component Name
     D  P2COTT                 1     10
     D P3PARM          DS
      * I:    Component Sequence Number
     D  P3CSEQ                 1      5
     D P4PARM          DS
      * I:    Calling Parameters
     D  P4CLPM                 1    100
     D P5PARM          DS
      * I:    Multi-branching Indicator
     D  P5MBIN                 1      1
     D P6PARM          DS
      * I:    Level
     D  P6LVL                  1      1
     D P7PARM          DS
      * I:    Entity
     D  P7ETTY                 1      3
     D FCRCOM        E DS                  EXTNAME(FCRCOJW0)                                MD055265
     D FCREPT        E DS                  EXTNAME(FCREPJW0)                                MD055265
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1RNAM        PARM                    WP0001           10            Report name
     C     P2COTT        PARM                    WP0002           10            Component Name
     C     P3CSEQ        PARM                    WP0003            5            Component Seque
     C     P4CLPM        PARM                    WP0004          100            Calling Paramet
     C     P5MBIN        PARM                    WP0005            1            Multi-branching
     C     P6LVL         PARM                    WP0006            1            Level
     C     P7ETTY        PARM                    WP0007            3            Entity
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Submit Report Program
      * User Data Structure - standard functions  *
      *****************************************************************
      **
      ** DEFINE USER DETAILS DATA STRUCTURE
      ** LAST AMEND : 00                         DATE : 00/00/00
      **
      * 200 Byte Access Program - standard functions  *
      *****************************************************************
      **
      ** DEFINE 200 BYTE DATA STRUCTURE
      ** LAST AMEND : 00                         DATE : 00/00/00
      **
      * Submit Report
      * Next Report Sequence No. - standard functions  *
     C*
      ** ACCESS DATA AREA REPSEQ FOR NEXT SEQUENCE NUMBER, AND UPDATE
     C*
     C     *DTAARA       DEFINE                  REPSEQ
     C     *LOCK         IN        REPSEQ
     C                   MOVE      UUSEQ         WURQSQ
     C                   ADD       1             UUSEQ
     C                   OUT       REPSEQ
      * Get Default Output Id - Report Descriptions  *
     C                   EXSR      SARVGN
      * Retrieve parameters - Report Components  *
     C                   EXSR      SBRVGN
      *CASE:     PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(02)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     WUDFTO        WUSOID                         Instruction Ide
      * Set Up Time - standard functions  *
     C                   MOVEL     ##JTM         WURQTM
     C                   MOVEL     ##USR         WUUSRR                         User ID For Req
     C                   MOVEL     @CN(04)       WUAPOP                         Access Option  E3902
     C                   MOVEL     @CN(05)       WUAPRC                         Access Program E3902
     C*                                                                   E39022
     C** ACCESS MUSER FOR USER'S DEFAULT BRANCH                           E39022
     C*                                                                   E39022
     C     USRID         IFNE      *BLANKS
     C                   MOVE      USRID         WUUSRR
     C                   ENDIF
     C                   CALL      'AOUSERR0'                                                  E3902
     C                   PARM                    WUAPRC            7                           E3902
     C                   PARM                    WUAPOP            7                           E3902
     C                   PARM                    WUUSRR           10                           E3902
     C***********D@USER    PARM D@USER    UUFDY                     E39022087380
     C     D@USER        PARM      D@USER        UUSDY                                         08738
     C*                                                                   E39022
     C                   MOVE      DBRN          WUDBRN                                        E3902
     C                   MOVE      DPPT          WUDEPT                                        E3902
      *CASE:     PAR.Multi-branching Indicator is Multibranch system
     C     P5MBIN        IFEQ      @CN(03)                                      *IF
     C**********           MOVEL@CN,04    WUAPOP           Access Option  E39022
     C**********           MOVEL@CN,05    WUAPRC           Access Program E39022
     C                   MOVEL     P7ETTY        WUETTY                         Entity
     C                   MOVEL     P6LVL         WULVL                          Level
      * Call access pgm for MUSER - standard functions  *
     C**********                                                          E39022
     C***ACCESS*MUSER FOR USER'S DEFAULT BRANCH                           E39022
     C**********                                                          E39022
     C**********           CALL 'AOUSERR0'                                E39022
     C**********           PARM           WUAPRC  7                       E39022
     C**********           PARM           WUAPOP  7                       E39022
     C**********           PARM           WUUSRR 10                       E39022
     C********** D@USER    PARM D@USER    UUFDY                           E39022
     C**********                                                          E39022
     C**********           MOVE DBRN      WUDBRN                          E39022
     C**********           MOVE DPPT      WUDEPT                          E39022
     C*
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     *BLANK        WULVL                          Level
     C                   MOVEL     *BLANK        WUETTY                         Entity
     C**********           MOVEL*BLANK    WUDBRN           User's Branch  E39022
     C                   END                                                    *FI
      * Create Report Requests - Report Requests  *
     C                   EXSR      SCCRRC
      * Send 'MIDAS' message to message queue MSTATUS                     LN1063
     C                   CALL      'QCMDEXC'                                                   LN106
     C                   PARM                    UUSB(4)                                       LN106
     C                   PARM      35            UULEN                                         LN106
      * QCMDEXC for submit report - standard functions  *
     C*
     C** SUBMIT REPORT TO BATCH
     C*
     C*********************MOVE UUSB,1    UU1                             RT0032
     C                   MOVEL     UUSB(1)       UU1                                           RT003
     C                   MOVEL     UUSB(2)       UU3
     C                   MOVEL     UUSB(3)       UU4                                           LN091
     C                   MOVEL     UUSB(6)       UU6                                           RT003
     C                   MOVEL     P1RNAM        UURNAM
     C                   MOVEL     P2COTT        UUCNAM
     C                   MOVEL     UUSB(5)       UUSBM1
     C                   MOVEL     UUSB(7)       UUSBM2
     C*********************MOVELWUCLPM    UU2                             RT0032
     C***********P4CLPM    IFEQ *BLANKS                             RT0078RT0032
     C*********************MOVEL*BLANKS   @QUOT1                    RT0078RT0032
     C*********************MOVEL*BLANKS   @QUOT2                    RT0078RT0032
     C*********************ELSE                                     RT0078RT0032
     C*********************MOVEL@CN,07    @QUOT1                    RT0078RT0032
     C*********************MOVEL@CN,07    @QUOT2                    RT0078RT0032
     C                   MOVEL     P4CLPM        UUPARM
     C*********************END                                      RT0078RT0032
     C                   MOVEL     WURQSQ        UURQSQ
     C                   MOVEL     P6LVL         UULVL
     C                   MOVEL     P7ETTY        UUETTY
     C                   MOVEL     P2COTT        UUCOTT                                        RT003
     C                   MOVEL     P3CSEQ        UUCSEQ                                        RT003
     C*********************MOVE '))'      UUBRAK                          RT0032
     C                   CALL      'QCMDEXC'
     C                   PARM                    UUCMD
     C/COPY WNCPYSRC,FC0040XC01
     C**********           PARM 280       UULEN  155                      LN0911
     C**********           PARM 294       UULEN  155                LN0911LN1197
     C*********************PARM 327       UULEN  155                LN1197RT0032
     C**********           PARM 261       UULEN  155                      RT0032              CPK014
     C**********           PARM 273       UULEN  155                                   CPK014 255781
     C**********           PARM 261       UULEN  155                                   255781 262779
     C                   PARM      273           UULEN            15 5
     C/COPY WNCPYSRC,FC0040XC02
     C*
      * Submit 'MIDASRMV' batch job                                       LN1063
     C                   CALL      'QCMDEXC'                                                   LN106
     C**********           PARM           UUSB,5                          LN1063              CPK014
     C**********           PARM 71        UULEN                           LN1063              CPK014
     C                   PARM                    UUCMD2
     C**********           PARM 83        UULEN                                        CPK014 CSC023
     C                   PARM      95            UULEN
      *----------------------------------------------------------------
      * Exit program.
     C     AAEXIT        TAG
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Get Default Output Id - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSA         KLIST
     C                   KFLD                    DXRNAM                         Report name
      * Move fields to key list.
     C                   MOVEL     P1RNAM        DXRNAM                         Report name
     C*****KRSSA         CHAIN     @DXREIK                            90        *           MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCRPEJW0                                                                       MD055265
     C+ where DXRNAM = :DXRNAM                                                              MD055265
     C/END-EXEC                                                                             MD055265
     C******IN90         IFEQ      '1'                                                      MD055265
     C                   If        SQLCODE = 100                                            MD055265
      * DBF Record not found.
     C**********           MOVEL'USR0712' W0RTN   7                       LN1190
     C                   MOVEL     'RCF0712'     W0RTN             7                           LN119
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(01)       W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     DXDFTO        WUDFTO                         Default Output
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Retrieve parameters - Report Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSB         KLIST
     C                   KFLD                    D3RNAM                         Report name
     C                   KFLD                    D3COTT                         Component Name
     C                   KFLD                    D3CSEQ                         Component Seque
      * Move fields to key list.
     C                   MOVEL     P1RNAM        D3RNAM                         Report name
     C                   MOVEL     P2COTT        D3COTT                         Component Name
     C                   MOVEL     P3CSEQ        D3CSEQ                         Component Seque
     C*****KRSSB         CHAIN     @D3REI5                            90        *           MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRCOM                                                                        MD055265
     C+ from FCRCOJW0                                                                       MD055265
     C+ where D3RNAM = :D3RNAM and D3COTT = :D3COTT and D3CSEQ = :D3CSEQ                    MD055265
     C/END-EXEC                                                                             MD055265
     C******IN90         IFEQ      '1'                                                      MD055265
     C                   If        SQLCODE = 100                                            MD055265
      * DBF Record not found.
     C**********           MOVEL'USR0724' W0RTN   7                       LN1190
     C                   MOVEL     'RCF0724'     W0RTN             7                           LN119
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(01)       W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C******IN90         IFEQ      '0'                                                      MD055265
     C                   If        SQLCODE = 0                                              MD055265
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     D3CLPM        WUCLPM                         Calling Paramet
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCRRC        BEGSR
      *================================================================
      * Create Report Requests - Report Requests  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @D5REI8
     C                   MOVEL     WURQSQ        D5RQSQ                         Sequence Number
     C                   MOVEL     P1RNAM        D5RNAM                         Report name
     C                   MOVEL     WUSOID        D5SOID                         Instruction Ide
     C                   MOVEL     WULVL         D5LVL                          Level
     C                   MOVEL     WUETTY        D5ETTY                         Entity
     C                   MOVEL     @CN(03)       D5IPCY                         Input Cycle
     C                   MOVEL     @CN(06)       D5PDFL                         Periodic
     C                   MOVEL     *BLANK        D5DLS1                         Distribution Li
     C                   MOVEL     *BLANK        D5DLS2                         Distribution Li
     C*******              MOVEL*BLANK    D5USRO           User ID For Out105398
     C                   MOVEL     WUUSRR        D5USRO                         User ID For Out10539
     C                   MOVEL     @CN(06)       D5ARMF                         Archived On Mic
     C                   MOVEL     @CN(06)       D5AROD                         Archived On Opt
     C                   MOVEL     @CN(06)       D5DRQD                         Distribution Re
     C                   MOVEL     WUUSRR        D5USRR                         User ID For Req
     C                   MOVEL     WUDBRN        D5DBRN                         User's Branch
     C                   Z-ADD     WURQTM        D5RQTM                         Request Time
     C                   MOVEL     @CN(06)       D5COBR                         Close Of Busine
     C                   MOVEL     *BLANK        D5JBNM                         Job Name
     C                   MOVEL     *BLANK        D5JUSR                         User Name
     C                   MOVEL     *BLANK        D5JBNB                         Job Number
     C                   MOVEL     *BLANK        D5PSQR                         Periodic Sequen
     C                   MOVEL     P2COTT        D5COTT                         Component Name
     C                   MOVEL     P3CSEQ        D5CSEQ                         Component Seque
     C                   Z-ADD     *ZERO         D5TNLU                         Transaction No.
      *
     C     KLCRSC        KLIST
     C                   KFLD                    D5RQSQ                         Sequence Number
      * Check for duplicate primary key.
     C     KLCRSC        SETLL     @D5REI8                                90    *
     C     *IN90         IFEQ      '1'
     C**********           MOVEL'USR0729' W0RTN   7                       LN1190
     C                   MOVEL     'RCF0729'     W0RTN             7                           LN119
      * Send message 'Report Requests        EX'
     C**********           MOVEL'USR0729' ZAMSID           Message id.    LN1190
     C                   MOVEL     'RCF0729'     ZAMSID                         Message id.    LN119
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SCEXIT
     C                   END
      *
     C                   WRITE     @D5REI8                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Write successful.
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
      * Send if first error message or not an error message.
     C     ZAMSTP        IFNE      *BLANK
     C     ZAFSMS        ORNE      'N'
     C     ZAMSTP        IFEQ      *BLANK
      * Signal first error message sent.
     C                   MOVEL     'N'           ZAFSMS
     C                   END
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
     C                   END
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
      *                                                                   LN1128
      ** Set up quote character                                           LN1128
     C**********           MOVEL@CN,07    @QUOTE                    LN1128RT0078
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Define work field Sequence Number
     C                   MOVEL     *BLANK        WURQSQ            5
      * Define work field Default Output Id
     C                   MOVEL     *BLANK        WUDFTO           10
      * Define work field Calling Parameters
     C                   MOVEL     *BLANK        WUCLPM          100
      * Define work field Instruction Identifier
     C                   MOVEL     *BLANK        WUSOID           10
      * Define work field Request Time
     C                   Z-ADD     *ZERO         WURQTM            4 0
      * Define work field User ID For Request
     C                   MOVEL     *BLANK        WUUSRR           10
      * Define work field Access Option
     C                   MOVEL     *BLANK        WUAPOP            7
      * Define work field Access Program Return Cde
     C                   MOVEL     *BLANK        WUAPRC            7
      * Define work field Entity
     C                   MOVEL     *BLANK        WUETTY            3
      * Define work field Level
     C                   MOVEL     *BLANK        WULVL             1
      * Define work field User's Branch
     C                   MOVEL     *BLANK        WUDBRN            3
      * Define work field Department
     C                   MOVEL     *BLANK        WUDEPT            3
      * Obtain default message file.
     C     *DTAARA       DEFINE    FCMGFLA       ZADFMF           10
     C                   IN        ZADFMF
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      * Signal first error message outstanding.
     C                   MOVEL     'Y'           ZAFSMS            1
      *================================================================
     CSR   ZZEXIT        ENDSR
**  UUSB - SUBMIT REPORT TO BATCH
SBMJOB JOB(XXXXXXXXXX) CMD(CALL PGM(FCC0200) PARM('
' '     ' ' ' '   ' '
')) JOBD(MBATCH) RTGDTA(*JOBD) OUTQ(*JOBD) INLLIBL(*JOBD) USER(*JOBD)                  255781 262779
SNDMSG MSG('MIDAS') TOMSGQ(MSTATUS)
SBMJOB CMD(CALL PGM(MIDASRMV)) JOB(MIDASRMV) JOBD(MBATCH) RTGDTA(*JOBD)
@' '          ' '
USER(*JOBD) OUTQ(*JOBD)
** @CN Long constants used in program.
Y2U0005
Y2U0004
Y
*KEY
*DBERR
N
'
