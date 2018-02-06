     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas API Transactions Awaiting Repair/Completion')    *
      *****************************************************************
      *                                                               *
      *  Midas - API                                                  *
      *                                                               *
      *  AP0015LE - Transactions Awaiting Repair/Completion           *
      *                                                               *
      *  Function:  This program produces a list of all transactions  *
      *             received with currently incomplete details.       *
      *                                                               *
      *  Called By: APC0002 - List of Transactions Awaiting Repair    *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CAP190             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13365 *CREATE   Date 15Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CAP190 - Customer Exchange MQ enabling. (Recompile)          *
      *  BUG13365 - COB should not proceed if Repair Queue file has   *
      *             records. Create a report that will show all the   *
      *             transactions awaiting repair.                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FAPMRPQZL2 IF   E           K DISK
      ** API logging file
      *
     FAP0015P1  O    E             PRINTER OFLIND(*IN87)
     F                                     INFDS(SPOOL1)
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
      *     80 - READ indicator for APMRPQZL2                         *
      *     87 - Overflow indicator                                   *
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
     C     *LOVAL        SETLL     APMRPQZL2
     C                   READ      APMRPQZL2                              80
      *
     C                   IF        *IN80 = *OFF
     C                   MOVE      *OFF          *IN50
     C                   ENDIF
      ** Write Header
     C                   IF        #FIRST = 'Y'
     C                   WRITE     AP015CH1
     C                   WRITE     AP015CH2
     C                   MOVE      'N'           #FIRST
     C                   ENDIF
      *
      ** If no records found
     C                   IF        *IN50 = *ON
     C                   WRITE     AP015CST
     C                   ELSE
     C                   DOW       *IN80 = *OFF
      ** Next Page
     C                   IF        *IN87 = *ON
     C                   WRITE     AP015CH1
     C                   WRITE     AP015CH2
     C                   ENDIF
      *
     C                   MOVEL     MSWAPI        RAPIN
     C                   MOVE      MSWID         RPRID
     C                   MOVEL     MSWACT        RACTN
     C                   MOVE      MSWINPTS      RINTS
     C                   MOVEL     MSWINPUSER    RUSER
      *
     C                   WRITE     AP015CD1
      *
     C                   READ      APMRPQZL2                              80
      *
     C                   ENDDO
     C                   ENDIF
      *
      ** End of Report
     C                   WRITE     AP015CT
      *
     C                   SETON                                        LR
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
     C                   MOVEL     'AP0015P1'    DBKEY                          * DBERR 02 *
     C                   Z-ADD     2             DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      'Y'           #FIRST            1
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
     C                   MOVEL(P)  'AP0015LE'    DBPGM
     C                   OUT       LDA
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@ - Object copyright
(c) Finastra International Limited 2007
