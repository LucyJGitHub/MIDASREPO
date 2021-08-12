     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Auto Generation Rules Extension')             *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1540W1 - Auto Generation Rules Extension                   *
      *                                                               *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems Ltd 2003   *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 15Jul2011             *
      *                 ESL038             Date 01Oct2004             *
      *                 EEE065             Date 01Jan2004             *
      *                 ERN054             Date 15Jul2003             *
      *                 EEE058 *Create     Date 26Mar2003             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *  ESL038 - ING STP Development                                 *
      *  EEE065 - FT Payment Routing                                  *
      *  ERN054 - Agent Message changes                               *
      *  EEE058 - Incoming STP                                        *
      *                                                               *
      *****************************************************************
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *       03      F3 PRESSED EXIT PROGRAM
      *       05      F5 PRESSED REDISPLAY THE SCREEN
      *       12      F12 PRESSED GOTO PREVIOUS SCREEN
      *       20      PROTECT FIELDS IN ENQUIRE MODE
      *       30      REDISPLAY THE SCREEN
      *       35      ENABLE F5
      *       51      Iban incorrect
      *       51      Szok incorrect
      *
     FME1540#1  CF   E             WORKSTN
      ** Display file for MT900 Outgoing Payments Window
      *
     FFTGNEXV1  IF   E           K DISK
      ** Rtv: Auto generation rules extension
      *
     FFTGNEXV0  UF A E           K DISK
      ** Upd: Auto generation rules extension
      *
     FFTSTPQV1  IF   E           K DISK
      ** Rtv: STP Queues
      *
      *****************************************************************
      *
      ** Array containing Copyright statement
      *
      *****************************************************************
      *
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * External Data Structure for Swtichable features description
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D ##NoError       S              1A   INZ(' ')
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * External Data structure to hold the outgoing record format
      * of the file.
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * SDBANKPD - Bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Data Structures for Currency Definition
      *
     D D#DTA           DS           256
      *
      *  Calling parameter data structure for AOCCYCV0
      *
      *                                       From Currency & amount
     D  D#FCCY                 1      3
     D  D#FAMT                 4     11P 0
      *                                       To Currency & amount
     D  D#TCCY                12     14
     D  D#TAMT                15     22P 0
      *                                       Rate and multi/div ind.
     D  D#MDIN                23     23
     D  D#RATE                24     36P 8
      *                            Output     Rate and multi/div ind.
      *                                       If no in rate
     D  O#MDIN                37     37
     D  O#RATE                38     50P 8
      *
      * Define passed paramters to FTP840
     D O2parm          DS            20
     D  O2Stpq                 1     20
      *
     D/COPY QWINDSRC,ME1540SDTA
      * Data member for main program
      *****************************************************************
     C/EJECT
      *
      **   Standard parameter list for window manager
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1
     C                   PARM                    DATA
     C                   PARM                    RTNCDE            7
     C                   PARM                    WLEN              3 0
     C                   PARM                    WWID              3 0
     C                   PARM                    SROW              3 0
     C                   PARM                    SCOL              3 0
     C                   PARM                    TITLE             7
     C                   PARM                    SPARE           256
      *
      *****************************************************************
      *                M A I N  P R O C E S S I N G
      *****************************************************************
      *
      ** Initialise data
      *
     C                   EXSR      INIT
      *
      ** Continue to redisplay the screen if *IN30 remains off
      *
     C     ##NoError     DOUEQ     *blanks
      *
      **   If error write messages
      *
     C                   If        ##NoError <> *blanks
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
      ** Main format of the display file
     C                   EXFMT     ME1540W#1
     C                   EXSR      CLEAR
      *
     C     *IN03         CASEQ     '1'           EXIT
     C     *IN05         CASEQ     '1'           RESET
     C     *IN12         CASEQ     '1'           PREV
     C                   CAS                     VALID
     C                   ENDCS
      *
     C                   ENDDO
      *
      **   Exit from program
      *
     C                   EXSR      END
      /EJECT
      *****************************************************************
      * CLEAR MESSAGE FILE
      *****************************************************************
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      /EJECT
      *****************************************************************
      * EXIT FROM PROGRAM
      *****************************************************************
     C     END           BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      /EJECT
      *****************************************************************
      * EXIT FROM PROGRAM IF F3 HAS BEEN PRESSED
      *****************************************************************
     C     EXIT          BEGSR
     C                   MOVE      'Y2U9999'     RTNCDE
     C                   EXSR      END
     C                   ENDSR
      /EJECT
      *****************************************************************
      * INITIALISE FIELDS
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Extract bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ** Only display the window if SAR EEE058 is active.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'EEE058'      @SARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   EXSR      END
     C                   ENDIF
      *
      ** Only do first time through
      *
     C     *IN01         IFEQ      '0'
      *
      ** Define the LDA for error handling
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Define window position
      *
     C                   Z-ADD     SROW          SWROW
     C                   Z-ADD     SCOL          SWCOL
      *

      * Get data for screen if not insert

     C                   If        ACTN <> 'I'

     C     KGNEXV1       Klist
     C                   Kfld                    GEMTPY
     C                   Kfld                    GEMSET

     C                   Eval      GEMTPY = #1MTPY
     C                   Move      #1MSET        GEMSET
      * Get data from FTGNEXV1
     C     KGNEXV1       Chain     @GNEXV1
     C                   If        Not %Found
     C                   Eval      SBAUT = 'N'
     C                   Eval      SPDTD = 'N'
     C                   Eval      SSLTD = 'N'                                                ERN054
     C                   Eval      SM191 = 'N'
     C                   Eval      SM900 = 'N'
     C                   Eval      SM910 = 'N'
     C                   Eval      SAPPR = 'N'                                                EEE065
     C                   Eval      SSTPQ = *blanks
     C                   Else
     C                   Eval      SBAUT = GEBAUT
     C                   Eval      SPDTD = GEPDTD
     C                   Eval      SSLTD = GESLTD                                             ERN054
     C                   Eval      SM191 = GEM191
     C                   Eval      SM900 = GEM900
     C                   Eval      SM910 = GEM910
     C                   Eval      SAPPR = GEAPPR                                             EEE065
     C                   Eval      SSTPQ = GESTPQ
     C                   Endif

      * insert defaulting
     C                   Else
     C                   Eval      SBAUT = 'N'
     C                   Eval      SPDTD = 'N'
     C                   Eval      SSLTD = 'N'                                                ERN054
     C                   Eval      SM191 = 'N'
     C                   Eval      SM900 = 'N'
     C                   Eval      SM910 = 'N'
     C                   Eval      SAPPR = 'N'                                                EEE065
     C                   Eval      SSTPQ = *blanks
     C                   Endif

      *
      ** Protect input fields if enquiry and enable command keys
      *
     C     ACTN          IFEQ      'E'
     C                   SETON                                        20
     C                   ELSE
     C***                SETON                                        35
     C                   ENDIF
      *
     C                   SETON                                        01
     C                   ENDIF
      *
      ** If Delete mode then do not run this window controller
      ** and exit program.
      *
     C     ACTN          IFEQ      'D'
     C                   EXSR      END                                          kw
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *    EXIT FROM PROGRAM IF F12 HAS BEEN PRESSED
      *****************************************************************
     C     PREV          BEGSR
      *
      **   Set F12 return code and end program
      *
     C                   MOVE      'USR0790'     RTNCDE
     C                   EXSR      END
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * RESET/REFRESH THE SCREEN IF F5 IS PRESSED
      *****************************************************************
     C     RESET         BEGSR
      *
      **   Clear the program message queue and call SR/INIT to retrieve
      **   the last committed data from the extension file.
      *
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      INIT
      *
      **   Reset all error indicators
      *
     C                   SETOFF                                       505152
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * UPDATE THE EXTENSION FILE
      *****************************************************************
     C     UPDAT         BEGSR
      *
      * Get data from file
      *

     C     KGNEXV0       Klist
     C                   Kfld                    GEMTPY
     C                   Kfld                    GEMSET

     C                   Eval      GEMTPY = #1MTPY
     C                   Move      #1MSET        GEMSET
      * Get data from FTGNEXV0
     C     KGNEXV0       Chain     @GNEXV0
      *
     C                   If        Not %Found
     C                   Eval      GEMTPY = #1MTPY
     C                   Move      #1MSET        GEMSET
     C                   Eval      GEBAUT = SBAUT
     C                   Eval      GEPDTD = SPDTD
     C                   Eval      GESLTD = SSLTD                                             ERN054
     C                   Eval      GEM191 = SM191
     C                   Eval      GEM900 = SM900
     C                   Eval      GEM910 = SM910
     C                   Eval      GEAPPR = SAPPR                                             EEE065
     C                   Eval      GESTPQ = SSTPQ

     C                   Write     @GNEXV0
     C                   Else
     C                   Eval      GEBAUT = SBAUT
     C                   Eval      GEPDTD = SPDTD
     C                   Eval      GESLTD = SSLTD                                             ERN054
     C                   Eval      GEM191 = SM191
     C                   Eval      GEM900 = SM900
     C                   Eval      GEM910 = SM910
     C                   Eval      GEAPPR = SAPPR                                             EEE065
     C                   Eval      GESTPQ = SSTPQ

     C                   Update    @GNEXV0
     C                   Endif

     C                   ENDSR
      /EJECT
      *****************************************************************
      * VALIDATE THE SCREEN
      *****************************************************************
     C     VALID         BEGSR
      *
      ** If the Action code is Enquire then simply exit from program
      *
     C     ACTN          IFEQ      'E'
     C                   EXSR      END
     C                   ENDIF
      *
      ** If there are any errors ##Noerror is not blank
     C                   Eval      ##NoError = ' '
      * Default if blank
     C                   If        SBAUT = *blanks
     C                   Eval      SBAUT = 'N'
     C                   Endif
     C                   If        SPDTD = *blanks
     C                   Eval      SPDTD = 'N'
     C                   Endif
     C                   If        SSLTD = *blanks                                            ERN054
     C                   Eval      SSLTD = 'N'                                                ERN054
     C                   Endif                                                                ERN054
     C                   If        SM191 = *blanks
     C                   Eval      SM191 = 'N'
     C                   Endif
     C                   If        SM900 = *blanks
     C                   Eval      SM900 = 'N'
     C                   Endif
     C                   If        SM910 = *blanks
     C                   Eval      SM910 = 'N'
     C                   Endif

      * If not Y or N error
     C                   If        SBAUT  <> 'Y' and SBAUT <> 'N'
     C                   SETON                                        51
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
     C                   If        SPDTD  <> 'Y' and SPDTD <> 'N' and
     C                             SPDTD  <> 'M' and SPDTD <> 'L' and
     C                             SPDTD  <> 'T'
     C                   SETON                                        52
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
     C                   If        SSLTD  <> 'Y' and SSLTD <> 'N' and                         ERN054
     C                             SSLTD  <> 'M' and SSLTD <> 'L' and                         ERN054
     C                             SSLTD  <> 'T'                                              ERN054
     C                   SETON                                        57                      ERN054
     C                   MOVE      'STP0035'     ZAMSID                                       ERN054
     C                   EXSR      ZASNMS                                                     ERN054
     C                   Eval      ##NoError = 'Y'                                            ERN054
     C                   Endif                                                                ERN054
                                                                                              EEE065
      * Check Payment Route Flag                                                              EEE065
     C                   If        SAPPR  = *blanks                                           EEE065
     C                   Eval      SAPPR = 'N'                                                EEE065
     C                   Endif                                                                EEE065
                                                                                              EEE065
     C                   If        SAPPR  <> 'Y' and SAPPR <> 'N'                             EEE065
     C                   SETON                                        57                      EEE065
     C                   MOVE      'STP0047'     ZAMSID                                       EEE065
     C                   EXSR      ZASNMS                                                     EEE065
     C                   Eval      ##NoError = 'Y'                                            EEE065
     C                   Endif                                                                EEE065
                                                                                              EEE065
     C                   If        SM191  <> 'Y' and SM191 <> 'N'
     C                   SETON                                        53
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
     C                   If        SM900  <> 'Y' and SM900 <> 'N'
     C                   SETON                                        54
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
     C                   If        SM910  <> 'Y' and SM910 <> 'N'
     C                   SETON                                        55
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif

      * Check STP queue name
      *
      * Check if ? in field
      *
     C     '?'           SCAN      SSTPQ
     C                   If        %found
      *
     C                   CLEAR                   O2PARM                         RCD: STP Q
      *
      * Call select program
     C                   CALL      'FTP840'
     C                   PARM                    O2RTN             7
     C                   PARM      'S'           O2ACTC            1           Action Code
     C                   PARM                    O2PARM                        RCD: STP Q
      *
      * If return code is PTC0027 then queue selected
     C                   If        O2RTN = 'PTC0027'
     C                   Eval      SSTPQ = O2STPQ                               CD: STP Q
     C                   Eval      ##NoError = 'Y'
     C                   Endif
      *
     C                   Endif
      *
      * STP Queue must be defined
      *
     C                   If        SSTPQ <> *blanks
     C     SSTPQ         CHAIN     @STPQV1
     C                   If        Not %Found  or SQRECI <> 'D'
     C                   MOVE      'STP0003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        56
     C                   Eval      ##NoError = 'Y'
     C                   Endif
      *
     C                   Endif
      *
      *
      ** No errors so update the extension valid file
      *
     C                   IF        ##NoError = ' '
     C                   EXSR      UPDAT
     C                   ELSE
     C                   SETON                                        50
     C                   ENDIF
      *
     C     VAEXIT        ENDSR
      /EJECT
      *****************************************************************
      * Send message to program's message queue.
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     'XXUSRMSG'    ZAMSGF
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
     C     ZAEXIT        ENDSR
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *****************************************************************
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *
**CTDATA CPY@
(C) Copyright Midas-Kapiti International Ltd. 1997
