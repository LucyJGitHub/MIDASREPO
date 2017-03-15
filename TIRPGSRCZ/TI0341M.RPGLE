     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas TI I/c JEG of TI with total trans postings')     *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI0341M - TI I/C Journal Entry Generation of TI Postings     *
      *            with Total Transaction Postings field              *
      *                                                               *
      *  Function:  This program is responsible for doing any journal *
      *             entry generation of TI Postings marked as pending *
      *             journal entry generation                          *
      *                                                               *
      *  Component of: TI0341                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL154             Date 13Oct14               *
      *  Prev Amend No. MD027587           Date 19Jun14               *
      *                 TI010329           Date 28May13               *
      *                 CAP207             Date 10Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13952           Date 18May07               *
      *                 235646             Date 10Nov06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 226312             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 235668             Date 07Sep05               *
      *                 BUG7951            Date 22Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6289            Date 14Mar05               *
      *                 BUG6008            Date 25Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4860            Date 03Dec04               *
      *                 BUG4969            Date 29Nov04               *
      *                 BUG4704  Re-open   Date 26Nov04               *
      *                 BUG4704            Date 11Nov04               *
      *                 BUG3957            Date 10Nov04               *
      *                 BUG4050            Date 25Aug04               *
      *                 BUG4200            Date 09Sep04               *
      *                 CTI004             Date 12Apr04               *
      *                 BUG2798            Date 27May04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 218763             Date 18Aug03               *
      *                 214492             Date 07Feb03               *
      *                 212558             Date 31Jan03               *
      *                 214454             Date 30Jan03               *
      *                 214390             Date 30Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 152041             Date 07Jan03               *
      *                 210539             Date 06Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212600             Date 27Nov02               *
      *                 212215             Date 19Nov02               *
      *                 212129             Date 14Nov02               *
      *                 211453             Date 24Oct02               *
      *                 207601             Date 03Sep02               *
      *                 211072             Date 13Aug02               *
      *                 211073             Date 26Jul02               *
      *                 211074             Date 23Jul02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003  *CREATE    Date 06Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  MD027587 - Unable to used the C for Copy and T for Template  *
      *             (Recompile)                                       *
      *  TI010329 - Posting transactions from TI did not reflect in   *
      *             MIDAS. Applied for MD026906.                      *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  BUG13952 - Duplicate key on access path when writing to      *
      *             GLJENPPD.                                         *
      *  235646  - Use different indicators when CHAIN-ing.           *
      *          - Initialize TIBATCH with TI Lower Batch No. if it   *
      *            is *BLANK.                                         *
      *  226312 - Check if DR=CR and TRPST=1, then W#HTB should be ' '*
      *         - Reset W##AMT before calling SR/RELDDT to prevent    *
      *           the Hash amounts to be doubled.                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  235668 -  Fixed to ensure unique front ofc id.               *
      *  BUG7951- Removed TRANID from the key to TIPOSTLZ.            *
      *           Condition batch closing condition on whether these  *
      *           postings are maturity postings. TRTOT = 0000001.    *
      *  CSC024 - Open Month End (Recompile)                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6289- Batch handling errors on muti-branch transactions.  *
      *         - Only increment batch number to upper range number.  *
      *         - Ignore batch size maximum for upper range batch.    *
      *  BUG6008- Set flag BTVALI to set TI postings as invalid.      *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4860 - Set up batch valid flag and use to report error    *
      *            details in TI0341P1 to handle held TI batches.     *
      *  BUG4969 - Ensure current batch is closed if parameter P#STCD *
      *            is 'S' from TIC0055.                               *
      *  BUG4704 - REOPEN - one line missing from original delivery.  *
      *  BUG4704 - Remove unnecessary setting of hold the batch flag. *
      *          - Validate account status flags in identical way to  *
      *            API Journal Entry Maintenance - GLVIMER module.    *
      *          - Keep a batch held code for debugging - W#HTBRF.    *
      *          - Do not move the current batch number on to the     *
      *            next one if this batch is not held or accepted.    *
      *  BUG3957 - Handle case when TI daily postings have a TRTOT    *
      *            of only 0000001. Shortcoming in TI.                *
      *  BUG4050 - GLJENHPD header is now maintained throughout the   *
      *            life of the batch (not just at end).               *
      *          - Add timestamp to journal header for error analysis.*
      *          - Reinstate batch closing check to close batch 3     *
      *            calls later if not all postings have been received *
      *            for batch minimum greater than 2.                  *
      *          - Add TRTOT to TRRTOT on TIDTA to test when to close *
      *            an out of balance batch with minimum *GT 002.      *
      *          - Reduce retry timeout from 3.5x wait-time to 2.5x.  *
      *  BUG4200 - Introduce new LFs TIPOSTLV (Midas-generated SP101  *
      *           postings with additional key TISEQN) and TIPOSTLW   *
      *           (Midas-generated postings keyed on TIEVRF).         *
      *           Applied fix 222857.                                 *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           Default Profit Centre from Matrix                   *
      *  BUG2798 - Add processing for GLBTNOPD.                       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  218763 - Postings being placed in the wrong batch.           *
      *  214492 - Correct batching when minimum size is set to be     *
      *           greater than the postings for one transaction.      *
      *           W#POSC is total posts in this batch and W#SEQC is   *
      *           total posts for this transaction. W#HOLD redundant. *
      *  212558 - Change keys to TIPOSTLZ and TIPOSTLY to ensure a    *
      *           unique event reference for every transaction.       *
      *  214454 - If TIBATCH refers to an existing batch which is not *
      *           in use, need to recover by adding one to the batch  *
      *           number on the dataarea and proceeding with that no. *
      *  214390 - Ensure this call of batch program picks up any      *
      *           recent change to batch min/max from TI ICD.         *
      *  152041 - Customer originated flag should be set according to *
      *           the transaction type for retail accounts.           *
      *  210539 - Initialise the Last Insert User and Last Amend User *
      *           fields when writing a new journal item.             *
      *  212600 - Add only the last 6 characters of the event         *
      *           reference after the deal type and deal reference.   *
      *  212215 - Set timestamp on GLJENPPD posting so if batch       *
      *           waiting inordinate time, can assume a posting was   *
      *           rejected by the interface, close this batch as      *
      *           held and proceed with the other transactions.       *
      *  212129 - No. of items should default to 1, so it does not    *
      *           have to be rekeyed after held.                      *
      *         - Use event reference on the posting narrative to     *
      *           retain uniqueness per transaction.                  *
      *         - Pad AOCUSTR0 key with blanks to initialise.         *
      *         - Populate TIDTA with new key for first posting.      *
      *         - 207601 uses wrong key for projection count.         *
      *         - Use W#POSC to count the postings in the batch.      *
      *  211453 - Do not close batch and open a new one if the next   *
      *           posting read has a different branch code to the     *
      *           previous for the same transaction reference.        *
      *  207601 - Correction to TRTOT field processing, as total per  *
      *           transaction erroneously includes projections.       *
      *  211072 - Do not close batch and open a new one if the next   *
      *           posting read has a different value date to the last *
      *           for the same transaction reference.                 *
      *  211073 - Replace TIPOSTL2 and L0 with views built over 17    *
      *           character event reference to ensure transaction has *
      *           unique key for access.                              *
      *  211074 - Only adjust the value date if the batch is          *
      *           succesful. Otherwise leave as date in TI for        *
      *           invesitgating cause of held status.                 *
      *  CTI003 - Transaction Postings Total Enhancements.            *
      *           If total number of postings in transaction will     *
      *           break maximum batch size, close batch and open new  *
      *           one.                                                *
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
     F*TIPOSTL0**UF***E          K DISK    INFSR(*PSSR)                         211073
     FTIPOSTLX  UF   E           K DISK    INFSR(*PSSR)                         211073
     F                                     COMMIT
      * TI Postings by projection id, ie deal branch mnemonic,
      *    deal type, deal reference, seqeunce no., value date
      *
     F***TIPOSTL8  UF   E           K DISK    INFSR(*PSSR)                                   BUG4200
     F**********                           COMMIT                                            BUG4200
     F**********                           RENAME(TIPOSTD0:TIPOSTD8)                         BUG4200
     FTIPOSTLV  UF   E           K DISK    INFSR(*PSSR)                                      BUG4200
     F                                     COMMIT                                            BUG4200
     F                                     RENAME(TIPOSTD0:TIPOSTDV)                         BUG4200
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
     F*TI0341AU*O****E             PRINTER USROPN                                            BUG4860
     FTI0341AU  O    E             PRINTER INFDS(SPOOLU)  USROPN                             BUG4860
      *   Audit Report
      *
     F*TIPOSTL2**IF   E          K DISK    INFSR(*PSSR)                         211073
     F**********                           RENAME(TIPOSTD0:TIPOSTD2)            211073
     FTIPOSTLZ  IF   E           K DISK    INFSR(*PSSR)                         211073
     F                                     RENAME(TIPOSTD0:TIPOSTDZ)            211073
      * TI Postings, select those pending journal entry gen
      *
     FTIPOSTLY  IF   E           K DISK    INFSR(*PSSR)                         207601
     F                                     RENAME(TIPOSTD0:TIPOSTDY)            207601
     F                                     PREFIX(Y_)                           207601
      * TI projections, counted to subtract from TRTOT on postings.             207601
      *                                                                         207601
     FGLJENPL6  IF   E           K DISK    INFSR(*PSSR)                                       214492
     F                                     RENAME(@BTREAK:@BTREAK6)                           214492
     F                                     PREFIX(G_)                                         214492
      * GL Journal Entry Posting view to count transaction already written                    214492
      *                                                                                       214492
     FTIPOSTLW  IF   E           K DISK    INFSR(*PSSR)                                      BUG4200
     F                                     RENAME(TIPOSTD0:TIPOSTDW)                         BUG4200
     F                                     PREFIX(W_)                                        BUG4200
      * TI Midas-generated postings.                                                         BUG4200
      *                                                                                      BUG4200
     FGLJENPL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BTREMG:@BTREMG4)
     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG13952
      *
     FGLJENHL0  UF A E           K DISK    INFSR(*PSSR)
     FGLJENHL1  IF   E           K DISK    INFSR(*PSSR)
      *                                                                                      BUG4860
     FTI0341P1  O    E             PRINTER INFDS(SPOOL1)  USROPN                             BUG4860
      *   Held Batch posting report                                                          BUG4860
     F/COPY WNCPYSRC,TIH00005
      *                                                                                     TI010329
      ** GL Journal entry header Extension File                                             TI010329
     FGLJENHQD  O    E             DISK    INFSR(*PSSR)                                     TI010329
     F                                     COMMIT                                           TI010329
      *                                                                                     TI010329
      ** GL Journal entry item Extension File                                               TI010329
     FGLJENPQD  O    E             DISK    INFSR(*PSSR)                                     TI010329
     F                                     COMMIT                                           TI010329
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *  10    - Used by LOOKUP                                       *
      *  46    - CHAIN GLJENHPD HI position - Record Found            *                       235646
      *  47    - CHAIN GLJENHPD LO postinio - Record Locked           *                       235646
      *  90-99 - Used by Standard Subroutines                         *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      *
     D PSDS           SDS
      *  Program status data structure.
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
     D SDRETR        E DS                  EXTNAME(SDRETRPD)                                  152041
      *                                                                                       152041
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
     D TIDTA         E DS           128    EXTNAME(TIDTA)
      *  External DS for stored key fields
      *
     D W#POST          DS
      * K#POST Key list
     D  TRANID                 1      4                                                       212558
     D  TIDLBR                 5      8                                                       212558
     D  TIEVRF                 9     25                                                       212558
     D  EVR6                  20     25                                                       212558
     D  TISEQN                26     28  0                                                    212558
     D  TIVALD                29     35  0                                                    212558
     D**TIDLBR**               1      4                                                       212558
     D**TIDLTP**               5      7                                                       212558
     D**TIDLRF**               8     20                                         211073
     D**TISEQN**              21     23  0                                      211073
     D**TIVALD**              24     30  0                                      211073
     D**TIEVRF**               8     24                                                211073 212558
     D**EVR6****              19     24                                                212600 212558
     D**TISEQN**              25     27  0                                             211073 212558
     D**TIVALD**              28     34  0                                             211073 212558
      *
     D W#ASOC          DS
     D  W#CBN                  1      3  0
     D  W#CBNA                 1      3
     D  ACNO                   7     16  0
     D  P#BATC                20     22  0
      *                                                                                       212600
     D BTNRDC          DS                                                                     212600
     D  RDC6                  17     22                                                       212600
      *                                                                                      BUG4704
      ** Retail Override data area DS                                                        BUG4704
     D GLREOV          DS                                                                    BUG4704
     D  WRRE01                 1      1                                                      BUG4704
     D  WRRE02                 2      2                                                      BUG4704
     D  WRRE03                 3      3                                                      BUG4704
     D  WRRE04                 4      4                                                      BUG4704
     D  WRRE05                 5      5                                                      BUG4704
     D  WRRE06                 6      6                                                      BUG4704
     D  WRRE07                 7      7                                                      BUG4704
     D  WRRE08                 8      8                                                      BUG4704
     D  WRRE09                 9      9                                                      BUG4704
     D  WRRE10                10     10                                                      BUG4704
      *
     D C#CUST          C                   CONST('Trade Innovation')
     D C#BTIU          C                   CONST('Batch in use by TI')
      *
     D NumbOfCurr      C                   CONST(200)
     D CurrArr         S              3    DIM(NumbOfCurr)
     D TotalsDS        DS                  OCCURS(NumbOfCurr)
     D  TotCredit              1     13  0
     D  TotDebit              14     26  0
      *                                                                                      BUG4860
     D SPOOL1          DS                                                                    BUG4860
      ***  File Information Data Structure for TI0341P1                                      BUG4860
     D  SFILE1                83     92                                                      BUG4860
     D  SFNUM1               123    124B 0                                                   BUG4860
     D  OFLLN1               188    189B 0                                                   BUG4860
     D  PRTLN1               367    368B 0                                                   BUG4860
      *                                                                                      BUG4860
     D SPOOLU          DS                                                                    BUG4860
      ***  File Information Data Structure for TI0341AU                                      BUG4860
     D  SFILEU                83     92                                                      BUG4860
     D  SFNUMU               123    124B 0                                                   BUG4860
      *                                                                                       212215
     D WSysTmSt        S             26Z                                                      212215
     D WCompTmSt       S             26Z                                                      212215
     D WCompData       S             26    DIM(1) CTDATA PERRCD(1)                            212215
      *
     D WWKEY4          S             10A                                                      CGL029
     D WACODA          S             10A                                                      CGL029
                                                                                              CGL029
     D HLDRSN          S             60    DIM(10) CTDATA PERRCD(1)                          BUG4860
      *                                                                                      BUG4860
      *****************************************************************
      *  P R O G R A M     S T A R T                                  *
      *****************************************************************
      *
      * Program entry
      *
     C     *ENTRY        PLIST
     C     W#STCD        PARM      W#STCD        P#STCD            1
     C                   PARM                    P#BATN            3
      *
     C                   EXSR      INIT
      *
     C                   EXSR      DETL
      *
      * otherwise, only close the current batch if it has postings
      *
      * Reload details for batch header and flag batch as held
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
      *  If this is the first new entry to a previously unclosed batch
      *  then set pointer to next available posting.
     C
     C     W#ONCE        IFEQ      'N'
     C     BRRVVD        ANDEQ     'O'
     C*****K#POST        SETLL     TIPOSTL2                                     211073
     C*****K#POST        SETLL     TIPOSTLZ                                           211073 BUG7951
     C     K#ULPOST      SETLL     TIPOSTLZ                                                  BUG7951
     C                   ENDIF
      *
      * Read the first posting
     C**********         READ      TIPOSTL2                               89    211073
     C                   READ      TIPOSTLZ                               89    211073
      * When read a new record, check no. of projections for that transaction.  207601
     C                   MOVEL     TRANID        Y_TRANID                                     214492
     C                   MOVEL     TIEVRF        Y_TIEVRF                                     214492
     C                   EXSR      TRSUB                                        207601
      *
      *  If the key fields do not match after the re-load then close the
      *  batch and hold.
     C
     C     W#ONCE        IFEQ      'N'
     C     BRRVVD        ANDEQ     'O'
     C*****TIDLBR        IFNE      BTIBCA                                       211453
     C*****TIDLTP        ORNE      TRDLTP                                       211453
     C     TIDLTP        IFNE      TRDLTP                                       211453
     C*****TRANID        ORNE      TRRNID                                             212558 BUG7951
     C*****TIDLRF        ORNE      TRDLRF                                       211073
     C     TIEVRF        ORNE      TREVRF                                       211073
     C*****TIVALD        ORNE      TRVALD                                       211072
      *                                                                                       214492
     C     W#POSC        IFGE      TIMNBS                                                     214492
     C                   EXSR      CLOSE
     C                   ELSE                                                                 214492
     C     *LOCK         IN        TIDTA                                                      214492
     C                   MOVE      TRTOT         TRRTOT                                      BUG4050
     C                   MOVE      TRANID        TRRNID                                       214492
     C                   MOVE      TIDLTP        TRDLTP                                       214492
     C                   MOVE      TIDLRF        TRDLRF                                       214492
     C                   MOVE      TIEVRF        TREVRF                                       214492
     C                   MOVE      TIVALD        TRVALD                                       214492
     C                   MOVE      TISEQN        TRSEQN                                       214492
     C                   OUT       TIDTA                                                      214492
     C                   END                                                                  214492
      *                                                                                       214492
     C                   ENDIF
     C                   ENDIF
      *
      * If there are no additional postings
     C     *IN89         IFEQ      *ON
      *
      **If*postings*counter*is*zero*then*there*is*an*empty*new                               BUG4969
      **batch*so*return*with*a*blank*status*code.                                            BUG4969
      * If postings counter is zero and no more records found in TIPOSTLZ view,              BUG4969
      * then there are no postings to process in this call.                                  BUG4969
     C     W#POSC        IFEQ      *ZERO
     C     P#STCD        IFNE      'S'
     C                   MOVE      *BLANKS       W#STCD
     C                   ENDIF
      **********                                                                     BUG4704 BUG4860
     C*****W#HTBRF       IFGT      0                                                 BUG4704 BUG4860
     C**********         DUMP                                                        BUG4704 BUG4860
     C**********         END                                                         BUG4704 BUG4860
      **********                                                                     BUG4704 BUG4860
     C                   SETON                                        LR
     C                   RETURN
      *                                                                                       212215
      * If postings counter is not zero then batch details exist but are no                   212215
      * further postings on TIPOSTLZ to process.                                              212215
     C                   ELSE                                                                 212215
      *                                                                                       212215
      * Compare timestamp of last posting read, and if generated from more                    212215
      **than*three*calls*ago*of*this*program,*then*assume*the*remaining               212215 BUG4050
      * than two calls ago of this program, then assume the remaining                        BUG4050
      * posting(s) were rejected from the interface and will never arrive.                    212215
      * Close batch as held and free processing for the next transaction.                     212215
     C*****TIPRWT*       MULT      210           TIWAIT            5 0                212215 BUG4050
     C     TIPRWT        MULT      150           TIWAIT            5 0                       BUG4050
     C                   ADDDUR    TIWAIT:*S     WCompTmSt                                    212215
      *                                                                                       212215
     C                   CALL      'ZAGENTS'                                                  212215
     C                   PARM                    WSysTmSt                                     212215
      *                                                                                       212215
      * Handle unconditionally if batch minimum size is 002, if greater then                  214492
      * we maw need to wait for other transactions to make up the minimum                     214492
      * batch size. So only fail if this transaction is incomplete and has                    214492
      * waited so long.                                                                       214492
      *                                                                                       214492
     C     WCompTmSt     IFLT      WSysTmSt                                                   212215
     C     W#CBN         ANDNE     TIURBN                                                     214492
     C     TIMNBS        IFLE      2                                                          214492
      *  Call subroutine TOTALS to check if debit equals credit.                             BUG4969
     C                   EXSR      TOTALS                                                    BUG4969
     C                   EXSR      CLOSE                                                      212215
     C                   ELSE                                                                 214492
     C*****W#SEQC        IFLT      TRPST                                               214492 218763
     C**********         EXSR      CLOSE                                               214492 218763
     C**********         END                                                           214492 218763
      * Check no of records expected for transaction in TIDTA.                               BUG4050
     C                   Z-ADD     TRRTOT        TRTOT                                       BUG4050
     C                   MOVEL     TRRNID        Y_TRANID                                    BUG4050
     C                   MOVEL     TREVRF        Y_TIEVRF                                    BUG4050
     C                   EXSR      TRSUB                                                     BUG4050
      *                                                                                      BUG4050
      * If after two more calls of TI0341M there are still less postings for this            BUG4050
      * transaction than were sent by TI, then assume that a posting has been rejected by    BUG4050
      * the interface (TI0310M) and close this batch as held (and out of balance).           BUG4050
      *                                                                                      BUG4050
     C     W#SEQC        IFLT      TRPST                                                     BUG4050
      *  Call subroutine TOTALS to check if debit equals credit.                             BUG4969
     C                   EXSR      TOTALS                                                    BUG4969
     C                   EXSR      CLOSE                                                     BUG4050
     C                   END                                                                 BUG4050
     C                   END                                                                  214492
     C                   END                                                                  212215
      *                                                                                       212215
     C*****W#HTBRF       IFGT      0                                                 BUG4704 BUG4860
     C**********         DUMP                                                        BUG4704 BUG4860
     C**********         END                                                         BUG4704 BUG4860
      **********                                                                     BUG4704 BUG4860
     C     P#STCD        IFNE      'S'                                                       BUG4969
     C                   SETON                                        LR                      212215
     C                   RETURN                                                               212215
     C                   ENDIF                                                               BUG4969
     C                   ENDIF
      *
     C                   ELSE
      *
      * Otherwise, process the additional postings
     C     *IN89         DOWEQ     *OFF
      *
      * If next record is a different transaction then
      * return.
      * Do not return if comparing to blank data, then next transaction never processed.     BUG4969
     C     W#SEQC        IFNE      *ZERO
     C*****TIDLBR        IFNE      TIDLBR1                                      211453
     C*****TIDLTP        ORNE      TIDLTP1                                      211453
     C     TIDLTP        IFNE      TIDLTP1                                      211453
     C     TIDLTP1       ANDNE     *BLANKS                                                   BUG4969
     C*****TIDLRF        ORNE      TIDLRF1                                      211073
     C*****TRANID        ORNE      TRANID1                                            212558 BUG7951
     C*****TRANID1       ANDNE     *BLANKS                                           BUG4969 BUG7951
     C     TIEVRF        ORNE      TIEVRF1                                      211073
     C     TIEVRF1       ANDNE     *BLANKS                                                   BUG4969
     C*****TIVALD        ORNE      TIVALD1                                      211072
      *
      ** Populate TIDTA data area with key fields for
      ** re-load.
     C     *DTAARA       DEFINE                  TIDTA
     C     *LOCK         IN        TIDTA
     C                   MOVE      TRTOT         TRRTOT                                      BUG4050
     C                   MOVE      TRANID1       TRRNID                                       212558
     C                   MOVE      TIDLTP1       TRDLTP
     C                   MOVE      TIDLRF1       TRDLRF
     C                   MOVE      TIEVRF1       TREVRF                         211073
     C                   MOVE      TIVALD1       TRVALD
     C                   MOVE      TISEQN1       TRSEQN
     C                   OUT       TIDTA
      *
      * Commit changes within this call to the program
     C                   COMMIT
      *
     C*****W#HTBRF       IFGT      0                                                 BUG4704 BUG4860
     C**********         DUMP                                                        BUG4704 BUG4860
     C**********         END                                                         BUG4704 BUG4860
      * End
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *                                                                                       212129
      * If first record, W#SEQC=0 update TIDTA with current transaction ref.                  212129
     C                   ELSE                                                                 212129
      *                                                                                       212129
     C     *LOCK         IN        TIDTA                                                      212129
     C                   MOVE      TRTOT         TRRTOT                                      BUG4050
     C                   MOVE      TRANID        TRRNID                                       212558
     C                   MOVE      TIDLTP        TRDLTP                                       212129
     C                   MOVE      TIDLRF        TRDLRF                                       212129
     C                   MOVE      TIEVRF        TREVRF                                       212129
     C                   MOVE      TIVALD        TRVALD                                       212129
     C                   MOVE      TISEQN        TRSEQN                                       212129
     C                   OUT       TIDTA                                                      212129
     C                   ENDIF
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
     C                   DOU       NOT %EQUAL(GLJENPL1)                                     BUG13952
     C                   ADD       1             W#POSC
     C     K#GLJENP      SETLL     GLJENPL1                                                 BUG13952
     C                   ENDDO                                                              BUG13952
      ***Set*sequence*counter*monitor                                                         214492
     C**********         Z-ADD     W#SEQC        W#HOLD                                       214492
      *  Set sequence counter for this batch
     C                   ADD       1             W#SEQC
      *
      *  If next Transaction Total Postings breaks the Maximum
      *  Batch Size then close the batch.
     C     W#SEQC        IFEQ      1
     C*****W#MAX         ADD       TRTOT         W#MAX                          207601
     C     W#MAX         ADD       TRPST         W#MAX                          207601
     C     W#MAX         IFGE      TIMXBS
     C     W#STCD        ANDNE     'S'
     C     W#POSC        ANDNE     1
     C**********         EVAL      W#SEQC = TRTOT                               207601
     C**********         EVAL      W#SEQC = TRPST                                      207601 214492
     C                   EXSR      CLOSE
     C**********         Z-ADD     *ZERO         W#MAX                                        214492
     C                   Z-ADD     1             W#POSC
     C                   Z-ADD     1             W#SEQC
     C                   ENDIF
     C                   ENDIF
      *
      *  Validate fields
     C                   EXSR      VALID
      *
      *  Write postings to Journal Entry Postings File
     C                   EXSR      GLJENP
      *
      *  If this is a new batch, then write header and flag as in use
      *  This writes an empty header with zero hash totals and no. of items = 1.             BUG4050
     C     W#POSC        IFEQ      1
     C                   EXSR      GLJENH
     C                   ENDIF
      *
      *  Update the posting status to 'JEG'
     C     MIDGEN        IFEQ      'N'
     C*****K#POST        CHAIN     TIPOSTL0                           85        211073
     C     K#POST        CHAIN     TIPOSTLX                           85        211073
      *
     C     *IN85         IFEQ      *ON
     C                   MOVEL     W#POST        DBKEY
     C**********         MOVEL     'TIPOSTL0'    DBFILE                         211073
     C                   MOVEL     'TIPOSTLX'    DBFILE                         211073
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Update the posting status to 'JEG'
     C                   MOVE      'JEG'         PSTS
     C                   UPDATE    TIPOSTD0
     C                   ELSE
     C*****K#BCUR        CHAIN     TIPOSTL8                           85                     BUG4200
     C     K#BCUR        CHAIN     TIPOSTLV                           85                     BUG4200
      *
     C     *IN85         IFEQ      *ON
     C                   MOVEL     W#POST        DBKEY
     C**********         MOVEL     'TIPOSTL8'    DBFILE                                      BUG4200
     C                   MOVEL     'TIPOSTLV'    DBFILE                                      BUG4200
     C                   Z-ADD     8             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Update the posting status to 'JEG'
     C                   MOVE      'JEG'         PSTS
     C**********         UPDATE    TIPOSTD8                                                  BUG4200
     C                   UPDATE    TIPOSTDV                                                  BUG4200
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
      *                                                                                      BUG4050
      *  New call to maintain the header running totals as each posting is processed.        BUG4050
     C                   EXSR      GLJENHU                                                   BUG4050
      *
     C     *DTAARA       DEFINE    TI0340        W#034T          128
     C                   IN        W#034T
     C                   MOVEL     W#034T        W#0340            5
      *
      *  Call subroutine TOTALS to check if debit equals credit.
      *  This subroutine will set the flag DebEQCred
     C                   EXSR      TOTALS
      *
      *  If batch is at maximum then close batch
     C     W#POSC        IFEQ      TIMXBS
     C     W#STCD        ANDNE     'S'
      *
      * Close batch if batch is past minimum size and
      * total debits = total credits for all currencies
      * & transaction postings counter equals
      * transaction postings total
      * and this is not the final batch
      * and this is not a COB generated maturity posting, in which case it is covered        BUG7951
      * by the following TRPST=1 condition.                                                  BUG7951
      *                                                                                       214492
     C     W#POSC        ORGE      TIMNBS
     C*****DebEQCred     ANDEQ     'Y'                                                        214492
     C*****W#SEQC        ANDEQ     TRTOT                                        207601
     C*****W#SEQC        ANDEQ     TRPST                                               207601 212129
     C*****W#POSC        ANDEQ     TRPST                                               212129 214492
     C     W#SEQC        ANDGE     TRPST                                                      214492
     C     W#CBN         ANDNE     TIURBN
     C     TRPST         ANDGT     1                                                         BUG7951
      *                                                                                      BUG3957
      * Close the batch if TRPST=1 and the batch is balanced and                             BUG3957
      * past minimum batch size.                                                             BUG3957
      *                                                                                      BUG3957
     C     W#POSC        ORGE      TIMNBS                                                    BUG3957
     C     TRPST         ANDEQ     1                                                         BUG3957
     C     DebEQCred     ANDEQ     'Y'                                                       BUG3957
      *                                                                                      BUG3957
     C                   EXSR      CLOSE
     C                   ELSE
     C*****W#SEQC        IFEQ      TRTOT                                        207601
     C     W#SEQC        IFEQ      TRPST                                        207601
     C                   Z-ADD     *ZERO         W#SEQC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      TRANID        TRANID1                                      212558
     C                   MOVE      TIDLBR        TIDLBR1
     C                   MOVE      TIDLTP        TIDLTP1
     C                   MOVE      TIDLRF        TIDLRF1
     C                   MOVE      TIEVRF        TIEVRF1                        211073
     C                   MOVE      TIVALD        TIVALD1
     C                   MOVE      W#SEQC        TISEQN1
      *
      * Get next posting
     C**********         READ      TIPOSTL2                               89    211073
     C                   READ      TIPOSTLZ                               89    211073
      * When read a new record, check no. of projections for that transaction.  207601
     C                   MOVEL     TRANID        Y_TRANID                                     214492
     C                   MOVEL     TIEVRF        Y_TIEVRF                                     214492
     C                   EXSR      TRSUB                                        207601
      *
     C                   ENDDO
      *
     C                   ENDIF
      * If last batch of the day then set flag to show this.
     C     W#0340        IFEQ      'STOP'
     C                   MOVE      'S'           W#STCD
      *                                                                                       226312
      ** Reset hash Total Amount                                                              226312
      *                                                                                       226312
     C                   Z-ADD     *ZERO         W##AMT                                       226312
      *                                                                                       226312
     C                   EXSR      RELDDT
     C                   EXSR      TOTALS
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
     C                   MOVE      *BLANKS       DESC             60                         BUG4860
     C                   Z-ADD     *ZERO         W                 2 0                       BUG4860
      * W#HTB stays on while processing the rest of the batch.                               BUG4860
      * W#HTBRF is reset per posting (and unaffected by RELDDT/VALID2 batch reload).         BUG4860
     C                   Z-ADD     *ZERO         W#HTBRF                                     BUG4860
     C                   MOVE      'Y'           PVALI             1                         BUG6008
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
     C                   Z-ADD     1             W#HTBRF           2 0                       BUG4704
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Validate Customer
     C**********         MOVEL(P)  CNUM          WWKY10                                       212129
     C                   MOVE      *BLANKS       WWKY10                                       212129
     C                   MOVEL     CNUM          WWKY10                                       212129
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG    '    WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM                    WWKY10           10
     C                   PARM      *BLANKS       WWKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     2             W#HTBRF                                     BUG4704
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
     C                   Z-ADD     3             W#HTBRF                                     BUG4704
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Validate Account Code
     C                   MOVE      ACOD          WWKEY4
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG    '    WWRTCD            7            B:Return Cd
     C                   PARM      '*KEY    '    WWOPTN            7            I:Option
     C**********         PARM                    WWKEY4            4            I:Account CodeCGL029
     C                   PARM                    WWKEY4                                       CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                          O:Format
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     4             W#HTBRF                                     BUG4704
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   MOVE      ACOD          WACODA
     C                   ENDIF
      *
      * Get Account
     C     K#ACCN        CHAIN     ACCNT                              88
     C     *IN88         IFEQ      *ON
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     5             W#HTBRF                                     BUG4704
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
     C                   Z-ADD     6             W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Value date after date account opened?
     C     MTIVD         IFLT      DACO
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     7             W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL
     C                   ENDIF
      *                                                                           211074
      * Ensure W#BACK is reset for every posting read                             211074
     C                   Z-ADD     0             W#BACK                           211074
      *
      **Retail*a/c?****************************************************                      BUG4704
     C*****ACNO*         IFNE      *ZERO                                                     BUG4704
      *
      *  Back valued posting within back value period?
     C     MTIVD         IFLT      BJRDNB
      *
     C     BJRDNB        SUB       MTIVD         W#BACK
     C     W#BACK        IFGT      BJBVPD
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     8             W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
      *
      *  Check status of retail account?
     C     TIREAS        IFEQ      'Y'
     C     ATYP          ANDEQ     'R'                                                       BUG4704
      *
      ****Bit*0*-*Refer*Debits?****************************************                      BUG4704
      ****Bit*1*-*Refer Credits?***************************************                      BUG4704
      ****Bit*2*-*Block Debits?****************************************                      BUG4704
      ****Bit*3*-*Block Credits?***************************************                      BUG4704
      *   Bit 4 - Account is Inactive?
      *   Bit 6 - Bankrupt/Liquidation?
      *   Bit 7 - Bad Debt?
     C**********         TESTB     '467'         RETB                 87                     BUG4704
     C                   TESTB     '4'           RETB                     87                 BUG4704
     C******IN87         IFEQ      *OFF                                                      BUG4704
     C     *IN87         IFEQ      *ON                                          B02          BUG4704
     C     WRRE05        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     9             W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL
     C                   ENDIF
      *                                                                                      BUG4704
     C                   TESTB     '6'           RETB                     87                 BUG4704
     C     *IN87         IFEQ      *ON                                          B02          BUG4704
     C     WRRE07        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB                                       BUG4704
     C                   Z-ADD     10            W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL                                                    BUG4704
     C                   ENDIF                                                  E02          BUG4704
      *                                                                                      BUG4704
     C                   TESTB     '7'           RETB                     87                 BUG4704
     C     *IN87         IFEQ      *ON                                          B02          BUG4704
     C     WRRE08        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB                                       BUG4704
     C                   Z-ADD     11            W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL                                                    BUG4704
     C                   ENDIF                                                  E02          BUG4704
     C                   ENDIF                                                  E01          BUG4704
      *
      *  Check status of retail account, or GL account with CGL002 on.                       BUG4704
     C     ATYP          IFEQ      'R'                                          B01          BUG4704
     C     ATYP          OREQ      'G'                                                       BUG4704
     C     CGL002        ANDEQ     'Y'                                                       BUG4704
      *                                                                                      BUG4704
      *   Bit 0 - Refer Debits?                                                              BUG4704
      *   Bit 1 - Refer Credits?                                                             BUG4704
      *   Bit 2 - Block Debits?                                                              BUG4704
      *   Bit 3 - Block Credits?                                                             BUG4704
      *                                                                                      BUG4704
     C     TIDCIN        IFEQ      'D'
     C**********         TESTB     '02'          RETB                 87                     BUG4704
     C                   TESTB     '0'           RETB                     87                 BUG4704
     C******IN87         IFEQ      *OFF                                                      BUG4704
     C     *IN87         IFEQ      *ON                                          B03          BUG4704
     C     WRRE01        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     12            W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL
     C                   ENDIF
      *                                                                                      BUG4704
     C                   TESTB     '2'           RETB                     87                 BUG4704
     C     *IN87         IFEQ      *ON                                          B03          BUG4704
     C     WRRE03        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB                                       BUG4704
     C                   Z-ADD     13            W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL                                                    BUG4704
     C                   ENDIF                                                  E03          BUG4704
     C                   ENDIF
      *
     C     TIDCIN        IFEQ      'C'
     C**********         TESTB     '13'          RETB                 87                     BUG4704
     C                   TESTB     '1'           RETB                     87                 BUG4704
     C******IN87         IFEQ      *OFF                                                      BUG4704
     C     *IN87         IFEQ      *ON                                          B03          BUG4704
     C     WRRE02        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     14            W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL
     C                   ENDIF
      *                                                                                      BUG4704
     C                   TESTB     '3'           RETB                     87                 BUG4704
     C     *IN87         IFEQ      *ON                                          B03          BUG4704
     C     WRRE04        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB                                       BUG4704
     C                   Z-ADD     15            W#HTBRF                                     BUG4704
     C                   MOVE      'N'           PVALI                                       BUG6008
     C                   GOTO      ENDVAL                                                    BUG4704
     C                   ENDIF                                                  E03          BUG4704
     C                   ENDIF
      *
     C                   ENDIF
     C**********         ENDIF                                                               BUG4704
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
      * Keep date as from TI if it is invalid (batch will be held).               211074
     C     ATYP          IFEQ      'R'
     C     MTIVD         ORLT      DACO                                           211074
     C     W#BACK        ORGT      BJBVPD                                         211074
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
     C*****TIDLTP        CAT       TIDLRF        BTNRDC                                       212129
     C**********         MOVEL     TIEVRF        BTNRDC                                212129 212600
     C     TIDLTP        CAT       TIDLRF        BTNRDC                                       212600
     C                   MOVEL     EVR6          RDC6                                         212600
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
     C*                                                                                       152041
     C     BTACTY        IFEQ      'R'                                                        152041
     C     BTTRTY        ANDNE     *ZERO                                                      152041
     C* Access Retail Transaction types for the customer originated Ind                       152041
     C*                                                                                       152041
     C                   CALL      'AORETRR0'                                                 152041
     C                   PARM      '*MSG    '    WWRTCD                                       152041
     C                   PARM      '*KEY    '    WWOPTN                                       152041
     C                   PARM      BTTRTY        WWKEY5            5                          152041
     C     SDRETR        PARM      *BLANKS       DSFDY                                        152041
      *  Error?                                                                               152041
     C     WWRTCD        IFNE      *BLANKS                                                    152041
     C**********         MOVE      'Y'           W#HTB                                152041 BUG4704
     C                   MOVE      'N'           BTCOIN                                      BUG4704
     C                   ELSE                                                                 152041
     C* Assign work field to file field values.                                               152041
     C                   MOVE      A1COIN        BTCOIN                                       152041
     C                   ENDIF                                                                152041
     C                   ENDIF                                                                152041
     C*                                                                                       152041
      * SWIFT Common Reference
     C                   CLEAR                   BTSWCR
      * Profit Centre
     C                   CLEAR                   BTPRCN
                                                                                              CTI004
      ** The following lines of defaulting the profit centre                                  CTI004
      ** are made redundant when CTI004 is on                                                 CTI004
      *
      *
     C*****ATYP*         IFEQ      'N'                                                        CTI004
     C*****ATYP*         OREQ      'R'                                                        CTI004
     C*****@NOSTR        OREQ      'Y'                                                        CTI004
     C*****PRFC*         IFNE      *BLANKS                                                    CTI004
     C**********         MOVE      PRFC          BTPRCN                                       CTI004
     C**********         ENDIF                                                                CTI004
     C**********         ENDIF                                                                CTI004
      *
      **Default*profit*centre*using*TI*ICD*if*PRFC*is*blank*and*AA*is*OFF                     CTI004
     C*****BTPRCN        IFEQ      *BLANKS                                                    CTI004
     C*****BGN0ST        ANDNE     'Y'                                                        CTI004
     C**********         MOVE      TIPRFC        BTPRCN                                       CTI004
     C**********         ENDIF                                                                CTI004
      *
      **Default*profit*centre*using*default*matrix*if*PRFC*is*blank*and AA is ON              CTI004
     C*****BTPRCN        IFEQ      *BLANKS                                                    CTI004
     C*****BGN0ST        ANDEQ     'Y'                                                        CTI004
                                                                                              CTI004
     C                   MOVE      ASOC          CUST
                                                                                              CTI004
     C                   EVAL      DEPT1 = TIDEPT                                             CTI004
     C                   EVAL      USER = *BLANKS                                             CTI004
                                                                                              CTI004
     C                   CALLB     'AOPRFMR0'
     C                   PARM                    RTCD              1
     C                   PARM      TIBOOK        BOOK              2            Book Code
     C                   PARM      TIDLTP        TRTP              5            TransactonType
     C                   PARM      *BLANKS       SUTP              2            Sub Type
     C                   PARM      BRCA          BRAN              3            Branch Code
     C**********         PARM      *BLANKS       DEPT1             3            Deptment Code CTI004
     C**********         PARM      ##USER        USER             10            User          CTI004
     C                   PARM                    DEPT1             3                          CTI004
     C                   PARM                    USER             10                          CTI004
     C                   PARM      BBACOC        ACOF              2            AccountOfficer
     C                   PARM                    CUST              6            CustomerNumber
     C                   PARM                    DPRFC             4            Profit Centre
      *
     C     RTCD          IFNE      '0'
     C     DPRFC         OREQ      FTUAPC
     C     BGN0ST        ANDEQ     'Y'                                                        CTI004
     C                   MOVE      TIPRFC        BTPRCN
     C                   ELSE
     C                   MOVE      DPRFC         BTPRCN
     C                   ENDIF
     C**********         ENDIF                                                                CTI004
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
     C**********         CLEAR                   BTNITM                                       212129
     C                   Z-ADD     1             BTNITM                                       212129
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
      *                                                                                       212215
      * Set Timestamp on TI journal entry record.                                             212215
     C                   CALL      'ZAGENTS'                                                  212215
     C                   PARM                    BTTMST                                       212215
      *                                                                                      BUG4860
      * Print details of any posting giving rise to a held batch                             BUG4860
     C     W#HTBRF       IFGE      6                                                         BUG4860
     C     W#HTBRF       ANDLE     15                                                        BUG4860
     C                   EVAL      W = (W#HTBRF-5)                                           BUG4860
     C                   EVAL      DESC = HLDRSN(W)                                          BUG4860
     C                   OPEN      TI0341P1                                                  BUG4860
     C                   EXSR      RCFP1                                                     BUG4860
     C                   WRITE     HEADP1                                                    BUG4860
     C                   WRITE     PSTERROR                                                  BUG4860
     C                   WRITE     TRAILP1                                                   BUG4860
     C                   CLOSE     TI0341P1                                                  BUG4860
     C                   ENDIF                                                               BUG4860
      * Reverse/Void Ind.                                                                    BUG6008
     C                   MOVE      PVALI         BTVALI                                      BUG6008
     C/COPY WNCPYSRC,TIH00006
      *
      * Write Record
     C                   WRITE     @BTREMG
      ** Write Records to extension file GLJENPQD                                           TI010329
      *                                                                                     TI010329
     C                   EVAL      IQBTCH = BTBTNB                                          TI010329
     C                   EVAL      IQBRCD = BTIBCA                                          TI010329
     C                   EVAL      IQBITM = BTBINB                                          TI010329
     C                   EVAL      IQFRID = 'APCTRANVU' + BTBTNB                            TI010329
     C                   WRITE     GLJEPQD0                                                 TI010329
     C/COPY WNCPYSRC,TIH00007
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
      *           This SR is to be called as before to set up a new   *                      BUG4050
      *           header with zero hash totals (*IN46 ON) to start    *                      BUG4050
      *           the batch and once again when closing the batch     *                      BUG4050
      *           (*IN46 OFF) to complete the figures and release     *                      BUG4050
      *           the header. GLJENHU is called separatey to maintain *                      BUG4050
      *           interim totals as postings are processed.           *                      BUG4050
      *                                                               *
      *  Called By: DETL                                              *
      *           : & CLOSE                                           *                      BUG4050
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
     C     GLJENH        BEGSR
      *
      * Batch Number
     C                   MOVE      W#CBN         BRBTNB
      *
      * If closing the header then find the correct batch
     C*****BRBTNB*       CHAIN     @BRREAG                            4646                    235646
     C     BRBTNB        CHAIN     @BRREAG                            4647                    235646
      * Branch
     C                   MOVE      TIBRCH        BRBCDA
      * Department
     C                   MOVE      TIDEPT        BRDPCD
      * Workstation id
      *
      * Default Workstation ID correctly
      *
     C                   CLEAR                   BRWSID
     C                   MOVEL     'TI-BATCH'    BRWSID
      * Hash amount
     C     W##AMT        DIV       1000          Amount           15 3
     C*
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
      *                                                                                       235668
      ** Front ofc id                                                                         235668
      *                                                                                       235668
     C                   EVAL      BRFRNT = 'APCTRANVU' + BRBTNB                              235668
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
     C     *IN46         IFEQ      *ON
     C     W#STCD        IFNE      'F'
     C                   MOVE      'Y'           BRBIUF
     C                   MOVE      'O'           BRRVVD
     C                   MOVEL     C#BTIU        BRBDES
     C                   ELSE
     C                   MOVE      'N'           BRBIUF
     C                   MOVE      ' '           BRRVVD
     C                   MOVE      C#CUST        BRBDES
     C                   ENDIF
      *
     C     W#HTB         IFEQ      'Y'
     C                   MOVE      'H'           BRBTSF
     C                   ELSE
     C                   MOVE      ' '           BRBTSF
     C                   ENDIF
      *                                                                                      BUG4050
      * Set Timestamp on TI journal header record.                                           BUG4050
     C                   CALL      'ZAGENTS'                                                 BUG4050
     C                   PARM                    BRTMST                                      BUG4050
      *
     C                   WRITE     @BRREAG
      *                                                                                      BUG2798
     C                   MOVEL     BRBTNB        B3BTNB                                      BUG2798
     C                   MOVEL     'N'           B3DUMP                                      BUG2798
     C                   WRITE     GLBTNOD0                                                  BUG2798
      *                                                                                     TI010329
      ** Populate extension file                                                            TI010329
      *                                                                                     TI010329
     C                   EVAL      HQBTCH = BRBTNB                                          TI010329
     C                   EVAL      HQBRCD = BRBCDA                                          TI010329
     C                   EVAL      HQFRID = BRFRNT                                          TI010329
     C                   EVAL      HQJETP = 'R'                                             TI010329
     C                   WRITE     GLJEHQD0                                                 TI010329
      *
     C                   ELSE
     C                   MOVE      'N'           BRBIUF
     C                   MOVE      ' '           BRRVVD
     C     W#HTB         IFEQ      'Y'
     C                   MOVE      'H'           BRBTSF
     C                   ELSE
     C                   MOVE      'A'           BRBTSF
     C                   ENDIF
      *                                                                                      BUG4050
      * Set Timestamp on TI journal header record.                                           BUG4050
     C                   CALL      'ZAGENTS'                                                 BUG4050
     C                   PARM                    BRTMST                                      BUG4050
     C                   UPDATE    @BRREAG
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN46
     C                   MOVE      *OFF          *IN47                                        235646
      *
     C                   ENDSR
      *****************************************************************                      BUG4050
      *                                                               *                      BUG4050
      *  GLJENHU - Update the Header with running totals as           *                      BUG4050
      *            individual postings are processed. Batch status    *                      BUG4050
      *            stays as 'Held' and Batch-in-use flag as 'Y'.      *                      BUG4050
      *                                                               *                      BUG4050
      *  Called By: DETL                                              *                      BUG4050
      *  Calls    : None.                                             *                      BUG4050
      *                                                               *                      BUG4050
      *****************************************************************                      BUG4050
     C     GLJENHU       BEGSR                                                               BUG4050
      *                                                                                      BUG4050
      * Batch Number                                                                         BUG4050
     C                   MOVE      W#CBN         BRBTNB                                      BUG4050
      *                                                                                      BUG4050
      * To update the header find the correct batch number                                   BUG4050
     C*****BRBTNB*       CHAIN     @BRREAG                            4646           BUG4050  235646
     C     BRBTNB        CHAIN     @BRREAG                            4647                    235646
      * Branch                                                                               BUG4050
     C                   MOVE      TIBRCH        BRBCDA                                      BUG4050
      * Department                                                                           BUG4050
     C                   MOVE      TIDEPT        BRDPCD                                      BUG4050
      * Workstation id                                                                       BUG4050
      *                                                                                      BUG4050
      * Default Workstation ID correctly                                                     BUG4050
      *                                                                                      BUG4050
     C                   CLEAR                   BRWSID                                      BUG4050
     C                   MOVEL     'TI-BATCH'    BRWSID                                      BUG4050
      * Hash amount                                                                          BUG4050
     C     W##AMT        DIV       1000          Amount           15 3                       BUG4050
     C*                                                                                      BUG4050
     C                   CALLB     'ZZADD'                                                   BUG4050
     C                   PARM                    Amount                                      BUG4050
     C                   PARM      *ZERO         IntPart          15 0                       BUG4050
     C                   PARM      *ZERO         DecPart           3 0                       BUG4050
      *                                                                                      BUG4050
     C                   Z-ADD     IntPart       BRHICC                                      BUG4050
     C                   Z-ADD     DecPart       BRHDCC                                      BUG4050
     C                   Z-ADD     IntPart       BRHIIN                                      BUG4050
     C                   Z-ADD     DecPart       BRHDIN                                      BUG4050
      * Hash Item Number                                                                     BUG4050
     C                   Z-ADD     W#POSC        BRHINC                                      BUG4050
     C                   Z-ADD     W#POSC        BRHINI                                      BUG4050
      *                                                                                      BUG4050
      * Batch is now flagged as in use until fully closed                                    BUG4050
      * Shadow Post Indicator                                                                BUG4050
     C                   MOVE      'N'           BRSHPI                                      BUG4050
      * Multiple Branch Batch                                                                BUG4050
     C                   MOVE      'Y'           BRMBRB                                      BUG4050
      * Batch Description                                                                    BUG4050
     C                   MOVE      *BLANKS       BRBDES                                      BUG4050
     C                   MOVEL     C#CUST        BRBDES                                      BUG4050
      * Type of Journal Entry                                                                BUG4050
     C                   MOVEL     'J'           BRTOJE                                      BUG4050
      *                                                                                      BUG4050
     C                   CLEAR                   BRRAPI                                      BUG4050
      *                                                                                      BUG4050
      * This flag now used as work field to inidicate an open                                BUG4050
      * batch                                                                                BUG4050
     C                   CLEAR                   BRUSRI                                      BUG4050
     C                   CLEAR                   BRUSRA                                      BUG4050
     C                   CLEAR                   BRSPTT                                      BUG4050
     C                   CLEAR                   BRNIST                                      BUG4050
     C                   CLEAR                   BRSPRF                                      BUG4050
     C                   CLEAR                   BRDCIN                                      BUG4050
     C                   CLEAR                   BRIBCF                                      BUG4050
     C                   CLEAR                   BRCUSF                                      BUG4050
     C                   CLEAR                   BRCYCF                                      BUG4050
     C                   CLEAR                   BRACCF                                      BUG4050
     C                   CLEAR                   BRACSF                                      BUG4050
     C                   CLEAR                   BRNNBF                                      BUG4050
     C                   CLEAR                   BRRACF                                      BUG4050
     C                   CLEAR                   BRPRCF                                      BUG4050
     C                   CLEAR                   BRAMTF                                      BUG4050
     C                   CLEAR                   BRIBCT                                      BUG4050
     C                   CLEAR                   BRCYCT                                      BUG4050
     C                   CLEAR                   BRCNAT                                      BUG4050
     C                   CLEAR                   BRACCT                                      BUG4050
     C                   CLEAR                   BRASNT                                      BUG4050
     C                   CLEAR                   BRNNBT                                      BUG4050
     C                   CLEAR                   BRRACT                                      BUG4050
      *                                                                                      BUG4050
      * Update or Write depending on whether a record exists for an open                     BUG4050
      * batch. A header record should have already been written by SR GLJENH,                BUG4050
      * however keep *IN46 ON processing in case of unexpected recovery.                     BUG4050
      *                                                                                      BUG4050
     C     *IN46         IFEQ      *ON                                          B01          BUG4050
     C     W#STCD        IFNE      'F'                                          B02          BUG4050
     C                   MOVE      'Y'           BRBIUF                                      BUG4050
     C                   MOVE      'O'           BRRVVD                                      BUG4050
     C                   MOVEL     C#BTIU        BRBDES                                      BUG4050
     C                   ELSE                                                   X02          BUG4050
     C                   MOVE      'N'           BRBIUF                                      BUG4050
     C                   MOVE      ' '           BRRVVD                                      BUG4050
     C                   MOVE      C#CUST        BRBDES                                      BUG4050
     C                   ENDIF                                                  E02          BUG4050
      *                                                                                      BUG4050
     C     W#HTB         IFEQ      'Y'                                          B02          BUG4050
     C                   MOVE      'H'           BRBTSF                                      BUG4050
     C                   ELSE                                                   X02          BUG4050
     C                   MOVE      ' '           BRBTSF                                      BUG4050
     C                   ENDIF                                                  E02          BUG4050
      *                                                                                      BUG4050
      * Set Timestamp on TI journal header record.                                           BUG4050
     C                   CALL      'ZAGENTS'                                                 BUG4050
     C                   PARM                    BRTMST                                      BUG4050
      *                                                                                      BUG4050
     C                   WRITE     @BRREAG                                                   BUG4050
      *                                                                                      BUG4050
     C                   MOVEL     BRBTNB        B3BTNB                                      BUG4050
     C                   MOVEL     'N'           B3DUMP                                      BUG4050
     C                   WRITE     GLBTNOD0                                                  BUG4050
      *                                                                                      BUG4050
     C                   ELSE                                                   X01          BUG4050
     C     W#STCD        IFNE      'F'                                          B02          BUG4050
     C                   MOVE      'Y'           BRBIUF                                      BUG4050
     C                   MOVE      'O'           BRRVVD                                      BUG4050
     C                   MOVEL     C#BTIU        BRBDES                                      BUG4050
     C                   ELSE                                                   X02          BUG4050
     C                   MOVE      'N'           BRBIUF                                      BUG4050
     C                   MOVE      ' '           BRRVVD                                      BUG4050
     C                   MOVE      C#CUST        BRBDES                                      BUG4050
     C                   ENDIF                                                  E02          BUG4050
      *                                                                                      BUG4050
     C     W#HTB         IFEQ      'Y'                                          B02          BUG4050
     C                   MOVE      'H'           BRBTSF                                      BUG4050
     C                   ELSE                                                   X02          BUG4050
     C                   MOVE      ' '           BRBTSF                                      BUG4050
     C                   ENDIF                                                  E02          BUG4050
      *                                                                                      BUG4050
      * Set Timestamp on TI journal header record.                                           BUG4050
     C                   CALL      'ZAGENTS'                                                 BUG4050
     C                   PARM                    BRTMST                                      BUG4050
      *                                                                                      BUG4050
     C                   UPDATE    @BRREAG                                                   BUG4050
     C                   ENDIF                                                  E01          BUG4050
      *                                                                                      BUG4050
     C                   MOVE      *OFF          *IN46                                       BUG4050
     C                   MOVE      *OFF          *IN47                                        235646
      *                                                                                      BUG4050
     C                   ENDSR                                                               BUG4050
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None.                                             *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *                                                                                       214492
      * Check no of records expected for transaction in TIDTA.                                214492
     C                   MOVEL     TRRNID        Y_TRANID                                     214492
     C                   MOVEL     TREVRF        Y_TIEVRF                                     214492
     C                   EXSR      TRSUB                                                      214492
      *                                                                                       214492
      * Check for any prior posted records for transaction in TIDTA for this                  214492
      * or any previous batch for today. (check all GLJENPPD records).                        214492
     C                   EXSR      TRCNT                                                      214492
     C                   MOVE      TRNCNT        W#SEQC                                       214492
      *                                                                                       214492
      * If previous transaction is complete, set up the next transaction into TIDTA.          214492
     C     W#SEQC        IFGE      TRPST                                                      214492
      *                                                                                       214492
     C     *LOVAL        SETLL     TIPOSTLZ                                                   214492
     C                   READ      TIPOSTLZ                               89                  214492
      *                                                                                       214492
      * Set TIDTA to hold details of the next transaction to process.                         214492
     C     *IN89         IFEQ      *OFF                                                       214492
     C     *LOCK         IN        TIDTA                                                      214492
     C                   MOVE      TRTOT         TRRTOT                                      BUG4050
     C                   MOVE      TRANID        TRRNID                                       214492
     C                   MOVE      TIDLTP        TRDLTP                                       214492
     C                   MOVE      TIDLRF        TRDLRF                                       214492
     C                   MOVE      TIEVRF        TREVRF                                       214492
     C                   MOVE      TIVALD        TRVALD                                       214492
     C                   MOVE      TISEQN        TRSEQN                                       214492
     C                   OUT       TIDTA                                                      214492
     C                   Z-ADD     *ZERO         W#SEQC                                       214492
      *                                                                                       214492
      * Re-count W#SEQC for the new transaction.                                              214492
     C                   MOVEL     TRRNID        Y_TRANID                                     214492
     C                   MOVEL     TREVRF        Y_TIEVRF                                     214492
     C                   EXSR      TRSUB                                                      214492
     C                   EXSR      TRCNT                                                      214492
     C                   MOVE      TRNCNT        W#SEQC                                       214492
      *                                                                                       214492
     C                   END                                                                  214492
      *                                                                                       214492
      * Re-set pointer to start of file for detail processing.                                214492
     C     *LOVAL        SETLL     TIPOSTLZ                                                   214492
     C                   END                                                                  214492
      *                                                                                      BUG4704
      * Initialise the batch held flag as the whole batch is revalidated in RELDDT.          BUG4704
     C                   MOVE      ' '           W#HTB                                       BUG4704
      * Initialise the batch held reason flag (for debugging).                               BUG4704
     C                   Z-ADD     0             W#HTBRF                                     BUG4704
      *
      * First Call?
     C     W#ONCE        IFEQ      *BLANK
     C                   MOVE      'Y'           W#ONCE            1
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
      *                                                                                       214390
      *  Free AOTIINR0 so it will recheck the Min/Max batch sizes on each program call        214390
     C                   CALL      'AOTIINR0'                                                 214390
     C                   PARM      '    '        WWRTCD                                       214390
     C                   PARM      '*FREE '      WWOPTN                                       214390
     C     SDTIIN        PARM      SDTIIN        DSFDY                                        214390
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
     C/COPY WNCPYSRC,TIH00008
      *
      ** Access SAR details file to determine if CEU029 is installed.
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD            7
     C                   PARM      '*VERIFY'     ##OPTN            7
     C                   PARM      'CEU029'      ##SARD            6
      *
      ** Database Error
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
      *                                                                                      BUG4704
      ** Access SAR details file to determine if CGL002 is installed.                        BUG4704
     C                   CALL      'AOSARDR0'                                                BUG4704
     C                   PARM      '       '     ##RTCD            7                         BUG4704
     C                   PARM      '*VERIFY'     ##OPTN            7                         BUG4704
     C                   PARM      'CGL002'      ##SARD            6                         BUG4704
      *                                                                                      BUG4704
      ** Database Error                                                                      BUG4704
     C     ##RTCD        IFNE      *BLANK                                                    BUG4704
     C     ##RTCD        ANDNE     '*NRF   '                                                 BUG4704
     C                   Z-ADD     10            DBASE                                       BUG4704
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG4704
     C                   MOVEL     '*CALL'       DBKEY                                       BUG4704
     C                   EXSR      *PSSR                                                     BUG4704
     C                   ENDIF                                                               BUG4704
      *                                                                                      BUG4704
     C     ##RTCD        IFEQ      *BLANK                                                    BUG4704
     C                   MOVEL     'Y'           CGL002            1                         BUG4704
     C                   ELSE                                                                BUG4704
     C                   MOVEL     'N'           CGL002                                      BUG4704
     C                   ENDIF                                                               BUG4704
      *                                                                                      BUG4704
      ** Access Overrides data area.                                                         BUG4704
      *                                                                                      BUG4704
     C     *DTAARA       DEFINE                  GLREOV                                      BUG4704
     C                   IN        GLREOV                                                    BUG4704
      *
      *  Set current batch number from data area TIBATCH
      *  If this is blank then set current batch no. as TILRBN
      *  And also initialise the value in the data area.                                      235646
     C     *DTAARA       DEFINE    TIBATCH       BTCHNM          128
     C                   IN        BTCHNM
     C                   MOVEL     BTCHNM        W#CBNA
      *                                                                                       235646
     C     W#CBNA        IFEQ      *BLANKS
     C                   Z-ADD     TILRBN        W#CBN
     C     *LOCK         IN        BTCHNM                                                     235646
     C                   MOVEL     W#CBNA        BTCHNM                                       235646
     C                   OUT       BTCHNM                                                     235646
     C                   ENDIF
      *                                                                                       214454
      *  Verify if header found is not for a previously completed batch.                      214454
      *                                                                                       214454
     C     W#CBNA        CHAIN     @BRREAG                            46                      214454
     C     *IN46         IFEQ      *OFF                                                       214454
     C     BRBIUF        ANDEQ     ' '                                                        214454
     C     *IN46         OREQ      *OFF                                                      BUG4704
     C     BRBIUF        ANDEQ     'N'                                                       BUG4704
     C     BRBTSF        IFEQ      'A'                                                       BUG4704
     C     BRBTSF        OREQ      'H'                                                       BUG4704
     C     W#CBN         IFLT      TIURBN                                                    BUG6289
     C                   ADD       1             W#CBN                                        214454
      *                                                                                       214454
      * Update data area TIBATCH with next batch number                                       214454
     C     *LOCK         IN        BTCHNM                                                     214454
     C                   MOVEL     W#CBNA        BTCHNM                                       214454
     C                   OUT       BTCHNM                                                     214454
     C                   ENDIF                                                               BUG6289
     C                   END                                                                  214454
     C                   END                                                                 BUG4704
     C                   MOVE      *OFF          *IN46                                        214454
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
     C                   ELSE
     C**********         CLOSE     TIPOSTL2                                     211073
     C**********         OPEN      TIPOSTL2                                     211073
     C                   CLOSE     TIPOSTLZ                                     211073
     C                   OPEN      TIPOSTLZ                                     211073
     C                   ENDIF
      *
     C     W#CBN         IFEQ      TIURBN
      *
      *   Last Batch Reached
     C                   MOVE      'Y'           W#LBR             1
     C                   ENDIF
      *
      *   Clear the multiple-occurrence DS which holds total amounts
     C                   CLEAR     *ALL          TotalsDS
      *
      * Check last batch number of post not equal to header batch number
      *
     C                   MOVE      TIURBN        BTNO              3
     C                   Z-ADD     0             W#HBAT
     C     BTNO          SETGT     @BTREMG4
     C                   READP     @BTREMG4                               47
     C     BTNO          SETGT     @BRREAH
     C                   READP     @BRREAH                                48
     C                   MOVE      BRBTNB        W#HBAT            3 0
     C     W#HBAT        IFGE      TILRBN
     C     W#HBAT        ANDLE     TIURBN
     C     BRRVVD        ANDEQ     'O'
     C     BRBIUF        ANDEQ     'Y'
      *   Add to this batch unconditionally if is the last available.                        BUG6289
     C     W#CBN         OREQ      TIURBN                                                    BUG6289
     C                   MOVE      BTBINB        W#POSC
     C                   ENDIF
      *  Read in the details of the data area TI0340
     C                   IN        W#034T
     C                   MOVEL     W#034T        W#0340            5
      *  If this is the first new entry to a previously unclosed batch
      *  then re-fill previous values for debit and credit amounts.
      *  Then update Total Debit and Credit amounts
     C
     C     W#ONCE        IFEQ      'Y'
      *
      *  Replace open batch processing from previously with new version
     C     BRRVVD        ANDEQ     'O'
      *
     C                   EXSR      RELDDT
      *  Call subroutine TOTALS to check if debit equals credit.                             BUG4969
     C                   EXSR      TOTALS                                                    BUG4969
      *
     C                   ENDIF
      *
     C     K#ACCN        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
      *
     C     K#ULPOST      KLIST                                                               BUG7951
     C                   KFLD                    TIDLBR                                      BUG7951
     C                   KFLD                    TIEVRF                                      BUG7951
     C                   KFLD                    TISEQN                                      BUG7951
     C                   KFLD                    TIVALD                                      BUG7951
      *                                                                                      BUG7951
     C     K#POST        KLIST
     C                   KFLD                    TRANID                                       212558
     C                   KFLD                    TIDLBR
     C**********         KFLD                    TIDLTP                                       212558
     C**********         KFLD                    TIDLRF                         211073
     C                   KFLD                    TIEVRF                         211073
     C                   KFLD                    TISEQN
     C                   KFLD                    TIVALD
      *
     C     K#PROJ        KLIST                                                  207601
     C**********         KFLD                    Y_TIDLBR                              207601 212129
     C**********         KFLD                    Y_TIDLTP                              207601 212129
     C                   KFLD                    Y_TRANID                                     212558
     C                   KFLD                    Y_TIEVRF                       207601
     C**********         KFLD                    Y_TISEQN                              207601 212129
     C**********         KFLD                    Y_TIVALD                              207601 212129
      *                                                                         207601
     C     K#BCUR        KLIST
     C**********         KFLD                    DRCV                                         212558
     C                   KFLD                    TRDATE                                       212558
     C                   KFLD                    TISEQN                                      BUG4200
     C                   KFLD                    TRANID
     C                   KFLD                    TICCYM
     C                   KFLD                    TICCY2
      *
     C     K#JENS        KLIST
     C                   KFLD                    W#CBNA
     C                   KFLD                    CCY
     C                   KFLD                    BRCA
      *                                                                                       214492
     C     K#JENT        KLIST                                                                214492
     C                   KFLD                    JENKEY                                       214492
      *
     C     K#GLJENP      KLIST                                                              BUG13952
     C                   KFLD                    W#CBNA                                     BUG13952
     C                   KFLD                    W#POSC                                     BUG13952
      *                                                                                     BUG13952
     C     *LIKE         DEFINE    P#STCD        W#STCD
     C     *LIKE         DEFINE    BJBVPD        W#BACK
     C     *LIKE         DEFINE    TIMXBS        W#POSC
     C     *LIKE         DEFINE    TIAMNT        W##AMT
     C     *LIKE         DEFINE    TIAMNT        W#AMNT
     C     *LIKE         DEFINE    TRTOT         W#SEQC
     C     *LIKE         DEFINE    TRTOT         W#MAX
     C******LIKE         DEFINE    TRTOT         W#HOLD                                       214492
     C     *LIKE         DEFINE    TRTOT         TRPRJ                          207601
     C     *LIKE         DEFINE    TRTOT         TRPST                          207601
     C     *LIKE         DEFINE    TRTOT         MGPOST                                      BUG4200
     C     *LIKE         DEFINE    TIDLBR        TIDLBR1
     C     *LIKE         DEFINE    TIDLTP        TIDLTP1
     C     *LIKE         DEFINE    TIDLRF        TIDLRF1
     C     *LIKE         DEFINE    TIEVRF        TIEVRF1                        211073
     C     *LIKE         DEFINE    TIVALD        TIVALD1
     C     *LIKE         DEFINE    TISEQN        TISEQN1
     C     *LIKE         DEFINE    TRANID        TRANID1                                      212558
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
      * or if transaction postings counter is not equal to transaction
      * postings total.
     C*****DebEQCred     IFNE      'Y'                                                       BUG4704
     C     DebEQCred     IFEQ      'N'                                                       BUG4704
     C*****W#SEQC        ORNE      TRTOT                                        207601
     C*****W#SEQC        ORNE      TRPST                                               207601 212129
     C*****W#POSC        ORNE      TRPST                                               212129 214492
     C*****W#SEQC        ORNE      TRPST                                              214492 BUG4704
     C                   MOVE      'Y'           W#HTB
     C                   Z-ADD     16            W#HTBRF                                     BUG4704
      *                                                                                      BUG4860
      * Print details of any closing held batch                                              BUG4860
     C                   OPEN      TI0341P1                                                  BUG4860
     C                   EXSR      RCFP1                                                     BUG4860
     C                   WRITE     HEADP1                                                    BUG4860
     C                   WRITE     BCHERROR                                                  BUG4860
     C                   WRITE     TRAILP1                                                   BUG4860
     C                   CLOSE     TI0341P1                                                  BUG4860
      * Re-set posting flag
     C                   ENDIF
      *                                                                                       226312
      * Check if TRPST=1 and batch is balanced.                                               226312
     C     DebEQCred     IFEQ      'Y'                                                        226312
     C     TRPST         ANDEQ     1                                                          226312
     C                   MOVE      ' '           W#HTB                                        226312
     C                   ENDIF                                                                226312
      *
     C     W#HTB         IFEQ      'Y'
     C                   MOVE      'H'           BRBTSF
     C                   MOVE      W#CBNA        P#BATN
     C     W#STCD        IFEQ      'S'
     C                   MOVE      'F'           W#STCD
     C                   ELSE
     C                   MOVE      'H'           W#STCD
     C                   ENDIF
      *
     C                   ELSE
      *  Batch Accepted
     C                   MOVE      'A'           BRBTSF
     C                   MOVE      'A'           W#STCD
     C                   MOVE      W#CBNA        P#BATN
     C                   ENDIF
      *
      *  Write record to the Journal Entry Header File
      *  Final call to close batch, removing batch-in-use flag and resetting held status.    BUG4050
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
      *   Transaction Postings Sequence Counter
     C                   Z-ADD     *ZERO         W#SEQC
      *   Max field to see if next transaction will take batch over maximum size              214492
     C                   Z-ADD     *ZERO         W#MAX                                        214492
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
      * If this is the last batch of the day then force the close after
      * all the postings have been processed.
     C     W#STCD        IFEQ      'S'
     C     W#POSC        ANDNE     0
     C                   EXSR      CLOSE
     C                   ENDIF
      *
      * Commit changes within this call to the program
     C                   COMMIT
      *
     C*****W#HTBRF       IFGT      0                                                 BUG4704 BUG4860
     C**********         DUMP                                                        BUG4704 BUG4860
     C**********         END                                                         BUG4704 BUG4860
      * End
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
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
      * Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
      * Database error report
     C                   OPEN      TI0341AU
     C                   EXSR      RCFAU                                                     BUG4860
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   CLOSE     TI0341AU
      *
     C                   DUMP
     C                   ENDIF
      *
      * Exit program
     C                   RETURN
      *
     C                   ENDSR
      *                                                                                      BUG4860
      *****************************************************************                      BUG4860
      /EJECT                                                                                 BUG4860
      *****************************************************************                      BUG4860
      *                                                               *                      BUG4860
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *                      BUG4860
      *                                                               *                      BUG4860
      *****************************************************************                      BUG4860
      *                                                                                      BUG4860
     C     RCFP1         BEGSR                                                  *** RCFP1 ***BUG4860
      *                                                                                      BUG4860
      ***  Ensure Report Spool File recorded by RCF.                                         BUG4860
      *                                                                                      BUG4860
     C                   Z-ADD     SFNUM1        ZSNUM             6 0                       BUG4860
      *                                                                                      BUG4860
     C                   CALL      'ZSFILE'                                                  BUG4860
     C                   PARM      PRSEQ         PRSEQ             5                         BUG4860
     C                   PARM                    PRENT             3                         BUG4860
     C                   PARM                    SFILE1                                      BUG4860
     C                   PARM                    ZSNUM                                       BUG4860
     C                   PARM                    ZSERR             1                         BUG4860
      *                                                                                      BUG4860
      ***  If Error occurs during ZSFILE processing, then return to the                      BUG4860
      ***  Calling Program.                                                                  BUG4860
      *                                                                                      BUG4860
     C     ZSERR         IFEQ      'Y'                                                       BUG4860
     C                   SETON                                        U7U8LR                 BUG4860
     C                   RETURN                                                              BUG4860
     C                   ENDIF                                                               BUG4860
      *                                                                                      BUG4860
     C                   ENDSR                                                               BUG4860
      *                                                                                      BUG4860
      *****************************************************************                      BUG4860
      /EJECT                                                                                 BUG4860
      *****************************************************************                      BUG4860
      *                                                               *                      BUG4860
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *                      BUG4860
      *                                                               *                      BUG4860
      *****************************************************************                      BUG4860
      *                                                                                      BUG4860
     C     RCFAU         BEGSR                                                  *** RCFAU ***BUG4860
      *                                                                                      BUG4860
      ***  Ensure Audit Spool File recorded by RCF.                                          BUG4860
      *                                                                                      BUG4860
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0                       BUG4860
      *                                                                                      BUG4860
     C                   CALL      'ZSFILE'                                                  BUG4860
     C                   PARM                    PRSEQ                                       BUG4860
     C                   PARM                    PRENT                                       BUG4860
     C                   PARM                    SFILEU                                      BUG4860
     C                   PARM                    ZSNUMU                                      BUG4860
     C                   PARM      *BLANK        ZSERR                                       BUG4860
      *                                                                                      BUG4860
      ***  If Error occurs during ZSFILE processing, then return to the                      BUG4860
      ***  Calling Program.                                                                  BUG4860
      *                                                                                      BUG4860
     C     ZSERR         IFEQ      'Y'                                                       BUG4860
     C                   SETON                                        U7U8LR                 BUG4860
     C                   RETURN                                                              BUG4860
     C                   ENDIF                                                               BUG4860
      *                                                                                      BUG4860
     C                   ENDSR                                                               BUG4860
      *                                                                                      BUG4860
      *****************************************************************                      BUG4860
      /EJECT                                                                                 BUG4860
      *****************************************************************
      *                                                               *
      *  RELDDT - Reload details for batch.                           *
      *                                                               *
      *  Called By: Detl                                              *
      *                                                               *
      *****************************************************************
      *
     C     RELDDT        BEGSR
      *                                                                                       212215
      * Initialise comparison timestamp with high value                                       212215
     C                   MOVEA     WCompData     WCompAlph        26                          212215
     C                   MOVE      WCompAlph     WCompTmSt                                    212215
      *
     C     *LOVAL        SETLL     GLJENPL4
     C     BTBTNB        CHAIN     @BTREMG4                           50
     C                   MOVE      BTBTNB        W#BTNB            3
     C                   MOVE      BTTMST        WCompTmSt                                    212215
      *
      *  Loop to re-load debit and credit info for this batch.
     C     *IN50         DOWEQ     *OFF
      *
     C                   Z-ADD     1             Index
     C     BTCYCD        LOOKUP    CurrArr(Index)                         10
     C     *IN10         IFEQ      '0'
     C                   MOVEL     BTCYCD        DBKEY
     C                   MOVEL     'Array   '    DBFILE
     C                   Z-ADD     11            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     Index         OCCUR     TotalsDS
     C     BTDCIN        IFEQ      'D'
     C                   ADD(H)    BTPTAM        TotDebit
     C                   ELSE
     C                   ADD(H)    BTPTAM        TotCredit
     C                   ENDIF
      *
      * Validate Posting details, including currency decimal places.
      * to reset W#HTB (Held batch flag)
     C                   EXSR      VALID2
      *
      * Determine appropriate factor of 10.
      * Update Hash Total Amount
     C     A6NBDP        IFEQ      0
     C     BTPTAM        MULT      1000          W#AMNT
     C                   ENDIF
     C     A6NBDP        IFEQ      1
     C     BTPTAM        MULT      100           W#AMNT
     C                   ENDIF
     C     A6NBDP        IFEQ      2
     C     BTPTAM        MULT      10            W#AMNT
     C                   ENDIF
     C                   ADD(H)    W#AMNT        W##AMT
      *
     C     BTBTNB        READE     @BTREMG4                               50
     C                   MOVE      BTTMST        WCompTmSt                                    212215
     C                   ENDDO
      *
      *   Reset flag for batch info complete.
     C                   MOVE      'N'           W#ONCE
     C     *LOCK         IN        TIDTA
     C                   MOVE      TRRNID        TRANID                                       212558
     C                   MOVE      TRDLTP        TIDLTP
     C                   MOVE      TRDLRF        TIDLRF
     C                   MOVE      TREVRF        TIEVRF                         211073
     C                   MOVE      TRVALD        TIVALD
     C**********         MOVE      TRSEQN        W#SEQC                                       214492
     C                   OUT       TIDTA
     C     *LOCK         IN        TIDTA
     C                   MOVE      TRRNID        TRANID1                                      212558
     C                   MOVE      TRDLTP        TIDLTP1
     C                   MOVE      TRDLRF        TIDLRF1
     C                   MOVE      TREVRF        TIEVRF1                        211073
     C                   MOVE      TRVALD        TIVALD1
     C                   OUT       TIDTA
     C**********         MOVEL     BTIBCA        TIDLBR                                      BUG6289
     C**********         EVAL      TIDLBR1 = BTIBCA                                          BUG6289
     C**********         EVAL      TISEQN = 1                                                 218763
     C                   EVAL      TISEQN = 0                                                 218763
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  VALID2 - Validate the fields                                 *
      *                                                               *
      *  Called By: RELDDT                                            *
      *  Calls    : AOBRCHR0, AOCUSTR0, AOCURRR0, AOACODR0            *
      *                                                               *
      *****************************************************************
     C     VALID2        BEGSR
      *
      * Validate branch code
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG    '    WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM      BTIBCA        WWKEY3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C* No need to set-up W#HTBRF in SR VALID2 as SR VALID produced the dump when record     BUG4704
     C* was written. Otherwise multiple dumps would be produced as the whole batch is        BUG4704
     C* revalidated each time this program is called.                                        BUG4704
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *
      * Validate Customer
     C**********         MOVEL     BTCUST        WWKY10                                       212129
     C                   MOVE      *BLANKS       WWKY10                                       212129
     C                   MOVEL     BTCUST        WWKY10                                       212129
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG    '    WWRTCD
     C                   PARM      '*KEY    '    WWOPTN
     C                   PARM                    WWKY10           10
     C                   PARM      *BLANKS       WWKYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *
      * Validate Currency
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    WWRTCD            7
     C                   PARM      '*KEY    '    WWOPTN            7
     C                   PARM      BTCYCD        WWKEY3            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *
      * Validate Currency
     C                   MOVE      BTACCD        WWKEY4
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG    '    WWRTCD            7
     C                   PARM      '*KEY    '    WWOPTN            7
     C**********         PARM                    WWKEY4            4                          CGL029
     C                   PARM                    WWKEY4                                       CGL029
     C     SDACOD        PARM      SDACOD        DSSDY
      *  Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *
      * Get Account
     C                   MOVE      BTCUST        CNUM
     C                   MOVE      BTCYCD        CCY
     C                   MOVE      BTACCD        ACOD
     C                   MOVE      BTACSN        ACSQ
     C                   MOVE      BTIBCA        BRCA
      *
     C     K#ACCN        CHAIN     ACCNT                              88
     C     *IN88         IFEQ      *ON
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *
      * Account must be open to be valid
     C     DACC          IFNE      *ZERO
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *
      * Value date after date account opened?
     C     BTVLDT        IFLT      DACO
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *
      **Retail*a/c?                                                                          BUG4704
     C*****ACNO*         IFNE      *ZERO                                                     BUG4704
      *
      *  Back valued posting within back value period?
     C     BTVLDT        IFLT      BJRDNB
      *
     C     BJRDNB        SUB       BTVLDT        W#BACK
     C     W#BACK        IFGT      BJBVPD
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
     C                   ENDIF
      *
      *  Check status of retail account?
     C     TIREAS        IFEQ      'Y'
     C     ATYP          ANDEQ     'R'                                                       BUG4704
      *
      ****Bit*0*-*Refer Debits?****************************************                      BUG4704
      ****Bit*1*-*Refer Credits?***************************************                      BUG4704
      ****Bit*2*-*Block Debits?****************************************                      BUG4704
      ****Bit*3*-*Block Credits?***************************************                      BUG4704
      *   Bit 4 - Account is Inactive?
      *   Bit 6 - Bankrupt/Liquidation?
      *   Bit 7 - Bad Debt?
     C**********         TESTB     '467'         RETB                 87                     BUG4704
     C                   TESTB     '4'           RETB                     87                 BUG4704
     C******IN87         IFEQ      *OFF                                                      BUG4704
     C     *IN87         IFEQ      *ON                                          B02          BUG4704
     C     WRRE05        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *                                                                                      BUG4704
     C                   TESTB     '6'           RETB                     87                 BUG4704
     C     *IN87         IFEQ      *ON                                          B02          BUG4704
     C     WRRE07        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB                                       BUG4704
     C                   GOTO      ENDVAL2                                                   BUG4704
     C                   ENDIF                                                  E02          BUG4704
      *                                                                                      BUG4704
     C                   TESTB     '7'           RETB                     87                 BUG4704
     C     *IN87         IFEQ      *ON                                          B02          BUG4704
     C     WRRE08        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB                                       BUG4704
     C                   GOTO      ENDVAL2                                                   BUG4704
     C                   ENDIF                                                  E02          BUG4704
     C                   ENDIF                                                  E01          BUG4704
      *
      *  Check status of retail account, or GL account with CGL002 on.                       BUG4704
     C     ATYP          IFEQ      'R'                                          B01          BUG4704
     C     ATYP          OREQ      'G'                                                       BUG4704
     C     CGL002        ANDEQ     'Y'                                                       BUG4704
      *                                                                                      BUG4704
      *   Bit 0 - Refer Debits?                                                              BUG4704
      *   Bit 1 - Refer Credits?                                                             BUG4704
      *   Bit 2 - Block Debits?                                                              BUG4704
      *   Bit 3 - Block Credits?                                                             BUG4704
      *                                                                                      BUG4704
     C     BTDCIN        IFEQ      'D'
     C**********         TESTB     '02'          RETB                 87                     BUG4704
     C                   TESTB     '0'           RETB                     87                 BUG4704
     C******IN87         IFEQ      *OFF                                                      BUG4704
     C     *IN87         IFEQ      *ON                                          B03          BUG4704
     C     WRRE01        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *                                                                                      BUG4704
     C                   TESTB     '2'           RETB                     87                 BUG4704
     C     *IN87         IFEQ      *ON                                          B03          BUG4704
     C     WRRE03        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB                                       BUG4704
     C                   GOTO      ENDVAL2                                                   BUG4704
     C                   ENDIF                                                  E03          BUG4704
     C                   ENDIF
      *
     C     BTDCIN        IFEQ      'C'
     C**********         TESTB     '13'          RETB                 87                     BUG4704
     C                   TESTB     '1'           RETB                     87                 BUG4704
     C******IN87         IFEQ      *OFF                                                      BUG4704
     C     *IN87         IFEQ      *ON                                          B03          BUG4704
     C     WRRE02        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL2
     C                   ENDIF
      *                                                                                      BUG4704
     C                   TESTB     '3'           RETB                     87                 BUG4704
     C     *IN87         IFEQ      *ON                                          B03          BUG4704
     C     WRRE04        ANDNE     'Y'                                                       BUG4704
     C                   MOVE      'Y'           W#HTB                                       BUG4704
     C                   GOTO      ENDVAL2                                                   BUG4704
     C                   ENDIF                                                  E03          BUG4704
     C                   ENDIF
      *
     C                   ENDIF
      *
     C**********         ENDIF                                                               BUG4704
      *
     C     ENDVAL2       TAG
      *
     C                   ENDSR
      *****************************************************************         207601
      *                                                               *         207601
      *  TRSUB - Calculate the number of projections which exist      *         207601
      *          for this transaction and place in field TRPRJ.       *         207601
      *          Total postings should be TRTOT - TRPRJ.              *         207601
      *          This SR is called after each read of TIPOSTLZ and    *         207601
      *          will setup TRPST from the TRTOT of the posting just  *         207601
      *          read.                                                *         207601
      *                There are other reads to TIPOSTLX and L8 (to   *         207601
      *          update the status). These should be reaccessing the  *         207601
      *          currently read posting. TRPST should not change when *         207601
      *          these CHAINs are made.                               *         207601
      *                                                               *         207601
      *  Called By: Main Processing                                   *         207601
      *  Calls    :                                                   *         207601
      *                                                               *         207601
      *****************************************************************         207601
     C     TRSUB         BEGSR                                                  207601
      *                                                                         207601
      * Read through all projections found for the transaction,                 207601
      * retaining count of all records found.                                   207601
      *                                                                         207601
     C**********         MOVEL     TIDLBR        Y_TIDLBR                              207601 212129
     C**********         MOVEL     TIDLTP        Y_TIDLTP                              207601 212129
     C**********         MOVEL     TRANID        Y_TRANID                              212558 214492
     C**********         MOVEL     TIEVRF        Y_TIEVRF                              207601 214492
     C**********         Z-ADD     TISEQN        Y_TISEQN                              207601 212129
     C**********         Z-ADD     TIVALD        Y_TIVALD                              207601 212129
     C                   Z-ADD     0             TRPRJ                          207601
     C                   Z-ADD     0             MGPOST                                      BUG4200
     C                   MOVE      *OFF          *IN83                          207601
     C     K#PROJ        SETLL     TIPOSTLY                                     207601
     C     K#PROJ        READE     TIPOSTLY                               83    207601
      *                                                                         207601
     C     *IN83         DOWEQ     *OFF                                         207601
     C                   ADD       1             TRPRJ                          207601
     C     K#PROJ        READE     TIPOSTLY                               83    207601
     C                   ENDDO                                                  207601
      *                                                                         207601
     C     K#PROJ        SETLL     TIPOSTLW                                                  BUG4200
     C     K#PROJ        READE     TIPOSTLW                               83                 BUG4200
      *                                                                                      BUG4200
     C     *IN83         DOWEQ     *OFF                                                      BUG4200
     C                   ADD       1             MGPOST                                      BUG4200
     C     K#PROJ        READE     TIPOSTLW                               83                 BUG4200
     C                   ENDDO                                                               BUG4200
      *                                                                                      BUG4200
     C                   EVAL      TRPST = TRTOT - TRPRJ                        207601
     C                   EVAL      TRPST = TRPST + MGPOST                                    BUG4200
      *                                                                         207601
     C                   ENDSR                                                  207601
      *****************************************************************                       214492
      *                                                               *                       214492
      *  TRCNT - Calculate the number of postings for this            *                       214492
      *          reference already batched. This sets up the field    *                       214492
      *          W#SEQC starting amount prior to incrementing the     *                       214492
      *          additional postings during this call of TI0341       *                       214492
      *                                                               *                       214492
      *  Called By: Init Processing                                   *                       214492
      *  Calls    :                                                   *                       214492
      *                                                               *                       214492
      *****************************************************************                       214492
     C     TRCNT         BEGSR                                                                214492
      *                                                                                       214492
      * Read through all journal entries to count number of postings                          214492
      * already batched.                                                                      214492
      *                                                                                       214492
     C                   CLEAR                   BTNRDC                                       214492
     C     *LOCK         IN        TIDTA                                                      214492
     C                   OUT       TIDTA                                                      214492
     C     TRDLTP        CAT       TRDLRF        BTNRDC                                       214492
     C                   MOVE      TREVRF        RDC6                                         214492
     C                   MOVE      BTNRDC        JENKEY           30                          214492
     C                   Z-ADD     0             TRNCNT            3 0                        214492
     C                   MOVE      *OFF          *IN83                                        214492
     C     K#JENT        SETLL     GLJENPL6                                                   214492
     C     K#JENT        READE     GLJENPL6                               83                  214492
      *                                                                                       214492
     C     *IN83         DOWEQ     *OFF                                                       214492
     C                   ADD       1             TRNCNT                                       214492
     C     K#JENT        READE     GLJENPL6                               83                  214492
     C                   ENDDO                                                                214492
      *                                                                                       214492
     C                   ENDSR                                                                214492
      *****************************************************************                       214492
** WCompData - Dummy comparison timestamp                                                     212215
2099-01-01-00.00.01.000000                                                                    212215
** HLDRSN                                                                                    BUG4860
Account is flagged for closure                                                               BUG4860
Posting value date is prior to the date account opened                                       BUG4860
Posting is backvalued beyond the system backvalue period                                     BUG4860
Inactive status set for this account                                                         BUG4860
Bankrupt/liquidated status set for this account                                              BUG4860
Bad Debt status set for this account                                                         BUG4860
Refer all debits set for this account                                                        BUG4860
Block all debits set for this account                                                        BUG4860
Refer all credits set for this account                                                       BUG4860
Block all credits set for this account                                                       BUG4860
