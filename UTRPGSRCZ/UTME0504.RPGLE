     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME MT101 & MT102 Totals Utility')                *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  UTME0504 - MT101 & MT102 Totals Utility                      *
      *                                                               *
      *  Function: The utility will delete records in MEIRFTPD        *
      *            that are not in MEINCRPD. If record is in          *
      *            MEINCRPD, deletion will be determined depending    *
      *            on the message received date and retention period. *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD057504 *CREATE   Date 22Jan21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057504 - Utility program to housekeep records in MEIRFTPD  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMEINCRL2  IF   E           K DISK
     FMEIRFTL3  UF   E           K DISK
     FUTME0504P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

     FUTME0504AUO    E             PRINTER INFSR(*PSSR)
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

      ** External DS for Funds Tranfer Details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      ** Short DS for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File information DS for UTME0504P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File information DS for UTME0504AU
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
     D WDelCtr         S             10  0 INZ(*ZEROS)
     D Mode            S              1A
     D WCalc           S              5  0
     D WDate           S              6  0
     D MsgRcvDt        S              5  0

     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZERR            S              7A
     D ZDATEFM         S              1A   INZ('M')

     D WrkYMD          DS             6
     D WrkYY                   1      2  0
     D WrkMD                   3      6  0

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     *LOVAL        SETLL     MEIRFTD0
     C                   READ      MEIRFTD0                               70
     C
     C                   DOW       *IN70 = *OFF

     C     SWIFTR        SETLL     @INCRL2
     C     SWIFTR        READE     @INCRL2                                75

     C                   IF        *IN75 = *OFF

      ** Convert Message Received Date (YYMMDD) to MMDDYY

     C                   MOVEL     CRMODE        WrkYMD
     C                   MOVEL     WrkMD         WDate
     C                   MOVE      WrkYY         WDate
     C                   MOVEL     WDate         ZDATE

      ** Format from MMDDYY to Midas Day Number

     C                   EXSR      FmtDate1
     C                   EVAL      MsgRcvDt = ZDAYNO

     C                   IF        MsgRcvDt < WCalc

     C                   EVAL      WDelCtr  = WDelCtr + 1
     C                   EXSR      SrFormat

      ** If Update mode

     C                   IF        *IN60 = *ON
     C                   DELETE    MEIRFTD0
     C                   ENDIF

     C                   ENDIF

      ** If record not found in MEINCRPD

     C                   ELSE
     C                   EVAL      WDelCtr = WDelCtr + 1
     C                   EXSR      SrFormat

      ** If Update mode

     C                   IF        *IN60 = *ON
     C                   DELETE    MEIRFTD0
     C                   ENDIF

     C                   ENDIF

     C                   READ      MEIRFTD0                               70
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
      *  Calls: SrRCFP1                                               *
      *                                                               *
      *****************************************************************
     C     SrFormat      BEGSR

     C                   IF        NOT %OPEN(UTME0504P1)
     C                   OPEN      UTME0504P1

     C                   SELECT
     C                   WHEN      Mode = 'A' or Mode = 'a'
     C                   EVAL      RMODE = 'Audit Mode'
     C                   WHEN      Mode = 'U' or Mode = 'u'
     C                   EVAL      RMODE = 'Update Mode'
     C                   ENDSL

     C                   WRITE     HEADP1
     C                   ENDIF

     C                   EVAL      RSWFR = SWIFTR
     C                   EVAL      RMTPY = MTPY

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

     C                   IF        %OPEN(UTME0504P1)

     C                   IF        OFLLN1 <= PRTLN1 + 3
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   CLOSE     UTME0504P1

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAudit - Subroutine to write to audit report UTME0504AU      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrRCFAU                                                *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

     C                   WRITE     HEADAU

     C                   IF        (WDelCtr = 0) AND (*INU7 = *OFF)
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RPURGE = WDelCtr
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

     C                   EVAL      DBPGM = 'UTME0504'

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

      ** Access Funds Transfer Details

     C                   CALL      'AOFTFRR0'
     C                   PARM      '*MSG   '     RetCode
     C                   PARM      '*FIRST '     Option
     C     SDFTFR        PARM      SDFTFR        DSFDY

      ** Database Error

     C                   IF        RetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 2
     C                   EVAL      DBFILE = 'SDFTFRPD'
     C                   EVAL      DBKEY  = Option
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WCalc = BJRDNB - BTMAHP

     C                   EVAL      *IN60 = *OFF
     C                   IF        Mode = 'U' OR Mode = 'u'
     C                   EVAL      *IN60 = *ON
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FmtDate1 - Call to ZDATE1                                    *
      *                                                               *
      *  Called By: SR/SrFormat                                       *
      *                                                               *
      *  Calls    : ZDATE2                                            *
      *                                                               *
      *****************************************************************
     C     FmtDate1      BEGSR
      *
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATEFM
     C                   PARM      *ZEROS        ZDAYNO
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

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
