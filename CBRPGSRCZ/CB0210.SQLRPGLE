     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Produce dependency table report')             *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing
     F*                                                               *
     F*  CB0210 - PRODUCE DEPENDENCY TABLE REPORT                     *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CPK030             Date 26Mar14               *
      *                 CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 180007             Date 08Jun00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPB001             Date 02Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CPL002             DATE 08MAR99               *
     F*                 CTI001             DATE 30JUL97               *
     F*                 CCB003             Date 21OCT96               *
     F*                 CAC001             DATE 17JUN96               *
     F*                 S01486             DATE 06JUN94               *
     F*                 S01498             DATE 06JUN94               *
     F*                 S01522             DATE 25NOV94               *
     F*                 S01493             DATE 19JUL94               *
     F*                 S01488             DATE 25APR94               *
     F*                 S01393             DATE 29OCT92               *
     F*                 S10736             DATE 29OCT92               *
     F*                 S01379             DATE 22SEP92               *
     F*                 S01382             DATE 11AUG92               *
     F*                 S01339             DATE 31JUL92               *
     F*                 S01310             DATE 31JUL91               *
     F*                 LN0635             DATE 16AUG90               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK030 - Program wrote out incorrect format on first line.   *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
     F*  180007 - Increase size of variables to prevent array idx err *
     F*  CPB001 - 'Private Banking' Module                            *
     F*  CPL002 - Midas - Plato Interface Enhancement.                *
     F*  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *  CCB003 - COB Performance Enhancements - Task Split           *
      *           Amended to show new fields for Task Split process.  *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Introduction of new Analytical Accounting module    *
     F*  S01486 - PORTFOLIO MANAGEMENT                                *
     F*  S01498 - PORTFOLIO LENDING                                   *
      *  S01522 - User Defined Correspondence                         *
      *  S01493 - MIDAS EXPORT DATA INTERFACE                         *   S01493
      *  S01488 - COB RUN CONDITIONS ENHANCEMENTS                     *
      *           RUNDAY COMPILE TIME ARRAY REMOVED                   *
      *  S01393 - RISK MANAGEMENT                                     *
      *  S10736 - MANAGEMENT ACCOUNTING                               *
      *  S01379 - HISTORY AND AUDIT FACILITY                          *
      *         - USE 'HF' FOR HISTORY AND AUDIT FACILITY             *
      *  S01382 - OPTICAL DISK REPORTING                              *
      *         - USE 'MF' FOR MICROFICHE, 'OD' FOR OPTICAL DISK      *
      *  S01339 - SYNDICATED LOANS MADE REDUNDANT AT R10.             *
      *  S01310 - SWIFT RATIONALISATION                               *
      *           CHANGE 'NETWORK MIDAS' (NM) TO 'MESSAGE             *
      *           MANAGEMENT' (ME) - ARRAYS MODPOS, MODNM & MODIDS    *
      *           CHANGED                                             *
      *           --- AND ADD CF (POSN 70)
     F*  LN0635 - CHANGE FRA/IRS MODULE ID FORM '#L' TO 'IR'          *
     F*                                                               *
     F*****************************************************************
     F*CBMDCNL1* IF   E           K DISK    USROPN                                          MD055891
     F*CBDPRLL1* IF   E           K DISK    USROPN                                          MD055891
     F*CBDPRLL4* IF   E           K DISK    USROPN                                          MD055891
     F*CBMEXCL1* IF   E           K DISK    USROPN                                          MD055891
     F*CBCMPNL1* IF   E           K DISK                                                    MD055891
     F*CBCMPNL4* IF   E           K DISK                                                    MD055891
     F*CBRUNCL1* IF   E           K DISK    USROPN                               S01488     MD055891
     FCB0210P1  O    E             PRINTER
     F                                     INFDS(PRINT)
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    25      ERROR ON LOKUP OF ARRAY MMODFL
     F*    30      OUTPUT 'NO. OF TASK SPLIT JOBS' FIELD ON REPORT        CCB003
     F*    35      NO RECORDS FOUND ON OR END OF FILE CBCMPNL4
     F*    36      NO RECORDS FOUND ON OR END OF FILE CBCMPNL4 ALSO
     F*            SETON AFTER SINGLE COMPONENT REPORT PRODUCED
     F*    41      FAIL ON CHAIN TO CBCMPNL1 OR NO FURTHER RECORDS
     F*            FOUND ON SAME KEY
     F*    43      FAIL ON CHAIN TO CBDPRLL1 OR NO FURTHER RECORDS
     F*            FOUND ON SAME KEY
     F*    44      FAIL ON CHAIN TO CBCMPNL1 FOR TEXT FIELD
     F*    45      FAIL ON CHAIN TO CBDPRLL1 OR NO FURTHER RECORDS
     F*            FOUND ON SAME KEY
     F*    47      FAIL ON CHAIN TO CBMEXCL1 OR NO FURTHER RECORDS
     F*            FOUND ON SAME KEY
     F*    49      FAIL ON CHAIN TO CBCMPNL4
     F*    50      ERROR ON LOKUP OF ARRAY MODPOS
     F*    70      PRINT SUB HEADING FOR FIRST RECORD ON OTHER MODULES
     F*            DETAILS FORMAT
     F*    71      PRINT SUB HEADING FOR FIRST RECORD ON DEPENDENT
     F*            COMPONENT DETAILS FORMAT
     F*    72      PRINT SUB HEADING FOR FIRST RECORD ON DEPENDS ON
     F*            COMPONENT DETAILS FORMAT
     F*    73      PRINT SUB HEADING FOR FIRST RECORD ON MUTUALLY
     F*            EXCLUSIVE COMPONENT DETAILS FORMAT
     F*    81      PRINT OTHER MODULES DETAILS SUB HEADING WITH (cont.)
     F*            FIELD
     F*    83      PRINT DEPENDENT COMPONENT DETAILS SUB-HEADING WITH
     F*            (cont.) FIELD
     F*    84      PRINT DEPENDS ON COMPONENT DETAILS SUB-HEADING WITH
     F*            (cont.) FIELD
     F*    85      PRINT MUTUALLY EXCLUSIVE COMPONENT DETAILS SUB
     F*            HEADINGS WITH (cont.) FIELD
     F*    89      PRINT 'OR' IF MORE THAN ONE RECORD FOR OTHER MODULES
     F*            DETAILS
     F*    90      END OF FILE CBRUNCL1
     F*
     F*        LR  LAST RECORD INDICATOR
     F*
     F*    U7&U8   DATABASE ERROR
     F*
     F*                 ****************************
     F*                  EXPLANATION OF MODULE CODES
     F*                 ****************************
     F*
     F*    CODE   POSITION DESCRIPTION
     F*
     F*     SD      14     STANDING DATA
     F*     MT      15     MIDAS/TELEX   MODULE
     F*     #A      16     SWIFT FUNDS TRANSFER
     F*     #B      17     SWIFT SECURITIES TRADING
     F*     #C      18     SWIFT CUSTOMER LENDING
     F******#D******19*****SWIFT SYNDICATED LOANS                         S01339
     F*     #E      20     SWIFT STATEMENTS
     F*     #F      21     SWIFT DEALING
     F*     GL      22     STANDING DATA/GENERAL LEDGER
     F*     DL      23     DEALING: FX
     F******CL******24*****SYNDICATED LOANS                               S01339
     F*     EM      25     EXPOSURE MANAGEMENT
     F*     FM      26     FINANCIAL MODELLER
     F*     ST      27     STATUTORY RETURNS
     F*     LE      28     CUSTOMER LENDING
     F*     RE      29     RETAIL BANKING
     F*     MS      30     MIDAS/S.W.I.F.T. DIRECT LINK
     F*     SE      31     SECURITIES TRADING
     F*     RC      32     AUTO-RECONCILIATIONS
     F*     #G      33     BOND DEALERS INTERFACE
     F*     FD      34     DRS STANDING DATA
     F*     CM      35     DRS CONTROL MODULE
     F*     FX      36     DRS FOREIGN EXCHANGE
     F*     MM      37     DRS MONEY MARKET
     F*     AB      38     DRS ARBITRAGE MODULE
     F*     FT      39     FUNDS TRANSFER
     F*     CA      40     DRS COMMON APPLICATIONS
     F*     FF      41     FUTURES & OPTIONS
     F******#H******42*****MIDAS/TELEX SYNDICATED LOANS                   S01339
     F*     #I      43     MIDAS/TELEX DEALING
     F*     #J      44     MIDAS/TELEX GENERAL LEDGER
     F*     #K      45     MIDAS/TELEX CUSTOMER LENDING
      *     ME      46     MESSAGE MANAGEMENT                             S01310
     F******NM******46*****NETWORK MIDAS                                  S01310
     F******#L******47     FRA/IRS INDICATOR                              LN0635
     F*     IR      47     FRA/IRS INDICATOR                              LN0635
     F*     DL      48     DEALING: MM
     F*     DL      49     INTERNAL CONTRACTS
     F*     TM      50     TREASURY MANAGEMENT
     F******#M      51     RISK MANAGEMENT                                S01393
     F*     RM      51     RISK MANAGEMENT                                S01393
     F*     TK      52     TESTKEY
     F*     MQ      53     MIDAS/Q
     F******MA******54     MICROFICHE                                     S01382
     F*     MF      54     MICROFICHE                                     S01382
     F*     IA      55     INTEREST ON ACCOUNTS MODULE
     F*             56     WINDOW PROCESSING
     F*             57     SAR PROCESSING
     F*             58     FRENCH RETURNS
     F*             59     LUX RETURNS
     F*             60     DUTCH RETURNS
     F*             61     GERMAN RETURNS
     F*             62     BELGIAN RETURNS
     F*             63     ITALIAN RETURNS
     F*             64     SWIFT EXTERNAL INTERFACE
     F*             65     PORTFLOIO MANAGEMENT
     F*             66     CREDIT MANAGEMENT
     F*             67     HEAD OFFICE REPORTING
     F*             68     AVERAGE BALANCES
     F*             69     MARGINS
     F************* 70     CONFIRMATION MATCHING                          S01310
     F*     CF      70     CONFIRMATION MATCHING                          S01310
     F*             71     MIMIX
     F*             72     REPORT CONTROL FACILITY
     F*             73     AMPS INT
     F*             74     SWISS RETURNS
     F*             75     FIDUCIARY LOANS AND DEPOSITS
     F*             76     LOMBARD CREDITS
     F*             77     CANTONAL TAX
     F*             78     STAMP DUTY
     F*             79     USE DRS SHORTNAMES
     F*             80     CHIPS DEALING
     F*             81     CHIPS LENDING
     F*             82     CHIPS OPENING BALANCE
     F*             83     CHIPS
     F*             84     CHIPS DIRECT LINK
     F**************85     OPTICAL DISK                                   S01382
     F*     OD      85     OPTICAL DISK                                   S01382
     F*     MB      86     MULTIBRANCHING INDICATOR
     F*     HF      94     HISTORY AND AUDIT FACILITY                     S01379
     F*     MC      95     MANAGEMENT ACCOUNTING                          S10736
     F*     ED      99     MIDAS EXPORT DATA INTERFACE                    S01493
     F*     CG     101     User Defined Correspondence                    S01522
     F*     PL     102     Midas Plato Interface Enhancement              CPL002
     F*     TI     103     Midas/TI Interface                             CTI001
     F*     PB     104     Private Banking                                CPB001
     F**********87-128     RESERVED FOR LATER USE                         S01379
     F* REMAINING POSITIONS RESERVED FOR LATER USE                        S01379
     F*
     F*****************************************************************
     F/EJECT
     D*
     D** COPYRIGHT ARRAY
     D*
     D MODPOS          S              2    DIM(128) CTDATA PERRCD(11)
     D** ARRAY SHOWING POSITIONS OF MODULES FROM FILE SDMMODPD
     D*
     D MODIDS          S              4    DIM(128) CTDATA PERRCD(13)
     D** ARRAY SHOWING FOUR NAME MODULE TITLE FOR REPORT
     D*
     D MODNM           S             30    DIM(128) CTDATA PERRCD(1)
     D** ARRAY TO CONVERT 2A MODULE NAME TO MEANINGFUL ENGLISH NAME
     D*
     D********************RUNDAY  1  21 76                                S01488
     D RDAY            S             70    DIM(99)                                               S01
     D** ARRAY SHOWING DAY ON WHICH REPORT IS RUN
     D*
     D VALM            S              3    DIM(10)
     D** ARRAY TO HOLD MODULE ID'S AND
     D** SWITCH SETTINGS FROM CBMDCNL1
     D*
     D OUT             S              8    DIM(10)
     D** RENAME FIELDS AS USED IN CHAIN TO CBMEXCL1
     D*
     D*OMOD            DS
     D* OTHMOD                 1     30
     D* DJMD01                 1      2
     D* DJMP01                 3      3
     D* DJMD02                 4      5
     D* DJMP02                 6      6
     D* DJMD03                 7      8
     D* DJMP03                 9      9
     D* DJMD04                10     11
     D* DJMP04                12     12
     D* DJMD05                13     14
     D* DJMP05                15     15
     D* DJMD06                16     17
     D* DJMP06                18     18
     D* DJMD07                19     20
     D* DJMP07                21     21
     D* DJMD08                22     23
     D* DJMP08                24     24
     D* DJMD09                25     26
     D* DJMP09                27     27
     D* DJMD10                28     29
     D* DJMP10                30     30
     D** DATA STRUCTURE TO TAKE MODULE ID
     D** AND SWITCH SETTING FIELDS FROM CBMDCNL1
     D*
     D MODSDT          DS
     D  VAL                    1      3
     D  FLDNM                  1      2
     D  ONOFF                  3      3
     D** DATA STRUCTURE TO SPLIT OTHER MODULE DETAILS FIELD
     D*
     D MODKDS          DS
     D  MODNMX                 1     10
     D  MODSQX                11     15
     D** DATA STRUCTURE FOR KEY FIELD MODKEY TO BE MOVED INTO DBKEY FIELD
     D*
     D COMKDS          DS
     D  CMPMDX                 1      2
     D  CMPNMX                 3     12
     D  CMPSQX                13     17
     D** DATA STRUCTURE FOR KEY FIELD COMKEY TO BE MOVED INTO DBKEY FIELD
     D*
     D DEPKDS          DS
     D  DCOPX                  1     10
     D  DSEQX                 11     15
     D** DATA STRUCTURE FOR KEY FIELD DEPKEY TO BE MOVED INTO DBKEY FIELD
     D*
     D DPCKDS          DS
     D  DPCOPX                 1     10
     D  DPSEQX                11     15
     D** DATA STRUCTURE FOR KEY FIELD DPCKEY TO BE MOVED INTO DBKEY FIELD
     D*
     D MEXKDS          DS
     D  MECOX                  1     10
     D  MESQX                 11     15
     D** DATA STRUCTURE FOR KEY FIELD MEXKEY TO BE MOVED INTO DBKEY FIELD
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D** LOCAL DATA AREA
     D*
     D PRINT           DS
     D  LINE                 367    368B 0
     D** DATA STRUCTURE FOR LINE VARIABLE
     D*
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D** DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** EXTERNAL DATA STRUCTURE FOR ACESS OBJECT AOBANKR0
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D CBDPRL        E DS                  EXTNAME(CBDPRJW0)                                MD055891
     D CBMEXC        E DS                  EXTNAME(CBMEXJW0)                                MD055891
     D CBMDCN        E DS                  EXTNAME(CBMDCJW0)                                MD055891
     D  OTHMOD                18     49                                                     MD055891
     D CBRUNC        E DS                  EXTNAME(CBRUNJW0)                                MD055891
     D TotRow          S             13  0                                                  MD055891
     D XXDMCD          S              5                                                     MD055891
     D XXKGST          S              1                                                     MD055891
     D XXDLCD          S             10                                                     MD055891
     I** ARRAY TO HOLD MODULE ID AND SWITCH
     I** SETTING TO BE OUTPUT TO REPORT
     I*
     I*****************************************************************
     I/EJECT
     I*
     I*@DHREGH**                                                                            MD055891
     I**********    DHCSEQ                      XXDMCD                                      MD055891
     I**********    DHCMEF                      XXKGST                                      MD055891
     I**********    DHCOTT                      XXDLCD                                      MD055891
     I** FIRST DATA STRUCTURE FOR ACCESS OBJECTS, SHORT DATA STRUCTURE
     I*
     I*****************************************************************
     I/EJECT
     /*
     C     *ENTRY        PLIST
     C                   PARM                    NUM               1
     C                   PARM                    CMPNM            10
     C                   PARM                    CMPSQ             5
     C                   PARM                    MODID             2
     C*
     C** KEY TO CHAIN TO CBMDCNL1
     C*
     C     MODKEY        KLIST
     C                   KFLD                    COMPNM
     C                   KFLD                    COMPSQ
     C*
     C** KEY TO CHAIN TO CBCMPNL4
     C*
     C     COMKEY        KLIST
     C                   KFLD                    COMPMD
     C                   KFLD                    COMPNM
     C                   KFLD                    COMPSQ
     C*
     C** KEY TO CHAIN TO CBDPRLL1
     C*
     C     DEPKEY        KLIST
     C                   KFLD                    DIDDON
     C                   KFLD                    DIDDOS
     C*
     C** KEY TO CHAIN TO CBDPRLL4
     C*
     C     DPCKEY        KLIST
     C                   KFLD                    DIDSON
     C                   KFLD                    DIDSOS
     C*
     C** KEY TO CHAIN TO CBMEXCL1
     C*
     C     MEXKEY        KLIST
     C                   KFLD                    DKMECN
     C                   KFLD                    DKMECS
     C*
     C** DEFINE LOCAL DATA AREA
     C*
     C     *DTAARA       DEFINE                  LDA
     C*
     C** SET UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0210  '    DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
     C*
     C** CALL AOBANKR0
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C** DATABASE ERROR IF AOBANKR0 DOES
     C** NOT EXIST OR INVALID RECORD FOUND
     C*
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   WRITE     RPTHDG
     C                   MOVEL     'BNKR0'       DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      DBERR                                        ***************
     C                   END
      *                                                                   S01488
      *    Load array of run days from CB run conditions file             S01488
      *                                                                   S01488
     C**********         OPEN      CBRUNCL1                                           S0148 MD055891
     C**********         READ      CBRUNCL1                               90          S0148 MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare RCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBRUNJW0                                                              MD055891
     C+ order by ANRUNC                                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open RCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from RCursor into :CBRUNC                                                MD055891
     C/END-EXEC                                                                             MD055891
     C******IN90         DOWEQ     '0'                                                S0148 MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
     C                   ADD       1             C                 2 0                         S0148
     C                   MOVE      ANRUNT        RDAY(C)                                       S0148
     C**********         READ      CBRUNCL1                               90          S0148 MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from RCursor into :CBRUNC                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   ENDDO                                                                 S0148
     C**********         CLOSE     CBRUNCL1                                           S0148 MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close RCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
     C*
     C** IF PARAMETER NUM = 1 MOVE COMPONENT
     C** NAME INTO REPORT TYPE FIELD
     C*
     C     NUM           IFEQ      '1'
     C                   MOVEL     CMPNM         REPTYP
     C                   END
     C*
     C** IF PARAMETER NUM = 2 MOVE MODULE TITLE INTO
     C** REPORT TYPE FIELD USING ARRAYS MODPOS AND MODNM
     C*
     C     NUM           IFEQ      '2'
     C******************** Z-ADD1         X       20                      S01522
     C                   Z-ADD     1             X                 3 0                         S0152
     C     MODID         LOOKUP    MODPOS(X)                              50
     C*
     C** IF MODULE ID NOT FOUND ON ARRAY MODPOS DATABASE ERROR
     C*
     C     *IN50         IFEQ      '0'
     C     *LOCK         IN        LDA
     C                   WRITE     RPTHDG
     C                   MOVEL     'MODPS'       DBFILE
     C                   MOVEL     MODID         DBKEY                          ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   MOVEL     MODNM(X)      REPTYP
     C*
     C                   END
     C*
     C** IF PARAMETER NUM = 3 MOVE 'ALL COMPONENTS'
     C** INTO REPORT TYPE FIELD USING WORK FIELD FLDZZ
     C*
     C     NUM           IFEQ      '3'
     C                   MOVEL     'ALL COMP'    FLDZZ            14
     C                   MOVE      'ONENTS'      FLDZZ
     C                   MOVEL     FLDZZ         REPTYP
     C                   END
     C*
     C** WRITE REPORT HEADER
     C*
     C                   WRITE     RPTHDG
     C*
     C** IF NUM = 1 CHAIN TO CBCMPNL4 TO FIND RECORD
     C*
     C     NUM           IFEQ      '1'
     C                   MOVE      MODID         COMPMD            2
     C                   MOVE      CMPNM         COMPNM           10
     C                   MOVE      CMPSQ         COMPSQ            5
     C*****COMKEY        CHAIN     @CMPNHK                            49                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :COMPNM and DHCSEQ = :COMPSQ and DHCMOD = :COMPMD                    MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C*
     C** IF RECORD NOT ON CBCMPNL4 DATABASE ERROR
     C*
     C******IN49         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C     *LOCK         IN        LDA
     C                   MOVEL     'CMPL4'       DBFILE
     C                   MOVE      COMPMD        CMPMDX
     C                   MOVE      COMPNM        CMPNMX
     C                   MOVE      COMPSQ        CMPSQX
     C                   MOVEL     COMKDS        DBKEY                          ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   EXSR      RPTDET
     C*
     C                   END
     C*
     C** IF NUM = 2 READ FILE CBCMPNL4 TO FIND RECORDS
     C*
     C     NUM           IFEQ      '2'
     C*****MODID         SETLL     @CMPNHK                                35                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare XCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ where DHCMOD = :MODID                                                               MD055891
     C+ order by DHCMOD, DHCOTT, DHCSEQ                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open XCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ get diagnostics :TotRow  = db2_number_rows                                          MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close XCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       35                    MD055891
     C                   IF        TotRow  > 0                                              MD055891
     C                   Seton                                        35                    MD055891
     C                   Endif                                                              MD055891
     C*
     C** IF NO RECORDS FOR THIS MODULE WRITE
     C** NO DETAILS TO REPORT FORMAT
     C*
     C     *IN35         IFEQ      '0'
     C                   WRITE     NODTRP
     C*
     C                   ELSE
     C*****MODID         READE     @CMPNHK                                35                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare BCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ where DHCMOD = :MODID                                                               MD055891
     C+ order by DHCMOD, DHCOTT, DHCSEQ                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open BCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from BCursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       35                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        35                    MD055891
     C                   Endif                                                              MD055891
     C*
     C     *IN35         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CMPL4'       DBFILE
     C                   MOVEL     MODID         DBKEY                          ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   EXSR      RPTDET
     C*
     C                   END
     C*
     C                   END
     C*
     C** IF NUM = 3 READ COMPONENTS FILE TO FIND RECORDS
     C*
     C     NUM           IFEQ      '3'
     C**********         READ      @CMPNHK                                36                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare CCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ order by DHCMOD, DHCOTT, DHCSEQ                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open CCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from CCursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       36                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        36                    MD055891
     C                   Endif                                                              MD055891
     C*
     C** IF NO RECORDS ON CBCMPNL4 DATABASE ERROR
     C*
     C     *IN36         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CMPL4'       DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     5             DBASE                          * DB ERROR 05 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   EXSR      RPTDET
     C*
     C                   END
     C*
     C** WRITE 'END OF REPORT' LINE
     C*
     C                   WRITE     RPTEND
     C*
     C/EXEC SQL                                                                             MD055891
     C+ close BCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close CCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close DCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close ECursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close MCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
     C                   SETON                                        LR
     C*
     C***************************************************************
     C/EJECT
     C********************************************************************
     C**
     C** INDEX OF SUBROUTINES
     C**
     C**
     C** RPTDET - TO PRODUCE REPORT DETAILS
     C**
     C** DBERR  - DATABASE ERROR HANDLING
     C**
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** RPTDET - SUBROUTINE TO PRODUCE REPORT DETAILS
     C*
     C     RPTDET        BEGSR
     C*
     C** DO WHILE RECORDS FOUND ON CBCMPNL4
     C*
     C     *IN36         DOWNE     '1'
     C*
     C** SETON INDICATORS FOR PRINTING REPORT SECTION HEADINGS
     C*
     C                   SETON                                        707172
     C                   SETON                                        73
     C*
     C** SET UP RUN TYPE FIELD VIA ARRAY
     C** ADD ONE AS FIRST TYPE IS '00'
     C*
     C                   MOVE      DHCFRQ        T                 2 0
     C                   ADD       1             T
     C*********************MOVE RUNDAY,T  RUNTP                           S01488
     C                   MOVEL     RDAY(T)       RUNTP                                         S0148
     C*
      ** Only display 'No. of Task Split Jobs' field if                   CCB003
      ** 'Task Split Job' field is 'Y'.                                   CCB003
      *                                                                   CCB003
     C                   MOVE      '0'           *IN30                                         CCB00
      *                                                                   CCB003
     C     DHTASK        IFEQ      'Y'                                                         CCB00
     C                   MOVE      '1'           *IN30                                         CCB00
     C                   ELSE                                                                  CCB00
     C                   MOVE      'N'           DHTASK                                        CCB00
     C                   ENDIF                                                                 CCB00
     C** WRITE COMPONENT DETAILS FORMAT
     C*
     C                   WRITE     COMPDT
     C*
     C** IF THERE ARE EXTRA MODULES RELATING TO THIS COMPONENT
     C*
     C     DHCEMI        IFEQ      'Y'
     C*
     C** OPEN FILE CBMDCNL1 AND CHAIN FOR OTHER MODULES DETAILS
     C*
     C**********         OPEN      CBMDCNL1                                                 MD055891
     C                   MOVE      DHCOTT        COMPNM
     C                   MOVE      DHCSEQ        COMPSQ
     C*****MODKEY        CHAIN     @DJREGN                            41                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close FCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare FCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMDCJW0                                                              MD055891
     C+ where DJCOTT = :COMPNM and DJCSEQ = :COMPSQ                                         MD055891
     C+ order by DJCOTT, DJCSEQ, DJMCUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open FCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from FCursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C*
     C** IF NO RECORDS ON CBMDCNL1 CLOSE FILE
     C** AND PERFORM DATABASE ERROR SUBROUTINE
     C*
     C******IN41         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C**********         CLOSE     CBMDCNL1                                                 MD055891
     C     *LOCK         IN        LDA
     C                   MOVEL     'MDCL1'       DBFILE
     C                   MOVE      COMPNM        MODNMX
     C                   MOVE      COMPSQ        MODSQX
     C                   MOVEL     MODKDS        DBKEY                          ***************
     C                   Z-ADD     6             DBASE                          * DB ERROR 06 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** DO WHILE SAME KEY
     C*
     C******IN41         DOWEQ     '0'                                                      MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
     C*
     C** SET UP ARRAYS TO DETERMINE OTHER MODULE DETAILS TO REPORT
     C*
     C                   MOVE      *BLANKS       OUT
     C                   MOVEA     OTHMOD        VALM
     C**********           Z-ADD1         Z       20                      180007
     C**********           Z-ADD1         CNT     20                      180007
     C                   Z-ADD     1             Z                 3 0                         18000
     C                   Z-ADD     1             CNT               3 0                         18000
     C                   MOVE      VALM(CNT)     VAL
     C*
     C** DO FOR EACH OF THE TEN RECORDS UNLESS ONE IS BLANK,
     C** IF ONE BLANK RECORD FOUND ALL REMAINDER ARE ASSUMED BLANK
     C*
     C     Z             DOWLE     10
     C     FLDNM         ANDNE     *BLANKS
     C*
     C** ZEROISE LOKUP FIELD IN ORDER TO SEARCH WHOLE
     C** ARRAY FOR EACH MODULE ID ON OTHER MODULES FILE
     C*
     C**********           Z-ADD1         Y       20                      180007
     C                   Z-ADD     1             Y                 3 0                         18000
     C*
     C     FLDNM         LOOKUP    MODPOS(Y)                              25
     C*
     C     *IN25         IFEQ      '0'
     C     *LOCK         IN        LDA
     C                   MOVEL     'MODPS'       DBFILE
     C                   MOVEL     FLDNM         DBKEY                          ***************
     C                   Z-ADD     7             DBASE                          * DB ERROR 07 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   MOVEL     MODIDS(Y)     OUT(Z)
     C                   MOVE      *BLANKS       WORK              3
     C                   MOVEL     ONOFF         WORK
     C                   MOVE      WORK          OUT(Z)
     C                   ADD       1             Z
     C                   ADD       1             CNT
     C                   MOVE      VALM(CNT)     VAL
     C                   END
     C*
     C                   MOVEA     OUT           OTMDFL
     C*
     C*
     C** IF PAGE IS WRITING ON LINE 56 OR BELOW
     C** WRITE CONTINUATION LINE AND NEXT PAGE
     C** HEADING AND SET ON INDICATOR TO WRITE SUB-HEADING
     C*
     C     LINE          IFGE      56
     C                   WRITE     CONLIN
     C                   SETON                                        81
     C*
     C                   WRITE     RPTHDG
     C                   WRITE     OTMDDT
     C*
     C** SET OFF SUB HEADING LINE INDICATOR
     C*
     C                   SETOFF                                       81
     C*
     C                   ELSE
     C*
     C                   WRITE     OTMDDT
     C*
     C** SET OFF INDICATOR AFTER FIRST PRINT OF SUB-HEADING
     C*
     C     *IN70         IFEQ      '1'
     C                   SETOFF                                       70
     C                   END
     C*
     C                   END
     C*
     C** READ NEXT RECORD WITH SAME KEY
     C*
     C*****MODKEY        READE     @DJREGN                                41                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from FCursor into :CBMDCN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C*
     C** OUTPUT 'OR' TO REPORT LINE IF FURTHER RECORDS FOUND
     C*
     C******IN41         IFEQ      '0'                                                      MD055891
     C     SQLCODE       IFEQ      0                                                        MD055891
     C                   SETON                                        89
     C                   END
     C*
     C                   END
     C*
     C** CLOSE FILE CBMDCNL1
     C*
     C**********         CLOSE     CBMDCNL1                                                 MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close FCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
     C*
     C                   END
     C*
     C** DETERMINE COMPONENTS WHICH MUST RUN
     C** BEFORE COMPONENT BEING REPORTED ON
     C*
     C** OPEN CBDPRLL1 AND CHAIN TO FILE
     C*
     C**********         OPEN      CBDPRLL1                                                 MD055891
     C                   MOVE      DHCOTT        COMPNM
     C                   MOVE      DHCSEQ        COMPSQ
     C*****MODKEY        CHAIN     @DIREGK                            43                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close DCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare DCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDSON = :COMPNM and DIDSOS = :COMPSQ                                         MD055891
     C+ order by DIDSON, DIDSOS, DIDRUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open DCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from DCursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       43                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        43                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C*
     C** IF NO RECORDS ON CBDPRLL1 CLOSE FILE
     C** AND PERFORM DATABASE ERROR HANDLING,
     C** UNLESS REPORT ON COBBEGIN COMPONENT IS
     C** REQUIRED WHEN PROCESSING FOR COMPONENTS
     C** TO RUN BEFORE IS BYPASSED
     C*
     C     *IN43         IFEQ      '1'
     C     DHCOTT        ANDNE     'COBBEGIN'
     C**********         CLOSE     CBDPRLL1                                                 MD055891
     C     *LOCK         IN        LDA
     C                   MOVEL     'DPRL1'       DBFILE
     C                   MOVE      COMPNM        MODNMX
     C                   MOVE      COMPSQ        MODSQX
     C                   MOVEL     MODKDS        DBKEY                          ***************
     C                   Z-ADD     8             DBASE                          * DB ERROR 08 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** DO WHILE SAME KEY
     C*
     C     *IN43         DOWEQ     '0'
     C*
     C** CHAIN CBCMPNL1 FOR TEXT FIELD
     C*
     C*****DEPKEY        CHAIN     @DHREGH                            44
     C                   eval      XXDMCD = DHCSEQ                                          MD055891
     C                   eval      XXKGST = DHCMEF                                          MD055891
     C                   eval      XXDLCD = DHCOTT                                          MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :DIDDON and DHCSEQ = :DIDDOS                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       44                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        44                    MD055891
     C                   ENDIF                                                              MD055891
     C                   eval      DHCSEQ = XXDMCD                                          MD055891
     C                   eval      DHCMEF = XXKGST                                          MD055891
     C                   eval      DHCOTT = XXDLCD                                          MD055891
                                                                                            MD055891
     C*
     C** IF NO RECORDS ON CBCMPNL1 DATABASE ERROR
     C*
     C     *IN44         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CMPL1'       DBFILE
     C                   MOVE      DIDDON        DCOPX
     C                   MOVE      DIDDOS        DSEQX
     C                   MOVEL     DEPKDS        DBKEY                          ***************
     C                   Z-ADD     9             DBASE                          * DB ERROR 09 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** IF PAGE IS WRITING ON LINE 56 OR BELOW WRITE
     C** CONTINUATION LINE, NEW PAGE HEADING AND
     C** DEPENDENT COMPONENT FORMAT ON NEXT PAGE
     C*
     C     LINE          IFGE      56
     C*
     C** WRITE CONTINUATION LINE ONLY
     C** IF NOT FIRST PRINT OF HEADINGS
     C*
     C     *IN71         IFEQ      '0'
     C                   WRITE     CONLIN
     C                   SETON                                        83
     C                   END
     C*
     C                   WRITE     RPTHDG
     C                   WRITE     DEPCDT
     C*
     C** SET OFF SUB HEADING LINE INDICATOR
     C*
     C                   SETOFF                                       83
     C*
     C                   ELSE
     C*
     C                   WRITE     DEPCDT
     C*
     C                   END
     C*
     C** SET OFF INDICATOR AFTER FIRST PRINT OF SUB-HEADING
     C*
     C     *IN71         IFEQ      '1'
     C                   SETOFF                                       71
     C                   END
     C*
     C** READ NEXT RECORD WITH SAME KEY
     C*
     C*****MODKEY        READE     @DIREGK                                43                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from DCursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       43                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        43                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C*
     C                   END
     C*
     C** CLOSE FILE CBDPRLL1 AFTER ALL RECORDS FOUND
     C*
     C**********         CLOSE     CBDPRLL1                                                 MD055891
     C*
     C** DETERMINE COMPONENTS WHICH MUST RUN
     C** BEFORE COMPONENT BEING REPORTED ON
     C*
     C** OPEN CBDPRLL4 AND CHAIN TO FILE
     C*
     C**********         OPEN      CBDPRLL4                                                 MD055891
     C                   MOVE      DHCOTT        COMPNM
     C                   MOVE      DHCSEQ        COMPSQ
     C*****MODKEY        CHAIN     @DPRLHW                            45                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close ECursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ECursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDDON = :COMPNM and DIDDOS = :COMPSQ                                         MD055891
     C+ order by DIDDON, DIDDOS                                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ECursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ECursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       45                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        45                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C*
     C***IF*NO*RECORDS*ON*CBDPRLL4*CLOSE*FILE**************************                       CCB020
     C***AND*PERFORM*DATABASE*ERROR*HANDLING,**************************                       CCB020
     C***UNLESS*REPORT*ON*COBEND*COMPONENT*IS**************************                       CCB020
     C***REQUIRED*WHEN*PROCESSING*FOR*COMPONENTS***********************                       CCB020
     C***TO*RUN*AFTER*IS*BYPASSED**************************************                       CCB020
      ** If no records on CBDPRLL4 close file and perform database                            CCB020
      ** error handling, unless report on SCOBFINISH component is                             CCB020
      ** required when processing for components to run after is                              CCB020
      ** bypassed                                                                             CCB020
     C*
     C                   MOVEL     'SCOBFINI'    SCOBFI           10
     C                   MOVE      'SH'          SCOBFI
     C     *IN45         IFEQ      '1'
     C********** DHCOTT    ANDNE'COBEND'                                                      CCB020
     C     DHCOTT        ANDNE     SCOBFI
     C**********         CLOSE     CBDPRLL4                                                 MD055891
     C     *LOCK         IN        LDA
     C                   MOVEL     'DPRL4'       DBFILE
     C                   MOVE      COMPNM        MODNMX
     C                   MOVE      COMPSQ        MODSQX
     C                   MOVEL     MODKDS        DBKEY                          ***************
     C                   Z-ADD     10            DBASE                          * DB ERROR 10 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** DO WHILE SAME KEY
     C*
     C     *IN45         DOWEQ     '0'
     C*
     C** CHAIN CBCMPNL1 FOR TEXT FIELD
     C*
     C*****DPCKEY        CHAIN     @DHREGH                            44                    MD055891
     C                   eval      XXDMCD = DHCSEQ                                          MD055891
     C                   eval      XXKGST = DHCMEF                                          MD055891
     C                   eval      XXDLCD = DHCOTT                                          MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :DIDSON and DHCSEQ = :DIDSOS                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       44                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        44                    MD055891
     C                   ENDIF                                                              MD055891
     C                   eval      DHCSEQ = XXDMCD                                          MD055891
     C                   eval      DHCMEF = XXKGST                                          MD055891
     C                   eval      DHCOTT = XXDLCD                                          MD055891
                                                                                            MD055891
     C*
     C** IF NO RECORDS ON CBCMPNL1 DATABASE ERROR
     C*
     C     *IN44         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CMPL1'       DBFILE
     C                   MOVE      DIDSON        DCOPX
     C                   MOVE      DIDSOS        DSEQX
     C                   MOVEL     DPCKDS        DBKEY                          ***************
     C                   Z-ADD     11            DBASE                          * DB ERROR 11 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** IF PAGE IS WRITING ON LINE 55 OR BELOW WRITE
     C** CONTINUATION LINE, NEW PAGE HEADING AND
     C** DEPENDS ON COMPONENT FORMAT ON NEXT PAGE
     C*
     C     LINE          IFGE      55
     C*
     C** WRITE CONTINUATION LINE ONLY
     C** IF NOT FIRST PRINT OF HEADINGS
     C*
     C     *IN72         IFEQ      '0'
     C                   WRITE     CONLIN
     C                   SETON                                        84
     C                   END
     C*
     C                   WRITE     RPTHDG
     C**********           WRITEDEPCDT                                                        CPK030
     C                   WRITE     DEPONC
     C*
     C** SET OFF SUB HEADING LINE INDICATOR
     C*
     C                   SETOFF                                       84
     C*
     C                   ELSE
     C*
     C                   WRITE     DEPONC
     C*
     C                   END
     C*
     C** SET OFF INDICATOR AFTER FIRST PRINT OF SUB-HEADING
     C*
     C     *IN72         IFEQ      '1'
     C                   SETOFF                                       72
     C                   END
     C*
     C** READ NEXT RECORD WITH SAME KEY
     C*
     C*****MODKEY        READE     @DPRLHW                                45                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ECursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       45                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        45                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C*
     C                   END
     C*
     C** CLOSE FILE CBDPRLL4 AFTER ALL RECORDS FOUND
     C*
     C**********         CLOSE     CBDPRLL4                                                 MD055891
     C*
     C** IF MUTUALLY EXCLUSIVE FLAG IS ON
     C*
     C     DHCMEF        IFEQ      'Y'
     C*
     C** OPEN OTHER MODULES DETAIL FILE CBMEXCL1 AND CHAIN FOR RECORDS
     C*
     C**********         OPEN      CBMEXCL1                                                 MD055891
     C                   MOVE      DHCOTT        COMPNM
     C                   MOVE      DHCSEQ        COMPSQ
     C*****MODKEY        CHAIN     @DKREGQ                            47                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close MCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare MCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :COMPNM and DKCSEQ = :COMPSQ                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open MCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from MCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       47                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        47                    MD055891
     C                   Endif                                                              MD055891
     C*
     C** IF NO RECORDS ON CBMEXCL1 CLOSE FILE
     C** AND PERFORM DATABASE ERROR HANDLING
     C*
     C     *IN47         IFEQ      '1'
     C**********         CLOSE     CBMEXCL1                                                 MD055891
     C     *LOCK         IN        LDA
     C                   MOVEL     'CBMEX'       DBFILE
     C                   MOVE      COMPNM        MODNMX
     C                   MOVE      COMPSQ        MODSQX
     C                   MOVEL     MODKDS        DBKEY                          ***************
     C                   Z-ADD     12            DBASE                          * DB ERROR 12 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** DO WHILE SAME KEY
     C*
     C     *IN47         DOWEQ     '0'
     C*
     C** CHAIN CBCMPNL1 FOR TEXT FIELD FORMAT OVERRIDDEN TO @DHREGH
     C*
     C*****MEXKEY        CHAIN     @DHREGH                            44                    MD055891
     C                   eval      XXDMCD = DHCSEQ                                          MD055891
     C                   eval      XXKGST = DHCMEF                                          MD055891
     C                   eval      XXDLCD = DHCOTT                                          MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :DKMECN and DHCSEQ = :DKMECS                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       44                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        44                    MD055891
     C                   ENDIF                                                              MD055891
     C                   eval      DHCSEQ = XXDMCD                                          MD055891
     C                   eval      DHCMEF = XXKGST                                          MD055891
     C                   eval      DHCOTT = XXDLCD                                          MD055891
                                                                                            MD055891
     C*
     C** IF NO RECORDS ON CBCMPNL1 DATABASE ERROR
     C*
     C     *IN44         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CMPL1'       DBFILE
     C                   MOVE      DKMECN        MECOX
     C                   MOVE      DKMECS        MESQX
     C                   MOVEL     MEXKDS        DBKEY                          ***************
     C                   Z-ADD     13            DBASE                          * DB ERROR 13 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** IF WRITING ON OR BELOW LINE 55 WRITE
     C** CONTINUATION LINE, SET ON INDICATOR FOR
     C** NEXT PAGE SUB HEADING AND WRITE NEXT
     C** PAGE HEADING AND DETAIL.
     C*
     C     LINE          IFGE      55
     C*
     C** WRITE CONTINUATION LINE ONLY
     C** IF NOT FIRST PRINT OF HEADINGS
     C*
     C     *IN73         IFEQ      '0'
     C                   WRITE     CONLIN
     C                   SETON                                        85
     C                   END
     C*
     C                   WRITE     RPTHDG
     C                   WRITE     MUEXDT
     C*
     C** SETOFF SUB HEADING LINE INDICATOR
     C*
     C                   SETOFF                                       85
     C*
     C                   ELSE
     C*
     C                   WRITE     MUEXDT
     C*
     C                   END
     C*
     C** SET OFF INDICATOR AFTER FIRST PRINT OF SUB-HEADING
     C*
     C     *IN73         IFEQ      '1'
     C                   SETOFF                                       73
     C                   END
     C*
     C** READ NEXT RECORD WITH SAME KEY
     C*
     C*****MODKEY        READE     @DKREGQ                                47
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from MCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       47                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        47                    MD055891
     C                   Endif                                                              MD055891
     C*
     C                   END
     C*
     C** CLOSE FILE WHEN ALL RECORDS WITH SAME KEY FOUND
     C*
     C**********         CLOSE     CBMEXCL1                                                 MD055891
     C*
     C                   END
     C*
     C* IF SINGLE COMPONENT REPORT REQUESTED
     C* SET ON END OF FILE INDICATOR
     C*
     C     NUM           IFEQ      '1'
     C                   SETON                                        36
     C*
     C                   END
     C*
     C** IF REPORT BY MODULE READ ALL RECORDS WITH SAME
     C** MODULE ID ON COMPONENTS FILE (CBCMPNL4)
     C*
     C     NUM           IFEQ      '2'
     C*****MODID         READE     @CMPNHK                                36                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from BCursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       36                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        36                    MD055891
     C                   Endif                                                              MD055891
     C
     C*
     C                   END
     C*
     C** IF ALL COMPONENT REPORT READ ALL RECORDS
     C** ON COMPONENTS FILE (CBCMPNL4)
     C*
     C     NUM           IFEQ      '3'
     C**********         READ      @CMPNHK                                36                MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from CCursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       36                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        36                    MD055891
     C                   Endif                                                              MD055891
     C*
     C                   END
     C*
     C** IF RECORD FOUND WRITE HEADER
     C*
     C     *IN36         IFEQ      '0'
     C                   WRITE     RPTHDG
     C*
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** DATABASE ERROR SUBROUTINE TO PERFORM DATABASE ERROR
     C** EXIT FROM PROGRAM
     C*
     C** CALLED FROM MAIN CYCLE AND RPTDET SUBROUTINE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C*
     C** WRITE DATABASE ERROR ON NEW PAGE
     C*
     C                   WRITE     RPTHDG
     C*
     C** OUTPUT DATA BASE ERROR MESSAGE TO PRINTER FILE.
     C*
     C                   WRITE     DBERDT
     C*
     C** OUTPUT 'END OF REPORT' MESSAGE TO PRINTER FILE.
     C*
     C                   WRITE     RPTEND
     C*
     C** SETON INDICATORS U7 U8 LR AND RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        U7U8LR
     C                   OUT       LDA
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA MODPOS

    SDMT#A#B#C  #E#FGL                                                    S01339
DL  EMFMSTLEREMSSERC#G                                                    S01339
FDCMFXMMABFTCAFF  #I#J                                                    S01339
#KMEIRDLDLTMRMTKMQMFIA                                  LN0635S01310S01382S01393
                  PM                                                      S01486
      CF          LB                                                      S01498
              OD                                                          S01382
          HFMC                                                      S01379S10736
AACGPLTIPB                                        CTI001S01522CAC001CPL002CPB001


**CTDATA MODIDS

  SD  MTSWMTSWSESWLESWCLSWSMSWDL  GL  DL  CL  EM  FM
  ST  LE  RE  MS  SE  RC      FD  CM  FX  MM  AB  FT
  CA  FFMTCLMTDLMTGLMTLE  ME  IR  DL  DL  TM  RM  TK                LN0635S01310
  MQ  MF  IA                                                              S01382

                  CF                                                      S01310
                          OD                                              S01382
          HF  MC                  AA  CG  PL            S01379S10736S01522CPL002

**CTDATA MODNM
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
NOT USED
STANDING DATA
MIDAS/TELEX MODULE
SWIFT FUNDS TRANSFER
SWIFT SECURITIES TRADING
SWIFT CUSTOMER LENDING
SWIFT SYNDICATED LOANS (REDUN)                                            S01339
SWIFT STATEMENTS
SWIFT DEALING
GENERAL LEDGER
DEALING:FX
SYNDICATED LOANS       (REDUN)                                            S01339
EXPOSURE MANAGEMENT
DRS FINANCIAL MODELLER
STATUTORY RETURNS
CUSTOMER LENDING
RETAIL
MIDAS/SWIFT DIRECT LINK
SECURITIES TRADING
AUTOMATIC RECONCILIATIONS
BOND DEALERS INTERFACE
DRS STANDING DATA
DRS CONTROL MODULE
DRS FOREIGN EXCHANGE
DRS MONEY MARKET
DRS ARBITRAGE
FUNDS TRANSFER
DRS COMMON APPLICATIONS
FUTURES & OPTIONS
MIDAS/TELEX SYNDICATED LOANS (REDUN)                                      S01339
MIDAS/TELEX DEALING
MIDAS/TELEX GENERAL LEDGER
MIDAS/TELEX CUSTOMER LENDING
MESSAGE MANAGEMENT                                                        S01310
FRA/IRS
DEALING:MM
INTERNAL CONTRACTS
TREASURY MANAGEMENT
RISK MANAGEMENT
TESTKEY
MIDAS/Q
MICROFICHE
INTEREST ON ACCOUNTS
WINDOW PROCESSING
SAR PROCESSING
FRENCH RETURNS
LUX RETURNS
DUTCH RETURNS
GERMAN RETURNS
BELGIAN RETURNS
ITALIAN RETURNS
SWIFT EXTERNAL INTERFACE
PORTFOLIO MANAGEMENT
CREDIT MANAGEMENT
HEAD OFFICE REPORTING
AVERAGE BALANCES
MARGINS
CONFIRMATION MATCHING
MIMIX
REPORT CONTROL FACILITY
AMPS INT
SWISS RETURNS
FIDUCIARY LOANS AND DEPOSITS
LOMBARD CREDITS
CANTONAL TAX
STAMP DUTY
USE DRS SHORTNAMES
CHIPS DEALING
CHIPS LENDING
CHIPS OPENING BALENCE
CHIPS
CHIPS DIRECT LINK
OPTICAL DISK
MULTIBRANCHING INDICATOR
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
HISTORY AND AUDIT FACILITY                                                S01379
MANAGEMENT ACCOUNTING                                                     S10736
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
MIDAS EXPORT DATA INTERFACE                                               S01493
ANALYTICAL ACCOUNTING                                                     CAC001
User Defined Correspondence                                               S01522
Midas Plato Interface                                                     CPL002
MIDAS/TI INTERFACE                                                        CTI001
PRIVATE BANKING                                                           CPB001
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
RESERVED FOR FUTURE USE
