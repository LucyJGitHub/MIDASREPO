     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate beneficiary')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVBEBE  - Validate Beneficiary                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD021318           Date 26Jul13               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD021337           Date 25May16               *
      *                 CSW215             Date 06Apr15               *
      *                 AR924684           Date 10Nov14               *
      *                 AR924563           Date 05Nov14               *
      *                 MD027201           Date 19Aug14               *
      *                 262721             Date 19Nov12               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26016           Date 15Sep09               *
      *                 BUG25237           Date 30Jul08               *
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 255453             Date 14Jul08               *
      *                 255286             Date 07Jul08               *
      *                 BUG13798           Date 24Apr07               *
      *                 247159             Date 19Apr07               *
      *                 250600             Date 07Oct07               *
      *                 BUG14771           Date 12Aug07               *
      *                 249652             Date 09Jul07               *
      *                 BUG14042           Date 24May07               *
      *                 245094             Date 24Apr07               *
      *                 BUG13455           Date 20Feb07               *
      *                 BUG13161           Date 29Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12541           Date 16Nov06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG10107           Date 25Jan06               *
      *                 BUG7778            Date 11Jul05               *
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
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 22Nov99               *
      *                 CAP031  *CREATE    Date 12Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD046248 - Finastra Rebranding                               *
      *  MD021337 - Payment cannot be authorised due to blank BNCT.   *
      *             Set BNCT field if OKBnc fields is not 'N'.        *
      *             Applied for MD036932.                             *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  AR924684 - Text following account is wrongly validated as    *
      *             BIC. (Child: AR924685)                            *
      *  AR924563 - '-' should not be present in 1st character of     *
      *             outgoing payments fields 50, 57D, 59, 70 and 72.  *
      *             Recompile due to change in /copy SFTADDRCLE       *
      *             (Child: AR924564)                                 *
      *  MD027201 - Additional Beneficiary Validation                 *
      *  262721 - MMM: Outgoing Swift messages were not generated.    *
      *           Ensure that if a Customer Shortname is entered on   *
      *           the second line of the Beneficiary field it will be *
      *           converted to its corresponding Customer Number      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  BUG26016 - Address line after first line is mandatory        *
      *  BUG25237 - Slash followed by valid IBAN is rejected.         *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  255453 - Reversed fix 233421, it caused MT202 to be treated  *
      *           as MT103.  Fix 233421 is client specific.           *
      *  255286 - Allow lowercase characters on input.                *
      *           Recompile due to change in /copy SFTVALCSLE         *
      *  BUG13798 - CFT032 errors. Applied by 14042                   *
      *  247159 - Partially applied BUG12541 from MP1.3               *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  BUG14771 - Amended the input function and the message        *
      *             generation for CFT032                             *
      *  249652 - CFT032, a few problems                              *
      *  BUG14042 - CFT032 errors ; applied fix 13798                 *
      *  245094 - Apply fixes 233421, 228239 and 135810.              *
      *           Partially apply fix 243531.                         *
      *  233421 - Do not expand the beneficiary field if a customer   *
      *           number or customer name is entered.                 *
      *  228239 - The system changes the beneficiary if it is not     *
      *           found in PF/SDCUSTPD. Need to move BBCUST only when *
      *           record is found after AOCUSTR0 call. Otherwise,     *
      *           perform validation of Beneficiaary line as per      *
      *           normal.                                             *
      *  135810 - Remove the checking of the 2nd line of Beneficiary, *
      *           if the 1st line starts with a '/', allow two line   *
      *           information with '/' instead of three lines have to *
      *           be entered.                                         *
      *  243531 - Error in customer validation logic.                 *
      *  BUG13455 - CFT032 Parameter Mismatch for AOOUFMR0            *
      *  BUG13161 - Error Message Occured in FT0060                   *
      *  BUG12541- Resolve the problem encountered in Beneficiary Type*
      *            and Ordering Type.                                 *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG10107- Error fields does not prompt a color "red" letters.*
      *  BUG7778 - 10 characters name is validated as S/N.            *
      *           Second line in the beneficiary field should be con- *
      *           sidered as an address after it has been checked that*
      *           it is not a customer number nor a customer shortname*
      *           Applied fix 221090.                                 *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - IBAN, International Bank Account Number             *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** String for System Values Array                                                     MD027201
     D SysValBEN1      C                   CONST('BeneField1Expand')                        MD027201
                                                                                            MD027201
      ** String for System Values Array                                                     MD027201
     D SysValBEN2      C                   CONST('BeneField2Expand')                        MD027201
                                                                                            MD027201
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInSecC    E DS                  EXTNAME(FTOPY1PD)                                  CFT032
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY2PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** Array of valid swift characters
     D SWCH            S              1    DIM(47) CTDATA PERRCD(47)
 
      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Midas Counterparty NOSTROS
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** Midas BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** External data strcuture for Accounts Master Detail                                   CFT032
                                                                                              CFT032
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CFT032
                                                                                              CFT032
      ** External data structure for Nostro details                                           CFT032
                                                                                              CFT032
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CFT032
                                                                                              CFT032
      ** Midas Outgoing Message Field Management                                              CFT032
                                                                                              CFT032
     D MEOUFM        E DS                  EXTNAME(MEOUFMPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Bank details                                             CFT032
                                                                                              CFT032
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CFT032
                                                                                              CFT032
      ** External data structure for Midas modules                                            CFT032
                                                                                              CFT032
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CFT032
                                                                                              CFT032
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D/COPY FTCPYSRC,SFTADDRILE
 
     D SBNCDS          DS           175
     D  DSBNC1Pos1             1      1                                         CFT004
     D  DSBNC1                 1     35
     D  DSBNC2                36     70
     D  DSBNC3                71    105
     D  DSBNC4               106    140
     D  DSBNC5               141    175
 
     DCLSWTK           DS
     D SW                      1     12
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
     D C#RTCD          S              7
     D C#OPTN          S              7
     D C#CNUM          S             10
     D C#KYST          S              7
 
     D ADLINE          S              1
     D ADSLON          S              1
     D ##CSID          S              1
 
      ** IBAN character test arrays                                             CFT004
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)            CFT004
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)            CFT004
      **                                                                        CFT004
                                                                                              CFT032
     D P@CUST          S              6A                                                      CFT032
     D P@CYCD          S              3A                                                      CFT032
     D*P@ACCD***       S             10A                                             CFT032 BUG14771
     D P@ACCD          S              4A                                                    BUG14771
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
     D WSBrca          S              3A                                                    BUG14771
     D PMode           S              6A                                                    MD021318
                                                                                              CFT032
     D FeatureCSW024   S               N                                                      CFT032
     D FeatureCFT004   S               N                                                      CFT032
                                                                                              CFT032
     D CSW215          S              1A                                                      CSW215
     D PRTCD           S              7A                                                      CSW215
     D PCLFR           S              4A                                                      CSW215
     D PNETW           S              6A                                                      CSW215
     D PTYPE           S              3A                                                      CSW215
     D PTAG            S              5A                                                      CSW215
     D PBRCH           S              3A                                                      CSW215
     D PCNTY           S              2A                                                      CSW215
     D PCURR           S              3A                                                      CSW215
     D PNOST           S              2A                                                      CSW215
     D POUT1           S             35A                                                      CSW215
     D POUT2           S             35A                                                      CSW215
     D POUT3           S             35A                                                      CSW215
     D POUT4           S             35A                                                      CSW215
     D POUT5           S             35A                                                      CSW215
     D PMSGD           S              7A                                                      CSW215
     D PERRT           S              1A                                                      CSW215
                                                                                              CSW215
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
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
     C                   Eval      AD#1 = 'N'
     C                   Eval      AD#2 = 'N'
     C                   Eval      AD#3 = 'N'
     C                   Eval      AD#4 = 'N'
     C                   Eval      AD#5 = 'N'
     C                   Eval      AD#6 = 'N'
 
 
      * Validate
      *
     C                   Exsr      VBENFCY
      *                                                                                       CSW215
      ** Validate 59F format if CSW215 is installed                                           CSW215
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                             AND IDx = 0                                                CSW215
     C                   EXSR      VAL59F                                                     CSW215
     C                   ENDIF                                                                CSW215
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKBnc1 = 'N' or
     C                             OKBnc2 = 'N' or
     C                             OKBnc3 = 'N' or
     C                             OKBnc4 = 'N' or
     C                             OKBnc5 = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKBnc1 = 'W' or                                            CSD089
     C                             OKBnc2 = 'W' or                                            CSD089
     C                             OKBnc3 = 'W' or                                            CSD089
     C                             OKBnc4 = 'W' or                                            CSD089
     C                             OKBnc5 = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End
 
      * RETURN
 
     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VBENFCY - VALIDATION OF BENEFIFICIARY                          *
      ******************************************************************
     C*
     C     VBENFCY       BEGSR
 
     C                   Eval      DSBNC1 = SBNC1
     C                   Eval      DSBNC2 = SBNC2
     C                   Eval      DSBNC3 = SBNC3
     C                   Eval      DSBNC4 = SBNC4
     C                   Eval      DSBNC5 = SBNC5
     C                   Eval      @BNCT = *Blanks
     C                   Eval      WSBrca = SBRCA                                           BUG14771
 
      *  Beneficiary is mandatory
     C                   If        SBNCDS = *Blanks
      * Send error to screen
     C                   Move      'N'           OKBnc1
     C                   Add       1             Idx
     C***********        Movel     'DDBnc1'      FldNamXAr(Idx)                 CFT014
     C                   Movel     'SBNC1 '      FldNamXAr(Idx)                 CFt014
     C                   Movel     'MMA1052'     MsgIdXAr(Idx)
 
     C                   Else
      *  ? not allowed
     C     '?'           Scan      SBNC1         Y#                3 0    90
      *
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKBnc1
     C                   Add       1             Idx
     C***********        Movel     'DDBnc1'      FldNamXAr(Idx)                 CFT014
     C                   Movel     'SBNC1 '      FldNamXAr(Idx)                 CFT014
     C                   Movel     'MMA1053'     MsgIdXAr(Idx)
     C                   End
 
      * No error
     C                   If        OKBnc1 <> 'N'
 
     C                   Movel(P)  SBNCDS        ADDRSS
      *
      *  If first ten characters used then try to find via SDCUSTPD
     C                   If        ADCH26 = *Blanks and
     C                             ADEXCS = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADXCS2 = *Blanks and
     C                             ADCHK2 <> *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'
 
      *  First 10 characters should be key for SDCUST
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        C#CNUM
     C                   MOVE      'Y'           WIND1             1                        MD027201
     C                   MOVE      *BLANKS       WIND2                                      MD027201
     C                   Else
     C                   Movel     ADCHK2        C#CNUM
     C                   MOVE      'Y'           WIND2             1                        MD027201
     C                   MOVE      *BLANKS       WIND1                                      MD027201
     C                   End
 
      *  Check if the first 6 characters are numeric if so
      *  look for customer number else look for shortname
      *
     C                   Move      *BLANKS       FLD
     C                   Movel     C#CNUM        FLD
     C*****DIGITS        Check     FLD           Y#                       90                  243531
     C     ALPHAN        Check     FLD           Y#                       90                  243531
 
      *  Valid only if 6 digits - now check rest for blanks
     C                   If        *IN90 = *On and
     C                             Y# = 7
     C     ' '           CHECK     FLD:7         Y#                       90
 
      * Customer validation
     C                   If        *IN90 = *Off
     C                             AND BEN1EXPND = 'Y'                                      MD027201
     C                             AND WIND1 = 'Y'                                          MD027201
     C                             OR *IN90 = *OFF                                          MD027201
     C                             AND BEN2EXPND = 'Y'                                      MD027201
     C                             AND WIND2 = 'Y'                                          MD027201
      *
      *  Call to access pgm for Customer details
     C                   CALLB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#CNUM
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY
      *                                                                                     BUG13161
     C                   If        C#RTCD = '*NRF   '                                       BUG13161
     C                   Move      'N'           OKBnc1                                     BUG13161
     C                   Add       1             Idx                                        BUG13161
     C                   MOVEL     'SBNC1 '      FldNamXAr(Idx)                             BUG13161
     C                   Movel     'MMA1054'     MsgIdXAr(Idx)                              BUG13161
     C                   Else                                                               BUG13161
      *                                                                                     BUG13161
 
     C**********         If        C#RTCD = *Blanks or                                        262721
     C**********                   C#KYST <> '*CNUM  '                                        262721
     C                   IF        (C#RTCD = *BLANKS AND C#KYST = '*CNUM') OR                 262721
     C                             (C#RTCD = *BLANKS AND C#KYST = '*CSHT')                    262721
     C                   Eval      @BNCT = 'C'
     C                   IF        ADSLSH <> '/'                                              262721
     C                   MOVEL(P)  BBCUST        SBNC1                                        262721
     C                   ELSE                                                                 262721
     C                   MOVEL(P)  BBCUST        SBNC2                                        262721
     C                   ENDIF                                                                262721
     C**********         If        ADSLSH = '/'                                        233421 255453
     C**********                   and C#KYST = '*CNUM  '                              233421 255453
     C**********         Eval      @BNCT = 'A'                                         233421 255453
     C**********         Endif                                                         233421 255453
 
     C                   Else
      *  Send error to screen
     C                   If        ADSLSH <> '/'
     C                   Movel(P)  'N'           OKBnc1
     C                   Else
     C                   Movel(P)  'N'           OKBnc2
     C                   End
     C                   Add       1             Idx
     C**********         Movel     'DDBnc'       FldNamXAr(Idx)                             BUG10107
     C                   MOVEL     'SBNC1 '      FldNamXAr(Idx)                             BUG10107
     C                   Movel     'MMA1054'     MsgIdXAr(Idx)
     C                   End
     C                   End
      *
     C                   Endif                                                              BUG13161
 
     C                   Else
      *                                                                                     MD027201
      ** Expand only if Sytem value is 'Y'                                                  MD027201
      *                                                                                     MD027201
     C     BEN1EXPND     IFEQ      'Y'                                                      MD027201
     C     WIND1         ANDEQ     'Y'                                                      MD027201
     C     BEN2EXPND     OREQ      'Y'                                                      MD027201
     C     WIND2         ANDEQ     'Y'                                                      MD027201
                                                                                            MD027201
      *  Call to access pgm for Customer details
     C                   CALLB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#CNUM
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY
 
     C*****              If        C#RTCD = *Blanks or                                        243531
     C*****                        C#KYST <> '*CSHT  '                                        243531
     C                   If        C#RTCD = *Blanks and                                       228239
     C                             C#KYST <> '*ERROR '                                        228239
                                                                                              228239
     C                   If        C#KYST = '*CNUM  ' or                                      228239
     C                             C#KYST = '*CSHT  '                                         228239
 
     C                   If        ADSLSH <> '/'
     C                   Movel(P)  BBCUST        SBNC1
     C                   Else
     C                   Movel(P)  BBCUST        SBNC2
     C                   End
 
     C                   Eval      @BNCT = 'C'
     C**********         If        ADSLSH = '/'                                        233421 255453
     C**********                   and C#KYST = '*CSHT  '                              233421 255453
     C**********         Movel(P)  BBCSSN        SBNC2                                 233421 255453
     C**********         Eval      @BNCT = 'A'                                         233421 255453
     C**********         Endif                                                         233421 255453
     C                   End
     C                   Endif                                                                228239
 
     C                   ENDIF                                                              MD027201
     C                   End
     C                   End
     C                   End
 
     C                   If        OKBnc1 <> 'N' and
     C                             OKBnc2 <> 'N' and
     C                             @BNCT = *Blanks
 
      *  If 1st 11 Chars of 1st line then SWIFT address assumed
      *  Or first is '/' and second is SWIFT Address
 
      *  If field does not begin with '/' and is not longer than 11
      *  characters, validate as a S.W.I.F.T. Address
     C                   If        ADCH26 = *Blanks and
     C                             ADEXSW = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADEXS2 = *Blanks and
     C                             ADCHK2 <> *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'
 
      *  First 11 characters should be key for CLSWT.
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        CLSWTK
     C                   Else
     C                   Movel     ADCHK2        CLSWTK
     C                   End
 
     C                   Exsr      SWIFT
 
     C                   Move      'N'           WCsid             1                        BUG14771
     C                   If        ##CSID = 'Y'
     C                   If        ADSLSH = '/'and *IN31=*Off and *IN32=*Off                AR924684
     C                             or ADSLSH <> '/'                                         AR924684
 
     C                   If        *IN31 = *On
      * Send error to screen
     C                   If        ADSLSH <> '/'
     C**********         Move      'N'           OKBnc1                                       CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBnc1                                     MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBnc1                                       CSD089
     C                   ENDIF                                                              MD021318
     C                   Else
     C**********         Move      'N'           OKBnc2                                       CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBnc2                                     MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBnc2                                       CSD089
     C                   ENDIF                                                              MD021318
     C                   End
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'DDBnc'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1055'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'DDBnc'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1055'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'DDBnc'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1055'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
 
     C                   Else
     C                   Eval      @BNCT = 'S'
     C                   Move      'Y'           WCsid                                      BUG14771
      *
      *  No SWIFT address record.
     C                   If        *IN32 = *On and
     C                             *IN31 = *Off
 
      *  If text changed then warning needs to be changed
     C                   If        ADSLSH <> '/'
     C                   Movel     CLSWTK        @BNC1
      * Send warning to screen
     C                   Move      'W'           OKBnc1
     C                   Add       1             WIx
     C                   Movel     'MMA1056'     WMsgIdXAr(WIx)
     C                   Movel     'SBNC1'       WFldNmXAr(WIx)
 
     C                   Else
     C                   Movel     CLSWTK        @BNC2
      * Send warning to screen
     C                   Move      'W'           OKBnc2
     C                   Add       1             WIx
     C                   Movel     'MMA1056'     WMsgIdXAr(WIx)
     C                   Movel     'SBNC2'       WFldNmXAr(WIx)
     C                   End
 
     C                   End
     C                   End
     C                   EndIf                                                              AR924684
     C                   End
     C                   End
     C                   End
 
     C                   If        OKBnc1 <> 'N' and
     C                             @BNCT = *Blanks
 
      * Invalid customer number or shortname.
     C                   If        ADCH26 = *Blanks and
     C                             ADEXCS = *Blanks and
     C                             ADSLSH <> '/'                                              135810
     C**********                   ADSLSH <> '/' or                                           135810
     C**********                   ADCH36 = *Blanks and                                       135810
     C**********                   ADXCS2 = *Blanks and                                       135810
     C**********                   ADCHK2 <> *Blanks and                                      135810
     C**********                   ADSLSH = '/' and                                           135810
     C**********                   ADSLS2 <> '/'                                              135810
 
      *  First 10 characters should be key for SDCUST
      * Send error to screen
     C                   Add       1             Idx
     C                   If        ADSLSH <> '/'
     C                             AND BEN1EXPND = 'Y'                                      MD027201
     C                             AND WIND1 = 'Y'                                          MD027201
     C                   Move      'N'           OKBnc1
     C                   Movel     'SBNC1'       FldNamXAr(Idx)
     C**********         Else                                                                BUG7778
     C**********         Move      'N'           OKBnc2                                      BUG7778
     C**********         Movel     'SBNC2'       FldNamXAr(Idx)                              BUG7778
     C**********         End                                                                 BUG7778
     C                   Movel     'MMA1054'     MsgIdXAr(Idx)
     C                   End                                                                 BUG7778
 
     C                   Else
      * Validate as an address
     C                   Eval      ADLINE = 'Y'
     C                   Exsr      ADCHK
 
      *  Depending on the indicators, highlight the field in error
     C**********         If        *IN91 = *On                                              BUG25237
      **Send*error*to*screen*                                                               BUG25237
     C**********         Move      'N'           OKBnc1                                     BUG25237
     C**********         Add       1             Idx                                        BUG25237
     C**********         Movel     'SBNC1'       FldNamXAr(Idx)                             BUG25237
     C**********         Movel     'MMA1057'     MsgIdXAr(Idx)                              BUG25237
     C**********         End                                                                BUG25237
     C                   If        *IN91 = *On                                              BUG26016
      **Send error to screen                                                                BUG26016
     C                   Move      'N'           OKBnc1                                     BUG26016
     C                   Add       1             Idx                                        BUG26016
     C                   Movel     'SBNC1'       FldNamXAr(Idx)                             BUG26016
     C                   Movel     'MMA1057'     MsgIdXAr(Idx)                              BUG26016
     C                   End                                                                BUG26016
      *
     C                   If        *IN92 = *On
      * Send error to screen
     C                   Move      'N'           OKBnc1
     C                   Add       1             Idx
     C                   Movel     'SBNC1'       FldNamXAr(Idx)
     C                   Movel     'MMA1058'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
     C                   If        AD#1 = 'Y'
     C**********         Move      'N'           OKBnc1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBNC1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBnc1                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBNC1'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBnc1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBNC1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        AD#2 = 'Y'
     C**********         Move      'N'           OKBnc2                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBNC2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBnc2                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBNC2'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBnc2                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBNC2'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        AD#3 = 'Y'
     C**********         Move      'N'           OKBnc3                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBNC3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBnc3                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBNC3'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBnc3                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBNC3'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        AD#4 = 'Y'
     C**********         Move      'N'           OKBnc4                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBNC4'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBnc4                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBNC4'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBnc4                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBNC4'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        AD#5 = 'Y'
     C**********         Move      'N'           OKBnc5                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SBNC5'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKBnc5                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SBNC5'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKBnc5                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SBNC5'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIDXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
      *  If no errors then customer is an address
     C**********         If        OKBnc1 = 'Y' and                                         MD021337
     C**********                   OKBnc2 = 'Y' and                                         MD021337
     C**********                   OKBnc3 = 'Y' and                                         MD021337
     C**********                   OKBnc4 = 'Y' and                                         MD021337
     C**********                   OKBnc5 = 'Y' and                                         MD021337
     C                   If        OKBnc1 <> 'N' and                                        MD021337
     C                             OKBnc2 <> 'N' and                                        MD021337
     C                             OKBnc3 <> 'N' and                                        MD021337
     C                             OKBnc4 <> 'N' and                                        MD021337
     C                             OKBnc5 <> 'N' and                                        MD021337
     C                             @BNCT = *Blanks
     C                   Eval      @BNCT = 'A'
     C                   End
 
     C                   End
                                                                                CFT014
      ** Beneficiary does not contain an account line while bank operation      CFT014
      ** code is 'SPRI', SSTD' or 'SPAY'.                                       CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   If        (SBOCD = 'SPRI') Or (SBOCD = 'SSTD') Or      CFT014
     C                             (SBOCD = 'SPAY')                             CFT014
     C                   If        ADSLSH <> '/'                                CFT014
     C                   Move      'N'           OKBNC1                         CFT014
     C                   Add       1             Idx                            CFT014
     C                   Movel     'SBNC1'       FldNamXAr(Idx)                 CFT014
     C                   Movel     'FTM3216'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                                                                          CFT004
      *  If IBAN (International Bank Account Number) is switched on             CFT004
     C                                                                          CFT004
     C                   IF        @CFT004 = 'Y'                                CFT004
                                                                                            BUG14771
     C                   Eval      @@IBAN = 'N'                                             BUG14771
                                                                                CFT004
      *  Remove '/' from first position                                         CFT004
                                                                                CFT004
     C                   IF        DSBNC1Pos1 = '/'                             CFT004
     C     34            SUBST     DSBNC1:2      PIBAN                          CFT004
     C                   ELSE                                                   CFT004
     C                   EVAL      PIBAN = DSBNC1                               CFT004
     C                   ENDIF                                                  CFT004
                                                                                CFT004
      *  Format field, removing blanks and IBAN prefix                          CFT004
                                                                                CFT004
     C                   CALL      'AOIBANR3'                                   CFT004
     C                   PARM                    @Rcode            7            CFT004
     C                   PARM                    PIBAN            47            CFT004
     C                   PARM                    POWith           47            CFT004
     C     P@IBAN        PARM                    PONobl           34            CFT004
                                                                                CFT004
      *  If first four characters are 'AANN', proceed with IBAN validn          CFT004
                                                                                CFT004
     C     1             SUBST     P@IBAN:1      IBCTY1            1            CFT004
     C     1             SUBST     P@IBAN:2      IBCTY2            1            CFT004
     C     1             SUBST     P@IBAN:3      IBCHK1            1            CFT004
     C     1             SUBST     P@IBAN:4      IBCHK2            1            CFT004
     C     IBCTY1        LOOKUP    Alpha                                  94    CFT004
     C   94IBCTY2        LOOKUP    Alpha                                  94    CFT004
     C   94IBCHK1        LOOKUP    Numeric                                94    CFT004
     C   94IBCHK2        LOOKUP    Numeric                                94    CFT004
                                                                                CFT004
     C                   IF        *IN94 = *ON                                  CFT004
                                                                                CFT004
     C                   CALL      'AOIBANR5'                           90      CFT004
     C                   PARM      *Blanks       @Rcode                         CFT004
     C                   PARM                    P@IBAN           34            CFT004
                                                                                CFT004
      *  If no warnings, prefix IBAN with '/'                                   CFT004
                                                                                CFT004
     C                   IF        *IN90 = *Off and @Rcode = *Blanks            CFT004
     C                   EVAL      @@IBAN = 'Y'                                               CFT032
     C*****'/'**         CAT       P@IBAN        SBNC1                               CFT004 BUG26016
     C                   ELSE                                                   CFT004
                                                                                CFT004
      *  Warnings:                                                              CFT004
                                                                                CFT004
     C                   EVAL      @@IBAN = 'N'                                               CFT032
     C**********         EVAL      OKBnc1 = 'N'                                      CFT004 BUG25237
     C                   EVAL      OKBnc1 = 'W'                                             BUG25237
     C                   EVAL      WIx = WIx + 1                                CFT004
     C                   EVAL      WFldNmXAr(WIx) = 'SBNC1     '                CFT004
     C                   EVAL      WMsgDtaXAr(WIx) =                            CFT004
     C                             'Beneficiary      '                          CFT004
     C                   SELECT                                                 CFT004
                                                                                CFT004
      *  Invalid ISO country code                                               CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      1'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2400'                   CFT004
                                                                                CFT004
      *  Invalid BBAN length                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      2'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2401'                   CFT004
                                                                                CFT004
      *  Invalid character                                                      CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      3'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2402'                   CFT004
                                                                                CFT004
      *  Invalid IBAN length                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      4'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2403'                   CFT004
                                                                                CFT004
      *  Invalid check digit                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      5'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2404'                   CFT004
                                                                                CFT004
      *  Other/non-specific warning                                             CFT004
                                                                                CFT004
     C                   OTHER                                                  CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2405'                   CFT004
     C                   ENDSL                                                  CFT004
                                                                                CFT004
     C                   ENDIF                                                  CFT004
     C                   ENDIF                                                  CFT004
     C                   ENDIF                                                  CFT004
     C                                                                          CFT004
      **********                                                                   BUG25237 BUG26016
     C**********         If        OKBnc1 <> 'N' AND                               BUG25237 BUG26016
     C**********                   OKBnc2 <> 'N' AND                               BUG25237 BUG26016
     C**********                   OKBnc3 <> 'N' AND                               BUG25237 BUG26016
     C**********                   OKBnc4 <> 'N' AND                               BUG25237 BUG26016
     C**********                   OKBnc5 <> 'N' AND                               BUG25237 BUG26016
     C**********                   @@IBAN = 'N' AND                                BUG25237 BUG26016
     C**********                   DSBNC1Pos1 = '/' and                            BUG25237 BUG26016
     C**********                   *IN91 = *On                                     BUG25237 BUG26016
      **********                                                                   BUG25237 BUG26016
      ***Send*error*to*screen*                                                     BUG25237 BUG26016
      **********                                                                   BUG25237 BUG26016
     C**********         Move      'N'           OKBnc1                            BUG25237 BUG26016
     C**********         Add       1             Idx                               BUG25237 BUG26016
     C**********         Movel     'SBNC1'       FldNamXAr(Idx)                    BUG25237 BUG26016
     C**********         Movel     'MMA1057'     MsgIdXAr(Idx)                     BUG25237 BUG26016
     C**********         End                                                       BUG25237 BUG26016
      **********                                                                   BUG25237 BUG26016
     C                   End
 
     C                   EXSR      SROUFM                                                     CFT032
                                                                                              CFT032
     C                   ENDSR
     C*****************************************************************
     C* END OF BENEFICIARY VALIDATION                                 *
     C*****************************************************************
      /EJECT                                                                                  CFT032
      ************************************************************                            CFT032
      ** SROUFM -                                                                             CFT032
      ************************************************************                            CFT032
                                                                                              CFT032
     C     SROUFM        BEGSR                                                                CFT032
                                                                                              CFT032
     C                   Eval      WEntryType = @BNCT                                         CFT032
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
     C**********         Eval      WFieldTag = ':50K:'                               CFT032 BUG14771
     C                   Eval      WFieldTag = ':59:'                                       BUG14771
     C                   If        @BNCT = 'S' Or                                             CFT032
     C**********                   BBCSID <> *Blanks Or                              CFT032 BUG14771
     C                             WCsid = 'Y'      Or                                      BUG14771
     C                             (FeatureCSW024 = *On And BBCBEI <> *Blanks)                CFT032
     C**********         Eval      WFieldTag = ':50A:'                               CFT032 BUG14771
     C                   Eval      WFieldTag = ':59A:'                                      BUG14771
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C*                  If        SSTTP = '08'                                               CFT032
     C*                  Eval      WNetwork = 'SWIFT'                                         CFT032
     C*                  Else                                                                 CFT032
     C*                  Eval      WNetwork = 'Telex'                                         CFT032
     C*                  EndIf                                                                CFT032
                                                                                            BUG14042
     C                   IF        SSTTP = '08'                                             BUG14042
     C                   EVAL      WNetwork = 'SWIFT'                                       BUG14042
     C                   ENDIF                                                              BUG14042
     C                   IF        SSTTP = '01'                                             BUG14042
     C                   EVAL      WNetwork = 'TELEX'                                       BUG14042
     C                   ENDIF                                                              BUG14042
                                                                                              CFT032
     C                   Select                                                               CFT032
     C                   When      @DSTT = 'A'                                                CFT032
     C                   Eval      WCountry = ' '                                             CFT032
     C                   When      @DSTT = 'S'                                                CFT032
     C**********         Eval      WCountry = %Subst(DSBNC1:5:2)                     CFT032 BUG14771
     C                   Eval      WCountry = %Subst(SDST1:5:2)                             BUG14771
                                                                                              CFT032
     C                   Other                                                                CFT032
                                                                                              CFT032
     C                   Call      'AOACCTV1'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      *Blanks       P@Typ                                        CFT032
     C**********         Parm      SBNCDS        P@Str                               CFT032 BUG14771
     C                   Parm      SDST1         P@Str                                      BUG14771
     C                   Parm                    DSSDY                                        CFT032
                                                                                              CFT032
     C                   Select                                                               CFT032
     C                   When      P@Typ = '*RETAIL' Or                                       CFT032
     C                             P@Typ = '*LEDGER'                                          CFT032
     C                   Eval      ACCNT = DSSDY                                              CFT032
     C**********         Eval      WCustomer = CNUM                                  CFT032 BUG13798
     C                   MOVEL     CNUM          WCustomer                           CFT032 BUG13798
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
     C                   Parm      WCustomer     C#CNUM                                       CFT032
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
     C                   Eval      WAddress = ' '                                             CFT032
     C                   If        SSNCO <> *Blanks                                         BUG14771
     C                   Eval      WAddress =  SSNCO                                        BUG14771
     C                   Movel     @SNCT         WEntryType2       1                        BUG14771
     C                   Else                                                               BUG14771
     C                   If        SDST1 <> *Blanks                                         BUG14771
     C                   Eval      WAddress =  SDST1                                        BUG14771
     C                   Movel     @DSTT         WEntryType2       1                        BUG14771
     C                   EndIf                                                              BUG14771
     C                   EndIf                                                              BUG14771
     C*                  If        SSNCO <> *Blanks                                           CFT032
     C*                  Eval      WAddress = SSNCO                                           CFT032
     C*                  Else                                                                 CFT032
     C*                  If        SDST1 <> *Blanks                                           CFT032
     C*                  Eval      WAddress = SDST1                                           CFT032
     C*                  EndIf                                                                CFT032
     C*                  EndIf                                                                CFT032
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
     C**********         Eval      P@Cycd = WCurrency                                CFT032 BUG14771
     C                   Eval      P@Cycd = SPCCY                                           BUG14771
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C**********         When      WEntryType = 'R'                                  CFT032 BUG14771
     C                   When      WEntryType2 = 'R'                                        BUG14771
                                                                                            BUG14771
     C                   Movel     WAddress      P@RETL                                     BUG14771
                                                                                              CFT032
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
     C                   Movel     WAddress      P@IBAN                                     BUG14771
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
     C                   Call      'AOOUFMR0'                                                 CFT032
     C                   Parm      *Blanks       @RtCd                                        CFT032
     C                   Parm      '*KEY'        @Optn                                        CFT032
     C                   Parm      WNetwork      P@NET                                        CFT032
     C**********         Parm      '103'         P@TYP                                 CFT032 249652
     C                   Parm      '103'         P@TYP3A                                      249652
     C                   Parm      WFieldTag     P@TAG                                        CFT032
     C**********         Parm      @BRCA         P@BRCD                              CFT032 BUG14042
     C**********         Parm      @BRCA         P@BRCD4A                          BUG14042 BUG14771
     C                   Parm      WSbrca        P@BRCD4A                                   BUG14771
     C**********         Parm      WCountry      P@CTRY                            BUG13455 BUG14042
     C                   Parm      WCountry      P@CTRY4A                                   BUG14042
     C                   Parm      SPCCY         P@CYCD            3                          CFT032
     C                   Parm      WNostro       P@NOS                                        CFT032
     C**********         Parm      'ACCOUNTLINE' P@ACT                               CFT032 BUG14042
     C                   Parm      'ACOUNTLINE'  P@ACT                                      BUG14042
     C     MEOUFM        Parm      MEOUFM        DSSDY                                        CFT032
                                                                                              CFT032
     C                   If        @RtCd = *Blanks                                            CFT032
     C                   Select                                                               CFT032
     C**********         When      OMAACT = ' '                                      CFT032 BUG14042
     C**********         Eval      OMAACT = 'O'                                      CFT032 BUG14042
     C                   When      OMFLAG = ' '                                             BUG14042
     C                   Eval      OMFLAG = 'O'                                             BUG14042
                                                                                              CFT032
     C**********         When      OMAACT = 'M' And                                  CFT032 BUG14042
     C**********                   (@ODMTT = 'S' Or @ODMTT = 'C')                    CFT032 BUG14042
     C                   When      OMFLAG = 'M' And                                         BUG14042
     C                             ADSLSH <> '/'                                            BUG14042
     C                   Eval      Idx = Idx + 1                                              CFT032
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14042
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1424'                         CFT032 BUG14042
     C                   Eval      FldNamXAr(Idx) = 'SBNC1'                                 BUG14042
     C                   Eval      MsgIdXAr(Idx) = 'MMA1417'                                BUG14042
     C                   Eval      OkBnc1 = 'N'                                               CFT032
                                                                                              CFT032
     C**********         When      OMAACT = 'W' And                                  CFT032 BUG14042
     C**********                   (@ODMTT = 'S' Or @ODMTT = 'C')                    CFT032 BUG14042
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14042
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14042
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1425'                         CFT032 BUG14042
     C                   When      OMFLAG = 'W' And                                         BUG14042
     C                             ADSLSH <> '/'                                            BUG14042
     C                   Eval      WIx = WIx + 1                                            BUG14042
     C                   Eval      WFldNmXAr(WIx) = 'SBNC1'                                 BUG14042
     C                   Eval      WMsgIDXar(WIx) = 'MMA1418'                               BUG14042
     C                   Eval      OKbnc1 = 'N'                                               CFT032
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
     C**********         Parm      @BRCA         P@BRCD4A                          BUG14042 BUG14771
     C                   Parm      WSbrca        P@BRCD4A                                   BUG14771
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
     C**********         Eval      OMAACT = 'O'                                      CFT032 BUG14042
     C                   When      OMFLAG = ' '                                             BUG14042
     C                   Eval      OMFLAG = 'O'                                             BUG14042
                                                                                              CFT032
     C**********         When      OMAACT = 'M' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'M' And                                         BUG14042
     C                             @@IBAN = 'N'                                               CFT032
     C                   Eval      Idx = Idx + 1                                              CFT032
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14042
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1426'                         CFT032 BUG14042
     C                   Eval      FldNamXAr(Idx) = 'SBNC1'                                 BUG14042
     C                   Eval      MsgIdXAr(Idx) = 'MMA1420'                                BUG14042
     C                   Eval      OKBnc1 = 'N'                                               CFT032
                                                                                              CFT032
     C**********         When      OMAACT = 'W' And                                  CFT032 BUG14042
     C                   When      OMFLAG = 'W' And                                         BUG14042
     C                             @@IBAN = 'N'                                               CFT032
     C**********         Eval      Idx = Idx + 1                                     CFT032 BUG14042
     C**********         Eval      FldNamXAr(Idx) = 'SODMT'                          CFT032 BUG14042
     C**********         Eval      MsgIdXAr(Idx) = 'MMA1427'                         CFT032 BUG14042
     C                   Eval      WIx = WIx + 1                                            BUG14042
     C                   Eval      WFldNmXAr(WIx) = 'SBNC1'                                 BUG14042
     C                   Eval      WMsgIDXAr(WIx) = 'MMA1421'                               BUG14042
     C                   Eval      OkBnc1 = 'N'                                               CFT032
                                                                                              CFT032
     C                   EndSl                                                                CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   EndIf                                                                CFT032
                                                                                              CFT032
     C                   ENDSR                                                                CFT032
                                                                                              CFT032
      ************************************************************                            CFT032
      ** End                                                                                  CFT032
      ************************************************************                            CFT032
      /EJECT                                                                                  CFT032
      ************************************************************                            CSW215
      *  VAL59F - Validation of Beneficiary 59F Format           *                            CSW215
      ************************************************************                            CSW215
                                                                                              CSW215
     C     VAL59F        BEGSR                                                                CSW215
                                                                                              CSW215
      ** Set Nostro based on Destination                                                      CSW215
                                                                                              CSW215
     C                   EVAL      WNostro = *BLANKS                                          CSW215
     C                   IF        WEntryType2 = 'F'                                          CSW215
     C                             AND WADDRESS <> *BLANKS                                    CSW215
     C                   EVAL      WNostro = %SUBST(WAddress:4:2)                             CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   CALL      'MG001001'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
     C                   PARM      'TRAN'        PCLFR                                        CSW215
     C                   PARM                    SBNC1                                        CSW215
     C                   PARM                    SBNC2                                        CSW215
     C                   PARM                    SBNC3                                        CSW215
     C                   PARM                    SBNC4                                        CSW215
     C                   PARM                    SBNC5                                        CSW215
     C                   PARM      WNetwork      PNETW                                        CSW215
     C                   PARM      '103'         PTYPE                                        CSW215
     C                   PARM      ':59F:'       PTAG                                         CSW215
     C                   PARM      WSbrca        PBRCH                                        CSW215
     C                   PARM      WCountry      PCNTY                                        CSW215
     C                   PARM      SPCCY         PCURR                                        CSW215
     C                   PARM      WNostro       PNOST                                        CSW215
     C                   PARM      *BLANKS       POUT1                                        CSW215
     C                   PARM      *BLANKS       POUT2                                        CSW215
     C                   PARM      *BLANKS       POUT3                                        CSW215
     C                   PARM      *BLANKS       POUT4                                        CSW215
     C                   PARM      *BLANKS       POUT5                                        CSW215
     C                   PARM      *BLANKS       PMSGD                                        CSW215
     C                   PARM      *BLANKS       PERRT                                        CSW215
                                                                                              CSW215
     C                   IF        PERRT = 'E'                                                CSW215
     C                   EVAL      OKBnc1 = 'N'                                               CSW215
     C                   EVAL      OKBnc2 = 'N'                                               CSW215
     C                   EVAL      OKBnc3 = 'N'                                               CSW215
     C                   EVAL      OKBnc4 = 'N'                                               CSW215
     C                   EVAL      OKBnc5 = 'N'                                               CSW215
     C                   EVAL      Idx = Idx + 1                                              CSW215
     C                   EVAL      FldNamXAr(Idx) = 'SBNC1'                                   CSW215
     C                   EVAL      MsgIdXAr(Idx) = PMSGD                                      CSW215
                                                                                              CSW215
     C                   ELSEIF    PERRT = 'W'                                                CSW215
     C                   EVAL      OKBnc1 = 'W'                                               CSW215
     C                   EVAL      OKBnc2 = 'W'                                               CSW215
     C                   EVAL      OKBnc3 = 'W'                                               CSW215
     C                   EVAL      OKBnc4 = 'W'                                               CSW215
     C                   EVAL      OKBnc5 = 'W'                                               CSW215
     C                   EVAL      WIx = WIx + 1                                              CSW215
     C                   EVAL      WFldNmXAr(WIx) = 'SBNC1'                                   CSW215
     C                   EVAL      WMsgIdXAr(WIx) = PMSGD                                     CSW215
                                                                                              CSW215
     C                   IF        PMSGD = 'ME00329'                                          CSW215
     C                   EVAL      WMsgDtaXAr(WIx) = WNetwork                                 CSW215
     C                   ELSEIF    PMSGD = 'ME00330'                                          CSW215
     C                   EVAL      WMsgDtaXAr(WIx) = PTAG                                     CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   ENDSR                                                                CSW215
      *                                                                                       CSW215
      ****************************************************************                      MD027201
      *                                                              *                      MD027201
      *  SRSysVal - Subroutine to access system value                *                      MD027201
      *                                                              *                      MD027201
      *  Called by: INZSR                                            *                      MD027201
      *  Calls:  None                                                *                      MD027201
      *                                                              *                      MD027201
      ****************************************************************                      MD027201
     C     SRSysVal      BEGSR                                                              MD027201
      *                                                                                     MD027201
     C                   CALL      'AOSVALR0'                                               MD027201
     C                   PARM      *BLANKS       PRetCode          7                        MD027201
     C                   PARM      SysValBEN     P@OP01           20                        MD027201
     C                   PARM      *BLANKS       P@VL01          200                        MD027201
     C                   PARM      *BLANKS       P@OP02           20                        MD027201
     C                   PARM      *BLANKS       P@VL02          200                        MD027201
     C                   PARM      *BLANKS       P@OP03           20                        MD027201
     C                   PARM      *BLANKS       P@VL03          200                        MD027201
     C                   PARM      *BLANKS       P@OP04           20                        MD027201
     C                   PARM      *BLANKS       P@VL04          200                        MD027201
     C                   PARM      *BLANKS       P@OP05           20                        MD027201
     C                   PARM      *BLANKS       P@VL05          200                        MD027201
     C                   PARM      *BLANKS       P@OP06           20                        MD027201
     C                   PARM      *BLANKS       P@VL06          200                        MD027201
     C                   PARM      *BLANKS       P@OP07           20                        MD027201
     C                   PARM      *BLANKS       P@VL07          200                        MD027201
     C                   PARM      *BLANKS       P@OP08           20                        MD027201
     C                   PARM      *BLANKS       P@VL08          200                        MD027201
     C                   PARM      *BLANKS       P@OP09           20                        MD027201
     C                   PARM      *BLANKS       P@VL09          200                        MD027201
     C                   PARM      *BLANKS       P@OP10           20                        MD027201
     C                   PARM      *BLANKS       P@VL10          200                        MD027201
      *                                                                                     MD027201
     C                   IF        PRetCode  <> *BLANKS                                     MD027201
     C                   Eval      DBFile = 'SDSVALPD'                                      MD027201
     C                   Eval      Dbase = 003                                              MD027201
     C                   Eval      DBKey = '*KEY   '                                        MD027201
     C                   Exsr      *PSSR                                                    MD027201
     C                   ENDIF                                                              MD027201
      *                                                                                     MD027201
     C                   ENDSR                                                              MD027201
      ****************************************************************                      MD027201
     C/EJECT
      * Subroutine SWIFT
     E/COPY FTCPYSRC,SFTSWFTCLE
 
      * Subroutine ADCHK
     E/COPY FTCPYSRC,SFTADDRCLE
 
      * Subroutine SWSET
     E/COPY FTCPYSRC,SFTADDRSC1
 
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInSecA
     C                   Parm                    TranInSecB
     C                   Parm                    TranInSecC                                 BUG12541
 
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
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
      *                                                                                     MD027201
      ** Access system value                                                                MD027201
      *                                                                                     MD027201
     C                   MOVE      *BLANKS       SysValBEN        20                        MD027201
     C                   MOVEL     SysValBEN1    SysValBEN                                  MD027201
     C                   EXSR      SRSysVal                                                 MD027201
     C                   IF        P@VL01 = 'Y'                                             MD027201
     C                   MOVEL     'Y'           BEN1EXPND         1                        MD027201
     C                   ELSE                                                               MD027201
     C                   MOVEL     'N'           BEN1EXPND                                  MD027201
     C                   ENDIF                                                              MD027201
      *                                                                                     MD027201
     C                   MOVE      *BLANKS       SysValBEN        20                        MD027201
     C                   MOVEL     SysValBEN2    SysValBEN                                  MD027201
     C                   EXSR      SRSysVal                                                 MD027201
     C                   IF        P@VL01 = 'Y'                                             MD027201
     C                   MOVEL     'Y'           BEN2EXPND         1                        MD027201
     C                   ELSE                                                               MD027201
     C                   MOVEL     'N'           BEN2EXPND                                  MD027201
     C                   ENDIF                                                              MD027201
      *                                                                                     MD027201
      ** Check if CSW215 is installed                                                         CSW215
      *                                                                                       CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM                    PRTCD                                        CSW215
                                                                                              CSW215
     C                   IF        PRTCD = 'CSW2015'                                          CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  SWCH  - Array of valid Swift characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+
**  Alpha - Array of alphabetic characters                                      CFT004
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of numeric characters                                       CFT004
0123456789
