     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Edit Withholding Tax Rate Codes')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000205 - Edit Withholding Tax Rate Codes                   *
      *                                                               *
      *  Function:  This program maintains Withholding Tax Rate Codes *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CGL165  *CREATE    Date 17Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Withholding Tax Enhancement                         *
      *                                                               *
      *****************************************************************
     FSD000205DFCF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Edit withholding tax rate code
      *
     FSDWTRCL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
     F                                     RENAME(SDWTRCD0:SDWTRCD2)
      * RTV : Midas SD Withholding tax rate codes retrieval
      *
     FSDWTRCL0  UF A E           K DISK    USROPN
     F                                     RENAME(SDWTRCD0:SDWTRCD1)
     F                                     COMMIT
     F                                     INFDS(ID0003)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Withholding tax rate codes update
      *
     FSDFCTLL0  UF   E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0004)
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
     FSDWTDML2  IF   E           K DISK
     F                                     RENAME(SDWTDMD0:SDWTDMD3)
      * Midas SD Withholding tax rate default matrix retrieval
     FSDWTDML3  IF   E           K DISK
     F                                     RENAME(SDWTDMD0:SDWTDMD4)
      * Midas SD Withholding tax rate default matrix retrieval
 TST F*DEALSDY1 IF   E           K DISK
      * Midas DL Withholding tax rate code of MM deals
 TST F*ACCNTY1  IF   E           K DISK
      * Midas DL Withholding tax rate code of retail accounts
      *
     D AENA            S             78    DIM(3) CTDATA PERRCD(1)
     D*
     D*  DETAIL LINE COMMAND KEY TEXT
     D*
     D*
     D* KEY LINE COMMAND KEY TEXT
     D*
     D ARGV            S             78    DIM(1) CTDATA PERRCD(1)
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D NUM             S              1    DIM(16)
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
     D @1DBRC        E DS                  EXTNAME(SDWTRCL0)
     D                                     Inz
      * UPD : Midas SD Withholding tax rate codes update
      * Current/previous master file format fields for change control
      *
     D @2DBRC          DS            61
      * Stored master file format fields
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D                                     Inz
      ** Currency Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D                                     Inz
      ** First data structure for access program, Short data structure
      *
     D QSDFC1        E DS                  EXTNAME(SDFCTLL0)
     D                                     Inz
      * UPD : Midas SD Standing data controls update

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D                                     Inz

      ** External data structure for Account Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D                                     Inz
      *
     D YARDCS          DS            22
     D YBRDCS          DS            22
     D YCRDCS          DS            64
     D YDRDCS          DS            22
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D ID0003          DS           528
      * File information data structure
      *
     D ID0004          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS             2
      * KEY: Midas SD Withholding tax rate codes retrieval
      * I : MAP Withholding Tax Rate Code
     D  P1WTRC                 1      2
     D P2PARM          DS
      * I :  Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0001                 1     10
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Key Field
     D  ZA0003                 2     11
      * Message data for 'Invalid Withholding Tax Rate Code'
      * Withholding Tax Rate Code
     D  ZA0004                 1      2
      * Message data for 'Withholding tax rate is reqd.'
      * Withholding Tax Rate
     D  ZA0005                 1      5  2
      * Message data for 'Currency is required.'
      * Currency
     D  ZA0006                 1      3
      * Message data for 'Description is required.'
      * Description
     D  ZA0007                 1     30

      // Variables Declaration
     D Exists          S               N
     D PACOD           S                   LIKE(#1RITAC)
     D rcdCount        S              3U 0
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         KEY:Tax Rate Cd
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
     C     #1WTRC        IFEQ      *BLANK                                       W Tax Rate Code
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
      * Redisplay previous screen
     C   12              CAS                     CCDSPV2
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
     C                   KFLD                    WTRC                           W Tax Rate Code
      * Setup key
     C                   MOVEL     #1WTRC        WTRC                           W Tax Rate Code
     C     KRTV          CHAIN     SDWTRCD2                           9091      *
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
      * Send message 'Withholding Tax Rate Codes       NF'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      *
      * USER: Initialize detail screen (existing record)
      * Set-up DTL Screen Footer - Standard Functions  *

      ** Initialize the indicator for deletion action
     C                   Eval      *IN92  = *Off
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'
     C                   Eval      *IN92  = *On
     C                   MOVEA     AENA(1)       ##CTX1
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'
     C                   MOVEA     AENA(2)       ##CTX1
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'
     C                   MOVEA     AENA(3)       ##CTX1
     C                   END
      *
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        9931      *
      * Send message 'Withholding Tax Rate Codes       EX'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0534'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
      * USER: Initialize detail screen (new record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'
     C                   MOVEA     AENA(1)       ##CTX1
     C                   END
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'
     C                   MOVEA     AENA(2)       ##CTX1
     C                   END
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'
     C                   MOVEA     AENA(3)       ##CTX1
     C                   END
     C*
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
      * USER: Validate key screen
     C                   MOVEL     #1WTRC        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1WTRC        WUIVKF                         If value in key
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     '?INVAL'      W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     #1WTRC        ZA0001                         W Tax Rate Code
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   ELSE
      * CASE: WRK.If value in key field is Asterisk
     C     WUIVKF        IFEQ      '*'                                          *IF
     C                   MOVEL     *BLANK        W0RTN                          *Return code
     C                   MOVEL     '?INVAL'      W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     WUIVKF        ZA0002                         If value in key
     C                   MOVEL     #1WTRC        ZA0003                         W Tax Rate Code
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Withholding tax rate code required
     C     #1WTRC        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      BFEXIT
     C                   ELSE
     C                   MOVEL     #1WTRC        LCHAR             1
     C                   MOVE      #1WTRC        RCHAR             1
     C     LCHAR         IFLT      '0'
     C     RCHAR         ORLT      '0'
     C     LCHAR         ORGT      '9'
     C     RCHAR         ORGT      '9'
     C     LCHAR         OREQ      '0'
     C     RCHAR         ANDEQ     '0'
     C                   SETON                                        9931
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0548'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      BFEXIT
     C                   ENDIF
     C                   END                                                    FI
      **
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
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Set-up KEY Screen Footer - Standard Functions  *
     C*****              MOVEA     ARGV(1)       ##CTX1
     C                   MOVEA     AENA(2)       ##CTX1
      *
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
     CSR   CCDSPV2       BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
      * Set-up KEY Screen Footer - Standard Functions  *
     C*****              MOVEA     ARGV(1)       ##CTX1
     C                   MOVEA     AENA(2)       ##CTX1
      *
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C   12              MOVEL     'X'           W0TRN
     C   12              MOVE      'N'           W0RPT
      *================================================================
     CSR   CCEXIT2       ENDSR
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
      * Delete processing.
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
      *
      * Withholding tax rate
      * CASE: DTL. Withholding Tax rate is blank
     C     #1WTRT        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1WTRT        ZA0005                         W Tax Rate
      * Send message 'Withholding tax rate is reqd.'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0535'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   ELSE
     C                   CALL      'ZALIGN'
     C                   PARM                    P@RTCD            7
     C                   PARM      #1WTRT        @FIELD
     C                   PARM      2             @DECI             1 0
     C                   PARM      5             @DIGT             2 0
     C                   PARM      *BLANK        @WTRTV           16
      *
     C     P@RTCD        IFNE      *BLANK
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0537'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   ENDIF
      *
     C                   MOVE      @WTRTV        #DWTRT            5 2
     C     #DWTRT        IFGT      100
     C     #DWTRT        ORLT      0
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0537'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   ENDIF
     C                   END                                                    *FI
      *
      * Currency code
     C                   If        #1CYCD <> *Blank
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM      '*KEY    '    P@OPTN            7
     C                   PARM                    #1CYCD
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     P@RTCD        IFNE      *BLANK
      * Send message 'Currency Codes         NF'
     C                   MOVEL     'USR0235'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9933      *
     C                   ENDIF
     C                   ENDIf                                                  *FI
      *
      * Minimum Interest
     C                   IF        #1MINT <> *BlankS

     C                   CALL      'ZALIGN'
     C                   PARM                    P@RTCD            7
     C                   PARM      #1MINT        @FIELD           16
     C                   PARM      0             @DECI             1 0
     C                   PARM      15            @DIGT             2 0
     C                   PARM      *BLANK        @VAL             16
      *
     C                   MOVEA     @VAL          NUM
      *
     C     P@RTCD        IFNE      *BLANK
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0538'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
     C                   ELSE
     C     NUM(3)        IFGT      '0'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0549'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * CASE: DTL.Description is Blank
     C     #1DESC        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1DESC        ZA0007                         Description
      * Send message 'Description is required.'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0539'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9934      *
      *
     C                   END                                                    *FI
      *
      * CASE: DTL.Retail Account Code is Blank
     C     #1RITAC       IFEQ      *BLANK                                       *IF
      * Setup message data for message
      * Send message 'Retail Interest Account must be entered'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0556'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
     C                   Else
      *
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      #1RITAC       PACOD
     C     SDACOD        PARM      SDACOD        DSSDY

      ** Record not found

     C                   IF        P@RTCD = '*NRF   '
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USR0173'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *

     C                   ELSE

      ** Must be non-title account code

     C                   IF        A5TOIN = 'Y'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USR4230'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
     C                   ENDIF

     C                   IF        A5ACTY <>'G'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USR2769'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9935      *
     C                   ENDIF

     C                   EVAL      #1RITAC = A5ACCD
     C                   ENDIF


     C                   ENDIF                                                  *FI
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
      * Create Withholding Tax Rate Codes - Withholding Tax Rate Codes  *
     C                   EXSR      SACRRC
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
      * Delete Withholding Tax Rate Codes - Withholding Tax Rate Codes  *
     C                   EXSR      SCDLRC
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
      * Change Withholding Tax Rate Codes - Withholding Tax Rate Codes  *
     C                   EXSR      SECHRC
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
     C     P1WTRC        IFEQ      *BLANK                                       W Tax Rate Code
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
     C                   MOVEL     *BLANK        #1TYPC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1WTRT                         W Tax Rate
     C                   MOVEL     *BLANK        #1MINT                         Minimum Int.
     C                   MOVEL     *BLANK        #1CYCD                         Currency
     C                   MOVEL     *BLANK        #1DESC                         Description
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move SDWTRCD2 fields to screen
      *================================================================
      ** Retrieve Decimal point
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    CYCD
     C     SDCURR        PARM      SDCURR        DSFDY
      *
      ** Retrieve Minimum interest
     C                   MOVE      MINT          WUZASF           16
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                                      ZEDIT Screen Fi
     C     WUZASF        PARM      WUZASF        WQ0029           16            ZALIGN Screen F
     C                   PARM      0             WQ0030            1 0          ZALIGN No Of De
      ** Retrieve Withholding tax rate
     C                   MOVE      WTRT          WUZAFF           16
      * ZEDIT Screen Field - Standard Functions  *
     C                   CALL      'ZEDIT'                                      ZEDIT Screen Fi
     C     WUZAFF        PARM      WUZAFF        WQ0029           16            ZALIGN Screen F
     C                   PARM      2             WQ0030            1 0          ZALIGN No Of De
      *
     C                   Z-ADD     LCD           #1LCD                          Last Change Dat
     C                   MOVEL     TYPC          #1TYPC                         Type of Last Ch
     C                   MOVEL     WTRC          #1WTRC                         W Tax Rate Code
     C                   MOVE      WUZAFF        #1WTRT                         W Tax Rate
     C                   MOVEL     WUZASF        #1MINT                         Minimun Int.
     C                   MOVEL     CYCD          #1CYCD                         Currency
     C                   MOVEL     DESC          #1DESC                         Description
     C                   MOVEL     RITAC         #1RITAC
      * Hold existing record image
     C                   MOVEL     @1DBRC        @2DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1WTRC        #1WTRC                         W Tax Rate Code
      * USER: Initialize key screen
      * Set-up KEY Screen Footer - Standard Functions  *
     C*****              MOVEA     ARGV(1)       ##CTX1
     C                   MOVEA     AENA(2)       ##CTX1
     C                   SETON                                        87
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Withholding Tax Rate Codes - Withholding Tax Rate Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to SDWTRCD1
     C                   MOVEL     #1WTRC        WTRC                           W Tax Rate Code
     C                   Z-ADD     #DWTRT        WTRT                           W Tax Rate
     C                   MOVE      @VAL          MINT                           Minimun Int.
     C                   MOVEL     #1CYCD        CYCD                           Currency
     C                   MOVEL     #1DESC        DESC                           Description
     C                   Z-ADD     WURDNB        LCD                            Last Change Dat
     C                   MOVEL     'I'           TYPC                           Type of Last Ch
     C                   MOVEL     #1RITAC       RITAC
      *
     C     KLCRSA        KLIST
     C                   KFLD                    WTRC                           W Tax Rate Code
      * Check for duplicate primary key

      /free
         //TEST Setll WTRC SDWTRCL0;
         exec sql
             select count(*)  into :rcdCount
              from SDWTRCL0 where WTRC = :WTRC;
      /end-free

     C                   IF        sqlcod < 0 and RcdCount > 0
     C                   MOVEL     'USR0078'     W0RTN             7
      * Send message 'Withholding Tax Rate Code     EX'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0534'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   ENDIf
      *
     C                   WRITE     SDWTRCD1                             91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * USER: Processing after Data update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDWTRCPD'    AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSB        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
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
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      * Delete Withholding Tax Rate Codes - Withholding Tax Rate Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before Data update
      * CASE: PAR.Action Code is Delete
     C     P2ANCD        IFNE      'D'                                          *IF
      *
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y2U0004'     W0RTN                          *Return code
     C                   GOTO      SCEXIT                                       *QUIT
     C                   END                                                    *FI
      * Move key fields to SDWTRCD1
     C                   MOVEL     #1WTRC        WTRC                           W Tax Rate Code
      *
     C     KLDLSC        KLIST
     C                   KFLD                    WTRC                           W Tax Rate Code
     C     KLDLSC        CHAIN     SDWTRCD1                           9091      *
     C     *IN90         IFEQ      '1'
      * Record already deleted
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
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C     @2DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C     KLDLSC        SETLL     SDWTRCD1                           9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI @2DBRC
      *................................................................
     C  N90              EXSR      TRCCHK
     C  N90              DELETE    SDWTRCD1                             91      *
     C  N90*IN91         IFEQ      '1'
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF delete successful
      * USER: Processing after Data update
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SDCHRC
     C                   MOVEL     'D'           WUTYLC                         Type of Last Ch
      *
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
     C                   MOVEL     'SDWTRCPD'    AHFLNM                         Filename
      *
     C     KLCHSD        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSD        CHAIN     @AHREAU                            9091      *
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
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Withholding Tax Rate Codes - Withholding Tax Rate Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YCRDC             1
      *
      * Move key fields to SDWTRCD1
     C                   MOVEL     #1WTRC        WTRC                           W Tax Rate Code
      *
     C     KLCHSE        KLIST
     C                   KFLD                    WTRC                           W Tax Rate Code
     C     KLCHSE        CHAIN     SDWTRCD1                           9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * Check for changed record
     C     @2DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Release record lock
     C                   UNLOCK    SDWTRCL0                             91      *
     C                   GOTO      SEEXIT
     C                   END                                                    FI @2DBRC
      * Store record data for null update check
     C                   MOVE      @1DBRC        YCRDCS
      * Move non-key fields to SDWTRCD1
     C                   Z-ADD     #DWTRT        WTRT                           W Tax Rate
     C                   MOVE      @VAL          MINT                           Minimum Int.
     C                   MOVEL     #1CYCD        CYCD                           Currency
     C                   MOVEL     #1DESC        DESC                           Description
     C                   MOVEL     #1RITAC       RITAC
     C                   Z-ADD     WURDNB        LCD                            Last Change Dat
     C                   MOVEL     'A'           TYPC                           Type of Last Ch
      *
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * Set PGM.*Record Data Changed flag
     C     @1DBRC        IFNE      YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   END
      * If changed update record otherwise release record
     C     YCRDC         IFEQ      'Y'
     C                   UPDATE    SDWTRCD1                             91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    SDWTRCL0                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        @2DBRC
      * DBF change successful
      * USER: Processing after Data update
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SFCHRC
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
     C                   MOVE      'N'           YDRDC             1
      *
      * Move key fields to @AHREAU
     C                   MOVE      *BLANK        AHFLNM                         Filename
     C                   MOVEL     'SDWTRCPD'    AHFLNM                         Filename
      *
     C     KLCHSF        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSF        CHAIN     @AHREAU                            9091      *
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
     CSR   SFEXIT        ENDSR
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
     CSR   TRCCHK        BEGSR
      *================================================================
      * Check tax rate code
      *================================================================
      ** Check if tax rate code is used in files
      *
     C     KLDWML        KLIST
     C                   KFLD                    #1WTRC                         W Tax Rate Code
      *
tst  C*****KLDWML        SETLL     SDWTDMD3

      /free

        // Check if tax rate code is used in files
        Setll #1WTRC SDWTDML2;
        Exists = %equal(SDWTDML2);

        If not Exists;
           Setll #1WTRC SDWTDML3;
           Exists = %equal(SDWTDML3);
        EndIf;


        // Check WTRC in AMAD;
        If not Exists;
           exec sql
              select count(*) into :rcdCount
                 from ACCNTBXC where ATTXC1 = :#1WTRC or ATTXC2 = :#1WTRC;

           If rcdCount > 0;
              Exists = *on;
           EndIf;
        EndIf;

        // Check WTRC in LDNI;
        If not Exists;
           exec sql
              select count(*) into :rcdCount
                 from DEALSDC where TXC1 = :#1WTRC or TXC2 = :#1WTRC;

           If rcdCount > 0;
              Exists = *on;
           EndIf;
        EndIf;

      /end-free

tst  C**** *IN90         IFEQ      ' 1'
      ** Check if tax rate code is in file DEALSDY1
TST  C*****KLDLSC        CHAIN     DEALYF1                            90
TST  C******IN90         IFEQ      ' 1'
      ** Check if tax rate code is in file ACCNTY1
TST  C*****KLDLSC        CHAIN     ACNTYF1                            90
TST  C*****              ENDIF
tst  C*********          ENDIF
      *
     C                   SETOFF                                       90
     C                   IF         Exists
     C                   MOVEL     'USS0536'     W0RTN             7
      * Send message 'Tax rate code can not be deleted'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0536'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        90
     C                   ENDIF
      *
     CSR   TRINIT        ENDSR
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
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
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
      * Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
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
     C                   OPEN      SD000205DF
     C                   OPEN      SDWTRCL1
     C                   OPEN      SDWTRCL0
     C                   OPEN      SDFCTLL0
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SDH021R Precompiler - Withholding Tax Rate Codes *
      * Remove Last Amend Box and Creation Parameter Functions
      * Copyright Statement - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Insert processing.
      * CASE: PAR.Action Code is Insert
     C     P2ANCD        IFEQ      'I'                                          *IF
     C                   MOVEL     'ADD'         W0PMD                          *Program mode
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     'CHG'         W0PMD                          *Program mode
     C                   END                                                    *FI
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
      * Standard Midas PSSR processing.
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'PSSR   '     P0RTN
     C                   DUMP
      *
      ** Route job back into Midas.
      *
     C                   SETON                                        LR
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA AENA
F3=Main Menu   F10=Delete   F12=Previous
F3=Exit   F12=Previous
F3=Main Menu   F12=Previous
**CTDATA ARGV
F3=Previous
**CTDATA CPY@
(c) Finastra International Limited 2015
