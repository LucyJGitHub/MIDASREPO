     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments validation control 4')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY4VL - Outgoing Payments Validation Control 4           *
      *                                                               *
      *  Function:  This API module will serve as the validation mo   *
      *             dule for all the Charges and Commissions input    *
      *             fields. All existing validations of these fields  *
      *             from the previous modules (FTOPAY2VL and FTOPAY3  *
      *             VL) did not change aside from the additional vali *
      *             dations for MT103 fields being introduced.        *
      *                                                               *
      *  Called By: FTOPAY1SN                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055656           Date 20Apr20               *
      *  Prev Amend No. MD021318           Date 26Jul13               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042042           Date 14Feb17               *
      *                 CFT157             Date 29Aug14               *
      *                 CSW213             Date 03Jun13               *
      *                 AR1028639          Date 17Dec12               *
      *                 260510             Date 28Sep12               *
      *                 257125             Date 28Sep12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 255428             Date 04Dec08               *
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      *                 247142             Date 01Jun07               *
      *                 247506             Date 03May07               *
      *                 241255             Date 19Sep06               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 240689             Date 29Jun06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      *                 CAP084             Date 14Jul03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CFT017             Date 08Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 03Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055656 - OPAY messages sent via JMS API end in error       *
      *             (ERZ248) (Recompile)                              *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042042 - Input Officer 1 and Input Officer 2 are being     *
      *             populated with WIP authoriser. Use the WIP input  *
      *             user profile instead.                             *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  AR1028639 - MMA0574 is encountered on vat charge formatting  *
      *              when ccy involved has 0 decimal places.          *
      *              (Child: AR1028640)                               *
      *  260510 - Charges showing in Settle ccy should be ccy of CDRO *
      *  257125 - CAR CFT120 Charge display error                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  255428 - Apply client fix 255930                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning. Apply fix 210654.*
      *  210654 - Check for blocked and referred accounts.            *
      *           Same fix with 240689.                               *
      *  247506 - If "Charges to the Debit of" field is non-blank,    *
      *           Payment Authorisation Charges Currency is default   *
      *           for the transaction instead of Base Currency.       *
      *  241255 - Remove condition SRCRM = *Blanks and change to      *
      *           SACTION = 'I' so that the default receivers charges *
      *           will be calculated during insert.                   *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240689 - Applied fix 210654 + additional changes by 232151   *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD                *
      *  CFT017 - Multilateral Inter-bank Exchange Fee.               *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *                                                                                       CFT017
     FMEISOCL1  IF   E           K DISK                                                       CFT017
      ** Midas ME SWIFT ISO Country Codes retrieval index                                     CFT017
      *                                                                                       CFT017
 
      *****************************************************************
      /EJECT
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
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
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInThir    E DS                  EXTNAME(FTOPY4PD)
 
      ** Payment Extension Details layout
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)
     D TranInThrB    E DS                  EXTNAME(FTOPY5PD)
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)
 
      ** FT (OPAY) Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
 
      ** Valid Payments layout
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
 
      ** Valid Outgoing Payments Extension File
     D ValidPmtX     E DS                  EXTNAME(FTVOPY2PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)
 
      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D @CDRO1        E                     EXTFLD(@CDRQQ)                                     CGL029
                                                                                CFT009
      ** Valid Outgoing Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
     D ZMUSER          DS            17                                                       CAP084
     D  WUSRID                 1     10                                                       CAP084
                                                                                              CAP084
      ** Switchable Features File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                         CFT009
      ** External DS for Currency details                                       CFT009
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CFT009
      *                                                                                       CFT017
      ** General Ledger details                                                               CFT017
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CFT017
      *                                                                                       CFT017
      ** Funds Transfer details                                                               CFT017
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                                  CFT017
      *                                                                                       CFT017
      ** Location code details                                                                CFT017
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  CFT017
      *                                                                                       CFT017
      ** Country code details                                                                 CFT017
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                  CFT017
      *                                                                                       CFT017
      ** Account details                                                                      CFT017
     D SDACCT        E DS                  EXTNAME(ACCNTAB)                                   CFT017
     D  WARECI       E                     EXTFLD(RECI)                                       CFT017
     D  WABRCA       E                     EXTFLD(BRCA)                                       CFT017
     D  WALCD        E                     EXTFLD(LCD)                                        CFT017
      *                                                                                       CFT017
      ** Counterparty details                                                                 CFT017
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                  CFT017
      *                                                                                       CFT017
      ** Customer details                                                                     CFT017
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CFT017
      *                                                                                       CFT017
      ** Nostro details                                                                       CFT017
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CFT017
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      *                                                                                       CFT017
      ** Branch details                                                                       CFT017
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CFT017
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      *                                                                                       CFT017
      ** BIC details                                                                          CFT017
     D MEBICD        E DS                  EXTNAME(MEBICDPD)                                  CFT017
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D TCNTRL          DS           256
     D  WPDTI                  1      1
     D  WGLUI                  4      4
     D  WVATF                  6      6
 
      ** Data structure to retrieve VAT rate
     DVATDS            DS
     D WVATR                  10     12P 4
                                                                                CFT009
     D Trans_Det       DS          3000                                         CFT009
      *  Transaction details file DS for FT000984                               CFT009
                                                                                CFT009
     D Trans_Ext       DS          3000                                         CFT009
      *  Transaction details extension file DS for FT000984                     CFT009
                                                                                CFT009
     D File_Detail   E DS                  EXTNAME(OTPAYDD)                     CFT009
     D                                     PREFIX(F_)                           CFT009
      *  Transaction details file                                               CFT009
                                                                                CFT009
     D File_Ext      E DS                  EXTNAME(OTPAYXPD)                    CFT009
      *  Transaction details extension file                                     CFT009
 
     D/COPY WNCPYSRC,FTH00251
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                CFT009
      * Parameters for ZALIGN/ZEDIT                                             CFT009
                                                                                CFT009
     D ZFIELD          S             16                                         CFT009
     D ZADEC           S              1  0                                      CFT009
     D ZALIGNOK        S              1                                         CFT009
     D ZADIG           S              2  0                                      CFT009
                                                                                CFT009
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
 
      ** A code to indicate the calling function to the lower level modules
     D OPAY            S              4A   INZ('OPAY')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
     D I               S              3  0
      *                                                                         CFT009
      ** Access object parameters                                               CFT009
     D*PRtcd****       S              1A                                               CFT009 CFT017
     D POptn           S              7A                                        CFT009
                                                                                CFT009
     D PReDspChg       S              1A                                        CFT009
     D CFT120          S              1A                                                      CFT120
                                                                                              CRE067
     D C#ACTN          S              8                                                       CRE067
     D C#RTCD          S              7                                                       CRE067
                                                                                              CRE067
     D WDATE           S              5  0                                                    CRE067
     D PMode           S              6A                                                    MD021318
                                                                                              CRE067
     D ##DTA           DS           256                                                       CRE067
     D  ##FCCY                 1      3                                                       CRE067
     D  ##FAMT                 4     11P 0                                                    CRE067
     D  ##TCCY                12     14                                                       CRE067
     D  ##TAMT                15     22P 0                                                    CRE067
     D  ##IMDIN               23     23                                                       CRE067
     D  ##IRATE               24     36P 8                                                    CRE067
     D  ##OMDIN               23     23                                                       CRE067
     D  ##ORATE               24     36P 8                                                    CRE067
 
     D InputUser       S             10A                                                    MD042042
      **  Data Structure for input/output parameters
     D/COPY FTCPYSRC,FT0010D001
     D/COPY WNCPYSRC,FTH00253
 
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
 
      ** Initial Processing
 
     C                   ExSr      SrInit
      *                                                                                       260510
      ** Validate Details of Charges                                                          260510
      *                                                                                       260510
     C                   ExSr      SrDetChg                                                   260510
 
      ** Validate Charges to the debit of account
 
     C                   ExSr      SrChgDbA
 
      ***Validate*Details*of*Charges***********************************                       260510
      *****************************************************************                       260510
     C**********         If        OKCDRO  =  'Y' AND CFT120 = 'Y'                     CFT120 260510
     C**********                   OR CFT120 <> 'Y'                                    CFT120 260510
     C**********         ExSr      SrDetChg
      *                                                                         CFT009
      ** Determine Charge Currencies based on 'Charges to the Debit of'         CFT009
      ** Customer.                                                              CFT009
      *                                                                         CFT009
      ** Sort out charge Currencu even if CFT009 is not On                                    CFT120
     C**********         IF        @CFT009 = 'Y'                                       CFT009 CFT120
     C                   IF        @CFT009 = 'Y' AND CFT120 <> 'Y'                     CFT009 CFT120
     C                             OR CFT120 = 'Y'                                            CFT120
     C                   EXSR      SRCCCY                                       CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** If CFT009 is on, default receivers charges remitted field.             CFT009
                                                                                CFT009
     C                   If        @CFT009 = 'Y' and SDTCH = 'OUR'              CFT009
     C**********                   and SRCRM = *blanks and SADDC = 'A'                 CFT009 241255
     C                             and SACTION = 'I' and SADDC = 'A'                          241255
      *                                                                                       CFT017
      ** Set up an indicator which says receiver's charges has been                           CFT017
      ** defaulted by CFT009.                                                                 CFT017
      *                                                                                       CFT017
     C                   MOVEL     'Y'           WDefRCRM                                     CFT017
                                                                                CFT009
      ** Set up the file DS for call to FT000984                                CFT009
     C                   ExSr      Setup_984_fld                                CFT009
                                                                                CFT009
      ** Call FT000984                                                          CFT009
     C                   ExSr      Sub_984                                      CFT009
                                                                                CFT009
      ** Format and set up screen field for receivers charges remitted.         CFT009
                                                                                CFT009
     C                   ExSr      Fmt_984                                      CFT009
                                                                                CFT009
     C                   EndIf                                                  CFT009
      *                                                                                       CFT017
      ** Determine if MIF is applicable for this transaction                                  CFT017
      *                                                                                       CFT017
     C                   IF        CFT017 = 'Y'                                               CFT017
     C                   EXSR      SRMIF                                                      CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** If MIF = 'Y', default receiver's charges to multilateral                             CFT017
      ** inter-bank fee defined in FT ICD.                                                    CFT017
      *                                                                                       CFT017
     C                   IF        WVMIFF = 'Y' AND                                           CFT017
     C                             (SRCRM = *BLANKS OR WDefRCRM = 'Y')                        CFT017
      *                                                                                       CFT017
      ** Get currency details of BKEURO                                                       CFT017
     C                   EVAL      PCYCD = BKEURO                                             CFT017
     C                   EVAL      WACCS = 'U'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
      *                                                                                       CFT017
      ** Format amount using ZEDIT                                                            CFT017
     C                   EVAL      ZFIELD = *BLANKS                                           CFT017
     C                   MOVE      BTMIFE        ZFIELD                                       CFT017
     C                   EVAL      ZADEC = A6NBDP                                             CFT017
      *                                                                                       CFT017
     C                   CALLB     'ZEDIT'                                                    CFT017
     C                   PARM                    ZFIELD                                       CFT017
     C                   PARM                    ZADEC                                        CFT017
      *                                                                                       CFT017
     C                   MOVE      ZFIELD        SRCRM                                        CFT017
     C                   ENDIF                                                                CFT017
 
      ** Validate Transfer Commission Charges
 
     C                   ExSr      SrTrfCom
 
      ** Validate F/Xchange Commission Charges
 
     C                   If        @01494 = 'Y'
     C                   ExSr      SrComChg
     C                   EndIf
 
      ** Validate Telex Charges
 
     C                   ExSr      SrTlxChg
 
      ** Validate Cheque Charges
 
     C                   ExSr      SrChqChg
 
      ** Validate Costs Abroad
 
     C                   ExSr      SrCstAbr
 
      ** Validate Swift Priority Charges
 
     C                   ExSr      SrSwpChg
 
      ** Validate Miscellaneous Charges
 
     C                   ExSr      SrMscChg
                                                                                CFT009
      ** Validate Swift Standard Charges and Miscellaneous 1-5 Charges          CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   EXSR      SRSWSCCC                                     CFT009
     C                   EXSR      SRMS1CHG                                     CFT009
     C                   EXSR      SRMS2CHG                                     CFT009
     C                   EXSR      SRMS3CHG                                     CFT009
     C                   EXSR      SRMS4CHG                                     CFT009
     C                   EXSR      SRMS5CHG                                     CFT009
     C                   ENDIF                                                  CFT009
 
      ** Validate VAT Flags and Calculate charges
 
     C                   If        @VATP = 'Y'
     C                   ExSr      SrVatFlg
     C**********         EndIf                                                             AR1028639
                                                                                              CRE067
     C                   EXSR      SRVATFLD                                                   CRE067
     C                   IF        @TVAT = 'Y'                                                CRE067
     C                   EXSR      SRCNVAMT                                                   CRE067
     C                   ENDIF                                                                CRE067
     C                   ENDIF                                                             AR1028639
 
      ** Validate Total Charges (Pay Amount)
 
     C                   ExSr      SrTotChg
 
     C                   If        @CFT014 = 'Y'
      ** Validate Receiver's Charges
 
     C                   ExSr      SrRcvChg
 
      ** Validate Sender's Charges
 
     C                   ExSr      SrSdrChg
     C                   EndIf
     C**********         ENDIF                                                         CFT120 260510
 
     C/COPY WNCPYSRC,FTOPA4VC01
      ** Setup outstanding fields for valid file when no error is encoun -
      ** tered
 
     C                   If        Idx = *Zero
     C                   ExSr      SetupValid
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      /Title Sr/SrChgDbA
      *****************************************************************
      *                                                               *
      * SR/SrChgDbA  - Validate Charges of Debit of                   *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVCSRF    - Charges to the Debit of Validation Module       *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrChgDbA      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Charges to Debit of entry
 
     C                   CallB     'FTVCSRF'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    PMode                                      MD021318
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrDetChg
      *****************************************************************
      *                                                               *
      * SR/SrDetChg  - Validate Details of Charges                    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVDECH    - Details of Charges Validation Module            *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrDetChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Details of Charges entry
 
     C                   CallB     'FTVDECH'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   Parm                    TranInPrim                                   255428
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrTrfCom
      *****************************************************************
      *                                                               *
      * SR/SrTrfCom  - Validate Transfer Commission Charges           *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVTFCH    - Transfer Commission Charges Validation Module   *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrTrfCom      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Transfer Commission Charges entry
 
     C                   CallB     'FTVTFCH'
     C                   Parm                    ReTCodeOut
     C                   PARM                    TRANINPRIM                     CFT009
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrComChg
      *****************************************************************
      *                                                               *
      * SR/SrComChg  - Validate FX/Change Commission Charges          *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVCMCH    - FX/Change Commission Charges Validation Module  *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrComChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate FX/Change Commission Charges entry
 
     C                   CallB     'FTVCMCH'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrTlxChg
      *****************************************************************
      *                                                               *
      * SR/SrTlxChg  - Validate Telex Charge                          *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVTLCH    - Telex Charge Validation Module                  *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrTlxChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Telex Charge entry
 
     C                   CallB     'FTVTLCH'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrChqChg
      *****************************************************************
      *                                                               *
      * SR/SrChqChg  - Validate Cheque Charge                         *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVCQCH    - Cheque Charge Validation Module                 *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrChqChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Cheque Charge entry
 
     C                   CallB     'FTVCQCH'
     C                   Parm                    ReTCodeOut
     C                   PARM                    TRANINPRIM                     CFT009
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrCstAbr
      *****************************************************************
      *                                                               *
      * SR/SrCstAbr  - Validate Costs Abroad                          *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVCTAB    - Costs Abroad Validation Module                  *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrCstAbr      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Costs Abroad entry
 
     C                   CallB     'FTVCTAB'
     C                   Parm                    ReTCodeOut
     C                   PARM                    TRANINPRIM                     CFT009
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrSwsChg                                                        CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/SWSWSCCC  - Validate SWIFT Standard Charge                 *         CFT009
      *                                                               *         CFT009
      * Called By: Main Routine                                       *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *  RESETERRS  - Resets variables updated by each modules        *         CFT009
      *  FTVSFCH01  - Swift Standard Charge Validation Module         *         CFT009
      *  UPDATERRS  - Updates error information                       *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     SRSWSCCC      BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      RESETERRS                                    CFT009
                                                                                CFT009
      ** Validate Swift Standard Charge entry                                   CFT009
                                                                                CFT009
     C                   CALLB     'FTVSFCH01'                                  CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINFOUR                     CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
                                                                                CFT009
      ** Update error info with that retured from the validation module         CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /Title Sr/SrMs1Chg                                                        CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/SWMS1CHG  - Validate Miscellaneous Charge 1                *         CFT009
      *                                                               *         CFT009
      * Called By: Main Routine                                       *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *  RESETERRS  - Resets variables updated by each modules        *         CFT009
      *  FTVMCCH01  - Miscellaneous Charge 1 Validation Module        *         CFT009
      *  UPDATERRS  - Updates error information                       *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     SRMS1CHG      BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      RESETERRS                                    CFT009
                                                                                CFT009
      ** Validate Miscellaneous Charge 1 entry                                  CFT009
                                                                                CFT009
     C                   CALLB     'FTVMCCH01'                                  CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINFOUR                     CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
                                                                                CFT009
      ** Update error info with that retured from the validation module         CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /Title Sr/SrMs2Chg                                                        CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/SWMS2CHG  - Validate Miscellaneous Charge 2                *         CFT009
      *                                                               *         CFT009
      * Called By: Main Routine                                       *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *  RESETERRS  - Resets variables updated by each modules        *         CFT009
      *  FTVMCCH02  - Miscellaneous Charge 2 Validation Module        *         CFT009
      *  UPDATERRS  - Updates error information                       *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     SRMS2CHG      BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      RESETERRS                                    CFT009
                                                                                CFT009
      ** Validate Miscellaneous Charge 2 entry                                  CFT009
                                                                                CFT009
     C                   CALLB     'FTVMCCH02'                                  CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINFOUR                     CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
                                                                                CFT009
      ** Update error info with that retured from the validation module         CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /Title Sr/SrMs3Chg                                                        CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/SWMS3CHG  - Validate Miscellaneous Charge 3                *         CFT009
      *                                                               *         CFT009
      * Called By: Main Routine                                       *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *  RESETERRS  - Resets variables updated by each modules        *         CFT009
      *  FTVMCCH03  - Miscellaneous Charge 3 Validation Module        *         CFT009
      *  UPDATERRS  - Updates error information                       *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     SRMS3CHG      BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      RESETERRS                                    CFT009
                                                                                CFT009
      ** Validate Miscellaneous Charge 3 entry                                  CFT009
                                                                                CFT009
     C                   CALLB     'FTVMCCH03'                                  CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINFOUR                     CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
                                                                                CFT009
      ** Update error info with that retured from the validation module         CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /Title Sr/SrMs4Chg                                                        CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/SWMS4CHG  - Validate Miscellaneous Charge 4                *         CFT009
      *                                                               *         CFT009
      * Called By: Main Routine                                       *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *  RESETERRS  - Resets variables updated by each modules        *         CFT009
      *  FTVMCCH04  - Miscellaneous Charge 4 Validation Module        *         CFT009
      *  UPDATERRS  - Updates error information                       *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     SRMS4CHG      BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      RESETERRS                                    CFT009
                                                                                CFT009
      ** Validate Miscellaneous Charge 4 entry                                  CFT009
                                                                                CFT009
     C                   CALLB     'FTVMCCH04'                                  CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINFOUR                     CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
                                                                                CFT009
      ** Update error info with that retured from the validation module         CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /Title Sr/SrMs5Chg                                                        CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/SWMS5CHG  - Validate Miscellaneous Charge 5                *         CFT009
      *                                                               *         CFT009
      * Called By: Main Routine                                       *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *  RESETERRS  - Resets variables updated by each modules        *         CFT009
      *  FTVMCCH05  - Miscellaneous Charge 5 Validation Module        *         CFT009
      *  UPDATERRS  - Updates error information                       *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     SRMS5CHG      BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      RESETERRS                                    CFT009
                                                                                CFT009
      ** Validate Miscellaneous Charge 5 entry                                  CFT009
                                                                                CFT009
     C                   CALLB     'FTVMCCH05'                                  CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINFOUR                     CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
                                                                                CFT009
      ** Update error info with that retured from the validation module         CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /Title Sr/SrSwpChg
      *****************************************************************
      *                                                               *
      * SR/SrSwpChg  - Validate SWIFT Priority Charge                 *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVSFCH    - Swift Priority Charge Validation Module         *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrSwpChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Swift Priority Charge entry
 
     C                   CallB     'FTVSFCH'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrMscChg
      *****************************************************************
      *                                                               *
      * SR/SrMscChg  - Validate Miscellaneous Charge                  *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVMCCH    - Miscellaneous Charge Validation Module          *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrMscChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Miscellaneous Charge entry
 
     C                   CallB     'FTVMCCH'
     C                   Parm                    ReTCodeOut
     C                   PARM                    TRANINPRIM                     CFT009
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTXAR                      CFT009
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG                       CFT009
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrVatFlg
      *****************************************************************
      *                                                               *
      * SR/SrMscChg  - Validate VAT Flags                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVVTIN    - Vat Flags Validation Module                     *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrVatFlg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate VAT Flags entries
 
     C                   CallB     'FTVVTIN'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************                       CRE067
      /Title Sr/SrVatFld                                                                      CRE067
      *****************************************************************                       CRE067
      *                                                               *                       CRE067
      * SR/SrVatFld  - Validate VAT Field                             *                       CRE067
      *                                                               *                       CRE067
      * Called By: Main Routine                                       *                       CRE067
      *                                                               *                       CRE067
      * Calls:                                                        *                       CRE067
      *  RESETERRS  - Resets variables updated by each modules        *                       CRE067
      *  FTVTVAT    - Vat Field Validation Module                     *                       CRE067
      *  UPDATERRS  - Updates error information                       *                       CRE067
      *                                                               *                       CRE067
      *****************************************************************                       CRE067
                                                                                              CRE067
     C     SRVATFLD      BEGSR                                                                CRE067
                                                                                              CRE067
      ** Reset variables updated by other modules                                             CRE067
                                                                                              CRE067
     C                   EXSR      ResetErrs                                                  CRE067
                                                                                              CRE067
      ** Validate VAT Flags entries                                                           CRE067
                                                                                              CRE067
     C                   CALLB     'FTVTVAT'                                                  CRE067
     C                   PARM                    ReTCodeOut                                   CRE067
     C                   PARM                    TranInFour                                   CRE067
     C                   PARM                    FldNamXAr                                    CRE067
     C                   PARM                    MsgIDXAr                                     CRE067
     C                   PARM                    MsgDtaXAr                                    CRE067
     C                   PARM                    OKFlagsDS                                    CRE067
     C                   PARM                    Val@Fields                                   CRE067
                                                                                              CRE067
      ** Update error info with that retured from the validation module                       CRE067
                                                                                              CRE067
     C                   EXSR      UpdatErrs                                                  CRE067
                                                                                              CRE067
     C                   ENDSR                                                                CRE067
      *****************************************************************                       CRE067
      /Title Sr/SrCnvAmt                                                                      CRE067
      *****************************************************************                       CRE067
      *                                                               *                       CRE067
      * SR/SrCnvAmt - Convert VAT amount                              *                       CRE067
      *                                                               *                       CRE067
      * Called By: Main Routine                                       *                       CRE067
      *                                                               *                       CRE067
      * Calls:                                                        *                       CRE067
      *  FT0010     - Currency conversion/validation                  *                       CRE067
      *  FTCALCLEV  - Calculate levied charge                         *                       CRE067
      *  AOCCYCV0   - Convert Currency amount                         *                       CRE067
      *                                                               *                       CRE067
      *****************************************************************                       CRE067
                                                                                              CRE067
     C     SRCNVAMT      BEGSR                                                                CRE067
     C                                                                                        CRE067
     C                   IF        @VATD <> *ZERO                                             CRE067
                                                                                              CRE067
     C                   IF        @CEU006 = 'Y'                                              CRE067
     C                             AND @CFT009 = 'N'                                          CRE067
                                                                                              CRE067
     C* If EMU FT Enhancement is switched on then call FT0010                                 CRE067
     C                   CLEAR                   P#0010                                       CRE067
     C                   EVAL      P#FRCY = @CCCY                                             CRE067
     C                   EVAL      P#FRAM = @VATD                                             CRE067
     C                   EVAL      P#FRDT = WDATE                                             CRE067
     C                   EVAL      P#TOCY = @RCCY                                             CRE067
     C                   EVAL      P#TODT = WDATE                                             CRE067
                                                                                              CRE067
     C                   CALL      'FT0010'                                                   CRE067
     C                   PARM                    P#0010                                       CRE067
                                                                                              CRE067
      *  Check if database error occurred                                                     CRE067
     C                   IF        P#RTCD <> *Blanks                                          CRE067
     C                   MOVEL     'FTVCHPY'     DBPGM                                        CRE067
     C                   MOVEL     'FT0010'      DBFILE                                       CRE067
     C                   Z-ADD     7             DBASE                                        CRE067
     C                   MOVEL     P#TOCY        DBKEY                                        CRE067
     C                   EXSR      *PSSR                                                      CRE067
     C                   End                                                                  CRE067
                                                                                              CRE067
     C                   EVAL      @VATT =  P#TOAM                                            CRE067
                                                                                              CRE067
     C                   ELSE                                                                 CRE067
      *                                                                                       CRE067
     C                   CLEAR                   ##DTA                                        CRE067
     C                   EVAL      ##FAMT = @VATD                                             CRE067
     C                   EVAL      ##FCCY = @CCCY                                             CRE067
     C                   EVAL      ##TCCY = @RCCY                                             CRE067
                                                                                              CRE067
      ** Change to use FTCALCLEV, if CFT009 is turned on.                                     CRE067
                                                                                              CRE067
     C                   IF        @CFT009 = 'Y'                                              CRE067
                                                                                              CRE067
     C                   CALLB     'FTCALCLEV'                                                CRE067
     C                   PARM      *BLANKS       PRet_Code        10                          CRE067
     C                   PARM      @VATD         PCharge_Amt      13 0                        CRE067
     C                   PARM      SPCCY         PPay_Ccy          3                          CRE067
     C                   PARM      SSMCY         PSettle_Ccy       3                          CRE067
     C                   PARM      @CCCY         PCharge_Ccy       3                          CRE067
     C                   PARM      @RCCY         PLev_Ccy          3                          CRE067
     C                   PARM      Rate_To_Use   PExch_Rate       13 8                        CRE067
     C                   PARM      *ZEROS        PLev_Charge      13 0                        CRE067
     C                   PARM      *BLANKS       PLev_Charge_F    16                          CRE067
                                                                                              CRE067
     C                   Z-ADD     PLev_Charge   @TRCM                                        CRE067
                                                                                              CRE067
     C                   ELSE                                                                 CRE067
                                                                                              CRE067
     C                   CALL      'AOCCYCV0'                                                 CRE067
     C                   PARM      *BLANKS       C#RTCD                                       CRE067
     C                   PARM      '*F*T*SPT'    C#ACTN                                       CRE067
     C     ##DTA         PARM                    ##DTA                                        CRE067
                                                                                              CRE067
     C                   IF        C#RTCD <> *Blanks                                          CRE067
     C                   MOVEL     'FTVCHPY'     DBPGM                                        CRE067
     C                   MOVEL     'AOCCYCV0'    DBFILE                                       CRE067
     C                   Z-ADD     8             DBASE                                        CRE067
     C                   MOVEL     '*CALL'       DBKEY                                        CRE067
     C                   EXSR      *PSSR                                                      CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
      * Set Valid Fields                                                                      CRE067
     C                   EVAL      @VATT =  ##TAMT                                            CRE067
                                                                                              CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      @VATT = *ZERO                                              CRE067
     C                   ENDIF                                                                CRE067
     C                                                                                        CRE067
     C                   ENDSR                                                                CRE067
      *****************************************************************
      /Title Sr/SrTotChg
      *****************************************************************
      *                                                               *
      * SR/SrTotChg  - Validate Total Charges                         *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVCHPY    - Total Charges Validation Module                 *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrTotChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Total Charges
 
     C                   CallB     'FTVCHPY'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   Parm                    O2XRTE                         CFT009
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrRcvChg
      *****************************************************************
      *                                                               *
      * SR/SrRcvChg  - Validate Receiver's Charges                    *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVRCRM    - Receiver's Charges Validation Module            *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrRcvChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Receiver's Charges
 
     C                   CallB     'FTVRCRM'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    CFT017
     C                   PARM                    WMsgIdXAr                                    CFT017
     C                   PARM                    WMsgDtXAr                                    CFT017
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
     C                   Parm                    CFT017                                       CFT017
     C                   Parm                    WVMIFF                                       CFT017
     C                   Parm                    BTMIFE                                       CFT017
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrSdrChg
      *****************************************************************
      *                                                               *
      * SR/SrSdrChg  - Validate Sender's Charges                      *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVSCHG    - Sender's Charges Validation Module              *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
 
     C     SrSdrChg      BegSr
 
      ** Reset variables updated by other modules
 
     C                   ExSr      ResetErrs
 
      ** Validate Sender's Charges
 
     C                   CallB     'FTVSCHG'
     C                   Parm                    ReTCodeOut
     C                   Parm                    TranInPrim
     C                   Parm                    TranInFour
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    OKFlagsDS
     C                   Parm                    Val@Fields
 
      ** Update error info with that retured from the validation module
 
     C                   ExSr      UpdatErrs
 
     C                   EndSr
 
      *****************************************************************         CFT009
      /EJECT                                                                    CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  SRCCcy - Recalculate charges if Charge to Debit account      *         CFT009
      *           has been changed.                                   *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
     C     SRCCcy        BEGSR                                                  CFT009
                                                                                CFT009
      ** Set Input and Ouput currency to Base currency if                       CFT009
      ** 'Charges to Debit Of' customer has been changed.                       CFT009
      ** If CFT120 is on, set input to ICD charge currency and output                         CFT120
      ** to currency of the CDRO                                                              CFT120
      *------------------------------------------------------------------------------         247506
      **   The following lines are redundant with Java Front End at Midas Plus                247506
      **   1.3, because FTOPAYDP sets the value PCDROCHG, which is not run from               247506
      **   FTOPAYVU: instead fix 187056 in the validation module FTVCSRF has                  247506
      **   corrected the charges currencies; the only addition is to set up                   247506
      **   parameter O2CCDE (Charges Currency) and O2XRTE cross rate; O2CCDE                  247506
      **   is the default Charges Currency of transaction and updates OPCHGC on               247506
      **   the ext. file FTOPAYXPD in FTOPAYUPD: this is the Charge Currency seen             247506
      **   on the authorisation screen F9 of FT0060 when you authorise an OP.                 247506
      *------------------------------------------------------------------------------         247506
                                                                                CFT009
     C                   IF        PCDROCHG = 'Y'                               CFT009
                                                                                CFT009
      ** Redisplay screen to show new default charges.                          CFT009
     C                   EVAL      PReDspChg = 'Y'                              CFT009
                                                                                CFT009
      ** If charges to the debit of field is filled in, set charge ccy          CFT009
      ** to be the base currency                                                CFT009
     C                   If        SCDRO <> *BLANKS                             CFT009
     C                   If        SCDRC =  *BLANKS AND CFT120 = 'Y'                          CFT120
     C                             OR CFT120 <> 'Y'                                           CFT120
                                                                                CFT009
      ** Get Base currency no. of decimal places.                               CFT009
     C                   CALLB     'AOCURRR0'                                   CFT009
     C                   PARM      *BLANK        PRtcd                          CFT009
     C                   PARM      '*KEY   '     POptn                          CFT009
     C                   PARM                    BJCYCD                         CFT009
     C     SDCURR        PARM      SDCURR        DSSDY                          CFT009
      *                                                                         CFT009
     C     PRTCD         IFNE      *BLANKS                                      CFT009
     C                   MOVEL     BJCYCD        DBKEY                          CFT009
     C                   MOVEL     'SDCURRPD'    DBFILE                         CFT009
     C                   Z-ADD     1             DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
      ** Get Charges DR Of Currency decimal places                                            CFT120
     C                   CALLB     'AOCURRR0'                                                 CFT120
     C                   PARM      *BLANK        PRtcd                                        CFT120
     C                   PARM      '*KEY   '     POptn                                        CFT120
     C                   PARM                    SCDRC                                        CFT120
     C     SDCURR        PARM      SDCURR        DSSDY                                        CFT120
      *                                                                                       CFT120
     C     PRTCD         IFNE      *BLANKS                                                    CFT120
     C                   MOVEL     SCDRC         DBKEY                                        CFT120
     C                   MOVEL     'SDCURRPD'    DBFILE                                       CFT120
     C                   Z-ADD     9             DBASE                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
                                                                                CFT009
      ** Save charge and levied currencies, and exchange rate incase            CFT009
      ** charges to the debit of field is blanked out again.                    CFT009
                                                                                CFT009
     C     *LIKE         DEFINE    @RCCY         Saved_Lev_ccy                  CFT009
     C     *LIKE         DEFINE    @CCCY         Saved_Chg_ccy                  CFT009
     C     *LIKE         DEFINE    O2XRTE        Saved_X_Rate                   CFT009
                                                                                CFT009
     C                   EVAL      Saved_Chg_ccy = @CCCY                        CFT009
     C                   EVAL      Saved_X_Rate = O2XRTE                        CFT009
                                                                                CFT009
      ** Set up input and output currency details.                              CFT009
                                                                                CFT009
     C**********         EVAL      @CCCY = BJCYCD                                      CFT009 257125
     C**********         EVAL      @RCCY = BJCYCD                                      CFT009 257125
                                                                                CFT009
      ***Set*up*charge*currency.***************************************                CFT009 257125
     C**********         EVAL      O2CCDE = @CCCY                                      CFT009 257125
      ***Set*up*charges*exchange*rate.*********************************                CFT009 257125
     C**********         EVAL      O2XRTE = 1                                          CFT009 257125
      *                                                                                       257125
      ** Set up Levied currency.                                                              257125
     C                   IF        SCDRC =  *BLANKS                                           257125
     C                   EVAL      @RCCY = BJCYCD                                             257125
     C                   ELSE                                                                 257125
     C                   EVAL      @RCCY = SCDRC                                              257125
     C                   ENDIF                                                                257125
      *                                                                                       257125
      ** Set up charge currency.                                                              257125
     C                   SELECT                                                               257125
     C                   WHEN      BTCHCY = 'B'                                               257125
     C                   EVAL      @CCCY = BJCYCD                                             257125
     C                   WHEN      BTCHCY = 'L'                                               257125
     C                   EVAL      @CCCY = BJLCCY                                             257125
     C                   WHEN      BTCHCY = 'C' AND SADDC = 'A'                               257125
     C                   EVAL      @CCCY = SSMCY                                              257125
     C                   WHEN      BTCHCY = 'F'                                               257125
     C                   EVAL      @CCCY = FCHCCY                                             257125
     C                   OTHER                                                                257125
     C                   EVAL      @CCCY = SPCCY                                              257125
     C                   ENDSL                                                                257125
      *                                                                                       257125
      ** Set up charge currency for extension file                                            257125
     C                   EVAL      O2CCDE = @CCCY                                             257125
     C                   EVAL      O2XRTE = 1                                                 257125
                                                                                CFT009
     C                   ELSE                                                   CFT009
                                                                                CFT009
      ** If the charges to the debit of field has been blanked, restore         CFT009
      ** the charge currency                                                    CFT009
                                                                                CFT009
     C*reset in code     EVAL      @RCCY = Saved_Lev_ccy                        CFT009
     C                   EVAL      Saved_Chg_ccy = @CCCY                        CFT009
     C                   EVAL      O2CCDE = Saved_Chg_ccy                       CFT009
     C                   EVAL      O2XRTE = Saved_X_Rate                        CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *------------------------------------------------------------------------------         247506
      **   If CDRO input, change the charge currency parameters to Base Ccy                   247506
                                                                                              247506
     C                   If        SCDRO  <> *Blanks And                                      247506
     C                             O2CCDE <> @CCCY                                            247506
      ** Set up charge currency.                                                              247506
     C                   EVAL      O2CCDE = @CCCY                                             247506
      ** Set up charges exchange rate.                                                        247506
     C                   EVAL      O2XRTE = 1                                                 247506
     C                   Endif                                                                247506
                                                                                              247506
      *------------------------------------------------------------------------------         247506
      *                                                                         CFT009
     C                   ENDSR                                                  CFT009
      *****************************************************************         CFT009
      /Title Sr/SetupValid
      *****************************************************************
      *                                                               *
      * SR/SetupValid - Set up valid file record                      *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SetupValid    BegSr
 
      ** Charges to Debit of Branch / Type / Value
 
     C                   Eval      OTCDBR = SCDBR
     C                   Eval      OTCDRT = @CDRT
     C                   Eval      OTCDRO = @CDRO
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Eval      OTCDRC = @CDRC                                             CFT120
     C                   ENDIF                                                                CFT120
 
      ** Details of Charges
 
     C                   Eval      OTDTCH = SDTCH
 
      ** Charges
 
     C                   Eval      OTDUMA1 = @TRCD
     C                   Eval      OTTRCM = @TRCM
 
     C                   Eval      OTDUMA2 = @TXCD
     C                   Eval      OTTXCH = @TXCH
 
     C                   Eval      OTDUMA3 = @CQCD
     C                   Eval      OTCQCH = @CQCH
 
     C                   Eval      OTDUMA4 = @CSTD
     C                   Eval      OTCSTA = @CSTA
 
     C                   Eval      OTDUMA5 = @SPCD
     C                   Eval      OTSPCH = @SPCH
 
     C                   Eval      OTDUMA6 = @MSCD
     C                   Eval      OTMSCH = @MSCH
 
     C                   If        @01494 = 'Y'
     C                   Eval      OTOPDUM7 = @CHCD
     C                   Eval      OTOPCHCM = @CHCM
     C                   EndIf
                                                                                CFT009
     C                   If        @CFT009 = 'Y'                                CFT009
     C                   Eval      O2AMCS = @SSCD                               CFT009
     C                   Eval      O2AMSS = @SSCH                               CFT009
     C                   Eval      O2AMC1 = @MI1CD                              CFT009
     C                   Eval      O2AMM1 = @M1CH                               CFT009
     C                   Eval      O2AMC2 = @MI2CD                              CFT009
     C                   Eval      O2AMM2 = @M2CH                               CFT009
     C                   Eval      O2AMC3 = @MI3CD                              CFT009
     C                   Eval      O2AMM3 = @M3CH                               CFT009
     C                   Eval      O2AMC4 = @MI4CD                              CFT009
     C                   Eval      O2AMM4 = @M4CH                               CFT009
     C                   Eval      O2AMC5 = @MI5CD                              CFT009
     C                   Eval      O2AMM5 = @M5CH                               CFT009
     C                   EndIf                                                  CFT009
 
      ** If switchable feature S01499 is switched ON, set up V.A.T. details
 
     C                   If        @01499 = 'Y'
     C                             AND @CFT009 ='N' OR @CFT010 = 'Y'            CFT009
     C                   Eval      OTOPDUM8 = @VATD
     C                   Eval      OTOPVATT = @VATT
     C                   Eval      OTOPVAT1 = SVAT1
     C                   Eval      OTOPVAT2 = SVAT2
     C                   Eval      OTOPVAT3 = SVAT3
     C                   Eval      OTOPVAT4 = SVAT4
     C                   Eval      OTOPVAT5 = SVAT5
     C                   Eval      OTOPVAT6 = SVAT6
     C                   Eval      OTOPVAT7 = SVAT7
 
      ** Store V.A.T. rate if used
     C                   If        @VATD <> 0 or
     C                             @VATT <> 0
     C                   Eval      OTOPVATR = @VATR
     C                   EndIf
 
     C                   EndIf
 
      ** Receiver's and Sender's Charges
 
     C                   If        @CFT014 = 'Y'
 
     C                   Eval      O2RCUS = @RCUS
     C                   Eval      O2RCRM = @RCRM
     C                   Eval      O2SCH1 = @SCH1
     C                   Eval      O2SCH2 = @SCH2
     C                   Eval      O2SCH3 = @SCH3
     C                   Eval      O2SCH4 = @SCH4
     C                   Eval      O2SCH5 = @SCH5
     C                   Eval      O2SCC1 = SSCC1
     C                   Eval      O2SCC2 = SSCC2
     C                   Eval      O2SCC3 = SSCC3
     C                   Eval      O2SCC4 = SSCC4
     C                   Eval      O2SCC5 = SSCC5
     C                   Eval      O2SCLE = @SENT
 
      ** Set paramaters for call to FT0010 to calculate receiver's charges base
      ** equivalent
 
     C                   Clear                   P#0010
 
     C                   Eval      P#FRDT = @PVDT
     C                   Eval      P#TODT = @SLDT
     C                   Eval      P#FRCY = SPCCY
     C                   Z-Add     @RCRM         P#FRAM
     C                   Eval      P#TOCY = BJCYCD
     C                   Eval      P#TOAM = *ZERO
     C                   Eval      P#RATE = *ZERO
     C                   Call      'FT0010'
     C                   Parm                    P#0010
 
     C     P#RTCD        IfNe      *BLANKS
     C                   MoveL     'FT0010  '    DBFILE
     C                   Z-Add     6             DBASE
     C                   MoveL     '*CALL   '    DBKEY
     C                   Exsr      *PSSR
     C                   Else
     C                   Z-Add     P#TOAM        O2RBCQ
     C                   EndIf
 
      ** Set paramaters for call to FT0010 to calculate receiver's charges
      ** in settlement currency
 
     C                   Clear                   P#0010
 
     C                   Eval      P#FRDT = @PVDT
     C                   Eval      P#TODT = @SLDT
     C                   Eval      P#FRCY = SPCCY
     C                   Z-Add     @RCRM         P#FRAM
     C                   Eval      P#TOCY = SSMCY
     C                   Eval      P#TOAM = *ZERO
     C                   Eval      P#RATE = *ZERO
     C                   Call      'FT0010'
     C                   Parm                    P#0010
 
     C     P#RTCD        IfNe      *BLANKS
     C                   MoveL     'FT0010  '    DBFILE
     C                   Z-Add     7             DBASE
     C                   MoveL     '*CALL   '    DBKEY
     C                   Exsr      *PSSR
     C                   Else
     C                   Z-Add     P#TOAM        O2RCSC
     C                   EndIf
 
      ** Set paramaters for call to FT0010 to calculate base currency equivalent
      ** of receiver's charges in settlement currency
 
     C                   Clear                   P#0010
 
     C                   Eval      P#FRDT = @PVDT
     C                   Eval      P#TODT = @SLDT
     C                   Eval      P#FRCY = SSMCY
     C                   Z-Add     O2RCSC        P#FRAM
     C                   Eval      P#TOCY = BJCYCD
     C                   Eval      P#TOAM = *ZERO
     C                   Eval      P#RATE = *ZERO
     C                   Call      'FT0010'
     C                   Parm                    P#0010
 
     C     P#RTCD        IfNe      *BLANKS
     C                   MoveL     'FT0010  '    DBFILE
     C                   Z-Add     8             DBASE
     C                   MoveL     '*CALL   '    DBKEY
     C                   Exsr      *PSSR
     C                   Else
     C                   Z-Add     P#TOAM        O2RCSQ
     C                   EndIf
     C                   EndIf
                                                                                CFT009
      ** Update Charge Codes, extra charge amounts and VAT flags                CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   EVAL      O2TFCD = TRCDE                               CFT009
     C                   EVAL      O2FXCD = FXCDE                               CFT009
     C                   EVAL      O2TXCD = TXCDE                               CFT009
     C                   EVAL      O2CQCD = CQCDE                               CFT009
     C                   EVAL      O2CACD = CACDE                               CFT009
     C                   EVAL      O2SPCD = SPCDE                               CFT009
     C                   EVAL      O2MSCD = MSCDE                               CFT009
     C                   EVAL      O2SSCD = STCDE                               CFT009
     C                   EVAL      O2M1CD = M1CDE                               CFT009
     C                   EVAL      O2M2CD = M2CDE                               CFT009
     C                   EVAL      O2M3CD = M3CDE                               CFT009
     C                   EVAL      O2M4CD = M4CDE                               CFT009
     C                   EVAL      O2M5CD = M5CDE                               CFT009
     C                   EVAL      O2AMSS = @SSCH                               CFT009
     C                   EVAL      O2AMM1 = @M1CH                               CFT009
     C                   EVAL      O2AMM2 = @M2CH                               CFT009
     C                   EVAL      O2AMM3 = @M3CH                               CFT009
     C                   EVAL      O2AMM4 = @M4CH                               CFT009
     C                   EVAL      O2AMM5 = @M5CH                               CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      O2TFCD = *BLANKS                             CFT009
     C                   EVAL      O2FXCD = *BLANKS                             CFT009
     C                   EVAL      O2TXCD = *BLANKS                             CFT009
     C                   EVAL      O2CQCD = *BLANKS                             CFT009
     C                   EVAL      O2CACD = *BLANKS                             CFT009
     C                   EVAL      O2SPCD = *BLANKS                             CFT009
     C                   EVAL      O2MSCD = *BLANKS                             CFT009
     C                   EVAL      O2SSCD = *BLANKS                             CFT009
     C                   EVAL      O2M1CD = *BLANKS                             CFT009
     C                   EVAL      O2M2CD = *BLANKS                             CFT009
     C                   EVAL      O2M3CD = *BLANKS                             CFT009
     C                   EVAL      O2M4CD = *BLANKS                             CFT009
     C                   EVAL      O2M5CD = *BLANKS                             CFT009
     C                   EVAL      O2AMSS = *ZEROS                              CFT009
     C                   EVAL      O2AMM1 = *ZEROS                              CFT009
     C                   EVAL      O2AMM2 = *ZEROS                              CFT009
     C                   EVAL      O2AMM3 = *ZEROS                              CFT009
     C                   EVAL      O2AMM4 = *ZEROS                              CFT009
     C                   EVAL      O2AMM5 = *ZEROS                              CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @CFT010 = 'Y'                                CFT009
     C                   EVAL      O2VTSS = VAT14                               CFT009
     C                   EVAL      O2VTM1 = VAT9                                CFT009
     C                   EVAL      O2VTM2 = VAT10                               CFT009
     C                   EVAL      O2VTM3 = VAT11                               CFT009
     C                   EVAL      O2VTM4 = VAT12                               CFT009
     C                   EVAL      O2VTM5 = VAT13                               CFT009
     C                   ENDIF                                                  CFT009
 
      ** If insert set up audit information
 
     C                   If        SACTION = 'I'
     C                   Time                    OTLCHT
     C                   Eval      OTLCD = BJRDNB
     C                   Eval      OTCHTP = 'I'
     C                   Eval      @USRID = WUSRID                                            CAP084
     C                   IF        InputUser = *BLANKS                                      MD042042
     C                   Eval      OTINUSR2 = @USRID
     C                   ELSE                                                               MD042042
     C                   EVAL      OTINUSR2 = InputUser                                     MD042042
     C                   ENDIF                                                              MD042042
     C                   EndIf
     C
 
      ** If amend set up audit information
 
     C                   If        SACTION = 'A'
     C                   Time                    OTLCHT
     C                   If        OTLCD <> BJRDNB
     C                   Eval      OTCHTP = 'A'
     C                   EndIf
     C                   Eval      OTAUP1 = *Blanks
     C                   Eval      OTLCD = BJRDNB
     C                   Eval      @USRID = WUSRID                                            CAP084
     C                   IF        InputUser = *BLANKS                                      MD042042
     C                   Eval      OTINUSR2 = @USRID
     C                   ELSE                                                               MD042042
     C                   EVAL      OTINUSR2 = InputUser                                     MD042042
     C                   ENDIF                                                              MD042042
     C                   EndIf
 
      ** If delete set up audit information
 
     C                   If        SACTION = 'D'
     C                   Eval      OTRECI = 'C'
     C                   Time                    OTLCHT
     C                   Eval      OTLCD = BJRDNB
     C                   Eval      OTCHTP = 'D'
     C                   EndIf
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Program Initialisation Routine                *
      *                                                               *
      * Called By: Automatically executed when program starts.        *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
     C     *Entry        Plist
     C                   PARM                    RespMode
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
     C                   PARM                    TranInThir
     C                   PARM                    TranInPrmB
     C                   PARM                    TranInThrB
     C                   PARM                    TranInFour
     C                   PARM                    ExtData
     C                   PARM                    PReDspChg                      CFT009
     C                   PARM                    OKFlagsDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmtX
     C                   Parm                    Val@Fields
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
     C                   PARM                    InputUser                                  MD042042
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
     C     *LOCK         In        LDA
     C                   Movel     'FTOPAY4VL'   DBPGM
     C                   Out       LDA
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDBANKPD'    DBFILE
     C                   Z-Add     1             DBASE
     C                   MoveL     @Optn         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Access Module Details
 
     C                   Call      'AOMMODR0'
     C                   Parm      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C     @RTCD         IfNe      *Blanks
     C                   Movel     'SDMMODPD'    DBFILE
     C                   Z-Add     2             DBASE
     C                   Movel     @Optn         DBKEY
     C                   ExSr      *PSSR
     C                   EndIf
      *                                                                                       CFT017
      ** Access GL ICD details                                                                CFT017
      *                                                                                       CFT017
     C**********         CALLB     'AOGELRR0'                                          CFT017 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD                                        CFT017
     C                   PARM      '*FIRST '     @OPTN                                        CFT017
     C*****SDGELR        PARM      SDGELR        DSFDY                                 CFT017 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *                                                                                       CFT017
     C     @RTCD         IFNE      *BLANKS                                                    CFT017
     C                   MOVEL     'SDGELRPD'    DBFILE                                       CFT017
     C                   Z-ADD     3             DBASE                                        CFT017
     C                   MOVEL     @OPTN         DBKEY                                        CFT017
     C                   EXSR      *PSSR                                                      CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Access FT ICD details                                                                CFT017
      *                                                                                       CFT017
     C                   CALLB     'AOFTFRR0'                                                 CFT017
     C                   PARM      *BLANKS       @RTCD                                        CFT017
     C                   PARM      '*FIRST '     @OPTN                                        CFT017
     C     SDFTFR        PARM      SDFTFR        DSFDY                                        CFT017
      *                                                                                       CFT017
     C     @RTCD         IFNE      *BLANKS                                                    CFT017
     C                   MOVEL     'SDFTFRPD'    DBFILE                                       CFT017
     C                   Z-ADD     4             DBASE                                        CFT017
     C                   MOVEL     @OPTN         DBKEY                                        CFT017
     C                   EXSR      *PSSR                                                      CFT017
     C                   ELSE                                                                 CRE067
                                                                                              CRE067
     C     *LIKE         DEFINE    @RATE         Rate_To_Use                                  CRE067
     C                   IF        CHTRCY = 'Y'                                               CRE067
     C                   EVAL      Rate_To_Use = @RATE                                        CRE067
     C                   ELSE                                                                 CRE067
     C                   EVAL      Rate_To_Use = O2XRTE                                       CRE067
     C                   ENDIF                                                                CRE067
                                                                                              CRE067
     C                   ENDIF                                                                CFT017
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
 
     C                   EVAL      #MsgFile     = 'FTUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
      **********                                                                      CAP084 BUG7029
      ***Retrieve*ZMUSER*details.                                                     CAP084 BUG7029
      **********                                                                      CAP084 BUG7029
     C******DTAARA       DEFINE                  ZMUSER                               CAP084 BUG7029
     C**********         IN        ZMUSER                                             CAP084 BUG7029
 
     C/COPY WNCPYSRC,FTH00471
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrInit
      *****************************************************************
      *                                                               *
      * SR/SrInit     - Initial Processing                            *
      *                                                               *
      * Called By: Main Processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BegSr
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
 
      ** Access FT Control data
 
     C                   Call      'FT0005'                             9090
     C                   Parm      *BLANKS       @RTCD
     C     TCNTRL        Parm      TCNTRL        DSFDY
      *
     C                   If        *IN90 = True or
     C                             @RTCD = '*ERROR*'
     C                   Movel     'FTOPAY4VL'   DBPGM
     C                   Movel     'FT0005'      DBFILE
     C                   Z-Add     3             DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   If        WGLUI = 'I'
     C                   Eval      @FTOV = 'Y'
     C                   Else
     C                   Eval      @FTOV = *Blanks
     C                   EndIf
 
     C                   Eval      @PDTI =WPDTI
     C                   Eval      @VATF =WVATF
 
      ** Access SAR details file to determine if CEU006 enhancement is ce -
      ** switched on.
 
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Z-Add     4             DBASE
     C                   Movel     'CEU006'      DBKEY
     C                   ExSr      *PSSR
     C                   EndIf
 
     C                   If        @RTCD = *BLANKS
     C                   Movel     'Y'           CEU006            1
     C                   Else
     C                   Movel     'N'           CEU006
     C                   EndIf
 
      ** Read V.A.T. details if S01499 switched ON
      ** OR CFT010 switched on                                                  CFT009
 
     C                   If        @01499 = 'Y'
     C                             AND @CFT009 ='N' OR @CFT010 = 'Y'            CFT009
     C                   Call      'AOVATR0'                            9090
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C                   Parm                    VATDS
 
     C                   If        *IN90 = True or
     C                             @RTCD = '*ERROR*'
     C                   Movel     'FTOPAY4VL'   DBPGM
     C                   Movel     'AOVATR0'     DBFILE
     C                   Z-Add     5             DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   Else
     C                   Eval      OTOPVATR = WVATR
     C                   Eval      @VATR = WVATR
     C                   Eval      @VATP = 'Y'
     C                   EndIf
     C                   EndIf
      *                                                                                       CFT017
      ** Access SAR details file to determine if CFT017 is switched on.                       CFT017
      *                                                                                       CFT017
     C                   Call      'AOSARDR0'                                                 CFT017
     C                   Parm      *BLANKS       @RTCD                                        CFT017
     C                   Parm      '*VERIFY'     @OPTN                                        CFT017
     C                   Parm      'CFT017'      @SARD                                        CFT017
     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT017
                                                                                              CFT017
     C                   IF        @RTCD = *BLANKS                                            CFT017
     C                   MOVEL     'Y'           CFT017            1                          CFT017
     C                   ELSE                                                                 CFT017
     C                   MOVEL     'N'           CFT017                                       CFT017
     C                   ENDIF                                                                CFT017
                                                                                              CFT017
     C                   MOVEL     'N'           WDefRCRM          1                          CFT017
      *                                                                                       CFT120
      ** Access SAR details file to determine if CFT120 enhancement is                        CFT120
      ** switched on.                                                                         CFT120
      *                                                                                       CFT120
     C                   Call      'AOSARDR0'                                                 CFT120
     C                   PARM      *Blanks       @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')                CFT120
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT120
     C                   Z-ADD     6             DBASE                                        CFT120
     C                   MOVEL     'CFT120'      DBKEY                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   MOVEL     'N'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   EndSr
 
      *****************************************************************
      /Title Sr/Reseterrs
      *****************************************************************
      *                                                               *
      * SR/Reseterrs  - Reset information that is received back from  *
      *                 each validation module                        *
      *                                                               *
      * Called By: Validation subroutines                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     Reseterrs     BegSr
 
     C                   Eval      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *BlankS
     C                   Eval      WMsgDtXAr = *BlankS
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/Updaterrs
      *****************************************************************
      *                                                               *
      * SR/Updaterrs  - Update error information with that received   *
      *                 back from each validation module              *
      *                                                               *
      * Called By: Validation subroutines                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     Updaterrs     BegSr
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Eval      I = 1
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   If        *IN99 = True
     C                   Movea     FldNamXar     FldNameArr(I)
     C                   Movea     MsgIDXAr      MsgIdArr(I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(I)
     C                   EndIf
 
      ** Set Error Index
 
     C                   Eval      I = 1
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   Eval      Idx = I - 1
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Eval      I = 1
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   If        *IN99 = True
     C                   Movea     WFldNmXAr     WFldNamArr(I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(I)
     C                   EndIf
 
      ** Set Warning Index
 
     C                   Eval      I = 1
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   Eval      WIdx = I - 1
 
     C                   EndSr
 
      *****************************************************************
      /EJECT                                                                    CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/Setup_984_fld  - Set up fields for FT000984                *         CFT009
      *                                                               *         CFT009
      * Called By:                                                    *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     Setup_984_fld BegSr                                                  CFT009
                                                                                CFT009
      ** Move fields from screen format to file format, for cal to FT000984     CFT009
                                                                                CFT009
     C                   Eval      F_PYAM = @PYAM                               CFT009
     C                   Eval      F_PCCY = SPCCY                               CFT009
     C                   Eval      F_SMCY = SSMCY                               CFT009
     C                   Eval      OPCHRT = O2XRTE                              CFT009
     C                   Eval      OPCHGC = O2CCDE                              CFT009
     C                   Eval      OPSTPI = 'M'                                 CFT009
     C                   Eval      F_CDRO = @CDRO                               CFT009
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      F_OPCDRC = @CDRC                                           CFT120
     C                   ENDIF                                                                CFT120
     C                   Eval      F_SMAM = @SMAM                               CFT009
     C                   Eval      F_ADDC = SADDC                               CFT009
     C                   Eval      F_DSTT = @DSTT                               CFT009
     C                   Eval      F_DST1 = SDST1                               CFT009
     C                   Eval      F_DST2 = SDST2                               CFT009
     C                   Eval      F_INBT = @INBT                               CFT009
     C                   Eval      F_INB1 = SINB1                               CFT009
     C                   Eval      F_INB2 = SINB2                               CFT009
     C                   Eval      F_ACBT = @ACBT                               CFT009
     C                   Eval      F_ACB1 = SACB1                               CFT009
     C                   Eval      F_ACB2 = SACB2                               CFT009
                                                                                CFT009
     C                   MoveL     File_Detail   Trans_Det                      CFT009
     C                   MoveL     File_Ext      Trans_Ext                      CFT009
                                                                                CFT009
     C                   EndSr                                                  CFT009
                                                                                CFT009
      *****************************************************************         CFT009
      /EJECT                                                                    CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/Sub_984 - Call FT000984 to get receivers charges remitted  *         CFT009
      *                                                               *         CFT009
      * Called By:                                                    *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     Sub_984       BegSr                                                  CFT009
                                                                                CFT009
     C                   CallB     'FT000984'                                   CFT009
     C                   Parm                    RTN_984          10            CFT009
     C                   Parm                    Trans_Det                      CFT009
     C                   Parm                    Trans_Ext                      CFT009
     C                   Parm      'OP'          TYPE              2            CFT009
     C                   Parm                    Chg_Returned     11 0          CFT009
                                                                                CFT009
     C                   EndSr                                                  CFT009
                                                                                CFT009
      *****************************************************************         CFT009
      /EJECT                                                                    CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      * SR/Fmt_984 - Format amount from FT000984                      *         CFT009
      *                                                               *         CFT009
      * Called By:                                                    *         CFT009
      *                                                               *         CFT009
      * Calls:                                                        *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     Fmt_984       BegSr                                                  CFT009
                                                                                CFT009
      ** Get number of decimal places for receivers charges remitted ccy.       CFT009
                                                                                CFT009
     C                   CALLB     'AOCURRR0'                                   CFT009
     C                   PARM      *BLANK        PRtcd                          CFT009
     C                   PARM      '*KEY   '     POptn                          CFT009
     C**********         PARM                    SRCRM                                 CFT009 CFT017
     C                   PARM      SPCCY         PCYCD                                        CFT017
     C     SDCURR        PARM      SDCURR        DSSDY                          CFT009
                                                                                CFT009
      ** Format and set up screen field for receivers charges remitted.         CFT009
                                                                                CFT009
     C                   EVAL      ZFIELD = *BLANKS                             CFT009
     C                   MOVE      Chg_Returned  ZFIELD                         CFT009
     C                   EVAL      ZADEC = A6NBDP                               CFT009
                                                                                CFT009
     C                   CALLB     'ZEDIT'                                      CFT009
     C                   PARM                    ZFIELD                         CFT009
     C                   PARM                    ZADEC                          CFT009
                                                                                CFT009
     C                   MOVE      ZFIELD        SRCRM                          CFT009
                                                                                CFT009
     C                   EndSr                                                  CFT009
                                                                                CFT009
      *****************************************************************         CFT009
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRMIF - Determine if MIF is applicable                       *                       CFT017
      *                                                               *                       CFT017
      *  Called By: Main processing                                   *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRMIF         BEGSR                                                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     *BLANK        WVMIFF            1                          CFT017
      *                                                                                       CFT017
      ** Check if Sender and Intermediary Bank/Account with Bank are                          CFT017
      ** located in two different EEA member countries by getting                             CFT017
      ** their ISO country codes.                                                             CFT017
      *                                                                                       CFT017
     C                   EXSR      SRSISO                                                     CFT017
     C                   IF        WCNCD = *BLANKS OR                                         CFT017
     C                             WSCNCD = *BLANKS OR                                        CFT017
     C                             WCNCD = WSCNCD                                             CFT017
     C                   GOTO      ENDMIF                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Go to end of subroutine if the following conditions                                  CFT017
      ** are not met.                                                                         CFT017
      ** 1. payment currency is in Euro                                                       CFT017
      ** 2. payment amount is less than or equal to the MIF                                   CFT017
      ** threshold defined in ICD                                                             CFT017
      ** 3. details of charges is 'OUR' and Add/Deduct ind i 'A'                              CFT017
      *                                                                                       CFT017
     C                   IF        SPCCY <> BKEURO  OR                                        CFT017
     C                             @PYAM > BTMIFT OR                                          CFT017
     C                             SDTCH <> 'OUR' OR                                          CFT017
     C                             SADDC <> 'A'                                               CFT017
     C                   GOTO      ENDMIF                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Beneficiary must be an IBAN account                                                  CFT017
      *                                                                                       CFT017
     C                   IF        %SUBST(SBNC1:1:1) = '/'                                    CFT017
     C                   EVAL      PIBN = %SUBST(SBNC1:2:34)                                  CFT017
     C                   ELSE                                                                 CFT017
     C                   EVAL      PIBN = SBNC1                                               CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     'I'           WACCS             1                          CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS AND                                       CFT017
     C                             PRTCD <> '      6'                                         CFT017
     C                   GOTO      ENDMIF                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Source of Payment must be an MT103.                                                  CFT017
      *                                                                                       CFT017
     C                   EXSR      SRM103                                                     CFT017
     C                   IF        WM103 <> 'Y'                                               CFT017
     C                   GOTO      ENDMIF                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** If all conditions were satisfied, set MIF flag to 'Y'                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     'Y'           WVMIFF                                       CFT017
      *                                                                                       CFT017
     C     ENDMIF        ENDSR                                                                CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRSISO - Determine ISO country code                          *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRMIF                                             *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRSISO        BEGSR                                                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     'Y'           WSISO             1                          CFT017
     C                   CLEAR                   WSCNCD            2                          CFT017
     C                   CLEAR                   WSNDTP            1                          CFT017
     C                   CLEAR                   WSNDID           35                          CFT017
     C                   CLEAR                   WSNDI2           35                          CFT017
      *                                                                                       CFT017
      ** Check if booking branch has an ISO country code                                      CFT017
     C                   EVAL      WMBRCA = SBRCA                                             CFT017
     C                   EXSR      SRBISO                                                     CFT017
      *                                                                                       CFT017
      ** Do not proceed if error in country code or                                           CFT017
      ** country is not an EEA member                                                         CFT017
     C                   IF        WCNCD = *BLANKS                                            CFT017
     C                   GOTO      ENSISO                                                     CFT017
     C                   ENDIF                                                                CFT017
     C                   EVAL      WSCNCD = WCNCD                                             CFT017
     C                   EVAL      WCNCD = *BLANKS                                            CFT017
      *                                                                                       CFT017
      ** Get the other field's country code                                                   CFT017
      ** Get country code of Intermediary                                                     CFT017
     C                   IF        SINB1  <> *BLANKS                                          CFT017
     C                   EVAL      WSNDTP = @INBT                                             CFT017
     C                   EVAL      WSNDID = SINB1                                             CFT017
     C                   EVAL      WSNDI2 = SINB2                                             CFT017
     C                   EXSR      SRCSID                                                     CFT017
     C                   ELSE                                                                 CFT017
      *                                                                                       CFT017
      ** Else get country code of Account with Bank if present                                CFT017
      *                                                                                       CFT017
     C                   IF        SACB1  <> *BLANKS                                          CFT017
     C                   IF        @ACBT = 'N'                                                CFT017
     C                   EVAL      PCYCD = SPCCY                                              CFT017
     C                   ENDIF                                                                CFT017
     C                   EVAL      WSNDTP = @ACBT                                             CFT017
     C                   EVAL      WSNDID = SACB1                                             CFT017
     C                   EVAL      WSNDI2 = SACB2                                             CFT017
     C                   EXSR      SRCSID                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   EVAL      WSISO = 'N'                                                CFT017
      *                                                                                       CFT017
     C     ENSISO        ENDSR                                                                CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRBISO - Determine Branch ISO country code                   *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRSISO                                            *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRBISO        BEGSR                                                                CFT017
      *                                                                                       CFT017
     C                   CLEAR                   WCNCD                                        CFT017
     C                   CLEAR                   WWCUS                                        CFT017
      *                                                                                       CFT017
      ** If multi-branching environment access branch file thru                               CFT017
      ** booking branch, otherwise thru single branch code                                    CFT017
      *                                                                                       CFT017
     C                   IF        BGMBIN <> 'Y'                                              CFT017
     C                   MOVEL     BJSBRC        WMBRCA            3                          CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Get SWIFT Id via access object AOBRCHR0                                              CFT017
      *                                                                                       CFT017
     C                   EVAL      WACCS = 'B'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS                                           CFT017
     C                   GOTO      ENBISO                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   SELECT                                                               CFT017
      *                                                                                       CFT017
      ** Get ISO Country code via SWIFT Id.                                                   CFT017
      *                                                                                       CFT017
     C                   WHEN      A8BTID <> *BLANKS                                          CFT017
     C                   EVAL      WCNCD = %SUBST(A8BTID:5:2)                                 CFT017
      *                                                                                       CFT017
      ** No SWIFT Id., get ISO Country code via location code.                                CFT017
      *                                                                                       CFT017
     C                   WHEN      A8LCCD <> *BLANKS                                          CFT017
     C                   MOVEL     A8LCCD        WLCCD             3                          CFT017
     C                   EVAL      WACCS = 'L'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS                                           CFT017
     C                   GOTO      ENBISO                                                     CFT017
     C                   ENDIF                                                                CFT017
     C                   EVAL      WCNCD = DVCNCD                                             CFT017
     C                   EVAL      WACCS = 'O'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS                                           CFT017
     C                   CLEAR                   WCNCD                                        CFT017
     C                   GOTO      ENBISO                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Otherwise, use customer number to derive the ISO Country Code.                       CFT017
      *                                                                                       CFT017
     C                   OTHER                                                                CFT017
     C                   EVAL      WWCUS = A8BICN                                             CFT017
     C                   EVAL      WACCS = 'C'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS                                           CFT017
     C                   GOTO      ENBISO                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   IF        BBCSID <> *BLANKS                                          CFT017
     C                   EVAL      WCNCD = %SUBST(BBCSID:5:2)                                 CFT017
     C                   ELSE                                                                 CFT017
      *                                                                                       CFT017
      ** No SWIFT id, get country code                                                        CFT017
      ** Get ISO Country Code via access object AOCTRYR0                                      CFT017
     C                   EVAL      WCNCD = BBCOLC                                             CFT017
     C                   EVAL      WACCS = 'O'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS                                           CFT017
     C                   MOVEL     *BLANKS       WCNCD                                        CFT017
     C                   GOTO      ENBISO                                                     CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   ENDSL                                                                CFT017
      *                                                                                       CFT017
     C                   IF        WCNCD <> *BLANKS                                           CFT017
     C                   EXSR      SRCNCD                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C     ENBISO        ENDSR                                                                CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRCSID - Determine SWIFT id                                  *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRMIF                                             *                       CFT017
      *             SRSISO                                            *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRCSID        BEGSR                                                                CFT017
      *                                                                                       CFT017
     C                   CLEAR                   WWCUS            10                          CFT017
     C                   CLEAR                   WCSID            11                          CFT017
     C                   MOVEL     WSNDID        WSLSH             1                          CFT017
     C                   MOVEL     WSNDID        WSNDIB           35                          CFT017
     C                   IF        WSLSH = '/' AND                                            CFT017
     C                             WSNDI2 <> *BLANKS                                          CFT017
     C                   EVAL      WSNDID = WSNDI2                                            CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   SELECT                                                               CFT017
      *                                                                                       CFT017
      ** Nostro                                                                               CFT017
     C                   WHEN      WSNDTP = 'F' OR                                            CFT017
     C                             WSNDTP = 'N'                                               CFT017
      *                                                                                       CFT017
     C                   IF        WSNDTP = 'F'                                               CFT017
     C                   MOVEL     WSNDID        PCYCD                                        CFT017
     C                   EVAL      PNONB = %SUBST(WSNDID:4:2)                                 CFT017
     C                   ELSE                                                                 CFT017
     C                   EVAL      PNONB = WSNDID                                             CFT017
     C                   ENDIF                                                                CFT017
     C                   EVAL      WACCS = 'N'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD = *BLANKS                                            CFT017
     C                   EVAL      WWCUS = A7CUST                                             CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Retail                                                                               CFT017
     C                   WHEN      WSNDTP = 'R'                                               CFT017
     C                   CLEAR                   PPSTR            35                          CFT017
     C                   EVAL      PPSTR = WSNDID                                             CFT017
     C                   EVAL      WACCS = 'A'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD = *BLANKS                                            CFT017
     C                   MOVEL     CNUM          WWCUS                                        CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Customer                                                                             CFT017
     C                   WHEN      WSNDTP = 'C'                                               CFT017
     C                   EVAL      WWCUS = WSNDID                                             CFT017
      *                                                                                       CFT017
      ** Full account/partial account                                                         CFT017
     C                   WHEN      WSNDTP = 'G' OR                                            CFT017
     C                             WSNDTP = 'P'                                               CFT017
     C                   EVAL      WWCUS = %SUBST(WSNDID:1:6)                                 CFT017
      *                                                                                       CFT017
      ** SWIFT id                                                                             CFT017
     C                   WHEN      WSNDTP = 'S'                                               CFT017
     C                   EVAL      WCSID = WSNDID                                             CFT017
     C     2             SUBST     WCSID:5       WCNCD                                        CFT017
      *                                                                                       CFT017
      ** IBAN or address                                                                      CFT017
     C                   WHEN      WSNDTP = 'I' OR                                            CFT017
     C                             WSNDTP = 'A'                                               CFT017
     C                   IF        WSLSH = '/'                                                CFT017
     C                   EVAL      PIBN = %SUBST(WSNDIB:2:34)                                 CFT017
     C                   ELSE                                                                 CFT017
     C                   EVAL      PIBN = WSNDIB                                              CFT017
     C                   ENDIF                                                                CFT017
     C                   EVAL      WACCS = 'I'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD = *BLANKS                                            CFT017
     C                   MOVEL     CNUM          WWCUS                                        CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   ENDSL                                                                CFT017
      *                                                                                       CFT017
      ** If customer is entered, check if there is SWIFT Id                                   CFT017
      ** attached to it.                                                                      CFT017
      *                                                                                       CFT017
     C                   IF        WWCUS <> *BLANKS                                           CFT017
     C                   EVAL      WACCS = 'C'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS                                           CFT017
     C                   GOTO      ENCSID                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   IF        BBCSID <> *BLANKS                                          CFT017
     C                   MOVEL     BBCSID        WCSID                                        CFT017
     C     2             SUBST     WCSID:5       WCNCD                                        CFT017
     C                   ELSE                                                                 CFT017
      *                                                                                       CFT017
      ** No SWIFT id, get country code                                                        CFT017
      ** Get ISO Country Code via access object AOCTRYR0                                      CFT017
     C                   IF        WSISO = 'Y'                                                CFT017
     C                   EVAL      WCNCD = BBCOLC                                             CFT017
     C                   EVAL      WACCS = 'O'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS                                           CFT017
     C                   CLEAR                   WCNCD             2                          CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Get ISO country code                                                                 CFT017
      *                                                                                       CFT017
     C                   IF        WCNCD <> *BLANKS AND                                       CFT017
     C                             WSISO = 'Y'                                                CFT017
     C                   EXSR      SRCNCD                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C     ENCSID        ENDSR                                                                CFT017
      *                                                                                       CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRACCS - Process using access object                         *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRMIF                                             *                       CFT017
      *             SRSISO                                            *                       CFT017
      *             SRBISO                                            *                       CFT017
      *             SRCSID                                            *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRACCS        BEGSR                                                                CFT017
      *                                                                                       CFT017
      ** Access detail file according to access indicator                                     CFT017
      *                                                                                       CFT017
     C                   SELECT                                                               CFT017
      *                                                                                       CFT017
      ** Customer                                                                             CFT017
     C                   WHEN      WACCS = 'C'                                                CFT017
     C                   CALLB     'AOCUSTR0'                                                 CFT017
     C                   PARM      *BLANKS       PRTCD                                        CFT017
     C                   PARM      '*KEY   '     POPTN                                        CFT017
     C                   PARM      WWCUS         PKEY1            10                          CFT017
     C                   PARM      *BLANKS       PKYST             7                          CFT017
     C     SDCUST        PARM      SDCUST        DSSDY                                        CFT017
      *                                                                                       CFT017
      ** Nostro                                                                               CFT017
     C                   WHEN      WACCS = 'N'                                                CFT017
     C                   CALLB     'AONOSTR0'                                                 CFT017
     C                   PARM      *BLANKS       PRTCD             7                          CFT017
     C                   PARM      '*KEY   '     POPTN             7                          CFT017
     C                   PARM      *BLANKS       PCNOM             6                          CFT017
     C                   PARM                    PCYCD             3                          CFT017
     C                   PARM      *BLANKS       PACCN             4                          CFT017
     C                   PARM      *BLANKS       PACSN             2                          CFT017
     C                   PARM                    PNONB             2                          CFT017
     C                   PARM      *BLANKS       PBRCD             3                          CFT017
     C                   PARM      *BLANKS       PCSSN            10                          CFT017
     C                   PARM      *BLANKS       PPNOI             1                          CFT017
     C     SDNOST        PARM      SDNOST        DSFDY                                        CFT017
      *                                                                                       CFT017
      ** Location                                                                             CFT017
     C                   WHEN      WACCS = 'L'                                                CFT017
     C                   CALL      'AOLOCNR0'                                                 CFT017
     C                   PARM      *BLANKS       PRTCD                                        CFT017
     C                   PARM      '*KEY   '     POPTN                                        CFT017
     C                   PARM      WLCCD         PLOCN             3                          CFT017
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        CFT017
      *                                                                                       CFT017
      ** Country Code                                                                         CFT017
     C                   WHEN      WACCS = 'O'                                                CFT017
     C                   CALL      'AOCTRYR0'                                                 CFT017
     C                   PARM      *BLANKS       PRTCD                                        CFT017
     C                   PARM      '*KEY   '     POPTN                                        CFT017
     C                   PARM      WCNCD         PCTCD             2                          CFT017
     C     SDCTRY        PARM      SDCTRY        DSFDY                                        CFT017
      *                                                                                       CFT017
      ** Branch                                                                               CFT017
     C                   WHEN      WACCS = 'B'                                                CFT017
     C**********         CALLB     'AOBRCHR0'                                          CFT017 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD                                        CFT017
     C                   PARM      '*KEY   '     POPTN                                        CFT017
     C                   PARM      WMBRCA        PBRCD             3                          CFT017
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CFT017 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *                                                                                       CFT017
      ** Branch                                                                               CFT017
     C                   WHEN      WACCS = 'A'                                                CFT017
     C                   CALLB     'AOACCTV1'                                                 CFT017
     C                   PARM      *BLANKS       PRTCD                                        CFT017
     C                   PARM      *BLANKS       POPTN                                        CFT017
     C                   PARM                    PPSTR                                        CFT017
     C     SDACCT        PARM      *BLANKS       DSSDY                                        CFT017
      *                                                                                       CFT017
      ** IBAN                                                                                 CFT017
     C                   WHEN      WACCS = 'I'                                                CFT017
     C                   CALLB     'AOIBANR2'                                                 CFT017
     C                   PARM      *BLANKS       PRTCD                                        CFT017
     C                   PARM                    PIBN             34                          CFT017
     C     SDACCT        PARM      *BLANKS       DSSDY                                        CFT017
      *                                                                                       CFT017
      ** Currency                                                                             CFT017
     C                   WHEN      WACCS = 'U'                                                CFT017
     C                   CALLB     'AOCURRR0'                                                 CFT017
     C                   PARM      *BLANKS       PRTCD                                        CFT017
     C                   PARM      '*KEY   '     POPTN                                        CFT017
     C                   PARM                    PCYCD                                        CFT017
     C     SDCURR        PARM      *BLANKS       DSSDY                                        CFT017
      *                                                                                       CFT017
     C                   ENDSL                                                                CFT017
      *                                                                                       CFT017
     C                   ENDSR                                                                CFT017
      *                                                                                       CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRCNCD - Get country code                                    *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRCSID                                            *                       CFT017
      *             SRBISO                                            *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRCNCD        BEGSR                                                                CFT017
      *                                                                                       CFT017
      ** Get ISO country code. Country must be an EEA member.                                 CFT017
      *                                                                                       CFT017
     C     WCNCD         CHAIN     MEISOCL1                           01                      CFT017
      *                                                                                       CFT017
     C                   IF        *IN01 OR                                                   CFT017
     C                             M3EEAM <> 'Y'                                              CFT017
     C                   CLEAR                   WCNCD                                        CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   ENDSR                                                                CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRM103 - Determine if source of payment is MT103             *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRMIF                                             *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRM103        BEGSR                                                                CFT017
      *                                                                                       CFT017
     C                   CLEAR                   WM103             1                          CFT017
     C                   CLEAR                   WBTBK                                        CFT017
     C                   CLEAR                   WCSID                                        CFT017
     C                   CLEAR                   WWCUS                                        CFT017
      *                                                                                       CFT017
      ** Check if beneficiary is a non-bank. At this stage,                                   CFT017
      ** beneficiary could only be an IBAN account.                                           CFT017
      *                                                                                       CFT017
     C                   IF        PRTCD = *BLANKS                                            CFT017
     C                   MOVEL     CNUM          WWCUS                                        CFT017
     C                   EVAL      WACCS = 'C'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   IF        PRTCD <> *BLANKS OR                                        CFT017
     C                             BBBNBI = 'Y'                                               CFT017
      *                                                                                       CFT017
     C                   CLEAR                   WWCUS                                        CFT017
      *                                                                                       CFT017
      ** Otherwise, check if ordering customer is non-bank.                                   CFT017
      *                                                                                       CFT017
     C                   SELECT                                                               CFT017
     C                   WHEN      @ORCT = 'C'                                                CFT017
     C                   If        %Subst(SORC1:1:1) = '/'                                    CFT032
     C                   Eval      WWCUS = SORC2                                              CFT032
     C                   Else                                                                 CFT032
     C                   MOVEL     SORC1         WWCUS                                        CFT017
     C                   EndIf                                                                CFT032
     C                   WHEN      @ORCT = 'S'                                                CFT017
     C                   If        %Subst(SORC1:1:1) = '/'                                    CFT032
     C                   Eval      WCSID = SORC2                                              CFT032
     C                   Else                                                                 CFT032
     C                   MOVEL     SORC1         WCSID                                        CFT017
     C                   EndIf                                                                CFT032
     C                   OTHER                                                                CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDSL                                                                CFT017
      *                                                                                       CFT017
      ** Ordering cust entered is a SWIFT id. Get customer                                    CFT017
      ** attached to it.                                                                      CFT017
      *                                                                                       CFT017
     C                   IF        WCSID <> *BLANKS                                           CFT017
     C                   EXSR      SR1400                                                     CFT017
     C                   IF        PCNUM = 'Y'                                                CFT017
     C                   IF        BBBNBI = 'Y'                                               CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
     C                   ELSE                                                                 CFT017
     C                   IF        PCNST = 'Y'                                                CFT017
     C                   EVAL      WWCUS = AWCSN1 + AWCSN2                                    CFT017
     C                   ELSE                                                                 CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   IF        WWCUS <> *BLANKS                                           CFT017
     C                   EVAL      WACCS = 'C'                                                CFT017
     C                   EXSR      SRACCS                                                     CFT017
     C                   IF        PRTCD <> *BLANKS OR                                        CFT017
     C                             BBBNBI = 'Y'                                               CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Check if any of these fields are entered as a SWIFT BIC or                           CFT017
      ** input can be linked to a SWIFT BIC.                                                  CFT017
      ** 1. Ordering bank                                                                     CFT017
      ** 2. Sender's Correspondent                                                            CFT017
      ** 3. Receiver's Correspondent                                                          CFT017
      ** 4. Intermediary                                                                      CFT017
      ** 5. Account with Bank                                                                 CFT017
      *                                                                                       CFT017
     C                   EXSR      SRSBIC                                                     CFT017
      *                                                                                       CFT017
      ** If SWIFT id is present, check if it exists in BIC directory                          CFT017
      *                                                                                       CFT017
     C                   IF        WCSID = *BLANKS                                            CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Intruction code fields may only contain SDVA, INTC and CORT                          CFT017
      *                                                                                       CFT017
     C                   IF        SICD1 <> *BLANKS AND                                       CFT017
     C                             SICD1 <> 'SDVA' AND                                        CFT017
     C                             SICD1 <> 'CORT' AND                                        CFT017
     C                             SICD1 <> 'INTC'                                            CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   IF        SICD2 <> *BLANKS AND                                       CFT017
     C                             SICD2 <> 'SDVA' AND                                        CFT017
     C                             SICD2 <> 'CORT' AND                                        CFT017
     C                             SICD2 <> 'INTC'                                            CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   IF        SICD3 <> *BLANKS AND                                       CFT017
     C                             SICD3 <> 'SDVA' AND                                        CFT017
     C                             SICD3 <> 'CORT' AND                                        CFT017
     C                             SICD3 <> 'INTC'                                            CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   IF        SICD4 <> *BLANKS AND                                       CFT017
     C                             SICD4 <> 'SDVA' AND                                        CFT017
     C                             SICD4 <> 'CORT' AND                                        CFT017
     C                             SICD4 <> 'INTC'                                            CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   IF        SICD5 <> *BLANKS AND                                       CFT017
     C                             SICD5 <> 'SDVA' AND                                        CFT017
     C                             SICD5 <> 'CORT' AND                                        CFT017
     C                             SICD5 <> 'INTC'                                            CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Bank to Bank info                                                                    CFT017
      *                                                                                       CFT017
     C                   MOVEL     SBBI1         WWBTBK           35                          CFT017
     C                   EXSR      SRBTBK                                                     CFT017
     C                   IF        WBTBK <> 'Y'                                               CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     SBBI2         WWBTBK                                       CFT017
     C                   EXSR      SRBTBK                                                     CFT017
     C                   IF        WBTBK <> 'Y'                                               CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     SBBI3         WWBTBK                                       CFT017
     C                   EXSR      SRBTBK                                                     CFT017
     C                   IF        WBTBK <> 'Y'                                               CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     SBBI4         WWBTBK                                       CFT017
     C                   EXSR      SRBTBK                                                     CFT017
     C                   IF        WBTBK <> 'Y'                                               CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     SBBI5         WWBTBK                                       CFT017
     C                   EXSR      SRBTBK                                                     CFT017
     C                   IF        WBTBK <> 'Y'                                               CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   MOVEL     SBBI6         WWBTBK                                       CFT017
     C                   EXSR      SRBTBK                                                     CFT017
     C                   IF        WBTBK <> 'Y'                                               CFT017
     C                   GOTO      ENM103                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** If all conditions were satisfied, set ind to 'Y'                                     CFT017
      *                                                                                       CFT017
     C                   MOVEL     'Y'           WM103                                        CFT017
      *                                                                                       CFT017
     C     ENM103        ENDSR                                                                CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRSBIC - Check if field is attached to SWIFT BIC             *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRM103                                            *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRSBIC        BEGSR                                                                CFT017
      *                                                                                       CFT017
     C                   CLEAR                   WSNDID                                       CFT017
     C                   CLEAR                   WSNDI2                                       CFT017
      *                                                                                       CFT017
      ** Ordering bank is SWIFT id                                                            CFT017
     C                   EVAL      WSNDTP = @ORBT                                             CFT017
     C                   EVAL      WSNDID = SORBK                                             CFT017
     C                   IF        @ORBT = 'N'                                                CFT017
     C                   MOVEL     SSMCY         PCYCD                                        CFT017
     C                   ENDIF                                                                CFT017
     C                   EXSR      SRCSID                                                     CFT017
     C                   EXSR      SR1400                                                     CFT017
     C                   IF        WCSID <> *BLANKS                                           CFT017
     C                   GOTO      ENSBIC                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Sender's Correspondent is SWIFT id                                                   CFT017
     C                   EVAL      WSNDTP = @SNCT                                             CFT017
     C                   EVAL      WSNDID = SSNCO                                             CFT017
     C                   EXSR      SRCSID                                                     CFT017
     C                   EXSR      SR1400                                                     CFT017
     C                   IF        WCSID <> *BLANKS                                           CFT017
     C                   GOTO      ENSBIC                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Receiver's correspondent                                                             CFT017
     C                   EVAL      WSNDTP = @RCRT                                             CFT017
     C                   EVAL      WSNDID = SRCO1                                             CFT017
     C                   EVAL      WSNDI2 = SRCO2                                             CFT017
     C                   IF        @RCRT = 'N'                                                CFT017
     C                   EVAL      PCYCD = SSMCY                                              CFT017
     C                   ENDIF                                                                CFT017
     C                   EXSR      SRCSID                                                     CFT017
     C                   EXSR      SR1400                                                     CFT017
     C                   IF        WCSID <> *BLANKS                                           CFT017
     C                   GOTO      ENSBIC                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Third Reimbursement Institution                                                      CFT017
     C                   MOVEL     @TRIT         WSNDTP                                       CFT017
     C                   MOVEL     STRI1         WSNDID                                       CFT017
     C                   MOVEL     STRI2         WSNDI2                                       CFT017
     C                   EXSR      SRCSID                                                     CFT017
     C                   EXSR      SR1400                                                     CFT017
     C                   IF        WCSID <> *BLANKS                                           CFT017
     C                   GOTO      ENSBIC                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Intermediary                                                                         CFT017
     C                   MOVEL     @INBT         WSNDTP                                       CFT017
     C                   MOVEL     SINB1         WSNDID                                       CFT017
     C                   MOVEL     SINB2         WSNDI2                                       CFT017
     C                   EXSR      SRCSID                                                     CFT017
     C                   EXSR      SR1400                                                     CFT017
     C                   IF        WCSID <> *BLANKS                                           CFT017
     C                   GOTO      ENSBIC                                                     CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** Account with Bank                                                                    CFT017
     C                   MOVEL     @ACBT         WSNDTP                                       CFT017
     C                   MOVEL     SACB1         WSNDID                                       CFT017
     C                   MOVEL     SACB2         WSNDI2                                       CFT017
     C                   IF        @ACBT = 'N'                                                CFT017
     C                   EVAL      PCYCD = SPCCY                                              CFT017
     C                   ENDIF                                                                CFT017
     C                   EXSR      SRCSID                                                     CFT017
     C                   EXSR      SR1400                                                     CFT017
      *                                                                                       CFT017
     C     ENSBIC        ENDSR                                                                CFT017
      *                                                                                       CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SR1400 - Call ME1400 to check valid SWIFT address            *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRSBIC                                            *                       CFT017
      *             SRBTBK                                            *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SR1400        BEGSR                                                                CFT017
      *                                                                                       CFT017
     C     WCSID         IFNE      *BLANKS                                                    CFT017
      *                                                                                       CFT017
     C                   MOVEL     WCSID         PBICC             8                          CFT017
     C                   MOVE      WCSID         PBICB             3                          CFT017
      *                                                                                       CFT017
     C                   CALL      'ME1400'                                                   CFT017
     C                   PARM      *BLANKS       PRTCD                                        CFT017
     C                   PARM                    PBICC                                        CFT017
     C                   PARM                    PBICB                                        CFT017
     C                   PARM                    SDCUST                                       CFT017
     C                   PARM                    SDCNST                                       CFT017
     C                   PARM                    MEBICD                                       CFT017
     C                   PARM      *BLANKS       PCNUM             1                          CFT017
     C                   PARM      *BLANKS       PCNST             1                          CFT017
     C                   PARM      *BLANKS       PBICD             1                          CFT017
      *                                                                                       CFT017
     C                   IF        PCNUM <> 'Y' AND                                           CFT017
     C                             PCNST <> 'Y' AND                                           CFT017
     C                             PBICD <> 'Y' OR                                            CFT017
     C                             BDSUBT = 'BEID' AND                                        CFT017
     C                             WBTBK  = *BLANK OR                                         CFT017
     C                             BDSUBT = 'TRCO' AND                                        CFT017
     C                             WBTBK  = *BLANK                                            CFT017
     C                   CLEAR                   WCSID                                        CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   ENDSR                                                                CFT017
      *                                                                                       CFT017
      *****************************************************************                       CFT017
     C/EJECT                                                                                  CFT017
      *****************************************************************                       CFT017
      *                                                               *                       CFT017
      *  SRBTBK - Check Bank to Bank field                            *                       CFT017
      *                                                               *                       CFT017
      *  Called By: SRM103                                            *                       CFT017
      *                                                               *                       CFT017
      *****************************************************************                       CFT017
     C     SRBTBK        BEGSR                                                                CFT017
      *                                                                                       CFT017
     C                   MOVE      'N'           WBTBK             1                          CFT017
     C/COPY WNCPYSRC,FTH00252
      *                                                                                       CFT017
      ** It must not contain the codeword /REJT/, /RETN/, nor the ERI                         CFT017
      ** codeword /OCMT/.                                                                     CFT017
      *                                                                                       CFT017
     C                   IF        WWBTBK <> *BLANKS                                          CFT017
     C     '/REJT/'      SCAN      WWBTBK                                 01                  CFT017
     C                   IF        *IN01                                                      CFT017
     C                   GOTO      ENBTBK                                                     CFT017
     C                   ENDIF                                                                CFT017
     C     '/RETN/'      SCAN      WWBTBK                                 01                  CFT017
     C                   IF        *IN01                                                      CFT017
     C                   GOTO      ENBTBK                                                     CFT017
     C                   ENDIF                                                                CFT017
     C     '/OCMT/'      SCAN      WWBTBK                                 01                  CFT017
     C                   IF        *IN01                                                      CFT017
     C                   GOTO      ENBTBK                                                     CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
      ** If field contains /INS/, it should be followed by a SWIFT                            CFT017
      ** address.  The SWIFT address will be validated via call to                            CFT017
      ** ME1400.  It is a SWIFT address if it is found in Customers                           CFT017
      ** file, Counterparty Nostros file, or in BIC Directory.                                CFT017
      *                                                                                       CFT017
     C                   IF        WWBTBK <> *BLANKS                                          CFT017
     C     '/INS/'       SCAN      WWBTBK                                 01                  CFT017
     C                   IF        *IN01                                                      CFT017
     C                   EVAL      WCSID = %SUBST(WWBTBK:6:11)                                CFT017
     C                   EXSR      SR1400                                                     CFT017
     C                   IF        WCSID = *BLANKS                                            CFT017
     C                   GOTO      ENBTBK                                                     CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
     C                   ENDIF                                                                CFT017
      *                                                                                       CFT017
     C                   MOVE      'Y'           WBTBK                                        CFT017
      *                                                                                       CFT017
     C     ENBTBK        ENDSR                                                                CFT017
      *****************************************************************                       CFT017
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** Scaling factors array - @SF
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
