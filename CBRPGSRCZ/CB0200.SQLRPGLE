     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB Request dependency table report')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing
     F*                                                               *
     F*  CB0200 - REQUEST DEPENDENCY TABLE REPORT                     *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPB001             Date 02Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
     F*                 CTI001             DATE 30JUL97               *
     F*                 CAC001             DATE 17JUN96               *
     F*                 S01486             DATE 06JUN94               *
     F*                 S01498             DATE 06JUN94               *
     F*                 S01522             DATE 25NOV94               *
     F*                 S01493             DATE 19JUL94               *
     F*                 S01393             DATE 30OCT92               *
     F*                 S10736             DATE 29OCT92               *
     F*                 S01379             DATE 22SEP92               *
     F*                 S01382             DATE 11AUG92               *
     F*                 S01339             DATE 31JUL92               *
     F*                 S01310             DATE 31JUL91               *
     F*                 LN0635             DATE 16AUG90               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
     F*  CPB001 - 'Private Banking' Module                            *
     F*  CPL001 - Midas - Plato Interface Enhancement.                *
     F*  CTI001 - Midas / Trade Innovation Interface Phase 1          *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Introduction of new Analytical Accounting module    *
     F*  S01486 - PORTFOLIO MANAGEMENT                                *
     F*  S01498 - PORTFOLIO LENDING                                   *
      *  S01522 - User Defined Correspondence                         *
      *  S01493 - MIDAS EXPORT DATA INTERFACE                         *   S01493
      *  S01393 - RISK MANAGEMENT                                     *
      *  S10736 - MANAGEMENT ACCOUNTING                               *
      *  S01379 - HISTORY AND AUDIT FACILITY                          *
      *         - USE 'HF' FOR HISTORY AND AUDIT FACILITY             *
      *  S01382 - OPTICAL DISK REPORTING                              *
      *         - USE 'MF' FOR MICROFICHE, 'OD' FOR OPTICAL DISK      *
      *  S01339 - SYNDICATED LOANS MADE REDUNDANT AT R10.             *
      *  S01310 - SWIFT RATIONALISATION                               *
      *           CHANGE 'NETWORK MIDAS' (NM) TO 'MESSAGE             *
      *           MANAGEMENT' (ME) - ARRAY MODPOS CHANGED             *
      *           AND --- ADD CF (POSN 70)
     F*  LN0635 - CHANGE FRA/IRS MODULE ID FORM '#L' TO 'IR'          *
     F*                                                               *
     F*****************************************************************
     FSDMMODPD  IT   F  128        DISK
     F*CBCMPNL1* IF   E           K DISK    USROPN                                          MD055891
     FCB0200DF  CF   E             WORKSTN USROPN
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    03      KEY F3
     F*    12      KEY F12
     F*    40      READ ERROR ON FORMAT CB0200F1
     F*    41      READ ERROR ON FORMAT CB0200F2
     F*    42      READ ERROR ON FORMAT CB0200F3
     F*    47      WRITE ERROR MESSAGES
     F*    48      NO REPORT REQUESTED ON FIRST SCREEN AND NOT F3
     F*    49      NO VALID COMPONENT ON COMPONENTS FILE (CBCMPNL1)
     F*    50      NO VALID MODULE ID FOUND ON ARRAY MODPOS
     F*    51      MODULE ID REQUESTED IS NOT ON IN SYSTEM
     F*    52      COMPONENT NUMBER NOT NUMERIC OR INVALID
     F*    55      TEST FOR COMPONENT NUMBER NOT NUMERIC
     F*    60-63   TOO MANY FIELDS ENTERED ON FORMAT CB0200F1
     F*    64-66   FIELD ENTRY INVALID ON FORMAT CB0200F1
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
     F******NM******46*****NETWORK MIDAS                                  S01310
      *     NM      46     MESSAGE MANAGEMENT                             S01310
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
     F*             65     PORTFOLIO MANAGEMENT
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
     F*     PL     102     Midas Plato Interface Enhancement              CPL001
     F*     TI     103     Midas/TI Interface                             CTI001
     F*     PB     104     Private Banking                                CPB001
     F**********87-128     RESERVED FOR LATER USE                         S01379
     F* REMAINING POSITIONS RESERVED FOR LATER USE                        S01379
     F*
     F*
     F*****************************************************************
     F/EJECT
     D*
     D** COPYRIGHT ARRAY
     D*
     D ERRMSG          S             78    DIM(9) CTDATA PERRCD(1)
     D** ERROR MESSAGE ARRAY
     D*
     D MODPOS          S              2    DIM(128) CTDATA PERRCD(11)
     D** ARRAY SHOWING POSITIONS OF MODULES ON FILE SDMMODPD
     D*
     D SMOD            S              1    DIM(128) FROMFILE(SDMMODPD)
     D                                     PERRCD(128)
     D** ARRAY TO DETERMINE WHETHER MODULE IS ON IN FILE SDMMODPD
     D*****************************************************************
     D/EJECT
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D**     LOCAL DATA AREA
     D*
     D RUNDAT          DS            13
     D  AGMRDT                 1      7
     D** DATA STRUCTURE TO GET DATE FROM RUNDAT DATA AREA
     D*
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D*
     D PSDS           SDS
     D  WSID                 244    253
     D  USRID                254    263
     I**      DATA STRUCTURE FOR WORKSTATION ID FOR SCREEN OUTPUT
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     I*
     I*****************************************************************
     I/EJECT
     C*
     C** KEY TO CHAIN TO CBCMPNL1
     C*
     C     CKEY          KLIST
     C                   KFLD                    SCCOT
     C                   KFLD                    SEQCHN
     C*
     C** DEFINE LOCAL DATA AREA
     C*
     C     *DTAARA       DEFINE                  LDA
     C*
     C** SET UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0200  '    DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C*
     C**  OBTAIN RUN DATE FROM DATA AREA RUNDAT
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      AGMRDT        RUNA
     C                   UNLOCK    RUNDAT
     C*
     C** OPEN DISPLAY FILE USER CONTROL
     C*
     C                   OPEN      CB0200DF
     C*
     C** DO WHILE NOT F3
     C*
     C     *IN03         DOWNE     '1'
     C*
     C** CLEAR INPUT FIELDS, OUTPUT HEADER & INITIAL SCREEN FORMATS
     C*
     C                   MOVE      *BLANKS       SCOMRP
     C                   MOVE      *BLANKS       SMODRP
     C                   MOVE      *BLANKS       SALLRP
     C*
     C                   WRITE     CB0200F0
     C                   WRITE     CB0200F1
     C*
     C** ENSURE PREVIOUS SCREEN INDICATOR (*IN12)
     C** IS OFF WHEN WRITING FIRST SCREEN
     C*
     C     *IN12         IFEQ      '1'
     C                   SETOFF                                       12
     C                   END
     C*
     C** VALIDATE INITIAL SCREEN - ALL ERROR INDICATORS MUST BE OFF
     C*
     C     *IN47         DOUEQ     '0'
     C*
     C** READ DETAILS ENTERED TO INITIAL SCREEN FORMAT
     C*
     C                   READ      CB0200F1                               40
     C*
     C     *IN40         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT1'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** SET OFF INITIAL SCREEN ERROR INDICATORS
     C*
     C                   SETOFF                                       474860
     C                   SETOFF                                       616263
     C                   SETOFF                                       646566
     C*
     C** IF F3 NOT PRESSED
     C*
     C     *IN03         IFEQ      '0'
     C*
     C** IF MORE THAN ONE FIELD ENTERED SETON ERROR
     C** INDICATOR TO APPROPRIATE ERROR MESSAGE
     C*
     C     SCOMRP        IFEQ      'X'
     C     SMODRP        ANDEQ     'X'
     C     SALLRP        ANDEQ     '   '
     C                   SETON                                        4760
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(1)     MSG
     C                   END
     C*
     C     SCOMRP        IFEQ      'X'
     C     SMODRP        ANDEQ     ' '
     C     SALLRP        ANDEQ     'ALL'
     C                   SETON                                        4761
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(1)     MSG
     C                   END
     C*
     C     SCOMRP        IFEQ      ' '
     C     SMODRP        ANDEQ     'X'
     C     SALLRP        ANDEQ     'ALL'
     C                   SETON                                        4762
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(1)     MSG
     C                   END
     C*
     C     SCOMRP        IFEQ      'X'
     C     SMODRP        ANDEQ     'X'
     C     SALLRP        ANDEQ     'ALL'
     C                   SETON                                        4763
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(1)     MSG
     C                   END
     C*
     C** IF FIELD ENTRY IS NOT 'X' 'ALL' AND NOT  BLANK SETON
     C** INDICATOR TO WRITE APPROPRIATE ERROR MESSAGE
     C*
     C     SCOMRP        IFNE      'X'
     C     SCOMRP        ANDNE     ' '
     C                   SETON                                        4764
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(2)     MSG
     C                   END
     C*
     C     *IN47         IFNE      '1'
     C     SMODRP        ANDNE     'X'
     C     SMODRP        ANDNE     ' '
     C                   SETON                                        4765
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(2)     MSG
     C                   END
     C*
     C     *IN47         IFNE      '1'
     C     SALLRP        ANDNE     'ALL'
     C     SALLRP        ANDNE     '   '
     C                   SETON                                        4766
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(3)     MSG
     C                   END
     C*
     C** IF NO FIELDS ENTERED SETON ERROR
     C** INDICATOR TO WRITE ERROR MESSAGE FOUR
     C*
     C     SCOMRP        IFEQ      ' '
     C     SMODRP        ANDEQ     ' '
     C     SALLRP        ANDEQ     '   '
     C                   SETON                                        4748
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(4)     MSG
     C*
     C                   END
     C*
     C** IF ERROR INDICATOR ON
     C*
     C     *IN47         IFEQ      '1'
     C*
     C** OUTPUT HEADER & INITIAL SCREEN FORMATS
     C*
     C                   WRITE     CB0200F0
     C                   WRITE     CB0200F1
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C** IF F3 NOT PRESSED
     C*
     C     *IN03         IFEQ      '0'
     C*
     C** IF SINGLE COMPONENT REPORT REQUESTED
     C*
     C     SCOMRP        IFEQ      'X'
     C*
     C** PRODUCE REPORT VIA SINGLE COMPONENT SUBROUTINE
     C*
     C                   EXSR      SINCOM
     C*
     C                   END
     C*
     C** IF SINGLE MODULE REPORT REQUESTED
     C*
     C     SMODRP        IFEQ      'X'
     C*
     C** PRODUCE REPORT VIA SINGLE MODULE SUBROUTINE
     C*
     C                   EXSR      SINMOD
     C*
     C                   END
     C*
     C** IF ALL COMPONENTS REPORT REQUESTED
     C*
     C     SALLRP        IFEQ      'ALL'
     C*
     C** PRODUCE REPORT VIA ALL COMPONENTS SUBROUTINE
     C*
     C                   EXSR      ALLCOM
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C** CLOSE DISPLAY FILE BEFORE ENDING PROGRAM
     C*
     C                   CLOSE     CB0200DF
     C*
     C                   SETON                                        LR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**
     C** INDEX OF SUBROUTINES
     C**
     C**
     C** SINCOM - TO PRODUCE REPORT FOR ONE COMPONENT ONLY
     C**
     C** SINMOD - TO PRODUCE REPORT FOR ONE MODULE ONLY
     C**
     C** ALLCOM - TO PRODUCE REPORT FOR ALL COMPONENTS
     C**
     C** DBERR  - DATABASE ERROR HANDLING
     C**
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SINGLE COMPONENT SUBROUTINE PRODUCES
     C** A REPORT FOR A SINGLE MODULE
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS PROGRAM CBC0210
     C*
     C** CALLS DBERR SUBROUTINE
     C*
     C********************************************************************
     C*
     C*
     C     SINCOM        BEGSR
     C*
     C** CLEAR SCREEN INPUT FIELDS FOR SINGLE COMPONENT REPORT SCREEN
     C*
     C                   MOVE      *BLANKS       SCCOT
     C                   MOVE      *BLANKS       SCSEQ
     C*
     C** DO WHILE F3 OR F12 NOT PRESSED
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C*
     C** WRITE SINGLE COMPONENT REPORT SCREEN
     C*
     C                   WRITE     CB0200F2
     C*
     C** READ SINGLE COMPONENT REPORT SCREEN
     C*
     C                   READ      CB0200F2                               41
     C*
     C     *IN41         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT2'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** SET OFF SCREEN ERROR INDICATORS
     C*
     C                   SETOFF                                       474952
     C*
     C** IF F3 OR F12 NOT PRESSED WHEN
     C** ERROR ON COMPONENT NUMBER FIELD
     C*
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C*
     C** TEST IF SEQUENCE NUMBER ENTERED IS NUMERIC
     C*
     C     *IN55         DOWEQ     '0'
     C     *IN03         ANDNE     '1'
     C     *IN12         ANDNE     '1'
     C*
     C                   MOVE      0             TSTSEQ            6
     C                   MOVEL     SCSEQ         TSTSEQ
     C                   TESTN                   TSTSEQ               55
     C*
     C     *IN55         IFEQ      '1'
     C*
     C** SETUP FIELD FOR CHAINING TO COMPONENTS FILE
     C*
     C                   MOVEL     TSTSEQ        SEQCHN            5
     C*
     C** WRITE ERROR MESSAGE FIVE
     C*
     C                   ELSE
     C                   SETON                                        4752
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(5)     MSG
     C*
     C** WRITE SINGLE COMPONENT REPORT SCREEN
     C*
     C                   WRITE     CB0200F2
     C*
     C** READ SINGLE COMPONENT REPORT SCREEN
     C*
     C                   READ      CB0200F2                               41
     C*
     C     *IN41         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT2'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** SET OFF SCREEN ERROR INDICATORS
     C*
     C                   SETOFF                                       4752
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C** CHAIN TO COMPONENTS FILE (CBCMPNL1) FOR
     C** COMPONENT DETAILS IF F3 OR F12 NOT PRESSED
     C*
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C*
     C** SET OFF INDICATOR IF COMPONENT NUMBER IS VALID
     C*
     C                   SETOFF                                       55
     C*
     C**********         OPEN      CBCMPNL1                                                 MD055891
     C*
     C*****CKEY          CHAIN     CBCMPNL1                           49                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :SCCOT  and DHCSEQ = :SEQCHN                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       49                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        49                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C*
     C**********         CLOSE     CBCMPNL1                                                 MD055891
     C*
     C** IF COMPONENT NOT FOUND WRITE ERROR MESSAGE SIX
     C*
     C     *IN49         IFEQ      '1'
     C                   SETON                                        4752
     C*
     C** WRITE ERROR MESSAGE SIX
     C*
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(6)     MSG
     C*
     C                   ELSE
     C*
     C** SET UP PARAMETER FOR PROGRAM
     C*
     C                   MOVE      '1'           SMODRP
     C*
     C** PRODUCE REPORT FOR SINGLE COMPONENT
     C*
     C                   CALL      'CBC0210'
     C                   PARM                    SMODRP
     C                   PARM                    DHCOTT
     C                   PARM                    SCSEQ
     C                   PARM                    DHCMOD
     C*
     C** CHECK FOR DATABASE ERROR IN CALLED PROGRAM
     C*
     C     *LOCK         IN        LDA
     C     DBFILE        IFNE      *BLANKS
     C                   EXSR      DBERR
     C*
     C                   ELSE
     C*
     C                   MOVEL     'CB0200  '    DBPGM
     C                   OUT       LDA
     C                   END
     C*
     C** CLEAR SCREEN INPUT FIELDS FOR SINGLE COMPONENT
     C** REPORT SCREEN AND WRITE FORMAT TO CLEAR MESSAGE
     C*
     C                   SETOFF                                       47
     C                   MOVE      *BLANKS       SCCOT
     C                   MOVE      *BLANKS       SCSEQ
     C                   WRITE     CB0200F4
     C*
     C                   END
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
     C** SINGLE MODULE SUBROUTINE PRODUCES A REPORT FOR A SINGLE MODULE
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS PROGRAM CBC0205
     C*
     C** CALLS DBERR SUBROUTINE
     C*
     C********************************************************************
     C*
     C*
     C     SINMOD        BEGSR
     C*
     C** CLEAR INPUT FIELD FOR SINGLE MODULE REPORT SCREEN
     C*
     C                   MOVE      *BLANKS       SCMOD
     C*
     C** DO WHILE F3 OR F12 NOT PRESSED
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C*
     C** WRITE SINGLE MODULE REPORT SCREEN
     C*
     C                   WRITE     CB0200F3
     C*
     C** READ SINGLE MODULE REPORT SCREEN
     C*
     C                   READ      CB0200F3                               42
     C*
     C     *IN42         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT3'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** SET OFF SCREEN ERROR INDICATORS EXCEPT
     C** ARRAY CHECK INDICATOR WHICH REQUIRES SETTING ON
     C*
     C                   SETOFF                                       4751
     C                   SETON                                        50
     C*
     C** IF F3 OR F12 NOT PRESSED
     C*
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C*
     C** IF MODULE SELECTED IS SD THEN PRODUCE REPORT
     C** THE SD MODULE IS ASSUMED TO EXIST IN ALL SYSTEMS
     C*
     C     SCMOD         IFEQ      'SD'
     C*
     C** SET UP PARAMETER
     C*
     C                   MOVE      '2'           SMODRP
     C                   MOVE      *BLANKS       SCCOT
     C                   MOVE      *BLANKS       SCSEQ
     C*
     C** PRODUCE REPORT FOR SD MODULE
     C*
     C                   CALL      'CBC0205'
     C                   PARM                    SMODRP
     C                   PARM                    SCCOT
     C                   PARM                    SCSEQ
     C                   PARM                    SCMOD
     C*
     C** CLEAR INPUT FIELD AND WRITE FORMAT TO CLEAR ERROR MESSAGE
     C*
     C                   SETOFF                                       47
     C                   MOVE      *BLANKS       SCMOD
     C                   WRITE     CB0200F4
     C*
     C                   ELSE
     C*
     C** IF MODULE SELECTED FIELD IS BLANK WRITE ERROR MESSAGE
     C*
     C     SCMOD         IFEQ      '  '
     C                   SETON                                        47
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(7)     MSG
     C*
     C                   ELSE
     C*
     C** VALIDATE MODULE ID ENTERED ON ARRAY MODPOS
     C*
     C******************** Z-ADD1         X       20                      S01522
     C                   Z-ADD     1             X                 3 0                         S0152
     C     SCMOD         LOOKUP    MODPOS(X)                              50
     C*
     C** IF MODULE ID NOT FOUND ON ARRAY
     C*
     C     *IN50         IFEQ      '0'
     C                   SETON                                        47
     C*
     C** WRITE ERROR MESSAGE EIGHT
     C*
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(8)     MSG
     C*
     C                   ELSE
     C*
     C** IF MODULE ID IS FOUND ON ARRAY CHECK IF THE
     C** MODULE IS OFF IN SYSTEM ON ARRAY SMOD
     C*
     C     SMOD(X)       IFEQ      'N'
     C*
     C** IF MODULE NOT ON SETON ERROR INDICATOR TO WRITE
     C** ERROR MESSAGE NINE
     C*
     C                   SETON                                        4751
     C*
     C                   MOVE      *BLANKS       MSG
     C                   MOVE      ERRMSG(9)     MSG
     C*
     C                   ELSE
     C*
     C** SET UP PARAMETER
     C*
     C                   MOVE      '2'           SMODRP
     C                   MOVE      *BLANKS       SCCOT
     C                   MOVE      *BLANKS       SCSEQ
     C*
     C** PRODUCE REPORT FOR MODULE SELECTED
     C*
     C                   CALL      'CBC0205'
     C                   PARM                    SMODRP
     C                   PARM                    SCCOT
     C                   PARM                    SCSEQ
     C                   PARM                    SCMOD
     C*
     C** CLEAR INPUT FIELD AND WRITE FORMAT TO CLEAR ERROR MESSAGE
     C*
     C                   SETOFF                                       47
     C                   MOVE      *BLANKS       SCMOD
     C                   WRITE     CB0200F4
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
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
     C** ALL COMPONENTS SUBROUTINE PRODUCES REPORT FOR ALL COMPONENTS
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS PROGRAM CBC0205
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     ALLCOM        BEGSR
     C*
     C** SET UP PARAMETER
     C*
     C                   MOVE      '3'           SMODRP
     C                   MOVE      *BLANKS       SCCOT
     C                   MOVE      *BLANKS       SCSEQ
     C                   MOVE      *BLANKS       SCMOD
     C*
     C** PRODUCE REPORT FOR ALL COMPONENTS
     C*
     C                   CALL      'CBC0205'
     C                   PARM                    SMODRP
     C                   PARM                    SCCOT
     C                   PARM                    SCSEQ
     C                   PARM                    SCMOD
     C*
     C** WHEN ALL COMPONENTS REPORT PRODUCED EXIT
     C** PROGRAM HAVING CLOSED DISPLAY FILE
     C*
     C                   CLOSE     CB0200DF
     C*
     C                   SETON                                        LR
     C*
     C                   RETURN
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
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C*
     C** SETON INDICATORS U7 U8 LR AND RETURN TO
     C** CALLING PROGRAM HAVING CLOSED DISPLAY FILE
     C*
     C*
     C                   CLOSE     CB0200DF
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
**CTDATA ERRMSG
Only one type of report may be selected.
Enter `X` to select type of report.
Enter `ALL` to select all components report.
No type of report has been selected.
Invalid component number entered.
Invalid component details entered.
Enter module code to obtain module report.
Invalid module code entered.
The module code entered is not present in system.
**CTDATA MODPOS

      MT#A#B#C  #E#FGL                                                    S01339
DL  EMFMSTLEREMSSERC#G                                                    S01339
FDCMFXMMABFTCAFF  #I#J                                                    S01339
#KMEIRDLDLTMRMTKMQMFIA                                  LN0635S01310S01382S01393
                  PM                                                      S01486
      CF          LB                                                S01310S01498
              OD                                                          S01382
          HFMC      ED                                        S01379S10736S01493
AACGPLTIPB                                        CTI001S01522CAC001CPL001CPB001


