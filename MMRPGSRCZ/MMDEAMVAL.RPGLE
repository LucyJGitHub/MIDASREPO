     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments validation')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMVAL - MM Deal Amendments Validation                    *
      *                                                               *
      *  Function: This Program Validates MM Deams for Input into     *
      *            the Midas database.                                *
      *            The sequence of validation is based on subroutine  *
      *            #ZI in Midas program MM0028.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR1006306          Date 20Nov12               *
      *                 AR947093A          Date 04May12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR953104           Date 14Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 AR853219           Date 31Oct11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 258693             Date 13Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16257           Date 14Mar08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6979            Date 04May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3620            Date 12Jul04               *
      *                 BUG3870            Date 27Jul04               *
      *                 BUG3735            Date 20Jul04               *
      *                 BUG3499            Date 30Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Apr00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 181274             Date 17Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 174313             Date 27Jan00               *
      *                 CSE006             Date 08Nov99               *
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 CAP002  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  AR1006306 - Deal Amendment_Spread Change did not change      *
      *              after COB                                        *
      *  AR947093A - Base Rate amendment resulted to 0 interest rate  *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR953104 - No error message for zero final rate              *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR853219 - Spread change issued an error but was able to     *
      *             complete the transaction                          *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  258693 - Int Dealing-MM: A serious Midas error during        *
      *           deal amendment                                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16257 - Clarify the settlement default for amendment      *
      *             type BC, SC, or CI with a warning message         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3620- Apply Base Rate at Value Date for Spread Changes    *
      *  BUG3870 - All deal amendment rate changes are added to the   *
      *            database with a ZERO rate. This is due to BUG3499  *
      *  BUG3735- Pass extra parameter on call to MMVPNLTYPR          *
      *  BUG3499- Decimal Data Error (initialise fields)              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL022 - Deal Amendment Changes                              *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  CSC011 - 24x7 Midas Availability                             *
      *  CDE002 - Revenue Analysis                                    *
      *  CSD006 - Use DSSDY as MMVDEAMCUR *ENTRY parm, not SDCURRPD   *
      *  181274 - Branch code  BRCA  not correctly initialised  and   *
      *           is  stopping  the input of  a  Deal Amendment  when *
      *           Settlement Method = 04  .   Error  msg   ESM0904 =  *
      *            'Must reference a Live Retail account '  issued  . *
      *  174313 - Replace EXPORT/IMPORTs with parameters.             *
      *  CSE006 - Repos Enhancements                                  *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *  CGL011 - Collateral Processing for Midas                     *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *           Add Action Code parameter to call of MMVDEAMAMT     *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(RECDS)
     FMMDELULL  IF   E           K DISK    INFSR(*PSSR)                                       258693
     F                                     INCLUDE(DEALSDCF: DEALSDDF)                        258693
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMDEAMV016
 
      *****************************************************************
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Customer from original deal                                            CDL006  174313
     D*H@CNUM**********S              6  0 EXPORT                               CDL006  174313
     D*H@CNUM***       S              6  0                                             174313 CSD027
                                                                                CDL006  174313
      ** Currency from original deal                                            CDL006  174313
     D*H@CCY***********S              3A   EXPORT                               CDL006  174313
     D H@CCY           S              3A                                                174313
                                                                                CDL006  174313
      ** Deal Type from original deal                                           CDL006  174313
     D*H@MTYP**********S              2A   EXPORT                               CDL006  174313
     D H@MTYP          S              2A                                                174313
                                                                                CDL006  174313
      ** Charges on Principal (from SDDEALPD)                                   CDL006  174313
     D*B@CHPC**********S              1A   EXPORT                               CDL006  174313
     D B@CHPC          S              1A                                                174313
                                                                                CDL006  174313
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDGELRACCD    E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ValidDeal     E DS                  EXTNAME(MMVDEAMPD)
      * Valid Deals layout
 
     D RECDS           DS
      **  Data structure for file status of MM deals file.
     D  MMRECORD         *RECORD
 
     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D                 DS
     D*
     D**  Data Structure for input value date
     D  H@VDAT                 1      8  0 INZ(0)
     D  H@VDYY                 1      4  0
     D  H@VDMM                 5      6  0
     D  H@VDDD                 7      8  0
     D*
     D                 DS
     D*
     D**  Data Structure for input start/last interest date
     D  H@SLDT                 1      8  0 INZ(0)
     D  H@SLYY                 1      4  0
     D  H@SLMM                 5      6  0
     D  H@SLDD                 7      8  0
     D*
     D                 DS
     D*
     D**  Data Structure for input next interest date
     D  H@NIDT                 1      8  0 INZ(0)
     D  H@NIYY                 1      4  0
     D  H@NIMM                 5      6  0
     D  H@NIDD                 7      8  0
     D*
     D                 DS
     D**  Data Structure for input interest accrual control date
     D  H@IADT                 1      8  0 INZ(0)
     D  H@IAYY                 1      4  0
     D  H@IAMM                 5      6  0
     D  H@IADD                 7      8  0
 
 
     D TranIn        E DS                  EXTNAME(MMDEAMPD)
      * Incoming Transaction
                                                                                CAP051
     D InfData       E DS                  EXTNAME(MMDAIFPD)                    CAP051
     D                                     PREFIX(IF_)                          CAP051
      * MM Extra Data - File (D/B) format                                       CAP051
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(MMDAEXPD)                    CAP004
      * MM Deal Amendments Extra Data - File (D/B) format                       CAP004
     D   SDBSRT      E DS                  EXTNAME(SDBSRTPD)                                  CRE073
      **Base Rate Code details accessed via access programme                                  CRE073
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
 
      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
     D     WMSGID5     S                   LIKE(#MsgID)
     D     WMSGID6     S                   LIKE(#MsgID)                                       CGL011
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDVDatOK                      1A
     D  DDDs38OK                      1A
     D  DDCsnmOK                      1A
     D  DDMtypOK                      1A
     D  DDIntrOK                      1A
     D  DDCcyOK                       1A
     D  DDAmnpOK                      1A
     D  DDFsrpOK                      1A
     D  DDPenPOK                      1A                                                      CDL017
     D  DDEmdtOK                      1A                                                      CDL017
     D  DDBsrtOK                      1A                                                      CDL022
     D  DDAirOK                       1A                                                      CDL020
     D  DDCNSPOK                      1A                                                      CRE073
     D  DDRDMTOK                      1A                                                      CRE073
     D  DDRDFDOK                      1A                                                      CRE073
 
      ** Flags to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A
 
      ** A code to indicate the calling function to the lower level modules
     D DEAM            S              4A   INZ('DEAM')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      ** Value Date in Midas Day Number format.
     D ValDate         S              5  0
 
      ** Start/Last Interest Date in Midas Day Number format.
     D SLIntDate       S              5  0
 
      ** Interest Accrual Date in Midas Day Number format.
     D IntAcrDate      S              5  0
 
      ** Fields used by Module ZDATE10 to change date format.
     D DateIn          S              8S 0
     D DateOut         S              5  0
 
      ** Define H@NTCE here in order to ensure ZONED format.
     D H@NTCE          S              3S 0
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D WProcDate       S                   LIKE(BJRDNB)                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CDL010
      ** Fields defined for Enhancement CDL010                                                CDL010
     D CDL010          S              1A                                                      CDL010
      **                                                                                      CRE073
     D CRE073          S              1A   INZ('N')                                           CRE073
     D TMCNSP          S             11P 7                                                    CRE073
     D NEWSRT          S             11P 7                                                    CRE073
     D NEWFRT          S             11P 7                                                  AR847249
     D PModule         S              6A   INZ('LDNI')                                        CRE073
     D PCurset         S              2P 0                                                    CRE073
     D WWFXRT          S             12A                                                      CRE073
     D DDDCSG          S              1A   INZ('A')                                           CRE073
     D DDDCSGOK        S              1A                                                      CRE073
     D WWBRTT          S             11P 7                                                    CRE073
     D WDDBRTT         S             12A                                                      CRE073
     D WDDBSRT         S              2A                                                      CRE073
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMDEAMV017
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
                                                                                             BUG6979
      ** GET ZMUSER to access default branch.                                                BUG6979
                                                                                             BUG6979
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C                   IN        ZMUSER                                                    BUG6979
     C                   UNLOCK    ZMUSER                                                    BUG6979
 
     C                   RESET                   MMRECORD
 
      ** Get original Deal Details
 
     C                   EXSR      RTVDEALDTL
 
      ** Bypass further validation if Deam does not reference a
      ** valid Deal
 
     C     DDDlnoOK      IFNE      'Y'
     C                   GOTO      EXITMODULE
     C                   ELSE                                                   CSE006
     C*                                                                         CSE006
     C** If CSE006 is on and this is a repo deal send error message             CSE006
     C                   IF        CSE006 = 'Y' and HKDRID <> *Blanks           CSE006
     C                                                                          CSE006
     C                   ADD       1             Idx                            CSE006
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'                   CSE006
     C                   EVAL      MsgIdArr(Idx)   = 'MMA0793'                  CSE006
     C                   MOVE      'N'           DDDlnoOK                       CSE006
     C                   GOTO      EXITMODULE                                   CSE006
     C                   END                                                    CSE006
     C                   END
 
      /COPY WNCPYSRC,MMDEAMV001
 
      * Call Validation Modules in Sequence
 
      *  *------------------------*
      *  * Validate Customer      *  #01
      *  *------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVDEAMCUS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    CustFormat
     C                   PARM                    DDCSNM
     C                   PARM                    IGCNUM
     C                   PARM                    IGCSNM
     C                   PARM                    H@CNUM
     C                   PARM                    SDCUST
     C                   PARM                    DDACTN                                       CSD025
 
      /COPY WNCPYSRC,MMDEAMV002
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCsnmOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMDEAMV003
 
      *  *------------------------*
      *  * Validate Value Date    *  #02
      *  *------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVDEAMVDT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    WMsgid1
     C                   PARM                    DDVDAT
     C                   PARM                    DDMTYP
     C                   PARM                    DDACTN
     C                   PARM                    DDDLNO
     C                   PARM                    H@RCID
     C                   PARM                    H@CCY
     C                   PARM                    H@NTCE
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WProcDate                                    CSC011
     C                   PARM                    BJLCCY
     C                   PARM                    BJDFIN
     C                   PARM                    BJSLCD
     C                   PARM                    @RLOC             3
     C                   PARM                    ValDate
     C                   PARM                    IGVDYY
     C                   PARM                    IGVDMM
     C                   PARM                    IGVDDD
 
      /COPY WNCPYSRC,MMDEAMV004
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDVDatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If Value Date valid set up in Midas Date format for output.
     C     DDVDatOK      IFNE      'N'
     C                   Z-ADD     ValDate       IGDVSD
     C                   ENDIF
 
      /COPY WNCPYSRC,MMDEAMV005
 
      *  *-------------------------------*
      *  * Validate Deal Amendment Type  *  #03
      *  *-------------------------------*
 
      * Reset variables updated by each module before each call
     C                   EXSR      RESETERRS
 
      ** Convert dates used in module MMVDEAMTYP to Midas Day
      ** Number format (5,0)
 
     C                   EXSR      CONVERTDAT
 
     C/COPY WNCPYSRC,MMH00173
     C                   CALLB     'MMVDEAMTYP'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    MSG5
     C                   PARM                    MSG6
     C                   PARM                    MSG7
     C                   PARM                    WMSGID2                                    BUG16257
     C                   PARM                    DDMTYP
     C                   PARM                    DDDLNO
     C                   PARM                    H@DADN
     C                   PARM                    H@VDAT
     C                   PARM                    H@SLDT
     C                   PARM                    H@IADT
     C                   PARM                    H@RCID
     C                   PARM                    H@CPTI
     C                   PARM                    H@MTYP
     C                   PARM                    H@IPFQ
     C                   PARM                    H@NIDT
     C                   PARM                    IGMTYP
     C                   PARM                    ValDate
     C                   PARM                    SLIntDate
     C                   PARM                    IntAcrDate
     C                   PARM                    DDVdatOK
     C                   PARM                    DDDlnoOK
 
      /COPY WNCPYSRC,MMDEAMV006
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   MOVE      'N'           DDMTypOK
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   MOVE      'N'           DDMTypOK
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   MOVE      'N'           DDMTypOK
     C                   ENDIF
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   MOVE      'N'           DDMTypOK
     C                   ENDIF
     C     MSG5          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG5
     C                   MOVE      'N'           DDMTypOK
     C                   ENDIF
     C     MSG6          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDat'
     C                   EVAL      MsgIDArr(Idx) = MSG6
     C                   MOVE      'N'           DDVdatOK
     C                   ENDIF
     C     MSG7          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDlNo'
     C                   EVAL      MsgIDArr(Idx) = MSG7
     C                   MOVE      'N'           DDDlNoOK
     C                   ENDIF
 
     C     WMSGID2       IFNE      *BLANK                                                   BUG16257
     C                   ADD       1             WIdx                                       BUG16257
     C                   EVAL      WFldNamArr(WIdx) = 'DDMTYP'                              BUG16257
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2                                BUG16257
     C                   ENDIF                                                              BUG16257
                                                                                            BUG16257
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDltStpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMDEAMV007
 
      *  *-------------------*
      *  * Validate Currency *  #4
      *  *-------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVDEAMCUR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDCCY
     C                   PARM                    H@CCY
     C                   PARM                    IGCCY
     C                   PARM                    IGCYDP
     C****************** PARM                    SDCURR                                       CSD006
     C     SDCURR        PARM                    DSSDY                                        CSD006
 
      /COPY WNCPYSRC,MMDEAMV008
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY '
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCcyOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      *  *-------------------------------------*
      *  SKIP FURTHER VALIDATION IF ERRORS FOUND
      *  *-------------------------------------*
     C     Idx           IFNE      0
     C                   GOTO      EXITMODULE
     C                   END
 
     C     CRE073        IFEQ      'Y'                                                      AR853219
     C     DDMTYP        IFEQ      'BC'                                                     AR853219
     C     DDMTYP        OREQ      'SC'                                                     AR853219
                                                                                            AR853219
     C     DDFSRP        IFNE      *BLANKS                                                  AR853219
     C                   EVAL      IGFRCF ='Y'                                              AR853219
     C                   ELSE                                                               AR853219
     C                   EVAL      IGFRCF ='N'                                              AR853219
     C                   ENDIF                                                              AR853219
                                                                                            AR853219
      ** Validate Contractual Spread/Sign                                                   AR853219
                                                                                            AR853219
     C                   EXSR      SRSPSG                                                   AR853219
                                                                                            AR853219
      ** Validate Rounding Method                                                           AR853219
                                                                                            AR853219
     C                   EXSR      SRRNDM                                                   AR853219
                                                                                            AR853219
      ** Validate Rounding Fraction/Decimal                                                 AR853219
                                                                                            AR853219
     C                   EXSR      SRRNDF                                                   AR853219
                                                                                            AR853219
      ** If all interest rate rounding related fields are valid                             AR853219
      ** compute for the new spread rate                                                    AR853219
                                                                                            AR853219
     C                   IF        DDCNSPOK = 'Y' AND                                       AR853219
     C                             DDCNSPOK = 'Y' AND                                       AR853219
     C                             DDRDMTOK = 'Y' AND                                       AR853219
     C                             DDRDFDOK = 'Y'                                           AR853219
     C                   EXSR      SRSPRT                                                   AR853219
                                                                                            AR853219
     C                   ENDIF                                                              AR853219
                                                                                            AR853219
     C                   ENDIF                                                              AR853219
                                                                                            AR853219
     C                   ELSE                                                              AR947093A
     C**********         ENDIF                                                    AR853219 AR947093A
      /COPY WNCPYSRC,MMDEAMV009
 
      *  *-------------------------------*
      *  * Validate Interest Rate/Spread *  #5
      *  *-------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVDEAMIRS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDMTYP
     C                   PARM                    DDINTR
     C                   PARM                    BGN0ST
     C                   PARM                    BNDCSP
     C                   PARM                    IGINTR
     C                   PARM                    CDE002                                       CDE002
     C                   PARM                    DDAMNP                                       CDL017
 
      /COPY WNCPYSRC,MMDEAMV010
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINTR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIntrOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF                                                             AR947093A
 
      /COPY WNCPYSRC,MMDEAMV011
 
      *  *-------------------*
      *  * Validate Amount   *  #6
      *  *-------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVDEAMAMT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
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
                                                                                CDL006
      ** Fiduciary charge details                                               CDL006
      ** Fiduciary charge code                                                  CDL006
                                                                                CDL006
     C                   PARM                    IGFCGC                         CDL006
                                                                                CDL006
      ** Fiduciary charge description                                           CDL006
                                                                                CDL006
     C                   PARM                    IGFCGD                         CDL006
                                                                                CDL006
      ** Fiduciary charge amount                                                CDL006
                                                                                CDL006
     C                   PARM                    IGFXGA                         CDL006
     C                   Parm                    CGL011                                       CGL011
     C                   Parm                    HKCOLF                                       CGL011
     C                   Parm                    WMSGID6                                      CGL011
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
 
      /COPY WNCPYSRC,MMDEAMV012
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
                                                                                              CGL011
     C     WMSGID6       IfNe      *BLANK                                                     CGL011
     C                   Add       1             WIdx                                         CGL011
     C                   Eval      WFldNamArr(WIdx) = 'DDAMNP'                                CGL011
     C                   Eval      WMsgIDArr(WIdx) = WMSGID6                                  CGL011
     C                   EndIf                                                                CGL011
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAmnpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMDEAMV013
 
      *  *-------------------------------*
      *  * Validate Funding Spread/Rate  *  #7
      *  *-------------------------------*
 
      ** Only process if Analytical Accounting is switched on in system.    C001
      ** or Revenue Analysis is installed                                                     CDE002
                                                                                             BUG3499
     C                   EVAL      IGFSRP = 0                                                BUG3499
     C**********         EVAL      IGINTR = 0                                        BUG3499 BUG3870
     C**********         IF        CRE073 = 'N'                                     CRE073 AR1006306
                                                                                             BUG3499
     C     BGN0ST        IFEQ      'Y'                                                         CAC00
     C     CDE002        OREQ      'Y'                                                        CDE002
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVDEAMFSR'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    WMsgid1
     C                   PARM                    DDMTYP
     C                   PARM                    DDFSRP
     C                   PARM                    DDINTR
     C                   PARM                    DDDLNO
     C                   PARM                    DDDS38
     C                   PARM                    DDCCY
     C                   PARM                    ValDate
     C                   PARM                    BNDCSP
     C                   PARM                    H@FPRC
     C                   PARM                    H@BSRC
     C                   PARM                    H@SPRD
     C                   PARM                    H@FSRP
     C                   PARM                    H@INTR
     C                   PARM                    H@FSGN
     C                   PARM                    DDIntrOK
     C                   PARM                    IGIRCF
     C                   PARM                    IGFRCF
     C                   PARM                    IGFSRP
     C                   PARM                    IGINTR
     C                   PARM                    BGN0ST                                       CDE002
 
      /COPY WNCPYSRC,MMDEAMV014
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSRP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINTR'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
 
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDFSRP'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
 
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDFsrpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      **********                                                                     CRE073 AR853219
     C**********         ELSE                                                        CRE073 AR853219
      **********                                                                     CRE073 AR853219
     C*****DDMTYP        IFEQ      'BC'                                              CRE073 AR853219
     C*****DDMTYP        OREQ      'SC'                                              CRE073 AR853219
      **********                                                                     CRE073 AR853219
     C*****DDFSRP        IFNE      *BLANKS                                           CRE073 AR853219
     C**********         EVAL      IGFRCF ='Y'                                       CRE073 AR853219
     C**********         ELSE                                                        CRE073 AR853219
     C**********         EVAL      IGFRCF ='N'                                       CRE073 AR853219
     C**********         ENDIF                                                       CRE073 AR853219
      **********                                                                     CRE073 AR853219
      ***Validate*Contractual*Spread/Sign                                            CRE073 AR853219
      **********                                                                     CRE073 AR853219
     C**********         EXSR      SRSPSG                                            CRE073 AR853219
      **********                                                                     CRE073 AR853219
      ***Validate*Rounding*Method                                                    CRE073 AR853219
      **********                                                                     CRE073 AR853219
     C**********         EXSR      SRRNDM                                            CRE073 AR853219
      **********                                                                     CRE073 AR853219
      ***Validate*Rounding*Fraction/Decimal                                          CRE073 AR853219
      **********                                                                     CRE073 AR853219
     C**********         EXSR      SRRNDF                                            CRE073 AR853219
      **********                                                                     CRE073 AR853219
      ***If*all*interest*rate*rounding*related*fields*are*valid                      CRE073 AR853219
      ***compute*for*the*new*spread*rate                                             CRE073 AR853219
      **********                                                                     CRE073 AR853219
     C**********         IF        DDCNSPOK = 'Y' AND                                CRE073 AR853219
     C**********                   DDCNSPOK = 'Y' AND                                CRE073 AR853219
     C**********                   DDRDMTOK = 'Y' AND                                CRE073 AR853219
     C**********                   DDRDFDOK = 'Y'                                    CRE073 AR853219
     C**********         EXSR      SRSPRT                                            CRE073 AR853219
      **********                                                                     CRE073 AR853219
     C**********         ENDIF                                                       CRE073 AR853219
      **********                                                                     CRE073 AR853219
     C**********         ENDIF                                                       CRE073 AR853219
                                                                                              CRE073
     C**********         ENDIF                                                      CRE073 AR1006306
                                                                                              CDL010
      ** Set up The user field from ZMUSER which is the front office                          CDL010
      ** user if sent . Only if CDL010 is installed                                           CDL010
                                                                                              CDL010
     C     CDL010        IFEQ      'Y'                                                        CDL010
     C     DDMTYP        OREQ      'EM'                                                       CDL017
     C                   MOVE      ZUSER         IGUSER                                       CDL010
     C                   END                                                                  CDL010
 
      /COPY WNCPYSRC,MMDEAMV015
 
      *  *------------------------------*                                                     CDL017
      *  * Validate Penalty Pay/Receive *                                                     CDL017
      *  *------------------------------*                                                     CDL017
                                                                                              CDL017
     C                   EXSR      RESETERRS                                                  CDL017
                                                                                              CDL017
     C                   CALLB     'MMVPNLTYPR'                                               CDL017
     C                   PARM                    ReturnCode                                   CDL017
     C                   PARM                    MSG1                                         CDL017
     C                   PARM                    DDPENP                                       CDL017
     C                   PARM                    DDMTYP                                       CDL017
     C                   PARM                    IGPENP                                       CDL017
     C                   PARM                    DDAMNP                                      BUG3735
                                                                                              CDL017
     C     MSG1          IFNE      *BLANK                                                     CDL017
     C                   ADD       1             Idx                                          CDL017
     C                   EVAL      FldNameArr(Idx) = 'DDPENP'                                 CDL017
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL017
     C                   ENDIF                                                                CDL017
                                                                                              CDL017
      ** Use the return code's value to set the field's OK flag                               CDL017
     C                   CALLB     'ZASETOKFLG'                                               CDL017
     C                   PARM                    DDPENPOK                                     CDL017
     C                   PARM                    ReturnCode                                   CDL017
     C                   PARM                    WarnGlobal                                   CDL017
                                                                                              CDL017
      *  *------------------------------*                                                     CDL017
      *  * Validate Early Maturity Date *                                                     CDL017
      *  *------------------------------*                                                     CDL017
     C                   EXSR      RESETERRS                                                  CDL017
                                                                                              CDL017
     C                   CALLB     'MMVERLYMDT'                                               CDL017
     C                   PARM                    ReturnCode                                   CDL017
     C                   PARM                    MSG1                                         CDL017
     C                   PARM                    WMsgid1                                      CDL017
     C                   PARM                    HKMATD                                       CDL017
     C                   PARM                    DDVDAT                                       CDL017
     C                   PARM                    DDMTYP                                       CDL017
     C                   PARM                    BJLCCY                                       CDL017
     C                   PARM                    BJDFIN                                       CDL017
     C                   PARM                    BJSLCD                                       CDL017
     C                   PARM                    DDEMDt                                       CDL017
     C                   PARM                    IGEMDT                                       CDL017
                                                                                              CDL017
     C     MSG1          IFNE      *BLANK                                                     CDL017
     C                   ADD       1             Idx                                          CDL017
     C                   EVAL      FldNameArr(Idx) = 'DDEMDT'                                 CDL017
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL017
     C                   ENDIF                                                                CDL017
                                                                                              CDL017
     C     WMSGID1       IFNE      *BLANK                                                     CDL017
     C                   ADD       1             WIdx                                         CDL017
     C                   EVAL      WFldNamArr(WIdx) = 'DDEMDT'                                CDL017
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1                                  CDL017
     C                   ENDIF                                                                CDL017
                                                                                              CDL017
      ** Use the return code's value to set the field's OK flag                               CDL017
     C                   CALLB     'ZASETOKFLG'                                               CDL017
     C                   PARM                    DDEMDTOK                                     CDL017
     C                   PARM                    ReturnCode                                   CDL017
     C                   PARM                    WarnGlobal                                   CDL017
                                                                                              CDL022
     C/COPY WNCPYSRC,MMH00169
      *  *-------------------------*                                                          CDL022
      *  * Validate Base Rate Code *                                                          CDL022
      *  *-------------------------*                                                          CDL022
     C                   EXSR      RESETERRS                                                  CDL022
                                                                                              CDL022
     C                   CALLB     'MMVBASERAT'                                               CDL022
     C                   PARM                    ReturnCode                                   CDL022
     C                   PARM                    MSG1                                         CDL022
     C                   PARM                    WMSGID1                                      CDL022
     C                   PARM                    DDVDAT                                       CDL022
     C                   PARM                    DDAMNP                                       CDL022
     C                   PARM                    DDCCY                                        CDL022
     C                   PARM                    DDBSRT                                       CDL022
     C                   PARM                    DDMTYP                                       CDL022
     C                   PARM                    IGBSRT                                       CDL022
                                                                                              CDL022
     C     MSG1          IFNE      *BLANK                                                     CDL022
     C                   ADD       1             Idx                                          CDL022
     C                   EVAL      FldNameArr(Idx) = 'DDBSRT'                                 CDL022
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL022
     C                   ENDIF                                                                CDL022
                                                                                              CDL022
     C     WMSGID1       IFNE      *BLANK                                                     CDL022
     C                   ADD       1             WIdx                                         CDL022
     C                   EVAL      WFldNamArr(WIdx) = 'DDBSRT'                                CDL022
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1                                  CDL022
     C                   ENDIF                                                                CDL022
                                                                                              CDL022
      ** Use the return code's value to set the field's OK flag                               CDL022
     C                   CALLB     'ZASETOKFLG'                                               CDL022
     C                   PARM                    DDBSRTOK                                     CDL022
     C                   PARM                    ReturnCode                                   CDL022
     C                   PARM                    WarnGlobal                                   CDL022
                                                                                              CDL020
      *  *-------------------------------*                                                    CDL020
      *  * Validate Actual Interest Rate *                                                    CDL020
      *  *-------------------------------*                                                    CDL020
     C     CDL020        IFEQ      'Y'                                                        CDL020
                                                                                              CDL020
     C                   EXSR      RESETERRS                                                  CDL020
                                                                                             BUG3620
     C     DDMTYP        IFEQ      'SC'                                                      BUG3620
     C                   MOVE      H@BSRC        DDBSRT                                      BUG3620
     C                   ENDIF                                                               BUG3620
                                                                                              CDL020
     C                   CALLB     'MMVDEAMAIR'                                               CDL020
     C                   PARM                    ReturnCode                                   CDL020
     C                   PARM                    MSG1                                         CDL020
     C                   PARM                    DDMTYP                                       CDL020
     C                   PARM                    DDAIR                                        CDL020
     C                   PARM                    BGN0ST                                       CDL020
     C                   PARM                    BNDCSP                                       CDL020
     C                   PARM                    DDCCY                                        CDL020
     C                   PARM                    DDBSRT                                       CDL020
     C                   PARM                    ValDate                                      CDL020
     C                   PARM                    WProcDate                                    CDL020
     C                   PARM                    IGINTR                                       CDL020
     C                   PARM                    IGBRTE                                       CDL020
                                                                                             BUG3620
     C     DDMTYP        IFEQ      'SC'                                                      BUG3620
     C                   MOVE      *BLANKS       DDBSRT                                      BUG3620
     C                   ENDIF                                                               BUG3620
                                                                                              CDL020
     C     MSG1          IFNE      *BLANK                                                     CDL020
     C                   ADD       1             Idx                                          CDL020
     C                   EVAL      FldNameArr(Idx) = 'DDAIR'                                  CDL020
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL020
      ** Use the return code's value to set the field's OK flag                               CDL020
     C                   CALLB     'ZASETOKFLG'                                               CDL020
     C                   PARM                    DDAIROK                                      CDL020
     C                   PARM                    ReturnCode                                   CDL020
     C                   PARM                    WarnGlobal                                   CDL020
                                                                                              CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL020
     C     EXITMODULE    TAG
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMDEAMV018
 
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
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Supplemental Information Data                                           CAP051
     C                   PARM                    InfData                        CAP051
      * Supplemental Extra Data                                                 CAP004
     C                   PARM                    ExtData                        CAP004
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
 
 
      * File / Data area Accesses required for calling parameters
      * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C**  Define Work Fields
     C     *LIKE         DEFINE    HKDN38        H@DN38
     C     *LIKE         DEFINE    HKCNUM        H@CNUM
     C     *LIKE         DEFINE    HKRCID        H@RCID
     C     *LIKE         DEFINE    HKCCY         H@CCY
     C     *LIKE         DEFINE    HKNTCE        H@NTCE
     C     *LIKE         DEFINE    HKDADN        H@DADN
     C     *LIKE         DEFINE    HKVDYY        H@VDYY
     C     *LIKE         DEFINE    HKVDMM        H@VDMM
     C     *LIKE         DEFINE    HKVDDD        H@VDDD
     C     *LIKE         DEFINE    HKSLYY        H@SLYY
     C     *LIKE         DEFINE    HKSLMM        H@SLMM
     C     *LIKE         DEFINE    HKSLDD        H@SLDD
     C     *LIKE         DEFINE    HKIAYY        H@IAYY
     C     *LIKE         DEFINE    HKIAMM        H@IAMM
     C     *LIKE         DEFINE    HKIADD        H@IADD
     C     *LIKE         DEFINE    HKCPTI        H@CPTI
     C     *LIKE         DEFINE    HKMTYP        H@MTYP
     C     *LIKE         DEFINE    HKIPFQ        H@IPFQ
     C     *LIKE         DEFINE    HKNIYY        H@NIYY
     C     *LIKE         DEFINE    HKNIMM        H@NIMM
     C     *LIKE         DEFINE    HKNIDD        H@NIDD
     C     *LIKE         DEFINE    HKAMNP        H@AMNP
     C     *LIKE         DEFINE    HKFPRC        H@FPRC
     C     *LIKE         DEFINE    HKFSGN        H@FSGN
     C     *LIKE         DEFINE    HKFSRP        H@FSRP
     C     *LIKE         DEFINE    HKBSRC        H@BSRC
     C     *LIKE         DEFINE    HKSPRD        H@SPRD
     C     *LIKE         DEFINE    HKINTR        H@INTR
      **********                                                                             BUG6979
      ****GET*ZMUSER*to*access*default*branch.                                               BUG6979
      **********                                                                             BUG6979
     C******DTAARA       DEFINE                  ZMUSER                                      BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
     C**********         UNLOCK    ZMUSER                                                    BUG6979
      **
      **  Move program name into *LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMDEAMVAL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
                                                                                CDL006
      ** Save Charges on Principal Change to export field                       CDL006
                                                                                CDL006
     C                   Eval      B@CHPC = BNCHPC                              CDL006
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access SAR details file to determine if CDL005 is on.
      ** (Customer format in input functions is shortname)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'CDL005'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *                                                                                       CDL011
      ** Access SAR details file to determine if CDL011 is on.                                CDL011
      ** (Expansion of Customer Number on Dealing Transactions)                               CDL011
      *                                                                                       CDL011
     C                   CALLB     'AOSARDR0'                                                 CDL011
     C                   PARM      *BLANKS       @RTCD                                        CDL011
     C                   PARM      '*VERIFY'     @OPTN                                        CDL011
     C                   PARM      'CDL011'      @SARD                                        CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL011
      *                                                                                       CDL011
      * DATABASE ERROR                                                                        CDL011
      *                                                                                       CDL011
     C     @RTCD         IFNE      *BLANKS                                                    CDL011
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL011
     C                   MOVEL     'CDL011'      DBKEY                                        CDL011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL011
     C                   MOVEL     '906'         DBASE                                        CDL011
     C                   EXSR      *PSSR                                                      CDL011
     C                   END                                                                  CDL011
      *                                                                                       CDL011
     C     @RTCD         IFEQ      *BLANK                                                     CDL011
     C                   MOVEL     'S'           CustFormat                                   CDL011
     C                   END                                                                  CDL011
      *                                                                                       CGL011
      ** Access Switchable Features file to check if CGL011                                   CGL011
      ** is installed.                                                                        CGL011
      *                                                                                       CGL011
     C                   Move      'N'           CGL011            1                          CGL011
      *                                                                                       CGL011
     C                   CallB     'AOSARDR0'                                                 CGL011
     C                   Parm      *BLANKS       @RTCD                                        CGL011
     C                   Parm      '*VERIFY'     @OPTN                                        CGL011
     C                   Parm      'CGL011'      @SARD                                        CGL011
     C     SCSARD        Parm      SCSARD        DSFDY                                        CGL011
                                                                                              CGL011
     C     @RTCD         IfNe      *BLANKS                                                    CGL011
     C     @RTCD         AndNe     '*NRF   '                                                  CGL011
     C     *Lock         In        LDA                                                        CGL011
     C                   Z-Add     2             DBASE                                        CGL011
     C                   MoveL     'SCSARDPD'    DBFILE                                       CGL011
     C                   MoveL     'CGL011'      DBKEY                                        CGL011
     C                   Out       LDA                                                        CGL011
     C                   Exsr      *PSSR                                                      CGL011
     C                   EndIf                                                                CGL011
      *                                                                                       CGL011
     C     @RTCD         IfEq      *BLANKS                                                    CGL011
     C                   Move      'Y'           CGL011                                       CGL011
     C                   EndIf                                                                CGL011
      *
      *                                                                         CSE006
      ** Access SAR details file to determine if CSE006 is on.                  CSE006
      ** (Repurchase Agreement Enhancements)                                    CSE006
      *                                                                         CSE006
     C                   CALLB     'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD             6            CSE006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE006
      *                                                                         CSE006
     C     @RTCD         IFNE      *BLANKS                                      CSE006
     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
     C     *LOCK         IN        LDA                                          CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '002'         DBASE                          CSE006
     C                   MOVEL     'CSE006'      DBKEY                          CSE006
     C                   OUT       LDA                                          CSE006
     C                   SETON                                        U7U8LR    CSE006
     C                   EXSR      #TERM                                        CSE006
     C                   END                                                    CSE006
      *                                                                         CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVEL     'Y'           CSE006            1            CSE006
     C                   END                                                    CSE006
      *                                                                                       CDE002
      ** Access SAR details file to determine if CDE002 is switched on                        CDE002
      *                                                                                       CDE002
     C                   CallB     'AOSARDR0'                                                 CDE002
     C                   Parm      *Blanks       PRTCD             7                          CDE002
     C                   Parm      '*VERIFY'     POPTN             7                          CDE002
     C                   Parm      'CDE002'      PSARD             6                          CDE002
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDE002
      *                                                                                       CDE002
     C                   Move      'N'           CDE002            1                          CDE002
     C                   If        PRTCD = *Blanks                                            CDE002
     C                   Eval      CDE002 = 'Y'                                               CDE002
     C                   Endif                                                                CDE002
                                                                                              CSC011
     C                   EVAL      WProcDate = BJRDNB                                         CSC011
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
      ** If 24X7 Midas availability is installed and support system is                        CSC011
      ** active, used processing date from dataarea SC24X7 as the                             CSC011
      ** rundate.                                                                             CSC011
                                                                                              CSC011
     C                   IF        S1SUPP = LIBR                                              CSC011
     C                   EVAL      WProcDate = S1DATE                                         CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 900                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CDL010
      ** Access SAR details file to determine if CDL010 is on.                                CDL010
      ** (Dealing Transaction Authorisation)                                                  CDL010
                                                                                              CDL010
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       PRTCD                                        CDL010
     C                   PARM      '*VERIFY'     POPTN                                        CDL010
     C                   PARM      'CDL010'      PSARD                                        CDL010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
     C                   IF        PRTCD <> *BLANKS AND                                       CDL010
     C                             PRTCD <> '*NRF   '                                         CDL010
     C     *LOCK         IN        LDA                                                        CDL010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
     C                   EVAL      DBASE = 901                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   OUT       LDA                                                        CDL010
     C                   EVAL      *INU7 = *ON                                                CDL010
     C                   EVAL      *INU8 = *ON                                                CDL010
     C                   EVAL      *INLR = *ON                                                CDL010
     C                   EXSR      #TERM                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        PRTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL020
      ** Access SAR details file to determine if CDL020 is switched on                        CDL020
      *                                                                                       CDL020
     C                   CallB     'AOSARDR0'                                                 CDL020
     C                   Parm      *Blanks       PRTCD                                        CDL020
     C                   Parm      '*VERIFY'     POPTN                                        CDL020
     C                   Parm      'CDL020'      PSARD                                        CDL020
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL020
      *                                                                                       CDL020
     C                   Move      'N'           CDL020            1                          CDL020
     C                   If        PRTCD = *Blanks                                            CDL020
     C                   Eval      CDL020 = 'Y'                                               CDL020
     C                   Endif                                                                CDL020
      *                                                                                       CRE073
      ** Access SAR details file to determine if CRE073 is switched on                        CRE073
      *                                                                                       CRE073
     C                   CallB     'AOSARDR0'                                                 CRE073
     C                   Parm      *Blanks       PRTCD                                        CRE073
     C                   Parm      '*VERIFY'     POPTN                                        CRE073
     C                   Parm      'CRE073'      PSARD                                        CRE073
     C     SCSARD        Parm      SCSARD        DSFDY                                        CRE073
      *                                                                                       CRE073
     C                   If        PRTCD = *Blanks                                            CRE073
     C                   Eval      CRE073 = 'Y'                                               CRE073
     C                   Endif                                                                CRE073
     C/COPY WNCPYSRC,MMH00174
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMDEAMV019
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVDEALDTL - Retrieve the original Deal Details of the Deal   *
      *    Amendment and move into common Data Structure              *
      *                                                               *
      *****************************************************************
 
     C     RTVDEALDTL    BEGSR
 
      *                                                                                       258693
      ** for insert - deal number must exist in DEALSDC/DEALSDD                               258693
      *                                                                                       258693
     C                   If        DDACTN = 'X'                                               258693
     C                   MOVE      DDDLNO        DealNum                                      258693
     C     DealNum       Chain     MMDELULL                           64                      258693
     C                   EndIf                                                                258693
                                                                                              258693
      ** Get Original Deal Details
 
     C                   MOVE      DDDLNO        DealNum           6 0
     C     DealNum       CHAIN     MMDEALLL                           65
 
      ** Check for a valid record.
 
     C     *IN65         IFEQ      '1'
     C     HKDLTF        ORNE      *BLANK
     C     MMRECORD      ANDEQ     'MMDELDP0'
     C     HLDLTF        ORNE      *BLANK
     C     MMRECORD      ANDEQ     'MMDENBP0'
     C     MMRECORD      ORNE      'MMDELDP0'
     C     MMRECORD      ANDNE     'MMDENBP0'
     C     DDACTN        OREQ      'X'                                                        258693
     C     *IN64         ANDEQ     *ON                                                        258693
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIdArr(Idx)   = 'MMM0150'
     C                   MOVE      'N'           DDDlnoOK
     C                   END
     C*
     C** Move the Deals file fields to common fields depending
     C** on which format was found.
     C*
     C     MMRECORD      IFEQ      'MMDELDP0'
     C                   MOVE      HKDN38        H@DN38
     C                   MOVE      HKCNUM        H@CNUM
     C                   MOVE      HKRCID        H@RCID
     C                   MOVE      HKCCY         H@CCY
     C                   MOVE      HKNTCE        H@NTCE
     C                   MOVE      HKDADN        H@DADN
     C                   MOVE      HKVDYY        H@VDYY
     C                   MOVE      HKVDMM        H@VDMM
     C                   MOVE      HKVDDD        H@VDDD
     C                   MOVE      HKSLYY        H@SLYY
     C                   MOVE      HKSLMM        H@SLMM
     C                   MOVE      HKSLDD        H@SLDD
     C                   MOVE      HKIAYY        H@IAYY
     C                   MOVE      HKIAMM        H@IAMM
     C                   MOVE      HKIADD        H@IADD
     C                   MOVE      HKCPTI        H@CPTI
     C                   MOVE      HKMTYP        H@MTYP
     C                   MOVE      HKIPFQ        H@IPFQ
     C                   MOVE      HKNIYY        H@NIYY
     C                   MOVE      HKNIMM        H@NIMM
     C                   MOVE      HKNIDD        H@NIDD
     C                   MOVE      HKAMNP        H@AMNP
     C                   MOVE      HKFPRC        H@FPRC
     C                   MOVE      HKFSGN        H@FSGN
     C                   MOVE      HKFSRP        H@FSRP
     C                   MOVE      HKBSRC        H@BSRC
     C                   MOVE      HKSPRD        H@SPRD
     C                   MOVE      HKINTR        H@INTR
     C                   MOVE      HKFCGC        IGFCGC                         CDL006
     C                   MOVE      HKFCGD        IGFCGD                         CDL006
     C                   MOVE      HKBRCA        IGBRCA                                       181274
     C                   END
 
     C     MMRECORD      IFEQ      'MMDENBP0'
     C                   MOVE      HLDN38        H@DN38
     C                   MOVE      HLCNUM        H@CNUM
     C                   MOVE      HLRCID        H@RCID
     C                   MOVE      HLCCY         H@CCY
     C                   Z-ADD     *ZEROS        H@NTCE
     C                   MOVE      HLDADN        H@DADN
     C                   MOVE      HLVDYY        H@VDYY
     C                   MOVE      HLVDMM        H@VDMM
     C                   MOVE      HLVDDD        H@VDDD
     C                   Z-ADD     *ZEROS        H@SLDT
     C                   Z-ADD     *ZEROS        H@IADT
     C                   MOVE      *BLANK        H@CPTI
     C                   MOVE      HLMTYP        H@MTYP
     C                   MOVE      HLIPFQ        H@IPFQ
     C                   MOVE      HLNIYY        H@NIYY
     C                   MOVE      HLNIMM        H@NIMM
     C                   MOVE      HLNIDD        H@NIDD
     C                   MOVE      HLAMNP        H@AMNP
     C                   MOVE      HLFPRC        H@FPRC
     C                   MOVE      HLFSGN        H@FSGN
     C                   MOVE      HLFSRP        H@FSRP
     C                   MOVE      *BLANKS       H@BSRC
     C                   MOVE      *BLANKS       H@SPRD
     C                   MOVE      HLINTR        H@INTR
     C                   MOVE      HLBRCA        IGBRCA                                       181274
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CONVERTDAT - Convert dates from input file format (YYYYMMDD)  *
      *              to Midas Day Numbers (5,0)                       *
      *                                                               *
      *****************************************************************
 
     C     CONVERTDAT    BEGSR
 
      ** Convert Start/Last Interest Date.
 
     C                   Z-ADD     H@SLDT        DateIn
     C
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             SLIntDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   MOVE      DateOut       SLIntDate
     C                   END
     C*
      ** Convert Interest Accrual Date.
     C                   Z-ADD     H@IADT        DateIn
     C
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             IntAcrDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    DateOut
     C                   MOVE      DateOut       IntAcrDate
     C                   END
 
     C                   ENDSR
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRSPSG - Validate Contractual Spread/Sign                    *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPSG        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   MOVE      DDCNSP        PSCRF                                     AR947093A
     C                   CALLB     'ZA0841'                                                AR947093A
     C                   PARM      *BLANKS       PRTCD                                     AR947093A
     C                   PARM                    PSCRF            16                       AR947093A
     C                   PARM      7             PNDEC             2 0                     AR947093A
     C                   PARM      4             PNDIG             2 0                     AR947093A
     C                   PARM      'N'           @@MTID            1                       AR947093A
     C                   PARM      0             @@ERCD            1 0                     AR947093A
     C                   PARM                    @@AMT            15 0                     AR947093A
     C                   PARM                    BNDCSP                                    AR947093A
                                                                                           AR947093A
     C     @@ERCD        IFNE      0                                                       AR947093A
     C                   EVAL      DDCNSPOK = 'N'                                          AR947093A
     C                   EVAL      Idx = Idx + 1                                           AR947093A
     C                   EVAL      FldNameArr(Idx) = 'DDCNSP'                              AR947093A
     C                   EVAL      MsgIDArr(Idx) = 'USR9023'                               AR947093A
     C                   ELSE                                                              AR947093A
                                                                                           AR947093A
     C                   EVAL      WDDBSRT = *BLANKS                                          CRE073
     C                   IF        DDMTYP = 'BC'                                              CRE073
     C                   EVAL      WDDBSRT = DDBSRT                                           CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      WDDBSRT = H@BSRC                                           CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   CALLB     'AOBSRTR0'                                                 CRE073
     C                   PARM      *BLANK        PRTCD                                        CRE073
     C                   PARM      '*KEY'        POPTN                                        CRE073
     C                   PARM                    DDCCY                                        CRE073
     C                   PARM                    WDDBSRT                                      CRE073
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CRE073
     C                                                                                        CRE073
     C                   EVAL      WWBRTT = 0                                                 CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C                   EVAL      WWBRTT = BACBSR                                            CRE073
     C                   ENDIF                                                                CRE073
     C                                                                                        CRE073
     C                   EVAL      WDDBRTT = *BLANKS                                          CRE073
     C                   IF        WWBRTT <> 0                                                CRE073
     C                   EVAL      WDDBRTT = %CHAR(WWBRTT)                                    CRE073
     C                   EVAL      WDDBRTT = %TRIMR(WDDBRTT)                                  CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      ** Need to set this ok flag to Yes because is not existing on OKFlagsDS                 CRE073
     C                   EVAL      DDDCSGOK ='Y'                                              CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    WDDBRTT                                      CRE073
     C                   PARM                    H@BSRC                                       CRE073
     C                   PARM                    WWFXRT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDDCSG                                       CRE073
     C                   PARM      *ZERO         TMCNSP                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDCNSPOK                                     CRE073
     C                   PARM                    DDDCSGOK                                     CRE073
                                                                                           AR947093A
     C                   MOVE      @@AMT         TMCNSP                                    AR947093A
     C                   ENDIF                                                             AR947093A
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRRNDM - Validate Rounding Method                            *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDM        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDRDMTOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRRNDF - Validate Fraction/Decimal                           *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDF        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   EVAL      DDRDFDOK = 'Y'                                             CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDRDFDOK                                     CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRSPRT - Compute for the new spread rate based on the        *                       CRE073
      *           rounding rules                                      *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPRT        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    WWBRTT                                       CRE073
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    DDDCSG                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM      *ZERO         NEWSRT                                       CRE073
     C                   PARM      *ZEROS        NEWFRT                                     AR847249
                                                                                              CRE073
     C                   IF        PRTCD <> *BLANKS                                           CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   EVAL      DDINTR = *BLANKS                                           CRE073
     C**********         IF        NEWFRT = 0 AND                                  AR953104 AR947093
     C**********                   DDRDMT <> *BLANKS                               AR953104 AR947093
     C**********         EVAL      DDRDMTOK = 'N'                                  AR953104 AR947093
     C**********         EVAL      Idx = Idx + 1                                   AR953104 AR947093
     C**********         EVAL      FldNameArr(Idx) = 'DDRDMT'                      AR953104 AR947093
     C**********         EVAL      MsgIDArr(Idx) = 'USS0015'                       AR953104 AR947093
      **********                                                                   AR953104 AR947093
     C**********         EVAL      MsgDtaArr(Idx) = %EDITC(NEWFRT:'J')             AR953104 AR947093
      **********                                                                   AR953104 AR947093
     C**********         ELSE                                                      AR953104 AR947093
     C                   IF        NEWSRT <> *ZERO                                            CRE073
     C                   EVAL      DDINTR = %CHAR(NEWSRT)                                     CRE073
     C                   EVAL      DDINTR = %TRIMR(DDINTR)                                    CRE073
     C                   EVAL      IGINTR = NEWSRT                                         AR947093A
     C                   ENDIF                                                                CRE073
     C**********         ENDIF                                                     AR953104 AR947093
                                                                                              CRE073
     C                   EVAL      IGCNSP = TMCNSP                                            CRE073
     C                   EVAL      IGCNSG = 'A'                                               CRE073
     C                   EVAL      IGRDMT = DDRDMT                                            CRE073
     C                   EVAL      IGRDFD = DDRDFD                                            CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7
 
     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4
     C                   RESET                   WMsgID5
     C                   RESET                   WMsgID6                                      CGL011
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #TERM    - Termination processing.                            *
      *                                                               *
      *****************************************************************
     C     #TERM         BEGSR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,DBERREXIT
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
