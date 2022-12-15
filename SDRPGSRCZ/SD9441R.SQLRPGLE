     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Midas-trade innovation i/face ICD maint')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD9441R - Midas-Trade Innovation Interface ICD Maintenance   *
      *                                                               *
      *  Function:  This program allows the user to amend the         *
      *             Midas-Trade Innovation Interface ICD file.        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058755           Date 01Sep21               *
      *  Prev Amend No. MD058085           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      *                 MD030956           Date 09Oct14               *
      *                 CTI006             Date 31Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3130            Date 23Jun04               *
      *                 CTI004             Date 12Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003             Date 07Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 167480             Date 18Jan00               *
      *                 CTI099             Date 30Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156783             Date 23Apr99               *   156783
      *                 130055             Date 10FEB98               *
      *                 CSD003             Date 27OCT97               *
      *                 CTI001             Date 01AUG97               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD058755 - Deliverable Data Split for SDRETRPD and TABLETZ   *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *             (Recompile)                                       *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG3130 - Add SWIFT Address Code and Alternate Prime Address *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           FX Deals Integration                                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CTI003 - Patch D. New fields on ICD.
      *  167480 - Add new field 'TICUSN' to flag whether the Midas    *
      *           Customer Number or Midas Customer Shortname is to   *
      *           used as the TI Customer Identifier.                 *
      *  CTI099 - Utility to open accounts for Midas/TI Interface     *
      *  156783 - If switchable feature S01492 is on restrict range   *   156783
      *           to under 900 as 900 plus reserved for LEO.          *   156783
      *  130055 - Transaction type should not be displayed when       *
      *           Retail Module is off.                               *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  CTI001 - Midas-Trade Innovation Interface:                   *
      *           - New program.                                      *
      *                                                               *
      *****************************************************************
     F/COPY WNCPYSRC,SD9441RFPG
     FSD9441R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Midas-trade innovation i/face ICD maint
      *
     FSDTIINL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas/TI interface ICD retrieval
      *
     FSDBRCHL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Branch codes retrieval
      *
     FSDDEPTL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * RTV : Department Codes          Retrieval index
      *
     F*SDRETRL1* IF   E           K DISK    USROPN                                          MD058755
     F**********                           INFDS(ID0003)                                    MD058755
     F**********                           INFSR(*PSSR)                                     MD058755
      * RTV : Midas SD Retail transaction types retrieval
      *
     FSDPRFCL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0004)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Profit centres retrieval
      *
     FSDBOOKL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0005)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Book details retrieval
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0006)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     FSDGELRL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0007)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Deal Sub-type                                                          CTI004
      *                                                                                       CTI004
     FSDDLSTL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      * RTV : Midas SD General ledger ICD details retrieval
      *
     FSDTIINL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0008)
     F                                     INFSR(*PSSR)
     F*SDTIACL0* UF   E           K DISK    USROPN                                          MD058085
     F**********                           COMMIT                                           MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * UPD : Midas SD Midas/TI interface ICD update
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0009)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D ALPHB           S              1    DIM(26) CTDATA PERRCD(26)            ALPHAB-Z&SPACE
     D/COPY WNCPYSRC,SD9441REPG
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*COPY*QWINDSRC,SD9440GDTA                                           S01229            MD058085
     D/COPY QWINDSRC,SD9440GDTL                                                             MD058085
     D/COPY WNCPYSRC,SD9441RIPG
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
     D @1DBRC        E DS                  EXTNAME(SDTIINL0)
      * UPD : Midas SD Midas/TI interface ICD update
      * Current/previous master file format fields for change control
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      **  Account code details                                                                CTI003
      *
     D*#1DBRC******DS                             47                                          CTI099
     D***#1DBRC   DS                             52                                    CTI099 167480
     D*#1DBRC*****DS                             53                                    167480 CTI003
     D***#1DBRC*  DS                             61                                    CTI003 CGL029
     D #1DBRC          DS          9999
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D*YARDCS******DS                             47                                          CTI099
     D*YARDCS*****DS                             52                                    CTI099 CTI003
     D***YARDCS*  DS                             61                                    CTI003 CGL029
     D YARDCS          DS          9999
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
      * UPD : Midas SD Standing data controls update
     D YBRDCS          DS            22
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D YRSW0A          DS          9999
     D YRSW0B          DS          9999
     D YRSW0C          DS          9999
     D YRSW0D          DS          9999
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
     D ID0005          DS           528
      * File information data structure
      *
     D ID0006          DS           528
      * File information data structure
      *
     D ID0007          DS           528
      * File information data structure
      *
     D ID0008          DS           528
      * File information data structure
      *
     D ID0009          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS            10
      * KEY: Midas SD Midas/TI interface ICD retrieval
      * I : RST Midas/TI Interface Key
     D  P1INKY                 1     10
     D P2PARM          DS
      * O :  *Return code
     D  P2RTN                  1      7
     D P3PARM          DS
      * B : MAP Work Return code
     D  P3WRTC                 1      5
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'TI Branch Blank'
      * Branch
     D  ZA0001                 1      3
      * Message data for 'TI Branch not on SDBRCHPD'
      * Branch
     D  ZA0002                 1      3
      * Message data for 'TI Dept Blank'
      * Department
     D  ZA0003                 1      3
      * Message data for 'TI Dept not on Dept File'
      * Department
     D  ZA0004                 1      3
      * Message data for 'TI Transaction Type blank'
      * Transaction Type (TI)
     D  ZA0005                 1      5
      * Message data for 'TI Transaction Type inval'
      * Transaction Type (TI)
     D  ZA0006                 1      5
      * Message data for 'TI Prof Centre blank'
      * Profit centre code  MIDAS
     D  ZA0007                 1      4
      * Message data for 'TI Profit Centre Invalid'
      * Profit centre code  MIDAS
     D  ZA0008                 1      4
      * Message data for 'TI Book blank'
      * Book
     D  ZA0009                 1      2
      * Message data for 'TI Book invalid'
      * Book
     D  ZA0010                 1      2
      * Message data for 'Min Batch Size invalid'
      * Minimum Batch Size (scrn)
     D  ZA0011                 1      3
      * Message data for 'Min Batch Size invalid'
      * Minimum Batch Size (scrn)
     D  ZA0012                 1      3
      * Message data for 'Min Batch Size invalid'
      * Minimum Batch Size (scrn)
     D  ZA0013                 1      3
      * Message data for 'Max Batch Size invalid'
      * Maximum Batch Size (Scrn)
     D  ZA0014                 1      3
      * Message data for 'Max Batch Size invalid'
      * Maximum Batch Size (Scrn)
     D  ZA0015                 1      3
      * Message data for 'Max Batch Size too small'
      * Maximum Batch Size (Scrn)
     D  ZA0016                 1      3
      * Message data for 'Max Batch Size invalid'
      * Maximum Batch Size (Scrn)
     D  ZA0017                 1      3
      * Message data for 'Lower Rng Batch Size invd'
      * Lower Rng Batch Nbr (scr)
     D  ZA0018                 1      3
      * Message data for 'Lower Rng Batch Size invd'
      * Lower Rng Batch Nbr (scr)
     D  ZA0019                 1      3
      * Message data for 'Lower Rng Batch Size invd'
      * Lower Rng Batch Nbr (scr)
     D  ZA0020                 1      3
      * Message data for 'Upper Rng Batch Size invd'
      * Upper Rng Batch Nbr (scr)
     D  ZA0021                 1      3
      * Message data for 'Upper Rng Batch Size invd'
      * Upper Rng Batch Nbr (scr)
     D  ZA0022                 1      3
      * Message data for 'Upper Rng Batch Size invd'
      * Upper Rng Batch Nbr (scr)
     D  ZA0023                 1      3
      * Message data for 'RE Account Sts Check invd'
      * Retail Account Sts Check
     D  ZA0024                 1      1
      * Message data for 'Processing Wait Time invd'
      * Processg Wait Time (Scrn)
     D  ZA0025                 1      2
      * Message data for 'Processing Wait Time invd'
      * Processg Wait Time (Scrn)
     D  ZA0026                 1      2
      * Message data for 'Processing Wait Time invd'
      * Processg Wait Time (Scrn)
     D  ZA0027                 1      2
      * Message data for 'Cont COB No Link invalid'
      * Continue COB if No Link
     D  ZA0028                 1      1
      * Message data for 'Use Midas Customer No invalid'                                      167480
      * Use Midas Customer Number                                                             167480
     D  ZA0029                 1      1
      * Message data for 'Max Batch Size invalid'                                             CTI003
      * Maximum Batch Size (Scrn)                                                             CTI003
     D  ZA0030                 1      3
      **Message*data*for*'TI*FX*Deal*Sub-type'                                        CTI004 BUG3130
      * Message data for 'TI FX Deal Sub-type invalid'                                       BUG3130
      **Maximum*Batch*Size*(Scrn)                                                     CTI004 BUG3130
      * TI FX Deal Sub-type (Scrn)                                                           BUG3130
     D  ZA0031                 1      2
      * Message data for 'Swift Address Code Invalid'                                        BUG3130
      * SWIFT Address Code (Scrn)                                                            BUG3130
     D  ZA0032                 1      1                                                            B
      * Message data for 'Alternate Prime Address'                                           BUG3130
      * Alternate Prime Address (Scrn)                                                       BUG3130
     D  ZA0033                 1      1                                                            B
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    156783
      **  Switchable Features File Details                                156783
     D*SDTIAC***     E DS                  EXTNAME(SDTIACPD)                                MD058085
     D SDTIAC        E DS                  EXTNAME(SDTIAJW0)                                MD058085
      **  TI Account Type FIle                                                                CTI099
      *                                                                   156783
     D DSFDY         E DS                  EXTNAME(DSFDY)                       156783
      **  Short data structure for access programs                        156783
      *                                                                   156783
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, Long Date Structure                                   CTI003
      *                                                                                       CTI033
     D SDRETR        E DS                  EXTNAME(SDRTRJW0)                                MD058755
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY: Midas/TI I
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
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1INKY        IFEQ      *BLANK                                       Midas/TI Interf
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
     C                   KFLD                    TIINKY                         Midas/TI Interf
      * Setup key
     C                   MOVEL     #1INKY        TIINKY                         Midas/TI Interf
     C     KRTV          CHAIN     @TIINL1                            9091      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9931      *
      * Send message 'Midas/TI Interface ICD NF'
     C                   MOVEL     'USR3502'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * 00/Copy Member SD9441RSFF - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RSFF
      * USER: Initialize detail screen (existing record)
      * Move data to the screen fields
     C                   MOVEL     #1MNBS        #DMBSS                         Minimum Batch S
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DMBSS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0002           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0003            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0004            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0005           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0006           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0007            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DMBSS                 90      Minimum Batch S
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVEL     #1MXBS        #DMAXS                         Maximum Batch S
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DMAXS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0008            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0009           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0010            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0011            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0012           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0013           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0014            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DMAXS                 90      Maximum Batch S
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVEL     #1LRBN        #DLRBS                         Lower Rng Batch
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DLRBS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0015            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0016           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0017            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0018            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0019           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0020           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0021            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DLRBS                 90      Lower Rng Batch
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVEL     #1URBN        #DURBS                         Upper Rng Batch
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DURBS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0022            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0023           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0024            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0025            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0026           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0027           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0028            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DURBS                 90      Upper Rng Batch
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVEL     #1PRWT        #DPWTS                         Processg Wait T
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DPWTS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0029            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0030           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0031            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0032            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0033           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0034           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0035            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
     C                   Z-ADD     2             YRSW03
     C                   Z-ADD     15            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DPWTS                 90      Processg Wait T
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
      *                                                                                       CTI003
     C                   MOVEL     #1NOSM        #DNOSM                         No. of SWIFT message
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DNOSM        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT                                                                   CTI003
      * ZALIGN Screen Field - Standard Functions  *                                           CTI003
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0002           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0003            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0004            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0005           16            ZALIGN File Fie
      *                                                                                       CTI003
     C     *IN90         IFEQ      '1'
      * Call to program ended in error                                                        CTI003
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'                                              CTI003
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CTI003
      * Error detected?                                                                       CTI003
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error                                             CTI003
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE                                                                      CTI003
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *                                            CTI003
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0006           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0007            1 0          ZALIGN No Of De
      *                                                                                       CTI003
     C     *IN90         IFEQ      '1'
      * Call to program ended in error                                                        CTI003
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'                                              CTI003
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CTI003
     C                   END                                                    *FI
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DNOSM                 90      No. of SWIFT message
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
      * 00/Copy Member SD9441RISE - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RISE
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
      * 00/Copy Member SD9441RVKS - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RVKS
      * Midas/TI Interface Key required
     C     #1INKY        IFEQ      *BLANK                                       IF
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
      * Bypass Key screen if F12 is pressed on detail screen
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      * 00/Copy Member SD9441RPKR - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RPKR
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
      * Validate details
     C                   EXSR      DCVLDL
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
      ** Skip other valildations when CTI006 is enabled                                       CTI006
      *                                                                                       CTI006
     C     CTI006        IFNE      'Y'
      * Validate Retail Account Sts Check
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1REAS        W0NSRQ            1            Retail Account
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1213063       Y2LSNO            7 0
     C     #1REAS        PARM      #1REAS        W0EXVL           20            Retail Account
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      **Validate*Continue*COB*if*No*Link                                                      CTI003
     C***********          MOVEL*BLANK    W0RTN                                               CTI003
     C***********          MOVEL#1CMNL    W0NSRQ  1        Continue COB if                    CTI003
      **Name*search*required?                                                                 CTI003
     C***********W0NSRQ    IFEQ '?'                                                           CTI003
     C***********          CALL 'Y2VLLSR'              90  *                                  CTI003
     C***********          PARM           W0RTN   7                                           CTI003
     C***********          PARM 1213065   Y2LSNO  70                                          CTI003
     C***********#1CMNL    PARM #1CMNL    W0EXVL 20        Continue COB if                    CTI003
      **Defer*confirm*                                                                        CTI003
     C***********          MOVEL'Y'       W0DCF   1                                           CTI003
     C***********          END                                                                CTI003
      *
      * USER: Validate detail screen fields
      * Validate Branch Code
      * CASE: DTL.Branch is Blank
     C     #1BRCH        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1BRCH        ZA0001                         Branch
      * Send message 'TI Branch Blank'
     C                   MOVEL     'USR3515'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1BRCH        WUQMEN                         question mark e
      * Question mark processing
      * CASE: WRK.question mark entered is Question mark
     C     WUQMEN        IFEQ      '?'                                          *IF
      * Select Branch Codes - Branch Codes  *
     C                   CALL      'SD0061S'                            90      Select Branch C
     C                   PARM      *BLANK        W0RTN             7
     C     #1BRCH        PARM      #1BRCH        WQ0037            3            Branch code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0061S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9931      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Exist of branch cd - Branch Codes  *
     C                   EXSR      SARVGN
      * Check record exists flag
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1BRCH        ZA0002                         Branch
      * Send message 'TI Branch not on SDBRCHPD'
     C                   MOVEL     'USR3516'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Department
      * CASE: DTL.Department is Blank
     C     #1DEPT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DEPT        ZA0003                         Department
      * Send message 'TI Dept Blank'
     C                   MOVEL     'USR3517'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1DEPT        WUQMEN                         question mark e
      * Question mark processing
      * CASE: WRK.question mark entered is Question mark
     C     WUQMEN        IFEQ      '?'                                          *IF
      * Select Department Codes - Department Codes  *
     C                   CALL      'SD0121S'                            90      Select Departme
     C                   PARM      *BLANK        W0RTN             7
     C     #1DEPT        PARM      #1DEPT        WQ0038            3            Dept Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0121S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9932      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Existance Of Dept - Department Codes  *
     C                   EXSR      SBRVGN
      * Check record exists flag
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1DEPT        ZA0004                         Department
      * Send message 'TI Dept not on Dept File'
     C                   MOVEL     'USR3518'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C* Only validate the Transaction Type if Retail module is on....     130055
     C     *IN78         IFEQ      *ON                                                         13005
      * Validate Transaction Type
      * CASE: DTL.Transaction Type (TI) is Blank
     C     #1TRTP        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1TRTP        ZA0005                         Transaction Typ
      * Send message 'TI Transaction Type blank'
     C                   MOVEL     'USR3521'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1TRTP        WUQMEN                         question mark e
      * Question mark processing
      * CASE: WRK.question mark entered is Question mark
     C     WUQMEN        IFEQ      '?'                                          *IF
      * Select Retail Transaction - Retail Transaction Types  *
     C                   CALL      'SD0130S'                            90      Select Retail T
     C                   PARM      *BLANK        W0RTN             7
     C     #1TRTP        PARM      #1TRTP        WQ0039            5            Retail Transact
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
     C                   SETON                                        9933      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Rcd & get CR/DB Ind - Retail Transaction Types  *
     C                   EXSR      SCRVGN
      * Check record exists flag
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1TRTP        ZA0006                         Transaction Typ
      * Send message 'TI Transaction Type inval'
     C                   MOVEL     'USR3519'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ENDIF                                                                 13005
     C                   ENDIF
      *                                                                                       CTI006
      * Validate Profit Centre if profit centres are used
      * CASE: WRK.Profit Centres Used is Yes
     C     WUPRCU        IFEQ      'Y'                                          *IF
      * Validate Profit Centre
      * CASE: DTL.Profit centre code  MIDAS is Blank
     C     #1PRFC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1PRFC        ZA0007                         Profit centre c
      * Send message 'TI Prof Centre blank'
     C                   MOVEL     'USR3522'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1PRFC        WUQMEN                         question mark e
      * Question mark processing
      * CASE: WRK.question mark entered is Question mark
     C     WUQMEN        IFEQ      '?'                                          *IF
      * Select Profit Centres - Profit Centres  *
     C                   CALL      'SD0480S'                            90      Select Profit C
     C                   PARM      *BLANK        W0RTN             7
     C     #1PRFC        PARM      #1PRFC        WQ0040            4            Profit Centre C
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0480S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9934      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Retrieve Profit Descr. - Profit Centres  *
     C                   EXSR      SDRVGN
      * Check record exists flag
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1PRFC        ZA0008                         Profit centre c
      * Send message 'TI Profit Centre Invalid'
     C                   MOVEL     'USR3520'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Book
      * CASE: DTL.Book is Blank
     C     #1BOOK        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1BOOK        ZA0009                         Book
      * Send message 'TI Book blank'
     C                   MOVEL     'USR3523'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     #1BOOK        WUQMEN                         question mark e
      * Question mark processing
      * CASE: WRK.question mark entered is Question mark
     C     WUQMEN        IFEQ      '?'                                          *IF
      * Select Book Details - Book Details  *
     C                   CALL      'SD0310S'                            90      Select Book Det
     C                   PARM      *BLANK        W0RTN             7
     C     #1BOOK        PARM      #1BOOK        WQ0041            2            Book Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0310S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9935      *
     C                   END
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
      * Check Existance Of Book. - Book Details  *
     C                   EXSR      SERVGN
      * Check record exists flag
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1BOOK        ZA0010                         Book
      * Send message 'TI Book invalid'
     C                   MOVEL     'USR3524'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *                                                                                       CTI006
      ** Skip other validations when CTI006 is enabled                                        CTI006
     C     CTI006        IFNE      'Y'
      * Validate Minimum Batch Size
      * CASE: DTL.Minimum Batch Size (scrn) is Blank
     C     #DMBSS        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DMBSS        ZA0011                         Minimum Batch S
      * Send message 'Min Batch Size invalid'
     C                   MOVEL     'USR3525'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DMBSS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0042            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0043           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0044            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0045            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0046           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0047           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0048            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DMBSS        ZA0012                         Minimum Batch S
      * Send message 'Min Batch Size invalid'
     C                   MOVEL     'USR3525'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DMBSS                 90      Minimum Batch S
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVE      WUZAFF        #1MNBS                         Minimum Batch S
      * Is Minimum Batch Size value between 0 and 999 ?
      * CASE: DTL.Minimum Batch Size is Valid Range
     C     #1MNBS        IFGE      *ZERO                                        *IF
     C     #1MNBS        ANDLE     999
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DMBSS        ZA0013                         Minimum Batch S
      * Send message 'Min Batch Size invalid'
     C                   MOVEL     'USR3525'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Maximum Batch Size
      * CASE: DTL.Maximum Batch Size (Scrn) is Blank
     C     #DMAXS        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DMAXS        ZA0014                         Maximum Batch S
      * Send message 'Max Batch Size invalid'
     C                   MOVEL     'USR3526'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DMAXS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0049            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0050           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0051            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0052            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0053           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0054           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0055            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DMAXS        ZA0015                         Maximum Batch S
      * Send message 'Max Batch Size invalid'
     C                   MOVEL     'USR3526'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DMAXS                 90      Maximum Batch S
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVE      WUZAFF        #1MXBS                         Maximum Batch S
      * Is Maximum Batch Size value between 0 and 999 ?
      * CASE: DTL.Maximum Batch Size is Valid Range
     C     #1MXBS        IFGE      *ZERO                                        *IF
     C     #1MXBS        ANDLE     999
      * Max Batch Size > Min Batch Size ?
      * CASE: DTL.Maximum Batch Size LE DTL.Minimum Batch Size
     C     #1MXBS        IFLE      #1MNBS                                       *IF
      * Setup message data for message
     C                   MOVEL     #DMAXS        ZA0016                         Maximum Batch S
      * Send message 'Max Batch Size too small'
     C                   MOVEL     'USR3527'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DMAXS        ZA0017                         Maximum Batch S
      * Send message 'Max Batch Size invalid'
     C                   MOVEL     'USR3526'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Lower Range Batch Number
      * CASE: DTL.Lower Rng Batch Nbr (scr) is Blank
     C     #DLRBS        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DLRBS        ZA0018                         Lower Rng Batch
      * Send message 'Lower Rng Batch Size invd'
     C                   MOVEL     'USR3528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DLRBS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0056            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0057           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0058            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0059            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0060           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0061           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0062            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DLRBS        ZA0019                         Lower Rng Batch
      * Send message 'Lower Rng Batch Size invd'
     C                   MOVEL     'USR3528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DLRBS                 90      Lower Rng Batch
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVE      WUZAFF        #1LRBN                         Lower Range Bat
      * Is Lower Range Batch Number between 0 and 999 ?
      * CASE: DTL.Lower Range Batch Number is Valid Range
     C*                                                                   156783
     C* Additionally make sure that batch numbers do not fall in range    156783
     C* 900 to 999 if switchbale feature S01492 is on as this range       156783
     C* reserved for LEO.                                                 156783
     C*
     C* Make sure lower range correct.                                    156783
     C*
     C     S01492        IFEQ      'Y'                                                         15678
     C                   Z-ADD     899           LOWRAN            3 0                         15678
     C                   ELSE                                                                  15678
     C                   Z-ADD     999           LOWRAN                                        15678
     C                   END                                                                   15678
     C*
     C     #1LRBN        IFGE      *ZERO                                        *IF
     C********** #1LRBN    ANDLE999                                       156783
     C     #1LRBN        ANDLE     LOWRAN                                                      15678
     C*                                                                   156783
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DLRBS        ZA0020                         Lower Rng Batch
      * Send message 'Lower Rng Batch Size invd'
     C                   MOVEL     'USR3528'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Upper Range Batch Number
      * CASE: DTL.Upper Rng Batch Nbr (scr) is Blank
     C* Additionally make sure that batch numbers do not fall in range    156783
     C* 900 to 999 if switchbale feature S01492 is on as this range       156783
     C* reserved for LEO.                                                 156783
     C*                                                                   156783
     C     S01492        IFEQ      'Y'                                                         15678
     C                   Z-ADD     899           HGHRAN            3 0                         15678
     C                   ELSE                                                                  15678
     C                   Z-ADD     999           HGHRAN                                        15678
     C                   END                                                                   15678
     C*                                                                   156783
     C* MAKE #DURBS NUMERIC FURTHER CHECKS REQUIRED.                      156783
     C*                                                                   156783
     C                   MOVEL     #DURBS        HIGHSC            3 0                         15678
     C*                                                                   156783
     C***********#DURBS    IFEQ *BLANK                     *IF            156783
     C     HIGHSC        IFGT      HGHRAN                                                      15678
     C     HIGHSC        ORLT      #1LRBN                                                      15678
     C*                                                                   156783
      * Setup message data for message
     C                   MOVEL     #DURBS        ZA0021                         Upper Rng Batch
      * Send message 'Upper Rng Batch Size invd'
     C                   MOVEL     'USR3529'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DURBS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0063            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0064           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0065            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0066            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0067           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0068           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0069            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DURBS        ZA0022                         Upper Rng Batch
      * Send message 'Upper Rng Batch Size invd'
     C                   MOVEL     'USR3529'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DURBS                 90      Upper Rng Batch
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVE      WUZAFF        #1URBN                         Upper Range Bat
      * Upper Range Batch Number > Lower Range Batch Number ?
      * CASE: DTL.Upper Range Batch Number LE DTL.Lower Range Batch Numbe
     C     #1URBN        IFLE      #1LRBN                                       *IF
      * Setup message data for message
     C                   MOVEL     #DURBS        ZA0023                         Upper Rng Batch
      * Send message 'Upper Rng Batch Size invd'
     C                   MOVEL     'USR3529'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ENDIF
      *                                                                                       CTI004
      ** Validate TI FX Deal Sub-type                                                         CTI004
      ** CASE: Default to 'TF' if blank                                                       CTI004
      *                                                                                       CTI004
     C     #DDLSS        IFEQ      *BLANKS
     C                   MOVEL     'TF'          #DDLSS
     C                   ELSE
      *                                                                                       CTI004
      ** CASE: *OTHERWISE                                                                     CTI004
      *                                                                                       CTI004
     C     #DDLSS        CHAIN     SDDLSTL0                           90
     C     *IN90         IFEQ      *ON
      *                                                                                       CTI004
      ** Setup message data for message                                                       CTI004
      *                                                                                       CTI004
     C                   MOVEL     #DDLSS        ZA0031
      *                                                                                       CTI004
      ** Send message 'TI FX Deal Sub-type invd'                                              CTI004
      *                                                                                       CTI004
     C                   MOVEL     'USR4178'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9948
      *                                                                                       CTI004
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CTI006
      ** Skip other validations when CTI006 is enabled                                        CTI006
      *                                                                                       CTI006
     C     CTI006        IFNE      'Y'
      *                                                                                      BUG3130
      ** Validate SWIFT Address Code                                                         BUG3130
      *                                                                                      BUG3130
     C     #DSWAD        LOOKUP    ALPHB                                  90
      *                                                                                      BUG3130
     C     *IN90         IFEQ      *OFF
      *                                                                                      BUG3130
      ** Setup message data for message                                                      BUG3130
      *                                                                                      BUG3130
     C                   MOVEL     #DSWAD        ZA0032
      *                                                                                      BUG3130
      ** Send message 'SWIFT Address Code invd'                                              BUG3130
      *                                                                                      BUG3130
     C                   MOVEL     'USR4179'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9949
      *                                                                                      BUG3130
     C                   ENDIF
      *                                                                                      BUG3130
      ** Validate Alternate Prime Address                                                    BUG3130
      *                                                                                      BUG3130
     C     #DADCD        LOOKUP    ALPHB                                  90
      *                                                                                      BUG3130
     C     *IN90         IFEQ      *OFF
      *                                                                                      BUG3130
      ** Setup message data for message                                                      BUG3130
      *                                                                                      BUG3130
     C                   MOVEL     #DADCD        ZA0033
      *                                                                                      BUG3130
      ** Send message 'Alternate Prime Address'                                              BUG3130
      *                                                                                      BUG3130
     C                   MOVEL     'USR4180'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9950
      *                                                                                      BUG3130
     C                   ENDIF
      * Validate Retail Account Status Check
      * CASE: DTL.Retail Account Sts Check is Valid Values
     C     #1REAS        IFEQ      'N'                                          *IF
     C     #1REAS        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1REAS        ZA0024                         Retail Account
      * Send message 'RE Account Sts Check invd'
     C                   MOVEL     'USR3531'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   END                                                    *FI
      * Validate Processing Wait Time
      * CASE: DTL.Processg Wait Time (Scrn) is Blank
     C     #DPWTS        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DPWTS        ZA0025                         Processg Wait T
      * Send message 'Processing Wait Time invd'
     C                   MOVEL     'USR3532'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DPWTS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard Functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0070            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0071           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0072            1 0          ZALIGN No Of De
     C                   PARM      2             WQ0073            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0074           16            ZALIGN File Fie
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
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
      * CASE: PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0075           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0076            1 0          ZALIGN No Of De
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DPWTS        ZA0026                         Processg Wait T
      * Send message 'Processing Wait Time invd'
     C                   MOVEL     'USR3532'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   Z-ADD     2             YRSW03
     C                   Z-ADD     15            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DPWTS                 90      Processg Wait T
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVE      WUZAFF        #1PRWT                         Processing Wait
      * Is Processing Wait Time between 1 and 99 ?
      * CASE: DTL.Processing Wait Time is Valid Range
     C     #1PRWT        IFGE      1                                            *IF
     C     #1PRWT        ANDLE     99
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DPWTS        ZA0027                         Processg Wait T
      * Send message 'Processing Wait Time invd'
     C                   MOVEL     'USR3532'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      **Validate*Continue*Midas*COB*if*No*Link                                                CTI003
      **CASE:*DTL.Continue*COB*if*No*Link*is*Valid*values                                     CTI003
     C***********#1CMNL    IFEQ 'Y'                        *IF                                CTI003
     C***********#1CMNL    OREQ 'N'                                                           CTI003
     C***********          ELSE                                                               CTI003
      **CASE:**OTHERWISE                                                                      CTI003
      **Setup*message*data*for*message                                                        CTI003
     C***********          MOVEL#1CMNL    ZA0028           Continue COB if                    CTI003
      **Send*message*'Cont*COB*No*Link*invalid'                                               CTI003
     C***********          MOVEL'USR3533' ZAMSID                                              CTI003
     C***********          EXSR ZASNMS                                                        CTI003
     C***********          SETON                     9942  *                                  CTI003
      ***********                                                                             CTI003
     C***********          END                             *FI                                CTI003
      *                                                                                       CTI099
      * Validation for TI Account Type                                                        CTI099
     C     #1ATYP        IFEQ      *BLANK
     C                   MOVEL     #1ATYP        ZA0010
     C                   MOVEL     'USR3647'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943
      *                                                                                       CTI099
     C                   ELSE
      * Question mark processing                                                              CTI099
     C     #1ATYP        IFEQ      '?'
     C                   CALL      'SD0035S'                            90
     C                   PARM      *BLANK        W0RTN
     C     #1ATYP        PARM      #1ATYP        SATYP             2
      * If  system error on call                                                              CTI099
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'SD0035S'     W0CLPG
      * Send message '*Error occured on CALL...'                                              CTI099
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      * If error code returned from call                                                      CTI099
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9943
     C                   END
     C                   MOVEL     'Y'           W0DCF                                      rm
     C                   ELSE
      * Check that TI Account Type exists                                                     CTI099
     C                   CALL      'AOTIACR0'                                                  15678
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1ATYP        KC5AT             2
     C     SDTIAC        PARM      SDTIAC        DSFDY
      * If return code not blank report error                                                 CTI099
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     #1ATYP        ZA0010
     C                   MOVEL     'USR3645'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
     C                   ENDIF
      *                                                                                       CTI099
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CTI099
      * Validate SP101 Basic Number                                                           CTI099
     C     #1BCNO        IFEQ      *BLANK
     C                   MOVEL     #1BCNO        ZA0018
     C                   MOVEL     'USR3646'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944
      *                                                                                       CTI099
     C                   ELSE
      *                                                                                       CTI099
      * Is SP101 Basic Number between 0 and 999 ?                                             CTI099
     C     #1BCNO        IFLE      '000'
     C     #1BCNO        ORGT      '999'
      * CASE: *OTHERWISE                                                                      CTI099
      * Setup message data for message                                                        CTI099
     C                   MOVEL     #1BCNO        ZA0020
     C                   MOVEL     'USR3646'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944
      *                                                                                       CTI099
     C                   END
     C                   END
      *                                                                                       CTI099
      * If Basic Number is OK then write to TI Account Type file                              CTI099
     C     *IN44         IFEQ      *OFF
     C**********         OPEN      SDTIACL0                                                 MD058085
     C***********TIATYP    CHAIN@TIACL0              1515                              CTI099 167480
     C*****#1ATYP        CHAIN     @TIACL0                            1515
     C/EXEC SQL                                                                             MD058085
     C+ update SDTIAXTD set                                                                 MD058085
     C+   GDBCNO = :GDBCNO                                                                  MD058085
     C+ where GDC5AT = :#1ATYP                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       15                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        15                    MD058085
     C                   ENDIF                                                              MD058085
     C     *IN15         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ELSE
     C**********         MOVEL     TIBCNO        GDBCNO                                     MD058085
     C**********         UPDATE    @TIACL0                                                  MD058085
     C**********         CLOSE     SDTIACL0                                                 MD058085
     C                   ENDIF
      *                                                                                       CTI099
     C                   ENDIF
      * Validate Use Midas Customer Number                                                    167480
      * CASE: DTL.Use Midas Customer Number is Valid Values                                   167480
     C     #1CUSN        IFEQ      'Y'                                          *IF
     C     #1CUSN        OREQ      'N'
     C                   ELSE
      * CASE: *OTHERWISE                                                                      167480
      * Setup message data for message                                                        167480
     C                   MOVEL     #1CUSN        ZA0029                         Midas Cust No
      * Send message 'Cont COB No Link invalid'                                               167480
     C                   MOVEL     'USR3700'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9945      *
      *                                                                                       167480
     C                   ENDIF                                                  *FI
      * Validate No. of SWIFT messages                                                        CTI003
      * CASE:  No. of SWIFT messages (scrn) is Blank                                          CTI003
     C     #DNOSM        IFEQ      *BLANK                                       *IF
      * Setup message data for message                                                        CTI003
     C                   MOVEL     #DNOSM        ZA0011                         No. of SWIFT message
      * Send message 'No. of SWIFT messages is invalid'                                       CTI003
     C                   MOVEL     'USR9109'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *                                                                                       CTI003
     C                   ELSE
      * CASE: *OTHERWISE                                                                      CTI003
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DNOSM        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT                                                                   CTI003
      * ZALIGN Screen Field - Standard Functions  *                                           CTI003
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0042            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0043           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0044            1 0          ZALIGN No Of De
     C                   PARM      3             WQ0045            2 0          ZALIGN No Of Di
     C     WUZAFF        PARM      *BLANK        WQ0046           16            ZALIGN File Fie
      *                                                                                       CTI003
     C     *IN90         IFEQ      '1'
      * Call to program ended in error                                                        CTI003
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZALIGN'      W0CLPG
      * Send message '*Error occured on CALL...'                                              CTI003
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CTI003
      * Error detected?                                                                       CTI003
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      * CASE: PGM.*Return code is Old Table Error                                             CTI003
     C     W0RTN         IFEQ      '*ERROR*'                                    *IF
     C                   MOVEL     'Y'           WUERCD                         Err Code
     C                   ELSE
      * CASE: *OTHERWISE                                                                      CTI003
     C                   MOVEL     'N'           WUERCD                         Err Code
      * ZEDIT Screen Field - Standard Functions  *                                            CTI003
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0047           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0048            1 0          ZALIGN No Of De
      *                                                                                       CTI003
     C     *IN90         IFEQ      '1'
      * Call to program ended in error                                                        CTI003
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'ZEDIT'       W0CLPG
      * Send message '*Error occured on CALL...'                                              CTI003
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *                                                                                       CTI003
     C                   END                                                    *FI
      * CASE: WRK.Err Code is Error Found                                                     CTI003
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message                                                        CTI003
     C                   MOVEL     #DNOSM        ZA0012                         No. of SWIFT message
      * Send message 'No. of SWIFT messages is invalid'                                       CTI003
     C                   MOVEL     'USR9109'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *                                                                                       CTI003
     C                   ELSE
      * CASE: *OTHERWISE                                                                      CTI003
     C                   Z-ADD     3             YRSW03
     C                   Z-ADD     14            ZQ                5 0
     C     YRSW03        IFLT      1
     C     ZQ            ORLT      1
     C     YRSW03        ORGT      00016
     C     ZQ            ORGT      00016
     C                   MOVEL     'Y2U0510'     W0RTN
     C                   ELSE
     C     YRSW03        SUBST(P)  WUZASF:ZQ     #DNOSM                 90      No. of SWIFT message
     C   90              MOVEL     'Y2U0510'     W0RTN
     C                   END
     C                   MOVE      WUZAFF        #1NOSM                         No. of SWIFT message
      * Is 'No. of SWIFT messages' value between 1 and 999 ?                                  CTI003
     C     #1NOSM        IFGT      *ZERO                                        *IF
     C     #1NOSM        ANDLE     999
     C                   ELSE
      * CASE: *OTHERWISE                                                                      CTI003
      * Setup message data for message                                                        CTI003
     C                   MOVEL     #DNOSM        ZA0013                         No. of SWIFT message
      * Send message 'No. of SWIFT messages' is invalid                                       CTI003
     C                   MOVEL     'USR9109'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *                                                                                       CTI003
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate Accruals check by branch                                                     CTI003
     C     #1ACBB        IFEQ      'Y'                                          *IF
     C     #1ACBB        OREQ      'N'
     C                   ELSE
      * Setup message data for message                                                        CTI003
     C                   MOVEL     #1ACBB        ZA0028                         Accruals check by br
      * Send message 'Accruals check by branch must be "N" or "Y"                             CTI003
     C                   MOVEL     'USR9110'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9946      *
      *                                                                                       CTI003
     C                   END                                                    *FI
     C                   ENDIF
      *                                                                                       CTI003
      * Validate balancing account code                                                       CTI003
      * An account code must be entered                                                       CTI003
     C     #1BALA        IFEQ      *BLANKS                                      *IF
     C                   MOVEL     'USR9111'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9947      *
     C                   ELSE
      * Question mark processing                                                              CTI003
     C     #1BALA        IFEQ      '?   '
     C     #1BALA        OREQ      ' ?  '
     C     #1BALA        OREQ      '  ? '
     C     #1BALA        OREQ      '   ?'
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C********** #1BALA    PARM #1BALA    WQ0078  4        Account Code                CTI003 CGL029
     C     #1BALA        PARM      #1BALA        WQ0078           10
     C     *IN90         IFEQ      '1'
      * Call to program ended in error                                                        CTI003
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0031S'     W0CLPG
      * Send message '*Error occured on CALL...'                                              CTI003
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
      * Check that account code exists                                                        CTI003
     C                   CALL      'AOACODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    #1BALA
     C     SDACOD        PARM      *BLANKS       DSSDY
      *                                                                                       CTI003
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   MOVEL     'USR0069'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9947      *
     C                   END
     C                   ENDIF
     C                   ENDIF
      * 00/Copy Member SD9441RVSF - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RVSF
      * CALC: Detail screen function fields
      * 00/Copy Member SD9441RSFF - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RSFF
      * USER: Validate detail screen relations
      * 00/Copy Member SD9441RVSR - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RVSR
      * Is Maximum Batch Size 30 more than minimum?                                           CTI003
     C     CTI006        IFNE      'Y'
     C     #1MNBS        ADD       30            W#MAX
     C     #1MXBS        IFLT      W#MAX
      * Setup message data for message                                                        CTI003
     C                   MOVEL     #DMAXS        ZA0030                         Maximum Batch S
      * Send message 'Max Batch Size must be 30 more than Min'                                CTI003
     C                   MOVEL     'USR3950'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *                                                                                       CTI003
     C                   END                                                    *FI
     C                   ENDIF
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
      * 00/Copy Member SD9441RVSR - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RVSR
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
      * Change Midas/TI Interface - Midas/TI Interface ICD  *
     C                   EXSR      SFCHRC
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
     C     P1INKY        IFEQ      *BLANK                                       Midas/TI Interf
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
     C     WUPRCU        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
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
     C                   MOVEL     P3WRTC        #PWRTC                         Work Return cod
     C                   Z-ADD     *ZERO         #1MNBS                         Minimum Batch S
     C                   Z-ADD     *ZERO         #1MXBS                         Maximum Batch S
     C                   Z-ADD     *ZERO         #1LRBN                         Lower Range Bat
     C                   Z-ADD     *ZERO         #1URBN                         Upper Range Bat
     C                   Z-ADD     *ZERO         #1PRWT                         Processing Wait
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1BRCH                         Branch
     C                   MOVEL     *BLANK        #1DEPT                         Department
     C                   MOVEL     *BLANK        #1TRTP                         Transaction Typ
     C                   MOVEL     *BLANK        #1PRFC                         Profit centre c
     C                   MOVEL     *BLANK        #1BOOK                         Book
     C                   MOVEL     *BLANK        #DMBSS                         Minimum Batch S
     C                   MOVEL     *BLANK        #DMAXS                         Maximum Batch S
     C                   MOVEL     *BLANK        #DLRBS                         Lower Rng Batch
     C                   MOVEL     *BLANK        #DURBS                         Upper Rng Batch
     C                   MOVEL     *BLANK        #1REAS                         Retail Account
     C                   MOVEL     *BLANK        #DPWTS                         Processg Wait T
     C***********          MOVEL*BLANK    #1CMNL           Continue COB if                    CTI003
     C                   MOVEL     *BLANK        #1ATYP                         TI Account Type
     C                   MOVEL     *BLANKS       #1BCNO                         SP101 Basic Number
     C                   MOVEL     *BLANK        #1CUSN                         Midas Cust No
     C                   Z-ADD     *ZERO         #1NOSM                         No. of SWIFT message
     C                   MOVEL     *BLANK        #1ACBB                         Accruals check by br
     C                   MOVEL     *BLANK        #1BALA                         Balancing account co
     C                   MOVEL     *BLANK        #DDLSS
     C                   MOVEL     *BLANK        #DSWAD
     C                   MOVEL     *BLANK        #DADCD
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @TIINL1 fields to screen
      *================================================================
     C                   MOVEL     TIINKY        #1INKY                         Midas/TI Interf
     C                   Z-ADD     TIMNBS        #1MNBS                         Minimum Batch S
     C                   Z-ADD     TIMXBS        #1MXBS                         Maximum Batch S
     C                   Z-ADD     TILRBN        #1LRBN                         Lower Range Bat
     C                   Z-ADD     TIURBN        #1URBN                         Upper Range Bat
     C                   Z-ADD     TIPRWT        #1PRWT                         Processing Wait
     C                   MOVEL     TITYLC        #1TYLC                         Type of Last Ch
     C                   Z-ADD     TILCD         #1LCD                          Last Change Dat
     C                   MOVEL     TIBRCH        #1BRCH                         Branch
     C                   MOVEL     TIDEPT        #1DEPT                         Department
     C                   MOVEL     TITRTP        #1TRTP                         Transaction Typ
     C                   MOVEL     TIPRFC        #1PRFC                         Profit centre c
     C                   MOVEL     TIBOOK        #1BOOK                         Book
     C                   MOVEL     TIREAS        #1REAS                         Retail Account
     C***********          MOVELTICMNL    #1CMNL           Continue COB if                    CTI003
     C                   MOVEL     TIATYP        #1ATYP                         TI Account Type
     C                   MOVEL     TIBCNO        #1BCNO                         SP101 Basic Number
     C                   MOVEL     TICUSN        #1CUSN                         Midas Cust No
     C***********          MOVELTICMNL    #1CMNL           Continue COB if             167480 CTI003
     C                   Z-ADD     TINOSM        #1NOSM                         No. of SWIFT message
     C                   MOVEL     TIACBB        #1ACBB                         Accruals check by br
     C                   MOVEL     TIBALA        #1BALA                         Balancing account co
     C                   MOVEL     TIDLST        #DDLSS
     C                   MOVEL     TISWAD        #DSWAD
     C                   MOVEL     TIADCD        #DADCD
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRC
      * Initialize work field for batch size                                                  CTI003
     C                   Z-ADD     *ZERO         W#MAX             4 0
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P3WRTC        #PWRTC                         Work Return cod
     C                   MOVEL     P1INKY        #1INKY                         Midas/TI Interf
      * USER: Initialize key screen
      * 00/Copy Member SD9441RIKS - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Check Exist of branch cd - Branch Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    A8BRCD                         Branch code
      * Move fields to key list
     C                   MOVEL     #1BRCH        A8BRCD                         Branch code
     C     KRSSA         CHAIN     @A8REB0                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0075'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Check Existance Of Dept - Department Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    AEDPCD                         Dept Code
      * Move fields to key list
     C                   MOVEL     #1DEPT        AEDPCD                         Dept Code
     C     KRSSB         CHAIN     @AECPAN                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0013'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
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
     C                   MOVEL     #1TRTP        A1RTTY                         Retail Transact
     C*****KRSSC         CHAIN     @A1RECX                            90        *           MD058755
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
      * Retrieve Profit Descr. - Profit Centres  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSD         KLIST
     C                   KFLD                    DSPCCD                         Profit Centre C
      * Move fields to key list
     C                   MOVEL     #1PRFC        DSPCCD                         Profit Centre C
     C     KRSSD         CHAIN     @DSREHC                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0647'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     DSPCDS        WUPCDS                         Profit Centre D
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SERVGN        BEGSR
      *================================================================
      * Check Existance Of Book. - Book Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSE         KLIST
     C                   KFLD                    BDBKCD                         Book Code
      * Move fields to key list
     C                   MOVEL     #1BOOK        BDBKCD                         Book Code
     C     KRSSE         CHAIN     @BDREDK                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0085'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Midas/TI Interface - Midas/TI Interface ICD  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @TIINL0
     C                   MOVE      *BLANK        TIINKY                         Midas/TI Interf
     C                   MOVEL     'TIIN'        TIINKY                         Midas/TI Interf
      *
     C     KLCHSF        KLIST
     C                   KFLD                    TIINKY                         Midas/TI Interf
     C     KLCHSF        CHAIN     @TIINL0                            9091      *
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
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C                   UNLOCK    SDTIINL0                             91      *
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C**********           MOVE @1DBRC    YARDCS                                              CGL029
     C                   MOVEL     @1DBRC        YARDCS
      * USER: Processing after Data read
      * Save last change date for record
     C                   Z-ADD     TILCD         WULCD                          Last Change Dat
      * Move non-key fields to @TIINL0
     C                   MOVEL     #1BRCH        TIBRCH                         Branch
     C                   MOVEL     #1DEPT        TIDEPT                         Department
     C                   MOVEL     #1TRTP        TITRTP                         Transaction Typ
     C                   MOVEL     #1PRFC        TIPRFC                         Profit centre c
     C                   MOVEL     #1BOOK        TIBOOK                         Book
     C                   Z-ADD     #1MNBS        TIMNBS                         Minimum Batch S
     C                   Z-ADD     #1MXBS        TIMXBS                         Maximum Batch S
     C                   Z-ADD     #1LRBN        TILRBN                         Lower Range Bat
     C                   Z-ADD     #1URBN        TIURBN                         Upper Range Bat
     C                   MOVEL     #1REAS        TIREAS                         Retail Account
     C                   Z-ADD     #1PRWT        TIPRWT                         Processing Wait
     C***********          MOVEL#1CMNL    TICMNL           Continue COB if                    CTI003
     C                   MOVEL     #1ATYP        TIATYP                         TI Account Type
     C                   MOVEL     #1BCNO        TIBCNO                         SP101 Basic Number
     C                   Z-ADD     #1NOSM        TINOSM                         No. of SWIFT message
     C                   MOVEL     #1ACBB        TIACBB                         Accruals check by br
     C                   MOVEL     #1BALA        TIBALA                         Balancing account co
     C                   MOVEL     #DDLSS        TIDLST
     C                   MOVEL     #DSWAD        TISWAD
     C                   MOVEL     #DADCD        TIADCD
     C                   Z-ADD     WULCD         TILCD                          Last Change Dat
     C                   MOVEL     'A'           TITYLC                         Type of Last Ch
     C                   MOVEL     #1CUSN        TICUSN                         Midas Cust No
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * USER: Processing before Data update
      * Window processing
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
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD9441RBUW - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RBUW
     C                   END                                                    *FI
      * 00/Copy Member SD9441RBDU - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RBDU
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    @TIINL0                              91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDTIINL0                             91      *
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
      * Update file controls
      * CASE: WRK.Last Change Date NE WRK.Run day number
     C     WULCD         IFNE      WURDNB                                       *IF
      * Update only if file has not already been updated
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SGCHRC
     C                   END                                                    *FI
      * 00/Copy Member SD9441RADU - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RADU
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGCHRC        BEGSR
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
     C     KLCHSG        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSG        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SGEXIT
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
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSH         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSH         CHAIN     @BGREC8                            90        *
      * Data record not found
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUWDPR                         Window processi
     C                   END                                                    *FI
     C*                                                                   130055
     C* If Retail Module is on then seton *IN78                           130055
     C*                                                                   130055
     C     BGRTBN        IFEQ      'Y'                                                         13005
     C                   MOVE      *ON           *IN78                                         13005
     C                   ENDIF                                                                 13005
     C*                                                                   130055
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Check Profit Centres Used - General Ledger Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    BKGNLG                         General Ledger
      * Move fields to key list
     C                   MOVE      *BLANK        BKGNLG                         General Ledger
     C                   MOVEL     'GELR'        BKGNLG                         General Ledger
     C     KRSSI         CHAIN     @BKREEC                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0199'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SIEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C     CTI006        IFEQ      'Y'
     C                   MOVEL     'Y'           WUPRCU
     C                   ELSE
     C                   MOVEL     BKPRCU        WUPRCU                         Profit Centres
     C                   ENDIF
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1INKY        WK1X01            1
     C     WK1X01        IFEQ      '?'                                          Midas/TI Interf
     C                   CALL      'SDUESRR'                            90      Select Midas/TI
     C                   PARM      *BLANK        W0RTN             7
     C     #1INKY        PARM      #1INKY        WQ0036           10            Midas/TI Interf
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDUESRR'     W0CLPG
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
     C                   PARM      'SDU8E1R'     W0HPMB           10            Help text sourc
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
      * 00/Copy Member SD9441RVSR - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RVSR
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
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field question mark entered
     C                   MOVEL     *BLANK        WUQMEN            1
      * Define work field Debit/Credit Indicator
     C                   MOVEL     *BLANK        WUDCIN            1
      * Define work field Profit Centres Used
     C                   MOVEL     *BLANK        WUPRCU            1
      * Define work field Profit Centre Description
     C                   MOVEL     *BLANK        WUPCDS           30
      * Define work field Last Change Date
     C                   Z-ADD     *ZERO         WULCD             5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
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
     C                   Z-ADD     *ZEROS        YRSW00            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW01            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW02            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW03            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW04            5 0          *Synon (5,0) wo
     C                   Z-ADD     *ZEROS        YRSW05            5 0          *Synon (5,0) wo
     C                   MOVEL     *BLANKS       YRSW06            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW07            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW08            7            *Return code
     C                   MOVEL     *BLANKS       YRSW09            1            *String work fi
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0A                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0B                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0C                         *Synon (9999) w
      * *Synon (9999) work field
     C                   MOVEL     *BLANKS       YRSW0D                         *Synon (9999) w
     C                   MOVEL     *BLANKS       YRSW0E            1            *String work fi
     C                   MOVEL     *BLANKS       YRSW0F            1            *String work fi
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
     C                   OPEN      SD9441R#
     C                   OPEN      SDTIINL1
     C                   OPEN      SDBRCHL1
     C                   OPEN      SDDEPTL1
     C**********         OPEN      SDRETRL1                                                 MD058755
     C                   OPEN      SDPRFCL1
     C                   OPEN      SDBOOKL1
     C                   OPEN      SDMMODL1
     C                   OPEN      SDGELRL1
     C                   OPEN      SDTIINL0
     C                   OPEN      SDFCTLL0
     C                   MOVEL     'N'           W0PMT             1
      * Set to *CHANGE mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      *                                                                                       CTI006
      ** Check whether CTI006 is switched on                                                  CTI006
      *                                                                                       CTI006
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CTI006'      @KEY
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CTI006
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CTI006            1
     C                   SETON                                        60
     C                   ELSE
     C                   MOVE      'N'           CTI006
     C                   SETOFF                                       60
     C                   ENDIF
      *                                                                                       CTI006
      * USER: Initialize program
      * SD9441R Precompiler - Midas/TI Interface ICD  *
      * Copyright Statement 1997 - Standard Functions  *
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
     C                   EXSR      SHRVGN
      * Midas-TI ICD Data Struct - Midas/TI Interface ICD  *
      * Check to see if profit centres are used
      * Check Profit Centres Used - General Ledger Details  *
     C                   EXSR      SIRVGN
      * 00/Copy Member SD9441RIPG - Midas/TI Interface ICD  *
     C/COPY WNCPYSRC,SD9441RCPG
      *                                                                   156783
      ** Access the switchable features file, to see if the feature       156783
      ** S01492 is on. This features reserves some batch numbers for      156783
      ** Leo usage. Set on an indicator if the feature is there.          156783
     C                   CALL      'AOSARDR0'                                                  15678
     C                   PARM      *BLANKS       @RTCD             7                           15678
     C                   PARM      '*VERIFY'     @OPTN             7                           15678
     C                   PARM      'S01492'      @KEY              6                           15678
     C     SCSARD        PARM      SCSARD        DSFDY                                         15678
      *                                                                   156783
     C     @RTCD         IFEQ      *BLANKS                                                     15678
     C                   MOVE      'Y'           S01492            1                           15678
     C                   END                                                                   15678
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
     C/COPY WNCPYSRC,SD9441RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD9441RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRICD                                                              MD058085
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058085
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD9441RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O/COPY WNCPYSRC,SD9441ROPG
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA ALPHB
 BCDEFGHIJKLMNOPQRSTUVWXYZ                                                                   BUG3130
