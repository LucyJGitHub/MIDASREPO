     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Function code maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0681R - Midas SD RTS function code maintenance.            *
      *                                                               *
      *  Function:  This program allows the user to maintain one      *
      *             RTS function record at a time.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT002             Date 24Feb97               *
      *                 093698             DATE 03OCT95               *
      *                 CRT001             DATE 02MAR95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  CRT002 - Retail Branch Access:                               *
      *           Validation Indicator fields have new valid option   *
      *           of 'X' - 'Validation not Required'.                 *
      *  093698 - Increase the range of allowable Retail Transaction  *
      *           Types.                                              *
      *  CRT001 - New program for Retail Teller System.               *
      *                                                               *
      *****************************************************************
     F*Function Codes Edit      Initialise Program F-spec
     F/COPY WNCPYSRC,SD0681RFPG
     FSD0681R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Function code maintenance
      *
     F*SDFNCDL1* IF   E           K DISK    USROPN                                          MD058085
     F**********                           INFDS(INFDS1)                                    MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * RTV : Midas SD RTS function codes file retrieval
      *
     FSDRETRL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Retail transaction types retrieval
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     F*SDFNCDL0* UF A E           K DISK    USROPN                                          MD058085
     F**********                           COMMIT                                           MD058085
     F**********                           INFDS(ID0003)                                    MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * UPD : Midas SD RTS function codes file update
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0004)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*Function Codes Edit      Initialise Program E-spec
     D/COPY WNCPYSRC,SD0681REPG
      * Long constants
     D @CN#            S              6    DIM(1) CTDATA PERRCD(1)
     D @CN             S             25    DIM(1) ALT(@CN#)
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*                                                                   S01229
     D*COPY*QWINDSRC,SD0680GDTA                                           S01229            MD058085
     D/COPY QWINDSRC,SD0680GDTL                                                             MD058085
     D*                                                                   S01229
     D*
     D*Function Codes Edit      Initialise Program I-spec
     D/COPY WNCPYSRC,SD0681RIPG
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
     D*@1DBRC***     E DS                  EXTNAME(SDFNCDL0)
     D @1DBRC        E DS                  EXTNAME(SDFNCJW0)                                MD058085
     D                                     PREFIX(X)                                        MD058085
     D SDFNCD        E DS                  EXTNAME(SDFNCJW0)                                MD058085
      * UPD : Midas SD RTS function codes file update
      * Current/previous master file format fields for change control
      *
     D*#1DBRC***       DS            82                                                     MD058085
     D #1DBRC          DS            83                                                     MD058085
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
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
     D YCRDCS          DS            82
     D YDRDCS          DS            22
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D @RDS            DS            25
     D* Data structure to redefine override indicators
     D  WUVWIN                 1     25
     D  #DBLDB                 1      1
     D  #DBLCR                 2      2
     D  #DRFDR                 3      3
     D  #DRFCR                 4      4
     D  #DINAC                 5      5
     D  #DBRLQ                 6      6
     D  #DBDDT                 7      7
     D  #DINFD                 8      8
     D  #DEXOD                 9      9
     D  #DMNBL                10     10
     D  #DSTCQ                11     11
     D  #DCQOR                12     12
     D  #DCQPR                13     13
     D  #DTLLM                14     14
     D  #DERAT                15     15
     D  #DBRDF                16     16
     D  #DACCL                17     17
     D  #DNWKD                18     18
     D  #DINBV                19     19
     D  #DNAGL                20     20
     D*
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
     D P1PARM          DS            82
      * RCD: Midas SD RTS function codes file retrieval
      * I : MAP Function Code
     D  P1FNCD                 1      3
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Validation Indicators:'
      * Message data for 'Validation Indicators:'
      * Message data for 'Function code cannot be 0'
      * Function Code
     D  ZA0001                 1      3
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0002                 1     10
      * Message data for 'Function Code exists'
      * Function Code
     D  ZA0003                 1      3
      * Message data for 'Function Code is required'
      * Function Code Narrative
     D  ZA0004                 1     30
      * Message data for 'Debit tran cannot have C'
      * Debit Tran. Code No.1
     D  ZA0005                 1      5
      * Message data for 'Debit tran No.1 not found'
      * Debit Tran. Code No.1
     D  ZA0006                 1      5
      * Message data for 'Debit tran cannot have C'
      * Debit Tran. Code No.1
     D  ZA0007                 1      5
      * Message data for 'Dbt tran type 1 invalid'
      * Debit Tran. Code No.1
     D  ZA0008                 1      5
      * Message data for 'Credit tran cannot have D'
      * Credit Tran. Code No.1
     D  ZA0009                 1      5
      * Message data for 'Credit tran No.1 not fond'
      * Credit Tran. Code No.1
     D  ZA0010                 1      5
      * Message data for 'Credit tran cannot have D'
      * Credit Tran. Code No.1
     D  ZA0011                 1      5
      * Message data for 'CR tran no. 1 is invalid'
      * Credit Tran. Code No.1
     D  ZA0012                 1      5
      * Message data for 'Dbt tran 2 must be blank'
      * Debit Tran. Code No.2
     D  ZA0013                 1      5
      * Message data for 'Debit trn 2 cannot have C'
      * Debit Tran. Code No.2
     D  ZA0014                 1      5
      * Message data for 'Debit tran No.2 not found'
      * Debit Tran. Code No.2
     D  ZA0015                 1      5
      * Message data for 'Debit trn 2 cannot have C'
      * Debit Tran. Code No.2
     D  ZA0016                 1      5
      * Message data for 'Dbt tran no.2 invalid'
      * Debit Tran. Code No.2
     D  ZA0017                 1      5
      * Message data for 'Cr trans 2 must be blank'
      * Credit Tran. Code No.2
     D  ZA0018                 1      5
      * Message data for 'Crdt tran 2 cannot have D'
      * Credit Tran. Code No.2
     D  ZA0019                 1      5
      * Message data for 'Credit tran no.2 not fond'
      * Credit Tran. Code No.2
     D  ZA0020                 1      5
      * Message data for 'Crdt tran 2 cannot have D'
      * Credit Tran. Code No.2
     D  ZA0021                 1      5
      * Message data for 'CR trans no. 2 invalid'
      * Credit Tran. Code No.2
     D  ZA0022                 1      5
      * Message data for 'Block Debit Ind is req'
      * Block Debit Ind
     D  ZA0023                 1      1
      * Message data for 'Block Debit ind invalid'
      * Block Debit Ind
     D  ZA0024                 1      1
      * Message data for 'Stopped Cheque Ind is req'
      * Stopped Cheque Ind
     D  ZA0025                 1      1
      * Message data for 'Stopped cheque invalid'
      * Stopped Cheque Ind
     D  ZA0026                 1      1
      * Message data for 'Block Credit Ind is req'
      * Block Credit Ind
     D  ZA0027                 1      1
      * Message data for 'Block Credit invalid'
      * Block Credit Ind
     D  ZA0028                 1      1
      * Message data for 'Cheqe out of rnge ind req'
      * Cheque Out of Range Ind
     D  ZA0029                 1      1
      * Message data for 'Chqe out of range invalid'
      * Cheque Out of Range Ind
     D  ZA0030                 1      1
      * Message data for 'Refer Debit ind is req'
      * Refer Debit Ind
     D  ZA0031                 1      1
      * Message data for 'Refer debit invalid'
      * Refer Debit Ind
     D  ZA0032                 1      1
      * Message data for 'Cheqe presentd ind is req'
      * Cheque Presented Ind
     D  ZA0033                 1      1
      * Message data for 'Chqe prsntd cannot be 'Y''
      * Cheque Presented Ind
     D  ZA0034                 1      1
      * Message data for 'Cheqe Presented invalid'
      * Cheque Presented Ind
     D  ZA0035                 1      1
      * Message data for 'Refer credit ind is req'
      * Refer Credit Ind
     D  ZA0036                 1      1
      * Message data for 'Refer Credit invalid'
      * Refer Credit Ind
     D  ZA0037                 1      1
      * Message data for 'Teller limit is req'
      * Teller Limit
     D  ZA0038                 1      1
      * Message data for 'Teller limit invalid'
      * Teller Limit
     D  ZA0039                 1      1
      * Message data for 'Inactive account is req'
      * Inactive Account
     D  ZA0040                 1      1
      * Message data for 'Inactive Account invalid'
      * Inactive Account
     D  ZA0041                 1      1
      * Message data for 'Exchange Rate is req'
      * Exchange Rate Ind
     D  ZA0042                 1      1
      * Message data for 'Exchange rate invalid'
      * Exchange Rate Ind
     D  ZA0043                 1      1
      * Message data for 'Bankrupt/Liquid is req'
      * Bankrupt/Liqidation Ind
     D  ZA0044                 1      1
      * Message data for 'Bankrupt/Liquid invalid'
      * Bankrupt/Liqidation Ind
     D  ZA0045                 1      1
      * Message data for 'Branch Different is req'
      * Branch Different Ind
     D  ZA0046                 1      1
      * Message data for 'Branch different invalid'
      * Branch Different Ind
     D  ZA0047                 1      1
      * Message data for 'Bad debt is req'
      * Bad Debt Ind
     D  ZA0048                 1      1
      * Message data for 'Bad debt invalid'
      * Bad Debt Ind
     D  ZA0049                 1      1
      * Message data for 'Account closing is req'
      * Account Closing Ind
     D  ZA0050                 1      1
      * Message data for 'Account closing invalid'
      * Account Closing Ind
     D  ZA0051                 1      1
      * Message data for 'Insufficient fund is req'
      * Insufficient Fund Ind
     D  ZA0052                 1      1
      * Message data for 'Insufficient fund invalid'
      * Insufficient Fund Ind
     D  ZA0053                 1      1
      * Message data for 'Non-working Day is req'
      * Non-working Day Ind
     D  ZA0054                 1      1
      * Message data for 'Non-working day invalid'
      * Non-working Day Ind
     D  ZA0055                 1      1
      * Message data for 'Exceeding OD is req'
      * Exceeding OD Ind
     D  ZA0056                 1      1
      * Message data for 'Exceeding OD invalid'
      * Exceeding OD Ind
     D  ZA0057                 1      1
      * Message data for 'Invalid Backvaluation req'
      * Invalid Backvaluation Ind
     D  ZA0058                 1      1
      * Message data for 'Invalid Backvalu invalid'
      * Invalid Backvaluation Ind
     D  ZA0059                 1      1
      * Message data for 'Minimum balance is req'
      * Minimum Balance Ind
     D  ZA0060                 1      1
      * Message data for 'Minimum balance invalid'
      * Minimum Balance Ind
     D  ZA0061                 1      1
      * Message data for 'No assoc Gl code is req'
      * No Associated GL Code Ind
     D  ZA0062                 1      1
      * Message data for 'No assoc gl code invalid'
      * No Associated GL Code Ind
     D  ZA0063                 1      1
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0064                 1     10
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         RCD: RTS functi
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
     C     #1FNCD        IFEQ      *BLANK                                       Function Code
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
     C                   KFLD                    FQFNCD                         Function Code
      * Setup key
     C                   MOVEL     #1FNCD        FQFNCD                         Function Code
     C*****KRTV*         CHAIN     @FNCDL1                            9091      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDFNCD                                                                        MD058085
     C+ from SDFNCJW0                                                                       MD058085
     C+ where FQFNCD = :FQFNCD                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9091                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        91                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
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
      * Send message 'RTS function codes fil NF'
     C                   MOVEL     'USR2683'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * 00/Copy member SD0681RSFF - RTS function codes file  *
     C*Function Codes Edit      Calc Detail Function Flds
     C/COPY WNCPYSRC,SD0681RSFF
      * USER: Initialize detail screen (existing record)
      * Setup message data for message
      * Retrieve message Validation Indicators:
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2715'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DVIND        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * SD0681R DTL screen footer - RTS function codes file  *
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
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
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
     C*  If Action Code is Amend:
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
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
     C*  If Action Code is Insert:
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
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
     C                   MOVEL     FQVWIN        WUVWIN                         Validate/Warnin
      * 00/Copy member SD0681RISE - RTS function codes file  *
     C*Function Codes Edit      Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,SD0681RISE
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        9931      *
      * Send message 'RTS function codes fil EX'
     C                   MOVEL     'USR2684'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      * USER: Initialize detail screen (new record)
      * SD0681R DTL screen footer - RTS function codes file  *
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
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
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
     C*  If Action Code is Amend:
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
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
     C*  If Action Code is Insert:
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
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
      * Setup message data for message
      * Retrieve message Validation Indicators:
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2715'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     #DVIND        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Set all the 'Validation Indicators' to 'N'.
     C                   MOVEL     @CN(01)       WUVWIN                         Validate/Warnin
      * 00/Copy member SD0681RISN - RTS function codes file  *
     C*Function Codes Edit      Initialise Dtl New Rcd
     C/COPY WNCPYSRC,SD0681RISN
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
     C     W0PMD         IFNE      'ADD'
      * Select existing record
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * CASE: KEY.Function Code is All zeros
     C     #1FNCD        IFEQ      '000'                                        *IF
      * Setup message data for message
     C                   MOVEL     #1FNCD        ZA0001                         Function Code
      * Send message 'Function code cannot be 0'
     C                   MOVEL     'USR2716'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1FNCD        WUTQKF                         Test ? in Key F
      * Question mark has been entered.
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1FNCD        ZA0002                         Function Code
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * Check for Duplicate - RTS function codes file  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1FNCD        ZA0003                         Function Code
      * Send message 'Function Code exists'
     C                   MOVEL     'USR2717'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0681RVKS - RTS function codes file  *
     C*Function Codes Edit      Validate Key Screen
     C/COPY WNCPYSRC,SD0681RVKS
      * Function Code required
     C     #1FNCD        IFEQ      *BLANK                                       IF
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
      * 00/Copy member SD0681RPKR - RTS function codes file  *
     C*Function Codes Edit      Process Key Screen Rqst
     C/COPY WNCPYSRC,SD0681RPKR
      * F12 processing
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * SD0681R KEY screen footer - RTS function codes file  *
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
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
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
     C*
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
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
      * USER: Validate detail screen fields
      * Disable 'ENTER' in delete mode
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * Send message 'F3/F10/F12 only valid opt'
     C                   MOVEL     'USR0536'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * Function Code Narrative
      * CASE: DTL.Function Code Narrative is Blank
     C     #1RNNR        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1RNNR        ZA0004                         Function Code N
      * Send message 'Function Code is required'
     C                   MOVEL     'USR2718'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * Debit Transaction Code No.1
      * CASE: DTL.Debit Tran. Code No.1 is Entered
     C     #1DRC1        IFNE      *BLANK                                       *IF
     C                   MOVEL     #1DRC1        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        WURTTY                         Retail Transact
      * Select RTS Retail Trans. - Retail Transaction Types  *
     C                   CALL      'SD0131S'                            90      Select RTS Reta
     C                   PARM      *BLANK        W0RTN             7
     C     WURTTY        PARM      WURTTY        WQ0002            5            Retail Transact
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0131S'     W0CLPG
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
     C                   MOVEL     WURTTY        #1DRC1                         Debit Tran. Cod
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SBRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Check Debit/Credit Indicator
      * CASE: WRK.Debit/Credit Indicator is 'D' or blank
     C     WUDCIN        IFEQ      'D'                                          *IF
     C     WUDCIN        OREQ      *BLANK
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1DRC1        ZA0005                         Debit Tran. Cod
      * Send message 'Debit tran cannot have C'
     C                   MOVEL     'USR2719'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #1DRC1                         Debit Tran. Cod
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1DRC1        WURTTY                         Retail Transact
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SCRVGN
      * Check return code and Debit/Credit indicator
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1DRC1        ZA0006                         Debit Tran. Cod
      * Send message 'Debit tran No.1 not found'
     C                   MOVEL     'USR2720'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Debit Tran. Code No.1 is Valid range
     C     #1DRC1        IFGE      '99500'                                      *IF
     C     #1DRC1        ANDLE     '99799'
      * Check Debit/Credit Indicator
      * CASE: WRK.Debit/Credit Indicator is 'D' or blank
     C     WUDCIN        IFEQ      'D'                                          *IF
     C     WUDCIN        OREQ      *BLANK
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1DRC1        ZA0007                         Debit Tran. Cod
      * Send message 'Debit tran cannot have C'
     C                   MOVEL     'USR2719'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1DRC1        ZA0008                         Debit Tran. Cod
      * Send message 'Dbt tran type 1 invalid'
     C                   MOVEL     'USR2784'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Credit Transaction Code No.1
      * CASE: DTL.Credit Tran. Code No.1 is Entered
     C     #1CRC1        IFNE      *BLANK                                       *IF
     C                   MOVEL     #1CRC1        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        WURTTY                         Retail Transact
      * Select RTS Retail Trans. - Retail Transaction Types  *
     C                   CALL      'SD0131S'                            90      Select RTS Reta
     C                   PARM      *BLANK        W0RTN             7
     C     WURTTY        PARM      WURTTY        WQ0003            5            Retail Transact
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0131S'     W0CLPG
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
     C                   MOVEL     WURTTY        #1CRC1                         Credit Tran. Co
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SDRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Check Debit/Credit Indicator
      * CASE: WRK.Debit/Credit Indicator is 'C' or blank
     C     WUDCIN        IFEQ      'C'                                          *IF
     C     WUDCIN        OREQ      *BLANK
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CRC1        ZA0009                         Credit Tran. Co
      * Send message 'Credit tran cannot have D'
     C                   MOVEL     'USR2721'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #1CRC1                         Credit Tran. Co
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1CRC1        WURTTY                         Retail Transact
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SERVGN
      * Check return code and Debit/Credit indicator
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CRC1        ZA0010                         Credit Tran. Co
      * Send message 'Credit tran No.1 not fond'
     C                   MOVEL     'USR2722'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Credit Tran. Code No.1 is Valid range
     C     #1CRC1        IFGE      '99500'                                      *IF
     C     #1CRC1        ANDLE     '99799'
      * Check Debit/Credit Indicator
      * CASE: WRK.Debit/Credit Indicator is 'C' or blank
     C     WUDCIN        IFEQ      'C'                                          *IF
     C     WUDCIN        OREQ      *BLANK
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CRC1        ZA0011                         Credit Tran. Co
      * Send message 'Credit tran cannot have D'
     C                   MOVEL     'USR2721'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CRC1        ZA0012                         Credit Tran. Co
      * Send message 'CR tran no. 1 is invalid'
     C                   MOVEL     'USR2785'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Debit Transaction Code No.2
      * CASE: DTL.Debit Tran. Code No.2 is Entered
     C     #1DRC2        IFNE      *BLANK                                       *IF
      * CASE: DTL.Debit Tran. Code No.1 is Blank
     C     #1DRC1        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DRC2        ZA0013                         Debit Tran. Cod
      * Send message 'Dbt tran 2 must be blank'
     C                   MOVEL     'USR2800'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1DRC2        WUTQKF                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        WURTTY                         Retail Transact
      * Select RTS Retail Trans. - Retail Transaction Types  *
     C                   CALL      'SD0131S'                            90      Select RTS Reta
     C                   PARM      *BLANK        W0RTN             7
     C     WURTTY        PARM      WURTTY        WQ0004            5            Retail Transact
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0131S'     W0CLPG
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
     C                   MOVEL     WURTTY        #1DRC2                         Debit Tran. Cod
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SFRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Check Debit/Credit Indicator
      * CASE: WRK.Debit/Credit Indicator is 'D' or blank
     C     WUDCIN        IFEQ      'D'                                          *IF
     C     WUDCIN        OREQ      *BLANK
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1DRC2        ZA0014                         Debit Tran. Cod
      * Send message 'Debit trn 2 cannot have C'
     C                   MOVEL     'USR2723'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #1DRC2                         Debit Tran. Cod
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1DRC2        WURTTY                         Retail Transact
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SGRVGN
      * Check return code and Debit/Credit indicator
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1DRC2        ZA0015                         Debit Tran. Cod
      * Send message 'Debit tran No.2 not found'
     C                   MOVEL     'USR2724'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Debit Tran. Code No.2 is Valid range
     C     #1DRC2        IFGE      '99500'                                      *IF
     C     #1DRC2        ANDLE     '99799'
      * Check Debit/Credit Indicator
      * CASE: WRK.Debit/Credit Indicator is 'D' or blank
     C     WUDCIN        IFEQ      'D'                                          *IF
     C     WUDCIN        OREQ      *BLANK
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1DRC2        ZA0016                         Debit Tran. Cod
      * Send message 'Debit trn 2 cannot have C'
     C                   MOVEL     'USR2723'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1DRC2        ZA0017                         Debit Tran. Cod
      * Send message 'Dbt tran no.2 invalid'
     C                   MOVEL     'USR2786'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Credit Transaction Code No.2
      * CASE: DTL.Credit Tran. Code No.2 is Entered
     C     #1CRC2        IFNE      *BLANK                                       *IF
     C                   MOVEL     #1CRC2        WUTQKF                         Test ? in Key F
      * CASE: DTL.Credit Tran. Code No.1 is Blank
     C     #1CRC1        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CRC2        ZA0018                         Credit Tran. Co
      * Send message 'Cr trans 2 must be blank'
     C                   MOVEL     'USR2801'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        WURTTY                         Retail Transact
      * Select RTS Retail Trans. - Retail Transaction Types  *
     C                   CALL      'SD0131S'                            90      Select RTS Reta
     C                   PARM      *BLANK        W0RTN             7
     C     WURTTY        PARM      WURTTY        WQ0005            5            Retail Transact
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0131S'     W0CLPG
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
     C                   MOVEL     WURTTY        #1CRC2                         Credit Tran. Co
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SHRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Check Debit/Credit Indicator
      * CASE: WRK.Debit/Credit Indicator is 'C' or blank
     C     WUDCIN        IFEQ      'C'                                          *IF
     C     WUDCIN        OREQ      *BLANK
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CRC2        ZA0019                         Credit Tran. Co
      * Send message 'Crdt tran 2 cannot have D'
     C                   MOVEL     'USR2725'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #1CRC2                         Credit Tran. Co
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1CRC2        WURTTY                         Retail Transact
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SIRVGN
      * Check return code and Debit/Credit indicator
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CRC2        ZA0020                         Credit Tran. Co
      * Send message 'Credit tran no.2 not fond'
     C                   MOVEL     'USR2726'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Credit Tran. Code No.2 is Valid range
     C     #1CRC2        IFGE      '99500'                                      *IF
     C     #1CRC2        ANDLE     '99799'
      * Check Debit/Credit Indicator
      * CASE: WRK.Debit/Credit Indicator is 'C' or blank
     C     WUDCIN        IFEQ      'C'                                          *IF
     C     WUDCIN        OREQ      *BLANK
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CRC2        ZA0021                         Credit Tran. Co
      * Send message 'Crdt tran 2 cannot have D'
     C                   MOVEL     'USR2725'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CRC2        ZA0022                         Credit Tran. Co
      * Send message 'CR trans no. 2 invalid'
     C                   MOVEL     'USR2787'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Block Debit indicator
      * CASE: DTL.Block Debit Ind is Blank
     C     #DBLDB        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DBLDB        ZA0023                         Block Debit Ind
      * Send message 'Block Debit Ind is req'
     C                   MOVEL     'USR2727'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Block Debit Ind is Valid value
     C     #DBLDB        IFEQ      'N'                                          *IF
     C     #DBLDB        OREQ      'Y'
     C     #DBLDB        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DBLDB        ZA0024                         Block Debit Ind
      * Send message 'Block Debit ind invalid'
     C                   MOVEL     'USR2733'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Stopped Cheque indicator
      * CASE: DTL.Stopped Cheque Ind is Blank
     C     #DSTCQ        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DSTCQ        ZA0025                         Stopped Cheque
      * Send message 'Stopped Cheque Ind is req'
     C                   MOVEL     'USR2728'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Stopped Cheque Ind is Valid value
     C     #DSTCQ        IFEQ      'N'                                          *IF
     C     #DSTCQ        OREQ      'Y'
     C     #DSTCQ        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DSTCQ        ZA0026                         Stopped Cheque
      * Send message 'Stopped cheque invalid'
     C                   MOVEL     'USR2734'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Block credit indicator
      * CASE: DTL.Block Credit Ind is Blank
     C     #DBLCR        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DBLCR        ZA0027                         Block Credit In
      * Send message 'Block Credit Ind is req'
     C                   MOVEL     'USR2729'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Block Credit Ind is Valid value
     C     #DBLCR        IFEQ      'N'                                          *IF
     C     #DBLCR        OREQ      'Y'
     C     #DBLCR        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DBLCR        ZA0028                         Block Credit In
      * Send message 'Block Credit invalid'
     C                   MOVEL     'USR2735'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Cheque out of range
      * CASE: DTL.Cheque Out of Range Ind is Blank
     C     #DCQOR        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DCQOR        ZA0029                         Cheque Out of R
      * Send message 'Cheqe out of rnge ind req'
     C                   MOVEL     'USR2730'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Cheque Out of Range Ind is Valid value
     C     #DCQOR        IFEQ      'N'                                          *IF
     C     #DCQOR        OREQ      'Y'
     C     #DCQOR        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DCQOR        ZA0030                         Cheque Out of R
      * Send message 'Chqe out of range invalid'
     C                   MOVEL     'USR2736'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Refer Debit
      * CASE: DTL.Refer Debit Ind is Blank
     C     #DRFDR        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DRFDR        ZA0031                         Refer Debit Ind
      * Send message 'Refer Debit ind is req'
     C                   MOVEL     'USR2731'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Refer Debit Ind is Valid value
     C     #DRFDR        IFEQ      'N'                                          *IF
     C     #DRFDR        OREQ      'Y'
     C     #DRFDR        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DRFDR        ZA0032                         Refer Debit Ind
      * Send message 'Refer debit invalid'
     C                   MOVEL     'USR2737'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Cheque Presentered
      * CASE: DTL.Cheque Presented Ind is Blank
     C     #DCQPR        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DCQPR        ZA0033                         Cheque Presente
      * Send message 'Cheqe presentd ind is req'
     C                   MOVEL     'USR2732'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Cheque Presented Ind is Valid value
     C     #DCQPR        IFEQ      'N'                                          *IF
     C     #DCQPR        OREQ      'Y'
     C     #DCQPR        OREQ      'X'
      * Cheques Presented & Cheques Out of Range.
      * CASE:
      *  - c1 AND c2
      *   |- c1    : DTL.Cheque Presented Ind is Yes
      *   |- c2    : DTL.Cheque Out of Range Ind is No
      *   '-
     C                   MOVEL     '0'           Y0CX01            1
     C     #DCQPR        IFEQ      'Y'                                          *IF
     C     #DCQOR        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DCQPR        ZA0034                         Cheque Presente
      * Send message 'Chqe prsntd cannot be 'Y''
     C                   MOVEL     'USR2767'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DCQPR        ZA0035                         Cheque Presente
      * Send message 'Cheqe Presented invalid'
     C                   MOVEL     'USR2738'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Refer Credit
      * CASE: DTL.Refer Credit Ind is Blank
     C     #DRFCR        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DRFCR        ZA0036                         Refer Credit In
      * Send message 'Refer credit ind is req'
     C                   MOVEL     'USR2739'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Refer Credit Ind is Valid value
     C     #DRFCR        IFEQ      'N'                                          *IF
     C     #DRFCR        OREQ      'Y'
     C     #DRFCR        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DRFCR        ZA0037                         Refer Credit In
      * Send message 'Refer Credit invalid'
     C                   MOVEL     'USR2740'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Teller Limit
      * CASE: DTL.Teller Limit is Blank
     C     #DTLLM        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DTLLM        ZA0038                         Teller Limit
      * Send message 'Teller limit is req'
     C                   MOVEL     'USR2741'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Teller Limit is Valid value
     C     #DTLLM        IFEQ      'N'                                          *IF
     C     #DTLLM        OREQ      'Y'
     C     #DTLLM        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DTLLM        ZA0039                         Teller Limit
      * Send message 'Teller limit invalid'
     C                   MOVEL     'USR2742'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Inactive Account
      * CASE: DTL.Inactive Account is Blank
     C     #DINAC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DINAC        ZA0040                         Inactive Accoun
      * Send message 'Inactive account is req'
     C                   MOVEL     'USR2743'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Inactive Account is Valid value
     C     #DINAC        IFEQ      'N'                                          *IF
     C     #DINAC        OREQ      'Y'
     C     #DINAC        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DINAC        ZA0041                         Inactive Accoun
      * Send message 'Inactive Account invalid'
     C                   MOVEL     'USR2744'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Exchange Rate
      * CASE: DTL.Exchange Rate Ind is Blank
     C     #DERAT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DERAT        ZA0042                         Exchange Rate I
      * Send message 'Exchange Rate is req'
     C                   MOVEL     'USR2745'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Exchange Rate Ind is Valid value
     C     #DERAT        IFEQ      'N'                                          *IF
     C     #DERAT        OREQ      'Y'
     C     #DERAT        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DERAT        ZA0043                         Exchange Rate I
      * Send message 'Exchange rate invalid'
     C                   MOVEL     'USR2746'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Bankrupt/Liquidation
      * CASE: DTL.Bankrupt/Liqidation Ind is Blank
     C     #DBRLQ        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DBRLQ        ZA0044                         Bankrupt/Liqida
      * Send message 'Bankrupt/Liquid is req'
     C                   MOVEL     'USR2747'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Bankrupt/Liqidation Ind is Valid value
     C     #DBRLQ        IFEQ      'N'                                          *IF
     C     #DBRLQ        OREQ      'Y'
     C     #DBRLQ        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DBRLQ        ZA0045                         Bankrupt/Liqida
      * Send message 'Bankrupt/Liquid invalid'
     C                   MOVEL     'USR2748'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Branch Defferent
      * CASE: DTL.Branch Different Ind is Blank
     C     #DBRDF        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DBRDF        ZA0046                         Branch Differen
      * Send message 'Branch Different is req'
     C                   MOVEL     'USR2749'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9947      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Branch Different Ind is Valid value
     C     #DBRDF        IFEQ      'N'                                          *IF
     C     #DBRDF        OREQ      'Y'
     C     #DBRDF        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DBRDF        ZA0047                         Branch Differen
      * Send message 'Branch different invalid'
     C                   MOVEL     'USR2750'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9947      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Bad Debt
      * CASE: DTL.Bad Debt Ind is Blank
     C     #DBDDT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DBDDT        ZA0048                         Bad Debt Ind
      * Send message 'Bad debt is req'
     C                   MOVEL     'USR2751'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9948      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Bad Debt Ind is Valid value
     C     #DBDDT        IFEQ      'N'                                          *IF
     C     #DBDDT        OREQ      'Y'
     C     #DBDDT        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DBDDT        ZA0049                         Bad Debt Ind
      * Send message 'Bad debt invalid'
     C                   MOVEL     'USR2752'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9948      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Account Closing
      * CASE: DTL.Account Closing Ind is Blank
     C     #DACCL        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DACCL        ZA0050                         Account Closing
      * Send message 'Account closing is req'
     C                   MOVEL     'USR2753'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9949      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Account Closing Ind is Valid value
     C     #DACCL        IFEQ      'N'                                          *IF
     C     #DACCL        OREQ      'Y'
     C     #DACCL        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DACCL        ZA0051                         Account Closing
      * Send message 'Account closing invalid'
     C                   MOVEL     'USR2754'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9949      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Insufficient Fund
      * CASE: DTL.Insufficient Fund Ind is Blank
     C     #DINFD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DINFD        ZA0052                         Insufficient Fu
      * Send message 'Insufficient fund is req'
     C                   MOVEL     'USR2755'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9950      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Insufficient Fund Ind is Valid Value
     C     #DINFD        IFEQ      'N'                                          *IF
     C     #DINFD        OREQ      'Y'
     C     #DINFD        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DINFD        ZA0053                         Insufficient Fu
      * Send message 'Insufficient fund invalid'
     C                   MOVEL     'USR2756'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9950      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Non-working Day
      * CASE: DTL.Non-working Day Ind is Blank
     C     #DNWKD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DNWKD        ZA0054                         Non-working Day
      * Send message 'Non-working Day is req'
     C                   MOVEL     'USR2757'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9951      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Non-working Day Ind is Valid value
     C     #DNWKD        IFEQ      'N'                                          *IF
     C     #DNWKD        OREQ      'Y'
     C     #DNWKD        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DNWKD        ZA0055                         Non-working Day
      * Send message 'Non-working day invalid'
     C                   MOVEL     'USR2758'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9951      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Exceeding OD
      * CASE: DTL.Exceeding OD Ind is Blank
     C     #DEXOD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DEXOD        ZA0056                         Exceeding OD In
      * Send message 'Exceeding OD is req'
     C                   MOVEL     'USR2759'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Exceeding OD Ind is Valid value
     C     #DEXOD        IFEQ      'N'                                          *IF
     C     #DEXOD        OREQ      'Y'
     C     #DEXOD        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DEXOD        ZA0057                         Exceeding OD In
      * Send message 'Exceeding OD invalid'
     C                   MOVEL     'USR2760'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9952      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Invalid Backvaluation
      * CASE: DTL.Invalid Backvaluation Ind is Blank
     C     #DINBV        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DINBV        ZA0058                         Invalid Backval
      * Send message 'Invalid Backvaluation req'
     C                   MOVEL     'USR2761'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Invalid Backvaluation Ind is Valid value
     C     #DINBV        IFEQ      'N'                                          *IF
     C     #DINBV        OREQ      'Y'
     C     #DINBV        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DINBV        ZA0059                         Invalid Backval
      * Send message 'Invalid Backvalu invalid'
     C                   MOVEL     'USR2762'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9953      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Minimum Balance
      * CASE: DTL.Minimum Balance Ind is Blank
     C     #DMNBL        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DMNBL        ZA0060                         Minimum Balance
      * Send message 'Minimum balance is req'
     C                   MOVEL     'USR2763'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Minimum Balance Ind is Valid value
     C     #DMNBL        IFEQ      'N'                                          *IF
     C     #DMNBL        OREQ      'Y'
     C     #DMNBL        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DMNBL        ZA0061                         Minimum Balance
      * Send message 'Minimum balance invalid'
     C                   MOVEL     'USR2764'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9954      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * No Associated GL Code
      * CASE: DTL.No Associated GL Code Ind is Blank
     C     #DNAGL        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DNAGL        ZA0062                         No Associated G
      * Send message 'No assoc Gl code is req'
     C                   MOVEL     'USR2765'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.No Associated GL Code Ind is Valid value
     C     #DNAGL        IFEQ      'N'                                          *IF
     C     #DNAGL        OREQ      'Y'
     C     #DNAGL        OREQ      'X'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DNAGL        ZA0063                         No Associated G
      * Send message 'No assoc gl code invalid'
     C                   MOVEL     'USR2766'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9955      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0681RVSF - RTS function codes file  *
     C*Function Codes Edit      Validate Detail Screen
     C/COPY WNCPYSRC,SD0681RVSF
      * CALC: Detail screen function fields
      * 00/Copy member SD0681RSFF - RTS function codes file  *
     C*Function Codes Edit      Calc Detail Function Flds
     C/COPY WNCPYSRC,SD0681RSFF
      * USER: Validate detail screen relations
      * 00/Copy member SD0681RVSR - RTS function codes file  *
     C*Function Codes Edit      Validate Screen Relns
     C/COPY WNCPYSRC,SD0681RVSR
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
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
      * 00/Copy member SD0681RPCK - RTS function codes file  *
     C*Function Codes Edit      Process Command Keys
     C/COPY WNCPYSRC,SD0681RPCK
      * CASE: DTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
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
      * Create RTS function codes - RTS function codes file  *
     C                   EXSR      SJCRRC
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
      * Delete RTS function codes - RTS function codes file  *
     C                   EXSR      SLDLRC
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
      * Change RTS function codes - RTS function codes file  *
     C                   EXSR      SNCHRC
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
     C     P1FNCD        IFEQ      *BLANK                                       Function Code
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
     C                   MOVEL     *BLANK        #1VWIN                         Validate/Warnin
     C                   MOVEL     *BLANK        #1RNNR                         Function Code N
     C                   MOVEL     *BLANK        #1DRC1                         Debit Tran. Cod
     C                   MOVEL     *BLANK        #1CRC1                         Credit Tran. Co
     C                   MOVEL     *BLANK        #1DRC2                         Debit Tran. Cod
     C                   MOVEL     *BLANK        #1CRC2                         Credit Tran. Co
     C                   MOVEL     *BLANK        #DVIND                         Validation Indi
     C                   MOVEL     *BLANK        #DBLDB                         Block Debit Ind
     C                   MOVEL     *BLANK        #DSTCQ                         Stopped Cheque
     C                   MOVEL     *BLANK        #DBLCR                         Block Credit In
     C                   MOVEL     *BLANK        #DCQOR                         Cheque Out of R
     C                   MOVEL     *BLANK        #DRFDR                         Refer Debit Ind
     C                   MOVEL     *BLANK        #DCQPR                         Cheque Presente
     C                   MOVEL     *BLANK        #DRFCR                         Refer Credit In
     C                   MOVEL     *BLANK        #DTLLM                         Teller Limit
     C                   MOVEL     *BLANK        #DINAC                         Inactive Accoun
     C                   MOVEL     *BLANK        #DERAT                         Exchange Rate I
     C                   MOVEL     *BLANK        #DBRLQ                         Bankrupt/Liqida
     C                   MOVEL     *BLANK        #DBRDF                         Branch Differen
     C                   MOVEL     *BLANK        #DBDDT                         Bad Debt Ind
     C                   MOVEL     *BLANK        #DACCL                         Account Closing
     C                   MOVEL     *BLANK        #DINFD                         Insufficient Fu
     C                   MOVEL     *BLANK        #DNWKD                         Non-working Day
     C                   MOVEL     *BLANK        #DEXOD                         Exceeding OD In
     C                   MOVEL     *BLANK        #DINBV                         Invalid Backval
     C                   MOVEL     *BLANK        #DMNBL                         Minimum Balance
     C                   MOVEL     *BLANK        #DNAGL                         No Associated G
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @FNCDL1 fields to screen
      *================================================================
     C                   Z-ADD     FQLCD         #1LCD                          Last Change Dat
     C                   MOVEL     FQTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     FQVWIN        #1VWIN                         Validate/Warnin
     C                   MOVEL     FQFNCD        #1FNCD                         Function Code
     C                   MOVEL     FQRNNR        #1RNNR                         Function Code N
     C                   MOVEL     FQDRC1        #1DRC1                         Debit Tran. Cod
     C                   MOVEL     FQCRC1        #1CRC1                         Credit Tran. Co
     C                   MOVEL     FQDRC2        #1DRC2                         Debit Tran. Cod
     C                   MOVEL     FQCRC2        #1CRC2                         Credit Tran. Co
      * Hold existing record image
     C                   eval      @1DBRC = SDFNCD                                          MD058085
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1FNCD        #1FNCD                         Function Code
      * USER: Initialize key screen
      * SD0681R KEY screen footer - RTS function codes file  *
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
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
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
     C*
      * 00/Copy member SD0681RIKS - RTS function codes file  *
     C*Function Codes Edit      Initialise Key Screen
     C/COPY WNCPYSRC,SD0681RIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Check for Duplicate - RTS function codes file  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    FQFNCD                         Function Code
      * Move fields to key list
     C                   MOVEL     #1FNCD        FQFNCD                         Function Code
     C*****KRSSA         CHAIN     @FNCDL1                            90        *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDFNCD                                                                        MD058085
     C+ from SDFNCJW0                                                                       MD058085
     C+ where FQFNCD = :FQFNCD                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       90                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR2683'     W0RTN             7
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
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     WURTTY        A1RTTY                         Retail Transact
     C     KRSSB         CHAIN     @A1RECX                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     A1DCIN        WUDCIN                         Debit/Credit In
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSC         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     WURTTY        A1RTTY                         Retail Transact
     C     KRSSC         CHAIN     @A1RECX                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     A1DCIN        WUDCIN                         Debit/Credit In
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSD         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     WURTTY        A1RTTY                         Retail Transact
     C     KRSSD         CHAIN     @A1RECX                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     A1DCIN        WUDCIN                         Debit/Credit In
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SERVGN        BEGSR
      *================================================================
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSE         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     WURTTY        A1RTTY                         Retail Transact
     C     KRSSE         CHAIN     @A1RECX                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     A1DCIN        WUDCIN                         Debit/Credit In
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFRVGN        BEGSR
      *================================================================
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSF         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     WURTTY        A1RTTY                         Retail Transact
     C     KRSSF         CHAIN     @A1RECX                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     A1DCIN        WUDCIN                         Debit/Credit In
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGRVGN        BEGSR
      *================================================================
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSG         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     WURTTY        A1RTTY                         Retail Transact
     C     KRSSG         CHAIN     @A1RECX                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     A1DCIN        WUDCIN                         Debit/Credit In
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSH         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     WURTTY        A1RTTY                         Retail Transact
     C     KRSSH         CHAIN     @A1RECX                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     A1DCIN        WUDCIN                         Debit/Credit In
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Move fields to key list
     C                   MOVEL     WURTTY        A1RTTY                         Retail Transact
     C     KRSSI         CHAIN     @A1RECX                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0061'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SIEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     A1DCIN        WUDCIN                         Debit/Credit In
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJCRRC        BEGSR
      *================================================================
      * Create RTS function codes - RTS function codes file  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @FNCDL0
     C                   MOVEL     #1FNCD        FQFNCD                         Function Code
     C                   Z-ADD     WURDNB        FQLCD                          Last Change Dat
     C                   MOVEL     'I'           FQTYLC                         Type of Last Ch
     C                   MOVEL     #1RNNR        FQRNNR                         Function Code N
     C                   MOVEL     #1DRC1        FQDRC1                         Debit Tran. Cod
     C                   MOVEL     #1DRC2        FQDRC2                         Debit Tran. Cod
     C                   MOVEL     #1CRC1        FQCRC1                         Credit Tran. Co
     C                   MOVEL     #1CRC2        FQCRC2                         Credit Tran. Co
     C                   MOVEL     WUVWIN        FQVWIN                         Validate/Warnin
      *
      * USER: Processing before Data update
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
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
     C                   GOTO      SJEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SJEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SJEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0681RCBW - RTS function codes file  *
     C*Function Codes Edit      Proc Before Create - WN
     C/COPY WNCPYSRC,SD0681RCBW
     C                   END                                                    *FI
      * 00/Copy member SD0681RCBU - RTS function codes file  *
     C*Function Codes Edit      Processing Before Create
     C/COPY WNCPYSRC,SD0681RCBU
     C     KLCRSJ        KLIST
     C                   KFLD                    FQFNCD                         Function Code
      * Check for duplicate primary key
     C*****KLCRSJ        SETLL     @FNCDL0                                90    *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDFNCD                                                                        MD058085
     C+ from SDFNCJW0                                                                       MD058085
     C+ where FQFNCD = :FQFNCD                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       90                    MD058085
     C                   If        SQLCODE = 0                                              MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR2684'     W0RTN             7
      * Send message 'RTS function codes fil EX'
     C                   MOVEL     'USR2684'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SJEXIT
     C                   END
      *
     C**********         WRITE     @FNCDL0                              91      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDFNCBTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   FQFNCD                                                                            MD058085
     C+  ,FQLCD                                                                             MD058085
     C+  ,FQTYLC                                                                            MD058085
     C+  ,FQRNNR                                                                            MD058085
     C+  ,FQDRC1                                                                            MD058085
     C+  ,FQDRC2                                                                            MD058085
     C+  ,FQCRC1                                                                            MD058085
     C+  ,FQCRC2                                                                            MD058085
     C+  ,FQVWIN                                                                            MD058085
     C+  ,FQMODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :FQFNCD                                                                           MD058085
     C+  ,:FQLCD                                                                            MD058085
     C+  ,:FQTYLC                                                                           MD058085
     C+  ,:FQRNNR                                                                           MD058085
     C+  ,:FQDRC1                                                                           MD058085
     C+  ,:FQDRC2                                                                           MD058085
     C+  ,:FQCRC1                                                                           MD058085
     C+  ,:FQCRC2                                                                           MD058085
     C+  ,:FQVWIN                                                                           MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDFNCXTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   FQFNCD                                                                            MD058085
     C+  ,FQLCD                                                                             MD058085
     C+  ,FQTYLC                                                                            MD058085
     C+  ,FQRNNR                                                                            MD058085
     C+  ,FQDRC1                                                                            MD058085
     C+  ,FQDRC2                                                                            MD058085
     C+  ,FQCRC1                                                                            MD058085
     C+  ,FQCRC2                                                                            MD058085
     C+  ,FQVWIN                                                                            MD058085
     C+  ,FQMODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :FQFNCD                                                                           MD058085
     C+  ,:FQLCD                                                                            MD058085
     C+  ,:FQTYLC                                                                           MD058085
     C+  ,:FQRNNR                                                                           MD058085
     C+  ,:FQDRC1                                                                           MD058085
     C+  ,:FQDRC2                                                                           MD058085
     C+  ,:FQCRC1                                                                           MD058085
     C+  ,:FQCRC2                                                                           MD058085
     C+  ,:FQVWIN                                                                           MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
      *
     C******IN91         IFEQ      '1'                                                      MD058085
     C     SQLCODE       IFNE      0                                                        MD058085
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SKCHRC
      * 00/Copy member SD0681RCAU - RTS function codes file  *
     C*Function Codes Edit      Processing After Create
     C/COPY WNCPYSRC,SD0681RCAU
     C                   END
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDFNCDPD'    AHFLNM                         Filename
      *
     C     KLCHSK        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSK        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SKEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SKEXIT
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
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SKEXIT        ENDSR
      /EJECT
     CSR   SLDLRC        BEGSR
      *================================================================
      * Delete RTS function codes - RTS function codes file  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFEQ      'D'                                          *IF
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
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
     C                   GOTO      SLEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SLEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SLEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0681RDBW - RTS function codes file  *
     C*Function Codes Edit      Proc Before Delete - WN
     C/COPY WNCPYSRC,SD0681RDBW
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   END                                                    *FI
      * 00/Copy member SD0681RDBU - RTS function codes file  *
     C*Function Codes Edit      Processing Before Delete
     C/COPY WNCPYSRC,SD0681RDBU
      * Move key fields to @FNCDL0
     C                   MOVEL     #1FNCD        FQFNCD                         Function Code
      *
     C     KLDLSL        KLIST
     C                   KFLD                    FQFNCD                         Function Code
     C*****KLDLSL        CHAIN     @FNCDL0                            9091      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDFNCD                                                                        MD058085
     C+ from SDFNCJW0                                                                       MD058085
     C+ where FQFNCD = :FQFNCD                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9091                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        91                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SLEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SLEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = SDFNCD                                          MD058085
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****KLDLSL        SETLL     @FNCDL0                            9091      *           MD058085
     C                   GOTO      SLEXIT
     C                   END                                                    FI #1DBRC
      * Do not allow deletion of core record                                                MD058085
     C     FQMODE        IFEQ      'C'                                                      MD058085
     C                   MOVEL     'USR0549'     ZAMSID                                     MD058085
     C                   MOVEL     'USR0549'     W0RTN                                      MD058085
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058085
     C                   EXSR      ZASNMS                                                   MD058085
     C                   GOTO      SLEXIT                                                   MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
      *................................................................
     C**********         DELETE    @FNCDL0                              91      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDFNCBTD                                                                MD058085
     C+ where FQFNCD = :FQFNCD                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDFNCXTD                                                                MD058085
     C+ where FQFNCD = :FQFNCD                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C******IN91         IFEQ      '1'                                                      MD058085
     C     SQLCODE       IFNE      0                                                        MD058085
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDFNCDPD'    PAFNME                         File name
     C                   MOVEL     #1FNCD        PALKEY                         Long Key
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
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SMCHRC
      * 00/Copy member SD0681RDAU - RTS function codes file  *
     C*Function Codes Edit      Processing After Delete
     C/COPY WNCPYSRC,SD0681RDAU
     C                   END
      *================================================================
     CSR   SLEXIT        ENDSR
      /EJECT
     CSR   SMCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDFNCDPD'    AHFLNM                         Filename
      *
     C     KLCHSM        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSM        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SMEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SMEXIT
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
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SMEXIT        ENDSR
      /EJECT
     CSR   SNCHRC        BEGSR
      *================================================================
      * Change RTS function codes - RTS function codes file  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to @FNCDL0
     C                   MOVEL     #1FNCD        FQFNCD                         Function Code
      *
     C     KLCHSN        KLIST
     C                   KFLD                    FQFNCD                         Function Code
     C*****KLCHSN        CHAIN     @FNCDL0                            9091      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDFNCD                                                                        MD058085
     C+ from SDFNCJW0                                                                       MD058085
     C+ where FQFNCD = :FQFNCD                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9091                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        91                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SNEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SNEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = SDFNCD                                          MD058085
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C**********         UNLOCK    SDFNCDL0                             91      *           MD058085
     C                   GOTO      SNEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to @FNCDL0
     C                   Z-ADD     WURDNB        FQLCD                          Last Change Dat
     C                   MOVEL     'A'           FQTYLC                         Type of Last Ch
     C                   MOVEL     #1RNNR        FQRNNR                         Function Code N
     C                   MOVEL     #1DRC1        FQDRC1                         Debit Tran. Cod
     C                   MOVEL     #1DRC2        FQDRC2                         Debit Tran. Cod
     C                   MOVEL     #1CRC1        FQCRC1                         Credit Tran. Co
     C                   MOVEL     #1CRC2        FQCRC2                         Credit Tran. Co
     C                   MOVEL     WUVWIN        FQVWIN                         Validate/Warnin
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * USER: Processing before Data update
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'A'           UACTCD            1            Action  S01212 S0122
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
     C                   GOTO      SNEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SNEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SNEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0681RBUW - RTS function codes file  *
     C*Function Codes Edit      Before Update, Window on
     C/COPY WNCPYSRC,SD0681RBUW
     C                   END                                                    *FI
      * 00/Copy member SD0681RBDU - RTS function codes file  *
     C*Function Codes Edit      Processing Before Update
     C/COPY WNCPYSRC,SD0681RBDU
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C**********         UPDATE    @FNCDL0                              91      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ update SDFNCXTD set                                                                 MD058085
     C+   FQLCD  = :FQLCD                                                                   MD058085
     C+  ,FQTYLC = :FQTYLC                                                                  MD058085
     C+  ,FQRNNR = :FQRNNR                                                                  MD058085
     C+  ,FQDRC1 = :FQDRC1                                                                  MD058085
     C+  ,FQDRC2 = :FQDRC2                                                                  MD058085
     C+  ,FQCRC1 = :FQCRC1                                                                  MD058085
     C+  ,FQCRC2 = :FQCRC2                                                                  MD058085
     C+  ,FQVWIN = :FQVWIN                                                                  MD058085
     C+ where FQFNCD = :FQFNCD                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       91                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        91                    MD058085
     C                   ENDIF                                                              MD058085
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFNCDL0                             91      *           MD058085
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SOCHRC
      * 00/Copy member SD0681RADU - RTS function codes file  *
     C*Function Codes Edit      Processing After Update
     C/COPY WNCPYSRC,SD0681RADU
     C                   END
      *================================================================
     CSR   SNEXIT        ENDSR
      /EJECT
     CSR   SOCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDFNCDPD'    AHFLNM                         Filename
      *
     C     KLCHSO        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSO        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SOEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SOEXIT
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
     C                   UPDATE    @AHREAU                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDFCTLL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SOEXIT        ENDSR
      /EJECT
     CSR   SPRVGN        BEGSR
      *================================================================
      * Get all Midas Modules - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSP         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSP         CHAIN     @BGREC8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0064                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SPEXIT                                       *QUIT
     C                   GOTO      SPEXIT
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
     CSR   SPEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1FNCD        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Function Code
     C                   CALL      'SD0680S'                            90      Select RTS Func
     C                   PARM      *BLANK        W0RTN             7
     C     #1FNCD        PARM      #1FNCD        WQ0001            3            Function Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0680S'     W0CLPG
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
      * 00/Copy member SD0681REPP - RTS function codes file  *
     C*Function Codes Edit      Exit Program Processing
     C/COPY WNCPYSRC,SD0681REPP
      * Fast Exit processing
      * CASE: KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
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
      * Define work field Validate/Warning Ind.
     C                   MOVEL     *BLANK        WUVWIN           25
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field Retail Transaction Type
     C                   MOVEL     *BLANK        WURTTY            5
      * Define work field Debit/Credit Indicator
     C                   MOVEL     *BLANK        WUDCIN            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
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
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
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
      * Define work field Retail Banking
     C                   MOVEL     *BLANK        WURTBN            1
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
      * Define work field Portfolio Management
     C                   MOVEL     *BLANK        WUPFMG            1
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
      * Define work field Retail 3
     C                   MOVEL     *BLANK        WUNXST            1
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
     C                   OPEN      SD0681R#
     C**********         OPEN      SDFNCDL1                                                 MD058085
     C                   OPEN      SDRETRL1
     C                   OPEN      SDMMODL1
     C**********         OPEN      SDFNCDL0                                                 MD058085
     C                   OPEN      SDFCTLL0
      * Dummy move for compiler
     C                   MOVE      '0'           @CN#(1)
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD0681R precompiler - RTS function codes file  *
      * Copyright Statement 1995 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Get all Midas Modules - MIDAS Modules  *
     C                   EXSR      SPRVGN
      * File Data DS - RTS function codes file  *
      * Override Indicators DS - RTS function codes file  *
      * Program mode processing
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
      * 00/Copy member SD0681RFPG - RTS function codes file  *
      * 00/Copy member SD0681REPG - RTS function codes file  *
      * 00/Copy member SD0681RIPG - RTS function codes file  *
      * 00/Copy member SD0681RCPG - RTS function codes file  *
     C*Function Codes Edit      Initialise Program C-spec
     C/COPY WNCPYSRC,SD0681RCPG
      * 00/Copy member SD0681ROPG - RTS function codes file  *
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
     C/COPY WNCPYSRC,SD0681RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0681RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058085
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058085
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0681RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*Function Codes Edit      Initialise Program O-spec
     O/COPY WNCPYSRC,SD0681ROPG
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA @CN#
00001 NNNNNNNNNNNNNNNNNNNN
