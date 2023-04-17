     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SE SECTYDQD File Utility')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  UTSE0859 - Security Details JMS Enabling Extn File Utility   *
      *                                                               *
      *  Function: The utility will add records in SECTYDQD for       *
      *            existing securities that have no matching records  *
      *            in SECTYDQD.                                       *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD058313 *CREATE   Date 17Apr23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058313 - Utility program to add records in SECTYDQD        *
      *             Applied for MD-61078.                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FUTSE0859P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

     FUTSE0859AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short DS for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File information DS for UTSE0859P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File information DS for UTSE0859AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D RetCode         S              7A
     D Option          S              7A
     D WRun            S              1A
     D WAddCtr         S             10  0 INZ(*ZEROS)
     D WOldCtr         S             10  0 INZ(*ZEROS)
     D Mode            S              1A

      ** DS for SQL cursor C1
     D dsC1            DS
     D Status                  1      1
     D Security                2     11

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Get number of existing records in SECTYDQD

     C/EXEC SQL
     C+ SELECT COUNT(*)
     C+ INTO :WOldCtr
     C+ FROM SECTYDQD
     C/END-EXEC

      ** Select records in SECTYD that are not in SECTYDQD

     C/EXEC SQL
     C+ DECLARE C1 CURSOR FOR
     C+ SELECT
     C+   A.RECI
     C+ , A.SESN
     C+ FROM SECTYD A
     C+ WHERE A.SESN NOT IN
     C+ (
     C+ SELECT X.SESESN
     C+ FROM SECTYDQD X
     C+ )
     C/END-EXEC

     C/EXEC SQL
     C+ OPEN C1
     C/END-EXEC

     C/EXEC SQL
     C+ FETCH NEXT FROM C1 INTO :dsC1
     C/END-EXEC

      ** If record is found

     C                   DOW       SQLCODE <> 100
     C                   EVAL      WAddCtr = WAddCtr + 1
     C                   EXSR      SRFormat

      ** If update mode, add records to SECTYDQD

     C                   IF        *IN60 = *ON

     C/EXEC SQL
     C+ INSERT INTO SECTYDQD
     C+ (
     C+   SESESN
     C+ , SEFRID
     C+ )
     C+ VALUES
     C+ (
     C+   :Security
     C+ , ' '
     C+ )
     C/END-EXEC

     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C/EXEC SQL
     C+ FETCH NEXT FROM C1 INTO :dsC1
     C/END-EXEC

     C                   ENDDO

     C                   EXSR      SrWP1End
     C                   EXSR      SrAudit

     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFormat - Subroutine to format and move the details to      *
      *             printer fields                                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrFormat      BEGSR

     C                   IF        NOT %OPEN(UTSE0859P1)
     C                   OPEN      UTSE0859P1

     C                   SELECT
     C                   WHEN      Mode = 'A' or Mode = 'a'
     C                   EVAL      RMODE = 'Audit Mode'
     C                   WHEN      Mode = 'U' or Mode = 'u'
     C                   EVAL      RMODE = 'Update Mode'
     C                   ENDSL

     C                   WRITE     HEADP1
     C                   ENDIF

     C                   EVAL      RSESN = Security

     C                   SELECT
     C                   WHEN      Status = 'D'
     C                   EVAL      RSTAT = 'Live'
     C                   WHEN      Status = 'M'
     C                   EVAL      RSTAT = 'Matured'
     C                   WHEN      Status = '*'
     C                   EVAL      RSTAT = 'Deleted'
     C                   ENDSL

     C                   IF        OFLLN1 <= PRTLN1 + 4
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     DETAIL1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWP1End - Subroutine to write End of Report                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrWP1End      BEGSR

     C                   IF        %OPEN(UTSE0859P1)

     C                   IF        OFLLN1 <= PRTLN1 + 3
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   CLOSE     UTSE0859P1

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Subroutine to write to audit report UTSE0859AU      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

     C                   WRITE     HEADAU

     C                   IF        (WAddCtr = 0) AND (*INU7 = *OFF)
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RINSRT = WAddCtr
     C                   EVAL      RTOTAL = WOldCtr
     C                   WRITE     CONTROL
     C                   ENDIF

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF

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

     C     *ENTRY        PLIST
     C                   PARM                    Mode

      ** Define LDA

     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA

      ** Initialize program name

     C                   EVAL      DBPGM = 'UTSE0859'

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       RetCode
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        RetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = Option
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *IN60 = *OFF
     C                   IF        Mode = 'U' OR Mode = 'u'
     C                   EVAL      *IN60 = *ON
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(C) Copyright Finastra International Limited 2021
