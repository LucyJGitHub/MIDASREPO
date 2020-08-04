     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas MA Edit reps for collation')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Microfiche/Optical Disk Archiving Module
     F*                                                               *
     F*  MA0330R - EDIT REPORTS FOR COLLATION                         *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 028265             Date 20Sep93               *
      *                 S01407             Date 26Jan93               *
     F*                 LN1292             DATE 06JUN91               *
     F*                 LN1252             DATE 16APR91               *
     F*                 LN1190             DATE 26APR91               *
     F*                 LN1147             DATE 15APR91               *
     F*                 LN0661             DATE 12SEP90               *
     F*                 LN0634             DATE 15AUG90               *
     F*                 LN0587             DATE 01AUG90               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
     F*  028265 - Save parameter fields so that when F12 is pressed   *
     F*           amendment on print file name field will be reflected*
     F*           on MA0330V.                                         *
     F*  S01407 - SWITCHABILITY ENHANCEMENTS                          *
     F*  LN1292 - 1. CORRECT THE PROCESSING FOR CF12                  *
     F*           2. REMOVE THE SWITCH BETWEEN 'ADD' AND              *
     F*              'CHANGE' MODES FROM THE 'ADD' SCREEN             *
     F*  LN1252 - REMOVE 'Y2' SYNON MESSAGES AND REPLACE WITH         *
     F*           'RCF' MESSAGES.                                     *
     F*  LN1190 - REMOVE 'USR' MESSAGES AND REPLACE WITH 'RCF'        *
     F*           MESSAGES.                                           *
     F*  LN1147 - 1. CF05 NOT USED IN PROGRAM                         *
     F*           2. CF10 ENABLED ONLY IN DELETE MODE                 *
     F*           3. CHANGE ERROR MESSAGE Y2U0001 TO EQUIVALENT IN    *
     F*              MSG FILE FCUSRMSG - RCF1074                      *
     F*  LN0634 - AMEND FILE NAME RCOL TO MARCOLPD IN                 *
     F*           ARRAY @CN FOR USE BY SDFCTLPA                       *
     F*  LN0587 - COLLATION FLAG NOW ON RSFX NOT REPT                 *
     F*                                                               *
     F*****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *                                                               *
      *****************************************************************
     F*Reports for Colln Edit   Initialise Program F-spec
     F/COPY WNCPYSRC,MA0330RFPG
     FMA0330R#  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
      * DSP: Edit Reps for Collation   Edit record(1 screen)
      *
     FMARCOLL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
      * RTV: Reports For Collation     Retrieval index
      *
     F***********FCREPTL1IF  E           K        DISK                    S01407
     F*FCREPTJ0* IF   E           K DISK                                         S01407     MD055265
      * RTV: Report Descriptions       Retrieval index
      *
     F***********FCRSFXL1IF  E           K        DISK                    S01407
     F*FCRSFXJ0* IF   E           K DISK                                         S01407     MD055265
      * RTV: Report Suffix             Retrieval index
      *
     FMARCOLL0  UF A E           K DISK    USROPN
     F                                     COMMIT
      * UPD: Reports For Collation     Update index
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
      * UPD: Standing Data Controls    Update index
      *
     D AENA            S             78    DIM(3) CTDATA PERRCD(1)
      *
     D ARGV            S             78    DIM(3) CTDATA PERRCD(1)
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*Reports for Colln Edit   Initialise Program E-spec
     D/COPY WNCPYSRC,MA0330REPG
     D @CN             S             25    DIM(12) CTDATA PERRCD(1)             Long constants.
     D*Reports for Colln Edit   Initialise Program I-spec
     D/COPY WNCPYSRC,MA0330RIPG
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file data structure.
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure.
      *
     D @1DBRC        E DS                  EXTNAME(MARCOLL0)
      * Current/previous master file format fields for change control.
     D FCREPT        E DS                  EXTNAME(FCREPJW1)                                MD055265
     D NullInds        s              5i 0 dim(19)                                          MD055265
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
      *
     D #1DBRC          DS            85
      * Stored master file format fields.
     D  #1DB1                  1      1
      *
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      /EJECT
      * Parameter declarations.
     D P1PARM          DS            21
      * KEY: Reports For Collation     Retrieval index
      * I:MAP Report name
     D  P1RNAM                 1     10
      * I:MAP Print File Name
     D  P1RSFX                11     20
      * I:MAP Collation Freqency
     D  P1CLFR                21     21
     D P2PARM          DS
      * B:    Action Code
     D  P2JTST                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Report not found'
      * Report name
     D  ZA0001                 1     10
      * Message data for 'Can't Collate Report'
      * Report name
     D  ZA0002                 1     10
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C                   PARM                    P1PARM                         KEY: Reports Fo
     C     P2JTST        PARM      P2JTST        WP0001            1            Action Code
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
     C* Enable CF10 in 'Delete Mode' only                                 LN1147
     C     P2JTST        IFEQ      @CN(05)                                                     LN114
     C                   SETON                                        21                       LN114
     C                   END                                                                   LN114
      *                                                                   LN1147
      * Check passed parameters.
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat.
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen.
     C                   EXSR      BADSKY
     C                   END
      * Terminate program.
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen.
      *================================================================
      * Initialise key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible.
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction.
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'R'
      * Ensure transaction continues (if reset).
     C                   MOVEL     'Y'           W0TRN             1
      * Initialise detail screen.
     C                   EXSR      MAIZ#1
      * Conduct screen conversation:
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1RNAM        IFEQ      *BLANK                                       Report name
     C     #1RSFX        OREQ      *BLANK                                       Print File Name
     C     #1CLFR        OREQ      *BLANK                                       Collation Freqe
      * One or more key field is blank.
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen.
     C     W0BYP         IFNE      'Y'
      * Display key screen.
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass.
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      **Switch*between**ADD/*CHANGE*modes.***************************     LN1292
     C***09******          CAS            BCCHMD                          LN1292
      * HOME: Reset screen fields.
     C***05******          CAS            BDHMKY                          LN1292
     C   12              CAS                     BDHMKY                                        LN129
      * Process key screen input.
     C                   CAS                     BEPRKY
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
      * Set screen conditioning indicators.
     C                   EXSR      GADSAK
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
      * PUTOVR unless conditioned fields change.
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator.
     C                   SETOFF                                           99    *
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     C*SR********BCCHMD    BEGSR                                          LN1292
      *================================================================
      **Switch*between*ADD*and*CHANGE*modes.************************      LN1292
      *================================================================
     C***********W0PMD     IFEQ 'ADD'                                     LN1292
     C***********          MOVEL'CHG'     W0PMD   3                       LN1292
     C***********          ELSE                                           LN1292
     C***********          MOVEL'ADD'     W0PMD                           LN1292
     C***********          END                                            LN1292
      *================================================================
     C*SR********BCEXIT    ENDSR                                          LN1292
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
      * Process key screen.
      *================================================================
      * Validate key fields.
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record.
     C     KRTV          KLIST
     C                   KFLD                    D4RNAM                         Report name
     C                   KFLD                    D4RSFX                         Print File Name
     C                   KFLD                    D4CLFR                         Collation Freqe
      * Setup key.
     C                   MOVEL     #1RNAM        D4RNAM                         Report name
     C                   MOVEL     #1RSFX        D4RSFX                         Print File Name
     C                   MOVEL     #1CLFR        D4CLFR                         Collation Freqe
     C     KRTV          CHAIN     @D4REI3                            9091      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   SETON                                        993132    *
     C                   SETON                                        33        *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * Verify record existance against program mode
     C     W0PMD         IFNE      'ADD'
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        993132    *
     C                   SETON                                        33        *
      * Send message 'Reports For Collation  NF'
     C**********           MOVEL'USR0726' ZAMSID           Message id.    LN1190
     C                   MOVEL     'RCF0726'     ZAMSID                         Message id.    LN119
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
     C*********************MOVEL*BLANK    #DARST           Frequency for DLN0661
     C                   MOVEL     #1CLFR        #DARST                         Frequency for DLN066
      * 07 /COPY FC0330RSFF - Reports For Collation  *
     C*Reports for Colln Edit   Calc Detail Function Flds
     C/COPY WNCPYSRC,MA0330RSFF
      * USER: Initialise detail screen (existing record)
     C                   MOVEL     @CN(01)       WUAJST                         Key Screen Flag
      * Set-up DTL Screen Footer - standard functions  *
     C     P2JTST        IFEQ      'D'
     C                   MOVEA     AENA(1)       ##AENA
     C                   END
      *
     C     P2JTST        IFEQ      'A'
     C                   MOVEA     AENA(2)       ##AENA
     C                   END
      *
     C     P2JTST        IFEQ      'I'
     C                   MOVEA     AENA(3)       ##AENA
     C                   END
      *
      *CASE:     DTL.Collation Freqency is BLANK
     C***********#1CLFR****IFEQ @CN,02                     *IF            LN0661
     C*********************MOVEL*BLANK    #DARST           Frequency for DLN0661
     C*********************ELSE                                           LN0661
      *CASE:******OTHERWISE                                               LN0661
     C                   MOVEL     #1CLFR        #DARST                         Frequency for D
     C*********************END                             *FI            LN0661
      * 04 /COPY FC0330RISE - Reports For Collation  *
     C*Reports for Colln Edit   Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,MA0330RISE
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        993132    *
     C                   SETON                                        33        *
      * Send message 'Reports For Collation  EX'
     C**********           MOVEL'USR0727' ZAMSID           Message id.    LN1190
     C                   MOVEL     'RCF0727'     ZAMSID                         Message id.    LN119
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      * USER: Initialise detail screen (new record)
     C                   MOVEL     @CN(01)       WUAJST                         Key Screen Flag
      * Set-up DTL Screen Footer - standard functions  *
     C     P2JTST        IFEQ      'D'
     C                   MOVEA     AENA(1)       ##AENA
     C                   END
     C     P2JTST        IFEQ      'A'
     C                   MOVEA     AENA(2)       ##AENA
     C                   END
     C     P2JTST        IFEQ      'I'
     C                   MOVEA     AENA(3)       ##AENA
     C                   END
      *CASE:     DTL.Collation Report Desc is blank
     C     #1CRDS        IFEQ      *BLANK                                       *IF
      * Get report description - Report Descriptions  *
     C                   EXSR      SARVGN
     C                   MOVEL     WURDSC        #1CRDS                         Collation Repor
     C                   END                                                    *FI
      *CASE:     DTL.Collation Freqency is BLANK
     C***********#1CLFR****IFEQ @CN,02                     *IF            LN0661
     C*********************MOVEL*BLANK    #DARST           Frequency for DLN0661
     C*********************ELSE                                           LN0661
      *CASE:******OTHERWISE                                               LN0661
     C                   MOVEL     #1CLFR        #DARST                         Frequency for D
     C*********************END                             *FI            LN0661
      * 03 /COPY FC0330RISN - Reports For Collation  *
     C*Reports for Colln Edit   Initialise Dtl New Rcd
     C/COPY WNCPYSRC,MA0330RISN
     C                   END
     C                   END
      *.................................................
     C   99              GOTO      BEEXIT
      * No errors: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields.
      *================================================================
     C*                                                                   028265
     C** Save parameter fields                                            028265
     C*                                                                   028265
     C                   MOVEL     #1RNAM        P1RNAM                         Report name    02826
     C                   MOVEL     #1RSFX        P1RSFX                         Print File Name02826
     C                   MOVEL     #1CLFR        P1CLFR                         Collation Freqe02826
      * Validate Collation Freqency
      * Name search required ?
     C                   MOVEL     #1CLFR        W0NSRQ            1            Collation Freqe
     C     W0NSRQ        IFEQ      '?'                                          Search required
     C                   CALL      'FCVLLSR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100271       Y2LSNO            7 0          List number.
     C     #1CLFR        PARM      #1CLFR        W0EXVL           20            Collation Freqe
     C                   MOVEL     'Y'           W0DCF             1            Defer confirm
     C                   END
     C     W0PMD         IFNE      'ADD'
     C                   END
      * Check relations.
      * Check reference to Report Suffix.
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        993132    *
     C                   END
      * USER: Validate key screen
      * 02 /COPY FC0330RVKS - Reports For Collation  *
     C*Reports for Colln Edit   Validate Key Screen
     C/COPY WNCPYSRC,MA0330RVKS
      * Report name required.
     C     #1RNAM        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C***********          MOVEL'Y2U0001' ZAMSID           Message id.    LN1147
     C***********          MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1147
     C                   MOVEL     'RCF1074'     ZAMSID                         Message id.    LN114
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN114
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Print File Name required.
     C     #1RSFX        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C***********          MOVEL'Y2U0001' ZAMSID           Message id.    LN1147
     C***********          MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1147
     C                   MOVEL     'RCF1074'     ZAMSID                         Message id.    LN114
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN114
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Collation Freqency required.
     C     #1CLFR        IFEQ      *BLANK                                       IF
     C                   SETON                                        9933      *
      * Send message '*Value required'
     C***********          MOVEL'Y2U0001' ZAMSID           Message id.    LN1147
     C***********          MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1147
     C                   MOVEL     'RCF1074'     ZAMSID                         Message id.    LN114
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN114
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
     C*                                                                   028265
     C** Collation frequency field - Check for valid values               028265
     C*                                                                   028265
     C     #1CLFR        IFNE      'A'                                                         02826
     C     #1CLFR        ANDNE     'D'                                                         02826
     C     #1CLFR        ANDNE     'B'                                                         02826
     C     #1CLFR        ANDNE     '5'                                                         02826
     C     #1CLFR        ANDNE     '1'                                                         02826
     C     #1CLFR        ANDNE     '6'                                                         02826
     C     #1CLFR        ANDNE     '7'                                                         02826
     C     #1CLFR        ANDNE     '4'                                                         02826
     C     #1CLFR        ANDNE     '2'                                                         02826
     C     #1CLFR        ANDNE     '3'                                                         02826
     C     #1CLFR        ANDNE     'Y'                                                         02826
     C     #1CLFR        ANDNE     'Z'                                                         02826
     C                   MOVEL     'RCF0067'     ZAMSID                                        02826
     C                   SETON                                        3399                     02826
     C                   EXSR      ZASNMS                                                      02826
     C                   END                                                                   02826
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process details.
      *================================================================
      * Conduct detail screen conversation:
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen.
     C                   EXSR      CBEXFM
      * Process response to detail screen:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * Process detail screen input.
     C                   CAS                     CFPRSC
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests.
      *================================================================
      * Set screen conditioning indicators.
     C                   EXSR      GBDSAD
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
      * PUTOVR unless conditioned fields change.
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator.
     C                   SETOFF                                           99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen.
      *================================================================
      * USER: Process key screen request
     C                   MOVEL     @CN(03)       WUAJST                         Key Screen Flag
      * 05 /COPY FC0330RPKR - Reports For Collation  *
     C*Reports for Colln Edit   Process Key Screen Rqst
     C/COPY WNCPYSRC,MA0330RPKR
     C                   MOVEL     @CN(04)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   MOVEL     'R'           W0TRN
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record.
      *================================================================
      * Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details.
     C  N10              CAS                     DCVLDL
     C                   END
      * Quit if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: Update record:
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details.
      *================================================================
      * Initialise virtual fields.
     C                   EXSR      MEIZ#1
      * USER: Validate detail screen fields
      *CASE:     PAR.Action Code is Delete
     C     P2JTST        IFEQ      @CN(05)                                      *IF
      *CASE:*****DTL.*CMD*key*is**Delete*******                           LN1147
     C************IN10     IFEQ '1'                        *IF            LN1147
     C***********          ELSE                                           LN1147
      *CASE:******OTHERWISE                                               LN1147
      **Send*message*'F3/F10/F12*only*valid*opt'***                       LN1147
     C***********          MOVEL'RCF0033' ZAMSID           Message id.    LN1147
     C***********          EXSR ZASNMS                     Send message   LN1147
     C***********          SETON                     99    *              LN1147
      ***********                                                         LN1147
     C***********          END                             *FI            LN1147
     C                   ELSE
      *CASE:     *OTHERWISE
      **Get*Collation*Flag*-*Report*Descriptions  *                       LN0587
     C******************** EXSR SBRVGN                                    LN0587
      *CASE:*****PGM.*Return*code*is**Record*does*not*exist               LN0587
     C***********W0RTN     IFEQ @CN,06                     *IF            LN0587
      **Setup*message*data*for*message.                                   LN0587
     C******************** MOVEL#1RNAM    ZA0001           Report name    LN0587
      **Send*message*'Report*not*found'                                   LN0587
     C******************** MOVEL'RCF0039' ZAMSID           Message id.    LN0587
     C******************** EXSR ZASNMS                     Send message   LN0587
     C******************** SETON                     99    *              LN0587
      ********************                                                LN0587
     C******************** ELSE                                           LN0587
      *CASE:******OTHERWISE                                               LN0587
      *CASE:*****WRK.Collation*is*No*********                             LN0587
     C***********WUCOLT    IFEQ @CN,01                     *IF            LN0587
      **Setup*message*data*for*message.********                           LN0587
     C***********          MOVEL#1RNAM    ZA0002           Report name    LN0587
      **Send*message*'Can't*Collate*Report'                               LN0587
     C***********          MOVEL'RCF0040' ZAMSID           Message id.    LN0587
     C***********          EXSR ZASNMS                     Send message   LN0587
     C***********          SETON                     99    *              LN0587
      ***********                                                         LN0587
     C***********          END                             *FI            LN0587
      *CASE:     DTL.Collation Report Desc is blank
     C     #1CRDS        IFEQ      *BLANK                                       *IF
      * Get report description - Report Descriptions  *
     C                   EXSR      SCRVGN
     C                   MOVEL     WURDSC        #1CRDS                         Collation Repor
     C                   END                                                    *FI
     C                   END                                                    *FI
     C************         END                             *FI            LN0587
      * 06 /COPY FC0330RVSF - Reports For Collation  *
     C*Reports for Colln Edit   Validate Detail Screen
     C/COPY WNCPYSRC,MA0330RVSF
      * CALC: Detail screen function fields
     C*********************MOVEL*BLANK    #DARST           Frequency for DLN0661
     C                   MOVEL     #1CLFR        #DARST                         Frequency for DLN066
      * 07 /COPY FC0330RSFF - Reports For Collation  *
     C*Reports for Colln Edit   Calc Detail Function Flds
     C/COPY WNCPYSRC,MA0330RSFF
      * USER: Validate detail screen relations
      * 08 /COPY FC0330RVSR - Reports For Collation  *
     C*Reports for Colln Edit   Validate Screen Relns
     C/COPY WNCPYSRC,MA0330RVSR
      * Collation Report Name required.
     C     #1CORP        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C***********          MOVEL'Y2U0001' ZAMSID           Message id.    LN1147
     C***********          MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1147
     C                   MOVEL     'RCF1074'     ZAMSID                         Message id.    LN114
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN114
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Collation Report Desc required.
     C     #1CRDS        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C***********          MOVEL'Y2U0001' ZAMSID           Message id.    LN1147
     C***********          MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1147
     C                   MOVEL     'RCF1074'     ZAMSID                         Message id.    LN114
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN114
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record.
      *================================================================
      * Process delete request.
     C   10              CAS                     EDDLRQ
      * Process add request.
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request.
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes.
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes.
     C                   COMMIT
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * 09 /COPY FC0330RPCK - Reports For Collation  *
     C*Reports for Colln Edit   Process Command Keys
     C/COPY WNCPYSRC,MA0330RPCK
      * Restart program for next record.
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request.
      *================================================================
      * USER: Create DBF record
      * Create Reports For Collat - Reports For Collation  *
     C                   EXSR      SDCRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C**********           MOVEL'Y2U0011' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1081'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request.
      *================================================================
      * USER: Delete DBF record
      * Delete Reports For Collat - Reports For Collation  *
     C                   EXSR      SFDLRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C**********           MOVEL'Y2U0013' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1082'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request.
      *================================================================
      * USER: Change DBF record
      * Change Reports For Collat - Reports For Collation  *
     C                   EXSR      SHCHRC
     C     W0RTN         IFNE      *BLANK
      * DBF Update error detected.
      * Reset screen fields if changed record.
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C**********           MOVEL'Y2U0012' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1083'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters.
      *================================================================
      * Is full key present?
     C     P1RNAM        IFEQ      *BLANK                                       Report name
     C     P1RSFX        OREQ      *BLANK                                       Print File Name
     C     P1CLFR        OREQ      *BLANK                                       Collation Freqe
      * Not every key field passed - loop program.
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program.
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen.
     C                   SETON                                        88        *
      * Enable key screen.
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields.
      *================================================================
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1CHTP                         Type of Last Ch
     C*********************MOVEL*BLANK    #DARST           Frequency for DLN0661
     C                   MOVEL     #1CLFR        #DARST                         Frequency for DLN066
     C                   MOVEL     *BLANK        #1CORP                         Collation Repor
     C                   MOVEL     *BLANK        #1CRDS                         Collation Repor
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @D4REI3 fields to screen.
      *================================================================
     C                   MOVEL     D4CLFR        #1CLFR                         Collation Freqe
     C                   Z-ADD     D4LCD         #1LCD                          Last Change Dat
     C                   MOVEL     D4CHTP        #1CHTP                         Type of Last Ch
     C                   MOVEL     D4RNAM        #1RNAM                         Report name
     C                   MOVEL     D4RSFX        #1RSFX                         Print File Name
     C                   MOVEL     D4CORP        #1CORP                         Collation Repor
     C                   MOVEL     D4CRDS        #1CRDS                         Collation Repor
      * Hold existing record image.
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialise key screen.
      *================================================================
     C                   MOVEL     P1RNAM        #1RNAM                         Report name
     C                   MOVEL     P1RSFX        #1RSFX                         Print File Name
     C                   MOVEL     P1CLFR        #1CLFR                         Collation Freqe
      * USER: Initialise key screen
      * 01 /COPY FC0330RIKS - Reports For Collation  *
     C*Reports for Colln Edit   Initialise Key Screen
     C/COPY WNCPYSRC,MA0330RIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   MEIZ#1        BEGSR
      *================================================================
      * Initialise virtual/derived fields.
      *================================================================
     C*********************MOVEL*BLANK    #DARST           Frequency for DLN0661
     C                   MOVEL     #1CLFR        #DARST                         Frequency for DLN066
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Get report description - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSA         KLIST
     C                   KFLD                    DXRNAM                         Report name
      * Move fields to key list.
     C                   MOVEL     #1RNAM        DXRNAM                         Report name
     C***********KRSSA     CHAIN@DXREIK              90    *              S01407
     C*****KRSSA         CHAIN     FCREPTD0                           90        *     S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT :NullInds                                                              MD055265
     C+ from FCREPJW1                                                                       MD055265
     C+ where DXRNAM = :#1RNAM                                                              MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       90                    MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                        90                    MD055265
     C                   ENDIF                                                              MD055265
      * DBF Record not found.
     C***90******          MOVEL'USR0712' W0RTN   7                       LN1190
     C   90              MOVEL     'RCF0712'     W0RTN             7                           LN119
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     DXRDSC        WURDSC                         Report Descript
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     C*R*********SBRVGN    BEGSR                                          LN0587
      ************=====================================================   LN0587
      **Get*Collation*Flag*-*Report*Descriptions  *                       LN0587
      ************=====================================================   LN0587
     C************         MOVEL*BLANK    W0RTN   7                       LN0587
      **Define*Keylist.                                                   LN0587
     C***********KRSSB     KLIST                                          LN0587
     C**********           KFLD           DXRNAM           Report name    LN0587
      **Move*fields*to*key*list.                                          LN0587
     C************         MOVEL#1RNAM    DXRNAM           Report name    LN0587
     C*********  KRSSB     CHAIN@DXREIK              90    *              LN0587
     C*********  *IN90     IFEQ '1'                                       LN0587
      **DBF*Record*not*found.                                             LN0587
     C****************     MOVEL'USR0712' W0RTN   7                       LN0587
      **USER:*Processing*if*DBF*record*not*found                          LN0587
     C***************      MOVEL@CN,06    W0RTN            *Return code   LN0587
     C*************        GOTO SBEXIT                                    LN0587
     C************         END                                            LN0587
      *************                                                       LN0587
     C************IN90     IFEQ '0'                                       LN0587
      **USER:*Process*DBF*record                                          LN0587
     C**************       MOVELDXCOLT    WUCOLT           Collation      LN0587
     C*************        END                                            LN0587
      *************====================================================   LN0587
     C*R******** SBEXIT    ENDSR                                          LN0587
      *EJECT*****                                                         LN0587
     CSR   SCRVGN        BEGSR
      *================================================================
      * Get report description - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSC         KLIST
     C                   KFLD                    DXRNAM                         Report name
      * Move fields to key list.
     C                   MOVEL     #1RNAM        DXRNAM                         Report name
     C***********KRSSC     CHAIN@DXREIK              90    *              S01407
     C*****KRSSC         CHAIN     FCREPTD0                           90        *     S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT :NullInds                                                              MD055265
     C+ from FCREPJW1                                                                       MD055265
     C+ where DXRNAM = :#1RNAM                                                              MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       90                    MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                        90                    MD055265
     C                   ENDIF                                                              MD055265
      * DBF Record not found.
     C***90*****           MOVEL'USR0712' W0RTN   7                       LN1190
     C   90              MOVEL     'RCF0712'     W0RTN             7                           LN119
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     DXRDSC        WURDSC                         Report Descript
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCRRC        BEGSR
      *================================================================
      * Create Reports For Collat - Reports For Collation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @D4REI2
     C                   MOVEL     #1RNAM        D4RNAM                         Report name
     C                   MOVEL     #1RSFX        D4RSFX                         Print File Name
     C                   MOVEL     #1CLFR        D4CLFR                         Collation Freqe
     C                   Z-ADD     WURUND        D4LCD                          Last Change Dat
     C                   MOVEL     @CN(07)       D4CHTP                         Type of Last Ch
     C                   MOVEL     #1CORP        D4CORP                         Collation Repor
     C                   MOVEL     #1CRDS        D4CRDS                         Collation Repor
      *
      * USER: Processing before DBF update
      * 12 /COPY FC0330RCBU - Reports For Collation  *
     C*Reports for Colln Edit   Processing Before Create
     C/COPY WNCPYSRC,MA0330RCBU
     C     KLCRSD        KLIST
     C                   KFLD                    D4RNAM                         Report name
     C                   KFLD                    D4RSFX                         Print File Name
     C                   KFLD                    D4CLFR                         Collation Freqe
      * Check for duplicate primary key.
     C     KLCRSD        SETLL     @D4REI2                                90    *
     C     *IN90         IFEQ      '1'
     C**********           MOVEL'USR0727' W0RTN   7                       LN1190
     C                   MOVEL     'RCF0727'     W0RTN             7                           LN119
      * Send message 'Reports For Collation  EX'
     C**********           MOVEL'USR0727' ZAMSID           Message id.    LN1190
     C                   MOVEL     'RCF0727'     ZAMSID                         Message id.    LN119
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SDEXIT
     C                   END
      *
     C                   WRITE     @D4REI2                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Write successful.
      * USER: Processing after DBF update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SECHRC
      * 11 /COPY FC0330RCAU - Reports For Collation  *
     C*Reports for Colln Edit   Processing After Create
     C/COPY WNCPYSRC,MA0330RCAU
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(08)       AHFLNM                         Filename
      *
     C     KLCHSE        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSE        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C**********           MOVEL'Y2U0009' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1084'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
      * Move @AHREAU fields back.
     C                   MOVEL     AHFLNM        @CN(08)                        Filename
     C                   Z-ADD     AHNORC        WUNORC                         No. of Records
     C                   Z-ADD     AHNOIN        WUNOIN                         No. of Inserts
     C                   Z-ADD     AHNOAM        WUNOAM                         No. of Amends
     C                   Z-ADD     AHNODL        WUNODL                         No. of Deletes
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFDLRC        BEGSR
      *================================================================
      * Delete Reports For Collat - Reports For Collation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before DBF update
      * 13 /COPY FC0330RDBU - Reports For Collation  *
     C*Reports for Colln Edit   Processing Before Delete
     C/COPY WNCPYSRC,MA0330RDBU
      * Move key fields to @D4REI2
     C                   MOVEL     #1RNAM        D4RNAM                         Report name
     C                   MOVEL     #1RSFX        D4RSFX                         Print File Name
     C                   MOVEL     #1CLFR        D4CLFR                         Collation Freqe
      *
     C     KLDLSF        KLIST
     C                   KFLD                    D4RNAM                         Report name
     C                   KFLD                    D4RSFX                         Print File Name
     C                   KFLD                    D4CLFR                         Collation Freqe
     C     KLDLSF        CHAIN     @D4REI2                            9091      *
     C     *IN90         IFEQ      '1'
      * Record already deleted.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C**********           MOVEL'Y2U0009' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1084'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * Check for changed record.
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C**********           MOVEL'Y2U0007' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1085'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C     KLDLSF        SETLL     @D4REI2                            9091      *
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C                   DELETE    @D4REI2                              91      *
     C     *IN91         IFEQ      '1'
      * Delete error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Delete successful.
      * USER: Processing after DBF update
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SGCHRC
      * 14 /COPY FC0330RDAU - Reports For Collation  *
     C*Reports for Colln Edit   Processing After Delete
     C/COPY WNCPYSRC,MA0330RDAU
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(08)       AHFLNM                         Filename
      *
     C     KLCHSG        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSG        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C**********           MOVEL'Y2U0009' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1084'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SGEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
      * Move @AHREAU fields back.
     C                   MOVEL     AHFLNM        @CN(08)                        Filename
     C                   Z-ADD     AHNORC        WUNORC                         No. of Records
     C                   Z-ADD     AHNOIN        WUNOIN                         No. of Inserts
     C                   Z-ADD     AHNOAM        WUNOAM                         No. of Amends
     C                   Z-ADD     AHNODL        WUNODL                         No. of Deletes
     C                   END
      *================================================================
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHCHRC        BEGSR
      *================================================================
      * Change Reports For Collat - Reports For Collation  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before DBF read
      * 16 /COPY FC0330RBDU - Reports For Collation  *
     C*Reports for Colln Edit   Processing Before Update
     C/COPY WNCPYSRC,MA0330RBDU
      * Move key fields to @D4REI2
     C                   MOVEL     #1RNAM        D4RNAM                         Report name
     C                   MOVEL     #1RSFX        D4RSFX                         Print File Name
     C                   MOVEL     #1CLFR        D4CLFR                         Collation Freqe
      *
     C     KLCHSH        KLIST
     C                   KFLD                    D4RNAM                         Report name
     C                   KFLD                    D4RSFX                         Print File Name
     C                   KFLD                    D4CLFR                         Collation Freqe
     C     KLCHSH        CHAIN     @D4REI2                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C**********           MOVEL'Y2U0009' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1084'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SHEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SHEXIT
     C                   END
      *
      * Check for changed record.
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C**********           MOVEL'Y2U0007' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1085'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C     KLCHSH        SETLL     @D4REI2                            9091      *
     C                   GOTO      SHEXIT
     C                   END                                                    FI #1DBRC
      * Move Non-key fields to @D4REI2
     C                   Z-ADD     WURUND        D4LCD                          Last Change Dat
     C                   MOVEL     @CN(09)       D4CHTP                         Type of Last Ch
     C                   MOVEL     #1CORP        D4CORP                         Collation Repor
     C                   MOVEL     #1CRDS        D4CRDS                         Collation Repor
      *
     C                   UPDATE    @D4REI2                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
      * Update saved record image.
     C                   MOVEL     @1DBRC        #1DBRC
      * USER: Processing after DBF update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SICHRC
      * 15 /COPY FF0330RADU - Reports For Collation  *
     C*Reports for Colln Edit   Processing After Update
     C/COPY WNCPYSRC,MA0330RADU
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   SICHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(08)       AHFLNM                         Filename
      *
     C     KLCHSI        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSI        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C**********           MOVEL'Y2U0009' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C                   MOVEL     'RCF1084'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SIEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SIEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
      * Move @AHREAU fields back.
     C                   MOVEL     AHFLNM        @CN(08)                        Filename
     C                   Z-ADD     AHNORC        WUNORC                         No. of Records
     C                   Z-ADD     AHNOIN        WUNOIN                         No. of Inserts
     C                   Z-ADD     AHNOAM        WUNOAM                         No. of Amends
     C                   Z-ADD     AHNODL        WUNODL                         No. of Deletes
     C                   END
      *================================================================
     CSR   SIEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check reference to Report Suffix.
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * If all low order keys not entered, exit.
     C     #1RNAM        IFEQ      *BLANK                                       Report name
     C     #1RSFX        ANDEQ     *BLANK                                       Print File Name
     C                   GOTO      VAEXIT
     C                   END
      *
     C     KLVADY        KLIST
     C                   KFLD                    DYRNAM                         Report name
     C                   KFLD                    DYRSFX                         Print File Name
      * Setup key.
     C                   MOVEL     #1RNAM        DYRNAM                         Report name
     C                   MOVEL     #1RSFX        DYRSFX                         Print File Name
     C***********KLVADY    CHAIN@DYREIO              9091  *              S01407
     C*****KLVADY        CHAIN     FCRSFXD0                           9091      *     S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRSFX                                                                        MD055265
     C+ from FCRSFJW0                                                                       MD055265
     C+ where DYRNAM = :DYRNAM and DYRSFX = :DYRSFX                                         MD055265
     C/END-EXEC                                                                             MD055265
     C******IN90         IFEQ      '0'                                                      MD055265
     C                   IF        SQLCODE = 0                                              MD055265
      * Record found - move back any virtuals.
     C                   GOTO      VAEXIT
     C                   END
      * Send message 'Report Suffix          NF'
     C**********           MOVEL'USR0714' ZAMSID           Message id.    LN1190
     C                   MOVEL     'RCF0714'     ZAMSID                         Message id.    LN119
     C                   EXSR      ZASNMS                                       Send message
     C**********           MOVEL'USR0714' W0RTN                           LN1190
     C                   MOVEL     'RCF0714'     W0RTN                                         LN119
      *================================================================
     CSR   VAEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
      * Send if first error message or not an error message.
     C     ZAMSTP        IFNE      *BLANK
     C     ZAFSMS        ORNE      'N'
     C     ZAMSTP        IFEQ      *BLANK
      * Signal first error message sent.
     C                   MOVEL     'N'           ZAFSMS
     C                   END
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
     C                   END
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen.
      *================================================================
      * USER: Exit program processing
      * 10 /COPY FC0330REPP - Reports For Collation  *
     C*Reports for Colln Edit   Exit Program Processing
     C/COPY WNCPYSRC,MA0330REPP
      *CASE:     KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(10)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * ROLLBACK any uncommitted DBF changes.
     C                   ROLBK                                          90
      *
      * Terminate program.
     C                   SETON                                        LR
      *
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Obtain default message file.
     C     *DTAARA       DEFINE    FCMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Key Screen Flag
     C                   MOVEL     *BLANK        WUAJST            1
      * Define work field Report Description
     C                   MOVEL     *BLANK        WURDSC           50
      **Define*work*field*Collation                                       LN0587
     C******************   MOVEL*BLANK    WUCOLT  1                       LN0587
      * Define work field run day number
     C                   Z-ADD     *ZERO         WURUND            5 0
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WURUNA            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSSF             1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUDATF            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Signal first error message outstanding.
     C                   MOVEL     'Y'           ZAFSMS            1
      * Open files.
      * Begin commit control.
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      MARCOLL0
     C                   OPEN      SDFCTLL0
      * Select initial mode.
     C     @1NROP        IFEQ      *ZERO
     C                   MOVEL     'ADD'         W0PMD             3            Add mode
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD                          Change mode
     C                   END
      * USER: Initialise program
      * Last Amd Hdr box fc0330r - Reports For Collation  *
      * Initialise EDTRCD program
      * Set-up KEY Screen Footer - standard functions  *
     C                   MOVEA     ARGV(1)       ##AENA
      * Copyright Statement - standard functions  *
     C                   MOVEA     CPY@          BIS@             80
      * get rundate - rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      RUNA          ##RUNA
     C                   MOVE      RUNA          WURUNA
     C                   MOVE      RUND          WURUND
     C                   MOVE      SSF           WUSSF
     C                   MOVE      DATF          WUDATF
     C                   MOVE      MBIN          WUMBIN
      *CASE:     PAR.Action Code is Insert
     C     P2JTST        IFEQ      @CN(07)                                      *IF
     C                   MOVEL     @CN(11)       W0PMD                          *Program mode
     C                   ELSE
      *CASE:     PAR.Action Code is Amend
     C     P2JTST        IFEQ      @CN(09)                                      *IF
     C                   MOVEL     @CN(12)       W0PMD                          *Program mode
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00 /COPY FC0330RFPG - Reports For Collation  *
      * 00 /COPY FC0330REPG - Reports For Collation  *
      * 00 /COPY FC0330RIPG - Reports For Collation  *
      * 00 /COPY FC0330RCPG - Reports For Collation  *
     C*Reports for Colln Edit   Initialise Program C-spec
     C/COPY WNCPYSRC,MA0330RCPG
      * 00 /COPY FC0330ROPG - Reports For Collation  *
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*Reports for Colln Edit   Initialise Program O-spec
     O/COPY WNCPYSRC,MA0330ROPG
**
F3=Main Menu   F10=Delete   F12=Previous
F3=Main Menu   F12=Previous
F3=Main Menu   F12=Previous
**
F3=Main Menu   F12=Previous
** CPY@
(c) Finastra International Limited 2001
** @CN Long constants used in program.                                    LN0634
N
*
Y
PREVSCN
D
Y2U0005
I
MARCOLPD
A
Y2U9999
ADD
CHG
