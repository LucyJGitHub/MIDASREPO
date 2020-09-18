     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate MT100 customer number')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCSNM  - Validate MT100 Customer                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD051679           Date 09Nov18               *
      *                 MD046248           Date 27Oct17               *
      *                 CSW213             Date 03Jun13               *
      *                 MD000091           Date 15May13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25472           Date 12Aug09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 BUG16810           Date 10Mar08               *
      *                 BUG13798           Date 24Apr07               *
      *                 BUG15157           Date 27Oct07               *
      *                 BUG15045           Date 19Oct07               *
      *                 BUG15037           Date 16Oct07               *
      *                 BUG15029           Date 16Oct07               *
      *                 250804A            Date 11Oct07               *
      *                 250600             Date 07Oct07               *
      *                 BUG14948           Date 04Oct07               *
      *                 BUG14771           Date 12Aug07               *
      *                 BUG14716A          Date 04Sep07               *
      *                 249652             Date 09Jul07               *
      *                 CSW207A            Date 27Jul07               *
      *                 CSW207             Date 07Jun07               *
      *                 BUG14042           Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 246451             Date 16Mar07               *
      *                 BUG13455           Date 20Feb07               *
      *                 BUG13027           Date 10Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12829           Date 07Dec06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 19Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD051679 - Added clear before reading SDNOSTPD to ensure that*
      *             no values are carried out when reading again. Also*
      *             added a validation to not set ODMTT to 'F' if     *
      *             account was not found.                            *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22580 - Fields incorrectly labeled and lengths            *
      *           (Recompile)                                         *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG25472 - NAHO not accepted in MT103 Account field          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  BUG16810 - MT103 customer error                              *
      *  BUG13798 - CFT032 errors. Annotated as BUG14042.             *
      *  BUG15157 - MT103 Account is not a valid full general ledger  *
      *             account. (Field: MT103 Account).                  *
      *  BUG15045 - System does not accept an External account input  *
      *             in Ordering customer field                        *
      *  BUG15037 - Error message should be a warning                 *
      *  BUG15029 - Warning message displayed was "ERROR - Message    *
      *             not found                                         *
      *  250804A - Fix various CFT032/CSW207 Errors                   *
      *  250600 - Fix various CFT032/CSW207 Errors                    *
      *  BUG14948 - CFT032 errors                                     *
      *  BUG14771 - Amended the input function and the message        *
      *             generation for CFT032                             *
      *  BUG14716A - CFT032 pre-req missing CFT018 OPSI Outgoing      *
      *              Payments Template (Recompile)                    *
      *  249652 - CFT032, few problems                                *
      *  CSW207A - Swift 2007 Standard Changes                        *
      *  CSW207 - Swift 2007 Standard Changes                         *
      *  BUG14042 - CFT032 errors ; applied fix 13798                 *
      *  246451 - Applied Bugzilla fix 12829 from MP1_3.               *
      *  BUG13455 - CFT032 Parameter Mismatch for AOOUFMR0            *
      *  BUG13027 - Invalid Data in field MT103 Customer              *
      *             Stops Production of SWIFT Messages                *
      *  BUG12829 - ODMTT field not populated                         *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.  (Recompiled)           *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
                                                                                              CFT032
      ** Midas ME SWIFT ISO country codes                                                     CFT032
                                                                                              CFT032
     FMEISOCL1  IF   E           K Disk                                                       CFT032
                                                                                              CFT032
      *                                                                                       250600
     FSDJACCL3  IF   E           K DISK    INFSR(*PSSR)                                       250600
      *                                                                                       250600
     FSDJACCL4  IF   E           K DISK    INFSR(*PSSR)                                       250600
     F                                     RENAME(SDJACCD0:SDJACCF)                           250600
      *****************************************************************
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
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
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ** Array of Warning in error.                                                         BUG14042
     D WFldNamXAr      S             10A   DIM(XArrayMax)                                   BUG14042
                                                                                            BUG14042
      ** Array of Warning message IDs                                                       BUG14042
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                      BUG14042
                                                                                            BUG14042
      ** Array of Warning message data.                                                     BUG14042
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                    BUG14042
                                                                                            BUG14042
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                                 CFT032
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External data structure for Nostro customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D B_SDCUST      E DS                  EXTNAME(SDCUSTPD)                                 250804A
     D                                     Prefix(B_)                                        250804A
 
      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    250804A
 
      ** External data strcuture for Accounts Master Detail                                   CFT032
                                                                                              CFT032
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CFT032
                                                                                              CFT032
      ** External data structure for Nostro details                                           CFT032
                                                                                              CFT032
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CFT032
                                                                                              CFT032
      ** External data stsructure for ME BIC Directory                                        CFT032
                                                                                              CFT032
     D MEBICD        E DS                  EXTNAME(MEBICDPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Bank details                                             CFT032
                                                                                              CFT032
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Midas modules                                            CFT032
                                                                                              CFT032
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Retail details                                           CFT032
                                                                                              CFT032
     D SDRETL        E DS                  EXTNAME(SDRETLPD)                                  CFT032
     D  RTLQQACCD    E                     EXTFLD(QQACCD)                                     CFT032
                                                                                              CFT032
      ** External data structure for Counterparty Nostros                                     CFT032
                                                                                              CFT032
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Location codes                                           CFT032
                                                                                              CFT032
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Country codes                                            CFT032
                                                                                              CFT032
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Branch codes                                             CFT032
                                                                                              CFT032
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CFT032
     D   BRCQQDFAC   E                     EXTFLD(QQDFAC)                                     CFT032
                                                                                              CFT032
      ** External data structure for Outgoing Field Mgmt                                      CFT032
                                                                                              CFT032
     D MEOUFM        E DS                  EXTNAME(MEOUFMPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Non Account Holder                                       CSW207
                                                                                              CSW207
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)                                  CSW207
                                                                                              CSW207
      ** #SODMT Data Structure                                                                CFT032
                                                                                              CFT032
     D #SODMT          DS                                                                     CFT032
     D   DRET                  1     10                                                       CFT032
     D   DCUS                  1     10                                                       CFT032
     D   NCUR                  1      3                                                       CFT032
     D   DNOS                  1      5                                                       CFT032
     D   DNUM                  1      6                                                       CFT032
     D   NNUM                  4      5                                                       CFT032
     D   DSCY                  7      9                                                       CFT032
     D   DCOD                 10     13                                                       CFT032
     D   DSEQ                 14     15                                                       CFT032
     D   DBRC                 16     18                                                       CFT032
     D   D05R                  6     34                                                       CFT032
     D   D06R                  7     34                                                       CFT032
     D   D10R                 11     34                                                       CFT032
     D   D15R                 16     34                                                       CFT032
     D   D18R                 19     34                                                       CFT032
                                                                                              CFT032
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Midas general constant fields                                                        CFT032
                                                                                              CFT032
      /COPY FTCPYSRC,SFTVALCSLE                                                               CFT032
                                                                                              CFT032
      ** Midas FT general address data structure                                              CFT032
                                                                                              CFT032
      /COPY FTCPYSRC,SFTADDRILE                                                               CFT032
                                                                                              CFT032
      ** System Value for MT103 Account transactions for FATF countries                       CFT032
                                                                                              CFT032
     D CMT103BetFATF   C                    'AllowMT103AccFATF'                               CFT032
                                                                                              CFT032
                                                                                              CFT032
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc                                        BUG14042
     D WIx             S              3P 0                                                  BUG14042
 
     D C#KEY1          S             10
     D C#KYST          S              7
     D C#OPTN          S              7
     D C#RTCD          S              7
                                                                                              CFT032
      ** Parameters for Access Objects                                                        CFT032
                                                                                              CFT032
     D P@RTCD          S              7A                                                      CFT032
     D P@OP01          S             20A                                                      CFT032
     D P@VL01          S            200A                                                      CFT032
     D P@OP02          S             20A                                                      CFT032
     D P@VL02          S            200A                                                      CFT032
     D P@OP03          S             20A                                                      CFT032
     D P@VL03          S            200A                                                      CFT032
     D P@OP04          S             20A                                                      CFT032
     D P@VL04          S            200A                                                      CFT032
     D P@OP05          S             20A                                                      CFT032
     D P@VL05          S            200A                                                      CFT032
     D P@OP06          S             20A                                                      CFT032
     D P@VL06          S            200A                                                      CFT032
     D P@OP07          S             20A                                                      CFT032
     D P@VL07          S            200A                                                      CFT032
     D P@OP08          S             20A                                                      CFT032
     D P@VL08          S            200A                                                      CFT032
     D P@OP09          S             20A                                                      CFT032
     D P@VL09          S            200A                                                      CFT032
     D P@OP10          S             20A                                                      CFT032
     D P@VL10          S            200A                                                      CFT032
                                                                                              CFT032
     D P@CUST          S              6A                                                      CFT032
     D P@CYCD          S              3A                                                      CFT032
     D P@ACCD          S             10A                                                      CFT032
     D P@ACSQ          S              2A                                                      CFT032
     D P@NONB          S              2A                                                      CFT032
     D P@BRCD          S              3A                                                      CFT032
     D P@BRCD4A        S              4A                                                    BUG14042
     D P@CSSN          S             10A                                                      CFT032
     D P@PNOI          S              1A                                                      CFT032
     D P@IBAN          S             34A                                                      CFT032
     D P@RETL          S             10A                                                      CFT032
     D P@NET           S              6A                                                      CFT032
     D P@NOS           S              2A                                                      CFT032
     D P@STR           S             35A                                                      CFT032
     D P@TAG           S              5A                                                      CFT032
     D*P@ACT****       S             15A                                               CFT032 249652
     D P@ACT           S             10A                                                      249652
     D P@TYP           S             10A                                                      CFT032
     D P@TYP3A         S              3A                                                      249652
     D P@Sar           S              6A                                                      CFT032
     D P@CTRY          S              2A                                                    BUG13455
     D P@CTRY4A        S              4A                                                    BUG14042
                                                                                              CFT032
      ** Work variables                                                                       CFT032
                                                                                              CFT032
     D WMT103AccType   S              1A                                                      CFT032
     D WCurrency       S              3A                                                      CFT032
     D WCustomer       S              6A                                                      CFT032
     D WFTAFCountry    S              2A                                                      CFT032
     D @@IBAN          S              1A                                                      CFT032
     D WSendFTAF       S              1A                                                      CFT032
     D WDestFTAF       S              1A                                                      CFT032
     D WFieldTag       S              5A                                                      CFT032
     D WAcctBrc        S                   Like(BRCA)                                         CFT032
     D WAcctCcy        S                   Like(CCY)                                          CFT032
     D WAcctCod        S                   Like(ACOD)                                         CFT032
     D WAcctCus        S                   Like(CNUM)                                         CFT032
     D WAcctSeq        S                   Like(ACSQ)                                         CFT032
     D WAddress        S             35A                                                      CFT032
     D WBrc            S                   Like(BRCA)                                         CFT032
     D WCountry        S              3A                                                      CFT032
     D WEntryType      S              1A                                                      CFT032
     D WNetwork        S             10A                                                      CFT032
     D WNostro         S              2A                                                      CFT032
     D WSbrca          S              3A                                                    BUG15037
                                                                                              CFT032
     D FeatureCSW024   S               N                                                      CFT032
     D FeatureCFT004   S               N                                                      CFT032
                                                                                              CFT032
      ** SWIFT subroutine parameters/variables                                                CFT032
                                                                                              CFT032
     D CLSWTK          S             34A                                                      CFT032
     D ##CSID          S              1A                                                      CFT032
                                                                                              CSW207
      ** SWIFT 2007 feature                                                                   CSW207
                                                                                              CSW207
     D CSW207          S              1A                                                      CSW207
 
     D PfAccnt         DS            24                                                       250600
     D  PfBRCA                 1      3                                                       250600
     D  PfCNUM                 4      9                                                       250600
     D  PfCYY                 10     12                                                       250600
     D  PfACOD                13     22  0                                                    250600
     D  PfACSQ                23     24  0                                                    250600
      *                                                                                       250600
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
      *
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0                                                  BUG14042
 
      * MT100 Customer
      *
     C                   Exsr      VODMTX
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKOdmt = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT
     C****************************************************************
     C* VODMTX -  VALIDATION OF MT100 CUSTOMER                      *
     C****************************************************************
     C*
     C     VODMTX        BEGSR
 
     C                   Eval      #SODMT = SODMT                                             CFT032
     C                   Eval      WSbrca = SBRCA                                           BUG15037
     C                   If        %Check('?':SODMT) = 0                                      CFT032
                                                                                              CFT032
      ** Send error to screen: ? is not allowed....                                           CFT032
                                                                                              CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1401'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
                                                                                              CFT032
     C                   Else                                                                 CFT032
                                                                                              CFT032
     C                   Eval      WMT103AccType = ' '                                        CFT032
     C                   If        SSMCY <> ' '                                               CFT032
     C                   Eval      WCurrency = SSMCY                                          CFT032
     C                   Else                                                                 CFT032
     C                   Eval      WCurrency = SPCCY                                          CFT032
     C                   EndIf                                                                CFT032
     C                   Eval      @@IBAN = 'N'                                               CFT032
                                                                                              CFT032
      ** Retrieve "Allow MT103 Accounts between FATF countries" system value                  CFT032
      ** to see if such transactions are allowed or not.                                      CFT032
                                                                                              CFT032
     C                   Call      'AOSVALR0'                                                 CFT032
     C                   Parm      *Blanks       P@RTCD                                       CFT032
     C                   Parm      CMT103BetFATF P@OP01                                       CFT032
     C                   Parm      *Blanks       P@VL01                                       CFT032
     C                   Parm      *Blanks       P@OP02                                       CFT032
     C                   Parm      *Blanks       P@VL02                                       CFT032
     C                   Parm      *Blanks       P@OP03                                       CFT032
     C                   Parm      *Blanks       P@VL03                                       CFT032
     C                   Parm      *Blanks       P@OP04                                       CFT032
     C                   Parm      *Blanks       P@VL04                                       CFT032
     C                   Parm      *Blanks       P@OP05                                       CFT032
     C                   Parm      *Blanks       P@VL05                                       CFT032
     C                   Parm      *Blanks       P@OP06                                       CFT032
     C                   Parm      *Blanks       P@VL06                                       CFT032
     C                   Parm      *Blanks       P@OP07                                       CFT032
     C                   Parm      *Blanks       P@VL07                                       CFT032
     C                   Parm      *Blanks       P@OP08                                       CFT032
     C                   Parm      *Blanks       P@VL08                                       CFT032
     C                   Parm      *Blanks       P@OP09                                       CFT032
     C                   Parm      *Blanks       P@VL09                                       CFT032
     C                   Parm      *Blanks       P@OP10                                       CFT032
     C                   Parm      *Blanks       P@VL10                                       CFT032
                                                                                              CFT032
      ** Not allowed....                                                                      CFT032
                                                                                              CFT032
     C                   If        %Trim( P@VL01 ) = 'N'                                      CFT032
                                                                                              CFT032
      ** Check if sender is part of FATF                                                      CFT032
                                                                                              CFT032
     C                   Call      'AOBRCHR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C**********         Parm      *Blanks       @Optn                               CFT032 BUG14948
     C                   Parm      '*KEY   '     @Optn                                      BUG14948
     C**********         Parm                    @BRCA                               CFT032 BUG15037
     C                   Parm                    WSbrca                                     BUG15037
     C     SDBRCH        Parm      SDBRCH        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RTCd = *Blanks                                            CFT032
     C                   Movel(P)  A8BICN        C#Key1                                      250804A
     C                   CALL      'AOCUSTR1'                                                250804A
     C                   PARM      '*BLANKS'     @RtCd                                       250804A
     C                   PARM      '*KEY   '     @Optn                                       250804A
     C                   PARM                    C#Key1                                      250804A
     C                   PARM      *BLANKS       C#Kyst                                      250804A
     C     B_SDCUST      PARM      B_SDCUST      DSLDY                                       250804A
      *                                                                                      250804A
     C                   If        A8LCCD <> *Blanks                                         250804A
     C                   Call      'AOLOCNR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C**********         Parm      *Blanks       @Optn                               CFT032 BUG14948
     C                   Parm      '*KEY   '     @Optn                                      BUG14948
     C                   Parm                    A8LCCD                                       CFT032
     C     SDLOCN        Parm      SDLOCN        DSSDY                                        CFT032
      *                                                                                      250804A
     C                   Eval      @CTRY = DVCNCD                                            250804A
     C                   Else                                                                250804A
     C                   Eval      @CTRY = B_BBCOLC                                          250804A
     C                   Endif                                                               250804A
      *                                                                                      250804A
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Call      'AOCTRYR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C**********         Parm      *Blanks       @Optn                               CFT032 BUG14948
     C                   Parm      '*KEY   '     @Optn                                      BUG14948
     C**********         Parm                    A8LCCD                              CFT032 BUG14948
     C**********         Parm                    DVCNCD                             BUG14948 250804A
     C                   Parm                    @CTRY             2                         250804A
     C     SDCTRY        Parm      SDCTRY        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCD = *Blanks                                            CFT032
     C     A4ISOC        Chain     MEISOCL1                                                   CFT032
     C                   If        %Found( MEISOCL1 )                                         CFT032
     C                   Eval      WSendFTAF = M3FATF                                         CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Check if destination is part of FATF                                                 CFT032
                                                                                              CFT032
     C                   Select                                                               CFT032
     C                   When      @DSTT = 'A'                                                CFT032
     C                   Eval      WFTAFCountry = ' '                                         CFT032
     C                   Eval      WDestFTAF = 'N'                                            CFT032
                                                                                              CFT032
     C                   When      @DSTT = 'S'                                                CFT032
     C**********         Eval      WFTAFCountry = %Subst(#SODMT:5:2)                 CFT032 BUG14771
     C                   Eval      WFTAFCountry = %Subst(SDST1:5:2)                         BUG14771
                                                                                              CFT032
     C                   Other                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOACCTV1'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      *Blanks       P@Typ                                        CFT032
     C**********         Parm      #SODMT        P@Str                               CFT032 BUG14771
     C                   Parm      SDST1         P@Str                                      BUG14771
     C                   Parm                    DSSDY                                        CFT032
                                                                                              CFT032
     C                   Select                                                               CFT032
     C                   When      P@Typ = '*RETAIL' Or                                       CFT032
     C                             P@Typ = '*LEDGER'                                          CFT032
     C                   Eval      ACCNT = DSSDY                                              CFT032
     C                   Eval      WCustomer = CNUM                                           CFT032
     C                   When      P@Typ = '*NOSTRO'                                          CFT032
     C                   Eval      SDNOST = DSSDY                                             CFT032
     C                   Eval      WCustomer = A7CUST                                         CFT032
     C                   When      P@Typ = '*CUSTNO' Or                                       CFT032
     C                             P@Typ = '*SHNAME'                                          CFT032
     C                   Eval      SDCUST = DSSDY                                             CFT032
     C                   Eval      WCustomer = BBCUST                                         CFT032
     C                   EndSl                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOCUSTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      WCustomer     C#Key1                                       CFT032
     C                   Parm      *Blanks       C#Kyst                                       CFT032
     C     SDCUST        Parm      SDCUST        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCD = *Blanks                                            CFT032
     C                   Eval      WFTAFCountry = BBCOLC                                      CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndSl                                                                CFT032
                                                                                              CFT032
     C     WFTAFCountry  Chain     MEISOCL1                                                   CFT032
     C                   If        %Found( MEISOCL1 )                                         CFT032
     C                   Eval      WDestFTAF = M3FATF                                         CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Sender FTAF and Destination FTAF flags should not be both 'Y'                        CFT032
                                                                                              CFT032
     C                   If        WSendFTAF = 'Y'  And                                       CFT032
     C                             WDestFTAF = 'Y'  And                                       CFT032
     C                             SODMT <> *Blanks                                           CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1402'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
     C                   LeaveSr                                                              CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                              BUG13027
                                                                                              CFT032
     C                   ENDIF                                                              BUG25472
E2    *                                                                                     BUG14771
                                                                                             CSW207A
      ** Check if entered value is a non-account holder                                      CSW207A
                                                                                             CSW207A
     C**********         If        %Len( %Trim( #SODMT ) ) = 10 AND                 CSW207A BUG16810
     C**********         If        %Len( %Trim( #SODMT ) ) <= 10 AND               BUG16810 BUG25472
     C**********                   CSW207 = 'Y'                                     CSW207A BUG25472
     C                   IF        CSW207 = 'Y'                                             BUG25472
     C                   EXSR      SRNHLDR                                                   CSW207A
     C                   ENDIF                                                               CSW207A
                                                                                             CSW207A
     C**********         EndIf                                                       250600 BUG25472
      ** Check for IBAN: 1st 2 characters are alphabetic and                                  CFT032
      **                 next 2 characters are numberic                                       CFT032
                                                                                              CFT032
     C                   If        %Check( ALPHAB :                                         BUG12829
     C                                     %Subst( #SODMT : 1 : 2 )) = 0  AND               BUG12829
     C                             %Check( DIGITS :                                         BUG12829
     C                                     %Subst( #SODMT : 3 : 2 )) = 0                    BUG12829
     C**********         If        %Check( %Subst( #SODMT : 1 : 2 ) :                CFT032 BUG12829
     C**********                           ALPHAB) = 0  AND                          CFT032 BUG12829
     C**********                   %Check( %Subst( #SODMT : 3 : 2 ) :                CFT032 BUG12829
     C**********                           DIGITS) = 0                               CFT032 BUG12829
     C                             And @ODMTT <> 'O'                                         CSW207A
     C                   Exsr      VIBAN                                                      CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Check if entered value is a customer number (Nostro)                                 CFT032
                                                                                              CFT032
     C                   If        %Len( %Trim( #SODMT ) ) = 5                                CFT032
     C                             And @ODMTT <> 'O'                                        BUG16810
     C                   Exsr      VNOSTRO                                                    CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Check if entered value is a customer number                                          CFT032
                                                                                              CFT032
     C                   If        %Len( %Trim( #SODMT ) ) = 6                                CFT032
     C                             And @ODMTT <> 'O'                                        BUG16810
     C                   Exsr      VNUM                                                       CFT032
     C                   EndIf                                                                CFT032
     ***********                                                                      CSW207 CSW207A
     ****Check*if*entered*value*is*a*non-account*holder                               CSW207 CSW207A
     ***********                                                                      CSW207 CSW207A
     C**********         If        %Len( %Trim( #SODMT ) ) = 10 AND                   CSW207 CSW207A
     C**********                   CSW207 = 'Y'                                       CSW207 CSW207A
     C**********         EXSR      SRNHLDR                                            CSW207 CSW207A
     C**********         ENDIF                                                        CSW207 CSW207A
                                                                                              CFT032
      ** Check if entered value is a retail account                                           CFT032
                                                                                              CFT032
     C                   If        %Len( %Trim( #SODMT ) ) = 10                               CFT032
     C                             And @ODMTT <> 'O'                                         CSW207A
     C                   Exsr      VRET                                                       CFT032
     C                   EndIf                                                                CFT032
                                                                                            BUG14948
      ** Check Customer short name                                                          BUG14948
                                                                                            BUG14948
     C                   If        %Len( %Trim( #SODMT ) ) <= 11 and                        BUG14948
     C                             %Len( %Trim( #SODMT ) ) > 0                              BUG14948
     C                             And @ODMTT = ' '                                         BUG14948
     C                   Exsr      VNAM                                                     BUG14948
     C                   EndIf                                                              BUG14948
                                                                                              CFT032
      ** Check if entered value is a full ledger account                                      CFT032
                                                                                              CFT032
     C**********         If        %Len( %Trim( #SODMT ) ) = 15  Or                  CFT032 BUG15045
     C**********                   %Len( %Trim( #SODMT ) ) = 18                      CFT032 BUG15045
     C                   If        %Len( %Trim( #SODMT ) ) = 21  Or                         BUG15045
     C                             %Len( %Trim( #SODMT ) ) = 24                             BUG15045
     C                   Exsr      VACC                                                       CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Check if valid account has been entered                                              CFT032
                                                                                              CFT032
     C                   If        @ODMTT = 'I'  Or                                           CFT032
     C                             @ODMTT = 'G'  Or                                           CFT032
     C                             @ODMTT = 'F'  Or                                           CFT032
     C                             @ODMTT = 'R'                                               CFT032
                                                                                              CFT032
     C                   If        SSMCY <> *Blanks                                           CFT032
     C                   If        SSMCY <> CCY                                               CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1403'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
     C                   EndIf                                                                CFT032
     C                   Else                                                                 CFT032
     C                   If        SPCCY <> CCY                                               CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1403'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Additional validation                                                                CFT032
                                                                                              CFT032
     C                   If        #SODMT <> *Blanks                                          CFT032
     C                   If        @ODMTT = 'I'  Or                                           250600
     C                             @ODMTT = 'G'  Or                                           250600
     C                             @ODMTT = 'F'  Or                                           250600
     C                             @ODMTT = 'R'                                               250600
     C                   Eval      PfBRCA = BRCA                                              250600
     C                   Eval      PfCNUM = CNUM                                              250600
     C                   Eval      PfCYY = CCY                                                250600
     C                   Eval      PfACOD = ACOD                                              250600
     C                   Eval      PfACSQ = ACSQ                                              250600
     C                   Else                                                                 250600
     C                   Eval      PfAccnt = *Blanks                                          250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Exsr      SROUFM                                                     CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      SODMT = #SODMT                                             CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   If        @ODMTT  = *Blanks  And                                   BUG12829
     C                             #SODMT <> *Blanks                                        BUG12829
     C                   Eval      Idx = Idx + 1                                            BUG12829
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                 BUG12829
     C                   Eval      MsgIdXAr(Idx) = 'MMA0772'                                BUG12829
     C                   Eval      OkOdmt = 'N'                                             BUG12829
     C                   EndIf                                                              BUG12829
                                                                                            BUG12829
     C**********         EndIf                                                       CFT032 BUG13027
                                                                                              CFT032
     C**********         EndIf                                                         CFT032 250600
                                                                                              CFT032
      * Optional - Must be a 6 digit Customer no. or 10 digit customer name
     C**********         If        SODMT <> *Blanks                                           CFT032
     C**********         CALLB     'AOCUSTR0'                                                 CFT032
     C**********         Parm      *Blanks       C#RTCD                                       CFT032
     C**********         Parm      '*KEY   '     C#OPTN                                       CFT032
     C**********         Parm      SODMT         C#KEY1                                       CFT032
     C**********         Parm      *Blanks       C#KYST                                       CFT032
     C*****SDCUST        Parm      SDCUST        DSSDY                                        CFT032
 
     C**********         If        C#RTCD <> *Blanks                                          CFT032
      **Send*error to screen                                                                  CFT032
     C**********         Move      'N'           OKOdmt                                       CFT032
     C**********         Add       1             Idx                                          CFT032
     C**********         Movel     'SODMT'       FldNamXAr(Idx)                               CFT032
     C**********         Movel     'MMA1013'     MsgIdXAr(Idx)                                CFT032
 
     C**********         Else                                                                 CFT032
     C**********         Movel(P)  BBCUST        SODMT                                        CFT032
     C**********         End                                                                  CFT032
     C**********         End                                                                  CFT032
     C*
     C                   ENDSR
     C*
     C************************************************************
     C* END OF MT100 CUSTOMER VALIDATION
     C************************************************************
     C/EJECT
      ************************************************************                            CFT032
      ** VNOSTRO - Check if customer number                                                   CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     VNOSTRO       BEGSR                                                                CFT032
     C                   Clear                   SDNOST                                     MD051679
                                                                                              CFT032
     C                   Call      'AONOSTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      *Blanks       P@CUST                                     BUG12829
     C**********         Parm      NNUM          P@CUST                              CFT032 BUG12829
     C                   Parm      NCUR          P@CYCD                                       CFT032
     C                   Parm      *Blanks       P@ACCD                                       CFT032
     C                   Parm      *Blanks       P@ACSQ                                       CFT032
     C                   Parm      NNUM          P@NONB                                     BUG12829
     C**********         Parm      *Blanks       P@NONB                              CFT032 BUG12829
     C                   Parm      *Blanks       P@BRCD                                       CFT032
     C                   Parm      *Blanks       P@CSSN                                       CFT032
     C                   Parm      *Blanks       P@PNOI                                       CFT032
     C     SDNOST        Parm      SDNOST        DSSDY                                        CFT032
                                                                                              CFT032
     C**********         If        @RtCd <> *Blanks                                  CFT032 BUG14948
     C                   If        @RtCd = *Blanks                                          BUG14948
                                                                                              CFT032
     C**********         Eval      P@ACSQ = %EDITC(ACSQ:'X')                         CFT032 BUG14771
     C                   Eval      P@ACSQ = %EDITC(A7ACSN:'X')                              BUG14771
     C                   Call      'AOACCTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      *Zeros        P@RETL                                       CFT032
     C                   Parm      A7CUST        P@CUST                                       CFT032
     C                   Parm      A7CYCD        P@CYCD                                       CFT032
     C                   Parm      A7ACCD        P@ACCD                                       CFT032
     C                   Parm                    P@ACSQ                                       CFT032
     C                   Parm      A7BRCD        P@BRCD                                       CFT032
     C     ACCNT         Parm      ACCNT         DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks  And                                       CFT032
     C                             RECI = 'D'                                                 CFT032
     C                   Eval      @ODMTT = 'F'                                               CFT032
     C                   If        IBAN <> ' '                                                CFT032
     C                   Eval      @@IBAN = 'Y'                                               CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   Else                                                                 CFT032
                                                                                              CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1404'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   ELSE                                                               BUG12829
     C                   If        @RtCd <> '*NRF   '                                       MD051679
     C                   Eval      @ODMTT = 'F'                                             BUG12829
     C                   Eval      CCY = A7CYCD                                             BUG12829
     C                   EndIf                                                              MD051679
                                                                                            BUG12829
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End of Check if customer number                                                      CFT032
      ************************************************************                            CFT032
      /EJECT                                                                                  CFT032
      ************************************************************                            CFT032
      ** VNUM - Check if customer number                                                      CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     VNUM          BEGSR                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOCUSTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C**********         Parm      NNUM          C#Key1                                       CFT032
     C**********         Parm      DNUM          C#Key1                            BUG12829 BUG14771
     C                   Parm      DCUS          C#Key1                                     BUG14771
     C                   Parm      *Blanks       C#Kyst                                       CFT032
     C     SDCUST        Parm      SDCUST        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      @ODMTT = 'C'                                               CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End of Check if customer number                                                      CFT032
      ************************************************************                            CFT032
      /EJECT                                                                                  CFT032
      ************************************************************                            CSW207
      /EJECT                                                                                  CSW207
      ************************************************************                            CSW207
      ** SRNHLDR - Check if non account holder                                                CSW207
      ************************************************************                            CSW207
                                                                                              CSW207
     C     SRNHLDR       BEGSR                                                                CSW207
                                                                                              CSW207
      ** Non account holder only allowed if ordering customer is linked to an internal        250600
      ** Customer                                                                             250600
     C                   If        @ORDCS <> *Blanks                                          250600
      *                                                                                       250600
     C                   MOVEL     SODMT         C#Key1                                      CSW207A
     C                   Call      'AONAHOR0'                                                 CSW207
     C                   Parm      *Blanks       @RtCd                                        CSW207
     C                   Parm      '*KEY'        @Optn                                        CSW207
     C**********         Parm      DCUS          C#Key1                               CSW207 CSW207A
     C                   Parm                    C#Key1                                      CSW207A
     C     SDNAHO        Parm      SDNAHO        DSSDY                                        CSW207
                                                                                              CSW207
     C                   If        @RtCd = *Blanks                                            CSW207
      *                                                                                       250600
     C                   Eval      C#JANO = @ORDCS                                            250600
      *                                                                                       250600
     C     JACMKY1       KLIST                                                                250600
     C                   KFLD                    C#JANO            6                          250600
     C                   KFLD                    C#Key1                                       250600
      *                                                                                       250600
     C     JACMKY1       Chain     SDJACCL3                                                   250600
      *                                                                                       250600
     C                   If        NOT %Found(SDJACCL3)                                       250600
      *                                                                                       250600
     C     @ORDCS        Chain     SDJACCL4                                                   250600
      *                                                                                       250600
     C                   If        %Found(SDJACCL4)                                           250600
     C                   Eval      C#JANO = JCJANO                                            250600
     C     JACMKY1       Chain     SDJACCL3                                                   250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   If        NOT %Found(SDJACCL3)                                       250600
     C                   Eval      OKOdmt = 'N'                                               250600
     C                   Eval      Idx = Idx + 1                                              250600
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   250600
     C                   Eval      MsgIdXAr(Idx) = 'MMA3000'                                  250600
     C                   LeaveSR                                                              250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   Eval      @ODMTT = 'O'                                               CSW207
     C                   EndIf                                                                CSW207
     C                   EndIf                                                                250600
                                                                                              CSW207
     C                   ENDSR                                                                CSW207
                                                                                              CSW207
      ************************************************************                            CSW207
      ** End of Check if non account holder                                                   CSW207
      ************************************************************                            CSW207
      /EJECT                                                                                  CSW207
      ************************************************************                            CFT032
      ** VRET - Check if retail account                                                       CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     VRET          BEGSR                                                                CFT032
                                                                                              CFT032
     C                   If        %Check( DIGITS : DRET ) = 0                              BUG12829
     C**********         If        %Check( DRET : DIGITS ) = 0                       CFT032 BUG12829
                                                                                              CFT032
      ** Check if Retail Number is not allowed                                                CFT032
                                                                                              CFT032
     C                   If        BMRANR = 'N'                                               CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1405'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
     C                   LeaveSr                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOACCTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      DRET          P@RETL                                       CFT032
     C                   Parm      *Blanks       P@CUST                                       CFT032
     C                   Parm      *Blanks       P@CYCD                                       CFT032
     C                   Parm      *Blanks       P@ACCD                                       CFT032
     C                   Parm      *Blanks       P@ACSQ                                       CFT032
     C                   Parm      *Blanks       P@BRCD                                       CFT032
     C     ACCNT         Parm      ACCNT         DSSDY                                        CFT032
                                                                                              CFT032
     C**********         If        @RtCD <> *Blanks  And                             CFT032 BUG14771
     C**********                   RECI <> 'D'                                       CFT032 BUG14771
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14771
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14771
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1406'                         CFT032 BUG14771
     C**********         Eval      OkOdmt = 'N'                                      CFT032 BUG14771
     C**********         Else                                                        CFT032 BUG14771
     C                   If        @RtCD =  *Blanks  And                                    BUG14771
     C                             RECI =  'D'                                              BUG14771
     C                   Eval      WAcctSeq = ACSQ                                          BUG14771
     C                   Eval      WAcctCod = ACOD                                          BUG14771
     C                   Eval      WAcctBrc = BRCA                                          BUG14771
     C                   Eval      WAcctCcy = CCY                                           BUG14771
     C                   Eval      WAcctCus = CNUM                                          BUG14771
     C                   Eval      @ODMTT = 'R'                                             BUG14771
     C                   If        IBAN <> ' '                                              BUG14771
     C                   Eval      @@IBAN = 'Y'                                             BUG14771
     C                   EndIf                                                              BUG14771
     C                   else                                                               BUG14771
     C                   Eval      Idx = Idx + 1                                            BUG14771
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                 BUG14771
     C                   Eval      MsgIdXAr(Idx) = 'MMA1406'                                BUG14771
     C                   Eval      OkOdmt = 'N'                                             BUG14771
     C                   EndIf                                                              BUG14771
     C**********         Eval      WAcctSeq = ACSQ                                   CFT032 BUG14771
     C**********         Eval      WAcctCod = ACOD                                   CFT032 BUG14771
     C**********         Eval      WAcctBrc = BRCA                                   CFT032 BUG14771
     C**********         Eval      WAcctCcy = CCY                                    CFT032 BUG14771
     C**********         Eval      WAcctCus = CNUM                                   CFT032 BUG14771
     C**********         Eval      @ODMTT = 'R'                                      CFT032 BUG14771
     C**********         If        IBAN <> ' '                                       CFT032 BUG14771
     C**********         Eval      @@IBAN = 'Y'                                      CFT032 BUG14771
     C**********         EndIf                                                       CFT032 BUG14771
     C**********         EndIf                                                       CFT032 BUG14771
                                                                                              CFT032
     C**********         Else                                                        CFT032 BUG14771
                                                                                              CFT032
     C**********         If        @ODMTT = ' '                                    BUG14771 BUG14948
     C**********         Exsr      VNAM                                              CFT032 BUG14948
     C**********         EndIf                                                     BUG14771 BUG14948
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End of Check if retail account                                                       CFT032
      ************************************************************                            CFT032
      /EJECT                                                                                  CFT032
      ************************************************************                            CFT032
      ** VNAM - Check Customer short name                                                     CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     VNAM          BEGSR                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOCUSTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      DCUS          C#Key1                                       CFT032
     C                   Parm      *Blanks       C#Kyst                                       CFT032
     C     SDCUST        Parm      SDCUST        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd <> *Blanks                                           CFT032
                                                                                              CFT032
     C                   EVAL      CLSWTK = #SODMT                                          BUG14948
                                                                                            BUG14948
     C                   Exsr      SWIFT                                                      CFT032
     C                   Move      'N'           WCSID             1                        BUG14771
     C                   If        ##CSID = 'Y' And                                           CFT032
     C                             *IN31 = *Off And                                           CFT032
     C                             *IN32 = *Off                                               CFT032
     C                   Eval      @ODMTT = 'S'                                               CFT032
     C                   Move      'Y'           WCSID             1                        BUG14771
     C                   Else                                                                 CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1013'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   Else                                                                 CFT032
                                                                                            BUG14948
     C                   EVAL      #SODMT = BBCUST                                          BUG14948
     C                   EVAL      SODMT = BBCUST                                           BUG14948
                                                                                              CFT032
     C                   Eval      @ODMTT = 'C'                                               CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End of Check customer short name                                                     CFT032
      ************************************************************                            CFT032
      /EJECT                                                                                  CFT032
      ************************************************************                            CFT032
      ** VACC - Check if Full Ledger Account                                                  CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     VACC          BEGSR                                                                CFT032
                                                                                              CFT032
     C                   Exsr      SWIFT                                                      CFT032
     C                   Move      'N'           WCSID             1                        BUG14771
     C                   If        ##CSID = 'Y' And                                           CFT032
     C                             *IN31 = *Off And                                           CFT032
     C                             *IN32 = *Off                                               CFT032
     C                   Eval      @ODMTT = 'S'                                               CFT032
     C                   Move      'Y'           WCSID             1                        BUG14771
     C                   Else                                                                 CFT032
                                                                                              CFT032
      ** Check if multiple branch is not allowed.                                             CFT032
                                                                                              CFT032
     C**********         If        BGMBIN = 'N'                                      CFT032 BUG14771
                                                                                              CFT032
     C**********         If        %Len(%Trim(#SODMT)) = 18                          CFT032 BUG14771
     C**********         If        %Len(%Trim(#SODMT)) = 18 And                    BUG14771 BUG15157
     C                   If        %Len(%Trim(#SODMT)) = 24 And                             BUG15157
     C                             BGMBIN = 'Y'                                             BUG14771
     C**********         Eval      WBrc = DBRC                                       CFT032 BUG15157
     C                   Eval      WBrc = %SUBST(#SODMT:22:3)                               BUG15157
     C                   Eval      P@ACCD = %SUBST(#SODMT:10:10)                            BUG15157
     C                   Eval      DSEQ = %SUBST(#SODMT:20:2)                               BUG15157
     C                   Else                                                                 CFT032
     C                   Eval      WBrc = BJSBRC                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOACCTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      *Zeros        P@RETL                                       CFT032
     C                   Parm      DNUM          P@CUST                                       CFT032
     C                   Parm      DSCY          P@CYCD                                       CFT032
     C**********         Parm      DCOD          P@ACCD                              CFT032 BUG15157
     C                   Parm                    P@ACCD                                     BUG15157
     C                   Parm      DSEQ          P@ACSQ                                       CFT032
     C                   Parm      WBrc          P@BRCD                                       CFT032
     C     ACCNT         Parm      ACCNT         DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   If        @ODMTT = ' '                                               CFT032
     C                   Eval      @ODMTT = 'G'                                               CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   If        IBAN <> *Blanks                                            CFT032
     C                   Eval      @@IBAN ='Y'                                                CFT032
     C                   EndIf                                                                CFT032
     C                   Else                                                                 CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1403'                         CFT032 BUG14771
     C                   Eval      MsgIdXAr(Idx) = 'MMA1407'                                BUG14771
     C                   Eval      OkOdmt = 'N'                                               CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C**********         EndIf                                                       CFT032 BUG14771
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End of Check if Full Ledger Account                                                  CFT032
      ************************************************************                            CFT032
      /EJECT                                                                                  CFT032
      ************************************************************                            CFT032
      ** VIBAN - Check for IBAN                                                               CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     VIBAN         BEGSR                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOIBANR4'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      #SODMT        P@IBAN                                       CFT032
     C**********         Parm                    DSSDY                               CFT032 BUG14771
     C     ACCNT         Parm                    DSSDY                                      BUG14771
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      @ODMTT = 'I'                                               CFT032
     C                   Eval      @@IBAN = 'Y'                                               CFT032
     C                   Else                                                                 CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1408'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End of Check for IBAN                                                                CFT032
      ************************************************************                            CFT032
      /EJECT                                                                                  CFT032
      ************************************************************                            CFT032
      ** SROUFM -                                                                             CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     SROUFM        BEGSR                                                                CFT032
                                                                                              CFT032
     C                   Eval      WEntryType = @ODMTT                                        CFT032
     C                   Eval      WNostro = *Blanks                                          250600
                                                                                              CFT032
      ** Check if feature CSW024 is installed                                                 CFT032
                                                                                              CFT032
     C                   Call      'AOSARSR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*VERIFY'     @Optn                                        CFT032
     C                   Parm      'CSW024'      P@Sar                                        CFT032
     C                   Parm                    DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      FeatureCSW024 = *On                                        CFT032
     C                   Else                                                                 CFT032
     C                   Eval      FeatureCSW024 = *Off                                       CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Check if feature CFT004 is installed                                                 CFT032
                                                                                              CFT032
     C                   Call      'AOSARSR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*VERIFY'     @Optn                                        CFT032
     C                   Parm      'CFT004'      P@Sar                                        CFT032
     C                   Parm                    DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      FeatureCFT004 = *On                                        CFT032
     C                   Else                                                                 CFT032
     C                   Eval      FeatureCFT004 = *Off                                       CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Set value of field tag work field                                                    CFT032
                                                                                              CFT032
     C                   If        BBCUST = *blanks                                          250804A
     C                   Movel(P)  CNUM          C#Key1                                      250804A
     C                   CALL      'AOCUSTR1'                                                250804A
     C                   PARM      '*BLANKS'     @RtCd                                       250804A
     C                   PARM      '*KEY   '     @Optn                                       250804A
     C                   PARM                    C#Key1                                      250804A
     C                   PARM      *BLANKS       C#Kyst                                      250804A
     C     SDCUST        PARM      SDCUST        DSLDY                                       250804A
     C                   Endif                                                               250804A
      *                                                                                      250804A
     C                   Eval      WFieldTag = ':50K:'                                        CFT032
     C                   If        @ODMTT = 'S' Or                                            CFT032
     C**********                   BBCSID <> *Blanks Or                              CFT032 BUG14771
     C**********                   WCSID = 'Y'       Or                             BUG14771 250804A
     C                             BBCSID <> *Blanks Or                                      250804A
     C                             (FeatureCSW024 = *On And BBCBEI <> *Blanks)                CFT032
     C                   Eval      WFieldTag = ':50A:'                                        CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   If        SSTTP = '08'                                               CFT032
     C                   Eval      WNetwork = 'SWIFT'                                         CFT032
     C                   Else                                                                 CFT032
     C**********         Eval      WNetwork = 'Telex'                                CFT032 BUG14771
     C                   Eval      WNetwork = 'TELEX'                                       BUG14771
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   Select                                                               CFT032
     C                   When      @DSTT = 'A'                                                CFT032
     C                   Eval      WCountry = ' '                                             CFT032
     C                   When      @DSTT = 'S'                                                CFT032
     C**********         Eval      WCountry = %Subst(#SODMT:5:2)                       CFT032 250600
     C                   Eval      WCountry = %Subst( SDST1:5:2)                            BUG14771
                                                                                              CFT032
     C                   Other                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOACCTV1'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      *Blanks       P@Typ                                        CFT032
     C**********         Parm      #SODMT        P@Str                               CFT032 BUG14771
     C                   Parm      SDST1         P@Str                                      BUG14771
     C                   Parm                    DSSDY                                        CFT032
                                                                                              CFT032
     C                   Select                                                               CFT032
     C                   When      P@Typ = '*RETAIL' Or                                       CFT032
     C                             P@Typ = '*LEDGER'                                          CFT032
     C                   Eval      ACCNT = DSSDY                                              CFT032
     C                   Eval      WCustomer = CNUM                                           CFT032
     C                   When      P@Typ = '*NOSTRO'                                          CFT032
     C                   Eval      SDNOST = DSSDY                                             CFT032
     C                   Eval      WCustomer = A7CUST                                         CFT032
     C                   When      P@Typ = '*CUSTNO' Or                                       CFT032
     C                             P@Typ = '*SHNAME'                                          CFT032
     C                   Eval      SDCUST = DSSDY                                             CFT032
     C                   Eval      WCustomer = BBCUST                                         CFT032
     C                   EndSl                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOCUSTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      WCustomer     C#Key1                                       CFT032
     C                   Parm      *Blanks       C#Kyst                                       CFT032
     C     SDCUST        Parm      SDCUST        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCD = *Blanks                                            CFT032
     C                   Eval      WCountry = BBCOLC                                          CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndSl                                                                CFT032
                                                                                              CFT032
      ** Determine from where to get Nostro: Sender Correspondent                             CFT032
      ** or Destination (1st field)                                                           CFT032
                                                                                              CFT032
     C**********         Eval      WAddress = ' '                                    CFT032 BUG14771
     C                   Eval      ADDRSS   = ' '                                           BUG14771
     C                   If        SSNCO <> *Blanks                                           CFT032
     C**********         Eval      WAddress = SSNCO                                  CFT032 BUG14771
     C                   Eval      ADDRSS   = SSNCO                                         BUG14771
     C                   Movel     @SNCT         WEntryType2       1                        BUG14771
     C                   Else                                                                 CFT032
     C                   If        SDST1 <> *Blanks                                           CFT032
     C**********         Eval      WAddress = SDST1                                  CFT032 BUG14771
     C                   Eval      ADDRSS   = SDST1                                         BUG14771
     C                   Movel     @DSTT         WEntryType2       1                        BUG14771
     C                   EndIf                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Prepare to extract the nostro number                                                 CFT032
                                                                                              CFT032
     C                   Select                                                               CFT032
     C**********         When      WEntryType = 'P' Or                               CFT032 BUG14771
     C**********                   WEntryType = 'G'                                  CFT032 BUG14771
     C                   When      WEntryType2= 'P' Or                                      BUG14771
     C                             WEntryType2= 'G'                                         BUG14771
                                                                                              CFT032
      ** Check if multi-branch to determine how the branch is retrieved.                      CFT032
                                                                                              CFT032
     C                   If        BGMBIN = 'Y'                                               CFT032
     C                   Eval      P@Brcd = ADPBRC                                            CFT032
     C                   Else                                                                 CFT032
     C                   Eval      P@Brcd = BJSBRC                                            CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C**********         If        WEntryType = 'P'                                  CFT032 BUG14771
     C                   If        WEntryType2= 'P'                                         BUG14771
     C                   Eval      P@Cust = ADPCNM                                            CFT032
     C                   Eval      P@Accd = ADPACD                                            CFT032
     C                   Eval      P@ACSQ = ADPASQ                                            CFT032
     C**********         Eval      P@Cycd = WCurrency                                CFT032 BUG14771
     C                   Eval      P@Cycd = SPCCY                                           BUG14771
     C                   Else                                                                 CFT032
     C                   Eval      P@Cust = ADGCNM                                            CFT032
     C                   Eval      P@Accd = ADGACD                                            CFT032
     C                   Eval      P@ACSQ = ADGASQ                                            CFT032
     C**********         Eval      P@Cycd = WCurrency                                  CFT032 250600
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'R'                                  CFT032 BUG14771
     C                   When      WEntryType2= 'R'                                         BUG14771
                                                                                              CFT032
     C                   Movel     ADDRSS        P@RETL                                     BUG14771
                                                                                            BUG14771
     C                   Call      'AOACCTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C**********         Parm      WAddress      P@RETL                              CFT032 BUG14771
     C                   Parm                    P@RETL                                     BUG14771
     C                   Parm      *Blanks       P@CUST                                       CFT032
     C                   Parm      *Blanks       P@CYCD                                       CFT032
     C                   Parm      *Blanks       P@ACCD                                       CFT032
     C                   Parm      *Blanks       P@ACSQ                                       CFT032
     C                   Parm      *Blanks       P@BRCD                                       CFT032
     C     ACCNT         Parm      ACCNT         DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      P@CUST = CNUM                                              CFT032
     C                   Eval      P@ACCD = %EDITC(ACOD:'X')                                  CFT032
     C                   Eval      P@CYCD = CCY                                               CFT032
     C                   Eval      P@BRCD = BRCA                                              CFT032
     C                   Eval      P@ACSQ = %EDITC(ACSQ:'X')                                  CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'I'                                  CFT032 BUG14771
     C                   When      WEntryType2= 'I'                                         BUG14771
     C                   Movel     ADDRSS        P@IBAN                                     BUG14771
     C                   Call      'AOIBANR4'
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C**********         Parm      WAddress      P@IBAN                              CFT032 BUG14771
     C                   Parm                    P@IBAN                                     BUG14771
     C     ACCNT         Parm      ACCNT         DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      P@CUST = CNUM                                              CFT032
     C                   Eval      P@ACCD = %EDITC(ACOD:'X')                                  CFT032
     C                   Eval      P@CYCD = CCY                                               CFT032
     C                   Eval      P@BRCD = BRCA                                              CFT032
     C                   Eval      P@ACSQ = %EDITC(ACSQ:'X')                                  CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndSl                                                                CFT032
                                                                                              CFT032
      ** Retrieve nostro number for diffent types                                             CFT032
                                                                                              CFT032
     C                   Select                                                               CFT032
                                                                                              CFT032
      ** For Entry Type 'N', just get it directly from input                                  CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'N'                                  CFT032 BUG14771
     C                   When      WEntryType2= 'N'                                         BUG14771
     C                   Eval      WNostro = ADNOSN                                           CFT032
                                                                                              CFT032
                                                                                              CFT032
      ** For Entry Type 'F', just get it directly from input                                  CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'F'                                  CFT032 BUG14771
     C                   When      WEntryType2= 'F'                                         BUG14771
     C                   Eval      WNostro = ADFNNB                                           CFT032
                                                                                              CFT032
      ** For other types, get it from SDNOSTPD                                                CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'P' Or                               CFT032 BUG14771
     C**********                   WEntryType = 'G' Or                               CFT032 BUG14771
     C**********                   WEntryType = 'R' Or                               CFT032 BUG14771
     C**********                   WEntryType = 'I'                                  CFT032 BUG14771
     C                   When      WEntryType2= 'P' Or                                      BUG14771
     C                             WEntryType2= 'G' Or                                      BUG14771
     C                             WEntryType2= 'R' Or                                      BUG14771
     C                             WEntryType2= 'I'                                         BUG14771
                                                                                              CFT032
     C                   Call      'AONOSTR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm                    P@CUST                                       CFT032
     C                   Parm                    P@CYCD                                       CFT032
     C                   Parm                    P@ACCD                                       CFT032
     C                   Parm                    P@ACSQ                                       CFT032
     C                   Parm      *Blanks       P@NONB                                       CFT032
     C                   Parm                    P@BRCD                                       CFT032
     C                   Parm      *Blanks       P@CSSN                                       CFT032
     C                   Parm      *Blanks       P@PNOI                                       CFT032
     C     SDNOST        Parm      SDNOST        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Eval      WNostro = A7NONB                                           CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndSl                                                                CFT032
                                                                                              CFT032
     C                   If        CSW207 = 'Y'                                               250600
     C                   EXSR      SRVAL50                                                    250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   If        CSW207 = 'N' or                                            250600
     C                             PFlag <> 'E'                                               250600
     C                             and PRtCd <> *Blanks                                       250600
      *                                                                                       250600
     C                   Call      'AOOUFMR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      WNetwork      P@NET                                        CFT032
     C**********         Parm      '103'         P@TYP                                 CFT032 249652
     C                   Parm      '103'         P@TYP3A                                      249652
     C                   Parm      WFieldTag     P@TAG                                        CFT032
     C**********         Parm      @BRCA         P@BRCD                              CFT032 BUG14042
     C**********         Parm      @BRCA         P@BRCD4A                          BUG14042 BUG15037
     C                   Parm      WSBrca        P@BRCD4A                                   BUG15037
     C**********         Parm      WCountry      P@CTRY                            BUG13455 BUG14042
     C                   Parm      WCountry      P@CTRY4A                                   BUG14042
     C                   Parm      SPCCY         P@CYCD                                       CFT032
     C                   Parm      WNostro       P@NOS                                        CFT032
     C**********         Parm      'ACCOUNTLINE' P@ACT                               CFT032 BUG14042
     C                   Parm      'ACOUNTLINE'  P@ACT                                      BUG14042
     C     MEOUFM        Parm      MEOUFM        DSSDY                                        CFT032
      *                                                                                       250600
     C                   If        @RtCd <> *Blanks                                           250600
     C                   Eval      OMFLAG = 'O'                                               250600
     C                   EndIf                                                                250600
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Select                                                               CFT032
     C**********         When      OMAACT = ' '                                      CFT032 BUG14042
     C                   When      OMFLAG = ' '                                             BUG14042
     C**********         Eval      OMAACT = 'O'                                      CFT032 BUG14042
     C                   Eval      OMFLAG = 'O'                                             BUG14042
                                                                                              CFT032
     C**********         When      OMAACT = 'M' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'M' And                                         BUG14042
     C                             (@ODMTT = 'S' Or @ODMTT = 'C')                             CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1424'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
                                                                                              CFT032
     C**********         When      OMAACT = 'W' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'W' And                                         BUG14042
     C                             (@ODMTT = 'S' Or @ODMTT = 'C')                             CFT032
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14042
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14042
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1425'                         CFT032 BUG14042
     C                   Eval      WIx = WIx + 1                                            BUG14042
     C                   Eval      WFldNamXAr(WIx) = 'SODMT'                                BUG14042
     C                   Eval      WMsgIdXAr(WIx) = 'MMA1425'                               BUG14042
     C**********         Eval      OkOdmt = 'N'                                      CFT032 BUG14042
                                                                                              CFT032
     C                   EndSl                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   If        FeatureCFT004 = *On                                        CFT032
     C                   Call      'AOOUFMR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      WNetwork      P@NET                                        CFT032
     C**********         Parm      '103'         P@TYP                                 CFT032 249652
     C                   Parm      '103'         P@TYP3A                                      249652
     C                   Parm      WFieldTag     P@TAG                                        CFT032
     C**********         Parm      @BRCA         P@BRCD                              CFT032 BUG14042
     C**********         Parm      @BRCA         P@BRCD4A                          BUG14042 BUG15037
     C                   Parm      WSbrca        P@BRCD4A                                   BUG15037
     C**********         Parm      WCountry      P@CTRY                            BUG13455 BUG14042
     C                   Parm      WCountry      P@CTRY4A                                   BUG14042
     C                   Parm      SPCCY         P@CYCD                                       CFT032
     C                   Parm      WNostro       P@NOS                                        CFT032
     C**********         Parm      'ACCOUNTIBAN' P@ACT                               CFT032 BUG14042
     C                   Parm      'ACOUNTIBAN'  P@ACT                                      BUG14042
     C     MEOUFM        Parm      MEOUFM        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Select                                                               CFT032
     C**********         When      OMAACT = ' '                                      CFT032 BUG14042
     C                   When      OMFLAG = ' '                                             BUG14042
     C**********         Eval      OMAACT = 'O'                                      CFT032 BUG14042
     C                   Eval      OMFLAG = 'O'                                             BUG14042
                                                                                              CFT032
     C**********         When      OMAACT = 'M' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'M' And                                         BUG14042
     C                             @@IBAN = 'N'                                               CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   CFT032
     C                   Eval      MsgIdXAr(Idx) = 'MMA1426'                                  CFT032
     C                   Eval      OkOdmt = 'N'                                               CFT032
                                                                                              CFT032
     C**********         When      OMAACT = 'W' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'W' And                                         BUG14042
     C                             @@IBAN = 'N'                                               CFT032
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14042
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14042
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1427'                         CFT032 BUG14042
     C                   Eval      WIx = WIx + 1                                            BUG14042
     C                   Eval      WFldNamXAr(WIx) = 'SODMT'                                BUG14042
     C                   Eval      WMsgIdXAr(WIx) = 'MMA1427'                               BUG14042
     C                   Eval      OkOdmt = 'N'                                               CFT032
                                                                                              CFT032
     C                   EndSl                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                                250600
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End                                                                                  CFT032
      ************************************************************                            CFT032
      ************************************************************                            250600
     C/EJECT                                                                                  250600
      *****************************************************************                       250600
      ** SRVAL50 - Validation for 50F Tag                             *                       250600
      *****************************************************************                       250600
      *                                                                                       250600
     C     SRVAL50       BEGSR                                                                250600
      *                                                                                       250600
     C                   Eval      PAcc = PfAccnt                                             250600
     C                   Eval      PModI = 'FT'                                               250600
     C                   If        @ODMTT  = 'O'                                              250600
     C                   Eval      PNAHo = NHNAHO                                             250600
     C                   Endif                                                                250600
      *                                                                                       250600
     C                   Call      'FT001000'                                                 250600
     C                   Parm      *Blanks       PRtCd             7                          250600
     C                   Parm      *Blanks       PMsgID            7                          250600
     C                   Parm      *Blank        PFlag             1                          250600
     C                   Parm      'TRAN'        PVTyp             4                          250600
     C                   Parm      SODMT         PFmtFld1         35                          250600
     C                   Parm      *BLANKS       PFmtFld2         35                          250600
     C                   Parm      *BLANKS       PFmtFld3         35                          250600
     C                   Parm      *BLANKS       PFmtFld4         35                          250600
     C                   Parm      *BLANKS       PFmtFld5         35                          250600
     C                   Parm      @ODMTT        PAcctyp           1                          250600
     C                   Parm                    PAcc             34                          250600
     C                   Parm                    PCust             6                          250600
     C                   Parm                    PNAHo            10                          250600
     C                   Parm      WNetwork      PNtWrk            6                          250600
     C                   Parm      '103'         PMsgTp            3                          250600
     C                   Parm      WFieldTag     PMsgTag           5                          250600
     C                   Parm      WCountry      PCtry             2                          250600
     C**********         Parm      @BRCA         PBrch             3                 250600 BUG15037
     C                   Parm      WSbrca        PBrch             3                        BUG15037
     C                   Parm      SPCCY         PCurr             3                          250600
     C                   Parm      WNostro       PNostro           2                          250600
     C                   Parm                    PModI             2                          250600
     C                   Parm                    POut1            35                          250600
     C                   Parm                    POut2            35                          250600
     C                   Parm                    POut3            35                          250600
     C                   Parm                    POut4            35                          250600
     C                   Parm                    POut5            35                          250600
      *                                                                                       250600
     C                   If        PRtCd = '*ERROR'                                           250600
      *                                                                                       250600
     C                   If        PFlag = 'E'                                                250600
     C                   Eval      Idx = Idx + 1                                              250600
     C                   Eval      MsgIdXAr(Idx) = PMsgID                                     250600
     C                   Eval      RetCodeIn = 'Error'                                        250600
      *                                                                                       250600
     C                   Eval      OKOdmt = 'N'                                               250600
     C                   Eval      FldNamXAr(Idx) = 'SODMT'                                   250600
      *                                                                                       250600
     C                   ElseIf    PFlag = 'W'                                                250600
     C                   Eval      WIx = WIx + 1                                              250600
     C                   Eval      WMsgIdXAr(WIx) = PMsgID                                    250600
     C                   Eval      RetCodeIn = 'Error'                                        250600
      *                                                                                     BUG15029
     C                   If        PMsgID = 'FTS0053'                                       BUG15029
     C**********         Eval      WMsgDtaXAr(WIx) =WNetwork                       BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(WNetwork))                             MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(WNetwork)                MD000091
     C                   ElseIf    PMsgID = 'FTS0054'                                       BUG15029
     C**********         Eval      WMsgDtaXAr(WIx) =WFieldTag                      BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(WFieldTag))                            MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(WFieldTag)               MD000091
     C                   Endif                                                              BUG15029
      *                                                                                       250600
     C                   Eval      OKOdmt = 'W'                                               250600
     C                   Eval      WFldNamXAr(WIx) = 'SODMT'                                  250600
      *                                                                                       250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   EndIf                                                                250600
      *                                                                                       250600
     C                   ENDSR                                                                250600
      *                                                                                       250600
      ************************************************************                            250600
      ** End                                                                                  250600
      ************************************************************                            250600
      /EJECT                                                                                  CFT032
      /COPY FTCPYSRC,SFTSWFTCLE                                                               CFT032
      /EJECT                                                                                  CFT032
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB                                   CFT032
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNamXAr                                 BUG14042
     C                   Parm                    WMsgIDXAr                                  BUG14042
     C                   Parm                    WMsgDtaXAr                                 BUG14042
                                                                                            BUG14042
      * OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank details                                                                  CFT032
                                                                                              CFT032
     C                   Call      'AOBANKR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*FIRST'      @Optn                                        CFT032
     C     SDBANK        Parm      SDBANK        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd <> *Blanks                                           CFT032
     C                   Eval      DBFile = 'SDBANKPD'                                        CFT032
     C                   Eval      Dbase = 001                                                CFT032
     C                   Eval      DBKey = @Optn                                              CFT032
     C                   Exsr      *PSSR                                                      CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Access Module Details                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOMMODR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*FIRST'      @Optn                                        CFT032
     C     SDMMOD        Parm      SDMMOD        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd <> *Blanks                                           CFT032
     C                   Eval      DBFile = 'SDMMODPD'                                        CFT032
     C                   Eval      Dbase = 002                                                CFT032
     C                   Eval      DBKey = @Optn                                              CFT032
     C                   Exsr      *PSSR                                                      CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Access Retail Details if Retail Banking                                              CFT032
                                                                                              CFT032
     C                   If        BGRTBN = 'Y'                                               CFT032
     C                   Call      'AORETLR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*FIRST'      @Optn                                        CFT032
     C     SDRETL        Parm      SDRETL        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd <> *Blanks                                           CFT032
     C                   Eval      DBFile = 'SDRETLPD'                                        CFT032
     C                   Eval      Dbase = 003                                                CFT032
     C                   Eval      DBKey = @Optn                                              CFT032
     C                   Exsr      *PSSR                                                      CFT032
     C                   EndIf                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *Blanks       @RtCd                                        CSW207
                                                                                              CSW207
     C                   IF        @RtCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                      250804A
     C                   Clear                   SDCUST                                      250804A
                                                                                              CSW207
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
