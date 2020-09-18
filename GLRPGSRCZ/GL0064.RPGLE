     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Statement of account extract')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0064 - Statement of Account Extract                        *
      *                                                               *
      *  Function:  This program will calculate Opening Balance as    *
      *             at Start Date and will output the necessary       *
      *             account details to STMTAH for reporting.          *
      *                                                               *
      *  Called By: GLC0064 - Statement of Account Ctl Pgm            *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG6708            Date 12May05               *
      *                 BUG5808            Date 15Feb05               *
      *                 BUG4844            Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL025  *CREATE    Date 14Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6708 - I/O Operation error on STMTHH.                     *
      *  BUG5808- Statement type should be 'Management' not 'Demand'  *
      *  BUG4844- Errors in on-line statements                        *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL025 - Statement of Account for a Specific Period.         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
     FAPOSTL4   IF   E           K DISK
     FSTMTHH    O    E             DISK    USROPN
     FSTMTAH    O    E             DISK    USROPN
     FSTMTZX    O    E             DISK    USROPN
     FCGSTMTPD  O    E             DISK    USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D DSAccKey        DS            24
     D     pBRCA               1      3
     D     pCNUM               4      9
     D     pCCY               10     12
      *
      ** Change Account Code definition to 10 digits
      *
     D     pACOD              13     22
     D     pACSQ              23     24
     D     AccKey              4     24
      ** DS for Account Key
 
     D##UDCR         E DS                  EXTNAME(CGUDCRPD)
      ** External DS for incomplete reference
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC_)
      ** Retail Account Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Module File Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for Access Object Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for Access Object Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @RUN            S              1
     D StartDate       S              5  0
     D EndDate         S              5  0
     D TotalPost       S             15  0
     D CarriedFwd      S             15  0
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      ** Retrieve account details (Today's Cleared Balance)
     C                   EXSR      SRAcctDtls
 
      ** Calculate Forward Balance
     C                   EXSR      SRCarrdFwd
 
     C                   If        ##COPD <> 'Y'
      ** Output record to STMTHH, STMTAH, and STMTZX
     C                   EXSR      SRWriteSTMT
 
     C                   Else
      ** Output record to CGSTMTPD
     C                   EXSR      SRWriteCGST
     C                   Endif
      *
      ** Terminate and return to calling pgm
      ** Close all files                                                                     BUG6708
      *                                                                                      BUG6708
     C                   Close     STMTHH                                                    BUG6708
     C                   Close     STMTAH                                                    BUG6708
     C                   Close     STMTZX                                                    BUG6708
     C     ##COPD        IFEQ      'Y'                                                       BUG6708
     C                   CLOSE     CGSTMTPD                                                  BUG6708
     C                   Endif                                                               BUG6708
      *                                                                                      BUG6708
     C                   Eval      *INLR = *On
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRAcctDtls    BegSr
 
      ** Get the account details
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @Rtcd             7
     C                   Parm      '*KEY    '    @Optn             7
     C                   Parm      *Blank        W@Retl           10
     C                   Parm      pCNUM         WCusN             6
     C                   Parm      pCCY          W@Cur             3
     C                   Parm      pACOD         W@Acctcde        10
     C                   Parm      pACSQ         W@AcctSeq         2
     C                   Parm      pBRCA         W@Brch            3
     C     ACCNT         Parm      ACCNT         DSSDY
     C     @Rtcd         IfNE      *Blank
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBFILE =  'ACCNTAB'
     C                   Eval      DBKEY  =  pCNUM+pCCY+pACOD+pACSQ+pBRCA
     C                   Eval      DBASE  =  3
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRCarrdFwd    BegSr
 
     C                   Eval      TotalPost = *Zero
 
      ** Accumulate Postings from after Start Date
     C                   Move      pBRCA         K@BRCA
     C                   Move      pCNUM         K@CNUM
     C                   Move      pCCY          K@CCY
     C                   Move      pACOD         K@ACOD
     C                   Move      pACSQ         K@ACSQ
     C                   Move      pStartDate    K@PSTD
     C                   Move      *Zero         K@DRCR
     C     KeyAPOST      SETLL     APOSTL4
     C                   Read      APOSTL4
     C                   DoW       NOT %EOF(APOSTL4) AND
     C                             BRCA = K@BRCA     AND
     C                             CNUM = K@CNUM     AND
     C                             CCY  = K@CCY      AND
     C                             ACOD = K@ACOD     AND
     C                             ACSQ = K@ACSQ
 
     C                   If        DRCR = 1
     C                   Eval      TotalPost = TotalPost - PSTA
     C                   Else
     C                   Eval      TotalPost = TotalPost + PSTA
     C                   Endif
 
     C                   Read      APOSTL4
     C                   EndDo
 
      ** Carried Forward = Cleared Balance - Total Postings
     C**********         Eval      CarriedFwd = AC_CLBL - TotalPost                          BUG4844
     C                   Eval      CarriedFwd = AC_LDBL - TotalPost                          BUG4844
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRWriteSTMT   BegSr
 
     C                   Move      'H'           RECI
     C                   Write     STMTHHF
 
     C                   Move      'D'           RECI
     C                   Move      AC_ATYP       ATYP
     C                   Move      pBRCA         BRCA
     C                   Move      pCNUM         CNUM
     C                   Move      pCCY          CCY
     C                   Move      pACOD         ACOD
     C                   Move      pACSQ         ACSQ
     C                   Move      'N'           MSFL
     C                   MoveL     pEndDate      ZZ011
     C     pStartDate    Sub       1             LSTD
     C                   Move      AC_NSTD       NSTD
     C                   Move      *Zero         LSTP
     C                   Move      CarriedFwd    CFSB
     C                   Move      AC_YTDB       YTDB
     C**********         BITON     '12'          GLBT                                        BUG5808
     C                   BITON     '0'           GLBT                                        BUG5808
     C                   BITOFF    '1'           GLBT                                        BUG5808
     C                   BITON     '2'           GLBT                                        BUG5808
     C                   Write     STMTAHF
 
     C                   Move      'T'           RECI
     C                   Z-Add     3             NORE1
     C                   Write     STMTZXF
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRWriteCGST   BegSr
 
     C                   MoveL     'STATEMENT'   SDPTYP
     C                   MoveL     'NORMAL'      SDPSTP
     C                   Move      pEndDate      SDUNXD
     C                   Move      'D'           SDRECI
 
     C                   Move      'D'           RECI
     C                   Move      AC_ATYP       ATYP
     C                   Move      pBRCA         BRCA
     C                   Move      pCNUM         CNUM
     C                   Move      pCCY          CCY
     C                   Move      pACOD         ACOD
     C                   Move      pACSQ         ACSQ
     C                   Move      'N'           MSFL
     C     pStartDate    Sub       1             LSTD
     C                   Move      AC_NSTD       NSTD
     C                   Move      *Zero         LSTP
     C                   Move      CarriedFwd    CFSB
     C                   Move      AC_YTDB       YTDB
     C                   BITON     '12'          GLBT
     C                   Write     @STMTPD
 
     C                   EndSr
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
 
     C     *entry        PLIST
     C                   PARM                    FullAcctKey      24
     C                   PARM                    pStartDate        5 0
     C                   PARM                    pEndDate          5 0
      ** Account Key
     C                   Eval      DSAcckey = FullAcctKey
      *
      ** Define DTAARA/LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Access Bank details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @Rtcd             7
     C                   Parm      '*FIRST  '    @Optn             7
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNE      *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBFILE =  'SDBANKPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBASE  =  1
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Access MIDAS Modules details via access program
     C                   Call      'AOMMODR0'
     C                   Parm      *BLANK        @Rtcd
     C                   Parm      '*FIRST '     @Optn
     C     SDMMOD        Parm      SDMMOD        DSFDY
 
     C     @RTCD         IfNE      *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBFILE =  'SDMMODPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBASE  =  2
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
      ** define KLIST for APOSTL4
     C     KeyAPOST      KLIST
     C                   KFLD                    K@BRCA            3
     C**********         KFLD                    K@CNUM            6 0                        CSD027
     C                   KFLD                    K@CNUM            6                          CSD027
     C                   KFLD                    K@CCY             3
     C                   KFLD                    K@ACOD           10 0
     C                   KFLD                    K@ACSQ            2 0
     C                   KFLD                    K@PSTD            5 0
     C                   KFLD                    K@DRCR            1 0
 
     C                   Move      'N'           ##COPD            1
     C                   If        BGN1ST = 'Y'
     C                   MoveL     pCNUM         ##CUST
     C                   Movel     pBRCA         DRBRCA
     C                   Movel     'GL'          DRMODI
     C                   MoveL     Acckey        DRMACT
     C                   Move      pBRCA         DRMACT
     C                   MoveL     'STATEMENT'   DRPTYP
     C                   MoveL     'NORMAL'      DRPSTP
     C                   MoveL     'N'           DRATRM
     C                   Call      'CG9010'
     C                   Parm                    ##RTCD            7
     C                   Parm      '*REF'        ##MODE           10
     C                   Parm      'NO '         ##CMT             3
     C                   Parm                    ##CUST            6
     C                   Parm                    ##UDCR
     C                   Parm                    ##ITMA            8
      *
      **  Blank return code implies generate correspondence.
      **  CGD1270 => no error, but suppress output for this transaction.
      *
     C                   If        ##RTCD = *BLANK
     C                   Move      'Y'           ##COPD
     C                   Open      CGSTMTPD
     C                   Else
     C                   If        ##RTCD <> 'CGD1270'
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBFILE =  'CG9010'
     C                   Eval      DBKEY  =  ##RTCD
     C                   Eval      DBASE  =  4
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif                                                               BUG6708
     C                   Endif                                                               BUG6708
      *                                                                                      BUG6708
     C                   Open      STMTHH
     C                   Open      STMTAH
     C                   Open      STMTZX
     C**********         Endif                                                               BUG6708
     C**********         Endif                                                               BUG6708
 
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
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
      *****************************************************************
