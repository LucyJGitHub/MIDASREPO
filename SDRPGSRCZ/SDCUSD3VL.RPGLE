     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details secondary validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDCUSD3VL - Customer Secondary Details Validation           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW216             Date 14Mar16               *
      *  Prev Amend No. CSW214             Date 25Nov14               *
      *                 MD022862           Date 17Oct13               *
      *                 MD022444           Date 18Sep13               *
      *                 CFT050             Date 03Jun13               *
      *                 AR917747           Date 27Feb12               *
      *                 AR855391           Date 27Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207A            Date 02Aug07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD025             Date 11Jan05               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 189507             Date 02Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034             Date 08Apr99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD022862 - LEI Code not accepted eventhough consists of first*
      *             18 uppercase character and last 2 numbers.        *
      *  MD022444 - Namespace value was reset during Authorisation    *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  AR917747 - CUSD returning multiple warning message for the   *
      *             same error in IBEI. (Recompile)                   *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2)                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD025 - Customer De-Activation                              *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87 (Recompiled).       *
      *  189507 - Change setup of CLS fields in Customer details      *
      *           and FX deals input                                  *
      *  CSD007 - Customer Closing: Recompile.                        *
      * CDL008  - Continuous Linked Settlement                        *
      * CAP034  - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDSV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Customer Primary Details in screen format
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
      ** Customer Swift Details in screen format                                         CSW207
     D CuSwft        E DS                  EXTNAME(SDCUSWPD)                             CSW207
 
      ** Customer Secondary Details in screen format
     D CuSeco        E DS                  EXTNAME(SDCUSEPD)
 
      ** Customer Secondary Details OK indicators
     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
      ** Customer SWIFT Details OK indicators                                                 CSW207
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
 
      ** External DS for Bank Details                                                         CDL008
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CDL008
                                                                                              CDL008
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ***External*DS*for*Branch*Details***                                             CDL008 189507
     D***SDBRCH********E*DS                  EXTNAME(SDBRCHPD)                         CDL008 189507
                                                                                              CDL008
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for run date and Multibranch Indicator using rundat.
     D RUNDAT          DS
     D  RDNB                   8     10P 0
 
 
     D ZMUSER          DS            17
 
 
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)
      * Valid Customer Details layout
     D ValidSwft     E DS                  EXTNAME(SDVSWSDPD)                                 CSW207
      * Valid SWIFT  Details layout                                                           CSW207
 
     D ExtData       E DS                  EXTNAME(SDCUEXPD)
      * Customer Details Extra Data - File (D/B) format
     D CuSW13        E DS                  EXTNAME(SDSW13PD)                                  CFT050
     D  S13DDBRCD    E                     EXTFLD(DDBRCD)                                     CFT050
      ** Customer dtls Bank directory plus detail                                             CFT050
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
     D CFT050          S              1A                                                      CFT050
     D DDBDRKOK        S              1A                                                      CFT050
     D WLEN            S              2S 0                                                    CFT050
     D CSW213          S              1A                                                    MD022862
     D PRTCD           S              7A                                                    MD022862
     D CSW214          S              1A                                                      CSW214
     D CSW216          S              1A                                                      CSW216
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUDSV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCUDSV003
 
 
      ** Pass data not requiring validation to VALIDCUSD fields
 
      ** BOJ Financial Institution Code
      ** Bankleitzahl Code
     C                   MOVE      DDBFIC        CUBFIC
     C                   MOVE      DDBLCD        CUBLCD
      *
 
      * Call Validation Modules in Sequence
      *
      ** Validate SWIFT ID
      *
      /COPY WNCPYSRC,SDCUDSV004
     C                   EXSR      VCCSID
      /COPY WNCPYSRC,SDCUDSV005
      *
      *                                                                                       CSW036
      ** Validate SWIFT ID 2                                                                  CSW036
      *                                                                                       CSW036
     C                   if        CSW036 = 'Y'                                               CSW036
     C                   EXSR      VCCSI2                                                     CSW036
     C                   endif                                                                CSW036
      *                                                                                       CSW036
      *
      ** Validate STTX address
      *
      /COPY WNCPYSRC,SDCUDSV006
     C                   EXSR      VCSTAD
      /COPY WNCPYSRC,SDCUDSV007
      *
      *
      ** Validate that SSTX and TELEX addresses are not both entered
      *
      /COPY WNCPYSRC,SDCUDSV008
     C                   EXSR      VCSATA
      /COPY WNCPYSRC,SDCUDSV009
      *
      ** Validate corporate customer and psuedo SWIFT code
      *
      /COPY WNCPYSRC,SDCUDSV010
     C                   EXSR      VCCCPS
      /COPY WNCPYSRC,SDCUDSV011
      *
      *
      ** Validate SWIFT financial institution flag
      *
      /COPY WNCPYSRC,SDCUDSV012
     C                   EXSR      VCSWFI
      /COPY WNCPYSRC,SDCUDSV013
      *
      *
      ** Validate CHIPS ID
      *
      /COPY WNCPYSRC,SDCUDSV014
     C                   EXSR      VCCIDA
      /COPY WNCPYSRC,SDCUDSV015
      *
      *
      ** Validate CHAPS sort code
      *
      /COPY WNCPYSRC,SDCUDSV016
     C                   EXSR      VCCSCA
      /COPY WNCPYSRC,SDCUDSV017
      *
      *
      ** Validate CHIPS ABA
      *
      /COPY WNCPYSRC,SDCUDSV018
     C                   EXSR      VCABAS
      /COPY WNCPYSRC,SDCUDSV019
      *
      *
      ** Validate Fedwire code is numeric
      *
      /COPY WNCPYSRC,SDCUDSV020
     C                   EXSR      VCFWCA
      /COPY WNCPYSRC,SDCUDSV021
      *
      *
      ** Validate suppress download
      *
      /COPY WNCPYSRC,SDCUDSV022
     C                   EXSR      VCSSDL
      /COPY WNCPYSRC,SDCUDSV023
      *
      ** Validate CLS Settlement and Effective Date                                           CDL008
      *                                                                                       CDL008
     C     CDL008        IFEQ      'Y'                                                        CLD008
     C                   EXSR      VCCLS                                                      CLD008
     C                   ENDIF                                                                CDL008
      *
      ** Process 'generate SWIFT message' flag
      *
      /COPY WNCPYSRC,SDCUDSV024
     C                   EXSR      VCGSFM
      /COPY WNCPYSRC,SDCUDSV025
      *
      *
      ** Process SWIFT/TELEX flag
      *
      /COPY WNCPYSRC,SDCUDSV026
     C                   EXSR      VCSTFG
      /COPY WNCPYSRC,SDCUDSV027
      *
      ** Validate International Business Entity Identifier                                    CSW207
      *                                                                                       CSW207
     C*********          EXSR      SRVIBEI                                             CSW207 CFT050
     C**********         IF        CSW214 <> 'Y'                                       CSW214 CSW216
     C                   IF        CSW214 <> 'Y' OR                                           CSW216
     C                             CSW216 <> 'Y'                                              CSW216
     C                   EXSR      SRVNMSP                                                    CSW214
     C                   ENDIF                                                                CSW214
     C                   EVAL      CUIBEI = DDIBEI                                          MD022444
                                                                                              CFT050
     C                   IF        CFT050 = 'Y'                                               CFT050
      ** Validate Bank Directory Record key                                                   CFT050
     C                   EXSR      SRVBDRK                                                    CFT050
     C                   ENDIF                                                              MD022862
     C                   IF        CSW213 = 'Y'                                             MD022862
      ** Validate LEI code                                                                    CFT050
     C                   EXSR      SRVLEIC                                                    CFT050
      ** Validate Clearing system code                                                        CFT050
     C                   EXSR      SRVCLCY                                                    CFT050
      ** Validate Clearing identification                                                     CFT050
     C                   EXSR      SRVCLID                                                    CFT050
     C                   ENDIF                                                                CFT050
 
     C                   RETURN
 
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUDSV028
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate SWIFT financial institution flag
      *****************************************************************
     C     VCSWFI        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate SWIFT financial institution flag
      *
     C                   CALLB     'SDVSFDE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** SWIFT Financial Institution Flag (1A)
     C     CUSWFI        PARM                    DDSWFI
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SWIFT Financial Institution Flag - OK
     C                   PARM                    DDSWFIOK
      *
      *
      * Update error info with that returned from validation
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate CHIPS ID
      *****************************************************************
     C     VCCIDA        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate CHIPS ID
      *
     C                   CALLB     'SDVCHDE02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** CHIPS ID alpha (6A)
     C                   PARM                    DDCIDA
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Validate CHIPS ID - OK
     C                   PARM                    DDCHIDOK
      *
      ** CHIPS ID numeric (6,0)
     C                   PARM                    CUCHID
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate CHAPS sort code
      *****************************************************************
     C     VCCSCA        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate CHAPS sort code
      *
     C                   CALLB     'SDVCHDE03'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** CHAPS sort code alpha (6A)
     C                   PARM                    DDCSCA
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Validate CHAPS sort code - OK
     C                   PARM                    DDCHSCOK
      *
      ** CHAPS sort code numeric (6,0)
     C                   PARM                    CUCHSC
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate CHIPS ABA
      *****************************************************************
     C     VCABAS        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate CHIPS ABA alpha
      *
     C                   CALLB     'SDVCHDE01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** CHIPS ABA (4A)
      ** CHIPS 2 Indicator (1A)
     C                   PARM                    DDABAS
     C                   PARM                    S01429
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Validate CHIPS ABA - OK
     C                   PARM                    DDABASOK
      *
      ** CHIPS ABA Numeric (3,0)
      ** CHIPS ABA 2 Numeric (4,0)
     C                   PARM                    CUCABA
     C                   PARM                    CUABA2
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Fedwire code is numeric
      *****************************************************************
     C     VCFWCA        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Fedwire code is numeric
      *
     C                   CALLB     'SDVMCDE01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Fedwire code alpha (9A)
     C                   PARM                    DDFWCA
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Fedwire code is numeric - OK
     C                   PARM                    DDFWCDOK
      *
      ** Fedwire code numeric (9,0)
     C                   PARM                    CUFWCD
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate suppress download
      *****************************************************************
     C     VCSSDL        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate suppress download
      *
     C                   CALLB     'SDVSMDE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Stop Statement Download (1A)
      ** Auto-reconciliation (1A)
     C     CUSSDL        PARM                    DDSSDL
     C                   PARM                    BGAURC
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Stop Statement Download - OK
     C                   PARM                    DDSSDLOK
      *
      * Update error info with that returned from validation
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate SWIFT ID
      *****************************************************************
     C     VCCSID        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate SWIFT ID
      *
     C                   CALLB     'SDVSFID'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Customer SWIFT ID (12A)
      ** MIDAS/SWIFT direct link (1A)
     C     CUCSID        PARM                    DDCSID
     C                   PARM                    BGMSDL
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                            AR855391
      * Warning fields/message IDs/message data (arrays) from/to caller                     AR855391
     C                   PARM                    WFldNmXAr                                  AR855391
     C                   PARM                    WMsgIDXAr                                  AR855391
     C                   PARM                    WMsgDtXAr                                  AR855391
      *
      ** SWIFT ID - OK
     C                   PARM                    DDCSIDOK
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************                       CSW036
      ** Validate SWIFT ID 2                                                                  CSW036
      *****************************************************************                       CSW036
     C     VCCSI2        BEGSR                                                                CSW036
                                                                                              CSW036
      * Reset variables updated by each module                                                CSW036
                                                                                              CSW036
     C                   EXSR      RESETERRS                                                  CSW036
      *                                                                                       CSW036
      ** Validate SWIFT ID                                                                    CSW036
      *                                                                                       CSW036
     C                   CALLB     'SDVSFI2'                                                  CSW036
      *                                                                                       CSW036
      * INPUTS                                                                                CSW036
      *                                                                                       CSW036
      ** Return Code                                                                          CSW036
     C                   PARM                    RetCodeOut                                   CSW036
      *                                                                                       CSW036
      ** Customer SWIFT ID (12A) - original                                                   CSW036
     C                   PARM                    DDCSID                                       CSW036
     C                   PARM                    DDCSIDOK                                     CSW036
      ** Customer SWIFT ID 2 (12A)                                                            CSW036
      ** MIDAS/SWIFT direct link (1A)                                                         CSW036
     C     CUCSI2        PARM                    DDCSI2                                       CSW036
     C                   PARM                    BGMSDL                                       CSW036
      *                                                                                       CSW036
      *                                                                                       CSW036
      * OUTPUTS                                                                               CSW036
      *                                                                                       CSW036
      * Error fields/message IDs/message data (arrays) from/to caller                         CSW036
     C                   PARM                    FldNamXAr                                    CSW036
     C                   PARM                    MsgIDXAr                                     CSW036
     C                   PARM                    MsgDtaXAr                                    CSW036
     C                   PARM                    WFldNmXAr                                  AR855391
     C                   PARM                    WMsgIDXAr                                  AR855391
     C                   PARM                    WMsgDtXAr                                  AR855391
      *                                                                                       CSW036
      ** SWIFT ID 2 - OK                                                                      CSW036
     C                   PARM                    DDCSI2OK                                     CSW036
                                                                                              CSW036
      * Update error info with that returned from the validation module                       CSW036
                                                                                              CSW036
     C                   EXSR      UPDATERRS                                                  CSW036
      *                                                                                       CSW036
     C                   ENDSR                                                                CSW036
      *****************************************************************                       CSW036
     C/EJECT                                                                                  CSW036
      *****************************************************************
      ** Validate STTX address
      *****************************************************************
     C     VCSTAD        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate STTX address
      *
     C                   CALLB     'SDVTXAD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** STTX Address (12A)
      ** Switchable Feature BGMSDL (1A)
     C     CUSTAD        PARM                    DDSTAD
     C                   PARM                    BGMSDL
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** STTX Address - OK
     C                   PARM                    DDSTADOK
 
 
      * Update error info with that returned from validation
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate that SSTX and TELEX addresses are not both entered
      *****************************************************************
     C     VCSATA        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate that SSTX and TELEX addresses are not both entered
      *
     C                   CALLB     'SDVTXDX'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** STTX Address (12A)
      ** Telex Address (10A)
     C                   PARM                    DDSTAD
     C     CUTXA1        PARM                    DDTXA1
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** STTX Address - OK
      ** Telex Address - OK
     C                   PARM                    DDSTADOK
     C                   PARM                    DDTXA1OK
 
      * Update error info with that returned from validation
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate corporate customer and psuedo SWIFT code
      *****************************************************************
     C     VCCCPS        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate corporate customer and psuedo SWIFT code
      *
     C                   CALLB     'SDVCSSF'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Switchable Feature CCF001 (1A)
      ** Corporate customer (1A)
      ** Pseudo SWIFT code (11A)
     C                   PARM                    CCF001
     C     CUCRPC        PARM                    DDCRPC
     C     CUPSWC        PARM                    DDPSWC
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Corporate customer - OK
     C                   PARM                    DDCRPCOK
 
      ** Pseudo SWIFT code - OK
     C                   PARM                    DDPSWCOK
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CDL008
      *****************************************************************                       CDL008
      ** Validate CLS Settlement and Effective Date                                           CDL008
      *****************************************************************                       CDL008
     C     VCCLS         BEGSR                                                                CDL008
                                                                                              CDL008
      ** Reset variables updated by validation module                                         CDL008
                                                                                              CDL008
     C                   EXSR      RESETERRS                                                  CDL008
                                                                                              CDL008
      ***Access*Branch Codes*file*for*the*value*of*'Default*CLS*by*Customer'***        CDL008 189507
      ***********                                                                      CDL008 189507
     C***********        CALL      'AOBRCHR1'                                          CDL008 189507
     C***********        PARM      *BLANKS       WRTCD             7                   CDL008 189507
     C***********        PARM      '*KEY   '     WOPTN             7                   CDL008 189507
     C***********        PARM      DDBRCD        WBRCD             3                   CDL008 189507
     C*****SDBRCH        PARM      SDBRCH        DSSDY                                 CDL008 189507
      ***********                                                                      CDL008 189507
     C*****WRTCD*        IFEQ      *BLANKS                                             CDL008 189507
     C***********        MOVE      A8DCLC        DefaultCLS        1                   CDL008 189507
     C***********        ENDIF                                                         CDL008 189507
                                                                                              CDL008
     C                   CALLB     'SDVCLSS'                                                  CDL008
                                                                                              CDL008
      ** INPUT                                                                                CDL008
      ** Return Code                                                                          CDL008
                                                                                              CDL008
     C                   PARM                    RetCodeOut                                   CDL008
                                                                                              CDL008
      ** CLS Settlement (1A)                                                                  CDL008
      ** Effective Date (6A)                                                                  CDL008
                                                                                              CDL008
     C                   PARM                    DDCLSS                                       CDL008
     C                   PARM                    DDEFDT                                       CDL008
      ***********                                                                      CDL008 189507
      ***Default*CLS*By*Customer*(1A)***                                               CDL008 189507
      ***********                                                                      CDL008 189507
     C***********        PARM                    DefaultCLS                            CDL008 189507
                                                                                              CDL008
      ** Date Format Indicator (1A)                                                           CDL008
                                                                                              CDL008
     C                   PARM                    BJDFIN                                       CDL008
                                                                                              CDL008
      ** OUTPUT                                                                               CDL008
      ** Error fields/message IDs/message data (arrays) from/to caller                        CDL008
                                                                                              CDL008
     C                   PARM                    FldNamXAr                                    CDL008
     C                   PARM                    MsgIDXAr                                     CDL008
     C                   PARM                    MsgDtaXAr                                    CDL008
                                                                                              CDL008
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CDL008
                                                                                              CDL008
     C                   PARM                    WFldNmXAr                                    CDL008
     C                   PARM                    WMsgIDXAr                                    CDL008
     C                   PARM                    WMsgDtXAr                                    CDL008
                                                                                              CDL008
      ** CLS Settlement - OK                                                                  CDL008
      ** Effective Date - OK                                                                  CDL008
                                                                                              CDL008
     C                   PARM                    DDCLSSOK                                     CDL008
     C                   PARM                    DDEFDTOK                                     CDL008
                                                                                              CDL008
      ** Effective Date in Midas day number format (5,0)                                      CDL008
                                                                                              CDL008
     C                   PARM                    CUEFDT                                       CDL008
                                                                                              CDL008
      ** Default values for CLS Settlement and Effective Date                                 CDL008
                                                                                              CDL008
     C                   MOVE      DDCLSS        CUCLSS                                       CDL008
     C     DDCLSSOK      IFEQ      'Y'                                                        CDL008
     C     DDCLSS        ANDEQ     *BLANK                                                     CDL008
     C                   MOVE      'N'           CUCLSS                                       CDL008
     C                   ENDIF                                                                CDL008
                                                                                              CDL008
     C     DDEFDTOK      IFEQ      'Y'                                                        CDL008
     C     DDEFDT        ANDEQ     *BLANKS                                                    CDL008
     C                   Z-ADD     *ZERO         CUEFDT                                       CDL008
     C                   ENDIF                                                                CDL008
                                                                                              CDL008
      ** If warning message was issued, default CLS Settlement to 'N'                         CDL008
      ** and Effective date to zero.                                                          CDL008
                                                                                              CDL008
     C     DDCLSSOK      IFEQ      'W'                                                        CDL008
     C     DDEFDTOK      OREQ      'W'                                                        CDL008
     C                   MOVE      'N'           CUCLSS                                       CDL008
     C                   Z-ADD     *ZERO         CUEFDT                                       CDL008
     C                   MOVE      'N'           DDCLSS                                       CDL008
     C                   MOVE      *BLANKS       DDEFDT                                       CDL008
     C                   ENDIF                                                                CDL008
                                                                                              CDL008
      ** Update error info with that returned from the validation module                      CDL008
                                                                                              CDL008
     C                   EXSR      UPDATERRS                                                  CDL008
      *                                                                                       CDL008
     C                   ENDSR                                                                CDL008
      *****************************************************************                       CDL008
     C/EJECT
      *****************************************************************
      ** Process 'generate SWIFT message' flag
      *****************************************************************
     C     VCGSFM        BEGSR
      *
     C     DDCSID        IFNE      *BLANK
     C                   MOVE      'Y'           CUGSFM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Process SWIFT/TELEX flag
      *****************************************************************
     C     VCSTFG        BEGSR
 
     C     DDCSID        IFNE      *BLANK
     C                   MOVE      'S'           CUSTFG
     C                   ELSE
     C     DDTXA1        IFNE      *BLANK
     C                   MOVE      'T'           CUSTFG
     C                   ELSE
     C     DDSTAD        IFNE      *BLANK
     C                   MOVE      'X'           CUSTFG
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CSW207
     C/EJECT                                                                                  CSW207
      *****************************************************************                       CSW207
      ** Validate International Business Entity Identifier                                    CSW207
      *****************************************************************                       CSW207
     C     SRVIBEI       BEGSR                                                                CSW207
                                                                                              CSW207
      * Reset variables updated by each module                                                CSW207
                                                                                              CSW207
     C                   EXSR      RESETERRS                                                  CSW207
                                                                                              CSW207
      ** Validate International Business Entity Identifier                                    CSW207
                                                                                              CSW207
     C**********         CALLB     'SDVIBEI'                                           CSW207 CFT050
                                                                                              CSW207
      * INPUTS                                                                                CSW207
                                                                                              CSW207
      ** Return Code                                                                          CSW207
     C**********         PARM                    RetCodeOut                            CSW207 CFT050
                                                                                              CSW207
      ** International Business Entity Identifier (10A)                                       CSW207
     C*****CUIBEI        PARM                    DDIBEI                                CSW207 CFT050
                                                                                              CSW207
      * OUTPUTS                                                                               CSW207
                                                                                              CSW207
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW207
     C**********         PARM                    FldNamXAr                             CSW207 CFT050
     C**********         PARM                    MsgIDXAr                              CSW207 CFT050
     C**********         PARM                    MsgDtaXAr                             CSW207 CFT050
     C**********         PARM                    WFldNmXAr                           AR855391 CFT050
     C**********         PARM                    WMsgIDXAr                           AR855391 CFT050
     C**********         PARM                    WMsgDtXAr                           AR855391 CFT050
                                                                                              CSW207
      ** International Business Entity Identifier - OK                                        CSW207
     C**********         PARM                    DDIBEIOK                              CSW207 CFT050
                                                                                              CSW207
      * Update error info with that returned from the validation module                       CSW207
                                                                                              CSW207
     C**********         EXSR      UPDATERRS                                           CSW207 CFT050
                                                                                              CSW207
     C                   MOVEL     DDIBEI        CUIBEI                                       CFT050
     C                   ENDSR                                                                CSW207
      *****************************************************************                       CSW214
     C/EJECT                                                                                  CSW214
      *****************************************************************                       CSW214
      ** Validate Namespace                                                                   CSW214
      *****************************************************************                       CSW214
     C     SRVNMSP       BEGSR                                                                CSW214
                                                                                              CSW214
      * Reset variables updated by each module                                                CSW214
                                                                                              CSW214
     C                   EXSR      RESETERRS                                                  CSW214
                                                                                              CSW214
      ** Validate Namespace                                                                   CSW214
                                                                                              CSW214
     C                   CALLB     'SDVNMSP'                                                  CSW214
                                                                                              CSW214
      * INPUTS                                                                                CSW214
                                                                                              CSW214
      ** Return Code                                                                          CSW214
     C                   PARM                    RetCodeOut                                   CSW214
                                                                                              CSW214
      ** Namespace (20A)                                                                      CSW214
     C     CUIBEI        PARM                    DDIBEI                                       CSW214
                                                                                              CSW214
      * OUTPUTS                                                                               CSW214
                                                                                              CSW214
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW214
     C                   PARM                    FldNamXAr                                    CSW214
     C                   PARM                    MsgIDXAr                                     CSW214
     C                   PARM                    MsgDtaXAr                                    CSW214
                                                                                              CSW214
      ** Namespace - OK                                                                       CSW214
     C                   PARM                    DDIBEIOK                                     CSW214
      ** SWIFT2014 Flag                                                                       CSW216
     C                   PARM                    CSW214                                       CSW216
      ** SWIFT2016 Flag                                                                       CSW216
     C                   PARM                    CSW216                                       CSW216
                                                                                              CSW214
      ** Update error info with that returned from the validation module                      CSW214
                                                                                              CSW214
     C                   EXSR      UPDATERRS                                                  CSW214
                                                                                              CSW214
     C                   ENDSR                                                                CSW214
      *****************************************************************                       CFT050
     C/EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      ** Validate Bank Directory Plus Record key                                              CFT050
      *****************************************************************                       CFT050
     C     SRVBDRK       BEGSR                                                                CFT050
                                                                                              CFT050
      * Reset variables updated by each module                                                CFT050
                                                                                              CFT050
     C                   EXSR      RESETERRS                                                  CFT050
                                                                                              CFT050
     C                   CALLB     'SDVBDRK'                                                  CFT050
                                                                                              CFT050
      * INPUTS                                                                                CFT050
                                                                                              CFT050
      ** Return Code                                                                          CFT050
     C                   PARM                    RetCodeOut                                   CFT050
                                                                                              CFT050
      ** Validate Bank Directory Record key                                                   CFT050
     C**********         PARM                    CUBDRK                                       CFT050
     C     CUBDRK        PARM                    DDBDRK                                       CFT050
                                                                                              CFT050
      * OUTPUTS                                                                               CFT050
                                                                                              CFT050
      ** Error fields/message IDs/message data (arrays) from/to caller                        CFT050
     C                   PARM                    FldNamXAr                                    CFT050
     C                   PARM                    MsgIDXAr                                     CFT050
     C                   PARM                    MsgDtaXAr                                    CFT050
                                                                                              CFT050
      ** International Business Entity Identifier - OK                                        CFT050
     C                   PARM                    DDBDRKOK                                     CFT050
                                                                                              CFT050
      * Update error info with that returned from the validation module                       CFT050
                                                                                              CFT050
     C                   EXSR      UPDATERRS                                                  CFT050
                                                                                              CFT050
     C                   ENDSR                                                                CFT050
      *****************************************************************                       CFT050
     C/EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      ** Validate LEI Code                                                                    CFT050
      *****************************************************************                       CFT050
     C     SRVLEIC       BEGSR                                                                CFT050
                                                                                              CFT050
      * Reset variables updated by each module                                                CFT050
                                                                                              CFT050
     C                   EXSR      RESETERRS                                                  CFT050
                                                                                              CFT050
      ** Validate LEI Code                                                                    CFT050
                                                                                              CFT050
     C                   CALLB     'SDVLEIC'                                                  CFT050
                                                                                              CFT050
      * INPUTS                                                                                CFT050
                                                                                              CFT050
      ** Return Code                                                                          CFT050
     C                   PARM                    RetCodeOut                                   CFT050
                                                                                              CFT050
      ** LEI Code                                                                             CFT050
     C     CULEIC        PARM                    DDLEIC                                       CFT050
                                                                                              CFT050
      * OUTPUTS                                                                               CFT050
                                                                                              CFT050
      ** Error fields/message IDs/message data (arrays) from/to caller                        CFT050
     C                   PARM                    FldNamXAr                                    CFT050
     C                   PARM                    MsgIDXAr                                     CFT050
     C                   PARM                    MsgDtaXAr                                    CFT050
                                                                                              CFT050
      ** LEI Code - OK                                                                        CFT050
     C                   PARM                    DDLEICOK                                     CFT050
                                                                                              CFT050
      * Update error info with that returned from the validation module                       CFT050
                                                                                              CFT050
     C                   EXSR      UPDATERRS                                                  CFT050
                                                                                              CFT050
     C                   ENDSR                                                                CFT050
                                                                                              CFT050
      *****************************************************************                       CFT050
     C/EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      ** Validate Clearing system code                                                        CFT050
      *****************************************************************                       CFT050
     C     SRVCLCY       BEGSR                                                                CFT050
                                                                                              CFT050
      * Reset variables updated by each module                                                CFT050
                                                                                              CFT050
     C                   EXSR      RESETERRS                                                  CFT050
                                                                                              CFT050
      ** Validate Clearing code system                                                        CFT050
                                                                                              CFT050
     C                   CALLB     'SDVCLCY'                                                  CFT050
                                                                                              CFT050
      * INPUTS                                                                                CFT050
                                                                                              CFT050
      ** Return Code                                                                          CFT050
     C                   PARM                    RetCodeOut                                   CFT050
                                                                                              CFT050
      ** Currency code                                                                        CFT050
     C                   PARM                    BJCYCD                                       CFT050
      ** Clearing system code                                                                 CFT050
     C     CUCLSY        PARM                    DDCLSY                                       CFT050
                                                                                              CFT050
      * OUTPUTS                                                                               CFT050
                                                                                              CFT050
      ** Error fields/message IDs/message data (arrays) from/to caller                        CFT050
     C                   PARM                    FldNamXAr                                    CFT050
     C                   PARM                    MsgIDXAr                                     CFT050
     C                   PARM                    MsgDtaXAr                                    CFT050
      *                                                                                       CFT050
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CFT050
      *                                                                                       CFT050
     C                   PARM                    WFldNmXAr                                    CFT050
     C                   PARM                    WMsgIDXAr                                    CFT050
     C                   PARM                    WMsgDtXAr                                    CFT050
                                                                                              CFT050
      ** Clearing system code - ok                                                            CFT050
     C                   PARM                    DDCLSYOK                                     CFT050
      ** Clearing system code length                                                          CFT050
     C                   PARM                    WLEN                                         CFT050
                                                                                              CFT050
      * Update error info with that returned from the validation module                       CFT050
                                                                                              CFT050
     C                   EXSR      UPDATERRS                                                  CFT050
                                                                                              CFT050
     C                   ENDSR                                                                CFT050
                                                                                              CFT050
      *****************************************************************                       CFT050
     C/EJECT                                                                                  CFT050
      *****************************************************************                       CFT050
      ** Validate Clearing identification                                                     CFT050
      *****************************************************************                       CFT050
     C     SRVCLID       BEGSR                                                                CFT050
                                                                                              CFT050
      * Reset variables updated by each module                                                CFT050
                                                                                              CFT050
     C                   EXSR      RESETERRS                                                  CFT050
                                                                                              CFT050
      ** Validate Clearing code system                                                        CFT050
                                                                                              CFT050
     C                   CALLB     'SDVCLID'                                                  CFT050
                                                                                              CFT050
      * INPUTS                                                                                CFT050
                                                                                              CFT050
      ** Return Code                                                                          CFT050
     C                   PARM                    RetCodeOut                                   CFT050
                                                                                              CFT050
      ** Clearing system code                                                                 CFT050
     C                   PARM                    DDCLSY                                       CFT050
      ** Clearing identification                                                              CFT050
     C     CUCLID        PARM                    DDCLID                                       CFT050
      ** SWIFT ID                                                                             CFT050
     C                   PARM                    DDCSID                                       CFT050
      ** Customer Number                                                                      CFT050
     C                   PARM                    DDCUSN                                       CFT050
      ** Country of location                                                                  CFT050
     C                   PARM                    DDCOLC                                       CFT050
                                                                                              CFT050
      * OUTPUTS                                                                               CFT050
                                                                                              CFT050
      ** Error fields/message IDs/message data (arrays) from/to caller                        CFT050
     C                   PARM                    FldNamXAr                                    CFT050
     C                   PARM                    MsgIDXAr                                     CFT050
     C                   PARM                    MsgDtaXAr                                    CFT050
                                                                                              CFT050
      ** Clearing system code - ok                                                            CFT050
     C                   PARM                    DDCLIDOK                                     CFT050
                                                                                              CFT050
      * Update error info with that returned from the validation module                       CFT050
                                                                                              CFT050
     C                   EXSR      UPDATERRS                                                  CFT050
                                                                                              CFT050
     C                   ENDSR                                                                CFT050
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
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
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
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
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Customer Primary Details
     C                   PARM                    CuPrim
      ** Customer Secondary Details
     C                   PARM                    CuSeco
     C                   PARM                    ExtData
      ** SWIFT Detail                                                                         CSW207
     C                   PARM                    CuSwft                                       CSW207
     C                   PARM                    CuSW13                                       CFT050
 
 
      *
      * OUTPUTS
      *
      ** Customer Secondary Details OK inds
     C                   PARM                    OKCuSeco
 
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
 
      * Valid Customer Details layout (DS) from/to caller
     C                   PARM                    ValidCusd
      * Valid SWIFT Details layout (DS) from/to caller                                        CSW207
     C                   PARM                    ValidSwft                                    CSW207
      ** Customer SWIFT Details OK inds                                                       CSW207
     C                   PARM                    OKCuSwft                                     CSW207
     C/COPY WNCPYSRC,SDCUS3VC01
      *                                                                                       CDL008
      ** Access Bank Details                                                                  CDL008
      *                                                                                       CDL008
     C                   CALL      'AOBANKR0'                                                 CDL008
     C                   PARM      *BLANKS       @RTCD                                        CDL008
     C                   PARM      '*FIRST '     @OPTN                                        CDL008
     C     SDBANK        PARM      SDBANK        DSFDY                                        CDL008
      *                                                                                       CDL008
      ** Database Error                                                                       CDL008
      *                                                                                       CDL008
     C     @RTCD         IFNE      *BLANKS                                                    CDL008
     C                   MOVEL     @OPTN         DBKEY                                        CDL008
     C                   MOVEL     'SDBANKPD'    DBFILE                                       CDL008
     C                   MOVEL     '904'         DBASE                                        CDL008
     C                   EXSR      SRERR                                                      CDL008
     C                   END                                                                  CDL008
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Check if switchable feature CCF001 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CCF001'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CCF001'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CCF001            1
     C                   ELSE
     C                   MOVE      'N'           CCF001
     C                   END
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01429'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01429'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01429            1
     C                   ELSE
     C                   MOVE      'N'           S01429
     C                   END
      *                                                                                       CDL008
      ** Check if CDL008 (Continuous Linked Settlement) is on.                                CDL008
      *                                                                                       CDL008
     C                   CALL      'AOSARDR0'                                                 CDL008
     C                   PARM      *BLANKS       @RTCD                                        CDL008
     C                   PARM      '*VERIFY'     @OPTN                                        CDL008
     C                   PARM      'CDL008'      @SARD                                        CDL008
      *                                                                                       CDL008
     C     @RTCD         IFNE      *BLANKS                                                    CDL008
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL008
     C                   MOVEL     'CDL008'      DBKEY                                        CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL008
     C                   MOVEL     '903'         DBASE                                        CDL008
     C                   EXSR      SRERR                                                      CDL008
     C                   ENDIF                                                                CDL008
      *                                                                                       CDL008
     C     @RTCD         IFEQ      *BLANKS                                                    CDL008
     C                   MOVE      'Y'           CDL008            1                          CDL008
     C                   ELSE                                                                 CDL008
     C                   MOVE      'N'           CDL008                                       CDL008
     C                   ENDIF                                                                CDL008
      *                                                                                       CSW036
      ** Check if CSW036 is on.                                                               CSW036
      *                                                                                       CSW036
     C                   CALL      'AOSARDR0'                                                 CSW036
     C                   PARM      *BLANKS       @RTCD                                        CSW036
     C                   PARM      '*VERIFY'     @OPTN                                        CSW036
     C                   PARM      'CSW036'      @SARD                                        CSW036
      *                                                                                       CSW036
     C     @RTCD         IFNE      *BLANKS                                                    CSW036
     C     @RTCD         ANDNE     '*NRF   '                                                  CSW036
     C                   MOVEL     'CSW036'      DBKEY                                        CSW036
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSW036
     C                   MOVEL     '905'         DBASE                                        CSW036
     C                   EXSR      SRERR                                                      CSW036
     C                   ENDIF                                                                CSW036
      *                                                                                       CSW036
     C     @RTCD         IFEQ      *BLANKS                                                    CSW036
     C                   MOVE      'Y'           CSW036            1                          CSW036
     C                   ELSE                                                                 CSW036
     C                   MOVE      'N'           CSW036                                       CSW036
     C                   ENDIF                                                                CSW036
      *                                                                                       CFT050
      ** Check if CFT050 is installed                                                         CFT050
      *                                                                                       CFT050
     C                   CALL      'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       @RTCD                                        CFT050
     C                   PARM      '*VERIFY'     @OPTN                                        CFT050
     C                   PARM      'CFT050'      @SARD                                        CFT050
      *                                                                                       CFT050
     C     @RTCD         IFNE      *BLANKS                                                    CFT050
     C     @RTCD         ANDNE     '*NRF   '                                                  CFT050
     C                   MOVEL     'CFT050'      DBKEY                                        CFT050
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT050
     C                   MOVEL     '905'         DBASE                                        CFT050
     C                   EXSR      SRERR                                                      CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                       CFT050
     C     @RTCD         IFEQ      *BLANKS                                                    CFT050
     C                   MOVE      'Y'           CFT050                                       CFT050
     C                   ELSE                                                                 CFT050
     C                   MOVE      'N'           CFT050                                       CFT050
     C                   ENDIF                                                                CFT050
      *                                                                                     MD022862
      ** Check if SWIFT 2013 is installed                                                   MD022862
      *                                                                                     MD022862
     C                   CALL      'SWIF2013'                                               MD022862
     C                   PARM      *BLANKS       PRTCD                                      MD022862
                                                                                            MD022862
     C                   IF        PRTCD   = 'CSW2013'                                      MD022862
     C                   EVAL      CSW213 = 'Y'                                             MD022862
     C                   ELSE                                                               MD022862
     C                   EVAL      CSW213 = 'N'                                             MD022862
     C                   ENDIF                                                              MD022862
      *                                                                                       CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
                                                                                              CSW214
     C                   IF        PRTCD   = 'CSW2014'                                        CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   ENDIF                                                                CSW214
      *                                                                                       CSW216
      ** Check if SWIFT 2016 is installed                                                     CSW216
      *                                                                                       CSW216
     C                   CALL      'SWIF2016'                                                 CSW216
     C                   PARM      *BLANKS       PRTCD                                        CSW216
                                                                                              CSW216
     C                   IF        PRTCD   = 'CSW2016'                                        CSW216
     C                   EVAL      CSW216 = 'Y'                                               CSW216
     C                   ELSE                                                                 CSW216
     C                   EVAl      CSW216 = 'N'                                               CSW216
     C                   ENDIF                                                                CSW216
      *
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUDSV029
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C***********        MOVEL     'SETRADSVAL'  DBPGM                                        CDL008
     C                   MOVEL     'SDCUSD3VL'   DBPGM                                        CDL008
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
