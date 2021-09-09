     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1210W1 - Auto Generation Rules Extension                   *
      *                                                               *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems Ltd 2003   *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 15Jul2011             *
      *  Last Amend No. ESL038             Date 30Nov2004             *
      *  Prev Amend No. ERN056             Date 09Aug2004             *
      *                 EEE065             Date 06Apr2004             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *  ESL038 - Funds Transfer STP Enhancements                     *
      *  ERN056 - FT Rocket Payment Messages                          *
      *  EEE065 - FT Payment Routing                                  *
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
     FME1210#1  CF   E             WORKSTN
      ** Display file for Valid messages extension
      *
     FMEINMVV1  IF   E           K DISK
      ** Rtv: Valid messages extension
      *
     FMEINMVV0  UF A E           K DISK
      ** Upd: Valid messages extension
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
     D/COPY QWINDSRC,ME1210SDTA
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
     C     ESL038        Ifne      'Y'                                                        ESL038
     C                   EXFMT     ME1210W#1
     C                   Else                                                                 ESL038
     C                   Exfmt     ME1210W#2                                                  ESL038
     C                   Endif                                                                ESL038
     C                   EXSR      CLEAR
      *
     C     *IN03         CASEQ     '1'           EXIT
     C     *IN05         CASEQ     '1'           RESET
     C     *IN12         CASEQ     '1'           PREV
     C     ESL038        CASEQ     'Y'           VALID2                                       ESL038
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
      ** Only display the window if SAR EEE065 is active.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'EEE065'      @SARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           EEE065            1                          ESL038
     C                   ELSE                                                                 ESL038
     C                   MOVE      'Y'           EEE065                                       ESL038
     C                   ENDIF                                                                ESL038
      *                                                                                       ESL038
      ** or if SAR ESL038 is active.                                                          ESL038
      *                                                                                       ESL038
     C                   CALL      'AOSARDR0'                                                 ESL038
     C                   PARM      *BLANKS       @RTCD             7                          ESL038
     C                   PARM      '*VERIFY'     @OPTN             7                          ESL038
     C                   PARM      'EEE065'      @SARD             6                          ESL038
     C     SCSARD        PARM      *BLANKS       DSFDY                                        ESL038
      *                                                                                       ESL038
     C     @RTCD         IFNE      *BLANKS                                                    ESL038
     C                   MOVE      'N'           ESL038            1                          ESL038
     C                   ELSE                                                                 ESL038
     C                   MOVE      'Y'           ESL038                                       ESL038
     C                   ENDIF                                                                ESL038
      *                                                                                       ESL038
     C     EEE065        IFNE      'Y'                                                        ESL038
     C     ESL038        ANDNE     'Y'                                                        ESL038
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

     C     KINMVV1       Klist
     C                   Kfld                    MVNWRK
     C                   Kfld                    MVMTPY
     C                   Kfld                    MVSNDK

     C                   Eval      MVNWRK = #1NWRK
     C                   Eval      MVMTPY = #1MTPY
     C                   Eval      MVSNDK = #1SNDK
      * Get data from MEINMVV1
     C     KINMVV1       Chain     @INMVV1
     C                   If        Not %Found
     C                   Eval      SDSPR = 'N'
     C                   Eval      SMCMG = 'N'
     C                   Eval      SMCSX = *blanks
     C************       Eval      SM281 = 'N'                                                ERN056
     C************       Eval      SM291 = 'N'                                                ERN056
     C                   Eval      SMACK = 'N'                                                ERN056
     C                   Eval      SMNCK = 'N'                                                ERN056
     C                   Eval      SIMPA = 'N'
     C                   Eval      SREVA = 'N'
     C     ESL038        Ifeq      'Y'                                                        ESL038
     C                   Eval      SDSPI = 'Y'                                                ESL038
     C                   Eval      SDSPO = 'Y'                                                ESL038
     C                   Eval      SDSPR = 'N'                                                ESL038
     C                   Eval      SMCMG = 'N'                                                ESL038
     C                   Eval      SDINC = 'N'                                                ESL038
     C                   Endif                                                                ESL038
     C                   Else
     C                   Eval      SDSPR = MVDSPR
     C                   Eval      SMCMG = MVMCMG
     C                   Eval      SMCSX = MVMCSX
     C************       Eval      SM281 = MVM281                                             ERN056
     C************       Eval      SM291 = MVM291                                             ERN056
     C                   Eval      SMACK = MVMACK                                             ERN056
     C                   Eval      SMACM = MVMACM                                             ERN056
     C                   Eval      SMNCK = MVMNCK                                             ERN056
     C                   Eval      SMNCM = MVMNCM                                             ERN056
     C                   Eval      SIMPA = MVIMPA
     C                   Eval      SREVA = MVREVA
     C     ESL038        Ifeq      'Y'                                                        ESL038
     C                   Eval      SDSPI = MVDSPI                                             ESL038
     C                   Eval      SDSPO = MVDSPO                                             ESL038
     C                   Eval      SDSPR = MVDSPR                                             ESL038
     C                   Eval      SMCMG = MVMCMG                                             ESL038
     C                   Eval      SDINC = MVDINC                                             ESL038
     C                   Endif                                                                ESL038
     C                   Endif

      * insert defaulting
     C                   Else
     C                   Eval      SDSPR = 'N'
     C                   Eval      SMCMG = 'N'
     C                   Eval      SMCSX = *blanks
     C************       Eval      SM281 = 'N'                                                ERN056
     C************       Eval      SM291 = 'N'                                                ERN056
     C                   Eval      SMACK = 'N'                                                ERN056
     C                   Eval      SMNCK = 'N'                                                ERN056
     C                   Eval      SIMPA = 'N'
     C                   Eval      SREVA = 'N'
     C     ESL038        Ifeq      'Y'                                                        ESL038
     C                   Eval      SDSPI = 'Y'                                                ESL038
     C                   Eval      SDSPO = 'Y'                                                ESL038
     C                   Eval      SDSPR = 'N'                                                ESL038
     C                   Eval      SMCMG = 'N'                                                ESL038
     C                   Eval      SDINC = 'N'                                                ESL038
     C                   Endif                                                                ESL038
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

     C     KINMVV0       Klist
     C                   Kfld                    MVNWRK
     C                   Kfld                    MVMTPY
     C                   Kfld                    MVSNDK

     C                   Eval      MVNWRK = #1NWRK
     C                   Eval      MVMTPY = #1MTPY
     C                   Eval      MVSNDK = #1SNDK
      * Get data from MEINMVV0
     C     KINMVV0       Chain     @INMVV0
      *
     C                   If        Not %Found
     C                   Eval      MVNWRK = #1NWRK
     C                   Eval      MVMTPY = #1MTPY
     C                   Eval      MVSNDK = #1SNDK
     C                   Eval      MVRECI = 'D'
     C                   Eval      MVDSPR = SDSPR
     C                   Eval      MVMCMG = SMCMG
     C                   Eval      MVMCSX = SMCSX
     C************       Eval      MVM281 = SM281                                             ERN056
     C************       Eval      MVM291 = SM291                                             ERN056
     C                   Eval      MVMACK = SMACK                                             ERN056
     C                   Eval      MVMACM = SMACM                                             ERN056
     C                   Eval      MVMNCK = SMNCK                                             ERN056
     C                   Eval      MVMNCM = SMNCM                                             ERN056
     C                   Eval      MVIMPA = SIMPA
     C                   Eval      MVREVA = SREVA
     C     ESL038        Ifeq      'Y'                                                        ESL038
     C                   Eval      MVDSPI = SDSPI                                             ESL038
     C                   Eval      MVDSPO = SDSPO                                             ESL038
     C                   Eval      MVDSPR = SDSPR                                             ESL038
     C                   Eval      MVMCMG = SMCMG                                             ESL038
     C                   Eval      MVDINC = SDINC                                             ESL038
     C                   Endif                                                                ESL038

     C                   Write     @INMVV0
     C                   Else
     C                   Eval      MVRECI = 'D'
     C                   Eval      MVDSPR = SDSPR
     C                   Eval      MVMCMG = SMCMG
     C                   Eval      MVMCSX = SMCSX
     C************       Eval      MVM281 = SM281                                             ERN056
     C************       Eval      MVM291 = SM291                                             ERN056
     C                   Eval      MVMACK = SMACK                                             ERN056
     C                   Eval      MVMACM = SMACM                                             ERN056
     C                   Eval      MVMNCK = SMNCK                                             ERN056
     C                   Eval      MVMNCM = SMNCM                                             ERN056
     C                   Eval      MVIMPA = SIMPA
     C                   Eval      MVREVA = SREVA
     C     ESL038        Ifeq      'Y'                                                        ESL038
     C                   Eval      MVDSPI = SDSPI                                             ESL038
     C                   Eval      MVDSPO = SDSPO                                             ESL038
     C                   Eval      MVDSPR = SDSPR                                             ESL038
     C                   Eval      MVMCMG = SMCMG                                             ESL038
     C                   Eval      MVDINC = SDINC                                             ESL038
     C                   Endif                                                                ESL038

     C                   Update    @INMVV0
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
     C                   If        SDSPR = *blanks
     C                   Eval      SDSPR = 'N'
     C                   Endif
     C                   If        SMCMG = *blanks
     C                   Eval      SMCMG = 'N'
     C                   Endif
     C************       If        SM281 = *blanks                                            ERN056
     C************       Eval      SM281 = 'Y'                                                ERN506
     C************       Endif                                                                ERN506
     C************       If        SM291 = *blanks                                            ERN506
     C************       Eval      SM291 = 'N'                                                ERN506
     C************       Endif                                                                ERN506
     C                   If        SIMPA = *blanks
     C                   Eval      SIMPA = 'N'
     C                   Endif
     C                   If        SREVA = *blanks
     C                   Eval      SREVA = 'N'
     C                   Endif

      * If not Y or N error
     C                   If        SDSPR  <> 'Y' and SDSPR <> 'N'
     C                   SETON                                        51
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
     C                   If        SMCMG  <> 'Y' and SMCMG <> 'N'
     C                   SETON                                        52
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
     C************       If        SM281  <> 'Y' and SM281 <> 'N'                             ERN056
     C************       SETON                                        54                      ERN056
     C************       MOVE      'STP0035'     ZAMSID                                       ERN056
     C************       EXSR      ZASNMS                                                     ERN056
     C************       Eval      ##NoError = 'Y'                                            ERN056
     C************       Endif                                                                ERN056
      ************                                                                            ERN056
     C************       If        SM291  <> 'Y' and SM291 <> 'N'                             ERN056
     C************       SETON                                        55                      ERN056
     C************       MOVE      'STP0040'     ZAMSID                                       ERN056
     C************       EXSR      ZASNMS                                                     ERN056
     C************       Eval      ##NoError = 'Y'                                            ERN056
     C************       Endif                                                                ERN056
                                                                                              ERN056
     C                   If        SMACK  <> 'Y' and SMACK <> 'N'                             ERN056
     C                   SETON                                        54                      ERN056
     C                   MOVE      'STP0008'     ZAMSID                                       ERN056
     C                   EXSR      ZASNMS                                                     ERN056
     C                   Eval      ##NoError = 'Y'                                            ERN056
     C                   Endif                                                                ERN056
     C                   If        SMACK = 'Y' and                                            ERN056
     C                             (SMACM <> '181' and SMACM <> '281')                        ERN056
     C                   SETON                                        58                      ERN056
     C                   MOVE      'STP0042'     ZAMSID                                       ERN056
     C                   EXSR      ZASNMS                                                     ERN056
     C                   Eval      ##NoError = 'Y'                                            ERN056
     C                   Endif                                                                ERN056
     C                   If        SMACK = 'N' and                                            ERN056
     C                             (SMACM <> '181' and SMACM <> '281'                         ERN056
     C                             and SMACM <> *Blanks)                                      ERN056
     C                   SETON                                        58                      ERN056
     C                   MOVE      'STP0043'     ZAMSID                                       ERN056
     C                   EXSR      ZASNMS                                                     ERN056
     C                   Eval      ##NoError = 'Y'                                            ERN056
     C                   Endif                                                                ERN056
                                                                                              ERN056
     C                   If        SMNCK  <> 'Y' and SMNCK <> 'N'                             ERN056
     C                   SETON                                        55                      ERN056
     C                   MOVE      'STP0008'     ZAMSID                                       ERN056
     C                   EXSR      ZASNMS                                                     ERN056
     C                   Eval      ##NoError = 'Y'                                            ERN056
     C                   Endif                                                                ERN056
     C                   If        SMNCK = 'Y' and                                            ERN056
     C                             (SMNCM <> '191' and SMNCM <> '291')                        ERN056
     C                   SETON                                        59                      ERN056
     C                   MOVE      'STP0044'     ZAMSID                                       ERN056
     C                   EXSR      ZASNMS                                                     ERN056
     C                   Eval      ##NoError = 'Y'                                            ERN056
     C                   Endif                                                                ERN056
     C                   If        SMNCK = 'N' and SMNCM <> *Blanks                           ERN056
     C                   SETON                                        59                      ERN056
     C                   MOVE      'STP0045'     ZAMSID                                       ERN056
     C                   EXSR      ZASNMS                                                     ERN056
     C                   Eval      ##NoError = 'Y'                                            ERN056
     C                   Endif                                                                ERN056

     C                   If        SIMPA  <> 'Y' and SIMPA <> 'N'
     C                   SETON                                        56
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
     C                   If        SREVA  <> 'Y' and SREVA <> 'N'
     C                   SETON                                        57
     C                   MOVE      'STP0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
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
      *****************************************************************                       ESL038
      * VALIDATE THE SCREEN                                                                   ESL038
      *****************************************************************                       ESL038
     C     VALID2        BEGSR                                                                ESL038
      *                                                                                       ESL038
      ** If the Action code is Enquire then simply exit from program                          ESL038
     C     ACTN          IFEQ      'E'                                                        ESL038
     C                   EXSR      END                                                        ESL038
     C                   ENDIF                                                                ESL038
      *                                                                                       ESL038
      ** If there are any errors ##Noerror is not blank                                       ESL038
     C                   Eval      ##NoError = ' '                                            ESL038
      *                                                                                       ESL038
      * Default if blank                                                                      ESL038
     C                   If        SDSPR = *blanks                                            ESL038
     C                   Eval      SDSPR = 'N'                                                ESL038
     C                   Endif                                                                ESL038
     C                   If        SMCMG = *blanks                                            ESL038
     C                   Eval      SMCMG = 'N'                                                ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      * Indicator to display PCAT on Incoming Payments                                        ESL038
     C                   If        SDSPI  <> 'Y' and SDSPI <> 'N'                             ESL038
     C                   SETON                                        51                      ESL038
     C                   MOVE      'STP0101'     ZAMSID                                       ESL038
     C                   EXSR      ZASNMS                                                     ESL038
     C                   Eval      ##NoError = 'Y'                                            ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      * Indicator to display PCAT on Outgoing Payments                                        ESL038
     C                   If        SDSPO  <> 'O' and SDSPI <> 'B'                             ESL038
     C                             and SDSPO <> 'N'                                           ESL038
     C                   SETON                                        52                      ESL038
     C                   MOVE      'STP0102'     ZAMSID                                       ESL038
     C                   EXSR      ZASNMS                                                     ESL038
     C                   Eval      ##NoError = 'Y'                                            ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      * Display pay route indicaor must be Y or N                                             ESL038
     C                   If        SDSPR  <> 'Y' and SDSPR <> 'N'                             ESL038
     C                   SETON                                        53                      ESL038
     C                   MOVE      'STP0103'     ZAMSID                                       ESL038
     C                   EXSR      ZASNMS                                                     ESL038
     C                   Eval      ##NoError = 'Y'                                            ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      * External system indicaor must be Y or N                                               ESL038
     C                   If        SMCMG  <> 'Y' and SMCMG <> 'N'                             ESL038
     C                   SETON                                        54                      ESL038
     C                   MOVE      'STP0104'     ZAMSID                                       ESL038
     C                   EXSR      ZASNMS                                                     ESL038
     C                   Eval      ##NoError = 'Y'                                            ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      * Disable input correction must be Y or N                                               ESL038
     C                   If        SDINC  <> 'Y' and SDINC <> 'N'                             ESL038
     C                   SETON                                        54                      ESL038
     C                   MOVE      'STP0105'     ZAMSID                                       ESL038
     C                   EXSR      ZASNMS                                                     ESL038
     C                   Eval      ##NoError = 'Y'                                            ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      *                                                                                       ESL038
      ** No errors so update the extension valid file                                         ESL038
     C                   IF        ##NoError = ' '                                            ESL038
     C                   EXSR      UPDAT                                                      ESL038
     C                   ELSE                                                                 ESL038
     C                   SETON                                        50                      ESL038
     C                   ENDIF                                                                ESL038
      *                                                                                       ESL038
     C     VAEXT2        ENDSR                                                                ESL038
      /EJECT                                                                                  ESL038
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
(C) Copyright Misys International Banking Systems. 2004.
