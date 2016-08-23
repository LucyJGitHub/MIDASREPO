     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('User Definition + Menu Items Details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SFAMUS1VL - User Definition + Menu Items Details Validation  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SFAMUSV001
 
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
 
      * Midas SD Modules Details from Access Program
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
     D**     RUNDAT data area.
     D**
     D RUNDAT          DS
     D  AGMRDT                 1      7
     D  AGRDNB                 8     10P 0
     D  AGSUC                 11     11
     D  AGDFF                 12     12
     D  AGMBIN                13     13
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SFAMUSPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SFEAMUSPD)
 
      ** Valid Transaction Details layout
     D ValidAMUS     E DS                  EXTNAME(SFVAMUSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
      ** SF Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(SFUSEXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SFAMUSV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SFAMUSV003
 
      *
      ** Validate User Profile Name
      /COPY WNCPYSRC,SFAMUSV004
     C                   EXSR      VUSER1SR
      /COPY WNCPYSRC,SFAMUSV005
      *
      ** Validate Security Level
      /COPY WNCPYSRC,SFAMUSV006
     C                   EXSR      VSECLSR
      /COPY WNCPYSRC,SFAMUSV007
      *
      ** Validate User Language Code
      /COPY WNCPYSRC,SFAMUSV008
     C                   EXSR      VMULTSR
      /COPY WNCPYSRC,SFAMUSV009
      *
      ** Validate User Department
      /COPY WNCPYSRC,SFAMUSV010
     C                   EXSR      VDPPTSR
      /COPY WNCPYSRC,SFAMUSV011
      *
      ** Validate Account Officer
      /COPY WNCPYSRC,SFAMUSV012
     C                   EXSR      VACFASR
      /COPY WNCPYSRC,SFAMUSV013
      *
      ** Validate User Default Branch
      /COPY WNCPYSRC,SFAMUSV014
     C                   EXSR      VDBRNSR
      /COPY WNCPYSRC,SFAMUSV015
      *
      ** Validate Perform Payment Authorisation
      /COPY WNCPYSRC,SFAMUSV016
     C                   EXSR      VPAUTSR
      /COPY WNCPYSRC,SFAMUSV017
      *
      ** Validate System Routing Officer
      /COPY WNCPYSRC,SFAMUSV018
     C                   EXSR      VROUFSR
      /COPY WNCPYSRC,SFAMUSV019
      *
      ** Validate Only If FRA/IRS module or Treasury Management is on
      *
     C     BGFIIN        IFEQ      'Y'
     C     BGTRMG        OREQ      'Y'
      *
      ** Validate Auto Refresh For User
      /COPY WNCPYSRC,SFAMUSV020
     C                   EXSR      VAURFSR
      /COPY WNCPYSRC,SFAMUSV021
      *
      ** Validate Refresh Period
      /COPY WNCPYSRC,SFAMUSV022
     C                   EXSR      VREFPSR
      /COPY WNCPYSRC,SFAMUSV023
      *
     C                   ENDIF
      *
      ** Validate COB User
      /COPY WNCPYSRC,SFAMUSV024
     C                   EXSR      VCOBUSR
      /COPY WNCPYSRC,SFAMUSV025
      *
      ** Validate Teller ID
      /COPY WNCPYSRC,SFAMUSV026
     C                   EXSR      VTLIDSR
      /COPY WNCPYSRC,SFAMUSV027
      *
      ** Validate Only If Securities Module is on
      *
     C     BGSECS        IFEQ      'Y'
      *
      ** Validate Entering Threshold Limit
      /COPY WNCPYSRC,SFAMUSV028
     C                   EXSR      VENTLSR
      /COPY WNCPYSRC,SFAMUSV029
      *
      ** Validate Approving Limit
      /COPY WNCPYSRC,SFAMUSV030
     C                   EXSR      VAUT1SR
      /COPY WNCPYSRC,SFAMUSV031
      *
      ** Validate Authorising Limit
      /COPY WNCPYSRC,SFAMUSV032
     C                   EXSR      VAUT2SR
      /COPY WNCPYSRC,SFAMUSV033
      *
     C                   ENDIF
      *
      ** Validate Choice of Report Output
      /COPY WNCPYSRC,SFAMUSV034
     C                   EXSR      VROUTSR
      /COPY WNCPYSRC,SFAMUSV035
      *
      ** Validate Directory ID
      /COPY WNCPYSRC,SFAMUSV036
     C                   EXSR      VDIRIDSR
      /COPY WNCPYSRC,SFAMUSV037
      *
      ** Validate Output Queue Name
      /COPY WNCPYSRC,SFAMUSV038
     C                   EXSR      VOUTQSR
      /COPY WNCPYSRC,SFAMUSV039
      *
      ** Validate Only If Fund Transfer Module is on
      *
     C     BGFDTR        IFEQ      'Y'
      *
      ** Validate Cheque's Output Queue Name
      /COPY WNCPYSRC,SFAMUSV040
     C                   EXSR      VCOUTQSR
      /COPY WNCPYSRC,SFAMUSV041
      *
     C                   ENDIF
      *
      ** Validate Only If Multi-Branch Environment is on
      *
     C     AGMBIN        IFEQ      'Y'
      *
      ** Validate Access to Multiple Users Report
      /COPY WNCPYSRC,SFAMUSV042
     C                   EXSR      VMUREPSR
      /COPY WNCPYSRC,SFAMUSV043
      *
     C                   ENDIF
      *
      ** Validate Only If CGL008 - Security on Journal Entry is on
      *
     C     CGL008        IFEQ      'Y'
      *
      ** Validate Allow Access to Journal Entry ACOD's
      /COPY WNCPYSRC,SFAMUSV044
     C                   EXSR      VJEAASR
      /COPY WNCPYSRC,SFAMUSV045
      *
     C                   ENDIF
      *
      ** Validate Only If Multi-Branch Environment is on
      *
     C     AGMBIN        IFEQ      'Y'
      *
      ** Validate Access to Multiple Branches Report
      /COPY WNCPYSRC,SFAMUSV046
     C                   EXSR      VMBREPSR
      /COPY WNCPYSRC,SFAMUSV047
      *
     C                   ENDIF
      *
      ** Validate Only If CGL008 - Security on Journal Entry is on
      *
     C     CGL008        IFEQ      'Y'
      *
      ** Validate Reference User
      /COPY WNCPYSRC,SFAMUSV048
     C                   EXSR      VREFUSR
      /COPY WNCPYSRC,SFAMUSV049
      *
     C                   ENDIF
      *
      ** Validate User Authorisation Level
      /COPY WNCPYSRC,SFAMUSV050
     C                   EXSR      VALVLSR
      /COPY WNCPYSRC,SFAMUSV051
      *
      ** Validate User Bank Level Functions
      /COPY WNCPYSRC,SFAMUSV052
     C                   EXSR      VBANKSR
      /COPY WNCPYSRC,SFAMUSV053
      *
      ** Validate Only If Multi-Branch Environment is on
      *
     C     AGMBIN        IFEQ      'Y'
      *
      ** Validate Booking Branches
      /COPY WNCPYSRC,SFAMUSV054
     C                   EXSR      VBRBSSR
      /COPY WNCPYSRC,SFAMUSV055
      *
      ** Validate Originating Branches
      /COPY WNCPYSRC,SFAMUSV056
     C                   EXSR      VBROSSR
      /COPY WNCPYSRC,SFAMUSV057
      *
      ** Validate Companies
      /COPY WNCPYSRC,SFAMUSV058
     C                   EXSR      VCMPSSR
      /COPY WNCPYSRC,SFAMUSV059
      *
     C                   ENDIF
      *
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SFAMUSV060
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VUSER1SR - Validate User Profile Name
      *****************************************************************
     C     VUSER1SR      BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate User Profile Name
     C                   CALLB     'SFVUSER1'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** User Profile Name
     C                   PARM                    DDUSER1
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** User Profile Name - OK
     C                   PARM                    DDUSER1OK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSECLSR - Validate Security Level
      *****************************************************************
     C     VSECLSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Security Level
     C                   CALLB     'SFVSECL'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Security Level
     C                   PARM                    DDSECL
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Level - OK
     C                   PARM                    DDSECLOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VMULTSR - Validate User Language Code
      *****************************************************************
     C     VMULTSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate User Language Code
     C                   CALLB     'SFVMULT'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** User Language Code
     C                   PARM                    DDMULT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** User Language Code - OK
     C                   PARM                    DDMULTOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDPPTSR - Validate User Department
      *****************************************************************
     C     VDPPTSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate User Department
     C                   CALLB     'SFVDPPT'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** User Department
     C                   PARM                    DDDPPT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** User Department - OK
     C                   PARM                    DDDPPTOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VACFASR - Validate Account Officer
      *****************************************************************
     C     VACFASR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Account Officer
     C                   CALLB     'SFVACFA'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Account Officer
     C                   PARM                    DDACFA
     C                   PARM                    DDDPPT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Account Officer - OK
     C                   PARM                    DDACFAOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      ****************************************************************
      ** VDBRNSR - Validate Default Branch
      *****************************************************************
     C     VDBRNSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Default Branch
     C                   CALLB     'SFVDBRN'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Default Branch
     C                   PARM                    DDDBRN
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Default Branch - OK
     C                   PARM                    DDDBRNOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VPAUTSR - Validate Perform Payment Authorisation
      *****************************************************************
     C     VPAUTSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Perform Payment Authorisation
     C                   CALLB     'SFVPAUT'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Perform Payment Authorisation
     C                   PARM                    DDPAUT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Perform Payment Authorisation - OK
     C                   PARM                    DDPAUTOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VROUFSR - Validate Systems Routing Officer
      *****************************************************************
     C     VROUFSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Systems Routing Officer
     C                   CALLB     'SFVROUF'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
     ** Other parms
      *
      ** Systems Routing Officer
     C                   PARM                    DDROUF
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Systems Routing Officer - OK
     C                   PARM                    DDROUFOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VAURFSR - Validate Auto Refresh for User
      *****************************************************************
     C     VAURFSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Auto Refresh for User
     C                   CALLB     'SFVAURF'
      * Inputs
      *
     ** Return Code
     C                   PARM                    RetCodeIn
      *
     ** Other parms
      *
      ** Auto Refresh for User
     C                   PARM                    DDAURF
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Auto Refresh for User - OK
     C                   PARM                    DDAURFOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VREFPSR - Validate Refresh Period
      *****************************************************************
     C     VREFPSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Refresh Period
     C                   CALLB     'SFVREFP'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Refresh Period
     C                   PARM                    DDREFP
      ** Auto Refresh for User
     C                   PARM                    DDAURF
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Refresh Period - OK
     C                   PARM                    DDREFPOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VCOBUSR - Validate COB User
      *****************************************************************
     C     VCOBUSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate COB User
     C                   CALLB     'SFVCOBU'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** COB User
     C                   PARM                    DDCOBU
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** COB User - OK
     C                   PARM                    DDCOBUOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VTLIDSR - Validate Teller ID
      *****************************************************************
     C     VTLIDSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Teller ID
     C                   CALLB     'SFVTLID'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
     ** Other parms
      *
      ** Teller ID
     C                   PARM                    DDTLID
      *
     C                   PARM                    DDUSRP
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Teller ID - OK
     C                   PARM                    DDTLIDOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VENTLSR - Validate Entering Threshold
      *****************************************************************
     C     VENTLSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Entering Threshold
     C                   CALLB     'SFVENTL'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Entering Threshold
     C                   PARM                    DDENTL
     C                   PARM                    USENTL
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Entering Threshold - OK
     C                   PARM                    DDENTLOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VAUT1SR - Validate Approving Limit
      *****************************************************************
     C     VAUT1SR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Approving Limit
     C                   CALLB     'SFVAUT1'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Approving Limit
     C                   PARM                    DDAUT1
     C                   PARM                    USAUT1
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Approving Limit - OK
     C                   PARM                    DDAUT1OK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VAUT2SR - Validate Authorising Limit
      *****************************************************************
     C     VAUT2SR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Authorising Limit
     C                   CALLB     'SFVAUT2'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Authorising Limit
     C                   PARM                    DDAUT2
     C                   PARM                    USAUT2
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Authorising Limit - OK
     C                   PARM                    DDAUT2OK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VROUTSR - Validate Choice Of Report Output
      *****************************************************************
     C     VROUTSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Choice Of Report Output
     C                   CALLB     'SFVROUT'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Choice Of Report Output
     C                   PARM                    DDROUT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Choice Of Report Output - OK
     C                   PARM                    DDROUTOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VDIRIDSR - Validate Directory ID &  Directory Address
      *****************************************************************
     C     VDIRIDSR      BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Directory ID
     C                   CALLB     'SFVDIRID'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Directory ID
     C                   PARM                    DDDIRID
     C                   PARM                    DDDIRAD
     C                   PARM                    DDACTN
     C                   PARM                    DDUSRP
     C                   PARM                    DDUSER1
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Directory ID - OK
     C                   PARM                    DDDIRIDOK
     C                   PARM                    DDDIRADOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
     *****************************************************************
     ** VOUTQSR - Validate Output Queue Name
     *****************************************************************
     C     VOUTQSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Output Queue Name
     C                   CALLB     'SFVOUTQ'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Output Queue Name
     C                   PARM                    DDOUTQ
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Output Queue Name - OK
     C                   PARM                    DDOUTQOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VCOUTQSR - Validate Cheque's Output Queue Name
      *****************************************************************
     C     VCOUTQSR      BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Cheque's Output Queue Name
     C                   CALLB     'SFVCOUTQ'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Cheque's Output Queue Name
     C                   PARM                    DDCOUTQ
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Cheque's Output Queue Name - OK
     C                   PARM                    DDCOUTQOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VMUREPSR - Validate Access to Multiple Users Report
      *****************************************************************
     C     VMUREPSR      BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Access to Multiple Users Report
     C                   CALLB     'SFVMUREP'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Access to Multiple Users Report
     C                   PARM                    DDMUREP
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Access to Multiple Users Report - OK
     C                   PARM                    DDMUREPOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VJEAASR - Validate Allow Access to Journal Entry ACOD's
      *****************************************************************
     C     VJEAASR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Allow Access to Journal Entry ACOD's
     C                   CALLB     'SFVJEAA'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Allow Access to Journal Entry ACOD's
     C                   PARM                    DDJEAA
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Allow Access to Journal Entry ACOD's - OK
     C                   PARM                    DDJEAAOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VMBREPSR - Validate Access to Multiple Branches Report
      *****************************************************************
     C     VMBREPSR      BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Access to Multiple Branches Report
     C                   CALLB     'SFVMBREP'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Access to Multiple Branches Report
     C                   PARM                    DDMBREP
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Access to Multiple Branches Report - OK
     C                   PARM                    DDMBREPOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VREFUSR - Validate Reference User
      *****************************************************************
     C     VREFUSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Reference User
     C                   CALLB     'SFVREFU'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Reference User
     C                   PARM                    DDREFU
     C                   PARM                    DDUSRP
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Reference User - OK
     C                   PARM                    DDREFUOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VALVLSR - Validate User Authorisation Level
      *****************************************************************
     C     VALVLSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate User Authorisation Level
     C                   CALLB     'SFVALVL'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** User Authorisation Level
     C                   PARM                    DDALVL
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** User Authorisation Level - OK
     C                   PARM                    DDALVLOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VBANKSR - Validate Bank Level Functions
      *****************************************************************
     C     VBANKSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Bank Level Functions
     C                   CALLB     'SFVBANK'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Bank Level Functions
     C                   PARM                    DDBANK
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Bank Level Functions - OK
     C                   PARM                    DDBANKOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VBRBSSR - Validate Booking Branches
      *****************************************************************
     C     VBRBSSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Booking Branches
     C                   CALLB     'SFVBRBS'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Booking Branches
     C                   PARM                    DDBRBS
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Booking Branches - OK
     C                   PARM                    DDBRBSOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** VBROSSR - Validate Originating Branches
      *****************************************************************
     C     VBROSSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Originating Branches
     C                   CALLB     'SFVBROS'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Originating Branches
     C                   PARM                    DDBROS
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Originating Branches - OK
     C                   PARM                    DDBROSOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
     *****************************************************************
     ** VCMPSSR - Validate Companies
     *****************************************************************
     C     VCMPSSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Companies
     C                   CALLB     'SFVCMPS'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Companies
     C                   PARM                    DDCMPS
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Companies - OK
     C                   PARM                    DDCMPSOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
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
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * Inputs
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** User Maintenance + Menu Items Details
     C                   PARM                    TrnDets
     C                   PARM                    ExtData
      * Outputs
 
      ** User Maintenance + Menu Items OK inds
     C                   PARM                    OKTrnDets
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid User Maintenance + Menu Items details layout (DS)
      * from/to caller
     C                   PARM                    ValidAMUS
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
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
      *
      ** Check if switchable feature CGL008 is switched on.
      ** - Security on JE input
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL008'      @SARD             6
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CGL008'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  901
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGL008            1
     C                   ELSE
     C                   MOVE      'N'           CGL008
     C                   ENDIF
      ** Access SD Midas Module File.
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 902
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SFAMUSV063
 
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
(c) Misys International Banking Systems Ltd. 2006
