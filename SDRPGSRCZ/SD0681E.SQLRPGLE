     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD RTS function code enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0681E - Midas SD RTS function code enquiry.                *
      *                                                               *
      *  Function:  This program displays the details of a function   *
      *             code record.                                      *
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
      *                 CRT001             Date 02Mar95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  CRT001 - New program for Retail Teller System.               *
      *                                                               *
      *****************************************************************
     F*Function Codes Enquiry   Initialise Program F-Spec
     F/COPY WNCPYSRC,SD0681EFPG
     FSD0681E#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD RTS function code enquiry
      *
     F*SDFNCDL1* IF   E           K DISK    USROPN                                          MD058085
     F**********                           INFDS(INFDS1)                                    MD058085
     F**********                           INFSR(*PSSR)                                     MD058085
      * RTV : Midas SD RTS function codes file retrieval
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*Function Codes Enquiry   Initialise Program E-Spec
     D/COPY WNCPYSRC,SD0681EEPG
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*                                                                   S01229
     D*COPY*QWINDSRC,SD0680GDTA                                           S01229            MD058085
     D/COPY QWINDSRC,SD0680GDTL                                                             MD058085
     D*                                                                   S01229
     D*
     D*Function Codes Enquiry   Initialise Program I-Spec
     D/COPY WNCPYSRC,SD0681EIPG
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
      /EJECT
      * Parameter declarations
     D P1PARM          DS            82
      * RCD: Midas SD RTS function codes file retrieval
      * I : MAP Function Code
     D  P1FNCD                 1      3
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Validation Indicators:'
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0001                 1     10
     D SDFNCD        E DS                  EXTNAME(SDFNCJW0)                                MD058085
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         RCD: RTS functi
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
      *
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
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Enable PUTOVR
     C                   SETON                                        86
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
      * If record does not exist, then signal error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9931      *
      * Send message 'RTS function codes fil NF'
     C                   MOVEL     'USR2683'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * 00/Copy member SD0681ESFF - RTS function codes file  *
     C*Function Codes Enquiry   Calculate Detail Func Fld
     C/COPY WNCPYSRC,SD0681ESFF
      * USER: Load detail screen from DBF record
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
     C                   MOVEL     FQVWIN        WUVWIN                         Validate/Warnin
      * 00/Copy member SD0681ELDS - RTS function codes file  *
     C*Function Codes Enquiry   Load Detail Screen
     C/COPY WNCPYSRC,SD0681ELDS
     C                   END
      *
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
      * 00/COPY member SD0681EVKS - RTS function codes file  *
     C*Function Codes Enquiry   Validate Key Screen
     C/COPY WNCPYSRC,SD0681EVKS
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
     C   03              CAS                     ZXEXPG
      * HOME: Reset screen fields
      * Process detail screen input
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process key screen input
     C                   CAS                     CFPRSC
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
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y1SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Enable PUTOVR
     C                   SETON                                        86
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
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * 00/Copy member SD0681EPKR - RTS function codes file  *
     C*Function Codes Enquiry   Process Key Screen Rqst
     C/COPY WNCPYSRC,SD0681EPKR
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C   05              MOVEL     'Y'           W0TRN
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
     C                   MOVEL     'Y'           W0TRN
      * Validate details
     C                   EXSR      DCVLDL
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * Process record:
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * CALC: Detail screen function fields
      * 00/Copy member SD0681ESFF - RTS function codes file  *
     C*Function Codes Enquiry   Calculate Detail Func Fld
     C/COPY WNCPYSRC,SD0681ESFF
      * USER: Validate detail screen
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
     C                   PARM      'E'           UACTCD            1            Action  S01212 S0122
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
     C                   GOTO      DCEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD0681EVSW - RTS function codes file  *
     C*Function Codes Enquiry   Validate Detail Scrn Wdw
     C/COPY WNCPYSRC,SD0681EVSW
     C                   END                                                    *FI
      * 00/Copy member SD0681EVDS - RTS function codes file  *
     C*Function Codes Enquiry   Validate Detail Screen
     C/COPY WNCPYSRC,SD0681EVDS
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * USER: Perform confirmed action
      * 00/Copy member SD0681EPCA - RTS function codes file  *
     C*Function Codes Enquiry   Perform Confrimed Action
     C/COPY WNCPYSRC,SD0681EPCA
      * Quit if error signalled
     C   99              GOTO      EBEXIT
      * USER: Process command keys
      * 00/Copy member SD0681EPCK - RTS function codes file  *
     C*Function Codes Enquiry   Process Command Keys
     C/COPY WNCPYSRC,SD0681EPCK
      * Quit if error signalled
     C   99              GOTO      EBEXIT
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   EBEXIT        ENDSR
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
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
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
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1FNCD        #1FNCD                         Function Code
      * USER: Load key screen
      * 00/Copy member SD0681ELKS - RTS function codes file  *
     C*Function Codes Enquiry   Load Key Screen
     C/COPY WNCPYSRC,SD0681ELKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Get all Midas Modules - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSA         CHAIN     @BGREC8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0001                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SAEXIT                                       *QUIT
     C                   GOTO      SAEXIT
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
     CSR   SAEXIT        ENDSR
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
     C                   SETON                                        99        *
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
      * 00/Copy member SD0681EEPP - RTS function codes file  *
     C*Function Codes Enquiry   Exit Program Processing
     C/COPY WNCPYSRC,SD0681EEPP
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
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
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
     C                   OPEN      SD0681E#
     C**********         OPEN      SDFNCDL1                                                 MD058085
     C                   OPEN      SDMMODL1
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD0681E precompiler - RTS function codes file  *
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
     C                   EXSR      SARVGN
      * File Data DS - RTS function codes file  *
      * Override Indicators DS - RTS function codes file  *
      * 00/Copy member SD0681EFPG - RTS function codes file  *
      * 00/Copy member SD0681EEPG - RTS function codes file  *
      * 00/Copy member SD0681EIPG - RTS function codes file  *
      * 00/Copy member SD0681ECPG - RTS function codes file  *
     C*Function Codes Enquiry   Initialise Program C-Spec
     C/COPY WNCPYSRC,SD0681ECPG
      * 00/Copy member SD0681EOPG - RTS function codes file  *
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
     C/COPY WNCPYSRC,SD0681EPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0681EPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058085
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058085
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0681EPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*Function Codes Enquiry   Initialise Program O-Spec
     O/COPY WNCPYSRC,SD0681EOPG
**CTDATA CPY@
(c) Finastra International Limited 2001
