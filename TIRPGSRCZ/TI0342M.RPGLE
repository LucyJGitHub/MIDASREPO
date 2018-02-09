     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas TI COB jrn ent gen of TI accruals postings')     *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI0342M - Midas TI COB jrn ent gen of TI accrual postings    *
      *                                                               *
      *  Function:  This program is responsible for doing any journal *
      *             entry generation of TI Accrual Postings           *
      *                                                               *
      *  Component of: TI0342                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP207             Date 10Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6289            Date 14Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2798            Date 27May04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 212558             Date 31Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210539             Date 06Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208261             Date 08Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003  *CREATE    Date 06Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSC024 - Open Month End (Recompile)                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6289- If an existing daily posting batch is still open    *
      *           do not add accruals to it but set up a new batch.   *
      *         - Only increment batch number to upper range number.  *
      *         - At upper range batch, add accruals to that batch.   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2798 - Add processing for GLBTNOPD.                       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212558 - Use TIPOSTLB as is same key as TIPOSTLA. Event      *
      *           reference cannot be used for the accruals.          *
      *  210539 - Initialise the Last Insert User and Last Amend User *
      *           fields when writing a new journal item.             *
      *  208261 - Generate suspense postings correctly.               *
      *  CTI003 - Midas/TI Accrual postings journal entry generation. *
      *                                                               *
      *****************************************************************
      *
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
      * GL Accounts Master
      *
     FSTOPCL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(STOP)
      * RE Stopped Cheques
      *
     F*TIPOSTL0*UF***E           K DISK    INFSR(*PSSR)                                       212558
     FTIPOSTLB  UF   E           K DISK    INFSR(*PSSR)                                       212558
     F                                     COMMIT
      * TI Postings by projection id, ie deal branch mnemonic,
      *    deal type, deal reference, seqeunce no., value date
      *
     FTIPOSTL8  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(TIPOSTD0:TIPOSTD8)
      * Base Currency Equivalent Postings Update Index
      *
     FGLBTNOPD  O    E             DISK    INFSR(*PSSR)                                      BUG2798
     F                                     COMMIT                                            BUG2798
      *                                                                                      BUG2798
      ** Today's batch numbers used                                                          BUG2798
      *                                                                                      BUG2798
     FGLJENSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      * GL Journal Entry Summary
      *
     FGLJENPPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      * GL Journal Entry Posting
      *
     FGLJENHPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      * GL Journal Entry Header
      *
     FTI0342AU  O    E             PRINTER USROPN
      *   Audit Report
      *
     FTIPOSTLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TIPOSTD0:TIPOSTDA)
      * TI Postings, select those accruals pending jrn ent gen
      *
     FGLJENPL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BTREMG:@BTREMG4)
      *
     FGLJENHL0  UF A E           K DISK    INFSR(*PSSR)
     FGLJENHL1  IF   E           K DISK    INFSR(*PSSR)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *  10    - Used by LOOKUP                                       *
      *  45    - *OFF means we have moved onwards to a new header     *                      BUG6289
      *          or this is the highest batch in the range.           *                      BUG6289
      *  46    - *OFF means a header was found to be updated.         *                      BUG6289
      *  90-99 - Used by Standard Subroutines                         *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      *
     D PSDS           SDS
      **  Program status data structure.
     D  ##JOB                244    253
     D  ##USER               254    263
     D  ##JBNO               264    269  0
     D  ##PGM            *PROC
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDTIIN        E DS                  EXTNAME(SDTIINPD)
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  CustDFAC     E                     EXTFLD(QQDFAC)                                     CGL029
      *
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  NostACCD     E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
     D  PcacFNAA     E                     EXTFLD(QQFNAA)                                     CGL029
     D  PcacFNIC     E                     EXTFLD(QQFNIC)                                     CGL029
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D DBERR         E DS                  EXTNAME(LDA)
      * Data structure for data-base error processing.
      *
     D W#POST          DS
      * K#POST Key list
     D  TIDLBR                 1      4
     D  TIDLTP                 5      7
     D  TIDLRF                 8     20
     D  TISEQN                21     23  0
     D  TIVALD                24     30  0
      *
     D W#ASOC          DS
     D  W#CBN                  1      3  0
     D  W#CBNA                 1      3
     D  ACNO                   7     16  0
     D  P#BATC                20     22  0
      *
     D*C#CUST***       C                   CONST('Trade Innovation')                         BUG6289
     D*C#BTIU***       C                   CONST('Batch in use by TI')                       BUG6289
     D C#CUST          C                   CONST('Trade Innovation Accruals')                BUG6289
      *
     D NumbOfCurr      C                   CONST(200)
     D CurrArr         S              3    DIM(NumbOfCurr)
     D TotalsDS        DS                  OCCURS(NumbOfCurr)
     D  TotCredit              1     13  0
     D  TotDebit              14     26  0
                                                                                              CGL029
     D WWKEY4          S             10A                                                      CGL029
     D WACODA          S             10A                                                      CGL029
      *
      *****************************************************************
      *  P R O G R A M     S T A R T                                  *
      *****************************************************************
      *
      * Program entry
     C     *ENTRY        PLIST
     C     W#STCD        PARM      W#STCD        P#STCD            1
     C                   PARM                    P#BATN            3
     C                   PARM                    W#ACNO
     C                   PARM                    SuspFlag
      *
     C                   EXSR      INIT
      * read the first posting
     C                   READ      TIPOSTLA                               89
      *
      * If there are postings
     C     *IN89         IFEQ      *OFF
      *
      * Count the accruals on the postings file
     C     *IN89         DOWEQ     *OFF
     C                   ADD       1             TOTC
      * Get next posting
     C                   READ      TIPOSTLA                               89
      *
     C                   ENDDO
     C                   ENDIF
      *
      * Read the first posting
     C     *LOVAL        SETLL     TIPOSTLA                           89
     C                   READ      TIPOSTLA                               89
      *
      * Store key fields
     C                   EVAL      W#DLBR = TIDLBR
     C                   EVAL      W#DLTP = TIDLTP
     C                   EVAL      W#DLRF = TIDLRF
     C                   EVAL      W#SEQN = TISEQN
     C                   EVAL      W#VALD = TIVALD
      *
      * Process until final totals counter reaches total postings
     C                   DOU       FTOTC >= TOTC
     C                   EXSR      DETL
      *
      * Final totals counter updated with batch postings counter
     C                   EVAL      FTOTC = FTOTC + W#TOTC
      *
      * Reset batch postings counter
     C                   EVAL      W#TOTC = 0
     C                   ENDDO
      *
     C                   EXSR      LAST
      *
      *****************************************************************
      *                                                               *
      *  DETL     - Subroutine to do the Detail Processing.           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
     C     DETL          BEGSR
      *
      * If there are no additional postings
     C     *IN89         IFEQ      *ON
 
      * If postings counter is zero then there is an empty new
      * batch so return with a blank status code.
     C     W#POSC        IFEQ      *ZERO
     C     P#STCD        IFNE      'S'
     C                   MOVE      *BLANKS       W#STCD
     C                   ENDIF
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ELSE
      **********************************
      * Process the postings
      **********************************
     C                   DOU       *IN89 OR W#TOTC = TIMXBS OR W#TRAN > TIMXBS
     C                   EVAL      W#TOTC = W#TOTC + 1
     C                   EVAL      W#TRAN = 0
      *
      * Better to let it try and write than fail with minimal information.                   BUG6289
      **Check*for*no*more*batches*available                                                  BUG6289
     C*****W#CBN         IFGT      TIURBN                                                    BUG6289
     C**********         MOVEL     TIURBN        DBKEY                                       BUG6289
     C**********         MOVEL     'UR BATCH'    DBFILE                                      BUG6289
     C**********         Z-ADD     4             DBASE                                       BUG6289
     C**********         EXSR      *PSSR                                                     BUG6289
     C**********         ENDIF                                                               BUG6289
      *
     C                   ADD       1             W#POSC
      *
      *  Validate fields
     C                   EXSR      VALID
      *
      *  Write postings to Journal Entry Postings File
     C                   EXSR      GLJENP
      *
      *  If this is a new batch, then write header and flag as in use
     C     W#POSC        IFEQ      1
     C                   EXSR      GLJENH
     C                   ENDIF
      *
      *  Update the posting status to 'JEG'
     C     MIDGEN        IFEQ      'N'
     C*****K#POST        CHAIN     TIPOSTL0                           85                      212558
     C     K#POST        CHAIN     TIPOSTLB                           85                      212558
      *
     C     *IN85         IFEQ      *ON
     C                   MOVEL     W#POST        DBKEY
     C**********         MOVEL     'TIPOSTL0'    DBFILE                                       212558
     C                   MOVEL     'TIPOSTLB'    DBFILE                                       212558
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Update the posting status to 'JEG'
     C                   MOVE      'JEG'         PSTS
     C                   UPDATE    TIPOSTD0
     C                   ELSE
     C     K#BCUR        CHAIN     TIPOSTL8                           85
      *
     C     *IN85         IFEQ      *ON
     C                   MOVEL     W#POST        DBKEY
     C                   MOVEL     'TIPOSTL8'    DBFILE
     C                   Z-ADD     8             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Update the posting status to 'JEG'
     C                   MOVE      'JEG'         PSTS
     C                   UPDATE    TIPOSTD8
     C                   ENDIF
      *
      *  Update Total Debit and Credit amounts
     C                   Z-ADD     1             Index
     C     CCY           LOOKUP    CurrArr(Index)                         10
     C     *IN10         IFEQ      '0'
     C                   MOVEL     CCY           DBKEY
     C                   MOVEL     'Array   '    DBFILE
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     Index         OCCUR     TotalsDS
     C     TIDCIN        IFEQ      'D'
     C                   ADD(H)    TIAMNT        TotDebit
     C                   ELSE
     C                   ADD(H)    TIAMNT        TotCredit
     C                   ENDIF
      *
      * Depending on number of decimal places of currency multiply by
      *  factor of 10
     C     A6NBDP        IFEQ      0
     C     TIAMNT        MULT      1000          W#AMNT
     C                   ENDIF
     C     A6NBDP        IFEQ      1
     C     TIAMNT        MULT      100           W#AMNT
     C                   ENDIF
     C     A6NBDP        IFEQ      2
     C     TIAMNT        MULT      10            W#AMNT
     C                   ENDIF
      *
      *  Update Hash Total Amount
     C                   ADD(H)    W#AMNT        W##AMT
      *
      *  Update the Journal Entry Summary File
     C                   EXSR      GLJENS
      *
     C     *DTAARA       DEFINE    TI0340        W#034T          128
     C                   IN        W#034T
     C                   MOVEL     W#034T        W#0340            5
      *
      *  Call subroutine TOTALS to check if debit equals credit.
      *  This subroutine will set the flag DebEQCred
     C                   EXSR      TOTALS
      *
      * Get next posting
     C                   READ      TIPOSTLA                               89
      *
      * If next record is a different transaction then
      * check it will not break the max batch size
     C     TIDLBR        IFNE      W#DLBR
     C     TIDLTP        ORNE      W#DLTP
     C     TIDLRF        ORNE      W#DLRF
      *
      * Store key fields
     C                   EVAL      W#DLBR = TIDLBR
     C                   EVAL      W#DLTP = TIDLTP
     C                   EVAL      W#DLRF = TIDLRF
     C                   EVAL      W#SEQN = TISEQN
     C                   EVAL      W#VALD = TIVALD
      *
     C                   EXSR      TRANS
      *
      * Check next transaction total will not break limit
     C                   EVAL      W#TRAN = W#TOTC + W#NEXT
     C                   EVAL      W#NEXT = 0
      *
      * Restore key fields
     C                   EVAL      TIDLBR = W#DLBR
     C                   EVAL      TIDLTP = W#DLTP
     C                   EVAL      TIDLRF = W#DLRF
     C                   EVAL      TISEQN = W#SEQN
     C                   EVAL      TIVALD = W#VALD
      *
      * Return to the first posting of the new transaction
     C     K#POST        SETLL     TIPOSTLA                           89
     C                   READ      TIPOSTLA                               89
     C                   ENDIF
      *
     C                   ENDDO
     C                   EXSR      CLOSE
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VALID - Validate the fields                                  *
      *                                                               *
      *  Called By: DETL                                              *
      *  Calls    : AOBRCHR0                                          *
      *                                                               *
      *****************************************************************
     C     VALID         BEGSR
      *
      * Initialise field
     C                   Z-ADD     *ZEROS        ACNO
      *
      * Validate branch code
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG    '    WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM      BRCA          WWKEY3            3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Validate Customer
     C                   MOVEL(P)  CNUM          WWKY10
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG    '    WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM                    WWKY10           10
     C                   PARM      *BLANKS       WWKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   MOVE      CNUM          WCNMA
     C                   ENDIF
      *
      * Validate Currency
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    WWRTCD            7
     C                   PARM      '*KEY    '    WWOPTN            7
     C                   PARM      CCY           WWKEY3            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Validate Account Code
     C                   MOVE      ACOD          WWKEY4
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG    '    WWRTCD            7            B:Return Cd
     C                   PARM      '*KEY    '    WWOPTN            7            I:Option
     C**********         PARM                    WWKEY4            4            I:Accou LN033 CGL029
     C                   PARM                    WWKEY4                                       CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                          O:Format
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   MOVE      ACOD          WACODA
     C                   ENDIF
      *
      * Get Account
     C     K#ACCN        CHAIN     ACCNT                              88
     C     *IN88         IFEQ      *ON
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Check if Account is actually a Nostro
     C                   MOVE      ACSQ          WACSN
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*KEY   '     WWOPTN
     C                   PARM                    WCNMA             6
     C                   PARM      CCY           WCYCD             3
     C**********         PARM                    WACODA            4                          CGL029
     C                   PARM                    WACODA                                       CGL029
     C                   PARM                    WACSN             2
     C                   PARM      *BLANKS       WNONB             2
     C                   PARM      BRCA          WBRCD             3
     C                   PARM      *BLANKS       WCSSN            10
     C                   PARM      *BLANKS       WPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     WWRTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           @NOSTR            1
     C                   ELSE
     C                   MOVE      'N'           @NOSTR
     C                   ENDIF
      *
      * Account must be open to be valid
     C     DACC          IFNE      *ZERO
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Value date after date account opened?
     C     MTIVD         IFLT      DACO
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Retail a/c?
     C     ACNO          IFNE      *ZERO
      *
      *  Back valued posting within back value period?
     C     MTIVD         IFLT      BJRDNB
      *
     C     BJRDNB        SUB       MTIVD         W#BACK
     C     W#BACK        IFGT      BJBVPD
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
      *
      *  Check status of retail account?
     C     TIREAS        IFEQ      'Y'
      *
      *   Bit 0 - Refer Debits?
      *   Bit 1 - Refer Credits?
      *   Bit 2 - Block Debits?
      *   Bit 3 - Block Credits?
      *   Bit 4 - Account is Inactive?
      *   Bit 6 - Bankrupt/Liquidation?
      *   Bit 7 - Bad Debt?
     C                   TESTB     '467'         RETB                 87
     C     *IN87         IFEQ      *OFF
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
     C     TIDCIN        IFEQ      'D'
     C                   TESTB     '02'          RETB                 87
     C     *IN87         IFEQ      *OFF
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     TIDCIN        IFEQ      'C'
     C                   TESTB     '13'          RETB                 87
     C     *IN87         IFEQ      *OFF
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDVAL        TAG
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  GLJENP- Write Postings to Journal Entry Postings File        *
      *                                                               *
      *  Called By: DETL                                              *
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
     C     GLJENP        BEGSR
      *
      * Batch number
     C                   MOVEL     W#CBN         BTBTNB
      * Batch Item No.
     C                   Z-ADD     W#POSC        BTBINB
      * Branch Number
     C                   MOVE      BRCA          BTIBCA
      * Customer No.
     C                   MOVEL     CNUM          BTCUST
      * Currency Code
     C                   MOVE      CCY           BTCYCD
      * Account Code
     C                   MOVE      ACOD          BTACCD
      * Account Seq. No.
     C                   MOVE      ACSQ          BTACSN
      * Nostro Number
     C                   IF        NONB <> 0
     C                   MOVE      NONB          BTNNBI
     C                   ELSE
     C                   MOVE      *BLANK        BTNNBI
     C                   ENDIF
      * Retail A/C No.
     C                   Z-ADD     ACNO          BTRACN
      * Retail Ind.: Override
     C                   CLEAR                   BTRINO
      * Retail Ind.: Error
     C                   MOVE      'N'           BTRINE
      * Transaction Type
     C                   CLEAR                   BTTRTY
     C     ATYP          IFEQ      'R'
     C                   MOVE      TITRTP        BTTRTY
     C                   ENDIF
      * Posting Amount
     C                   Z-ADD     TIAMNT        BTPTAM
      * Debit/Credit Ind.
     C                   MOVE      TIDCIN        BTDCIN
      * Posting Date
     C                   Z-ADD     BJRDNB        BTPTDT
      * Value Date
      * Call access program for Midas Modules details
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG    '    WWRTCD            7
     C                   PARM      '*FIRST  '    WWOPTN            7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     WWRTCD        IFNE      *BLANK
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Allow future or backvalued date if account is retail.
     C     ATYP          IFEQ      'R'
     C                   Z-ADD     MTIVD         BTVLDT
     C                   ELSE
      * Otherwise allow backvalued date if management accounts is on.
     C     BGNVST        IFEQ      'Y'
     C     MTIVD         ANDLE     BJRDNB
     C                   Z-ADD     MTIVD         BTVLDT
     C                   ELSE
      * Otherwise set date to run date as a GL account would require.
     C                   Z-ADD     BJRDNB        BTVLDT
     C                   ENDIF
     C                   ENDIF
      * Narrative Code
     C                   CLEAR                   BTNVCD
      * Narrative Description
     C                   CLEAR                   BTNRDC
     C     TIDLTP        CAT       TIDLRF        BTNRDC
      * Account Type
     C                   MOVE      ATYP          BTACTY
      * Assoc. Customer No.
     C*****ASOC*         IFNE      *ZERO                                                      CSD027
     C     ASOC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      ASOC          BTACNB
     C                   ELSE
     C                   MOVE      *BLANKS       BTACNB
     C                   ENDIF
      * Cheque Number
     C                   CLEAR                   BTCQNB
      * Customer Originated Ind.
     C                   MOVE      'N'           BTCOIN
      * SWIFT Common Reference
     C                   CLEAR                   BTSWCR
      * Profit Centre
     C                   CLEAR                   BTPRCN
      *
     C     ATYP          IFEQ      'N'
     C     ATYP          OREQ      'R'
     C     @NOSTR        OREQ      'Y'
     C     PRFC          IFNE      *BLANKS
     C                   MOVE      PRFC          BTPRCN
     C                   ENDIF
     C                   ENDIF
      *
      * Default profit centre using TI ICD if PRFC is blank and AA is OFF
     C     BTPRCN        IFEQ      *BLANKS
     C     BGN0ST        ANDNE     'Y'
     C                   MOVE      TIPRFC        BTPRCN
     C                   ENDIF
      *
      * Default profit centre using default matrix if PRFC is blank and AA is ON
     C     BTPRCN        IFEQ      *BLANKS
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVE      ASOC          CUST
     C                   CALLB     'AOPRFMR0'
     C                   PARM                    RTCD              1
     C                   PARM      TIBOOK        BOOK              2            Book Code
     C                   PARM      TIDLTP        TRTP              5            TransactonType
     C                   PARM      *BLANKS       SUTP              2            Sub Type
     C                   PARM      BRCA          BRAN              3            Branch Code
     C                   PARM      *BLANKS       DEPT1             3            Deptment Code
     C                   PARM      ##USER        USER             10            User
     C                   PARM      BBACOC        ACOF              2            AccountOfficer
     C                   PARM                    CUST              6            CustomerNumber
     C                   PARM                    DPRFC             4            Profit Centre
      *
     C     RTCD          IFNE      '0'
     C     DPRFC         OREQ      FTUAPC
     C                   MOVE      TIPRFC        BTPRCN
     C                   ELSE
     C                   MOVE      DPRFC         BTPRCN
     C                   ENDIF
     C                   ENDIF
      *
      * Branch Code (Batch Header)
     C                   MOVE      TIBRCH        BTBCBH
      * Retail Advice Printed
     C                   MOVE      'N'           BTRADP
      * Shadow Posted Indicator
     C     PSTS          IFEQ      'PJS'
     C                   MOVE      'N'           BTSHPI
     C                   ENDIF
     C     PSTS          IFEQ      'PJN'
     C                   MOVE      'Y'           BTSHPI
     C                   ENDIF
      * RRN of memos
     C                   CLEAR                   BTRRNM
      * Retail Number Entered
     C                   MOVE      'N'           BTRNBE
      * Book Code
     C                   MOVE      TIBOOK        BTBKCD
      * Retail a/c Referall Cond.
     C                   CLEAR                   BTRARC
      * Transaction sub-type
     C                   CLEAR                   BTTSTY
      * Spread Factor
     C                   CLEAR                   BTSPFC
      * Reverse/Void Ind.
     C                   CLEAR                   BTRVDI
      * No. of items
     C                   CLEAR                   BTNITM
      *
      * If EMU Midas-TI Interface Enhancement is switched on
      * then write Original Currency and Amount to GLJENPPD.
      *
     C     CEU029        IFEQ      'Y'
     C                   MOVEL     TIOCCY        BTOCCY
     C                   Z-ADD     TIOAMT        BTOAMT
     C                   ELSE
     C                   eval      BTOCCY = *BLANKS
     C                   eval      BTOAMT = 0
     C                   ENDIF
      *
      * Write Record
     C                   WRITE     @BTREMG
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  TOTALS - Check if Debit equals Credit across all currencies  *
      *                                                               *
      *  Called By: DETL                                              *
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
     C     TOTALS        BEGSR
      *
     C                   MOVE      'Y'           DebEQCred         1
      *
      * Check all the currencies for debit/credit discrepencies
      *
     C     1             DO        RealNCurr     Index
     C     Index         OCCUR     TotalsDS
     C                   IF        TotDebit <> TotCredit
     C                   MOVE      'N'           DebEQCred
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  GLJENS- Update the Journal Entry Summary File                *
      *                                                               *
      *  Called By: DETL                                              *
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
     C     GLJENS        BEGSR
      *
      * Check if Journal Entry Summary already exists for this batch
      *
     C     K#JENS        CHAIN     GLJENSL0                           84
     C     *IN84         IFEQ      *ON
     C                   CLEAR                   BSDBTT
     C                   CLEAR                   BSCRTT
     C                   ENDIF
      *
      * Debit
     C     TIDCIN        IFEQ      'D'
     C                   ADD       TIAMNT        BSDBTT
     C                   ELSE
      * Credit
     C                   ADD       TIAMNT        BSCRTT
     C                   ENDIF
      *
      * Batch Number
     C                   MOVE      W#CBN         BSBTNB
      * Currency Code
     C                   MOVE      CCY           BSCYCD
      * Branch Code
     C                   MOVE      BRCA          BSBRCD
      *
     C     *IN84         IFEQ      *ON
      * Write Record
     C                   WRITE     @BSREAI
     C                   ELSE
      * Update Record
     C                   UPDATE    @BSREAI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  GLJENH - Write Record to Journal Entry Header File           *
      *                                                               *
      *  Called By: DETL                                              *
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
     C     GLJENH        BEGSR
      *
      * Batch Number
     C                   MOVE      W#CBN         BRBTNB
      *
      * If closing the header then find the correct batch
      *
     C     BRBTNB        CHAIN     @BRREAG                            4646
      * Branch
     C                   MOVE      TIBRCH        BRBCDA
      * Department
     C                   MOVE      TIDEPT        BRDPCD
      * Workstation id
      *
      * Default Workstation ID correctly
     C                   CLEAR                   BRWSID
     C                   MOVEL     'TI-BATCH'    BRWSID
      * Hash amount
     C     W##AMT        DIV       1000          Amount           15 3
      *
     C                   CALLB     'ZZADD'
     C                   PARM                    Amount
     C                   PARM      *ZERO         IntPart          15 0
     C                   PARM      *ZERO         DecPart           3 0
      *
     C                   Z-ADD     IntPart       BRHICC
     C                   Z-ADD     DecPart       BRHDCC
     C                   Z-ADD     IntPart       BRHIIN
     C                   Z-ADD     DecPart       BRHDIN
      * Hash Item Number
     C                   Z-ADD     W#POSC        BRHINC
     C                   Z-ADD     W#POSC        BRHINI
      *
      * Batch is now flagged as in use until fully closed
      * Shadow Post Indicator
     C                   MOVE      'N'           BRSHPI
      * Multiple Branch Batch
     C                   MOVE      'Y'           BRMBRB
      * Batch Description
     C                   MOVE      *BLANKS       BRBDES
     C                   MOVEL     C#CUST        BRBDES
      * Type of Journal Entry
     C                   MOVEL     'J'           BRTOJE
      *
     C                   CLEAR                   BRRAPI
      *
      * This flag now used as work field to inidicate an open
      * batch
     C                   CLEAR                   BRUSRI                                       210539
     C                   CLEAR                   BRUSRA                                       210539
     C                   CLEAR                   BRSPTT
     C                   CLEAR                   BRNIST
     C                   CLEAR                   BRSPRF
     C                   CLEAR                   BRDCIN
     C                   CLEAR                   BRIBCF
     C                   CLEAR                   BRCUSF
     C                   CLEAR                   BRCYCF
     C                   CLEAR                   BRACCF
     C                   CLEAR                   BRACSF
     C                   CLEAR                   BRNNBF
     C                   CLEAR                   BRRACF
     C                   CLEAR                   BRPRCF
     C                   CLEAR                   BRAMTF
     C                   CLEAR                   BRIBCT
     C                   CLEAR                   BRCYCT
     C                   CLEAR                   BRCNAT
     C                   CLEAR                   BRACCT
     C                   CLEAR                   BRASNT
     C                   CLEAR                   BRNNBT
     C                   CLEAR                   BRRACT
      *
      * Update or Write depending on whether a record exists for an
      * open batch
      * Never keep batch open and in use. If last batch in TI range, can then be added to.   BUG6289
      * Only want status to be 'H' if held and made 'A' on final CLOSE subroutine call.      BUG6289
      *
     C     *IN46         IFEQ      *ON
     C*****W#STCD        IFNE      'F'                                                       BUG6289
     C**********         MOVE      'Y'           BRBIUF                                      BUG6289
     C**********         MOVE      'O'           BRRVVD                                      BUG6289
     C**********         MOVEL     C#BTIU        BRBDES                                      BUG6289
     C**********         ELSE                                                                BUG6289
     C                   MOVE      'N'           BRBIUF
     C                   MOVE      ' '           BRRVVD
     C**********         MOVE      C#CUST        BRBDES                                      BUG6289
     C**********         ENDIF                                                               BUG6289
      *
     C     W#HTB         IFEQ      'Y'
     C                   MOVE      'H'           BRBTSF
     C**********         ELSE                                                                BUG6289
     C**********         MOVE      ' '           BRBTSF                                      BUG6289
     C                   ENDIF
      *
     C                   WRITE     @BRREAG
      *                                                                                      BUG2798
     C                   MOVEL     BRBTNB        B3BTNB                                      BUG2798
     C                   MOVEL     'N'           B3DUMP                                      BUG2798
     C                   WRITE     GLBTNOD0                                                  BUG2798
      *
     C                   ELSE
     C                   MOVE      'N'           BRBIUF
     C                   MOVE      ' '           BRRVVD
     C     W#HTB         IFEQ      'Y'
     C                   MOVE      'H'           BRBTSF
     C                   ELSE
     C                   MOVE      'A'           BRBTSF
     C                   ENDIF
     C                   UPDATE    @BRREAG
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN46
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      * Initialise flag for postings to suspense
     C                   MOVE      'N'           SuspFlag          1
      *
     C                   CLEAR                   DBASE
      *
      *  Retrieve Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        WWRTCD            7
     C                   PARM      '*FIRST'      WWOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Retrieve TI Details
     C                   CALL      'AOTIINR0'
     C                   PARM      '*MSG'        WWRTCD            7
     C                   PARM      '*FIRST'      WWOPTN            7
     C     SDTIIN        PARM      SDTIIN        DSFDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDTIINPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      TIBALA        W#ACNO
      *
      *  Check that AA is switched on using SDMMODPD and if it is
      *  Validate that TIPRFC is a valid profit centre.
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     13            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If AA is ON validate that TIPRFC is a valid profit centre.
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPRFCR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      TIPRFC        @KEY              4
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'TIPRFC'      DBKEY
     C                   MOVEL     'SDPRFCPD'    DBFILE
     C                   Z-ADD     14            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  (AA is ON) Obtain the 'Unallocated Profit Centre' from PF/SDPCACPD
     C                   CALL      'AOPCACR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *   Error?
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDPCACPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * Access SAR details file to determine if CEU029 is installed.
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD            7
     C                   PARM      '*VERIFY'     ##OPTN            7
     C                   PARM      'CEU029'      ##SARD            6
      *
      * Database Error
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   Z-ADD     9             DBASE
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '*CALL'       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU029            1
     C                   ELSE
     C                   MOVEL     'N'           CEU029
     C                   ENDIF
      *
      *  Set current batch number from data area TIBATCH
      *  If this is blank then set current batch no. as TILRBN
     C     *DTAARA       DEFINE    TIBATCH       BTCHNM          128
     C                   IN        BTCHNM
     C                   MOVEL     BTCHNM        W#CBNA
     C     W#CBNA        IFEQ      *BLANKS
     C                   Z-ADD     TILRBN        W#CBN
     C                   ENDIF
      *                                                                                      BUG6289
      *  If header already exists, it could contain daily postings which may be out of       BUG6289
      *  balance, do not add accruals to it but open a new batch (if available).             BUG6289
      *                                                                                      BUG6289
     C     W#CBN         IFLT      TIURBN                                                    BUG6289
     C     W#CBNA        CHAIN     @BRREAG                            45                     BUG6289
     C     *IN45         IFEQ      *OFF                                                      BUG6289
     C                   ADD       1             W#CBN                                       BUG6289
      *                                                                                      BUG6289
      * Update data area TIBATCH with next batch number                                      BUG6289
     C     *LOCK         IN        BTCHNM                                                    BUG6289
     C                   MOVEL     W#CBNA        BTCHNM                                      BUG6289
     C                   OUT       BTCHNM                                                    BUG6289
     C                   ENDIF                                                               BUG6289
     C                   ENDIF                                                               BUG6289
      *
      *  Last Batch Reached
     C                   MOVE      'N'           W#LBR             1
      *  STOP Increment
      *  Not waiting for new postings
     C                   MOVE      'N'           W#WAIT            1
      *
      *  Initialise CurrArr array with Currency Codes from SDCURRPD
     C                   Z-ADD     NumbOfCurr    RealNCurr         3 0
     C                   CALL      'AOCURRR0'
     C                   PARM      '        '    WWRTCD
     C                   PARM      '*FIRST  '    WWOPTN
     C                   PARM      *BLANK        WWKEY3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      A6CYCD        CurrArr(1)
     C                   ENDIF
      *
     C     2             DO        NumbOfCurr    Index             3 0
     C                   CALL      'AOCURRR0'
     C                   PARM      '        '    WWRTCD
     C                   PARM      '*NEXT   '    WWOPTN
     C                   PARM      *BLANK        WWKEY3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     WWRTCD        IFEQ      '*EOF'
     C                   EVAL      RealNCurr = Index - 1
     C                   LEAVE
     C                   ENDIF
      *
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     Index         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      A6CYCD        CurrArr(Index)
     C                   ENDIF
     C                   ENDDO
      *
      * End of first call processing
      *
     C     W#CBN         IFEQ      TIURBN
      *
      *   Last Batch Reached
     C                   MOVE      'Y'           W#LBR             1
      *   Find next available posting in the last batch to add from.                         BUG6289
     C     W#CBNA        SETGT     @BTREMG4                                                  BUG6289
     C                   READP     @BTREMG4                               47                 BUG6289
     C                   Z-ADD     BTBINB        W#POSC                                      BUG6289
     C                   ENDIF
      *
      *   Clear the multiple-occurrence DS which holds total amounts
     C                   CLEAR     *ALL          TotalsDS
      **********                                                                             BUG6289
      * Dont need this anymore as no longer add records to a previous batch unless this      BUG6289
      * is the highest batch in the range, in which case the code above handles it.          BUG6289
      **Check*last*batch*number*of*post*not*equal*to*header*batch*number                     BUG6289
      **********                                                                             BUG6289
     C**********         MOVE      TIURBN        BTNO              3                         BUG6289
     C**********         Z-ADD     0             W#HBAT                                      BUG6289
     C*****BTNO*         SETGT     @BTREMG4                                                  BUG6289
     C**********         READP     @BTREMG4                               47                 BUG6289
     C*****BTNO*         SETGT     @BRREAH                                                   BUG6289
     C**********         READP     @BRREAH                                48                 BUG6289
     C**********         MOVE      BRBTNB        W#HBAT            3 0                       BUG6289
     C*****W#HBAT        IFGE      TILRBN                                                    BUG6289
     C*****W#HBAT        ANDLE     TIURBN                                                    BUG6289
     C*****BRRVVD        ANDEQ     'O'                                                       BUG6289
     C*****BRBIUF        ANDEQ     'Y'                                                       BUG6289
     C**********         MOVE      BTBINB        W#POSC                                      BUG6289
     C**********         ENDIF                                                               BUG6289
      *  Read in the details of the data area TI0340
     C                   IN        W#034T
     C                   MOVEL     W#034T        W#0340            5
      *
     C     K#ACCN        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
      *
     C     K#POST        KLIST
     C                   KFLD                    TIDLBR
     C                   KFLD                    TIDLTP
     C                   KFLD                    TIDLRF
     C                   KFLD                    TISEQN
     C                   KFLD                    TIVALD
      *
     C     K#BCUR        KLIST
     C**********         KFLD                    DRCV                                         212558
     C                   KFLD                    TRDATE                                       212558
     C                   KFLD                    TRANID
     C                   KFLD                    TICCYM
     C                   KFLD                    TICCY2
      *
     C     K#JENS        KLIST
     C                   KFLD                    W#CBNA
     C                   KFLD                    CCY
     C                   KFLD                    BRCA
      *
      *
      *
     C*****K#SUSP        KLIST                                                                208261
     C**********         KFLD                    W#CBNA                                       208261
     C**********         KFLD                    BTCYCD                                       208261
      *
     C     *LIKE         DEFINE    P#STCD        W#STCD
     C     *LIKE         DEFINE    BJBVPD        W#BACK
     C     *LIKE         DEFINE    TIMXBS        W#POSC
     C     *LIKE         DEFINE    TIAMNT        W##AMT
     C     *LIKE         DEFINE    TIAMNT        W#AMNT
     C     *LIKE         DEFINE    TRTOT         W#SEQC
     C     *LIKE         DEFINE    TRTOT         W#TOTC
     C     *LIKE         DEFINE    TRTOT         FTOTC
     C     *LIKE         DEFINE    TRTOT         TOTC
     C     *LIKE         DEFINE    TIAMNT        W#SUSP
     C     *LIKE         DEFINE    BTACCD        W#ACNO
     C     *LIKE         DEFINE    TIDLBR        W#DLBR
     C     *LIKE         DEFINE    TIDLTP        W#DLTP
     C     *LIKE         DEFINE    TIDLRF        W#DLRF
     C     *LIKE         DEFINE    TISEQN        W#SEQN
     C     *LIKE         DEFINE    TIVALD        W#VALD
     C     *LIKE         DEFINE    TRTOT         W#NEXT
     C     *LIKE         DEFINE    TRTOT         W#TRAN
     C                   EVAL      TIMXBS = 999 - RealNCurr
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  CLOSE - Close of Batch Processing                            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
     C     CLOSE         BEGSR
      *
      * Hold the batch if total debits not equal to total credits
     C     DebEQCred     IFNE      'Y'
      *
     C                   EXSR      SUSP
     C                   EXSR      VALID
      *
      * Call subroutine TOTALS to check if debit equals credit.
      * This subroutine will set the flag DebEQCred
     C                   EXSR      TOTALS
     C
     C                   ENDIF
     C     DebEQCred     IFEQ      'Y'
      *  Batch Accepted
     C                   MOVE      'A'           BRBTSF
     C                   MOVE      'A'           W#STCD
     C                   MOVE      W#CBNA        P#BATN
     C                   ENDIF
      *
      *  Write record to the Journal Entry Header File
     C                   EXSR      GLJENH
      *
     C                   COMMIT
      * Submit an accepted batch to MIDAS
     C     W#STCD        IFEQ      'A'
     C                   CALL      'GLSBMBCH'
     C                   PARM      *BLANK        WWRTCD
     C                   PARM      P#BATN        WWBATNO           3
     C                   ENDIF
      *
      * Increment the current batch number
     C     W#CBN         IFLT      TIURBN                                                    BUG6289
     C                   ADD       1             W#CBN
      *
      * Update data area TIBATCH with next batch number
     C     *LOCK         IN        BTCHNM
     C                   MOVEL     W#CBNA        BTCHNM
     C                   OUT       BTCHNM
     C                   ENDIF                                                               BUG6289
      *
      * Set up the next batch
      *
      *   Postings Counter
     C                   Z-ADD     *ZERO         W#POSC
      *   Hold the Batch
     C                   MOVE      'N'           W#HTB             1
      *  Hash Total Amount
     C                   Z-ADD     *ZERO         W##AMT
      *   Clear the multiple-occurrence DS which holds total amounts
     C                   CLEAR     *ALL          TotalsDS
      *   STOP No. of Postings
      *   Not waiting for new postings
     C                   MOVE      'N'           W#WAIT
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  LAST   - Subroutine to do End Processing.                    *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
     C     LAST          BEGSR
      *
      * Waiting for new postings on next call
     C                   MOVE      'Y'           W#WAIT
      *
      * Commit changes within this call to the program
     C                   COMMIT
      *
      * End
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SUSP - Create suspense account.                              *
      *                                                               *
      *  Called By: Close                                             *
      *                                                               *
      *****************************************************************
      *
     C     SUSP          BEGSR
      *
      * Set postings to suspense account flag to 'Y'
     C                   MOVE      'Y'           SuspFlag
      *
     C                   MOVE      BTBTNB        W#BTNB            3
      *
      **Loop*to*re-load*debit*and*credit*info*for*this*batch.                                 208261
     C**********         Z-ADD     1             Index                                        208261
     C**********         DOU       Index = RealNCurr                                          208261
      **********                                                                              208261
     C*****Index         OCCUR     TotalsDS                                                   208261
      *                                                                                       208261
      * Read batch summary file to see if credits and debits balance                          208261
     C     W#BTNB        SETLL     GLJENSL0                                                   208261
     C                   READ      GLJENSL0                               86                  208261
      * Do until a different batch is reached                                                 208261
     C     BSBTNB        DOWEQ     W#BTNB                                                     208261
     C     *IN86         ANDEQ     *OFF                                                       208261
      * If credits do not match debits then create suspense posting                           208261
     C     BSCRTT        IFNE      BSDBTT                                                     208261
      * Work out if suspense amount will be debit and credit and the amount                   208261
     C                   Z-ADD     0             W#SUSP
     C     BSCRTT        IFGT      BSDBTT                                                     208261
     C                   MOVE      'D'           BTDCIN                                       208261
     C     BSCRTT        SUB       BSDBTT        W#SUSP                                       208261
     C     BSDBTT        ADD       W#SUSP        BSDBTT                                       208261
     C                   ELSE                                                                 208261
     C                   MOVE      'C'           BTDCIN                                       208261
     C     BSDBTT        SUB       BSCRTT        W#SUSP                                       208261
     C     BSCRTT        ADD       W#SUSP        BSCRTT                                       208261
     C                   ENDIF                                                                208261
      *                                                                                       202861
     C*****TotDebit      IFNE      TotCredit                                                  208261
     C**********         MOVEA     CurrArr(Index)BTCYCD                                       208261
      **********                                                                              208261
      **Check*if*Journal*Entry*Summary*already*exists*for*this*batch                          208261
     C*****K#SUSP        CHAIN     GLJENSL0                           84                      208261
     C*****TotDebit      IFGT      TotCredit                                                  208261
     C**********         EVAL      W#SUSP = TotDebit - TotCredit                              208261
     C**********         Z-ADD     W#SUSP        BTPTAM                                       208261
     C**********         MOVE      'C'           BTDCIN                                       208261
     C**********         ADD       W#SUSP        BSCRTT                                       208261
     C**********         ADD       W#SUSP        TotCredit                                    208261
     C**********         ELSE                                                                 208261
     C**********         EVAL      W#SUSP = TotCredit - TotDebit                              208261
     C**********         Z-ADD     W#SUSP        BTPTAM                                       208261
     C**********         ADD       W#SUSP        BSDBTT                                       208261
     C**********         MOVE      'D'           BTDCIN                                       208261
     C**********         ADD       W#SUSP        TotDebit                                     208261
     C**********         ENDIF                                                                208261
     C                   ADD       1             W#POSC
      **Depending*on*number*of*decimal*places*of*currency*multiply*by                         208261
      ***factor*of*10                                                                         208261
     C*****A6NBDP        IFEQ      0                                                          208261
     C*****W#SUSP        MULT      1000          W#AMNT                                       208261
     C**********         ENDIF                                                                208261
     C*****A6NBDP        IFEQ      1                                                          208261
     C*****W#SUSP        MULT      100           W#AMNT                                       208261
     C**********         ENDIF                                                                208261
     C*****A6NBDP        IFEQ      2                                                          208261
     C*****W#SUSP        MULT      10            W#AMNT                                       208261
     C**********         ENDIF                                                                208261
      **********                                                                              208261
      ***Update*Hash*Total*Amount                                                             208261
     C**********         ADD(H)    W#AMNT        W##AMT                                       208261
      *
      *  Write postings to Journal Entry Postings File
      *
      * Postings amount                                                                       208261
     C                   Z-ADD     W#SUSP        BTPTAM                                       208261
      * Currency                                                                              208261
     C                   MOVEL     BSCYCD        BTCYCD                                       208261
      * Batch number
     C**********         MOVEL     W#CBN         BTBTNB                                       208261
     C                   MOVEL     W#BTNB        BTBTNB                                       208261
      * Batch Item No.
     C                   Z-ADD     W#POSC        BTBINB
      * Branch Number
     C**********         MOVE      BRCA          BTIBCA                                       208261
     C                   MOVE      BSBRCD        BTIBCA                                       208261
      * Customer No.
     C**********         MOVEL     CNUM          BTCUST                                       208261
                                                                                              202861
      * Get branch internal customer                                                          208261
     C**********         CALL      'AOBRCHR0'                                          208261 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       WWRTCD                                       208261
     C                   PARM      '*KEY    '    WWOPTN                                       208261
     C                   PARM      BSBRCD        WWKEY3            3                          208261
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 208261 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      * If branch not found                                                                   208261
     C     WWRTCD        IFNE      *BLANKS                                                    208261
     C                   MOVEL     BSBRCD        DBKEY                                        208261
     C                   MOVEL     'SDBRCHPD'    DBFILE                                       208261
     C                   Z-ADD     15            DBASE                                        208261
     C                   EXSR      *PSSR                                                      208261
     C                   ENDIF                                                                208261
     C                   MOVEL     A8BICN        BTCUST                                       208261
      * Account Code
     C                   MOVE      TIBALA        BTACCD
      * Account Seq. No.
     C                   MOVE      ACSQ          BTACSN
      * Nostro Number
     C                   IF        NONB <> 0
     C                   MOVE      NONB          BTNNBI
     C                   ELSE
     C                   MOVE      *BLANK        BTNNBI
     C                   ENDIF
      * Retail A/C No.
     C                   Z-ADD     *ZERO         BTRACN
      * Retail Ind.: Override
     C                   CLEAR                   BTRINO
      * Retail Ind.: Error
     C                   MOVE      'N'           BTRINE
      * Transaction Type
     C                   CLEAR                   BTTRTY
     C     ATYP          IFEQ      'R'
     C                   MOVE      TITRTP        BTTRTY
     C                   ENDIF
      * Posting Date
     C                   Z-ADD     BJRDNB        BTPTDT
      * Value Date
     C                   Z-ADD     BJRDNB        BTVLDT
      * Narrative Code
     C                   CLEAR                   BTNVCD
      * Narrative Description
     C                   CLEAR                   BTNRDC
     C                   EVAL      BTNRDC = 'SUSPENSE ACCOUNT'
      * Account Type
     C                   MOVE      ATYP          BTACTY
      * Profit Centre
     C                   CLEAR                   BTPRCN
      *
     C     ATYP          IFEQ      'N'
     C     ATYP          OREQ      'R'
     C     @NOSTR        OREQ      'Y'
     C     PRFC          IFNE      *BLANKS
     C                   MOVE      PRFC          BTPRCN
     C                   ENDIF
     C                   ENDIF
      *
      * Default profit centre using TI ICD if PRFC is blank and AA is OFF
     C     BTPRCN        IFEQ      *BLANKS
     C     BGN0ST        ANDNE     'Y'
     C                   MOVE      TIPRFC        BTPRCN
     C                   ENDIF
      *
      * Default profit centre using default matrix if PRFC is blank and AA is ON
     C     BTPRCN        IFEQ      *BLANKS
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVE      ASOC          CUST
     C                   CALLB     'AOPRFMR0'
     C                   PARM                    RTCD              1
     C                   PARM      TIBOOK        BOOK              2            Book Code
     C                   PARM      TIDLTP        TRTP              5            TransactonType
     C                   PARM      *BLANKS       SUTP              2            Sub Type
     C                   PARM      BRCA          BRAN              3            Branch Code
     C                   PARM      *BLANKS       DEPT1             3            Deptment Code
     C                   PARM      ##USER        USER             10            User
     C                   PARM      BBACOC        ACOF              2            AccountOfficer
     C                   PARM                    CUST              6            CustomerNumber
     C                   PARM                    DPRFC             4            Profit Centre
      *
     C     RTCD          IFNE      '0'
     C     DPRFC         OREQ      FTUAPC
     C                   MOVE      TIPRFC        BTPRCN
     C                   ELSE
     C                   MOVE      DPRFC         BTPRCN
     C                   ENDIF
     C                   ENDIF
      *
      * Branch Code (Batch Header)
     C                   MOVE      TIBRCH        BTBCBH
      * RRN of memos
     C                   CLEAR                   BTRRNM
      * Retail Number Entered
     C                   MOVE      'N'           BTRNBE
      * Spread Factor
     C                   CLEAR                   BTSPFC
      * No. of items
     C                   EVAL      BTNITM = 1
      *
      * If EMU Midas-TI Interface Enhancement is switched on
      * then write Original Currency and Amount to GLJENPPD.
     C     CEU029        IFEQ      'Y'
     C                   MOVEL     TIOCCY        BTOCCY
     C                   Z-ADD     TIOAMT        BTOAMT
     C                   ELSE
     C                   eval      BTOCCY = *BLANKS
     C                   eval      BTOAMT = 0
     C                   ENDIF
      *
      * Write Record to Postings File
     C                   WRITE     @BTREMG
      **Branch*Code                                                                           208261
     C**********         MOVE      BRCA          BSBRCD                                       208261
      *
      * Update Record on summary file.
     C                   UPDATE    @BSREAI
     C                   ENDIF
     C**********         ADD       1             Index                                        208261
      * Read next record on postings summary file                                             208261
     C                   READ      GLJENSL0                               86                  208261
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  TRANS - Create suspense account.                             *
      *                                                               *
      *  Called By: Detl                                             *
      *                                                               *
      *****************************************************************
      *
     C     TRANS         BEGSR
     C                   DOU       *IN89 OR TIDLBR <> W#DLBR
     C                             OR TIDLTP <> W#DLTP
     C                             OR TIDLRF <> W#DLRF
     C                   READ      TIPOSTLA                               89
     C                   EVAL      W#NEXT = W#NEXT + 1
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
     C                   SETON                                        U7U8LR
      *
      *  Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
      * Database error report
     C                   OPEN      TI0342AU
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   CLOSE     TI0342AU
      *
     C                   DUMP
     C                   ENDIF
      *
      * Exit program
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
