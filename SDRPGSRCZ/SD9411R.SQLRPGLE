     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Cashier interface ICD maintenance subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD9411R - Midas SD Cashier Interface ICD Maintenance         *
      *                                                               *
      *  Function:  This program allows the user to maintain details  *
      *             on the cashier interface ICD                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD058085           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CRT005             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT003             Date 26Sep96               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRT005 - Cashier Enhancement for Cash In/Cash Out            *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  CRT003 - Cashier Interface.                                  *
      *           Creation of new function.                           *
      *                                                               *
      *****************************************************************
     F*Edit Cashier Intrface ICDInitialise Program F-spec
     F/COPY WNCPYSRC,SD9411RFPG
     FSD9411R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Cashier interface ICD maintenance subfile
      *
     FSDBAIIL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : BAI ICD                  ce ICD Retrieval index
      *
     F*SDBAIPL1* IF   E           K DISK    USROPN                                          MD058085
     F**********                           INFDS(ID0001)                                    MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * RTV : BAI Products & Comms      Retrieval index
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     FSDBAIIL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      * UPD : BAI ICD                   Update index
      *
     F*SDFCTLL0* UF   E           K DISK    USROPN                                          MD061007
     F**********                           COMMIT                                           MD061007
     F**********                           INFDS(ID0004)                                    MD061007
     F**********                           INFSR(*PSSR)                                     MD061007
      * UPD : Midas SD Standing data controls update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*Edit Cashier Intrface ICDInitialise Program E-spec
     D/COPY WNCPYSRC,SD9411REPG
      * Screen one error indicator store
      * Screen two error indicator store
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*COPY*QWINDSRC,SD9411GDTA                                           S01229            MD058085
     D/COPY QWINDSRC,SD9411GDTL                                                             MD058085
     D*Edit Cashier Intrface ICDInitialise Program I-spec
     D/COPY WNCPYSRC,SD9411RIPG
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
     D @1DBRC        E DS                  EXTNAME(SDBAIIL0)
      * UPD : BAI ICD                   Update index
      * Current/previous master file format fields for change control
     D SDBAIP        E DS                  EXTNAME(SDBAPJW0)                                MD058085
      *
     D**********#1DBRC      DS                            264                                 CRT005
     D***#1DBRC*     DS                            312                                 CRT005 CGL029
     D #1DBRC          DS          9999
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D @@I1            DS
      * Screen one error indicator store
     D  @I1                    1    100
     D                                     DIM(100)
     D  INSCR1                31     44
     D @@I2            DS
      * Screen two error indicator store
     D  @I2                    1    100
     D                                     DIM(100)
     D**********                             31  39 INSCR2                                    CRT005
     D  INSCR2                31     44
     D**********YARDCS      DS                            264                                 CRT005
     D***YARDCS*     DS                            312                                 CRT005 CGL029
     D YARDCS          DS          9999
     D*QSDFC1***     E DS                  EXTNAME(SDFCTLL0)                                MD061007
     D QSDFC1          DS                                                                   MD061007
     D  AHFLNM                 1     10                                                     MD061007
     D  AHNORC                11     13P 0                                                  MD061007
     D  AHNOIN                14     16P 0                                                  MD061007
     D  AHNOAM                17     19P 0                                                  MD061007
     D  AHNODL                20     22P 0                                                  MD061007
      * UPD : Midas SD Standing data controls update
     D YBRDCS          DS            22
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
     D P1PARM          DS            10
      * KEY: BAI ICD                  ce ICD Retrieval index
      * I : RST BAI ICD Record
     D  P1BAII                 1     10
     D P2PARM          DS
      * O : MAP *Return code
     D  P2RTN                  1      7
     D P3PARM          DS
      * B : MAP Work Return code
     D  P3WRTC                 1      5
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Retail Bankng Hall Pd REQ'
      * Retail Banking Hall Prod
     D  ZA0001                 1     10
      * Message data for 'Rtl Bkg Hll prd/ComPrt NF'
      * Retail Banking Hall Prod
     D  ZA0002                 1     10
      * Communications Protocol
     D  ZA0003                11     20
      * Message data for 'Communicatns Protocol REQ'
      * Communications Protocol
     D  ZA0004                 1     10
      * Message data for 'Rtl Bkg Hll prd/ComPrt NF'
      * Retail Banking Hall Prod
     D  ZA0005                 1     10
      * Communications Protocol
     D  ZA0006                11     20
      * Message data for 'Strt CI at I/C Init   INV'
      * Start BAI at I/C Init
     D  ZA0007                 1      1
      * Message data for 'Job Descrption to Use REQ'
      * Job Description to use
     D  ZA0008                 1     10
      * Message data for 'Job Descrption to Use INV'
      * Job Description to use
     D  ZA0009                 1     10
      * Message data for 'Job Queue to Use      REQ'
      * Job Queue to use
     D  ZA0010                 1     10
      * Message data for 'Job Queue to Use      INV'
      * Job Queue to use
     D  ZA0011                 1     10
      * Message data for 'Class to Use          REQ'
      * Class to use
     D  ZA0012                 1     10
      * Message data for 'Class to Use          INV'
      * Class to use
     D  ZA0013                 1     10
      * Message data for 'Retail A/c Balnce Enq INV'
      * Retail A/c Balance Enq
     D  ZA0014                 1      1
      * Message data for 'Retail A/c Transfer   INV'
      * Retail A/c Transfer
     D  ZA0015                 1      1
      * Message data for 'Cash Dep in A/c Ccy   INV'
      * Cash Dep in A/c Currency
     D  ZA0016                 1      1
      * Message data for 'Chq Dep in A/c Ccy    INV'
      * Chq Dep in A/c Currency
     D  ZA0017                 1      1
      * Message data for 'Cash Dep Non A/c Ccy  INV'
      * Cash Dep in Non A/c Ccy
     D  ZA0018                 1      1
      * Message data for 'Chq Dep in Non A/c CcyINV'
      * Chq Dep in Non A/c Ccy
     D  ZA0019                 1      1
      * Message data for 'Cash Wdl in A/c Ccy   INV'
      * Cash Wdl in A/c Currency
     D  ZA0020                 1      1
      * Message data for 'Chq Wdl in A/c Ccy    INV'
      * Chq Wdl in A/c Currency
     D  ZA0021                 1      1
      * Message data for 'Cash Wdl Non A/c Ccy  INV'
      * Cash Wdl in Non A/c Ccy
     D  ZA0022                 1      1
      * Message data for 'Chq Wdl in Non A/c CcyINV'
      * Chq Wdl in Non A/c Ccy
     D  ZA0023                 1      1
      * Message data for 'Bureau de Change TransINV'
      * Bureau De Change Txn
     D  ZA0024                 1      1
      * Message data for 'Buy Traveller's Chqs  INV'
      * Buy Traveller's Cheques
     D  ZA0025                 1      1
      * Message data for 'Sell Traveller's Chqs INV'
      * Sell Traveller's Cheques
     D  ZA0026                 1      1
      * Message data for 'Transaction Reversals INV'
      * Transaction Reversals
     D  ZA0027                 1      1
      * Message data for 'Passbook Update       INV'
      * Passbook Update
     D  ZA0028                 1      1
      * Message data for 'Passbook Name & Addr  INV'
      * Passbook Name & Address
     D  ZA0029                 1      1
      * Message data for 'Draft Issue           INV'
      * Draft Issue
     D  ZA0030                 1      1
      * Message data for 'Teller Cross In Invalid  '                                          CRT005
      * Teller Cross In                                                                       CRT005
     D  ZA0031                 1      1
      * Message data for 'Teller Cross Out Invalid '                                          CRT005
      * Teller Cross Out                                                                      CRT005
     D  ZA0032                 1      1
      * Message data for 'Teller Treasury In Invalid'                                         CRT005
      * Teller Treasury In                                                                    CRT005
     D  ZA0033                 1      1
      * Message data for 'Teller Treasury out Invalid'                                        CRT005
      * Teller Treasury Out                                                                   CRT005
     D  ZA0034                 1      1
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for Account codes                                                        CRT005
      *                                                                                       CRT005
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACD1       E                     EXTFLD(QQACCD)
      **  Data structure for General Ledger Details file                                      CRT005
      *                                                                                       CRT005
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for Switchable Features                                                  CRT005
      *                                                                                       CRT005
     D LDA           E DS           256    EXTNAME(LDA)
     D  SPARF        E                     EXTFLD(SPARE)
      ** Local data area for database error details                                           CRT005
      *                                                                                       CRT005
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, Short data structure                                  CRT005
      *                                                                                       CRT005
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, Long data structure                                   CRT005
      *                                                                                       CRT005
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY: BAI ICD
     C     P2RTN         PARM      P2RTN         WP0001            7            *Return code
     C     P3WRTC        PARM      P3WRTC        WP0002            5            Work Return cod
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
      * Set control to display first screen
     C                   Z-ADD     1             W0SCR             3 0
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1BAII        IFEQ      *BLANK                                       BAI ICD Record
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
      * Update screen time
     C                   TIME                    ##TME
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
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
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
     C                   KFLD                    FUBAII                         BAI ICD Record
      * Setup key
     C                   MOVEL     #1BAII        FUBAII                         BAI ICD Record
     C     KRTV          CHAIN     @BAIIL1                            9091      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9931      *
      * Send message 'BAI ICD               NF'
     C                   MOVEL     'USR2890'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * 00/Copy Member SD9411RSFF - BAI ICD  *
     C*Edit Cashier Intrface ICDCalc Detail Function Flds
     C/COPY WNCPYSRC,SD9411RSFF
      * USER: Initialize detail screen (existing record)
     C                   MOVEL     FUBALP        #1BALP                         Retail A/c Bal
     C                   MOVEL     FUTFRP        #1TFRP                         Retail A/c Tran
     C                   MOVEL     FUCDAP        #1CDAP                         Cash Dep In A/c
     C                   MOVEL     FUCQDP        #1CQDP                         Chq Dep In A/c
     C                   MOVEL     FUCDNP        #1CDNP                         Cash Dep Non A/
     C                   MOVEL     FUCQNP        #1CQNP                         Chq Dep Non A/c
     C                   MOVEL     FUCWAP        #1CWAP                         Cash Wdl In A/c
     C                   MOVEL     FUCWNP        #1CWNP                         Cash Wdl Non A/
     C                   MOVEL     FUCQWP        #1CQWP                         Chq Wdl In A/c
     C                   MOVEL     FUCQWQ        #1CQWQ                         Chq Wdl Non A/c
      * 00/Copy Member SD9411RISE - BAI ICD  *
     C*Edit Cashier Intrface ICDInitialise Dtl Exist Rcd
     C/COPY WNCPYSRC,SD9411RISE
     C                   END
      *
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
      * Select existing record
     C                   EXSR      VACKRL
      * USER: Validate key screen
      * 00/Copy Member SD9411RVKS - BAI ICD  *
     C*Edit Cashier Intrface ICDValidate Key Screen
     C/COPY WNCPYSRC,SD9411RVKS
      * BAI ICD Record required
     C     #1BAII        IFEQ      *BLANK                                       IF
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
     C     W0HLP         DOUEQ     'N'
     C     W0ROL         ANDEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
      * Update screen time
     C                   TIME                    ##TME
     C     W0SCR         IFEQ      1
      * Set error
     C                   MOVEA     INSCR1        *IN(31)
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Test cursor
     C                   EXSR      Y8TST
     C                   ELSE
     C     W0SCR         IFEQ      2
      * Set error
     C                   MOVEA     INSCR2        *IN(31)
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y2SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT3
     C                   EXFMT     #RCDDTL2
      * Test cursor
     C                   EXSR      Y8TST
     C                   END
     C                   END
      * Reset roll flag
     C                   MOVEL     'N'           W0ROL             1
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
      * Show next page of details
     C   27              EXSR      CDNXSC
      * Show previous page of details
     C   28              EXSR      CEPVSC
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
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
      * 00/Copy Member SD9411RPKR - BAI ICD  *
     C*Edit Cashier Intrface ICDProcess Key Screen Rqst
     C/COPY WNCPYSRC,SD9411RPKR
      * Bypass Key screen if F12 is taken at Detail screen
     C                   MOVEL     *BLANK        P3WRTC                         Work Return cod
     C                   MOVEL     'PREV'        P3WRTC                         Work Return cod
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'K'           W0TRN
      * Initialise error memories
     C                   MOVE      *ZERO         INSCR1
     C                   MOVE      *ZERO         INSCR2
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CDNXSC        BEGSR
      *================================================================
      * Display next screen
      *================================================================
      * Set roll flag
     C                   MOVEL     'Y'           W0ROL             1
     C                   Z-ADD     2             W0SCR
      *================================================================
     CSR   CDEXIT        ENDSR
      /EJECT
     CSR   CEPVSC        BEGSR
      *================================================================
      * Display previous screen
      *================================================================
      * Set roll flag
     C                   MOVEL     'Y'           W0ROL             1
     C                   Z-ADD     1             W0SCR
      *================================================================
     CSR   CEEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Validate details
     C                   MOVE      *ZEROS        INSCR1
     C                   MOVE      *ZEROS        INSCR2
     C                   EXSR      DCVLDL
      * Display first screen in error
     C     INSCR1        IFNE      *ZERO
     C                   Z-ADD     1             W0SCR
     C                   ELSE
     C     INSCR2        IFNE      *ZERO
     C                   Z-ADD     2             W0SCR
     C                   END
     C                   END
      * QUIT if error:
     C     *IN99         CABEQ     '1'           CFEXIT
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
      * Validate Start BAI at I/C Init
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1INIT        W0NSRQ            1            Start BAI at I/
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199818       Y2LSNO            7 0
     C     #1INIT        PARM      #1INIT        W0EXVL           20            Start BAI at I/
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(33)
     C                   SETON                                        99        *
     C                   END
      * Validate Retail A/c Balance Enq
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1BALE        W0NSRQ            1            Retail A/c Bala
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199822       Y2LSNO            7 0
     C     #1BALE        PARM      #1BALE        W0EXVL           20            Retail A/c Bala
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(37)
     C                   SETON                                        99        *
     C                   END
      * Validate Retail A/c Transfer
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1RTFR        W0NSRQ            1            Retail A/c Tran
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199826       Y2LSNO            7 0
     C     #1RTFR        PARM      #1RTFR        W0EXVL           20            Retail A/c Tran
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(38)
     C                   SETON                                        99        *
     C                   END
      * Validate Cash Dep in A/c Currency
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CDAC        W0NSRQ            1            Cash Dep in A/c
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199830       Y2LSNO            7 0
     C     #1CDAC        PARM      #1CDAC        W0EXVL           20            Cash Dep in A/c
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(39)
     C                   SETON                                        99        *
     C                   END
      * Validate Chq Dep in A/c Currency
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CQDA        W0NSRQ            1            Chq Dep in A/c
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199834       Y2LSNO            7 0
     C     #1CQDA        PARM      #1CQDA        W0EXVL           20            Chq Dep in A/c
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(40)
     C                   SETON                                        99        *
     C                   END
      * Validate Cash Dep in Non A/c Ccy
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CDNC        W0NSRQ            1            Cash Dep in Non
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199838       Y2LSNO            7 0
     C     #1CDNC        PARM      #1CDNC        W0EXVL           20            Cash Dep in Non
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(41)
     C                   SETON                                        99        *
     C                   END
      * Validate Chq Dep in Non A/c Ccy
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CQNA        W0NSRQ            1            Chq Dep in Non
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199842       Y2LSNO            7 0
     C     #1CQNA        PARM      #1CQNA        W0EXVL           20            Chq Dep in Non
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(42)
     C                   SETON                                        99        *
     C                   END
      * Validate Cash Wdl in A/c Currency
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CWAC        W0NSRQ            1            Cash Wdl in A/c
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199846       Y2LSNO            7 0
     C     #1CWAC        PARM      #1CWAC        W0EXVL           20            Cash Wdl in A/c
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(43)
     C                   SETON                                        99        *
     C                   END
      * Validate Chq Wdl in A/c Currency
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CQWA        W0NSRQ            1            Chq Wdl in A/c
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199854       Y2LSNO            7 0
     C     #1CQWA        PARM      #1CQWA        W0EXVL           20            Chq Wdl in A/c
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(44)
     C                   SETON                                        99        *
     C                   END
      * Validate Cash Wdl in Non A/c Ccy
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CWNA        W0NSRQ            1            Cash Wdl in Non
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199850       Y2LSNO            7 0
     C     #1CWNA        PARM      #1CWNA        W0EXVL           20            Cash Wdl in Non
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(31)
     C                   SETON                                        99        *
     C                   END
      * Validate Chq Wdl in Non A/c Ccy
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CQWN        W0NSRQ            1            Chq Wdl in Non
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199858       Y2LSNO            7 0
     C     #1CQWN        PARM      #1CQWN        W0EXVL           20            Chq Wdl in Non
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(32)
     C                   SETON                                        99        *
     C                   END
      * Validate Bureau De Change Txn
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1BDCT        W0NSRQ            1            Bureau De Chang
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199862       Y2LSNO            7 0
     C     #1BDCT        PARM      #1BDCT        W0EXVL           20            Bureau De Chang
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(33)
     C                   SETON                                        99        *
     C                   END
      * Validate Buy Traveller's Cheques
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1BTC         W0NSRQ            1            Buy Traveller's
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199866       Y2LSNO            7 0
     C     #1BTC         PARM      #1BTC         W0EXVL           20            Buy Traveller's
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(34)
     C                   SETON                                        99        *
     C                   END
      * Validate Sell Traveller's Cheques
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1STC         W0NSRQ            1            Sell Traveller'
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199870       Y2LSNO            7 0
     C     #1STC         PARM      #1STC         W0EXVL           20            Sell Traveller'
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(35)
     C                   SETON                                        99        *
     C                   END
      * Validate Transaction Reversals
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1TXRV        W0NSRQ            1            Transaction Rev
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199874       Y2LSNO            7 0
     C     #1TXRV        PARM      #1TXRV        W0EXVL           20            Transaction Rev
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(36)
     C                   SETON                                        99        *
     C                   END
      * Validate Passbook Update
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1PUPD        W0NSRQ            1            Passbook Update
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199818       Y2LSNO            7 0
     C     #1PUPD        PARM      #1PUPD        W0EXVL           20            Passbook Update
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(37)
     C                   SETON                                        99        *
     C                   END
      * Validate Passbook Name & Address
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1PNAD        W0NSRQ            1            Passbook Name &
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199818       Y2LSNO            7 0
     C     #1PNAD        PARM      #1PNAD        W0EXVL           20            Passbook Name &
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(38)
     C                   SETON                                        99        *
     C                   END
      * Validate Draft Issue
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1DISS        W0NSRQ            1            Draft Issue
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1199818       Y2LSNO            7 0
     C     #1DISS        PARM      #1DISS        W0EXVL           20            Draft Issue
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(39)
     C                   SETON                                        99        *
     C                   END
      *                                                                                       CRT005
     C     CRT005        IFEQ      'Y'
      *                                                                                       CRT005
      ** Validate Teller Cross In                                                             CRT005
      *                                                                                       CRT005
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1TCI         W0NSRQ
      *                                                                                       CRT005
      ** Name search required?                                                                CRT005
      *                                                                                       CRT005
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90
     C                   PARM                    W0RTN
     C                   PARM      1199818       Y2LSNO
     C     #1TCI         PARM      #1TCI         W0EXVL
      *                                                                                       CRT005
      ** Defer confirm                                                                        CRT005
      *                                                                                       CRT005
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CRT005
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(40)
     C                   SETON                                        99
     C                   ENDIF
      *                                                                                       CRT005
      ** Validate Teller Cross Out                                                            CRT005
      *                                                                                       CRT005
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1TCO         W0NSRQ
      *                                                                                       CRT005
      ** Name search required?                                                                CRT005
      *                                                                                       CRT005
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90
     C                   PARM                    W0RTN
     C                   PARM      1199818       Y2LSNO
     C     #1TCO         PARM      #1TCO         W0EXVL
      *                                                                                       CRT005
      ** Defer confirm                                                                        CRT005
      *                                                                                       CRT005
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CRT005
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(41)
     C                   SETON                                        99
     C                   ENDIF
      *                                                                                       CRT005
      ** Validate Teller Treasury In                                                          CRT005
      *                                                                                       CRT005
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1TTI         W0NSRQ
      *                                                                                       CRT005
      ** Name search required?                                                                CRT005
      *                                                                                       CRT005
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90
     C                   PARM                    W0RTN
     C                   PARM      1199818       Y2LSNO
     C     #1TTI         PARM      #1TTI         W0EXVL
      *                                                                                       CRT005
      ** Defer confirm                                                                        CRT005
      *                                                                                       CRT005
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CRT005
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(42)
     C                   SETON                                        99
     C                   ENDIF
      *                                                                                       CRT005
      ** Validate Teller Treasury Out                                                         CRT005
      *                                                                                       CRT005
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1TTO         W0NSRQ
      *                                                                                       CRT005
      ** Name search required?                                                                CRT005
      *                                                                                       CRT005
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90
     C                   PARM                    W0RTN
     C                   PARM      1199818       Y2LSNO
     C     #1TTO         PARM      #1TTO         W0EXVL
      *                                                                                       CRT005
      ** Defer confirm                                                                        CRT005
      *                                                                                       CRT005
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
      *                                                                                       CRT005
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I2(43)
     C                   SETON                                        99
     C                   ENDIF
      *                                                                                       CRT005
     C                   ENDIF
      *                                                                                       CRT005
      * USER: Validate detail screen fields
      * *** 1st Screen ***
      * Retail Banking Hall Product
      * CASE: DTL.Retail Banking Hall Prod is Blank
     C     #1PROD        IFEQ      *BLANK                                       *IF
      * CASE: DTL.Communications Protocol is Blank
     C     #1COMP        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1PROD        ZA0001                         Retail Banking
      * Send message 'Retail Bankng Hall Pd REQ'
     C                   MOVEL     'USR3068'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)                        *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Retail Banking Hall Prod is Question Mark
     C     #1PROD        IFEQ      '?'                                          *IF
      * Selt CI Prd & Cmms fr ICD - BAI Products & Comms  *
     C                   CALL      'SD1230S'                            90      Selt CI Prd & C
     C                   PARM      *BLANK        W0RTN             7
     C     #1PROD        PARM      #1PROD        WQ0002           10            Retail Banking
     C     #1COMP        PARM      #1COMP        WQ0003           10            Communications
     C     #1COMM        PARM      *BLANK        WQ0004           10            Communications
     C     #1CONV        PARM      *ZERO         WQ0005            2 0          No. Convs for C
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD1230S'     W0CLPG
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
     C                   MOVEL     '1'           @I1(31)                        *
     C                   MOVEL     '1'           @I1(32)                        *
     C                   END
      * If a Retail Banking Hall Product is not selected blank out field
      * CASE: DTL.Retail Banking Hall Prod is Question Mark
     C     #1PROD        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        #1PROD                         Retail Banking
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Check CI Prod & Comms - BAI Products & Comms  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1PROD        ZA0002                         Retail Banking
     C                   MOVEL     #1COMP        ZA0003                         Communications
      * Send message 'Rtl Bkg Hll prd/ComPrt NF'
     C                   MOVEL     'USR3069'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)                        *
     C                   MOVEL     '1'           @I1(32)                        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Communications Protocol
      * CASE: DTL.Communications Protocol is Blank
     C     #1COMP        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1COMP        ZA0004                         Communications
      * Send message 'Communicatns Protocol REQ'
     C                   MOVEL     'USR3070'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(32)                        *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: DTL.Communications Protocol is Question Mark
     C     #1COMP        IFEQ      '?'                                          *IF
      * Selt CI Prd & Cmms fr ICD - BAI Products & Comms  *
     C                   CALL      'SD1230S'                            90      Selt CI Prd & C
     C                   PARM      *BLANK        W0RTN             7
     C     #1PROD        PARM      #1PROD        WQ0006           10            Retail Banking
     C     #1COMP        PARM      #1COMP        WQ0007           10            Communications
     C     #1COMM        PARM      *BLANK        WQ0008           10            Communications
     C     #1CONV        PARM      *ZERO         WQ0009            2 0          No. Convs for C
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD1230S'     W0CLPG
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
     C                   MOVEL     '1'           @I1(31)                        *
     C                   MOVEL     '1'           @I1(32)                        *
     C                   END
      * If a Communications Protocol is not selected blank out field
      * CASE: DTL.Communications Protocol is Question Mark
     C     #1COMP        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        #1COMP                         Communications
     C                   END                                                    *FI
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Check CI Prod & Comms - BAI Products & Comms  *
     C                   EXSR      SBRVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1PROD        ZA0005                         Retail Banking
     C                   MOVEL     #1COMP        ZA0006                         Communications
      * Send message 'Rtl Bkg Hll prd/ComPrt NF'
     C                   MOVEL     'USR3069'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)                        *
     C                   MOVEL     '1'           @I1(32)                        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start Cshr Intr at I/C Init
      * CASE: DTL.Start BAI at I/C Init is Valid Values
     C     #1INIT        IFEQ      'N'                                          *IF
     C     #1INIT        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1INIT        ZA0007                         Start BAI at I/
      * Send message 'Strt CI at I/C Init   INV'
     C                   MOVEL     'USR3071'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(33)                        *
      *
     C                   END                                                    *FI
      * Job Description to Use
      * CASE: DTL.Job Description to use is Blank
     C     #1JBDE        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1JBDE        ZA0008                         Job Description
      * Send message 'Job Descrption to Use REQ'
     C                   MOVEL     'USR3082'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(34)                        *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Object SCC0260 - Standard Functions  *
     C                   CALL      'SCC0260'                            90      Check Object SC
     C     WUYVST        PARM      *BLANK        WQ0010            1            Object Found
     C                   PARM      #1JBDE        WQ0011           10            Object Name
     C                   PARM      '*JOBD'       WQ0012           10            Object Type
     C                   PARM      '*NONE'       WQ0013           10            MBR
     C                   PARM      '*NONE'       WQ0014           10            AUT
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SCC0260'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * CASE: WRK.Object Found is No
     C     WUYVST        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1JBDE        ZA0009                         Job Description
      * Send message 'Job Descrption to Use INV'
     C                   MOVEL     'USR3083'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(34)                        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Job Queue to Use
      * CASE: DTL.Job Queue to use is Blank
     C     #1JBQU        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1JBQU        ZA0010                         Job Queue to us
      * Send message 'Job Queue to Use      REQ'
     C                   MOVEL     'USR3084'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(35)                        *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Object - Standard Functions  *
     C                   CALL      'SCC0260'                            90      Check Object SC
     C     WUYVST        PARM      *BLANK        WQ0015            1            Object Found
     C                   PARM      #1JBQU        WQ0016           10            Object Name
     C                   PARM      '*JOBQ'       WQ0017           10            Object Type
     C                   PARM      '*NONE'       WQ0018           10            MBR
     C                   PARM      '*NONE'       WQ0019           10            AUT
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SCC0260'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * CASE: WRK.Object Found is No
     C     WUYVST        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1JBQU        ZA0011                         Job Queue to us
      * Send message 'Job Queue to Use      INV'
     C                   MOVEL     'USR3085'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(35)                        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Class to Use
      * CASE: DTL.Class to use is Blank
     C     #1CLSS        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CLSS        ZA0012                         Class to use
      * Send message 'Class to Use          REQ'
     C                   MOVEL     'USR3086'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(36)                        *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Object - Standard Functions  *
     C                   CALL      'SCC0260'                            90      Check Object SC
     C     WUYVST        PARM      *BLANK        WQ0020            1            Object Found
     C                   PARM      #1CLSS        WQ0021           10            Object Name
     C                   PARM      '*CLS'        WQ0022           10            Object Type
     C                   PARM      '*NONE'       WQ0023           10            MBR
     C                   PARM      '*NONE'       WQ0024           10            AUT
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SCC0260'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * CASE: WRK.Object Found is No
     C     WUYVST        IFEQ      'N'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1CLSS        ZA0013                         Class to use
      * Send message 'Class to Use          INV'
     C                   MOVEL     'USR3087'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(36)                        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Retail A/c Balance Enquiry
      * CASE: DTL.Retail A/c Balance Enq is Valid Values
     C     #1BALE        IFEQ      'N'                                          *IF
     C     #1BALE        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1BALE        ZA0014                         Retail A/c Bala
      * Send message 'Retail A/c Balnce Enq INV'
     C                   MOVEL     'USR3072'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(37)                        *
      *
     C                   END                                                    *FI
      * Retail A/c Transfer
      * CASE: DTL.Retail A/c Transfer is Valid Values
     C     #1RTFR        IFEQ      'N'                                          *IF
     C     #1RTFR        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1RTFR        ZA0015                         Retail A/c Tran
      * Send message 'Retail A/c Transfer   INV'
     C                   MOVEL     'USR3073'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(38)                        *
      *
     C                   END                                                    *FI
      * Cash Deposit in A/c Currency
      * CASE: DTL.Cash Dep in A/c Currency is Valid Values
     C     #1CDAC        IFEQ      'N'                                          *IF
     C     #1CDAC        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CDAC        ZA0016                         Cash Dep in A/c
      * Send message 'Cash Dep in A/c Ccy   INV'
     C                   MOVEL     'USR3074'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(39)                        *
      *
     C                   END                                                    *FI
      * Cheque Deposit in A/c Currency
      * CASE: DTL.Chq Dep in A/c Currency is Valid Values
     C     #1CQDA        IFEQ      'N'                                          *IF
     C     #1CQDA        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CQDA        ZA0017                         Chq Dep in A/c
      * Send message 'Chq Dep in A/c Ccy    INV'
     C                   MOVEL     'USR3075'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(40)                        *
      *
     C                   END                                                    *FI
      * Cash Deposit in Non A/c Currency
      * CASE: DTL.Cash Dep in Non A/c Ccy is Valid Values
     C     #1CDNC        IFEQ      'N'                                          *IF
     C     #1CDNC        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CDNC        ZA0018                         Cash Dep in Non
      * Send message 'Cash Dep Non A/c Ccy  INV'
     C                   MOVEL     'USR3077'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(41)                        *
      *
     C                   END                                                    *FI
      * Cheque Deposit in Non A/c Currency
      * CASE: DTL.Chq Dep in Non A/c Ccy is Valid values
     C     #1CQNA        IFEQ      'N'                                          *IF
     C     #1CQNA        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CQNA        ZA0019                         Chq Dep in Non
      * Send message 'Chq Dep in Non A/c CcyINV'
     C                   MOVEL     'USR3076'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(42)                        *
      *
     C                   END                                                    *FI
      * Cash Withdrawl in A/c Currency
      * CASE: DTL.Cash Wdl in A/c Currency is Valid Values
     C     #1CWAC        IFEQ      'N'                                          *IF
     C     #1CWAC        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CWAC        ZA0020                         Cash Wdl in A/c
      * Send message 'Cash Wdl in A/c Ccy   INV'
     C                   MOVEL     'USR3078'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(43)                        *
      *
     C                   END                                                    *FI
      * Cheque Withdrawl in A/c Currency
      * CASE: DTL.Chq Wdl in A/c Currency is Valid Values
     C     #1CQWA        IFEQ      'N'                                          *IF
     C     #1CQWA        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CQWA        ZA0021                         Chq Wdl in A/c
      * Send message 'Chq Wdl in A/c Ccy    INV'
     C                   MOVEL     'USR3080'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(44)                        *
      *
     C                   END                                                    *FI
      * *** 2nd Screen ***
      * Cash Withdrawl in Non A/c Currency
      * CASE: 2ND.Cash Wdl in Non A/c Ccy is Valid Values
     C     #1CWNA        IFEQ      'N'                                          *IF
     C     #1CWNA        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CWNA        ZA0022                         Cash Wdl in Non
      * Send message 'Cash Wdl Non A/c Ccy  INV'
     C                   MOVEL     'USR3079'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(31)                        *
      *
     C                   END                                                    *FI
      * Cheque Withdrawl in Non A/c Currency
      * CASE: 2ND.Chq Wdl in Non A/c Ccy is Valid Values
     C     #1CQWN        IFEQ      'N'                                          *IF
     C     #1CQWN        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CQWN        ZA0023                         Chq Wdl in Non
      * Send message 'Chq Wdl in Non A/c CcyINV'
     C                   MOVEL     'USR3081'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(32)                        *
      *
     C                   END                                                    *FI
      * Bureau de Change Transaction
      * CASE: 2ND.Bureau De Change Txn is Valid Values
     C     #1BDCT        IFEQ      'N'                                          *IF
     C     #1BDCT        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1BDCT        ZA0024                         Bureau De Chang
      * Send message 'Bureau de Change TransINV'
     C                   MOVEL     'USR3088'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(33)                        *
      *
     C                   END                                                    *FI
      * Buy Traveller's Cheques
      * CASE: 2ND.Buy Traveller's Cheques is Valid Values
     C     #1BTC         IFEQ      'N'                                          *IF
     C     #1BTC         OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1BTC         ZA0025                         Buy Traveller's
      * Send message 'Buy Traveller's Chqs  INV'
     C                   MOVEL     'USR3089'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(34)                        *
      *
     C                   END                                                    *FI
      * Sell Traveller's Cheques
      * CASE: 2ND.Sell Traveller's Cheques is Valid Values
     C     #1STC         IFEQ      'N'                                          *IF
     C     #1STC         OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1STC         ZA0026                         Sell Traveller'
      * Send message 'Sell Traveller's Chqs INV'
     C                   MOVEL     'USR3090'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(35)                        *
      *
     C                   END                                                    *FI
      * Transaction Reversals
      * CASE: 2ND.Transaction Reversals is Valid Values
     C     #1TXRV        IFEQ      'N'                                          *IF
     C     #1TXRV        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1TXRV        ZA0027                         Transaction Rev
      * Send message 'Transaction Reversals INV'
     C                   MOVEL     'USR3091'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(36)                        *
      *
     C                   END                                                    *FI
      * Passbook Update
      * CASE: 2ND.Passbook Update is Valid Values
     C     #1PUPD        IFEQ      'N'                                          *IF
     C     #1PUPD        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1PUPD        ZA0028                         Passbook Update
      * Send message 'Passbook Update       INV'
     C                   MOVEL     'USR3092'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(37)                        *
      *
     C                   END                                                    *FI
      * Passbook Name & Address
      * CASE: 2ND.Passbook Name & Address is Valid Values
     C     #1PNAD        IFEQ      'N'                                          *IF
     C     #1PNAD        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1PNAD        ZA0029                         Passbook Name &
      * Send message 'Passbook Name & Addr  INV'
     C                   MOVEL     'USR3093'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(38)                        *
      *
     C                   END                                                    *FI
      * Draft Issue
      * CASE: 2ND.Draft Issue is Valid Values
     C     #1DISS        IFEQ      'N'                                          *IF
     C     #1DISS        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1DISS        ZA0030                         Draft Issue
      * Send message 'Draft Issue           INV'
     C                   MOVEL     'USR3094'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I2(39)                        *
      *
     C                   END                                                    *FI
      *                                                                                       CRT005
     C     CRT005        IFEQ      'Y'
      *                                                                                       CRT005
      ** Teller Cross In                                                                      CRT005
      *                                                                                       CRT005
     C     #1TCI         IFNE      'N'
     C     #1TCI         ANDNE     'Y'
     C                   MOVEL     #1TCI         ZA0031
     C                   MOVEL     'USR5714'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     '1'           @I2(40)
     C                   ENDIF
      *                                                                                       CRT005
      ** Teller Cross Out                                                                     CRT005
      *                                                                                       CRT005
     C     #1TCO         IFNE      'N'
     C     #1TCO         ANDNE     'Y'
     C                   MOVEL     #1TCO         ZA0032
     C                   MOVEL     'USR5589'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     '1'           @I2(41)
     C                   ENDIF
      *                                                                                       CRT005
      ** Teller Treasury In                                                                   CRT005
      *                                                                                       CRT005
     C     #1TTI         IFNE      'N'
     C     #1TTI         ANDNE     'Y'
     C                   MOVEL     #1TTI         ZA0033
     C                   MOVEL     'USR5590'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     '1'           @I2(42)
     C                   ENDIF
      *                                                                                       CRT005
      ** Teller Treasury Out                                                                  CRT005
      *                                                                                       CRT005
     C     #1TTO         IFNE      'N'
     C     #1TTO         ANDNE     'Y'
     C                   MOVEL     #1TTO         ZA0034
     C                   MOVEL     'USR5591'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     '1'           @I2(43)
      *                                                                                       CRT005
     C                   ENDIF
      *                                                                                       CRT005
      **  Access General Ledger Details                                                       CRT005
      *                                                                                       CRT005
     C**********           CALL 'AOGELRR0'                                             CRT005 CGL029
     C                   CALL      'AOGELRR1'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C********** SDGELR    PARM SDGELR    DSFDY                                        CRT005 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY
     C*                                                                                       CRT005
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   OUT       LDA
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CRT005
     C     #1OUAC        IFNE      *BLANKS
     C     BKACCD        ANDNE     #1OUAC
      *                                                                                       CRT005
      **  Access Account Code Details                                                         CRT005
      *                                                                                       CRT005
     C                   CALL      'AOACODR0'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C**********           PARM #1OUAC    PAFNB   4                                    CRT005 CGL029
     C                   PARM      #1OUAC        PAFNB            10
     C     SDACOD        PARM      SDACOD        DSSDY
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'USR5594'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     '1'           @I2(44)
     C                   ELSE
     C                   MOVEL     A5ACCD        #1OUAC
     C                   ENDIF
      *                                                                                       CRT005
     C     A5ACTY        IFNE      'G'
     C                   MOVEL     'USR5592'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     '1'           @I2(44)
     C                   ENDIF
      *                                                                                       CRT005
     C     A5ACSC        IFNE      'IN'
     C     A5ACSC        ANDNE     'EX'
     C                   MOVEL     'USR5593'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
     C                   MOVEL     '1'           @I2(44)
     C                   ENDIF
      *                                                                                       CRT005
     C                   ELSE
     C                   MOVEL     BKACCD        #1OUAC
      *                                                                                       CRT005
     C                   ENDIF
      *                                                                                       CRT005
     C                   ENDIF
      *                                                                                       CRT005
      * 00/Copy Member SD9411RVSF - BAI ICD  *
     C*Edit Cashier Intrface ICDValidate Detail Screen
     C/COPY WNCPYSRC,SD9411RVSF
      * Check relations
      * Check reference to BAI Products & Comms
     C                   EXSR      VBCKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     '1'           @I1(31)
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(32)
     C                   SETON                                        99        *
     C                   END
      * CALC: Detail screen function fields
      * 00/Copy Member SD9411RSFF - BAI ICD  *
     C*Edit Cashier Intrface ICDCalc Detail Function Flds
     C/COPY WNCPYSRC,SD9411RSFF
      * USER: Validate detail screen relations
      * 00/Copy Member SD9411RVSR - BAI ICD  *
     C*Edit Cashier Intrface ICDValidate Screen Relns
     C/COPY WNCPYSRC,SD9411RVSR
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
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
      * 00/Copy Member SD9411RPCK - BAI ICD  *
     C*Edit Cashier Intrface ICDProcess Command Keys
     C/COPY WNCPYSRC,SD9411RPCK
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Branch Auto Interf - BAI ICD  *
     C                   EXSR      SCCHRC
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
     C     P1BAII        IFEQ      *BLANK                                       BAI ICD Record
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
     C     W0SCR         IFNE      1
     C                   END
     C     W0SCR         IFNE      2
     C                   END
     C     W0SCR         IFEQ      1
     C                   ELSE
     C     W0SCR         IFEQ      2
     C                   END
     C                   END
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   MOVEL     P3WRTC        #PWRTC                         Work Return cod
     C                   MOVEL     *BLANK        #PRTN                          *Return code
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1CWNA                         Cash Wdl in Non
     C                   MOVEL     *BLANK        #1CWNP                         Cash Wdl Non A/
     C                   MOVEL     *BLANK        #1CQWN                         Chq Wdl in Non
     C                   MOVEL     *BLANK        #1CQWQ                         Chq Wdl Non A/c
     C                   MOVEL     *BLANK        #1BDCT                         Bureau De Chang
     C                   MOVEL     *BLANK        #1BDCP                         Bureau De Chang
     C                   MOVEL     *BLANK        #1BTC                          Buy Traveller's
     C                   MOVEL     *BLANK        #1BTCP                         Buy Traveller's
     C                   MOVEL     *BLANK        #1STC                          Sell Traveller'
     C                   MOVEL     *BLANK        #1STCP                         Sell Traveller'
     C                   MOVEL     *BLANK        #1TXRV                         Transaction Rev
     C                   MOVEL     *BLANK        #1TXRP                         Transaction Rev
     C                   MOVEL     *BLANK        #1PUPD                         Passbook Update
     C                   MOVEL     *BLANK        #1PUPP                         Passbook Update
     C                   MOVEL     *BLANK        #1PNAD                         Passbook Name &
     C                   MOVEL     *BLANK        #1PNAP                         Passbook Name/A
     C                   MOVEL     *BLANK        #1DISS                         Draft Issue
     C                   MOVEL     *BLANK        #1DISP                         Draft Issue Pgm
     C                   MOVEL     *BLANK        #1PROD                         Retail Banking
     C                   MOVEL     *BLANK        #1COMM                         Communications
     C                   MOVEL     *BLANK        #1COMP                         Communications
     C                   Z-ADD     *ZERO         #1CONV                         No. Convs for C
     C                   MOVEL     *BLANK        #1INIT                         Start BAI at I/
     C                   MOVEL     *BLANK        #1JBDE                         Job Description
     C                   MOVEL     *BLANK        #1JBQU                         Job Queue to us
     C                   MOVEL     *BLANK        #1CLSS                         Class to use
     C                   MOVEL     *BLANK        #1BALE                         Retail A/c Bala
     C                   MOVEL     *BLANK        #1BALP                         Retail A/c Bal
     C                   MOVEL     *BLANK        #1RTFR                         Retail A/c Tran
     C                   MOVEL     *BLANK        #1TFRP                         Retail A/c Tran
     C                   MOVEL     *BLANK        #1CDAC                         Cash Dep in A/c
     C                   MOVEL     *BLANK        #1CDAP                         Cash Dep In A/c
     C                   MOVEL     *BLANK        #1CQDA                         Chq Dep in A/c
     C                   MOVEL     *BLANK        #1CQDP                         Chq Dep In A/c
     C                   MOVEL     *BLANK        #1CDNC                         Cash Dep in Non
     C                   MOVEL     *BLANK        #1CDNP                         Cash Dep Non A/
     C                   MOVEL     *BLANK        #1CQNA                         Chq Dep in Non
     C                   MOVEL     *BLANK        #1CQNP                         Chq Dep Non A/c
     C                   MOVEL     *BLANK        #1CWAC                         Cash Wdl in A/c
     C                   MOVEL     *BLANK        #1CWAP                         Cash Wdl In A/c
     C                   MOVEL     *BLANK        #1CQWA                         Chq Wdl in A/c
     C                   MOVEL     *BLANK        #1CQWP                         Chq Wdl In A/c
     C                   MOVEL     P3WRTC        #PWRTC                         Work Return cod
     C                   MOVEL     *BLANK        #PRTN                          *Return code
     C                   MOVEL     *BLANK        #1TCI
     C                   MOVEL     *BLANK        #1TCIP
     C                   MOVEL     *BLANK        #1TCO
     C                   MOVEL     *BLANK        #1TCOP
     C                   MOVEL     *BLANK        #1TTI
     C                   MOVEL     *BLANK        #1TTIP
     C                   MOVEL     *BLANK        #1TTO
     C                   MOVEL     *BLANK        #1TTOP
     C                   MOVEL     *BLANK        #1OUAC
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @BAIIL1 fields to screen
      *================================================================
     C                   MOVEL     FUBAII        #1BAII                         BAI ICD Record
     C                   Z-ADD     FULCD         #1LCD                          Last Change Dat
     C                   MOVEL     FUTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     FUCWNA        #1CWNA                         Cash Wdl in Non
     C                   MOVEL     FUCWNP        #1CWNP                         Cash Wdl Non A/
     C                   MOVEL     FUCQWN        #1CQWN                         Chq Wdl in Non
     C                   MOVEL     FUCQWQ        #1CQWQ                         Chq Wdl Non A/c
     C                   MOVEL     FUBDCT        #1BDCT                         Bureau De Chang
     C                   MOVEL     FUBDCP        #1BDCP                         Bureau De Chang
     C                   MOVEL     FUBTC         #1BTC                          Buy Traveller's
     C                   MOVEL     FUBTCP        #1BTCP                         Buy Traveller's
     C                   MOVEL     FUSTC         #1STC                          Sell Traveller'
     C                   MOVEL     FUSTCP        #1STCP                         Sell Traveller'
     C                   MOVEL     FUTXRV        #1TXRV                         Transaction Rev
     C                   MOVEL     FUTXRP        #1TXRP                         Transaction Rev
     C                   MOVEL     FUPUPD        #1PUPD                         Passbook Update
     C                   MOVEL     FUPUPP        #1PUPP                         Passbook Update
     C                   MOVEL     FUPNAD        #1PNAD                         Passbook Name &
     C                   MOVEL     FUPNAP        #1PNAP                         Passbook Name/A
     C                   MOVEL     FUDISS        #1DISS                         Draft Issue
     C                   MOVEL     FUDISP        #1DISP                         Draft Issue Pgm
     C                   MOVEL     FUPROD        #1PROD                         Retail Banking
     C                   MOVEL     FUCOMM        #1COMM                         Communications
     C                   MOVEL     FUCOMP        #1COMP                         Communications
     C                   Z-ADD     FUCONV        #1CONV                         No. Convs for C
     C                   MOVEL     FUINIT        #1INIT                         Start BAI at I/
     C                   MOVEL     FUJBDE        #1JBDE                         Job Description
     C                   MOVEL     FUJBQU        #1JBQU                         Job Queue to us
     C                   MOVEL     FUCLSS        #1CLSS                         Class to use
     C                   MOVEL     FUBALE        #1BALE                         Retail A/c Bala
     C                   MOVEL     FUBALP        #1BALP                         Retail A/c Bal
     C                   MOVEL     FURTFR        #1RTFR                         Retail A/c Tran
     C                   MOVEL     FUTFRP        #1TFRP                         Retail A/c Tran
     C                   MOVEL     FUCDAC        #1CDAC                         Cash Dep in A/c
     C                   MOVEL     FUCDAP        #1CDAP                         Cash Dep In A/c
     C                   MOVEL     FUCQDA        #1CQDA                         Chq Dep in A/c
     C                   MOVEL     FUCQDP        #1CQDP                         Chq Dep In A/c
     C                   MOVEL     FUCDNC        #1CDNC                         Cash Dep in Non
     C                   MOVEL     FUCDNP        #1CDNP                         Cash Dep Non A/
     C                   MOVEL     FUCQNA        #1CQNA                         Chq Dep in Non
     C                   MOVEL     FUCQNP        #1CQNP                         Chq Dep Non A/c
     C                   MOVEL     FUCWAC        #1CWAC                         Cash Wdl in A/c
     C                   MOVEL     FUCWAP        #1CWAP                         Cash Wdl In A/c
     C                   MOVEL     FUCQWA        #1CQWA                         Chq Wdl in A/c
     C                   MOVEL     FUCQWP        #1CQWP                         Chq Wdl In A/c
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      *                                                                                       CRT005
     C     CRT005        IFEQ      'Y'
     C                   MOVEL     FUTCI         #1TCI
     C                   MOVEL     FUTCIP        #1TCIP
     C                   MOVEL     FUTCO         #1TCO
     C                   MOVEL     FUTCOP        #1TCOP
     C                   MOVEL     FUTTI         #1TTI
     C                   MOVEL     FUTTIP        #1TTIP
     C                   MOVEL     FUTTO         #1TTO
     C                   MOVEL     FUTTOP        #1TTOP
     C                   MOVEL     FUOUAC        #1OUAC
     C                   ENDIF
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P3WRTC        #PWRTC                         Work Return cod
     C                   MOVEL     *BLANK        #PRTN                          *Return code
     C                   MOVEL     P1BAII        #1BAII                         BAI ICD Record
      * USER: Initialize key screen
      * 00/Copy Member SD9411RIKS - BAI ICD  *
     C*Edit Cashier Intrface ICDInitialise Key Screen
     C/COPY WNCPYSRC,SD9411RIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Check CI Prod & Comms - BAI Products & Comms  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    FZPROD                         Retail Banking
     C                   KFLD                    FZCOMP                         Communications
      * Move fields to key list
     C                   MOVEL     #1PROD        FZPROD                         Retail Banking
     C                   MOVEL     #1COMP        FZCOMP                         Communications
     C*****KRSSA         CHAIN     @BAIPL2                            90        *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDBAIP                                                                        MD058085
     C+ from SDBAPJW0                                                                       MD058085
     C+ where FZPROD = :FZPROD and FZCOMP = :FZCOMP                                         MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       90                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR2930'     W0RTN             7
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
      * Check CI Prod & Comms - BAI Products & Comms  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    FZPROD                         Retail Banking
     C                   KFLD                    FZCOMP                         Communications
      * Move fields to key list
     C                   MOVEL     #1PROD        FZPROD                         Retail Banking
     C                   MOVEL     #1COMP        FZCOMP                         Communications
     C*****KRSSB         CHAIN     @BAIPL2                            90        *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDBAIP                                                                        MD058085
     C+ from SDBAPJW0                                                                       MD058085
     C+ where FZPROD = :FZPROD and FZCOMP = :FZCOMP                                         MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       90                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR2930'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Change Branch Auto Interf - BAI ICD  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @BAIIL0
     C                   MOVEL     #1BAII        FUBAII                         BAI ICD Record
      *
     C     KLCHSC        KLIST
     C                   KFLD                    FUBAII                         BAI ICD Record
     C     KLCHSC        CHAIN     @BAIIL0                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C                   UNLOCK    SDBAIIL0                             91      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C**********           MOVE @1DBRC    YARDCS                                              CGL029
     C                   MOVEL     @1DBRC        YARDCS
      * USER: Processing after Data read
      * save Last Change Date from record
     C                   Z-ADD     FULCD         WULCD                          Last Change Dat
      * Move non-key fields to @BAIIL0
     C                   Z-ADD     WURDNB        FULCD                          Last Change Dat
     C                   MOVEL     'A'           FUTYLC                         Type of Last Ch
     C                   MOVEL     #1PROD        FUPROD                         Retail Banking
     C                   MOVEL     #1COMP        FUCOMP                         Communications
     C                   MOVEL     #1COMM        FUCOMM                         Communications
     C                   Z-ADD     #1CONV        FUCONV                         No. Convs for C
     C                   MOVEL     #1INIT        FUINIT                         Start BAI at I/
     C                   MOVEL     #1JBDE        FUJBDE                         Job Description
     C                   MOVEL     #1JBQU        FUJBQU                         Job Queue to us
     C                   MOVEL     #1CLSS        FUCLSS                         Class to use
     C                   MOVEL     #1BALE        FUBALE                         Retail A/c Bala
     C                   MOVEL     #1BALP        FUBALP                         Retail A/c Bal
     C                   MOVEL     #1RTFR        FURTFR                         Retail A/c Tran
     C                   MOVEL     #1TFRP        FUTFRP                         Retail A/c Tran
     C                   MOVEL     #1CDAC        FUCDAC                         Cash Dep in A/c
     C                   MOVEL     #1CDAP        FUCDAP                         Cash Dep In A/c
     C                   MOVEL     #1CQDA        FUCQDA                         Chq Dep in A/c
     C                   MOVEL     #1CQDP        FUCQDP                         Chq Dep In A/c
     C                   MOVEL     #1CDNC        FUCDNC                         Cash Dep in Non
     C                   MOVEL     #1CDNP        FUCDNP                         Cash Dep Non A/
     C                   MOVEL     #1CQNA        FUCQNA                         Chq Dep in Non
     C                   MOVEL     #1CQNP        FUCQNP                         Chq Dep Non A/c
     C                   MOVEL     #1CWAC        FUCWAC                         Cash Wdl in A/c
     C                   MOVEL     #1CWAP        FUCWAP                         Cash Wdl In A/c
     C                   MOVEL     #1CWNA        FUCWNA                         Cash Wdl in Non
     C                   MOVEL     #1CWNP        FUCWNP                         Cash Wdl Non A/
     C                   MOVEL     #1CQWA        FUCQWA                         Chq Wdl in A/c
     C                   MOVEL     #1CQWP        FUCQWP                         Chq Wdl In A/c
     C                   MOVEL     #1CQWN        FUCQWN                         Chq Wdl in Non
     C                   MOVEL     #1CQWQ        FUCQWQ                         Chq Wdl Non A/c
     C                   MOVEL     #1BDCT        FUBDCT                         Bureau De Chang
     C                   MOVEL     #1BDCP        FUBDCP                         Bureau De Chang
     C                   MOVEL     #1BTC         FUBTC                          Buy Traveller's
     C                   MOVEL     #1BTCP        FUBTCP                         Buy Traveller's
     C                   MOVEL     #1STC         FUSTC                          Sell Traveller'
     C                   MOVEL     #1STCP        FUSTCP                         Sell Traveller'
     C                   MOVEL     #1TXRV        FUTXRV                         Transaction Rev
     C                   MOVEL     #1TXRP        FUTXRP                         Transaction Rev
     C                   MOVEL     #1PUPD        FUPUPD                         Passbook Update
     C                   MOVEL     #1PUPP        FUPUPP                         Passbook Update
     C                   MOVEL     #1PNAD        FUPNAD                         Passbook Name &
     C                   MOVEL     #1PNAP        FUPNAP                         Passbook Name/A
     C                   MOVEL     #1DISS        FUDISS                         Draft Issue
     C                   MOVEL     #1DISP        FUDISP                         Draft Issue Pgm
      *                                                                                       CRT005
     C     CRT005        IFEQ      'Y'
     C                   MOVEL     #1TCI         FUTCI
     C                   MOVEL     #1TCIP        FUTCIP
     C                   MOVEL     #1TCO         FUTCO
     C                   MOVEL     #1TCOP        FUTCOP
     C                   MOVEL     #1TTI         FUTTI
     C                   MOVEL     #1TTIP        FUTTIP
     C                   MOVEL     #1TTO         FUTTO
     C                   MOVEL     #1TTOP        FUTTOP
     C                   MOVEL     #1OUAC        FUOUAC
     C                   ENDIF
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
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
     C                   GOTO      SCEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SCEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD9411RBUW - BAI ICD  *
     C*Edit Cashier Intrface ICDBefore Update, Window on
     C/COPY WNCPYSRC,SD9411RBUW
     C                   END                                                    *FI
      * 00/Copy Member SD9411RBDU - BAI ICD  *
     C*Edit Cashier Intrface ICDProcessing Before Update
     C/COPY WNCPYSRC,SD9411RBDU
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    @BAIIL0                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDBAIIL0                             91      *
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
      * CASE: WRK.Last Change Date NE WRK.Run day number
     C     WULCD         IFNE      WURDNB                                       *IF
      * only update file controls if record has not been updated already
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SDCHRC
     C                   END                                                    *FI
      * 00/Copy Member SD9411RADU - BAI ICD  *
     C*Edit Cashier Intrface ICDProcessing After Update
     C/COPY WNCPYSRC,SD9411RADU
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDICDRPD'    AHFLNM                         Filename
      *
     C     KLCHSD        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSD        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
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
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    SDFCTLL0                             91      *           MD061007
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SERVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSE         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSE         CHAIN     @BGREC8                            90        *
      * Data record not found
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1BAII        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          BAI ICD Record
     C                   CALL      'SDZFSRR'                            90      Select Branch A
     C                   PARM      *BLANK        W0RTN             7
     C     #1BAII        PARM      #1BAII        WQ0001           10            BAI ICD Record
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDZFSRR'     W0CLPG
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
     CSR   VBCKRL        BEGSR
      *================================================================
      * Check reference to BAI Products & Comms
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Name search required?
     C                   MOVEL     #1PROD        WK1X01            1
     C                   MOVEL     #1COMP        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Retail Banking
     C     WK1X02        OREQ      '?'                                          Communications
     C                   CALL      'SDHGSRR'                            90      Select BAI Prod
     C                   PARM      *BLANK        W0RTN             7
     C     #1PROD        PARM      #1PROD        WQ0025           10            Retail Banking
     C     #1COMP        PARM      #1COMP        WQ0026           10            Communications
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDHGSRR'     W0CLPG
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
     C                   SETON                                        99        *
     C                   MOVEL     '1'           @I1(31)                        *
     C                   MOVEL     '1'           @I1(32)                        *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
      * No value selected, exit
     C     W0RTN         IFNE      *BLANK
     C                   GOTO      VBEXIT
     C                   END
     C                   END
      *................................................................
      * If all low order keys not entered, exit
     C     #1PROD        IFEQ      *BLANK                                       Retail Banking
     C     #1COMP        ANDEQ     *BLANK                                       Communications
     C                   GOTO      VBEXIT
     C                   END
      *
     C     KLVBFZ        KLIST
     C                   KFLD                    FZPROD                         Retail Banking
     C                   KFLD                    FZCOMP                         Communications
      * Setup key
     C                   MOVEL     #1PROD        FZPROD                         Retail Banking
     C                   MOVEL     #1COMP        FZCOMP                         Communications
     C*****KLVBFZ        CHAIN     @BAIPL2                            9091      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDBAIP                                                                        MD058085
     C+ from SDBAPJW0                                                                       MD058085
     C+ where FZPROD = :FZPROD and FZCOMP = :FZCOMP                                         MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       90                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VBEXIT
     C                   END
      * Send message 'BAI Products & Comms   NF'
     C                   MOVEL     'USR2930'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'USR2930'     W0RTN
      *================================================================
     CSR   VBEXIT        ENDSR
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
     CSR   Y2SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR   Y2EXIT        ENDSR
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
     C     @#DFMT        IFEQ      '#RCDDTL2'
      * DETAIL 2 Screen
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
     C                   PARM      'SDYDE2R'     W0HPMB           10            Help text sourc
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
      * 00/Copy Member SD9411REPP - BAI ICD  *
     C*Edit Cashier Intrface ICDExit Program Processing
     C/COPY WNCPYSRC,SD9411REPP
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
      * Define work field Object Found
     C                   MOVEL     *BLANK        WUYVST            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Last Change Date
     C                   Z-ADD     *ZERO         WULCD             5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
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
     C                   OPEN      SD9411R#
     C                   OPEN      SDBAIIL1
     C**********         OPEN      SDBAIPL1                                                 MD058085
     C                   OPEN      SDMMODL1
     C                   OPEN      SDBAIIL0
     C**********         OPEN      SDFCTLL0                                                 MD061007
     C                   MOVEL     'N'           W0PMT             1
      * Initialise error memories
     C                   MOVE      *ZERO         @@I1
     C                   MOVE      *ZERO         @@I2
      * Set to *CHANGE mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD9411R Precompiler - BAI ICD  *
      * Copyright Statement 1996 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      SERVGN
      * Cashier Intf ICD Data Str - BAI ICD  *
      * 00/Copy Member SD9411RIPG - BAI ICD  *
      * 00/Copy Member SD9411RFPG - BAI ICD  *
      * 00/Copy Member SD9411REPG - BAI ICD  *
      * 00/Copy Member SD9411RCPG - BAI ICD  *
     C*Edit Cashier Intrface ICDInitialise Program C-spec
     C/COPY WNCPYSRC,SD9411RCPG
      * 00/Copy Member SD9411ROPG - BAI ICD  *
      *                                                                                       CRT005
      ** Initialize LDA                                                                       CRT005
      *                                                                                       CRT005
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'SD9411R'     DBPGM
     C                   OUT       LDA
      *                                                                                       CRT005
      ** Determine if CRT005 is installed                                                     CRT005
      *                                                                                       CRT005
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY '    POPTN             7
     C                   PARM      'CRT005'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CRT005
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'CRT005'      DBKEY
     C                   OUT       LDA
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CRT005
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRT005            1
     C                   MOVE      '0'           *IN45
     C                   ELSE
     C                   MOVE      'N'           CRT005
     C                   MOVE      '1'           *IN45
     C                   ENDIF
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
     C/COPY WNCPYSRC,SD9411RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD9411RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRICD                                                              MD058085
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058085
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD9411RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*Edit Cashier Intrface ICDInitialise Program O-spec
     O/COPY WNCPYSRC,SD9411ROPG
**CTDATA CPY@
(c) Finastra International Limited 2001
