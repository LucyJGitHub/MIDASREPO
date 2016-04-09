     H DEBUG DATEDIT(*YMD)
     H ALWNULL(*USRCTL)                                                                     BUG13365
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *                     BUG13365
/*EXI *  TEXT('Midas API Transactions Awaiting Repair/Completion')    *
      *****************************************************************
      *                                                               *
      *  Midas - API                                                  *
      *                                                               *
      *  AP0012LE - Transactions Awaiting Repair/Completion           *
      *                                                               *
      *  Function:  This program produces a list of all transactions  *
      *             received with currently incomplete details.       *
      *                                                               *
      *  Called By: APC0002 - List of Transactions Awaiting Repair/   *
      *                       Completion component                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CAP190             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27041           Date 01Mar10               *
      *                 BUG26909           Date 21Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG18230           Date 18Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG13365           Date 21Apr06               *
      *                 CAP185  *CREATE    Date 21Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CAP190 - Customer Exchange MQ enabling.  (Recompile)         *
      *  BUG27041 - Incorrect mapping for MQ STCQ                     *
      *  BUG26909 - Records did not appear in Report                  *
      *  BUG18230 - Wrong Midas Transaction ID displayed              *
      *  BUG13365 - Use zonal file.                                   *
      *  CAP185 - MQ Series Interface                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     F*****MSRPRQL1  IF   E           K DISK                                                BUG13365
     FAPMRPQZL1 IF   E           K DISK                                                     BUG13365
      ** API logging file
      *
     FAPTLOGL0  IF A E           K DISK
      *
     FAPTLOGL1  IF   E           K DISK
     F                                     RENAME(APTLOGD0:APTLOG1)
      *
     FAPTLOGL2  IF   E           K DISK
     F                                     RENAME(APTLOGD0:APTLOG2)
      *
     FZATRNLOGL7IF   E           K DISK
      *
     FAP0012P1  O    E             PRINTER OFLIND(*IN87)
     F                                     USROPN
     F                                     INFDS(SPOOL1)
     FAP0012P2  O    E             PRINTER OFLIND(*IN88)
     F                                     USROPN
     F                                     INFDS(SPOOL2)
     FAP0012P3  O    E             PRINTER OFLIND(*IN89)
     F                                     USROPN
     F                                     INFDS(SPOOL3)
      ** Transactions sent via APIs Today
     FAP0012AU  O    E             PRINTER USROPN
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
      *     80 - READ indicator for APMRPQZL1                         *
      *     87 - Overflow indicator                                   *
      *     88 - Overflow indicator                                   *
      *     89 - Overflow indicator                                   *
      *     90 - READ indicator for APTLOGPD                          *
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
      *****************************************************************
      /EJECT
      *****************************************************************
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
      *
     I*/COPY ZSRSRC,ZSEDITZ2
      *
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
     C                   EXSR      END
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Main Processing                                        *
      *                                                               *
      * Called by: Main line processing                               *
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
     C                   WRITE     AP012AH1
     C     *LOVAL        SETLL     APTLOGL0
     C                   READ      APTLOGL0                               90
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP012BH1
     C     *LOVAL        SETLL     APTLOGL1
     C                   READ      APTLOGL1                               90
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP012CH1
     C                   WRITE     AP012CH2
     C     *LOVAL        SETLL     APTLOGL2
     C                   READ      APTLOGL2                               90
     C                   ENDSL
      *
     C                   IF        *IN90 = *OFF
     C                   MOVE      *OFF          *IN50
     C                   ENDIF
      *
      ** Write Report header and sub-header details, depending
      ** on the sequence of report requested
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
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP012AS1
     C                   WRITE     AP012AH2
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP012BS1
     C                   WRITE     AP012BH2
     C                   ENDSL
      *
     C                   MOVE      'N'           #BREAK
     C                   ENDIF
      ** Format details
     C                   EXSR      FORMAT
      *
      ** Write details
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP012AD1
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP012BD1
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP012CD1
     C                   ENDSL
      *
      ** Check overflow
     C                   EXSR      OVRFLW
      *
      ** Read next record and loop back
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   READ      APTLOGL0                               90
      *
     C                   WHEN      UTYPE = '2'
     C                   READ      APTLOGL1                               90
      *
     C                   WHEN      UTYPE = '3'
     C                   READ      APTLOGL2                               90
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   ENDIF
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
      ** Do first read before main loop
     C******LOVAL        SETLL     MSRPRQL1                                                 BUG13365
     C**********         READ      MSRPRQL1                               80                BUG13365
     C     *LOVAL        SETLL     APMRPQZL1                                                BUG13365
     C                   READ      APMRPQZL1                              80                BUG13365
      *
     C                   IF        *IN80 = *OFF
     C                   MOVE      *OFF          *IN50
     C                   ENDIF
      *
      ** Loop while records read
     C                   DOW       *IN80 = *OFF
      *
     C                   SELECT
     C                   WHEN      MSWACT = 'TR_INSERT'
     C**********         MOVE      'I'           #ACTION                                    BUG26909
     C                   MOVEL     'I'           #ACTION                                    BUG26909
      *
     C                   WHEN      MSWACT = 'TR_AMEND'
     C**********         MOVE      'A'           #ACTION                                    BUG26909
     C                   MOVEL     'A'           #ACTION                                    BUG26909
      *
     C                   WHEN      MSWACT = 'TR_REVERSE'
     C**********         MOVE      'D'           #ACTION                                    BUG26909
     C                   MOVEL     'D'           #ACTION                                    BUG26909
     C                   ENDSL
 
      ** Only process selected action types
     C                   IF        USEL = 'ALL' OR
     C                             #ACTION = UINSE OR
     C                             #ACTION = UAMDS OR
     C                             #ACTION = UDELS
      *
      ** Populate Temporary File
     C                   MOVEL     MSWFOTID      TFOTID
     C                   MOVEL     MSWINPTS      TTMSTP
      *                                                                                     BUG18230
      ** Initialize variable                                                                BUG18230
      *                                                                                     BUG18230
     C                   MOVE      *BLANKS       TMTRID                                     BUG18230
      *
     C     MSWMSGID      CHAIN     ZATRNLOGL7
     C                   IF        %FOUND(ZATRNLOGL7)
     C                   MOVEL     AAMIDASMOD    TMIMOD
     C                   MOVE      AAACTNCODE    TACTCD
     C                   MOVEL     AARPRLOC      TRPLOC
     C**********         MOVEL     AAMIDTRNID    TMTRID                            BUG18230 BUG27041
     C                   MOVEL     AAMIDTRID2    TMTRID                                     BUG27041
     C                   ENDIF
     C
     C**********         IF        MSWTREF <> *BLANKS                                       BUG18230
     C**********         MOVEL     MSWTREF       TMTRID                                     BUG18230
     C**********         ENDIF                                                              BUG18230
      *
     C                   MOVEL     MSWAPI        TAPINM
     C                   MOVEL     MSWFOATID     TASCID
     C                   MOVE      *BLANKS       TSTATS
      *
     C                   WRITE     APTLOGD0
     C                   ENDIF
      *
      ** Read next record and loop back
     C**********         READ      MSRPRQL1                               80                BUG13365
     C                   READ      APMRPQZL1                              80                BUG13365
      *
     C                   ENDDO
      *
     C                   ENDSR
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
     C                   MOVEL     TAPINM        RAPIN
     C                   ENDIF
      *
     C                   MOVEL     TTMSTP        RTMES
     C                   MOVE      *BLANKS       RFOTR
     C                   MOVEL     TFOTID        RFOTR
      *                                                                                       CGL029
      ** If module is 'GL', Front Office Id must be equal to Front Office                     CGL029
      ** Id + Associated Front Office Id                                                      CGL029
      *                                                                                       CGL029
     C                   IF        TMIMOD = 'GL'
     C                   MOVE      TASCID        RFOTR
     C                   ENDIF
      *                                                                                       CGL029
     C                   MOVEL     TMTRID        RMIDT                                         CAP03
      *
     C                   SELECT
     C                   WHEN      TACTCD = 'I'
     C                   MOVEL     'INSERT'      RACTN
      *
     C                   WHEN      TACTCD = 'A'
     C                   MOVEL(P)  'AMEND'       RACTN
      *
     C                   WHEN      TACTCD = 'D'
     C                   MOVEL     'DELETE'      RACTN
      *
     C                   WHEN      TACTCD = 'X'
     C                   MOVEL(P)  'AUTH'        RACTN
     C                   ENDSL
      *
     C                   IF        TRPLOC = 'B'
     C                   MOVEL(P)  'BACK'        RRPRL
     C                   ELSE
     C                   IF        TRPLOC = 'S'
     C                   MOVEL     'SENDER'      RRPRL
     C                   ENDIF
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
     C                   WRITE     AP012AH1
     C                   WRITE     AP012AS1
     C                   WRITE     AP012AH2
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP012BH1
     C                   WRITE     AP012BS1
     C                   WRITE     AP012BH2
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP012CH1
     C                   WRITE     AP012CH2
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
      ** Write Main Header and 'No Records'
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP012AH1
     C                   WRITE     AP012AS1
     C                   WRITE     AP012AH2
     C                   WRITE     AP012AST
     C                   WRITE     AP012AT
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP012BH1
     C                   WRITE     AP012BS1
     C                   WRITE     AP012BH2
     C                   WRITE     AP012BST
     C                   WRITE     AP012BT
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP012CH1
     C                   WRITE     AP012CH2
     C                   WRITE     AP012CST
     C                   WRITE     AP012CT
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   SELECT
     C                   WHEN      UTYPE = ' ' OR
     C                             UTYPE = '1'
     C                   WRITE     AP012AT
      *
     C                   WHEN      UTYPE = '2'
     C                   WRITE     AP012BT
      *
     C                   WHEN      UTYPE = '3'
     C                   WRITE     AP012CT
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
      * Called by: Main line processing                               *
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
     C                   OPEN      AP0012P1
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
     C                   MOVEL     'AP0012P1'    DBKEY                          * DBERR 02 *
     C                   Z-ADD     2             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        UTYPE = '2'
     C                   OPEN      AP0012P2
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
     C                   MOVEL     'AP0012P2'    DBKEY                          * DBERR 03 *
     C                   Z-ADD     3             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        UTYPE = '3'
     C                   OPEN      AP0012P3
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
     C                   MOVEL     'AP0012P3'    DBKEY                          * DBERR 04 *
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
     C                   MOVE      *BLANK        #BREAK            1
      *
     C                   MOVE      *BLANKS       #ACTION          30
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * END - End Routine                                             *
      *                                                               *
      * Called by: Main line processing                               *
      * Calls: None                                                   *
      *****************************************************************
     C     END           BEGSR
      *
     C                   SETON                                            LR
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
     C                   MOVEL(P)  'AP0012'      DBPGM
     C                   OUT       LDA
     C                   DUMP
      ** Open audit printer file
     C                   OPEN      AP0012AU
     C                   WRITE     AP0012A1
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@ - Object copyright
(c) Misys International Banking Systems Ltd. 2006
