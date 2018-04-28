     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Account balance check API')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Inovation (TI) Module                          *
      *                                                               *
      *  TI0100 - TI Account Balance Check API                        *
      *                                                               *
      *  Function: To determine the current balance of a Midas a/c    *
      *  Phase(s): Input cycle                                        *
      *                                                               *
      *  Called By: TICONTROL                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR870652           Date 29Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 225886             Date 06Jun06               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 168123             Date 16Dec99               *
      *                 161108             Date 09Jul99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001   *CREATE   Date 16JUL97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR870652 - #MASERV01 goes into MSGW due to mismatch of       *
      *             parameters. Applied fix AR681290 to match with    *
      *             the TI fix CSNT50zg. (Child: AR870653)            *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  225886 - TI0100 prevents reply back to TI if A/C closed/     *
      *           doesn't exist. Applied fix 225323.                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  168123 - Inadequate checking of closed accounts.             *
      *  161108 - Condition the block debits check on the Retail      *
      *           account status check on the TI ICD.                 *
      *  CGL007 - Account Postings Enquiry.  Recompile.               *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** GL A/c Details
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      *
      ** GL A/c Movement
     FRSACMTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(APOSTPDF)
     FMEMOSL2   IF   E           K DISK    INFSR(*PSSR)                                     AR870652
      ** Shadow balances                                                                    AR870652
      *                                                                                     AR870652
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)                    161108
     D* TI ICD details                                                          161108
     D DSFDY         E DS                  EXTNAME(DSFDY)                       161108
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                      161108
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      ** Error Message for Insufficient Funds                                               AR870652
      *                                                                                     AR870652
     D INFERR          S            100    DIM(1) CTDATA PERRCD(1)                          AR870652
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
                                                                                161108
     D GLREOV          DS                                                       161108
      * Retail Override data area data structure                                161108
     D  URRE01                 1      1                                         161108
     D  URRE02                 2      2                                         161108
     D  URRE03                 3      3                                         161108   Block debit
     D  URRE04                 4      4                                         161108
     D  URRE05                 5      5                                         161108
     D  URRE06                 6      6                                         161108
     D  URRE07                 7      7                                         161108
     D  URRE08                 8      8                                         161108
     D  URRE09                 9      9                                         161108
     D  URRE10                10     10                                         161108
      *
     D***DSIACE*         DS            38                                                     CGL029
     D***DSIACE*         DS            44                                            CGL029 AR870652
     D DSIACE          DS            97                                                     AR870652
      ** Incoming A/c Enquiry Data Structure - Equation Account ID, Midas
      ** Account ID (Branch, Customer, Currency, A/C Code and A/C Sequence).
     D  DSEAID                 1     13
     D  DSBRCA                14     16
     D**DSCNUM**              17     22  0                                                    CSD027
     D  DSCNUM                17     22A                                                      CSD027
     D  DSCCY                 23     25
     D***DSACOD*               26     29  0                                                   CGL029
     D***DSACSQ*               30     31  0                                                   CGL029
     D***DSNOWT*               32     38                                                      CGL029
     D  DSACOD                26     35  0                                                    CGL029
     D  DSACSQ                36     37  0                                                    CGL029
     D  DSNOWT                38     44                                                       CGL029
     D  DSFLLR                45     58                                                     AR870652
     D  DSVDAT                59     65S 0                                                  AR870652
     D  DSACCY                66     68                                                     AR870652
     D  DSAMNT                69     76P 0                                                  AR870652
     D  DSDRCR                77     77                                                     AR870652
     D  DSCUST                78     97                                                     AR870652
      *
     D***DSRESD*         DS            22                                                   AR870652
     D DSRESD          DS           124                                                     AR870652
      ** Response Data Structure - Balance, Negative Balance?, Check Reqd?,
      ** Blocked A/c? + Error Code.
     D  DSBAL                  1     15
     D  DSNEG                 16     16
     D  DSCHK                 17     17    INZ('N')
     D**DSBLK**********       18     18                                         161108
     D  DSBLK                 18     18    INZ('N')                             161108
     D  DSERR                 19     22  0
     D  DSCBO                 23     23                                                     AR870652
     D  DSMSG                 24    123                                                     AR870652
     D  DSEOW                124    124                                                     AR870652
                                                                                              CGL029
     D***PEDATA*         S             44A                                           CGL029 AR870652
     D PEDATA          S             97A                                                    AR870652
     D BCCLAM          S             15  0                                                  AR870652
      *                                                                                     AR870652
      ** External data structures for Switcheable Feature                                   AR870652
      *                                                                                     AR870652
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                AR870652
     IMEMOSMDF                                                                              AR870652
     I              CLBLN                       MCLBLN                                      AR870652
      ** Rename field                                                                       AR870652
      *
      *================================================================
      *  P R O G R A M     S T A R T                                  *
      *================================================================
      *
      **  Initialisation Performed.
      *
      **  Access Account Details.
      *
     C                   EXSR      ACCNTD
      *
      *================================================================
      *  P R O G R A M     E N D                                      *
      *================================================================
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *================================================================
      /EJECT
      *****************************************************************
      /TITLE SR/ACCNTD
      *****************************************************************
      *                                                               *
      * ACCNTD  - Access Account Details                              *
      *                                                               *
      * Called By: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ACCNTD        BEGSR
      *
      **  Set up key for ACCNTL0 with Input Enquriy Data
     C                   MOVEL     PEDATA        DSIACE
     C     KACCNT        CHAIN     ACCNTL0                            89
     C*                                                                         168123
      *  If account found but not live send error message that account          168123
      *  is not valid.                                                          168123
      *                                                                         168123
     C     *IN89         IFEQ      *OFF                                         168123
     C     RECI          ANDNE     'D'                                          168123
     C     DACC          ORNE      0                                            168123
     C                   Z-ADD     1048          DSERR                          168123
     C                   MOVE      'L'           PRFLAG                         168123
     C                   MOVE      '1'           *IN89                          168123
     C                   ENDIF                                                  168123
      *
      **  If Account Found and not closed, check to see if Account
      **  is Blocked (Bit 2 of RETB is On.)
     C     *IN89         IFEQ      *OFF
     C     RECI          ANDNE     'C'
     C                   TESTB     '2'           RETB                     88
      *
      **  If Retail Account is Blocked flag Response Data Accordingly.
      **  If TI Retail Account Status Check equals 'N' ignore block.            161108
     C     ATYP          IFEQ      'R'
     C     TIREAS        ANDEQ     'Y'                                          161108
     C     URRE03        ANDNE     'Y'                                          161108
     C     *IN88         ANDEQ     *ON
     C                   MOVEL     'Y'           DSBLK
     C                   ELSE
     C                   MOVEL     'N'           DSBLK
     C                   ENDIF
      *
      **  If Retail Account is  not blocked, TI should check balance.
     C*****ATYP**********IFEQ      'R'                                          161108
     C******IN88*********ANDNE     *ON                                          161108
     C     DSBLK         IFEQ      'N'                                          161108
     C                   MOVEL     'Y'           DSCHK
     C                   ENDIF
      *
      **  Set up ledger balance work field
     C                   Z-ADD     LDBL          WFBAL
      *
      **  Determine All Account Movements for this Account
     C     KACMT2        CHAIN     RSACMTL2                           89
      *
     C     *IN89         DOWEQ     *OFF
      **  Add/Sub A/c Movement to Ledger Balance Parm.
     C     DORC          IFEQ      0
     C                   ADD       MVAM          WFBAL
     C                   ELSE
     C                   SUB       MVAM          WFBAL
     C                   ENDIF
     C     KACMT2        READE     RSACMTL2                               89
     C                   ENDDO
      *
      *   Change the sign of the amount for retail accounts
     C     ATYP          IFEQ      'R'
     C                   EVAL      WFBAL = (-1) * WFBAL
     C                   ENDIF
      *
      **  Set Balance
     C                   MOVE      *ALL'0'       DSBAL
     C                   MOVE      WFBAL         DSBAL
      *
      **  Set Negative Balance Indicator
     C     WFBAL         IFGT      0
     C                   MOVEL     'N'           DSNEG
     C                   ELSE
     C                   MOVEL     'Y'           DSNEG
     C                   ENDIF
      *
      ** Check balance when CRE060 is on                                                    AR870652
      *                                                                                     AR870652
     C                   MOVE      *BLANK        DSMSG                                      AR870652
     C                   MOVE      'N'           DSCBO                                      AR870652
     C                   MOVE      'N'           DSEOW                                      AR870652
     C     CRE060        IFEQ      'Y'                                                      AR870652
     C     STYP          ANDEQ     'S'                                                      AR870652
     C     DSDRCR        ANDEQ     'D'                                                      AR870652
     C                   Z-ADD     0             BCCLAM                                     AR870652
     C                   EVAL      BCCLAM = MCLBLN + BCOA                                   AR870652
     C                   EVAL      BCCLAM = BCCLAM + DSAMNT                                 AR870652
     C     BCCLAM        IFGT      0                                                        AR870652
     C                   MOVE      'Y'           DSCBO                                      AR870652
     C                   MOVEL     INFERR(1)     DSMSG                                      AR870652
     C                   MOVE      'Y'           DSEOW                                      AR870652
     C                   ENDIF                                                              AR870652
     C                   ENDIF                                                              AR870652
      *                                                                                     AR870652
      **  Set Enquiry ID, Error Code and Resposne Flag (L =Last).
     C                   MOVEL     'ACCBAL'      PENQID
     C                   Z-ADD     0             DSERR
     C                   MOVE      'L'           PRFLAG
      *
      **  Else Account Not Found or is Closed.                         sponse
      **  Set up Error Code and Response Flag (E=Error).
     C                   ELSE
     C                   MOVEL     'ACCBAL'      PENQID                                       225886
     C                   Z-ADD     2010          DSERR
     C                   MOVE      'L'           PRFLAG
     C                   ENDIF
      *
      **  Set Response Length.
     C**********         Z-ADD     22            PRLEN                                      AR870652
     C                   Z-ADD     124           PRLEN                                      AR870652
      *
      **  Set Response Data.
     C                   MOVEL     DSRESD        PRDATA
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      /TITLE SR/*INZSR
      *****************************************************************
      *                                                               *
      * *INZSR  - Intialisation routine                               *
      *                                                               *
      * Called: Automatically                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Initialise LDA field.
     C                   MOVEL     'TI0100'      DBPGM
      *
      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      ** Read in GLREOV Data                                                    161108
     C     *DTAARA       DEFINE                  GLREOV                         161108
     C                   IN        GLREOV                                       161108
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      **  Parameters - Enquiry Id, Enquiry Data, Response Flag, Response
      **  Data and Response Length.
     C     *ENTRY        PLIST
     C                   PARM                    PENQID           10
     C**********         PARM                    PEDATA           38                          CGL029
     C                   PARM                    PEDATA                                       CGL029
     C                   PARM                    PRFLAG            1
     C**********         PARM                    PRDATA           22                        AR870652
     C                   PARM                    PRDATA          124                        AR870652
     C                   PARM                    PRLEN             5 0
      *
      **  Key list for ACCNTL0                                         e
     C     KACCNT        KLIST
     C                   KFLD                    DSCNUM
     C                   KFLD                    DSCCY
     C                   KFLD                    DSACOD
     C                   KFLD                    DSACSQ
     C                   KFLD                    DSBRCA
      *
      **  Key list for RSACMTL2                                        e
     C     KACMT2        KLIST
     C                   KFLD                    DSBRCA
     C                   KFLD                    DSCNUM
     C                   KFLD                    DSCCY
     C                   KFLD                    DSACOD
     C                   KFLD                    DSACSQ
      *
      **  Work field for ledger balance during A/c movements           e
     C     *LIKE         DEFINE    LDBL          WFBAL
     C*  Retrieve TI Details                                                    161108
     C                   CALL      'AOTIINR0'                                   161108
     C                   PARM      '*MSG'        W0RTCD            7            161108
     C                   PARM      '*FIRST'      W0OPTN            7            161108
     C     SDTIIN        PARM      SDTIIN        DSFDY                          161108
     C** Database error                                                         161108
     C     W0RTCD        IFNE      *BLANKS                                      161108
     C     *LOCK         IN        LDA                                          161108
     C                   MOVE      'TI0100'      DBPGM                          161108
     C                   MOVEL     '*CALL'       DBKEY                          161108
     C                   MOVEL     'AOTIINR0'    DBFILE                         161108
     C                   Z-ADD     2             DBASE                          161108
     C                   EXSR      *PSSR                                        161108
     C                   ENDIF                                                  161108
      *                                                                                     AR870652
      ** Check if CRE060 is switched on                                                     AR870652
      *                                                                                     AR870652
     C                   MOVE      'N'           CRE060            1                        AR870652
     C                   CALL      'AOSARDR0'                                               AR870652
     C                   PARM      '*MSG   '     @RTCD             7                        AR870652
     C                   PARM      '*VERIFY'     @OPTN             7                        AR870652
     C                   PARM      'CRE060'      @SARN             6                        AR870652
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR870652
      *                                                                                     AR870652
     C     @RTCD         IFEQ      *BLANKS                                                  AR870652
     C                   MOVE      'Y'           CRE060                                     AR870652
     C                   ENDIF                                                              AR870652
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ** Interactive program therefore call 'DBERRCTL'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
