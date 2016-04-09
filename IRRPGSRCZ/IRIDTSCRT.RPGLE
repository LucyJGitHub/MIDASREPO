     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Invalid date schedule retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRIDTSCRT - Invalid Date Schedule Retrieval                  *
      *                                                               *
      *  Function:  This module gets the 'invalid' date schedule      *
      *             and puts it to the date schedule file. This is so *
      *             that these dates can be worked on in the interest *
      *             rate swap repair functions.                       *
      *             This module will only be called if the IRC        *
      *             switchable feature is on.                         *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAP043             Date 02May02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *  Prev Amend No. 211064             Date 08Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CIR003             Date 12Sep00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 168444  *CREATE    Date 30Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  211064 - Record IRIDTSCPD not deleted when deal has been     *
      *           repaired. This leads to the failing of APCCHKTRNS   *
      *           in COB.                                             *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *           Recompile over DLDETUL0.                            *
      *  168444 - Enable maintenance of date schedules in IRS repair  *
      *           functions.                                          *
      *                                                               *
      *****************************************************************
      *
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      *
     F*IRIDTSCL0IF*  E           K DISK                                                       CAP043
     F*************                        COMMIT                                      211064 CAP043
     F*DLDETDL0IF**  E           K DISK                                                       CAP043
     F*************                        RENAME(DLPCSCD0:DLPCSCD1)                          CAP043
     F*************                        RENAME(DLDTSCD0:DLDTSCD1)                          CAP043
     F*************                        RENAME(DLCFSCD0:DLCFSCD1)                          CAP043
     F*DLDETUL0*UF*A E           K DISK                                                       CAP043
     FDLDETUL0  UF A E           K DISK    PREFIX(X)                                          CAP043
     F                                     COMMIT
     FDLTDTSCL0 IF   E           K DISK    PREFIX(T)                                          CAP043
     F                                     RENAME(DLDTSCD0:DLTDTSCT0)                         CAP043
     FDLTDTSCPD UF A E           K DISK                                                       CAP043
     F                                     RENAME(DLDTSCD0:DLTDTSCD0)                         CAP043
     F                                     COMMIT                                             CAP043
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
   43D/COPY ZACPYSRC,ERR_ARRAYS
                                                                                              CAP043
     D DTSCTemp      E DS                  EXTNAME(DLTDTSCPD)                                 CAP043
                                                                                              CAP043
     D DTSCUpd       E DS                  EXTNAME(DLDTSCPD) PREFIX(X)                        CAP043
 
  109D IRCDates      E DS                  EXTNAME(IRIDTSCPD)
      ** Interest Rate Calendar dates
     D DatesToVal             24    515
 
     D                 DS
      ** Interest Rate Calendar dates as day numbers
     D  AlpDate                1    246A
     D  NumDate                1    246P 0 DIM(82)
 
     D**********       DS                                                                     CAP043
      ***Our*Rate*Change*dates*as*day*numbers                                                 CAP043
     D**URADate*               1    246A                                                      CAP043
     D**URNDate*               1    246P 0 DIM(82)                                            CAP043
 
     D**********       DS                                                                     CAP043
      ***Our*Payment*dates*as*day*numbers                                                     CAP043
     D**UPADate*               1    246A                                                      CAP043
     D**UPNDate*               1    246P 0 DIM(82)                                            CAP043
 
     D**********       DS                                                                     CAP043
      ***Their*Rate*Change*dates*as*day*numbers                                               CAP043
     D**TRADate*               1    246A                                                      CAP043
     D**TRNDate*               1    246P 0 DIM(82)                                            CAP043
 
     D**********       DS                                                                     CAP043
      ***Their*Payment*dates*as*day*numbers                                                   CAP043
     D**TPADate*               1    246A                                                      CAP043
     D**TPNDate*               1    246P 0 DIM(82)                                            CAP043
 
     D                 DS
      ** Our Rate Change dates - invalid - as day numbers
     D  URADateI               1    246A
     D  URNDateI               1    246P 0 DIM(82)
 
     D                 DS
      ** Our Payment dates - invalid - as day numbers
     D  UPADateI               1    246A
     D  UPNDateI               1    246P 0 DIM(82)
 
     D                 DS
      ** Their Rate Change dates - invalid - as day numbers
     D  TRADateI               1    246A
     D  TRNDateI               1    246P 0 DIM(82)
 
     D                 DS
      ** Their Payment dates - invalid - as day numbers
     D  TPADateI               1    246A
     D  TPNDateI               1    246P 0 DIM(82)
                                                                                              CAP043
     D ConfHolDS       DS                                                                     CAP043
      ** Confirmed Holiday indicators output field                                            CAP043
     D  WConfHol                      1A   DIM(82)                                            CAP043
                                                                                              CAP043
     D PErrorFndDt     DS                                                                     CAP043
     D   OurRateEr             1      1                                                       CAP043
     D   OurIntPEr             2      2                                                       CAP043
     D   ThrRateEr             3      3                                                       CAP043
     D   ThrIntPEr             4      4                                                       CAP043
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Front Office ID & Timestamp
     D @FOTRANID       S             20A
     D @TMESTMP        S             26Z
 
      ** IRC valid dates returned from IRVIRCVAL
     D ValidDates      S            246A   INZ(*BLANKS)
                                                                                              CAP043
      ** Work fields used by CAP043                                                           CAP043
     D PAction         S              1A                                                      CAP043
     D PDealNo         S              6A                                                      CAP043
     D PPrevDate       S              5P 0                                                    CAP043
     D POurTheir       S              1A                                                      CAP043
     D PValType        S              1A                                                      CAP043
     D PCurrency       S              3A                                                      CAP043
                                                                                              CAP043
      ** Amounts to be validated (max 82)                                                     CAP043
     D PAmount1        S           1148A                                                      CAP043
                                                                                              CAP043
      ** Amounts to be validated (max 82)                                                     CAP043
     D PAmount2        S           1312A                                                      CAP043
                                                                                              CAP043
      ** Increase/Decrease indicator                                                          CAP043
     D PIncDecInd      S             82A                                                      CAP043
                                                                                              CAP043
      ** Business Day Convention currencies                                                   CAP043
     D PBDConvtn       S             30A                                                      CAP043
                                                                                              CAP043
      ** Confirmed Holiday Indicator                                                          CAP043
     D PConfHol        S             82A                                                      CAP043
                                                                                              CAP043
      ** Output amounts                                                                       CAP043
     D PValidAmnt      S            574A                                                      CAP043
     D PValidCAmt      S            656A                                                      CAP043
     D POverride       S             32A   INZ('OVRDBF FILE(DLDETUL0) +                       CAP043
     D                                            SHARE(*NO)')                                CAP043
     D POvrLen         S             15  5                                                    CAP043
     D PUpdate         S              1A                                                      CAP043
     D PCtlDate        S              5P 0                                                    CAP043
     D WDeletedUR      S              1A                                                      CAP043
     D WDeletedUP      S              1A                                                      CAP043
     D WDeletedTR      S              1A                                                      CAP043
     D WDeletedTP      S              1A                                                      CAP043
 
      **
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
                                                                                              CAP043
      ** If update indicator is 'Y', update the db file thru temporary file                   CAP043
                                                                                              CAP043
     C                   IF        (PUpdate = 'Y')                                            CAP043
     C                   EXSR      SRUPDATE                                                   CAP043
     C                   ELSE                                                                 CAP043
 
      *  Use screen or automatic deal number
 
     C     SDLNO         IFNE      *BLANK
     C                   MOVEL     SDLNO         DLNO
     C                   ELSE
     C                   MOVEL     I#SDLNO       DLNO
     C                   ENDIF
 
      *  Get 'Invalid' Date Schedule
 
     C                   EXSR      GETIDATS
 
      *  Read Date Schedule files
 
     C**********         EXSR      REDDTFILS                                                  CAP043
 
      *  Update Date Schedule files
 
     C                   EXSR      UPDDTFILS
     C                   ENDIF                                                                CAP043
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETIDATS - Get 'Invalid' Date Schedule                       *
      *                                                               *
      *****************************************************************
     C     GETIDATS      BEGSR
 
      * Initialize Our/Their Rate Change and Payment Dates
 
     C                   Z-ADD     *ZERO         URNDateI
     C                   Z-ADD     *ZERO         UPNDateI
     C                   Z-ADD     *ZERO         TRNDateI
     C                   Z-ADD     *ZERO         TPNDateI
 
     C*****IRIDTSCK      SETLL     IRIDTSCD0                                                  CAP043
     C*****IRIDTSCK      READE     IRIDTSCD0                              99    *             CAP043
     C******in99         DOWEQ     '0'                                                        CAP043
 
     C                   MOVEL     SOURTHR       OTIN
     C                   MOVEL     SRATPAY       RCIP
 
      * If a date schedule is present
      *   Validate it
      *   If valid, store the dates in the appropriate date array
 
     C     DatesToVal    IFNE      *BLANK
     C                   EXSR      VALIDATS
     C     OKDates       IFEQ      'Y'
 
     C                   SELECT
     C     OTIN          WHENEQ    'U'
     C     RCIP          ANDEQ     'R'
     C                   MOVE      ValidDates    URADateI
     C     OTIN          WHENEQ    'U'
     C     RCIP          ANDEQ     'P'
     C                   MOVE      ValidDates    UPADateI
     C     OTIN          WHENEQ    'T'
     C     RCIP          ANDEQ     'R'
     C                   MOVE      ValidDates    TRADateI
     C     OTIN          WHENEQ    'T'
     C     RCIP          ANDEQ     'P'
     C                   MOVE      ValidDates    TPADateI
     C                   ENDSL
 
     C                   ENDIF
                                                                                              CAP043
      ** If error found, set error found parameter to 'Y'                                     CAP043
                                                                                              CAP043
     C                   IF        OkDates = 'N'                                              CAP043
     C                   SELECT                                                               CAP043
     C     OTIN          WHENEQ    'U'                                                        CAP043
     C     RCIP          ANDEQ     'R'                                                        CAP043
     C                   EVAL      OurRateEr = 'Y'                                            CAP043
     C     OTIN          WHENEQ    'U'                                                        CAP043
     C     RCIP          ANDEQ     'P'                                                        CAP043
     C                   EVAL      OurIntPEr = 'Y'                                            CAP043
     C     OTIN          WHENEQ    'T'                                                        CAP043
     C     RCIP          ANDEQ     'R'                                                        CAP043
     C                   EVAL      ThrRateEr = 'Y'                                            CAP043
     C     OTIN          WHENEQ    'T'                                                        CAP043
     C     RCIP          ANDEQ     'P'                                                        CAP043
     C                   EVAL      ThrIntPEr = 'Y'                                            CAP043
     C                   ENDSL                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF
 
     C*****IRIDTSCK      READE     IRIDTSCD0                              99    *             CAP043
     C**********         ENDDO                                                                CAP043
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATS - Validate 'Invalid' Date Schedule                   *
      *                                                               *
      *****************************************************************
     C     VALIDATS      BEGSR
                                                                                              CAP043
     C                   MOVE      DLNO          PDealNo                                      CAP043
                                                                                              CAP043
     C                   IF        SRATPAY = 'R'                                              CAP043
     C                   EVAL      PValType = 'R'                                             CAP043
     C                   ELSE                                                                 CAP043
     C                   IF        SRATPAY = 'P'                                              CAP043
     C                   EVAL      PValType = 'I'                                             CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Override DLDETUL0 to SHARE(*NO) to avoid unexpected error                            CAP043
                                                                                              CAP043
     C                   CALL      'QCMDEXC'                                                  CAP043
     C                   PARM                    POverride                                    CAP043
     C                   PARM      32            POvrLen                                      CAP043
      *
     C                   CALLB     'IRVIRCVAL'
      * Return Code
     C                   PARM                    ReturnCode
 
      * Value date in 5,0 format
      * Maturity date in 5,0 format
     C                   PARM                    RSVDAT
     C                   PARM                    RSMDAT
     C                   PARM      *ZERO         PCtlDate                                     CAP043
 
      * Date format indicator
     C                   PARM                    BJDFIN
     C                   PARM                    PAction                                      CAP043
     C                   PARM                    PDealNo                                      CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM                    PValType                                     CAP043
     C                   PARM      SOURTHR       POurTheir                                    CAP043
     C                   PARM                    PCurrency                                    CAP043
 
      * IRC Dates to Validate (82 x 6A)
     C                   PARM                    DatesToVal
     C                   PARM      *BLANK        PAmount1                                     CAP043
     C                   PARM      *BLANK        PAmount2                                     CAP043
     C                   PARM      *BLANK        PIncDecInd                                   CAP043
     C                   PARM      *BLANK        PConfHol                                     CAP043
     C                   PARM                    PBDConvtn                                    CAP043
 
      * IRC Dates OK flag
     C                   PARM      'Y'           OKDates           1
 
      * Error fields/message IDs (arrays) from/to caller
      * Array index (3P0) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C**********         PARM                    Idx               3 0                        CAP043
     C                   PARM      *ZERO         Idx               3 0                        CAP043
      * IRC dates in day number format (82 x 3A)
     C                   PARM                    ValidDates
     C                   PARM      *BLANK        PValidAmnt                                   CAP043
     C                   PARM      *BLANK        PValidCAmt                                   CAP043
                                                                                              CAP043
     C                   MOVEL     PConfHol      ConfHolDS                                    CAP043
 
     C                   ENDSR
      *****************************************************************
      ***/EJECT********************************************************                       CAP043
      *****************************************************************                       CAP043
      **********                                                      *                       CAP043
      ***REDDTFILS*-*Read*Date*Schedule*files                         *                       CAP043
      **********                                                      *                       CAP043
      *****************************************************************                       CAP043
     C*****REDDTFILS     BEGSR                                                                CAP043
      **********                                                                              CAP043
      ***Read*Date*Schedule*Records*-*Our*Rate                                                CAP043
      **********                                                                              CAP043
     C**********         MOVEL     'U'           OTIN                                         CAP043
     C**********         MOVEL     'R'           RCIP                                         CAP043
     C**********         EXSR      REDDTSCR                                                   CAP043
     C**********         MOVE      AlpDate       URADate                                      CAP043
      **********                                                                              CAP043
      ***Read*Date*Schedule*Records*-*Our*Payment                                             CAP043
      **********                                                                              CAP043
     C**********         MOVEL     'U'           OTIN                                         CAP043
     C**********         MOVEL     'P'           RCIP                                         CAP043
     C**********         EXSR      REDDTSCR                                                   CAP043
     C**********         MOVE      AlpDate       UPADate                                      CAP043
      **********                                                                              CAP043
      ***Read*Date*Schedule*Records*-*Their*Rate                                              CAP043
      **********                                                                              CAP043
     C**********         MOVEL     'T'           OTIN                                         CAP043
     C**********         MOVEL     'R'           RCIP                                         CAP043
     C**********         EXSR      REDDTSCR                                                   CAP043
     C**********         MOVE      AlpDate       TRADate                                      CAP043
      **********                                                                              CAP043
      ***Read*Date*Schedule*Records*-*Their*Payment                                           CAP043
      **********                                                                              CAP043
     C**********         MOVEL     'T'           OTIN                                         CAP043
     C**********         MOVEL     'P'           RCIP                                         CAP043
     C**********         EXSR      REDDTSCR                                                   CAP043
     C**********         MOVE      AlpDate       TPADate                                      CAP043
      **********                                                                              CAP043
     C**********         ENDSR                                                                CAP043
      *****************************************************************                       CAP043
      ***/EJECT*                                                                              CAP043
      *****************************************************************                       CAP043
      **********                                                      *                       CAP043
      ***REDDTSCR*-*Read*Date*Schedule*Records                        *                       CAP043
      **********                                                      *                       CAP043
      *****************************************************************                       CAP043
     C*****REDDTSCR      BEGSR                                                                CAP043
      **********                                                                              CAP043
     C**********         Z-ADD     1             D                 3 0                        CAP043
     C**********         Z-ADD     *ZERO         NumDate                                      CAP043
      **********                                                                              CAP043
     C*****DLDTSCK       SETLL     DLDTSCD1                                                   CAP043
     C*****DLDTSCK       READE     DLDTSCD1                               99    *             CAP043
     C******in99         DOWEQ     '0'                                                        CAP043
     C*****D****         ANDLE     82                                                         CAP043
     C**********         MOVE      PRDT          NumDate(D)                                   CAP043
     C**********         ADD       1             D                                            CAP043
     C*****DLDTSCK       READE     DLDTSCD1                               99    *             CAP043
     C**********         ENDDO                                                                CAP043
      **********                                                                              CAP043
     C**********         ENDSR                                                                CAP043
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDDTFILS - Update Date Schedule files                       *
      *                                                               *
      *****************************************************************
     C     UPDDTFILS     BEGSR
 
      *  Update Date Schedule Records - Our Rate
 
     C                   IF        (SOURTHR = 'U') AND (SRATPAY = 'R')                        CAP043
     C*****URADateI      IFNE      URADate                                                    CAP043
     C     URADateI      IFNE      *BLANK                                                     CAP043
     C                   MOVE      URADateI      AlpDate
     C                   MOVEL     'U'           OTIN
     C                   MOVEL     'R'           RCIP
     C**********         EXSR      DLTDTSCR                                                   CAP043
     C                   EXSR      WRTDTSCR
     C                   ENDIF
     C                   ENDIF                                                                CAP043
 
      *  Update Date Schedule Records - Our Payment
 
     C                   IF        (SOURTHR = 'U') AND (SRATPAY = 'P')                        CAP043
     C*****UPADateI      IFNE      UPADate                                                    CAP043
     C     UPADateI      IFNE      *BLANK                                                     CAP043
     C                   MOVE      UPADateI      AlpDate
     C                   MOVEL     'U'           OTIN
     C                   MOVEL     'P'           RCIP
     C**********         EXSR      DLTDTSCR                                                   CAP043
     C                   EXSR      WRTDTSCR
     C                   ENDIF
     C                   ENDIF                                                                CAP043
 
      *  Update Date Schedule Records - Their Rate
 
     C                   IF        (SOURTHR = 'T') AND (SRATPAY = 'R')                        CAP043
     C*****TRADateI      IFNE      TRADate                                                    CAP043
     C     TRADateI      IFNE      *BLANK                                                     CAP043
     C                   MOVE      TRADateI      AlpDate
     C                   MOVEL     'T'           OTIN
     C                   MOVEL     'R'           RCIP
     C**********         EXSR      DLTDTSCR                                                   CAP043
     C                   EXSR      WRTDTSCR
     C                   ENDIF
     C                   ENDIF                                                                CAP043
 
      *  Update Date Schedule Records - Their Payment
 
     C                   IF        (SOURTHR = 'T') AND (SRATPAY = 'P')                        CAP043
     C*****TPADateI      IFNE      TPADate                                                    CAP043
     C     TPADateI      IFNE      *BLANK                                                     CAP043
     C                   MOVE      TPADateI      AlpDate
     C                   MOVEL     'T'           OTIN
     C                   MOVEL     'P'           RCIP
     C**********         EXSR      DLTDTSCR                                                   CAP043
     C                   EXSR      WRTDTSCR
     C                   ENDIF
     C                   ENDIF                                                                CAP043
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DLTDTSCR - Delete Date Schedule Records                      *
      *                                                               *
      *****************************************************************
     C     DLTDTSCR      BEGSR
 
 
     C     DLDTSCK       SETLL     DLDTSCD0
     C     DLDTSCK       READE     DLDTSCD0                               99    *
     C     *in99         DOWEQ     '0'
 
      * If date not processed
     C     DTPR          IFNE      'Y'
     C                   DELETE    DLDTSCD0                                     *
     C                   ENDIF
     C     DLDTSCK       READE     DLDTSCD0                               99    *
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRTDTSCR - Write Date Schedule Records                       *
      *                                                               *
      *****************************************************************
     C     WRTDTSCR      BEGSR
 
      * Output all (non-processed) dates to the date schedule work file
 
     C                   Z-ADD     1             D                 3 0
     C     D             DOWLE     82
     C     NumDate(D)    ANDNE     *ZERO
     C                   MOVE      NumDate(D)    PRDT
     C**********         MOVE      ' '           COHO                                         CAP043
     C                   EVAL      COHO = WConfHol(D)                                         CAP043
     C                   MOVE      ' '           DTPR
     C*****DLDTSCKP      CHAIN     DLDTSCD1                           99        *             CAP043
     C***99*****         WRITE     DLDTSCD0                                     *             CAP043
     C     DLDTSCKP      CHAIN     DLTDTSCL0                                                  CAP043
     C                   IF        NOT %FOUND(DLTDTSCL0)                                      CAP043
     C                   WRITE     DLTDTSCD0                                                  CAP043
     C                   ENDIF                                                                CAP043
     C                   ADD       1             D
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRUPDATE - Update DLDTSC thru DLTDTSC file                       *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRUPDATE      BEGSR                                                                CAP043
                                                                                              CAP043
      ** No error found, update database                                                      CAP043
                                                                                              CAP043
     C                   EVAL      WDeletedUR = 'N'                                           CAP043
     C                   EVAL      WDeletedUP = 'N'                                           CAP043
     C                   EVAL      WDeletedTR = 'N'                                           CAP043
     C                   EVAL      WDeletedTP = 'N'                                           CAP043
                                                                                              CAP043
      ** Write new records to DLDTSCPD                                                        CAP043
                                                                                              CAP043
     C     *LOVAL        SETLL     DLTDTSCPD                                                  CAP043
     C                   READ      DLTDTSCPD                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(DLTDTSCPD)                                        CAP043
                                                                                              CAP043
      ** Delete old non-processed records from DLDTSCPD before writing new ones               CAP043
                                                                                              CAP043
     C                   IF        (OTIN = 'U') AND (RCIP = 'R') AND                          CAP043
     C                             (WDeletedUR = 'N') AND (OurRateEr = 'N')                   CAP043
     C                   EXSR      DLTDTSCR                                                   CAP043
     C                   EVAL      WDeletedUR = 'Y'                                           CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   IF        (OTIN = 'U') AND (RCIP = 'P') AND                          CAP043
     C                             (WDeletedUP = 'N') AND (OurIntPEr = 'N')                   CAP043
     C                   EXSR      DLTDTSCR                                                   CAP043
     C                   EVAL      WDeletedUP = 'Y'                                           CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   IF        (OTIN = 'T') AND (RCIP = 'R') AND                          CAP043
     C                             (WDeletedTR = 'N') AND (ThrRateEr = 'N')                   CAP043
     C                   EXSR      DLTDTSCR                                                   CAP043
     C                   EVAL      WDeletedTR = 'Y'                                           CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   IF        (OTIN = 'T') AND (RCIP = 'P') AND                          CAP043
     C                             (WDeletedTP = 'N') AND (ThrIntPEr = 'N')                   CAP043
     C                   EXSR      DLTDTSCR                                                   CAP043
     C                   EVAL      WDeletedTP = 'Y'                                           CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Only write to db file if there is no error for our or their schedules                CAP043
                                                                                              CAP043
     C                   IF        (OTIN = 'U') AND (RCIP = 'R') AND                          CAP043
     C                             (OurRateEr = 'N') OR                                       CAP043
     C                             (OTIN = 'U') AND (RCIP = 'P') AND                          CAP043
     C                             (OurIntPEr = 'N') OR                                       CAP043
     C                             (OTIN = 'T') AND (RCIP = 'R') AND                          CAP043
     C                             (ThrRateEr = 'N') OR                                       CAP043
     C                             (OTIN = 'T') AND (RCIP = 'P') AND                          CAP043
     C                             (ThrIntPEr = 'N')                                          CAP043
     C                   EVAL      DTSCUpd = DTSCTemp                                         CAP043
     C                   WRITE     DLDTSCD0                                                   CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   DELETE    DLTDTSCD0                                                  CAP043
     C                   READ      DLTDTSCPD                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
 
      * Front Office ID
      * Timestamp
     C**********         PARM                    @FOTRANID                                    CAP043
     C**********         PARM                    @TMESTMP                                     CAP043
 
      * Deal number
     C                   PARM                    SDLNO             6
     C                   PARM                    I#SDLNO           6
 
      * Value date in 5,0 format
      * Maturity date in 5,0 format
     C                   PARM                    RSVDAT            5 0
     C                   PARM                    RSMDAT            5 0
 
      * Date format indicator
     C                   PARM                    BJDFIN            1
     C                   PARM                    PAction                                      CAP043
     C                   PARM                    PUpdate                                      CAP043
     C                   PARM                    PErrorFndDt                                  CAP043
     C                   PARM                    IRCDates                                     CAP043
     C                   PARM                    PPrevDate                                    CAP043
     C                   PARM                    PCurrency                                    CAP043
     C                   PARM                    PBDConvtn                                    CAP043
      *
     C*****IRIDTSCK      KLIST                                                                CAP043
     C**********         KFLD                    @FOTRANID                                    CAP043
     C**********         KFLD                    @TMESTMP                                     CAP043
      *
     C     DLDTSCK       KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
      *
     C     DLDTSCKP      KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
     C                   KFLD                    PRDT
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
