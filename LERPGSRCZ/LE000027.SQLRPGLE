     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas LE CLE169 Take-on Program')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000027 - CLE169 Take-on Program                            *
      *                                                               *
      *  Function:  This program will trigger the facility history    *
      *             rebuild for retail accounts with linked facility  *
      *             if there is an imbalance with the facility amount *
      *             minus the drawn amount and the contingent facility*
      *             account                                           *
      *                                                               *
      *  Called By: LEC000027 - Midas LE CLE169 Take-on Program       *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD056172           Date 03Jul20               *
      *  Prev Amend No. MD052994  *CREATE  Date 25Nov19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD056172 - Typographical Error in LE000027AU.(Recompile)     *
      *  MD052994 - CL Facility event not generated for retail        *
      *             account debit capitalised interests               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    nn         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRALLRETAIL - Read all retail accounts with linked facility   *
      * SRWFATVAL - Get Todays Valuation in Exposure Currency         *
      * SRTRIGREBLD - Trigger rebuild by updating FCHD of Retail Acct *
      * SRREPORTAU - Audit Report Subroutine                          *
      * SRREPORTP1 - Detail Report Subroutine                         *
      * *INZSR - Initialise                                           *
      * *PSSR - Error processing                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** REPORT FILES
     FLE000027AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
     FLE000027P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** D-specs
      *
     D LDA           E DS           256    EXTNAME(LDA)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      *
      ** Arrays and Data Structures
      *

      ** File Information Data Structure for LE000027AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ** File Information Data Structure for LE000027P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Work Data Structures
     D ACCTDetails     DS
     D   RECNUM                       6A
     D   RECCY                        3A
     D   REACOD                      10S 0
     D   REACSQ                       2S 0
     D   REBRCA                       3A
     D   REACNO                      10S 0
     D   RELDBL                      15P 0
     D   REFCCU                       6A
     D   REFACT                       3S 0
     D   REFCNO                       2S 0

      *
      ** Declared variables
      *

     D @RUN            S              1

      ** Access Object Variables
     D PRTCD           S              7
     D POPTN           S              7

      ** Date Variables
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

      ** Report Variables
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
     D WOPNP1          S              1

      ** Declared Work Variables
     D WFCHD           S              5P 0
     D WLFCD           S              5P 0
     D WFATVAL         S             15P 0

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************
      ** Reinitialize Report Variables
     C                   EVAL      RREAD = 0
     C                   EVAL      RRBLD = 0
     C                   EVAL      WOPNP1 = 'N'

     C                   EXSR      SRALLRETAIL
     C                   EXSR      SRREPORTAU

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRALLRETAIL - Read all Retail Accounts with linked facilities *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SRWFATVAL, SRTRIGREBLD                                 *
      *                                                               *
      *****************************************************************

     C     SRALLRETAIL   BEGSR

      * Create a list of all the unique Contingent Facility Accounts (CFA)
     C/EXEC SQL
     C+ DECLARE ACCTCursor INSENSITIVE SCROLL CURSOR FOR
     C+ SELECT CNUM, CCY, ACOD, ACSQ, BRCA, ACNO, LDBL,
     C+        FCCU, FACT, FCNO
     C+ FROM ACCNTAB
     C+ WHERE ATYP = 'R' AND LDBL > 0 AND
     C+       FCCU <> '' AND FACT > 0 AND FCNO > 0
     C+ ORDER BY FCCU, FACT, FCNO
     C/END-EXEC

     C/EXEC SQL
     C+ OPEN ACCTCursor
     C/END-EXEC

     C                   CLEAR                   ACCTDetails

     C/EXEC SQL
     C+ FETCH NEXT FROM ACCTCursor INTO :ACCTDetails
     C/END-EXEC

     C                   IF        SQLCODE <> -305
     C                   DOW       SQLCODE <> 100

     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 005
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EXSR      SRWFATVAL

     C                   IF        RELDBL <> WFATVAL
     C                   EVAL      RRBLD = RRBLD + 1
     C                   EXSR      SRTRIGREBLD
     C                   ENDIF

     C                   EVAL      RREAD = RREAD + 1

     C                   CLEAR                   ACCTDetails

     C/EXEC SQL
     C+ FETCH NEXT FROM ACCTCursor INTO :ACCTDetails
     C/END-EXEC

     C                   ENDDO
     C                   ENDIF

     C/EXEC SQL
     C+ CLOSE ACCTCursor
     C/END-EXEC
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWFATVAL - Get Todays Valuation in Exposure Currency         *
      *                                                               *
      * Called by: SRALLRETAIL                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRWFATVAL     BEGSR

     C                   EVAL      WFATVAL = 0

     C/EXEC SQL
     C+  SELECT FATVAL INTO :WFATVAL
     C+  FROM FACHISA
     C+  WHERE FACNUM = :REFCCU AND FAFCTY = (:REFACT*100)+:REFCNO AND
     C+        FAACNO = :REACNO
     C+  ORDER BY FADATE DESC, FAFSEQ DESC
     C+  LIMIT 1
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND
     C                             SQLCODE <> 100 AND
     C                             SQLCODE <> -305
     C                   EVAL      DBFILE = 'FACHISA'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTRIGREBLD - Trigger the Facility Rebuild by changing        *
      *               the FCHD in GLACNTQD for the retail account     *
      *                                                               *
      * Called by: SRALLRETAIL                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRTRIGREBLD   BEGSR

     C                   EVAL      WLFCD = 0
     C                   EVAL      WFCHD = BJRDNB

     C/EXEC SQL
     C+ SELECT F1LFCD INTO :WLFCD
     C+ FROM GLACNTQD
     C+ WHERE F1CNUM = :RECNUM AND F1CCY = :RECCY AND F1ACOD = :REACOD
     C+       AND F1ACSQ = :REACSQ AND F1BRCA = :REBRCA
     C/END-EXEC


     C                   IF        SQLCODE <> 0 AND
     C                             SQLCODE <> 100 AND
     C                             SQLCODE <> -305
     C                   EVAL      DBFILE = 'GLACNTQD'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 003
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        WLFCD > 0
     C                   EVAL      WFCHD = WLFCD
     C                   ENDIF

     C/EXEC SQL
     C+ UPDATE GLACNTQD
     C+ SET F1FCHD = :WFCHD
     C+ WHERE F1CNUM = :RECNUM AND F1CCY = :RECCY AND F1ACOD = :REACOD
     C+       AND F1ACSQ = :REACSQ AND F1BRCA = :REBRCA
     C/END-EXEC

      * SQL Error Catch
     C                   IF        SQLCODE <> 0
     C                   EVAL      DBFILE = 'GLACNTQD'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBASE  = 004
     C                   EXSR      *PSSR
     C                   ENDIF

      * Reporting
     C                   EXSR      SRREPORTP1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRREPORTAU - Audit Report Subroutine and end of Detail Report *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRREPORTAU    BEGSR

      *** Write Audit Report
     C                   WRITE     HEADAU
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
     C                   WRITE     CONTROLAU
     C                   ENDIF

      *** Write the end of the Detail Report
     C                   IF        WOPNP1 = 'Y'
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LEHEADP1
     C                   ENDIF
      ** Write out Trailer Format.
     C                   WRITE     TRAILP1

     C                   CLOSE     LE000027P1
     C                   EVAL      WOPNP1 = 'N'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRREPORTP1 - Detail Report Subroutine                         *
      *                                                               *
      * Called by: SRTRIGREBLD                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRREPORTP1    BEGSR

      * Detailed Report Constructor
     C                   EVAL      RACNO = REACNO
     C                   EVAL      RFCCU = REFCCU
     C                   EVAL      RFACT = REFACT
     C                   EVAL      RFCNO = REFCNO

      * Date Formatter - Last Facility Change Date
     C                   EVAL      ZDAYNO = WLFCD

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

     C                   EVAL      RLFCD = ZADATE

      * Date Formatter - Facility Change Date (Updated)
     C                   EVAL      ZDAYNO = WFCHD

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

     C                   EVAL      RFCHD = ZADATE

      * Report Fields have value at this point
     C                   IF        WOPNP1 <> 'Y'
     C                   OPEN      LE000027P1
     C                   EVAL      WOPNP1 = 'Y'
     C                   ENDIF

      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     6             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     LEHEADP1
     C                   ENDIF

      ** Write out Detail Record.
     C                   WRITE     LEDETLP1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *DTAARA       DEFINE                  LDA

      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *INZSR, SRTOTALAUDIT, SRTOTALRELDBL, SRTOTALLECPAM,*
      *            SRTOTALOTHER, SRWRKFILE, SRWRKPROC, SRTRIGREBLD,   *
      *            SRCONVERT                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   EXSR      SRREPORTAU

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************

