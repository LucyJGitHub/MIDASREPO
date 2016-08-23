     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Service Fees Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDBVL - Customer Service Fees Validation                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSFEEV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDSFEEPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDESFEEPD)
 
      ** Valid Transaction Details layout
     D ValidSFEE     E DS                  EXTNAME(SDVSFEEPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
 
      ** Define work field Access Pgm Return Code
     D  WUAPRC         S              7    Inz(*Blanks)
 
      ** Define work field Access obj dummy DS (76)
     D  WUFDY          S             76    Inz(*Blanks)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Work variables
     D I               S              3P 0
     D RespMode        S              1A
     D CSD008          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSFEEV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SDSFEEV003
 
      ** Validate Settlement Account
 
      /COPY WNCPYSRC,SDSFEEV004
     C                   EXSR      VSMACSR
      /COPY WNCPYSRC,SDSFEEV005
 
      ** Validate Hold Mail Indicator
 
      /COPY WNCPYSRC,SDSFEEV006
     C                   IF        CSD008 = 'N'
     C                   EXSR      VHMINSR
     C                   ENDIF
      /COPY WNCPYSRC,SDSFEEV007
 
      ** Validate Numbered A/c Indicator
 
      /COPY WNCPYSRC,SDSFEEV008
     C                   IF        CSD008 = 'N'
     C                   EXSR      VNAINSR
     C                   ENDIF
      /COPY WNCPYSRC,SDSFEEV009
 
      ** Validate Profit Centre
 
      /COPY WNCPYSRC,SDSFEEV010
     C                   IF        CSD008 = 'N'    AND
     C                             BKPRCU = 'Y' AND   BGN0ST = 'N'
     C                   EXSR      VPFCDSR
     C                   ENDIF
      /COPY WNCPYSRC,SDSFEEV011
 
      ** Validate Profit Centre for Numbered A/c Charges
 
      /COPY WNCPYSRC,SDSFEEV012
     C                   IF        CSD008 = 'N'    AND
     C                             BKPRCU = 'Y' AND   BGN0ST = 'Y'
     C                   EXSR      VPCACSR
     C                   ENDIF
      /COPY WNCPYSRC,SDSFEEV013
 
      ** Validate Profit Centre for Hold Mail
 
      /COPY WNCPYSRC,SDSFEEV014
     C                   IF        CSD008 = 'N'    AND
     C                             BKPRCU = 'Y' AND   BGN0ST = 'Y'
     C                   EXSR      VPCHMSR
     C                   ENDIF
      /COPY WNCPYSRC,SDSFEEV015
 
      ** Validate Vat on Service Fees
 
      /COPY WNCPYSRC,SDSFEEV016
     C                   IF        CSD008 = 'Y'
     C                   EXSR      VTAIFSR
     C                   ENDIF
      /COPY WNCPYSRC,SDSFEEV017
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
 
      /COPY WNCPYSRC,SDSFEEV018
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VSMACSR - Validate Settlement Account                        *
      *                                                               *
      *****************************************************************
 
     C     VSMACSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Settlement Account
 
     C                   CALLB     'SDVSMAC'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Settlement Account
 
     C                   PARM                    DDSMAC
 
      ** Settlement Branch
 
     C                   PARM                    DDSBCH
 
      ** Settlement Currency
 
     C                   PARM                    DDSCCY
 
      **Numbered a/c indicator
 
     C                   PARM                    DDNAIN
 
      **Hold Mail indicator
 
     C                   PARM                    DDHMIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Settlement Account -       OK
 
     C                   PARM                    DDSMACOK
 
      ** Settlement Branch -        OK
 
     C                   PARM                    DDSBCHOK
 
      ** Settlement Currency -      OK
 
     C                   PARM                    DDSCCYOK
 
      ** Settlement Branch
 
     C                   PARM                    SFSBCH
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VHMINSR - Validate Hold Mail Indicator                       *
      *                                                               *
      *****************************************************************
 
     C     VHMINSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Hold Mail Indicator
 
     C                   CALLB     'SDVHMIN'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Hold Mail Indicator
 
     C                   PARM                    DDHMIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Hold Mail Indicator                               - OK
 
     C                   PARM                    DDHMINOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNAINSR - Validate Number A/c Indicator                      *
      *                                                               *
      *****************************************************************
 
     C     VNAINSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Number A/c Indicator
 
     C                   CALLB     'SDVNAIN'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Number A/c Indicator
 
     C                   PARM                    DDNAIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Number A/c Indicator - OK
 
     C                   PARM                    DDNAINOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VPFCDSR - Validate Profit Centre                             *
      *                                                               *
      *****************************************************************
 
     C     VPFCDSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Profit Centre
 
     C                   CALLB     'SDVPFCD'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Profit Centre
 
     C                   PARM                    DDPFCD
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Profit Centre       - OK
 
     C                   PARM                    DDPFCDOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VPCACSR - Validate Profit Centre for Numbered A/c Charges    *
      *                                                               *
      *****************************************************************
 
     C     VPCACSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Profit Centre for Numbered A/c Charges
 
     C                   CALLB     'SDVPCAC'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Profit Centre for Numbered A/c Charges
 
     C                   PARM                    DDPCAC
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Profit Centre for Numbered A/c Charges       - OK
 
     C                   PARM                    DDPCACOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VPCHMSR - Validate Profit Centre for Hold Mail               *
      *                                                               *
      *****************************************************************
      *
     C     VPCHMSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Profit Centre for Hold Mail
 
     C                   CALLB     'SDVPCHM'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Profit Centre for Hold Mail
 
     C                   PARM                    DDPCHM
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Profit Centre for Hold Mail       - OK
 
     C                   PARM                    DDPCHMOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VTAIFSR - Validate Vat for Service Fees                      *
      *                                                               *
      *****************************************************************
 
     C     VTAIFSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Profit Centre for Service Fees
 
     C                   CALLB     'SDVTAIF'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Vat for Service Fees
 
     C                   PARM                    DDTAIF
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Vat for Service Fees       - OK
 
     C                   PARM                    DDTAIFOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module                                *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module                                *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Service Fees Details
 
     C                   PARM                    TrnDets
 
      ** Outputs
      ** Service Fees OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Service Fees layout (DS) from/to caller
 
     C                   PARM                    ValidSFEE
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
 
      ** Call access program AOSARDR0- determine if CSD008 is
      ** installed
 
     C                   CALL      'AOSARDR0'                           90
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     *IN90         IFEQ      '1'
      *
     C                   EVAL      DBKEY  = 'AOSARDR0'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBASE  =  002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD  <> *BLANKS AND
     C                             @RTCD  <> '*NRF   '
     C                   EVAL      DBKEY  = 'CSD008'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** CSD008 is installed
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD008
     C                   ELSE
     C                   MOVE      'N'           CSD008
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      *BLANK        DSFDY
 
      ** Access General Ledger Details
 
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      *BLANK        DSSDY
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
 
      /COPY WNCPYSRC,SDSFEEV019
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      **------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2007
