     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058769
/*STD *  RPGSQLBND                                                    *                     MD058769
/*EXI *  TEXT('Midas GL Interbranch entries at item level')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0263 - Batch Transactions File Split Report.               *
      *                                                               *
      *  Function:  This program produces the Batch Transactions      *
      *             Report. No file updates are undertaken.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. MD058769           Date 21Sep21               *
      *  Prev Amend No. 250625             Date 10Mar22               *
      *                 CSD103             Date 10Aug20               *
      *                 MD056082           Date 22Jun20               *
      *                 MD055739           Date 22May20               *
      *                 MD055146           Date 04Feb20               *
      *                 MD050138           Date 12Apr18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD037270           Date 26Apr16               *
      *                 AR1097467          Date 19Apr13               *
      *                 CLE134             Date 01Aug12               *
      *                 CAP208             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 172408             Date 02Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 01MAR99               *
      *                 CTI002             Date 23Sep98               *
      *                 CCB003 *Create     Date 10Oct96               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058769 - Deliverable Data Split for SDNARRPD and TABLETP   *
      *  250625 - Discrepancy in use of indicators between GL0263     *
      *           and GL0263P1 (Recompile)                            *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD056082 - GLC0263 failed but batch with discrepancy was not *
      *             reported on GL0263AU. Outputs every record read   *
      *             by calling the EXCPT command inside the loop.     *
      *  MD055739 - CoB GLC0263 fails with no indication of reason    *
      *             Change printer file record type to E to generate  *
      *             report. Comment out condition *IN50 IFEQ '0' to   *
      *             proceed processing of report details. Set ON U8   *
      *             when discrepancy occurs for error processing.     *
      *  MD055146 - Failed MXC004802 seq. 00001 and others            *
      *             Increase Branches to 900.                         *
      *  MD050138 - Component GLC0263 00001 runs for many hours       *
      *           - Need to initialise ACDIDX to 9000                 *
      *           - Wrong indicator being checked when determining if *
      *             ACOD details already on #ACK array                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037270 - Component GLC0263 00001 looping. System unable to *
      *             load all narratives correctly. Increase array for *
      *             account codes and narratives.                     *
      *  AR1097467B - Expected 15% COB run optimization not met       *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  172408 - Amounts are not shown in the report if the currency *
      *           has 2 decimal places.  Indicator used for Printer   *
      *           File not the same as of the indicator used in RPG.  *
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
      *  CCB003 - COB Performance Enhancements - Task Split           *
      *           This program is essentially a copy of GL0260 with   *
      *           all file updates removed.                           *
      *           Management Accounts Enhancement for PCA included:   *
      *           Do not produce report details if CMC001 feature is  *
      *           installed.                                          *
      *                                                               *
      *****************************************************************
      *
     FGLJENHL2  IF   E           K DISK
     FGLJENPL0  IF   E           K DISK
     F*SDNARRL1* IF   E           K DISK                                                    MD058769
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     FSDBRCHL1  IF   E           K DISK                                                         AR10
     FSDCURRL1  IF   E           K DISK                                                         AR10
     FGL0263AU  O    F  132        PRINTER INFDS(SPOOLU)
     F                                     OFLIND(*INOF)
     FGL0263P1  O    E             PRINTER INFDS(SPOOL)
     F                                     OFLIND(*IN10)
     F                                     USROPN
      *
      *****************************************************************
      *
      *     02 - NO RECORD FOUND ON CHAIN TO ACCNT
      *     08 - CONDITIONS OUTPUT OF DETAILS
      *     10 - OVERFLOW INDICATOR
      *     40 - POSTING CURRENCY HAS ZERO DECIMAL POINTS
      *     41 - POSTING CURRENCY HAS ONE DECIMAL POINTS
      ******42*-*POSTING*CURRENCY*HAS*TWO*DECIMAL*POINTS***************   172408
      *     43 - POSTING CURRENCY HAS THREE DECIMAL POINTS
      *     44 - POSTING CURRENCY HAS TWO DECIMAL POINTS                  172408
      *     46 - DISCREPANCY BETWEEN NO. OF ITEMS READ AND CALCULATED
      *     47 - NEGATIVE HASH TOTAL.
      *     48 - ARRAY WORK IND IN SR/TOTREP
      *     49 - Cache Hit for Branch Codes                                               AR1097467B
      *     50 - END OF GLJENHL2 FILE
      *     51 - PRINT HEADING AND OUTPUT MANPO HEADER.
      *     52 - Cache Hit for Narrative Codes                                            AR1097467B
      *     53 - Cache Hit for Currency Codes                                             AR1097467B
      *     54 - Cache Hit for Account Codes                                              AR1097467B
      *     64 - END OF GLJENPL0 FILE
      *     65 - UNSUCCESSFUL CHAIN TO NARRATIVE CODES FILE
      *     70 - MULTIBRANCHED ENVIRONMENT
      *     71 - ERROR ON ACCESSING GENERAL LEDGER DETAILS
      *     72 - REPORT JOURNAL INTER-BRANCH ENTERIES AT ITEM LEVEL
      *     73 - BATCH PROCESSED IS MULTIBRANCHED
      *     74 - REPORT INTERBRANCH ENTERIES VIA MAIN BRANCH
      *     76 - POSTING BRANCH *NE MAIN BRANCH
      *     77 - GENERATED ENTRY IS DEBIT
      *
      ***U7+U8*-*DATABASE ERROR                                                             MD055739
      ******U8*-*ONE OR MORE BATCHES HAVE DISCREPANCY.                                      MD055739
      *  U7+U8 - DATABASE ERROR AND/OR                                                      MD055739
      *          ONE OR MORE BATCHES HAVE DISCREPANCY
      *****************************************************************
      *
     D DELT            S             17    DIM(1) CTDATA PERRCD(1)
      ** Array to pick up narrative deleted message
      *
     D NARR            S             30    DIM(5) CTDATA PERRCD(1)
      ** Array to pick up narrative for interbranch
      *
     D BRCY            S              6    DIM(500)
     D BCDR            S             15  0 DIM(500)
     D BCCR            S             15  0 DIM(500)
      ** Arrays to process branch ccy totals
      *
     D**********          #BCH      900  3                                       AR1097467B MD055146
     D #BCH            S              3    DIM(999)
     D**********          #NAR      300  2                                       AR1097467B MD037270
     D #NAR            S              2    DIM(900)
     D #CCY            S              3    DIM(250)
      ** Arrays to process full caches                                                    AR1097467B
      *
     D**********          #ACD      300 13 0             Account Codes Array     AR1097467B MD037270
     D**********          #ACS      300 13 0             Account Codes Sorted    AR1097467B MD037270
     D**********          #ACK      300 10               Account Codes Cache Key AR1097467B MD037270
     D #ACD            S             13  0 DIM(9000)                            Account Codes Array
     D #ACS            S             13  0 DIM(9000)                            Account Codes Sorted
     D #ACK            S             10    DIM(9000)                            Account Codes Cache
      ** Arrays to process LRU caches                                                     AR1097467B
      *
     D CCCY            S              3    DIM(100)
     D CCDR            S             15  0 DIM(100)
     D CCCR            S             15  0 DIM(100)
      ** Arrays to process ccy totals
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D SPOOL           DS
     D  SFILE                 83     90
     D  SFNUM                123    124B 0
      *
     D SPOOLU          DS
     D  SFILEU                83     90
     D  SFNUMU               123    124B 0
      *
     D***CURLOD*     DS                        100                                        AR1097467B
      ***DS*to*store*Currency*details**********************************                   AR1097467B
     D**********                              1   3 CURC                                  AR1097467B
     D**********                              4   4 NODEC                                 AR1097467B
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D W0BITM          DS             6
      ** DS for source of posting
     D  BNUMSP                 1      3
     D  ITEMSP                 4      6  0
      *
     D D@OTST          DS
      ** DS to split OTST for input length
     D  OTST                   1     10
     D  OTST2                  3     10
      *
     D D@LOAN        E DS                  EXTNAME(SDLOANPD)
      ** Loan Types/Sub-Types DS for validation of Transaction Type
      *
     D D@INTY        E DS                  EXTNAME(INTYPD)
      ** Instrument Type  DS for validation of Transaction Type
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Module details
      *
     D***SDBRCH*   E DSSDBRCHPD                                                           AR1097467B
     D***SDBRCH*   E DSSDBRCHPD                900                               AR1097467B MD055146
     D SDBRCH        E DS                  OCCURS(999) EXTNAME(SDBRCHPD)                          MD
      ** Branch code
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General ledger details
      *
     D***SDACOD*   E DSSDACODPD                                                           AR1097467B
     D***SDACOD*   E DSSDACODPD                300                               AR1097467B MD037270
     D SDACOD        E DS                  OCCURS(9000) EXTNAME(SDACODPD)                         MD
      ** Account code
     D  ATYP         E                     EXTFLD(A5ACTY)
     D  ACSC         E                     EXTFLD(A5ACSC)
     D  QQACCX       E                     EXTFLD(QQACCD)
      *
     D***SDCURR*   E DSSDCURRPD                                                           AR1097467B
     D SDCURR        E DS                  OCCURS(250) EXTNAME(SDCURRPD)                        AR10
     D***SDNARR*   E DSSDNARRPD                300                               AR1097467B MD037270
     D*SDNARR***     E DS                  OCCURS(900) EXTNAME(SDNARRPD)                 MD MD058769
     D SDNARX        E DS                  OCCURS(900) EXTNAME(SDNARRPD)                    MD058769
     D SDNARR        E DS                  EXTNAME(SDNARJW0)                                MD058769
     D                                     PREFIX(X)                                        MD058769
     D  PNAR1        E                     EXTFLD(ALDON)                                    MD058769
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable Features Details
     D  LCDX         E                     EXTFLD(LCD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for Access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Array for Object Copyright Statement
      *
      *****************************************************************
      *
     I@BRTHCJ
     I              BRBTNB                      BNUMH
     I              BRHINC                      NII
     I              BRDPCD                      DPMT
     I              BRBTSF                      STAT
      *
     I@BTREAK
     I              BTBTNB                      BNUM
     I              BTBINB                      ITEM
     I              BTCUST                      CNUMA
     I              BTCYCD                      CCY
     I              BTACCD                      ACODA
     I              BTACSN                      ACSQA
     I              BTVLDT                      VALD
     I              BTNVCD                      NARC
     I              BTTRTY                      TRATA
     I              BTNRDC                      PNAR
     I              BTPTAM                      PSTA
     I              BTACNB                      ASOCA
     I              BTCQNB                      CHQNA
     I              BTACTY                      ATYP
     I              BTSWCR                      SWCR
     I              BTTSTY                      OTST
     I              BTPRCN                      PRFCA
     I              BTBKCD                      BOKCA
     I              BTNITM                      NITMS
      *
     I*@ALREC0*                                                                             MD058769
     I*********     ALDON                       PNAR1                                       MD058769
      *
     IACCNTABF
     I              RECI                        CRECI
     I              CNUM                        CCNUM
     I              CCY                         CCYC
     I              ACOD                        CACOD
     I              ACSQ                        CACSQ
     I              BRCA                        CBRCA
     I              ATYP                        CATYP
     I              ACST                        CACST
     I              PRFC                        CPRFC
     I              RRNM                        CRRNM
      ** Long DS for Access programs
     I/COPY WNCPYSRC,GL0263I001
      *
      *================================================================
     C                   EXSR      INIT
      *
     C                   EXSR      MAIN
      *
     C                   EXSR      END
      *****************************************************************
      * MAIN - Main processing
      *****************************************************************
     C     MAIN          BEGSR
      *
     C                   EXCEPT    HEADER
      ** Read batch header record
     C                   READ      GLJENHL2                               50
     C/COPY WNCPYSRC,GL0263C001
      *
     C     *IN50         DOWEQ     '0'
      *
      ** Batch status flag of A or S.
     C     STAT          IFEQ      'A'
     C     STAT          OREQ      'S'
      *
      ** OBTAIN THE HEADER BRANCH DETAILS
     C                   Z-ADD     BCHARR        B
     C     BRBCDA        LOOKUP    #BCH(B)                                49
     C     *IN49         IFEQ      '1'
     C     B             OCCUR     SDBRCH
     C                   ELSE
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BRBCDA        @DSNB             3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL     @DSNB         DBKEY
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** SAVE INTERNAL CUSTOMER NO., Due To & Due From ACCOUNT CODE
      ** FOR HEADER BRANCH
     C**********           MOVE A8BICN    BICNHD  60                                          CSD027
     C                   MOVE      A8BICN        BICNHD            6
     C**********           MOVE A8DTAC    ADTOH   40                                          CGL029
     C**********           MOVE A8DFAC    ADFRH   40                                          CGL029
     C                   MOVE      A8DTAC        ADTOH            10 0
     C                   MOVE      A8DFAC        ADFRH            10 0
      *
      ** INCREMENT BATCHES COUNT.
     C                   ADD       1             COUNT             4 0
      *
      ** CHECK IF BATCH IS MULTIBRANCHED
     C     BGMBIN        COMP      'Y'                                    73
      *
      ** RESET THE NUMBER OF POSTINGS READ AND PROCESSED TO 0
     C                   Z-ADD     0             BTCH              5 0
      *
      ** CHECK IF BATCH IN FILE AND SET IND08 ACCORDINGLY
     C     DPMT          COMP      '   '                              0808
      *
     C     BNUMH         CHAIN     GLJENPL0                           64
      *
      ** LOOP TO EXTRACT ITEMS FROM BATCH TRANSACTION FILE.
      *
     C     *IN64         DOWEQ     '0'
      *
     C     NARC          IFNE      '  '
      *
     C                   Z-ADD     NARARR        C
     C     NARC          LOOKUP    #NAR(C)                                52
     C     *IN52         IFEQ      '1'
     C                   MOVEL     ALDON         PNAR
     C                   ELSE
     C                   MOVEL     DELT(1)       PNAR
     C                   ENDIF
     C********** NARC      CHAINSDNARRL1             65                                   AR1097467B
     C********** *IN65     IFEQ '1'                                                       AR1097467B
     C**********           MOVELDELT,1    PNAR                                            AR1097467B
     C**********           ELSE                                                           AR1097467B
     C**********           MOVELPNAR1     PNAR                                            AR1097467B
     C**********           ENDIF                                                          AR1097467B
      *
     C                   ENDIF
      *
      ** Store the value of PNAR
     C                   MOVE(P)   PNAR          NARA             30
      *
     C     *IN64         IFEQ      '0'
      *
      ** Format Original Transaction Type
     C                   MOVE      *BLANK        OTTP
     C                   MOVE      *BLANK        WUAPRC            7
      *
      ** If account is Retail, chain to ACCNT to check that account
      ** exists and is not closed.
      *
      ** Key fields to be used for CHAIN
     C     KEYFLD        KLIST
     C**********           KFLD           NUM     60                                          CSD027
     C                   KFLD                    NUM               6
     C                   KFLD                    CY                3
     C**********           KFLD           COD     40                                          CGL029
     C                   KFLD                    COD              10 0
     C                   KFLD                    ASQ               2 0
     C                   KFLD                    BRC               3
      *
     C                   MOVE      CNUMA         NUM
     C                   MOVE      CCY           CY
     C                   MOVE      ACODA         COD
     C                   MOVE      ACSQA         ASQ
     C                   MOVE      BTIBCA        BRC
      *
     C     KEYFLD        CHAIN     ACCNTABF                           02
      *
     C     *IN02         IFEQ      '0'
     C     CATYP         ANDEQ     'R'
     C     CRECI         ANDNE     'D'
     C     *IN02         OREQ      '1'
     C     ATYP          ANDEQ     'R'
      *
      ** Read posting branch information for batch item.
     C                   Z-ADD     BCHARR        B
     C     BTIBCA        LOOKUP    #BCH(B)                                49
     C     *IN49         IFEQ      '1'
     C     B             OCCUR     SDBRCH
     C                   ELSE
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BTIBCA        @DSNB             3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL     @DSNB         DBKEY
     C                   Z-ADD     9             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Change account of posting to suspense account, and change
      ** narrative to show the original account number.
      ** Note - this assumes that the suspense account is type 'G'
      *
     C                   MOVEL     CNUMA         STOR1             9
     C                   MOVE      CCY           STOR1
     C**********           MOVELACODA     STOR2   6                                           CGL029
     C                   MOVEL     ACODA         STOR2            12
     C                   MOVE      ACSQA         STOR2
     C**********           MOVELSTOR1     STOR   15                                           CGL029
     C                   MOVEL     STOR1         STOR             21
     C                   MOVE      STOR2         STOR
     C                   MOVE      *BLANK        PNAR
     C                   MOVEL     NARR(1)       PNAR
     C                   MOVE      STOR          PNAR
     C                   MOVE      CNUMA         ASOCA
     C                   MOVE      A8BICN        CNUMA
     C                   MOVE      BKACCD        ACODA
     C                   MOVE      '01'          ACSQA
     C                   MOVE      '00000'       TRATA
     C                   MOVE      '00000000'    CHQNA
     C                   Z-ADD     0             RRNM
     C                   MOVE      'G'           ATYP
     C                   Z-ADD     0             BTRACN
     C                   MOVE      *BLANK        BTCOIN
      *
     C                   ENDIF
      *
      ** FORMAT SOURCE OF POSTING DATA STRUCTURE
     C                   MOVE      BNUM          BNUMSP
     C                   Z-ADD     ITEM          ITEMSP
      *
      ** AND SETTING UP SOURCE OF POSTING
     C                   MOVE      BTIBCA        BRCA
     C                   ADD       1             ACTOT
     C                   EXSR      ACTYPE
      *
      ** Restore values of PNAR
     C                   MOVE(P)   NARA          PNAR
      *
      ** IF ENVIRONMENT IS MULTIBRANCHED AND IF WE ARE REPORTING
      ** INTER-BRANCH ENTERIES AT ITEM LEVEL AND IF MULTIBRANCHED
      ** BATCHES ARE USED, REPORT INTER-BRANCH ENTERIES
      *
     C     *IN70         IFEQ      '1'
     C     *IN72         ANDEQ     '1'
     C     *IN73         ANDEQ     '1'
      *
      ** CHECK THAT HEADER BRANCH IS NOT EQUAL TO POSTING BRANCH
      *
     C     BRBCDA        ANDNE     BTIBCA
      *
     C                   EXSR      HDPSBR
      *
      ** IF REPORTING INTER-BRANCH ENTERIES VIA MAIN BRANCH AND IF
      ** BATCH BRANCH NOT THE SAME AS MAIN BRANCH AND IF POSTING BRANCH
      ** DIFFERENT TO MAIN BRANCH, REPORT ADDITIONAL ENTRIES
      *
     C     *IN74         IFEQ      '1'
     C     BRBCDA        ANDNE     MAINB
     C     BTIBCA        ANDNE     MAINB
      *
     C                   EXSR      GENR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** OUTPUT RECORD
     C     PSTA          DIV       1000          ZZAMT
     C                   EXSR      GLZADD
     C                   ADD       1             BTCH
     C                   END
      *
     C     BNUMH         READE     GLJENPL0                               64
      *
     C                   ENDDO
      *
      ** TEST FOR DISCREPANCY
     C                   SETOFF                                       46
     C     BTCH          IFNE      NII
     C     NII           ANDNE     0
     C**********           SETON                     46U8                                   MD055739
     C                   SETON                                        46U8U7
     C                   ENDIF
      *
     C                   ENDIF
     C     *INOF         IFEQ      *ON
     C                   EXCEPT    HEADER
     C                   SETOFF                                       OF
     C                   ENDIF
     C                   EXCEPT    PROCES
      ** Read next batch header record
     C                   READ      @BRTHCJ                                50
      *
     C                   ENDDO
      *
      ** TOTAL TIME CALCULATIONS
     C                   EXSR      LRSR
      *
     C                   ENDSR
      *****************************************************************
      * HDPSBR - IF HEADER BRANCH NOT EQUAL TO POSTING BRANCH
      *          PRODUCE ONE POSTINGS FOR EACH BRANCH
      *****************************************************************
     C     HDPSBR        BEGSR
      *
      ** READ POSTING BRANCH INFORMATION
     C                   Z-ADD     BCHARR        B
     C     BTIBCA        LOOKUP    #BCH(B)                                49
     C     *IN49         IFEQ      '1'
     C     B             OCCUR     SDBRCH
     C                   ELSE
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BTIBCA        @DSNB             3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL     @DSNB         DBKEY
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
      *
     C**********           ELSE                                                           AR1097467B
     C                   ENDIF
     C                   ENDIF
      *
      ** SAVE INTERNAL CUSTOMER NO., Due To & Due From ACCOUNT CODE
      ** FOR POSTING BRANCH
     C**********           MOVE A8BICN    BICNPD  60                                          CSD027
     C                   MOVE      A8BICN        BICNPD            6
     C**********           MOVE A8DTAC    ADTOP   40                                          CGL029
     C**********           MOVE A8DFAC    ADFRP   40                                          CGL029
     C                   MOVE      A8DTAC        ADTOP            10 0
     C                   MOVE      A8DFAC        ADFRP            10 0
      *
     C**********           ENDIF                                                          AR1097467B
      *
      ** READ MAIN BRANCH INFORMATION
     C                   Z-ADD     BCHARR        B
     C     MAINB         LOOKUP    #BCH(B)                                49
     C     *IN49         IFEQ      '1'
     C     B             OCCUR     SDBRCH
     C                   ELSE
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      MAINB         @DSNB             3
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL     @DSNB         DBKEY
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
      *
     C**********           ELSE                                                           AR1097467B
     C                   ENDIF
     C                   ENDIF
      *
      ** SAVE INTERNAL CUSTOMER NO., Due To & Due From ACCOUNT CODE
      ** FOR MAIN BRANCH
     C**********           MOVE A8BICN    BICNMD  60                                          CSD027
     C                   MOVE      A8BICN        BICNMD            6
     C**********           MOVE A8DTAC    ADTOM   40                                          CGL029
     C**********           MOVE A8DFAC    ADFRM   40                                          CGL029
     C                   MOVE      A8DTAC        ADTOM            10 0
     C                   MOVE      A8DFAC        ADFRM            10 0
      *
     C**********           ENDIF                                                          AR1097467B
      *
     C     *IN74         IFEQ      '0'
     C     BRBCDA        OREQ      MAINB
     C     BTIBCA        OREQ      MAINB
     C                   MOVE      BICNHD        CNUMA
     C                   ELSE
     C                   MOVE      BICNMD        CNUMA
     C                   ENDIF
      *
     C                   MOVE      '01'          ACSQA
      *
     C     BTDCIN        IFEQ      'C'
     C                   MOVE      ADFRP         ACODA
     C                   MOVE      '1'           *IN77
     C                   ELSE
     C                   MOVE      ADTOP         ACODA
     C                   MOVE      '0'           *IN77
     C                   ENDIF
      *
      ** AND SETTING UP SOURCE OF POSTING
     C                   ADD       1             ACTOT
     C                   EXSR      ACTYPE
      *
      ** Setup the posting narrative for interbranch entries for
      ** entries branch level with NARR,1
     C                   MOVEL     NARR(1)       PNAR
     C                   MOVE      W0BITM        PNAR
      *
     C     CMC001        IFNE      'Y'
     C     CMC001        OREQ      'Y'
     C     STAT          ANDNE     'S'
      *
      ** FOR EACH NEW BRANCH PRODUCE A SEPARATE REPORT
      *
     C     BRBCDA        IFNE      BRCBX
      *
      ** WRITE CCY TOTALS IF APPLICABLE TO GL0263P1
     C                   SETON                                        10
      *
     C                   MOVE      CCY           @CCY              3
     C                   EXSR      TOTREP
     C                   MOVE      @CCY          CCY
      *
     C                   CLOSE     GL0263P1
     C                   SETON                                        10
     C                   OPEN      GL0263P1
      *
     C                   MOVE      BRBCDA        BRCBX             3
      *
      ** ENSURE REPORT SPOOL FILE RECORDED BY RCF
     C                   Z-ADD     SFNUM         SFNUM1            6 0
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      BRBCDA        SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    SFNUM1
     C                   PARM                    ZSERR             1
      *
      ** ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   Z-ADD     0             PAGE1
      *
     C                   ENDIF
      *
      ** CHECK CORRECT NO. OF DECIMALS FOR POSTING AMOUNT BY CHECKING
      ** TO SEE IF CURRENCY INPUT HAS BEEN ENTERED PREVIOUSLY
      *
     C**********           Z-ADD1         V       30                                      AR1097467B
      *****************************************************************                   AR1097467B
     C********** V         DOWLEW                                                         AR1097467B
     C********** *IN96     ANDNE'1'                                                       AR1097467B
      *****************************************************************                   AR1097467B
     C********** V         OCUR CURLOD                                                    AR1097467B
     C********** CCY       IFEQ CURC                                                      AR1097467B
     C**********           MOVE NODEC     A6NBDP                                          AR1097467B
     C**********           SETON                     96                                   AR1097467B
     C**********           ENDIF                                                          AR1097467B
     C**********           ADD  1         V                                               AR1097467B
      *****************************************************************                   AR1097467B
     C**********           ENDDO                                                          AR1097467B
      *****************************************************************                   AR1097467B
      ***IF*A*NEW*CCY*CODE,*THEN*OBTAIN*AND*LOAD*IN*DATA*STRUCTURE*****                   AR1097467B
      *****************************************************************                   AR1097467B
     C********** *IN96     IFEQ '0'                                                       AR1097467B
      *
     C     CCY           IFNE      PRVCCY
     C                   Z-ADD     CURARR        A
     C     CCY           LOOKUP    #CCY(A)                                53
     C     *IN53         IFEQ      '1'
     C     A             OCCUR     SDCURR
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    CCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
      *
     C**********           ELSE                                                           AR1097467B
     C                   ENDIF
     C                   ENDIF
      *
     C**********           ADD  1         W       30                                      AR1097467B
     C********** W         OCUR CURLOD                                                    AR1097467B
     C**********           MOVE CCY       CURC                                            AR1097467B
     C**********           MOVE A6NBDP    NODEC                                           AR1097467B
     C**********           ENDIF                                                          AR1097467B
     C                   MOVEL     CCY           PRVCCY
     C                   ENDIF
      *
     C     A6NBDP        COMP      1                                    4041
     C***********A6NBDP    COMP 2                    43  42               172408
     C     A6NBDP        COMP      2                                  43  44                   17240
      *
     C     *IN40         IFEQ      '1'
     C                   MOVE      PSTA          PSTAA
     C                   ENDIF
      *
     C     *IN41         IFEQ      '1'
     C                   MOVE      PSTA          PSTAB
     C                   ENDIF
      *
     C*********  *IN42     IFEQ '1'                                       172408
     C     *IN44         IFEQ      '1'                                                         17240
     C                   MOVE      PSTA          PSTAC
     C                   ENDIF
      *
     C     *IN43         IFEQ      '1'
     C                   MOVE      PSTA          PSTAD
     C                   ENDIF
      *
      ** PRINT AN AUDIT OF THE OPERATION
      *
     C                   EXSR      OVRF
     C                   WRITE     D001
     C                   EXSR      OVRF
     C                   WRITE     D002
      *
     C                   MOVE      BTIBCA        BRCA
      *
     C                   EXSR      AUDIT
      *
     C                   ENDIF
      *
     C     BTDCIN        IFEQ      'C'
     C                   MOVE      '0'           *IN77
     C                   MOVE      ADTOH         ACODA
     C                   ELSE
     C                   MOVE      ADFRH         ACODA
     C                   MOVE      '1'           *IN77
     C                   ENDIF
      *
     C     *IN74         IFEQ      '0'
     C     BRBCDA        OREQ      MAINB
     C     BTIBCA        OREQ      MAINB
     C                   MOVE      BICNPD        CNUMA
     C                   ELSE
     C                   MOVE      BICNMD        CNUMA
     C                   ENDIF
      *
     C                   MOVE      BRBCDA        BRCA
      *
     C                   ADD       1             ACTOT
     C                   EXSR      ACTYPE
      *
      ** Setup the posting narrative for interbranch entries for
      ** batch branch level with NARR,2
      *
     C                   MOVEL     NARR(2)       PNAR
     C                   MOVE      W0BITM        PNAR
      *
     C     CMC001        IFNE      'Y'
     C     CMC001        OREQ      'Y'
     C     STAT          ANDNE     'S'
      *
      ** PRINT AN AUDIT OF THE OPERATION
      *
     C                   EXSR      AUDIT
      *
     C                   ENDIF
      *
      ** ADD POSTING AMOUNT TO HASH TOTAL
      *
     C     PSTA          ADD       PSTA          PSTA2            15 0
     C     PSTA2         DIV       1000          ZZAMT            15 3
     C                   EXSR      GLZADD
      *
     C     ENDHD         ENDSR
      *****************************************************************
      * GENR - SET UP INFORMATION FOR REPORT OF INTERBRANCH ENTRIES
      *****************************************************************
     C     GENR          BEGSR
      *
     C                   MOVE      BICNPD        CNUMA
     C                   MOVE      MAINB         BRCA
      *
      ** Set Debit/Credit Indicator AND ACCOUNT CODE FOR BATCH BRANCH
     C     BTDCIN        IFEQ      'C'
     C                   MOVE      '0'           *IN77
     C                   MOVE      ADTOM         ACODA
     C                   ELSE
     C                   MOVE      '1'           *IN77
     C                   MOVE      ADFRM         ACODA
     C                   ENDIF
      *
     C                   ADD       1             ACTOT
     C                   EXSR      ACTYPE
      *
      ** Setup the posting narrative for interbranch entries for
      ** main/entries branch level with NARR,3
      *
     C                   MOVEL     NARR(3)       PNAR
     C                   MOVE      W0BITM        PNAR
      *                                                                   CMC001
     C     CMC001        IFNE      'Y'
     C     CMC001        OREQ      'Y'
     C     STAT          ANDNE     'S'
      *
      ** PRINT AN AUDIT OF THE OPERATION
      *
     C                   EXSR      AUDIT
      *
     C                   ENDIF
      *
     C                   MOVE      BICNHD        CNUMA
      *
      ** Set Debit/Credit Indicator AND ACCOUNT CODE
     C     BTDCIN        IFEQ      'C'
     C                   MOVE      '1'           *IN77
     C                   MOVE      ADFRM         ACODA
     C                   ELSE
     C                   MOVE      '0'           *IN77
     C                   MOVE      ADTOM         ACODA
     C                   ENDIF
      *
     C                   ADD       1             ACTOT
     C                   EXSR      ACTYPE
      *
      ** Setup the posting narrative for interbranch entries for
      ** main/batch branch level with NARR,4
      *
     C                   MOVEL     NARR(4)       PNAR
     C                   MOVE      W0BITM        PNAR
      *
     C     CMC001        IFNE      'Y'
     C     CMC001        OREQ      'Y'
     C     STAT          ANDNE     'S'
      *
      ** PRINT AN AUDIT OF THE OPERATION
      *
     C                   EXSR      AUDIT
      *
     C                   ENDIF
      *
      ** ADD POSTING AMOUNT TO HASH TOTAL
     C     PSTA          ADD       PSTA          PSTA2
     C     PSTA2         DIV       1000          ZZAMT            15 3
     C                   EXSR      GLZADD
      *
     C                   ENDSR
      *****************************************************************
      * AUDIT - TO PRINT A REPORT OF THE RECORDS PROCESSED
      *
      * Called by: HDPSBR, GENR
      *****************************************************************
     C     AUDIT         BEGSR
      *
     C                   EXSR      OVRF
      *
     C                   WRITE     D003
      *
      ** UPDATE BRANCH CCY TOTALS
     C                   MOVEL     BRCA          BRCYKY            6
     C                   MOVE      CCY           BRCYKY
      *
     C                   Z-ADD     1             B                 3 0
     C     BRCYKY        LOOKUP    BRCY(B)                                48
     C     *IN48         IFEQ      '0'
     C                   Z-ADD     1             B
     C     *BLANK        LOOKUP    BRCY(B)                                48
     C     *IN48         IFEQ      '1'
     C                   MOVE      BRCYKY        BRCY(B)
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN48         IFEQ      '1'
     C     *IN77         IFEQ      '1'
     C                   ADD       PSTA          BCDR(B)
     C                   ELSE
     C                   ADD       PSTA          BCCR(B)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * OVRF - HANDLE OVERFLOW
      *****************************************************************
     C     OVRF          BEGSR
      *
     C     *IN10         IFEQ      '1'
     C                   WRITE     H001
     C                   SETOFF                                       10
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * TOTREP - HANDLE END OF BRANCH TOTAL REPORTING
      *****************************************************************
     C     TOTREP        BEGSR
      *
     C                   Z-ADD     1             B
      *
     C     BRCY(B)       DOWNE     *BLANK
     C     B             ANDLE     500
      *
     C     BCDR(B)       IFNE      0
     C     BCCR(B)       ORNE      0
      *
     C                   MOVE      BRCY(B)       CCY
     C                   MOVEL     BRCY(B)       BRCA
     C**********           Z-ADD1         V       30                                      AR1097467B
     C**********           SETOF                     96                                   AR1097467B
      *****************************************************************                   AR1097467B
     C********** V         DOWLEW                                                         AR1097467B
     C********** *IN96     ANDNE'1'                                                       AR1097467B
      *****************************************************************                   AR1097467B
     C********** V         OCUR CURLOD                                                    AR1097467B
     C********** CCY       IFEQ CURC                                                      AR1097467B
     C**********           MOVE NODEC     A6NBDP                                          AR1097467B
     C**********           SETON                     96                                   AR1097467B
     C**********           ENDIF                                                          AR1097467B
     C**********           ADD  1         V                                               AR1097467B
      *****************************************************************                   AR1097467B
     C**********           ENDDO                                                          AR1097467B
     C     CCY           IFNE      PRVCCY
     C                   Z-ADD     CURARR        A
     C     CCY           LOOKUP    #CCY(A)                                53
     C     *IN53         IFEQ      '1'
     C     A             OCCUR     SDCURR
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    CCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     CCY           PRVCCY
     C                   ENDIF
      *
     C     A6NBDP        COMP      1                                    4041
     C***********A6NBDP    COMP 2                    43  42               172408
     C     A6NBDP        COMP      2                                  43  44                   17240
      *
     C     *IN40         IFEQ      '1'
     C                   MOVE      BCDR(B)       TDRAA
     C                   MOVE      BCCR(B)       TCRAA
     C                   ENDIF
      *
     C     *IN41         IFEQ      '1'
     C                   MOVE      BCDR(B)       TDRAB
     C                   MOVE      BCCR(B)       TCRAB
     C                   ENDIF
      *
     C*********  *IN42     IFEQ '1'                                       172408
     C     *IN44         IFEQ      '1'                                                         17240
     C                   MOVE      BCDR(B)       TDRAC
     C                   MOVE      BCCR(B)       TCRAC
     C                   END
      *
     C     *IN43         IFEQ      '1'
     C                   MOVE      BCDR(B)       TDRAD
     C                   MOVE      BCCR(B)       TCRAD
     C                   ENDIF
      *
     C     *IN10         IFEQ      '1'
     C                   EXSR      OVRF
     C                   WRITE     T001
     C                   ENDIF
      *
     C                   WRITE     T002
      *
     C                   ENDIF
      *
     C                   Z-ADD     1             C                 3 0
     C     CCY           LOOKUP    CCCY(C)                                48
     C     *IN48         IFEQ      '0'
     C                   Z-ADD     1             C
     C     *BLANK        LOOKUP    CCCY(C)                                48
     C     *IN48         IFEQ      '1'
     C                   MOVE      CCY           CCCY(C)
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN48         IFEQ      '1'
     C                   ADD       BCDR(B)       CCDR(C)
     C                   ADD       BCCR(B)       CCCR(C)
     C                   ENDIF
      *
     C                   ADD       1             B
      *
     C                   ENDDO
      *
     C                   Z-ADD     0             BCDR
     C                   Z-ADD     0             BCCR
     C                   MOVE      *BLANK        BRCY
     C*                                                                   172408
     C** Move back the value of *IN96 for later processing.               172408
     C*                                                                   172408
     C                   MOVE      '0'           *IN96                                         17240
      *
     C                   ENDSR
      *****************************************************************
      * FINREP - HANDLE END OF REPORT TOTAL REPORTING
      *****************************************************************
     C     FINREP        BEGSR
      *
     C                   XFOOT     CCCR          CCCRT            15 0
      *
     C     CCCRT         IFNE      0
      *
     C                   CLOSE     GL0263P1
     C                   SETON                                        10
     C                   OPEN      GL0263P1
      *
      ** ENSURE REPORT SPOOL FILE RECORDED BY RCF
     C                   Z-ADD     SFNUM         SFNUM1            6 0
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SFILE
     C                   PARM                    SFNUM1
     C                   PARM                    ZSERR             1
      *
      ** ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   Z-ADD     0             PAGE1
      *
     C                   ENDIF
      *
     C                   Z-ADD     1             C
     C     CCCY(C)       DOWNE     *BLANK
     C     C             ANDLE     100
      *
     C     CCDR(C)       IFNE      0
     C     CCCR(C)       ORNE      0
     C                   MOVE      CCCY(C)       CCY
     C**********           Z-ADD1         V       30                                      AR1097467B
     C**********           SETOF                     96                                   AR1097467B
      **********8******************************************************                   AR1097467B
     C********** V         DOWLEW                                                         AR1097467B
     C********** *IN96     ANDNE'1'                                                       AR1097467B
      *****************************************************************                   AR1097467B
     C********** V         OCUR CURLOD                                                    AR1097467B
     C********** CCY       IFEQ CURC                                                      AR1097467B
     C**********           MOVE NODEC     A6NBDP                                          AR1097467B
     C**********           SETON                     96                                   AR1097467B
     C**********           ENDIF                                                          AR1097467B
      *****************************************************************                   AR1097467B
     C**********           ADD  1         V                                               AR1097467B
      *****************************************************************                   AR1097467B
     C**********           ENDDO                                                          AR1097467B
     C     CCY           IFNE      PRVCCY
     C                   Z-ADD     CURARR        A
     C     CCY           LOOKUP    #CCY(A)                                53
     C     *IN53         IFEQ      '1'
     C     A             OCCUR     SDCURR
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    CCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     CCY           PRVCCY
     C                   ENDIF
      *
     C     A6NBDP        COMP      1                                    4041
     C***********A6NBDP    COMP 2                    43  42               172408
     C     A6NBDP        COMP      2                                  43  44                   17240
      *
     C     *IN40         IFEQ      '1'
     C                   MOVE      CCDR(C)       FDRAA
     C                   MOVE      CCCR(C)       FCRAA
     C                   ENDIF
      *
     C     *IN41         IFEQ      '1'
     C                   MOVE      CCDR(C)       FDRAB
     C                   MOVE      CCCR(C)       FCRAB
     C                   ENDIF
      *
     C*********  *IN42     IFEQ '1'                                       172408
     C     *IN44         IFEQ      '1'                                                         17240
     C                   MOVE      CCDR(C)       FDRAC
     C                   MOVE      CCCR(C)       FCRAC
     C                   ENDIF
      *
     C     *IN43         IFEQ      '1'
     C                   MOVE      CCDR(C)       FDRAD
     C                   MOVE      CCCR(C)       FCRAD
     C                   ENDIF
      *
     C     *IN10         IFEQ      '1'
     C                   EXSR      OVRF
     C                   WRITE     F001
     C                   ENDIF
      *
     C                   WRITE     F002
      *
     C                   ENDIF
      *
     C                   ADD       1             C
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      * BANKD - OBTAIN THE BANK DETAILS
      *****************************************************************
     C     BANKD         BEGSR
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * GELRD - OBTAIN THE GENERAL LEDGER DETAILS
      *****************************************************************
     C     GELRD         BEGSR
      *
     C**********           CALL 'AOGELRR0'                                                    CGL029
     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C********** SDGELR    PARM SDGELR    DSFDY                                               CGL029
     C     SDGELR        PARM      SDGELR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   SETON                                        71
     C     *LOCK         IN        LDA
     C                   MOVE      'SDGELRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * *PSSR - Terminate the program
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   MOVEL(P)  'GL0263'      DBPGM
     C                   OUT       LDA
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C**********           EXCPT                                                   MD055739 MD056082
     C                   EXCEPT    HEADER
     C                   EXCEPT    DBERR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      * LRSR - Total time calculations when LR is ON
      *****************************************************************
     C     LRSR          BEGSR
      *
      ** ENSURE TOTALS SPOOL FILE RECORDED BY RCF
     C                   Z-ADD     SFNUMU        SFNUM2            6 0
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANK        SENTY
     C                   PARM                    SFILEU
     C                   PARM                    SFNUM2
     C                   PARM                    ZSERR
      *
      ** ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
      ***IF*NOT*INITIALISED*OUTPUT*HEADER*RECORD***********************                     MD055739
     C********** *IN50     IFEQ '0'                                                         MD055739
      *
     C                   EXSR      BANKD
      *
      ** WRITE HEADING FOR REPORT
     C                   SETON                                        51
      *
     C**********           ENDIF                                                            MD055739
      *
      ** WRITE CCY TOTALS IF APPLICABLE TO GL0263P1
     C                   SETON                                        10
     C                   EXSR      TOTREP
     C                   SETON                                        10
     C                   EXSR      FINREP
      *
      *    TOTAL TIME CALCULATIONS.
     C     ACTOT         ADD       2             RECS              5 0
     C     ZZTOTD        MULT      10            TOTD              4 0  47
     C  N47ZZTOTI        COMP      0                                    47
      *
     C                   ENDSR
      *****************************************************************
      * SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
      *   IND '99' IS SET BY AN OVERFLOW ERROR
      *****************************************************************
     C     GLZADD        BEGSR
      *
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS
      *
      * SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     C                   Z-ADD     ZZAMT         ZZWK1             3 3
     C                   MOVE      ZZWK1         ZZAMTD            3 0          DECIMAL FIELD
      *
      * BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
      *
     C                   EXSR      GLZSUM
      *
     C     ZZAEND        ENDSR
      *****************************************************************
      * GLZSUM - Calculate hash total of records                      *
      *                                                               *
      * Input  : ZZAMTI, ZZAMTD                                       *
      * Output : ZZTOTI, ZZTOTD, ZZNEGD, *IN96, *IN99                 *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ** Determine sign of ZZAMTI and ZZAMTD
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
      *
      ** Determine sign of ZZTOTI and ZZTOTD
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
      *
      ** If ZZTOTAL is 0, return ZZAMOUNT.
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND
      *
      ** If signs differ, bypass overflow checks.
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
      *
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
      *
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      ** If the modulus of ZZWK3 is < modulus of ZZTOTI, then overflow.
      ** If overflow, then *IN99 set ON, fields ZZTOTI and ZZTOTD left
      ** intact and ZZAMT zeroized.
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
      *
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
      *
      ** The signs are different
     C     ZZOFPS        TAG
      *
      ** If ZZAMTI or ZZAMTD were negative, make them positive
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
      *
      ** If ZZTOTI or ZZTOTD were negative, make them positive
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** All ZZAMTI, ZZAMTD, ZZTOTI and ZZTOTD are now positive.
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      ** If ZZTOT = ZZAMT, return 0.
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
      *
      ** If ZZTOT > ZZAMT
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
      *
      ** If ZZTOT < ZZAMT
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
      *
      ** Reverse sign of ZZTOT if larger input fields were negative
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed.
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG
      *
      ** If ZZTOTD = 0 and ZZTOTI < 0, set up ZZNEGD.
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
      *
     C                   ENDSR
      *****************************************************************
      * ACTYPE - OBTAIN RETAIL INDICATOR FROM ACCOUNT CODE
      *****************************************************************
     C     ACTYPE        BEGSR
      *
      ** Move account code to ACALFA via a numeric field to re-instate
      ** leading zeros if missing.
      *
     C**********           MOVE ACODA     @TACN   40                                          CGL029
     C**********           MOVE @TACN     ACALFA  4                                           CGL029
     C                   MOVE      ACODA         @TACN            10 0
     C                   MOVE      @TACN         ACALFA           10
      *
     C                   MOVE      @TACN         KEYACD
     C                   ADD       1             ACDSEQ
     C                   EXSR      CHKACD
      *                                                                                   AR1097467B
      ** Use details from array if ACDKEY is found, otherwise,                            AR1097467B
      ** retrieve details from program call                                               AR1097467B
      *                                                                                   AR1097467B
     C     ACDIC         IFEQ      'Y'
      *                                                                                   AR1097467B
      ** Set occurence to index found from #ACK array                                     AR1097467B
      *                                                                                   AR1097467B
     C     P             OCCUR     SDACOD
      *                                                                                   AR1097467B
     C                   ELSE
      *                                                                                   AR1097467B
     C     ACDIDX        IFNE      0
     C                   Z-ADD     ACDIDX        P
     C                   ELSE
     C                   Z-ADD     1             P
     C                   MOVEA     #ACD          #ACS
     C                   SORTA     #ACS
     C                   Z-ADD     #ACS(1)       ACDKEY
     C     ACDKEY        LOOKUP    #ACD(P)                                54
     C                   ENDIF
      *                                                                                   AR1097467B
     C     P             OCCUR     SDACOD
      *                                                                                   AR1097467B
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    ACALFA
     C********** SDACOD    PARM SDACOD    DSFDY                                               CGL029
     C     SDACOD        PARM      SDACOD        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EXSR      ADDACD
     C     ATYP          IFNE      'R'
     C                   Z-ADD     0             ACNO
     C                   ENDIF
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   MOVE      'SDACODPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *  INIT - Initial processing                                    *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Copyright statement
     C                   MOVEA     CPY@          MKI@             80
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
      *
     C                   Z-ADD     0             SDLB             15 0
     C                   Z-ADD     0             SDCB             15 0
     C                   MOVE      *BLANKS       OTRF             15
     C                   MOVE      *BLANKS       OTTP             10
     C                   MOVE      *BLANKS       OTST             10
     C                   MOVE      *BLANKS       PRVCCY            3
      *
     C                   Z-ADD     0             ZERO5             5 0
      *
     C                   Z-ADD     0             ACTOT             5 0
     C                   Z-ADD     0             RRNM              5 0
     C**********           Z-ADD0         DBCNUM  60                                          CSD027
      *                                                                                   AR1097467B
      ** LRU element key and record arrival sequence                                      AR1097467B
      *                                                                                   AR1097467B
     C                   Z-ADD     0             ACDKEY           13 0
     C     *LIKE         DEFINE    ACDKEY        ACDSEQ
      *                                                                                   AR1097467B
      ** Set start index to upper limit of LRU Caching arrays                             AR1097467B
      *                                                                                   AR1097467B
     C**********           Z-ADD300       ACDIDX  40                             AR1097467B MD050138
     C                   Z-ADD     9000          ACDIDX            4 0
     C     *LIKE         DEFINE    ACDIDX        ACDPRV
     C     *LIKE         DEFINE    ACDIDX        P
      *                                                                                   AR1097467B
      ** Initialize work fields of LRU array routines                                     AR1097467B
      *                                                                                   AR1097467B
     C                   MOVE      *BLANK        ACDIC             1
     C                   MOVE      *BLANKS       KEYACD           10
     C                   Z-ADD     300           ACDPRV
     C                   Z-ADD     300           P
      *
     C                   EXSR      BANKD
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDMMODPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     8             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** MULTIBRANCHED ENVIRONMENT?
     C     BGMBIN        COMP      'Y'                                    70
      *
     C                   EXSR      GELRD
      *
      ** REPORT INTERBRANCH ENTERIES?
     C     BKIEBI        COMP      'I'                                    72
     C     BKIEMB        COMP      'Y'                                    74
     C                   MOVE      BKMABR        MAINB             3
      *
      **  Check if Management Accounts Enhancement is installed
      *
     C                   MOVE      'N'           CMC001            1
     C                   CALL      'AOSARDR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CMC001'      @SARN             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         IFNE      '*NRF'
     C                   MOVE      *ON           *IN42
     C     *LOCK         IN        LDA
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   MOVEL     @SARN         DBKEY
     C                   MOVEL     '010'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           CMC001            1
     C                   ENDIF
      *                                                                                   AR1097467B
      ** Full Cache SDBRCHPD                                                              AR1097467B
      *                                                                                   AR1097467B
     C     *LOVAL        SETLL     SDBRCHL1
     C**********           Z-ADD900       B       30                             AR1097467B MD055146
     C                   Z-ADD     999           B                 3 0
     C     B             OCCUR     SDBRCH
     C                   READ      SDBRCHL1                               13
     C                   MOVE      A8BRCD        #BCH(B)
     C     *IN13         DOWEQ     '0'
     C     B             ANDGT     0
     C                   SUB       1             B
     C     B             OCCUR     SDBRCH
     C                   READ      SDBRCHL1                               13
     C                   MOVE      A8BRCD        #BCH(B)
     C                   ENDDO
     C     B             IFEQ      0
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     'OVRFLOW'     DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     B             BCHARR            3 0
      *                                                                                   AR1097467B
      ** Full Cache SDNARRPD                                                              AR1097467B
      *                                                                                   AR1097467B
     C******LOVAL        SETLL     SDNARRL1                                                 MD058769
     C**********           Z-ADD300       C       30                             AR1097467B MD037270
     C                   Z-ADD     900           C                 3 0
     C*****C****         OCCUR     SDNARR                                                   MD058769
     C     C             OCCUR     SDNARX                                                   MD058769
     C**********         READ      SDNARRL1                               13                MD058769
     C/EXEC SQL                                                                             MD058769
     C+ declare ACursor insensitive scroll cursor for                                       MD058769
     C+ select * from SDNARJW0                                                              MD058769
     C+ order by ALNVCD                                                                     MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ open ACursor                                                                        MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch next from ACursor into :SDNARR                                                MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C                   setoff                                       13                    MD058769
     C                   If        SQLCODE = 100                                            MD058769
     C                   seton                                        13                    MD058769
     C                   Endif                                                              MD058769
     C**********         MOVE      ALNVCD        #NAR(C)                                    MD058769
     C                   MOVE      XALNVCD       #NAR(C)                                    MD058769
     C                   MOVE      PNAR1         ALDON
     C     *IN13         DOWEQ     '0'
     C     C             ANDGT     0
     C                   SUB       1             C
     C                   EVAL      SDNARX = SDNARR                                          MD058769
     C*****C****         OCCUR     SDNARR                                                   MD058769
     C     C             OCCUR     SDNARX                                                   MD058769
     C***********        READ      SDNARRL1                               13                MD058769
     C/EXEC SQL                                                                             MD058769
     C+ fetch next from ACursor into :SDNARR                                                MD058769
     C/END-EXEC                                                                             MD058769
                                                                                            MD058769
     C                   setoff                                       13                    MD058769
     C                   If        SQLCODE = 100                                            MD058769
     C                   seton                                        13                    MD058769
     C                   Endif                                                              MD058769
     C**********         MOVE      ALNVCD        #NAR(C)                                    MD058769
     C                   MOVE      XALNVCD       #NAR(C)                                    MD058769
     C                   MOVE      PNAR1         ALDON
     C                   ENDDO
     C     C             IFEQ      0
     C                   MOVEL     'SDNARRPD'    DBFILE
     C                   MOVEL     'OVRFLOW'     DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     C             NARARR            3 0
      *                                                                                   AR1097467B
      ** Full Cache SDCURRPD                                                              AR1097467B
      *                                                                                   AR1097467B
     C     *LOVAL        SETLL     SDCURRL1
     C                   Z-ADD     250           A                 3 0
     C     A             OCCUR     SDCURR
     C                   READ      SDCURRL1                               13
     C                   MOVE      A6CYCD        #CCY(A)
     C     *IN13         DOWEQ     '0'
     C     A             ANDGT     0
     C                   SUB       1             A
     C     A             OCCUR     SDCURR
     C                   READ      SDCURRL1                               13
     C                   MOVE      A6CYCD        #CCY(A)
     C                   ENDDO
     C     A             IFEQ      0
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     'OVRFLOW'     DBKEY
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     A             CURARR            3 0
      *
     C                   ENDSR
      *****************************************************************
      * END - Final processing
      *****************************************************************
     C     END           BEGSR
      *
     C                   SETON                                            LR
     C**********           EXCPT                                                   MD055739 MD056082
     C                   EXCEPT    SUMMRY
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *                   AR1097467B
      *  CHKACD - Check Account Codes details to array                *                   AR1097467B
      *                                                               *                   AR1097467B
      *****************************************************************                   AR1097467B
     C     CHKACD        BEGSR
      *                                                                                   AR1097467B
      ** Reinitialize work fields                                                         AR1097467B
      *                                                                                   AR1097467B
     C                   MOVEL     *BLANK        ACDIC
     C                   MOVE      *OFF          *IN54
      *                                                                                   AR1097467B
      ** Check previous base rate details if it's                                         AR1097467B
      ** same with current details                                                        AR1097467B
      *                                                                                   AR1097467B
     C                   Z-ADD     ACDPRV        P
      *                                                                                   AR1097467B
      ** Defend against index being 0                                                     AR1097467B
      ** Set current index to starting index                                              AR1097467B
      *                                                                                   AR1097467B
     C     P             IFEQ      0
     C                   Z-ADD     ACDIDX        P
     C                   ENDIF
      *                                                                                   AR1097467B
      ** If the KEYACD being checked is the same then use the index                       AR1097467B
      ** of the current detail rather than doing a LOKUP                                  AR1097467B
      *                                                                                   AR1097467B
     C     KEYACD        IFEQ      #ACK(P)
     C                   MOVE      *ON           *IN54
     C                   ELSE
      *                                                                                   AR1097467B
     C     ACDIDX        IFEQ      0
     C                   Z-ADD     1             P
     C                   ELSE
     C                   Z-ADD     ACDIDX        P
     C                   ENDIF
      *                                                                                   AR1097467B
     C     KEYACD        LOOKUP    #ACK(P)                                54
     C                   ENDIF
      *                                                                                   AR1097467B
      ** Save the last accessed detail to ACDPRV                                          AR1097467B
      ** Set the indicator to show the data was found                                     AR1097467B
      *                                                                                   AR1097467B
     C********** *IN48     IFEQ *ON                                              AR1097467B MD050138
     C     *IN54         IFEQ      *ON
     C                   MOVE      ACDSEQ        #ACS(P)
     C                   Z-ADD     P             ACDPRV
     C                   MOVEL     'Y'           ACDIC
     C                   ENDIF
      *                                                                                   AR1097467B
     C                   ENDSR
      *****************************************************************                   AR1097467B
      *                                                               *                   AR1097467B
      *  ADDACD - Add Account Codes details to array                  *                   AR1097467B
      *                                                               *                   AR1097467B
      *****************************************************************                   AR1097467B
     C     ADDACD        BEGSR
      *                                                                                   AR1097467B
      *                                                                                   AR1097467B
     C     ACDIDX        IFNE      0
     C                   SUB       1             ACDIDX
     C                   ENDIF
      *                                                                                   AR1097467B
     C                   MOVEL     KEYACD        #ACK(P)
     C                   ADD       ACDSEQ        #ACS(P)
      *                                                                                   AR1097467B
      ** Set last accessed detail to ACDIDX So that CHKACD checks this                    AR1097467B
      ** latest detail first                                                              AR1097467B
      *                                                                                   AR1097467B
     C                   Z-ADD     P             ACDPRV
      *                                                                                   AR1097467B
     C                   ENDSR
      *****************************************************************                   AR1097467B
      *
     O*****GL0263AUD  203   51                                                              MD055739
     O*****GL0263AUE  203   51                                                     MD055739 MD056082
     O*******OR*       OF                                                                   MD056082
     OGL0263AU  E            HEADER         2 03                                                  MD
     O                                           24 'REFERENCE GL0263AU'
     O                       BJURPT              89
     O                                          104 'DATE'
     O                       BJMRDT             113
     O                                          122 'PAGE'
     O                       PAGE          Z    127
     O********D* 1     51                                                                   MD055739
     O********E* 1     51                                                          MD055739 MD056082
     O*******OR*       OF                                                                   MD056082
     O          E            HEADER         1
     O                                           70 'BATCH TRANSACTIONS FILE'
     O                                           76 'SPLIT'
     O********D* 1     51                                                                   MD055739
     O********E* 2     51                                                          MD055739 MD056082
     O*******OR*       OF                                                                   MD056082
     O          E            HEADER         1
     O                                           70 '-----------------------'
     O                                           76 '------'                                      MD
     O********D* 2     08 64                                                                MD055739
     O********E* 2     08 64                                                                MD056082
     O          E    08 64   PROCES         2
     O                                           19 'BATCH NO.-'
     O                       BNUM                23
     O                                           34 'ACTUAL -'
     O                       BTCH          3     39
     O                                           53 'PROCESSED -'
     O                       NII           3     58
     O               46                          75 '*** NO OF ITEMS'
     O               46                          92 'DISCREPANCY ***'
      *
     O********T* 203   LR U7 U8                                                             MD055739
     O********E* 203   LR U7 U8                                                    MD055739 MD056082
     O*******OR*       LRN50                                                                MD055739
     O*******AND       LRN46                                                       MD055739 MD056082
     O**********                         24 'REFERENCE GL0263AU'                            MD056082
     O**********               BJURPT    89                                                 MD056082
     O**********                        104 'DATE'                                          MD056082
     O**********               BJMRDT   113                                                 MD056082
     O**********                        122 'PAGE'                                          MD056082
     O**********               PAGE  Z  127                                                 MD056082
     O********T* 1     LR U7 U8                                                             MD055739
     O********E* 1     LR U7 U8                                                    MD055739 MD056082
     O*******OR*       LRN50                                                       MD055739 MD056082
     O*******AND       LRN46                                                                MD055739
     O**********                         70 'BATCH TRANSACTIONS FILE'                       MD056082
     O**********                         76 'SPLIT'                                         MD056082
     O********T* 2     LR U7 U8                                                             MD055739
     O********E* 2     LR U7 U8                                                    MD055739 MD056082
     O*******OR*       LRN50                                                                MD055739
     O*******AND       LRN46                                                       MD055739 MD056082
     O**********                         70 '-----------------------'                       MD056082
     O**********                         76 '------'                                        MD056082
     O********T* 2     LRNU7                                                                MD055739
     O********E* 2     LRNU7                                                       MD055739 MD056082
     O          E    LR 50   SUMMRY         2                                                     MD
     O                                           26 'NUMBER OF BATCHES'
     O                                           36 'PROCESSED'
     O                       COUNT         1     67
     O********T* 2     LRNU7                                                                MD055739
     O********E* 2     LRNU7                                                       MD055739 MD056082
     O          E    LR 50   SUMMRY         2
     O                                           26 'NUMBER OF ACCOUNT'
     O                                           43 'POSTINGS WRITTEN'
     O                       ACTOT         1     67
     O********T* 2     LRNU7                                                                MD055739
     O********E* 2     LRNU7                                                       MD055739 MD056082
     O          E    LR 50   SUMMRY         2
     O                                           26 'VALUE OF ACCOUNT '
     O                                           43 'POSTINGS WRITTEN'
     O                       ZZTOTI        Z     64
     O                       TOTD                68
     O                                           68 ' '
     O               47                          68 '-'
     O********T*3      LR U7 U8                                                             MD055739
     O          E    LR U7 U8DBERR       3                                                        MD
     O                                           44 '*** REFERENCE'
     O                       DBPGM               53
     O                                           71 '-DATABASE ERROR AT'
     O                       DBASE               75
     O********T*1      LR U7 U8                                                             MD055739
     O          E    LR U7 U8DBERR       1                                                        MD
     O                                           37 'FILE NAME'
     O                       DBFILE              48
     O                                           52 'KEY'
     O                       DBKEY               82
     O********T*3      LR                                                                   MD055739
     O********E*3      LR                                                          MD055739 MD056082
      *****************************************************************
** DELT
NARRATIVE DELETED
** NARR
INTERBRANCH-ENTRY BRNCH
INTERBRANCH-BATCH BRNCH
INTERBRC-MAIN/ENTRY BRC
INTERBRC-MAIN/BATCH BRC
ENTRY FOR A/C
** CPY@ - Object Copyright
(c) Finastra International Limited 2001
