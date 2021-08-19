     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB COB components')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB0400R - COB Components Maintenance.                        *
      *                                                               *
      *  Function:  This program allows users to maintain the         *
      *             COB conditions file.                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD056555           Date 31Aug20               *
      *                 MD050576           Date 26Apr18               *
      *                 MD046248           Date 27Oct17               *
      *                 CCB020C            Date 16May13               *
      *                 CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPB001             Date 02Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 CCB008             Date 27OCT97               *
      *                 CTI001             Date 04SEP97               *
      *                 CCB003             Date 28NOV96               *
      *                 CAC001             Date 06SEP96               *
      *                 090416             Date 12JUL95               *
      *                 084303             Date 16MAR95               *
      *                 S01522             Date 19OCT94               *
      *                 S01486             Date 17AUG94               *
      *                 S01517             Date 01AUG94               *
      *                 S01491             Date 14JUN94               *
      *                 S01493             Date 31MAY94               *
      *                 S01488             Date 22APR94               *
      *                 S01459             Date 22APR94               *
      *                 S01417             Date 24AUG93               *
      *                 S01407             Date 20JAN93               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD050576 - Quote is not allowed in Text field.               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020C - COB Restructure - Secondary COB Infrastructure     *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPB001 - Amend validation processing for modules to allow    *
      *           'Private Banking' Module                            *
      *  CPL002 - Midas - Plato Interface Enhancement.                *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - Program removed from CB model.                    *
      *  CTI001 - Amend validation processing for modules to allow    *
      *           'TI' (Trade Innovation Interface).                  *
      *  CCB003 - CoB Task Split Enhancement - 2 fields added:        *
      *           - Task Split Job Ind. &                             *
      *           - Number of Task Split Jobs                         *
      *  CAC001 - Amend validation processing for modules to allow    *
      *           'AA' (Analytical Accounting).                       *
      *  090416 - Recompiled over changed display file.               *
      *  084303 - Amend validation processing for modules to allow    *
      *           'MG' (Message Generation) as a module ID.           *
      *  S01522 - Amend validation processing for modules to allow    *
      *           'CF' (Confirmation Matching) and 'CG' (User Defined *
      *           Correspondence) as module IDs.                      *
      *  S01486 - Amend validation processing for modules to allow    *
      *           'LB' (Portfolio Lending) and 'PM' (Portfolio        *
      *           Management) as module IDs.                          *
      *  S01517 - Addition of 'Allow Component Bypass' field.         *
      *  S01491 - Autocall Project:                                   *
      *           - Amend to allow maintenance of the new run         *
      *             time fields.                                      *
      *  S01493 - Amend validation processing for modules to allow    *
      *           'ED' to be recognised as the 'EUREKA Interface'     *
      *           module ID.                                          *
      *  S01488 - Amend validation processing for run conditions      *
      *           field to use CBRUNCPD.                              *
      *         - Amend validation processing for module field to     *
      *           be validated in the RPG and not at screen level.    *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  S01417 - Add 1A function input parameter to indicate         *
      *           successful update made to master file               *
      *  S01407 - Switchability enhancements:                         *
      *           Deletion of a component from CBCMPNPD should        *
      *           delete corresponding record(s) from SCSARCPD.       *
      *                                                               *
      *****************************************************************
     FCB0400R#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB COB components maintenance
      *
     F*CBCMPNL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(INFDS1)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB Components retrieval
      *
     F*CBRUNCL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0001)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB COB run conditions retrieval
      *
     F*CBMDCNL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0002)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Module Conditions         Retrieval index
      *
     F*CBMEXCL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0003)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Mutually Exclusive Compnt Retrieval index
      *
     F*CBMEXCL2* IF   E           K DISK    USROPN
     F**********                           INFDS(ID0004)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RSQ : Mutually Exclusive Compnt Rsq key                                             MD055891
      *
     F*CBDPRLL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0005)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB Dependency relations retrieval
      *
     F*CBDPRLL2* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0006)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RSQ : Midas CB Dependency relations for dep rel validn
      *
     F*SCSARCL2* IF   E           K DISK    USROPN                                          MD056555
     F**********                           INFDS(ID0007)                                    MD056555
     F**********                           INFSR(*PSSR)                                     MD056555
      * RSQ : Midas SC Switchable f - COB components
      *
     F*CBCMPNL0* UF A E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(ID0008)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * UPD : Midas CB Components update
      *
     F*SCSARCL0* UF   E           K DISK    USROPN                                          MD056555
     F**********                           INFDS(ID0009)                                    MD056555
     F**********                           INFSR(*PSSR)                                     MD056555
      * UPD : Midas SC Switchable f - COB components
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
      *
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
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
     D*@1DBRC***     E DS                  EXTNAME(CBCMPNL0)                                MD055891
     D @1DBRC        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D                                     PREFIX(X)                                        MD055891
      * UPD : Midas CB Components update
      * Current/previous master file format fields for change control
      *
     D*#1DBRC***       DS           262                                                     MD055891
     D #1DBRC          DS           264                                                     MD055891
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     D CBDPRL        E DS                  EXTNAME(CBDPRJW0)                                MD055891
     D CBMEXC        E DS                  EXTNAME(CBMEXJW0)                                MD055891
     D CBRUNC        E DS                  EXTNAME(CBRUNJW0)                                MD055891
     D WDHCOTT         S             10                                                     MD055891
     D WDHCSEQ         S              5                                                     MD055891
     D TotRow          S             13  0                                                  MD055891
     D*YARDCS***       DS           262                                                     MD055891
     D YARDCS          DS           264                                                     MD055891
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D COBP            DS
     D  WUFMT                  1    200
     D  WUCBBF               111    111
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
     D P1PARM          DS
      * FLD: Components
      * I : MAP Component Name
     D  P1COTT                 1     10
      * I : MAP Component Sequence Number
     D  P1CSEQ                11     15
     D P2PARM          DS
      * B :  Successful Update Made
     D  P2SUPD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Cobbegin not allowed'
      * Component Name
     D  ZA0001                 1     10
      **Message*data*for*'Cobend'**************************************                       CCB020
      ** Message data for 'SCOBFINISH'                                                        CCB020
      * Component Name
     D  ZA0002                 1     10
      * Message data for 'Scheduling Priority Inval'
      * Scheduling Priority (Scn)
     D  ZA0003                 1      1
      * Message data for 'End of Day Run Tme Invald'
      * End of Day Run Time (Scn)
     D  ZA0004                 1      6
      * Message data for 'End of Day Run Tme Invald'
      * End of Day Run Time (Scn)
     D  ZA0005                 1      6
      * Message data for 'End of Day Run Tme Invald'
      * End of Day Run Time (Scn)
     D  ZA0006                 1      6
      * Message data for 'Execution Priority Invald'
      * Execution Priority (Scrn)
     D  ZA0007                 1      2
      * Message data for 'Beg of Month Run Time Inv'
      * Beg of Mth Run Time (Scn)
     D  ZA0008                 1      6
      * Message data for 'Beg of Month Run Time Inv'
      * Beg of Mth Run Time (Scn)
     D  ZA0009                 1      6
      * Message data for 'Beg of Month Run Time Inv'
      * Beg of Mth Run Time (Scn)
     D  ZA0010                 1      6
      * Message data for 'Timeslice Invalid'
      * Timeslice (Screen)
     D  ZA0011                 1     11
      * Message data for 'Timeslice Invalid'
      * Timeslice (Screen)
     D  ZA0012                 1     11
      * Message data for 'End of Month Run Time Inv'
      * End of Mth Run Time (Scn)
     D  ZA0013                 1      6
      * Message data for 'End of Month Run Time Inv'
      * End of Mth Run Time (Scn)
     D  ZA0014                 1      6
      * Message data for 'End of Month Run Time Inv'
      * End of Mth Run Time (Scn)
     D  ZA0015                 1      6
      * Message data for 'FCOOB Error Accept Invald'
      * FCOOB Error Acceptability
     D  ZA0016                 1      1
      * Message data for 'End of Year Run Time Inv'
      * End of Yr Run Time (Scrn)
     D  ZA0017                 1      6
      * Message data for 'End of Year Run Time Inv'
      * End of Yr Run Time (Scrn)
     D  ZA0018                 1      6
      * Message data for 'End of Year Run Time Inv'
      * End of Yr Run Time (Scrn)
     D  ZA0019                 1      6
      * Message data for 'Module ID blank'
      * Module
     D  ZA0020                 1      2
      * Message data for 'Invalid module entered'
      * Module
     D  ZA0021                 1      2
      * Message data for 'Mod Cond Rec found'
      * Complex Module Conds Flag
     D  ZA0022                 1      1
      * Message data for 'Allow Bypass in COB Inval'
      * Allow Bypass in COB
     D  ZA0023                 1      1
      * Message data for 'Mut Excl Record Found'
      * Mut.Exclusive Comps.Flag
     D  ZA0024                 1      1
      * Message data for 'Mut Excl Record Found'
      * Mut.Exclusive Comps.Flag
     D  ZA0025                 1      1
      * Message data for 'Run condition not input'
      * Run Conditions
     D  ZA0026                 1      2
      * Message data for 'Run condition not defined'
      * Run Condition Text (Scrn)
     D  ZA0027                 1     70
      * Message data for 'No. of Task Split Jbs INV'
      * No of Task Split Jobs SCR
     D  ZA0028                 1      3
      * Message data for 'No. of Task Split Jbs INV'
      * No of Task Split Jobs SCR
     D  ZA0029                 1      3
      * Message data for 'No. of Task Split Jbs INV'
      * No of Task Split Jobs SCR
     D  ZA0030                 1      3
      * Message data for 'Dep'cy Rel Still Exist'
      * Component Name
     D  ZA0031                 1     10
      * Component Sequence Number
     D  ZA0032                11     15
      * Message data for 'Dep'cy Rel Still Exist'
      * Component Name
     D  ZA0033                 1     10
      * Component Sequence Number
     D  ZA0034                11     15
      * Message data for 'Mutually Exclusive Exists'
      * Component Name
     D  ZA0035                 1     10
      * Component Sequence Number
     D  ZA0036                11     15
      * Message data for 'Mutually Exclusive Exists'
      * Component Name
     D  ZA0037                 1     10
      * Component Sequence Number
     D  ZA0038                11     15
      * Message data for 'Mod Cons Exists'
      * Component Name
     D  ZA0039                 1     10
      * Component Sequence Number
     D  ZA0040                11     15
     D CBMDCN        E DS                  EXTNAME(CBMDCJW0)                                MD055891
     D SCSARC        E DS                  EXTNAME(SCSRCJW0)                                MD056555
     I*@MEXCG8**                                                                            MD055891
      **Mutually Exclusive Compnt Rsq key                                                   MD055891
      **Renamed*input format fields                                                         MD055891
     I**********    DKCOTT                      WACOTT                                      MD055891
     I**********    DKCSEQ                      WACSEQ                                      MD055891
     I**********    DKMEUN                      WAMEUN                                      MD055891
     I**********    DKMECN                      WAMECN                                      MD055891
     I**********    DKMECS                      WAMECS                                      MD055891
      *
     I*@DPRLG7**                                                                            MD055891
      **Midas*CB Dependency relations for dep rel validn                                    MD055891
      **Renamed input format fields                                                         MD055891
     I**********    DIDSON                      WBDSON                                      MD055891
     I**********    DIDSOS                      WBDSOS                                      MD055891
     I**********    DIDRUN                      WBDRUN                                      MD055891
     I**********    DIDDON                      WBDDON                                      MD055891
     I**********    DIDDOS                      WBDDOS                                      MD055891
     I**********    DICDST                      WBCDST                                      MD055891
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1COTT        PARM                    WP0001           10            Component Name
     C     P1CSEQ        PARM                    WP0002            5            Component Seque
     C     P2SUPD        PARM      P2SUPD        WP0003            1            Successful Upda
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
     C     #1COTT        IFEQ      *BLANK                                       Component Name
     C     #1CSEQ        OREQ      *BLANK                                       Component Seque
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
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #1COTT        DHCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DHCSEQ                         Component Seque
     C*****KRTV          CHAIN     @DHREGH                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        993132    *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialize detail screen (new record)
      * Start of change S01491.
      * Setup edit rcd dtl footer - Components  *
     C*
     C*  Detail line command key text
     C*
     C*  If Action Code is Delete :
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C                   MOVE      WUDISP        WUDISP            1                           10035
     C*
     C     'I'           IFEQ      'D'
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'CBM0193'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C     'I'           IFEQ      'I'
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'CBM0194'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C     'I'           IFEQ      'A'
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'CBM0195'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C*  If Action Code is Enquire :
     C*
     C     'I'           IFEQ      'E'
     C     WUDISP        IFEQ      'N'
     C* Setup footer text:
     C* F3=Exit   F5=Refresh Screen
     C                   MOVEL     'CBM0200'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C                   ELSE                                                                  10035
     C* Setup footer text:
     C* F3=Exit   F5=Refresh Screen   F11=Dependency Relations Enquiry
     C                   MOVEL     'CBM0202'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C                   ENDIF                                                                 10035
     C                   END
     C*
      * Setup end of day run time.
      * CASE: DTL.End of Day Run Time is Zeroes
     C     #1EODT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEDRA                         End of Day Run
     C                   END                                                    *FI
      * Setup beginning of month run time.
      * CASE: DTL.Begin of Month Run Time is Zeroes
     C     #1BOMT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DBOMA                         Beg of Mth Run
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        #DTSLS                         Timeslice (Scre
     C                   MOVEL     '10000'       #DTSLS                         Timeslice (Scre
      * Setup end of month run time.
      * CASE: DTL.End of Month Run Time is Zeroes
     C     #1EOMT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEOMA                         End of Mth Run
     C                   END                                                    *FI
      * Setup end of year run time.
      * CASE: DTL.End of Year Run Time is Zeroes
     C     #1EOYT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEOYA                         End of Yr Run T
     C                   END                                                    *FI
      * End of change S01491.
      * Start of change S01517.
     C                   MOVEL     'N'           #1ABIC                         Allow Bypass in
      * End of change S01517.
     C                   MOVEL     'I'           WUANCD                         Action Code
      * Start CCB003
      * Set Display indicator for 'Number of Task Split Jobs'
     C                   MOVEL     'N'           WUDNSJ                         Display No. tas
      * End CCB003
     C                   ELSE
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * USER: Initialize detail screen (existing record)
      * Start of change S01491.
      * Setup edit rcd dtl footer - Components  *
     C*
     C*  Detail line command key text
     C*
     C*  If Action Code is Delete :
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C                   MOVE      WUDISP        WUDISP            1                           10035
     C*
     C     'A'           IFEQ      'D'
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'CBM0193'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C     'A'           IFEQ      'I'
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'CBM0194'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C     'A'           IFEQ      'A'
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'CBM0195'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C*  If Action Code is Enquire :
     C*
     C     'A'           IFEQ      'E'
     C     WUDISP        IFEQ      'N'
     C* Setup footer text:
     C* F3=Exit   F5=Refresh Screen
     C                   MOVEL     'CBM0200'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C                   ELSE                                                                  10035
     C* Setup footer text:
     C* F3=Exit   F5=Refresh Screen   F11=Dependency Relations Enquiry
     C                   MOVEL     'CBM0202'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C                   ENDIF                                                                 10035
     C                   END
     C*
      * Initialise screen fields.
     C                   MOVEL     #1CSHP        #DSHPS                         Scheduling Prio
      * Setup end of day run time.
      * CASE: DTL.End of Day Run Time is Zeroes
     C     #1EODT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEDRA                         End of Day Run
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #1EODT        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0002           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0003            1 0          ZALIGN No of De
     C                   PARM      6             WQ0004            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0006           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0007            1 0          ZALIGN No of De
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
      * ZALIGN EOD Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEDRA
     C                   END                                                    *FI
     C                   MOVEL     #1CEPY        #DEXCP                         Execution Prior
      * Setup beginning of month run time.
      * CASE: DTL.Begin of Month Run Time is Zeroes
     C     #1BOMT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DBOMA                         Beg of Mth Run
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #1BOMT        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0008            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0009           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0010            1 0          ZALIGN No of De
     C                   PARM      6             WQ0011            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0013           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0014            1 0          ZALIGN No of De
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
      * ZALIGN BOM Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DBOMA
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #1CTSL        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0015            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0016           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0017            1 0          ZALIGN No of De
     C                   PARM      11            WQ0018            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0020           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0021            1 0          ZALIGN No of De
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
      * ZALIGN Timeslice - Components  *
     C                   MOVE      WUZASF        #DTSLS
      * Setup end of month run time.
      * CASE: DTL.End of Month Run Time is Zeroes
     C     #1EOMT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEOMA                         End of Mth Run
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #1EOMT        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0022            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0023           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0024            1 0          ZALIGN No of De
     C                   PARM      6             WQ0025            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0027           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0028            1 0          ZALIGN No of De
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
      * ZALIGN EOM Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEOMA
     C                   END                                                    *FI
      * Setup end of year run time.
      * CASE: DTL.End of Year Run Time is Zeroes
     C     #1EOYT        IFEQ      *ZERO                                        *IF
     C                   MOVEL     *BLANK        #DEOYA                         End of Yr Run T
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #1EOYT        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0029            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0030           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0031            1 0          ZALIGN No of De
     C                   PARM      6             WQ0032            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0034           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0035            1 0          ZALIGN No of De
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
      * ZALIGN EOY Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEOYA
     C                   END                                                    *FI
      * End of change S01491.
      * Retrieve COB Run Condns - COB Run Conditions  *
     C                   EXSR      SARVGN
     C                   MOVEL     DHCEMI        WUCEMI                         Complex Module
     C                   MOVEL     DHCMEF        WUCMEF                         Mut.Exclusive C
      * Move Input To Screen - Components  *
     C                   MOVE      DHCPRM        #DAMNA
     C                   MOVEL     DHCPRM        #DALNA
      * Start CCB003
      * Set Display Indicator for 'Number of Task Split Jobs'
      * CASE:
      *  - c1 OR c2
      *   |- c1    : DB1.Task Split Job Indicator is No
      *   |- c2    : DB1.Task Split Job Indicator is Blank
      *   '-
     C     DHTASK        IFEQ      'N'                                          *IF
     C     DHTASK        OREQ      *BLANK                                       *OR
     C                   MOVEL     'N'           WUDNSJ                         Display No. tas
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #DNTJS                         No of Task Spli
     C                   MOVEL     DHTSNO        #DNTJS                         No of Task Spli
     C                   END                                                    *FI
      * End CCB003
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
      * Check Component Sequence Number is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #1CSEQ               90  90    *
     C   90              MOVE      #1CSEQ        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#1CSEQ        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #1CSEQ        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
     C                   END
     C                   MOVEL     XG90          *IN90
     C     W0PMD         IFNE      'ADD'
      * Select existing record
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
     C                   MOVEL     *BLANK        WULLST                         Cob end/begin
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     #1COTT        WUJ8ST                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUJ8ST        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        #1COTT                         Component Name
      * z select - Components  *
     C                   CALL      'CB0400S'                            90      z select
     C                   PARM      *BLANK        W0RTN             7
     C     #1COTT        PARM      #1COTT        WQ0038           10            Component Name
     C     WUCSEQ        PARM      WUCSEQ        WQ0039            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0400S'     W0CLPG
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
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     #1CSEQ        WUJ8ST                         Test ? in Key F
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUJ8ST        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        #1CSEQ                         Component Seque
      * z select - Components  *
     C                   CALL      'CB0400S'                            90      z select
     C                   PARM      *BLANK        W0RTN             7
     C     WUCOTT        PARM      WUCOTT        WQ0040           10            Component Name
     C     #1CSEQ        PARM      #1CSEQ        WQ0041            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0400S'     W0CLPG
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
     C                   END                                                    *FI
     C                   END                                                    *FI
      * CASE: KEY.Component Name is cobbegin
     C     #1COTT        IFEQ      'COBBEGIN'                                   *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0001                         Component Name
      * Send message 'Cobbegin not allowed'
     C                   MOVEL     'USR0648'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      **CASE:*KEY.Component*Name*is*Cobend*****************************                       CCB020
      ** CASE: KEY.Component Name is SCOBFINISH                                               CCB020
     C********** #1COTT    IFEQ 'COBEND'                   *IF                                CCB020
     C     #1COTT        IFEQ      SCOBFI
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0002                         Component Name
      **Send*message*'Cobend'******************************************                       CCB020
      ** Send message 'SCOBFINISH'                                                            CCB020
     C                   MOVEL     'USR0649'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * Component Name required
     C     #1COTT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Component Sequence Number required
     C     #1CSEQ        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
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
      * Start of change S01491.
      * Insert mode.
      * CASE: WRK.Action Code is Insert
     C     WUANCD        IFEQ      'I'                                          *IF
      * Setup edit rcd key footer - Components  *
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'CBM0196'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
      * End of change S01491.
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
      * Validate Module
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CMOD        W0NSRQ            1            Module
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100620       Y2LSNO            7 0
     C     #1CMOD        PARM      #1CMOD        W0EXVL           20            Module
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Complex Module Conds Flag
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CEMI        W0NSRQ            1            Complex Module
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100637       Y2LSNO            7 0
     C     #1CEMI        PARM      #1CEMI        W0EXVL           20            Complex Module
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Allow Bypass in COB
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1ABIC        W0NSRQ            1            Allow Bypass in
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1104832       Y2LSNO            7 0
     C     #1ABIC        PARM      #1ABIC        W0EXVL           20            Allow Bypass in
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Mut.Exclusive Comps.Flag
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CMEF        W0NSRQ            1            Mut.Exclusive C
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100647       Y2LSNO            7 0
     C     #1CMEF        PARM      #1CMEF        W0EXVL           20            Mut.Exclusive C
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * Validate Run Conditions
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #1CFRQ        W0NSRQ            1            Run Conditions
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'CBVLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100657       Y2LSNO            7 0
     C     #1CFRQ        PARM      #1CFRQ        W0EXVL           20            Run Conditions
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * USER: Validate detail screen fields
      * Start of change S01491.
     C                   MOVE      #DSHPS        #1CSHP                         Scheduling Prio
      * Validate scheduling priority.
      * CASE: DTL.Scheduling Priority is Range 1 to 9
     C     #1CSHP        IFGE      1                                            *IF
     C     #1CSHP        ANDLE     9
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DSHPS        ZA0003                         Scheduling Prio
      * Send message 'Scheduling Priority Inval'
     C                   MOVEL     'CBM0089'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
      * Validate end of day run time.
      * CASE: WRK.S01491 is Present
     C     WUVANT        IFEQ      'Y'                                          *IF
      * Validate End of Day Run Time.
      * CASE: DTL.End of Day Run Time (Scn) is Blank
     C     #DEDRA        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DEDRA        ZA0004                         End of Day Run
      * Send message 'End of Day Run Tme Invald'
     C                   MOVEL     'CBM0085'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DEDRA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0042            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0043           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0044            1 0          ZALIGN No of De
     C                   PARM      6             WQ0045            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0047           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0048            1 0          ZALIGN No of De
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
      * Check return code.
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DEDRA        ZA0005                         End of Day Run
      * Send message 'End of Day Run Tme Invald'
     C                   MOVEL     'CBM0085'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1EODT                         End of Day Run
      * ZALIGN Move Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEDRA
      * Check to see if the value is numeric.
      * CASE: DTL.End of Day Run Time is Valid values
     C     #1EODT        IFGE      1                                            *IF
     C     #1EODT        ANDLE     999999
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DEDRA        ZA0006                         End of Day Run
      * Send message 'End of Day Run Tme Invald'
     C                   MOVEL     'CBM0085'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   MOVE      #DEXCP        #1CEPY                         Execution Prior
      * Validate execution priority.
      * CASE: DTL.Execution Priority is Range 20 to 99
     C     #1CEPY        IFGE      20                                           *IF
     C     #1CEPY        ANDLE     99
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DEXCP        ZA0007                         Execution Prior
      * Send message 'Execution Priority Invald'
     C                   MOVEL     'CBM0092'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
      *
     C                   END                                                    *FI
      * Validate beginning of month run time.
      * CASE: WRK.S01491 is Present
     C     WUVANT        IFEQ      'Y'                                          *IF
      * Validate Beginning of Month Run Time.
      * CASE: DTL.Beg of Mth Run Time (Scn) is Blank
     C     #DBOMA        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DBOMA        ZA0008                         Beg of Mth Run
      * Send message 'Beg of Month Run Time Inv'
     C                   MOVEL     'CBM0088'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DBOMA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0049            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0050           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0051            1 0          ZALIGN No of De
     C                   PARM      6             WQ0052            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0054           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0055            1 0          ZALIGN No of De
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
      * Check return code.
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DBOMA        ZA0009                         Beg of Mth Run
      * Send message 'Beg of Month Run Time Inv'
     C                   MOVEL     'CBM0088'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1BOMT                         Begin of Month
      * ZALIGN BOM Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DBOMA
      * Check to see if the value is numeric.
      * CASE: DTL.Begin of Month Run Time is Valid values
     C     #1BOMT        IFGE      1                                            *IF
     C     #1BOMT        ANDLE     999999
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DBOMA        ZA0010                         Beg of Mth Run
      * Send message 'Beg of Month Run Time Inv'
     C                   MOVEL     'CBM0088'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   MOVE      #DTSLS        #1CTSL                         Timeslice
      * Validate timeslice.
      * CASE: DTL.Timeslice is Blank
     C     #1CTSL        IFEQ      *ZERO                                        *IF
      * Setup message data for message
     C                   MOVEL     #DTSLS        ZA0011                         Timeslice (Scre
      * Send message 'Timeslice Invalid'
     C                   MOVEL     'CBM0091'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DTSLS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0056            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0057           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0058            1 0          ZALIGN No of De
     C                   PARM      11            WQ0059            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0061           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0062            1 0          ZALIGN No of De
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
      * Check return code.
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DTSLS        ZA0012                         Timeslice (Scre
      * Send message 'Timeslice Invalid'
     C                   MOVEL     'CBM0091'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1CTSL                         Timeslice
      * ZALIGN Timeslice - Components  *
     C                   MOVE      WUZASF        #DTSLS
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate end of month run time.
      * CASE: WRK.S01491 is Present
     C     WUVANT        IFEQ      'Y'                                          *IF
      * Validate End of Month Run Time.
      * CASE: DTL.End of Mth Run Time (Scn) is Blank
     C     #DEOMA        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DEOMA        ZA0013                         End of Mth Run
      * Send message 'End of Month Run Time Inv'
     C                   MOVEL     'CBM0086'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DEOMA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0063            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0064           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0065            1 0          ZALIGN No of De
     C                   PARM      6             WQ0066            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0068           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0069            1 0          ZALIGN No of De
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
      * Check return code.
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DEOMA        ZA0014                         End of Mth Run
      * Send message 'End of Month Run Time Inv'
     C                   MOVEL     'CBM0086'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1EOMT                         End of Month Ru
      * ZALIGN EOM Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEOMA
      * Check to see if the value is numeric.
      * CASE: DTL.End of Month Run Time is Valid values
     C     #1EOMT        IFGE      1                                            *IF
     C     #1EOMT        ANDLE     999999
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DEOMA        ZA0015                         End of Mth Run
      * Send message 'End of Month Run Time Inv'
     C                   MOVEL     'CBM0086'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9936      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Validate FCOOB error acceptability.
      * CASE: DTL.FCOOB Error Acceptability is Non-blank Values
     C     #1CFOB        IFEQ      'N'                                          *IF
     C     #1CFOB        OREQ      'Y'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CFOB        ZA0016                         FCOOB Error Acc
      * Send message 'FCOOB Error Accept Invald'
     C                   MOVEL     'CBM0090'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9937      *
      *
     C                   END                                                    *FI
      * Validate end of year run time.
      * CASE: WRK.S01491 is Present
     C     WUVANT        IFEQ      'Y'                                          *IF
      * Validate End of Year Run Time.
      * CASE: DTL.End of Yr Run Time (Scrn) is Blank
     C     #DEOYA        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DEOYA        ZA0017                         End of Yr Run T
      * Send message 'End of Year Run Time Inv'
     C                   MOVEL     'CBM0087'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DEOYA        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0070            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0071           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0072            1 0          ZALIGN No of De
     C                   PARM      6             WQ0073            2 0          ZALIGN No of Di
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0075           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0076            1 0          ZALIGN No of De
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
      * Check return code.
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DEOYA        ZA0018                         End of Yr Run T
      * Send message 'End of Year Run Time Inv'
     C                   MOVEL     'CBM0087'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1EOYT                         End of Year Run
      * ZALIGN EOY Run Time Fld - Components  *
     C                   MOVE      WUZASF        #DEOYA
      * Check to see if the value is numeric.
      * CASE: DTL.End of Year Run Time is Valid values
     C     #1EOYT        IFGE      1                                            *IF
     C     #1EOYT        ANDLE     999999
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DEOYA        ZA0019                         End of Yr Run T
      * Send message 'End of Year Run Time Inv'
     C                   MOVEL     'CBM0087'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9938      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change S01491.
      * Start of change S01488.
      * Validate module field.
      * CASE: DTL.Module is blank
     C     #1CMOD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CMOD        ZA0020                         Module
      * Send message 'Module ID blank'
     C                   MOVEL     'CBM0079'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Check that value entered is valid.
      * CASE: DTL.Module is Valid values
     C     #1CMOD        IFEQ      'RC'                                         *IF
     C     #1CMOD        OREQ      'LE'
     C     #1CMOD        OREQ      'DL'
     C     #1CMOD        OREQ      'AB'
     C     #1CMOD        OREQ      'CA'
     C     #1CMOD        OREQ      'CM'
     C     #1CMOD        OREQ      'FM'
     C     #1CMOD        OREQ      'FX'
     C     #1CMOD        OREQ      'MM'
     C     #1CMOD        OREQ      'FD'
     C     #1CMOD        OREQ      'EM'
     C     #1CMOD        OREQ      'FF'
     C     #1CMOD        OREQ      'FT'
     C     #1CMOD        OREQ      'GL'
     C     #1CMOD        OREQ      'IA'
     C     #1CMOD        OREQ      'MS'
     C     #1CMOD        OREQ      '#K'
     C     #1CMOD        OREQ      '#I'
     C     #1CMOD        OREQ      '#J'
     C     #1CMOD        OREQ      'MT'
     C     #1CMOD        OREQ      'NM'
     C     #1CMOD        OREQ      'RE'
     C     #1CMOD        OREQ      'SE'
     C     #1CMOD        OREQ      '#D'
     C     #1CMOD        OREQ      '#C'
     C     #1CMOD        OREQ      '#F'
     C     #1CMOD        OREQ      '#B'
     C     #1CMOD        OREQ      '#A'
     C     #1CMOD        OREQ      '#E'
     C     #1CMOD        OREQ      'SD'
     C     #1CMOD        OREQ      'MF'
     C     #1CMOD        OREQ      'IR'
     C     #1CMOD        OREQ      '#G'
     C     #1CMOD        OREQ      'MQ'
     C     #1CMOD        OREQ      'RM'
     C     #1CMOD        OREQ      'ST'
     C     #1CMOD        OREQ      'TK'
     C     #1CMOD        OREQ      'TM'
     C     #1CMOD        OREQ      'HF'
     C     #1CMOD        OREQ      'MC'
     C     #1CMOD        OREQ      'OD'
     C     #1CMOD        OREQ      'ED'
     C     #1CMOD        OREQ      'CF'
     C     #1CMOD        OREQ      'LB'
     C     #1CMOD        OREQ      'PM'
     C     #1CMOD        OREQ      'ME'
     C     #1CMOD        OREQ      'CG'
     C     #1CMOD        OREQ      'MG'
     C     #1CMOD        OREQ      'AA'
     C     #1CMOD        OREQ      'PL'                                                        CPL00
     C     #1CMOD        OREQ      'TI'
     C     #1CMOD        OREQ      'PB'                                                        CPB00
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1CMOD        ZA0021                         Module
      * Send message 'Invalid module entered'
     C                   MOVEL     'CBM0080'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9939      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change S01488.
      * If the program is in amend mode.
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
      * Complex conditions.
      * CASE: WRK.Complex Module Conds Flag is Yes
     C     WUCEMI        IFEQ      'Y'                                          *IF
      * If complex conditions is 'N'.
      * CASE: DTL.Complex Module Conds Flag is No
     C     #1CEMI        IFEQ      'N'                                          *IF
      * Check Mod Cons Exists - Module Conditions  *
     C                   EXSR      SBRVGN
      * If record already exists.
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CEMI        ZA0022                         Complex Module
      * Send message 'Mod Cond Rec found'
     C                   MOVEL     'USR0532'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9940      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of change S01517.
      * Validate Allow Bypass field.
      * CASE: WRK.S01517 is Present
     C     WUACBP        IFEQ      'Y'                                          *IF
      * CASE: DTL.Allow Bypass in COB is Valid values
     C     #1ABIC        IFEQ      'Y'                                          *IF
     C     #1ABIC        OREQ      'N'
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #1ABIC        ZA0023                         Allow Bypass in
      * Send message 'Allow Bypass in COB Inval'
     C                   MOVEL     'CBM0099'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9941      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change S01517.
      * If the program is in amend mode.
      * CASE: PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      'CHG'                                        *IF
      * Mutually exclusive flag.
      * CASE: WRK.Mut.Exclusive Comps.Flag is Yes
     C     WUCMEF        IFEQ      'Y'                                          *IF
      * If mutually exclusive flag is 'N'.
      * CASE: DTL.Mut.Exclusive Comps.Flag is No
     C     #1CMEF        IFEQ      'N'                                          *IF
      * Get Mutually Exclusive - Mutually Exclusive Compnt  *
     C                   EXSR      SCRVGN
      * If record already exists.
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CMEF        ZA0024                         Mut.Exclusive C
      * Send message 'Mut Excl Record Found'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
      * Get Mutually Ex (diff) - Mutually Exclusive Compnt  *
     C                   EXSR      SDRVGN
      * If record already exists.
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1CMEF        ZA0025                         Mut.Exclusive C
      * Send message 'Mut Excl Record Found'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9942      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of change S01488.
     C                   MOVEL     *BLANK        #DRUNS                         Run Condition T
      * Validate run conditions field.
      * CASE: DTL.Run Conditions is Blank
     C     #1CFRQ        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1CFRQ        ZA0026                         Run Conditions
      * Send message 'Run condition not input'
     C                   MOVEL     'CBM0077'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
      * Retrieve COB Run Condns - COB Run Conditions  *
     C                   EXSR      SERVGN
      * If a matching record was not found.
      * CASE: WRK.*Return code is *Record does not exist
     C     WURTN         IFEQ      'Y2U0005'                                    *IF
      * Setup message data for message
     C                   MOVEL     #DRUNS        ZA0027                         Run Condition T
      * Send message 'Run condition not defined'
     C                   MOVEL     'CBM0078'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *                                                                                      CCB020C
      ** All NWD COB components are Main COB components                                      CCB020C
      *                                                                                      CCB020C
     C                   ELSE
     C                   MOVEL     #1CSEQ        W#SE1             1
     C     #1CFRQ        IFEQ      '39'
     C     W#SE1         ANDEQ     '2'
     C                   MOVEL     'CBM0316'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9943
     C                   ENDIF
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End of change S01488.
      * Start CCB003
      * Validate Number of Task Split Jobs
      * CASE: DTL.Task Split Job Indicator is Yes
     C     #1TASK        IFEQ      'Y'                                          *IF
      * CASE: DTL.No of Task Split Jobs SCR is Blank
     C     #DNTJS        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #DNTJS        ZA0028                         No of Task Spli
      * Send message 'No. of Task Split Jbs INV'
     C                   MOVEL     'CBM0192'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        WUZASF                         ZALIGN Screen F
     C                   MOVEL     #DNTJS        WUZASF                         ZALIGN Screen F
      * Call ZALIGN & ZEDIT
      * ZALIGN Screen Field - Standard functions  *
     C                   CALL      'ZALIGN'                             90      ZALIGN Screen F
     C     W0RTN         PARM      W0RTN         WQ0077            7            *Return code
     C     WUZASF        PARM      WUZASF        WQ0078           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0079            1 0          ZALIGN No of De
     C                   PARM      3             WQ0080            2 0          ZALIGN No of Di
     C     WUZAFF        PARM      *BLANK        WQ0081           16            ZALIGN File Fie
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
      * ZEDIT Screen Field - Standard functions  *
     C                   CALL      'ZEDIT'                              90      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0082           16            ZALIGN Screen F
     C                   PARM      *ZERO         WQ0083            1 0          ZALIGN No of De
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
      * Check return code.
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'                                          *IF
      * Setup message data for message
     C                   MOVEL     #DNTJS        ZA0029                         No of Task Spli
      * Send message 'No. of Task Split Jbs INV'
     C                   MOVEL     'CBM0192'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVE      WUZAFF        #1TSNO                         Number of Task
      * CASE: DTL.Number of Task Split Jobs is Zero
     C     #1TSNO        IFEQ      *ZERO                                        *IF
      * Setup message data for message
     C                   MOVEL     #DNTJS        ZA0030                         No of Task Spli
      * Send message 'No. of Task Split Jbs INV'
     C                   MOVEL     'CBM0192'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9944      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * End CCB003
      * USER: Validate detail screen relations
      * Move Screen To Output - Components  *
     C                   MOVE      #DAMNA        #1CPRM
     C                   MOVEL     #DALNA        #1CPRM
      * Start of change S01488.
      * Display run condition text to the user.
     C                   MOVEL     WURUNT        #DRUNS                         Run Condition T
      * End of change S01488.
      * Complex Module Conds Flag required
     C     #1CEMI        IFEQ      *BLANK                                       IF
     C                   SETON                                        9940      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Mut.Exclusive Comps.Flag required
     C     #1CMEF        IFEQ      *BLANK                                       IF
     C                   SETON                                        9942      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Component Text required
     C     #1CTXT        IFEQ      *BLANK                                       IF
     C                   SETON                                        9947      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * QUOTE NOT ALLOWED.                                                                  MD050576
     C                   MOVEL     ''''          QUOTE             1
     C     QUOTE         SCAN      #1CTXT:1                               22
     C     *IN22         IFEQ      '1'
     C                   SETON                                        9947      *
      * SEND MESSAGE '*Value required'                                                      MD050576
     C                   MOVEL     'Y200080'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
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
     C     W0RTN         IFEQ      *BLANK
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
      * Create Components - Components  *
     C                   EXSR      SFCRRC
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
      * Delete Components - Components  *
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
      * Change Components - Components  *
     C                   EXSR      SOCHRC
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
     C     P1COTT        IFEQ      *BLANK                                       Component Name
     C     P1CSEQ        OREQ      *BLANK                                       Component Seque
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
     C                   MOVEL     '0'           *IN79
     C     WULLST        IFEQ      '1'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
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
     C     WUVANT        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     WUACBP        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     WUDNSJ        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
     C                   If        DHMODE = 'C'                                             MD055891
     C                   MOVEL     '1'           *IN50                                      MD055891
     C*****              MOVEL     '1'           *IN78                                      MD055891
     C                   ENDIF                                                              MD055891
     C                   MOVEL     '1'           *IN48                                      MD055891
     C                   If        DHCPCA = 'Y'                                             MD055891
     C                   MOVEL     '0'           *IN48                                      MD055891
     C                   ENDIF                                                              MD055891
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   Z-ADD     *ZERO         #1TSNO                         Number of Task
     C                   MOVEL     *BLANK        #1CSTS                         Component Statu
     C                   Z-ADD     *ZERO         #1CSHP                         Scheduling Prio
     C                   Z-ADD     *ZERO         #1EODT                         End of Day Run
     C                   Z-ADD     *ZERO         #1CEPY                         Execution Prior
     C                   Z-ADD     *ZERO         #1CTSL                         Timeslice
     C                   MOVEL     *BLANK        #1CPRM                         Execution Param
     C                   MOVEL     *BLANK        #1CRQD                         Sel for Today's
     C                   MOVEL     *BLANK        #1CRES                         Restart Flag
     C                   Z-ADD     *ZERO         #1CODP                         No.Outstndng De
     C                   MOVEL     *BLANK        #DRCTX                         Run condition t
     C                   Z-ADD     *ZERO         #1CSDE                         Start Date
     C                   Z-ADD     *ZERO         #1CSTI                         Start Time
     C                   Z-ADD     *ZERO         #1CEDE                         End Date
     C                   Z-ADD     *ZERO         #1CETI                         End Time
     C                   MOVEL     *BLANK        #1CHTB                         Halt Before
     C                   MOVEL     *BLANK        #1CHTA                         Halt After
     C                   MOVEL     *BLANK        #1CFAL                         Component Faile
     C                   Z-ADD     *ZERO         #1EOMT                         End of Month Ru
     C                   Z-ADD     *ZERO         #1BOMT                         Begin of Month
     C                   Z-ADD     *ZERO         #1EOYT                         End of Year Run
     C                   Z-ADD     *ZERO         #1EODC                         End of Day CPU
     C                   Z-ADD     *ZERO         #1EOMC                         End of Month CP
     C                   Z-ADD     *ZERO         #1BOMC                         Begin of Month
     C                   Z-ADD     *ZERO         #1EOYC                         End of Year CPU
     C                   MOVEL     *BLANK        #1CBSN                         COB Stream Name
     C                   MOVEL     *BLANK        #DSHPS                         Scheduling Prio
     C                   MOVEL     *BLANK        #DEDRA                         End of Day Run
     C                   MOVEL     *BLANK        #DEXCP                         Execution Prior
     C                   MOVEL     *BLANK        #DBOMA                         Beg of Mth Run
     C                   MOVEL     *BLANK        #DTSLS                         Timeslice (Scre
     C                   MOVEL     *BLANK        #DEOMA                         End of Mth Run
     C                   MOVEL     *BLANK        #1CFOB                         FCOOB Error Acc
     C                   MOVEL     *BLANK        #DEOYA                         End of Yr Run T
     C                   MOVEL     *BLANK        #1CMOD                         Module
     C                   MOVEL     *BLANK        #1CEMI                         Complex Module
     C                   MOVEL     *BLANK        #1ABIC                         Allow Bypass in
     C                   MOVEL     *BLANK        #1CMEF                         Mut.Exclusive C
     C                   MOVEL     *BLANK        #1TASK                         Task Split Job
     C                   MOVEL     *BLANK        #1CFRQ                         Run Conditions
     C                   MOVEL     *BLANK        #DNTJS                         No of Task Spli
     C                   MOVEL     *BLANK        #DRUNS                         Run Condition T
     C                   MOVEL     *BLANK        #DALNA                         screen split pa
     C                   MOVEL     *BLANK        #DAMNA                         screen split pa
     C                   MOVEL     *BLANK        #1CTXT                         Component Text
     C*                  MOVEL     *BLANK        #1MODE                         Mode        MD055891
     C*                  MOVEL     *BLANK        #1CPCA                         Mode        MD055891
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @DHREGH fields to screen
      *================================================================
     C                   Z-ADD     DHTSNO        #1TSNO                         Number of Task
     C                   MOVEL     DHCSTS        #1CSTS                         Component Statu
     C                   Z-ADD     DHCSHP        #1CSHP                         Scheduling Prio
     C                   Z-ADD     DHEODT        #1EODT                         End of Day Run
     C                   Z-ADD     DHCEPY        #1CEPY                         Execution Prior
     C                   Z-ADD     DHCTSL        #1CTSL                         Timeslice
     C                   MOVEL     DHCPRM        #1CPRM                         Execution Param
     C                   MOVEL     DHCRQD        #1CRQD                         Sel for Today's
     C                   MOVEL     DHCRES        #1CRES                         Restart Flag
     C                   Z-ADD     DHCODP        #1CODP                         No.Outstndng De
     C                   Z-ADD     DHCSDE        #1CSDE                         Start Date
     C                   Z-ADD     DHCSTI        #1CSTI                         Start Time
     C                   Z-ADD     DHCEDE        #1CEDE                         End Date
     C                   Z-ADD     DHCETI        #1CETI                         End Time
     C                   MOVEL     DHCHTB        #1CHTB                         Halt Before
     C                   MOVEL     DHCHTA        #1CHTA                         Halt After
     C                   MOVEL     DHCFAL        #1CFAL                         Component Faile
     C                   Z-ADD     DHEOMT        #1EOMT                         End of Month Ru
     C                   Z-ADD     DHBOMT        #1BOMT                         Begin of Month
     C                   Z-ADD     DHEOYT        #1EOYT                         End of Year Run
     C                   Z-ADD     DHEODC        #1EODC                         End of Day CPU
     C                   Z-ADD     DHEOMC        #1EOMC                         End of Month CP
     C                   Z-ADD     DHBOMC        #1BOMC                         Begin of Month
     C                   Z-ADD     DHEOYC        #1EOYC                         End of Year CPU
     C                   MOVEL     DHCBSN        #1CBSN                         COB Stream Name
     C                   MOVEL     DHCOTT        #1COTT                         Component Name
     C                   MOVEL     DHCSEQ        #1CSEQ                         Component Seque
     C                   MOVEL     DHCFOB        #1CFOB                         FCOOB Error Acc
     C                   MOVEL     DHCMOD        #1CMOD                         Module
     C                   MOVEL     DHCEMI        #1CEMI                         Complex Module
     C                   MOVEL     DHABIC        #1ABIC                         Allow Bypass in
     C                   MOVEL     DHCMEF        #1CMEF                         Mut.Exclusive C
     C                   MOVEL     DHTASK        #1TASK                         Task Split Job
     C                   MOVEL     DHCFRQ        #1CFRQ                         Run Conditions
     C                   MOVEL     DHCTXT        #1CTXT                         Component Text
     C*                  MOVEL     DHMODE        #1MODE                         Mode        MD055891
     C*                  MOVEL     DHCPCA        #1CPCA                         Mode        MD055891
      * Hold existing record image
     C                   eval      @1DBRC = CBCMPN                                          MD055891
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1COTT        #1COTT                         Component Name
     C                   MOVEL     P1CSEQ        #1CSEQ                         Component Seque
      * USER: Initialize key screen
      * Start of change S01491.
      * Setup edit rcd key footer - Components  *
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'CBM0196'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
      * End of change S01491.
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve COB Run Condns - COB Run Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    ANRUNC                         COB Run Conditi
      * Move fields to key list
     C                   MOVEL     DHCFRQ        ANRUNC                         COB Run Conditi
     C*****KRSSA         CHAIN     @RUNCL1                            90        *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBRUNC                                                                        MD055891
     C+ from CBRUNJW0                                                                       MD055891
     C+ where ANRUNC = :ANRUNC                                                              MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE = 100                                            MD055891
      * Data record not found
     C                   MOVEL     'CBM0075'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     WURTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     ANRUNT        #DRUNS                         COB Run Conditi
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Check Mod Cons Exists - Module Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DJCOTT        WQSB01                         Component Name
     C     *LIKE         DEFINE    DJCSEQ        WQSB02                         Component Seque
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    WQSB01                         Component Name
     C                   KFLD                    WQSB02                         Component Seque
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSB01                         Component Name
     C                   MOVEL     #1CSEQ        WQSB02                         Component Seque
     C*****KRSSB         SETLL     @DJREGN                                      *           MD055891
     C*****KRSSB         READE     @DJREGN                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare C1Cursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMDCJW0                                                              MD055891
     C+ where DJCOTT = :WQSB01 and DJCSEQ = :WQSB02                                         MD055891
     C+ order by DJCOTT, DJCSEQ, DJMCUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open C1Cursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from C1Cursor into :CBMDCN                                               MD055891
     C/END-EXEC                                                                             MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE = 100                                            MD055891
      * Data record not found
     C                   MOVEL     'USR0501'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C******IN90         DOWEQ     '0'                                                      MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSB         READE     @DJREGN                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from C1Cursor into :CBMDCN                                               MD055891
     C/END-EXEC                                                                             MD055891
     C                   END
     C/EXEC SQL                                                                             MD055891
     C+ close C1Cursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Get Mutually Exclusive - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQSC01                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQSC02                         Component Seque
      * Define keylist
     C     KRSSC         KLIST
     C                   KFLD                    WQSC01                         Component Name
     C                   KFLD                    WQSC02                         Component Seque
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSC01                         Component Name
     C                   MOVEL     #1CSEQ        WQSC02                         Component Seque
     C*****KRSSC         SETLL     @DKREGQ                                      *           MD055891
     C*****KRSSC         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare MCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close MCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open MCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from MCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSC         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from MCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDRVGN        BEGSR
      *================================================================
      * Get Mutually Ex (diff) - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C******LIKE         DEFINE    WAMECN        WQSD01                         Mut. Excl. CMD055891
     C******LIKE         DEFINE    WAMECS        WQSD02                         Mut. Excl. CMD055891
     C     *LIKE         DEFINE    DKCOTT        WQSD01                         Mut. Excl. CMD055891
     C     *LIKE         DEFINE    DKCSEQ        WQSD02                         Mut. Excl. CMD055891
      * Define keylist
     C     KRSSD         KLIST
     C                   KFLD                    WQSD01                         Mut. Excl. Comp
     C                   KFLD                    WQSD02                         Mut. Excl. Comp
      * Move fields to key list
     C                   MOVEL     P1COTT        WQSD01                         Mut. Excl. Comp
     C                   MOVEL     P1CSEQ        WQSD02                         Mut. Excl. Comp
     C*****KRSSD         SETLL     @MEXCG8                                      *           MD055891
     C*****KRSSD         READE     @MEXCG8                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare NCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKMECN = :P1COTT and DKMECS = :P1CSEQ                                         MD055891
     C+ order by DKMECN, DKMECS                                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close NCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open NCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from NCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSD         READE     @MEXCG8                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from NCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SERVGN        BEGSR
      *================================================================
      * Retrieve COB Run Condns - COB Run Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        WURTN
      * Define keylist
     C     KRSSE         KLIST
     C                   KFLD                    ANRUNC                         COB Run Conditi
      * Move fields to key list
     C                   MOVEL     #1CFRQ        ANRUNC                         COB Run Conditi
     C*****KRSSE         CHAIN     @RUNCL1                            90        *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBRUNC                                                                        MD055891
     C+ from CBRUNJW0                                                                       MD055891
     C+ where ANRUNC = :ANRUNC                                                              MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE = 100                                            MD055891
      * Data record not found
     C                   MOVEL     'CBM0075'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     WURTN                          *Return code
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     ANRUNT        WURUNS                         COB Run Conditi
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCRRC        BEGSR
      *================================================================
      * Create Components - Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DHREGG
     C                   MOVEL     #1COTT        DHCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DHCSEQ                         Component Seque
     C                   MOVEL     #1CSTS        DHCSTS                         Component Statu
     C                   Z-ADD     #1CSHP        DHCSHP                         Scheduling Prio
     C                   Z-ADD     #1CEPY        DHCEPY                         Execution Prior
     C                   Z-ADD     #1CTSL        DHCTSL                         Timeslice
     C                   MOVEL     #1CFOB        DHCFOB                         FCOOB Error Acc
     C                   MOVEL     #1CTXT        DHCTXT                         Component Text
     C                   MOVEL     #1CPRM        DHCPRM                         Execution Param
     C                   MOVEL     #1CRQD        DHCRQD                         Sel for Today's
     C                   MOVEL     #1CMOD        DHCMOD                         Module
     C                   MOVEL     #1CEMI        DHCEMI                         Complex Module
     C                   MOVEL     #1CRES        DHCRES                         Restart Flag
     C                   Z-ADD     #1CODP        DHCODP                         No.Outstndng De
     C                   MOVEL     #1CMEF        DHCMEF                         Mut.Exclusive C
     C                   MOVEL     #1CFRQ        DHCFRQ                         Run Conditions
     C                   Z-ADD     #1CSDE        DHCSDE                         Start Date
     C                   Z-ADD     #1CSTI        DHCSTI                         Start Time
     C                   Z-ADD     #1CEDE        DHCEDE                         End Date
     C                   Z-ADD     #1CETI        DHCETI                         End Time
     C                   MOVEL     #1CHTB        DHCHTB                         Halt Before
     C                   MOVEL     #1CHTA        DHCHTA                         Halt After
     C                   MOVEL     #1CFAL        DHCFAL                         Component Faile
     C                   Z-ADD     #1EODT        DHEODT                         End of Day Run
     C                   Z-ADD     #1EOMT        DHEOMT                         End of Month Ru
     C                   Z-ADD     #1BOMT        DHBOMT                         Begin of Month
     C                   Z-ADD     #1EOYT        DHEOYT                         End of Year Run
     C                   Z-ADD     #1EODC        DHEODC                         End of Day CPU
     C                   Z-ADD     #1EOMC        DHEOMC                         End of Month CP
     C                   Z-ADD     #1BOMC        DHBOMC                         Begin of Month
     C                   Z-ADD     #1EOYC        DHEOYC                         End of Year CPU
     C                   MOVEL     #1ABIC        DHABIC                         Allow Bypass in
     C                   MOVEL     #1CBSN        DHCBSN                         COB Stream Name
     C                   MOVEL     #1TASK        DHTASK                         Task Split Job
     C                   Z-ADD     #1TSNO        DHTSNO                         Number of Task
     C*                  MOVEL     #1MODE        DHMODE                         Mode        MD055891
     C*                  MOVEL     #1CPCA        DHCPCA                         Mode        MD055891
      *
      * USER: Processing before Data update
      * CASE: DB1.Sel for Today's COB Flag is Blank
     C     DHCRQD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           DHCRQD                         Sel for Today's
     C                   MOVEL     *BLANK        DHCSTS                         Component Statu
     C                   MOVEL     'N'           DHCRES                         Restart Flag
     C                   Z-ADD     *ZERO         DHCSDE                         Start Date
     C                   Z-ADD     *ZERO         DHCSTI                         Start Time
     C                   Z-ADD     *ZERO         DHCEDE                         End Date
     C                   Z-ADD     *ZERO         DHCETI                         End Time
     C                   MOVEL     'N'           DHCHTB                         Halt Before
     C                   MOVEL     'N'           DHCHTA                         Halt After
     C                   MOVEL     'N'           DHCFAL                         Component Faile
     C                   END                                                    *FI
     C     KLCRSF        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Check for duplicate primary key
     C*****KLCRSF        SETLL     @DHREGG                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare CDCursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open CDCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ get diagnostics :TotRow  = db2_number_rows                                          MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close CDCursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   IF        TotRow  > 0                                              MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C                   MOVEL     'USR0498'     W0RTN             7
      * Send message 'Components             EX'
     C                   MOVEL     'USR0498'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C**********         WRITE     @DHREGG                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBCMPBTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DHCOTT                                                                            MD055891
     C+ , DHCSEQ                                                                            MD055891
     C+ , DHCSTS                                                                            MD055891
     C+ , DHCSHP                                                                            MD055891
     C+ , DHCEPY                                                                            MD055891
     C+ , DHCTSL                                                                            MD055891
     C+ , DHCFOB                                                                            MD055891
     C+ , DHCTXT                                                                            MD055891
     C+ , DHCPRM                                                                            MD055891
     C+ , DHCRQD                                                                            MD055891
     C+ , DHCMOD                                                                            MD055891
     C+ , DHCEMI                                                                            MD055891
     C+ , DHCRES                                                                            MD055891
     C+ , DHCODP                                                                            MD055891
     C+ , DHCMEF                                                                            MD055891
     C+ , DHCFRQ                                                                            MD055891
     C+ , DHCSDE                                                                            MD055891
     C+ , DHCSTI                                                                            MD055891
     C+ , DHCEDE                                                                            MD055891
     C+ , DHCETI                                                                            MD055891
     C+ , DHCHTB                                                                            MD055891
     C+ , DHCHTA                                                                            MD055891
     C+ , DHCFAL                                                                            MD055891
     C+ , DHEODT                                                                            MD055891
     C+ , DHEOMT                                                                            MD055891
     C+ , DHBOMT                                                                            MD055891
     C+ , DHEOYT                                                                            MD055891
     C+ , DHEODC                                                                            MD055891
     C+ , DHEOMC                                                                            MD055891
     C+ , DHBOMC                                                                            MD055891
     C+ , DHEOYC                                                                            MD055891
     C+ , DHABIC                                                                            MD055891
     C+ , DHCBSN                                                                            MD055891
     C+ , DHTASK                                                                            MD055891
     C+ , DHTSNO                                                                            MD055891
     C+ , DHMODE                                                                            MD055891
     C+ , DHCPCA                                                                            MD055891
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1COTT                                                                           MD055891
     C+ , :#1CSEQ                                                                           MD055891
     C+ , :#1CSTS                                                                           MD055891
     C+ , :#1CSHP                                                                           MD055891
     C+ , :#1CEPY                                                                           MD055891
     C+ , :#1CTSL                                                                           MD055891
     C+ , :#1CFOB                                                                           MD055891
     C+ , :#1CTXT                                                                           MD055891
     C+ , :#1CPRM                                                                           MD055891
     C+ , :#1CRQD                                                                           MD055891
     C+ , :#1CMOD                                                                           MD055891
     C+ , :#1CEMI                                                                           MD055891
     C+ , :#1CRES                                                                           MD055891
     C+ , :#1CODP                                                                           MD055891
     C+ , :#1CMEF                                                                           MD055891
     C+ , :#1CFRQ                                                                           MD055891
     C+ , :#1CSDE                                                                           MD055891
     C+ , :#1CSTI                                                                           MD055891
     C+ , :#1CEDE                                                                           MD055891
     C+ , :#1CETI                                                                           MD055891
     C+ , :#1CHTB                                                                           MD055891
     C+ , :#1CHTA                                                                           MD055891
     C+ , :#1CFAL                                                                           MD055891
     C+ , :#1EODT                                                                           MD055891
     C+ , :#1EOMT                                                                           MD055891
     C+ , :#1BOMT                                                                           MD055891
     C+ , :#1EOYT                                                                           MD055891
     C+ , :#1EODC                                                                           MD055891
     C+ , :#1EOMC                                                                           MD055891
     C+ , :#1BOMC                                                                           MD055891
     C+ , :#1EOYC                                                                           MD055891
     C+ , :#1ABIC                                                                           MD055891
     C+ , :#1CBSN                                                                           MD055891
     C+ , :#1TASK                                                                           MD055891
     C+ , :#1TSNO                                                                           MD055891
     C+ , 'B'                                                                               MD055891
     C+ , 'Y'                                                                               MD055891
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ insert into CBCMPXTD                                                                MD055891
     C+ (                                                                                   MD055891
     C+   DHCOTT                                                                            MD055891
     C+ , DHCSEQ                                                                            MD055891
     C+ , DHCSHP                                                                            MD055891
     C+ , DHCEPY                                                                            MD055891
     C+ , DHCTSL                                                                            MD055891
     C+ , DHCPRM                                                                            MD055891
     C+ , DHCEMI                                                                            MD055891
     C+ , DHCODP                                                                            MD055891
     C+ , DHCMEF                                                                            MD055891
     C+ , DHCFRQ                                                                            MD055891
     C+ , DHCSDE                                                                            MD055891
     C+ , DHCSTI                                                                            MD055891
     C+ , DHCEDE                                                                            MD055891
     C+ , DHCETI                                                                            MD055891
     C+ , DHEODT                                                                            MD055891
     C+ , DHEOMT                                                                            MD055891
     C+ , DHBOMT                                                                            MD055891
     C+ , DHEOYT                                                                            MD055891
     C+ , DHEODC                                                                            MD055891
     C+ , DHEOMC                                                                            MD055891
     C+ , DHBOMC                                                                            MD055891
     C+ , DHEOYC                                                                            MD055891
     C+ , DHABIC                                                                            MD055891
     C+ , DHTSNO                                                                            MD055891
     C+ , DHMODE                                                                            MD055891
     C+ , DHCPCA                                                                            MD055891
     C+ )                                                                                   MD055891
     C+ Values                                                                              MD055891
     C+ (                                                                                   MD055891
     C+   :#1COTT                                                                           MD055891
     C+ , :#1CSEQ                                                                           MD055891
     C+ , :#1CSHP                                                                           MD055891
     C+ , :#1CEPY                                                                           MD055891
     C+ , :#1CTSL                                                                           MD055891
     C+ , :#1CPRM                                                                           MD055891
     C+ , :#1CEMI                                                                           MD055891
     C+ , :#1CODP                                                                           MD055891
     C+ , :#1CMEF                                                                           MD055891
     C+ , :#1CFRQ                                                                           MD055891
     C+ , :#1CSDE                                                                           MD055891
     C+ , :#1CSTI                                                                           MD055891
     C+ , :#1CEDE                                                                           MD055891
     C+ , :#1CETI                                                                           MD055891
     C+ , :#1EODT                                                                           MD055891
     C+ , :#1EOMT                                                                           MD055891
     C+ , :#1BOMT                                                                           MD055891
     C+ , :#1EOYT                                                                           MD055891
     C+ , :#1EODC                                                                           MD055891
     C+ , :#1EOMC                                                                           MD055891
     C+ , :#1BOMC                                                                           MD055891
     C+ , :#1EOYC                                                                           MD055891
     C+ , :#1ABIC                                                                           MD055891
     C+ , :#1TSNO                                                                           MD055891
     C+ , 'B'                                                                               MD055891
     C+ , 'Y'                                                                               MD055891
     C+ )                                                                                   MD055891
     C/END-EXEC                                                                             MD055891
      *                                                                                     MD055891
     C                   If        (SQLCODE <> 0)                                           MD055891
      *
     C******IN91         IFEQ      '1'                                                      MD055891
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * Start of S01417
      * Pass back 'Y' to parameter if DBF update complete
     C                   MOVEL     'Y'           P2SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGDLRC        BEGSR
      *================================================================
      * Delete Components - Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
     C                   MOVEL     'Y'           WUJEST                         work flag
                                                                                            MD055891
     C     DHMODE        IFEQ      'C'                                          *QUIT       MD055891
     C                   MOVEL     #1COTT        ZA0031                         Component NaMD055891
     C                   MOVEL     #1CSEQ        ZA0032                         Component SeMD055891
      * Send message 'Deletion of Core component is not allowed'                            MD055891
     C                   MOVEL     'USR0540'     ZAMSID                                     MD055891
     C                   EXSR      ZASNMS                                                   MD055891
     C                   SETON                                        99        *           MD055891
     C                   MOVEL     'N'           WUJEST                         work flag   MD055891
     C                   MOVEL     'USR0540'     W0RTN             7                        MD055891
     C                   GOTO      SGEXIT                                       *QUIT       MD055891
     C                   ENDIF                                                  *QUIT       MD055891
                                                                                            MD055891
      * Check Dep'cy Relations - Dependency Relations  *
     C                   EXSR      SHRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0031                         Component Name
     C                   MOVEL     #1CSEQ        ZA0032                         Component Seque
      * Send message 'Dep'cy Rel Still Exist'
     C                   MOVEL     'USR0525'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'N'           WUJEST                         work flag
     C                   END                                                    *FI
      * Check Dep Rel (not key) - Dependency Relations  *
     C                   EXSR      SIRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0033                         Component Name
     C                   MOVEL     #1CSEQ        ZA0034                         Component Seque
      * Send message 'Dep'cy Rel Still Exist'
     C                   MOVEL     'USR0525'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'N'           WUJEST                         work flag
     C                   END                                                    *FI
      * Get Mutually Exclusive - Mutually Exclusive Compnt  * ?
     C                   EXSR      SJRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0035                         Component Name
     C                   MOVEL     #1CSEQ        ZA0036                         Component Seque
      * Send message 'Mutually Exclusive Exists'
     C                   MOVEL     'USR0526'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'N'           WUJEST                         work flag
     C                   END                                                    *FI
      * Get Mutually Ex (diff) - Mutually Exclusive Compnt  *
     C                   EXSR      SKRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0037                         Component Name
     C                   MOVEL     #1CSEQ        ZA0038                         Component Seque
      * Send message 'Mutually Exclusive Exists'
     C                   MOVEL     'USR0526'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'N'           WUJEST                         work flag
     C                   END                                                    *FI
      * Check Mod Cons Exists - Module Conditions  *
     C                   EXSR      SLRVGN
      * CASE: PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      'Y2U0003'                                    *IF
      * Setup message data for message
     C                   MOVEL     #1COTT        ZA0039                         Component Name
     C                   MOVEL     #1CSEQ        ZA0040                         Component Seque
      * Send message 'Mod Cons Exists'
     C                   MOVEL     'USR0529'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'N'           WUJEST                         work flag
     C                   END                                                    *FI
      * CASE: WRK.work flag is Correct
     C     WUJEST        IFEQ      'Y'                                          *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   ELSE
      * CASE: *OTHERWISE
     C                   GOTO      SGEXIT                                       *QUIT
     C                   END                                                    *FI
      * Move key fields to @DHREGG
     C                   MOVEL     #1COTT        DHCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DHCSEQ                         Component Seque
      *
     C     KLDLSG        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
     C*****KLDLSG        CHAIN     @DHREGG                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
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
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SGEXIT
     C                   END
      *
     C                   eval      @1DBRC = CBCMPN                                          MD055891
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C*****KLDLSG        SETLL     @DHREGG                            9091      *           MD055891
     C                   GOTO      SGEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C**********         DELETE    @DHREGG                              91      *           MD055891
     C                   If        DHMODE = 'B'                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ delete from CBCMPBTD                                                                MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ delete from CBCMPXTD                                                                MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C******IN91         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
      * Start of S01407
      * RtvDlt Switchable F - COB - Switchable F - COB Compnt  *
     C                   EXSR      SMRVGN
      * End of S01407
      * Start of S01417
      * Pass back 'Y' to parameter if DBF update complete
     C                   MOVEL     'Y'           P2SUPD                         Successful Upda
      * End of S01417
     C                   END
     C                   Endif                                                              MD055891
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * Check Dep'cy Relations - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DIDSON        WQSH01                         Component Depen
     C     *LIKE         DEFINE    DIDSOS        WQSH02                         Compnt Depends-
      * Define keylist
     C     KRSSH         KLIST
     C                   KFLD                    WQSH01                         Component Depen
     C                   KFLD                    WQSH02                         Compnt Depends-
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSH01                         Component Depen
     C                   MOVEL     #1CSEQ        WQSH02                         Compnt Depends-
     C*****KRSSH         SETLL     @DIREGK                                      *           MD055891
     C*****KRSSH         READE     @DIREGK                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare DCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDSON = :#1COTT and DIDSOS = :#1CSEQ                                         MD055891
     C+ order by DIDSON, DIDSOS, DIDRUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close DCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open DCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from DCursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Else                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0499'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSH         READE     @DIREGK                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from DCursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Else                                                               MD055891
     C                   Setoff                                       90                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SIRVGN        BEGSR
      *================================================================
      * Check Dep Rel (not key) - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C******LIKE         DEFINE    WBDDON        WQSI01                         Compnt DepenMD055891
     C******LIKE         DEFINE    WBDDOS        WQSI02                         Compnt DepenMD055891
     C     *LIKE         DEFINE    DIDDON        WQSI01                         Compnt DepenMD055891
     C     *LIKE         DEFINE    DIDDOS        WQSI02                         Compnt DepenMD055891
      * Define keylist
     C     KRSSI         KLIST
     C                   KFLD                    WQSI01                         Compnt Depended
     C                   KFLD                    WQSI02                         Compnt Depended
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSI01                         Compnt Depended
     C                   MOVEL     #1CSEQ        WQSI02                         Compnt Depended
     C*****KRSSI         SETLL     @DPRLG7                                      *           MD055891
     C*****KRSSI         READE     @DPRLG7                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ECursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBDPRJW0                                                              MD055891
     C+ where DIDDON = :#1COTT and DIDDOS = :#1CSEQ                                         MD055891
     C+ order by DIDDON, DIDDOS                                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close ECursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ECursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ECursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0499'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SIEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSI         READE     @DPRLG7                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ECursor into :CBDPRL                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
                                                                                            MD055891
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   SJRVGN        BEGSR
      *================================================================
      * Get Mutually Exclusive - Mutually Exclusive Compnt  * ?
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DKCOTT        WQSJ01                         Component Name
     C     *LIKE         DEFINE    DKCSEQ        WQSJ02                         Component Seque
      * Define keylist
     C     KRSSJ         KLIST
     C                   KFLD                    WQSJ01                         Component Name
     C                   KFLD                    WQSJ02                         Component Seque
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSJ01                         Component Name
     C                   MOVEL     #1CSEQ        WQSJ02                         Component Seque
     C*****KRSSJ         SETLL     @DKREGQ                                      *           MD055891
     C*****KRSSJ         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare PCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKCOTT = :#1COTT and DKCSEQ = :#1CSEQ                                         MD055891
     C+ order by DKCOTT, DKCSEQ, DKMEUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close PCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open PCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from PCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SJEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSJ         READE     @DKREGQ                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from PCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
     C                   END
      *================================================================
     CSR   SJEXIT        ENDSR
      /EJECT
     CSR   SKRVGN        BEGSR
      *================================================================
      * Get Mutually Ex (diff) - Mutually Exclusive Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C******LIKE         DEFINE    WAMECN        WQSK01                         Mut. Excl. CMD055891
     C******LIKE         DEFINE    WAMECS        WQSK02                         Mut. Excl. CMD055891
     C     *LIKE         DEFINE    DKCOTT        WQSK01                         Mut. Excl. CMD055891
     C     *LIKE         DEFINE    DKCSEQ        WQSK02                         Mut. Excl. CMD055891
      * Define keylist
     C     KRSSK         KLIST
     C                   KFLD                    WQSK01                         Mut. Excl. Comp
     C                   KFLD                    WQSK02                         Mut. Excl. Comp
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSK01                         Mut. Excl. Comp
     C                   MOVEL     #1CSEQ        WQSK02                         Mut. Excl. Comp
     C*****KRSSK         SETLL     @MEXCG8                                      *           MD055891
     C*****KRSSK         READE     @MEXCG8                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare QCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBMEXJW0                                                              MD055891
     C+ where DKMECN = :P1COTT and DKMECS = :P1CSEQ                                         MD055891
     C+ order by DKMECN, DKMECS                                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close QCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open QCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from QCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0503'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SKEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSK         READE     @MEXCG8                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from QCursor into :CBMEXC                                                MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   Setoff                                       90                    MD055891
     C                   IF        SQLCODE = 100                                            MD055891
     C                   Seton                                        90                    MD055891
     C                   Endif                                                              MD055891
     C                   END
      *================================================================
     CSR   SKEXIT        ENDSR
      /EJECT
     CSR   SLRVGN        BEGSR
      *================================================================
      * Check Mod Cons Exists - Module Conditions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    DJCOTT        WQSL01                         Component Name
     C     *LIKE         DEFINE    DJCSEQ        WQSL02                         Component Seque
      * Define keylist
     C     KRSSL         KLIST
     C                   KFLD                    WQSL01                         Component Name
     C                   KFLD                    WQSL02                         Component Seque
      * Move fields to key list
     C                   MOVEL     #1COTT        WQSL01                         Component Name
     C                   MOVEL     #1CSEQ        WQSL02                         Component Seque
     C*****KRSSL         SETLL     @DJREGN                                      *           MD055891
     C*****KRSSL         READE     @DJREGN                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare C3Cursor insensitive scroll cursor for                                      MD055891
     C+ select * from CBMDCJW0                                                              MD055891
     C+ where DJCOTT = :WQSL01 and DJCSEQ = :WQSL02                                         MD055891
     C+ order by DJCOTT, DJCSEQ, DJMCUN                                                     MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open C3Cursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from C3Cursor into :CBMDCN                                               MD055891
     C/END-EXEC                                                                             MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE = 100                                            MD055891
      * Data record not found
     C                   MOVEL     'USR0501'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SLEXIT
     C                   END
      *
     C******IN90         DOWEQ     '0'                                                      MD055891
     C     SQLCODE       DOWEQ     0                                                        MD055891
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C*****KRSSL         READE     @DJREGN                                90    *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from C3Cursor into :CBMDCN                                               MD055891
     C/END-EXEC                                                                             MD055891
     C                   END
     C/EXEC SQL                                                                             MD055891
     C+ close C3Cursor                                                                      MD055891
     C/END-EXEC                                                                             MD055891
      *================================================================
     CSR   SLEXIT        ENDSR
      /EJECT
     CSR   SMRVGN        BEGSR
      *================================================================
      * RtvDlt Switchable F - COB - Switchable F - COB Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    ACCOTT        WQSM01                         Component Name
     C     *LIKE         DEFINE    ACCSEQ        WQSM02                         Component Seque
      * Define keylist
     C     KRSSM         KLIST
     C                   KFLD                    WQSM01                         Component Name
     C                   KFLD                    WQSM02                         Component Seque
      * Move fields to key list
     C                   MOVEL     DHCOTT        WQSM01                         Component Name
     C                   MOVEL     DHCSEQ        WQSM02                         Component Seque
     C*****KRSSM         SETLL     @SARCL2                                      *           MD056555
     C*****KRSSM         READE     @SARCL2                                90    *           MD056555
     C/EXEC SQL                                                                             MD056555
     C+ declare C2Cursor insensitive scroll cursor for                                      MD056555
     C+ select * from SCSRCJW0                                                              MD056555
     C+ order by ACCOTT, ACCSEQ                                                             MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ open C2Cursor                                                                       MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ fetch next from C2Cursor into :SCSARC                                               MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C******IN90         IFEQ      '1'                                                      MD056555
     C                   IF        SQLCODE = 100                                            MD056555
      * Data record not found
     C                   MOVEL     'CBM0006'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   GOTO      SMEXIT
     C                   END
      *
     C******IN90         DOWEQ     '0'                                                      MD056555
     C                   DOW       SQLCODE = 0                                              MD056555
      * USER: Process Data record
      * Delete all COB components with same component name and sequence n
      * Dlt    Switchable F - COB - Switchable F - COB Compnt  *
     C                   EXSR      SNDLRC
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C*****KRSSM         READE     @SARCL2                                90    *           MD056555
     C/EXEC SQL                                                                             MD056555
     C+ fetch next from C2Cursor into :SCSARC                                               MD056555
     C/END-EXEC                                                                             MD056555
     C                   END
     C/EXEC SQL                                                                             MD056555
     C+ close C2Cursor                                                                      MD056555
     C/END-EXEC                                                                             MD056555
      * USER: Exit processing
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      *================================================================
     CSR   SMEXIT        ENDSR
      /EJECT
     CSR   SNDLRC        BEGSR
      *================================================================
      * Dlt    Switchable F - COB - Switchable F - COB Compnt  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @SARCL0
     C                   MOVEL     DHCOTT        ACCOTT                         Component Name
     C                   MOVEL     DHCSEQ        ACCSEQ                         Component Seque
      *
     C     KLDLSN        KLIST
     C                   KFLD                    ACSARN                         Switchable Feat
     C                   KFLD                    ACCOTT                         Component Name
     C                   KFLD                    ACCSEQ                         Component Seque
     C*****KLDLSN        CHAIN     @SARCL0                            9091      *           MD056555
     C/EXEC SQL                                                                             MD056555
     C+ SELECT *                                                                            MD056555
     C+ into :SCSARC                                                                        MD056555
     C+ from SCSRCJW0                                                                       MD056555
     C+ where ACSARN = :ACSARN and ACCOTT = :ACCOTT and ACCSEQ = ACCSEQ                     MD056555
     C/END-EXEC                                                                             MD056555
     C******IN90         IFEQ      '1'                                                      MD056555
     C                   IF        SQLCODE = 100                                            MD056555
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SNEXIT
     C                   END
      *
     C******IN91         IFEQ      '1'                                                      MD056555
     C                   IF        SQLCODE <> 0                                             MD056555
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SNEXIT
     C                   END
      *
      *................................................................
     C**********         DELETE    @SARCL0                              91      *           MD056555
     C/EXEC SQL                                                                             MD056555
     C+ delete from SCSRCBTD                                                                MD056555
     C+ where ACSARN = :ACSARN and ACCOTT = :ACCOTT and ACCSEQ = ACCSEQ                     MD056555
     C/END-EXEC                                                                             MD056555
     C/EXEC SQL                                                                             MD056555
     C+ delete from SCSRCXTD                                                                MD056555
     C+ where ACSARN = :ACSARN and ACCOTT = :ACCOTT and ACCSEQ = ACCSEQ                     MD056555
     C/END-EXEC                                                                             MD056555
     C******IN91         IFEQ      '1'                                                      MD056555
     C                   IF        SQLCODE <> 0                                             MD056555
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SNEXIT        ENDSR
      /EJECT
     CSR   SOCHRC        BEGSR
      *================================================================
      * Change Components - Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @DHREGG
     C                   MOVEL     #1COTT        DHCOTT                         Component Name
     C                   MOVEL     #1CSEQ        DHCSEQ                         Component Seque
      *
     C     KLCHSO        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
     C*****KLCHSO        CHAIN     @DHREGG                            9091      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       9091                  MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   SETON                                        90                    MD055891
     C                   ENDIF                                                              MD055891
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055891
     C                   SETON                                        91                    MD055891
     C                   ENDIF                                                              MD055891
                                                                                            MD055891
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
     C                   eval      @1DBRC = CBCMPN                                          MD055891
      * Check for changed record
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C**********         UNLOCK    CBCMPNL0                             91      *           MD055891
     C                   GOTO      SOEXIT
     C                   END                                                    FI #1DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YARDCS
      * Move non-key fields to @DHREGG
     C                   MOVEL     #1CSTS        DHCSTS                         Component Statu
     C                   Z-ADD     #1CSHP        DHCSHP                         Scheduling Prio
     C                   Z-ADD     #1CEPY        DHCEPY                         Execution Prior
     C                   Z-ADD     #1CTSL        DHCTSL                         Timeslice
     C                   MOVEL     #1CFOB        DHCFOB                         FCOOB Error Acc
     C                   MOVEL     #1CTXT        DHCTXT                         Component Text
     C                   MOVEL     #1CPRM        DHCPRM                         Execution Param
     C                   MOVEL     #1CRQD        DHCRQD                         Sel for Today's
     C                   MOVEL     #1CMOD        DHCMOD                         Module
     C                   MOVEL     #1CEMI        DHCEMI                         Complex Module
     C                   MOVEL     #1CRES        DHCRES                         Restart Flag
     C                   Z-ADD     #1CODP        DHCODP                         No.Outstndng De
     C                   MOVEL     #1CMEF        DHCMEF                         Mut.Exclusive C
     C                   MOVEL     #1CFRQ        DHCFRQ                         Run Conditions
     C                   Z-ADD     #1CSDE        DHCSDE                         Start Date
     C                   Z-ADD     #1CSTI        DHCSTI                         Start Time
     C                   Z-ADD     #1CEDE        DHCEDE                         End Date
     C                   Z-ADD     #1CETI        DHCETI                         End Time
     C                   MOVEL     #1CHTB        DHCHTB                         Halt Before
     C                   MOVEL     #1CHTA        DHCHTA                         Halt After
     C                   MOVEL     #1CFAL        DHCFAL                         Component Faile
     C                   Z-ADD     #1EODT        DHEODT                         End of Day Run
     C                   Z-ADD     #1EOMT        DHEOMT                         End of Month Ru
     C                   Z-ADD     #1BOMT        DHBOMT                         Begin of Month
     C                   Z-ADD     #1EOYT        DHEOYT                         End of Year Run
     C                   Z-ADD     #1EODC        DHEODC                         End of Day CPU
     C                   Z-ADD     #1EOMC        DHEOMC                         End of Month CP
     C                   Z-ADD     #1BOMC        DHBOMC                         Begin of Month
     C                   Z-ADD     #1EOYC        DHEOYC                         End of Year CPU
     C                   MOVEL     #1ABIC        DHABIC                         Allow Bypass in
     C                   MOVEL     #1CBSN        DHCBSN                         COB Stream Name
     C                   MOVEL     #1TASK        DHTASK                         Task Split Job
     C                   Z-ADD     #1TSNO        DHTSNO                         Number of Task
     C*                  MOVEL     #1MODE        DHMODE                         Mode        MD055891
      *
     C                   eval      @1DBRC = CBCMPN                                          MD055891
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C**********         UPDATE    @DHREGG                              91      *           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPXTD                                                                     MD055891
     C+  SET DHCSHP = :#1CSHP                                                               MD055891
     C+  ,   DHCEPY = :#1CEPY                                                               MD055891
     C+  ,   DHCTSL = :#1CTSL                                                               MD055891
     C+  ,   DHCPRM = :#1CPRM                                                               MD055891
     C+  ,   DHCEMI = :#1CEMI                                                               MD055891
     C+  ,   DHCODP = :#1CODP                                                               MD055891
     C+  ,   DHCMEF = :#1CMEF                                                               MD055891
     C+  ,   DHCFRQ = :#1CFRQ                                                               MD055891
     C+  ,   DHCSDE = :#1CSDE                                                               MD055891
     C+  ,   DHCSTI = :#1CSTI                                                               MD055891
     C+  ,   DHCEDE = :#1CEDE                                                               MD055891
     C+  ,   DHCETI = :#1CETI                                                               MD055891
     C+  ,   DHEODT = :#1EODT                                                               MD055891
     C+  ,   DHEOMT = :#1EOMT                                                               MD055891
     C+  ,   DHBOMT = :#1BOMT                                                               MD055891
     C+  ,   DHEOYT = :#1EOYT                                                               MD055891
     C+  ,   DHEODC = :#1EODC                                                               MD055891
     C+  ,   DHEOMC = :#1EOMC                                                               MD055891
     C+  ,   DHBOMC = :#1BOMC                                                               MD055891
     C+  ,   DHEOYC = :#1EOYC                                                               MD055891
     C+  ,   DHABIC = :#1ABIC                                                               MD055891
     C+  ,   DHTSNO = :#1TSNO                                                               MD055891
     C+ WHERE DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
      * we may also have to update the BTD record                                           MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPBTD                                                                     MD055891
     C+  SET DHCFOB = :#1CFOB                                                               MD055891
     C+  ,   DHCTXT = :#1CTXT                                                               MD055891
     C+  ,   DHCMOD = :#1CMOD                                                               MD055891
     C+  ,   DHTASK = :#1TASK                                                               MD055891
     C+ WHERE DHCOTT = :#1COTT and DHCSEQ = :#1CSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C                   ELSE
      * Release record lock
     C**********         UNLOCK    CBCMPNL0                             91      *           MD055891
     C                   END
     C******IN91         IFEQ      '1'                                                      MD055891
     C                   IF        SQLCODE <> 0                                             MD055891
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   eval      @1DBRC = CBCMPN                                          MD055891
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
      * USER: Processing after Data update
      * Start of S01417
      * Pass back 'Y' to parameter if DBF update complete
     C                   MOVEL     'Y'           P2SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SOEXIT        ENDSR
      /EJECT
     CSR   SPRVGN        BEGSR
      *================================================================
      * First Record ? - Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KPSSP         KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Move fields to key list
     C                   MOVEL     *BLANK        DHCOTT                         Component Name
     C                   MOVEL     '*ZERO'       DHCSEQ                         Component Seque
     C*****KPSSP         SETLL     @DHREGH                                      *
     C**********         READ      @DHREGH                                90    *
     C/EXEC SQL                                                                             MD055891
     C+ declare BCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ where DHCOTT like '%'                                                               MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close BCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open BCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ get diagnostics :TotRow  = db2_number_rows                                          MD055891
     C/END-EXEC                                                                             MD055891
     C                   IF        TotRow = 0                                               MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
      * Data record not found
     C                   MOVEL     'USR0497'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     '*NOCOMP'     W0RTN                          *Return code
     C                   GOTO      SPEXIT
     C                   END
      *
     C******IN90         DOWEQ     '0'                                                      MD055891
      * USER: Process Data record
     C                   MOVEL     '*COMPFD'     W0RTN                          *Return code
     C**********         READ      @DHREGH                                90    *           MD055891
     C**********         END                                                                MD055891
      *================================================================
     CSR   SPEXIT        ENDSR
      /EJECT
     CSR   SQCRRC        BEGSR
      *================================================================
      * Create Components - Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DHREGG
     C                   MOVE      *BLANK        DHCOTT                         Component Name
     C**********           MOVEL'COBEND'  DHCOTT           Component Name                     CCB020
     C                   MOVEL     SCOBFI        DHCOTT                         Component Name
     C                   MOVEL     '00001'       DHCSEQ                         Component Seque
     C                   MOVEL     *BLANK        DHCSTS                         Component Statu
     C                   Z-ADD     1             DHCSHP                         Scheduling Prio
     C                   Z-ADD     20            DHCEPY                         Execution Prior
     C                   Z-ADD     10000         DHCTSL                         Timeslice
     C                   MOVEL     'Y'           DHCFOB                         FCOOB Error Acc
     C                   MOVEL     *BLANK        DHCTXT                         Component Text
     C                   MOVEL     *BLANK        DHCPRM                         Execution Param
     C                   MOVEL     'Y'           DHCRQD                         Sel for Today's
     C                   MOVEL     'CB'          DHCMOD                         Module
     C                   MOVEL     'N'           DHCEMI                         Complex Module
     C                   MOVEL     'N'           DHCRES                         Restart Flag
     C                   Z-ADD     *ZERO         DHCODP                         No.Outstndng De
     C                   MOVEL     'N'           DHCMEF                         Mut.Exclusive C
     C                   MOVEL     '01'          DHCFRQ                         Run Conditions
     C                   Z-ADD     *ZERO         DHCSDE                         Start Date
     C                   Z-ADD     *ZERO         DHCSTI                         Start Time
     C                   Z-ADD     *ZERO         DHCEDE                         End Date
     C                   Z-ADD     *ZERO         DHCETI                         End Time
     C                   MOVEL     'N'           DHCHTB                         Halt Before
     C                   MOVEL     'N'           DHCHTA                         Halt After
     C                   MOVEL     'N'           DHCFAL                         Component Faile
     C                   Z-ADD     2000          DHEODT                         End of Day Run
     C                   Z-ADD     2700          DHEOMT                         End of Month Ru
     C                   Z-ADD     2000          DHBOMT                         Begin of Month
     C                   Z-ADD     3600          DHEOYT                         End of Year Run
     C                   Z-ADD     *ZERO         DHEODC                         End of Day CPU
     C                   Z-ADD     *ZERO         DHEOMC                         End of Month CP
     C                   Z-ADD     *ZERO         DHBOMC                         Begin of Month
     C                   Z-ADD     *ZERO         DHEOYC                         End of Year CPU
     C                   MOVEL     'N'           DHABIC                         Allow Bypass in
     C                   MOVEL     *BLANK        DHCBSN                         COB Stream Name
     C                   MOVEL     'N'           DHTASK                         Task Split Job
     C                   Z-ADD     *ZERO         DHTSNO                         Number of Task
      *
      * USER: Processing before Data update
      * CASE: DB1.Sel for Today's COB Flag is Blank
     C     DHCRQD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           DHCRQD                         Sel for Today's
     C                   MOVEL     *BLANK        DHCSTS                         Component Statu
     C                   MOVEL     'N'           DHCRES                         Restart Flag
     C                   Z-ADD     *ZERO         DHCSDE                         Start Date
     C                   Z-ADD     *ZERO         DHCSTI                         Start Time
     C                   Z-ADD     *ZERO         DHCEDE                         End Date
     C                   Z-ADD     *ZERO         DHCETI                         End Time
     C                   MOVEL     'N'           DHCHTB                         Halt Before
     C                   MOVEL     'N'           DHCHTA                         Halt After
     C                   MOVEL     'N'           DHCFAL                         Component Faile
     C                   END                                                    *FI
     C     KLCRSQ        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Check for duplicate primary key
     C*****KLCRSQ        SETLL     @DHREGG                                90    *           MD055891
     C                   MOVEL     DHCOTT        WDHCOTT          10                        MD055891
     C                   MOVEL     DHCSEQ        WDHCSEQ           5                        MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare XCursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ where DHCOTT = :WDHCOTT and DHCSEQ = :WDHCSEQ                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open XCursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ get diagnostics :TotRow  = db2_number_rows                                          MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close XCursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C                   IF        TotRow  > 0                                              MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C                   MOVEL     'USR0498'     W0RTN             7
      * Send message 'Components             EX'
     C                   MOVEL     'USR0498'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SQEXIT
     C                   END
      *
      * Let's not do that for now as file will never be empty                               MD055891
     C**********         WRITE     @DHREGG                              91      *           MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * Start of S01417
      * Pass back 'Y' to parameter if DBF update complete
     C                   MOVEL     'Y'           P2SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SQEXIT        ENDSR
      /EJECT
     CSR   SRCRRC        BEGSR
      *================================================================
      * Create Components - Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DHREGG
     C                   MOVE      *BLANK        DHCOTT                         Component Name
     C                   MOVEL     'COBBEGIN'    DHCOTT                         Component Name
     C                   MOVEL     '00001'       DHCSEQ                         Component Seque
     C                   MOVEL     *BLANK        DHCSTS                         Component Statu
     C                   Z-ADD     1             DHCSHP                         Scheduling Prio
     C                   Z-ADD     20            DHCEPY                         Execution Prior
     C                   Z-ADD     10000         DHCTSL                         Timeslice
     C                   MOVEL     'Y'           DHCFOB                         FCOOB Error Acc
     C                   MOVEL     *BLANK        DHCTXT                         Component Text
     C                   MOVEL     *BLANK        DHCPRM                         Execution Param
     C                   MOVEL     'Y'           DHCRQD                         Sel for Today's
     C                   MOVEL     'CB'          DHCMOD                         Module
     C                   MOVEL     'N'           DHCEMI                         Complex Module
     C                   MOVEL     'N'           DHCRES                         Restart Flag
     C                   Z-ADD     *ZERO         DHCODP                         No.Outstndng De
     C                   MOVEL     'N'           DHCMEF                         Mut.Exclusive C
     C                   MOVEL     '01'          DHCFRQ                         Run Conditions
     C                   Z-ADD     *ZERO         DHCSDE                         Start Date
     C                   Z-ADD     *ZERO         DHCSTI                         Start Time
     C                   Z-ADD     *ZERO         DHCEDE                         End Date
     C                   Z-ADD     *ZERO         DHCETI                         End Time
     C                   MOVEL     'N'           DHCHTB                         Halt Before
     C                   MOVEL     'N'           DHCHTA                         Halt After
     C                   MOVEL     'N'           DHCFAL                         Component Faile
     C                   Z-ADD     1800          DHEODT                         End of Day Run
     C                   Z-ADD     2700          DHEOMT                         End of Month Ru
     C                   Z-ADD     2000          DHBOMT                         Begin of Month
     C                   Z-ADD     3600          DHEOYT                         End of Year Run
     C                   Z-ADD     *ZERO         DHEODC                         End of Day CPU
     C                   Z-ADD     *ZERO         DHEOMC                         End of Month CP
     C                   Z-ADD     *ZERO         DHBOMC                         Begin of Month
     C                   Z-ADD     *ZERO         DHEOYC                         End of Year CPU
     C                   MOVEL     'N'           DHABIC                         Allow Bypass in
     C                   MOVEL     *BLANK        DHCBSN                         COB Stream Name
     C                   MOVEL     'N'           DHTASK                         Task Split Job
     C                   Z-ADD     *ZERO         DHTSNO                         Number of Task
      *
      * USER: Processing before Data update
      * CASE: DB1.Sel for Today's COB Flag is Blank
     C     DHCRQD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'N'           DHCRQD                         Sel for Today's
     C                   MOVEL     *BLANK        DHCSTS                         Component Statu
     C                   MOVEL     'N'           DHCRES                         Restart Flag
     C                   Z-ADD     *ZERO         DHCSDE                         Start Date
     C                   Z-ADD     *ZERO         DHCSTI                         Start Time
     C                   Z-ADD     *ZERO         DHCEDE                         End Date
     C                   Z-ADD     *ZERO         DHCETI                         End Time
     C                   MOVEL     'N'           DHCHTB                         Halt Before
     C                   MOVEL     'N'           DHCHTA                         Halt After
     C                   MOVEL     'N'           DHCFAL                         Component Faile
     C                   END                                                    *FI
     C     KLCRSR        KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Check for duplicate primary key
     C*****KLCRSR        SETLL     @DHREGG                                90    *           MD055891
     C******IN90         IFEQ      '1'                                                      MD055891
     C**********         MOVEL     'USR0498'     W0RTN             7                        MD055891
      * Send message 'Components             EX'                                            MD055891
     C**********         MOVEL     'USR0498'     ZAMSID                                     MD055891
     C**********         EXSR      ZASNMS                                                   MD055891
     C**********         GOTO      SREXIT                                                   MD055891
     C**********         END                                                                MD055891
      *
     C**********         WRITE     @DHREGG                              91      *           MD055891
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
      * Start of S01417
      * Pass back 'Y' to parameter if DBF update complete
     C                   MOVEL     'Y'           P2SUPD                         Successful Upda
      * End of S01417
     C                   END
      *================================================================
     CSR   SREXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1COTT        WK1X01            1
     C                   MOVEL     #1CSEQ        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Component Name
     C     WK1X02        OREQ      '?'                                          Component Seque
     W* Y2W0053 - One or more arguments defaulted to available contexts
      * Field '(KEY) #1COTT' defaulted for 'Component Name'.
      * Field '(KEY) #1CSEQ' defaulted for 'Component Sequence Number'.
     C                   CALL      'CB0404S'                            90      Select Componen
     C                   PARM      *BLANK        W0RTN             7
     C     #1COTT        PARM      #1COTT        WQ0036           10            Component Name
     C     #1CSEQ        PARM      #1CSEQ        WQ0037            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0404S'     W0CLPG
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
     C                   SETON                                        993132    *
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
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
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
      * Define work field Action Code
     C                   MOVEL     *BLANK        WUANCD            1
      * Define work field Display No. task Split Jb
     C                   MOVEL     *BLANK        WUDNSJ            1
      * Define work field ZALIGN Screen Fun Field
     C                   MOVEL     *BLANK        WUZASF           16
      * Define work field ZALIGN File Field
     C                   MOVEL     *BLANK        WUZAFF           16
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field *Return code
     C                   MOVEL     *BLANK        WURTN             7
      * Define work field Complex Module Conds Flag
     C                   MOVEL     *BLANK        WUCEMI            1
      * Define work field Mut.Exclusive Comps.Flag
     C                   MOVEL     *BLANK        WUCMEF            1
      * Define work field Cob end/begin
     C                   MOVEL     *BLANK        WULLST            1
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUJ8ST            1
      * Define work field Component Sequence Number
     C                   MOVEL     *BLANK        WUCSEQ            5
      * Define work field Component Name
     C                   MOVEL     *BLANK        WUCOTT           10
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field S01491
     C                   MOVEL     *BLANK        WUVANT            1
      * Define work field S01517
     C                   MOVEL     *BLANK        WUACBP            1
      * Define work field Run Condition Text (Scrn)
     C                   MOVEL     *BLANK        WURUNS           70
      * Define work field COB Run Condition Text
     C                   MOVEL     *BLANK        WURUNT           70
      * Define work field work flag
     C                   MOVEL     *BLANK        WUJEST            1
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUAUST            1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUE3ST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUF1ST            1
      * Define work field Access Obj Return Code
     C                   MOVEL     *BLANK        WURTCD            7
      * Define work field Access Obj Rec Fmt (200)
     C                   MOVEL     *BLANK        WUFMT           200
      * Define work field COB Bypass Flag
     C                   MOVEL     *BLANK        WUCBBF            1
      * Define work field NUM QUESTION MARK
     C                   MOVEL     *BLANK        WUEBCD            6
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      *                                                                                       CCB020
      ** Set SCOBFINISH variable                                                              CCB020
      *                                                                                       CCB020
     C                   MOVEL     'SCOBFINI'    SCOBFI           10
     C                   MOVE      'SH'          SCOBFI
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
      * Open files
     C                   OPEN      CB0400R#
     C**********         OPEN      CBCMPNL1                                                 MD055891
     C**********         OPEN      CBRUNCL1                                                 MD055891
     C**********         OPEN      CBMDCNL1                                                 MD055891
     C**********         OPEN      CBMEXCL1                                                 MD055891
     C**********         OPEN      CBMEXCL2                                                 MD055891
     C**********         OPEN      CBDPRLL1                                                 MD055891
     C**********         OPEN      CBDPRLL2                                                 MD055891
     C**********         OPEN      SCSARCL2                                                 MD056555
     C**********         OPEN      CBCMPNL0                                                 MD055891
     C**********         OPEN      SCSARCL0                                                 MD056555
     C                   MOVEL     'N'           W0PMT             1
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
      * Change mode
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of change S01459.
      * CB0400R Precompiler - Components  *
      * Remove the Last Amend Box and Creation Parameters functions.
      * End of change S01459.
      * Copyright Statement 1988 - Standard functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      * Start of change S01491.
      * Check to see if Autocall is present.
      * Check for Switchable Feat - Standard functions  *
     C                   CALL      'AOSARDR0'                           90      Check for Switc
     C     WURTCD        PARM      *BLANK        WQ0084            7            Access Obj Retu
     C                   PARM      '*VERIFY'     WQ0085            7            Access Obj Acce
     C                   PARM      'S01491'      WQ0086            6            Switchable Feat
     C     WUFMT         PARM      *BLANK        WQ0087          200            Access Obj Rec
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
      * If Autocall is present.
      * CASE: WRK.Access Obj Return Code is Normal - no errors found
     C     WURTCD        IFEQ      *BLANK                                       *IF
     C                   MOVEL     'Y'           WUVANT                         S01491
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'N'           WUVANT                         S01491
     C                   END                                                    *FI
      * End of change S01491.
      * Start of change S01517.
      * Check to see if COB bypass is allowed.
      * SDCOBPPD Data Structure - Standard functions  *
      * SC ICD Access Object - Standard functions  *
     C                   CALL      'AOCOBPR0'                           90      SC ICD Access O
     C     WURTCD        PARM      *BLANK        WQ0088            7            Access Obj Retu
     C                   PARM      '*FIRST'      WQ0089            7            Access Obj Acce
     C     WUFMT         PARM      *BLANK        WQ0090          200            Access Obj Rec
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'AOCOBPR0'    W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   MOVEL     WUCBBF        WUACBP                         S01517
      * End of change S01517.
      * First Record ? - Components  *
     C                   EXSR      SPRVGN
      **If*there*are*no*records*create*COBBEGIN*and*COBEND.************                       CCB020
      ** If there are no records create COBBEGIN and SCOBFINISH.                              CCB020
      * CASE: PGM.*Return code is No Component Record Found
     C     W0RTN         IFEQ      '*NOCOMP'                                    *IF
      * Create Components - Components  *
     C                   EXSR      SQCRRC
      * Create Components - Components  *
     C                   EXSR      SRCRRC
     C                   END                                                    *FI
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   MOVEL     *BLANK        WUEBCD                         NUM QUESTION MA
     C                   MOVEL     '?'           WUEBCD                         NUM QUESTION MA
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
     C/COPY WNCPYSRC,CB0400RPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0400RPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055891
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055891
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0400RPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
