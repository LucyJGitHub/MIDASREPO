     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS RE Monthly W/h Tax Report')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE005011P - Midas RE Monthly Tax Reporting                   *
      *                                                               *
      *  Function:  This program will produce a report showing the    *
      *  (COB)      Tax Withheld for the month and the year to        *
      *             date tax amount.                                  *
      *                                                               *
      *  Called By: REC005011 - Monthly Withholding Tax Reporting     *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *         U7+U8    Set on if Database error occurs              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     FREAWTXPD  IF   E           K DISK
      ** Accumulated Withholding Tax File    Retrieval Index
      *
     FSDWTRCPD  IF   E           K DISK    USROPN
      ** Withholding Tax Rate Code File
      *
     FRE005011P1O    E             PRINTER INFDS(SPOOL)
     F                                     OFLIND(*IN01)
      ** Monthly Withholding Tax Report
      *
      /EJECT
      ****************************************************************
      *
     D TXCD            S              2    DIM(50)
     D TXDC            S             30    DIM(50)
      *
      ** TABLE FOR DESCRIPTION OF A PARTICULAR TAX CODE
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /EJECT
      ****************************************************************
     D SPOOL           DS
      *
      **DATA STRUCTURE THAT ACQUIRE THE SPOOL FILE DETAILS
      *
      **SPOOL FILE NAME
     D  SFILE                 83     92
      *
      **SPOOL FILE NUMBER
     D  SFNUM                123    124B 0
      *
     D PSDS           SDS
      *
      **  Program Status Data Structure
      *
      **                   Program name
     D  @PGM                   1     10
      *
      **                   Workstation ID
     D  @JOB                 244    253
      *
      **                   User ID
     D  @USER                254    263
      *
     D LDA            UDS           256
      *
      **  Local data area for data base errors.
      *
      **  Group level field of the foll. other fields
     D  DBLOT                134    177
      *
      **  Name of database file in error
     D  DBFILE               134    141
      *
      **  Key value causing database error
     D  DBKEY                142    167
      *
      **  Name of program causing database error
     D  DBPGM                168    175
      *
      **  Number of database error
     D  DBASE                176    177
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D**  MIDAS Bank Details
     D*
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D**  MIDAS Currency Details
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D**  Short data structure for access programs
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D**  Long data structure for access programs
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Index to subroutines                                         *
      *                                                               *
      *            MAIN   - Main Processing                           *
      *            FIRST  - Initialisation                            *
      *            PROC   - Detail Processing                         *
      *            CCYCHK - Checks Currency and gets its CDP          *
      *            TXDCHK - Checks Tax code and gets its              *
      *                     description                               *
      *            PRTDET - Prints Detail Line of Report              *
      *            LAST   - Final Processing                          *
      *            DBERR  - Database Error Handling : Terminates prog *
      *                                                               *
      *       Standard sub-routines                                   *
      *                                                               *
      *            ZFRPED   - Converts numeric fields to edited with  *
      *                       commas, decimals and sign(CR,-)         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            MAIN   - Main Processing                           *
      *                                                               *
      * CALLS      FIRST  - Initial Processing                        *
      *            PROC   - Detail Processing                         *
      *            LAST   - Final Processing                          *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
      *
      ** Receive Parameter from CLP/REC005011
      *
     C     *ENTRY        PLIST
     C                   PARM                    SEQ               5
      *
      ** Initial processing
      *
     C                   EXSR      FIRST
      *
      ** Detail processing
      *
     C                   EXSR      PROC
      *
      **  Final Processing
      *
     C                   EXSR      LAST
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            FIRST  - Initialize                                *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling                   *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     FIRST         BEGSR                                                  ** FIRST  **
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialization of LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   OUT       LDA
      *
      ** Move program name and wrkstn id to report fields
      *
     C                   MOVEL     @JOB          SWRKID           10
     C                   MOVE      *BLANKS       SMRNDT            7
     C                   MOVEL     @PGM          DBPGM
      *
      *
      ** Access SDBANKPD for bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE                          * * * * * * * *
     C                   MOVEL     'FIRST'       DBKEY                          *  DBERR 001  *
     C                   MOVEL     'SDBANKPD'    DBFILE                         * * * * * * * *
     C                   EXSR      *PSSR
     C                   END
      *
      * Set up Header Fields
     C                   MOVEL     BJURPT        TITL
     C                   MOVEL     BJMRDT        RUNA
      *
      ** CALL ACCESS PROGRAM FOR CURRENCY DETAILS
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      BJLCCY        @DCCY             3
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                          *************
     C                   MOVEL     '002'         DBASE                           *DBERROR 002*
     C                   MOVEL     BJLCCY        DBKEY                           **************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Store local currency decimal places.
     C     *LIKE         DEFINE    A6NBDP        LCCDP
     C                   Z-ADD     A6NBDP        LCCDP
      *
      ** Processing to place description of Tax code to array/table
      *
     C                   OPEN      SDWTRCPD
     C                   SETOFF                                       10
     C                   Z-ADD     0             X                 2 0
     C                   READ      SDWTRCPD                               10
     C     *IN10         DOWEQ     '0'
     C                   ADD       1             X
     C                   MOVE      WTRC          TXCD(X)
     C                   MOVEL     DESC          TXDC(X)
     C                   READ      SDWTRCPD                               10
     C                   END
      *
      ** Initialize calculated no. of records
      *
     C                   Z-ADD     0             CNOR
      *
      ** Initialise prev. currency field, write header & initialise
      ** line counter.
      *
     C                   MOVE      *BLANKS       @CCY              3
     C                   WRITE     HEADER
     C                   Z-ADD     8             @LCNT             2 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            PROC   - Detail Processing of file                 *
      *                                                               *
      * CALLS      CCYCHK - Currency Checking                         *
      *            TXDCHK - Tax Code Description Checking             *
      *            PRTDET - Detail Line Printing                      *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     PROC          BEGSR                                                  ** PROC   **
      *
     C                   SETOFF                                       11
     C                   READ      REAWTXPD                               11
      *
     C     *IN11         DOWEQ     '0'
      *
      ** Check if currently read currency is same as previously read
      ** currency.
      *
     C     CCY           IFNE      @CCY
     C                   EXSR      CCYCHK
     C                   END
      *
      ** Get Description of tax code
      *
     C                   EXSR      TXDCHK
      *
      ** Print Details
      *
     C                   EXSR      PRTDET
      *
      ** Update counter for records read
      *
     C                   ADD       1             CNOR
      *
      ** Get next record
      *
     C                   READ      REAWTXPD                               11
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            CCYCHK - Currency checking                         *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling                   *
      *                                                               *
      * CALLED BY  PROC   - Detail Processing of file                 *
      *                                                               *
      *****************************************************************
     C     CCYCHK        BEGSR                                                  ** CCYCHK **
      *
      ** Get currency decimal places
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      CCY           @DCCY             3
     C     SDCURR        PARM      SDCURR        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                          *************
     C                   MOVEL     '03'          DBASE                           *DBERROR 003*
     C                   MOVEL     CCY           DBKEY                           **************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            TXDCHK - Tax code checking                         *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling                   *
      *                                                               *
      * CALLED BY  PROC   - Detail Processing of file                 *
      *                                                               *
      *****************************************************************
     C     TXDCHK        BEGSR                                                  ** TXDCHK **
      *
      ** Set up variables for table look up to tax code.
      *
     C                   Z-ADD     1             X
     C                   MOVE      *BLANKS       STXDS            30
      *
      ** Look up and corresponding database error checking.
      *
     C     TTXRC         LOOKUP    TXCD(X)                                72
     C     *IN72         IFEQ      '0'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDTXRTPP'    DBFILE                         **************
     C                   MOVEL     '004'         DBASE                          * DB ERR 004 *
     C                   MOVEL     TTXRC         DBKEY                          **************
     C                   EXSR      DBERR
     C                   ELSE
     C                   MOVE      TXDC(X)       STXDS
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            PRTDET - Print Details of Report                   *
      *                                                               *
      * CALLS      ZFRPED - Numeric to Edited Numeric conversion      *
      *                                                               *
      * CALLED BY  PROC   - Detail Processing of file                 *
      *                                                               *
      *****************************************************************
     C     PRTDET        BEGSR                                                  ** PRTDET **
      *
      ** Set up amount variables for output
      *
     C                   MOVE      TTXRC         STXRC             2
      *
     C                   MOVE      *BLANKS       SMTXA
     C                   Z-ADD     0             ZFLD15
     C                   Z-ADD     TMTXA         ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      A6NBDP        ZDECS
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        SMTXA
      *
     C                   MOVE      *BLANKS       SYTXA
     C                   Z-ADD     0             ZFLD15
     C                   Z-ADD     TYTXA         ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      A6NBDP        ZDECS
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        SYTXA
      *
     C                   MOVE      *BLANKS       SMTXB
     C                   Z-ADD     0             ZFLD15
     C                   Z-ADD     TMTXL         ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      LCCDP         ZDECS
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        SMTXB
      *
     C                   MOVE      *BLANKS       SYTXB
     C                   Z-ADD     0             ZFLD15
     C                   Z-ADD     TYTXL         ZFLD15
     C                   MOVE      'J'           ZECODE
     C                   MOVE      LCCDP         ZDECS
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT22           22
     C                   PARM                    ZWRK25           25
      *
     C                   MOVE      ZOUT22        SYTXB
      *
      ** Check for line count before printing.  If bottom of page
      ** is reached, go to next page, printing header first.
      *
     C     @LCNT         IFGE      54
     C                   WRITE     HEADER
     C                   Z-ADD     8             @LCNT
     C                   END
     C                   WRITE     DETAIL
     C                   ADD       2             @LCNT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            LAST   - Terminate                                 *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Processing                           *
      *                                                               *
      *****************************************************************
     C     LAST          BEGSR                                                  ** LAST   **
      *
      ** Write Report Trailers
      *
     C     CNOR          IFEQ      0
     C                   WRITE     NODET                                        * No Details
     C                   ELSE
     C     @LCNT         IFGT      48
     C                   WRITE     HEADER
     C                   END
     C                   WRITE     TOTPRT                                       * Record Count
     C                   END
      *
     C                   MOVE      '1'           *INLR
      *
      ** ENSURE REPORT SPOOL FILE IS RECORDED BY RCF
      *
     C                   Z-ADD     SFNUM         SFNUM1            6 0
     C                   CALL      'ZSFILE'
     C                   PARM                    SEQ
     C                   PARM      *BLANKS       @PARM             3
     C                   PARM                    SFILE
     C                   PARM                    SFNUM1
     C                   PARM                    ZSERR             1
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *PSSR  -                                           *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR                                                  ** *PSSR  **
      *
     C                   DUMP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            INFSR  -                                           *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     INFSR         BEGSR                                                  ** INFSR  **
      *
     C                   DUMP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            DBERR  - Database Error Handling : Terminates prog *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  FIRST  - Fetching fields from Alternate Cust. Mast *
      *            CCYCHK - Move File Fields to Work/Screen           *
      *            TXDCHK - Fetching fields from Cust. mast. SDCUSTL1 *
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR                                                  ** DBERR  **
      *
     C                   MOVEL     @PGM          DBPGM
     C                   OUT       LDA
     C                   WRITE     DBERRP
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
**  CPY@
(c) Finastra International Limited 2015
