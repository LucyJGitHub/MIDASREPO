     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT STP Payment Charges Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP002 - Midas FT STP Payment Charges Maintenance            *
      *                                                               *
      *  Function:  This program controls the display and update      *
      *             of STP Correspondents                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 ESL038 *Create     Date 20Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 Upgrade STP enhancement to Midas Plus level.        *
      *  ESL038 - FT STP Enhancements                                 *
      *                                                               *
      *****************************************************************
     FFTP002DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Charges Detail Record
      *
     FFTPAYY1   IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : STP Charges               Retrieval index
      *
     FFTPAYY0   UF A E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(FTPAYX0F:FTPAYX1F)
     F                                     COMMIT
      * UPD : STP Charges               Update index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
      **  Data Structure for input/output parameters
     D/COPY FTCPYSRC,FT0010D001
      *
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/Time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D @1DBRC        E DS                  EXTNAME(FTPAYY0)
      * UPD : Charges Details           Update index
      * Current/previous master file format fields for change control
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SDLCD        E                     EXTFLD(LCD)
      * Switchable Features Details accessed via Access Program
      *
     D #1DBRCa         DS           634
      * Stored master file format fields
     D  #1DB1                  1    634
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      * Get Rundate - Rundate  *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Bank details Structure *
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *  Currency Details *
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *  Currency Details *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Data Structures used by Access Programs
      *
      /EJECT
      * Parameter declarations
     D P1Parm          DS
     D  P1ACTC                 1      1
      *
     D P2Parm          DS           256
     D  P2PREF                 1     15
      *
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code (FT)'
      * Action Code
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
      *  Work fields
      *
      *  Defined Constants
     D DIGITS          C                   CONST('0123456789')
      *
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PList
     C                   Parm                    P0RTN             7
     C     P1ACTC        Parm                    WP0001            1            Action Code
     C                   Parm                    P2Parm                         KEY: Correspond
      *
      *  Set up primary reference
     C                   MoveL     P2Parm        W0PREF
      *****************************************************************
      * Initialize
     C                   Exsr      ZZINIT
      *
      * Check passed parameters
     C                   Exsr      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DoUEq     'N'
      * Display and process key screen
     C                   Exsr      BADSKY
     C                   End
      * Terminate program
     C                   Exsr      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BegSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   Exsr      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MoveL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MoveL     'Y'           W0TRN             1
      *
     C     W0TRN         DoWEq     'Y'
     C     W0TRN         OrEq      'K'
      * Ensure transaction continues (if reset)
     C                   MoveL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DoWEq     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IfEq      'Y'
     C     #1PREF        IfEq      *BLANK
     C                   MoveL     'N'           W0BYP
     C                   EndIf
     C                   EndIf
      * Bypass key screen
     C     W0BYP         IfNe      'Y'
      * Display key screen
     C                   Exsr      BBEXFM
     C                   EndIf
      * Cancel key screen bypass
     C                   MoveL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              Cas                     ZXEXPG
     C   12              Cas                     ZXEXPG
      * HOME: Reset screen fields
     C   05              Cas                     BDHMKY
      * Process key screen input
     C                   Cas                     BEPRKY
     C                   End
     C     W0TRN         DoWEq     'R'
     C                   MoveL     'Y'           W0TRN
     C                   Exsr      BEPRKY
     C                   EndDo
      *
     C                   EndDo
     C                   EndDo
      *================================================================
     CSR   BAEXIT        EndSR
      /EJECT
     CSR   BBEXFM        BegSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SetOn                                            86    *
     C     *IN89         IfNe      BBIN89
     C                   SetOff                                           86    *
     C                   EndIf
     C                   Move      *IN89         BBIN89            1
      * Update screen Time
     C                   Time                    ##TME
     C                   Write     #MSGCTL
     C                   Write     #CMDTXT1
     C                   Exfmt     #RCDKEY
      * Update job Time
     C                   Time                    ##JTM
      * Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MoveL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   BBEXIT        EndSR
      /EJECT
     CSR   BDHMKY        BegSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MoveL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        EndSR
      /EJECT
     CSR   BEPRKY        BegSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   Exsr      MAIZ#1
      * If E,D ignore key field validation
     C     P1ACTC        IfEq      'D'
     C     P1ACTC        OrEq      'E'
     C                   SetOff                                       99
     C                   Move      '000'         *IN(31)
     C                   Move      *BLANK        W0RTN
     C                   EndIf
     C     *IN99         CabEq     '1'           BEEXIT
      * Check for existing record
     C                   MoveL     #1PREF        X1PREF
     C     KRTV          Chain     FTPAYY1                            9091      *
     C     *IN91         IfEq      '1'
      * Record locked
     C                   SetOn                                        9931      *
     C                   GoTo      BEEXIT
     C                   EndIf                                                  FI 91
      *                                                                         FI 91
      * If record exists, load screen fields from DBF                           FI 91
     C     *IN90         IfEq      '0'                                          FI 91
     C                   Exsr      MBFL#1                                       FI 91
     C                   EndIf                                                  FI 91
      *..................................................
     C   99              GoTo      BEEXIT
      *
      * No error: Display and process details
     C                   Exsr      CADSDA
      *
      *================================================================
     CSR   BEEXIT        EndSR
      /EJECT
     CSR   CADSDA        BegSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DoWEq     'Y'
      * Display detail screen
     C                   Exsr      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   End
      *
     C                   EndDo
      *================================================================
     CSR   CAEXIT        EndSR
      /EJECT
     CSR   CBEXFM        BegSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
     C     W0ROL         DoUEq     'N'
     C                   Move      *ALL'0'       ##OFF            30
     C                   MoveA     ##OFF         *IN(1)
      * Set screen conditioning indicators
     C                   Exsr      GBDSAD
      * Update screen Time
     C                   Time                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SetOn                                            86    *
     C     *IN89         IfNe      CBIN89
     C                   SetOff                                           86    *
     C                   EndIf
     C                   Move      *IN89         CBIN89            1
      * Set error
     C                   Write     #MSGCTL
     C                   Write     #CMDTXT1
     C                   Exfmt     #RCDKEY
      * Reset roll flag
     C                   MoveL     'N'           W0ROL             1
      * Show next page of details
     C   27              Exsr      CDNXSC
      * Show previous page of details
     C   28              Exsr      CEPVSC
     C                   EndDo
      * Update job Time
     C                   Time                    ##JTM
      * Clear messages from program message queue
     C                   Call      'Y2CLMSC'
     C                   Parm      ##PGM         ZAPGMQ           10
     C                   Parm      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MoveL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SetOff                                           99    *
      *================================================================
     CSR   CBEXIT        EndSR
      /EJECT
     CSR   CCDSPV        BegSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
     C   05              MoveL     'R'           W0TRN
      *
      * If insert go to key screen Else exit
      *
     C     *IN12         IfEq      '1'
     C                   Exsr      ZXEXPG
     C                   EndIf
      * Initialise error memories
      *================================================================
     CSR   CCEXIT        EndSR
      /EJECT
     CSR   CDNXSC        BegSR
      *================================================================
      * Display next screen
      *================================================================
      * Set roll flag
     C                   MoveL     'Y'           W0ROL             1
      *================================================================
     CSR   CDEXIT        EndSR
      /EJECT
     CSR   CEPVSC        BegSR
      *================================================================
      * Display previous screen
      *================================================================
      * Set roll flag
     C                   MoveL     'Y'           W0ROL             1
      *================================================================
     CSR   CEEXIT        EndSR
      /EJECT
     CSR   CFPRSC        BegSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MoveL     'N'           W0DCF             1
      * If delete is not pEnding....
     C     P1ACTC        IfEq      'A'
      * Validate details
     C                   SetOff                                       313233
     C                   Exsr      SRSCRN
     C                   EndIf
      * QUIT if error:
     C     *IN99         CabEq     '1'           CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CabEq     'Y'           CFEXIT
      * No error: update record
     C     P1ACTC        IfEq      'A'
     C     P1ACTC        OrEq      'D'
     C     *IN10         ANDEQ     '1'
     C                   Exsr      EBPR##
     C                   EndIf
      *
      * Exit if enquire
     C     P1ACTC        IfEq      'E'
     C                   MoveL     'N'           W0RPT
     C                   MoveL     'N'           W0TRN
     C                   EndIf
      *================================================================
     CSR   CFEXIT        EndSR
      /EJECT
      *================================================================
      *                                                               *
      *  SRSCRN   : Validate Screen                                   *
      *                                                               *
      *================================================================
     CSR   SRSCRN        BegSR
      *
      *  Set up subroutine stack name
      *
     C                   Add       1             Q
     C                   MoveL     'SRSCRN'      @STK(Q)
      *
      * Validate Currency
     C                   If        #1CCCY = *blanks
     C                   SetOn                                        99        *
     C                   MoveL     '1'           *IN31
     C                   MoveL     'FTP0012'     ZAMSID
     C                   MoveL     'FTUSRMSG'    ZAMSGF
     C                   MoveL     #1CCCY        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
 
     C     '?'           Scan      #1CCCY                                 99
     C                   Call      'AOCURRR0'                           9090
     C                   Parm      *BLANKS       P@RTCD            7            B:Return code
     C                   Parm      '*KEY   '     P@OPTN            7            I:Option
     C                   Parm      #1CCCY        P@CCY             3            I:Currency
     C     SDCURR        Parm      *BLANKS       DSSDY
 
     C                   If        P@RTCD <> *blanks
     C                   SetOn                                        99        *
     C                   MoveL     '1'           *IN31
     C                   MoveL     'FTP0007'     ZAMSID
     C                   MoveL     'FTUSRMSG'    ZAMSGF
     C                   MoveL     #1CCCY        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
     C                   Move      A6CYCD        #1CCCY                         I:Currency
     C                   EndIf
     C                   EndIf
      *
      * Validate Amount
     C                   Z-add     0             @@AMT
     C                   If        #1AMNT = *blanks
     C                   SetOn                                        99        *
     C                   MoveL     '1'           *IN32
     C                   MoveL     'FTP0013'     ZAMSID
     C                   MoveL     'FTUSRMSG'    ZAMSGF
     C                   MoveL     #1AMNT        ZAMSDA
     C                   Exsr      ZASNMS
     C                   Else
     C                   Z-Add     A6NBDP        @@IDP
     C     13            Sub       A6NBDP        @@IINT
     C                   Move      *BLANKS       @@ALPH
     C                   Move      #1AMNT        @@ALPH
     C                   Move      'Y'           @@MTID
      *
     C                   CallB     'ZA0840'
     C                   Parm      *BLANK        RetCodeOut        1
     C                   Parm                    @@ALPH           16
     C                   Parm                    @@IDP             3 0
     C                   Parm                    @@IINT            3 0
     C                   Parm                    @@MTID            1
     C                   Parm      *ZERO         @@ERCD            1 0
     C                   Parm      *ZERO         @@AMT            15 0
     C                   Parm                    BNDCSP
      *
     C                   SetOff                                       4546
     C                   If        A6NBDP = 0
     C     '.'           Scan      #1AMNT                                 45
     C     ','           Scan      #1AMNT                                 46
     C                   EndIf
     C     @@ERCD        IfNe      0
     C     *IN45         OrEq      '1'
     C     *IN46         OrEq      '1'
     C                   SetOn                                        99        *
     C                   MoveL     '1'           *IN32
     C                   MoveL     'FTP0014'     ZAMSID
     C                   MoveL     'FTUSRMSG'    ZAMSGF
     C                   MoveL     #1AMNT        ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
      *
     C                   Endif
      *
      * Validate Reasons for Change
     C                   If        #1REA1 = *Blanks and #1REA2 = *Blanks and
     C                             #1REA3 = *Blanks and #1REA4 = *Blanks and
     C                             #1REA5 = *Blanks
     C                   SetOn                                        99        *
     C                   MoveL     '1'           *IN33
     C                   MoveL     'FTP0015'     ZAMSID
     C                   MoveL     'FTUSRMSG'    ZAMSGF
     C                   MoveL     #1REA1        ZAMSDA
     C                   Exsr      ZASNMS
     C                   EndIf
      *
     C                   MoveA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 EndSR
      *================================================================
     C/EJECT
     CSR   EBPR##        BegSR
      *================================================================
      * Process record:
      *================================================================
      *
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process update request
     C                   CAS                     EECHRQ
     C                   End
     C     W0RTN         IfNe      *BLANK
      * Error: ROLLBACK any DBF changes
     C                   RolBk
     C                   GoTo      EBEXIT
     C                   Else
      * Otherwise COMMIT any DBF changes
     C                   Commit
     C                   EndIf
     C     W0RTN         IfEq      *BLANK
     C                   MoveL     'N'           W0TRN
     C                   EndIf
      *================================================================
     CSR   EBEXIT        EndSR
      /EJECT
     CSR   EDDLRQ        BegSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Correspondent - Correspondent Details  * 
     C                   Exsr      SCCHRC
 
     C     W0RTN         IfEq      *BLANK
      * SEnd message '*Record deleted'
     C                   MoveL     'FTP0011'     ZAMSID
     C                   MoveL     'FTUSRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   EndIf
      *================================================================
     CSR   EDEXIT        EndSR
      /EJECT
     CSR   EECHRQ        BegSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Correspondent - Correspondent Details  * 
     C                   Exsr      SDCHRC
     C     W0RTN         IfNe      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   End
     C                   Else
      * SEnd message '*Record changed'
     C                   MoveL     'Y2U0012'     ZAMSID
     C                   MoveL     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   EndIf
      *================================================================
     CSR   EEEXIT        EndSR
      /EJECT
     CSR   FACKPM        BegSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P2PREF        IfEq      *BLANK
      * Not every key field passed - loop program
     C                   MoveL     'Y'           W0RPT             1
     C                   Else
      * Full key passed, so single shot program
     C                   MoveL     'N'           W0RPT
     C                   EndIf
      *================================================================
     CSR   FAEXIT        EndSR
      /EJECT
     CSR   GBDSAD        BegSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
      * Protect key fields on detail screen
     C                   SetOn                                        88        *
     C                   MoveL     '0'           *IN79
     C                   MoveL     '0'           *IN79
     C     P1ACTC        IfEq      'E'                                          *IF
     C     P1ACTC        OrEq      'D'                                          *IF
     C                   MoveL     '1'           *IN79
     C                   EndIf                                                  *FI
      * Enable key screen
     C                   SetOn                                        87        *
      *================================================================
     CSR   GBEXIT        EndSR
      /EJECT
     CSR   MAIZ#1        BegSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
      *
      *
      * Fill Command lines and narrative text from messages
     C                   SELECT
      *
      * Enquiry screen
     C     P1ACTC        WhenEQ    'E'
      *
      * Option Name
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0001'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##ONKY
      *
      * Function keys
      *
     C                   MoveL     'FTP0003'     ##PG1
      *
      * AmEndment screen
     C     P1ACTC        WhenEQ    'A'
      *
      * Option Name
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0004'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##ONKY
      *
      * Function keys
     C                   MoveL     'FTP0003'     ##PG1
      *
      * Delete screen
     C     P1ACTC        WhenEQ    'D'
      *
      * Option Name
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0004'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##ONKY
      *
      * Function keys and allow delete key
     C                   MoveL     'FTP0016'     ##PG1
     C                   MoveL     '1'           *IN77
      *
     C                   EndSL
      *
      * Function keys
     C     *LIKE         Define    #MSGID        ##PG1
      *
     C                   Call      'MEC1150'                            9090
     C                   Parm      ##PG1         #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        #KCMD2
      *
      *================================================================
     CSR   MAEXIT        EndSR
      /EJECT
     CSR   MBFL#1        BegSR
      *================================================================
      * Move FTPAYY1 fields to screen
      *================================================================
     C                   Eval      #1PREF  = X1PREF
     C                   Eval      #1F20R  = X1F20R
     C                   Eval      #1CCCY  = X1CCCY
     C                   Eval      #1M19R  = X1M19R
     C                   Eval      #1REA1  = X1REA1
     C                   Eval      #1REA2  = X1REA2
     C                   Eval      #1REA3  = X1REA3
     C                   Eval      #1REA4  = X1REA4
     C                   Eval      #1REA5  = X1REA5
     C                   Eval      #1REA6  = X1REA6
      *
      * Format sent date
     C                   Z-Add     X1DATS        W2DAYN                         Day No.
     C                   Call      'ZDATE2'                             90
     C                   Parm                    W2DAYN            5 0          Day No.
     C                   Parm      WUDFF         W2DTFM            1            Date Format
     C                   Parm      *ZEROS        W2DATE            6 0          Date
     C                   Parm      *BLANKS       W2FDAT            7            DDMMMYY
     C                   MoveL     W2FDAT        #1DATS
      *
      * Get currency details
     C                   Call      'AOCURRR0'                           9090
     C                   Parm      *BLANKS       P@RTCD                         B:Return code
     C                   Parm      '*KEY   '     P@OPTN                         I:Option
     C                   Parm      #1CCCY        P@CCY                          I:Currency
     C     SDCURR        Parm      *BLANKS       DSSDY
      *
      * Get Amount details
     C                   Move      X1AMNT        PFMTIN                         I:numeric field
     C                   CallB     'ZA0920'                             90
     C                   Parm      *Blanks       PRETC            10
     C                   Parm                    PFMTIN           13 0
     C                   Parm      A6NBDP        PFMDEC            1 0
     C                   Parm                    BNDCSP                         I:numeric field
     C                   Parm      *Blanks       PFMTOUT          14            I:No of decimals
     C                   Move      *Blanks       #1AMNT                         I:Edit Code
     C                   Move      PFMTOUT       #1AMNT                         I:Edit Code
      *
      * Hold existing record image
     C                   MOVEL     @1DBRC        #1DBRCa
      *
      * Delete screen
     C     P1ACTC        IfEq      'D'
     C                   MoveL     '1'           *IN77
     C                   End
      *================================================================
     CSR   MBEXIT        EndSR
      /EJECT
     CSR   MDIZ#K        BegSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MoveL     P1ACTC        #PACTC                         Action Code
     C                   MoveL     P2PREF        #1PREF
      *
      * Option Name
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0004'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        ##ONKY
      *
      * Action codes
     C                   MoveL     *BLANKS       #KCMD1
      *
      * Function keys
     C                   Call      'MEC1150'                            9090
     C                   Parm      'FTP0003'     #MSGID
     C                   Parm      'FTUSRMSG'    #MSGF
     C                   Parm                    #MSDTA
     C                   Parm      *BLANKS       #MSTX1
     C                   Parm      *BLANKS       #MSTX2
      *
     C                   MoveL     #MSTX1        #KCMD2
      * USER: Initialize key screen
      *================================================================
     CSR   MDEXIT        EndSR
      /EJECT
     CSR   SCCHRC        BegSR
      *================================================================
      * Delete Correspondent - Correspondent Details  * 
      *================================================================
     C                   MoveL     *BLANK        W0RTN             7
      * Move key fields to FTPAYX0F
     C                   MoveL     #1PREF        X1PREF
      *
     C     KLCHSC        KList
     C                   KFld                    X1PREF
     C     KLCHSC        Chain     FTPAYY0                            9091      *
      *
     C     *IN90         IfEq      '1'
      * Record not found
     C                   MoveL     'Y2U0009'     W0RTN             7
      * SEnd message '*Record no longer on file'
     C                   MoveL     'Y2U0009'     ZAMSID
     C                   MoveL     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   GoTo      SCEXIT
     C                   End
      *
     C     *IN91         IfEq      '1'
      * Record locked
     C                   MoveL     'Y2U0004'     W0RTN             7
     C                   GoTo      SCEXIT
     C                   End
      *
      * Check for changed record
     C     #1DBRCa       IfNe      @1DBRC                                       IF
     C                   MoveL     'Y2U0007'     W0RTN             7
      * SEnd message '*Update not accepted'
     C                   MoveL     'Y2U0007'     ZAMSID
     C                   MoveL     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSC        SETLL     FTPAYX0F                           9091      *
     C                   GoTo      SCEXIT
     C                   End                                                    FI #1DBRC
      *
     C                   Move      '*'           X1RECI
     C                   UPDATE    FTPAYX1F                             91      *
      *
     C     *IN91         IfEq      '1'
      * Change error detected
     C                   MoveL     'Y2U0004'     W0RTN             7
     C                   Else
      *
      * Update saved record image
     C                   MoveL     @1DBRC        #1DBRCa
      * DBF change successful
     C                   End
      *================================================================
     CSR   SCEXIT        EndSR
      /EJECT
     CSR   SDCHRC        BegSR
      *================================================================
      * Change Correspondent - Correspondent Details  * 
      *================================================================
     C                   MoveL     *BLANK        W0RTN             7
      * Move key fields to FTPAYX0F
     C                   MoveL     #1PREF        X1PREF
      *
     C     KLCHSD        KList
     C                   KFld                    X1PREF
     C     KLCHSD        Chain     FTPAYY0                            9091      *
      *
     C     *IN90         IfEq      '1'
      * Record not found
     C                   MoveL     'Y2U0009'     W0RTN             7
      * SEnd message '*Record no longer on file'
     C                   MoveL     'Y2U0009'     ZAMSID
     C                   MoveL     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
     C                   GoTo      SDEXIT
     C                   End
      *
     C     *IN91         IfEq      '1'
      * Record locked
     C                   MoveL     'Y2U0004'     W0RTN             7
     C                   GoTo      SDEXIT
     C                   End
      *
      * Check for changed record
     C     #1DBRCa       IfNe      @1DBRC                                       IF
     C                   MoveL     'Y2U0007'     W0RTN             7
      * SEnd message '*Update not accepted'
     C                   MoveL     'Y2U0007'     ZAMSID
     C                   MoveL     'Y2USRMSG'    ZAMSGF
     C                   Exsr      ZASNMS
      * Use SETLL to release record lock
     C     KLCHSD        SETLL     FTPAYX0F                           9091      *
     C                   GoTo      SDEXIT
     C                   End                                                    FI #1DBRC
      * Move non-key fields to FTPAYX0F
     C                   Eval      X1CCCY  = #1CCCY
     C                   Z-add     @@AMT         X1AMNT
     C                   Eval      X1REA1  = #1REA1
     C                   Eval      X1REA2  = #1REA2
     C                   Eval      X1REA3  = #1REA3
     C                   Eval      X1REA4  = #1REA4
     C                   Eval      X1REA5  = #1REA5
     C                   Eval      X1REA6  = #1REA6
      *
     C                   UPDATE    FTPAYX1F                             91      *
      *
     C     *IN91         IfEq      '1'
      * Change error detected
     C                   MoveL     'Y2U0004'     W0RTN             7
     C                   Else
      *
      * Update saved record image
     C                   MoveL     @1DBRC        #1DBRCa
      * DBF change successful
     C                   End
      *================================================================
     CSR   SDEXIT        EndSR
      /EJECT
     CSR   ZASNMS        BegSR
      *================================================================
      * SEnd message to program's message queue
      *================================================================
     C     ZAPGMQ        IfEq      *BLANK
     C                   MoveL     ##PGM         ZAPGMQ
     C                   End
      * If no message file specified, use default
     C     ZAMSGF        IfEq      *BLANK
     C                   MoveL     ZADFMF        ZAMSGF
     C                   End
     C                   Call      'Y2SNMGC'
     C                   Parm                    ZAPGMQ           10            Program queue
     C                   Parm                    ZAPGRL            5            Rel queue
     C                   Parm                    ZAMSID            7            Message ID
     C                   Parm                    ZAMSGF           10            Message file
     C                   Parm                    ZAMSDA          132            Message data
     C                   Parm                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next Time
     C                   MoveL     *BLANK        ZAPGMQ
     C                   MoveL     *BLANK        ZAPGRL
     C                   MoveL     *BLANK        ZAMSID
     C                   MoveL     *BLANK        ZAMSGF
     C                   MoveL     *BLANK        ZAMSDA
     C                   MoveL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        EndSR
      /EJECT
     CSR   ZXEXPG        BegSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
     C                   MoveL     *BLANK        P0RTN
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IfEq      '1'                                          *IF
     C                   MoveL     'Y2U9999'     P0RTN                          *Return code
     C                   End                                                    *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IfEq      '1'                                          *IF
     C                   MoveL     'USR0790'     P0RTN                          *Return code
     C                   End                                                    *FI
      *
      * USER: Exit program processing
     C                   Exsr      ZYEXPG
      *================================================================
     CSR   ZXEXIT        EndSR
      /EJECT
     CSR   ZYEXPG        BegSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C                   ROLBK                                          90
      *
      * Copy any undisplayed messages back to Caller
     C                   Call      'Y2CPMSC'
     C                   Parm                    ##PGM
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        EndSR
      /EJECT
     CSR   ZZINIT        BegSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IfEq      *BLANK
     C                   MoveL     'Y'           W0ICL             1            *Initial Call
     C                   Else
     C                   MoveL     'N'           W0ICL
     C                   End
     C                   Move      *BLANK        P0RTN
     C                   Move      *BLANK        W0RTN             7
     C                   MoveL     *BLANK        W0RSL             1
     C                   MoveL     *BLANK        W0RSF             1
      * Initialise indicators for re-entry
     C                   Move      '0'           *IN
      * Setup job date/Time
      *
     C                   Z-Add     UDATE         ##JDT
     C                   Time                    ##JTM
      * Update screen Time
     C                   Time                    ##TME             6 0
      * Obtain default message file
     C                   MoveL     'FTUSRMSG'    ZADFMF           10
      * Define work field Midas run date
     C                   MoveL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-Add     *ZERO         WURDNB            5 0
     C                   MoveL     '0'           *IN77
     C                   MoveL     '0'           *IN75
     C                   MoveL     *BLANKS       BBIN89
     C                   MoveL     *BLANKS       CBIN89
      * Open files first Time only
     C     W0OPN         IfEq      *BLANK
      * Begin commit control
     C                   Call      'Y2BGCMC'
     C                   Parm                    W0RTN             7
     C     W0RTN         IfNe      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   Exsr      ZYEXPG
     C                   End
     C                   Open      FTPAYY0
      * Signal that files are now Open
     C                   Move      'Y'           W0OPN             1
     C                   End
     C                   MoveL     'N'           W0PMT             1
      * USER: Initialize program
      * Retrieve Midas Date - R10 Standard Functions  * 
      *
      *  Set up copyright parameter
     C                   MoveA     CPY@          ACT@             80
      *
      *  Extract bank details
     C                   Call      'AOBANKR0'                           9090
     C                   Parm      *BLANKS       P@RTCD            7            B:Return code
     C                   Parm      '*FIRST '     P@OPTN            7            I:Option
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C                   CallB     'AODEALR0'
     C                   Parm      '*DBERR '     @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDDEAL        Parm      SDDEAL        DSFDY
      *
      *  If return with an error (LR SetOn in Called program) then
      *  process for database error.
     C     *IN90         IfEq      '1'
     C     P@RTCD        OrEq      '*ERROR*'
     C                   MoveL     'AOBANKR0'    W0FILE
     C                   MoveL     '*Call'       W0KEY                          ***************
     C                   Z-Add     3             W0ERNB                         * DB ERROR 30 *
     C                   MoveL     'MEM5003'     W0MSGD                         ***************
     C                   MoveL     'MIDAS  '     W0MSGF
     C                   Exsr      SRERR
     C                   End
      *
      * Get Rundate - Rundate  *
     C     *DTAARA       Define    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   Move      AGMRDT        ##MRDT            7            Midas Run date
     C                   Move      AGMRDT        WUMRDT            7            Midas Run date
     C                   Move      AGRDNB        WURDNB            5 0          Run day number
     C                   Move      AGSUC         WUSUC             1            Set up complete
     C                   Move      AGDFF         WUDFF             1            Date Format
     C                   Move      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Set up Key List
     C     KRTV          KList
     C                   KFld                    X1PREF
                                                                                              E00009
      *================================================================
     CSR   ZZEXIT        EndSR
      *================================================================
     C/EJECT
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
