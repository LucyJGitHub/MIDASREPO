     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058755
/*STD *  RPGSQLBND                                                    *                     MD058755
/*EXI *  TEXT('Midas SD Edit Retail Transaction')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0131R - Retail transaction types maintenance.              *
      *                                                               *
      *  Function:  This program maintains a retail transaction       *
      *             type record.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061008           Date 31Dec21               *
      *  Prev Amend No. MD056963           Date 07Jun23               *
      *                 BA6026             Date 18Jan23               *
      *                 CSW101             Date 03Feb23               *
      *                 MD058755           Date 01Sep21               *
      *                 CGL177             Date 11Jan16               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL154             Date 13Oct14               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 01Mar99               *
      *                 CTI002             Date 23Sep98               *
      *                 CSD003             Date 27OCT97               *
      *                 CRT002             DATE 24FEB97               *
      *                 S01408             DATE 23AUG96               *
      *                 093811             DATE 03OCT95               *
      *                 093698             DATE 03OCT95               *
      *                 CRT001             DATE 10MAR95               *
      *                 S01486             DATE 24JUN94               *
      *                 S01459             DATE 24JUN94               *
      *                 S01413             DATE 05JUL93               *
      *                 031807             Date 22SEP92               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061008 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD056963 - Remove *IN91, as this is for the ommitted code    *
      *           - Replace *IN81 with *IN82, *IN81 is already used   *
      *  BA6026 - Structuring Current MT940 and SEPA Compliance.      *
      *  CSW101 - PAYplus Interface.                                  *
      *  MD058755 - Deliverable Data Split for SDRETRPD and TABLETZ   *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting                                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  CRT002 - Retail Branch Access.                               *
      *           Condition CRT001 fields to also appear if CRT002 is *
      *           on.                                                 *
      *  S01408 - Addition of core hooks:                             *
      *           - SD0131RCP1                                        *
      *           - SD0131RCP2                                        *
      *  093811 - When inserting a non-RTS transaction type after an  *
      *           RTS one, system still displays RTS part of input    *
      *           screen.                                             *
      *  093698 - Increase the range of allowable Retail Transaction  *
      *           Types.                                              *
      *  CRT001 - Retail Teller System development:                   *
      *           Addition of 'Associated GL Account Code',           *
      *           'Passbook Transaction Type', 'Cash Indicator'       *
      *           and 'Clearing Indicator'.                           *
      *           'Debit/Credit Indicator' has been made optional.    *
      *  S01486 - Private Banking: addition of                        *
      *           'Change to Portfolio Capital', 'Performance Event   *
      *           Type' and 'Applies to Retail Account'.              *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01413 - Retail 3 incorporation:- Account Commissions        *
      *           indicator available.                                *
      *  031807 - The Return Code should be specified in Factor 1     *
      *           of the parameter field, else the program will not   *
      *           detect an error in the Background Update program.   *
      *                                                               *
      *****************************************************************
     F*
     F*  S01212  - 14SEP89 - LOCAL RETURNS /COPY INCORPORATION            S01212
     F*
     F*
     F/COPY WNCPYSRC,SD0131RFPG
      *
     FA6RETRL0  UF A E           K DISK    USROPN                                             BA6026
     F                                     COMMIT                                             BA6026
     F                                     RENAME(A6RETRD0:A6RETRDA)                          BA6026
     F                                     INFSR(*PSSR)                                       BA6026
      ** Midas SD Retail Transaction Types - Extension Update                                 BA6026
      *                                                                                       BA6026
     FA6RETRL1  IF   E           K DISK    USROPN                                             BA6026
     F                                     RENAME(A6RETRD0:A6RETRDB)                          BA6026
     F                                     INFSR(*PSSR)                                       BA6026
      ** Midas SD Retail Transaction Types - Extension Retrieve                               BA6026
      *                                                                                       BA6026
     F*
     FSD0131R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Retail transaction types maintenance
      *
     F*SDRETRL1* IF   E           K DISK    USROPN                                          MD058755
     F**********                           INFDS(INFDS1)                                    MD058755
     F**********                           INFSR(*PSSR)                                     MD058755
      * RTV : Midas SD Retail transaction types retrieval
      *
     FSDACODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Account codes retrieval
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     F*SDRETRL0* UF A E           K DISK    USROPN                                          MD058755
     F**********                           COMMIT                                           MD058755
     F**********                           INFDS(ID0003)                                    MD058755
     F**********                           INFSR(*PSSR)                                     MD058755
      * UPD : Midas SD Retail transaction types update
      *
     F*SDFCTLL0* UF   E           K DISK    USROPN                                          MD061008
     F**********                           COMMIT                                           MD061008
     F**********                           INFDS(ID0004)                                    MD061008
     F**********                           INFSR(*PSSR)                                     MD061008
      * UPD : Midas SD Standing data controls update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D/COPY WNCPYSRC,SD0131REPG
     D*
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D****/COPY QWINDSRC,QZE1DTA                                          S01229
     D*COPY*QWINDSRC,SD0130GDTA                                           S01229            MD058755
     D/COPY QWINDSRC,SD0130GDTL                                                             MD058755
     D*
     D/COPY WNCPYSRC,SD0131RIPG
     D*
      *                                                                                       BA6026
     D@1DBSW         E DS                  EXTNAME(A6RETRL0)                                  BA6026
      ** Midas SD Retail Transaction Types - Extension Update                                 BA6026
      *                                                                                       BA6026
     D#1DBSW           DS          9999                                                       BA6026
      ** Stored master file format fields                                                     BA6026
      *                                                                                       BA6026
     D#1SIDC           DS                                                                     BA6026
     D  WCHAR1                 1      1                                                       BA6026
     D  WCHAR2                 2      2                                                       BA6026
     D  WCHAR3                 3      3                                                       BA6026
     D  WCHAR4                 4      4                                                       BA6026
      *                                                                                       BA6026
     DYCRDSW           DS          9999                                                       BA6026
      *                                                                                       BA6026
     D ALPHA           C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ')                BA6026

      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC***     E DS                  EXTNAME(SDRETRL0)                                MD058755
     D @1DBRC        E DS                  EXTNAME(SDRTRJW0)                                MD058755
     D                                     PREFIX(X)                                        MD058755
     D SDRETR        E DS                  EXTNAME(SDRTRJW0)                                MD058755
     D SDIDCD        E DS                  EXTNAME(SDIDCJW0)                                  CSW101
      * UPD : Midas SD Retail transaction types update
      * Current/previous master file format fields for change control
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D***#1DBRC*     DS                             56                                        CGL029
     D #1DBRC          DS          9999
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D*QSDFC1***     E DS                  EXTNAME(SDFCTLL0)                                MD061008
     D QSDFC1          DS                                                                   MD061008
     D  AHFLNM                 1     10                                                     MD061008
     D  AHNORC                11     13P 0                                                  MD061008
     D  AHNOIN                14     16P 0                                                  MD061008
     D  AHNOAM                17     19P 0                                                  MD061008
     D  AHNODL                20     22P 0                                                  MD061008
      * UPD : Midas SD Standing data controls update
     D YARDCS          DS            22
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
      *
     D YBRDCS          DS            22
     D***YCRDCS*     DS                             56                                        CGL029
     D*YCRDCS***       DS          9999                                                     MD058755
     D YCRDCS          DS            67                                                     MD058755
     D YDRDCS          DS            22
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
      *
     D ID0004          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS             5
      * KEY: Midas SD Retail transaction types retrieval
      * I : MAP Retail Transaction Type
     D  P1RTTY                 1      5
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0001                 1     10
      * Message data for 'Account Comm ind invalid'
      * Account Commission Ind
     D  ZA0002                 1      1
      * Message data for 'Change to P/folio Y or N.'
      * Change to P/folio Capital
     D  ZA0003                 1      1
      * Message data for 'Performance Event invalid'
      * Performance Event Type
     D  ZA0004                 1      2
      * Message data for 'Applies to Retail invalid'
      * Applies to Retail Account
     D  ZA0005                 1      1
      * Message data for 'A/C cannot be title only'
      * Associated GL Number
     D**********                              1   4 ZA0006                                    CGL029
     D  ZA0006                 1     10
      * Message data for 'Account must be GL A/C'
      * Associated GL Number
     D**********                              1   4 ZA0007                                    CGL029
     D  ZA0007                 1     10
      * Message data for 'Asociatd GL A/C not found'
      * Account Code
     D**********                              1   4 ZA0008                                    CGL029
     D  ZA0008                 1     10
      * Message data for 'A/C cannot be title only'
      * Associated GL Number
     D**********                              1   4 ZA0009                                    CGL029
     D  ZA0009                 1     10
      * Message data for 'Account must be GL A/C'
      * Associated GL Number
     D**********                              1   4 ZA0010                                    CGL029
     D  ZA0010                 1     10
      * Message data for 'Cash indicator is invalid'
      * Cash Indicator
     D  ZA0011                 1      1
      * Message data for 'Clear Ind cannot be 'Y''
      * Clearing Indicator
     D  ZA0012                 1      1
      * Message data for 'Clearing Ind invalid'
      * Clearing Indicator
     D  ZA0013                 1      1
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0014                 1     10
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY: Retail Tra
     C     P2ANCD        PARM                    WP0001            1            Action Code
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1RTTY        IFEQ      *BLANK                                       Retail Transact
      * One or more key fields is blank
     C     *IN05         OREQ      '1'
      * HOME: Reset screen fields
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Switch between *ADD/*CHANGE modes
     C   09              CAS                     BCCHMD
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BCCHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'CHG'         W0PMD             3
     C                   ELSE
     C                   MOVEL     'ADD'         W0PMD
     C                   END
      *================================================================
     CSR   BCEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Validate key fields
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Setup key
     C                   MOVEL     #1RTTY        A1RTTY                         Retail Transact
     C*****KRTV*         CHAIN     @A1RECX                            9091      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :SDRETR                                                                        MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   SETOFF                                       9091                  MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058755
     C                   SETON                                        91                    MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * Verify record existence against program mode
     C     W0PMD         IFNE      'ADD'
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9931      *
      * Send message 'Retail Transaction Typ NF'
     C                   MOVEL     'USR0061'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RSFF - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RSFF
     C*
     C                   END                                                    *FI
      * USER: Initialize detail screen (existing record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RISE - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RISE
     C*
     C                   END                                                    *FI
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        9931      *
      * Send message 'Retail Transaction Typ EX'
     C                   MOVEL     'USR0062'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      * USER: Initialize detail screen (new record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * Start of CRT001
      * Start of CRT002
      * End of CRT001
      * CASE: WRK.Display CRT001/002 fields is Display
     C     WUDSCT        IFEQ      'Y'                                          *IF
     C                   MOVEL     'N'           #1CIND                         Cash Indicator
     C                   MOVEL     'N'           #1CLIN                         Clearing Indica
     C                   END                                                    *FI
      * End of CRT002
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RISN - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RISN
     C*
     C                   END                                                    *FI
     C                   END
     C                   END
      *..................................................
     C   99              GOTO      BEEXIT
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
      * Check Retail Transaction Type is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1RTTY               90  90    *
     C   90              MOVE      #1RTTY        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1RTTY        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1RTTY        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   END
     C                   MOVEL     XG90          *IN90
     C     W0PMD         IFNE      'ADD'
      * Select existing record
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Retrieve Retail Trans - Retail Transaction Types  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Send message '*Record already exists'
     C                   MOVEL     'Y2U0003'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   MOVEL     #1RTTY        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1RTTY        ZA0001                         Retail Transact
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      BFEXIT                                       *QUIT
     C                   END                                                    *FI
      * Start of CRT001
      * CRT002: include CRT002 in conditioning
      * CASE:
      *  - c1 AND c2 AND c3 AND c4
      *   |- c1    : WRK.CRT001 or CRT002 is Present
      *   |- c2    : WRK.Retail 3 is Yes
      *   |- c3    : WRK.Retail Banking is Yes
      *   |- c4    : KEY.Retail Transaction Type is 99500 - 99799
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     WUDCRT        IFEQ      'Y'                                          *IF
     C     WUNXST        IFEQ      'Y'                                          *IF
     C     WURTBN        IFEQ      'Y'                                          *IF
     C     #1RTTY        IFGE      '99500'                                      *IF
     C     #1RTTY        ANDLE     '99799'
     C/COPY WNCPYSRC,SD0131RC01
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
      * Start CRT002
     C                   MOVEL     'Y'           WUDSCT                         Display CRT001/
     C                   ELSE
      * CASE: *OTHERWISE
      * Start of change 093811.
      * End of change 093811.
     C                   MOVEL     'N'           WUDSCT                         Display CRT001/
      * End of CRT002
     C                   END                                                    *FI
      * End of CRT001
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RVKS - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RVKS
     C*
     C                   END                                                    *FI
      * Retail Transaction Type required
     C     #1RTTY        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   EXSR      MAIZ#1
     C                   END
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C**********         MOVE      *ON           *IN81                               BA6026 MD056963
     C                   MOVE      *ON           *IN82                                      MD056963
     C                   ELSE                                                                 BA6026
     C**********         MOVE      *OFF          *IN81                               BA6026 MD056963
     C                   MOVE      *OFF          *IN82                                      MD056963
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
     C                   EXFMT     #RCDDTL1
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
     C                   ELSE
      * CASE: *OTHERWISE
      * Start of S01486
      * Remove code which did not allow F12.
      * F12 is pressed, return to previous screen.
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      * End of S01486
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RPKR - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RPKR
     C*
     C                   END                                                    *FI
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'K'           W0TRN
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details
     C  N10              CAS                     DCVLDL
     C                   END
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: update record
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * Validate Customer Originated Ind.
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1COIN        W0NSRQ            1            Customer Origin
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1136213       Y2LSNO            7 0
     C     #1COIN        PARM      #1COIN        W0EXVL           20            Customer Origin
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Debit/Credit Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1DCIN        W0NSRQ            1            Debit/Credit In
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100774       Y2LSNO            7 0
     C     #1DCIN        PARM      #1DCIN        W0EXVL           20            Debit/Credit In
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Reversal Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1RVIN        W0NSRQ            1            Reversal Indica
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1102174       Y2LSNO            7 0
     C     #1RVIN        PARM      #1RVIN        W0EXVL           20            Reversal Indica
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Print Advices Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1PADI        W0NSRQ            1            Print Advices I
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1178798       Y2LSNO            7 0
     C     #1PADI        PARM      #1PADI        W0EXVL           20            Print Advices I
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Account Commission Ind
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1ACOM        W0NSRQ            1            Account Commiss
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1170047       Y2LSNO            7 0
     C     #1ACOM        PARM      #1ACOM        W0EXVL           20            Account Commiss
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Change to P/folio Capital
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CPTC        W0NSRQ            1            Change to P/fol
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1180456       Y2LSNO            7 0
     C     #1CPTC        PARM      #1CPTC        W0EXVL           20            Change to P/fol
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Performance Event Type
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1PFMC        W0NSRQ            1            Performance Eve
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1180469       Y2LSNO            7 0
     C     #1PFMC        PARM      #1PFMC        W0EXVL           20            Performance Eve
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Applies to Retail Account
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1ATRA        W0NSRQ            1            Applies to Reta
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1180473       Y2LSNO            7 0
     C     #1ATRA        PARM      #1ATRA        W0EXVL           20            Applies to Reta
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate detail screen fields
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Send message 'F3/F10 Only Valid Options'
     C                   MOVEL     'USR0534'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * start S01413
      * Validate Account Commissions Indicator if field displayed
      * CASE: WRK.Account Comm. Ind.display is Yes
     C     WUACID        IFEQ      'Y'                                          *IF
      * CASE: DTL.Account Commission Ind is Blank
     C     #1ACOM        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           #1ACOM                         Account Commiss
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Account Commission Ind is Valid values
     C     #1ACOM        IFEQ      'N'                                          *IF
     C     #1ACOM        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ACOM        ZA0002                         Account Commiss
      * Send message 'Account Comm ind invalid'
     C                   MOVEL     'USR1958'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           #1ACOM                         Account Commiss
     C                   END                                                    *FI
      * end S01413
      * Start of S01486
      * Portfolio management is 'Y'
      * CASE: WRK.Portfolio Management is Yes
     C     WUPFMG        IFEQ      'Y'                                          *IF
      * Change to portfolio Capital
      * CASE: DTL.Change to P/folio Capital is Valid values
     C     #1CPTC        IFEQ      'N'                                          *IF
     C     #1CPTC        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CPTC        ZA0003                         Change to P/fol
      * Send message 'Change to P/folio Y or N.'
     C                   MOVEL     'USR2348'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   END                                                    *FI
      * Performance Event Type
      * CASE: DTL.Performance Event Type is Blank
     C     #1PFMC        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * ' C' has been entered.
      * CASE: DTL.Performance Event Type is ' C'
     C     #1PFMC        IFEQ      ' C'                                         *IF
     C                   MOVEL     *BLANK        #1PFMC                         Performance Eve
     C                   MOVEL     'C'           #1PFMC                         Performance Eve
     C                   END                                                    *FI
      * 'N' has been entered.
      * CASE: DTL.Performance Event Type is ' N'
     C     #1PFMC        IFEQ      ' N'                                         *IF
     C                   MOVEL     *BLANK        #1PFMC                         Performance Eve
     C                   MOVEL     'N'           #1PFMC                         Performance Eve
     C                   END                                                    *FI
      * ' F' has been entered.
      * CASE: DTL.Performance Event Type is ' F'
     C     #1PFMC        IFEQ      ' F'                                         *IF
     C                   MOVEL     *BLANK        #1PFMC                         Performance Eve
     C                   MOVEL     'F'           #1PFMC                         Performance Eve
     C                   END                                                    *FI
      * ' T' has been entered.
      * CASE: DTL.Performance Event Type is ' T'
     C     #1PFMC        IFEQ      ' T'                                         *IF
     C                   MOVEL     *BLANK        #1PFMC                         Performance Eve
     C                   MOVEL     'T'           #1PFMC                         Performance Eve
     C                   END                                                    *FI
      * CASE: DTL.Performance Event Type is Valid values
     C     #1PFMC        IFEQ      'N'                                          *IF
     C     #1PFMC        OREQ      'C'
     C     #1PFMC        OREQ      'DV'
     C     #1PFMC        OREQ      'F'
     C     #1PFMC        OREQ      'IR'
     C     #1PFMC        OREQ      'IP'
     C     #1PFMC        OREQ      'OT'
     C     #1PFMC        OREQ      'T'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1PFMC        ZA0004                         Performance Eve
      * Send message 'Performance Event invalid'
     C                   MOVEL     'USR2349'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Applies to Retail Account
      * CASE: DTL.Applies to Retail Account is Blank
     C     #1ATRA        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Applies to Retail Account is Valid values
     C     #1ATRA        IFEQ      'Y'                                          *IF
     C     #1ATRA        OREQ      'N'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ATRA        ZA0005                         Applies to Reta
      * Send message 'Applies to Retail invalid'
     C                   MOVEL     'USR2350'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of S01486
      * Start of CRT001
      * CRT002: conditioning changed to include CRT002.
      * CRT001 or CRT002 fields are displayed.
      * CASE: WRK.Display CRT001/002 fields is Display
     C     WUDSCT        IFEQ      'Y'                                          *IF
      * Associated GL Account Number
      * CASE: DTL.Associated GL Number is Entered
     C     #1ASGL        IFNE      *BLANK                                       *IF
     C                   MOVEL     #1ASGL        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        WUACCD                         Account Code
      * Select Account Codes - Account Codes  *
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** WUACCD    PARM WUACCD    WQ0002  4        Account Code                       CGL029
     C     WUACCD        PARM      WUACCD        WQ0002           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0031S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   MOVEL     WUACCD        #1ASGL                         Associated GL N
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
      * Retrieve title/type value - Account Codes  *
     C                   EXSR      SBRVGN
      * Account code cannot be a title only account
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ASGL        ZA0006                         Associated GL N
      * Send message 'A/C cannot be title only'
     C                   MOVEL     'USR2768'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   END                                                    *FI
      * Account code must be General Ledger 'G' type account
      * CASE: WRK.Account type is General Ledger
     C     WUACTY        IFEQ      'G'                                          *IF
      * 00/Copy member SD0131RCP1 - Retail Transaction Types  *
     C/COPY WNCPYSRC,SD0131RCP1
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ASGL        ZA0007                         Associated GL N
      * Send message 'Account must be GL A/C'
     C                   MOVEL     'USR2769'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1ASGL        WUACCD                         Account Code
      * Check Account Code exists - Account Codes  *
     C                   EXSR      SCRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1ASGL        ZA0008                         Associated GL N
      * Send message 'Asociatd GL A/C not found'
     C                   MOVEL     'USR2770'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Retrieve title/type value - Account Codes  *
     C                   EXSR      SDRVGN
      * Account code cannot be a title only account
      * CASE: WRK.Title Only Indicator is YES
     C     WUTOIN        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1ASGL        ZA0009                         Associated GL N
      * Send message 'A/C cannot be title only'
     C                   MOVEL     'USR2768'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   END                                                    *FI
      * Account code must be General Ledger 'G' type account
      * CASE: WRK.Account type is General Ledger
     C     WUACTY        IFEQ      'G'                                          *IF
      * 00/Copy member SD0131RCP2 - Retail Transaction Types  *
     C/COPY WNCPYSRC,SD0131RCP2
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ASGL        ZA0010                         Associated GL N
      * Send message 'Account must be GL A/C'
     C                   MOVEL     'USR2769'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Cash Indicator
      * CASE: DTL.Cash Indicator is Blank
     C     #1CIND        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Cash Indicator is Valid value
     C     #1CIND        IFEQ      'N'                                          *IF
     C     #1CIND        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CIND        ZA0011                         Cash Indicator
      * Send message 'Cash indicator is invalid'
     C                   MOVEL     'USR2771'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Clearing Indicator
      * CASE: DTL.Clearing Indicator is Blank
     C     #1CLIN        IFEQ      *BLANK                                       *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Clearing Indicator is Valid value
     C     #1CLIN        IFEQ      'N'                                          *IF
     C     #1CLIN        OREQ      'Y'
      * Clearing Ind can be a 'Y', only if CR/DR ind is a 'C'.
      * CASE:
      *  - c1 AND c2
      *   |- c1    : DTL.Clearing Indicator is Yes
      *   |- c2    : DTL.Debit/Credit Indicator is Not 'C'
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #1CLIN        IFEQ      'Y'                                          *IF
     C     #1DCIN        IFEQ      'D'                                          *IF
     C     #1DCIN        OREQ      *BLANK
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CLIN        ZA0012                         Clearing Indica
      * Send message 'Clear Ind cannot be 'Y''
     C                   MOVEL     'USR2798'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CLIN        ZA0013                         Clearing Indica
      * Send message 'Clearing Ind invalid'
     C                   MOVEL     'USR2772'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of CRT001
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RVSF - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RVSF
     C*
     C                   END                                                    *FI
      * CALC: Detail screen function fields
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RSFF - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RSFF
     C*
     C                   END                                                    *FI
      * USER: Validate detail screen relations
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RVSR - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RVSR
     C*
     C                   END                                                    *FI
      * Retail Transaction Name required
     C     #1RTNM        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Customer Originated Ind. required
     C     #1COIN        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Reversal Indicator required
     C     #1RVIN        IFEQ      *BLANK                                       IF
     C                   SETON                                        9934      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Print Advices Indicator required
     C     #1PADI        IFEQ      *BLANK                                       IF
     C                   SETON                                        9935      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *                                                                                       CGL154
      ** If CGL154 is ON validate FATCA Payment Type                                          CGL154
      *                                                                                       CGL154
     C     CGL154        IFEQ      'Y'
     C     CGL177        OREQ      'Y'
      *                                                                                       CGL154
      ** Blank FATCA Payment Type will be defaulted to 'N'                                    CGL154
      *                                                                                       CGL154
     C     #1FTPT        IFEQ      *BLANK
     C                   MOVEL     'N'           #1FTPT
     C                   MOVEL     'Y'           W0DCF
     C                   ELSE
      *                                                                                       CGL154
     C     #1FTPT        IFNE      'D'
     C     #1FTPT        ANDNE     'I'
     C     #1FTPT        ANDNE     'G'
     C     #1FTPT        ANDNE     'O'
     C     #1FTPT        ANDNE     'N'
     C                   SETON                                        9944
     C                   MOVEL     'USS0515'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGL154
     C                   ENDIF
                                                                                              CSW101
      ** If CSW101 is ON validate Identification Code                                         CSW101
                                                                                              CSW101
     C     CSW101        IFEQ      'Y'                                                        CSW101
                                                                                              CSW101
     C     #1IDCD        IFNE      *BLANK                                                     CSW101
     C                   MOVEL     #1IDCD        WUTQKF            1            Test ? in Key CSW101
      * CASE: WRK.Test ? in Key Field is Question Mark                                        CSW101
     C     WUTQKF        IFEQ      '?'                                          *IF           CSW101
     C                   MOVEL     *BLANK        WUIDCD            3                          CSW101
      * Select RTS Retail Trans. - Retail Transaction Types  *                                CSW101
     C                   CALL      'SD000131S'                          90                    CSW101
     C                   PARM      *BLANK        W0RTN             7                          CSW101
     C     WUIDCD        PARM      WUIDCD        WQA003            3                          CSW101
      *                                                                                       CSW101
     C     *IN90         IFEQ      '1'                                                        CSW101
      * Call to program ended in error                                                        CSW101
     C                   MOVEL     'Y2U0032'     W0RTN                                        CSW101
     C                   MOVEL     *BLANKS       W0CLPG           10                          CSW101
     C                   MOVEL     'SD000131S'   W0CLPG                                       CSW101
      * Send message '*Error occured on CALL...'                                              CSW101
     C                   MOVEL     'Y2U0032'     ZAMSID                                       CSW101
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                       CSW101
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data  CSW101
     C                   EXSR      ZASNMS                                                     CSW101
     C                   END                                                                  CSW101
      *                                                                                       CSW101
      * Error detected?                                                                       CSW101
     C     W0RTN         IFNE      *BLANK                                                     CSW101
     C                   SETON                                        99        *             CSW101
     C                   END                                                                  CSW101
     C                   MOVEL     WUIDCD        #1IDCD                                       CSW101
     C                   ENDIF                                                                CSW101
      *                                                                                       CSW101
     C/EXEC SQL                                                                               CSW101
     C+ SELECT *                                                                              CSW101
     C+ into :SDIDCD                                                                          CSW101
     C+ from SDIDCJW0                                                                         CSW101
     C+ where AAIDCD = :#1IDCD                                                                CSW101
     C/END-EXEC                                                                               CSW101
                                                                                              CSW101
     C     SQLCODE       IFEQ      100                                                        CSW101
     C                   SETON                                        9945                    CSW101
     C                   MOVEL     'USR4390'     ZAMSID                                       CSW101
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                                       CSW101
     C                   EXSR      ZASNMS                                                     CSW101
     C                   END                                                                  CSW101
     C                   ENDIF                                                                CSW101
     C                   ENDIF                                                                CSW101
      *                                                                                       BA6026
      ** Validate Transaction Type Identification Code.                                       BA6026
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C     #1SIDC        ANDNE     *BLANKS                                                    BA6026
      *                                                                                       BA6026
     C                   SETOFF                                       46                      BA6026
      *                                                                                       BA6026
      ** Send warning message if entry does not begin w/ 'N'.                                 BA6026
      *                                                                                       BA6026
     C     1             SUBST     #1SIDC:1      NTEST             1                          BA6026
     C     NTEST         IFNE      'N'                                                        BA6026
     C     #1SIDC        IFNE      W1SIDC                                                     BA6026
     C                   SETON                                        99                      BA6026
     C                   MOVE      *BLANKS       W1SIDC            4                          BA6026
     C                   MOVE      #1SIDC        W1SIDC                                       BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
     C                   MOVEL     'XXX0001'     ZAMSID                                       BA6026
     C     'GBXX'        CAT       'USRMSG'      ZAMSGF                                       BA6026
     C                   EXSR      ZASNMS                                                     BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
      ** Send error message entry must be 4 alphabetic characters                             BA6026
      *                                                                                       BA6026
     C     ' '           SCAN      #1SIDC                                 46                  BA6026
     C     *IN46         IFEQ      *ON                                                        BA6026
     C                   SETON                                        9948                    BA6026
     C                   MOVEL     'XXX0002'     ZAMSID                                       BA6026
     C     'GBXX'        CAT       'USRMSG'      ZAMSGF                                       BA6026
     C                   EXSR      ZASNMS                                                     BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
      ** Send error message must not contain numeric or symbols                               BA6026
      *                                                                                       BA6026
     C     WCHAR1        SCAN      ALPHA                                  47                  BA6026
     C   47WCHAR2        SCAN      ALPHA                                  47                  BA6026
     C   47WCHAR3        SCAN      ALPHA                                  47                  BA6026
     C   47WCHAR4        SCAN      ALPHA                                  47                  BA6026
     C     *IN47         IFEQ      *OFF                                                       BA6026
     C                   SETON                                        9948                    BA6026
     C                   MOVEL     'XXX0003'     ZAMSID                                       BA6026
     C     'GBXX'        CAT       'USRMSG'      ZAMSGF                                       BA6026
     C                   EXSR      ZASNMS                                                     BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
     C                   ENDIF                                                                BA6026
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      *                                                                                       CER030
      ** If CER030 is installed, Call Network Transaction Identifier                          CER030
      ** subfile program                                                                      CER030
      *                                                                                       CER030
     C     CER030        IFEQ      'Y'
     C     CGL013        OREQ      'Y'
     C     CER044        OREQ      'Y'
     C                   CALL      'SD001300'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      P2ANCD        PACTN             1
     C                   PARM      A1RTTY        PRTTYP            5
     C                   PARM      #1RTNM        PRTDES           30
     C                   PARM      *BLANKS       PWRTF             1
      *                                                                                       CER030
     C     PRTCD         IFEQ      'F3'
      *                                                                                       CER030
     C     PWRTF         IFEQ      *BLANKS
     C                   EXSR      ZXEXPG
     C                   ENDIF
      *                                                                                       CER030
     C                   ELSE
     C     PRTCD         IFEQ      'F12'
      *                                                                                       CER030
     C     PWRTF         IFEQ      *BLANKS
     C                   MOVE      'Y'           W0TRN
     C                   GOTO      EBEXIT
     C                   ENDIF
     C                   MOVE      'Y'           W0TRN
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      *                                                                                       CER030
     C                   ENDIF
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C                   COMMIT
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RPCK - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RPCK
     C*
     C                   END                                                    *FI
      * Start of S01486
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * End of S01486
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'N'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Ret Trans - FR - Retail Transaction Types  *
     C                   EXSR      SECRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Ret Trans - FR - Retail Transaction Types  *
     C                   EXSR      SGDLRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Ret Tran - FR - Retail Transaction Types  *
     C                   EXSR      SICHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P1RTTY        IFEQ      *BLANK                                       Retail Transact
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C                   MOVEL     '0'           *IN79
     C     WUACID        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     WUPFMG        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     WUDSCT        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN76
     C     WUDSPP        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1RTNM                         Retail Transact
     C                   MOVEL     *BLANK        #1COIN                         Customer Origin
     C                   MOVEL     *BLANK        #1DCIN                         Debit/Credit In
     C                   MOVEL     *BLANK        #1RVIN                         Reversal Indica
     C                   MOVEL     *BLANK        #1PADI                         Print Advices I
     C                   MOVEL     *BLANK        #1ACOM                         Account Commiss
     C                   MOVEL     *BLANK        #1CPTC                         Change to P/fol
     C                   MOVEL     *BLANK        #1PFMC                         Performance Eve
     C                   MOVEL     *BLANK        #1ATRA                         Applies to Reta
     C                   MOVEL     *BLANK        #1ASGL                         Associated GL N
     C                   MOVEL     *BLANK        #1PASB                         Passbook Transa
     C                   MOVEL     *BLANK        #1CIND                         Cash Indicator
     C                   MOVEL     *BLANK        #1CLIN                         Clearing Indica
     C                   MOVEL     *BLANK        #1FTPT
     C                   MOVEL     *BLANK        #1IDCD                                       CSW101
      *                                                                                       BA6026
      ** Initialize Transaction Type Idenfication Code.                                       BA6026
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   MOVEL     *BLANKS       #1SIDC                                       BA6026
     C                   ENDIF                                                                BA6026
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @A1RECX fields to screen
      *================================================================
     C                   Z-ADD     A1LCD         #1LCD                          Last Change Dat
     C                   MOVEL     A1TYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     A1RTTY        #1RTTY                         Retail Transact
     C                   MOVEL     A1RTNM        #1RTNM                         Retail Transact
     C                   MOVEL     A1COIN        #1COIN                         Customer Origin
     C                   MOVEL     A1DCIN        #1DCIN                         Debit/Credit In
     C                   MOVEL     A1RVIN        #1RVIN                         Reversal Indica
     C                   MOVEL     A1PADI        #1PADI                         Print Advices I
     C                   MOVEL     A1ACOM        #1ACOM                         Account Commiss
     C                   MOVEL     A1CPTC        #1CPTC                         Change to P/fol
     C                   MOVEL     A1PFMC        #1PFMC                         Performance Eve
     C                   MOVEL     A1ATRA        #1ATRA                         Applies to Reta
     C                   MOVEL     A1ASGL        #1ASGL                         Associated GL N
     C                   MOVEL     A1PASB        #1PASB                         Passbook Transa
     C                   MOVEL     A1CIND        #1CIND                         Cash Indicator
     C                   MOVEL     A1CLIN        #1CLIN                         Clearing Indica
      * Hold existing record image
     C                   eval      @1DBRC = SDRETR                                          MD058755
     C                   MOVEL     @1DBRC        #1DBRC
     C                   MOVEL     A1FTPT        #1FTPT
     C                   MOVEL     A1IDCD        #1IDCD                                       CSW101
      *                                                                                       BA6026
      ** Move file field Transaction Type Identification Code to screen                       BA6026
      ** work variables.                                                                      BA6026
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   MOVE      *IN89         WIN89             1                          BA6026
     C     KRTV          CHAIN     A6RETRDB                           89                      BA6026
     C     *IN89         IFEQ      *OFF                                                       BA6026
     C                   MOVEL     G1SIDC        #1SIDC                                       BA6026
     C                   MOVEL     @1DBSW        #1DBSW                                       BA6026
     C                   ENDIF                                                                BA6026
     C                   MOVE      WIN89         *IN89                                        BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1RTTY        #1RTTY                         Retail Transact
      * USER: Initialize key screen
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C*
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RIKS - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RIKS
     C*
     C                   END                                                    *FI
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve Retail Trans - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     #1RTTY        A1RTTY                         Retail Transact
     C*****KRSSA         CHAIN     @A1RECX                            90        *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :SDRETR                                                                        MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   SETOFF                                       90                    MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Retrieve title/type value - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     WUACCD        A5ACCD                         Account Code
     C     KRSSB         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Check Account Code exists - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSC         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     WUACCD        A5ACCD                         Account Code
     C     KRSSC         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * Retrieve title/type value - Account Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSD         KLIST
     C                   KFLD                    A5ACCD                         Account Code
      * Move fields to key list
     C                   MOVEL     WUACCD        A5ACCD                         Account Code
     C     KRSSD         CHAIN     @A5REA6                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0069'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   MOVEL     A5ACTY        WUACTY                         Account type
     C                   MOVEL     A5TOIN        WUTOIN                         Title Only Indi
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECRRC        BEGSR
      *================================================================
      * Create Ret Trans - FR - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @A1RECW
     C                   MOVEL     #1RTTY        A1RTTY                         Retail Transact
     C                   Z-ADD     WURDNB        A1LCD                          Last Change Dat
     C                   MOVEL     'I'           A1TYLC                         Type of Last Ch
     C                   MOVEL     #1RTNM        A1RTNM                         Retail Transact
     C                   MOVEL     #1COIN        A1COIN                         Customer Origin
     C                   MOVEL     #1DCIN        A1DCIN                         Debit/Credit In
     C                   MOVEL     #1RVIN        A1RVIN                         Reversal Indica
     C                   MOVEL     #1PADI        A1PADI                         Print Advices I
     C                   MOVEL     #1ACOM        A1ACOM                         Account Commiss
     C                   MOVEL     #1CPTC        A1CPTC                         Change to P/fol
     C                   MOVEL     #1PFMC        A1PFMC                         Performance Eve
     C                   MOVEL     #1ATRA        A1ATRA                         Applies to Reta
     C                   MOVEL     #1ASGL        A1ASGL                         Associated GL N
     C                   MOVEL     #1PASB        A1PASB                         Passbook Transa
     C                   MOVEL     #1CIND        A1CIND                         Cash Indicator
     C                   MOVEL     #1CLIN        A1CLIN                         Clearing Indica
     C                   MOVEL     #1IDCD        A1IDCD                                       CSW101
      *                                                                                       CGL154
     C                   MOVEL     #1FTPT        A1FTPT
     C     #1FTPT        IFEQ      *BLANK
     C     CGL154        ANDEQ     'Y'
     C     #1FTPT        OREQ      *BLANK
     C     CGL177        ANDEQ     'Y'
     C                   MOVEL     'N'           A1FTPT
     C                   ENDIF
      *                                                                                       BA6026
      ** Move screen fields to extension file.                                                BA6026
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   MOVEL     #1RTTY        G1RTTY                                       BA6026
     C                   MOVEL     #1SIDC        G1SIDC                                       BA6026
     C                   ENDIF                                                                BA6026
      *
      * USER: Processing before Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0131RC02
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C/COPY WNCPYSRC,SD0131RC03
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'I'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SEEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SEEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SEEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RCBW - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RCBW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RCBU - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RCBU
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     KLCRSE        KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Check for duplicate primary key
     C*****KLCRSE        SETLL     @A1RECW                                90    *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :SDRETR                                                                        MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   SETOFF                                       90                    MD058755
     C                   If        SQLCODE =  0                                             MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR0062'     W0RTN             7
      * Send message 'Retail Transaction Typ EX'
     C                   MOVEL     'USR0062'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C**********         WRITE     @A1RECW                              91      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ insert into SDRTRBTD                                                                MD058755
     C+ (                                                                                   MD058755
     C+   A1RTTY                                                                            MD058755
     C+  ,A1LCD                                                                             MD058755
     C+  ,A1TYLC                                                                            MD058755
     C+  ,A1RTNM                                                                            MD058755
     C+  ,A1COIN                                                                            MD058755
     C+  ,A1DCIN                                                                            MD058755
     C+  ,A1RVIN                                                                            MD058755
     C+  ,A1PADI                                                                            MD058755
     C+  ,A1ACOM                                                                            MD058755
     C+  ,A1CPTC                                                                            MD058755
     C+  ,A1PFMC                                                                            MD058755
     C+  ,A1ATRA                                                                            MD058755
     C+  ,QQASGL                                                                            MD058755
     C+  ,A1PASB                                                                            MD058755
     C+  ,A1CIND                                                                            MD058755
     C+  ,A1CLIN                                                                            MD058755
     C+  ,A1ASGL                                                                            MD058755
     C+  ,A1FTPT                                                                            MD058755
     C+  ,A1MODE                                                                            MD058755
     C+  ,A1IDCD                                                                              CSW101
     C+ )                                                                                   MD058755
     C+ Values                                                                              MD058755
     C+ (                                                                                   MD058755
     C+   :A1RTTY                                                                           MD058755
     C+  ,:A1LCD                                                                            MD058755
     C+  ,:A1TYLC                                                                           MD058755
     C+  ,:A1RTNM                                                                           MD058755
     C+  ,:A1COIN                                                                           MD058755
     C+  ,:A1DCIN                                                                           MD058755
     C+  ,:A1RVIN                                                                           MD058755
     C+  ,:A1PADI                                                                           MD058755
     C+  ,:A1ACOM                                                                           MD058755
     C+  ,:A1CPTC                                                                           MD058755
     C+  ,:A1PFMC                                                                           MD058755
     C+  ,:A1ATRA                                                                           MD058755
     C+  ,:QQASGL                                                                           MD058755
     C+  ,:A1PASB                                                                           MD058755
     C+  ,:A1CIND                                                                           MD058755
     C+  ,:A1CLIN                                                                           MD058755
     C+  ,:A1ASGL                                                                           MD058755
     C+  ,:A1FTPT                                                                           MD058755
     C+  ,'B'                                                                               MD058755
     C+  ,:A1IDCD                                                                             CSW101
     C+ )                                                                                   MD058755
     C/END-EXEC                                                                             MD058755
     C/EXEC SQL                                                                             MD058755
     C+ insert into SDRTRXTD                                                                MD058755
     C+ (                                                                                   MD058755
     C+   A1RTTY                                                                            MD058755
     C+  ,A1LCD                                                                             MD058755
     C+  ,A1TYLC                                                                            MD058755
     C+  ,A1RTNM                                                                            MD058755
     C+  ,A1COIN                                                                            MD058755
     C+  ,A1DCIN                                                                            MD058755
     C+  ,A1RVIN                                                                            MD058755
     C+  ,A1PADI                                                                            MD058755
     C+  ,A1ACOM                                                                            MD058755
     C+  ,A1CPTC                                                                            MD058755
     C+  ,A1PFMC                                                                            MD058755
     C+  ,A1ATRA                                                                            MD058755
     C+  ,QQASGL                                                                            MD058755
     C+  ,A1PASB                                                                            MD058755
     C+  ,A1CIND                                                                            MD058755
     C+  ,A1CLIN                                                                            MD058755
     C+  ,A1ASGL                                                                            MD058755
     C+  ,A1FTPT                                                                            MD058755
     C+  ,A1MODE                                                                            MD058755
     C+  ,A1IDCD                                                                              CSW101
     C+ )                                                                                   MD058755
     C+ Values                                                                              MD058755
     C+ (                                                                                   MD058755
     C+   :A1RTTY                                                                           MD058755
     C+  ,:A1LCD                                                                            MD058755
     C+  ,:A1TYLC                                                                           MD058755
     C+  ,:A1RTNM                                                                           MD058755
     C+  ,:A1COIN                                                                           MD058755
     C+  ,:A1DCIN                                                                           MD058755
     C+  ,:A1RVIN                                                                           MD058755
     C+  ,:A1PADI                                                                           MD058755
     C+  ,:A1ACOM                                                                           MD058755
     C+  ,:A1CPTC                                                                           MD058755
     C+  ,:A1PFMC                                                                           MD058755
     C+  ,:A1ATRA                                                                           MD058755
     C+  ,:QQASGL                                                                           MD058755
     C+  ,:A1PASB                                                                           MD058755
     C+  ,:A1CIND                                                                           MD058755
     C+  ,:A1CLIN                                                                           MD058755
     C+  ,:A1ASGL                                                                           MD058755
     C+  ,:A1FTPT                                                                           MD058755
     C+  ,'B'                                                                               MD058755
     C+  ,:A1IDCD                                                                             CSW101
     C+ )                                                                                   MD058755
     C/END-EXEC                                                                             MD058755
      *
     C******IN91         IFEQ      '1'                                                      MD058755
     C     SQLCODE       IFNE      0                                                        MD058755
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *                                                                                       BA6026
      ** Populate extension file A6RETRPD.                                                    BA6026
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   WRITE     A6RETRDA                                                   BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Start of SAR S01117
      * Change File Control Filename from RETRAN to SDRETRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SFCHRC
      * End of SAR S01117
      * Start of 031807
      * Update TABLETZ - Retail Transaction Types  *
     C                   CALL      'TABLETZ'                            90      Update TABLETZ
     C     W0RTN         PARM      W0RTN         WQ0003            7            *Return code
     C                   PARM      A1RTTY        WQ0004            5            Retail Transact
     C                   PARM      A1RTNM        WQ0005           30            Retail Transact
     C                   PARM      A1COIN        WQ0006            1            Customer Origin
     C                   PARM      A1DCIN        WQ0007            1            Debit/Credit In
     C                   PARM      A1RVIN        WQ0008            1            Reversal Indica
     C                   PARM      A1PADI        WQ0009            1            Print Advices I
     C                   PARM      A1ACOM        WQ0010            1            Account Commiss
     C                   PARM      A1TYLC        WQ0011            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0012            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETZ'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RCAU - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RCAU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDRETRPD'    AHFLNM                         Filename
      *
     C     KLCHSF        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSF        CHAIN     @AHREAU                            9091      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       9091                  MD061008
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YARDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       91                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061008
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGDLRC        BEGSR
      *================================================================
      * Delete Ret Trans - FR - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SGEXIT                                       *QUIT
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
     C/COPY WNCPYSRC,SD0131RC04
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C/COPY WNCPYSRC,SD0131RC05
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'D'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SGEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SGEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SGEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RDBW - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RDBW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RDBU - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RDBU
     C*
     C                   END                                                    *FI
      * Move key fields to @A1RECW
     C                   MOVEL     #1RTTY        A1RTTY                         Retail Transact
      *
     C     KLDLSG        KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
     C*****KLDLSG        CHAIN     @A1RECW                            9091      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :SDRETR                                                                        MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   SETOFF                                       9091                  MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058755
     C                   SETON                                        91                    MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C     KLDLSG        CHAIN     A6RETRL0                           9293                    BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
     C     *IN90         IFEQ      '1'
      *                                                                                       BA6026
     C     *IN92         OREQ      '1'                                                        BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026
      *                                                                                       BA6026
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      *                                                                                       BA6026
     C     *IN93         OREQ      '1'                                                        BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026
      *                                                                                       BA6026
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SGEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = SDRETR                                          MD058755
     C     #1DBRC        IFNE      @1DBRC                                       IF
      *                                                                                       BA6026
     C     #1DBSW        ORNE      @1DBSW                                                     BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026
      *                                                                                       BA6026
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****KLDLSG        SETLL     @A1RECW                            9091      *           MD058755
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C     KLDLSG        SETLL     A6RETRL0                           9293                    BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
     C                   GOTO      SGEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
      * Do not allow deletion of core record                                                MD058755
     C     A1MODE        IFEQ      'C'                                                      MD058755
     C                   MOVEL     'USR0553'     ZAMSID                                     MD058755
     C                   MOVEL     'USR0553'     W0RTN                                      MD058755
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058755
     C                   EXSR      ZASNMS                                                   MD058755
     C                   GOTO      SGEXIT                                                   MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
     C**********         DELETE    @A1RECW                              91      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ delete from SDRTRBTD                                                                MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C/EXEC SQL                                                                             MD058755
     C+ delete from SDRTRXTD                                                                MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   DELETE    A6RETRL0                             93                    BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026

     C******IN91         IFEQ      '1'                                                      MD058755
     C     SQLCODE       IFNE      0                                                        MD058755
     C     *IN93         OREQ      '1'                                                        BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026

      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDRETRPD'    PAFNME                         File name
     C                   MOVEL     #1RTTY        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change File Control Filename from RETRAN to SDRETRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SHCHRC
      * End of SAR S01117
     C                   MOVEL     'D'           WUTYLC                         Type of Last Ch
      * Start of 031807
      * Update TABLETZ - Retail Transaction Types  *
     C                   CALL      'TABLETZ'                            90      Update TABLETZ
     C     W0RTN         PARM      W0RTN         WQ0013            7            *Return code
     C                   PARM      A1RTTY        WQ0014            5            Retail Transact
     C                   PARM      A1RTNM        WQ0015           30            Retail Transact
     C                   PARM      A1COIN        WQ0016            1            Customer Origin
     C                   PARM      A1DCIN        WQ0017            1            Debit/Credit In
     C                   PARM      A1RVIN        WQ0018            1            Reversal Indica
     C                   PARM      A1PADI        WQ0019            1            Print Advices I
     C                   PARM      A1ACOM        WQ0020            1            Account Commiss
     C                   PARM      WUTYLC        WQ0021            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0022            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETZ'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RDAU - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RDAU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDRETRPD'    AHFLNM                         Filename
      *
     C     KLCHSH        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSH        CHAIN     @AHREAU                            9091      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       9091                  MD061008
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SHEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YBRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       91                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061008
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SICHRC        BEGSR
      *================================================================
      * Change Ret Tran - FR - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @A1RECW
     C                   MOVEL     #1RTTY        A1RTTY                         Retail Transact
      *
     C     KLCHSI        KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
     C*****KLCHSI        CHAIN     @A1RECW                            9091      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ SELECT *                                                                            MD058755
     C+ into :SDRETR                                                                        MD058755
     C+ from SDRTRJW0                                                                       MD058755
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
     C                   SETOFF                                       9091                  MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   SETON                                        90                    MD058755
     C                   ENDIF                                                              MD058755
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058755
     C                   SETON                                        91                    MD058755
     C                   ENDIF                                                              MD058755
                                                                                            MD058755
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C     KLCHSI        CHAIN     A6RETRDA                           9293                    BA6026
     C                   ENDIF                                                                BA6026

      *
     C     *IN90         IFEQ      '1'
     C     *IN92         OREQ      '1'                                                        BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SIEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
     C     *IN93         OREQ      '1'                                                        BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SIEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = SDRETR                                          MD058755
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C     #1DBSW        ORNE      @1DBSW                                                     BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C**********         UNLOCK    SDRETRL0                             91      *           MD058755
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   UNLOCK    A6RETRL0                             93                    BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
     C                   GOTO      SIEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C**********           MOVE @1DBRC    YCRDCS                                              CGL029
     C                   MOVEL     @1DBRC        YCRDCS
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   MOVEL     @1DBSW        YCRDSW                                       BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
      * Move non-key fields to @A1RECW
     C                   Z-ADD     WURDNB        A1LCD                          Last Change Dat
     C                   MOVEL     'A'           A1TYLC                         Type of Last Ch
     C                   MOVEL     #1RTNM        A1RTNM                         Retail Transact
     C                   MOVEL     #1COIN        A1COIN                         Customer Origin
     C                   MOVEL     #1DCIN        A1DCIN                         Debit/Credit In
     C                   MOVEL     #1RVIN        A1RVIN                         Reversal Indica
     C                   MOVEL     #1PADI        A1PADI                         Print Advices I
     C                   MOVEL     #1ACOM        A1ACOM                         Account Commiss
     C                   MOVEL     #1CPTC        A1CPTC                         Change to P/fol
     C                   MOVEL     #1PFMC        A1PFMC                         Performance Eve
     C                   MOVEL     #1ATRA        A1ATRA                         Applies to Reta
     C                   MOVEL     #1ASGL        A1ASGL                         Associated GL N
     C                   MOVEL     #1PASB        A1PASB                         Passbook Transa
     C                   MOVEL     #1CIND        A1CIND                         Cash Indicator
     C                   MOVEL     #1CLIN        A1CLIN                         Clearing Indica
     C                   MOVEL     #1IDCD        A1IDCD                                       CSW101
      *                                                                                       CGL154
     C                   MOVEL     #1FTPT        A1FTPT
     C     #1FTPT        IFEQ      *BLANK
     C     CGL154        ANDEQ     'Y'
     C     #1FTPT        OREQ      *BLANK
     C     CGL177        ANDEQ     'Y'
     C                   MOVEL     'N'           A1FTPT
     C                   ENDIF
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   MOVEL     #1SIDC        G1SIDC                                       BA6026
     C                   ENDIF                                                                BA6026

      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C     @1DBSW        ORNE      YCRDSW                                                     BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026
     C                   MOVE      'Y'           YCRDC
     C                   END
      * USER: Processing before Data update
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * CASE: PGM.*Program mode is *DISPLAY
     C     W0PMD         IFEQ      'DSP'                                        *IF
     C                   MOVEL     'E'           WUWMAC                         WM action code
     C                   END                                                    *FI
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
     C                   MOVEL     'A'           WUWMAC                         WM action code
     C/COPY WNCPYSRC,SD0131RC06
     C                   END                                                    *FI
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C/COPY WNCPYSRC,SD0131RC07
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      WUWMAC        UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SIEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SIEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SIEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0131RBUW - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RBUW
     C*
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RBDU - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RBDU
     C*
     C                   END                                                    *FI
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C     @1DBSW        ORNE      YCRDSW                                                     BA6026
     C     BA6026        ANDEQ     'Y'                                                        BA6026
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C***********        UPDATE    @A1RECW                              91      *           MD058755
     C/EXEC SQL                                                                             MD058755
     C+ update SDRTRXTD set                                                                 MD058755
     C+   A1LCD  = :A1LCD                                                                   MD058755
     C+  ,A1TYLC = :A1TYLC                                                                  MD058755
     C+  ,A1RTNM = :A1RTNM                                                                  MD058755
     C+  ,A1COIN = :A1COIN                                                                  MD058755
     C+  ,A1DCIN = :A1DCIN                                                                  MD058755
     C+  ,A1RVIN = :A1RVIN                                                                  MD058755
     C+  ,A1PADI = :A1PADI                                                                  MD058755
     C+  ,A1ACOM = :A1ACOM                                                                  MD058755
     C+  ,A1CPTC = :A1CPTC                                                                  MD058755
     C+  ,A1PFMC = :A1PFMC                                                                  MD058755
     C+  ,A1ATRA = :A1ATRA                                                                  MD058755
     C+  ,A1ASGL = :A1ASGL                                                                  MD058755
     C+  ,A1PASB = :A1PASB                                                                  MD058755
     C+  ,A1CIND = :A1CIND                                                                  MD058755
     C+  ,A1CLIN = :A1CLIN                                                                  MD058755
     C+  ,A1FTPT = :A1FTPT                                                                    CSW101
     C+  ,A1IDCD = :A1IDCD                                                                    CSW101
     C+ where A1RTTY = :A1RTTY                                                              MD058755
     C/END-EXEC                                                                             MD058755
      *                                                                                       BA6026
     C     BA6026        IFEQ      'Y'                                                        BA6026
     C                   UPDATE    A6RETRDA                             93                    BA6026
     C                   ENDIF                                                                BA6026
      *                                                                                       BA6026
     C                   ELSE
      * Release record lock
     C***********        UNLOCK    SDRETRL0                             91      *           MD058755
     C                   END
     C******IN91         IFEQ      '1'                                                      MD056963
     C                   If        SQLCODE <> 0                                             MD056963
     C                             OR (*IN93 = '1')  AND (BA6026 = 'Y')                       BA6026
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Start of SAR S01117
      * Change File Control Filename from RETRAN to SDRETRPD
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SJCHRC
      * End of SAR S01117
      * Start of 031807
      * Update TABLETZ - Retail Transaction Types  *
     C                   CALL      'TABLETZ'                            90      Update TABLETZ
     C     W0RTN         PARM      W0RTN         WQ0023            7            *Return code
     C                   PARM      A1RTTY        WQ0024            5            Retail Transact
     C                   PARM      A1RTNM        WQ0025           30            Retail Transact
     C                   PARM      A1COIN        WQ0026            1            Customer Origin
     C                   PARM      A1DCIN        WQ0027            1            Debit/Credit In
     C                   PARM      A1RVIN        WQ0028            1            Reversal Indica
     C                   PARM      A1PADI        WQ0029            1            Print Advices I
     C                   PARM      A1ACOM        WQ0030            1            Account Commiss
     C                   PARM      A1TYLC        WQ0031            1            Type of Last Ch
     C                   PARM      WURDNB        WQ0032            5 0          Run day number
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'TABLETZ'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * End of 031807
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
      * Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RADU - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RADU
     C*
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDRETRPD'    AHFLNM                         Filename
      *
     C     KLCHSJ        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSJ        CHAIN     @AHREAU                            9091      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       9091                  MD061008
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SJEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SJEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QSDFC1        YDRDCS
      * USER: Processing after Data read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
      * Set PGM.*Record Data Changed flag
     C     QSDFC1        IFNE      YDRDCS
     C                   MOVE      'Y'           YDRDC
     C                   END
      * If changed update record otherwise release record
     C     YDRDC         IFEQ      'Y'
     C**********         UPDATE    @AHREAU                              91      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       91                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061008
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKRVGN        BEGSR
      *================================================================
      * Get all Midas Modules - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSK         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSK         CHAIN     @BGREC8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0014                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SKEXIT                                       *QUIT
     C                   GOTO      SKEXIT
     C                   END
      *
      * USER: Exit processing
      * PAR = DB1 By name
     C                   MOVEL     BGMTMI        WUMTMI                         Midas/Telex Mod
     C                   MOVEL     BGSWFT        WUSWFT                         SWIFT Funds Tra
     C                   MOVEL     BGSWST        WUSWST                         SWIFT Securitie
     C                   MOVEL     BGSWCL        WUSWCL                         SWIFT Customer
     C                   MOVEL     BGSWSL        WUSWSL                         SWIFT Synd Loan
     C                   MOVEL     BGSWSM        WUSWSM                         SWIFT Statement
     C                   MOVEL     BGSWDL        WUSWDL                         SWIFT Dealing
     C                   MOVEL     BGSDGL        WUSDGL                         Standing data/G
     C                   MOVEL     BGDLFX        WUDLFX                         Dealing: FX
     C                   MOVEL     BGSYLN        WUSYLN                         Syndicated Loan
     C                   MOVEL     BGEXMG        WUEXMG                         Exposure Manage
     C                   MOVEL     BGFNMO        WUFNMO                         Financial Model
     C                   MOVEL     BGSTRT        WUSTRT                         Statutory Retur
     C                   MOVEL     BGCSLN        WUCSLN                         Customer Lendin
     C                   MOVEL     BGRTBN        WURTBN                         Retail Banking
     C                   MOVEL     BGMSDL        WUMSDL                         Midas/Swift dir
     C                   MOVEL     BGSECS        WUSECS                         Securities
     C                   MOVEL     BGAURC        WUAURC                         Auto-reconcilia
     C                   MOVEL     BGBDLI        WUBDLI                         Bond Dealers In
     C                   MOVEL     BGDRSD        WUDRSD                         DRS Standing Da
     C                   MOVEL     BGDRCM        WUDRCM                         DRS Control mod
     C                   MOVEL     BGDRFE        WUDRFE                         DRS Foreign Exc
     C                   MOVEL     BGDRMM        WUDRMM                         DRS Money Marke
     C                   MOVEL     BGDRAR        WUDRAR                         DRS Arbitrage
     C                   MOVEL     BGFDTR        WUFDTR                         Funds Transfer
     C                   MOVEL     BGDRCA        WUDRCA                         DRS Common Appl
     C                   MOVEL     BGFUOP        WUFUOP                         Futures & Optio
     C                   MOVEL     BGMTSL        WUMTSL                         Midas/Telex Syn
     C                   MOVEL     BGMTDL        WUMTDL                         Midas/Telex Dea
     C                   MOVEL     BGMTGL        WUMTGL                         Midas/Telex Gen
     C                   MOVEL     BGMTCL        WUMTCL                         Midas/Telex Cus
     C                   MOVEL     BGNWMI        WUNWMI                         Message Managem
     C                   MOVEL     BGFIIN        WUFIIN                         FRA/IRS Indicat
     C                   MOVEL     BGDLMM        WUDLMM                         Dealing: MM
     C                   MOVEL     BGINCN        WUINCN                         Internal Contra
     C                   MOVEL     BGTRMG        WUTRMG                         Treasury Manage
     C                   MOVEL     BGRKMG        WURKMG                         Interest Risk M
     C                   MOVEL     BGTSKY        WUTSKY                         Testkey
     C                   MOVEL     BGMIDQ        WUMIDQ                         Midas/Q
     C                   MOVEL     BGMFIC        WUMFIC                         Microfiche
     C                   MOVEL     BGIOAC        WUIOAC                         Interest on acc
     C                   MOVEL     BGWDPR        WUWDPR                         Window processi
     C                   MOVEL     BGSARP        WUSARP                         SAR's processin
     C                   MOVEL     BGFRIN        WUFRIN                         French return i
     C                   MOVEL     BGLRIN        WULRIN                         Lux return indi
     C                   MOVEL     BGDRIN        WUDRIN                         Dutch return in
     C                   MOVEL     BGGRIN        WUGRIN                         German return i
     C                   MOVEL     BGBRIN        WUBRIN                         Belgian return
     C                   MOVEL     BGIRIN        WUIRIN                         Italian return
     C                   MOVEL     BGSWEI        WUSWEI                         Swift External
     C                   MOVEL     BGPFMG        WUPFMG                         Portfolio Manag
     C                   MOVEL     BGCRMG        WUCRMG                         Credit Manageme
     C                   MOVEL     BGHORP        WUHORP                         Head Office Rep
     C                   MOVEL     BGAVBL        WUAVBL                         Average Balance
     C                   MOVEL     BGMARG        WUMARG                         Margins
     C                   MOVEL     BGCFMT        WUCFMT                         Confirmation Ma
     C                   MOVEL     BGMIMX        WUMIMX                         Mimix
     C                   MOVEL     BGRCFI        WURCFI                         Report Control
     C                   MOVEL     BGAMIN        WUAMIN                         Amps Int
     C                   MOVEL     BGSWRT        WUSWRT                         Swiss Returns
     C                   MOVEL     BGFLND        WUFLND                         Fiduciary Loans
     C                   MOVEL     BGLMCR        WULMCR                         Portfolio Lendi
     C                   MOVEL     BGCNTX        WUCNTX                         Cantonal Tax
     C                   MOVEL     BGSTDU        WUSTDU                         Stamp Duty
     C                   MOVEL     BGUDRS        WUUDRS                         Use DRS Shortna
     C                   MOVEL     BGCHDL        WUCHDL                         Chips Dealing
     C                   MOVEL     BGCHLN        WUCHLN                         Chips Lending
     C                   MOVEL     BGCHOB        WUCHOB                         Chips Opening B
     C                   MOVEL     BGCHIP        WUCHIP                         CHIPS
     C                   MOVEL     BGCHDI        WUCHDI                         Chips Direct Li
     C                   MOVEL     BGOPDK        WUOPDK                         Optical Disk
     C                   MOVEL     BGMBIN        WUMBIN                         Multi-branching
     C                   MOVEL     BGNNST        WUNNST                         Leo Data Nucleu
     C                   MOVEL     BGNOST        WUNOST                         Leo Letters of
     C                   MOVEL     BGNPST        WUNPST                         Leo Collections
     C                   MOVEL     BGNQST        WUNQST                         Leo Bills/Finan
     C                   MOVEL     BGNRST        WUNRST                         Leo Bankers Acc
     C                   MOVEL     BGNSST        WUNSST                         Leo Reimburseme
     C                   MOVEL     BGNTST        WUNTST                         Taxes
     C                   MOVEL     BGNUST        WUNUST                         History & Audit
     C                   MOVEL     BGNVST        WUNVST                         Management Acco
     C                   MOVEL     BGNWST        WUNWST                         IBLC Returns
     C                   MOVEL     BGNXST        WUNXST                         Retail 3
     C                   MOVEL     BGNYST        WUNYST                         Interest on Acc
     C                   MOVEL     BGNZST        WUNZST                         Midas Export Da
     C                   MOVEL     BGN0ST        WUN0ST                         Analytical Acco
     C                   MOVEL     BGN1ST        WUN1ST                         User Defined Co
     C                   MOVEL     BGN2ST        WUN2ST                         Midas-Plato Int
     C                   MOVEL     BGN3ST        WUN3ST                         Midas-Trade Inn
     C                   MOVEL     BGN4ST        WUN4ST                         Reserved for La
     C                   MOVEL     BGN5ST        WUN5ST                         Reserved for La
     C                   MOVEL     BGN6ST        WUN6ST                         Reserved for La
     C                   MOVEL     BGN7ST        WUN7ST                         Reserved for La
     C                   MOVEL     BGN8ST        WUN8ST                         Reserved for La
     C                   MOVEL     BGN9ST        WUN9ST                         Reserved for La
     C                   MOVEL     BGOAST        WUOAST                         Reserved for La
     C                   MOVEL     BGOBST        WUOBST                         Reserved for La
     C                   MOVEL     BGOCST        WUOCST                         Reserved for La
     C                   MOVEL     BGODST        WUODST                         Reserved for La
     C                   MOVEL     BGOEST        WUOEST                         Reserved for La
     C                   MOVEL     BGOFST        WUOFST                         Reserved for La
     C                   MOVEL     BGOGST        WUOGST                         Reserved for La
     C                   MOVEL     BGOHST        WUOHST                         Reserved for La
     C                   MOVEL     BGOIST        WUOIST                         Reserved for La
     C                   MOVEL     BGOJST        WUOJST                         Reserved for La
     C                   MOVEL     BGOKST        WUOKST                         Reserved for La
     C                   MOVEL     BGOLST        WUOLST                         Reserved for La
     C                   MOVEL     BGOMST        WUOMST                         Reserved for La
     C                   MOVEL     BGONST        WUONST                         Reserved for La
     C                   MOVEL     BGOOST        WUOOST                         Reserved for La
     C                   MOVEL     BGOPST        WUOPST                         Reserved for La
     C                   MOVEL     BGOQST        WUOQST                         Reserved for La
     C                   MOVEL     BGORST        WUORST                         Reserved for La
     C                   MOVEL     BGOSST        WUOSST                         Reserved for La
      *================================================================
     CSR   SKEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1RTTY        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Retail Transact
     C                   CALL      'SD0130S'                            90      Select Retail T
     C                   PARM      *BLANK        W0RTN             7
     C     #1RTTY        PARM      #1RTTY        WQ0001            5            Retail Transact
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0130S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        9931      *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y1SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y1EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C     @#DFMT        IFEQ      '#RCDKEY'
      * KEY Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
     C     @#DFMT        IFEQ      '#RCDDTL1'
      * DETAIL Screen
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
     C                   END
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y9EXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      1             YYLGCT            5 0          # of grps
     C                   PARM      W0GRP         YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131REPP - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131REPP
     C*
     C                   END                                                    *FI
      * Start of S01486
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * End of S01486
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Display CRT001/002 fields
     C                   MOVEL     *BLANK        WUDSCT            1
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field CRT001 or CRT002
     C                   MOVEL     *BLANK        WUDCRT            1
      * Define work field Retail 3
     C                   MOVEL     *BLANK        WUNXST            1
      * Define work field Retail Banking
     C                   MOVEL     *BLANK        WURTBN            1
      * Define work field Account Comm. Ind.display
     C                   MOVEL     *BLANK        WUACID            1
      * Define work field Portfolio Management
     C                   MOVEL     *BLANK        WUPFMG            1
      * Define work field Account Code
     C**********           MOVEL*BLANK    WUACCD  4                                           CGL029
     C                   MOVEL     *BLANK        WUACCD           10
      * Define work field Account type
     C                   MOVEL     *BLANK        WUACTY            1
      * Define work field Title Only Indicator
     C                   MOVEL     *BLANK        WUTOIN            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Define work field WM action code
     C                   MOVEL     *BLANK        WUWMAC            1
      * Define work field Display passbook
     C                   MOVEL     *BLANK        WUDSPP            1
      * Define work field Midas/Telex Module Ind.
     C                   MOVEL     *BLANK        WUMTMI            1
      * Define work field SWIFT Funds Transfer
     C                   MOVEL     *BLANK        WUSWFT            1
      * Define work field SWIFT Securities Trading
     C                   MOVEL     *BLANK        WUSWST            1
      * Define work field SWIFT Customer Lending
     C                   MOVEL     *BLANK        WUSWCL            1
      * Define work field SWIFT Synd Loans (REDUN)
     C                   MOVEL     *BLANK        WUSWSL            1
      * Define work field SWIFT Statements
     C                   MOVEL     *BLANK        WUSWSM            1
      * Define work field SWIFT Dealing
     C                   MOVEL     *BLANK        WUSWDL            1
      * Define work field Standing data/Gen.Ledger
     C                   MOVEL     *BLANK        WUSDGL            1
      * Define work field Dealing: FX
     C                   MOVEL     *BLANK        WUDLFX            1
      * Define work field Syndicated Loans (REDUN)
     C                   MOVEL     *BLANK        WUSYLN            1
      * Define work field Exposure Management
     C                   MOVEL     *BLANK        WUEXMG            1
      * Define work field Financial Modeller
     C                   MOVEL     *BLANK        WUFNMO            1
      * Define work field Statutory Returns
     C                   MOVEL     *BLANK        WUSTRT            1
      * Define work field Customer Lending
     C                   MOVEL     *BLANK        WUCSLN            1
      * Define work field Midas/Swift direct link
     C                   MOVEL     *BLANK        WUMSDL            1
      * Define work field Securities
     C                   MOVEL     *BLANK        WUSECS            1
      * Define work field Auto-reconciliations
     C                   MOVEL     *BLANK        WUAURC            1
      * Define work field Bond Dealers Interface
     C                   MOVEL     *BLANK        WUBDLI            1
      * Define work field DRS Standing Data
     C                   MOVEL     *BLANK        WUDRSD            1
      * Define work field DRS Control module
     C                   MOVEL     *BLANK        WUDRCM            1
      * Define work field DRS Foreign Exchange
     C                   MOVEL     *BLANK        WUDRFE            1
      * Define work field DRS Money Market
     C                   MOVEL     *BLANK        WUDRMM            1
      * Define work field DRS Arbitrage
     C                   MOVEL     *BLANK        WUDRAR            1
      * Define work field Funds Transfer
     C                   MOVEL     *BLANK        WUFDTR            1
      * Define work field DRS Common Applications
     C                   MOVEL     *BLANK        WUDRCA            1
      * Define work field Futures & Options
     C                   MOVEL     *BLANK        WUFUOP            1
      * Define work field Midas/Telex Synd. Loans
     C                   MOVEL     *BLANK        WUMTSL            1
      * Define work field Midas/Telex Dealing
     C                   MOVEL     *BLANK        WUMTDL            1
      * Define work field Midas/Telex Gen. Ledger
     C                   MOVEL     *BLANK        WUMTGL            1
      * Define work field Midas/Telex Cust. Lending
     C                   MOVEL     *BLANK        WUMTCL            1
      * Define work field Message Management
     C                   MOVEL     *BLANK        WUNWMI            1
      * Define work field FRA/IRS Indicator
     C                   MOVEL     *BLANK        WUFIIN            1
      * Define work field Dealing: MM
     C                   MOVEL     *BLANK        WUDLMM            1
      * Define work field Internal Contracts
     C                   MOVEL     *BLANK        WUINCN            1
      * Define work field Treasury Management
     C                   MOVEL     *BLANK        WUTRMG            1
      * Define work field Interest Risk Management
     C                   MOVEL     *BLANK        WURKMG            1
      * Define work field Testkey
     C                   MOVEL     *BLANK        WUTSKY            1
      * Define work field Midas/Q
     C                   MOVEL     *BLANK        WUMIDQ            1
      * Define work field Microfiche
     C                   MOVEL     *BLANK        WUMFIC            1
      * Define work field Interest on accounts
     C                   MOVEL     *BLANK        WUIOAC            1
      * Define work field SAR's processing required
     C                   MOVEL     *BLANK        WUSARP            1
      * Define work field French return indicator
     C                   MOVEL     *BLANK        WUFRIN            1
      * Define work field Lux return indicator
     C                   MOVEL     *BLANK        WULRIN            1
      * Define work field Dutch return indicator
     C                   MOVEL     *BLANK        WUDRIN            1
      * Define work field German return indicator
     C                   MOVEL     *BLANK        WUGRIN            1
      * Define work field Belgian return indicator
     C                   MOVEL     *BLANK        WUBRIN            1
      * Define work field Italian return indicator
     C                   MOVEL     *BLANK        WUIRIN            1
      * Define work field Swift External Interface
     C                   MOVEL     *BLANK        WUSWEI            1
      * Define work field Credit Management.
     C                   MOVEL     *BLANK        WUCRMG            1
      * Define work field Head Office Reporting
     C                   MOVEL     *BLANK        WUHORP            1
      * Define work field Average Balances
     C                   MOVEL     *BLANK        WUAVBL            1
      * Define work field Margins
     C                   MOVEL     *BLANK        WUMARG            1
      * Define work field Confirmation Matching
     C                   MOVEL     *BLANK        WUCFMT            1
      * Define work field Mimix
     C                   MOVEL     *BLANK        WUMIMX            1
      * Define work field Report Control Facility
     C                   MOVEL     *BLANK        WURCFI            1
      * Define work field Amps Int
     C                   MOVEL     *BLANK        WUAMIN            1
      * Define work field Swiss Returns
     C                   MOVEL     *BLANK        WUSWRT            1
      * Define work field Fiduciary Loans & Deposit
     C                   MOVEL     *BLANK        WUFLND            1
      * Define work field Portfolio Lending
     C                   MOVEL     *BLANK        WULMCR            1
      * Define work field Cantonal Tax
     C                   MOVEL     *BLANK        WUCNTX            1
      * Define work field Stamp Duty
     C                   MOVEL     *BLANK        WUSTDU            1
      * Define work field Use DRS Shortnames
     C                   MOVEL     *BLANK        WUUDRS            1
      * Define work field Chips Dealing
     C                   MOVEL     *BLANK        WUCHDL            1
      * Define work field Chips Lending
     C                   MOVEL     *BLANK        WUCHLN            1
      * Define work field Chips Opening Balance
     C                   MOVEL     *BLANK        WUCHOB            1
      * Define work field CHIPS
     C                   MOVEL     *BLANK        WUCHIP            1
      * Define work field Chips Direct Link
     C                   MOVEL     *BLANK        WUCHDI            1
      * Define work field Optical Disk
     C                   MOVEL     *BLANK        WUOPDK            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Leo Data Nucleus
     C                   MOVEL     *BLANK        WUNNST            1
      * Define work field Leo Letters of Credit
     C                   MOVEL     *BLANK        WUNOST            1
      * Define work field Leo Collections
     C                   MOVEL     *BLANK        WUNPST            1
      * Define work field Leo Bills/Financing
     C                   MOVEL     *BLANK        WUNQST            1
      * Define work field Leo Bankers Acceptances
     C                   MOVEL     *BLANK        WUNRST            1
      * Define work field Leo Reimbursements
     C                   MOVEL     *BLANK        WUNSST            1
      * Define work field Taxes
     C                   MOVEL     *BLANK        WUNTST            1
      * Define work field History & Audit Facility
     C                   MOVEL     *BLANK        WUNUST            1
      * Define work field Management Accounts
     C                   MOVEL     *BLANK        WUNVST            1
      * Define work field IBLC Returns
     C                   MOVEL     *BLANK        WUNWST            1
      * Define work field Interest on Accounts 3
     C                   MOVEL     *BLANK        WUNYST            1
      * Define work field Midas Export Data Module
     C                   MOVEL     *BLANK        WUNZST            1
      * Define work field Analytical Accounting
     C                   MOVEL     *BLANK        WUN0ST            1
      * Define work field User Defined Correspondnc
     C                   MOVEL     *BLANK        WUN1ST            1
      * Define work field Midas-Plato Interface
     C                   MOVEL     *BLANK        WUN2ST            1
      * Define work field Midas-Trade Innovation If
     C                   MOVEL     *BLANK        WUN3ST            1
      * Define work field Reserved for Later Use 41
     C                   MOVEL     *BLANK        WUN4ST            1
      * Define work field Reserved for Later Use 42
     C                   MOVEL     *BLANK        WUN5ST            1
      * Define work field Reserved for Later Use 43
     C                   MOVEL     *BLANK        WUN6ST            1
      * Define work field Reserved for Later Use 44
     C                   MOVEL     *BLANK        WUN7ST            1
      * Define work field Reserved for Later Use 45
     C                   MOVEL     *BLANK        WUN8ST            1
      * Define work field Reserved for Later Use 46
     C                   MOVEL     *BLANK        WUN9ST            1
      * Define work field Reserved for Later Use 47
     C                   MOVEL     *BLANK        WUOAST            1
      * Define work field Reserved for Later Use 48
     C                   MOVEL     *BLANK        WUOBST            1
      * Define work field Reserved for Later Use 49
     C                   MOVEL     *BLANK        WUOCST            1
      * Define work field Reserved for Later Use 50
     C                   MOVEL     *BLANK        WUODST            1
      * Define work field Reserved for Later Use 51
     C                   MOVEL     *BLANK        WUOEST            1
      * Define work field Reserved for Later Use 52
     C                   MOVEL     *BLANK        WUOFST            1
      * Define work field Reserved for Later Use 53
     C                   MOVEL     *BLANK        WUOGST            1
      * Define work field Reserved for Later Use 54
     C                   MOVEL     *BLANK        WUOHST            1
      * Define work field Reserved for Later Use 55
     C                   MOVEL     *BLANK        WUOIST            1
      * Define work field Reserved for Later Use 56
     C                   MOVEL     *BLANK        WUOJST            1
      * Define work field Reserved for Later Use 57
     C                   MOVEL     *BLANK        WUOKST            1
      * Define work field Reserved for Later Use 58
     C                   MOVEL     *BLANK        WUOLST            1
      * Define work field Reserved for Later Use 59
     C                   MOVEL     *BLANK        WUOMST            1
      * Define work field Reserved for Later Use 60
     C                   MOVEL     *BLANK        WUONST            1
      * Define work field Reserved for Later Use 61
     C                   MOVEL     *BLANK        WUOOST            1
      * Define work field Reserved for Later Use 62
     C                   MOVEL     *BLANK        WUOPST            1
      * Define work field Reserved for Later Use 63
     C                   MOVEL     *BLANK        WUOQST            1
      * Define work field Reserved for Later Use 64
     C                   MOVEL     *BLANK        WUORST            1
      * Define work field Reserved for Later Use 65
     C                   MOVEL     *BLANK        WUOSST            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Commission on Debit Turn
     C                   MOVEL     *BLANK        WUCODT            1
      * Define work field CRT002
     C                   MOVEL     *BLANK        WUYXST            1
      * Define work field SAR number field
     C                   MOVEL     *BLANK        WUSARN            6
      * Define work field Access Pgm Return Code
     C                   MOVEL     *BLANK        WUAPRC            7
      * Define work field Access obj dummy DS (76)
     C                   MOVEL     *BLANK        WUFDY            76
      * Define work field Switchable feature CRT002
     C                   MOVEL     *BLANK        WUCRT2            1
      * Define work field CRT001
     C                   MOVEL     *BLANK        WUCRT1            1
      * Define work field Switchable feature CRT001
     C                   MOVEL     *BLANK        WURTSS            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Open files
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
     C                   OPEN      SD0131R#
     C***********        OPEN      SDRETRL1                                                 MD058755
     C                   OPEN      SDACODL1
     C                   OPEN      SDMMODL1
     C***********        OPEN      SDRETRL0                                                 MD058755
     C***********        OPEN      SDFCTLL0                                                 MD061008
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of S01459
      * Remove the last amend box and creation parameter functions.
      * SD0131R Precompiler - Retail Transaction Types  *
      * End of S01459
      * Start of CRT001
      * Call 'Get all Midas Modules' instead of
      * 'Get Retail 3/IOA indic' &
      * 'Get Portfilio Management' &
      * Get 'Window Required' Ind
      * Get all Midas Modules - MIDAS Modules  *
     C                   EXSR      SKRVGN
      * End of CRT001
      * S01212 - Standard Functions  * S01212
     C                   MOVEL     'Y'           WUMFTS                         S01212
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement 1988 - Standard Functions  * copyright
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C*
      * start S01413
      * Replaced 'Get Retail 3/IOA indic' by 'Get all Midas Modules'
     C                   MOVEL     'N'           WUACID                         Account Comm. I
      * CASE: WRK.Retail 3 is Yes
     C     WUNXST        IFEQ      'Y'                                          *IF
      * Get Comm on Debit Turnovr - Retail Details  *
     C                   CALL      'SD9342'                             90      Get Comm on Deb
     C     W0RTN         PARM      W0RTN         WQ0033            7            *Return code
     C     WUCODT        PARM      *BLANK        WQ0034            1            Commission on D
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD9342'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: WRK.Commission on Debit Turn is Yes
     C     WUCODT        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUACID                         Account Comm. I
     C                   END                                                    *FI
     C                   END                                                    *FI
      * end S01413
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
      * Start of S01486
      * Replaced 'Get Portfolio Management' by 'Get all Midas Modules'
      * End of S01486
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * Replaced 'Get Window Required Ind' by 'Get all Midas Modules'
      * Data Structure - Ret Tran - Retail Transaction Types  *
     C                   END                                                    *FI
      * Start of change CRT002.
     C                   MOVEL     'N'           WUYXST                         CRT002
     C                   MOVEL     'CRT002'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0035            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0036            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0037            6            SAR number fiel
     C                   PARM      WUFDY         WQ0038           76            Access obj dumm
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Does the switchable feature CRT002 exist ?
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WUCRT2                         Switchable feat
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUCRT2                         Switchable feat
     C                   END                                                    *FI
      * End of change CRT002.
      * Start of change CRT001.
     C                   MOVEL     'N'           WUCRT1                         CRT001
     C                   MOVEL     'N'           WUDSPP                         Display passboo
     C                   MOVEL     'CRT001'      WUSARN                         SAR number fiel
      * SAR switched on check - Standard Functions  *
     C                   CALL      'AOSARDR0'                           90      SAR switched on
     C     WUAPRC        PARM      WUAPRC        WQ0039            7            Access Pgm Retu
     C                   PARM      '*VERIFY'     WQ0040            7            Option for ACCO
     C     WUSARN        PARM      WUSARN        WQ0041            6            SAR number fiel
     C                   PARM      WUFDY         WQ0042           76            Access obj dumm
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOSARDR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Does the switchable feature CRT001 exist ?
      * CASE: WRK.Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WURTSS                         Switchable feat
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WURTSS                         Switchable feat
     C                   END                                                    *FI
      * Start CRT002
      * CASE:
      *  - c1 OR c2
      *   |- c1    : WRK.Switchable feature CRT001 is Present
      *   |- c2    : WRK.Switchable feature CRT002 is Present
      *   '-
     C     WURTSS        IFEQ      'Y'                                          *IF
     C     WUCRT2        OREQ      'Y'                                          *OR
     C                   MOVEL     'Y'           WUDCRT                         CRT001 or CRT00
     C                   END                                                    *FI
      *                                                                                       BA6026
      ** Access SAR file to determine if BA6026 is installed.                                 BA6026
      *                                                                                       BA6026
     C                   CALL      'AOSARDR0'                                                 BA6026
     C                   PARM      *BLANKS       WRTCD             7                          BA6026
     C                   PARM      '*VERIFY'     WOPTN             7                          BA6026
     C                   PARM      'BA6026'      WSARD             6                          BA6026
     C                   PARM                    WUFDY                                        BA6026
      *                                                                                       BA6026
     C                   SELECT                                                               BA6026
     C     WRTCD         WHENEQ    *BLANKS                                                    BA6026
     C                   MOVE      'Y'           BA6026            1                          BA6026
     C                   OPEN      A6RETRL0                                                   BA6026
     C                   OPEN      A6RETRL1                                                   BA6026
      *                                                                                       BA6026
     C     WRTCD         WHENEQ    '*NRF'                                                     BA6026
     C                   MOVE      'N'           BA6026                                       BA6026
      *                                                                                       BA6026
     C                   OTHER                                                                BA6026
     C                   EXSR      *PSSR                                                      BA6026
     C                   ENDSL                                                                BA6026
      *
      * CASE:
      *  - c1 AND c2 AND c3 AND c4
      *   |- c1    : WRK.CRT001 or CRT002 is Present
      *   |- c2    : WRK.Retail 3 is Yes
      *   |- c3    : WRK.Retail Banking is Yes
      *   |- c4    : PAR.Retail Transaction Type is 99500 - 99799
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     WUDCRT        IFEQ      'Y'                                          *IF
     C     WUNXST        IFEQ      'Y'                                          *IF
     C     WURTBN        IFEQ      'Y'                                          *IF
     C     P1RTTY        IFGE      '99500'                                      *IF
     C     P1RTTY        ANDLE     '99799'
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y'           WUDSCT                         Display CRT001/
     C                   ELSE
      * CASE: *OTHERWISE
      * Start of change 093811.
      * End of change 093811.
     C                   MOVEL     'N'           WUDSCT                         Display CRT001/
      * End CRT002
     C                   END                                                    *FI
      * CRT002: include CRT002 in conditioning.
      * CASE:
      *  - c1 OR c2
      *   |- c1    : WRK.Switchable feature CRT001 is Present
      *   |- c2    : WRK.Switchable feature CRT002 is Present
      *   '-
     C     WURTSS        IFEQ      'Y'                                          *IF
     C     WUCRT2        OREQ      'Y'                                          *OR
     C                   MOVEL     'Y'           WUDSPP                         Display passboo
     C                   END                                                    *FI
      * End of change CRT001.
      *                                                                                       CER030
      ** Access SAR details to verify whether CER030 is installed                             CER030
      *                                                                                       CER030
     C                   MOVEL     'CER030'      WUSARN
      *                                                                                       CER030
      ** SAR switched on check - Standard Functions                                           CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                           90
     C     WUAPRC        PARM      WUAPRC        PQ0043            7
     C                   PARM      '*VERIFY'     WQ0044            7
     C     WUSARN        PARM      WUSARN        WQ0045            6
     C                   PARM      WUFDY         WQ0046           76
      *                                                                                       CER030
     C     *IN90         IFEQ      '1'
      *                                                                                       CER030
      ** Call to program ended in error                                                       CER030
      *                                                                                       CER030
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
      *                                                                                       CER030
      ** Send message '*Error occured on CALL...'                                             CER030
      *                                                                                       CER030
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CER030
      ** Does the switchable feature CER030 exist ?                                           CER030
      ** CASE: WRK.Access Pgm Return Code is *Normal                                          CER030
      *                                                                                       CER030
     C     WUAPRC        IFEQ      *BLANK
     C                   MOVEL     'Y'           CER030            1
     C                   ELSE
      *                                                                                       CER030
      ** CASE: *OTHERWISE                                                                     CER030
      *                                                                                       CER030
     C                   MOVEL     'N'           CER030
     C                   END
      *                                                                                       CER030
      ** Access SAR details to verify whether CGL013 is installed                             CER030
      *                                                                                       CER030
     C                   MOVEL     'CGL013'      WUSARN
      *                                                                                       CER030
      ** SAR switched on check - Standard Functions                                           CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                           90
     C     WUAPRC        PARM      WUAPRC        PQ0047            7
     C                   PARM      '*VERIFY'     PQ0048            7
     C     WUSARN        PARM      WUSARN        PQ0049            6
     C                   PARM      WUFDY         PQ0050           76
      *                                                                                       CER030
     C     *IN90         IFEQ      '1'
      *                                                                                       CER030
      ** Call to program ended in error                                                       CER030
      *                                                                                       CER030
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
      *                                                                                       CER030
      ** Send message '*Error occured on CALL...'                                             CER030
      *                                                                                       CER030
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CER030
      ** Does the switchable feature CGL013 exist ?                                           CER030
      ** CASE: WRK.Access Pgm Return Code is *Normal                                          CER030
      *                                                                                       CER030
     C     WUAPRC        IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL013            1
     C                   ELSE
      *                                                                                       CER030
      ** CASE: *OTHERWISE                                                                     CER030
      *                                                                                       CER030
     C                   MOVEL     'N'           CGL013
     C                   END
      *                                                                                       CER030
      *                                                                                       CER030
      ** Access SAR details to verify whether CER044 is installed                             CER030
      *                                                                                       CER030
     C                   MOVEL     'CER044'      WUSARN
      *                                                                                       CER030
      ** SAR switched on check - Standard Functions                                           CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                           90
     C     WUAPRC        PARM      WUAPRC        PQ0051            7
     C                   PARM      '*VERIFY'     PQ0052            7
     C     WUSARN        PARM      WUSARN        PQ0053            6
     C                   PARM      WUFDY         PQ0054           76
      *                                                                                       CER030
     C     *IN90         IFEQ      '1'
      *                                                                                       CER030
      ** Call to program ended in error                                                       CER030
      *                                                                                       CER030
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
      *                                                                                       CER030
      ** Send message '*Error occured on CALL...'                                             CER030
      *                                                                                       CER030
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CER030
      ** Does the switchable feature CGL013 exist ?                                           CER030
      ** CASE: WRK.Access Pgm Return Code is *Normal                                          CER030
      *                                                                                       CER030
     C     WUAPRC        IFEQ      *BLANK
     C                   MOVEL     'Y'           CER044            1
     C                   ELSE
      *                                                                                       CER030
      ** CASE: *OTHERWISE                                                                     CER030
      *                                                                                       CER030
     C                   MOVEL     'N'           CER044
     C                   END
      *                                                                                       CER030
      * CASE: WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      'Y'                                          *IF
      * 00/Copy member SD0131RFPG - Retail Transaction Types  * S01212
      * 00/Copy member SD0131REPG - Retail Transaction Types  * S01212
      * 00/Copy member SD0131RIPG - Retail Transaction Types  * S01212
      * 00/Copy member SD0131RCPG - Retail Transaction Types  * S01212
     C*
     C/COPY WNCPYSRC,SD0131RCPG
     C*
      * 00/Copy member SD0131ROPG - Retail Transaction Types  * S01212
     C                   END                                                    *FI
      *                                                                                       CGL154
      ** Check if CGL154 - FATCA Reporting is ON                                              CGL154
      *                                                                                       CGL154
     C                   MOVEL     'N'           CGL154
     C                   MOVE      '1'           *IN80
      *                                                                                       CGL154
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     OPTION            7
     C                   PARM      'CGL154'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGL154
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGL154
     C                   ELSE
      *                                                                                       CGL154
     C                   MOVEL     'Y'           CGL154            1
     C**********           MOVE '0'       *IN80                                        CGL154 CGL177
     C                   ENDIF
      *                                                                                       CGL177
      ** Check if CGL177 - CRS Reporting Phase 2 is ON                                        CGL177
      *                                                                                       CGL177
     C                   MOVEL     'N'           CGL177
      *                                                                                       CGL177
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     OPTION            7
     C                   PARM      'CGL177'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CGL177
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'AOSARDR0'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CGL177
     C                   ELSE
      *                                                                                       CGL177
     C                   MOVEL     'Y'           CGL177            1
     C                   ENDIF
      *                                                                                       CGL177
     C     CGL154        IFEQ      'Y'
     C     CGL177        OREQ      'Y'
     C                   MOVE      '0'           *IN80
     C                   ELSE
     C                   MOVE      '1'           *IN80
     C                   ENDIF
      *                                                                                       CSW101
      ** Check if CSW101 - PAYPlus is ON                                                      CSW101
      *                                                                                       CSw101
     C                   MOVEL     'N'           CSW101                                       CSW101
     C                   MOVE      '1'           *IN81                                        CSW101
      *                                                                                       CSW101
     C                   CALL      'AOSARDR0'                                                 CSW101
     C                   PARM      *BLANKS       PRTCD                                        CSw101
     C                   PARM      '*VERIFY'     OPTION                                       CSW101
     C                   PARM      'CSW101'      @SARD                                        CSw101
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW101
      *                                                                                       CSW101
     C     PRTCD         IFNE      *BLANKS                                                    CSw101
     C     PRTCD         IFNE      '*NRF'                                                     CSW101
     C                   MOVEL     'Y2U0032'     W0RTN                                        CSW101
     C                   MOVEL     *BLANKS       W0CLPG                                       CSw101
     C                   MOVEL     'AOSARDR0'    W0CLPG                                       CSW101
     C                   MOVEL     'Y2U0032'     ZAMSID                                       CSW101
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                       CSw101
     C                   MOVEL     W0CLPG        ZAMSDA                                       CSW101
     C                   EXSR      ZASNMS                                                     CSW101
     C                   ENDIF                                                                CSw101
      *                                                                                       CSW101
     C                   ELSE                                                                 CSW101
      *                                                                                       CSW101
     C                   MOVEL     'Y'           CSW101            1                          CSW101
     C                   MOVE      '0'           *IN81                                        CSW101
     C                   ENDIF                                                                CSW101
      *                                                                                       CSw101
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SD0131RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0131RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058755
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058755
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0131RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*
     O/COPY WNCPYSRC,SD0131ROPG
     O*
**CTDATA CPY@
(c) Finastra International Limited 2001
