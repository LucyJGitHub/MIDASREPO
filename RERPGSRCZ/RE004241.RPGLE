     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Cheques Presented Today Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Retail module                                        *
      *                                                               *
      *  RE004241 - Cheques Presented Today Extract                   *
      *                                                               *
      *  Function:  This module will produce an extract file          *
      *             in close of business showing details of all       *
      *             cheques presented today where                     *
      *             1.) the cheque numbers have presented more than   *
      *                 once.                                         *
      *             2.) the cheque numbers are outside of the range   *
      *                 corresponding to the cheque books issued      *
      *                 against each account.                         *
      *             3.) the cheque numbers result in an account       *
      *                 balance exceeding its overdraft limit.        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG2304            Date 30Apr04               *
      *                 CRE019  *CREATE    Date 12Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG2304 - Various file layout changes. Recompile.            *
      *  CRE019 - Cheque Processing and Maintenance                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         match LOOKUP for WArrMSG1/WProcFlag             *
      *    02         match LOOKUP for WArrMSG2                       *
      *    LR         End Pgm                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrTTran  - Read through all records in Transaction File      *
      *  SrGlJEnP - Read through all records in Journal Entry File    *
      *  SrCusEx  - Read through all records in Customer Exchange File*
      *  SrDetl   - Format details from TTRANPD to CHQPRPD            *
      *  SrFnCd   - Get Transaction details                           *
      *  *PSSR    - Error processing                                  *
      *  *INZSR   - Initialise                                        *
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
 
     FCHQPRPD   O    E           K DISK    INFSR(*PSSR)
      ** Midas RE Cheques Presented w/ Warning Messages
 
     FCHQBKL2   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CQ)
     F                                     IGNORE(CHQBKPHF)
     F                                     IGNORE(CHQBKPTF)
      ** Midas RE Cheque book file
 
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AN)
      ** Account Numbers Cross Reference File
 
     FTTRANL4   IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Teller Transaction Detail
 
     FGLJENPL8  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Journal Entry File
 
     FCUSEXEL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Customer Exchanges File
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Work field arrays
     D WArrMSG1        S              8A   DIM(9)
     D WArrMSG2        S              8A   DIM(9)
     D WProcFlag       S              1A   DIM(3)
 
      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Function Codes Data Structure
     D SDFNCD        E DS                  EXTNAME(SDFNCDPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for Access Object
     D PRtcd           S              7
     D POptn           S              7
     D PFnCd           S              5
 
     D WrkBINB         S              3
     D WRun            S              1
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Read through all records in Transaction File
 
     C                   EXSR      SrTTran
 
      ** Read through all records in Journal Entry File
 
     C                   EXSR      SrGlJEnP
 
      ** Read through all records in Customer Exchange File
 
     C                   EXSR      SrCusEx
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      *  SrTTran - Read through all records in Transaction File       *
      *                                                               *
      *****************************************************************
 
     C     SrTTran       BEGSR
 
     C                   READ      TTRANL4
 
     C                   DOW       NOT %EOF(TTRANL4)
 
      ** Process all live transactions and reversal transactions only
 
     C                   IF        FNCD = '0JD' OR
     C                             CRTN = 0
 
     C                   EVAL      PRDUPW = ' '
     C                   EVAL      PROUTW = ' '
     C                   EVAL      PROVRW = ' '
 
     C                   CLEAR                   WProcFlag
     C                   CLEAR                   WArrMSG1
     C                   CLEAR                   WArrMSG2
     C                   MOVEA     MSG1          WArrMSG1
     C                   MOVEA     MSG2          WArrMSG2
 
     C     'CHQPRES '    LOOKUP    WArrMSG1                               01
     C     'CHQPRES '    LOOKUP    WArrMSG2                               02
     C                   IF        *IN01 = *ON OR
     C                             *IN02 = *ON
     C                   EVAL      PRDUPW = 'Y'
     C                   EVAL      WProcFlag(1) = 'Y'
     C                   ENDIF
 
     C     'CHQRNG  '    LOOKUP    WArrMSG1                               01
     C     'CHQRNG  '    LOOKUP    WArrMSG2                               02
     C                   IF        *IN01 = *ON OR
     C                             *IN02 = *ON
 
     C     ACNO          CHAIN     ACNUM
     C                   IF        NOT %FOUND(ACNUM)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ACNUM'
     C                   MOVE      CQACNO        DBKEY
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      KlBrCa = ANBRCA
     C                   EVAL      KlAcNo = ACNO
     C                   EVAL      KlGCqI = 0
     C                   MOVE      CQNF          KlSCqN
 
     C     KlChqBk       CHAIN     CHQBKPDF
     C                   IF        %FOUND(CHQBKL2)  AND
     C                             CQSCQN  = CQECQN AND
     C                             CQOUTR  = 'Y'    AND
     C                             CQRECID = 'D'
     C                   EVAL      PROUTW = 'Y'
     C                   EVAL      WProcFlag(2) = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C     'N.S.F.  '    LOOKUP    WArrMSG1                               01
     C     'N.S.F.  '    LOOKUP    WArrMSG2                               02
     C                   IF        *IN01 = *ON OR
     C                             *IN02 = *ON
     C                   EVAL      PROVRW = 'Y'
     C                   EVAL      WProcFlag(3) = 'Y'
     C                   ENDIF
 
     C     'EX.O/D  '    LOOKUP    WArrMSG1                               01
     C     'EX.O/D  '    LOOKUP    WArrMSG2                               02
     C                   IF        *IN01 = *ON OR
     C                             *IN02 = *ON
     C                   EVAL      PROVRW = 'Y'
     C                   EVAL      WProcFlag(3) = 'Y'
     C                   ENDIF
 
     C     'Y'           LOOKUP    WProcFlag                              01
     C                   IF        %EQUAL
     C                   EXSR      SrDetl
     C                   WRITE     CHQPRD0
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      TTRANL4
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrGlJEnP - Read through all records in Journal Entry File    *
      *                                                               *
      *****************************************************************
 
     C     SrGlJEnP      BEGSR
 
     C     *LOVAL        SETLL     GLJENPL8
     C                   READ      GLJENPL8
 
     C                   DOW       NOT %EOF(GLJENPL8)
 
      ** Format details from GLJENPPD to CHQPRPD
 
     C                   EVAL      PRBRCA = BTIBCA
     C                   MOVEL     BTRACN        PRACNO
     C                   EVAL      PRCHQN = BTCQNB
     C                   MOVEL     BTBINB        WrkBINB
     C                   EVAL      PRTRNO = BTBTNB  + '/' + WrkBINB
     C                   EVAL      PRDESC = 'Journal Entry'
     C                   EVAL      PRCCY  = BTCYCD
     C                   EVAL      PRCHQA = BTPTAM
     C                   EVAL      PRDUPW = BTDUPC
     C                   EVAL      PROUTW = BTOUTR
 
     C                   WRITE     CHQPRD0
     C                   READ      GLJENPL8
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrCusEx - Read through all records in Customer Exchange File *
      *                                                               *
      *****************************************************************
 
     C     SrCusEx       BEGSR
 
     C     *LOVAL        SETLL     CUSEXEL3
     C                   READ      CUSEXEL3
 
     C                   DOW       NOT %EOF(CUSEXEL3)
 
      ** Format details from CUSEXCE to CHQPRPD
 
     C                   EVAL      PRBRCA = DRBR
     C                   MOVEL     DRAN          PRACNO
     C                   MOVEL     CHQN          PRCHQN
     C                   EVAL      PRTRNO = IPDN
     C                   EVAL      PRDESC = 'Customer Exchange'
     C                   EVAL      PRCCY  = DRCY
     C                   EVAL      PRCHQA = DRAM
     C                   EVAL      PRDUPW = DUPC
     C                   EVAL      PROUTW = OUTR
 
     C                   WRITE     CHQPRD0
     C                   READ      CUSEXEL3
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  SrDetl - Format details from TTRANPD to CHQPRPD              *
      *                                                               *
      *****************************************************************
 
     C     SrDetl        BEGSR
 
      ** Branch
 
     C                   EVAL      PRBRCA = ITLB
 
      ** Retail Account Number
 
     C                   MOVEL     ACNO          PRACNO
 
      ** Cheque Number
 
     C                   EVAL      PRCHQN = CQNF
 
      ** Transaction Number = teller id/teller trans.no.
 
     C                   EVAL      PRTRNO = TBID + '/'
     C                   MOVE      TBTN          PRTRNO
 
      ** Get function code description
 
     C                   EVAL      PFnCd  = FNCD
     C                   EXSR      SrFncd
     C                   EVAL      PRDESC = FQRNNR
 
      ** Currency
 
     C                   EVAL      PRCCY  = CCY1
 
      ** Amount
 
     C                   IF        FNCD = '00P' OR
     C                             FNCD = '0JP'
     C                   EVAL      PRCHQA = AMT2
     C                   ELSE
     C                   EVAL      PRCHQA = AMT1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFnCd - Get Transaction details                             *
      *                                                               *
      *****************************************************************
 
     C     SrFnCd        BEGSR
 
     C                   CALL      'AOFNCDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PFnCd
     C     SDFNCD        PARM      SDFNCD        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFNCDPD'
     C                   EVAL      DBKEY = PFnCd
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'RE004241'
 
      ** Define fields
 
     C     *LIKE         DEFINE    CQBRCA        KlBrcA
     C     *LIKE         DEFINE    CQACNO        KlAcNo
     C     *LIKE         DEFINE    CQGCQI        KlGCqI
     C     *LIKE         DEFINE    CQSCQN        KlSCqN
 
      ** Key-list for cheque book details
 
     C     KlChqBk       KLIST
     C                   KFLD                    KlBRCA
     C                   KFLD                    KlACNO
     C                   KFLD                    KlGCQI
     C                   KFLD                    KlSCQN
 
     C                   ENDSR
 
      *********************************************************************
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
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
