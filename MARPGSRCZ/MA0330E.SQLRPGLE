     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas MA Display reports for collation')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Microfiche/Optical Disk Archiving Module
     F*                                                               *
     F*  MA0330E - DISPLAY REPORTS FOR COLLATION                      *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD055265           Date 10Feb20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01407             Date 26Jan93               *
      *                 LN1190             Date 26Apr91               *
     F*                     LN0661       DATE 01OCT90                 *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
     F*      S01407 - SWITCHABILITY ENHANCEMENTS                      *
     F*      LN1190 - REMOVE 'USR' MESSAGES AND REPLACE WITH 'RCF'    *
     F*               MESSAGES.                                       *
     F*      LN0661 - PROGRAM RECOMPILED OVER AMENDED DISPLAY FILE    *
     F*                                                               *
     F*****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *                                                               *
      *****************************************************************
     F*Reports for Colln Enqry  Initialise Program F-Spec
     F/COPY WNCPYSRC,MA0330EFPG
     FMA0330E#  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
      * DSP: Disp. Reps for Collation  Display record(1 screen)
      *
     FMARCOLL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
      * RTV: Reports For Collation     Retrieval index
      *
     F***********FCRSFXL1IF  E           K        DISK                    S01407
     F*FCRSFXJ0* IF   E           K DISK                                         S01407     MD055265
      * RTV: Report Suffix             Retrieval index
      *
     D ARGV            S             78    DIM(3) CTDATA PERRCD(1)
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*Reports for Colln Enqry  Initialise Program E-Spec
     D/COPY WNCPYSRC,MA0330EEPG
     D @CN             S             25    DIM(3) CTDATA PERRCD(1)              Long constants.
     D*Reports for Colln Enqry  Initialise Program I-Spec
     D/COPY WNCPYSRC,MA0330EIPG
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
     D FCRSFX        E DS                  EXTNAME(FCRSFJW1)                                MD055265
     D*NullInds*       s              5i 0 dim(10)                                 MD055265 MD055681
     D NullInds        s              5i 0 dim(11)                                          MD055681
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
      *
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
      * HOME: Reset screen fields.
     C   05              CAS                     BDHMKY
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
      * Enable PUTOVR.
     C                   SETON                                        86
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
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
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
      * If record does not exist then signal error
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
     C                   MOVEL     *BLANK        #DBBNA                         Frequency condi
      * Frequency condition
      *CASE:     PAR.Collation Freqency is BLANK
     C     #1CLFR        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     *BLANK        #DBBNA                         Frequency condi
     C                   ELSE
      *CASE:     *OTHERWISE
      * PAR.Frequency condition = Condition name of PAR.Collation Freqency
     C                   CALL      'FCRVCNR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100265       Y2LSNO            7 0          List number
     C                   PARM      #1CLFR        W0INVL           20            Collation Freqe
     C                   PARM      ' '           W0VLMP            1            Value mapped?
     C     #DBBNA        PARM                    W0CNNM           25            Frequency condi
      *
     C                   END                                                    *FI
      * 05 /copy XX0330ESFF - Reports For Collation  *
     C*Reports for Colln Enqry  Calculate Detail Func Fld
     C/COPY WNCPYSRC,MA0330ESFF
      * USER: Load detail screen from DBF record
      * 03 /copy XX0330ELDS - Reports For Collation  *
     C*Reports for Colln Enqry  Load Detail Screen
     C/COPY WNCPYSRC,MA0330ELDS
     C                   END
      *
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
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   SETON                                        9933      *
     C                   END
      * Check relations.
      * Check reference to Report Suffix.
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   MOVEL     *BLANK        W0RTN
     C                   SETON                                        9931      *
     C                   SETON                                        993132    *
     C                   END
      * USER: Validate key screen
      * 02 /copy XX0330EVKS - Reports For Collation  *
     C*Reports for Colln Enqry  Validate Key Screen
     C/COPY WNCPYSRC,MA0330EVKS
      * Report name required.
     C     #1RNAM        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Print File Name required.
     C     #1RSFX        IFEQ      *BLANK                                       IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      * Collation Freqency required.
     C     #1CLFR        IFEQ      *BLANK                                       IF
     C                   SETON                                        9933      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
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
     C   03              CAS                     ZXEXPG
      * HOME: Reset screen fields.
      * Process detail screen input.
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
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
      * Enable PUTOVR.
     C                   SETON                                        86
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
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen.
      *================================================================
      * USER: Process key screen request
      * 04 /copy XX0330EPKR - Reports For Collation  *
     C*Reports for Colln Enqry  Process Key Screen Rqst
     C/COPY WNCPYSRC,MA0330EPKR
     C                   MOVEL     @CN(02)       P0RTN                          *Return code
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
      * Validate details.
     C                   EXSR      DCVLDL
      * Quit if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * Process record:
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details.
      *================================================================
      * Initialise derived fields.
     C                   EXSR      MEIZ#1
      * CALC: Detail screen function fields
     C                   MOVEL     *BLANK        #DBBNA                         Frequency condi
      * Frequency condition
      *CASE:     PAR.Collation Freqency is BLANK
     C     #1CLFR        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     *BLANK        #DBBNA                         Frequency condi
     C                   ELSE
      *CASE:     *OTHERWISE
      * PAR.Frequency condition = Condition name of PAR.Collation Freqency
     C                   CALL      'FCRVCNR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100265       Y2LSNO            7 0          List number
     C                   PARM      #1CLFR        W0INVL           20            Collation Freqe
     C                   PARM      ' '           W0VLMP            1            Value mapped?
     C     #DBBNA        PARM                    W0CNNM           25            Frequency condi
      *
     C                   END                                                    *FI
      * 05 /copy XX0330ESFF - Reports For Collation  *
     C*Reports for Colln Enqry  Calculate Detail Func Fld
     C/COPY WNCPYSRC,MA0330ESFF
      * USER: Validate detail screen
      * 06 /copy XX0330EVDS - Reports For Collation  *
     C*Reports for Colln Enqry  Validate Detail Screen
     C/COPY WNCPYSRC,MA0330EVDS
     C                   MOVEL     *BLANK        P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record.
      *================================================================
      * USER: Perform confirmed action
      * 07 /copy XX0330EPCA - Reports For Collation  *
     C*Reports for Colln Enqry  Perform Confrimed Action
     C/COPY WNCPYSRC,MA0330EPCA
      * Quit if error signalled.
     C   99              GOTO      EBEXIT
      * USER: Process command keys
      * 08 /copy XX0330EPCK - Reports For Collation  *
     C*Reports for Colln Enqry  Process Command Keys
     C/COPY WNCPYSRC,MA0330EPCK
      *CASE:     KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(03)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Quit if error signalled.
     C   99              GOTO      EBEXIT
      * Restart program for next record.
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   EBEXIT        ENDSR
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
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators.
      *================================================================
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
     C                   MOVEL     *BLANK        #DBBNA                         Frequency condi
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
      * USER: Load key screen
      * 01 /copy XX0330ELKS - Reports For Collation  *
     C*Reports for Colln Enqry  Load Key Screen
     C/COPY WNCPYSRC,MA0330ELKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   MEIZ#1        BEGSR
      *================================================================
      * Initialise derived fields.
      *================================================================
     C                   MOVEL     *BLANK        #DBBNA                         Frequency condi
      *================================================================
     CSR   MEEXIT        ENDSR
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
     C+ into :FCRSFX :NullInds                                                              MD055265
     C+ from FCRSFJW1                                                                       MD055265
     C+ where DYRNAM = :DYRNAM and DYRSFX = :DYRSFX                                         MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                         90                  MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                          90                  MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
     C     *IN90         IFEQ      '0'
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
      * 09 /copy XX0330EEPP - Reports For Collation  *
     C*Reports for Colln Enqry  Exit Program Processing
     C/COPY WNCPYSRC,MA0330EEPP
      *CASE:     KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(03)       P0RTN                          *Return code
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
      * Define work field run day number
     C                   Z-ADD     *ZERO         WURUND            5 0
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
      * USER: Initialise program
      * Last Amd Hdr box fc0330e - Reports For Collation  *
      * Initialise DSPRCD program
      * get rundate - rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      RUNA          ##RUNA
     C                   MOVE      RUNA          WURUNA
     C                   MOVE      RUND          WURUND
     C                   MOVE      SSF           WUSSF
     C                   MOVE      DATF          WUDATF
     C                   MOVE      MBIN          WUMBIN
      * Set-up KEY Screen Footer - standard functions  *
     C                   MOVEA     ARGV(1)       ##AENA
      * Copyright Statement - standard functions  *
     C                   MOVEA     CPY@          BIS@             80
      * 00 /copy XX0330EFPG - Reports For Collation  *
      * 00 /copy XX0330EEPG - Reports For Collation  *
      * 00 /copy XX0330EIPG - Reports For Collation  *
      * 00 /copy XX0330ECPG - Reports For Collation  *
     C*Reports for Colln Enqry  Initialise Program C-Spec
     C/COPY WNCPYSRC,MA0330ECPG
      * 00 /copy XX0330EOPG - Reports For Collation  *
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*Reports for Colln Enqry  Initialise Program O-Spec
     O/COPY WNCPYSRC,MA0330EOPG
**
F3=Main Menu   F12=Previous
** CPY@
(c) Finastra International Limited 2001
** @CN Long constants used in program.
*
PREVSCN
Y2U9999
