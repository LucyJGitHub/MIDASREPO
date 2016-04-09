     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
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
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP204  *CREATE    Date 15Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     C                   ENDIF
 
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
 
