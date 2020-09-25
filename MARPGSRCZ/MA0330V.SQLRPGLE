     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas MA Insert rpts for colln pmpt & vdt')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Microfiche/Optical Disk Archiving Module
     F*                                                               *
     F*  MA0330V - INSERT REPORTS FOR COLLATION (P & V)               *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD055265           Date 10Feb20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 028265             Date 19Sep93               *
      *                 S01407             Date 26Jan93               *
     F*                 LN1252             DATE 16APR91               *
     F*                 LN1190             DATE 26APR91               *
     F*                 LN1147             DATE 12APR91               *
     F*                 LN0661             DATE 12SEP90               *
     F*                 LN0587             DATE 01AUG90               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
     F*  028265 - Move parameter fields to program variables in case  *
     F*           of amensments in MA0330R.                           *
     F*  S01407 - SWITCHABILITY ENHANCEMENTS                          *
     F*  LN1252 - 1. REMOVE 'Y2' SYNON MESSAGES AND REPLACE WITH      *
     F*              'RCF' MESSAGES.                                  *
     F*           2. IF F12 TAKEN RETURN TO PREVIOUS SCREEN.          *
     F*           2. CORRECT KEY SCREEN VALIDATION.                   *
     F*  LN1190 - REMOVE 'USR' MESSAGES AND REPLACE WITH 'RCF'        *
     F*           MESSAGES.                                           *
     F*  LN1147 - SEND ALL ERROR MESSAGES AT ONCE                     *
     F*  LN0661 - STANDARDISE SCREEN APPEARANCE                       *
     F*  LN0587 - COLLATION MOVED FROM REPT TO RSFX                   *
     F*                                                               *
     F*****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *                                                               *
      *****************************************************************
     F*Insert Reports for Colln Initialise Program F-Spec
     F/COPY WNCPYSRC,MA0330VFPG
     FMA0330V#  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
      * DSP: Insert Reports for coll.  Prompt & validate record
      *
     F*CREPTL1IF**E***********K********DISK                               LN0587
     F**RTV**Report*Descriptions*******Retrieval index                    LN0587
      *
     F***********FCRSFXL1IF  E           K        DISK                    S01407
     F*FCRSFXJ0* IF   E           K DISK                                         S01407     MD055265
      * RTV: Report Suffix             Retrieval index
      *
     D ARGV            S             78    DIM(3) CTDATA PERRCD(1)
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*Insert Reports for Colln Initialise Program E-Spec
     D/COPY WNCPYSRC,MA0330VEPG
     D @CN             S             25    DIM(6) CTDATA PERRCD(1)              Long constants.
     D*Insert Reports for Colln Initialise Program I-Spec
     D/COPY WNCPYSRC,MA0330VIPG
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
      * Outward parameters.
     D PARC            DS            21
      * KEY: Reports For Collation     Retrieval index
      * I:MAP Report name
     D  PARNAM                 1     10
      * I:MAP Print File Name
     D  PARSFX                11     20
      * I:MAP Collation Freqency
     D  PACLFR                21     21
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
      * B:MAP Action Code
     D  P2JTST                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Report not found'
      * Report name
     D  ZA0001                 1     10
      * Message data for 'Can't Collate Report'
      * Report name
     D  ZA0002                 1     10
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
      * Conduct screen conversation.
     C                   DO        *HIVAL
      * Start new transaction.
     C                   MOVEL     'Y'           W0TRN             1
      * Process current transaction.
     C     W0TRN         DOWEQ     'Y'
      * Display screen.
     C                   EXSR      CAEXFM
      * Process response:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * Process screen input.
     C                   CAS                     DAPRSC
     C                   END
      *
     C                   END
      *
     C                   END
      *****************************************************************
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests.
      *================================================================
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
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
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPRSC        BEGSR
      *================================================================
      * Process screen input.
      *================================================================
      * Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      * USER: Process command keys
      * 02 /copy XX0330VPCK - Reports For Collation  *
     C*Insert Reports for Colln Process Command Keys
     C/COPY WNCPYSRC,MA0330VPCK
      *CASE:     DTL.*CMD key is Previous screen
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(01)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Validate screen.
     C                   EXSR      DBVLSC
      * If error, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: User defined action
      * 05 /copy XX0330VUDA - Reports For Collation  *
     C*Insert Reports for Colln User Defined Action
     C/COPY WNCPYSRC,MA0330VUDA
      * Edit Reps for Collation - Reports For Collation  *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     #1RNAM        PARNAM                         Report name
     C                   MOVEL     #1RSFX        PARSFX                         Print File Name
     C                   MOVEL     #1CLFR        PACLFR                         Collation Freqe
      *
     C                   CALL      'MA0330R'                            90      Edit Reps for C
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM                    PARC                           KEY: Reports Fo
     C     P2JTST        PARM      P2JTST        WQ0001            1            Action Code
     C*                                                                   028265
     C** Move parameter fields to program variables in case of            028265
     C** amendments in MA0330R.                                           028265
     C*                                                                   028265
     C                   MOVEL     PARNAM        #1RNAM                         Report name    02826
     C                   MOVEL     PARSFX        #1RSFX                         Print File Name02826
     C                   MOVEL     PACLFR        #1CLFR                         Collation Freqe02826
      *
     C*                                                                   LN1252
     C** BYPASS CALL TO SUBROUTINE ZXEXPG IF F12 WAS TAKEN IN MA0330R     LN1252
     C*                                                                   LN1252
     C     W0RTN         IFEQ      @CN(01)                                                     LN125
     C                   GOTO      DAEXIT                                                      LN125
     C                   END                                                                   LN125
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        993132    *
     C                   END
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(02)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Exit program.
     C                   EXSR      ZXEXPG
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBVLSC        BEGSR
      *================================================================
      * Validate screen.
      *================================================================
      * Validate Frequency For Input
      * Name search required ?
     C                   MOVEL     #DASST        W0NSRQ            1            Frequency For I
     C     W0NSRQ        IFEQ      '?'                                          Search required
     C                   CALL      'FCVLLSR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100271       Y2LSNO            7 0          List number.
     C     #DASST        PARM      #DASST        W0EXVL           20            Frequency For I
     C                   MOVEL     'Y'           W0DCF             1            Defer confirm
     C                   END
      *                                                                   LN1252
      ** Report name required.                                            LN1252
      *                                                                   LN1252
     C     #1RNAM        IFEQ      *BLANK                                       IF             LN125
     C                   SETON                                        9931      *              LN125
     C                   MOVEL     'RCF1074'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message   LN125
     C                   END                                                    FI             LN125
      *                                                                   LN1252
      ** Print File Name required.                                        LN1252
      *                                                                   LN1252
     C     #1RSFX        IFEQ      *BLANK                                       IF             LN125
     C                   SETON                                        9932      *              LN125
      * Send message '*Value required'                                    LN1252
     C                   MOVEL     'RCF1074'     ZAMSID                         Message id.    LN125
     C                   MOVEL     'FCUSRMSG'    ZAMSGF                         Message file.  LN125
     C                   EXSR      ZASNMS                                       Send message   LN125
     C                   END                                                    FI             LN125
      * USER: Validate fields
      **Get*Collation*Flag*-*Report*Descriptions**************************LN0587
     C*******************  EXSR SARVGN                                    LN0587
      *CASE:*****PGM.*Return*code*is**Record*does*not*exist***************LN0587
     C***********W0RTN     IFEQ @CN,03                     *IF            LN0587
      **Setup*message*data*for*message.********************               LN0587
     C******************** MOVEL#1RNAM    ZA0001           Report name    LN0587
      **Send*message*'Report*not*found'                                   LN0587
     C******************** MOVEL'RCF0039' ZAMSID           Message id.    LN0587
     C******************** EXSR ZASNMS                     Send message   LN0587
     C******************** SETON                     9931  *              LN0587
      ********************                                                LN0587
     C******************** ELSE                                           LN0587
      *CASE:******OTHERWISE                                               LN0587
      *CASE:*****WRK.Collation is No                                      LN0587
     C***********WUCOLT    IFEQ @CN,04                     *IF            LN0587
      **Setup*message*data*for*message.                                   LN0587
     C*********************MOVEL#1RNAM    ZA0002           Report name    LN0587
      **Send*message*'Can't*Collate*Report'                               LN0587
     C*********************MOVEL'RCF0040' ZAMSID           Message id.    LN0587
     C*********************EXSR ZASNMS                     Send message   LN0587
     C*********************SETON                     9931  *              LN0587
      *********************                                               LN0587
     C*********************END                             *FI            LN0587
     C*********************END                             *FI
      * 03 /copy XX0330VVFI - Reports For Collation  *
     C*Insert Reports for Colln Validate Fields
     C/COPY WNCPYSRC,MA0330VVFI
      **Bypass*ref*file*checks*if*error*already*detected.*                LN1252
     C***99******          GOTO DBEXIT                                    LN1252
      **Check*reference*to*Report*Suffix.*****                            LN1252
     C*                                                                   LN1252
     C** If no error on Report Name & Suffix check reference on file      LN1252
     C*                                                                   LN1252
     C     *IN31         IFEQ      '0'                                                         LN125
     C     *IN32         ANDEQ     '0'                                                         LN125
     C                   EXSR      VACKRL
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        993132    *
     C                   END
      *CASE:     WRK.Collation is No                                      LN0587
     C************IN99*****IFEQ '0'                        *IF      LN0587LN0661
     C***********DYCOLT****ANDEQ@CN,04                     *IF      LN0587LN0661
     C*                                                                   LN1252
     C** If valid Report Name & Suffix but can't be collated send a       LN1252
     C** message.                                                         LN1252
     C*                                                                   LN1252
     C     *IN31         IFEQ      '0'                                          *IF            LN125
     C     *IN32         ANDEQ     '0'                                                         LN125
     C     DYCOLT        IFEQ      @CN(04)                                      *IF            LN066
      * Setup message data for message.                                   LN0587
     C                   MOVEL     #1RNAM        ZA0002                         Report name    LN058
      * Send message 'Can't Collate Report'                               LN0587
     C                   MOVEL     'RCF0040'     ZAMSID                         Message id.    LN058
     C                   EXSR      ZASNMS                                       Send message   LN058
     C                   SETON                                        9932      *              LN058
      *                                                                   LN0587
     C                   END                                                    *FI            LN058
     C                   END                                                                   LN125
     C                   END                                                                   LN125
     C*                                                                   LN1252
     C** COLLATION FREQUENCY FIELD - CHECK FOR VALID VALUES               LN1252
     C*                                                                   LN1252
     C     #DASST        IFNE      'A'                                                         LN125
     C     #DASST        ANDNE     'D'                                                         LN125
     C     #DASST        ANDNE     'B'                                                         LN125
     C     #DASST        ANDNE     '5'                                                         LN125
     C     #DASST        ANDNE     '1'                                                         LN125
     C     #DASST        ANDNE     '6'                                                         LN125
     C     #DASST        ANDNE     '7'                                                         LN125
     C     #DASST        ANDNE     '4'                                                         LN125
     C     #DASST        ANDNE     '2'                                                         LN125
     C     #DASST        ANDNE     '3'                                                         LN125
     C     #DASST        ANDNE     'Y'                                                         LN125
     C     #DASST        ANDNE     'Z'                                                         LN125
     C                   MOVEL     'RCF0067'     ZAMSID                                        LN125
     C                   SETON                                        3399                     LN125
     C                   EXSR      ZASNMS                                                      LN125
     C                   END                                                                   LN125
      * CALC: Screen function fields
     C**********                                                    LN0661LN1252
     C***COLLATION*FREQUENCY*FIELD*-*CHECK*FOR*VALID*VALUES***      LN0661LN1252
     C**********                                                    LN0661LN1252
     C********** #DASST    IFNE 'A'                                 LN0661LN1252
     C********** #DASST    ANDNE'D'                                 LN0661LN1252
     C********** #DASST    ANDNE'B'                                 LN0661LN1252
     C********** #DASST    ANDNE'5'                                 LN0661LN1252
     C********** #DASST    ANDNE'1'                                 LN0661LN1252
     C********** #DASST    ANDNE'6'                                 LN0661LN1252
     C********** #DASST    ANDNE'7'                                 LN0661LN1252
     C********** #DASST    ANDNE'4'                                 LN0661LN1252
     C********** #DASST    ANDNE'2'                                 LN0661LN1252
     C********** #DASST    ANDNE'3'                                 LN0661LN1252
     C********** #DASST    ANDNE'Y'                                 LN0661LN1252
     C********** #DASST    ANDNE'Z'                                 LN0661LN1252
     C**********           MOVEL'RCF0067' ZAMSID                    LN0661LN1252
     C**********           SETON                     3399           LN0661LN1252
     C**********           EXSR ZASNMS                              LN0661LN1252
     C**********           END                                      LN0661LN1252
     C**********                                                    LN0661LN1252
      * 04 /copy XX0330VSFI - Reports For Collation  *
     C*Insert Reports for Colln Calculate Function Flds
     C/COPY WNCPYSRC,MA0330VSFI
      * USER: Validate relations
      *CASE:     DTL.Frequency For Input is Blank Input
     C     #DASST        IFEQ      *BLANK                                       *IF
     C                   MOVEL     @CN(05)       #1CLFR                         Collation Freqe
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     #DASST        #1CLFR                         Collation Freqe
     C                   END                                                    *FI
      * 04 /copy XX0330VVRE - Reports For Collation  *
     C*Insert Reports for Colln Validate Screen Relations
     C/COPY WNCPYSRC,MA0330VVRE
      **Report*name*required.************************                     LN1252
     C********** #1RNAM    IFEQ *BLANK                     IF             LN1252
     C**********           SETON                     9931  *              LN1252
      **Send*message*'*Value*required'***************                     LN1252
     C**********           MOVEL'Y2U0001' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C**********           EXSR ZASNMS                     Send message   LN1252
     C**********           END                             FI             LN1252
      **Print*File*Name*required.********                                 LN1252
     C********** #1RSFX    IFEQ *BLANK                     IF             LN1252
     C**********           SETON                     9932  *              LN1252
      **Send*message*'*Value required'***                                 LN1252
     C**********           MOVEL'Y2U0001' ZAMSID           Message id.    LN1252
     C**********           MOVEL'Y2USRMSG'ZAMSGF           Message file.  LN1252
     C**********           EXSR ZASNMS                     Send message   LN1252
     C**********           END                             FI             LN1252
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   MALDSC        BEGSR
      *================================================================
      * Load screen from passed parameters
      *================================================================
     C                   MOVEL     P2JTST        #PJTST                         Action Code
     C                   MOVEL     P1CLFR        #1CLFR                         Collation Freqe
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1CHTP                         Type of Last Ch
     C                   MOVEL     *BLANK        #1CORP                         Collation Repor
     C                   MOVEL     *BLANK        #1CRDS                         Collation Repor
     C                   MOVEL     P1RNAM        #1RNAM                         Report name
     C                   MOVEL     P1RSFX        #1RSFX                         Print File Name
     C                   MOVEL     *BLANK        #DASST                         Frequency For I
      * CALC: Screen function fields
      * 04 /copy XX0330VSFI - Reports For Collation  *
     C*Insert Reports for Colln Calculate Function Flds
     C/COPY WNCPYSRC,MA0330VSFI
      * USER: Load screen
      * Set-up KEY Screen Footer - standard functions  *
     C                   MOVEA     ARGV(1)       ##AENA
     C                   MOVEL     *BLANK        #DASST                         Frequency For I
     C*********************MOVEL@CN,06    #1RSFX           Print File NameLN0661
      * 01 /copy XX0330VLSR - Reports For Collation  *
     C*Insert Reports for Colln Load Screen
     C/COPY WNCPYSRC,MA0330VLSR
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     C*R*********SARVGN****BEGSR                                          LN0587
      *================================================================   LN0587
      **Get*Collation*Flag*-*Report*Descriptions  *                       LN0587
      *================================================================   LN0587
     C***********          MOVEL*BLANK    W0RTN   7                       LN0587
      **Define*Keylist.******                                             LN0587
     C***********KRSSA     KLIST                                          LN0587
     C***********          KFLD           DXRNAM           Report name    LN0587
      **Move*fields*to*key*list.*******                                   LN0587
     C***********          MOVEL#1RNAM    DXRNAM           Report name    LN0587
     C***********KRSSA     CHAIN@DXREIK              90    *              LN0587
     C********** *IN90     IFEQ '1'                                       LN0587
      **DBF*Record*not*found.*********                                    LN0587
     C******************** MOVEL'USR0712' W0RTN   7                       LN0587
      **USER:*Processing*if*DBF record not found                          LN0587
     C*********************MOVEL@CN,03    W0RTN            *Return code   LN0587
     C***********          GOTO SAEXIT                                    LN0587
     C***********          END                                            LN0587
      ***********                                                         LN0587
     C************IN90     IFEQ '0'                                       LN0587
      **USER:*Process DBF record                                          LN0587
     C***********          MOVELDXCOLT    WUCOLT           Collation      LN0587
     C***********          END                                            LN0587
      ***********======================================================   LN0587
     C*R*********SAEXIT    ENDSR                                          LN0587
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
      **Send*if*first*error*message*or*not*an*error*message.****          LN1147
     C***********ZAMSTP    IFNE *BLANK                                    LN1147
     C***********ZAFSMS    ORNE 'N'                                       LN1147
     C***********ZAMSTP    IFEQ *BLANK                                    LN1147
      **Signal*first*error*message*sent.*                                 LN1147
     C***********          MOVEL'N'       ZAFSMS                          LN1147
     C***********          END                                            LN1147
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
     C***********          END                                            LN1147
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
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
      * 06 /copy XX0330VEPP - Reports For Collation  *
     C*Insert Reports for Colln Exit Program Processing
     C/COPY WNCPYSRC,MA0330VEPP
      *CASE:     DTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(02)       P0RTN                          *Return code
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
      * Define work field Collation
     C                   MOVEL     *BLANK        WUCOLT            1
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
      * Last Amd Hdr box fc0330v - Reports For Collation  *
      * get rundate - rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      RUNA          ##RUNA
     C                   MOVE      RUNA          WURUNA
     C                   MOVE      RUND          WURUND
     C                   MOVE      SSF           WUSSF
     C                   MOVE      DATF          WUDATF
     C                   MOVE      MBIN          WUMBIN
      * Copyright Statement - standard functions  *
     C                   MOVEA     CPY@          BIS@             80
      * 00 /copy XX0330VFPG - Reports For Collation  *
      * 00 /copy XX0330VEPG - Reports For Collation  *
      * 00 /copy XX0330VIPG - Reports For Collation  *
      * 00 /copy XX0330VCPG - Reports For Collation  *
     C*Insert Reports for Colln Initialise Program C-Spec
     C/COPY WNCPYSRC,MA0330VCPG
      * 00 /copy XX0330VOPG - Reports For Collation  *
      * Load screen
     C                   EXSR      MALDSC
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*Insert Reports for Colln Initialise Program O-Spec
     O/COPY WNCPYSRC,MA0330VOPG
**
F3=Main Menu   F12=Previous
** CPY@
(c) Finastra International Limited 2001
** @CN Long constants used in program.
PREVSCN
Y2U9999
Y2U0005
N
*
P1
