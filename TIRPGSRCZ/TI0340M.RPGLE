     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas TI I/c journal entry gen of TI postings')        *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI0340M - TI I/C Journal Entry Generation of TI Postings     *
      *                                                               *
      *  Function:  This program is responsible for doing any journal *
      *             entry generation of TI Postings marked as pending *
      *             journal entry generation                          *
      *                                                               *
      *  Phases: I/C                                                  *
      *                                                               *
      *  Called By: TIC0340 - Controlling Component                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL154             Date 13Oct14               *
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
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2798            Date 27May04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 212558             Date 31Jan03               *
      *                 214454             Date 30Jan03               *
      *                 214390             Date 30Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 152041             Date 07Jan03               *
      *                 210539             Date 06Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003             Date 08May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      *                 179679             Date 10Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 179732             Date 27Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 168873             Date 16Dec99               *
      *                 156162             Date 07Jun99               *
      *                 156165             Date 24Jun99               *
      *                 162449             Date 01Jul99               *
      *                 161512             Date 01Jul99               *
      *                 150221             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 160811             Date 16May99               *
      *                 159339             Date 05May99               *
      *                 156998             Date 10May99               *
      *                 157551             Date 10May99               *
      *                 156304             Date 17Feb99               *
      *                 151069             Date 22Feb99               *
      *                 144700             Date 26Nov98               *
      *                 140071             Date 04AUG98               *
      *                 CEU029             Date 01Sep98               *
      *                 139756             Date 29Jul98               *
      *                 CTI001  *CREATE    Date 01AUG97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSC024 - Open Month End (Recompile)                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2798 - Add processing for GLBTNOPD.                       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212558 - Change K#POST & K#BCUR for TIPOSTL0 & TIPOSTL8      *
      *  214454 - If TIBATCH refers to an existing batch which is not *
      *           in use, need to recover by adding one to the batch  *
      *           number on the dataarea and proceeding with that no. *
      *  214390 - Ensure this call of batch program picks up any      *
      *           recent change to batch min/max from TI ICD.         *
      *  152041 - Customer originated flag should be set according to *
      *           the transaction type for retail accounts.           *
      *  210539 - Initialise the Last Insert User and Last Amend User *
      *           fields when writing a new journal item.             *
      *  CTI003 - Changes for patch D.  RETURN should be after LR is  *
      *            set on.                                            *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  179679 - If forward or backvalued, accept if account is      *
      *           retail. If non retail, accept backvalued only if    *
      *           management accounts is on. Otherwise set date to    *
      *           run date (as journal entry validation would).       *
      *  179732 - Incorp GEMS 165656 to use Profit Centres for Retail *
      *           or Nostro accounts.                                 *
      *           Further change: If not Retail/Nostro, assign        *
      *           the profit centre using the analytical accounting   *
      *           default matrix. If the profit centre is still blank *
      *           or 'unallocated' use the TI ICD value.              *
      *  168873 - If 'STOP' requested leave the program with W#STCD   *
      *           equal to 'S' even if there are no postings in last  *
      *           batch.                                              *
      *  156162 - Remove restrictions on batch size for minimum and   *
      *           maximum batch sizes for the last batch.             *
      *  156165 - Remove the checking for Stopped Cheques in an       *
      *           account since cheque numbers are not used.          *
      *  162449 - Submit accepted batches to MIDAS during CLOSE       *
      *           routine instead of from CL program except during    *
      *           the final posting which runs a start of COB (when   *
      *           stop code is 'B').                                  *
      *  161512 - Read GLJENHL1 instead of GLJENHL0                   *
      *  150221 - Out of balance batches are accepted.  This was due  *
      *           to the fact that the totals data structure was not  *
      *           cleared except in the INIT routine; it needs to be  *
      *           cleared as each batch is closed.                    *
      *  160811 - Initialise account number.                          *
      *  159339 - Produce batch header during the day.                *
      *  156998 - Default last batch header info correctly.           *
      *         - Default Workstation ID correctly.                   *
      *  157551 - Reset Narrative information.                        *
      *  156304 - Clear description field on GLJENHPD.                *
      *  151069 - TIJRNENT falls over on duplicate write to GLJENPPD  *
      *         - Prevent last batch of the day being accepted when   *
      *            out of balance.                                    *
      *  144700 - Batches held - Batch header out of balance          *
      *  140071 - Rename account code field on Stopped Cheques file.  *
      *  CEU029 - EMU Midas/Trade Innovation Interface Enhancements:  *
      *           include Original Currency and Amount on TI Postings.*
      *  139756 - Always put deal type/ref. into journal entry ref.   *
      *  CTI001 - Created for Midas/TI Interface                      *
      *                                                               *
      *****************************************************************
      *
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
      * GL Accounts Master
      *
     FSTOPCL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(STOP)                         140071
      * RE Stopped Cheques
      *
     FTIPOSTL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      * TI Postings by projection id, ie deal branch mnemonic,
      *    deal type, deal reference, seqeunce no., value date
      *
     FTIPOSTL8  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(TIPOSTD0:TIPOSTD8)
      * Base Currency Equivalent Postings Update Index
      *
     FGLJENSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      * GL Journal Entry Summary
      *
     F***GLJENPPD  O    E             DISK    INFSR(*PSSR)                      151069
     FGLJENPPD  UF A E             DISK    INFSR(*PSSR)                         151069
     F                                     COMMIT
      * GL Journal Entry Posting
      *
     F***GLJENHPD  O    E             DISK    INFSR(*PSSR)                      151069
     FGLJENHPD  UF A E             DISK    INFSR(*PSSR)                         151069
     F                                     COMMIT
      * GL Journal Entry Header
      *
     FTI0340AU  O    E             PRINTER USROPN
      *   Audit Report
      *
     FTIPOSTL2  IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(TIPOSTD0:TIPOSTD2)
      * TI Postings, select those pending journal entry gen
      *
      ** Today's batch numbers used                                                          BUG2798
      *                                                                                      BUG2798
     FGLBTNOPD  O    E             DISK    INFSR(*PSSR)                                      BUG2798
     F                                     COMMIT                                            BUG2798
      *                                                                                      BUG2798
     FGLJENPL4  IF   E           K DISK    INFSR(*PSSR)                         151069
     F                                     RENAME(@BTREMG:@BTREMG4)             151069
      *                                                                         151069
     F*****GLJENHL0  IF   E           K DISK    INFSR(*PSSR)             151069 159339
     FGLJENHL0  UF A E           K DISK    INFSR(*PSSR)                         159339
     FGLJENHL1  IF   E           K DISK    INFSR(*PSSR)                         161512
     F/COPY WNCPYSRC,TI0340MF01
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      *  10    - Used by LOOKUP                                       *
      *  90-99 - Used by Standard Subroutines                         *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      * Array for Object Copyright Statement.
      *
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
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  179732
      *                                                                                       179732
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)                                  179732
      *                                                                                       179732
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
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  179732
     D  NostACCD     E                     EXTFLD(QQACCD)                                     CGL029
      *                                                                                       179732
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)                                  179732
     D  PcacFNAA     E                     EXTFLD(QQFNAA)                                     CGL029
     D  PcacFNIC     E                     EXTFLD(QQFNIC)                                     CGL029
     D**  External DS for profit centre accounting ICD                                        179732
      *                                                                                       179732
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D DBERR         E DS                  EXTNAME(LDA)
      * Data structure for data-base error processing.
      *
     D W#POST          DS
      * K#POST Key list
     D  TRANID                 1      4                                                       212558
     D  TIDLBR                 5      8                                                       212558
     D  TIEVRF                 9     25                                                       212558
     D  TISEQN                26     28  0                                                    212558
     D  TIVALD                29     35  0                                                    212558
     D**TIDLBR**               1      4                                                       212558
     D**TIDLTP**               5      7                                                       212558
     D**TIDLRF**               8     20                                                       212558
     D**TISEQN**              21     23  0                                                    212558
     D**TIVALD**              24     30  0                                                    212558
      *
     D W#ASOC          DS
     D  W#CBN                  1      3  0
     D  W#CBNA                 1      3
     D  ACNO                   7     16  0
     D  P#BATC                20     22  0
      *
     D C#CUST          C                   CONST('Trade Innovation')
     D C#BTIU          C                   CONST('Batch in use by TI')          159339
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
      *
     C     *ENTRY        PLIST
     C     W#STCD        PARM      W#STCD        P#STCD            1
     C                   PARM                    P#BATN            3
      *
     C                   EXSR      INIT
      *
      **If*status*is*not*'S'*then*perform*detail*processing                     156162
     C*****W#STCD        IFNE      'S'                                          156162
     C                   EXSR      DETL
     C*****              ELSE                                                   156162
      *
      * otherwise, only close the current batch if it has postings
      *
     C*****W#POSC        IFNE      0                                            156162
      *                                                                         156998
      * Reload details for batch header and flag batch as held                  156998
      *                                                                         156998
     C**********         EXSR      RELDDT                                156998 156162
     C**********         EXSR      TOTALS                                156998 156162
     C**********         MOVE      'Y'           W#HTB                   151069 156162
     C**********         EXSR      CLOSE                                        156162
     C**********         ENDIF                                                  156162
     C**********         ENDIF                                                  156162
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
      * read the first posting
      *
     C                   READ      TIPOSTL2                               89
      *
      * If there are no additional postings
      *
     C     *IN89         IFEQ      *ON
      *
      * If postings counter is zero then there is an empty new
      * batch so return with a blank status code.
      *
     C     W#POSC        IFEQ      *ZERO
     C     P#STCD        IFNE      'S'                                          168873
     C                   MOVE      *BLANKS       W#STCD
     C                   ENDIF                                                  168873
     C*****              RETURN                                                               CTI003
     C                   SETON                                        LR        151069
     C                   RETURN                                                               CTI003
     C*****              ELSE                                                   151069
     C                   ENDIF                                                  151069
      *
      **Otherwise,*current*batch*has*postings,*so*close*it******                151069
      *
     C*****              EXSR      CLOSE                                        151069
     C*****              ENDIF                                                  151069
      *
     C                   ELSE
      *
      * Otherwise, process the additional postings
      *
     C     *IN89         DOWEQ     *OFF
     C*****W#0340        ANDNE     'STOP'                                       156162
      *
      * Check for no more batches available
      *
     C     W#CBN         IFGT      TIURBN
     C                   MOVEL     TIURBN        DBKEY
     C                   MOVEL     'UR BATCH'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ADD       1             W#POSC
      *
      *  Validate fields
      *
     C                   EXSR      VALID
      *
      *  Write postings to Journal Entry Postings File
      *
     C                   EXSR      GLJENP
      *
      *  If this is a new batch, then write header and flag as in use           159339
      *                                                                         159339
     C     W#POSC        IFEQ      1                                            159339
     C                   EXSR      GLJENH                                       159339
     C                   ENDIF                                                  159339
      *                                                                         159339
      *  Update the posting status to 'JEG'
      *
     C     MIDGEN        IFEQ      'N'
     C     K#POST        CHAIN     TIPOSTL0                           85
      *
     C     *IN85         IFEQ      *ON
     C                   MOVEL     W#POST        DBKEY
     C                   MOVEL     'TIPOSTL0'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Update the posting status to 'JEG'
      *
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
      *
     C                   MOVE      'JEG'         PSTS
     C                   UPDATE    TIPOSTD8
     C                   ENDIF
      *                                                                         151069
      *  If this is the first new entry to a previously unclosed batch          151069
      *  then re-fill previous values for debit and credit amounts.             151069
      *  Then update Total Debit and Credit amounts                             151069
     C                                                                          151069
     C     W#ONCE        IFEQ      'Y'                                          151069
      *                                                                         159339
      *  Replace open batch processing from previously with new version         159339
      *                                                                         159339
     C     BRRVVD        ANDEQ     'O'                                          159339
     C*****W#BAT         ANDNE     W#HBAT                                151069 159339
      *                                                                         151069
     C                   EXSR      RELDDT                                       151069
     C*                                                                         151069
     C                   ELSE                                                   151069
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
      * Depending on number of decimal places of currency multiply by           144700
      *  factor of 10                                                           144700
     C     A6NBDP        IFEQ      0                                            144700
     C     TIAMNT        MULT      1000          W#AMNT                         144700
     C                   ENDIF                                                  144700
     C     A6NBDP        IFEQ      1                                            144700
     C     TIAMNT        MULT      100           W#AMNT                         144700
     C                   ENDIF                                                  144700
     C     A6NBDP        IFEQ      2                                            144700
     C     TIAMNT        MULT      10            W#AMNT                         144700
     C                   ENDIF                                                  144700
      *
      *  Update Hash Total Amount
     C*****              ADD(H)    TIAMNT        W##AMT                         144700
     C                   ADD(H)    W#AMNT        W##AMT                         144700
      *                                                                         151069
      *  End of condition based on whether TotalsDS was already full            151069
      *                                                                         151069
     C                   ENDIF                                                  151069
      *
      *  Update the Journal Entry Summary File
      *
     C                   EXSR      GLJENS
      *
      **Check*for*STOP***                                                       156162
     C*****W#POSC        IFGT      W#STNP                                       156162
     C******DTAARA       DEFINE    TI0340        W#0340          128            156162
     C*****              IN        W#0340                                       156162
     C*****W#0340        IFEQ      'STOP'                                       156162
     C*****              MOVE      'S'           W#STCD                         156162
     C*****              ELSE                                                   156162
     C*****              ADD       W#STIN        W#STNP                         156162
     C*****              ENDIF                                                  156162
     C*****              ENDIF                                                  156162
     C     *DTAARA       DEFINE    TI0340        W#034T          128            156162
     C                   IN        W#034T                                       156162
     C                   MOVEL     W#034T        W#0340            5            156162
      *
      *  Call subroutine TOTALS to check if debit equals credit.
      *  This subroutine will set the flag DebEQCred
     C                   EXSR      TOTALS
      *
      *  If batch is at maximum then close batch
      *
     C     W#POSC        IFEQ      TIMXBS
     C     W#STCD        ANDNE     'S'                                          156162
      *
      *  IF STOP is requested then close batch
      *
     C*****W#0340        OREQ      'STOP'                                       156162
      *
      * Close batch if batch is past minimum size and
      * total debits = total credits for all currencies
      * and this is not the final batch
      *
     C     W#POSC        ORGE      TIMNBS
     C     DebEQCred     ANDEQ     'Y'
     C     W#CBN         ANDNE     TIURBN
      *
     C                   EXSR      CLOSE
      *
     C                   ENDIF
      *
      *
      * Get next posting
     C                   READ      TIPOSTL2                               89
      *
     C                   ENDDO
      *
     C                   ENDIF
      * If last batch of the day then set flag to show this.                    156162
     C     W#0340        IFEQ      'STOP'                                       156162
     C                   MOVE      'S'           W#STCD                         156162
     C                   EXSR      RELDDT                                       156162
     C                   EXSR      TOTALS                                       156162
     C                   ENDIF                                                  156162
      *
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
     C                   Z-ADD     *ZEROS        ACNO                           160811
      * Validate branch code
      *
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
      *
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
     C                   ELSE                                                                 179732
     C                   MOVE      CNUM          WCNMA                                        179732
     C                   ENDIF
      *
      * Validate Currency
      *
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
      **Validate*Currency*******************************************                          179732
      * Validate Account Code                                                                 179732
      *
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
     C                   ELSE                                                                 179732
     C                   MOVE      ACOD          WACODA                                       179732
     C                   ENDIF
      *
      * Get Account
      *
     C     K#ACCN        CHAIN     ACCNT                              88
     C     *IN88         IFEQ      *ON
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *                                                                                       179732
      * Check if Account is actually a Nostro                                                 179732
      *                                                                                       179732
     C                   MOVE      ACSQ          WACSN                                        179732
     C                   CALL      'AONOSTR0'                                                 179732
     C                   PARM      *BLANKS       WWRTCD                                       179732
     C                   PARM      '*KEY   '     WWOPTN                                       179732
     C                   PARM                    WCNMA             6                          179732
     C                   PARM      CCY           WCYCD             3                          179732
     C**********         PARM                    WACODA            4                   179732 CGL029
     C                   PARM                    WACODA                                       CGL029
     C                   PARM                    WACSN             2                          179732
     C                   PARM      *BLANKS       WNONB             2                          179732
     C                   PARM      BRCA          WBRCD             3                          179732
     C                   PARM      *BLANKS       WCSSN            10                          179732
     C                   PARM      *BLANKS       WPNOI             1                          179732
     C     SDNOST        PARM      SDNOST        DSFDY                                        179732
      *                                                                                       179732
     C     WWRTCD        IFEQ      *BLANKS                                                    179732
     C                   MOVE      'Y'           @NOSTR            1                          179732
     C                   ELSE                                                                 179732
     C                   MOVE      'N'           @NOSTR                                       179732
     C                   ENDIF                                                                179732
      *
      * Account must be open to be valid
      *
     C     DACC          IFNE      *ZERO
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Value date after date account opened?
      *
     C     MTIVD         IFLT      DACO
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
      *
      * Retail a/c?
      *
     C     ACNO          IFNE      *ZERO
      *
      *  Back valued posting within back value period?
      *
     C     MTIVD         IFLT      BJRDNB
     C*
     C     BJRDNB        SUB       MTIVD         W#BACK
     C     W#BACK        IFGT      BJBVPD
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
      *
      *  Check status of retail account?
      *
     C     TIREAS        IFEQ      'Y'
     C*
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
     C*
     C     TIDCIN        IFEQ      'D'
     C                   TESTB     '02'          RETB                 87
     C     *IN87         IFEQ      *OFF
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
     C*
     C     TIDCIN        IFEQ      'C'
     C                   TESTB     '13'          RETB                 87
     C     *IN87         IFEQ      *OFF
     C                   MOVE      'Y'           W#HTB
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
     C*
      ***Stopped*cheques for this account?                                      156165
     C*****ACNO          CHAIN     STOPCL1                            86        156165
     C******IN86         IFEQ      *OFF                                         156165
     C*****              MOVE      'Y'           W#HTB                          156165
     C*****              GOTO      ENDVAL                                       156165
     C*****              ENDIF                                                  156165
     C*
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDVAL        TAG
      *
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
     C***********        MOVE      ACNO          BTRACN                   160811
     C                   Z-ADD     ACNO          BTRACN                   160811
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
      * Call access program for Midas Modules details                           179679
     C                   CALL      'AOMMODR0'                                   179679
     C                   PARM      '*MSG    '    WWRTCD            7            179679
     C                   PARM      '*FIRST  '    WWOPTN            7            179679
     C     SDMMOD        PARM      SDMMOD        DSFDY                          179679
      *                                                                         179679
     C     WWRTCD        IFNE      *BLANK                                       179679
     C                   MOVEL     '*FIRST'      DBKEY                          179679
     C                   MOVEL     'SDMMODPD'    DBFILE                         179679
     C                   Z-ADD     7             DBASE                          179679
     C                   EXSR      *PSSR                                        179679
     C                   ENDIF                                                  179679
      *                                                                         179679
      * Allow future or backvalued date if account is retail.                   179679
     C     ATYP          IFEQ      'R'                                          179679
     C                   Z-ADD     MTIVD         BTVLDT
     C                   ELSE                                                   179679
      * Otherwise allow backvalued date if management accounts is on.           179679
     C     BGNVST        IFEQ      'Y'                                          179679
     C     MTIVD         ANDLE     BJRDNB                                       179679
     C                   Z-ADD     MTIVD         BTVLDT                         179679
     C                   ELSE                                                   179679
      * Otherwise set date to run date as a GL account would require.           179679
     C                   Z-ADD     BJRDNB        BTVLDT                         179679
     C                   ENDIF                                                  179679
     C                   ENDIF                                                  179679
      * Narrative Code
     C                   CLEAR                   BTNVCD
      * Narrative Description
     C*****ATYP**********IFEQ      'R'                                          139756
     C*****ATYP**********OREQ      'N'                                          139756
     C*******************MOVEL     TINAR1        BTNRDC                         139756
     C*******************ELSE                                                   139756
     C                   CLEAR                   BTNRDC                         157551
     C     TIDLTP        CAT       TIDLRF        BTNRDC
     C*******************ENDIF                                                  139756
      * Account Type
     C                   MOVE      ATYP          BTACTY
      * Assoc. Customer No.
     C*****ASOC*         IFNE      *ZERO                                               144700 CSD027
     C     ASOC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      ASOC          BTACNB
     C                   ELSE                                                   144700
     C                   MOVE      *BLANKS       BTACNB                         144700
     C                   ENDIF                                                  144700
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
     C                   MOVE      'Y'           W#HTB                                        152041
     C                   ELSE                                                                 152041
     C* Assign work field to file field values.                                               152041
     C                   MOVE      A1COIN        BTCOIN                                       152041
     C                   ENDIF                                                                152041
     C                   ENDIF                                                                152041
     C*                                                                                       152041
      * SWIFT Common Reference
     C                   CLEAR                   BTSWCR
      * Profit Centre
     C*******************MOVE      TIPRFC        BTPRCN                                       179732
     C                   CLEAR                   BTPRCN                                       179732
      *                                                                                       179732
     C     ATYP          IFEQ      'N'                                                        179732
     C     ATYP          OREQ      'R'                                                        179732
     C     @NOSTR        OREQ      'Y'                                                        179732
     C     PRFC          IFNE      *BLANKS                                                    179732
     C                   MOVE      PRFC          BTPRCN                                       179732
     C                   ENDIF                                                                179732
     C                   ENDIF                                                                179732
      *                                                                                       179732
      * Default profit centre using TI ICD if PRFC is blank and AA is OFF                     179732
     C     BTPRCN        IFEQ      *BLANKS                                                    179732
     C     BGN0ST        ANDNE     'Y'                                                        179732
     C                   MOVE      TIPRFC        BTPRCN                                       179732
     C                   ENDIF                                                                179732
      *                                                                                       179732
      * Default profit centre using default matrix if PRFC is blank and AA is ON              179732
     C     BTPRCN        IFEQ      *BLANKS                                                    179732
     C     BGN0ST        ANDEQ     'Y'                                                        179732
     C                   MOVE      ASOC          CUST                                         179732
     C                   CALLB     'AOPRFMR0'                                                 179732
     C                   PARM                    RTCD              1                          179732
     C                   PARM      TIBOOK        BOOK              2            Book Code     179732
     C                   PARM      TIDLTP        TRTP              5            TransactonType179732
     C                   PARM      *BLANKS       SUTP              2            Sub Type      179732
     C                   PARM      BRCA          BRAN              3            Branch Code   179732
     C                   PARM      *BLANKS       DEPT1             3            Deptment Code 179732
     C                   PARM      ##USER        USER             10            User          179732
     C                   PARM      BBACOC        ACOF              2            AccountOfficer179732
     C                   PARM                    CUST              6            CustomerNumber179732
     C                   PARM                    DPRFC             4            Profit Centre 179732
      *                                                                                       179732
     C     RTCD          IFNE      '0'                                                        179732
     C     DPRFC         OREQ      FTUAPC                                                     179732
     C                   MOVE      TIPRFC        BTPRCN                                       179732
     C                   ELSE                                                                 179732
     C                   MOVE      DPRFC         BTPRCN                                       179732
     C                   ENDIF                                                                179732
     C                   ENDIF                                                                179732
      *                                                                                       179732
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
      *                                                                         CEU029
      * If EMU Midas-TI Interface Enhancement is switched on                    CEU029
      * then write Original Currency and Amount to GLJENPPD.                    CEU029
      *                                                                         CEU029
     C     CEU029        IFEQ      'Y'                                          CEU029
     C                   MOVEL     TIOCCY        BTOCCY                         CEU029
     C                   Z-ADD     TIOAMT        BTOAMT                         CEU029
     C                   ELSE                                                   CEU029
     C                   eval      BTOCCY = *BLANKS                             CEU029
     C                   eval      BTOAMT = 0                                   CEU029
     C                   ENDIF                                                  CEU029
     C/COPY WNCPYSRC,TIH00001
      *
      * Write Record
     C                   WRITE     @BTREMG
      *
     C/COPY WNCPYSRC,TI0340MC03
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
      *
     C                   MOVE      W#CBN         BRBTNB
      *                                                                         159339
      * If closing the header then find the correct batch                       159339
      *                                                                         159339
     C     BRBTNB        CHAIN     @BRREAG                            4646      159339
      * Branch
     C                   MOVE      TIBRCH        BRBCDA
      * Department
     C                   MOVE      TIDEPT        BRDPCD
      * Workstation id
      *                                                                         156998
      * Default Workstation ID correctly                                        156998
      *                                                                         156998
     C                   CLEAR                   BRWSID                         156998
     C*****              MOVEL     'MOPERQ'      BRWSID                         156998
     C                   MOVEL     'TI-BATCH'    BRWSID                         156998
      * Hash amount
     C     W##AMT        DIV       1000          Amount           15 3
     C*
     C                   CALLB     'ZZADD'
     C                   PARM                    Amount
     C                   PARM      *ZERO         IntPart          15 0
     C                   PARM      *ZERO         DecPart           3 0
     C*
     C                   Z-ADD     IntPart       BRHICC
     C                   Z-ADD     DecPart       BRHDCC
     C                   Z-ADD     IntPart       BRHIIN
     C                   Z-ADD     DecPart       BRHDIN
      * Hash Item Number
     C                   Z-ADD     W#POSC        BRHINC
     C                   Z-ADD     W#POSC        BRHINI
      *                                                                         159339
      * Batch is now flagged as in use until fully closed                       159339
      *                                                                         159339
      * Batch in use flag
     C*****              MOVE      'N'           BRBIUF                         159339
      * Shadow Post Indicator
     C                   MOVE      'N'           BRSHPI
      * Multiple Branch Batch
     C                   MOVE      'Y'           BRMBRB
      * Batch Description
     C                   MOVE      *BLANKS       BRBDES                         156304
     C                   MOVEL     C#CUST        BRBDES
      * Type of Journal Entry
     C                   MOVEL     'J'           BRTOJE
      *
     C                   CLEAR                   BRRAPI
      *                                                                         159339
      * This flag now used as work field to inidicate an open                   159339
      * batch                                                                   159339
      *                                                                         159339
     C*****              CLEAR                   BRRVVD                         159339
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
      *                                                                         159339
      * Update or Write depending on whether a record exists for an             159339
      * open batch                                                              159339
      *                                                                         159339
     C     *IN46         IFEQ      *ON                                          159339
     C     W#STCD        IFNE      'F'                                          159339
     C                   MOVE      'Y'           BRBIUF                         159339
     C                   MOVE      'O'           BRRVVD                         159339
     C                   MOVEL     C#BTIU        BRBDES                         159339
     C                   ELSE                                                   159339
     C                   MOVE      'N'           BRBIUF                         159339
     C                   MOVE      ' '           BRRVVD                         159339
     C                   MOVE      C#CUST        BRBDES                         159339
     C                   ENDIF                                                  159339
      *                                                                         159339
     C     W#HTB         IFEQ      'Y'                                          159339
     C                   MOVE      'H'           BRBTSF                         159339
     C                   ELSE                                                   159339
     C                   MOVE      ' '           BRBTSF                         159339
     C                   ENDIF                                                  159339
      *
     C/COPY WNCPYSRC,TI0340MC06
     C*****              WRITE     @BRREMA                                      159339
     C                   WRITE     @BRREAG                                      159339
      *                                                                                      BUG2798
     C                   MOVEL     BRBTNB        B3BTNB                                      BUG2798
     C                   MOVEL     'N'           B3DUMP                                      BUG2798
     C                   WRITE     GLBTNOD0                                                  BUG2798
      *
     C                   ELSE                                                   159339
     C                   MOVE      'N'           BRBIUF                         159339
     C                   MOVE      ' '           BRRVVD                         159339
     C     W#HTB         IFEQ      'Y'                                          159339
     C                   MOVE      'H'           BRBTSF                         159339
     C                   ELSE                                                   159339
     C                   MOVE      'A'           BRBTSF                         159339
     C/COPY WNCPYSRC,TI0340MC01
     C                   ENDIF                                                  159339
     C                   UPDATE    @BRREAG                                      159339
     C                   ENDIF                                                  159339
      *
     C                   MOVE      *OFF          *IN46                          159339
      *                                                                         159339
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
      * First Call?
      *
     C     W#ONCE        IFEQ      *BLANK
     C                   MOVE      'Y'           W#ONCE            1
      *
      *  Copyright Statement.
      *
     C                   MOVEA     CPY@          MKI@             80
      *
     C                   CLEAR                   DBASE
      *
      *  Retrieve Bank Details
      *
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
      *                                                                                       214390
     C                   CALL      'AOTIINR0'                                                 214390
     C                   PARM      '    '        WWRTCD                                       214390
     C                   PARM      '*FREE '      WWOPTN                                       214390
     C     SDTIIN        PARM      SDTIIN        DSFDY                                        214390
      *
      *  Retrieve TI Details
      *
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
     C*                                                                                       179732
     C**  Check that AA is switched on using SDMMODPD and if it is                            179732
     C**  Validate that TIPRFC is a valid profit centre.                                      179732
     C*                                                                                       179732
     C                   CALL      'AOMMODR0'                                                 179732
     C                   PARM      '*DBERR '     @RTCD             7                          179732
     C                   PARM      '*FIRST '     @OPTN             7                          179732
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        179732
     C*   Error?                                                                              179732
     C     WWRTCD        IFNE      *BLANKS                                                    179732
     C                   MOVEL     '*FIRST'      DBKEY                                        179732
     C                   MOVEL     'SDMMODPD'    DBFILE                                       179732
     C                   Z-ADD     13            DBASE                                        179732
     C                   EXSR      *PSSR                                                      179732
     C                   ENDIF                                                                179732
     C*                                                                                       179732
     C** If AA is ON validate that TIPRFC is a valid profit centre.                           179732
     C*                                                                                       179732
     C     BGN0ST        IFEQ      'Y'                                                        179732
     C                   CALLB     'AOPRFCR0'                                                 179732
     C                   PARM      '       '     @RTCD                                        179732
     C                   PARM      '*VERIFY'     @OPTN                                        179732
     C                   PARM      TIPRFC        @KEY              4                          179732
     C     SDPRFC        PARM      SDPRFC        DSFDY                                        179732
     C*                                                                                       179732
     C     @RTCD         IFNE      *BLANKS                                                    179732
     C                   MOVEL     'TIPRFC'      DBKEY                                        179732
     C                   MOVEL     'SDPRFCPD'    DBFILE                                       179732
     C                   Z-ADD     14            DBASE                                        179732
     C                   EXSR      *PSSR                                                      179732
     C                   ENDIF                                                                179732
     C*                                                                                       179732
     C**  (AA is ON) Obtain the 'Unallocated Profit Centre' from PF/SDPCACPD                  179732
     C*                                                                                       179732
     C                   CALL      'AOPCACR0'                                                 179732
     C                   PARM      *BLANKS       @RTCD             7                          179732
     C                   PARM      '*FIRST '     @OPTN             7                          179732
     C     SDPCAC        PARM      SDPCAC        DSFDY                                        179732
     C*   Error?                                                                              179732
     C     @RTCD         IFNE      *BLANKS                                                    179732
     C                   MOVEL     '*FIRST'      DBKEY                                        179732
     C                   MOVEL     'SDPCACPD'    DBFILE                                       179732
     C                   Z-ADD     12            DBASE                                        179732
     C                   EXSR      *PSSR                                                      179732
     C                   ENDIF                                                                179732
     C                   ENDIF                                                                179732
     C*
      *
      ** Access SAR details file to determine if CEU029 is installed.           CEU029
      *                                                                         CEU029
     C                   CALL      'AOSARDR0'                                   CEU029
     C                   PARM      '       '     ##RTCD            7            CEU029
     C                   PARM      '*VERIFY'     ##OPTN            7            CEU029
     C                   PARM      'CEU029'      ##SARD            6            CEU029
      *                                                                         CEU029
      ** Database Error                                                         CEU029
      *                                                                         CEU029
     C     ##RTCD        IFNE      *BLANK                                       CEU029
     C     ##RTCD        ANDNE     '*NRF   '                                    CEU029
     C                   Z-ADD     9             DBASE                          CEU029*********
     C                   MOVEL     'SCSARDPD'    DBFILE                         CEU029RROR 9  *
     C                   MOVEL     '*CALL'       DBKEY                          CEU029*********
     C                   EXSR      *PSSR                                        CEU029
     C                   ENDIF                                                  CEU029
     C*                                                                         CEU029
     C     ##RTCD        IFEQ      *BLANK                                       CEU029
     C                   MOVEL     'Y'           CEU029            1            CEU029
     C                   ELSE                                                   CEU029
     C                   MOVEL     'N'           CEU029                         CEU029
     C                   ENDIF                                                  CEU029
     C/COPY WNCPYSRC,TI0340MC04
     C*                                                                         CEU029
      *  Set current batch number from data area TIBATCH
      *  If this is blank then set current batch no. as TILRBN
      *
     C     *DTAARA       DEFINE    TIBATCH       BTCHNM          128
     C                   IN        BTCHNM
     C                   MOVEL     BTCHNM        W#CBNA
     C     W#CBNA        IFEQ      *BLANKS
     C                   Z-ADD     TILRBN        W#CBN
     C                   ENDIF
      *                                                                                       214454
      *  Verify if header found is not for a previously completed batch.                      214454
      *                                                                                       214454
     C     W#CBNA        CHAIN     @BRREAG                            46                      214454
     C     *IN46         IFEQ      *OFF                                                       214454
     C     BRBIUF        ANDEQ     ' '                                                        214454
     C                   ADD       1             W#CBN                                        214454
      *                                                                                       214454
      * Update data area TIBATCH with next batch number                                       214454
     C     *LOCK         IN        BTCHNM                                                     214454
     C                   MOVEL     W#CBNA        BTCHNM                                       214454
     C                   OUT       BTCHNM                                                     214454
     C                   END                                                                  214454
     C                   MOVE      *OFF          *IN46                                        214454
      *
      *  Last Batch Reached
     C                   MOVE      'N'           W#LBR             1
      *  STOP Increment
     C*****TIMXBS        DIV       10            W#STIN                         156162
      *  Not waiting for new postings
     C                   MOVE      'N'           W#WAIT            1
     C*****              MOVE      'N'           W#ONCE                         151069
      *
      *  Initialise CurrArr array with Currency Codes from SDCURRPD
     C                   Z-ADD     NumbOfCurr    RealNCurr         3 0
     C                   CALL      'AOCURRR0'
     C                   PARM      '        '    WWRTCD
     C                   PARM      '*FIRST  '    WWOPTN
     C                   PARM      *BLANK        WWKEY3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
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
     C                   CLOSE     TIPOSTL2
     C                   OPEN      TIPOSTL2
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
      *                                                                         151069
      * Check last batch number of post not equal to header batch number        151069
      *                                                                         151069
     C                   MOVE      TIURBN        BTNO              3            151069
     C*****              Z-ADD     0             W#BAT                   151069 159339
     C                   Z-ADD     0             W#HBAT                         151069
     C     BTNO          SETGT     @BTREMG4                                     151069
     C                   READP     @BTREMG4                               47    151069
     C*****              MOVE      BTBTNB        W#BAT             3 0   151069 159339
     C******IN47         IFEQ      *OFF                                  151069 159339
     C*****BTNO          SETGT     @BRREAG                               151069 161512
     C*****              READP     @BRREAG                         48    151069 161512
     C     BTNO          SETGT     @BRREAH                                      161512
     C                   READP     @BRREAH                                48    161512
     C                   MOVE      BRBTNB        W#HBAT            3 0          151069
     C*****W#BAT         IFNE      W#HBAT                                151069 159339
     C     W#HBAT        IFGE      TILRBN                                       159339
     C     W#HBAT        ANDLE     TIURBN                                       159339
     C     BRRVVD        ANDEQ     'O'                                          159339
     C     BRBIUF        ANDEQ     'Y'                                          159339
     C                   MOVE      BTBINB        W#POSC                         151069
     C                   ENDIF                                                  151069
     C*****              ENDIF                                           151069 159339
      *  Read in the details of the data area TI0340                            156162
     C                   IN        W#034T                                       156162
     C                   MOVEL     W#034T        W#0340            5            156162
      *
     C     K#ACCN        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
      *
     C     K#POST        KLIST
     C                   KFLD                    TRANID                                       212558
     C                   KFLD                    TIDLBR
     C**********         KFLD                    TIDLTP                                       212558
     C**********         KFLD                    TIDLRF                                       212558
     C                   KFLD                    TIEVRF                                       212558
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
     C     *LIKE         DEFINE    P#STCD        W#STCD
     C******LIKE         DEFINE    TILRBN        W#STIN                         156162
     C******LIKE         DEFINE    TILRBN        W#STNP                         156162
     C     *LIKE         DEFINE    BJBVPD        W#BACK
     C     *LIKE         DEFINE    TIMXBS        W#POSC
     C     *LIKE         DEFINE    TIAMNT        W##AMT
     C     *LIKE         DEFINE    TIAMNT        W#AMNT                         144700
      *
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
      *
      * Hold the batch if total debits not equal to total credits
      *
     C*****DebEQCred     IFEQ      'N'                                          151069
     C     DebEQCred     IFNE      'Y'                                          151069
     C                   MOVE      'Y'           W#HTB
     C                   ENDIF
     C*
     C     W#HTB         IFEQ      'Y'
     C                   MOVE      'H'           BRBTSF
     C                   MOVE      W#CBNA        P#BATN
     C     W#STCD        IFEQ      'S'
     C                   MOVE      'F'           W#STCD
     C                   ELSE
     C                   MOVE      'H'           W#STCD
     C                   ENDIF
     C*
     C                   ELSE
     C*  Batch Accepted
     C                   MOVE      'A'           BRBTSF
     C                   MOVE      'A'           W#STCD
     C                   MOVE      W#CBNA        P#BATN
     C/COPY WNCPYSRC,TI0340MC02
     C                   ENDIF
      *
      *  Write record to the Journal Entry Header File
      *
     C                   EXSR      GLJENH
      *
     C                   COMMIT
      * Submit an accepted batch to MIDAS                                       162449
     C     W#STCD        IFEQ      'A'                                          162449
     C                   CALL      'GLSBMBCH'                                   162449
     C                   PARM      *BLANK        WWRTCD                         162449
     C                   PARM      P#BATN        WWBATNO           3            162449
     C                   ENDIF                                                  162449
      *
      * Increment the current batch number
      *
     C                   ADD       1             W#CBN
      *
      * Update data area TIBATCH with next batch number
      *
     C     *LOCK         IN        BTCHNM
     C                   MOVEL     W#CBNA        BTCHNM
     C                   OUT       BTCHNM
      *
      * Set up the next batch
      *
      *   Postings Counter
     C                   Z-ADD     *ZERO         W#POSC
      *   Hold the Batch
     C                   MOVE      'N'           W#HTB             1
      *  Hash Total Amount
     C                   Z-ADD     *ZERO         W##AMT
      *   Clear the multiple-occurrence DS which holds total amounts            150221
     C                   CLEAR     *ALL          TotalsDS                       150221
      *   STOP No. of Postings
     C*****              Z-ADD     W#STIN        W#STNP                         156162
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
      *
     C                   MOVE      'Y'           W#WAIT
      * If this is the last batch of the day then force the close after         156162
      * all the postings have been processed.                                   156162
     C     W#STCD        IFEQ      'S'                                          156162
     C     W#POSC        ANDNE     0                                            156162
     C                   EXSR      CLOSE                                        156162
     C                   ENDIF                                                  156162
      *                                                                         151069
      * Commit changes within this call to the program                          151069
      *                                                                         151069
     C                   COMMIT                                                 151069
      *
      * End
     C*****W#STCD        IFEQ      'S'                                          151069
     C*****W#STCD        OREQ      'F'                                          151069
     C                   SETON                                        LR
     C*****              ENDIF                                                  151069
     C                   RETURN
      *
      *
     C                   ENDSR
      *
     C/COPY WNCPYSRC,TI0340MC05
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
      *
     C                   SETON                                        U7U8LR
      *
      ***  Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
      * Database error report
     C                   OPEN      TI0340AU
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   CLOSE     TI0340AU
      *
     C                   DUMP
     C                   ENDIF
      *
      ** Exit program
     C                   RETURN
      *
      *
     C                   ENDSR
      *****************************************************************         151069
      *                                                               *         151069
      *  RELDDT - Reload details for batch.                           *         151069
      *                                                               *         151069
      *  Called By: Detl                                              *         151069
      *                                                               *         151069
      *****************************************************************         151069
      *                                                                         151069
     C     RELDDT        BEGSR                                                  151069
      *                                                                         151069
     C     *LOVAL        SETLL     GLJENPL4                                     151069
     C     BTBTNB        CHAIN     @BTREMG4                           50        151069
     C                   MOVE      BTBTNB        W#BTNB            3            151069
      *                                                                         151069
      *  Loop to re-load debit and credit info for this batch.                  151069
      *                                                                         151069
     C     *IN50         DOWEQ     *OFF                                         151069
      *                                                                         151069
     C                   Z-ADD     1             Index                          151069
     C     BTCYCD        LOOKUP    CurrArr(Index)                         10    151069
     C     *IN10         IFEQ      '0'                                          151069
     C*****              MOVEL     CCY           DBKEY                   151069 159339
     C                   MOVEL     BTCYCD        DBKEY                          159339
     C                   MOVEL     'Array   '    DBFILE                         151069
     C*****              Z-ADD     9             DBASE                   151069 159339
     C                   Z-ADD     11            DBASE                          159339
     C                   EXSR      *PSSR                                        151069
     C                   ENDIF                                                  151069
      *                                                                         151069
     C     Index         OCCUR     TotalsDS                                     151069
     C     BTDCIN        IFEQ      'D'                                          151069
     C*****              ADD(H)    TIAMNT        TotDebit                151069 159339
     C                   ADD(H)    BTPTAM        TotDebit                       159339
     C                   ELSE                                                   151069
     C*****              ADD(H)    TIAMNT        TotCredit               151069 159339
     C                   ADD(H)    BTPTAM        TotCredit                      159339
     C                   ENDIF                                                  151069
      *                                                                         151069
      * Validate Posting details, including currency decimal places.            151069
      * to reset W#HTB (Held batch flag)                                        151069
      *                                                                         151069
     C                   EXSR      VALID2                                       151069
      *                                                                         151069
      * Determine appropriate factor of 10.                                     151069
      * Update Hash Total Amount                                                151069
      *                                                                         151069
     C     A6NBDP        IFEQ      0                                            151069
     C     BTPTAM        MULT      1000          W#AMNT                         151069
     C                   ENDIF                                                  151069
     C     A6NBDP        IFEQ      1                                            151069
     C     BTPTAM        MULT      100           W#AMNT                         151069
     C                   ENDIF                                                  151069
     C     A6NBDP        IFEQ      2                                            151069
     C     BTPTAM        MULT      10            W#AMNT                         151069
     C                   ENDIF                                                  151069
     C                   ADD(H)    W#AMNT        W##AMT                         151069
      *                                                                         151069
     C     BTBTNB        READE     @BTREMG4                               50    151069
     C*****BTBTNB        CHAIN     @BTREMG4                           50        151069
     C                   ENDDO                                                  151069
      *                                                                         151069
      *   Reset flag for batch info complete.                                   151069
      *                                                                         151069
     C                   MOVE      'N'           W#ONCE                         151069
      *                                                                         151069
     C                   ENDSR                                                  151069
     C*                                                                         151069
      *****************************************************************         151069
      *                                                               *         151069
      *  VALID2 - Validate the fields                                 *         151069
      *                                                               *         151069
      *  Called By: RELDDT                                            *         151069
      *  Calls    : AOBRCHR0, AOCUSTR0, AOCURRR0, AOACODR0            *         151069
      *                                                               *         151069
      *****************************************************************         151069
     C     VALID2        BEGSR                                                  151069
      *                                                                         151069
      * Validate branch code                                                    151069
      *                                                                         151069
     C**********         CALL      'AOBRCHR0'                                          151069 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG    '    WWRTCD                         151069
     C                   PARM      '*KEY    '    WWOPTN                         151069
     C                   PARM      BTIBCA        WWKEY3                         151069
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 151069 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *  Error?                                                                 151069
     C     WWRTCD        IFNE      *BLANKS                                      151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
      *                                                                         151069
      * Validate Customer                                                       151069
      *                                                                         151069
     C                   MOVEL     BTCUST        WWKY10                         151069
     C                   CALL      'AOCUSTR0'                                   151069
     C                   PARM      '*MSG    '    WWRTCD                         151069
     C                   PARM      '*KEY    '    WWOPTN                         151069
     C                   PARM                    WWKY10           10            151069
     C                   PARM      *BLANKS       WWKYST            7            151069
     C     SDCUST        PARM      SDCUST        DSSDY                          151069
      *  Error?                                                                 151069
     C     WWRTCD        IFNE      *BLANKS                                      151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
      *                                                                         151069
      * Validate Currency                                                       151069
      *                                                                         151069
     C                   CALL      'AOCURRR0'                                   151069
     C                   PARM      '*MSG    '    WWRTCD            7            151069
     C                   PARM      '*KEY    '    WWOPTN            7            151069
     C                   PARM      BTCYCD        WWKEY3            3            151069
     C     SDCURR        PARM      SDCURR        DSSDY                          151069
      *  Error?                                                                 151069
     C     WWRTCD        IFNE      *BLANKS                                      151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
      *                                                                         151069
      * Validate Currency                                                       151069
      *                                                                         151069
     C                   MOVE      BTACCD        WWKEY4                         151069
     C                   CALL      'AOACODR0'                                   151069
     C                   PARM      '*MSG    '    WWRTCD            7            151069
     C                   PARM      '*KEY    '    WWOPTN            7            151069
     C**********         PARM                    WWKEY4            4                   151069 CGL029
     C                   PARM                    WWKEY4                                       CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                          151069
      *  Error?                                                                 151069
     C     WWRTCD        IFNE      *BLANKS                                      151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
      *                                                                         151069
      * Get Account                                                             151069
     C                   MOVE      BTCUST        CNUM                           151069
     C                   MOVE      BTCYCD        CCY                            151069
     C                   MOVE      BTACCD        ACOD                           151069
     C                   MOVE      BTACSN        ACSQ                           151069
     C                   MOVE      BTIBCA        BRCA                           151069
      *                                                                         151069
     C     K#ACCN        CHAIN     ACCNT                              88        151069
     C     *IN88         IFEQ      *ON                                          151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
      *                                                                         151069
      * Account must be open to be valid                                        151069
      *                                                                         151069
     C     DACC          IFNE      *ZERO                                        151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
      *                                                                         151069
      * Value date after date account opened?                                   151069
      *                                                                         151069
     C     BTVLDT        IFLT      DACO                                         151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
      *                                                                         151069
      * Retail a/c?                                                             151069
      *                                                                         151069
     C     ACNO          IFNE      *ZERO                                        151069
      *                                                                         151069
      *  Back valued posting within back value period?                          151069
      *                                                                         151069
     C     BTVLDT        IFLT      BJRDNB                                       151069
     C*                                                                         151069
     C     BJRDNB        SUB       BTVLDT        W#BACK                         151069
     C     W#BACK        IFGT      BJBVPD                                       151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
     C                   ENDIF                                                  151069
      *                                                                         151069
      *  Check status of retail account?                                        151069
      *                                                                         151069
     C     TIREAS        IFEQ      'Y'                                          151069
     C*                                                                         151069
      *   Bit 0 - Refer Debits?                                                 151069
      *   Bit 1 - Refer Credits?                                                151069
      *   Bit 2 - Block Debits?                                                 151069
      *   Bit 3 - Block Credits?                                                151069
      *   Bit 4 - Account is Inactive?                                          151069
      *   Bit 6 - Bankrupt/Liquidation?                                         151069
      *   Bit 7 - Bad Debt?                                                     151069
     C                   TESTB     '467'         RETB                 87        151069
     C     *IN87         IFEQ      *OFF                                         151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
     C*                                                                         151069
     C     BTDCIN        IFEQ      'D'                                          151069
     C                   TESTB     '02'          RETB                 87        151069
     C     *IN87         IFEQ      *OFF                                         151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
     C                   ENDIF                                                  151069
     C*                                                                         151069
     C     BTDCIN        IFEQ      'C'                                          151069
     C                   TESTB     '13'          RETB                 87        151069
     C     *IN87         IFEQ      *OFF                                         151069
     C                   MOVE      'Y'           W#HTB                          151069
     C                   GOTO      ENDVAL2                                      151069
     C                   ENDIF                                                  151069
     C                   ENDIF                                                  151069
     C*                                                                         151069
      ***Stopped*cheques for this account?                               151069 156165
     C*****ACNO          CHAIN     STOPCL1                     86        151069 156165
     C******IN86         IFEQ      *OFF                                  151069 156165
     C*****              MOVE      'Y'           W#HTB                   151069 156165
     C*****              GOTO      ENDVAL2                               151069 156165
     C*****              ENDIF                                           151069 156165
     C                   ENDIF                                                  151069
     C*                                                                         151069
     C                   ENDIF                                                  151069
      *                                                                         151069
     C     ENDVAL2       TAG                                                    151069
      *                                                                         151069
      *                                                                         151069
     C                   ENDSR                                                  151069
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
