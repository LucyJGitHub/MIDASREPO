     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AP Repair Queue Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  AP000015 - Midas AP Repair Queue Housekeeping                *
      *                                                               *
      *  Function:  This new program will delete all the records from *
      *             the Zonal Repair Queue File (T_MSRPRQZ) when      *
      *             Repair Queue Status (MSWSTAT) is 'COMPLETED' or   *
      *             'DELETED'.                                        *
      *                                                               *
      *  Called By: GOC000109 - Midas GO Repair Queue Housekeeping    *
      *                         Control                               *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD057729           Date 05Apr21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204  *CREATE    Date 15Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057729 - Housekeeping of repair queue files T_MSRPRQ and   *
      *             T_MSRPRQZ.                                        *
      *             Housekeep records with REPAIR status in zone      *
      *             repair file T_MSRPRQZ.                            *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR       - Error processing                               *
      *  *INZSR      - Initialise                                     *
      *  SrPrint     - Print Details                                  *
      *  SRAudit     - Generate Audit Report                          *
      *  SrOpenP1    - Open and Enroll report file                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

     FAPMRPQZL3 UF   E           K DISK    INFSR(*PSSR)
      ** Midas Repair Queue

     FAP000015P1O    E             PRINTER INFSR(*PSSR) INFDS(SPOOL1) USROPN
      ** AP Repair Queue Housekeeping Report

     FAP000015AUO    E             PRINTER INFSR(*PSSR) INFDS(SPOOLU) USROPN
      ** AP Repair Queue Housekeeping Audit

      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** Data Structure for Bank Details Access Program
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Structure for Bank Details Access Program
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for Bank Details
     D SPOOL1          DS
      ** P1 printer file information data structure

     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  SFPLE                152    153B 0
     D  SFOVR                188    189B 0
     D  SFCUR                367    368B 0

     D SPOOLU          DS
      ** AU printer file information data structure

     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  SFPLEU               152    153B 0
     D  SFOVRU               188    189B 0
     D  SFCURU               367    368B 0
      *                                                                                     MD057729
     D SYSVAL1         C                   'RepairPurgeZone'                                MD057729
     D SYSVAL2         C                   'RepairPurgeDayZone'                             MD057729
      *                                                                                     MD057729
      ** Parameter variables for AOSVALR0 string                                            MD057729
      *                                                                                     MD057729
     D SVALK1          S             20                                                     MD057729
     D SVAL1           S            200                                                     MD057729
     D SVAlK2          S             20                                                     MD057729
     D SVAL2           S            200                                                     MD057729
     D SVALK3          S             20                                                     MD057729
     D SVAL3           S            200                                                     MD057729
     D SVALK4          S             20                                                     MD057729
     D SVAL4           S            200                                                     MD057729
     D SVALK5          S             20                                                     MD057729
     D SVAL5           S            200                                                     MD057729
     D SVALK6          S             20                                                     MD057729
     D SVAL6           S            200                                                     MD057729
     D SVALK7          S             20                                                     MD057729
     D SVAL7           S            200                                                     MD057729
     D SVALK8          S             20                                                     MD057729
     D SVAL8           S            200                                                     MD057729
     D SVALK9          S             20                                                     MD057729
     D SVAL9           S            200                                                     MD057729
     D SVALK0          S             20                                                     MD057729
     D SVAL10          S            200                                                     MD057729
      *                                                                                     MD057729
     D HOUSEKEEP       S              1A                                                    MD057729
     D RETENTION       S              3S 0                                                  MD057729
      *                                                                                     MD057729
     D T_TMST          S             26A                                                    MD057729
     D W@DATEIN        S              8A                                                    MD057729
     D W@DAYNO         S              5P 0                                                  MD057729
     D W@DFMNT         S              1A                                                    MD057729
     D W@EFLAG         S              1A                                                    MD057729
      *                                                                                     MD057729
     D T_DATE          DS            10                                                     MD057729
     D W@YYYY                  1      4                                                     MD057729
     D W@MM                    6      7                                                     MD057729
     D W@DD                    9     10                                                     MD057729
      *                                                                                     MD057729

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1A
     D PZone           S             10A
     D PRtCd           S              7A
     D POptn           S              7A
     D PErms           S             50A
     D PCache          S              1A
     D PRecImage       S          32000A

     D MaxRptLine      S              3  0
     D CurRptLine      S              3  0
     D FirstPage       S              1A
     D RecordCount     S              5  0

     D ReptSeq         S              5A
     D Entity          S              3A
     D ZSNUMU          S              6  0
     D ZSERRU          S              1
     D ZSNUM           S              6  0
     D ZSERR           S              1

      *********************************************************************
      /EJECT
      *********************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *********************************************************************

     C     *LOVAL        SETLL     APMRPQZL3
     C                   READ      APMRPQZL3
     C                   DOW       NOT %EOF( APMRPQZL3 )

     C                   IF        MSWSTAT = 'COMPLETED' OR
     C                             MSWSTAT = 'DELETED'
     C                   EVAL      RecordCount = RecordCount + 1
     C                   EXSR      SRPrint
     C                   DELETE    T_MSRPRQZ
     C**********         ENDIF                                                              MD057729
     C                   ELSE                                                               MD057729
      *                                                                                     MD057729
      ** Housekeeping of 'REPAIR' status records                                            MD057729
      *                                                                                     MD057729
     C                   IF        MSWSTAT = 'REPAIR' AND                                   MD057729
     C                             HOUSEKEEP = 'Y'                                          MD057729
     C                   EVAL      T_TMST = %CHAR(MSWINPTS)                                 MD057729
     C                   EXSR      SRCONVERT                                                MD057729
      *                                                                                     MD057729
     C                   IF        (BJRDNB - W@DAYNO) > RETENTION                           MD057729
     C                   EVAL      RecordCount = RecordCount + 1                            MD057729
     C                   EXSR      SRPrint                                                  MD057729
     C                   DELETE    T_MSRPRQZ                                                MD057729
     C                   ENDIF                                                              MD057729
      *                                                                                     MD057729
     C                   ENDIF                                                              MD057729
     C                   ENDIF                                                              MD057729

     C                   READ      APMRPQZL3
     C                   ENDDO

      ** Output report trailer

     C                   IF        RecordCount <> 0

      **   Check for overflow line, output heading if required

     C                   Z-ADD     SFOVR         MaxRptLine
     C                   Z-ADD     SFCUR         CurRptLine
     C                   IF        ((MaxRptLine-CurRptLine) < 4) OR
     C                             FirstPage = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      FirstPage = 'N'
     C                   ENDIF

     C                   WRITE     TRAILP1

     C                   ENDIF

      ** Generate Audit Report

     C                   EXSR      SRAudit

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Print Details                                       *
      *                                                               *
      *****************************************************************

     C     SrPrint       BEGSR

      ** Open & enroll report file

     C                   EXSR      SrOpenP1

      ** Set up report fields

     C                   MOVE(P)   MSWID         RSWID
     C                   EVAL      RSWACT     = MSWACT
     C                   EVAL      RSWAPI     = MSWAPI
     C                   EVAL      RSWSTAT    = MSWSTAT
     C                   EVAL      RSWAUTHLVL = MSWAUTHLVL
     C                   EVAL      RSWINPUSER = MSWINPUSER

      ** Check for overflow line, output heading if required

     C                   Z-ADD     SFOVR         MaxRptLine
     C                   Z-ADD     SFCUR         CurRptLine
     C                   IF        ((MaxRptLine-CurRptLine) < 3) OR
     C                             FirstPage = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      FirstPage = 'N'
     C                   ENDIF

      ** Output detail line

     C                   WRITE     DETAIL

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

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'AP000015'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'AOBANKRO'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA

      ** Write to Audit file

     C                   EXSR      SRAudit

     C                   EXSR      *PSSR

     C                   ENDIF
      *                                                                                     MD057729
      ** Retrieve the System Values                                                         MD057729
      *                                                                                     MD057729
     C                   CALL      'AOSVALR0'                                               MD057729
     C                   PARM      *BLANKS       PRTCD                                      MD057729
     C                   PARM      SYSVAL1       SVAlK1                                     MD057729
     C                   PARM      *BLANKS       SVAL1                                      MD057729
     C                   PARM      SYSVAL2       SVALK2                                     MD057729
     C                   PARM      *BLANKS       SVAL2                                      MD057729
     C                   PARM                    SVALK3                                     MD057729
     C                   PARM                    SVAL3                                      MD057729
     C                   PARM                    SVALK4                                     MD057729
     C                   PARM                    SVAL4                                      MD057729
     C                   PARM                    SVALK5                                     MD057729
     C                   PARM                    SVAL5                                      MD057729
     C                   PARM                    SVALK6                                     MD057729
     C                   PARM                    SVAL6                                      MD057729
     C                   PARM                    SVALK7                                     MD057729
     C                   PARM                    SVAL7                                      MD057729
     C                   PARM                    SVALK8                                     MD057729
     C                   PARM                    SVAL8                                      MD057729
     C                   PARM                    SVALK9                                     MD057729
     C                   PARM                    SVAL9                                      MD057729
     C                   PARM                    SVALK0                                     MD057729
     C                   PARM                    SVAL10                                     MD057729
      *                                                                                     MD057729
     C                   EVAL      HOUSEKEEP = *BLANKS                                      MD057729
     C                   EVAL      RETENTION = *ZEROS                                       MD057729
      *                                                                                     MD057729
     C                   IF        PRTCD <> *BLANKS AND                                     MD057729
     C                             PRTCD <> '*NRF   '                                       MD057729
     C                   EVAL      DBFILE = 'SDSVLCTD'                                      MD057729
     C                   EVAL      DBKEY = SVALK1                                           MD057729
     C                   EVAL      DBPGM = 'AP000015'                                       MD057729
     C                   EVAL      DBASE  =  4                                              MD057729
     C                   OUT       LDA                                                      MD057729
     C                   EXSR      *PSSR                                                    MD057729
     C                   ENDIF                                                              MD057729
      *                                                                                     MD057729
     C                   MOVEL     SVAL1         HOUSEKEEP                                  MD057729
     C                   MOVEL     SVAL2         RETENTION                                  MD057729
      *                                                                                     MD057729

      ** Initialise report workfields and counter

     C                   EVAL      RecordCount = 0
     C                   Eval      FirstPage   = 'Y'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Generate Audit Report                               *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

      ** Open & enroll report file

     C                   IF        NOT %OPEN(AP000015AU)
     C                   OPEN      AP000015AU
     C                   Z-ADD     SFNUMU        ZSNUMU
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ReptSeq
     C                   PARM      *BLANKS       Entity
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM                    ZSERRU

     C                   IF        ZSERRU = 'Y'
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  'AP000015AU'
     C                   EVAL      DBPGM  =  'AP000015'
     C                   EVAL      DBASE  =  2
     C                   OUT       LDA
     C                   SETON                                        U7U8
     C                   DUMP
     C                   ENDIF

     C                   ENDIF

      ** Output audit heading

     C                   WRITE     HEADAU

      ** Output audit detail

     C                   IF        *INU7 = *OFF AND
     C                             *INU8 = *OFF
     C                   IF        RecordCount <> 0
     C                   Z-ADD     RecordCount   RCOUNT
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ELSE
     C                   WRITE     DBERROR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOpenP1 - Open and Enroll report file                        *
      *                                                               *
      *****************************************************************

     C     SrOpenP1      BEGSR

      ** Open & enroll report file

     C                   IF        NOT %OPEN(AP000015P1)
     C                   OPEN      AP000015P1
     C                   Z-ADD     SFNUM         ZSNUM
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ReptSeq
     C                   PARM      *BLANKS       Entity
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR

     C                   IF        ZSERR = 'Y'
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  'AP000015P1'
     C                   EVAL      DBPGM  =  'AP000015'
     C                   EVAL      DBASE  =  3
     C                   OUT       LDA
     C                   SETON                                        U7U8
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *                                                                                     MD057729
      *****************************************************************                     MD057729
      /EJECT                                                                                MD057729
      *****************************************************************                     MD057729
      *                                                               *                     MD057729
      * SRCONVERT - Convert Date/Timestamp to Day Number              *                     MD057729
      *                                                               *                     MD057729
      *****************************************************************                     MD057729
      *                                                                                     MD057729
     C     SRCONVERT     BEGSR                                                              MD057729
      *                                                                                     MD057729
     C                   EVAL      T_DATE = T_TMST                                          MD057729
     C                   EVAL      W@DATEIN = W@DD + W@MM + W@YYYY                          MD057729
      *                                                                                     MD057729
     C                   CALL      'ZDATE11'                                                MD057729
     C                   PARM                    W@DATEIN                                   MD057729
     C                   PARM      *ZERO         W@DAYNO                                    MD057729
     C                   PARM      'D'           W@DFMNT                                    MD057729
     C                   PARM      *BLANKS       W@EFLAG                                    MD057729
      *                                                                                     MD057729
     C                   IF        W@EFLAG = 'Y'                                            MD057729
     C     *LOCK         IN        LDA                                                      MD057729
     C                   EVAL      DBFILE = 'ZDATE11'                                       MD057729
     C                   EVAL      DBASE = 5                                                MD057729
     C                   EVAL      DBKEY = W@DATEIN                                         MD057729
     C                   OUT       LDA                                                      MD057729
     C                   EXSR      *PSSR                                                    MD057729
     C                   ENDIF                                                              MD057729
      *                                                                                     MD057729
     C                   ENDSR                                                              MD057729
      *                                                                                     MD057729

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

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

