     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                     MD039105
/*STD *  RPGSQLMOD                                                    *                     MD039105
/*EXI *  TEXT('Midas API Transactions Repaired/Completed Today')      *
      *****************************************************************
      *                                                               *
      *  Midas - API                                                  *
      *                                                               *
      *  AP0013LE - List of Transactions Repaired/Completed Today     *
      *                                                               *
      *  Function:  This program produces a list of all transactions  *
      *             repaired/completed today.                         *
      *                                                               *
      *  Called By: APC003 - List of Todays Transactions Component    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD039105           Date 06Jun16               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CAP190             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 01Mar10               *
      *                 BUG26911           Date 22Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CAP186C            Date 28Jan08               *
      *                 BUG13365           Date 15Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP185  *CREATE    Date 21Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039105 - Data truncation encountered when trying to insert *
      *             CUSD MQ and SOAP transaction with UDF fields      *
      *           - Applied for MD-39420.                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CAP190 - Customer Exchange MQ enabling. (Recompile)          *
      *  BUG27041 - Incorrect mapping for MQ STCQ                     *
      *  BUG26911 - Wrong API NAME in Report                          *
      *  CAP186C - MQ Enabled CB APIs (Recompile Only)                *
      *  BUG13365 - Use zonal file.                                   *
      *  CAP185 - MQ Series Interface                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** API logging file - selecting failed transactions
     FZATRNLOGL4IF   E           K DISK
      *
     F***APIMSGL0  IF   E           K DISK                                                  MD039105
      *
     FAPTLOGPD  O    E             DISK
     F                                     RENAME(APTLOGD0:APTLOGX)
      *
     FAPTLOGL0  IF   E           K DISK
     F                                     RENAME(APTLOGD0:APTLOG0)
      *
     FAPTLOGL1  IF   E           K DISK
     F                                     RENAME(APTLOGD0:APTLOG1)
      *
     F*****MSRPRQL0  IF   E           K DISK                                                BUG13365
     FAPMRPQZL0 IF   E           K DISK                                                     BUG13365
      ** Invalid transaction file - by Midas module/trans no/time
      *
     FAP0013P1  O    E             PRINTER OFLIND(*IN87)
     F                                     USROPN
     F                                     INFDS(SPOOL1)
     FAP0013P2  O    E             PRINTER OFLIND(*IN88)
     F                                     USROPN
     F                                     INFDS(SPOOL2)
     FAP0013P3  O    E             PRINTER OFLIND(*IN89)
     F                                     USROPN
     F                                     INFDS(SPOOL3)
      ** Transactions sent via APIs Today
     FAP0013AU  O    E             PRINTER USROPN
      ** Transactions sent via APIs Today Audit
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     50 - No records processed indicator                       *
      *                                                               *
      *     80 - READ indicator for ZATRNLOG                          *
      *     87 - Overflow indicator                                   *
      *     88 - Overflow indicator                                   *
      *     89 - Overflow indicator                                   *
      *                                                               *
      *  U7+U8 - Database error occurs                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DS for bank details
     D  TITL         E                     EXTFLD(BJURPT)
     D  ORUNA        E                     EXTFLD(BJMRDT)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, short data structure
      *
     D SPOOL1          DS
      ***  DS for ZSFILE data
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D SPOOL2          DS
      ***  DS for ZSFILE data
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D SPOOL3          DS
      ***  DS for ZSFILE data
     D  SFILE3                83     92
     D  SFNUM3               123    124B 0
     D RPARM           DS           100
      ***  DS for parameter data
     D  UTYPE                  1      1
     D  UINSE                  2      2
     D  UAMDS                  3      3
     D  UDELS                  4      4
     D  UAUTH                  5      5
     D APIDS         E DS                  EXTNAME(T_APIMSG)                                MD039105
     D  MQMSGS                47  32047                                                     MD039105
      *
     D WTemp           S              4                                                     BUG26911
     D WStart          S              5S 0                                                  BUG26911
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Initial processing
     C                   EXSR      INIT
      *
      ** Main processing
     C                   EXSR      MAIN
      *
      ** End processing
     C                   EXSR      ENDRTN
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Main Processing                                        *
      *                                                               *
      * Called by: C.MOD                                              *
      * Calls:     *PSSR                                              *
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Set on 'No records processed'
     C                   MOVE      *ON           *IN50
      *
      ** Populate Temporary File
     C                   EXSR      POPTFL
      *
      ** Write Report header and sub-header details, depending
      ** on the sequence of report requested
     C                   IF        *IN50 = *OFF
      *
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP013AH1
     C                   MOVE      'Y'           #FREP
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP013BH1
     C                   MOVE      'N'           #FREP
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP013CH1
     C                   WRITE     AP013CH2
     C                   MOVE      'Y'           #FREP
     C                   ENDSL
      *
     C                   IF        #FREP = 'Y'
     C     *LOVAL        SETLL     APTLOGL0
     C                   READ      APTLOGL0                               90
     C                   ELSE
     C     *LOVAL        SETLL     APTLOGL1
     C                   READ      APTLOGL1                               90
     C                   ENDIF
      *
     C                   DOW       *IN90 = *OFF
      *
     C                   IF        TAPINM <> #APISV
     C                   MOVE      'Y'           #BREAK
     C                   MOVEL(P)  TAPINM        #APISV
     C                   ENDIF
      *
      ** Check if another API
     C                   IF        #BREAK = 'Y'
      *
     C                   MOVEL(P)  TAPINM        RAPINM
      *
     C                   IF        UTYPE <> '3'
     C                   IF        #FREP = 'Y'
     C                   WRITE     AP013AS1
     C                   ELSE
     C                   WRITE     AP013BS1
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP013AH2
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP013BH2
     C                   ENDSL
      *
     C                   MOVE      'N'           #BREAK
     C                   ENDIF
      *
      ** Format details
     C                   EXSR      FORMAT
      *
      ** Write details
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP013AD1
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP013BD1
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP013CD1
     C                   ENDSL
      *
      ** Check overflow
     C                   EXSR      OVRFLW
      *
     C                   IF        #FREP = 'Y'
     C                   READ      APTLOGL0                               90
     C                   ELSE
     C                   READ      APTLOGL1                               90
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** End report
     C                   EXSR      ENDRPT
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * POPTFL - Populate Temporary File                              *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls:     *PSSR                                              *
      *****************************************************************
     C     POPTFL        BEGSR
      *
     C                   READ      ZATRNLOGL4                             80
      *
     C                   IF        *IN80 = *OFF
     C                   MOVE      *OFF          *IN50
     C                   ENDIF
      ** Loop while records read
     C                   DOW       *IN80 = *OFF
      *
      ** Only process selected action types
     C                   IF        USEL = 'ALL' OR
     C                             AAACTNCODE = UINSE OR
     C                             AAACTNCODE = UAMDS OR
     C                             AAACTNCODE = UDELS OR
     C                             AAACTNCODE = UAUTH
      *
      ** If the transaction is still on the Invalid Transaction
      ** file, then it has not been repaired - read next record
     C*****AAMSGLOGID    CHAIN     MSRPRQL0                                                 BUG13365
     C**********         IF        %FOUND(MSRPRQL0)                                         BUG13365
     C     AAMSGLOGID    CHAIN     APMRPQZL0                                                BUG13365
     C                   IF        NOT %FOUND(APMRPQZL0)                                    BUG13365
      *
      ** Populate Temporary File
     C                   MOVEL     AAFOTRNID     TFOTID
     C                   MOVEL     AATMESTMP     TTMSTP
     C                   MOVEL     AAMIDASMOD    TMIMOD
      *
      ** Check API name from MQ Series Messages Log file
     C*****AAMSGLOGID    CHAIN     APIMSGL0                           85                    MD039105
     C**********         IF        %FOUND(APIMSGL0)                                         MD039105
     C/exec SQL                                                                             MD039105
     C+ SELECT * INTO :APIDS FROM T_APIMSG                                                  MD039105
     C+ where MQMSID = :AAMSGLOGID                                                          MD039105
     C/end-exec                                                                             MD039105
     C                   IF        SQLCODE = 0                                              MD039105
     C                   MOVEL     MQMSGS        WTemp                                      BUG26911
     C                   IF        WTemp = '<mid'                                           BUG26911
     C                   Z-ADD     0             WStart                                     BUG26911
     C                   EVAL      WStart = %SCAN('.':MQMSGS) + 1                           BUG26911
     C                   EVAL      TAPINM = %SUBST(MQMSGS:WStart:4)                         BUG26911
     C                   ELSE                                                               BUG26911
     C                   MOVEL     MQMSGS        TAPINM
     C                   ENDIF                                                              BUG26911
     C                   ENDIF
      *
     C**********         MOVEL     AAMIDTRNID    TMTRID                                     BUG27041
     C                   MOVEL     AAMIDTRID2    TMTRID                                     BUG27041
     C                   MOVEL     AAACTNCODE    TACTCD
     C                   MOVEL     AARPRLOC      TRPLOC
     C                   MOVEL     AAASOCID      TASCID
      *
     C                   WRITE     APTLOGX
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read next record and loop back
     C                   READ      ZATRNLOGL4                             80
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * FORMAT - Format details                                       *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls:     *PSSR                                              *
      *****************************************************************
     C     FORMAT        BEGSR
      *
      * Set Report fields
     C                   IF        UTYPE = '3'
     C                   MOVEL(P)  TAPINM        RAPIN
     C                   ENDIF
      *
     C                   MOVEL     TTMSTP        RTMES
     C                   MOVEL     TFOTID        RFOTR
      *
      ** If module is 'GL', Front Office Id must be equal to Front Office
      ** Id + Associated Front Office Id
      *
     C                   IF        TMIMOD = 'GL'
     C                   MOVE      TASCID        RFOTR
     C                   ENDIF
      *
     C                   MOVEL     TMTRID        RMIDT
     C                   MOVE      *BLANK        RACTN
      *
     C                   SELECT
     C                   WHEN      TACTCD = 'I'
     C                   MOVEL     'INSERT'      RACTN
      *
     C                   WHEN      TACTCD = 'A'
     C                   MOVEL     'AMEND '      RACTN
      *
     C                   WHEN      TACTCD = 'D'
     C                   MOVEL     'DELETE'      RACTN
      *
     C                   WHEN      TACTCD = 'X'
     C                   MOVEL     'AUTH  '      RACTN
     C                   ENDSL
      *
     C                   MOVE      *BLANK        RRPRL
      *
     C                   IF        TRPLOC = 'B'
     C                   MOVEL     'BACK'        RRPRL
     C                   ELSE
     C                   MOVEL     'SENDER'      RRPRL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * OVRFLW - Check overflow                                       *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls:     None                                               *
      *****************************************************************
     C     OVRFLW        BEGSR
      *
      ** Print new header if required
     C                   IF        *IN87 = *ON OR
     C                             *IN88 = *ON OR
     C                             *IN89 = *ON
      *
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP013AH1
     C                   WRITE     AP013AS1
     C                   WRITE     AP013AH2
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP013BH1
     C                   WRITE     AP013BS1
     C                   WRITE     AP013BH2
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP013CH1
     C                   WRITE     AP013CH2
     C                   ENDSL
      *
     C                   MOVEA     '000'         *IN(87)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * ENDRPT - End report                                           *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls:     None                                               *
      *****************************************************************
     C     ENDRPT        BEGSR
      *
      ** If no records processed
     C                   IF        *IN50 = *ON
      *
      ** Write 'No details to report'
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP013AH1
     C                   WRITE     AP013AS1
     C                   WRITE     AP013AH2
     C                   WRITE     AP013AST
     C                   WRITE     AP013AT
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP013BH1
     C                   WRITE     AP013BS1
     C                   WRITE     AP013BH2
     C                   WRITE     AP013BST
     C                   WRITE     AP013BT
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP013CH1
     C                   WRITE     AP013CH2
     C                   WRITE     AP013CST
     C                   WRITE     AP013CT
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP013AT
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP013BT
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP013CT
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * INIT - Initialisation routine                                 *
      *                                                               *
      * Called by: C.MOD                                              *
      * Calls:     *PSSR                                              *
      *****************************************************************
     C     INIT          BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ZSEQ
     C                   PARM                    RLEV              1
     C                   PARM                    RENT              3
     C                   PARM                    RPARM           100
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
      *
      ** Access Bank ICD File for bank report heading, rundate and
      ** date format indicator
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     @OPTN         DBKEY                          * DBERR 01 *
     C                   Z-ADD     1             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check date format and move rundate to print field
     C     BJDFIN        COMP      'M'                                    98
      *
      ** Open relevant printer file
     C                   IF        UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   OPEN      AP0013P1
      *
      ** Call ZSFILE to log spool file details for report
     C                   Z-ADD     SFNUM1        ZSNUM
     C                   MOVEL     SFILE1        ZSNAM
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ              5
     C                   PARM      *BLANKS       ZENT              3
     C                   PARM                    ZSNAM            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If error perform database error handling and exit program
     C                   IF        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     'ZSFILE'      DBFILE                         ************
     C                   MOVEL     'AP0013P1'    DBKEY                          * DBERR 02 *
     C                   Z-ADD     2             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        UTYPE = '2'
     C                   OPEN      AP0013P2
      *
      ** Call ZSFILE to log spool file details for report
     C                   Z-ADD     SFNUM2        ZSNUM
     C                   MOVEL     SFILE2        ZSNAM
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ              5
     C                   PARM      *BLANKS       ZENT              3
     C                   PARM                    ZSNAM            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If error perform database error handling and exit program
     C                   IF        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     'ZSFILE'      DBFILE                         ************
     C                   MOVEL     'AP0013P2'    DBKEY                          * DBERR 03 *
     C                   Z-ADD     3             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        UTYPE = '3'
     C                   OPEN      AP0013P3
      *
      ** Call ZSFILE to log spool file details for report
     C                   Z-ADD     SFNUM3        ZSNUM
     C                   MOVEL     SFILE3        ZSNAM
     C                   CALL      'ZSFILE'
     C                   PARM                    ZSEQ              5
     C                   PARM      *BLANKS       ZENT              3
     C                   PARM                    ZSNAM            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM      *BLANKS       ZERR              1
      *
      ** If error perform database error handling and exit program
     C                   IF        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     'ZSFILE'      DBFILE                         ************
     C                   MOVEL     'AP0013P3'    DBKEY                          * DBERR 04 *
     C                   Z-ADD     4             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Set field for selection of all action codes
     C                   MOVE      *BLANK        USEL              3
     C                   IF        UINSE = *BLANK AND
     C                             UAMDS = *BLANK AND
     C                             UDELS = *BLANK AND
     C                             UAUTH = *BLANK
     C                   MOVE      'ALL'         USEL
     C                   ENDIF
      *
      ** API indicator
     C                   MOVE      *BLANKS       #APISV            4
      *
     C                   MOVE      *BLANK        #FREP             1
      *
     C                   MOVE      *BLANK        #BREAK            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * END - End Routine                                             *
      *                                                               *
      * Called by: C.MOD                                              *
      * Calls: None                                                   *
      *****************************************************************
     C     ENDRTN        BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      * Called by: INIT, MAIN                                         *
      * Calls:     None                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = 'N'
     C                   MOVE      'Y'           @RUN              1
     C                   MOVEL(P)  'AP0013'      DBPGM
     C                   OUT       LDA
     C                   DUMP
      ** Open audit printer file
     C                   OPEN      AP0013AU
     C                   WRITE     AP0013A1
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@ - Object copyright
(c) Misys International Banking Systems Ltd. 2006
