     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTPCATW0 - Incoming/Outgoing Payments PCAT Definition        *
      *                                                               *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems Ltd 2004   *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 13Sep11               *
      *  Last Amend No. ESL038             Date 25Nov04               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 Upgrade STP enhancement to Midas Plus level.        *
      *  ESL038 - Funds Transfer STP Enhancements                     *
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
     FFTPCATDF  CF   E             WORKSTN
      ** Display file for MT900 Outgoing Payments Window
      *
     FFTPCATJ0  IF   E           K DISK
      ** PCAT by IBAN
      *
     FFTPCATJ1  IF   E           K DISK
      ** PCAT by Retail Number
      *
     FFTSEGXV0  IF   E           K DISK
      ** Segment customer group x-ref
      *
     FFTFXGPV1  IF   E           K DISK
      ** FX Spread groups by customer group
      *
     FMEINMPL1  IF   E           K DISK
      *
      *  Message parts file for currency of payment and amount
      *
     FSDCMRKL0  IF   E           K DISK                                                       STP001
      *                                                                                       STP001
      *  Midas Customer Marketing Info                                                        STP001
      *                                                                                       STP001
      *****************************************************************
      *
      ** Array containing Copyright statement
      *
      *****************************************************************
      *
     D FTPCAT        E DS                  EXTNAME(FT@PCATPP)
      * Data structure to hold incoming parameter transaction details
     D                 DS
      * Data structure to hold beneficiary details
     D  I@CUS                  1    175
     D  ##CUS1                 1     35
     D  ##CUS2                36     70
     D  ##CUS3                71    105
     D  ##CUS4               106    140
     D  ##CUS5               141    175
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
     D                                     PREFIX(F_)
      * External Data Structure for Swtichable features description
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D FTPEXT        E DS                  EXTNAME(FTPEXTP0)
      *
     D ##NoError       S              1A   INZ(' ')
     D SVFXSP          S                   LIKE(GPFXS1)
     D SVPCAT          S                   LIKE(SPCAT )
     D SVPCIB          S                   LIKE(SPCIB )
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
     D R#REF           DS            15
      *
     D  R#TXT                  1      5    INZ('MSGRF')
     D  R#MSGR                 6     12  0
     D  R#KPRT                13     15  0
     D
      * Define passed paramters to FTP880
     D O2parm          DS            68
     D  O2Iban                 1     34
     D  O2rnbr                35     68
     D  O2rnb1                35     50
     D  O2rnb2                51     68

      * Parameters for ZALIGN/ZEDIT

     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZALIGNOK        S              1
     D ZADIG           S              2  0
     D ZAFLD           S             16
      * Compare message reference
     D  C#MSGR         S                   LIKE(R#MSGR)
     D  P#COMI         S                   LIKE(PCCOMI)
     D  P#COMA         S                   LIKE(PCCOMA)
     D  P#FXRI         S                   LIKE(PCFXRI)
     D  P#FXLA         S                   LIKE(PCFXLA)
     D  P#IDOC         S                   LIKE(PCIDOC)
     D  P#ICUT         S                   LIKE(PCICUT)
     D  P#IFXS         S                   LIKE(PCIFXS)
     D  PCODOC         S                   LIKE(PCIDOC)
      *
     D D@ACCT        E DS                  EXTNAME(ACCNTAB)
      * ACCNTABF - Account details record format data structure
      *
      *****************************************************************
     C/EJECT
      *
      **   Standard parameter list for window manager
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1
     C                   PARM                    FTPCAT
     C                   PARM                    RTNCDE            7
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
      ** Check if PCAT details are to be displayed or not
     C     ACTN          Ifne      'E'
     C                   Exsr      Sr_DspPCAT
     C                   Endif
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
      **   Save screen iban and account
      *
     C                   Eval      SVPCIB = SPCIB
     C                   Eval      SVPCAT = SPCAT
      *
      ** Main format of the display file
     C                   EXFMT     FTPCATD1
     C                   EXSR      CLEAR
      *
     C                   MOVEL(P)  SPCIB         I@IBAN
     ****                CALL      'MEP0040A'
     ****  R@IBAN        PARM                    I@IBAN
     ****                PARM      *BLANKS       P@RET             6
      *
     ****                If        P@RET = '*FOUND'
     ****                Movel(p)  R@IBAN        SPCIB
     ****                Endif
      *
     C     *IN03         CASEQ     '1'           EXIT
     C     *IN05         CASEQ     '1'           RESET
     C     *IN12         CASEQ     '1'           PREV
     C     *IN16         CASEQ     '1'           PCAT
     C                   CAS                     VALID
     C                   ENDCS
      *
      **   If not enquire and saved versions changed then redisplay
      *
     C                   If        (SVPCIB <> SPCIB or SVPCAT <> SPCAT) and
     C                             (ACTN <> 'E')
     C                   Eval      SVPCIB = SPCIB
     C                   Eval      SVPCAT = SPCAT
     C                   Exsr      Refresh
     C                   Eval      ##NoError = 'Y'
     C                   Endif
      *
     C                   ENDDO
      *
      **   Exit from program
      *
     C                   EXSR      END
      /EJECT
      *****************************************************************
      * Sr_DspPCAT -  Determine if PCAT Details are to be Displayed
      *****************************************************************
     C     Sr_DspPCAT    BEGSR
      *
      **  Initialise PCAT display indicator
     C                   Move      I@DSPY        SDSPY
      *
      ** Continue to redisplay until no errors
     C     ##NoError     DOUEQ     *blanks
      *
      **   If error write messages
     C                   If        ##NoError <> *blanks
     C                   Write     #MSGCTL
     C                   Endif
      *
      ** Main format of the display file
     C                   Exfmt     FTPCATD0
      *
      ** Clear messages
     C                   Exsr      CLEAR
      *
      ** F3 entered exit program
     C     *IN03         Ifeq      *ON
     C                   Exsr      EXIT
     C                   Endif
      *
      **  Validate display indicator
     C                   Move      *Off          *In55
     C                   Eval      ##NoError = ' '
     C                   If        SDSPY <> 'N' and SDSPY <> 'Y'
     C                   Move      *On           *In55
     C                   Move      'STP0106'     ZAMSID
     C                   Exsr      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
      *
      ** Check if details have been amended from PCAT to no PCAT
     C     SDSPY         Ifeq      'N'
      *
      **  Reinitialise all fields to blanks/zeros
     C                   Clear                   FTPEXT
     C                   Movel     'N'           PXPCAT
     C                   Movel     I@PREF        PXPREF
      *
      *  Store new details for update
     C                   Call      'FTP960'
     C                   Parm      'STORE  '     P@RTN             7
     C                   Parm                    FTPEXT
      *
     C                   Endif
      *
      ** If N entered then terminate program
     C     SDSPY         Ifeq      'N'
     C                   Move      *On           *InLR
     C                   Return
     C                   Endif
      *
     C                   Enddo
      *
      **  Initialise PCAT display parameter for return to calling program
     C                   Move      SDSPY         I@DSPY
      *
     C                   ENDSR
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
      * Refresh data after change
      *****************************************************************
     C     Refresh       BEGSR

     C                   Eval      PCIBAN = SPCIB
     C                   Eval      PCRNB1 = SPCAT
     C                   Move      SPCAT         PCRNB2
      *
     C                   CALL      'AOIBANR4'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    PCIBAN
     C     D@ACCT        PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
      *
      * Get PCAT data
     C     KPCIban       Chain     @PCATJ0
     C                   If        Not %Found
     C     KPCRnbr       Chain     @PCATJ1
     C                   Endif
     C                   If        %Found
     C                   If        PCIBAN <> *blanks
     C                   Clear                   SPCAT
     C                   Else
     C                   Clear                   SPCIB
     C                   Endif
      *
      **  Set up work fields according to Incoming or Outgoing Payment
     C     I@PTYP        Ifeq      'IN'
     C                   Movel     PCCOMI        P#COMI
     C                   Movel     PCCOMA        P#COMA
     C                   Movel     PCFXRI        P#FXRI
     C                   Movel     PCFXLA        P#FXLA
     C                   Movel     PCIDOC        P#IDOC
     C                   Movel     PCICUT        P#ICUT
     C                   Movel     PCIFXS        P#IFXS
     C                   Else
     C                   Movel     PCOCMI        P#COMI
     C                   Movel     PCOCMA        P#COMA
     C                   Movel     PCOXRI        P#FXRI
     C                   Movel     PCOXLA        P#FXLA
     C                   Movel     PCODOC        P#IDOC
     C                   Movel     PCOCUT        P#ICUT
     C                   Movel     PCOFXS        P#IFXS
     C                   Endif
      *
     C                   Eval      SCUS1  = PCBEN1
     C                   Eval      SCUS2  = PCBEN2
     C                   Eval      SCUS3  = PCBEN3
     C                   Eval      SBSEG  = PCBSEG
     C                   Eval      SBCCY  = PCBCCY
     C                   Eval      SCOMI  = P#COMI
     C                   Eval      SPENR  = PCPENR
     C                   Eval      SFXRI  = P#FXRI
     C                   Eval      SRIND  = PCRIND
     C                   Eval      SBTYP  = PCBTYP
     C                   Eval      SSPRT  = PCSPRT
     C                   Eval      SIMCY  = PCIMCY

      * Set status
     C                   Select
     C                   When      PCAsts = 'I'
     C                   Eval      SASTD = 'Investigate'
     C                   When      PCAsts = 'C'
     C                   Eval      SASTD = 'Closed'
     C                   When      PCAsts = 'E'
     C                   Eval      SASTD = 'Data Error'
     C                   Other
     C                   Eval      SASTD = *blanks
     C                   Endsl

     C                   Exsr      Setnarrative
     C                   Endif
     C                   Endif
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Set screen narratives for commissions and FX Rates
      *****************************************************************
     C     SetNarrative  BEGSR

     C                   Select
     C                   When      P#COMI = 'I'
     C                   Eval      SCOMN = 'Individual'
     C                   When      P#COMI = 'N'
     C                   Eval      SCOMN = 'No Charge '
     C                   Other
     C                   Eval      SCOMI = 'S'
     C                   Eval      SCOMN = 'Standard  '
     C                   Endsl

     C                   Select
     C                   When      P#FXRI = 'I'
     C                   Eval      SFXRN = 'Dealer    '
     C                   When      P#FXRI = 'L'
     C                   Eval      SFXRN = 'On Limit  '
     C                   Other
     C                   Eval      SFXRI = 'T'
     C                   Eval      SFXRN = 'Standard  '
     C                   Endsl
      *
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
      ** Only display the window if SAR ESL038 is active.
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'ESL038'      @SARD             6
     C     SCSARD        PARM      *BLANKS       DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   EXSR      END
     C                   ENDIF
      *
      ** Only do first time through
     C     *IN01         IFEQ      '0'
      *
      ** Define the LDA for error handling
     C     *DTAARA       DEFINE                  LDA
     C     *LIKE         DEFINE    PCIBAN        I@IBAN
     C     *LIKE         DEFINE    PCIBAN        R@IBAN
      *
     C                   Eval      I@NSRC = *blanks
      *
      ** Set up customer field I@CUST
     C                   Movel     I@CUS1        ##CUS1
     C                   Movel     I@CUS2        ##CUS2
     C                   Movel     I@CUS3        ##CUS3
     C                   Movel     I@CUS4        ##CUS4
     C                   Movel     I@CUS5        ##CUS5
      *
      *** Set up action if the window is called from a Repair function
     C                   SELECT
     C                   WHEN      ACTN   = 'U'
     C                   EVAL      ACTN   = 'A'
     C                   WHEN      ACTN   = 'N'
     C                   EVAL      ACTN   = 'E'
     C                   WHEN      ACTN   = 'Q'
     C                   EVAL      ACTN   = 'D'
     C                   ENDSL
      *
      * If payment reference then compare message reference and update data
     C                   If        I@Pref <> *blanks and ACTN <> 'I' and
     C                             I@PCAT <> 'N'
      * Get data if amend mode
     C                   If        ACTN =  'A' and I@PREF <> *blanks
     C                   Call      'FTP960'
     C                   Parm      *blanks       P@RTN             7
     C                   Parm                    FTPEXT
     C                   Endif
      * If reference is not the same then get data
     C                   If        I@Pref <> PXPREF
     C                   Clear                   FTPEXT
     C                   Eval      PXPREF = I@Pref
     C                   Call      'FTP960'
     C                   Parm      'RTV    '     P@RTN             7
     C                   Parm                    FTPEXT
      *
      **  Set PCAT display inidcator flag to file value
     C                   Movel     PXPCAT        I@DSPY
     C                   Movel     PXPCAT        I@PCAT
      *
     C                   Endif
     C                   Endif

      * If payment reference then compare message reference and update data

     C                   If        I@Pref <> *blanks
     C                   Call      'FTP960'
     C                   Parm      *blanks       P@RTN             7
     C                   Parm                    FTPEXT
     C                   If        %subst(PXPREF:1:5) = 'MSGRF'
     C                             or PXPREF = I@PREF
     C                   Eval      R#REF = PXPREF
     C                   Eval      C#MSGR = I@MSGR
     C                   If        (R#TXT = 'MSGRF' and R#MSGR = C#MSGR
     C                             and R#KPRT = I@KPRT)
     C                             or PXPREF = I@PREF
     C                   Eval      SPCIB = PXIBAN
     C     PXRNB2        Cat(p)    PXRNB1:0      SPCAT
     C                   Eval      SPENF = PXPENF
     C                   Eval      STTYP = PXTTYP
     C                   Eval      PCIBAN = SPCIB
      *
     C                   CALL      'AOIBANR4'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    PCIBAN
     C     D@ACCT        PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
      *

      * Get PCAT data
     C     KPCIban       Chain     @PCATJ0
     C                   If        Not %Found
     C     KPCRnbr       Chain     @PCATJ1
     C                   Endif
     C                   If        %Found
     C                   If        PCIBAN <> *blanks
     C                   Clear                   SPCAT
     C                   Else
     C                   Clear                   SPCIB
     C                   Endif
      *
      **  Set up work fields according to Incoming or Outgoing Payment
     C     I@PTYP        Ifeq      'IN'
     C                   Movel     PCCOMI        P#COMI
     C                   Movel     PCCOMA        P#COMA
     C                   Movel     PCFXRI        P#FXRI
     C                   Movel     PCFXLA        P#FXLA
     C                   Movel     PCIDOC        P#IDOC
     C                   Movel     PCICUT        P#ICUT
     C                   Movel     PCIFXS        P#IFXS
     C                   Else
     C                   Movel     PCOCMI        P#COMI
     C                   Movel     PCOCMA        P#COMA
     C                   Movel     PCOXRI        P#FXRI
     C                   Movel     PCOXLA        P#FXLA
     C                   Movel     PCODOC        P#IDOC
     C                   Movel     PCOCUT        P#ICUT
     C                   Movel     PCOFXS        P#IFXS
     C                   Endif
      *
     C                   Eval      SCUS1  = PCBEN1
     C                   Eval      SCUS2  = PCBEN2
     C                   Eval      SCUS3  = PCBEN3
     C                   Eval      SBSEG  = PCBSEG
     C                   Eval      SBCCY  = PCBCCY
     C                   Eval      SCOMI  = P#COMI
     C                   Eval      SPENR  = PCPENR
     C                   Eval      SFXRI  = P#FXRI
     C                   Eval      SRIND  = PCRIND
     C                   Eval      SBTYP  = PCBTYP
     C                   Eval      SSPRT  = PCSPRT
     C                   Eval      SIMCY  = PCIMCY

      * Set status
     C                   Select
     C                   When      PCAsts = 'I'
     C                   Eval      SASTD = 'Investigate'
     C                   When      PCAsts = 'C'
     C                   Eval      SASTD = 'Closed'
     C                   When      PCAsts = 'E'
     C                   Eval      SASTD = 'Data Error'
     C                   Other
     C                   Eval      SASTD = *blanks
     C                   Endsl

     C                   Exsr      Setnarrative
     C                   Endif
     C                   Endif

     C                   Endif
     C                   Endif
     C                   Endif

      *
     C                   If        PXRNB1 = *blanks and PXIBAN = *blanks
     C     35            Subst(p)  I@CUS:1       SPCIB
      * If /PL then remove /
     C                   If        %SubSt(SPcib:1:3) = '/PL'
     C     34            Subst(p)  I@CUS:2       SPCIB
     C                   Endif
      * Don't fill account
     C**** 35            Subst(p)  I@CUS:1       SPCAT
     C     35            Subst(p)  I@CUS:1       SCUS1
     C     35            Subst(p)  I@CUS:36      SCUS2
     C     35            Subst(p)  I@CUS:71      SCUS3
     C     35            Subst(p)  I@CUS:106     SCUS4
     C     35            Subst(p)  I@CUS:141     SCUS5
     C                   Endif
      * If Add/deduct and no 71F then from this indicator
     C                   IF        I@F71A = *blanks and I@ADDC = 'A'
     C                   Eval      I@F71A = 'OUR'
     C                   Endif
      *
      ** Protect input fields if enquiry and enable command keys
      *
     C     ACTN          IFEQ      'E'
     C                   SETON                                        20
     C                   ENDIF
      *
     C                   SETON                                        01
     C                   ENDIF
      *
      * Exit if not PCAT
     C                   If        I@PCAT <> 'Y' and I@PREF <> *blanks
     C                             and ACTN = 'E'
     C                   EXSR      END
     C                   Endif
      *
      ** If Delete mode then do not run this window controller
      ** and exit program.
      *
     C     ACTN          IFEQ      'D'
     C                   EXSR      END                                          kw
     C                   ENDIF
      *
      ** If Enquire or Amend mode then retrieve data from the extension
      ** file OTPAYX0.
      *
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'A'
      *
      ** Retrieve MT900 and MT910 from extension file
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *    EXIT FROM PROGRAM IF F12 HAS BEEN PRESSED
      *****************************************************************
     C     PREV          BEGSR
      *
      **  Reinitialise all fields to blanks/zeros
     C                   Clear                   FTPEXT
     C                   Movel     'N'           PXPCAT
     C                   Movel     I@PREF        PXPREF
      *
      *  Store new details for update
     C                   Call      'FTP960'
     C                   Parm      'STORE  '     P@RTN             7
     C                   Parm                    FTPEXT
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
      * PCAT Enquiry
      *****************************************************************
     C     PCAT          BEGSR
      *
      **   Call PCAT Maintenance
     C                   Eval      ActionCode = ACTN
     C                   If        ActionCode = 'I'
     C                   Eval      ActionCode = 'A'
     C                   Endif
     C                   Eval      ActionCode = 'S'
      *
     C                   Eval      O2iban = SPCIB
     C                   Eval      O2rnbr = SPCAT
      *
     C                   CALL      'FTP880'
     C                   PARM                    P0RTN             7
     C                   PARM                    ActionCode        1
     C                   PARM                    O2Parm
      *
      **   Clear the program message queue
      *
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
      *
      **   If data selected then show on screen
      *
     C                   If        P0RTN = 'PTC0020'

     C                   Eval      PCIBAN = O2IBAN
     C                   Eval      PCRNB1 = O2RNB1
     C                   Eval      PCRNB2 = O2RNB2
      * Get PCAT data
     C     KPCIban       Chain     @PCATJ0
     C                   If        Not %Found
     C     KPCRnbr       Chain     @PCATJ1
     C                   Endif
     C                   If        %Found
     C                   If        PCIBAN <> *blanks
     C                   Clear                   SPCAT
     C                   Eval      SPCIB  = O2IBAN
     C                   Else
     C                   Clear                   SPCIB
     C                   Eval      SPCAT  = O2RNB1
     C                   Move      O2RNB2        SPCAT
     C                   Endif
      *
      **  Set up work fields according to Incoming or Outgoing Payment
     C     I@PTYP        Ifeq      'IN'
     C                   Movel     PCCOMI        P#COMI
     C                   Movel     PCCOMA        P#COMA
     C                   Movel     PCFXRI        P#FXRI
     C                   Movel     PCFXLA        P#FXLA
     C                   Movel     PCIDOC        P#IDOC
     C                   Movel     PCICUT        P#ICUT
     C                   Movel     PCIFXS        P#IFXS
     C                   Else
     C                   Movel     PCOCMI        P#COMI
     C                   Movel     PCOCMA        P#COMA
     C                   Movel     PCOXRI        P#FXRI
     C                   Movel     PCOXLA        P#FXLA
     C                   Movel     PCODOC        P#IDOC
     C                   Movel     PCOCUT        P#ICUT
     C                   Movel     PCOFXS        P#IFXS
     C                   Endif
      *
     C                   Eval      SCUS1  = PCBEN1
     C                   Eval      SCUS2  = PCBEN2
     C                   Eval      SCUS3  = PCBEN3
     C                   Eval      SBSEG  = PCBSEG
     C                   Eval      SBCCY  = PCBCCY
     C                   Eval      SCOMI  = P#COMI
     C                   Eval      SPENR  = PCPENR
     C                   Eval      SFXRI  = P#FXRI
     C                   Eval      SRIND  = PCRIND
     C                   Eval      SBTYP  = PCBTYP
     C                   Eval      SSPRT  = PCSPRT
     C                   Eval      SIMCY  = PCIMCY

      * Set status
     C                   Select
     C                   When      PCAsts = 'I'
     C                   Eval      SASTD = 'Investigate'
     C                   When      PCAsts = 'C'
     C                   Eval      SASTD = 'Closed'
     C                   When      PCAsts = 'E'
     C                   Eval      SASTD = 'Data Error'
     C                   Other
     C                   Eval      SASTD = *blanks
     C                   Endsl

     C                   Exsr      Setnarrative
     C                   Endif
     C                   Endif
      *
      **   Reset all error indicators
      *
     C                   SETOFF                                       505152
     C                   Eval      ##NoError = 'Y'
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * UPDATE THE EXTENSION FILE
      *****************************************************************
     C     UPDAT         BEGSR
      * If insert and data changed then redefault via first screen
     C                   If        (ACTN  = 'I' or ACTN = 'A') and
     C                             PXIBAN <> PCIBAN
     C                             or
     C                             (ACTN  = 'I' or ACTN = 'A') and
     C                             PXRNB1 <> PCRNB1 and PXRNB2 <> PCRNB2
     C                             or
     C                             (ACTN  = 'I' or ACTN = 'A') and
     C                             PXPENF <> SPENF
      * Set next screen to P
     C                   Eval      I@NSRC = 'P'
     C                   Endif
      * Set up reference
     C                   If        I@PREF = *blanks
     C                   Clear                   R#REF
      *
     C                   Eval      R#TXT  = 'MSGRF'
     C                   Eval      R#MSGR = I@MSGR
     C                   Eval      R#KPRT = I@KPRT
     C                   Endif
      * Set up stored data
     C                   Clear                   FTPEXT
      *
     C                   If        SPCAT <> *blanks or
     C                             SPCIB <> *blanks
      * Set PCAT found
     C                   Eval      I@PCAT = 'Y'
     C                   Eval      PXPCAT = 'Y'
      *
     C                   If        I@PREF = *blanks
     C                   Eval      PXPREF = R#REF
     C                   Else
     C                   Eval      PXPREF = I@PREF
     C                   Endif
     C                   Eval      PXIBAN = PCIBAN
     C                   Eval      PXRNB1 = PCRNB1
     C                   Eval      PXRNB2 = PCRNB2
     C                   Eval      PXPENF = SPENF
     C                   Eval      PXTTYP = STTYP
      *
      * If currency of transaction different from account update
      *
     C                   If        PCBCCY <> I@MCCY
anne C                             and PCIMCY <> 'Y'
     C                   Eval      I@ACCY = PCBCCY
     C                   Endif
      *
      * Get segment data for customer group
      *
     C     KSegx         KLIST
     C                   Kfld                    SXBSEG
      *
     C                   Select
     C                   When      P#COMI = 'I' and I@F71A <> 'OUR'
     C                   Eval      PXCOMA = P#COMA
     C                   When      P#COMI <> 'I' and P#COMI <> 'N'
     C                   Eval      SXBSEG = PCBSEG
     C     KSegx         Chain     @SEGXV0
     C                   If        Not %Found
     C                   Eval      SXBSEG = 'ALL'
     C     KSegx         Chain     @SEGXV0
     C                   Endif
      * Only set up if charges not OUR
     C                   If        %Found and I@F71A <> 'OUR'
     C                   Eval      PXGPCD = SXGPCD
     C                   Endif
      * If pension payment then no charge
     C                   If        PXPENF <> 'N' and I@F71A <> 'OUR'
     C                   Eval      PXGPCD = '8001'
     C                   Endif
     C                   Endsl
      * get part information
     C     Kinmp         KLIST
     C                   KFLD                    MPMSGR
     C                   KFLD                    MPKPRT
      *
     C                   If        I@MSGR <> 0
     C                   Z-ADD     I@MSGR        MPMSGR
     C                   Z-ADD     I@KPRT        MPKPRT
      * get data
     C     Kinmp         CHAIN     @INMPL1                            90
     C                   Else
     C                   Eval      MPCYCD = I@MCCY
     C                   Endif
      * Fx spread if currencies are different
     C                   If        PCBCCY <> MPCYCD and P#FXRI <> 'I'
      *
      * Convert amount to base currency
      *
      *
      * Manual input
      *
     C                   If        I@MSGR = 0 and I@ECCY <> *blanks
     C                             and I@EAMT <> *blanks
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      I@ECCY        @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Currency found
     C                   If        @RTCD = *blanks

      * Convert screen rate to decimal rate for update

     C                   EVAL      ZFIELD = *BLANKS
     C                   MOVE      I@EAMT        ZFIELD
     C                   EVAL      ZADEC = A6NBDP
     C                   EVAL      ZADIG = 13 - A6NBDP

     C                   CALL      'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAFLD

     C                   If        ZALIGNOK = *blanks
     C                   MOVE      ZFIELD        D#FAMT
     C                   Eval      MPCYCD = I@ECCY
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      * Linked to message
      *
     C                   If        I@MSGR <> 0
     C                   CLEAR                   D#DTA
      *
     C                   MOVEL     MPCYCD        @CCY
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C                   Z-ADD     MPPYAM        D#FAMT
     C     A6NBDP        WHENEQ    1
     C     MPPYAM        MULT      10            D#FAMT
     C     A6NBDP        WHENEQ    2
     C     MPPYAM        MULT      100           D#FAMT
     C     A6NBDP        WHENEQ    3
     C     MPPYAM        MULT      1000          D#FAMT
     C                   ENDSL
     C                   Endif
      *
     C                   MOVEL     MPCYCD        D#FCCY
      ****               MOVEL     BJCYCD        D#TCCY
     C                   MOVEL     'EUR'         D#TCCY
      *
     C                   CALL      'AOCCYCV0'                           9090
     C                   PARM      *BLANKS       O#RTN             7
     C                   PARM      '*F*T*SPT'    W0ACT             8
     C     D#DTA         PARM      D#DTA         O#DTA           256
      *
      ****               MOVEL     BJCYCD        @CCY                           Letter currency
     C                   MOVEL     'EUR'         @CCY                           Letter currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C     *LIKE         DEFINE    D#FAMT        U#FXLA
     C                   Z-ADD     P#FXLA        U#FXLA
     C     A6NBDP        WHENEQ    1
     C     P#FXLA        MULT      10            U#FXLA
     C     A6NBDP        WHENEQ    2
     C     P#FXLA        MULT      100           U#FXLA
     C     A6NBDP        WHENEQ    3
     C     P#FXLA        MULT      1000          U#FXLA
     C                   ENDSL
      *  continue if not limit rate
     C     *IN90         IFEQ      *OFF
     C     O#RTN         ANDEQ     *BLANKS
     C     P#FXRI        ANDNE     'L'
      *  continue if limit rate and amount under limit
     C     *IN90         OREQ      *OFF
     C     O#RTN         ANDEQ     *BLANKS
     C     P#FXRI        ANDEQ     'L'
     C     U#FXLA        ANDGE     D#TAMT
      *
     C     KFxgp         Klist
     C                   KFLD                    GPSNBR
     C                   KFLD                    GPGPCD
     C                   KFLD                    GPSTPR
     C                   KFLD                    GPCYCD
      *
     C                   MOVEL     'ALL'         SXBSEG
     C     KSegx         Chain     @SEGXV0
      *
      * Get customer group information
      *
     C                   Move      *Zeros        W@CNUM            6
     C                   Move      CNUM          W@CNUM
     C     W@CNUM        CHAIN     SDCMRKL0
     C                   If        %Found
     C                   Move      D7GPC1        SXGPCD
     C                   Else
     C                   Move      '*ALL'        SXGPCD
     C                   Endif
     C
      *
     C                   MOVEL     '1'           GPSNBR
     C                   MOVEL     SXGPCD        GPGPCD
     C                   MOVEL     'M'           GPSTPR
     C                   MOVEL     I@MCCY        GPCYCD
      * Check if Manual rate for Currency
     C     Kfxgp         CHAIN     @FXGPV1
     C                   If        Not %Found
      * Check if Manual rate for ALL
     C                   MOVEL     'M'           GPSTPR
     C                   MOVEL     'ALL'         GPCYCD
     C     Kfxgp         CHAIN     @FXGPV1
     C                   Endif
      * group found
     C                   If        %Found
      *
     C                   If        GpQccy <> BJCyCd and GpQccy <> *blanks
     C                   If        I@MSGR <> 0
     C                   MOVEL     MPCYCD        @CCY
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   SELECT
     C     A6NBDP        WHENEQ    0
     C                   Z-ADD     MPPYAM        D#FAMT
     C     A6NBDP        WHENEQ    1
     C     MPPYAM        MULT      10            D#FAMT
     C     A6NBDP        WHENEQ    2
     C     MPPYAM        MULT      100           D#FAMT
     C     A6NBDP        WHENEQ    3
     C     MPPYAM        MULT      1000          D#FAMT
     C                   ENDSL
     C                   Endif
      *
     C                   MOVEL     MPCYCD        D#FCCY
     C                   MOVEL     GPQCCY        D#TCCY
      *
     C                   CALL      'AOCCYCV0'                           9090
     C                   PARM      *BLANKS       O#RTN             7
     C                   PARM      '*F*T*SPT'    W0ACT             8
     C     D#DTA         PARM      D#DTA         O#DTA           256
     C                   Endif
      *
      * Get customer group FX rate information
      *
     C                   Select
      * Range 1
     C     GPLAM1        Wheneq    -1
     C     GPLAM1        orge      D#TAMT
     C     GPDLR1        ifne      'Y'
     C     GPFXS1        andne     *BLANKS
     C                   Movel     GPFXS1        SVFXSP
     C                   Endif
      * Range 2
     C     GPLAM2        Wheneq    -1
     C     GPLAM2        orge      D#TAMT
     C     GPDLR2        ifne      'Y'
     C     GPFXS2        andne     *BLANKS
     C                   Movel     GPFXS2        SVFXSP
     C                   Endif
      * Range 3
     C     GPLAM3        Wheneq    -1
     C     GPLAM3        orge      D#TAMT
     C     GPDLR3        ifne      'Y'
     C     GPFXS3        andne     *BLANKS
     C                   Movel     GPFXS3        SVFXSP
     C                   Endif
      * Range 4
     C     GPLAM4        Wheneq    -1
     C     GPLAM4        orge      D#TAMT
     C     GPDLR4        ifne      'Y'
     C     GPFXS4        andne     *BLANKS
     C                   Movel     GPFXS4        SVFXSP
     C                   Endif
      * Range 5
     C     GPLAM5        Wheneq    -1
     C     GPLAM5        orge      D#TAMT
     C     GPDLR5        ifne      'Y'
     C     GPFXS5        andne     *BLANKS
     C                   Movel     GPFXS5        SVFXSP
     C                   Endif
      * Range 6
     C     GPLAM6        Wheneq    -1
     C     GPLAM6        orge      D#TAMT
     C     GPDLR6        ifne      'Y'
     C     GPFXS6        andne     *BLANKS
     C                   Movel     GPFXS6        SVFXSP
     C                   Endif
      * Range 7
     C     GPLAM7        Wheneq    -1
     C     GPLAM7        orge      D#TAMT
     C     GPDLR7        ifne      'Y'
     C     GPFXS7        andne     *BLANKS
     C                   Movel     GPFXS7        SVFXSP
     C                   Endif
      * Range 8
     C     GPLAM8        Wheneq    -1
     C     GPLAM8        orge      D#TAMT
     C     GPDLR8        ifne      'Y'
     C     GPFXS8        andne     *BLANKS
     C                   Movel     GPFXS8        SVFXSP
     C                   Endif
      * Range 9
     C     GPLAM9        Wheneq    -1
     C     GPLAM9        orge      D#TAMT
     C     GPDLR9        ifne      'Y'
     C     GPFXS9        andne     *BLANKS
     C                   Movel     GPFXS8        SVFXSP
     C                   Endif
     C                   Endsl
     C                   Eval      PXFXSP = SVFXSP
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   If        P#Idoc <> *blanks
     C                   Eval      PXDoCd = P#Idoc
     C                   Endif
      *
     C                   If        P#Ifxs <> *blanks
     C                   Eval      PXFXSP = P#Ifxs
     C                   Endif
      *
     C                   Call      'FTP960'
     C                   Parm      'STORE'       P@RTN             7
     C                   Parm                    FTPEXT
     C                   Else
      * Clear data
     C                   Clear                   FTPEXT
     C                   If        I@PREF = *blanks
     C                   Eval      PXPREF = R#REF
     C                   Else
     C                   Eval      PXPREF = I@PREF
     C                   Endif
     C                   Eval      PXPCAT = 'N'
     C                   Call      'FTP960'
     C                   Parm      'STORE'       P@RTN             7
     C                   Parm                    FTPEXT
     C                   Endif
      *
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
      ** If there are any errors *IN30 must be set off
     C                   Eval      ##NoError = ' '
      *
     C                   If        SPCIB <> *blanks and SPCAT <> *Blanks
     C                   SETON                                        5152
     C                   MOVE      'STP0007'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
      *
     C                   If        SPCIB <> *blanks
      *
      * If IBAN then must be valid one on file
     C     KPCIban       KLIST
     C                   Kfld                    PCIBAN
      *
     C                   Eval      PCIBAN = SPCIB
      *
     C                   CALL      'AOIBANR4'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    PCIBAN
     C     D@ACCT        PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFNE      *BLANKS
     C                   SETON                                        51
     C                   MOVE      'STP0004'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   ELse
      *
     C     KPCIban       Chain     @PCATJ0
     C                   If        %Found
      *
      **  Set up work fields according to Incoming or Outgoing Payment
     C     I@PTYP        Ifeq      'IN'
     C                   Movel     PCCOMI        P#COMI
     C                   Movel     PCCOMA        P#COMA
     C                   Movel     PCFXRI        P#FXRI
     C                   Movel     PCFXLA        P#FXLA
     C                   Movel     PCIDOC        P#IDOC
     C                   Movel     PCICUT        P#ICUT
     C                   Movel     PCIFXS        P#IFXS
     C                   Else
     C                   Movel     PCOCMI        P#COMI
     C                   Movel     PCOCMA        P#COMA
     C                   Movel     PCOXRI        P#FXRI
     C                   Movel     PCOXLA        P#FXLA
     C                   Movel     PCODOC        P#IDOC
     C                   Movel     PCOCUT        P#ICUT
     C                   Movel     PCOFXS        P#IFXS
     C                   Endif
      *
     C                   Eval      SBCCY  = PCBCCY
     C                   Eval      SBSEG  = PCBSEG
     C                   Eval      SCOMI  = P#COMI
     C                   Eval      SPENR  = PCPENR
     C                   Eval      SFXRI  = P#FXRI
     C                   Eval      SRIND  = PCRIND
     C                   Eval      SBTYP  = PCBTYP
     C                   Eval      SSPRT  = PCSPRT
     C                   Eval      SIMCY  = PCIMCY

      * Set status
     C                   Select
     C                   When      PCAsts = 'I'
     C                   Eval      SASTD = 'Investigate'
     C                   When      PCAsts = 'C'
     C                   Eval      SASTD = 'Closed'
     C                   When      PCAsts = 'E'
     C                   Eval      SASTD = 'Data Error'
     C                   Other
     C                   Eval      SASTD = *blanks
     C                   Endsl

     C                   Exsr      Setnarrative

      * Check currency against pay currency if set
     C                   If        I@CCY <> *blanks and
     C                             I@CCY <> PCBCCY
     C                   SETON                                        51
     C                   MOVE      'STP0034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   If        SPCAT <> *blanks
      * If Retail Number then must be valid one on file
     C     KPCRnbr       KLIST
     C                   Kfld                    PCRNB1
     C                   Kfld                    PCRNB2
      *
     C     16            Subst     SPCAT:1       PCRNB1
     C     18            Subst     SPCAT:17      PCRNB2
     C     KPCRnbr       Chain     @PCATJ1
     C                   If        Not %Found
     C                   SETON                                        52
     C                   MOVE      'STP0006'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   ELse
      *
      **  Set up work fields according to Incoming or Outgoing Payment
     C     I@PTYP        Ifeq      'IN'
     C                   Movel     PCCOMI        P#COMI
     C                   Movel     PCCOMA        P#COMA
     C                   Movel     PCFXRI        P#FXRI
     C                   Movel     PCFXLA        P#FXLA
     C                   Movel     PCIDOC        P#IDOC
     C                   Movel     PCICUT        P#ICUT
     C                   Movel     PCIFXS        P#IFXS
     C                   Else
     C                   Movel     PCOCMI        P#COMI
     C                   Movel     PCOCMA        P#COMA
     C                   Movel     PCOXRI        P#FXRI
     C                   Movel     PCOXLA        P#FXLA
     C                   Movel     PCODOC        P#IDOC
     C                   Movel     PCOCUT        P#ICUT
     C                   Movel     PCOFXS        P#IFXS
     C                   Endif
      *
     C                   Eval      SBCCY  = PCBCCY
     C                   Eval      SBSEG  = PCBSEG
     C                   Eval      SCOMI  = P#COMI
     C                   Eval      SPENR  = PCPENR
     C                   Eval      SFXRI  = P#FXRI
     C                   Eval      SRIND  = PCRIND
     C                   Eval      SBTYP  = PCBTYP
     C                   Eval      SSPRT  = PCSPRT
     C                   Eval      SIMCY  = PCIMCY

      * Set status
     C                   Select
     C                   When      PCAsts = 'I'
     C                   Eval      SASTD = 'Investigate'
     C                   When      PCAsts = 'C'
     C                   Eval      SASTD = 'Closed'
     C                   When      PCAsts = 'E'
     C                   Eval      SASTD = 'Data Error'
     C                   Other
     C                   Eval      SASTD = *blanks
     C                   Endsl

     C                   Exsr      Setnarrative
     C                   Endif
     C                   Endif
      * Default Foreign Pension
     C                   If        SPENF = *blanks
     C                   Eval      SPENF  = 'N'
     C                   Endif
      *
     C                   If        SPENF <> 'N' and SPENF <> 'Y'
      * Must Yes or No
     C                   SETON                                        53
     C                   MOVE      'STP0005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif

      * Transaction type is blank and pension default to 1740
     C                   If        STTYP =  *blanks and
     C                             SPENF = 'Y'
     C                   Eval      STTYP = '1740'
     C                   Endif

      * Transaction type is blank then default to 1730
     C                   If        STTYP =  *blanks and
     C                             SPENF <> 'Y'
     C                   Eval      STTYP = '1730'
     C                   Endif

      * Transaction type must be blank, 0000 1730 or 1740
     C                   If        STTYP <> *blanks and
     C                             STTYP <> '0000'  and
     C                             STTYP <> '1730'  and
     C                             STTYP <> '1740'
     C                   SETON                                        54
     C                   MOVE      'STP0037'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif

      * Transaction type must be blank, 0000 1730 or 1740
     C                   If        STTYP <> '1740' and
     C                             SPENF = 'Y'
     C                   SETON                                        54
     C                   MOVE      'STP0038'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif

      * If no error but account closed then error message
     C                   If        PCASTS = 'C' and ##NoError <> 'Y'
     C                   SETON                                        51
     C                   MOVE      'STP0040'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif

      * If no error but invalid data   then error message
     C                   If        PCASTS = 'E' and ##NoError <> 'Y'
     C                   SETON                                        51
     C                   MOVE      'STP0041'     ZAMSID
     C                   EXSR      ZASNMS
     C                   Eval      ##NoError = 'Y'
     C                   Endif
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
