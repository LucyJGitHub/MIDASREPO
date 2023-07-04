     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Account Balance and Historic Bal. Discrepancy Rpt')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  SMU90012 - Account Balance and History Balance Discrepancy   *
      *             Report and Update of Discrepant Accounts          *
      *                                                               *
      *  (c) Finastra International Banking Sytems Ltd. 2022          *
      *                                                               *
      *  Last Amend No. MD060124 *CREATE   Date 02Aug22               *
      *  Prev Amend No. MDnnnnnn           Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD060124 - Utility to correct discrepancies between history  *
      *             balance and account balance files.                *
      *           - Patterned fix to MD-53040                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
     FTABTBRE   IF   E             DISK    INFSR(*PSSR)
     FREHISSL   IF   E           K DISK    INFSR(*PSSR)
     FREACCNJL  IF   E           K DISK    INFSR(*PSSR)
     FRELINKJ2  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     FGEXZLL0   UF   E           K DISK
     F                                     RENAME(APOSTPDF:GEXZLF)
     FGEXZPPD   O  A F  620        DISK
     FSMU90012AUO    E             PRINTER INFDS(SPOOLU)
     FSMU90012P1O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN01)
     F                                     USROPN
     FSMU90012P2O    E             PRINTER INFDS(SPOOL2)
     F                                     OFLIND(*IN02)
     F                                     USROPN
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      * 01 - Overflow for SMU90012P1 printer file                     *
      * 02 - Overflow for SMU90012P2 printer file                     *
      * 05 - If history balance is equal to cleared balance           *
      * 19 - Retail account to be patched                             *
      * 41 - If no details to report                                  *
      * 70 - 0 decimal place                                          *
      * 71 - 1 decimal place                                          *
      * 72 - 2 decimal place                                          *
      * 73 - 3 decimal place                                          *
      * 79 - Multibranching indicator                                 *
      * 87 - Write 'End of Branch'                                    *
      * 88 - Link installed                                           *
      *                                                               *
      * 97 - Read error on REHISSL                                    *
      * 98 - Read error on ACCNT                                      *
      * 99 - General error and chaining                               *
      *                                                               *
      * U7 - Database error                                           *
      * U8 - Database error                                           *
      * LR - End of program                                           *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *   FIRST  - First cycle                                        *
      *   MPROC  - Main processing                                    *
      *   DETAIL - Detail processing                                  *
      *   TOTAL  - End processing                                     *
      *   SRGEAD - Calculate Adjustment                               *
      *   SRAUD  - Check primary/secondary a/c in GEXZPPD             *
      *   SRGEXZ - Output to GEXZPPD                                  *
      *   *PSSR  - Database error handling                            *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** KEY DATA STRUCTURE : RKEY TO MOVE IN DBKEY IF ERROR
      *
     D                 DS
     D  RKEY                   1     18
     D  ZCUST                  1      6
     D  ZACCY                  7      9
     D  ZACOQQ                10     13  0
     D  ZASEQ                 14     15  0
     D  ZBRCA                 16     18
      *
      **   FILE INFORMATION DATA STRUCTURE
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ** LOCAL DATA AREA FOR DATABASE ERROR DETAILS
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      **  Data Area RUNDAT
      *
     D RUNDT           DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *
      ** Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  TITL         E                     EXTFLD(BJURPT)
      *
      ** Data structure for retail details
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      *
      ** First DS for access programs, Short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access progrmas, Long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      **  External DS for Branch Codes.
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BRNM         E                     EXTFLD(A8BRNM)
      *
      **  External DS for Currency Codes.
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D  CDP          E                     EXTFLD(A6NBDP)
     D  SPOT         E                     EXTFLD(A6SPRT)
     D  MDIN         E                     EXTFLD(A6MDIN)
     D  ERLC         E                     EXTFLD(A6ERLC)
     D  TNOT         E                     EXTFLD(A6TXND)
     D  CCNM         E                     EXTFLD(A6CYNM)
     D  TACC         E                     EXTFLD(A6SPAE)
     D  SSNO         E                     EXTFLD(A6SSNB)
     I/EJECT
     IACCNTABF
     I              ACNO                        TACNO
     I              RRNM                        TRRNM
      *
     IFUSIONJF
     I              ACNO                        FACNO
     I              LTAB                        FLTAB
     I              LTAC                        FLTAC
     I              LTAS                        FLTAS
     IREHISPSF
     I              DRIS                        SDRIS
     I              CRIS                        SCRIS
     IGEXZLF
     I              BRCA                        GBRCA
     I              CNUM                        GCNUM
     I              CCY                         GCCY
     I              ACOD                        GACOD
     I              ACSQ                        GACSQ
     I              PSTA                        GPSTA
      *===================================================================
     C/EJECT
      *===================================================================
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** KEY LIST
      ** KEY FIELD TO READ ACCNT FILE
      *
     C     KRKEY         KLIST
     C                   KFLD                    ZCUST
     C                   KFLD                    ZACCY
     C                   KFLD                    ZACOD
     C                   KFLD                    ZASEQ
     C                   KFLD                    ZBRCA
      *
     C     LNKEY         KLIST
     C                   KFLD                    ZBRCA
     C                   KFLD                    ZCUST
     C                   KFLD                    ZACCY
     C                   KFLD                    ZACOD
     C                   KFLD                    ZASEQ
      *
      ** WORK FIELDS DEFINITION
      *
     C     *LIKE         DEFINE    ZHISB         WHISB
      ********************************************************************
     C/EJECT
      *===================================================================
      ** P R O G R A M     S T A R T
      *===================================================================
      *
      ** First Cycle Processing
      *
     C                   EXSR      FIRST
      *
      ** Main Processing
      *
     C                   READ      REACCJLF                               LR
     C                   MOVE      *BLANKS       BRCA#             3
      *
     C     *INLR         DOWEQ     '0'                                          - B1
     C                   SETOFF                                       41
      *
      ** Multibranching Processing
      *
     C     ZBRCA         IFNE      BRCA#
      *
     C     *IN87         IFEQ      '1'
     C                   WRITE     ENDP1
     C   88              WRITE     ENDP2
     C                   SETOFF                                       87
     C                   ENDIF
      *
     C                   MOVE      ZBRCA         BRCA#
      *
     C                   CLOSE     SMU90012P1
     C   88              CLOSE     SMU90012P2
     C                   OPEN      SMU90012P1
     C   88              OPEN      SMU90012P2
      *
     C                   SETON                                        87
     C                   Z-ADD     0             PAGE
     C                   Z-ADD     0             PAGE1
      *
      ** Retrieve Branch Name
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ZBRCA         @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ***************
     C                   MOVEL     @BRCA         DBKEY                          * DB ERROR 2  *
     C                   Z-ADD     2             DBASE                          ***************
     C                   OUT       LDA
     C                   WRITE     ERRP1
     C   88              WRITE     ERRP2
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   WRITE     HEADP1
     C   88              WRITE     HEADP2
     C                   ENDIF
      *
     C                   EXSR      MPROC
     C                   READ      REACCJLF                               LR
     C                   ENDDO                                                    - E1
      *
      ** Check GEXZPPD for Primary and Secondary Accounts at update mode
      *
     C                   EXSR      SRAUD
      *
      ** Total Processing
      *
     C                   EXSR      TOTAL
      *
      *===================================================================
      ** P R O G R A M     E N D
      *===================================================================
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  FIRST - Subroutine to execute first cycle.                      *
      *                                                                  *
      *  Called by : Main Program                                        *
      *  Calls: *PSSR                                                    *
      *                                                                  *
      ********************************************************************
     C     FIRST         BEGSR                                                  **FIRST BEGSR**
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
      *
     C                   SETON                                        41
      *
      ** INITIALISE LDA VARIABLES
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'SMU90012'    DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
      *
     C     MBIN          IFEQ      'Y'
     C                   SETON                                        79
     C                   ELSE
     C                   SETOFF                                       79
     C                   ENDIF
      *
      ** ACCESS SDRETLPD
      *
     C                   CALL      'AORETLR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** CHECK IF ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     003           DBASE                          ***************
     C                   MOVE      'SDRETLPD'    DBFILE                         * DBERROR 003 *
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SETOFF                                       69
      *
     C     BMCBAI        IFNE      'Y'
     C                   SETON                                        69
     C                   ENDIF
      *
      ** ACCESS TABTBRE TO CHECK LINK INSTALLED.
      *
     C     1             CHAIN     TABTBRE                            99
     C     LNKA          COMP      'Y'                                    88
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 001 *
     C                   Z-ADD     001           DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** OUTPUT AUDIT HEADER
      *
     C                   WRITE     HEADAU
      *
      ** INITIALISE ONE TIME FIELDS TO WRITE IN FILE AUDIT PRINTER
      *
     C                   Z-ADD     *ZEROS        NBRREC
      *
     C                   ENDSR                                                  **FIRST ENDSR**
      ********************************************************************
     C/EJECT
      ********************************************************************
      *
      *  MPROC - Subroutine to execute main processing.                  *
      *                                                                  *
      *  Called by: Main Program                                         *
      *  Calls: DETAIL                                                   *
      *                                                                  *
      ********************************************************************
     C     MPROC         BEGSR                                                  **MPROC BEGSR**
      *
     C     KRKEY         SETLL     ACCNT                                  99
      *
     C     *IN99         IFEQ      '1'                                          - B1
      *
      ** Access to ACCNT by key
      *
     C     KRKEY         READE     ACCNT                                  98
      *
     C     *IN98         DOWEQ     '0'                                          - B2
      *
      ** Update the retail accounts in error
      *
     C                   EXSR      DETAIL
      *
      ** Access to ACCNT by key
      *
     C     KRKEY         READE     ACCNT                                  98
     C                   ENDDO                                                  - E2
      *
     C                   ENDIF                                                  - E1
      *
     C                   ENDSR                                                  **MAIN ENDSR**
      ********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  DETAIL  - Subroutine to execute detail processing.              *
      *                                                                  *
      *  Called by: MPROC                                                *
      *  Calls: *PSSR, SRGEAD, SRGEXZ                                    *
      *                                                                  *
      ********************************************************************
     C     DETAIL        BEGSR                                                  *DETAIL BEGSR*
      *
      ** Check if currency exist
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ZACCY         @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         ***************
     C                   MOVEL     @CYCD         DBKEY                          * DB ERROR 2  *
     C                   Z-ADD     2             DBASE                          ***************
     C                   OUT       LDA
     C                   WRITE     ERRP1
     C   88              WRITE     ERRP2
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Calculation of Total Generated Balance
      *
     C                   EXSR      SRGEAD
      *
      ** If Accrual on CLR'D Balances Flag= 'N', Cleared Bal := Ledger BAL
      *
     C     BMCBAI        IFNE      'Y'
     C                   Z-ADD     LDBL          CLBL
     C                   ENDIF
      *
      ** Put the decimal point at the right place
      *
     C                   Z-ADD     ZHISB         OHISB
     C                   Z-ADD     CLBL          ZCLBL
     C     ZCLBL         SUB       ZHISB         ZDIFF
     C                   SUB       GEAD          ZDIFF
      *
     C                   SETOFF                                       707172
     C                   SETOFF                                       73
      *
     C     CDP           IFEQ      0                                            - B1
      *
     C                   SETON                                          70
      *
     C                   ELSE                                                   - X1
      *
     C     CDP           IFEQ      1                                            - B2
      *
     C     ZHISB         DIV       10            OHISB1
     C     CLBL          DIV       10            ZCLBL1
     C     GEAD          DIV       10            GEAD1
     C     ZDIFF         DIV       10            ZDIFF1
      *
     C                   SETON                                          71
      *
     C                   ELSE                                                   - X2
      *
     C     CDP           IFEQ      2                                            - B3
      *
     C     ZHISB         DIV       100           OHISB2
     C     CLBL          DIV       100           ZCLBL2
     C     GEAD          DIV       100           GEAD2
     C     ZDIFF         DIV       100           ZDIFF2
     C                   SETON                                          72
      *
     C                   ELSE                                                   - X3
      *
     C     ZHISB         DIV       1000          OHISB3
     C     CLBL          DIV       1000          ZCLBL3
     C     GEAD          DIV       1000          GEAD3
     C     ZDIFF         DIV       1000          ZDIFF3
     C                   SETON                                          73
      *
     C                   ENDIF                                                  - E3
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
      ** Output for GEXZPPD Field
      *
     C                   Z-ADD     1             TNITMS            5 0
     C                   Z-ADD     235959        TPTIM             6 0
     C                   Z-ADD     0             ZERO3             3 0
     C                   Z-ADD     0             ZERO5             5 0
     C                   Z-ADD     0             ZERO8             8 0
     C                   Z-ADD     0             ZERO13           13 0
     C                   Z-ADD     0             ZERO15           15 0
     C                   Z-ADD     0             ZACOQQ
     C                   Z-ADD     0             ZERO52            5 2
     C                   Z-ADD     0             ZERO32           13 2
      *
      ** Check if END of PAGE
      *
     C     *IN01         IFEQ      '1'                                          - B1
     C                   WRITE     HEADP1
     C                   MOVE      '0'           *IN01
     C                   ADD       1             PAGE
     C                   ENDIF                                                  - E1
      *
     C     *IN02         IFEQ      '1'                                          - B1
     C   88              WRITE     HEADP2
     C                   MOVE      '0'           *IN02
     C                   ADD       1             PAGE1
     C                   ENDIF                                                  - E1
      *
      ** Writing of Detail Line on Report
      *
     C     LTAS          IFEQ      *ZERO                                        - B1
      *
     C     ZHISB         ADD       GEAD          WHISB
     C     WHISB         IFNE      CLBL                                         - B1B
      *
     C     ZHISB         IFEQ      CLBL                                         - B2
     C                   MOVE      '1'           *IN05
     C                   ENDIF                                                  - E2
      *
     C                   WRITE     DETP1
     C                   ADD       1             NBRREC
      *
     C                   MOVE      '0'           *IN05
      *
      ** Output for GEXZPPD
      *
     C                   EXSR      SRGEXZ
      *
     C                   ENDIF                                                    E1B
      *
     C                   ELSE                                                   - X1
     C     LTAS          IFEQ      99                                           - B2
      *
      ** Open spool files
      *
     C     *IN87         IFEQ      '0'
     C                   MOVE      ZBRCA         BRCA#
     C                   OPEN      SMU90012P1
     C                   SETON                                        01
     C   88              OPEN      SMU90012P2
     C   88              SETON                                        02
     C                   SETON                                        87
     C                   Z-ADD     0             PAGE
     C                   Z-ADD     0             PAGE1
     C                   ENDIF
      *
     C     LNKEY         SETLL     RELINKJ2
     C     LNKEY         READE     RELINKJ2                               99
      *
     C     *IN99         DOWEQ     '0'                                          - B3
      *
     C     BMCBAI        IFEQ      'Y'
     C                   ADD       GROSS         CLBL
     C                   ELSE
     C                   ADD       GRLDBL        CLBL
     C                   ENDIF
      *
     C     LNKEY         READE     RELINKJ2                               99
     C                   ENDDO                                                  - E3
      *
     C     ZHISB         ADD       GEAD          WHISB
     C     WHISB         IFNE      CLBL                                         - B3
      *
      ** Put the decimal point at the right place
      *
     C                   Z-ADD     ZHISB         OHISB
     C                   Z-ADD     CLBL          ZCLBL
     C     ZCLBL         SUB       ZHISB         ZDIFF
     C                   SUB       GEAD          ZDIFF
      *
     C                   SETOFF                                       707172
     C                   SETOFF                                       73
      *
     C     CDP           IFEQ      0                                            - B4
      *
     C                   SETON                                          70
      *
     C                   ELSE                                                   - X4
      *
     C     CDP           IFEQ      1                                            - B5
      *
     C     ZHISB         DIV       10            OHISB1
     C     CLBL          DIV       10            ZCLBL1
     C     GEAD          DIV       10            GEAD1
     C     ZDIFF         DIV       10            ZDIFF1
     C                   SETON                                          71
      *
     C                   ELSE                                                   - X5
      *
     C     CDP           IFEQ      2                                            - B6
      *
     C     ZHISB         DIV       100           OHISB2
     C     CLBL          DIV       100           ZCLBL2
     C     GEAD          DIV       100           GEAD2
     C     ZDIFF         DIV       100           ZDIFF2
     C                   SETON                                          72
      *
     C                   ELSE                                                   - X6
      *
     C     ZHISB         DIV       1000          OHISB3
     C     CLBL          DIV       1000          ZCLBL3
     C     GEAD          DIV       1000          GEAD3
     C     ZDIFF         DIV       1000          ZDIFF3
     C                   SETON                                          73
      *
     C                   ENDIF                                                  - E6
     C                   ENDIF                                                  - E5
     C                   ENDIF                                                  - E4
      *
     C   88              WRITE     DETP2
     C   88              ADD       1             NBRREC
      *
      ** OUTPUT FOR GEXZPPD
      *
     C   88              EXSR      SRGEXZ
      *
     C                   ENDIF                                                  - E3
      *
     C                   ELSE                                                   - X2
     C     ZHISB         IFNE      CLBL
     C   88              WRITE     DETP2
     C   88              ADD       1             NBRREC
      *
      ** OUTPUT FOR GEXZPPD
      *
     C   88              EXSR      SRGEXZ
      *
     C                   ENDIF
     C                   ENDIF                                                  - E2
     C                   ENDIF                                                  - E1
      *
     C                   ENDSR                                                  *DETAIL ENDSR*
      ********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  TOTAL - Subroutine to execute end processing.                   *
      *                                                                  *
      *  Called by: Main Program                                         *
      *  Calls: None                                                     *
      *                                                                  *
      ********************************************************************
     C     TOTAL         BEGSR                                                  **TOTAL BEGSR**
      *
      **  Print 'END OF BRANCH' narrative at end of program also
      *
     C     *IN87         IFEQ      '1'
     C                   WRITE     ENDP1
     C   88              WRITE     ENDP2
     C                   ENDIF
      *
     C                   WRITE     TOTALS
      *
     C                   ENDSR                                                  **TOTAL ENDSR**
      ********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  SRGEAD - Subroutine to Calculate Adjustment                     *
      *                                                                  *
      *  Called by: DETAIL                                               *
      *  Calls: None                                                     *
      *                                                                  *
      ********************************************************************
     C     SRGEAD        BEGSR                                                  **SRGEAD BEGSR*
      *
      ** Initialize to Zero
      *
     C                   Z-ADD     *ZEROS        GEAD
      *
      ** Access Capitalisation Records
      *
     C     LNKEY         SETLL     REHISSL                                99
      *
     C     *IN99         IFEQ      '1'                                          - B1
      *
     C     LNKEY         READE     REHISSL                                97
     C     *IN97         DOWEQ     '0'                                          - B2
      *
     C     SDICI         IFNE      *BLANKS                                      - B3
     C     SDCI          ANDEQ     'Y'
      *
     C                   SUB       DAIC          GEAD
     C                   ENDIF                                                  - E3
      *
     C     SCICI         IFNE      *BLANKS                                      - B3
     C     SCCI          ANDEQ     'Y'
      *
     C                   ADD       CAIC          GEAD
     C                   ENDIF                                                  - E3
      *
     C     LNKEY         READE     REHISSL                                97
     C                   ENDDO                                                  - E2
      *
     C                   ENDIF                                                  - E1
      *
     C                   ENDSR                                                  **TOTAL ENDSR**
      ********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  SRAUD - Subroutine to check if an a/c in GEXZPPD is the         *
      *          primary/secondary of another a/c in the same file       *
      *                                                                  *
      *  Called by: Main Processing                                      *
      *  Calls: None                                                     *
      *                                                                  *
      ********************************************************************
     C     SRAUD         BEGSR                                                  *SRAUD BEGSR*
      *
     C                   READ      GEXZLL0                                LR
      *
     C     *INLR         DOWEQ     '0'
      *
      ** Key field to chain ACCNT
      *
     C     GAKEY         KLIST
     C                   KFLD                    GCNUM
     C                   KFLD                    GCCY
     C                   KFLD                    GACOD
     C                   KFLD                    GACSQ
     C                   KFLD                    GBRCA
      *
      ** Save secondary a/c posting amount
      *
     C                   Z-ADD     GPSTA         SPSTA            13 0
      *
      ** Check if secondary a/c, then get its primary a/c
      *
     C     GAKEY         CHAIN     ACCNT                              99
     C     *IN99         IFEQ      '0'
      *
     C     LTAS          ANDNE     0
     C     LTAC          ANDNE     0
     C     LTAB          ANDNE     *BLANKS
      *
      ** Get primary a/c details based on secondary a/c details.
      *
     C                   MOVEL     LTAB          SLTAB             3
     C                   MOVEL     CNUM          SCNUM             6
     C                   MOVEL     CCY           SCCY              3
     C                   Z-ADD     LTAC          SLTAC            10 0
     C                   Z-ADD     LTAS          SLTAS             2 0
      *
      ** Key field to chain LF/GEXZLL0
      *
     C     GSKEY         KLIST
     C                   KFLD                    SLTAB
     C                   KFLD                    SCNUM
     C                   KFLD                    SCCY
     C                   KFLD                    SLTAC
     C                   KFLD                    SLTAS
      *
     C     GSKEY         CHAIN     GEXZLF                             99
      *
      ** If corresponding primary a/c exists
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     GPSTA         PPSTA            13 0
      *
     C     PPSTA         IFEQ      SPSTA
     C                   DELETE    GEXZLF
     C                   ELSE
     C                   SUB       SPSTA         PPSTA
     C                   UPDATE    GEXZLF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      GEXZLL0                                LR
     C                   ENDDO
      *
     C                   ENDSR                                                  *SRAUD ENDSR**
      ********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  SRGEXZ - Subroutine to output to PF/GEXZPPD.                    *
      *                                                                  *
      *  Called by: DETAIL                                               *
      *  Calls:                                                          *
      *                                                                  *
      ********************************************************************
     C     SRGEXZ        BEGSR                                                  *SRGEXZ BEGSR**
      *
     C                   Z-ADD     0             ZDIFFG
      *
     C     ZDIFF         IFGT      0
     C                   MOVE      '0'           TDRCR             1
     C                   Z-ADD     ZDIFF         ZDIFFG
     C                   ELSE
     C     ZDIFF         MULT      -1            ZDIFFG           13 0
     C                   MOVE      '1'           TDRCR
     C                   ENDIF
      *
     C                   EXCEPT    OUTG
      *
     C                   ENDSR                                                  *SRGEXZ ENDSR**
      ********************************************************************
     C/EJECT
      ********************************************************************
      *                                                                  *
      *  *PSSR subroutine for database error handling                    *
      *                                                                  *
      *  Called by:                                                      *
      *  Calls: None                                                     *
      *                                                                  *
      ********************************************************************
     C     *PSSR         BEGSR                                                  **PSSR BEGSR**
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
     C                   WRITE     ERRAU
      *
     C                   RETURN
      *
     C                   ENDSR                                                  **PSSR ENDSR**
      *
      ********************************************************************
      /EJECT
      ********************************************************************
     OGEXZPPD   EADD         OUTG
     O                                            1 'P'
     O                       ZCUST                7
     O                       ZACCY               10
     O                       ZACOQQ              14
     O                       ZASEQ               16
     O                       TACNO               32
     O                       BJRDNB              35P
     O                       BJRDNB              38P
     O                                           43 '99999'
     O                                           73 'HISTORY CORRECTION'
     O                       ZDIFFG              80P
     O                       TDRCR               81
     O                                          102 'DUMMY'
     O                       ZBRCA              105
     O                                          106 '1'
     O                       TRRNM              114P
     O                                          124 'R'
     O                       TPTIM              140
     O                                          250 '9999'
     O                       TNITMS             271P
     O                                          303 'C'
     O                       ZACOD              599
     O                       ZERO8               95
     O                       ZERO3              108P
     O                                          130 '0'
     O                                          141 '0'
     O                                          147 '0'
     O                       ZERO15             258P
     O                       ZERO15             266P
     O                       ZERO13             279P
     O                       ZERO13             316P
     O                                          329 '0000000000'
     O                       ZERO13             359P
     O                       ZERO52             364
     O                       ZERO5              530P
     O                       ZERO32             573
**  CPY@ OBJECT COPYRIGHT **
(C) Finastra International Banking Systems Limited 2019
