     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Annual Tax Deducted Statement - Prompt')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Moduleodule                            *
      *                                                               *
      *  SD000769 - Annual Tax Deducted Statement - Prompt            *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user  selection input of Annual Tax           *
      *             Deducted Statement                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. AR689705           Date 03Jan11               *
      *  Prev Amend No. BUG24574           Date 07Jul09               *
      *                 BUG24767           Date 07Jul09               *
      *                 BUG24280A          Date 18Jun09               *
      *                 BUG22797           Date 05Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  BUG24574 - Withholding Tax - R4 vs M+                        *
      *  BUG24767 - Cannot request annual tax deducted statement      *
      *  BUG24280A - Value of Current Threshold is incorrect          *
      *  BUG22797 - Added Prompt Fields and Refresh Function          *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *                                                               *
      *  01        End of File indicator                              *
      ***10********Field*Error*-*highlight*screen*fields***************                     BUG22797
      *  10        Error on Field STAXYR                              *                     BUG22797
      *  11        Error on field TAXYRF                              *                     BUG22797
      *  12        Error on field TAXYRT                              *                     BUG22797
      *  13        Error on field SDCUST                              *                     BUG22797
      *  14        Error on field SDCUSTF                             *                     BUG22797
      *  15        Error on field SDCUSTT                             *                     BUG22797
      *  25        Subfile control                                    *
      *  25        Subfile end                                        *
      *  75        General error indicator                            *                     BUG22797
      *  77        Working field for scan '?'                         *                     BUG22797
      *  KC        F3 pressed = Exit                                  *
      *  KE        F5 pressed = Refresh                               *                     BUG22797
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProc - Process inputs                                      *
      *  SRVal - Validate details                                     *
      *  SRVals - Validate details                                    *                     BUG22797
      *  SRValCust - Validate Customer Details                        *                     BUG22797
      *  SRCust -  Validate Customer Number                           *                     BUG22797
      *  SRCustf - Validate Customer Number from                      *                     BUG22797
      *  SRCustt - Validate Customer Number to                        *                     BUG22797
      *  SRSndM - Send Message to Screen                              *
      *  SRDisp - Display screen                                      *
      *  SRValTxYr - Validate Tax Year                                *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Annual Tax Deducted Statement Prompt Screen
     FSD000769DFCF   E             WORKSTN
                                                                                            BUG22797
      ** Interest Payment History File                                                      BUG22797
     FSDINPHL1  IF   E           K DISK    USROPN                                           BUG22797
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array fo QCMDEXC                                                                   BUG22797
     D***ArrCmd          S             30A   DIM(2)                                BUG22797 BUG24574
     D**********                           PERRCD(1)                               BUG22797 BUG24574
     D**********                           CTDATA                                  BUG22797 BUG24574
     D ArrChk          S             36A   DIM(2)                                           BUG22797
     D                                     PERRCD(1)                                        BUG22797
     D                                     CTDATA                                           BUG22797
                                                                                            BUG22797
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                            BUG24767
      ** Externally described DS for Location details                                       BUG24767
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG24767
                                                                                            BUG24767
      ** Externally described DS for Country code details                                   BUG24767
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                BUG24767
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs, long data structure                                        BUG22797
                                                                                            BUG22797
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   BUG22797
                                                                                            BUG22797
      ** External DS for Customer Number                                                    BUG22797
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG22797
                                                                                            BUG22797
      ** Output DS
     D POutFlds        DS           100
     D  PTAXY                  1      4A
     D  PTaxYF                 5      8                                                     BUG22797
     D  PTaxYT                 9     12                                                     BUG22797
     D  PCust                 13     18                                                     BUG22797
     D  PCustf                19     24                                                     BUG22797
     D  Pcustt                25     30                                                     BUG22797
     D  PYrEnd                31     32A                                                    BUG24767
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ***Parameters*for*module*AOBANKR0********************************                     BUG22797
      ** Parameters for Access Objects                                                      BUG22797
     D PRtCd           S              7A
     D POptn           S              7A
     D PKey10          S             10A                                                    BUG22797
     D PKyst           S              7A                                                    BUG22797
     D PKey2           S              2A                                                    BUG22797
     D PKey3           S              3A                                                    BUG22797
 
      ** Work Fields
     D WScrn           S              1A
     D PReDsp          S              1A
     D WkScustn        S              6A                                                    BUG22797
     D WkCts           S              3P 0                                                  BUG22797
     D WkCmd           S             30A                                                    BUG22797
     D WkLen           S             15P 5                                                  BUG22797
     D WkResul         S              1P 0                                                  BUG22797
     D WLen            C                   30                                               BUG22797
     D WYear           S              2A                                                    BUG24767
     D WYearP          S              2P 0                                                  BUG24767
     D WYrEnd          S              6A                                                    BUG24767
     D WYrEndP         S              5P 0                                                  BUG24767
     D PERR            S              1A                                                    BUG24767
     D PLoc            S              3A                                                    BUG24767
     D PCtry           S              2A                                                    BUG24767
 
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A
 
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PACT            S              1A
     D PCMD            S              1A
     D WTaxYr#         S              4  0
     D WTaxYr@         S              4
     D WTaxYrF@        S              4                                                     BUG22797
     D WTaxYrT@        S              4                                                     BUG22797
     D WTaxYrF         S              4  0                                                  BUG22797
     D WTaxYrT         S              4  0                                                  BUG22797
     D YrNot#          S              2P 0                                                  BUG22797
     D CustNot#        S              2P 0                                                  BUG22797
     D WStr1           S             10A                                                    BUG22797
     D WStr2           S             36A                                                    BUG22797
     D WkTesty         S              2A                                                   BUG24280A
     D WkRtcd          S              1A                                                   BUG24280A
                                                                                           BUG24280A
     D PZDayNo         S              5P 0                                                 BUG24280A
     D PZDate          S              6P 0                                                 BUG24280A
     D PZADate         S              7A                                                   BUG24280A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Process inputs.
 
     C                   EXSR      SRProc
 
      ** Return.
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *****************************************************************
 
     C     SRProc        BEGSR
 
     C                   MOVE      WYrEnd        PYrEnd                                     BUG24767
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
 
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
      ** Do while SCREEN : Read details.
 
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRDisp
     C**********         IF        *INKC = *ON                                              BUG22797
                                                                                            BUG22797
     C                   SELECT                                                             BUG22797
                                                                                            BUG22797
     C                   WHEN      *INKC = *ON                                              BUG22797
     C                   EVAL      WScrn = 'E'
     C**********         ELSE                                                               BUG22797
                                                                                            BUG22797
     C                   WHEN      *INKE = *ON                                              BUG22797
     C                   EVAL      STAXYR = *BLANKS                                         BUG22797
     C                   EVAL      TAXYRF = *BLANKS                                         BUG22797
     C                   EVAL      TAXYRT = *BLANKS                                         BUG22797
     C                   EVAL      SCUSTN = *BLANKS                                         BUG22797
     C                   EVAL      SCUSTF = *BLANKS                                         BUG22797
     C                   EVAL      SCUSTT = *BLANKS                                         BUG22797
                                                                                            BUG22797
     C                   OTHER                                                              BUG22797
                                                                                            BUG22797
      ** Set Off General Error Indicator                                                    BUG22797
     C                   EVAL      *IN75 = *OFF                                             BUG22797
     C                   EXSR      SRVal
     C**********         ENDIF                                                              BUG22797
     C                   ENDSL                                                              BUG22797
                                                                                            BUG22797
     C                   ENDDO
 
      ** Do file update.
 
     C                   IF        WScrn = 'U'
     C                   EVAL      PTAXY = STAXYR
     C                   EVAL      PTaxYF = TAXYRF                                          BUG22797
     C                   EVAL      PTaxYT = TAXYRT                                          BUG22797
     C                   EVAL      PCust = SCUSTN                                           BUG22797
     C                   EVAL      PCustf = SCUSTF                                          BUG22797
     C                   EVAL      PCustt = SCUSTT                                          BUG22797
     C                   EVAL      WScrn = 'E'
     C                   ENDIF
 
      ** Terminate program.
 
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validate details                                     *
      *                                                               *
      *****************************************************************
 
     C     SRVal         BEGSR
 
      ** Move values to work fields for validation                                          BUG22797
     C                   EVAL      WStr1 = ArrChk(1)                                        BUG22797
     C                   EVAL      WStr2 = ArrChk(2)                                        BUG22797
                                                                                            BUG22797
      ** Validate details entered.
 
     C                   EXSR      SRValTxYr
 
      ** Only one customer selection is allowed.                                            BUG22797
     C                   EXSR      SRVals                                                   BUG22797
                                                                                            BUG22797
     C                   IF        WkCts <= 1                                               BUG22797
     C                   SELECT                                                             BUG22797
                                                                                            BUG22797
     C                   WHEN      SCUSTN <> *BLANKS                                        BUG22797
     C                   EXSR      SRCust                                                   BUG22797
                                                                                            BUG22797
     C                   OTHER                                                              BUG22797
     C                   EXSR      SRCustF                                                  BUG22797
     C                   EXSR      SRCustt                                                  BUG22797
                                                                                            BUG22797
     C                   ENDSL                                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** If no errors, update output parameter field.
 
     C                   IF        *IN10 = *OFF AND *IN11 = *OFF AND
     C**********                   *IN12 = *OFF AND *IN13 = *OFF                            BUG22797
     C                             *IN12 = *OFF AND *IN13 = *OFF AND                        BUG22797
     C                             *IN14 = *OFF AND *IN15 = *OFF AND                        BUG22797
     C                             *IN75 = *OFF                                             BUG22797
     C                   EVAL      WScrn = 'U'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send Message to Screen                              *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
 
      ** Call screen message handler.
 
     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    PMsgF
     C                   PARM                    PMsgId
     C                   PARM                    PMsgD
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisp - Display screen                                      *
      *                                                               *
      *****************************************************************
 
     C     SRDisp        BEGSR
 
      ** Write message subfile, details and footer screens.
 
     C                   TIME                    STIME
     C                   WRITE     SD000769C1
     C                   WRITE     SD000769F1                                               AR656294
     C                   WRITE     SD000769F0
     C**********         WRITE     SD000769F1                                               AR656294
 
      ** Read details screen.
 
     C                   READ      SD000769F0                             01
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off.
 
     C**********         MOVEA     '0000'        *IN(10)                                    BUG22797
     C                   MOVEA     '000000'      *IN(10)                                    BUG22797
     C                   EVAL      PReDsp = 'N'
 
      ** Initialize Work Fields                                                             BUG22797
     C                   EVAl      WTaxYr@ = *BLANKS                                        BUG22797
     C                   EVAl      WTaxYrF@ = *BLANKS                                       BUG22797
     C                   EVAl      WTaxYrT@ = *BLANKS                                       BUG22797
     C                   EVAl      WTaxYr# = *ZEROS                                         BUG22797
     C                   EVAl      WTaxYrF  = *ZEROS                                        BUG22797
     C                   EVAl      WTaxYrT  = *ZEROS                                        BUG22797
     C                   EVAL      YrNot# = *ZEROS                                          BUG22797
     C                   EVAL      CustNot# = *ZEROS                                        BUG22797
                                                                                            BUG22797
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTxYr - Validate Tax Year                                *
      *                                                               *
      *****************************************************************
     C     SRValTxYr     BEGSR
 
      ** Tax Year is Mandatory
 
     C                   IF        STAXYR = *BLANKS
                                                                                            BUG22797
     C                   SELECT                                                             BUG22797
                                                                                            BUG22797
      ** Tax Year is Mandatory                                                              BUG22797
     C                   WHEN      TAXYRF = *BLANKS  AND TAXYRT = *BLANKS                   BUG22797
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      PMsgId = 'USR4718'
     C                   EXSR      SRSndM
     C**********         ELSE                                                               BUG22797
 
      ** When input is tax year range                                                       BUG22797
     C                   OTHER                                                              BUG22797
     C                   EXSR      SRTAXYRF                                                 BUG22797
     C                   EXSR      SRTAXYRT                                                 BUG22797
                                                                                            BUG22797
     C                   ENDSL                                                              BUG22797
                                                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** Tax Year inputted by user                                                          BUG22797
     C                   IF        STAXYR <> *BLANKS AND                                    BUG22797
     C                             *IN75 = *OFF                                             BUG22797
                                                                                            BUG22797
     C                   SELECT                                                             BUG22797
                                                                                            BUG22797
      ** Tax Year input must either be Tax Year only OR Tax year Range.                     BUG22797
     C                   WHEN      TAXYRF <> *BLANKS  OR  TAXYRT <> *BLANKS                 BUG22797
     C                   EVAL      PMsgID = 'SDC0001'                                       BUG22797
     C                   MOVEA     '111'         *IN(10)                                    BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
                                                                                            BUG22797
      ** Tax Year must be numeric
 
     C**********         MOVE      STAXYR        WTaxYr#                                    BUG22797
     C**********         MOVE      WTaxYr#       WTaxYr@                                    BUG22797
     C**********         IF        WtaxYr@ <> STAXYR                                        BUG22797
     C                   WHEN      TAXYRF =  *BLANKS  AND TAXYRT = *BLANKS                  BUG22797
     C     WStr1         CHECK     STAXYR:1      YrNot#                                     BUG22797
                                                                                            BUG22797
     C                   IF        %FOUND                                                   BUG22797
     C                   EVAL      *IN10 = *ON
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C**********         EVAL      PMsgId = 'USR4719'                                       BUG22797
     C                   EVAL      PMsgId = 'USR8250'                                       BUG22797
     C                   EXSR      SRSndM
                                                                                            BUG22797
     C                   ELSE
 
      ** Tax Year must be from 2000 - 2099
 
     C                   MOVE      STAXYR        WTaxYr#                                    BUG22797
     C                   IF        WTaxYr# < 2000 or WTaxYr# > 2099
 
     C                   EVAL      *IN10 = *ON
     C                   EVAL      PMsgId = 'USR4719'
     C                   EXSR      SRSndM
      *                                                                                    BUG24280A
     C                   ELSE                                                              BUG24280A
      *                                                                                    BUG24280A
      ** Check this year history file exists                                               BUG24280A
      *                                                                                    BUG24280A
     C                   MOVE      STAXYR        WkTesty                                   BUG24280A
     C**********         MOVE      BJEYD         PZDayNo                          BUG24280A BUG24767
     C                   MOVE      WYrEndP       PZDayNo                                    BUG24767
      *                                                                                    BUG24280A
     C                   CALL      'ZDATE2'                                                BUG24280A
     C                   PARM                    PZDayNo                                   BUG24280A
     C                   PARM                    BJDFIN                                    BUG24280A
     C                   PARM      *ZEROS        PZDate                                    BUG24280A
     C                   PARM      *BLANKS       PZADate                                   BUG24280A
      *                                                                                    BUG24280A
     C                   IF        %SUBST(PZADate:6:2) <>                                  BUG24280A
     C                                   %SUBST(STAXYR:3:2)                                BUG24280A
      *                                                                                    BUG24280A
     C                   CALL      'SDC000797'                                             BUG24280A
     C                   PARM                    WkTesty                                   BUG24280A
     C                   PARM      *BLANKS       WkRtcd                                    BUG24280A
      *                                                                                    BUG24280A
     C                   IF        WkRtcd <> *BLANKS                                       BUG24280A
      *                                                                                    BUG24280A
     C                   EVAL      *IN10 = *ON                                             BUG24280A
     C                   EVAL      *IN75 = *ON                                             BUG24280A
     C                   EVAL      PMsgId = 'USR8252'                                      BUG24280A
     C                   EXSR      SRSndM                                                  BUG24280A
      *                                                                                    BUG24280A
     C                   ENDIF                                                             BUG24280A
      *                                                                                    BUG24280A
     C                   ENDIF                                                             BUG24280A
      *                                                                                    BUG24280A
     C                   ENDIF
                                                                                            BUG22797
     C                   ENDIF
                                                                                            BUG22797
     C                   ENDSL                                                              BUG22797
                                                                                            BUG22797
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG22797
      *                                                               *                     BUG22797
      *  SRTaxYrF - Validate Tax Year From                            *                     BUG22797
      *                                                               *                     BUG22797
      *****************************************************************                     BUG22797
     C     SRTaxYrF      BEGSR                                                              BUG22797
                                                                                            BUG22797
      ** If Tax year From is blanks and Tax year To is entered                              BUG22797
      ** -> error. The Two tax years must be entered.                                       BUG22797
                                                                                            BUG22797
     C                   IF        TAXYRF = *BLANKS AND                                     BUG22797
     C                             TAXYRT <> *BLANKS                                        BUG22797
                                                                                            BUG22797
     C                   EVAL      *IN11 = *ON                                              BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      PMsgId = 'USR8316'                                       BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** If user inputted a tax period                                                      BUG22797
                                                                                            BUG22797
     C                   IF        TAXYRF <> *BLANKS                                        BUG22797
                                                                                            BUG22797
      ** Tax From must be numeric                                                           BUG22797
     C                   MOVE      WTaxYrF       WTaxYrF@                                   BUG22797
     C     WStr1         CHECK     TAXYRF:1      YrNot#                                     BUG22797
                                                                                            BUG22797
     C                   IF        %FOUND                                                   BUG22797
     C                   EVAL      *IN11 = *ON                                              BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      PMsgId = 'USR8250'                                       BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   LeaveSR                                                            BUG22797
                                                                                            BUG22797
     C                   ELSE                                                               BUG22797
                                                                                            BUG22797
      ** Tax Year must be from 2000 - 2099                                                  BUG22797
                                                                                            BUG22797
     C                   MOVE      TAXYRF        WTaxYrF                                    BUG22797
     C                   IF        WTaxYrF < 2000 or WTaxYrF > 2099                         BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      *IN11 = *ON                                              BUG22797
     C                   EVAL      PMsgId = 'USR4719'                                       BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDIF                                                              BUG22797
      *                                                                                    BUG24280A
      ** Check this year history file exists                                               BUG24280A
      *                                                                                    BUG24280A
     C                   MOVE      WTaxYrF       WkTesty                                   BUG24280A
     C**********         MOVE      BJEYD         PZDayNo                          BUG24280A BUG24767
     C                   MOVE      WYrEndP       PZDayNo                                    BUG24767
      *                                                                                    BUG24280A
     C                   CALL      'ZDATE2'                                                BUG24280A
     C                   PARM                    PZDayNo                                   BUG24280A
     C                   PARM                    BJDFIN                                    BUG24280A
     C                   PARM      *ZEROS        PZDate                                    BUG24280A
     C                   PARM      *BLANKS       PZADate                                   BUG24280A
      *                                                                                    BUG24280A
     C                   IF        %SUBST(PZADate:6:2) <>                                  BUG24280A
     C                                   %SUBST(TAXYRF:3:2)                                BUG24280A
      *                                                                                    BUG24280A
     C                   CALL      'SDC000797'                                             BUG24280A
     C                   PARM                    WkTesty                                   BUG24280A
     C                   PARM      *BLANKS       WkRtcd                                    BUG24280A
      *                                                                                    BUG24280A
     C                   IF        WkRtcd <> *BLANKS                                       BUG24280A
      *                                                                                    BUG24280A
     C                   EVAL      *IN75 = *ON                                             BUG24280A
     C                   EVAL      *IN11 = *ON                                             BUG24280A
     C                   EVAL      PMsgId = 'USR8252'                                      BUG24280A
     C                   EXSR      SRSndM                                                  BUG24280A
      *                                                                                    BUG24280A
     C                   ENDIF                                                             BUG24280A
      *                                                                                    BUG24280A
     C                   ENDIF                                                             BUG24280A
                                                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDSR                                                              BUG22797
                                                                                            BUG22797
      *****************************************************************                     BUG22797
      /EJECT                                                                                BUG22797
      *****************************************************************                     BUG22797
      *                                                               *                     BUG22797
      *  SRTaxYrT - Validate Tax Year To                              *                     BUG22797
      *                                                               *                     BUG22797
      *****************************************************************                     BUG22797
     C     SRTaxYrT      BEGSR                                                              BUG22797
                                                                                            BUG22797
     ** If Tax Year To is blank and Tax Year From is entered                                BUG22797
     ** -> Error. The 2 Tax Years must be entered or none.                                  BUG22797
     C                   IF        TAXYRT = *BLANKS AND                                     BUG22797
     C                             TAXYRF <> *BLANKS                                        BUG22797
     C                   EVAL      *IN12 = *ON                                              BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      PMSGID = 'USR8316'                                       BUG22797
     C                   EXSR      SRSNDM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** If user inputted a tax period                                                      BUG22797
                                                                                            BUG22797
     C                   IF        TAXYRT <> *BLANKS                                        BUG22797
     C                                                                                      BUG22797
      ** Tax must be numeric                                                                BUG22797
     C     WStr1         CHECK     TaxYrT:1      YrNot#                                     BUG22797
                                                                                            BUG22797
     C                   IF        %FOUND                                                   BUG22797
     C                   EVAL      *IN12 = *ON                                              BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      PMsgId = 'USR8250'                                       BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   LeaveSR                                                            BUG22797
                                                                                            BUG22797
     C                   ELSE                                                               BUG22797
                                                                                            BUG22797
      ** Tax Year must be from 2000 - 2099                                                  BUG22797
                                                                                            BUG22797
     C                   MOVE      TAXYRT        WTaxYrT                                    BUG22797
     C                   IF        WTaxYrT < 2000 or WTaxYrT > 2099                         BUG22797
     C                   EVAL      *IN12 = *ON                                              BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      PMsgId = 'USR4719'                                       BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   LeaveSR                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** Year To must be greater than Year From                                             BUG22797
     C                   IF        WTaxYrF > WTaxYrT                                        BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      *IN12 = *ON                                              BUG22797
     C                   EVAL      PMsgId = 'USR8315'                                       BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   LEAVESR                                                           BUG24280A
     C                   ENDIF                                                              BUG22797
      *                                                                                    BUG24280A
      ** Check this year history file exists                                               BUG24280A
      *                                                                                    BUG24280A
     C                   MOVE      WTaxYrT       WkTesty                                   BUG24280A
     C**********         MOVE      BJEYD         PZDayNo                          BUG24280A BUG24767
     C                   MOVE      WYrEndP       PZDayNo                                    BUG24767
      *                                                                                    BUG24280A
     C                   CALL      'ZDATE2'                                                BUG24280A
     C                   PARM                    PZDayNo                                   BUG24280A
     C                   PARM                    BJDFIN                                    BUG24280A
     C                   PARM      *ZEROS        PZDate                                    BUG24280A
     C                   PARM      *BLANKS       PZADate                                   BUG24280A
      *                                                                                    BUG24280A
     C                   IF        %SUBST(PZADate:6:2) <>                                  BUG24280A
     C                                   %SUBST(TAXYRT:3:2)                                BUG24280A
      *                                                                                    BUG24280A
     C                   CALL      'SDC000797'                                             BUG24280A
     C                   PARM                    WkTesty                                   BUG24280A
     C                   PARM      *BLANKS       WkRtcd                                    BUG24280A
      *                                                                                    BUG24280A
     C                   IF        WkRtcd <> *BLANKS                                       BUG24280A
      *                                                                                    BUG24280A
     C                   EVAL      *IN75 = *ON                                             BUG24280A
     C                   EVAL      *IN12 = *ON                                             BUG24280A
     C                   EVAL      PMsgId = 'USR8252'                                      BUG24280A
     C                   EXSR      SRSndM                                                  BUG24280A
      *                                                                                    BUG24280A
     C                   ENDIF                                                             BUG24280A
      *                                                                                    BUG24280A
     C                   ENDIF                                                             BUG24280A
                                                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDSR                                                              BUG22797
                                                                                            BUG22797
      *****************************************************************                     BUG22797
      /EJECT                                                                                BUG22797
      *****************************************************************                     BUG22797
      *                                                               *                     BUG22797
      *  SRCust - Validate Customer Number                            *                     BUG22797
      *                                                               *                     BUG22797
      *  Called by: MAIN                                              *                     BUG22797
      *                                                               *                     BUG22797
      *  Calls: SRSndM                                                *                     BUG22797
      *                                                               *                     BUG22797
      *****************************************************************                     BUG22797
                                                                                            BUG22797
     C     SRCust        BEGSR                                                              BUG22797
                                                                                            BUG22797
      ** Check if customer exists                                                           BUG22797
                                                                                            BUG22797
     C                   EVAL      WkResul = %SCAN('?':SCUSTN)                              BUG22797
                                                                                            BUG22797
     C                   EVAL      *IN77 = *OFF                                             BUG22797
     C                   IF        WkResul >=  1                                            BUG22797
     C                   EVAL      *IN77 = *ON                                              BUG22797
     C                   MOVE      *BLANKS       SCUSTN                                     BUG22797
     C                   MOVEL     '?'           SCUSTN                                     BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   CALL      'AOCUSTR0'                                               BUG22797
     C                   PARM      *BLANKS       PRtcd                                      BUG22797
     C                   PARM      '*KEY   '     POptn                                      BUG22797
     C                   PARM      SCUSTN        PKey10                                     BUG22797
     C                   PARM      *BLANKS       PKyst                                      BUG22797
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG22797
                                                                                            BUG22797
     C                   IF        PRtcd <> *BLANKS                                         BUG22797
     C                   EVAL      PMsgId = 'SDM0113'                                       BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      *IN13 = *ON                                              BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   LEAVESR                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   IF        *IN77 = *ON                                              BUG22797
     C                   MOVEL     BBCUST        SCUSTN                                     BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ***The*selected*customer*must*exist*in*the*History*                          BUG22797 BUG24574
      ***header*file*                                                              BUG22797 BUG24574
      ***Retrieve*the*history*file*if*exist*(indicator*28)*                        BUG22797 BUG24574
                                                                                            BUG22797
     C**********         IF        *IN10 = *OFF                                    BUG22797 BUG24574
     C**********         EVAL      WkCmd = ArrCmd(1)                               BUG22797 BUG24574
     C**********         CALL      'QCMDEXC'                                       BUG22797 BUG24574
     C**********         PARM                    WkCmd                             BUG22797 BUG24574
     C**********         PARM      WLen          WkLen                             BUG22797 BUG24574
     C**********         ENDIF                                                     BUG22797 BUG24574
                                                                                            BUG22797
      ** The selected customer must exist in the Int Payment Hist File                      BUG24574
                                                                                            BUG24574
     C                   OPEN      SDINPHL1                                                 BUG22797
                                                                                            BUG22797
     C                   MOVE      SCUSTN        WkScustn                                   BUG22797
     C     WkScustn      CHAIN     SDINPHL1                                                 BUG22797
     C                   IF        NOT %FOUND(SDINPHL1)                                     BUG22797
     C                   EVAL      PMsgId = 'USR8246'                                       BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      *IN13 = *ON                                              BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   CLOSE     SDINPHL1                                                 BUG22797
                                                                                            BUG22797
     C**********         IF        *IN10 = *OFF                                    BUG22797 BUG24574
     C**********         MOVEA     ArrCmd(2)     WkCmd                             BUG22797 BUG24574
     C**********         CALL      'QCMDEXC'                                       BUG22797 BUG24574
     C**********         PARM                    WkCmd                             BUG22797 BUG24574
     C**********         PARM      WLen          WkLen                             BUG22797 BUG24574
     C**********         ENDIF                                                     BUG22797 BUG24574
                                                                                            BUG22797
     C                   ENDSR                                                              BUG22797
                                                                                            BUG22797
      *****************************************************************                     BUG22797
     C/EJECT                                                                                BUG22797
      *****************************************************************                     BUG22797
      *                                                               *                     BUG22797
      *  SRCustf - Validate Customer Number from                      *                     BUG22797
      *                                                               *                     BUG22797
      *  Called by: MAIN                                              *                     BUG22797
      *                                                               *                     BUG22797
      *  Calls:   SRSndM                                              *                     BUG22797
      *                                                               *                     BUG22797
      *****************************************************************                     BUG22797
     C     SRCustf       BEGSR                                                              BUG22797
                                                                                            BUG22797
      ** If Customer Number from is blank and customer to is entered                        BUG22797
      ** -> error The 2 customers must be entered or none                                   BUG22797
                                                                                            BUG22797
     C                   IF        SCUSTF = *BLANKS AND                                     BUG22797
     C                             SCUSTT <> *BLANKS                                        BUG22797
                                                                                            BUG22797
     C                   EVAL      PMsgId = 'USR8253'                                       BUG22797
     C                   EVAL      *IN14 = *ON                                              BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   IF        SCUSTF <> *BLANKS                                        BUG22797
                                                                                            BUG22797
      ** Check if customer from  exists                                                     BUG22797
                                                                                            BUG22797
     C                   EVAL      WkResul = %SCAN('?':SCUSTF)                              BUG22797
                                                                                            BUG22797
     C                   EVAL      *IN77 = *OFF                                             BUG22797
     C                   IF        WkResul >= 1                                             BUG22797
     C                   EVAL      *IN77 = *ON                                              BUG22797
     C                   MOVE      *BLANKS       SCUSTF                                     BUG22797
     C                   MOVEL     '?'           SCUSTF                                     BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   CALL      'AOCUSTR0'                                               BUG22797
     C                   PARM      *BLANKS       PRtcd                                      BUG22797
     C                   PARM      '*KEY   '     POptn                                      BUG22797
     C                   PARM      SCUSTF        PKey10                                     BUG22797
     C                   PARM      *BLANKS       PKyst                                      BUG22797
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG22797
                                                                                            BUG22797
     C                   IF        *IN77 = *ON                                              BUG22797
     C                   MOVEL     BBCUST        SCUSTF                                     BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** Check for embedded blanks and special character in field                           BUG22797
     C     WStr2         CHECK     SCUSTF:1      CustNot#                                   BUG22797
                                                                                            BUG22797
     C                   IF        %FOUND                                                   BUG22797
     C                   EVAL      *IN14 = *ON                                              BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      PMsgID = 'USR8314'                                       BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDSR                                                              BUG22797
                                                                                            BUG22797
      *****************************************************************                     BUG22797
     C/EJECT                                                                                BUG22797
      *****************************************************************                     BUG22797
      *                                                               *                     BUG22797
      *  SRCustt     Validate Customer Number to                      *                     BUG22797
      *                                                               *                     BUG22797
      *  Called by: MAIN                                              *                     BUG22797
      *                                                               *                     BUG22797
      *  Calls: SRSndM                                                *                     BUG22797
      *                                                               *                     BUG22797
      *****************************************************************                     BUG22797
                                                                                            BUG22797
     C     SRCustt       BEGSR                                                              BUG22797
                                                                                            BUG22797
      ** If Customer Number to is blank and customer from is entered                        BUG22797
      ** -> error The 2 customers must be entered or none                                   BUG22797
                                                                                            BUG22797
     C                   IF        SCUSTT = *BLANKS AND                                     BUG22797
     C                             SCUSTF <> *BLANKS AND                                    BUG22797
     C                             *IN14 = *OFF                                             BUG22797
     C                   EVAL      PMsgId = 'USR8253'                                       BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      *IN15 = *ON                                              BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   IF        SCUSTT <> *BLANKS                                        BUG22797
                                                                                            BUG22797
      ** Check if customer to exists                                                        BUG22797
                                                                                            BUG22797
     C                   EVAL      WkResul = %SCAN('?':SCUSTT)                              BUG22797
     C                   EVAL      *IN77 = *OFF                                             BUG22797
                                                                                            BUG22797
     C                   IF        WkResul >= 1                                             BUG22797
     C                   EVAL      *IN77 = *ON                                              BUG22797
     C                   MOVE      *BLANKS       SCUSTT                                     BUG22797
     C                   MOVEL     '?'           SCUSTT                                     BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   CALL      'AOCUSTR0'                                               BUG22797
     C                   PARM      *BLANKS       PRtcd                                      BUG22797
     C                   PARM      '*KEY   '     POptn                                      BUG22797
     C                   PARM      SCUSTT        PKey10                                     BUG22797
     C                   PARM      *BLANKS       PKyst                                      BUG22797
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG22797
                                                                                            BUG22797
     C                   IF        *IN77 = *ON                                              BUG22797
     C                   MOVEL     BBCUST        SCUSTT                                     BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** Check for embedded blanks and special character in field                           BUG22797
     C     WStr2         CHECK     SCUSTT:1      CustNot#                                   BUG22797
                                                                                            BUG22797
     C                   IF        %FOUND                                                   BUG22797
     C                   EVAL      *IN15 = *ON                                              BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      PMsgID = 'USR8314'                                       BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   LEAVESR                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** Customer to must be greater or equal to Customer from                              BUG22797
                                                                                            BUG22797
     C                   IF        SCUSTT < SCUSTF                                          BUG22797
     C                   EVAL      PMsgId = 'USR8254'                                       BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EVAL      *IN15 = *ON                                              BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDSR                                                              BUG22797
                                                                                            BUG22797
      *****************************************************************                     BUG22797
      /EJECT                                                                                BUG22797
      *****************************************************************                     BUG22797
      *                                                               *                     BUG22797
      *  SRVals - one selection allowed                               *                     BUG22797
      *                                                               *                     BUG22797
      *  Called by: MAIN                                              *                     BUG22797
      *                                                               *                     BUG22797
      *  Calls: SRSndM                                                *                     BUG22797
      *                                                               *                     BUG22797
      *****************************************************************                     BUG22797
                                                                                            BUG22797
     C     SRVals        BEGSR                                                              BUG22797
                                                                                            BUG22797
     C                   Z-ADD     *ZEROS        WkCts                                      BUG22797
                                                                                            BUG22797
      ** Customer Number and Customer Range must not have an input at the same time.        BUG22797
                                                                                            BUG22797
     C                   IF        SCUSTN <> *BLANKS                                        BUG22797
     C                   EVAL      WkCts = WkCts + 1                                        BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   IF        SCUSTF <> *BLANKS OR                                     BUG22797
     C                             SCUSTT <> *BLANKS                                        BUG22797
     C                   EVAL      WkCts = WkCts + 1                                        BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** Only One selection allowed for Customer Number                                     BUG22797
                                                                                            BUG22797
     C                   IF        WkCts > 1                                                BUG22797
     C                   EVAL      PMsgID = 'SDC0001'                                       BUG22797
     C                   MOVEA     '111'         *IN(13)                                    BUG22797
     C                   EVAL      *IN75 = *ON                                              BUG22797
     C                   EXSR      SRSndM                                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   ENDSR                                                              BUG22797
                                                                                            BUG22797
      *****************************************************************                     BUG22797
     C/EJECT                                                                                BUG22797
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
     C                   PARM                    PAct
     C                   PARM                    PCmd
 
      ** Access bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     1             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *                                                                                     BUG24767
      ** Access location code                                                               BUG24767
      *                                                                                     BUG24767
     C                   CALL      'AOLOCNR0'                                               BUG24767
     C                   PARM      *BLANKS       PRtcd                                      BUG24767
     C                   PARM      '*KEY'        POptn                                      BUG24767
     C                   PARM      BJSLCD        PLoc                                       BUG24767
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG24767
      *                                                                                     BUG24767
      ** Database error                                                                     BUG24767
      *                                                                                     BUG24767
     C                   IF        PRtcd <> *BLANKS                                         BUG24767
     C     *LOCK         IN        LDA                                                      BUG24767
     C                   EVAL      DBKey = PLoc                                             BUG24767
     C                   EVAL      DBFile = 'SDLOCNPD'                                      BUG24767
     C                   Z-ADD     2             DBase                                      BUG24767
     C                   OUT       LDA                                                      BUG24767
     C                   EXSR      *PSSR                                                    BUG24767
     C                   ENDIF                                                              BUG24767
      *                                                                                     BUG24767
      ** Access country codes                                                               BUG24767
      *                                                                                     BUG24767
     C                   CALL      'AOCTRYR0'                                               BUG24767
     C                   PARM      *BLANKS       PRtcd                                      BUG24767
     C                   PARM      '*KEY'        POptn                                      BUG24767
     C                   PARM      DVCNCD        PCtry                                      BUG24767
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      BUG24767
      *                                                                                     BUG24767
      ** Database error                                                                     BUG24767
      *                                                                                     BUG24767
     C                   IF        PRtcd <> *BLANKS                                         BUG24767
     C     *LOCK         IN        LDA                                                      BUG24767
     C                   EVAL      DBKey = PCtry                                            BUG24767
     C                   EVAL      DBFile = 'SDCTRYPD'                                      BUG24767
     C                   Z-ADD     3             DBase                                      BUG24767
     C                   OUT       LDA                                                      BUG24767
     C                   EXSR      *PSSR                                                    BUG24767
      *                                                                                     BUG24767
      ** Retrieve end of tax year                                                           BUG24767
      *                                                                                     BUG24767
     C                   ELSE                                                               BUG24767
     C                   IF        A4ETXY <> *ZERO                                          BUG24767
     C     2             SUBST     BJMRDT:6      WYear                                      BUG24767
     C                   MOVE      WYear         WYearP                                     BUG24767
     C                   MOVE      WYearP        WYrEnd                                     BUG24767
     C                   MOVEL     A4ETXY        WYrEnd                                     BUG24767
     C                   CALLB     'ZDATE1'                                                 BUG24767
     C                   PARM                    WYrEnd                                     BUG24767
     C                   PARM      *ZEROS        PZDAYNO                                    BUG24767
     C                   PARM                    BJDFIN                                     BUG24767
     C                   PARM      *BLANKS       PERR                                       BUG24767
     C                   Z-ADD     PZDAYNO       WYrEndP                                    BUG24767
     C                   IF        WYrEndP < BJRDNB                                         BUG24767
     C                   ADD       1             WYearP                                     BUG24767
     C                   MOVE      WYearP        WYrEnd                                     BUG24767
     C                   CALLB     'ZDATE1'                                                 BUG24767
     C                   PARM                    WYrEnd                                     BUG24767
     C                   PARM      *ZEROS        PZDAYNO                                    BUG24767
     C                   PARM                    BJDFIN                                     BUG24767
     C                   PARM      *BLANKS       PERR                                       BUG24767
     C                   Z-ADD     PZDAYNO       WYrEndP                                    BUG24767
     C                   ENDIF                                                              BUG24767
     C                   ENDIF                                                              BUG24767
     C                   ENDIF                                                              BUG24767
                                                                                            BUG24767
     C                   EVAL      WScrn = 'P'
 
     C                   EVAL      PMsgf = 'GBSDUSRMSG'
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
 
      ** Clear fields.
 
     C                   CLEAR                   POutFlds
     C                   CLEAR                   STAXYR
 
      ** Message subfile control and program queue initialisation.
 
     C                   MOVE      *ON           *IN25
     C                   MOVEL     '*'           SPGM
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Below values inserted by BUG22797 were deleted by BUG24574                         BUG24574
      *  0382.00 **  ArrCmd (2)                                                             BUG24574
      *  0383.00 OVRDBF SDINPHL1 SDINPHL1                                                   BUG24574
      *  0384.00 DLTOVR SDINPHL1                                                            BUG24574
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  ArrChk (2)
0123456789
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
