     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Accounts excluded from KWG @24C Reporting')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000100 - Accounts excluded from KWG @24C Report            *
      *                                                               *
      *  Function:  This program reports those accounts that are      *
      *             flagged as non-@24c reporting although they have  *
      *             an outstanding balance.                           *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24862           Date 10Jun09               *
      *                 BUG24335           Date 25Jun09               *
      *                 BUG24217           Date 06Jun09               *
      *                 BUG23958           Date 11May09               *
      *                 BUG23959           Date 09May09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24862 - Closed Accounts should not be processed           *
      *  BUG24335 - Accounts excluded from KWG Report does not        *
      *             capture retail accounts with zero balances        *
      *  BUG24217 - Not all excluded retail accounts are              *
      *             captured in the Report                            *
      *  BUG23958 - New field should use correct char § (Recompile)  *
      *  BUG23959 - Report not showing when accounts were opened      *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20  Change of Customer                                     *
      *    71  (WNewPageHdr) Print File Overflow                      *
      *    U7+U8 - Database error Indiacators                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRFill - Fill the fields                                     *
      *  SRWrite - Write record in Printer file                       *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR - Program exception error routine                      *
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
      *
      ** Midas Accounts join logical
      *
     FACCNTBJ0  IF   E           K DISK
      *
      ** Midas Accounts excluded from @24C
      *
     FGL000100P1O    E             PRINTER OFLIND(*IN71)
     F                                     INFDS(SPOOL1)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      *
      ** File Information Data Structure for SD000110P1
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Short DS for access programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Long DS for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Customer details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for Customer details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Definition of indicators
      *
     D IndicatorPtr    S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(IndicatorPtr)
      *
      ** Ind 71 = New page
      *
     D  WNewPageHdr           71     71
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Print End of Report
      *
     D WEndOfRep       S               N

     D WRun            S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PStKey          S              7A
     D PCcy            S              3A
     D*WCust           S              6  0                                                    CER059
     D WCust           S              6A                                                      CER059
     D WPDec           S              1  0
      *
      ** *ENTRY Parameters
      *
     D PRSeq           S              5A
     D PRLev           S              1A
     D PREnt           S              3A
      *
      ** Parameters for ZSFILE
      *
     D PEnty           S              3A
     D PFile           S             10A
     D PSNum           S              6  0
     D PSErr           S              1A
      *
      ** Parameters for ZFRPED
      *
     D PFld15          S             15  0
     D PECode          S              1A
     D PDecs           S              1  0
     D POut22          S             22A
     D POut25          S             25A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
      *
      ** Read Accounts file
      *
     C                   READ      ACCNTBD0
      *
      ** Read until  EOF
      *
     C                   DOW       NOT %EOF
      *
     C**********         IF        K24C <> 'Y' AND LDBL <> 0                                BUG24335
     C**********         IF        K24C <> 'Y'                                     BUG24335 BUG24862
     C                   IF        K24C <> 'Y' AND ACST = ' '                               BUG24862
      *
      ** Check if new customer
      *
     C                   EVAL      *IN20 = *OFF
     C                   IF        WCust <> CNUM
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
      *
      ** Get decimal places from ccy table
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CCY           PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WPDec = A6NBDP
     C                   ENDIF
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = CCY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      SRFill
     C                   EXSR      SRWrite
      *                                                                                     BUG24217
      ** only keep last CNUM when record is processed                                       BUG24217
      *                                                                                     BUG24217
     C                   EVAL      WCust = CNUM                                             BUG24217
      *                                                                                     BUG24217
     C                   ENDIF
      *
     C**********         EVAL      WCust = CNUM                                             BUG24217
      *
     C                   READ      ACCNTBD0
     C                   ENDDO
      *
      ** Print End of Report
      *
     C                   EVAL      WEndOfRep = *ON
     C                   EXSR      SRWrite
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFill - Fill the fields                                     *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************

     C     SRFill        BEGSR
      *
     C                   MOVE      CNUM          RCUST
      *
      ** Get Customer  name
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      RCUST         PCust
     C                   PARM      *BLANKS       PStKey
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      RNAME = BBCRNM
     C                   ELSE
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = RCUST
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RCCY = CCY
     C                   MOVE      ACOD          RACOD
     C                   MOVE      ACSQ          RACSQ
     C                   EVAL      RBRCA = BRCA
     C                   MOVE      ACNO          RACNO
      *
      ** Call ZFRPED with following parameters
      *
     C                   CALLB     'ZFRPED'
     C                   PARM      LDBL          PFld15
     C                   PARM      WPDec         PDecs
     C                   PARM      'A'           PECode
     C                   PARM                    POut22
     C                   PARM                    POut25
      *
     C                   EVAL      RBAL = POut22
      *                                                                                     BUG23959
      ** Get the Date Account Opened                                                        BUG23959
      *                                                                                     BUG23959
     C                   CallB     'ZDATE2'                                                 BUG23959
     C                   PARM      DACO          ZDAYNO            5 0                      BUG23959
     C                   PARM                    BJDFIN                                     BUG23959
     C                   PARM      0             ZDATE             6 0                      BUG23959
     C                   PARM      *BLANKS       ZADATE            7                        BUG23959
      *                                                                                     BUG23959
     C                   MOVE      ZADATE        RDACO                                      BUG23959
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Write record in Printer file                       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
      ** Write Header
      *
     C                   IF        WNewPageHdr = *ON AND
     C                             WEndOfRep = *OFF
     C                   WRITE     GL000100R0
      *
      ** Reset indicator for writing a Header
      *
     C                   EVAL      WNewPageHdr = *OFF
     C                   ENDIF
      *
      ** Print Detail or End of Report
      *
     C                   IF        WEndOfRep = *ON
     C                   WRITE     GL000100R2
      *
      ** Reset indicator for writing a End of Report
      *
     C                   EVAL      WEndOfRep = *OFF
     C                   ELSE
     C                   WRITE     GL000100R1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Entry Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRSeq
     C                   PARM                    PRLev
     C                   PARM                    PREnt
     C
      *
      ** Get info from the SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If error, then do
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Setup indicators for printing header of the report
      *
     C                   EVAL      WNewPageHdr = *ON
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM      SFILE1        PFile
     C                   PARM      SFNUM1        PSNum
     C                   PARM      *BLANKS       PSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PSErr = 'Y'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: Main Processing, SRFill, *INZSR                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
