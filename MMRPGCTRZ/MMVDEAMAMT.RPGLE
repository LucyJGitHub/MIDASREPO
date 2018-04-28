     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Amount (Deal Amendmnts)')            *
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVDEAMAMT - Validate Amount                                 *
      *               (for Deal Amendment processing)                 *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Deal Amendment Amount and confirms if valid.      *
      *             If it is valid the 10A return code will be        *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. AR704846           Date 15Feb11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3735            Date 20Jul04               *
      *                 CDL017             Date 05Mar03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 21Oct98               *
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR704846 - Amend program to show warning message for blank   *
      *             penalty fee. (Child artifact: AR704847)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3735- Should be able to enter early maturity deal with    *
      *           no penalty amount                                   *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  CGL011 - Collateral Processing for Midas                     *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP004 - SR #ZQ should be conditioned on action code, as in  *
      *           MM0028.                                             *
      *         - Move set up of value date work field from *INZSR    *
      *           as it is never updated on subsequent calls to module*
      *  CAP002 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
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
 
     D INFDS           DS
     D**  Data structure for file status of MM deals file.
     D*
     D @DEAM         E DS                  EXTNAME(MMDEAMPP)
     D  @DMVYR                51     52
     D  @DMVMT                53     54
     D  @DMVDY                55     56
 
     D                 DS
     D**  Data structure for convertion of YYMMDD to DDMMYY
     D  @DMVDT                 1      6
     D  @DMVD                  1      2
     D  @DMVM                  3      4
     D  @DMVY                  5      6
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
 
      ** Deal Amendment Type received as a paramater
     D DDMTYP          S              2A
 
      ** Deal Number received as a paramater
     D DDDLNO          S              6A
 
      ** Deal Amendment Amount received as a parameter
     D DDAMNP          S             15A
 
      ** Deal Amendment Value Date received as a parameter
     D DDVDAT          S              6A
 
      ** Deal Number received as a paramater
     D DDDS38          S              3A
 
      ** Action Code received as a paramater                                    CAP004
     D DDACTN          S              1A                                        CAP004
 
      ** Customer from original deal                                            CDL006  174313
     D*H@CNUM**********S              6  0 IMPORT                               CDL006  174313
     D*H@CNUM***       S              6  0                                             174313 CSD027
     D H@CNUM          S              6A                                                17431 CSD027
                                                                                CDL006  174313
      ** Currency from original deal                                            CDL006  174313
     D*H@CCY***********S              3A   IMPORT                               CDL006  174313
     D H@CCY           S              3A                                                174313
                                                                                CDL006  174313
      ** Deal Type from original deal                                           CDL006  174313
     D*H@MTYP**********S              2A   IMPORT                               CDL006  174313
     D H@MTYP          S              2A                                                174313
                                                                                CDL006  174313
      ** Charges on Principal (from SDDEALPD)                                   CDL006  174313
     D*B@CHPC**********S              1A   IMPORT                               CDL006  174313
     D B@CHPC          S              1A                                                174313
                                                                                CDL006  174313
      ** Deal Amount from original deal received as a parameter
     D H@AMNP          S             15  0
 
      ** Warning message code 1 received as a parameter                                       CGL011
     D WMSGID1         S                   LIKE(#MSGID)                                       CGL011
                                                                                              CGL011
      ** Currency number of decimal places (from SDCURRPD)
      ** received as a parameter
     D A6NBDP          S              1S 0
 
      ** Decimal separator (from SDDEALPD) received as a parameter
     D BNDCSP          S              1A
 
      ** Date Format Indicator (from SDBANKPD) received as a parameter
     D BJDFIN          S              1A
 
      ** Currency Field in error flag received as a parameter
     D DDCcyOK         S              1A
 
      ** Index of errors accumulated from previous modules
      ** received as a parameter
     D Idx             S              3  0
 
      ** Deal Amount passed as a parameter
     D IGAMNP          S             15  0
                                                                                CDL006
      ** Deal Fiduciary Charge Code passed as a return parameter                CDL006
     D IGFCGC          S              2                                         CDL006
                                                                                CDL006
      ** Deal Fiduciary Charge Description passed as a return parameter         CDL006
     D IGFCGD          S             20                                         CDL006
                                                                                CDL006
      ** Deal Fiduciary Charge Amount passed as a return parameter              CDL006
     D IGFXGA          S             13  0                                      CDL006
 
      ** Base Rate received as a parameter                                                    CDL017
     D DDBSRT          S              2A                                                      CDL017
                                                                                              CDL017
      ** Rate/Spread received as a parameter                                                  CDL017
     D DDINTR          S             12A                                                      CDL017
 
      ** Fields used in call to Module ZA0840
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
      ** Amount calculation field
     D @@AMT           S             15  0
      ** Error code
     D @@ERCD          S              1  0
      ** Number of decimal places
     D @@IDP           S              3  0
      ** Number of integers
     D @@IINT          S              3  0
 
      ** Fields used in call to Module ZDATE1
 
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D Errorflag       S              1A
     D DDVDATN         S              5P 0
     D @DMVDTN         S              5P 0
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   WarnFound                                    CGL011
     C                   RESET                   WMsgid1                                      CGL011
     C                   RESET                   WarnGlobal                                   CGL011
      *
     C** Convert value date to Midas Day No                                     CAP004
     C                   MOVE      DDVDAT        DateIn                         CAP004
     C                   CALLB     'ZDATE1'                                     CAP004
     C                   PARM                    DateIn                         CAP004
     C                   PARM                    DaynoOut                       CAP004
     C                   PARM                    BJDFIN                         CAP004
     C                   PARM                    Errorflag                      CAP004
     C                   Z-ADD     DaynoOut      DDVDATN                        CAP004
 
     C*  *-----------------*
     C*  * Validate Amount *
     C*  *-----------------*
     C*
     C**  If deal type is PI or PD and amount has not been entered
     C**  then it is an error.
     C     DDMTYP        IFEQ      'PI'
     C     DDAMNP        ANDEQ     *BLANK
     C     DDMTYP        OREQ      'PD'
     C     DDAMNP        ANDEQ     *BLANK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0471'     Msgid1
     C                   END
     C*
     C**  If deal type is not PI or PD and amount has been entered
     C**  then it is an error.
     C     DDMTYP        IFNE      'PI'
     C     DDMTYP        ANDNE     'PD'
     C     DDMTYP        ANDNE     'EM'                                                       CDL017
     C     DDMTYP        ANDNE     *BLANKS
     C     DDAMNP        IFNE      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0472'     Msgid1
     C                   END
     C                   END
     C**********                                                                      CDL017 BUG3735
     C****If*deal type is EM and Penalty Fee or Rate/Spread or Base Rate              CDL017 BUG3735
     C****have not been entered then it is an error.                                  CDL017 BUG3735
     C*****DDMTYP        IFEQ      'EM'                                               CDL017 BUG3735
     C*****DDAMNP        ANDEQ     *BLANKS                                            CDL017 BUG3735
     C*****DDINTR        ANDEQ     *BLANKS                                            CDL017 BUG3735
     C*****DDBSRT        ANDEQ     *BLANKS                                            CDL017 BUG3735
     C**********         MOVE      'Y'           ErrorFound                           CDL017 BUG3735
     C**********         MOVEL     'MMM0344'     Msgid1                               CDL017 BUG3735
     C**********         ENDIF                                                        CDL017 BUG3735
     C*
      ** If deal type id EM and penalty fee is not entered, issue a                         AR704846
      ** warning message.                                                                   AR704846
     C     DDMTYP        IFEQ      'EM'                                                     AR704846
     C     DDAMNP        ANDEQ     *BLANKS                                                  AR704846
     C                   MOVEL     'MMM0691'     WMSGID1                                    AR704846
     C                   MOVE      'Y'           WarnFound                                  AR704846
     C                   ENDIF                                                              AR704846
      *                                                                                     AR704846
     C     DDCcyOK       IFNE      'N'
     C     ErrorFound    ANDNE     'Y'
     C     DDAMNP        ANDNE     *BLANK
     C*
     C**  Verify that the amount entered is valid numeric.
     C                   Z-ADD     A6NBDP        @@IDP
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDAMNP        @@ALPH
     C                   MOVE      'Y'           @@MTID            1
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeIn
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@Ercd
     C                   PARM                    @@Amt
     C                   PARM                    BNDCSP
      *
     C     @@Ercd        IFNE      0
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0144'     Msgid1
     C                   END
     C*
     C**If amendment type is 'PD' execute process 'Check deal amendment
     C** principle'   : MMP0082.
     C** Only necessary if -ve result is possible (INSERT OF PD)
     C     DDMTYP        IFEQ      'PD'
     C     DDAMNP        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'I'                                          CAP004
     C     Idx           ANDEQ     0
     C     ErrorFound    ANDNE     'Y'
     C*
     C**  Store this deam amount
     C                   Z-ADD     @@Amt         ThisDMAmt
     C                   EXSR      #ZQ
     C                   END
     C*
     C**If amendment type is 'PI' execute process 'Check deal amendment         CAP004
     C** principle'   : MMP0082.                                                CAP004
     C** Only necessary if -ve result is possible (DELETE OF PI)                CAP004
     C     DDMTYP        IFEQ      'PI'                                         CAP004
     C     DDAMNP        ANDNE     *BLANKS                                      CAP004
     C     DDACTN        ANDEQ     'D'                                          CAP004
     C     Idx           ANDEQ     0                                            CAP004
     C     ErrorFound    ANDNE     'Y'                                          CAP004
     C*                                                                         CAP004
     C**  Store this deam amount                                                CAP004
     C                   Z-ADD     @@Amt         ThisDMAmt                      CAP004
     C                   EXSR      #ZQ                                          CAP004
     C                   END                                                    CAP004
     C*                                                                         CAP004
     C**  If the amount is valid, set up the numeric amount for output
     C*
     C     ErrorFound    IFNE      'Y'
     C     DDAMNP        IFNE      *BLANK
     C                   Z-ADD     @@Amt         IGAMNP
     C                   MOVE      @@ALPH        DDAMNP
     C                   ELSE
     C                   Z-ADD     *ZERO         IGAMNP
     C                   END
     C                   END
                                                                                CDL006
      ** Calculate charges when Dealing ICD 'Charges on Principal Change        CDL006
      ** is set to 'Y' and related deal is a fiduciary taking and the           CDL006
      ** inserted deal amendment principal change is 'PI' or 'PD'               CDL006
                                                                                CDL006
     C                   If        (DDACTN = 'I') and                           CDL006
     C                             (DDMTYP = 'PI' or DDMTYP = 'PD') and         CDL006
     C                             (H@MTYP = 'DT' or H@MTYP = 'LT') and         CDL006
     C                             (B@CHPC = 'Y')                               CDL006
                                                                                CDL006
      ** Setup Parameters                                                       CDL006
                                                                                CDL006
     C                   ExSr      SrSetup                                      CDL006
                                                                                CDL006
     C                   CallB     'MMFIDTCHG'                                  CDL006
     C                   Parm                    #PGM             10            CDL006
     C                   Parm                    ActionCode        1            CDL006
     C                   Parm                    DealNo            6 0          CDL006
     C**********         Parm                    CustNo            6 0                 CDL006 CSD027
     C                   Parm                    CustNo            6                          CSD027
     C                   Parm                    DealCurrency      3            CDL006
     C                   Parm                    DealAmendAmt     13 0          CDL006
     C                   Parm                    ChargeCode        2            CDL006
     C                   Parm                    ChargeDesc       20            CDL006
     C                   Parm                    ChargeAmt        13 0          CDL006
     C                   Parm                    ReturnCode                     CDL006
                                                                                CDL006
     C     ReturnCode    IfNe      *Blanks                                      CDL006
     C     *Lock         In        LDA                                          CDL006
     C                   Move      'MMFIDTCHG'   DbFile                         CDL006
     C                   MoveL     DealNo        WDbKey1          12            CDL006
     C                   Move      CustNo        WDbKey1                        CDL006
     C                   MoveL     DealCurrency  WDbKey2           5            CDL006
     C                   Move      ChargeCode    WDbKey2                        CDL006
     C                   MoveL     WDbKey1       WDbKey3          17            CDL006
     C                   Move      WDbKey2       WDbKey3                        CDL006
     C                   MoveL     WDbKey3       DbKey                          CDL006
     C                   Z-Add     001           Dbase                          CDL006
     C                   MoveL     'MMVDEAMAMT'  DbPgm                          CDL006
     C                   Out       LDA                                          CDL006
     C                   ExSr      *PSSR                                        CDL006
     C                   Else                                                   CDL006
     C                   MoveL     ChargeCode    IGFCGC                         CDL006
     C                   MoveL     ChargeDesc    IGFCGD                         CDL006
     C                   Z-Add     ChargeAmt     IGFXGA                         CDL006
     C                   EndIf                                                  CDL006
     C                                                                          CDL006
     C                   EndIf                                                  CDL006
     C                   END
      *                                                                                       CDL017
     C     DDAMNP        IFEQ      *BLANK                                                     CDL017
     C                   Z-ADD     *ZERO         IGAMNP                                       CDL017
     C                   ENDIF                                                                CDL017
      *                                                                                       CGL011
      ** Perform further validation if CGL011 is switched on                                  CGL011
      *                                                                                       CGL011
     C     CGL011        IfEq      'Y'                                                        CGL011
     C     Collateral_IndAndeq     'Y'                                                        CGL011
      *                                                                                       CGL011
     C     DDMTYP        IfEq      'PD'                                                       CGL011
     C                   MoveL     'MMM0116'     WMSGID1                                      CGL011
     C                   Move      'Y'           WarnFound                                    CGL011
     C                   EndIf                                                                CGL011
      *                                                                                       CGL011
     C                   EndIf                                                                CGL011
     C*
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C*
      ** If errors or warnings were found, set the return code appropriately                  CGL011
                                                                                              CGL011
     C                   SELECT                                                               CGL011
                                                                                              CGL011
     C                   WHEN      ErrorFound = 'Y' AND WarnFound    = 'N'                    CGL011
     C                   EVAL      RetCodeIn  = 'Error'                                       CGL011
     C                                                                                        CGL011
     C                   WHEN      WarnFound    = 'Y' AND ErrorFound = 'N'                    CGL011
     C                   EVAL      RetCodeIn  = 'Warning'                                     CGL011
                                                                                              CGL011
     C                   WHEN      ErrorFound = 'Y' AND WarnFound    = 'Y'                    CGL011
     C                   EVAL      RetCodeIn  = 'ErrAndWarn'                                  CGL011
                                                                                              CGL011
     C                   ENDSL                                                                CGL011
                                                                                              CGL011
     C                   RETURN
 
      *****************************************************************
      /EJECT                                                                    CDL006
      *****************************************************************         CDL006
      *                                                               *         CDL006
      *  SrSetup - Sets up Parameters for Fiduciary Takings Charges   *         CDL006
      *            Calculation.                                       *         CDL006
      *                                                               *         CDL006
      *  Called By: Main Processing                                   *         CDL006
      *                                                               *         CDL006
      *  Calls: None                                                  *         CDL006
      *                                                               *         CDL006
      *****************************************************************         CDL006
                                                                                CDL006
     C     SrSetup       BegSr                                                  CDL006
                                                                                CDL006
     C                   MoveL     'MMVDEAMAMT'  #PGM                           CDL006
     C                   MoveL     DDACTN        ActionCode                     CDL006
     C                   Move      DDDLNO        DealNo                         CDL006
     C**********         Z-Add     H@CNUM        CustNo                                CDL006 CSD027
     C                   Eval      CustNo = H@CNUM                                            CSD027
     C                   MoveL     H@CCY         DealCurrency                   CDL006
     C                   Z-Add     @@Amt         DealAmendAmt                   CDL006
     C                   MoveL     IGFCGC        ChargeCode                     CDL006
     C                   MoveL     IGFCGD        ChargeDesc                     CDL006
     C                   MoveL     *Zeros        ChargeAmt                      CDL006
     C                   Move      *Blank        ReturnCode                     CDL006
                                                                                CDL006
     C                   Endsr                                                  CDL006
      *****************************************************************         CDL006
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  #ZQ      - Check deal amendment principle                    *
     C*                                                               *
     C*****************************************************************
     C     #ZQ           BEGSR
     C*
     C** If deal amount is -ve make +ve for calculation
     C     H@AMNP        IFLT      0
     C                   Z-SUB     H@AMNP        H@AMNP
     C                   END
     C*
     C** Process all deams on file for this deal
     C*
     C                   Z-ADD     *LOVAL        KeyDealNo         6 0
     C                   MOVE      *LOVAL        KeyValDatD        2 0
     C                   MOVE      *LOVAL        KeyValDatM        2 0
     C                   MOVE      *LOVAL        KeyValDatY        4 0
     C                   MOVE      *LOVAL        KeySeqNum         3 0
     C                   MOVE      '0'           *IN74
     C                   MOVE      'N'           ErrorFound
     C                   MOVE      *ALL' '       DlnoOnFile        6
     C                   Z-ADD     *ZEROS        HNDA38
     C     @DMKY2        SETLL     MMLVDMLL
     C     *IN65         DOUEQ     '1'
     C     ErrorFound    OREQ      'Y'
     C                   READ      MMLVDMLL                               65
     C                   MOVE      HNDA38        DlnoOnFile
     C*
     C**  If a live record is found then a deam exists
     C**  for the deal number
     C     *IN65         IFEQ      '0'
     C     DlnoOnFile    ANDEQ     DDDLNO
     C*
     C**  Place value date from files into same sequence as display (DDMMYY)
     C                   MOVE      @DMVYR        @DMVY
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DMVMT        @DMVM
     C                   MOVE      @DMVDY        @DMVD
     C                   ELSE
     C                   MOVE      @DMVMT        @DMVD
     C                   MOVE      @DMVDY        @DMVM
     C                   END
     C*
     C** Convert to Midas Day No
     C                   MOVE      @DMVDT        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C                   Z-ADD     DaynoOut      @DMVDTN
     C*
     C** If DEAM amount is -ve make +ve for calculation
     C     HNAMNP        IFLT      0
     C                   Z-SUB     HNAMNP        HNAMNP
     C                   END
     C*
     C** If current transaction is an insert of a 'PD' & value date
     C** of current transaction is < value date of record read
     C** subtract amount from current transaction from deal amount
     C*
     C     DDMTYP        IFEQ      'PD'
     C     DDVDATN       ANDLT     @DMVDTN
     C     *IN74         ANDEQ     '0'
     C     H@AMNP        SUB       ThisDMAmt     H@AMNP
     C*
     C** Set on ind. to show calc. performed for current transaction
     C                   MOVE      '1'           *IN74
     C**
     C     H@AMNP        IFLT      *ZERO
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0295'     Msgid1
     C                   GOTO      #ZQ9
     C                   END
     C                   END
 
     C     DDMTYP        IFEQ      'PD'
     C*
     C     HNMTYP        IFEQ      'PD'
     C     H@AMNP        SUB       HNAMNP        H@AMNP
     C                   ELSE
     C     HNMTYP        IFEQ      'PI'
     C     H@AMNP        ADD       HNAMNP        H@AMNP
     C                   END
     C                   END
     C                   END
 
     C     H@AMNP        IFLT      *ZERO
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0295'     Msgid1
     C                   GOTO      #ZQ9
     C                   END
     C*
     C** If current transaction is a delete of a 'PI' & record read
     C** is record to be deleted ignore it
     C*
     C     DDMTYP        IFEQ      'PI'
     C*
     C** Place sequence number into alpha field for comparison
     C                   MOVE      *BLANKS       SeqNoAlpha
     C                   MOVE      HNDS38        SeqNoAlpha        3
     C*
     C     DDVDATN       IFNE      @DMVDTN
     C     SeqNoAlpha    ORNE      DDDS38
     C*
     C** If record read is PI add deam amount to deal principle
     C     HNMTYP        IFEQ      'PI'
     C     H@AMNP        ADD       HNAMNP        H@AMNP
     C                   END
     C                   END
     C** Move end to after check if PCPL >= 0.
     C*
     C** If read transaction is a 'PD' subtract deam amount
     C** from deal principle
     C     HNMTYP        IFEQ      'PD'
     C     H@AMNP        SUB       HNAMNP        H@AMNP
     C                   END
     C*
     C** New principle must be = or > 0.
     C     H@AMNP        IFLT      *ZERO
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0295'     Msgid1
     C                   GOTO      #ZQ9
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C**  If insert of a deam has not yet been subtracted from deal
     C**  principle calculate new principle.
     C     DDMTYP        IFEQ      'PD'
     C     ErrorFound    ANDNE     'Y'
     C     *IN74         ANDNE     '1'
     C*
     C     H@AMNP        SUB       ThisDMAmt     H@AMNP
     C*
     C     H@AMNP        IFLT      *ZERO
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0295'     Msgid1
     C                   END
     C                   END
     C*
     C     #ZQ9          ENDSR                                                  **#ZQ9**
      *****************************************************************
     C/EJECT
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDMTYP
     C                   PARM                    DDDLNO
     C                   PARM                    DDAMNP
     C                   PARM                    DDVDAT
     C                   PARM                    DDDS38
     C                   PARM                    DDACTN                         CAP004
     C                   PARM                    H@AMNP
     C                   PARM                    A6NBDP
     C                   PARM                    BNDCSP
     C                   PARM                    BJDFIN
     C                   PARM                    DDCcyOK
     C                   PARM                    Idx
     C                   PARM                    IGAMNP
     C                   PARM                    IGFCGC                         CDL006
     C                   PARM                    IGFCGD                         CDL006
     C                   PARM                    IGFXGA                         CDL006
     C                   Parm                    CGL011            1                          CGL011
     C                   Parm                    Collateral_Ind    1                          CGL011
     C                   Parm                    WMSGID1                                      CGL011
      ** Customer from original deal                                                          174313
     C                   PARM                    H@CNUM                                       174313
      ** Currency from original deal                                                          174313
     C                   PARM                    H@CCY                                        174313
      ** Deal Type from original deal                                                         174313
     C                   PARM                    H@MTYP                                       174313
      ** Charges on Principal (from S                                                         174313
     C                   PARM                    B@CHPC                                       174313
      ** Rate/Spread                                                                          CDL017
     C                   PARM                    DDINTR                                       CDL017
      ** Base Rate code                                                                       CDL017
     C                   PARM                    DDBSRT                                       CDL017
     C** Define work fields
     C     *LIKE         DEFINE    @@Amt         ThisDMAmt
 
     C** Key Lists.
     C     @DMKY2        KLIST
     C                   KFLD                    KeyDealNo
     C                   KFLD                    KeyValDatY
     C                   KFLD                    KeyValDatM
     C                   KFLD                    KeyValDatD
     C                   KFLD                    KeySeqNum
     C*
     C***Convert*value date to Midas Day No                                     CAP004
     C*******            MOVE      DDVDAT        DateIn                         CAP004
     C*******            CALLB     'ZDATE1'                                     CAP004
     C*******            PARM                    DateIn                         CAP004
     C*******            PARM                    DaynoOut                       CAP004
     C*******            PARM                    BJDFIN                         CAP004
     C*******            PARM                    Errorflag                      CAP004
     C*******            Z-ADD     DaynoOut      DDVDATN                        CAP004
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
